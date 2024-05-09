1 contract ERC20 {
2   uint public totalSupply;
3   function balanceOf(address who) constant returns (uint);
4   function allowance(address owner, address spender) constant returns (uint);
5 
6   function transfer(address to, uint value) returns (bool ok);
7   function transferFrom(address from, address to, uint value) returns (bool ok);
8   function approve(address spender, uint value) returns (bool ok);
9   event Transfer(address indexed from, address indexed to, uint value);
10   event Approval(address indexed owner, address indexed spender, uint value);
11 }
12 
13 contract SafeMath {
14   function safeMul(uint a, uint b) internal returns (uint) {
15     uint c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20   function safeDiv(uint a, uint b) internal returns (uint) {
21     assert(b > 0);
22     uint c = a / b;
23     assert(a == b * c + a % b);
24     return c;
25   }
26 
27   function safeSub(uint a, uint b) internal returns (uint) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function safeAdd(uint a, uint b) internal returns (uint) {
33     uint c = a + b;
34     assert(c>=a && c>=b);
35     return c;
36   }
37 
38   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
39     return a >= b ? a : b;
40   }
41 
42   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
43     return a < b ? a : b;
44   }
45 
46   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
47     return a >= b ? a : b;
48   }
49 
50   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
51     return a < b ? a : b;
52   }
53 
54   function assert(bool assertion) internal {
55     if (!assertion) {
56       throw;
57     }
58   }
59 }
60 
61 contract UpgradeAgent {
62 
63   uint public originalSupply;
64 
65   /** Interface marker */
66   function isUpgradeAgent() public constant returns (bool) {
67     return true;
68   }
69 
70   /**
71    * Upgrade amount of tokens to a new version.
72    *
73    * Only callable by UpgradeableToken.
74    *
75    * @param _tokenHolder Address that wants to upgrade its tokens
76    * @param _amount Number of tokens to upgrade. The address may consider to hold back some amount of tokens in the old version.
77    */
78   function upgradeFrom(address _tokenHolder, uint256 _amount) external;
79 }
80 
81 
82 contract StandardToken is ERC20, SafeMath {
83 
84   /* Actual balances of token holders */
85   mapping(address => uint) balances;
86 
87   /* approve() allowances */
88   mapping (address => mapping (address => uint)) allowed;
89 
90   /* Interface declaration */
91   function isToken() public constant returns (bool weAre) {
92     return true;
93   }
94 
95   function transfer(address _to, uint _value) returns (bool success) {
96     balances[msg.sender] = safeSub(balances[msg.sender], _value);
97     balances[_to] = safeAdd(balances[_to], _value);
98     Transfer(msg.sender, _to, _value);
99     return true;
100   }
101 
102   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
103     uint _allowance = allowed[_from][msg.sender];
104 
105     balances[_to] = safeAdd(balances[_to], _value);
106     balances[_from] = safeSub(balances[_from], _value);
107     allowed[_from][msg.sender] = safeSub(_allowance, _value);
108     Transfer(_from, _to, _value);
109     return true;
110   }
111 
112   function balanceOf(address _owner) constant returns (uint balance) {
113     return balances[_owner];
114   }
115 
116   function approve(address _spender, uint _value) returns (bool success) {
117 
118     // To change the approve amount you first have to reduce the addresses`
119     //  allowance to zero by calling `approve(_spender, 0)` if it is not
120     //  already 0 to mitigate the race condition described here:
121     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
122     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
123 
124     allowed[msg.sender][_spender] = _value;
125     Approval(msg.sender, _spender, _value);
126     return true;
127   }
128 
129   function allowance(address _owner, address _spender) constant returns (uint remaining) {
130     return allowed[_owner][_spender];
131   }
132 
133 }
134 
135 
136 
137 
138 contract UpgradeableToken is StandardToken {
139 
140   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
141   address public upgradeMaster;
142 
143   /** The next contract where the tokens will be migrated. */
144   UpgradeAgent public upgradeAgent;
145 
146   /** How many tokens we have upgraded by now. */
147   uint256 public totalUpgraded;
148 
149   /**
150    * Upgrade states.
151    *
152    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
153    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
154    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
155    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
156    *
157    */
158   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
159 
160   /**
161    * Somebody has upgraded some of his tokens.
162    */
163   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
164 
165   /**
166    * New upgrade agent available.
167    */
168   event UpgradeAgentSet(address agent);
169 
170   /**
171    * Upgrade master updated.
172    */
173   event NewUpgradeMaster(address upgradeMaster);
174 
175   /**
176    * Do not allow construction without upgrade master set.
177    */
178   function UpgradeableToken(address _upgradeMaster) {
179     upgradeMaster = _upgradeMaster;
180     NewUpgradeMaster(upgradeMaster);
181   }
182 
183   /**
184    * Allow the token holder to upgrade some of their tokens to a new contract.
185    */
186   function upgrade(uint256 value) public {
187 
188       UpgradeState state = getUpgradeState();
189       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
190         // Called in a bad state
191         throw;
192       }
193 
194       // Validate input value.
195       if (value == 0) throw;
196 
197       balances[msg.sender] = safeSub(balances[msg.sender], value);
198 
199       // Take tokens out from circulation
200       totalSupply = safeSub(totalSupply, value);
201       totalUpgraded = safeAdd(totalUpgraded, value);
202 
203       // Upgrade agent reissues the tokens
204       upgradeAgent.upgradeFrom(msg.sender, value);
205       Upgrade(msg.sender, upgradeAgent, value);
206   }
207 
208   /**
209    * Set an upgrade agent that handles
210    */
211   function setUpgradeAgent(address agent) external {
212 
213       if(!canUpgrade()) {
214         // The token is not yet in a state that we could think upgrading
215         throw;
216       }
217 
218       if (agent == 0x0) throw;
219       // Only a master can designate the next agent
220       if (msg.sender != upgradeMaster) throw;
221       // Upgrade has already begun for an agent
222       if (getUpgradeState() == UpgradeState.Upgrading) throw;
223 
224       upgradeAgent = UpgradeAgent(agent);
225 
226       // Bad interface
227       if(!upgradeAgent.isUpgradeAgent()) throw;
228       // Make sure that token supplies match in source and target
229       if (upgradeAgent.originalSupply() != totalSupply) throw;
230 
231       UpgradeAgentSet(upgradeAgent);
232   }
233 
234   /**
235    * Get the state of the token upgrade.
236    */
237   function getUpgradeState() public constant returns(UpgradeState) {
238     if(!canUpgrade()) return UpgradeState.NotAllowed;
239     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
240     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
241     else return UpgradeState.Upgrading;
242   }
243 
244   /**
245    * Change the upgrade master.
246    *
247    * This allows us to set a new owner for the upgrade mechanism.
248    */
249   function setUpgradeMaster(address master) public {
250       if (master == 0x0) throw;
251       if (msg.sender != upgradeMaster) throw;
252       upgradeMaster = master;
253       NewUpgradeMaster(upgradeMaster);
254   }
255 
256   /**
257    * Child contract can enable to provide the condition when the upgrade can begun.
258    */
259   function canUpgrade() public constant returns(bool) {
260      return true;
261   }
262 
263 }
264 
265 contract CentrallyIssuedToken is UpgradeableToken {
266 
267   string public name;
268   string public symbol;
269   uint public decimals;
270 
271   /** Name and symbol were updated. */
272   event UpdatedTokenInformation(string newName, string newSymbol);
273 
274   function CentrallyIssuedToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals)  UpgradeableToken(_owner) {
275     name = _name;
276     symbol = _symbol;
277     totalSupply = _totalSupply;
278     decimals = _decimals;
279 
280     // Allocate initial balance to the owner
281     balances[_owner] = _totalSupply;
282   }
283 
284   /**
285    * Owner can update token information here.
286    *
287    * It is often useful to conceal the actual token association, until
288    * the token operations, like central issuance or reissuance have been completed.
289    * In this case the initial token can be supplied with empty name and symbol information.
290    *
291    * This function allows the token owner to rename the token after the operations
292    * have been completed and then point the audience to use the token contract.
293    */
294   function setTokenInformation(string _name, string _symbol) {
295 
296     if(msg.sender != upgradeMaster) {
297       throw;
298     }
299 
300     if(bytes(name).length > 0 || bytes(symbol).length > 0) {
301       // Information already set
302       // Allow owner to set this information only once
303       throw;
304     }
305 
306     name = _name;
307     symbol = _symbol;
308     UpdatedTokenInformation(name, symbol);
309   }
310 
311 }