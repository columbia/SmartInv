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
19 
20 
21 
22 /**
23  * Math operations with safety checks
24  */
25 contract SafeMath {
26   function safeMul(uint a, uint b) internal returns (uint) {
27     uint c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30   }
31 
32   function safeDiv(uint a, uint b) internal returns (uint) {
33     assert(b > 0);
34     uint c = a / b;
35     assert(a == b * c + a % b);
36     return c;
37   }
38 
39   function safeSub(uint a, uint b) internal returns (uint) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function safeAdd(uint a, uint b) internal returns (uint) {
45     uint c = a + b;
46     assert(c>=a && c>=b);
47     return c;
48   }
49 
50   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
51     return a >= b ? a : b;
52   }
53 
54   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
55     return a < b ? a : b;
56   }
57 
58   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
59     return a >= b ? a : b;
60   }
61 
62   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
63     return a < b ? a : b;
64   }
65 
66   function assert(bool assertion) internal {
67     if (!assertion) {
68       throw;
69     }
70   }
71 }
72 
73 
74 
75 /**
76  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
77  *
78  * Based on code by FirstBlood:
79  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
80  */
81 contract StandardToken is ERC20, SafeMath {
82 
83   /* Actual balances of token holders */
84   mapping(address => uint) balances;
85 
86   /* approve() allowances */
87   mapping (address => mapping (address => uint)) allowed;
88 
89   /* Interface declaration */
90   function isToken() public constant returns (bool weAre) {
91     return true;
92   }
93 
94   function transfer(address _to, uint _value) returns (bool success) {
95     balances[msg.sender] = safeSub(balances[msg.sender], _value);
96     balances[_to] = safeAdd(balances[_to], _value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
102     uint _allowance = allowed[_from][msg.sender];
103 
104     balances[_to] = safeAdd(balances[_to], _value);
105     balances[_from] = safeSub(balances[_from], _value);
106     allowed[_from][msg.sender] = safeSub(_allowance, _value);
107     Transfer(_from, _to, _value);
108     return true;
109   }
110 
111   function balanceOf(address _owner) constant returns (uint balance) {
112     return balances[_owner];
113   }
114 
115   function approve(address _spender, uint _value) returns (bool success) {
116 
117     // To change the approve amount you first have to reduce the addresses`
118     //  allowance to zero by calling `approve(_spender, 0)` if it is not
119     //  already 0 to mitigate the race condition described here:
120     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
121     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
122 
123     allowed[msg.sender][_spender] = _value;
124     Approval(msg.sender, _spender, _value);
125     return true;
126   }
127 
128   function allowance(address _owner, address _spender) constant returns (uint remaining) {
129     return allowed[_owner][_spender];
130   }
131 
132 }
133 
134 
135 /**
136  * Upgrade agent interface inspired by Lunyr.
137  *
138  * Upgrade agent transfers tokens to a new version of a token contract.
139  * Upgrade agent can be set on a token by the upgrade master.
140  *
141  * Steps are
142  * - Upgradeabletoken.upgradeMaster calls UpgradeableToken.setUpgradeAgent()
143  * - Individual token holders can now call UpgradeableToken.upgrade()
144  *   -> This results to call UpgradeAgent.upgradeFrom() that issues new tokens
145  *   -> UpgradeableToken.upgrade() reduces the original total supply based on amount of upgraded tokens
146  *
147  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
148  */
149 contract UpgradeAgent {
150 
151   uint public originalSupply;
152 
153   /** Interface marker */
154   function isUpgradeAgent() public constant returns (bool) {
155     return true;
156   }
157 
158   /**
159    * Upgrade amount of tokens to a new version.
160    *
161    * Only callable by UpgradeableToken.
162    *
163    * @param _tokenHolder Address that wants to upgrade its tokens
164    * @param _amount Number of tokens to upgrade. The address may consider to hold back some amount of tokens in the old version.
165    */
166   function upgradeFrom(address _tokenHolder, uint256 _amount) external;
167 }
168 
169 
170 /**
171  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
172  *
173  * First envisioned by Golem and Lunyr projects.
174  */
175 contract UpgradeableToken is StandardToken {
176 
177   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
178   address public upgradeMaster;
179 
180   /** The next contract where the tokens will be migrated. */
181   UpgradeAgent public upgradeAgent;
182 
183   /** How many tokens we have upgraded by now. */
184   uint256 public totalUpgraded;
185 
186   /**
187    * Upgrade states.
188    *
189    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
190    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
191    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
192    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
193    *
194    */
195   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
196 
197   /**
198    * Somebody has upgraded some of his tokens.
199    */
200   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
201 
202   /**
203    * New upgrade agent available.
204    */
205   event UpgradeAgentSet(address agent);
206 
207   /**
208    * Upgrade master updated.
209    */
210   event NewUpgradeMaster(address upgradeMaster);
211 
212   /**
213    * Do not allow construction without upgrade master set.
214    */
215   function UpgradeableToken(address _upgradeMaster) {
216     upgradeMaster = _upgradeMaster;
217     NewUpgradeMaster(upgradeMaster);
218   }
219 
220   /**
221    * Allow the token holder to upgrade some of their tokens to a new contract.
222    */
223   function upgrade(uint256 value) public {
224 
225       UpgradeState state = getUpgradeState();
226       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
227         // Called in a bad state
228         throw;
229       }
230 
231       // Validate input value.
232       if (value == 0) throw;
233 
234       balances[msg.sender] = safeSub(balances[msg.sender], value);
235 
236       // Take tokens out from circulation
237       totalSupply = safeSub(totalSupply, value);
238       totalUpgraded = safeAdd(totalUpgraded, value);
239 
240       // Upgrade agent reissues the tokens
241       upgradeAgent.upgradeFrom(msg.sender, value);
242       Upgrade(msg.sender, upgradeAgent, value);
243   }
244 
245   /**
246    * Set an upgrade agent that handles
247    */
248   function setUpgradeAgent(address agent) external {
249 
250       if(!canUpgrade()) {
251         // The token is not yet in a state that we could think upgrading
252         throw;
253       }
254 
255       if (agent == 0x0) throw;
256       // Only a master can designate the next agent
257       if (msg.sender != upgradeMaster) throw;
258       // Upgrade has already begun for an agent
259       if (getUpgradeState() == UpgradeState.Upgrading) throw;
260 
261       upgradeAgent = UpgradeAgent(agent);
262 
263       // Bad interface
264       if(!upgradeAgent.isUpgradeAgent()) throw;
265       // Make sure that token supplies match in source and target
266       if (upgradeAgent.originalSupply() != totalSupply) throw;
267 
268       UpgradeAgentSet(upgradeAgent);
269   }
270 
271   /**
272    * Get the state of the token upgrade.
273    */
274   function getUpgradeState() public constant returns(UpgradeState) {
275     if(!canUpgrade()) return UpgradeState.NotAllowed;
276     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
277     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
278     else return UpgradeState.Upgrading;
279   }
280 
281   /**
282    * Change the upgrade master.
283    *
284    * This allows us to set a new owner for the upgrade mechanism.
285    */
286   function setUpgradeMaster(address master) public {
287       if (master == 0x0) throw;
288       if (msg.sender != upgradeMaster) throw;
289       upgradeMaster = master;
290       NewUpgradeMaster(upgradeMaster);
291   }
292 
293   /**
294    * Child contract can enable to provide the condition when the upgrade can begun.
295    */
296   function canUpgrade() public constant returns(bool) {
297      return true;
298   }
299 
300 }
301 
302 
303 
304 /**
305  * Centrally issued Ethereum token.
306  *
307  * We mix in burnable and upgradeable traits.
308  *
309  * Token supply is created in the token contract creation and allocated to owner.
310  * The owner can then transfer from its supply to crowdsale participants.
311  * The owner, or anybody, can burn any excessive tokens they are holding.
312  *
313  */
314 contract CentrallyIssuedToken is UpgradeableToken {
315 
316   // Token meta information
317   string public name;
318   string public symbol;
319   uint public decimals;
320 
321   // Token release switch
322   bool public released = false;
323 
324   // The date before the release must be finalized or upgrade path will be forced
325   uint public releaseFinalizationDate;
326 
327   /** Name and symbol were updated. */
328   event UpdatedTokenInformation(string newName, string newSymbol);
329 
330   function CentrallyIssuedToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals, uint _releaseFinalizationDate)  UpgradeableToken(_owner) {
331     name = _name;
332     symbol = _symbol;
333     totalSupply = _totalSupply;
334     decimals = _decimals;
335 
336     // Allocate initial balance to the owner
337     balances[_owner] = _totalSupply;
338 
339     releaseFinalizationDate = _releaseFinalizationDate;
340   }
341 
342   /**
343    * Owner can update token information here.
344    *
345    * It is often useful to conceal the actual token association, until
346    * the token operations, like central issuance or reissuance have been completed.
347    * In this case the initial token can be supplied with empty name and symbol information.
348    *
349    * This function allows the token owner to rename the token after the operations
350    * have been completed and then point the audience to use the token contract.
351    */
352   function setTokenInformation(string _name, string _symbol) {
353 
354     if(msg.sender != upgradeMaster) {
355       throw;
356     }
357 
358     if(bytes(name).length > 0 || bytes(symbol).length > 0) {
359       // Information already set
360       // Allow owner to set this information only once
361       throw;
362     }
363 
364     name = _name;
365     symbol = _symbol;
366     UpdatedTokenInformation(name, symbol);
367   }
368 
369 
370   /**
371    * Kill switch for the token in the case of distribution issue.
372    *
373    */
374   function transfer(address _to, uint _value) returns (bool success) {
375 
376     if(now > releaseFinalizationDate) {
377       if(!released) {
378         throw;
379       }
380     }
381 
382     return super.transfer(_to, _value);
383   }
384 
385   /**
386    * One way function to perform the final token release.
387    */
388   function releaseTokenTransfer() {
389     if(msg.sender != upgradeMaster) {
390       throw;
391     }
392 
393     released = true;
394   }
395 }