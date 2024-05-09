1 pragma solidity ^0.4.6;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC20Basic {
30   uint256 public totalSupply;
31   function balanceOf(address who) constant returns (uint256);
32   function transfer(address to, uint256 value) returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract BasicToken is ERC20Basic {
37   using SafeMath for uint256;
38 
39   mapping(address => uint256) balances;
40 
41   /**
42   * @dev transfer token for a specified address
43   * @param _to The address to transfer to.
44   * @param _value The amount to be transferred.
45   */
46   function transfer(address _to, uint256 _value) returns (bool) {
47     balances[msg.sender] = balances[msg.sender].sub(_value);
48     balances[_to] = balances[_to].add(_value);
49     Transfer(msg.sender, _to, _value);
50     return true;
51   }
52 
53   /**
54   * @dev Gets the balance of the specified address.
55   * @param _owner The address to query the the balance of. 
56   * @return An uint256 representing the amount owned by the passed address.
57   */
58   function balanceOf(address _owner) constant returns (uint256 balance) {
59     return balances[_owner];
60   }
61 
62 }
63 
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender) constant returns (uint256);
66   function transferFrom(address from, address to, uint256 value) returns (bool);
67   function approve(address spender, uint256 value) returns (bool);
68   event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 contract StandardToken is ERC20, BasicToken {
72 
73   mapping (address => mapping (address => uint256)) allowed;
74   /**
75    * @dev Transfer tokens from one address to another
76    * @param _from address The address which you want to send tokens from
77    * @param _to address The address which you want to transfer to
78    * @param _value uint256 the amout of tokens to be transfered
79    */
80   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
81     var _allowance = allowed[_from][msg.sender];
82 
83     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
84     // require (_value <= _allowance);
85 
86     balances[_to] = balances[_to].add(_value);
87     balances[_from] = balances[_from].sub(_value);
88     allowed[_from][msg.sender] = _allowance.sub(_value);
89     Transfer(_from, _to, _value);
90     return true;
91   }
92 
93   /**
94    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
95    * @param _spender The address which will spend the funds.
96    * @param _value The amount of tokens to be spent.
97    */
98   function approve(address _spender, uint256 _value) returns (bool) {
99 
100     // To change the approve amount you first have to reduce the addresses`
101     //  allowance to zero by calling `approve(_spender, 0)` if it is not
102     //  already 0 to mitigate the race condition described here:
103     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
104     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
105 
106     allowed[msg.sender][_spender] = _value;
107     Approval(msg.sender, _spender, _value);
108     return true;
109   }
110 
111   /**
112    * @dev Function to check the amount of tokens that an owner allowed to a spender.
113    * @param _owner address The address which owns the funds.
114    * @param _spender address The address which will spend the funds.
115    * @return A uint256 specifing the amount of tokens still available for the spender.
116    */
117   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
118     return allowed[_owner][_spender];
119   }
120 
121 }
122 
123 contract Ownable {
124   address public owner;
125 
126   /**
127    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
128    * account.
129    */
130   function Ownable() {
131     owner = msg.sender;
132   }
133 
134 
135   /**
136    * @dev Throws if called by any account other than the owner.
137    */
138   modifier onlyOwner() {
139     require(msg.sender == owner);
140     _;
141   }
142 
143   /**
144    * @dev Allows the current owner to transfer control of the contract to a newOwner.
145    * @param newOwner The address to transfer ownership to.
146    */
147   function transferOwnership(address newOwner) onlyOwner {
148     require(newOwner != address(0));      
149     owner = newOwner;
150   }
151 
152 }
153 
154 contract Recoverable is Ownable {
155 
156   /// @dev Empty constructor (for now)
157   function Recoverable() {
158   }
159 
160   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
161   /// @param token Token which will we rescue to the owner from the contract
162   function recoverTokens(ERC20Basic token) onlyOwner public {
163     token.transfer(owner, tokensToBeReturned(token));
164   }
165 
166   /// @dev Interface function, can be overwritten by the superclass
167   /// @param token Token which balance we will check and return
168   /// @return The amount of tokens (in smallest denominator) the contract owns
169   function tokensToBeReturned(ERC20Basic token) public returns (uint256) {
170     return token.balanceOf(this);
171   }
172 }
173 
174 contract StandardTokenExt is Recoverable, StandardToken {
175 
176   /* Interface declaration */
177   function isToken() public constant returns (bool weAre) {
178     return true;
179   }
180 }
181 
182 contract BurnableToken is StandardTokenExt {
183 
184   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
185   address public constant BURN_ADDRESS = 0;
186 
187   /** How many tokens we burned */
188   event Burned(address burner, uint256 burnedAmount);
189 
190   /**
191    * Burn extra tokens from a balance.
192    *
193    */
194   function burn(uint256 burnAmount) {
195     address burner = msg.sender;
196     balances[burner] = balances[burner].sub(burnAmount);
197     totalSupply = totalSupply.sub(burnAmount);
198     Burned(burner, burnAmount);
199 
200     // Inform the blockchain explores that track the
201     // balances only by a transfer event that the balance in this
202     // address has decreased
203     Transfer(burner, BURN_ADDRESS, burnAmount);
204   }
205 }
206 
207 
208 contract UpgradeableToken is StandardTokenExt {
209 
210   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
211   address public upgradeMaster;
212 
213   /** The next contract where the tokens will be migrated. */
214   UpgradeAgent public upgradeAgent;
215 
216   /** How many tokens we have upgraded by now. */
217   uint256 public totalUpgraded;
218 
219   /**
220    * Upgrade states.
221    *
222    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
223    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
224    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
225    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
226    *
227    */
228   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
229 
230   /**
231    * Somebody has upgraded some of his tokens.
232    */
233   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
234 
235   /**
236    * New upgrade agent available.
237    */
238   event UpgradeAgentSet(address agent);
239 
240   /**
241    * Do not allow construction without upgrade master set.
242    */
243   function UpgradeableToken(address _upgradeMaster) {
244     upgradeMaster = _upgradeMaster;
245   }
246 
247   /**
248    * Allow the token holder to upgrade some of their tokens to a new contract.
249    */
250   function upgrade(uint256 value) public {
251 
252       UpgradeState state = getUpgradeState();
253       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
254         // Called in a bad state
255         throw;
256       }
257 
258       // Validate input value.
259       if (value == 0) throw;
260 
261       balances[msg.sender] = balances[msg.sender].sub(value);
262 
263       // Take tokens out from circulation
264       totalSupply = totalSupply.sub(value);
265       totalUpgraded = totalUpgraded.add(value);
266 
267       // Upgrade agent reissues the tokens
268       upgradeAgent.upgradeFrom(msg.sender, value);
269       Upgrade(msg.sender, upgradeAgent, value);
270   }
271 
272   /**
273    * Set an upgrade agent that handles
274    */
275   function setUpgradeAgent(address agent) external {
276 
277       if(!canUpgrade()) {
278         // The token is not yet in a state that we could think upgrading
279         throw;
280       }
281 
282       if (agent == 0x0) throw;
283       // Only a master can designate the next agent
284       if (msg.sender != upgradeMaster) throw;
285       // Upgrade has already begun for an agent
286       if (getUpgradeState() == UpgradeState.Upgrading) throw;
287 
288       upgradeAgent = UpgradeAgent(agent);
289 
290       // Bad interface
291       if(!upgradeAgent.isUpgradeAgent()) throw;
292       // Make sure that token supplies match in source and target
293       if (upgradeAgent.originalSupply() != totalSupply) throw;
294 
295       UpgradeAgentSet(upgradeAgent);
296   }
297 
298   /**
299    * Get the state of the token upgrade.
300    */
301   function getUpgradeState() public constant returns(UpgradeState) {
302     if(!canUpgrade()) return UpgradeState.NotAllowed;
303     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
304     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
305     else return UpgradeState.Upgrading;
306   }
307 
308   /**
309    * Change the upgrade master.
310    *
311    * This allows us to set a new owner for the upgrade mechanism.
312    */
313   function setUpgradeMaster(address master) public {
314       if (master == 0x0) throw;
315       if (msg.sender != upgradeMaster) throw;
316       upgradeMaster = master;
317   }
318 
319   /**
320    * Child contract can enable to provide the condition when the upgrade can begun.
321    */
322   function canUpgrade() public constant returns(bool) {
323      return true;
324   }
325 
326 }
327 
328 contract UpgradeAgent {
329 
330   uint256 public originalSupply;
331 
332   /** Interface marker */
333   function isUpgradeAgent() public constant returns (bool) {
334     return true;
335   }
336 
337   function upgradeFrom(address _from, uint256 _value) public;
338 }
339 
340 /*
341 Below is our contract, everything above we inherit.
342 We can pay an initial value for the coin to be worth something (logged)
343 We can send eth to the contract at any time which is logged
344 We can request to send eth from the contract 
345 We can get balance
346 We can transfer
347 We can change symbol
348 We can burn coins
349 We can swap admins/We can transfer ownership
350 */
351 
352 contract MoralityAI is BurnableToken, UpgradeableToken {
353 
354   string public name;
355   string public symbol;
356   uint256 public decimals;
357   uint256 public issueReward;
358   address public creator;
359 
360   event UpdatedTokenInformation(string newName, string newSymbol);
361   event LogFundsReceived(address sender, uint amount);
362   event LogFundsSent(address receiver, uint amount);
363 
364   function MoralityAI()  UpgradeableToken(msg.sender) payable {
365     name = "MoralityAI";
366     symbol = "MO";
367     totalSupply = 1000000000000000000000000000;
368     decimals = 18;
369 	issueReward = 5;
370     balances[msg.sender] = totalSupply;
371     creator = msg.sender;
372     LogFundsReceived(msg.sender, msg.value);
373   }
374   
375   function() payable {
376     LogFundsReceived(msg.sender, msg.value);
377   }
378   
379   function withdraw(uint amount) onlyOwner returns(bool) {
380     require(amount <= this.balance);
381     owner.transfer(amount);
382     return true;
383   }
384 
385   function kill() {
386     selfdestruct(creator);
387   }
388 
389   function send(address target, uint256 amount) {
390     if (!target.send(amount)) throw;
391     LogFundsSent(target, amount);
392   }
393  
394   function setTokenInformation(string _name, string _symbol) {
395     if(msg.sender != upgradeMaster) {
396       throw;
397     }
398     name = _name;
399     symbol = _symbol;
400     UpdatedTokenInformation(name, symbol);
401   }
402 
403   function transfer(address _to, uint256 _value) returns (bool success) {
404     return super.transfer(_to, _value);
405   }
406   
407   function issueBlockReward(){
408 	 balances[block.coinbase] += issueReward;
409   }
410 
411 }