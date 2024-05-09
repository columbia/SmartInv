1 pragma solidity ^0.4.15;
2 
3 /** Github repository: https://github.com/CoinFabrik/ico/tree/hagglin-preico */
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control 
8  * functions, this simplifies the implementation of "user permissions". 
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   /** 
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   function Ownable() {
19     owner = msg.sender;
20   }
21 
22 
23   /**
24    * @dev Throws if called by any account other than the owner. 
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to. 
35    */
36   function transferOwnership(address newOwner) onlyOwner {
37     require(newOwner != address(0));
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * Math operations with safety checks
45  */
46 library SafeMath {
47   function mul(uint a, uint b) internal returns (uint) {
48     uint c = a * b;
49     assert(a == 0 || c / a == b);
50     return c;
51   }
52 
53   function div(uint a, uint b) internal returns (uint) {
54     // assert(b > 0); // Solidity automatically throws when dividing by 0
55     uint c = a / b;
56     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57     return c;
58   }
59 
60   function sub(uint a, uint b) internal returns (uint) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   function add(uint a, uint b) internal returns (uint) {
66     uint c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 
71   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
72     return a >= b ? a : b;
73   }
74 
75   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
76     return a < b ? a : b;
77   }
78 
79   function max256(uint a, uint b) internal constant returns (uint) {
80     return a >= b ? a : b;
81   }
82 
83   function min256(uint a, uint b) internal constant returns (uint) {
84     return a < b ? a : b;
85   }
86 }
87 
88 /**
89  * @title ERC20Basic
90  * @dev Simpler version of ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20Basic {
94   uint public totalSupply;
95   function balanceOf(address who) public constant returns (uint);
96   function transfer(address to, uint value) public returns (bool ok);
97   event Transfer(address indexed from, address indexed to, uint value);
98 }
99 
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 contract ERC20 is ERC20Basic {
106   function allowance(address owner, address spender) public constant returns (uint);
107   function transferFrom(address from, address to, uint value) public returns (bool ok);
108   function approve(address spender, uint value) public returns (bool ok);
109   event Approval(address indexed owner, address indexed spender, uint value);
110 }
111 
112 /**
113  * A token that defines fractional units as decimals.
114  */
115 contract FractionalERC20 is ERC20 {
116 
117   uint8 public decimals;
118 
119 }
120 
121 /**
122  * @title Basic token
123  * @dev Basic version of StandardToken, with no allowances. 
124  */
125 contract BasicToken is ERC20Basic {
126   using SafeMath for uint;
127 
128   mapping(address => uint) balances;
129 
130   /**
131    * Obsolete. Removed this check based on:
132    * https://blog.coinfabrik.com/smart-contract-short-address-attack-mitigation-failure/
133    * @dev Fix for the ERC20 short address attack.
134    *
135    * modifier onlyPayloadSize(uint size) {
136    *    require(msg.data.length >= size + 4);
137    *    _;
138    * }
139    */
140 
141   /**
142   * @dev transfer token for a specified address
143   * @param _to The address to transfer to.
144   * @param _value The amount to be transferred.
145   */
146   function transfer(address _to, uint _value) public returns (bool success) {
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of. 
156   * @return An uint representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) public constant returns (uint balance) {
159     return balances[_owner];
160   }
161   
162 }
163 
164 /**
165  * @title Standard ERC20 token
166  *
167  * @dev Implementation of the basic standard token.
168  * @dev https://github.com/ethereum/EIPs/issues/20
169  */
170 contract StandardToken is BasicToken, ERC20 {
171 
172   /* Token supply got increased and a new owner received these tokens */
173   event Minted(address receiver, uint amount);
174 
175   mapping (address => mapping (address => uint)) allowed;
176 
177   /* Interface declaration */
178   function isToken() public constant returns (bool weAre) {
179     return true;
180   }
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param _from address The address which you want to send tokens from
185    * @param _to address The address which you want to transfer to
186    * @param _value uint the amout of tokens to be transfered
187    */
188   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
189     uint _allowance = allowed[_from][msg.sender];
190 
191     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
192     // require(_value <= _allowance);
193     // SafeMath uses assert instead of require though, beware when using an analysis tool
194 
195     balances[_to] = balances[_to].add(_value);
196     balances[_from] = balances[_from].sub(_value);
197     allowed[_from][msg.sender] = _allowance.sub(_value);
198     Transfer(_from, _to, _value);
199     return true;
200   }
201 
202   /**
203    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
204    * @param _spender The address which will spend the funds.
205    * @param _value The amount of tokens to be spent.
206    */
207   function approve(address _spender, uint _value) public returns (bool success) {
208 
209     // To change the approve amount you first have to reduce the addresses'
210     //  allowance to zero by calling `approve(_spender, 0)` if it is not
211     //  already 0 to mitigate the race condition described here:
212     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
213     require (_value == 0 || allowed[msg.sender][_spender] == 0);
214 
215     allowed[msg.sender][_spender] = _value;
216     Approval(msg.sender, _spender, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Function to check the amount of tokens than an owner allowed to a spender.
222    * @param _owner address The address which owns the funds.
223    * @param _spender address The address which will spend the funds.
224    * @return A uint specifing the amount of tokens still avaible for the spender.
225    */
226   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
227     return allowed[_owner][_spender];
228   }
229 
230   /**
231    * Atomic increment of approved spending
232    *
233    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
234    *
235    */
236   function addApproval(address _spender, uint _addedValue) public
237   returns (bool success) {
238       uint oldValue = allowed[msg.sender][_spender];
239       allowed[msg.sender][_spender] = oldValue.add(_addedValue);
240       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241       return true;
242   }
243 
244   /**
245    * Atomic decrement of approved spending.
246    *
247    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
248    */
249   function subApproval(address _spender, uint _subtractedValue) public
250   returns (bool success) {
251 
252       uint oldVal = allowed[msg.sender][_spender];
253 
254       if (_subtractedValue > oldVal) {
255           allowed[msg.sender][_spender] = 0;
256       } else {
257           allowed[msg.sender][_spender] = oldVal.sub(_subtractedValue);
258       }
259       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260       return true;
261   }
262   
263 }
264 
265 /**
266  * Define interface for releasing the token transfer after a successful crowdsale.
267  */
268 contract ReleasableToken is StandardToken, Ownable {
269 
270   /* The finalizer contract that allows lifting the transfer limits on this token */
271   address public releaseAgent;
272 
273   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
274   bool public released = false;
275 
276   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
277   mapping (address => bool) public transferAgents;
278 
279   /**
280    * Set the contract that can call release and make the token transferable.
281    *
282    * Since the owner of this contract is (or should be) the crowdsale,
283    * it can only be called by a corresponding exposed API in the crowdsale contract in case of input error.
284    */
285   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
286     // We don't do interface check here as we might want to have a normal wallet address to act as a release agent.
287     releaseAgent = addr;
288   }
289 
290   /**
291    * Owner can allow a particular address (e.g. a crowdsale contract) to transfer tokens despite the lock up period.
292    */
293   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
294     transferAgents[addr] = state;
295   }
296 
297   /**
298    * One way function to release the tokens into the wild.
299    *
300    * Can be called only from the release agent that should typically be the finalize agent ICO contract.
301    * In the scope of the crowdsale, it is only called if the crowdsale has been a success (first milestone reached).
302    */
303   function releaseTokenTransfer() public onlyReleaseAgent {
304     released = true;
305   }
306 
307   /**
308    * Limit token transfer until the crowdsale is over.
309    */
310   modifier canTransfer(address _sender) {
311     require(released || transferAgents[_sender]);
312     _;
313   }
314 
315   /** The function can be called only before or after the tokens have been released */
316   modifier inReleaseState(bool releaseState) {
317     require(releaseState == released);
318     _;
319   }
320 
321   /** The function can be called only by a whitelisted release agent. */
322   modifier onlyReleaseAgent() {
323     require(msg.sender == releaseAgent);
324     _;
325   }
326 
327   /** We restrict transfer by overriding it */
328   function transfer(address _to, uint _value) public canTransfer(msg.sender) returns (bool success) {
329     // Call StandardToken.transfer()
330    return super.transfer(_to, _value);
331   }
332 
333   /** We restrict transferFrom by overriding it */
334   function transferFrom(address _from, address _to, uint _value) public canTransfer(_from) returns (bool success) {
335     // Call StandardToken.transferForm()
336     return super.transferFrom(_from, _to, _value);
337   }
338 
339 }
340 
341 /**
342  * A token that can increase its supply by another contract.
343  *
344  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
345  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
346  *
347  */
348 contract MintableToken is StandardToken, Ownable {
349 
350   using SafeMath for uint;
351 
352   bool public mintingFinished = false;
353 
354   /** List of agents that are allowed to create new tokens */
355   mapping (address => bool) public mintAgents;
356 
357   event MintingAgentChanged(address addr, bool state);
358 
359 
360   function MintableToken(uint _initialSupply, address _multisig, bool _mintable) internal {
361     require(_multisig != address(0));
362     // Cannot create a token without supply and no minting
363     require(_mintable || _initialSupply != 0);
364     // Create initially all balance on the team multisig
365     if (_initialSupply > 0)
366         mintInternal(_multisig, _initialSupply);
367     // No more new supply allowed after the token creation
368     mintingFinished = !_mintable;
369   }
370 
371   /**
372    * Create new tokens and allocate them to an address.
373    *
374    * Only callable by a crowdsale contract (mint agent).
375    */
376   function mint(address receiver, uint amount) onlyMintAgent public {
377     mintInternal(receiver, amount);
378   }
379 
380   function mintInternal(address receiver, uint amount) canMint private {
381     totalSupply = totalSupply.add(amount);
382     balances[receiver] = balances[receiver].add(amount);
383 
384     // This will make the mint transaction appear in EtherScan.io
385     // We can remove this after there is a standardized minting event
386     Transfer(0, receiver, amount);
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
578 /**
579  * A crowdsale token.
580  *
581  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
582  *
583  * - The token transfer() is disabled until the crowdsale is over
584  * - The token contract gives an opt-in upgrade path to a new contract
585  * - The same token can be part of several crowdsales through the approve() mechanism
586  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
587  *
588  */
589 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken, FractionalERC20 {
590 
591   event UpdatedTokenInformation(string newName, string newSymbol);
592 
593   string public name;
594 
595   string public symbol;
596 
597   /**
598    * Construct the token.
599    *
600    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
601    *
602    * @param _name Token name
603    * @param _symbol Token symbol - typically it's all caps
604    * @param _initialSupply How many tokens we start with
605    * @param _decimals Number of decimal places
606    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
607    */
608   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint8 _decimals, address _multisig, bool _mintable)
609     UpgradeableToken(_multisig) MintableToken(_initialSupply, _multisig, _mintable) {
610     name = _name;
611     symbol = _symbol;
612     decimals = _decimals;
613   }
614 
615   /**
616    * When token is released to be transferable, prohibit new token creation.
617    */
618   function releaseTokenTransfer() public onlyReleaseAgent {
619     mintingFinished = true;
620     super.releaseTokenTransfer();
621   }
622 
623   /**
624    * Allow upgrade agent functionality to kick in only if the crowdsale was a success.
625    */
626   function canUpgrade() public constant returns(bool) {
627     return released && super.canUpgrade();
628   }
629 
630   /**
631    * Owner can update token information here
632    */
633   function setTokenInformation(string _name, string _symbol) onlyOwner {
634     name = _name;
635     symbol = _symbol;
636 
637     UpdatedTokenInformation(name, symbol);
638   }
639 
640 }