1 pragma solidity ^0.4.11;
2 
3 
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract ERC20Basic {
32   uint256 public totalSupply;
33   function balanceOf(address who) constant returns (uint256);
34   function transfer(address to, uint256 value) returns (bool);
35   event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 contract ERC20 is ERC20Basic {
39   function allowance(address owner, address spender) constant returns (uint256);
40   function transferFrom(address from, address to, uint256 value) returns (bool);
41   function approve(address spender, uint256 value) returns (bool);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 contract BasicToken is ERC20Basic {
46       using SafeMath for uint256;
47 
48   mapping(address => uint256) balances;
49 
50 
51   function transfer(address _to, uint256 _value) returns (bool) {
52     balances[msg.sender] = balances[msg.sender].sub(_value);
53     balances[_to] = balances[_to].add(_value);
54     Transfer(msg.sender, _to, _value);
55     return true;
56   }
57 
58 
59   function balanceOf(address _owner) constant returns (uint256 balance) {
60     return balances[_owner];
61   }
62 
63 }
64 
65 contract StandardToken is ERC20, BasicToken {
66 
67   mapping (address => mapping (address => uint256)) allowed;
68 
69   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
70     var _allowance = allowed[_from][msg.sender];
71     balances[_to] = balances[_to].add(_value);
72     balances[_from] = balances[_from].sub(_value);
73     allowed[_from][msg.sender] = _allowance.sub(_value);
74     Transfer(_from, _to, _value);
75     return true;
76   }
77 
78 
79   function approve(address _spender, uint256 _value) returns (bool) {
80 
81     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
82 
83     allowed[msg.sender][_spender] = _value;
84     Approval(msg.sender, _spender, _value);
85     return true;
86   }
87 
88 
89   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
90     return allowed[_owner][_spender];
91   }
92 
93 }
94 
95 
96 
97 /**
98  * Upgrade agent interface inspired by Lunyr.
99  * Upgrade agent transfers tokens to a new contract.
100  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
101  */
102 contract UpgradeAgent {
103 
104   uint public originalSupply;
105 
106   /** Interface marker */
107   function isUpgradeAgent() public constant returns (bool) {
108     return true;
109   }
110 
111   function upgradeFrom(address _from, uint256 _value) public;
112 
113 }
114 
115 /**
116  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
117  *
118  */
119 contract UpgradeableToken is StandardToken {
120   using SafeMath for uint256;
121   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
122   address public upgradeMaster;
123 
124 
125   /** The next contract where the tokens will be migrated. */
126   UpgradeAgent public upgradeAgent;
127 
128   /** How many tokens we have upgraded by now. */
129   uint256 public totalUpgraded;
130 
131   /**
132    * Upgrade states.
133    *
134    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
135    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
136    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
137    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
138    *
139    */
140   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
141 
142   /**
143    * Somebody has upgraded some of his tokens.
144    */
145   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
146 
147   /**
148    * New upgrade agent available.
149    */
150   event UpgradeAgentSet(address agent);
151 
152   /**
153    * Do not allow construction without upgrade master set.
154    */
155   function UpgradeableToken(address _upgradeMaster) {
156     upgradeMaster = _upgradeMaster;
157   }
158 
159   /**
160    * Allow the token holder to upgrade some of their tokens to a new contract.
161    */
162   function upgrade(uint256 value) public {
163 
164       UpgradeState state = getUpgradeState();
165       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
166         // Called in a bad state
167         throw;
168       }
169 
170       // Validate input value.
171       if (value == 0) throw;
172 
173       balances[msg.sender] = balances[msg.sender].sub(value);
174 
175       // Take tokens out from circulation
176       totalSupply = totalSupply.sub(value);
177       totalUpgraded = totalUpgraded.add(value);
178 
179       // Upgrade agent reissues the tokens
180       upgradeAgent.upgradeFrom(msg.sender, value);
181       Upgrade(msg.sender, upgradeAgent, value);
182   }
183 
184   /**
185    * Set an upgrade agent that handles
186    */
187   function setUpgradeAgent(address agent) external {
188 
189       if(!canUpgrade()) {
190         // The token is not yet in a state that we could think upgrading
191         throw;
192       }
193 
194       if (agent == 0x0) throw;
195       // Only a master can designate the next agent
196       if (msg.sender != upgradeMaster) throw;
197       // Upgrade has already begun for an agent
198       if (getUpgradeState() == UpgradeState.Upgrading) throw;
199 
200       upgradeAgent = UpgradeAgent(agent);
201 
202       // Bad interface
203       if(!upgradeAgent.isUpgradeAgent()) throw;
204       // Make sure that token supplies match in source and target
205       if (upgradeAgent.originalSupply() != totalSupply) throw;
206 
207       UpgradeAgentSet(upgradeAgent);
208   }
209 
210   /**
211    * Get the state of the token upgrade.
212    */
213   function getUpgradeState() public constant returns(UpgradeState) {
214     if(!canUpgrade()) return UpgradeState.NotAllowed;
215     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
216     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
217     else return UpgradeState.Upgrading;
218   }
219 
220   /**
221    * Change the upgrade master.
222    *
223    * This allows us to set a new owner for the upgrade mechanism.
224    */
225   function setUpgradeMaster(address master) public {
226       if (master == 0x0) throw;
227       if (msg.sender != upgradeMaster) throw;
228       upgradeMaster = master;
229   }
230 
231   /**
232    * Child contract can enable to provide the condition when the upgrade can begun.
233    */
234   function canUpgrade() public constant returns(bool) {
235      return true;
236   }
237 
238 }
239 
240 
241 contract Readcoin is StandardToken, UpgradeableToken {
242     using SafeMath for uint256;
243   string public constant standard = "ERC20";
244   string public constant name = "Readcoin";
245   string public constant symbol = "RCN";
246   uint256 public constant decimals = 8;
247 
248   uint256 public constant INITIAL_SUPPLY = 80000000000000000;
249 
250   /**
251    * @dev Contructor that gives msg.sender all of existing tokens. 
252    */
253   function Readcoin() UpgradeableToken(0x3f55ac7032b08bBa74f1dcd9D069648d210dD2d5) {
254     totalSupply = INITIAL_SUPPLY;
255     balances[0xFAe3E22220AE3DFcf7484AD35A7AF90C0B714239] = totalSupply;
256   }
257 
258 }