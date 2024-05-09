1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) returns (bool);
22   function approve(address spender, uint256 value) returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title Ownable
28  * @dev The Ownable contract has an owner address, and provides basic authorization control
29  * functions, this simplifies the implementation of "user permissions".
30  */
31 contract Ownable {
32   address public owner;
33 
34 
35   /**
36    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37    * account.
38    */
39   function Ownable() {
40     owner = msg.sender;
41   }
42 
43 
44   /**
45    * @dev Throws if called by any account other than the owner.
46    */
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address newOwner) onlyOwner {
58     if (newOwner != address(0)) {
59       owner = newOwner;
60     }
61   }
62 
63 }
64 
65 
66 /**
67  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
68  *
69  * Based on code by FirstBlood:
70  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
71  */
72 contract StandardToken is ERC20 {
73   using SafeMath for uint;
74   /* Token supply got increased and a new owner received these tokens */
75   event Minted(address receiver, uint amount);
76 
77   /* Actual balances of token holders */
78   mapping(address => uint) balances;
79 
80   /* approve() allowances */
81   mapping (address => mapping (address => uint)) allowed;
82 
83   /* Interface declaration */
84   function isToken() public constant returns (bool weAre) {
85     return true;
86   }
87 
88   function transfer(address _to, uint _value) returns (bool success) {
89     balances[msg.sender] = balances[msg.sender].sub( _value);
90     balances[_to] = balances[_to].add(_value);
91     Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
96     uint _allowance = allowed[_from][msg.sender];
97 
98     balances[_to] = balances[_to].add(_value);
99     balances[_from] = balances[_from].sub(_value);
100     allowed[_from][msg.sender] = _allowance.sub(_value);
101     Transfer(_from, _to, _value);
102     return true;
103   }
104 
105   function balanceOf(address _owner) constant returns (uint balance) {
106     return balances[_owner];
107   }
108 
109   function approve(address _spender, uint _value) returns (bool success) {
110 
111     // To change the approve amount you first have to reduce the addresses`
112     //  allowance to zero by calling `approve(_spender, 0)` if it is not
113     //  already 0 to mitigate the race condition described here:
114     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
115     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) 
116       revert();
117 
118     allowed[msg.sender][_spender] = _value;
119     Approval(msg.sender, _spender, _value);
120     return true;
121   }
122 
123   function allowance(address _owner, address _spender) constant returns (uint remaining) {
124     return allowed[_owner][_spender];
125   }
126 
127 }
128 
129 
130 /**
131  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
132  *
133  * First envisioned by Golem and Lunyr projects.
134  */
135 contract UpgradeableToken is StandardToken {
136   using SafeMath for uint256;
137   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
138   address public upgradeMaster;
139 
140   /** The next contract where the tokens will be migrated. */
141   UpgradeAgent public upgradeAgent;
142 
143   /** How many tokens we have upgraded by now. */
144   uint256 public totalUpgraded;
145 
146   /**
147    * Upgrade states.
148    *
149    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
150    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
151    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
152    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
153    *
154    */
155   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
156 
157   /**
158    * Somebody has upgraded some of his tokens.
159    */
160   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
161 
162   /**
163    * New upgrade agent available.
164    */
165   event UpgradeAgentSet(address agent);
166 
167   /**
168    * Do not allow construction without upgrade master set.
169    */
170   function UpgradeableToken(address _upgradeMaster) {
171     upgradeMaster = _upgradeMaster;
172   }
173 
174   /**
175    * Allow the token holder to upgrade some of their tokens to a new contract.
176    */
177   function upgrade(uint256 value) public {
178 
179       UpgradeState state = getUpgradeState();
180       if (!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
181         // Called in a bad state
182         revert();
183       }
184 
185       // Validate input value.
186       if (value == 0) revert();
187 
188       balances[msg.sender] = balances[msg.sender].sub(value);
189 
190       // Take tokens out from circulation
191       totalSupply = totalSupply.sub(value);
192       totalUpgraded = totalUpgraded.add(value);
193 
194       // Upgrade agent reissues the tokens
195       upgradeAgent.upgradeFrom(msg.sender, value);
196       Upgrade(msg.sender, upgradeAgent, value);
197   }
198 
199   /**
200    * Set an upgrade agent that handles
201    */
202   function setUpgradeAgent(address agent) external {
203 
204       if(!canUpgrade()) {
205         // The token is not yet in a state that we could think upgrading
206         revert();
207       }
208 
209       if (agent == 0x0) revert();
210       // Only a master can designate the next agent
211       if (msg.sender != upgradeMaster) revert();
212       // Upgrade has already begun for an agent
213       if (getUpgradeState() == UpgradeState.Upgrading) revert();
214 
215       upgradeAgent = UpgradeAgent(agent);
216 
217       // Bad interface
218       if(!upgradeAgent.isUpgradeAgent()) revert();
219       // Make sure that token supplies match in source and target
220       if (upgradeAgent.originalSupply() != totalSupply) revert();
221 
222       UpgradeAgentSet(upgradeAgent);
223   }
224 
225   /**
226    * Get the state of the token upgrade.
227    */
228   function getUpgradeState() public constant returns(UpgradeState) {
229     if(!canUpgrade()) return UpgradeState.NotAllowed;
230     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
231     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
232     else return UpgradeState.Upgrading;
233   }
234 
235   /**
236    * Change the upgrade master.
237    *
238    * This allows us to set a new owner for the upgrade mechanism.
239    */
240   function setUpgradeMaster(address master) public {
241       if (master == 0x0) revert();
242       if (msg.sender != upgradeMaster) revert();
243       upgradeMaster = master;
244   }
245 
246   /**
247    * Child contract can enable to provide the condition when the upgrade can begun.
248    */
249   function canUpgrade() public constant returns(bool) {
250      return true;
251   }
252 
253 }
254 
255 
256 /**
257  * Upgrade agent interface inspired by Lunyr.
258  *
259  * Upgrade agent transfers tokens to a new contract.
260  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
261  */
262 contract UpgradeAgent {
263 
264   uint public originalSupply;
265 
266   /** Interface marker */
267   function isUpgradeAgent() public constant returns (bool) {
268     return true;
269   }
270 
271   function upgradeFrom(address _from, uint256 _value) public;
272 
273 }
274 
275 /**
276  * Define interface for releasing the token transfer after a successful crowdsale.
277  */
278 contract ReleasableToken is ERC20, Ownable {
279 
280   /* The finalizer contract that allows unlift the transfer limits on this token */
281   address public releaseAgent;
282 
283   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
284   bool public released = false;
285 
286   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
287   mapping (address => bool) public transferAgents;
288 
289   /**
290    * Limit token transfer until the crowdsale is over.
291    *
292    */
293   modifier canTransfer(address _sender) {
294 
295     if(!released) {
296         if(!transferAgents[_sender]) {
297             revert();
298         }
299     }
300 
301     _;
302   }
303 
304   /**
305    * Set the contract that can call release and make the token transferable.
306    *
307    * Design choice. Allow reset the release agent to fix fat finger mistakes.
308    */
309   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
310 
311     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
312     releaseAgent = addr;
313   }
314 
315   /**
316    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
317    */
318   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
319     transferAgents[addr] = state;
320   }
321 
322   /**
323    * One way function to release the tokens to the wild.
324    *
325    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
326    */
327   function releaseTokenTransfer() public onlyReleaseAgent {
328     released = true;
329   }
330 
331   /** The function can be called only before or after the tokens have been releasesd */
332   modifier inReleaseState(bool releaseState) {
333     if(releaseState != released) {
334         revert();
335     }
336     _;
337   }
338 
339   /** The function can be called only by a whitelisted release agent. */
340   modifier onlyReleaseAgent() {
341     if(msg.sender != releaseAgent) {
342         revert();
343     }
344     _;
345   }
346 
347   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
348     // Call StandardToken.transfer()
349    return super.transfer(_to, _value);
350   }
351 
352   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
353     // Call StandardToken.transferForm()
354     return super.transferFrom(_from, _to, _value);
355   }
356 
357 }
358 
359 /**
360  * @title Pausable
361  * @dev Base contract which allows children to implement an emergency stop mechanism.
362  */
363 contract Pausable is Ownable {
364   event Pause();
365   event Unpause();
366 
367   bool public paused = false;
368 
369 
370   /**
371    * @dev modifier to allow actions only when the contract IS paused
372    */
373   modifier whenNotPaused() {
374     require(!paused);
375     _;
376   }
377 
378   /**
379    * @dev modifier to allow actions only when the contract IS NOT paused
380    */
381   modifier whenPaused {
382     require(paused);
383     _;
384   }
385 
386   /**
387    * @dev called by the owner to pause, triggers stopped state
388    */
389   function pause() onlyOwner whenNotPaused returns (bool) {
390     paused = true;
391     Pause();
392     return true;
393   }
394 
395   /**
396    * @dev called by the owner to unpause, returns to normal state
397    */
398   function unpause() onlyOwner whenPaused returns (bool) {
399     paused = false;
400     Unpause();
401     return true;
402   }
403 }
404 
405 
406 /**
407  * Pausable token
408  *
409  * Simple ERC20 Token example, with pausable token creation
410  **/
411 
412 contract PausableToken is StandardToken, Pausable {
413 
414   function transfer(address _to, uint _value) whenNotPaused returns (bool) {
415     return super.transfer(_to, _value);
416   }
417 
418   function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) {
419     return super.transferFrom(_from, _to, _value);
420   }
421 }
422 
423 /**
424  * @title SafeMath
425  * @dev Math operations with safety checks that throw on error
426  */
427 library SafeMath {
428   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
429     uint256 c = a * b;
430     assert(a == 0 || c / a == b);
431     return c;
432   }
433 
434   function div(uint256 a, uint256 b) internal constant returns (uint256) {
435     // assert(b > 0); // Solidity automatically throws when dividing by 0
436     uint256 c = a / b;
437     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
438     return c;
439   }
440 
441   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
442     assert(b <= a);
443     return a - b;
444   }
445 
446   function add(uint256 a, uint256 b) internal constant returns (uint256) {
447     uint256 c = a + b;
448     assert(c >= a);
449     return c;
450   }
451 }
452 
453 
454 
455 
456 
457 /**
458  * Centrally issued Ethereum token.
459  *
460  * We mix in burnable and upgradeable traits.
461  *
462  * Token supply is created in the token contract creation and allocated to owner.
463  * The owner can then transfer from its supply to crowdsale participants.
464  * The owner, or anybody, can burn any excessive tokens they are holding.
465  *
466  */
467 contract CentrallyIssuedToken is UpgradeableToken, ReleasableToken, PausableToken {
468 
469   string public name;
470   string public symbol;
471   uint public decimals;
472 
473   function CentrallyIssuedToken(address _owner, string _name, string _symbol, uint _totalSupply, uint _decimals)  UpgradeableToken(_owner) {
474     name = _name;
475     symbol = _symbol;
476     totalSupply = _totalSupply;
477     decimals = _decimals;
478 
479     // Allocate initial balance to the owner
480     balances[_owner] = _totalSupply;
481   }
482 }