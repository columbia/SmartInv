1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 contract Ownable {
38   address public owner;
39 
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42   function Ownable() public {
43     owner = msg.sender;
44   }
45 
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51   function transferOwnership(address newOwner) public onlyOwner {
52     require(newOwner != address(0));
53     OwnershipTransferred(owner, newOwner);
54     owner = newOwner;
55   }
56 
57 }
58 
59 
60 contract Pausable is Ownable {
61   event Pause();
62   event Unpause();
63 
64   bool public paused = false;
65 
66   //Allow transfers from owner even in paused state - block all others
67   modifier whenNotPaused() {
68     require(!paused || msg.sender == owner);
69     _;
70   }
71 
72   modifier whenPaused() {
73     require(paused);
74     _;
75   }
76 
77   // called by the owner on emergency, triggers paused state
78   function pause() onlyOwner public{
79     require(paused == false);
80     paused = true;
81     Pause();
82   }
83 
84   // called by the owner on end of emergency, returns to normal state
85   function unpause() onlyOwner whenPaused public{
86     paused = false;
87     Unpause();
88   }
89 
90 }
91 
92 
93 // allow contract to be destructible
94 contract Mortal is Ownable {
95     function kill() onlyOwner public {
96         selfdestruct(owner);
97     }
98 }
99 
100 
101 /**
102  * Upgrade agent interface inspired by Lunyr.
103  *
104  * Upgrade agent transfers tokens to a new contract.
105  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
106  */
107 contract UpgradeAgent {
108 
109   uint public originalSupply;
110 
111   /** Interface marker */
112   function isUpgradeAgent() public constant returns (bool) {
113     return true;
114   }
115 
116   function upgradeFrom(address _from, uint256 _value) public;
117 
118 }
119 
120 
121 contract BaseToken is Ownable, Pausable, Mortal{
122 
123   using SafeMath for uint256;
124 
125   // ERC20 State
126   mapping (address => uint256) public balances;
127   mapping (address => mapping (address => uint256)) public allowances;
128   mapping (address => bool) public frozenAccount;
129   uint256 public totalSupply;
130 
131   // Human State
132   string public name;
133   uint8 public decimals;
134   string public symbol;
135   string public version;
136 
137   // ERC20 Events
138   event Transfer(address indexed _from, address indexed _to, uint256 _value);
139   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
140 
141   //Frozen event
142   event FrozenFunds(address target, bool frozen);
143 
144   // ERC20 Methods
145   function totalSupply() public constant returns (uint _totalSupply) {
146       return totalSupply;
147   }
148 
149   function balanceOf(address _address) public view returns (uint256 balance) {
150     return balances[_address];
151   }
152 
153   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
154     return allowances[_owner][_spender];
155   }
156 
157   //Freeze/unfreeze specific address
158   function freezeAccount(address target, bool freeze) onlyOwner public{
159     frozenAccount[target] = freeze;
160     FrozenFunds(target, freeze);
161     }
162 
163   //Check if given address is frozen
164   function isFrozen(address _address) public view returns (bool frozen) {
165       return frozenAccount[_address];
166   }
167 
168   //ERC20 transfer
169   function transfer(address _to, uint256 _value) whenNotPaused public returns (bool success)  {
170     require(_to != address(0));
171     require(_value <= balances[msg.sender]);
172     //REMOVED - SH 20180430 - WOULD PREVENT SENDING TO MULTISIG WALLET
173     //require(isContract(_to) == false);
174     require(!frozenAccount[msg.sender]);
175     balances[msg.sender] = balances[msg.sender].sub(_value);
176     balances[_to] = balances[_to].add(_value);
177     Transfer(msg.sender, _to, _value);
178     return true;
179   }
180 
181   //REMOVED - SH 20180430 - WOULD PREVENT SENDING TO MULTISIG WALLET
182   //Check if to address is contract
183   //function isContract(address _addr) private constant returns (bool) {
184   //      uint codeSize;
185   //      assembly {
186   //          codeSize := extcodesize(_addr)
187   //      }
188   //      return codeSize > 0;
189   //  }
190 
191   function approve(address _spender, uint256 _value) public returns (bool success) {
192     allowances[msg.sender][_spender] = _value;
193     Approval(msg.sender, _spender, _value);
194     return true;
195   }
196 
197   function transferFrom(address _owner, address _to, uint256 _value) whenNotPaused public returns (bool success) {
198     require(_to != address(0));
199     require(_value <= balances[_owner]);
200     require(_value <= allowances[_owner][msg.sender]);
201     require(!frozenAccount[_owner]);
202 
203     balances[_owner] = balances[_owner].sub(_value);
204     balances[_to] = balances[_to].add(_value);
205     allowances[_owner][msg.sender] = allowances[_owner][msg.sender].sub(_value);
206     Transfer(_owner, _to, _value);
207     return true;
208   }
209 
210 }
211 
212 
213 /**
214  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
215  *
216  * First envisioned by Golem and Lunyr projects.
217  */
218 contract UpgradeableToken is BaseToken {
219 
220   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
221   address public upgradeMaster;
222 
223   /** The next contract where the tokens will be migrated. */
224   UpgradeAgent public upgradeAgent;
225 
226   /** How many tokens we have upgraded by now. */
227   uint256 public totalUpgraded;
228 
229   /**
230    * Upgrade states.
231    *
232    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
233    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
234    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
235    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
236    *
237    */
238   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
239 
240   /**
241    * Somebody has upgraded some of his tokens.
242    */
243   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
244 
245   /**
246    * New upgrade agent available.
247    */
248   event UpgradeAgentSet(address agent);
249 
250   /**
251    * Do not allow construction without upgrade master set.
252    */
253   function UpgradeAgentEnabledToken(address _upgradeMaster) {
254     upgradeMaster = _upgradeMaster;
255   }
256 
257   /**
258    * Allow the token holder to upgrade some of their tokens to a new contract.
259    */
260   function upgrade(uint256 value) public {
261 
262       UpgradeState state = getUpgradeState();
263       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
264         // Called in a bad state
265         revert();
266       }
267 
268       // Validate input value.
269       if (value == 0) revert();
270 
271       balances[msg.sender] = balances[msg.sender].sub(value);
272 
273       // Take tokens out from circulation
274       totalSupply = totalSupply.sub(value);
275       totalUpgraded = totalUpgraded.add(value);
276 
277       // Upgrade agent reissues the tokens
278       upgradeAgent.upgradeFrom(msg.sender, value);
279       Upgrade(msg.sender, upgradeAgent, value);
280   }
281 
282   /**
283    * Set an upgrade agent that handles
284    */
285   function setUpgradeAgent(address agent) external {
286 
287       if(!canUpgrade()) {
288         // The token is not yet in a state that we could think upgrading
289         revert();
290       }
291 
292       if (agent == 0x0) revert();
293       // Only a master can designate the next agent
294       if (msg.sender != upgradeMaster) revert();
295       // Upgrade has already begun for an agent
296       if (getUpgradeState() == UpgradeState.Upgrading) revert();
297 
298       upgradeAgent = UpgradeAgent(agent);
299 
300       // Bad interface
301       if(!upgradeAgent.isUpgradeAgent()) revert();
302       // Make sure that token supplies match in source and target
303       if (upgradeAgent.originalSupply() != totalSupply) revert();
304 
305       UpgradeAgentSet(upgradeAgent);
306   }
307 
308   /**
309    * Get the state of the token upgrade.
310    */
311   function getUpgradeState() public constant returns(UpgradeState) {
312     if(!canUpgrade()) return UpgradeState.NotAllowed;
313     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
314     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
315     else return UpgradeState.Upgrading;
316   }
317 
318   /**
319    * Change the upgrade master.
320    *
321    * This allows us to set a new owner for the upgrade mechanism.
322    */
323   function setUpgradeMaster(address master) public {
324       if (master == 0x0) revert();
325       if (msg.sender != upgradeMaster) revert();
326       upgradeMaster = master;
327   }
328 
329   /**
330    * Child contract can enable to provide the condition when the upgrade can begin.
331    */
332   function canUpgrade() public constant returns(bool) {
333      return true;
334   }
335 
336 }
337 
338 
339 /**
340  * A crowdsaled token.
341  *
342  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
343  *
344  * - The token contract gives an opt-in upgrade path to a new contract
345  *
346  */
347 contract YBKToken is UpgradeableToken {
348 
349   string public name;
350   string public symbol;
351   uint public decimals;
352   string public version;
353 
354   /**
355    * Construct the token.
356    */
357    // Constructor
358    function YBKToken(string _name, string _symbol, uint _initialSupply, uint _decimals, string _version) public {
359 
360      owner = msg.sender;
361 
362      // Initially set the upgrade master same as owner
363      upgradeMaster = owner;
364 
365      name = _name;
366      decimals = _decimals;
367      symbol = _symbol;
368      version = _version;
369 
370      totalSupply = _initialSupply;
371      balances[msg.sender] = totalSupply;
372 
373    }
374 
375 }