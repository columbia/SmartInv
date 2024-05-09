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
80   /* Token supply got increased and a new owner received these tokens */
81   event Minted(address receiver, uint amount);
82 
83   /* Actual balances of token holders */
84   mapping(address => uint) balances;
85 
86   /* approve() allowances */
87   mapping (address => mapping (address => uint)) allowed;
88 
89   /**
90    *
91    * Fix for the ERC20 short address attack
92    *
93    * http://vessenes.com/the-erc20-short-address-attack-explained/
94    */
95   modifier onlyPayloadSize(uint size) {
96      if(msg.data.length != size + 4) {
97        throw;
98      }
99      _;
100   }
101 
102   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
103     balances[msg.sender] = safeSub(balances[msg.sender], _value);
104     balances[_to] = safeAdd(balances[_to], _value);
105     Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
110     uint _allowance = allowed[_from][msg.sender];
111 
112     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
113     // if (_value > _allowance) throw;
114 
115     balances[_to] = safeAdd(balances[_to], _value);
116     balances[_from] = safeSub(balances[_from], _value);
117     allowed[_from][msg.sender] = safeSub(_allowance, _value);
118     Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   function balanceOf(address _owner) constant returns (uint balance) {
123     return balances[_owner];
124   }
125 
126   function approve(address _spender, uint _value) returns (bool success) {
127 
128     // To change the approve amount you first have to reduce the addresses`
129     //  allowance to zero by calling `approve(_spender, 0)` if it is not
130     //  already 0 to mitigate the race condition described here:
131     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
133 
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   function allowance(address _owner, address _spender) constant returns (uint remaining) {
140     return allowed[_owner][_spender];
141   }
142 
143   /**
144    * Atomic increment of approved spending
145    *
146    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147    *
148    */
149   function addApproval(address _spender, uint _addedValue)
150   onlyPayloadSize(2 * 32)
151   returns (bool success) {
152       uint oldValue = allowed[msg.sender][_spender];
153       allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
154       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
155       return true;
156   }
157 
158   /**
159    * Atomic decrement of approved spending.
160    *
161    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    */
163   function subApproval(address _spender, uint _subtractedValue)
164   onlyPayloadSize(2 * 32)
165   returns (bool success) {
166 
167       uint oldVal = allowed[msg.sender][_spender];
168 
169       if (_subtractedValue > oldVal) {
170           allowed[msg.sender][_spender] = 0;
171       } else {
172           allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);
173       }
174       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175       return true;
176   }
177 
178 }
179 
180 
181 
182 contract BurnableToken is StandardToken {
183 
184   address public constant BURN_ADDRESS = 0;
185 
186   /** How many tokens we burned */
187   event Burned(address burner, uint burnedAmount);
188 
189   /**
190    * Burn extra tokens from a balance.
191    *
192    */
193   function burn(uint burnAmount) {
194     address burner = msg.sender;
195     balances[burner] = safeSub(balances[burner], burnAmount);
196     totalSupply = safeSub(totalSupply, burnAmount);
197     Burned(burner, burnAmount);
198   }
199 }
200 
201 
202 
203 
204 
205 /**
206  * Upgrade agent interface inspired by Lunyr.
207  *
208  * Upgrade agent transfers tokens to a new contract.
209  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
210  */
211 contract UpgradeAgent {
212 
213   uint public originalSupply;
214 
215   /** Interface marker */
216   function isUpgradeAgent() public constant returns (bool) {
217     return true;
218   }
219 
220   function upgradeFrom(address _from, uint256 _value) public;
221 
222 }
223 
224 
225 /**
226  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
227  *
228  * First envisioned by Golem and Lunyr projects.
229  */
230 contract UpgradeableToken is StandardToken {
231 
232   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
233   address public upgradeMaster;
234 
235   /** The next contract where the tokens will be migrated. */
236   UpgradeAgent public upgradeAgent;
237 
238   /** How many tokens we have upgraded by now. */
239   uint256 public totalUpgraded;
240 
241   /**
242    * Upgrade states.
243    *
244    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
245    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
246    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
247    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
248    *
249    */
250   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
251 
252   /**
253    * Somebody has upgraded some of his tokens.
254    */
255   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
256 
257   /**
258    * New upgrade agent available.
259    */
260   event UpgradeAgentSet(address agent);
261 
262   /**
263    * Do not allow construction without upgrade master set.
264    */
265   function UpgradeableToken(address _upgradeMaster) {
266     upgradeMaster = _upgradeMaster;
267   }
268 
269   /**
270    * Allow the token holder to upgrade some of their tokens to a new contract.
271    */
272   function upgrade(uint256 value) public {
273 
274       UpgradeState state = getUpgradeState();
275       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
276         // Called in a bad state
277         throw;
278       }
279 
280       // Validate input value.
281       if (value == 0) throw;
282 
283       balances[msg.sender] = safeSub(balances[msg.sender], value);
284 
285       // Take tokens out from circulation
286       totalSupply = safeSub(totalSupply, value);
287       totalUpgraded = safeAdd(totalUpgraded, value);
288 
289       // Upgrade agent reissues the tokens
290       upgradeAgent.upgradeFrom(msg.sender, value);
291       Upgrade(msg.sender, upgradeAgent, value);
292   }
293 
294   /**
295    * Set an upgrade agent that handles
296    */
297   function setUpgradeAgent(address agent) external {
298 
299       if(!canUpgrade()) {
300         // The token is not yet in a state that we could think upgrading
301         throw;
302       }
303 
304       if (agent == 0x0) throw;
305       // Only a master can designate the next agent
306       if (msg.sender != upgradeMaster) throw;
307       // Upgrade has already begun for an agent
308       if (getUpgradeState() == UpgradeState.Upgrading) throw;
309 
310       upgradeAgent = UpgradeAgent(agent);
311 
312       // Bad interface
313       if(!upgradeAgent.isUpgradeAgent()) throw;
314       // Make sure that token supplies match in source and target
315       if (upgradeAgent.originalSupply() != totalSupply) throw;
316 
317       UpgradeAgentSet(upgradeAgent);
318   }
319 
320   /**
321    * Get the state of the token upgrade.
322    */
323   function getUpgradeState() public constant returns(UpgradeState) {
324     if(!canUpgrade()) return UpgradeState.NotAllowed;
325     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
326     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
327     else return UpgradeState.Upgrading;
328   }
329 
330   /**
331    * Change the upgrade master.
332    *
333    * This allows us to set a new owner for the upgrade mechanism.
334    */
335   function setUpgradeMaster(address master) public {
336       if (master == 0x0) throw;
337       if (msg.sender != upgradeMaster) throw;
338       upgradeMaster = master;
339   }
340 
341   /**
342    * Child contract can enable to provide the condition when the upgrade can begun.
343    */
344   function canUpgrade() public constant returns(bool) {
345      return true;
346   }
347 
348 }
349 
350 
351 contract TradeToken is BurnableToken, UpgradeableToken {
352 
353   string public name;
354   string public symbol;
355   uint public decimals;
356   address public owner;
357 
358   mapping(address => uint) previligedBalances;
359 
360   function TradeToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals)  UpgradeableToken(_owner) {
361     name = _name;
362     symbol = _symbol;
363     totalSupply = _totalSupply;
364     decimals = _decimals;
365 
366     // Allocate initial balance to the owner
367     balances[_owner] = _totalSupply;
368 
369     // save the owner
370     owner = _owner;
371   }
372 
373   // privileged transfer
374   function transferPrivileged(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
375     if (msg.sender != owner) throw;
376     balances[msg.sender] = safeSub(balances[msg.sender], _value);
377     balances[_to] = safeAdd(balances[_to], _value);
378     previligedBalances[_to] = safeAdd(previligedBalances[_to], _value);
379     Transfer(msg.sender, _to, _value);
380     return true;
381   }
382 
383   // get priveleged balance
384   function getPrivilegedBalance(address _owner) constant returns (uint balance) {
385     return previligedBalances[_owner];
386   }
387 
388   // admin only can transfer from the privileged accounts
389   function transferFromPrivileged(address _from, address _to, uint _value) returns (bool success) {
390     if (msg.sender != owner) throw;
391 
392     uint availablePrevilegedBalance = previligedBalances[_from];
393 
394     balances[_from] = safeSub(balances[_from], _value);
395     balances[_to] = safeAdd(balances[_to], _value);
396     previligedBalances[_from] = safeSub(availablePrevilegedBalance, _value);
397     Transfer(_from, _to, _value);
398     return true;
399   }
400 }