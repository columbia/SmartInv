1 pragma solidity ^0.4.11;
2 
3 /*
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint a, uint b) internal returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal returns (uint) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) internal returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47   function assert(bool assertion) internal {
48     if (!assertion) {
49       throw;
50     }
51   }
52 }
53 
54 /*
55  * Ownable
56  *
57  * Base contract with an owner.
58  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
59  */
60 contract Ownable {
61   address public owner;
62 
63   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65   function Ownable() {
66     owner = msg.sender;
67   }
68 
69   modifier onlyOwner() {
70     require(msg.sender == owner);
71     _;
72   }
73 
74   function transferOwnership(address newOwner) onlyOwner public {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 /*
83  * ERC20 interface
84  * see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20 {
87   uint public totalSupply;
88   function balanceOf(address who) constant returns (uint);
89   function allowance(address owner, address spender) constant returns (uint);
90 
91   function transfer(address to, uint value) returns (bool ok);
92   function transferFrom(address from, address to, uint value) returns (bool ok);
93   function approve(address spender, uint value) returns (bool ok);
94   event Transfer(address indexed from, address indexed to, uint value);
95   event Approval(address indexed owner, address indexed spender, uint value);
96 }
97 
98 /*
99  * A token that defines fractional units as decimals.
100  */
101 contract FractionalERC20 is ERC20 {
102 
103   uint public decimals;
104 
105 }
106 
107 /**
108  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
109  *
110  */
111 contract StandardToken is ERC20 {
112 
113   using SafeMath for uint;
114 
115   /* Token supply got increased and a new owner received these tokens */
116   event Minted(address receiver, uint amount);
117 
118   /* Actual balances of token holders */
119   mapping(address => uint) balances;
120 
121   /* approve() allowances */
122   mapping (address => mapping (address => uint)) allowed;
123 
124   /* Interface declaration */
125   function isToken() public constant returns (bool weAre) {
126     return true;
127   }
128 
129   function transfer(address _to, uint _value) returns (bool success) {
130     balances[msg.sender] = balances[msg.sender].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     Transfer(msg.sender, _to, _value);
133     return true;
134   }
135 
136   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
137     uint _allowance = allowed[_from][msg.sender];
138 
139     balances[_to] = balances[_to].add(_value);
140     balances[_from] = balances[_from].sub(_value);
141     allowed[_from][msg.sender] = _allowance.sub(_value);
142     Transfer(_from, _to, _value);
143     return true;
144   }
145 
146   function balanceOf(address _owner) constant returns (uint balance) {
147     return balances[_owner];
148   }
149 
150   function approve(address _spender, uint _value) returns (bool success) {
151 
152     // To change the approve amount you first have to reduce the addresses`
153     //  allowance to zero by calling `approve(_spender, 0)` if it is not
154     //  already 0 to mitigate the race condition described here:
155     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
157 
158     allowed[msg.sender][_spender] = _value;
159     Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   function allowance(address _owner, address _spender) constant returns (uint remaining) {
164     return allowed[_owner][_spender];
165   }
166 
167   function increaseApproval (address _spender, uint _addedValue)
168     returns (bool success) {
169     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
170     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171     return true;
172   }
173 
174   function decreaseApproval (address _spender, uint _subtractedValue)
175     returns (bool success) {
176     uint oldValue = allowed[msg.sender][_spender];
177     if (_subtractedValue > oldValue) {
178       allowed[msg.sender][_spender] = 0;
179     } else {
180       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
181     }
182     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 
186 }
187 
188 contract MintableToken is StandardToken, Ownable {
189 
190   using SafeMath for uint;
191 
192   bool public mintingFinished = false;
193 
194   /* List of agents that are allowed to create new tokens */
195   mapping (address => bool) public mintAgents;
196 
197   event MintingAgentChanged(address addr, bool state  );
198 
199 
200   /*
201    * Create new tokens and allocate them to an address..
202    *
203    * Only callably by a crowdsale contract (mint agent).
204    */
205   function mint(address receiver, uint amount) onlyMintAgent canMint public {
206 
207     if(amount == 0) {
208       throw;
209     }
210 
211     totalSupply = totalSupply.add(amount);
212     balances[receiver] = balances[receiver].add(amount);
213     Transfer(0, receiver, amount);
214   }
215 
216   /*
217    * Owner can allow a crowdsale contract to mint new tokens.
218    */
219   function setMintAgent(address addr, bool state) onlyOwner canMint public {
220     mintAgents[addr] = state;
221     MintingAgentChanged(addr, state);
222   }
223 
224   modifier onlyMintAgent() {
225     // Only crowdsale contracts are allowed to mint new tokens
226     if(!mintAgents[msg.sender]) {
227         throw;
228     }
229     _;
230   }
231 
232   /* Make sure we are not done yet. */
233   modifier canMint() {
234     if(mintingFinished) throw;
235     _;
236   }
237 }
238 
239 /*
240  * Define interface for releasing the token transfer after a successful crowdsale.
241  */
242 contract ReleasableToken is ERC20, Ownable {
243 
244   /* The finalizer contract that allows unlift the transfer limits on this token */
245   address public releaseAgent;
246 
247   bool public released = false;
248 
249   /* Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
250   mapping (address => bool) public transferAgents;
251 
252   /*
253    * Limit token transfer until the crowdsale is over.
254    *
255    */
256   modifier canTransfer(address _sender) {
257 
258     if(!released) {
259         if(!transferAgents[_sender]) {
260             throw;
261         }
262     }
263 
264     _;
265   }
266 
267   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
268 
269     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
270     releaseAgent = addr;
271   }
272 
273   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
274     transferAgents[addr] = state;
275   }
276 
277   function releaseTokenTransfer() public onlyReleaseAgent {
278     released = true;
279   }
280 
281   /* The function can be called only before or after the tokens have been releasesd */
282   modifier inReleaseState(bool releaseState) {
283     if(releaseState != released) {
284         throw;
285     }
286     _;
287   }
288 
289   /* The function can be called only by a whitelisted release agent. */
290   modifier onlyReleaseAgent() {
291     if(msg.sender != releaseAgent) {
292         throw;
293     }
294     _;
295   }
296 
297   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
298     // Call StandardToken.transfer()
299    return super.transfer(_to, _value);
300   }
301 
302   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
303     // Call StandardToken.transferForm()
304     return super.transferFrom(_from, _to, _value);
305   }
306 
307 }
308 
309 contract UpgradeableToken is StandardToken {
310 
311   /* Contract  person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
312   address public upgradeMaster;
313 
314   /* The next contract where the tokens will be migrated. */
315   UpgradeAgent public upgradeAgent;
316 
317   /* How many tokens we have upgraded by now. */
318   uint256 public totalUpgraded;
319 
320   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
321 
322   /*
323    * Somebody has upgraded some of his tokens.
324    */
325   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
326 
327   /*
328    * New upgrade agent available.
329    */
330   event UpgradeAgentSet(address agent);
331 
332   /*
333    * Do not allow construction without upgrade master set.
334    */
335   function UpgradeableToken(address _upgradeMaster) {
336     upgradeMaster = _upgradeMaster;
337   }
338 
339   /*
340    * Allow the token holder to upgrade some of their tokens to a new contract.
341    */
342   function upgrade(uint256 value) public {
343 
344       UpgradeState state = getUpgradeState();
345       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
346         // Called in a bad state
347         throw;
348       }
349 
350       // Validate input value.
351       if (value == 0) throw;
352 
353       balances[msg.sender] = balances[msg.sender].sub(value);
354 
355       // Take tokens out from circulation
356       totalSupply = totalSupply.sub(value);
357       totalUpgraded = totalUpgraded.add(value);
358 
359       // Upgrade agent reissues the tokens
360       upgradeAgent.upgradeFrom(msg.sender, value);
361       Upgrade(msg.sender, upgradeAgent, value);
362   }
363 
364   /*
365    * Set an upgrade agent that handles
366    */
367   function setUpgradeAgent(address agent) external {
368 
369       if(!canUpgrade()) {
370         // The token is not yet in a state that we could think upgrading
371         throw;
372       }
373 
374       if (agent == 0x0) throw;
375       // Only a master can designate the next agent
376       if (msg.sender != upgradeMaster) throw;
377       // Upgrade has already begun for an agent
378       if (getUpgradeState() == UpgradeState.Upgrading) throw;
379 
380       upgradeAgent = UpgradeAgent(agent);
381 
382       // Bad interface
383       if(!upgradeAgent.isUpgradeAgent()) throw;
384       // Make sure that token supplies match in source and target
385       if (upgradeAgent.originalSupply() != totalSupply) throw;
386 
387       UpgradeAgentSet(upgradeAgent);
388   }
389 
390   /*
391    * Get the state of the token upgrade.
392    */
393   function getUpgradeState() public constant returns(UpgradeState) {
394     if(!canUpgrade()) return UpgradeState.NotAllowed;
395     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
396     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
397     else return UpgradeState.Upgrading;
398   }
399 
400   /*
401    * Change the upgrade master.
402    *
403    * This allows us to set a new owner for the upgrade mechanism.
404    */
405   function setUpgradeMaster(address master) public {
406       if (master == 0x0) throw;
407       if (msg.sender != upgradeMaster) throw;
408       upgradeMaster = master;
409   }
410 
411   /*
412    * Child contract can enable to provide the condition when the upgrade can begun.
413    */
414   function canUpgrade() public constant returns(bool) {
415      return true;
416   }
417 
418 }
419 
420 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
421 
422   event UpdatedTokenInformation(string newName, string newSymbol);
423 
424   string public name;
425 
426   string public symbol;
427 
428   uint public decimals;
429 
430   /*
431    * Construct the token.
432    *
433    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
434    */
435   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
436     UpgradeableToken(msg.sender) {
437 
438     // Create any address, can be transferred
439     // to team multisig via changeOwner(),
440     // also remember to call setUpgradeMaster()
441     owner = msg.sender;
442 
443     name = _name;
444     symbol = _symbol;
445 
446     totalSupply = _initialSupply;
447 
448     decimals = _decimals;
449 
450     // Create initially all balance on the team multisig
451     balances[owner] = totalSupply;
452 
453     if(totalSupply > 0) {
454       Minted(owner, totalSupply);
455     }
456 
457     // No more new supply allowed after the token creation. 
458     if(!_mintable) {
459       mintingFinished = true;
460       if(totalSupply == 0) {
461         throw; // Cannot create a token without supply and no minting
462       }
463     }
464 
465   }
466 
467   /*
468    * When token is released to be transferable, enforce no new tokens can be created.
469    */
470   function releaseTokenTransfer() public onlyReleaseAgent {
471     mintingFinished = true;
472     super.releaseTokenTransfer();
473   }
474 
475   /*
476    * Allow upgrade agent functionality kick in only if the crowdsale was success.
477    */
478   function canUpgrade() public constant returns(bool) {
479     return released && super.canUpgrade();
480   }
481 
482   /*
483    * Owner can update token information here
484    */
485   function setTokenInformation(string _name, string _symbol) onlyOwner {
486     name = _name;
487     symbol = _symbol;
488 
489     UpdatedTokenInformation(name, symbol);
490   }
491 
492 }
493 
494 contract TapcoinToken is CrowdsaleToken {
495   function TapcoinToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
496    CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
497   }
498 }
499 
500 contract UpgradeAgent {
501 
502   uint public originalSupply;
503 
504   /* Interface marker */
505   function isUpgradeAgent() public constant returns (bool) {
506     return true;
507   }
508 
509   function upgradeFrom(address _from, uint256 _value) public;
510 
511 }