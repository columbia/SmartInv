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
73  * Standard ERC20 token
74  *
75  * https://github.com/ethereum/EIPs/issues/20
76  * Based on code by FirstBlood:
77  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
78  */
79 contract StandardToken is ERC20, SafeMath {
80 
81   mapping(address => uint) balances;
82   mapping (address => mapping (address => uint)) allowed;
83 
84   function transfer(address _to, uint _value) returns (bool success) {
85     balances[msg.sender] = safeSub(balances[msg.sender], _value);
86     balances[_to] = safeAdd(balances[_to], _value);
87     Transfer(msg.sender, _to, _value);
88     return true;
89   }
90 
91   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
92     var _allowance = allowed[_from][msg.sender];
93 
94     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
95     // if (_value > _allowance) throw;
96 
97     balances[_to] = safeAdd(balances[_to], _value);
98     balances[_from] = safeSub(balances[_from], _value);
99     allowed[_from][msg.sender] = safeSub(_allowance, _value);
100     Transfer(_from, _to, _value);
101     return true;
102   }
103 
104   function balanceOf(address _owner) constant returns (uint balance) {
105     return balances[_owner];
106   }
107 
108   function approve(address _spender, uint _value) returns (bool success) {
109     allowed[msg.sender][_spender] = _value;
110     Approval(msg.sender, _spender, _value);
111     return true;
112   }
113 
114   function allowance(address _owner, address _spender) constant returns (uint remaining) {
115     return allowed[_owner][_spender];
116   }
117 
118 }
119 
120 
121 
122 contract BurnableToken is StandardToken {
123 
124   address public constant BURN_ADDRESS = 0;
125 
126   /** How many tokens we burned */
127   event Burned(address burner, uint burnedAmount);
128 
129   /**
130    * Burn extra tokens from a balance.
131    *
132    */
133   function burn(uint burnAmount) {
134     address burner = msg.sender;
135     balances[burner] = safeSub(balances[burner], burnAmount);
136     totalSupply = safeSub(totalSupply, burnAmount);
137     Burned(burner, burnAmount);
138 
139     // Keep exchanges happy by sending the burned amount to
140     // "burn address"
141     Transfer(burner, BURN_ADDRESS, burnAmount);
142   }
143 }
144 
145 
146 
147 
148 
149 /**
150  * Upgrade agent interface inspired by Lunyr.
151  *
152  * Upgrade agent transfers tokens to a new contract.
153  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
154  */
155 contract UpgradeAgent {
156 
157   uint public originalSupply;
158 
159   /** Interface marker */
160   function isUpgradeAgent() public constant returns (bool) {
161     return true;
162   }
163 
164   function upgradeFrom(address _from, uint256 _value) public;
165 
166 }
167 
168 
169 /**
170  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
171  *
172  * First envisioned by Golem and Lunyr projects.
173  */
174 contract UpgradeableToken is StandardToken {
175 
176   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
177   address public upgradeMaster;
178 
179   /** The next contract where the tokens will be migrated. */
180   UpgradeAgent public upgradeAgent;
181 
182   /** How many tokens we have upgraded by now. */
183   uint256 public totalUpgraded;
184 
185   /**
186    * Upgrade states.
187    *
188    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
189    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
190    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
191    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
192    *
193    */
194   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
195 
196   /**
197    * Somebody has upgraded some of his tokens.
198    */
199   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
200 
201   /**
202    * New upgrade agent available.
203    */
204   event UpgradeAgentSet(address agent);
205 
206   /**
207    * Do not allow construction without upgrade master set.
208    */
209   function UpgradeableToken(address _upgradeMaster) {
210     upgradeMaster = _upgradeMaster;
211   }
212 
213   /**
214    * Allow the token holder to upgrade some of their tokens to a new contract.
215    */
216   function upgrade(uint256 value) public {
217 
218       UpgradeState state = getUpgradeState();
219       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
220         // Called in a bad state
221         throw;
222       }
223 
224       // Validate input value.
225       if (value == 0) throw;
226 
227       balances[msg.sender] = safeSub(balances[msg.sender], value);
228 
229       // Take tokens out from circulation
230       totalSupply = safeSub(totalSupply, value);
231       totalUpgraded = safeAdd(totalUpgraded, value);
232 
233       // Upgrade agent reissues the tokens
234       upgradeAgent.upgradeFrom(msg.sender, value);
235       Upgrade(msg.sender, upgradeAgent, value);
236   }
237 
238   /**
239    * Set an upgrade agent that handles
240    */
241   function setUpgradeAgent(address agent) external {
242 
243       if(!canUpgrade()) {
244         // The token is not yet in a state that we could think upgrading
245         throw;
246       }
247 
248       if (agent == 0x0) throw;
249       // Only a master can designate the next agent
250       if (msg.sender != upgradeMaster) throw;
251       // Upgrade has already begun for an agent
252       if (getUpgradeState() == UpgradeState.Upgrading) throw;
253 
254       upgradeAgent = UpgradeAgent(agent);
255 
256       // Bad interface
257       if(!upgradeAgent.isUpgradeAgent()) throw;
258       // Make sure that token supplies match in source and target
259       if (upgradeAgent.originalSupply() != totalSupply) throw;
260 
261       UpgradeAgentSet(upgradeAgent);
262   }
263 
264   /**
265    * Get the state of the token upgrade.
266    */
267   function getUpgradeState() public constant returns(UpgradeState) {
268     if(!canUpgrade()) return UpgradeState.NotAllowed;
269     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
270     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
271     else return UpgradeState.Upgrading;
272   }
273 
274   /**
275    * Change the upgrade master.
276    *
277    * This allows us to set a new owner for the upgrade mechanism.
278    */
279   function setUpgradeMaster(address master) public {
280       if (master == 0x0) throw;
281       if (msg.sender != upgradeMaster) throw;
282       upgradeMaster = master;
283   }
284 
285   /**
286    * Child contract can enable to provide the condition when the upgrade can begun.
287    */
288   function canUpgrade() public constant returns(bool) {
289      return true;
290   }
291 
292 }
293 
294 
295 
296 /**
297  * Centrally issued Ethereum token.
298  *
299  * We mix in burnable and upgradeable traits.
300  *
301  * Token supply is created in the token contract creation and allocated to owner.
302  * The owner can then transfer from its supply to crowdsale participants.
303  * The owner, or anybody, can burn any excessive tokens they are holding.
304  *
305  */
306 contract CentrallyIssuedToken is BurnableToken, UpgradeableToken {
307 
308   string public name;
309   string public symbol;
310   uint public decimals;
311 
312   function CentrallyIssuedToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals)  UpgradeableToken(_owner) {
313     name = _name;
314     symbol = _symbol;
315     totalSupply = _totalSupply;
316     decimals = _decimals;
317 
318     // Allocate initial balance to the owner
319     balances[_owner] = _totalSupply;
320   }
321 }