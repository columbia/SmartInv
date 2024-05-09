1 pragma solidity ^0.4.11;
2 
3 /*
4  * ERC20 interface
5  * see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8   uint public totalSupply;
9   function balanceOf(address who) constant returns (uint);
10   function allowance(address owner, address spender) constant returns (uint);
11 
12   function transfer(address to, uint value) returns (bool ok);
13   function transferFrom(address from, address to, uint value) returns (bool ok);
14   function approve(address spender, uint value) returns (bool ok);
15   event Transfer(address indexed from, address indexed to, uint value);
16   event Approval(address indexed owner, address indexed spender, uint value);
17 }
18 
19 
20 /**
21  * Math operations with safety checks
22  */
23 contract SafeMath {
24   function safeSub(uint a, uint b) internal returns (uint) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function safeAdd(uint a, uint b) internal returns (uint) {
30     uint c = a + b;
31     assert(c>=a && c>=b);
32     return c;
33   }
34 
35   function assert(bool assertion) internal {
36     if (!assertion) {
37       throw;
38     }
39   }
40 }
41 
42 /**
43  * Standard ERC20 token
44  *
45  * https://github.com/ethereum/EIPs/issues/20
46  * Based on code by FirstBlood:
47  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
48  */
49 contract StandardToken is ERC20, SafeMath {
50 
51   mapping(address => uint) balances;
52   mapping (address => mapping (address => uint)) allowed;
53 
54   function transfer(address _to, uint _value) returns (bool success) {
55     balances[msg.sender] = safeSub(balances[msg.sender], _value);
56     balances[_to] = safeAdd(balances[_to], _value);
57     Transfer(msg.sender, _to, _value);
58     return true;
59   }
60 
61   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
62     var _allowance = allowed[_from][msg.sender];
63 
64     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
65     // if (_value > _allowance) throw;
66 
67     balances[_to] = safeAdd(balances[_to], _value);
68     balances[_from] = safeSub(balances[_from], _value);
69     allowed[_from][msg.sender] = safeSub(_allowance, _value);
70     Transfer(_from, _to, _value);
71     return true;
72   }
73 
74   function balanceOf(address _owner) constant returns (uint balance) {
75     return balances[_owner];
76   }
77 
78   function approve(address _spender, uint _value) returns (bool success) {
79     allowed[msg.sender][_spender] = _value;
80     Approval(msg.sender, _spender, _value);
81     return true;
82   }
83 
84   function allowance(address _owner, address _spender) constant returns (uint remaining) {
85     return allowed[_owner][_spender];
86   }
87 
88 }
89 /**
90  * Upgrade agent interface inspired by Lunyr.
91  *
92  * Upgrade agent transfers tokens to a new contract.
93  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
94  */
95 contract UpgradeAgent {
96 
97   uint public originalSupply;
98 
99   /** Interface marker */
100   function isUpgradeAgent() public constant returns (bool) {
101     return true;
102   }
103 
104   function upgradeFrom(address _from, uint256 _value) public;
105 
106 }
107 
108 /**
109  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
110  *
111  * First envisioned by Golem and Lunyr projects.
112  */
113 contract UpgradeableToken is StandardToken {
114 
115   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
116   address public upgradeMaster;
117 
118   /** The next contract where the tokens will be migrated. */
119   UpgradeAgent public upgradeAgent;
120 
121   /** How many tokens we have upgraded by now. */
122   uint256 public totalUpgraded;
123 
124   /**
125    * Upgrade states.
126    *
127    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
128    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
129    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
130    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
131    *
132    */
133   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
134 
135   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
136   event UpgradeAgentSet(address agent);
137 
138   /**
139    * Do not allow construction without upgrade master set.
140    */
141   function UpgradeableToken(address _upgradeMaster) {
142     upgradeMaster = _upgradeMaster;
143   }
144 
145   /**
146    * Allow the token holder to upgrade some of their tokens to a new contract.
147    */
148   function upgrade(uint256 value) public {
149 
150       UpgradeState state = getUpgradeState();
151       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
152         // Called in a bad state
153         throw;
154       }
155 
156       // Validate input value.
157       if (value == 0) throw;
158 
159       balances[msg.sender] = safeSub(balances[msg.sender], value);
160 
161       // Take tokens out from circulation
162       totalSupply = safeSub(totalSupply, value);
163       totalUpgraded = safeAdd(totalUpgraded, value);
164 
165       // Upgrade agent reissues the tokens
166       upgradeAgent.upgradeFrom(msg.sender, value);
167       Upgrade(msg.sender, upgradeAgent, value);
168   }
169 
170   /**
171    * Set an upgrade agent that handles
172    */
173   function setUpgradeAgent(address agent) external {
174 
175       if(!canUpgrade()) {
176         // The token is not yet in a state that we could think upgrading
177         throw;
178       }
179 
180       if (agent == 0x0) throw;
181       // Only a master can designate the next agent
182       if (msg.sender != upgradeMaster) throw;
183       // Upgrade has already begun for an agent
184       if (getUpgradeState() == UpgradeState.Upgrading) throw;
185 
186       upgradeAgent = UpgradeAgent(agent);
187 
188       // Bad interface
189       if(!upgradeAgent.isUpgradeAgent()) throw;
190 
191       // Make sure that token supplies match in source and target
192       if (upgradeAgent.originalSupply() != totalSupply) throw;
193 
194       UpgradeAgentSet(upgradeAgent);
195   }
196 
197   /**
198    * Get the state of the token upgrade.
199    */
200   function getUpgradeState() public constant returns(UpgradeState) {
201     if(!canUpgrade()) return UpgradeState.NotAllowed;
202     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
203     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
204     else return UpgradeState.Upgrading;
205   }
206 
207   /**
208    * Change the upgrade master.
209    *
210    * This allows us to set a new owner for the upgrade mechanism.
211    */
212   function setUpgradeMaster(address master) external {
213       if (master == 0x0) throw;
214       if (msg.sender != upgradeMaster) throw;
215       upgradeMaster = master;
216   }
217 
218   /**
219    * Child contract can enable to provide the condition when the upgrade can begun.
220    */
221   function canUpgrade() public constant returns(bool) {
222      return true;
223   }
224 
225 }
226 
227 /**
228  * A crowdsaled token.
229  *
230  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
231  *
232  * - The token contract gives an opt-in upgrade path to a new contract
233  *
234  */
235 contract CrowdsaleToken is UpgradeableToken, UpgradeAgent {
236   string public name;
237 
238   string public symbol;
239 
240   uint public decimals;
241 
242   address public source;
243 
244   event TokensUpgradedFrom(address indexed from, uint256 value);
245 
246   /**
247    * Construct the token.
248    *
249    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
250    */
251   function CrowdsaleToken(
252       string _name,
253       string _symbol,
254       uint _decimals,
255       address _source
256   ) UpgradeableToken (msg.sender) {
257     originalSupply = ERC20(_source).totalSupply();
258     if (originalSupply == 0) throw;
259 
260     source = _source;
261 
262     name = _name;
263     symbol = _symbol;
264     decimals = _decimals;
265   }
266 
267   function upgradeFrom(address _from, uint256 _value) public {
268     if (msg.sender != source) throw;
269     totalSupply = safeAdd(totalSupply, _value);
270     balances[_from] = safeAdd(balances[_from], _value);
271     TokensUpgradedFrom(_from, _value);
272   }
273 }