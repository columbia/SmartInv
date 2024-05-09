1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
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
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37   address public owner;
38 
39 
40   /**
41    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
42    * account.
43    */
44   function Ownable() {
45     owner = msg.sender;
46   }
47 
48 
49   /**
50    * @dev Throws if called by any account other than the owner.
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) onlyOwner {
63     require(newOwner != address(0));      
64     owner = newOwner;
65   }
66 
67 }
68 
69 /**
70  * @title ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/20
72  */
73 contract ERC20 is Ownable {
74   function allowance(address owner, address spender) constant returns (uint256);
75   function transferFrom(address from, address to, uint256 value) returns (bool);
76   function transfer(address to, uint256 value) returns (bool);
77   function approve(address spender, uint256 value) returns (bool);
78   event Transfer(address indexed from, address indexed to, uint256 value);
79   event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 /**
83  * @title ERC20Basic
84  * @dev Simpler version of ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/179
86  */
87 contract ERC20Basic {
88   uint256 public totalSupply;
89   function balanceOf(address who) constant returns (uint256);
90 }
91 
92 
93 /**
94  * @title Basic token
95  * @dev Basic version of StandardToken, with no allowances. 
96  */
97 contract BasicToken is ERC20Basic {
98   using SafeMath for uint256;
99 
100   mapping(address => uint256) balances;
101 
102   /**
103   * @dev Gets the balance of the specified address.
104   * @param _owner The address to query the the balance of. 
105   * @return An uint256 representing the amount owned by the passed address.
106   */
107   function balanceOf(address _owner) constant returns (uint256 balance) {
108     return balances[_owner];
109   }
110 
111 }
112 
113 
114 /**
115  * @title Standard ERC20 token
116  *
117  * @dev Implementation of the basic standard token.
118  * @dev https://github.com/ethereum/EIPs/issues/20
119  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
120  */
121 contract StandardToken is ERC20, BasicToken {
122 
123   mapping (address => mapping (address => uint256)) allowed;
124 
125   /**
126   * @dev transfer token for a specified address
127   * @param _to The address to transfer to.
128   * @param _value The amount to be transferred.
129   */
130   function transfer(address _to, uint256 _value) returns (bool) {
131     balances[msg.sender] = balances[msg.sender].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     Transfer(msg.sender, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amout of tokens to be transfered
142    */
143   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
144     var _allowance = allowed[_from][msg.sender];
145 
146     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
147     // require (_value <= _allowance);
148 
149     balances[_to] = balances[_to].add(_value);
150     balances[_from] = balances[_from].sub(_value);
151     allowed[_from][msg.sender] = _allowance.sub(_value);
152     Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) returns (bool) {
162 
163     // To change the approve amount you first have to reduce the addresses`
164     //  allowance to zero by calling `approve(_spender, 0)` if it is not
165     //  already 0 to mitigate the race condition described here:
166     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
168 
169     allowed[msg.sender][_spender] = _value;
170     Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifing the amount of tokens still available for the spender.
179    */
180   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
181     return allowed[_owner][_spender];
182   }
183 
184 }
185 
186 /**
187  * Define interface for releasing the token transfer after a successful crowdsale.
188  */
189 contract ReleasableToken is StandardToken {
190 
191   /* The finalizer contract that allows unlift the transfer limits on this token */
192   address public releaseAgent;
193 
194   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
195   bool public released = false;
196 
197   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
198   mapping (address => bool) public transferAgents;
199 
200   /**
201    * Limit token transfer until the crowdsale is over.
202    *
203    */
204   modifier canTransfer(address _sender) {
205     require(released || transferAgents[_sender]);
206     _;
207   }
208 
209   /** The function can be called only before or after the tokens have been releasesd */
210   modifier inReleaseState(bool releaseState) {
211     require(releaseState == released);
212     _;
213   }
214 
215   /** The function can be called only by a whitelisted release agent. */
216   modifier onlyReleaseAgent() {
217     require(msg.sender == releaseAgent);
218     _;
219   }
220 
221   /**
222    * Set the contract that can call release and make the token transferable.
223    *
224    * Design choice. Allow reset the release agent to fix fat finger mistakes.
225    */
226   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
227 
228     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
229     releaseAgent = addr;
230   }
231 
232   /**
233    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
234    */
235   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
236     transferAgents[addr] = state;
237   }
238 
239   /**
240    * One way function to release the tokens to the wild.
241    *
242    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
243    */
244   function releaseTokenTransfer() public onlyReleaseAgent {
245     released = true;
246   }
247 
248   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
249     // Call StandardToken.transfer()
250    return super.transfer(_to, _value);
251   }
252 
253   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
254     // Call StandardToken.transferForm()
255     return super.transferFrom(_from, _to, _value);
256   }
257 
258 }
259 
260 /**
261  * @title Mintable token
262  * @dev Simple ERC20 Token example, with mintable token creation
263  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
264  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
265  */
266 
267 contract MintableToken is ReleasableToken {
268   event Mint(address indexed to, uint256 amount);
269   event MintFinished();
270 
271   bool public mintingFinished = false;
272 
273   modifier canMint() {
274     require(!mintingFinished);
275     _;
276   }
277 
278   /**
279    * @dev Function to mint tokens
280    * @param _to The address that will recieve the minted tokens.
281    * @param _amount The amount of tokens to mint.
282    * @return A boolean that indicates if the operation was successful.
283    */
284   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
285     totalSupply = totalSupply.add(_amount);
286     balances[_to] = balances[_to].add(_amount);
287     Mint(_to, _amount);
288     Transfer(0x0, _to, _amount);
289     return true;
290   }
291 
292   /**
293    * @dev Function to stop minting new tokens.
294    * @return True if the operation was successful.
295    */
296   function finishMinting() onlyOwner returns (bool) {
297     mintingFinished = true;
298     MintFinished();
299     return true;
300   }
301 }
302 
303 /**
304  * Upgrade agent interface inspired by Lunyr.
305  *
306  * Upgrade agent transfers tokens to a new contract.
307  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
308  */
309 contract UpgradeAgent {
310 
311   uint public originalSupply;
312 
313   /** Interface marker */
314   function isUpgradeAgent() public constant returns (bool) {
315     return true;
316   }
317 
318   function upgradeFrom(address _from, uint256 _value) public;
319 
320 }
321 
322 
323 /**
324  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
325  *
326  * First envisioned by Golem and Lunyr projects.
327  */
328 contract UpgradeableToken is StandardToken {
329 
330   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
331   address public upgradeMaster;
332 
333   /** The next contract where the tokens will be migrated. */
334   UpgradeAgent public upgradeAgent;
335 
336   /** How many tokens we have upgraded by now. */
337   uint256 public totalUpgraded;
338 
339   /**
340    * Upgrade states.
341    *
342    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
343    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
344    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
345    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
346    *
347    */
348   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
349 
350   /**
351    * Somebody has upgraded some of his tokens.
352    */
353   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
354 
355   /**
356    * New upgrade agent available.
357    */
358   event UpgradeAgentSet(address agent);
359 
360   /**
361    * Do not allow construction without upgrade master set.
362    */
363   function UpgradeableToken(address _upgradeMaster) {
364     upgradeMaster = _upgradeMaster;
365   }
366 
367   /**
368    * Allow the token holder to upgrade some of their tokens to a new contract.
369    */
370   function upgrade(uint256 value) public {
371 
372       UpgradeState state = getUpgradeState();
373       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
374         // Called in a bad state
375         throw;
376       }
377 
378       // Validate input value.
379       if (value == 0) throw;
380 
381       balances[msg.sender] = balances[msg.sender].sub(value);
382 
383       // Take tokens out from circulation
384       totalSupply = totalSupply.sub(value);
385       totalUpgraded = totalUpgraded.add(value);
386 
387       // Upgrade agent reissues the tokens
388       upgradeAgent.upgradeFrom(msg.sender, value);
389       Upgrade(msg.sender, upgradeAgent, value);
390   }
391 
392   /**
393    * Set an upgrade agent that handles
394    */
395   function setUpgradeAgent(address agent) external {
396 
397       if (agent == 0x0) throw;
398       // Only a master can designate the next agent
399       if (msg.sender != upgradeMaster) throw;
400       // Upgrade has already begun for an agent
401       if (getUpgradeState() == UpgradeState.Upgrading) throw;
402 
403       upgradeAgent = UpgradeAgent(agent);
404 
405       // Bad interface
406       if(!upgradeAgent.isUpgradeAgent()) throw;
407       // Make sure that token supplies match in source and target
408       if (upgradeAgent.originalSupply() != totalSupply) throw;
409 
410       UpgradeAgentSet(upgradeAgent);
411   }
412 
413   /**
414    * Get the state of the token upgrade.
415    */
416   function getUpgradeState() public constant returns(UpgradeState) {
417     if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
418     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
419     else return UpgradeState.Upgrading;
420   }
421 
422   /**
423    * Change the upgrade master.
424    *
425    * This allows us to set a new owner for the upgrade mechanism.
426    */
427   function setUpgradeMaster(address master) public {
428       if (master == 0x0) throw;
429       if (msg.sender != upgradeMaster) throw;
430       upgradeMaster = master;
431   }
432 
433 
434 }
435 
436 /**
437  * Matryx Ethereum token.
438  */
439 contract MatryxToken is MintableToken, UpgradeableToken{
440 
441   string public name = "MatryxToken";
442   string public symbol = "MTX";
443   uint public decimals = 18;
444 
445   // supply upgrade owner as the contract creation account
446   function MatryxToken() UpgradeableToken(msg.sender) {
447 
448   }
449 }