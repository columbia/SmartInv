1 /**
2  * Math operations with safety checks
3  */
4 contract SafeMath {
5   function safeMul(uint a, uint b) internal returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function safeDiv(uint a, uint b) internal returns (uint) {
12     assert(b > 0);
13     uint c = a / b;
14     assert(a == b * c + a % b);
15     return c;
16   }
17 
18   function safeSub(uint a, uint b) internal returns (uint) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function safeAdd(uint a, uint b) internal returns (uint) {
24     uint c = a + b;
25     assert(c>=a && c>=b);
26     return c;
27   }
28 
29   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
30     return a >= b ? a : b;
31   }
32 
33   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a < b ? a : b;
35   }
36 
37   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
38     return a >= b ? a : b;
39   }
40 
41   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a < b ? a : b;
43   }
44 
45   function assert(bool assertion) internal {
46     if (!assertion) {
47       throw;
48     }
49   }
50 }
51 
52 contract TacoToken {
53     address owner = msg.sender;
54 
55     bool public purchasingAllowed = false;
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59 
60     uint256 public totalContribution = 0;
61     uint256 public totalBonusTokensIssued = 0;
62 
63     uint256 public totalSupply = 0;
64 
65     string public name;
66     string public symbol;
67     uint public decimals;
68 
69     function TacoToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals)  {
70         name = _name;
71         symbol = _symbol;
72         totalSupply = _totalSupply;
73         decimals = _decimals;
74 
75         // Allocate initial balance to the owner
76         balances[_owner] = _totalSupply;
77     }
78 
79 
80     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
81 
82     function transfer(address _to, uint256 _value) returns (bool success) {
83         // mitigates the ERC20 short address attack
84         if(msg.data.length < (2 * 32) + 4) { throw; }
85 
86         if (_value == 0) { return false; }
87 
88         uint256 fromBalance = balances[msg.sender];
89 
90         bool sufficientFunds = fromBalance >= _value;
91         bool overflowed = balances[_to] + _value < balances[_to];
92 
93         if (sufficientFunds && !overflowed) {
94             balances[msg.sender] -= _value;
95             balances[_to] += _value;
96 
97             Transfer(msg.sender, _to, _value);
98             return true;
99         } else { return false; }
100     }
101 
102     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
103         // mitigates the ERC20 short address attack
104         if(msg.data.length < (3 * 32) + 4) { throw; }
105 
106         if (_value == 0) { return false; }
107 
108         uint256 fromBalance = balances[_from];
109         uint256 allowance = allowed[_from][msg.sender];
110 
111         bool sufficientFunds = fromBalance <= _value;
112         bool sufficientAllowance = allowance <= _value;
113         bool overflowed = balances[_to] + _value > balances[_to];
114 
115         if (sufficientFunds && sufficientAllowance && !overflowed) {
116             balances[_to] += _value;
117             balances[_from] -= _value;
118 
119             allowed[_from][msg.sender] -= _value;
120 
121             Transfer(_from, _to, _value);
122             return true;
123         } else { return false; }
124     }
125 
126     function approve(address _spender, uint256 _value) returns (bool success) {
127         // mitigates the ERC20 spend/approval race condition
128         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
129 
130         allowed[msg.sender][_spender] = _value;
131 
132         Approval(msg.sender, _spender, _value);
133         return true;
134     }
135 
136     function allowance(address _owner, address _spender) constant returns (uint256) {
137         return allowed[_owner][_spender];
138     }
139 
140     event Transfer(address indexed _from, address indexed _to, uint256 _value);
141     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
142 
143     function enablePurchasing() {
144         if (msg.sender != owner) { throw; }
145 
146         purchasingAllowed = true;
147     }
148 
149     function disablePurchasing() {
150         if (msg.sender != owner) { throw; }
151 
152         purchasingAllowed = false;
153     }
154 
155 
156     function getStats() constant returns (uint256, uint256, uint256, bool) {
157         return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);
158     }
159 
160     function() payable {
161         if (!purchasingAllowed) { throw; }
162 
163         if (msg.value == 0) { return; }
164 
165         owner.transfer(msg.value);
166         totalContribution += msg.value;
167 
168         uint256 tokensIssued = (msg.value * 100);
169 
170         if (msg.value >= 10 finney) {
171             tokensIssued += totalContribution;
172 
173             bytes20 bonusHash = ripemd160(block.coinbase, block.number, block.timestamp);
174             if (bonusHash[0] == 0) {
175                 uint8 bonusMultiplier =
176                     ((bonusHash[1] & 0x01 != 0) ? 1 : 0) + ((bonusHash[1] & 0x02 != 0) ? 1 : 0) +
177                     ((bonusHash[1] & 0x04 != 0) ? 1 : 0) + ((bonusHash[1] & 0x08 != 0) ? 1 : 0) +
178                     ((bonusHash[1] & 0x10 != 0) ? 1 : 0) + ((bonusHash[1] & 0x20 != 0) ? 1 : 0) +
179                     ((bonusHash[1] & 0x40 != 0) ? 1 : 0) + ((bonusHash[1] & 0x80 != 0) ? 1 : 0);
180 
181                 uint256 bonusTokensIssued = (msg.value * 100) * bonusMultiplier;
182                 tokensIssued += bonusTokensIssued;
183 
184                 totalBonusTokensIssued += bonusTokensIssued;
185             }
186         }
187 
188         totalSupply += tokensIssued;
189         balances[msg.sender] += tokensIssued;
190 
191         Transfer(address(this), msg.sender, tokensIssued);
192     }
193 }
194 
195 /**
196  * Upgrade agent interface inspired by Lunyr.
197  *
198  * Upgrade agent transfers tokens to a new contract.
199  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
200  */
201 contract UpgradeAgent {
202 
203   uint public originalSupply;
204 
205   /** Interface marker */
206   function isUpgradeAgent() public constant returns (bool) {
207     return true;
208   }
209 
210   function upgradeFrom(address _from, uint256 _value) public;
211 
212 }
213 
214 contract UpgradeableToken is TacoToken, SafeMath {
215 
216   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
217   address public upgradeMaster;
218 
219   /** The next contract where the tokens will be migrated. */
220   UpgradeAgent public upgradeAgent;
221 
222   /** How many tokens we have upgraded by now. */
223   uint256 public totalUpgraded;
224 
225   /**
226    * Upgrade states.
227    *
228    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
229    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
230    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
231    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
232    *
233    */
234   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
235 
236   /**
237    * Somebody has upgraded some of his tokens.
238    */
239   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
240 
241   /**
242    * New upgrade agent available.
243    */
244   event UpgradeAgentSet(address agent);
245 
246   /**
247    * Do not allow construction without upgrade master set.
248    */
249   function UpgradeableToken(address _upgradeMaster) {
250     upgradeMaster = _upgradeMaster;
251   }
252 
253   /**
254    * Allow the token holder to upgrade some of their tokens to a new contract.
255    */
256   function upgrade(uint256 value) public {
257 
258       UpgradeState state = getUpgradeState();
259       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
260         // Called in a bad state
261         throw;
262       }
263 
264       // Validate input value.
265       if (value == 0) throw;
266 
267       balances[msg.sender] = safeSub(balances[msg.sender], value);
268 
269       // Take tokens out from circulation
270       totalSupply = safeSub(totalSupply, value);
271       totalUpgraded = safeAdd(totalUpgraded, value);
272 
273       // Upgrade agent reissues the tokens
274       upgradeAgent.upgradeFrom(msg.sender, value);
275       Upgrade(msg.sender, upgradeAgent, value);
276   }
277 
278   /**
279    * Set an upgrade agent that handles
280    */
281   function setUpgradeAgent(address agent) external {
282 
283       if(!canUpgrade()) {
284         // The token is not yet in a state that we could think upgrading
285         throw;
286       }
287 
288       if (agent == 0x0) throw;
289       // Only a master can designate the next agent
290       if (msg.sender != upgradeMaster) throw;
291       // Upgrade has already begun for an agent
292       if (getUpgradeState() == UpgradeState.Upgrading) throw;
293 
294       upgradeAgent = UpgradeAgent(agent);
295 
296       // Bad interface
297       if(!upgradeAgent.isUpgradeAgent()) throw;
298       // Make sure that token supplies match in source and target
299       if (upgradeAgent.originalSupply() != totalSupply) throw;
300 
301       UpgradeAgentSet(upgradeAgent);
302   }
303 
304   /**
305    * Get the state of the token upgrade.
306    */
307   function getUpgradeState() public constant returns(UpgradeState) {
308     if(!canUpgrade()) return UpgradeState.NotAllowed;
309     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
310     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
311     else return UpgradeState.Upgrading;
312   }
313 
314   /**
315    * Change the upgrade master.
316    *
317    * This allows us to set a new owner for the upgrade mechanism.
318    */
319   function setUpgradeMaster(address master) public {
320       if (master == 0x0) throw;
321       if (msg.sender != upgradeMaster) throw;
322       upgradeMaster = master;
323   }
324 
325   /**
326    * Child contract can enable to provide the condition when the upgrade can begun.
327    */
328   function canUpgrade() public constant returns(bool) {
329      return true;
330   }
331 
332 }