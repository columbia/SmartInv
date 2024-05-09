1 pragma solidity ^0.4.6;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC20Basic {
30   uint256 public totalSupply;
31   function balanceOf(address who) constant returns (uint256);
32   function transfer(address to, uint256 value) returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract BasicToken is ERC20Basic {
37   using SafeMath for uint256;
38 
39   mapping(address => uint256) balances;
40 
41   /**
42   * @dev transfer token for a specified address
43   * @param _to The address to transfer to.
44   * @param _value The amount to be transferred.
45   */
46   function transfer(address _to, uint256 _value) returns (bool) {
47     balances[msg.sender] = balances[msg.sender].sub(_value);
48     balances[_to] = balances[_to].add(_value);
49     Transfer(msg.sender, _to, _value);
50     return true;
51   }
52 
53   /**
54   * @dev Gets the balance of the specified address.
55   * @param _owner The address to query the the balance of. 
56   * @return An uint256 representing the amount owned by the passed address.
57   */
58   function balanceOf(address _owner) constant returns (uint256 balance) {
59     return balances[_owner];
60   }
61 
62 }
63 
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender) constant returns (uint256);
66   function transferFrom(address from, address to, uint256 value) returns (bool);
67   function approve(address spender, uint256 value) returns (bool);
68   event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 contract StandardToken is ERC20, BasicToken {
72 
73   mapping (address => mapping (address => uint256)) allowed;
74 
75 
76   /**
77    * @dev Transfer tokens from one address to another
78    * @param _from address The address which you want to send tokens from
79    * @param _to address The address which you want to transfer to
80    * @param _value uint256 the amout of tokens to be transfered
81    */
82   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
83     var _allowance = allowed[_from][msg.sender];
84 
85     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
86     // require (_value <= _allowance);
87 
88     balances[_to] = balances[_to].add(_value);
89     balances[_from] = balances[_from].sub(_value);
90     allowed[_from][msg.sender] = _allowance.sub(_value);
91     Transfer(_from, _to, _value);
92     return true;
93   }
94 
95   /**
96    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
97    * @param _spender The address which will spend the funds.
98    * @param _value The amount of tokens to be spent.
99    */
100   function approve(address _spender, uint256 _value) returns (bool) {
101 
102     // To change the approve amount you first have to reduce the addresses`
103     //  allowance to zero by calling `approve(_spender, 0)` if it is not
104     //  already 0 to mitigate the race condition described here:
105     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
107 
108     allowed[msg.sender][_spender] = _value;
109     Approval(msg.sender, _spender, _value);
110     return true;
111   }
112 
113   /**
114    * @dev Function to check the amount of tokens that an owner allowed to a spender.
115    * @param _owner address The address which owns the funds.
116    * @param _spender address The address which will spend the funds.
117    * @return A uint256 specifing the amount of tokens still available for the spender.
118    */
119   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
120     return allowed[_owner][_spender];
121   }
122 
123 }
124 
125 contract Ownable {
126   address public owner;
127 
128 
129   /**
130    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
131    * account.
132    */
133   function Ownable() {
134     owner = msg.sender;
135   }
136 
137 
138   /**
139    * @dev Throws if called by any account other than the owner.
140    */
141   modifier onlyOwner() {
142     require(msg.sender == owner);
143     _;
144   }
145 
146 
147   /**
148    * @dev Allows the current owner to transfer control of the contract to a newOwner.
149    * @param newOwner The address to transfer ownership to.
150    */
151   function transferOwnership(address newOwner) onlyOwner {
152     require(newOwner != address(0));      
153     owner = newOwner;
154   }
155 
156 }
157 
158 contract Recoverable is Ownable {
159 
160   /// @dev Empty constructor (for now)
161   function Recoverable() {
162   }
163 
164   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
165   /// @param token Token which will we rescue to the owner from the contract
166   function recoverTokens(ERC20Basic token) onlyOwner public {
167     token.transfer(owner, tokensToBeReturned(token));
168   }
169 
170   /// @dev Interface function, can be overwritten by the superclass
171   /// @param token Token which balance we will check and return
172   /// @return The amount of tokens (in smallest denominator) the contract owns
173   function tokensToBeReturned(ERC20Basic token) public returns (uint) {
174     return token.balanceOf(this);
175   }
176 }
177 
178 contract StandardTokenExt is Recoverable, StandardToken {
179 
180   /* Interface declaration */
181   function isToken() public constant returns (bool weAre) {
182     return true;
183   }
184 }
185 
186 contract BurnableToken is StandardTokenExt {
187 
188   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
189   address public constant BURN_ADDRESS = 0;
190 
191   /** How many tokens we burned */
192   event Burned(address burner, uint burnedAmount);
193 
194   /**
195    * Burn extra tokens from a balance.
196    *
197    */
198   function burn(uint burnAmount) {
199     address burner = msg.sender;
200     balances[burner] = balances[burner].sub(burnAmount);
201     totalSupply = totalSupply.sub(burnAmount);
202     Burned(burner, burnAmount);
203 
204     // Inform the blockchain explores that track the
205     // balances only by a transfer event that the balance in this
206     // address has decreased
207     Transfer(burner, BURN_ADDRESS, burnAmount);
208   }
209 }
210 
211 
212 contract UpgradeableToken is StandardTokenExt {
213 
214   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
215   address public upgradeMaster;
216 
217   /** The next contract where the tokens will be migrated. */
218   UpgradeAgent public upgradeAgent;
219 
220   /** How many tokens we have upgraded by now. */
221   uint256 public totalUpgraded;
222 
223   /**
224    * Upgrade states.
225    *
226    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
227    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
228    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
229    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
230    *
231    */
232   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
233 
234   /**
235    * Somebody has upgraded some of his tokens.
236    */
237   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
238 
239   /**
240    * New upgrade agent available.
241    */
242   event UpgradeAgentSet(address agent);
243 
244   /**
245    * Do not allow construction without upgrade master set.
246    */
247   function UpgradeableToken(address _upgradeMaster) {
248     upgradeMaster = _upgradeMaster;
249   }
250 
251   /**
252    * Allow the token holder to upgrade some of their tokens to a new contract.
253    */
254   function upgrade(uint256 value) public {
255 
256       UpgradeState state = getUpgradeState();
257       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
258         // Called in a bad state
259         throw;
260       }
261 
262       // Validate input value.
263       if (value == 0) throw;
264 
265       balances[msg.sender] = balances[msg.sender].sub(value);
266 
267       // Take tokens out from circulation
268       totalSupply = totalSupply.sub(value);
269       totalUpgraded = totalUpgraded.add(value);
270 
271       // Upgrade agent reissues the tokens
272       upgradeAgent.upgradeFrom(msg.sender, value);
273       Upgrade(msg.sender, upgradeAgent, value);
274   }
275 
276   /**
277    * Set an upgrade agent that handles
278    */
279   function setUpgradeAgent(address agent) external {
280 
281       if(!canUpgrade()) {
282         // The token is not yet in a state that we could think upgrading
283         throw;
284       }
285 
286       if (agent == 0x0) throw;
287       // Only a master can designate the next agent
288       if (msg.sender != upgradeMaster) throw;
289       // Upgrade has already begun for an agent
290       if (getUpgradeState() == UpgradeState.Upgrading) throw;
291 
292       upgradeAgent = UpgradeAgent(agent);
293 
294       // Bad interface
295       if(!upgradeAgent.isUpgradeAgent()) throw;
296       // Make sure that token supplies match in source and target
297       if (upgradeAgent.originalSupply() != totalSupply) throw;
298 
299       UpgradeAgentSet(upgradeAgent);
300   }
301 
302   /**
303    * Get the state of the token upgrade.
304    */
305   function getUpgradeState() public constant returns(UpgradeState) {
306     if(!canUpgrade()) return UpgradeState.NotAllowed;
307     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
308     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
309     else return UpgradeState.Upgrading;
310   }
311 
312   /**
313    * Change the upgrade master.
314    *
315    * This allows us to set a new owner for the upgrade mechanism.
316    */
317   function setUpgradeMaster(address master) public {
318       if (master == 0x0) throw;
319       if (msg.sender != upgradeMaster) throw;
320       upgradeMaster = master;
321   }
322 
323   /**
324    * Child contract can enable to provide the condition when the upgrade can begun.
325    */
326   function canUpgrade() public constant returns(bool) {
327      return true;
328   }
329 
330 }
331 
332 contract UpgradeAgent {
333 
334   uint public originalSupply;
335 
336   /** Interface marker */
337   function isUpgradeAgent() public constant returns (bool) {
338     return true;
339   }
340 
341   function upgradeFrom(address _from, uint256 _value) public;
342 
343 }
344 
345 contract MoreAI is BurnableToken, UpgradeableToken {
346 
347   // Token meta information
348   string public name;
349   string public symbol;
350   uint public decimals;
351 
352   event UpdatedTokenInformation(string newName, string newSymbol);
353 
354   function MoreAI()  UpgradeableToken(msg.sender) {
355     name = "MoreAI";
356     symbol = "MO";
357     totalSupply = 1000000000000000000000000000;
358     decimals = 18;
359 
360     // Allocate initial balance to the owner
361     balances[msg.sender] = totalSupply;
362 
363   }
364 
365   function setTokenInformation(string _name, string _symbol) {
366 
367     if(msg.sender != upgradeMaster) {
368       throw;
369     }
370 
371     name = _name;
372     symbol = _symbol;
373     UpdatedTokenInformation(name, symbol);
374   }
375 
376 
377   function transfer(address _to, uint _value) returns (bool success) {
378     return super.transfer(_to, _value);
379   }
380 
381 }