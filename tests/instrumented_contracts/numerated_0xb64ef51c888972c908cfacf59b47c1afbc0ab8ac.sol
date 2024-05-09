1 /*
2  * ERC20 interface
3  * see https://github.com/ethereum/EIPs/issues/20
4  */
5 contract ERC20 {
6   uint public totalSupply;
7   function balanceOf(address who) constant returns (uint);
8   function allowance(address owner, address spender) constant returns (uint);
9 
10   function transfer(address to, uint value) returns (bool ok);
11   function transferFrom(address from, address to, uint value) returns (bool ok);
12   function approve(address spender, uint value) returns (bool ok);
13   event Transfer(address indexed from, address indexed to, uint value);
14   event Approval(address indexed owner, address indexed spender, uint value);
15 }
16 
17 
18 
19 /**
20  * Math operations with safety checks
21  */
22 contract SafeMath {
23   function safeMul(uint a, uint b) internal returns (uint) {
24     uint c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29   function safeDiv(uint a, uint b) internal returns (uint) {
30     assert(b > 0);
31     uint c = a / b;
32     assert(a == b * c + a % b);
33     return c;
34   }
35 
36   function safeSub(uint a, uint b) internal returns (uint) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function safeAdd(uint a, uint b) internal returns (uint) {
42     uint c = a + b;
43     assert(c>=a && c>=b);
44     return c;
45   }
46 
47   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
48     return a >= b ? a : b;
49   }
50 
51   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
52     return a < b ? a : b;
53   }
54 
55   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
56     return a >= b ? a : b;
57   }
58 
59   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
60     return a < b ? a : b;
61   }
62 
63   function assert(bool assertion) internal {
64     if (!assertion) {
65       throw;
66     }
67   }
68 }
69 
70 
71 
72 /**
73  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
74  *
75  * Based on code by FirstBlood:
76  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
77  */
78 contract StandardToken is ERC20, SafeMath {
79 
80   mapping(address => uint) balances;
81   mapping (address => mapping (address => uint)) allowed;
82 
83   // Interface marker
84   bool public constant isToken = true;
85 
86   /**
87    *
88    * Fix for the ERC20 short address attack
89    *
90    * http://vessenes.com/the-erc20-short-address-attack-explained/
91    */
92   modifier onlyPayloadSize(uint size) {
93      if(msg.data.length < size + 4) {
94        throw;
95      }
96      _;
97   }
98 
99   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
100     balances[msg.sender] = safeSub(balances[msg.sender], _value);
101     balances[_to] = safeAdd(balances[_to], _value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   function transferFrom(address _from, address _to, uint _value)  returns (bool success) {
107     var _allowance = allowed[_from][msg.sender];
108 
109     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
110     // if (_value > _allowance) throw;
111 
112     balances[_to] = safeAdd(balances[_to], _value);
113     balances[_from] = safeSub(balances[_from], _value);
114     allowed[_from][msg.sender] = safeSub(_allowance, _value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   function balanceOf(address _owner) constant returns (uint balance) {
120     return balances[_owner];
121   }
122 
123   function approve(address _spender, uint _value) returns (bool success) {
124 
125     // To change the approve amount you first have to reduce the addresses`
126     //  allowance to zero by calling `approve(_spender, 0)` if it is not
127     //  already 0 to mitigate the race condition described here:
128     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
130 
131     allowed[msg.sender][_spender] = _value;
132     Approval(msg.sender, _spender, _value);
133     return true;
134   }
135 
136   function allowance(address _owner, address _spender) constant returns (uint remaining) {
137     return allowed[_owner][_spender];
138   }
139 
140 }
141 
142 
143 
144 /**
145  * A trait that allows any token owner to decrease the token supply.
146  *
147  * We add a Burned event to differentiate from normal transfers.
148  * However, we still try to support some legacy Ethereum ecocsystem,
149  * as ERC-20 has not standardized on the burn event yet.
150  *
151  */
152 contract BurnableToken is StandardToken {
153 
154   address public constant BURN_ADDRESS = 0;
155 
156   /** How many tokens we burned */
157   event Burned(address burner, uint burnedAmount);
158 
159   /**
160    * Burn extra tokens from a balance.
161    *
162    */
163   function burn(uint burnAmount) {
164     address burner = msg.sender;
165     balances[burner] = safeSub(balances[burner], burnAmount);
166     totalSupply = safeSub(totalSupply, burnAmount);
167     Burned(burner, burnAmount);
168 
169     // Keep token balance tracking services happy by sending the burned amount to
170     // "burn address", so that it will show up as a ERC-20 transaction
171     // in etherscan, etc. as there is no standarized burn event yet
172     Transfer(burner, BURN_ADDRESS, burnAmount);
173   }
174 }
175 
176 
177 
178 
179 /**
180  * Upgrade agent interface inspired by Lunyr.
181  *
182  * Upgrade agent transfers tokens to a new contract.
183  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
184  */
185 contract UpgradeAgent {
186 
187   uint public originalSupply;
188 
189   /** Interface marker */
190   function isUpgradeAgent() public constant returns (bool) {
191     return true;
192   }
193 
194   function upgradeFrom(address _from, uint256 _value) public;
195 
196 }
197 
198 
199 /**
200  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
201  *
202  * First envisioned by Golem and Lunyr projects.
203  */
204 contract UpgradeableToken is StandardToken {
205 
206   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
207   address public upgradeMaster;
208 
209   /** The next contract where the tokens will be migrated. */
210   UpgradeAgent public upgradeAgent;
211 
212   /** How many tokens we have upgraded by now. */
213   uint256 public totalUpgraded;
214 
215   /**
216    * Upgrade states.
217    *
218    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
219    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
220    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
221    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
222    *
223    */
224   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
225 
226   /**
227    * Somebody has upgraded some of his tokens.
228    */
229   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
230 
231   /**
232    * New upgrade agent available.
233    */
234   event UpgradeAgentSet(address agent);
235 
236   /**
237    * Do not allow construction without upgrade master set.
238    */
239   function UpgradeableToken(address _upgradeMaster) {
240     upgradeMaster = _upgradeMaster;
241   }
242 
243   /**
244    * Allow the token holder to upgrade some of their tokens to a new contract.
245    */
246   function upgrade(uint256 value) public {
247 
248       UpgradeState state = getUpgradeState();
249       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
250         // Called in a bad state
251         throw;
252       }
253 
254       // Validate input value.
255       if (value == 0) throw;
256 
257       balances[msg.sender] = safeSub(balances[msg.sender], value);
258 
259       // Take tokens out from circulation
260       totalSupply = safeSub(totalSupply, value);
261       totalUpgraded = safeAdd(totalUpgraded, value);
262 
263       // Upgrade agent reissues the tokens
264       upgradeAgent.upgradeFrom(msg.sender, value);
265       Upgrade(msg.sender, upgradeAgent, value);
266   }
267 
268   /**
269    * Set an upgrade agent that handles
270    */
271   function setUpgradeAgent(address agent) external {
272 
273       if(!canUpgrade()) {
274         // The token is not yet in a state that we could think upgrading
275         throw;
276       }
277 
278       if (agent == 0x0) throw;
279       // Only a master can designate the next agent
280       if (msg.sender != upgradeMaster) throw;
281       // Upgrade has already begun for an agent
282       if (getUpgradeState() == UpgradeState.Upgrading) throw;
283 
284       upgradeAgent = UpgradeAgent(agent);
285 
286       // Bad interface
287       if(!upgradeAgent.isUpgradeAgent()) throw;
288       // Make sure that token supplies match in source and target
289       if (upgradeAgent.originalSupply() != totalSupply) throw;
290 
291       UpgradeAgentSet(upgradeAgent);
292   }
293 
294   /**
295    * Get the state of the token upgrade.
296    */
297   function getUpgradeState() public constant returns(UpgradeState) {
298     if(!canUpgrade()) return UpgradeState.NotAllowed;
299     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
300     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
301     else return UpgradeState.Upgrading;
302   }
303 
304   /**
305    * Change the upgrade master.
306    *
307    * This allows us to set a new owner for the upgrade mechanism.
308    */
309   function setUpgradeMaster(address master) public {
310       if (master == 0x0) throw;
311       if (msg.sender != upgradeMaster) throw;
312       upgradeMaster = master;
313   }
314 
315   /**
316    * Child contract can enable to provide the condition when the upgrade can begun.
317    */
318   function canUpgrade() public constant returns(bool) {
319      return true;
320   }
321 
322 }
323 
324 
325 
326 /**
327  * Centrally issued Ethereum token.
328  *
329  * We mix in burnable and upgradeable traits.
330  *
331  * Token supply is created in the token contract creation and allocated to owner.
332  * The owner can then transfer from its supply to crowdsale participants.
333  * The owner, or anybody, can burn any excessive tokens they are holding.
334  *
335  */
336 contract CentrallyIssuedToken is BurnableToken, UpgradeableToken {
337 
338   string public name;
339   string public symbol;
340   uint public decimals;
341 
342   function CentrallyIssuedToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals)  UpgradeableToken(_owner) {
343     name = _name;
344     symbol = _symbol;
345     totalSupply = _totalSupply;
346     decimals = _decimals;
347 
348     // Allocate initial balance to the owner
349     balances[_owner] = _totalSupply;
350   }
351 }