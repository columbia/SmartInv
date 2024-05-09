1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14 
15   /**
16   * @dev transfer token for a specified address
17   * @param _to The address to transfer to.
18   * @param _value The amount to be transferred.
19   */
20   function transfer(address _to, uint256 _value) returns (bool) {
21     balances[msg.sender] = balances[msg.sender].sub(_value);
22     balances[_to] = balances[_to].add(_value);
23     Transfer(msg.sender, _to, _value);
24     return true;
25   }
26 
27   /**
28   * @dev Gets the balance of the specified address.
29   * @param _owner The address to query the the balance of.
30   * @return An uint256 representing the amount owned by the passed address.
31   */
32   function balanceOf(address _owner) constant returns (uint256 balance) {
33     return balances[_owner];
34   }
35 
36 }
37 
38 contract ERC20 is ERC20Basic {
39   function allowance(address owner, address spender) constant returns (uint256);
40   function transferFrom(address from, address to, uint256 value) returns (bool);
41   function approve(address spender, uint256 value) returns (bool);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 library SafeMath {
46   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
47     uint256 c = a * b;
48     assert(a == 0 || c / a == b);
49     return c;
50   }
51 
52   function div(uint256 a, uint256 b) internal constant returns (uint256) {
53     // assert(b > 0); // Solidity automatically throws when dividing by 0
54     uint256 c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return c;
57   }
58 
59   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   function add(uint256 a, uint256 b) internal constant returns (uint256) {
65     uint256 c = a + b;
66     assert(c >= a);
67     return c;
68   }
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
125 contract StandardTokenExt is StandardToken {
126 
127   /* Interface declaration */
128   function isToken() public constant returns (bool weAre) {
129     return true;
130   }
131 }
132 
133 contract BurnableToken is StandardTokenExt {
134 
135   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
136   address public constant BURN_ADDRESS = 0;
137 
138   /** How many tokens we burned */
139   event Burned(address burner, uint burnedAmount);
140 
141   /**
142    * Burn extra tokens from a balance.
143    *
144    */
145   function burn(uint burnAmount) {
146     address burner = msg.sender;
147     balances[burner] = balances[burner].sub(burnAmount);
148     totalSupply = totalSupply.sub(burnAmount);
149     Burned(burner, burnAmount);
150 
151     // Inform the blockchain explores that track the
152     // balances only by a transfer event that the balance in this
153     // address has decreased
154     Transfer(burner, BURN_ADDRESS, burnAmount);
155   }
156 }
157 
158 contract UpgradeAgent {
159 
160   uint public originalSupply;
161 
162   /** Interface marker */
163   function isUpgradeAgent() public constant returns (bool) {
164     return true;
165   }
166 
167   function upgradeFrom(address _from, uint256 _value) public;
168 
169 }
170 
171 contract UpgradeableToken is StandardTokenExt {
172 
173   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
174   address public upgradeMaster;
175 
176   /** The next contract where the tokens will be migrated. */
177   UpgradeAgent public upgradeAgent;
178 
179   /** How many tokens we have upgraded by now. */
180   uint256 public totalUpgraded;
181 
182   /**
183    * Upgrade states.
184    *
185    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
186    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
187    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
188    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
189    *
190    */
191   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
192 
193   /**
194    * Somebody has upgraded some of his tokens.
195    */
196   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
197 
198   /**
199    * New upgrade agent available.
200    */
201   event UpgradeAgentSet(address agent);
202 
203   /**
204    * Do not allow construction without upgrade master set.
205    */
206   function UpgradeableToken(address _upgradeMaster) {
207     upgradeMaster = _upgradeMaster;
208   }
209 
210   /**
211    * Allow the token holder to upgrade some of their tokens to a new contract.
212    */
213   function upgrade(uint256 value) public {
214 
215       UpgradeState state = getUpgradeState();
216       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
217         // Called in a bad state
218         throw;
219       }
220 
221       // Validate input value.
222       if (value == 0) throw;
223 
224       balances[msg.sender] = balances[msg.sender].sub(value);
225 
226       // Take tokens out from circulation
227       totalSupply = totalSupply.sub(value);
228       totalUpgraded = totalUpgraded.add(value);
229 
230       // Upgrade agent reissues the tokens
231       upgradeAgent.upgradeFrom(msg.sender, value);
232       Upgrade(msg.sender, upgradeAgent, value);
233   }
234 
235   /**
236    * Set an upgrade agent that handles
237    */
238   function setUpgradeAgent(address agent) external {
239 
240       if(!canUpgrade()) {
241         // The token is not yet in a state that we could think upgrading
242         throw;
243       }
244 
245       if (agent == 0x0) throw;
246       // Only a master can designate the next agent
247       if (msg.sender != upgradeMaster) throw;
248       // Upgrade has already begun for an agent
249       if (getUpgradeState() == UpgradeState.Upgrading) throw;
250 
251       upgradeAgent = UpgradeAgent(agent);
252 
253       // Bad interface
254       if(!upgradeAgent.isUpgradeAgent()) throw;
255       // Make sure that token supplies match in source and target
256       if (upgradeAgent.originalSupply() != totalSupply) throw;
257 
258       UpgradeAgentSet(upgradeAgent);
259   }
260 
261   /**
262    * Get the state of the token upgrade.
263    */
264   function getUpgradeState() public constant returns(UpgradeState) {
265     if(!canUpgrade()) return UpgradeState.NotAllowed;
266     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
267     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
268     else return UpgradeState.Upgrading;
269   }
270 
271   /**
272    * Change the upgrade master.
273    *
274    * This allows us to set a new owner for the upgrade mechanism.
275    */
276   function setUpgradeMaster(address master) public {
277       if (master == 0x0) throw;
278       if (msg.sender != upgradeMaster) throw;
279       upgradeMaster = master;
280   }
281 
282   /**
283    * Child contract can enable to provide the condition when the upgrade can begun.
284    */
285   function canUpgrade() public constant returns(bool) {
286      return true;
287   }
288 
289 }
290 
291 contract CentrallyIssuedToken is BurnableToken, UpgradeableToken {
292 
293   // Token meta information
294   string public name;
295   string public symbol;
296   uint public decimals;
297 
298   // Token release switch
299   bool public released = false;
300 
301   // The date before the release must be finalized or upgrade path will be forced
302   uint public releaseFinalizationDate;
303 
304   /** Name and symbol were updated. */
305   event UpdatedTokenInformation(string newName, string newSymbol);
306 
307   function CentrallyIssuedToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals, uint _releaseFinalizationDate)  UpgradeableToken(_owner) {
308     name = _name;
309     symbol = _symbol;
310     totalSupply = _totalSupply;
311     decimals = _decimals;
312 
313     // Allocate initial balance to the owner
314     balances[_owner] = _totalSupply;
315 
316     releaseFinalizationDate = _releaseFinalizationDate;
317   }
318 
319   /**
320    * Owner can update token information here.
321    *
322    * It is often useful to conceal the actual token association, until
323    * the token operations, like central issuance or reissuance have been completed.
324    * In this case the initial token can be supplied with empty name and symbol information.
325    *
326    * This function allows the token owner to rename the token after the operations
327    * have been completed and then point the audience to use the token contract.
328    */
329   function setTokenInformation(string _name, string _symbol) {
330 
331     if(msg.sender != upgradeMaster) {
332       throw;
333     }
334 
335     name = _name;
336     symbol = _symbol;
337     UpdatedTokenInformation(name, symbol);
338   }
339 
340 
341   /**
342    * Kill switch for the token in the case of distribution issue.
343    *
344    */
345   function transfer(address _to, uint _value) returns (bool success) {
346 
347     if(now > releaseFinalizationDate) {
348       if(!released) {
349         throw;
350       }
351     }
352 
353     return super.transfer(_to, _value);
354   }
355 
356   /**
357    * One way function to perform the final token release.
358    */
359   function releaseTokenTransfer() {
360     if(msg.sender != upgradeMaster) {
361       throw;
362     }
363 
364     released = true;
365   }
366 }