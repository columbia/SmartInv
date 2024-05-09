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
20 
21 /**
22  * Math operations with safety checks
23  */
24 contract SafeMath {
25   function safeMul(uint a, uint b) internal returns (uint) {
26     uint c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function safeDiv(uint a, uint b) internal returns (uint) {
32     assert(b > 0);
33     uint c = a / b;
34     assert(a == b * c + a % b);
35     return c;
36   }
37 
38   function safeSub(uint a, uint b) internal returns (uint) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function safeAdd(uint a, uint b) internal returns (uint) {
44     uint c = a + b;
45     assert(c>=a && c>=b);
46     return c;
47   }
48 
49   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
50     return a >= b ? a : b;
51   }
52 
53   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
54     return a < b ? a : b;
55   }
56 
57   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
58     return a >= b ? a : b;
59   }
60 
61   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
62     return a < b ? a : b;
63   }
64 
65   function assert(bool assertion) internal {
66     if (!assertion) {
67       throw;
68     }
69   }
70 }
71 
72 
73 
74 /**
75  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
76  *
77  * Based on code by FirstBlood:
78  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
79  */
80 contract StandardToken is ERC20, SafeMath {
81 
82   /* Actual balances of token holders */
83   mapping(address => uint) balances;
84 
85   /* approve() allowances */
86   mapping (address => mapping (address => uint)) allowed;
87 
88   /* Interface declaration */
89   function isToken() public constant returns (bool weAre) {
90     return true;
91   }
92 
93   /**
94    *
95    * Fix for the ERC20 short address attack
96    *
97    * http://vessenes.com/the-erc20-short-address-attack-explained/
98    */
99   modifier onlyPayloadSize(uint size) {
100      if(msg.data.length < size + 4) {
101        throw;
102      }
103      _;
104   }
105 
106   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
107     balances[msg.sender] = safeSub(balances[msg.sender], _value);
108     balances[_to] = safeAdd(balances[_to], _value);
109     Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
114     uint _allowance = allowed[_from][msg.sender];
115 
116     balances[_to] = safeAdd(balances[_to], _value);
117     balances[_from] = safeSub(balances[_from], _value);
118     allowed[_from][msg.sender] = safeSub(_allowance, _value);
119     Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   function balanceOf(address _owner) constant returns (uint balance) {
124     return balances[_owner];
125   }
126 
127   function approve(address _spender, uint _value) returns (bool success) {
128 
129     // To change the approve amount you first have to reduce the addresses`
130     //  allowance to zero by calling `approve(_spender, 0)` if it is not
131     //  already 0 to mitigate the race condition described here:
132     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
134 
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   function allowance(address _owner, address _spender) constant returns (uint remaining) {
141     return allowed[_owner][_spender];
142   }
143 
144 }
145 
146 
147 
148 
149 
150 /**
151  * Upgrade agent interface inspired by Lunyr.
152  *
153  * Upgrade agent transfers tokens to a new contract.
154  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
155  */
156 contract UpgradeAgent {
157 
158   uint public originalSupply;
159 
160   /** Interface marker */
161   function isUpgradeAgent() public constant returns (bool) {
162     return true;
163   }
164 
165   function upgradeFrom(address _from, uint256 _value) public;
166 
167 }
168 
169 
170 /**
171  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
172  *
173  * First envisioned by Golem and Lunyr projects.
174  */
175 contract UpgradeableToken is StandardToken {
176 
177   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
178   address public upgradeMaster;
179 
180   /** The next contract where the tokens will be migrated. */
181   UpgradeAgent public upgradeAgent;
182 
183   /** How many tokens we have upgraded by now. */
184   uint256 public totalUpgraded;
185 
186   /**
187    * Upgrade states.
188    *
189    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
190    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
191    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
192    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
193    *
194    */
195   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
196 
197   /**
198    * Somebody has upgraded some of his tokens.
199    */
200   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
201 
202   /**
203    * New upgrade agent available.
204    */
205   event UpgradeAgentSet(address agent);
206 
207   /**
208    * Do not allow construction without upgrade master set.
209    */
210   function UpgradeableToken(address _upgradeMaster) {
211     upgradeMaster = _upgradeMaster;
212   }
213 
214   /**
215    * Allow the token holder to upgrade some of their tokens to a new contract.
216    */
217   function upgrade(uint256 value) public {
218 
219       UpgradeState state = getUpgradeState();
220       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
221         // Called in a bad state
222         throw;
223       }
224 
225       // Validate input value.
226       if (value == 0) throw;
227 
228       balances[msg.sender] = safeSub(balances[msg.sender], value);
229 
230       // Take tokens out from circulation
231       totalSupply = safeSub(totalSupply, value);
232       totalUpgraded = safeAdd(totalUpgraded, value);
233 
234       // Upgrade agent reissues the tokens
235       upgradeAgent.upgradeFrom(msg.sender, value);
236       Upgrade(msg.sender, upgradeAgent, value);
237   }
238 
239   /**
240    * Set an upgrade agent that handles
241    */
242   function setUpgradeAgent(address agent) external {
243 
244       if(!canUpgrade()) {
245         // The token is not yet in a state that we could think upgrading
246         throw;
247       }
248 
249       if (agent == 0x0) throw;
250       // Only a master can designate the next agent
251       if (msg.sender != upgradeMaster) throw;
252       // Upgrade has already begun for an agent
253       if (getUpgradeState() == UpgradeState.Upgrading) throw;
254 
255       upgradeAgent = UpgradeAgent(agent);
256 
257       // Bad interface
258       if(!upgradeAgent.isUpgradeAgent()) throw;
259       // Make sure that token supplies match in source and target
260       if (upgradeAgent.originalSupply() != totalSupply) throw;
261 
262       UpgradeAgentSet(upgradeAgent);
263   }
264 
265   /**
266    * Get the state of the token upgrade.
267    */
268   function getUpgradeState() public constant returns(UpgradeState) {
269     if(!canUpgrade()) return UpgradeState.NotAllowed;
270     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
271     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
272     else return UpgradeState.Upgrading;
273   }
274 
275   /**
276    * Change the upgrade master.
277    *
278    * This allows us to set a new owner for the upgrade mechanism.
279    */
280   function setUpgradeMaster(address master) public {
281       if (master == 0x0) throw;
282       if (msg.sender != upgradeMaster) throw;
283       upgradeMaster = master;
284   }
285 
286   /**
287    * Child contract can enable to provide the condition when the upgrade can begun.
288    */
289   function canUpgrade() public constant returns(bool) {
290      return true;
291   }
292 
293 }
294 
295 
296 
297 
298 /*
299  * Ownable
300  *
301  * Base contract with an owner.
302  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
303  */
304 contract Ownable {
305   address public owner;
306 
307   function Ownable() {
308     owner = msg.sender;
309   }
310 
311   modifier onlyOwner() {
312     if (msg.sender != owner) {
313       throw;
314     }
315     _;
316   }
317 
318   function transferOwnership(address newOwner) onlyOwner {
319     if (newOwner != address(0)) {
320       owner = newOwner;
321     }
322   }
323 
324 }
325 
326 
327 
328 
329 /**
330  * Define interface for releasing the token transfer after a successful crowdsale.
331  */
332 contract ReleasableToken is ERC20, Ownable {
333 
334   /* The finalizer contract that allows unlift the transfer limits on this token */
335   address public releaseAgent;
336 
337   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
338   bool public released = false;
339 
340   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
341   mapping (address => bool) public transferAgents;
342 
343   /**
344    * Limit token transfer until the crowdsale is over.
345    *
346    */
347   modifier canTransfer(address _sender) {
348 
349     if(!released) {
350         if(!transferAgents[_sender]) {
351             throw;
352         }
353     }
354 
355     _;
356   }
357 
358   /**
359    * Set the contract that can call release and make the token transferable.
360    *
361    * Design choice. Allow reset the release agent to fix fat finger mistakes.
362    */
363   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
364 
365     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
366     releaseAgent = addr;
367   }
368 
369   /**
370    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
371    */
372   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
373     transferAgents[addr] = state;
374   }
375 
376   /**
377    * One way function to release the tokens to the wild.
378    *
379    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
380    */
381   function releaseTokenTransfer() public onlyReleaseAgent {
382     released = true;
383   }
384 
385   /** The function can be called only before or after the tokens have been releasesd */
386   modifier inReleaseState(bool releaseState) {
387     if(releaseState != released) {
388         throw;
389     }
390     _;
391   }
392 
393   /** The function can be called only by a whitelisted release agent. */
394   modifier onlyReleaseAgent() {
395     if(msg.sender != releaseAgent) {
396         throw;
397     }
398     _;
399   }
400 
401   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
402     // Call StandardToken.transfer()
403    return super.transfer(_to, _value);
404   }
405 
406   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
407     // Call StandardToken.transferForm()
408     return super.transferFrom(_from, _to, _value);
409   }
410 
411 }
412 
413 /**
414  * A crowdsaled token.
415  *
416  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
417  *
418  * - The token transfer() is disabled until the crowdsale is over
419  * - The token contract gives an opt-in upgrade path to a new contract
420  * - The same token can be part of several crowdsales through approve() mechanism
421  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
422  *
423  */
424 contract CrowdsaleToken is ReleasableToken, UpgradeableToken {
425 
426   /** Name and symbol were updated. */
427   event UpdatedTokenInformation(string newName, string newSymbol);
428 
429   string public name;
430 
431   string public symbol;
432 
433   uint public decimals;
434 
435   /**
436    * Construct the token.
437    *
438    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
439    *
440    * @param _name Token name
441    * @param _symbol Token symbol - should be all caps
442    * @param _initialSupply How many tokens we start with
443    * @param _decimals Number of decimal places
444    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
445    */
446   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
447     UpgradeableToken(msg.sender) {
448 
449     // Create any address, can be transferred
450     // to team multisig via changeOwner(),
451     // also remember to call setUpgradeMaster()
452     owner = msg.sender;
453 
454     name = _name;
455     symbol = _symbol;
456 
457     totalSupply = _initialSupply;
458 
459     decimals = _decimals;
460 
461     // Create initially all balance on the team multisig
462     balances[owner] = totalSupply;
463 
464   }
465 
466   /**
467    * Allow upgrade agent functionality kick in only if the crowdsale was success.
468    */
469   function canUpgrade() public constant returns(bool) {
470     return released && super.canUpgrade();
471   }
472 
473   /**
474    * Owner can update token information here.
475    *
476    * It is often useful to conceal the actual token association, until
477    * the token operations, like central issuance or reissuance have been completed.
478    *
479    * This function allows the token owner to rename the token after the operations
480    * have been completed and then point the audience to use the token contract.
481    */
482   function setTokenInformation(string _name, string _symbol) onlyOwner {
483     name = _name;
484     symbol = _symbol;
485 
486     UpdatedTokenInformation(name, symbol);
487   }
488 
489 }