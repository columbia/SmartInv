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
17 /**
18  * Math operations with safety checks
19  */
20 contract SafeMath {
21   function safeMul(uint a, uint b) internal returns (uint) {
22     uint c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27   function safeDiv(uint a, uint b) internal returns (uint) {
28     assert(b > 0);
29     uint c = a / b;
30     assert(a == b * c + a % b);
31     return c;
32   }
33 
34   function safeSub(uint a, uint b) internal returns (uint) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function safeAdd(uint a, uint b) internal returns (uint) {
40     uint c = a + b;
41     assert(c>=a && c>=b);
42     return c;
43   }
44 
45   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
46     return a >= b ? a : b;
47   }
48 
49   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
50     return a < b ? a : b;
51   }
52 
53   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
54     return a >= b ? a : b;
55   }
56 
57   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
58     return a < b ? a : b;
59   }
60 
61   function assert(bool assertion) internal {
62     if (!assertion) {
63       throw;
64     }
65   }
66 }
67 
68 
69 
70 /**
71  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
72  *
73  * Based on code by FirstBlood:
74  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
75  */
76 contract StandardToken is ERC20, SafeMath {
77 
78   /* Actual balances of token holders */
79   mapping(address => uint) balances;
80 
81   /* approve() allowances */
82   mapping (address => mapping (address => uint)) allowed;
83 
84   /* Interface declaration */
85   function isToken() public constant returns (bool weAre) {
86     return true;
87   }
88 
89   function transfer(address _to, uint _value) returns (bool success) {
90     balances[msg.sender] = safeSub(balances[msg.sender], _value);
91     balances[_to] = safeAdd(balances[_to], _value);
92     Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
97     uint _allowance = allowed[_from][msg.sender];
98 
99     balances[_to] = safeAdd(balances[_to], _value);
100     balances[_from] = safeSub(balances[_from], _value);
101     allowed[_from][msg.sender] = safeSub(_allowance, _value);
102     Transfer(_from, _to, _value);
103     return true;
104   }
105 
106   function balanceOf(address _owner) constant returns (uint balance) {
107     return balances[_owner];
108   }
109 
110   function approve(address _spender, uint _value) returns (bool success) {
111 
112     // To change the approve amount you first have to reduce the addresses`
113     //  allowance to zero by calling `approve(_spender, 0)` if it is not
114     //  already 0 to mitigate the race condition described here:
115     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
116     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
117 
118     allowed[msg.sender][_spender] = _value;
119     Approval(msg.sender, _spender, _value);
120     return true;
121   }
122 
123   function allowance(address _owner, address _spender) constant returns (uint remaining) {
124     return allowed[_owner][_spender];
125   }
126 
127 }
128 
129 
130 /**
131  * Upgrade agent interface inspired by Lunyr.
132  *
133  * Upgrade agent transfers tokens to a new version of a token contract.
134  * Upgrade agent can be set on a token by the upgrade master.
135  *
136  * Steps are
137  * - Upgradeabletoken.upgradeMaster calls UpgradeableToken.setUpgradeAgent()
138  * - Individual token holders can now call UpgradeableToken.upgrade()
139  *   -> This results to call UpgradeAgent.upgradeFrom() that issues new tokens
140  *   -> UpgradeableToken.upgrade() reduces the original total supply based on amount of upgraded tokens
141  *
142  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
143  */
144 contract UpgradeAgent {
145 
146   uint public originalSupply;
147 
148   /** Interface marker */
149   function isUpgradeAgent() public constant returns (bool) {
150     return true;
151   }
152 
153   /**
154    * Upgrade amount of tokens to a new version.
155    *
156    * Only callable by UpgradeableToken.
157    *
158    * @param _tokenHolder Address that wants to upgrade its tokens
159    * @param _amount Number of tokens to upgrade. The address may consider to hold back some amount of tokens in the old version.
160    */
161   function upgradeFrom(address _tokenHolder, uint256 _amount) external;
162 }
163 
164 
165 /**
166  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
167  *
168  * First envisioned by Golem and Lunyr projects.
169  */
170 contract UpgradeableToken is StandardToken {
171 
172   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
173   address public upgradeMaster;
174 
175   /** The next contract where the tokens will be migrated. */
176   UpgradeAgent public upgradeAgent;
177 
178   /** How many tokens we have upgraded by now. */
179   uint256 public totalUpgraded;
180 
181   /**
182    * Upgrade states.
183    *
184    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
185    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
186    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
187    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
188    *
189    */
190   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
191 
192   /**
193    * Somebody has upgraded some of his tokens.
194    */
195   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
196 
197   /**
198    * New upgrade agent available.
199    */
200   event UpgradeAgentSet(address agent);
201 
202   /**
203    * Upgrade master updated.
204    */
205   event NewUpgradeMaster(address upgradeMaster);
206 
207   /**
208    * Do not allow construction without upgrade master set.
209    */
210   function UpgradeableToken(address _upgradeMaster) {
211     upgradeMaster = _upgradeMaster;
212     NewUpgradeMaster(upgradeMaster);
213   }
214 
215   /**
216    * Allow the token holder to upgrade some of their tokens to a new contract.
217    */
218   function upgrade(uint256 value) public {
219 
220       UpgradeState state = getUpgradeState();
221       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
222         // Called in a bad state
223         throw;
224       }
225 
226       // Validate input value.
227       if (value == 0) throw;
228 
229       balances[msg.sender] = safeSub(balances[msg.sender], value);
230 
231       // Take tokens out from circulation
232       totalSupply = safeSub(totalSupply, value);
233       totalUpgraded = safeAdd(totalUpgraded, value);
234 
235       // Upgrade agent reissues the tokens
236       upgradeAgent.upgradeFrom(msg.sender, value);
237       Upgrade(msg.sender, upgradeAgent, value);
238   }
239 
240   /**
241    * Set an upgrade agent that handles
242    */
243   function setUpgradeAgent(address agent) external {
244 
245       if(!canUpgrade()) {
246         // The token is not yet in a state that we could think upgrading
247         throw;
248       }
249 
250       if (agent == 0x0) throw;
251       // Only a master can designate the next agent
252       if (msg.sender != upgradeMaster) throw;
253       // Upgrade has already begun for an agent
254       if (getUpgradeState() == UpgradeState.Upgrading) throw;
255 
256       upgradeAgent = UpgradeAgent(agent);
257 
258       // Bad interface
259       if(!upgradeAgent.isUpgradeAgent()) throw;
260       // Make sure that token supplies match in source and target
261       if (upgradeAgent.originalSupply() != totalSupply) throw;
262 
263       UpgradeAgentSet(upgradeAgent);
264   }
265 
266   /**
267    * Get the state of the token upgrade.
268    */
269   function getUpgradeState() public constant returns(UpgradeState) {
270     if(!canUpgrade()) return UpgradeState.NotAllowed;
271     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
272     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
273     else return UpgradeState.Upgrading;
274   }
275 
276   /**
277    * Change the upgrade master.
278    *
279    * This allows us to set a new owner for the upgrade mechanism.
280    */
281   function setUpgradeMaster(address master) public {
282       if (master == 0x0) throw;
283       if (msg.sender != upgradeMaster) throw;
284       upgradeMaster = master;
285       NewUpgradeMaster(upgradeMaster);
286   }
287 
288   /**
289    * Child contract can enable to provide the condition when the upgrade can begun.
290    */
291   function canUpgrade() public constant returns(bool) {
292      return true;
293   }
294 
295 }
296 
297 
298 /**
299  * Centrally issued Ethereum token.
300  *
301  * We mix in burnable and upgradeable traits.
302  *
303  * Token supply is created in the token contract creation and allocated to owner.
304  * The owner can then transfer from its supply to crowdsale participants.
305  * The owner, or anybody, can burn any excessive tokens they are holding.
306  *
307  */
308 contract BitAirToken is UpgradeableToken {
309 
310   string public name;
311   string public symbol;
312   uint public decimals;
313 
314   /** Name and symbol were updated. */
315   event UpdatedTokenInformation(string newName, string newSymbol);
316 
317   function BitAirToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals)  UpgradeableToken(_owner) {
318     name = _name;
319     symbol = _symbol;
320     totalSupply = _totalSupply;
321     decimals = _decimals;
322 
323     // Allocate initial balance to the owner
324     balances[_owner] = _totalSupply;
325   }
326 
327   /**
328    * Owner can update token information here.
329    *
330    * It is often useful to conceal the actual token association, until
331    * the token operations, like central issuance or reissuance have been completed.
332    * In this case the initial token can be supplied with empty name and symbol information.
333    *
334    * This function allows the token owner to rename the token after the operations
335    * have been completed and then point the audience to use the token contract.
336    */
337   function setTokenInformation(string _name, string _symbol) {
338 
339     if(msg.sender != upgradeMaster) {
340       throw;
341     }
342 
343     if(bytes(name).length > 0 || bytes(symbol).length > 0) {
344       // Information already set
345       // Allow owner to set this information only once
346       throw;
347     }
348 
349     name = _name;
350     symbol = _symbol;
351     UpdatedTokenInformation(name, symbol);
352   }
353 
354 }