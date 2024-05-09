1 pragma solidity ^0.4.13;
2 
3 contract UpgradeAgent {
4 
5   uint public originalSupply;
6 
7   /** Interface marker */
8   function isUpgradeAgent() public constant returns (bool) {
9     return true;
10   }
11 
12   function upgradeFrom(address _from, uint256 _value) public;
13 
14 }
15 
16 contract Ownable {
17   address public owner;
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   function Ownable() {
25     owner = msg.sender;
26   }
27 
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address newOwner) onlyOwner {
43     require(newOwner != address(0));      
44     owner = newOwner;
45   }
46 
47 }
48 
49 library SafeMathLib {
50 
51   function times(uint a, uint b) returns (uint) {
52     uint c = a * b;
53     assert(a == 0 || c / a == b);
54     return c;
55   }
56 
57   function minus(uint a, uint b) returns (uint) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   function plus(uint a, uint b) returns (uint) {
63     uint c = a + b;
64     assert(c>=a);
65     return c;
66   }
67 
68 }
69 
70 contract ERC20Basic {
71   uint256 public totalSupply;
72   function balanceOf(address who) constant returns (uint256);
73   function transfer(address to, uint256 value) returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 contract ERC20 is ERC20Basic {
78   function allowance(address owner, address spender) constant returns (uint256);
79   function transferFrom(address from, address to, uint256 value) returns (bool);
80   function approve(address spender, uint256 value) returns (bool);
81   event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 contract ReleasableToken is ERC20, Ownable {
85 
86   /* The finalizer contract that allows unlift the transfer limits on this token */
87   address public releaseAgent;
88 
89   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
90   bool public released = false;
91 
92   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
93   mapping (address => bool) public transferAgents;
94 
95   /**
96    * Limit token transfer until the crowdsale is over.
97    *
98    */
99   modifier canTransfer(address _sender) {
100 
101     if(!released) {
102         if(!transferAgents[_sender]) {
103             throw;
104         }
105     }
106 
107     _;
108   }
109 
110   /**
111    * Set the contract that can call release and make the token transferable.
112    *
113    * Design choice. Allow reset the release agent to fix fat finger mistakes.
114    */
115   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
116 
117     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
118     releaseAgent = addr;
119   }
120 
121   /**
122    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
123    */
124   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
125     transferAgents[addr] = state;
126   }
127 
128   /**
129    * One way function to release the tokens to the wild.
130    *
131    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
132    */
133   function releaseTokenTransfer() public onlyReleaseAgent {
134     released = true;
135   }
136 
137   /** The function can be called only before or after the tokens have been releasesd */
138   modifier inReleaseState(bool releaseState) {
139     if(releaseState != released) {
140         throw;
141     }
142     _;
143   }
144 
145   /** The function can be called only by a whitelisted release agent. */
146   modifier onlyReleaseAgent() {
147     if(msg.sender != releaseAgent) {
148         throw;
149     }
150     _;
151   }
152 
153   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
154     // Call StandardToken.transfer()
155    return super.transfer(_to, _value);
156   }
157 
158   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
159     // Call StandardToken.transferForm()
160     return super.transferFrom(_from, _to, _value);
161   }
162 
163 }
164 
165 library SafeMath {
166   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
167     uint256 c = a * b;
168     assert(a == 0 || c / a == b);
169     return c;
170   }
171 
172   function div(uint256 a, uint256 b) internal constant returns (uint256) {
173     // assert(b > 0); // Solidity automatically throws when dividing by 0
174     uint256 c = a / b;
175     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
176     return c;
177   }
178 
179   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
180     assert(b <= a);
181     return a - b;
182   }
183 
184   function add(uint256 a, uint256 b) internal constant returns (uint256) {
185     uint256 c = a + b;
186     assert(c >= a);
187     return c;
188   }
189 }
190 
191 contract BasicToken is ERC20Basic {
192   using SafeMath for uint256;
193 
194   mapping(address => uint256) balances;
195 
196   /**
197   * @dev transfer token for a specified address
198   * @param _to The address to transfer to.
199   * @param _value The amount to be transferred.
200   */
201   function transfer(address _to, uint256 _value) returns (bool) {
202     balances[msg.sender] = balances[msg.sender].sub(_value);
203     balances[_to] = balances[_to].add(_value);
204     Transfer(msg.sender, _to, _value);
205     return true;
206   }
207 
208   /**
209   * @dev Gets the balance of the specified address.
210   * @param _owner The address to query the the balance of. 
211   * @return An uint256 representing the amount owned by the passed address.
212   */
213   function balanceOf(address _owner) constant returns (uint256 balance) {
214     return balances[_owner];
215   }
216 
217 }
218 
219 contract StandardToken is ERC20, BasicToken {
220 
221   mapping (address => mapping (address => uint256)) allowed;
222 
223 
224   /**
225    * @dev Transfer tokens from one address to another
226    * @param _from address The address which you want to send tokens from
227    * @param _to address The address which you want to transfer to
228    * @param _value uint256 the amout of tokens to be transfered
229    */
230   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
231     var _allowance = allowed[_from][msg.sender];
232 
233     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
234     // require (_value <= _allowance);
235 
236     balances[_to] = balances[_to].add(_value);
237     balances[_from] = balances[_from].sub(_value);
238     allowed[_from][msg.sender] = _allowance.sub(_value);
239     Transfer(_from, _to, _value);
240     return true;
241   }
242 
243   /**
244    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
245    * @param _spender The address which will spend the funds.
246    * @param _value The amount of tokens to be spent.
247    */
248   function approve(address _spender, uint256 _value) returns (bool) {
249 
250     // To change the approve amount you first have to reduce the addresses`
251     //  allowance to zero by calling `approve(_spender, 0)` if it is not
252     //  already 0 to mitigate the race condition described here:
253     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
255 
256     allowed[msg.sender][_spender] = _value;
257     Approval(msg.sender, _spender, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Function to check the amount of tokens that an owner allowed to a spender.
263    * @param _owner address The address which owns the funds.
264    * @param _spender address The address which will spend the funds.
265    * @return A uint256 specifing the amount of tokens still available for the spender.
266    */
267   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
268     return allowed[_owner][_spender];
269   }
270 
271 }
272 
273 contract StandardTokenExt is StandardToken {
274 
275   /* Interface declaration */
276   function isToken() public constant returns (bool weAre) {
277     return true;
278   }
279 }
280 
281 contract MintableToken is StandardTokenExt, Ownable {
282 
283   using SafeMathLib for uint;
284 
285   bool public mintingFinished = false;
286 
287   /** List of agents that are allowed to create new tokens */
288   mapping (address => bool) public mintAgents;
289 
290   event MintingAgentChanged(address addr, bool state);
291   event Minted(address receiver, uint amount);
292 
293   /**
294    * Create new tokens and allocate them to an address..
295    *
296    * Only callably by a crowdsale contract (mint agent).
297    */
298   function mint(address receiver, uint amount) onlyMintAgent canMint public {
299     totalSupply = totalSupply.plus(amount);
300     balances[receiver] = balances[receiver].plus(amount);
301 
302     // This will make the mint transaction apper in EtherScan.io
303     // We can remove this after there is a standardized minting event
304     Transfer(0, receiver, amount);
305   }
306 
307   /**
308    * Owner can allow a crowdsale contract to mint new tokens.
309    */
310   function setMintAgent(address addr, bool state) onlyOwner canMint public {
311     mintAgents[addr] = state;
312     MintingAgentChanged(addr, state);
313   }
314 
315   modifier onlyMintAgent() {
316     // Only crowdsale contracts are allowed to mint new tokens
317     if(!mintAgents[msg.sender]) {
318         throw;
319     }
320     _;
321   }
322 
323   /** Make sure we are not done yet. */
324   modifier canMint() {
325     if(mintingFinished) throw;
326     _;
327   }
328 }
329 
330 contract UpgradeableToken is StandardTokenExt {
331 
332   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
333   address public upgradeMaster;
334 
335   /** The next contract where the tokens will be migrated. */
336   UpgradeAgent public upgradeAgent;
337 
338   /** How many tokens we have upgraded by now. */
339   uint256 public totalUpgraded;
340 
341   /**
342    * Upgrade states.
343    *
344    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
345    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
346    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
347    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
348    *
349    */
350   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
351 
352   /**
353    * Somebody has upgraded some of his tokens.
354    */
355   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
356 
357   /**
358    * New upgrade agent available.
359    */
360   event UpgradeAgentSet(address agent);
361 
362   /**
363    * Do not allow construction without upgrade master set.
364    */
365   function UpgradeableToken(address _upgradeMaster) {
366     upgradeMaster = _upgradeMaster;
367   }
368 
369   /**
370    * Allow the token holder to upgrade some of their tokens to a new contract.
371    */
372   function upgrade(uint256 value) public {
373 
374       UpgradeState state = getUpgradeState();
375       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
376         // Called in a bad state
377         throw;
378       }
379 
380       // Validate input value.
381       if (value == 0) throw;
382 
383       balances[msg.sender] = balances[msg.sender].sub(value);
384 
385       // Take tokens out from circulation
386       totalSupply = totalSupply.sub(value);
387       totalUpgraded = totalUpgraded.add(value);
388 
389       // Upgrade agent reissues the tokens
390       upgradeAgent.upgradeFrom(msg.sender, value);
391       Upgrade(msg.sender, upgradeAgent, value);
392   }
393 
394   /**
395    * Set an upgrade agent that handles
396    */
397   function setUpgradeAgent(address agent) external {
398 
399       if(!canUpgrade()) {
400         // The token is not yet in a state that we could think upgrading
401         throw;
402       }
403 
404       if (agent == 0x0) throw;
405       // Only a master can designate the next agent
406       if (msg.sender != upgradeMaster) throw;
407       // Upgrade has already begun for an agent
408       if (getUpgradeState() == UpgradeState.Upgrading) throw;
409 
410       upgradeAgent = UpgradeAgent(agent);
411 
412       // Bad interface
413       if(!upgradeAgent.isUpgradeAgent()) throw;
414       // Make sure that token supplies match in source and target
415       if (upgradeAgent.originalSupply() != totalSupply) throw;
416 
417       UpgradeAgentSet(upgradeAgent);
418   }
419 
420   /**
421    * Get the state of the token upgrade.
422    */
423   function getUpgradeState() public constant returns(UpgradeState) {
424     if(!canUpgrade()) return UpgradeState.NotAllowed;
425     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
426     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
427     else return UpgradeState.Upgrading;
428   }
429 
430   /**
431    * Change the upgrade master.
432    *
433    * This allows us to set a new owner for the upgrade mechanism.
434    */
435   function setUpgradeMaster(address master) public {
436       if (master == 0x0) throw;
437       if (msg.sender != upgradeMaster) throw;
438       upgradeMaster = master;
439   }
440 
441   /**
442    * Child contract can enable to provide the condition when the upgrade can begun.
443    */
444   function canUpgrade() public constant returns(bool) {
445      return true;
446   }
447 
448 }
449 
450 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
451 
452   /** Name and symbol were updated. */
453   event UpdatedTokenInformation(string newName, string newSymbol);
454 
455   string public name;
456 
457   string public symbol;
458 
459   uint public decimals;
460 
461   /**
462    * Construct the token.
463    *
464    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
465    *
466    * @param _name Token name
467    * @param _symbol Token symbol - should be all caps
468    * @param _initialSupply How many tokens we start with
469    * @param _decimals Number of decimal places
470    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
471    */
472   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
473     UpgradeableToken(msg.sender) {
474 
475     // Create any address, can be transferred
476     // to team multisig via changeOwner(),
477     // also remember to call setUpgradeMaster()
478     owner = msg.sender;
479 
480     name = _name;
481     symbol = _symbol;
482 
483     totalSupply = _initialSupply;
484 
485     decimals = _decimals;
486 
487     // Create initially all balance on the team multisig
488     balances[owner] = totalSupply;
489 
490     if(totalSupply > 0) {
491       Minted(owner, totalSupply);
492     }
493 
494     // No more new supply allowed after the token creation
495     if(!_mintable) {
496       mintingFinished = true;
497       if(totalSupply == 0) {
498         throw; // Cannot create a token without supply and no minting
499       }
500     }
501   }
502 
503   /**
504    * When token is released to be transferable, enforce no new tokens can be created.
505    */
506   function releaseTokenTransfer() public onlyReleaseAgent {
507     mintingFinished = true;
508     super.releaseTokenTransfer();
509   }
510 
511   /**
512    * Allow upgrade agent functionality kick in only if the crowdsale was success.
513    */
514   function canUpgrade() public constant returns(bool) {
515     return released && super.canUpgrade();
516   }
517 
518   /**
519    * Owner can update token information here.
520    *
521    * It is often useful to conceal the actual token association, until
522    * the token operations, like central issuance or reissuance have been completed.
523    *
524    * This function allows the token owner to rename the token after the operations
525    * have been completed and then point the audience to use the token contract.
526    */
527   function setTokenInformation(string _name, string _symbol) onlyOwner {
528     name = _name;
529     symbol = _symbol;
530 
531     UpdatedTokenInformation(name, symbol);
532   }
533 
534 }
535 
536 contract BurnableToken is StandardTokenExt {
537 
538   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
539   address public constant BURN_ADDRESS = 0;
540 
541   /** How many tokens we burned */
542   event Burned(address burner, uint burnedAmount);
543 
544   /**
545    * Burn extra tokens from a balance.
546    *
547    */
548   function burn(uint burnAmount) {
549     address burner = msg.sender;
550     balances[burner] = balances[burner].sub(burnAmount);
551     totalSupply = totalSupply.sub(burnAmount);
552     Burned(burner, burnAmount);
553 
554     // Inform the blockchain explores that track the
555     // balances only by a transfer event that the balance in this
556     // address has decreased
557     Transfer(burner, BURN_ADDRESS, burnAmount);
558   }
559 }
560 
561 contract BurnableCrowdsaleToken is BurnableToken, CrowdsaleToken {
562 
563   function BurnableCrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
564     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
565 
566   }
567 }