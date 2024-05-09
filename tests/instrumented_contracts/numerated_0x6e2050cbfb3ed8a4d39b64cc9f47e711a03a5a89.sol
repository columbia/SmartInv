1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) returns (bool);
13   function approve(address spender, uint256 value) returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract UpgradeAgent {
18 
19   uint public originalSupply;
20 
21   /** Interface marker */
22   function isUpgradeAgent() public constant returns (bool) {
23     return true;
24   }
25 
26   function upgradeFrom(address _from, uint256 _value) public;
27 
28 }
29 
30 contract Ownable {
31   address public owner;
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   function Ownable() {
39     owner = msg.sender;
40   }
41 
42 
43   /**
44    * @dev Throws if called by any account other than the owner.
45    */
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address newOwner) onlyOwner {
57     require(newOwner != address(0));      
58     owner = newOwner;
59   }
60 
61 }
62 
63 library SafeMathLib {
64 
65   function times(uint a, uint b) returns (uint) {
66     uint c = a * b;
67     assert(a == 0 || c / a == b);
68     return c;
69   }
70 
71   function minus(uint a, uint b) returns (uint) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   function plus(uint a, uint b) returns (uint) {
77     uint c = a + b;
78     assert(c>=a);
79     return c;
80   }
81 
82 }
83 
84 /**
85  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
86  *
87  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
88  */
89 
90 contract ReleasableToken is ERC20, Ownable {
91 
92   /* The finalizer contract that allows unlift the transfer limits on this token */
93   address public releaseAgent;
94 
95   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
96   bool public released = false;
97 
98   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
99   mapping (address => bool) public transferAgents;
100 
101   /**
102    * Limit token transfer until the crowdsale is over.
103    *
104    */
105   modifier canTransfer(address _sender) {
106 
107     if(!released) {
108         if(!transferAgents[_sender]) {
109             throw;
110         }
111     }
112 
113     _;
114   }
115 
116   /**
117    * Set the contract that can call release and make the token transferable.
118    *
119    * Design choice. Allow reset the release agent to fix fat finger mistakes.
120    */
121   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
122 
123     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
124     releaseAgent = addr;
125   }
126 
127   /**
128    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
129    */
130   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
131     transferAgents[addr] = state;
132   }
133 
134   /**
135    * One way function to release the tokens to the wild.
136    *
137    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
138    */
139   function releaseTokenTransfer() public onlyReleaseAgent {
140     released = true;
141   }
142 
143   /** The function can be called only before or after the tokens have been releasesd */
144   modifier inReleaseState(bool releaseState) {
145     if(releaseState != released) {
146         throw;
147     }
148     _;
149   }
150 
151   /** The function can be called only by a whitelisted release agent. */
152   modifier onlyReleaseAgent() {
153     if(msg.sender != releaseAgent) {
154         throw;
155     }
156     _;
157   }
158 
159   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
160     // Call StandardToken.transfer()
161    return super.transfer(_to, _value);
162   }
163 
164   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
165     // Call StandardToken.transferForm()
166     return super.transferFrom(_from, _to, _value);
167   }
168 
169 }
170 
171 library SafeMath {
172   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
173     uint256 c = a * b;
174     assert(a == 0 || c / a == b);
175     return c;
176   }
177 
178   function div(uint256 a, uint256 b) internal constant returns (uint256) {
179     // assert(b > 0); // Solidity automatically throws when dividing by 0
180     uint256 c = a / b;
181     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
182     return c;
183   }
184 
185   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
186     assert(b <= a);
187     return a - b;
188   }
189 
190   function add(uint256 a, uint256 b) internal constant returns (uint256) {
191     uint256 c = a + b;
192     assert(c >= a);
193     return c;
194   }
195 }
196 
197 contract BasicToken is ERC20Basic {
198   using SafeMath for uint256;
199 
200   mapping(address => uint256) balances;
201 
202   /**
203   * @dev transfer token for a specified address
204   * @param _to The address to transfer to.
205   * @param _value The amount to be transferred.
206   */
207   function transfer(address _to, uint256 _value) returns (bool) {
208     balances[msg.sender] = balances[msg.sender].sub(_value);
209     balances[_to] = balances[_to].add(_value);
210     Transfer(msg.sender, _to, _value);
211     return true;
212   }
213 
214   /**
215   * @dev Gets the balance of the specified address.
216   * @param _owner The address to query the the balance of. 
217   * @return An uint256 representing the amount owned by the passed address.
218   */
219   function balanceOf(address _owner) constant returns (uint256 balance) {
220     return balances[_owner];
221   }
222 
223 }
224 
225 contract StandardToken is ERC20, BasicToken {
226 
227   mapping (address => mapping (address => uint256)) allowed;
228 
229 
230   /**
231    * @dev Transfer tokens from one address to another
232    * @param _from address The address which you want to send tokens from
233    * @param _to address The address which you want to transfer to
234    * @param _value uint256 the amout of tokens to be transfered
235    */
236   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
237     var _allowance = allowed[_from][msg.sender];
238 
239     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
240     // require (_value <= _allowance);
241 
242     balances[_to] = balances[_to].add(_value);
243     balances[_from] = balances[_from].sub(_value);
244     allowed[_from][msg.sender] = _allowance.sub(_value);
245     Transfer(_from, _to, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
251    * @param _spender The address which will spend the funds.
252    * @param _value The amount of tokens to be spent.
253    */
254   function approve(address _spender, uint256 _value) returns (bool) {
255 
256     // To change the approve amount you first have to reduce the addresses`
257     //  allowance to zero by calling `approve(_spender, 0)` if it is not
258     //  already 0 to mitigate the race condition described here:
259     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
261 
262     allowed[msg.sender][_spender] = _value;
263     Approval(msg.sender, _spender, _value);
264     return true;
265   }
266 
267   /**
268    * @dev Function to check the amount of tokens that an owner allowed to a spender.
269    * @param _owner address The address which owns the funds.
270    * @param _spender address The address which will spend the funds.
271    * @return A uint256 specifing the amount of tokens still available for the spender.
272    */
273   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
274     return allowed[_owner][_spender];
275   }
276 
277 }
278 
279 contract StandardTokenExt is StandardToken {
280 
281   /* Interface declaration */
282   function isToken() public constant returns (bool weAre) {
283     return true;
284   }
285 }
286 
287 
288 /**
289  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
290  *
291  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
292  */
293 
294  /**
295  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
296  *
297  * First envisioned by Golem and Lunyr projects.
298  */
299  
300 contract UpgradeableToken is StandardTokenExt {
301 
302   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
303   address public upgradeMaster;
304 
305   /** The next contract where the tokens will be migrated. */
306   UpgradeAgent public upgradeAgent;
307 
308   /** How many tokens we have upgraded by now. */
309   uint256 public totalUpgraded;
310 
311   /**
312    * Upgrade states.
313    *
314    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
315    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
316    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
317    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
318    *
319    */
320   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
321 
322   /**
323    * Somebody has upgraded some of his tokens.
324    */
325   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
326 
327   /**
328    * New upgrade agent available.
329    */
330   event UpgradeAgentSet(address agent);
331 
332   /**
333    * Do not allow construction without upgrade master set.
334    */
335   function UpgradeableToken(address _upgradeMaster) {
336     upgradeMaster = _upgradeMaster;
337   }
338 
339   /**
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
364   /**
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
390   /**
391    * Get the state of the token upgrade.
392    */
393   function getUpgradeState() public constant returns(UpgradeState) {
394     if(!canUpgrade()) return UpgradeState.NotAllowed;
395     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
396     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
397     else return UpgradeState.Upgrading;
398   }
399 
400   /**
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
411   /**
412    * Child contract can enable to provide the condition when the upgrade can begun.
413    */
414   function canUpgrade() public constant returns(bool) {
415      return true;
416   }
417 
418 }
419 
420 contract MintableToken is StandardTokenExt, Ownable {
421 
422   using SafeMathLib for uint;
423 
424   bool public mintingFinished = false;
425 
426   /** List of agents that are allowed to create new tokens */
427   mapping (address => bool) public mintAgents;
428 
429   event MintingAgentChanged(address addr, bool state);
430   event Minted(address receiver, uint amount);
431 
432   /**
433    * Create new tokens and allocate them to an address..
434    *
435    * Only callably by a crowdsale contract (mint agent).
436    */
437   function mint(address receiver, uint amount) onlyMintAgent canMint public {
438     totalSupply = totalSupply.plus(amount);
439     balances[receiver] = balances[receiver].plus(amount);
440 
441     // This will make the mint transaction apper in EtherScan.io
442     // We can remove this after there is a standardized minting event
443     Transfer(0, receiver, amount);
444   }
445 
446   /**
447    * Owner can allow a crowdsale contract to mint new tokens.
448    */
449   function setMintAgent(address addr, bool state) onlyOwner canMint public {
450     mintAgents[addr] = state;
451     MintingAgentChanged(addr, state);
452   }
453 
454   modifier onlyMintAgent() {
455     // Only crowdsale contracts are allowed to mint new tokens
456     if(!mintAgents[msg.sender]) {
457         throw;
458     }
459     _;
460   }
461 
462   /** Make sure we are not done yet. */
463   modifier canMint() {
464     if(mintingFinished) throw;
465     _;
466   }
467 }
468 
469 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
470 
471   /** Name and symbol were updated. */
472   event UpdatedTokenInformation(string newName, string newSymbol);
473 
474   string public name;
475 
476   string public symbol;
477 
478   uint public decimals;
479 
480   /**
481    * Construct the token.
482    *
483    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
484    *
485    * @param _name Token name
486    * @param _symbol Token symbol - should be all caps
487    * @param _initialSupply How many tokens we start with
488    * @param _decimals Number of decimal places
489    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
490    */
491   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
492     UpgradeableToken(msg.sender) {
493 
494     // Create any address, can be transferred
495     // to team multisig via changeOwner(),
496     // also remember to call setUpgradeMaster()
497     owner = msg.sender;
498 
499     name = _name;
500     symbol = _symbol;
501 
502     totalSupply = _initialSupply;
503 
504     decimals = _decimals;
505 
506     // Create initially all balance on the team multisig
507     balances[owner] = totalSupply;
508 
509     if(totalSupply > 0) {
510       Minted(owner, totalSupply);
511     }
512 
513     // No more new supply allowed after the token creation
514     if(!_mintable) {
515       mintingFinished = true;
516       if(totalSupply == 0) {
517         throw; // Cannot create a token without supply and no minting
518       }
519     }
520   }
521 
522   /**
523    * When token is released to be transferable, enforce no new tokens can be created.
524    */
525   function releaseTokenTransfer() public onlyReleaseAgent {
526     mintingFinished = true;
527     super.releaseTokenTransfer();
528   }
529 
530   /**
531    * Allow upgrade agent functionality kick in only if the crowdsale was success.
532    */
533   function canUpgrade() public constant returns(bool) {
534     return released && super.canUpgrade();
535   }
536 
537   /**
538    * Owner can update token information here.
539    *
540    * It is often useful to conceal the actual token association, until
541    * the token operations, like central issuance or reissuance have been completed.
542    *
543    * This function allows the token owner to rename the token after the operations
544    * have been completed and then point the audience to use the token contract.
545    */
546   function setTokenInformation(string _name, string _symbol) onlyOwner {
547     name = _name;
548     symbol = _symbol;
549 
550     UpdatedTokenInformation(name, symbol);
551   }
552 
553 }
554 
555 contract BurnableToken is StandardTokenExt {
556 
557   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
558   address public constant BURN_ADDRESS = 0;
559 
560   /** How many tokens we burned */
561   event Burned(address burner, uint burnedAmount);
562 
563   /**
564    * Burn extra tokens from a balance.
565    *
566    */
567   function burn(uint burnAmount) {
568     address burner = msg.sender;
569     balances[burner] = balances[burner].sub(burnAmount);
570     totalSupply = totalSupply.sub(burnAmount);
571     Burned(burner, burnAmount);
572 
573     // Inform the blockchain explores that track the
574     // balances only by a transfer event that the balance in this
575     // address has decreased
576     Transfer(burner, BURN_ADDRESS, burnAmount);
577   }
578 }
579 
580 contract StreamSpaceToken is BurnableToken, CrowdsaleToken {
581 
582   function StreamSpaceToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
583     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
584 
585   }
586 }