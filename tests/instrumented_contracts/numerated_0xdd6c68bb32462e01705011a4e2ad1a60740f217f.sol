1 pragma solidity ^0.4.13;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control 
7  * functions, this simplifies the implementation of "user permissions". 
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /** 
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner. 
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to. 
34    */
35   function transferOwnership(address newOwner) onlyOwner {
36     require(newOwner != address(0));
37     owner = newOwner;
38   }
39 
40 }
41 
42 /**
43  * Math operations with safety checks
44  */
45 library SafeMath {
46   function mul(uint a, uint b) internal returns (uint) {
47     uint c = a * b;
48     assert(a == 0 || c / a == b);
49     return c;
50   }
51 
52   function div(uint a, uint b) internal returns (uint) {
53     // assert(b > 0); // Solidity automatically throws when dividing by 0
54     uint c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return c;
57   }
58 
59   function sub(uint a, uint b) internal returns (uint) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   function add(uint a, uint b) internal returns (uint) {
65     uint c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 
70   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
71     return a >= b ? a : b;
72   }
73 
74   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
75     return a < b ? a : b;
76   }
77 
78   function max256(uint a, uint b) internal constant returns (uint) {
79     return a >= b ? a : b;
80   }
81 
82   function min256(uint a, uint b) internal constant returns (uint) {
83     return a < b ? a : b;
84   }
85 }
86 
87 /**
88  * @title ERC20Basic
89  * @dev Simpler version of ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20Basic {
93   uint public totalSupply;
94   function balanceOf(address who) public constant returns (uint);
95   function transfer(address to, uint value) public returns (bool ok);
96   event Transfer(address indexed from, address indexed to, uint value);
97 }
98 
99 
100 /**
101  * @title ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/20
103  */
104 contract ERC20 is ERC20Basic {
105   function allowance(address owner, address spender) public constant returns (uint);
106   function transferFrom(address from, address to, uint value) public returns (bool ok);
107   function approve(address spender, uint value) public returns (bool ok);
108   event Approval(address indexed owner, address indexed spender, uint value);
109 }
110 
111 /**
112  * A token that defines fractional units as decimals.
113  */
114 contract FractionalERC20 is ERC20 {
115 
116   uint8 public decimals;
117 
118 }
119 
120 /**
121  * @title Basic token
122  * @dev Basic version of StandardToken, with no allowances. 
123  */
124 contract BasicToken is ERC20Basic {
125   using SafeMath for uint;
126 
127   mapping(address => uint) balances;
128 
129   /**
130    * Obsolete. Removed this check based on:
131    * https://blog.coinfabrik.com/smart-contract-short-address-attack-mitigation-failure/
132    * @dev Fix for the ERC20 short address attack.
133    *
134    * modifier onlyPayloadSize(uint size) {
135    *    require(msg.data.length >= size + 4);
136    *    _;
137    * }
138    */
139 
140   /**
141   * @dev transfer token for a specified address
142   * @param _to The address to transfer to.
143   * @param _value The amount to be transferred.
144   */
145   function transfer(address _to, uint _value) public returns (bool success) {
146     balances[msg.sender] = balances[msg.sender].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     Transfer(msg.sender, _to, _value);
149     return true;
150   }
151 
152   /**
153   * @dev Gets the balance of the specified address.
154   * @param _owner The address to query the the balance of. 
155   * @return An uint representing the amount owned by the passed address.
156   */
157   function balanceOf(address _owner) public constant returns (uint balance) {
158     return balances[_owner];
159   }
160   
161 }
162 
163 /**
164  * @title Standard ERC20 token
165  *
166  * @dev Implementation of the basic standard token.
167  * @dev https://github.com/ethereum/EIPs/issues/20
168  */
169 contract StandardToken is BasicToken, ERC20 {
170 
171   /* Token supply got increased and a new owner received these tokens */
172   event Minted(address receiver, uint amount);
173 
174   mapping (address => mapping (address => uint)) allowed;
175 
176   /* Interface declaration */
177   function isToken() public constant returns (bool weAre) {
178     return true;
179   }
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint the amout of tokens to be transfered
186    */
187   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
188     uint _allowance = allowed[_from][msg.sender];
189 
190     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
191     // require(_value <= _allowance);
192     // SafeMath uses assert instead of require though, beware when using an analysis tool
193 
194     balances[_to] = balances[_to].add(_value);
195     balances[_from] = balances[_from].sub(_value);
196     allowed[_from][msg.sender] = _allowance.sub(_value);
197     Transfer(_from, _to, _value);
198     return true;
199   }
200 
201   /**
202    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
203    * @param _spender The address which will spend the funds.
204    * @param _value The amount of tokens to be spent.
205    */
206   function approve(address _spender, uint _value) public returns (bool success) {
207 
208     // To change the approve amount you first have to reduce the addresses'
209     //  allowance to zero by calling `approve(_spender, 0)` if it is not
210     //  already 0 to mitigate the race condition described here:
211     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212     require (_value == 0 || allowed[msg.sender][_spender] == 0);
213 
214     allowed[msg.sender][_spender] = _value;
215     Approval(msg.sender, _spender, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Function to check the amount of tokens than an owner allowed to a spender.
221    * @param _owner address The address which owns the funds.
222    * @param _spender address The address which will spend the funds.
223    * @return A uint specifing the amount of tokens still avaible for the spender.
224    */
225   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
226     return allowed[_owner][_spender];
227   }
228 
229   /**
230    * Atomic increment of approved spending
231    *
232    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233    *
234    */
235   function addApproval(address _spender, uint _addedValue) public
236   returns (bool success) {
237       uint oldValue = allowed[msg.sender][_spender];
238       allowed[msg.sender][_spender] = oldValue.add(_addedValue);
239       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240       return true;
241   }
242 
243   /**
244    * Atomic decrement of approved spending.
245    *
246    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
247    */
248   function subApproval(address _spender, uint _subtractedValue) public
249   returns (bool success) {
250 
251       uint oldVal = allowed[msg.sender][_spender];
252 
253       if (_subtractedValue > oldVal) {
254           allowed[msg.sender][_spender] = 0;
255       } else {
256           allowed[msg.sender][_spender] = oldVal.sub(_subtractedValue);
257       }
258       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259       return true;
260   }
261   
262 }
263 
264 /**
265  * Define interface for releasing the token transfer after a successful crowdsale.
266  */
267 contract ReleasableToken is StandardToken, Ownable {
268 
269   /* The finalizer contract that allows lifting the transfer limits on this token */
270   address public releaseAgent;
271 
272   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
273   bool public released = false;
274 
275   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
276   mapping (address => bool) public transferAgents;
277 
278   /**
279    * Set the contract that can call release and make the token transferable.
280    *
281    * Since the owner of this contract is (or should be) the crowdsale,
282    * it can only be called by a corresponding exposed API in the crowdsale contract in case of input error.
283    */
284   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
285     // We don't do interface check here as we might want to have a normal wallet address to act as a release agent.
286     releaseAgent = addr;
287   }
288 
289   /**
290    * Owner can allow a particular address (e.g. a crowdsale contract) to transfer tokens despite the lock up period.
291    */
292   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
293     transferAgents[addr] = state;
294   }
295 
296   /**
297    * One way function to release the tokens into the wild.
298    *
299    * Can be called only from the release agent that should typically be the finalize agent ICO contract.
300    * In the scope of the crowdsale, it is only called if the crowdsale has been a success (first milestone reached).
301    */
302   function releaseTokenTransfer() public onlyReleaseAgent {
303     released = true;
304   }
305 
306   /**
307    * Limit token transfer until the crowdsale is over.
308    */
309   modifier canTransfer(address _sender) {
310     require(released || transferAgents[_sender]);
311     _;
312   }
313 
314   /** The function can be called only before or after the tokens have been released */
315   modifier inReleaseState(bool releaseState) {
316     require(releaseState == released);
317     _;
318   }
319 
320   /** The function can be called only by a whitelisted release agent. */
321   modifier onlyReleaseAgent() {
322     require(msg.sender == releaseAgent);
323     _;
324   }
325 
326   /** We restrict transfer by overriding it */
327   function transfer(address _to, uint _value) public canTransfer(msg.sender) returns (bool success) {
328     // Call StandardToken.transfer()
329    return super.transfer(_to, _value);
330   }
331 
332   /** We restrict transferFrom by overriding it */
333   function transferFrom(address _from, address _to, uint _value) public canTransfer(_from) returns (bool success) {
334     // Call StandardToken.transferForm()
335     return super.transferFrom(_from, _to, _value);
336   }
337 
338 }
339 
340 /**
341  * A token that can increase its supply by another contract.
342  *
343  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
344  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
345  *
346  */
347 contract MintableToken is StandardToken, Ownable {
348 
349   using SafeMath for uint;
350 
351   bool public mintingFinished = false;
352 
353   /** List of agents that are allowed to create new tokens */
354   mapping (address => bool) public mintAgents;
355 
356   event MintingAgentChanged(address addr, bool state);
357 
358 
359   function MintableToken(uint _initialSupply, address _multisig, bool _mintable) internal {
360     require(_multisig != address(0));
361     // Cannot create a token without supply and no minting
362     require(_mintable || _initialSupply != 0);
363     // Create initially all balance on the team multisig
364     if (_initialSupply > 0)
365         mintInternal(_multisig, _initialSupply);
366     // No more new supply allowed after the token creation
367     mintingFinished = !_mintable;
368   }
369 
370   /**
371    * Create new tokens and allocate them to an address.
372    *
373    * Only callable by a crowdsale contract (mint agent).
374    */
375   function mint(address receiver, uint amount) onlyMintAgent public {
376     mintInternal(receiver, amount);
377   }
378 
379   function mintInternal(address receiver, uint amount) canMint private {
380     totalSupply = totalSupply.add(amount);
381     balances[receiver] = balances[receiver].add(amount);
382 
383     // Removed because this may be confused with anonymous transfers in the upcoming fork.
384     // This will make the mint transaction appear in EtherScan.io
385     // We can remove this after there is a standardized minting event
386     // Transfer(0, receiver, amount);
387 
388     Minted(receiver, amount);
389   }
390 
391   /**
392    * Owner can allow a crowdsale contract to mint new tokens.
393    */
394   function setMintAgent(address addr, bool state) onlyOwner canMint public {
395     mintAgents[addr] = state;
396     MintingAgentChanged(addr, state);
397   }
398 
399   modifier onlyMintAgent() {
400     // Only mint agents are allowed to mint new tokens
401     require(mintAgents[msg.sender]);
402     _;
403   }
404 
405   /** Make sure we are not done yet. */
406   modifier canMint() {
407     require(!mintingFinished);
408     _;
409   }
410 }
411 
412 /**
413  * Upgrade agent transfers tokens to a new contract.
414  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
415  *
416  * The Upgrade agent is the interface used to implement a token
417  * migration in the case of an emergency.
418  * The function upgradeFrom has to implement the part of the creation
419  * of new tokens on behalf of the user doing the upgrade.
420  *
421  * The new token can implement this interface directly, or use.
422  */
423 contract UpgradeAgent {
424 
425   /** This value should be the same as the original token's total supply */
426   uint public originalSupply;
427 
428   /** Interface to ensure the contract is correctly configured */
429   function isUpgradeAgent() public constant returns (bool) {
430     return true;
431   }
432 
433   /**
434   Upgrade an account
435 
436   When the token contract is in the upgrade status the each user will
437   have to call `upgrade(value)` function from UpgradeableToken.
438 
439   The upgrade function adjust the balance of the user and the supply
440   of the previous token and then call `upgradeFrom(value)`.
441 
442   The UpgradeAgent is the responsible to create the tokens for the user
443   in the new contract.
444 
445   * @param _from Account to upgrade.
446   * @param _value Tokens to upgrade.
447 
448   */
449   function upgradeFrom(address _from, uint _value) public;
450 
451 }
452 
453 /**
454  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
455  *
456  */
457 contract UpgradeableToken is StandardToken {
458 
459   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
460   address public upgradeMaster;
461 
462   /** The next contract where the tokens will be migrated. */
463   UpgradeAgent public upgradeAgent;
464 
465   /** How many tokens we have upgraded by now. */
466   uint public totalUpgraded;
467 
468   /**
469    * Upgrade states.
470    *
471    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
472    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
473    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
474    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
475    *
476    */
477   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
478 
479   /**
480    * Somebody has upgraded some of his tokens.
481    */
482   event Upgrade(address indexed _from, address indexed _to, uint _value);
483 
484   /**
485    * New upgrade agent available.
486    */
487   event UpgradeAgentSet(address agent);
488 
489   /**
490    * Do not allow construction without upgrade master set.
491    */
492   function UpgradeableToken(address _upgradeMaster) {
493     setUpgradeMaster(_upgradeMaster);
494   }
495 
496   /**
497    * Allow the token holder to upgrade some of their tokens to a new contract.
498    */
499   function upgrade(uint value) public {
500     UpgradeState state = getUpgradeState();
501     // Ensure it's not called in a bad state
502     require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
503 
504     // Validate input value.
505     require(value != 0);
506 
507     balances[msg.sender] = balances[msg.sender].sub(value);
508 
509     // Take tokens out from circulation
510     totalSupply = totalSupply.sub(value);
511     totalUpgraded = totalUpgraded.add(value);
512 
513     // Upgrade agent reissues the tokens
514     upgradeAgent.upgradeFrom(msg.sender, value);
515     Upgrade(msg.sender, upgradeAgent, value);
516   }
517 
518   /**
519    * Set an upgrade agent that handles the upgrade process
520    */
521   function setUpgradeAgent(address agent) external {
522     // Check whether the token is in a state that we could think of upgrading
523     require(canUpgrade());
524 
525     require(agent != 0x0);
526     // Only a master can designate the next agent
527     require(msg.sender == upgradeMaster);
528     // Upgrade has already begun for an agent
529     require(getUpgradeState() != UpgradeState.Upgrading);
530 
531     upgradeAgent = UpgradeAgent(agent);
532 
533     // Bad interface
534     require(upgradeAgent.isUpgradeAgent());
535     // Make sure that token supplies match in source and target
536     require(upgradeAgent.originalSupply() == totalSupply);
537 
538     UpgradeAgentSet(upgradeAgent);
539   }
540 
541   /**
542    * Get the state of the token upgrade.
543    */
544   function getUpgradeState() public constant returns(UpgradeState) {
545     if (!canUpgrade()) return UpgradeState.NotAllowed;
546     else if (address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
547     else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
548     else return UpgradeState.Upgrading;
549   }
550 
551   /**
552    * Change the upgrade master.
553    *
554    * This allows us to set a new owner for the upgrade mechanism.
555    */
556   function changeUpgradeMaster(address new_master) public {
557     require(msg.sender == upgradeMaster);
558     setUpgradeMaster(new_master);
559   }
560 
561   /**
562    * Internal upgrade master setter.
563    */
564   function setUpgradeMaster(address new_master) private {
565     require(new_master != 0x0);
566     upgradeMaster = new_master;
567   }
568 
569   /**
570    * Child contract can enable to provide the condition when the upgrade can begin.
571    */
572   function canUpgrade() public constant returns(bool) {
573      return true;
574   }
575 
576 }
577 
578 
579 /**
580  * A crowdsale token.
581  *
582  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
583  *
584  * - The token transfer() is disabled until the crowdsale is over
585  * - The token contract gives an opt-in upgrade path to a new contract
586  * - The same token can be part of several crowdsales through the approve() mechanism
587  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
588  *
589  */
590 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken, FractionalERC20 {
591 
592   event UpdatedTokenInformation(string newName, string newSymbol);
593 
594   string public name;
595 
596   string public symbol;
597 
598   /**
599    * Construct the token.
600    *
601    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
602    *
603    * @param _name Token name
604    * @param _symbol Token symbol - typically it's all caps
605    * @param _initialSupply How many tokens we start with
606    * @param _decimals Number of decimal places
607    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
608    */
609   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint8 _decimals, address _multisig, bool _mintable)
610     UpgradeableToken(_multisig) MintableToken(_initialSupply, _multisig, _mintable) {
611     name = _name;
612     symbol = _symbol;
613     decimals = _decimals;
614   }
615 
616   /**
617    * When token is released to be transferable, prohibit new token creation.
618    */
619   function releaseTokenTransfer() public onlyReleaseAgent {
620     mintingFinished = true;
621     super.releaseTokenTransfer();
622   }
623 
624   /**
625    * Allow upgrade agent functionality to kick in only if the crowdsale was a success.
626    */
627   function canUpgrade() public constant returns(bool) {
628     return released && super.canUpgrade();
629   }
630 
631   /**
632    * Owner can update token information here
633    */
634   function setTokenInformation(string _name, string _symbol) onlyOwner {
635     name = _name;
636     symbol = _symbol;
637 
638     UpdatedTokenInformation(name, symbol);
639   }
640 
641 }