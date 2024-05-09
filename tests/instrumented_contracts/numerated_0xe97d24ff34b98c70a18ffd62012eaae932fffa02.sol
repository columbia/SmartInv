1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * Safe unsigned safe math.
37  *
38  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
39  *
40  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
41  *
42  * Maintained here until merged to mainline zeppelin-solidity.
43  *
44  */
45 library SafeMathLib {
46 
47   function times(uint a, uint b) internal pure returns (uint) {
48     uint c = a * b;
49     assert(a == 0 || c / a == b);
50     return c;
51   }
52 
53   function minus(uint a, uint b) internal pure returns (uint) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   function plus(uint a, uint b) internal pure returns (uint) {
59     uint c = a + b;
60     assert(c>=a);
61     return c;
62   }
63 
64 }
65 
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73   address public owner;
74 
75 
76   /**
77    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78    * account.
79    */
80   function Ownable() public {
81     owner = msg.sender;
82   }
83 
84 
85   /**
86    * @dev Throws if called by any account other than the owner.
87    */
88   modifier onlyOwner() {
89     require(msg.sender == owner);
90     _;
91   }
92 
93 
94   /**
95    * @dev Allows the current owner to transfer control of the contract to a newOwner.
96    * @param newOwner The address to transfer ownership to.
97    */
98   function transferOwnership(address newOwner) public onlyOwner {
99     require(newOwner != address(0));
100     owner = newOwner;
101   }
102 
103 }
104 
105 
106 /**
107  * @title ERC20Basic
108  * @dev Simpler version of ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/179
110  */
111 contract ERC20Basic {
112   uint256 public totalSupply;
113   function balanceOf(address who) constant public returns (uint256);
114   function transfer(address to, uint256 value) public returns (bool);
115   event Transfer(address indexed from, address indexed to, uint256 value);
116 }
117 
118 
119 /**
120  * @title ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/20
122  */
123 contract ERC20 is ERC20Basic {
124   function allowance(address owner, address spender) public constant returns (uint256);
125   function transferFrom(address from, address to, uint256 value) public returns (bool);
126   function approve(address spender, uint256 value) public returns (bool);
127   event Approval(address indexed owner, address indexed spender, uint256 value);
128 }
129 
130 
131 /**
132  * @title Basic token
133  * @dev Basic version of StandardToken, with no allowances.
134  */
135 contract BasicToken is ERC20Basic {
136   using SafeMath for uint256;
137 
138   mapping(address => uint256) balances;
139 
140   /**
141    * @dev transfer token for a specified address
142    * @param _to The address to transfer to.
143    * @param _value The amount to be transferred.
144    */
145   function transfer(address _to, uint256 _value) public returns (bool) {
146     balances[msg.sender] = balances[msg.sender].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     Transfer(msg.sender, _to, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Gets the balance of the specified address.
154    * @param _owner The address to query the the balance of.
155    * @return An uint256 representing the amount owned by the passed address.
156    */
157   function balanceOf(address _owner) view public returns (uint256 balance) {
158     return balances[_owner];
159   }
160 
161 }
162 
163 
164 /**
165  * @title Standard ERC20 token
166  *
167  * @dev Implementation of the basic standard token.
168  * @dev https://github.com/ethereum/EIPs/issues/20
169  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
170  */
171 contract StandardToken is ERC20, BasicToken {
172 
173   mapping (address => mapping (address => uint256)) allowed;
174 
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param _from address The address which you want to send tokens from
179    * @param _to address The address which you want to transfer to
180    * @param _value uint256 the amout of tokens to be transfered
181    */
182   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
183     var _allowance = allowed[_from][msg.sender];
184 
185     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
186     require(_value <= _allowance);
187 
188     balances[_to] = balances[_to].add(_value);
189     balances[_from] = balances[_from].sub(_value);
190     allowed[_from][msg.sender] = _allowance.sub(_value);
191     Transfer(_from, _to, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
197    * @param _spender The address which will spend the funds.
198    * @param _value The amount of tokens to be spent.
199    */
200   function approve(address _spender, uint256 _value) public returns (bool) {
201 
202     // To change the approve amount you first have to reduce the addresses`
203     //  allowance to zero by calling `approve(_spender, 0)` if it is not
204     //  already 0 to mitigate the race condition described here:
205     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
207 
208     allowed[msg.sender][_spender] = _value;
209     Approval(msg.sender, _spender, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Function to check the amount of tokens that an owner allowed to a spender.
215    * @param _owner address The address which owns the funds.
216    * @param _spender address The address which will spend the funds.
217    * @return A uint256 specifing the amount of tokens still available for the spender.
218    */
219   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
220     return allowed[_owner][_spender];
221   }
222 
223 }
224 
225 
226 /**
227  * Standard EIP-20 token with an interface marker.
228  *
229  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
230  *
231  */
232 contract StandardTokenExt is StandardToken {
233 
234   /* Interface declaration */
235   function isToken() public pure returns (bool weAre) {
236     return true;
237   }
238 }
239 
240 
241 /**
242  * Define interface for releasing the token transfer after a successful crowdsale.
243  */
244 contract ReleasableToken is ERC20, Ownable {
245 
246   /* The finalizer contract that allows unlift the transfer limits on this token */
247   address public releaseAgent;
248 
249   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
250   bool public released = false;
251 
252   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
253   mapping (address => bool) public transferAgents;
254 
255   /**
256    * Limit token transfer until the crowdsale is over.
257    *
258    */
259   modifier canTransfer(address _sender) {
260 
261     if(!released) {
262       require(transferAgents[_sender]);
263     }
264 
265     _;
266   }
267 
268   /**
269    * Set the contract that can call release and make the token transferable.
270    *
271    * Design choice. Allow reset the release agent to fix fat finger mistakes.
272    */
273   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
274 
275     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
276     releaseAgent = addr;
277   }
278 
279   /**
280    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
281    */
282   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
283     transferAgents[addr] = state;
284   }
285 
286   /**
287    * One way function to release the tokens to the wild.
288    *
289    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
290    */
291   function releaseTokenTransfer() public onlyReleaseAgent {
292     released = true;
293   }
294 
295   /** The function can be called only before or after the tokens have been releasesd */
296   modifier inReleaseState(bool releaseState) {
297     require(releaseState == released);
298     _;
299   }
300 
301   /** The function can be called only by a whitelisted release agent. */
302   modifier onlyReleaseAgent() {
303     require(msg.sender == releaseAgent);
304     _;
305   }
306 
307   function transfer(address _to, uint _value) canTransfer(msg.sender) public returns (bool success) {
308     // Call StandardToken.transfer()
309     return super.transfer(_to, _value);
310   }
311 
312   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) public returns (bool success) {
313     // Call StandardToken.transferForm()
314     return super.transferFrom(_from, _to, _value);
315   }
316 
317 }
318 
319 
320 /**
321  * A token that can increase its supply by another contract.
322  *
323  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
324  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
325  *
326  */
327 contract MintableToken is StandardTokenExt, Ownable {
328 
329   using SafeMathLib for uint;
330 
331   bool public mintingFinished = false;
332 
333   /** List of agents that are allowed to create new tokens */
334   mapping (address => bool) public mintAgents;
335 
336   event MintingAgentChanged(address addr, bool state);
337   event Minted(address receiver, uint amount);
338 
339   /**
340    * Create new tokens and allocate them to an address..
341    *
342    * Only callably by a crowdsale contract (mint agent).
343    */
344   function mint(address receiver, uint amount) onlyMintAgent canMint public {
345     totalSupply = totalSupply.plus(amount);
346     balances[receiver] = balances[receiver].plus(amount);
347 
348     // This will make the mint transaction apper in EtherScan.io
349     // We can remove this after there is a standardized minting event
350     Transfer(0, receiver, amount);
351   }
352 
353   /**
354    * Owner can allow a crowdsale contract to mint new tokens.
355    */
356   function setMintAgent(address addr, bool state) onlyOwner canMint public {
357     mintAgents[addr] = state;
358     MintingAgentChanged(addr, state);
359   }
360 
361   modifier onlyMintAgent() {
362     // Only crowdsale contracts are allowed to mint new tokens
363     require(mintAgents[msg.sender]);
364     _;
365   }
366 
367   /** Make sure we are not done yet. */
368   modifier canMint() {
369     require(!mintingFinished);
370     _;
371   }
372 }
373 
374 
375 /**
376  * Upgrade agent interface inspired by Lunyr.
377  *
378  * Upgrade agent transfers tokens to a new contract.
379  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
380  */
381 contract UpgradeAgent {
382 
383   uint public originalSupply;
384 
385   /** Interface marker */
386   function isUpgradeAgent() public pure returns (bool) {
387     return true;
388   }
389 
390   function upgradeFrom(address _from, uint256 _value) public;
391 
392 }
393 
394 
395 /**
396  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
397  *
398  * First envisioned by Golem and Lunyr projects.
399  */
400 contract UpgradeableToken is StandardTokenExt {
401 
402   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
403   address public upgradeMaster;
404 
405   /** The next contract where the tokens will be migrated. */
406   UpgradeAgent public upgradeAgent;
407 
408   /** How many tokens we have upgraded by now. */
409   uint256 public totalUpgraded;
410 
411   /**
412    * Upgrade states.
413    *
414    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
415    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
416    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
417    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
418    *
419    */
420   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
421 
422   /**
423    * Somebody has upgraded some of his tokens.
424    */
425   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
426 
427   /**
428    * New upgrade agent available.
429    */
430   event UpgradeAgentSet(address agent);
431 
432   /**
433    * Do not allow construction without upgrade master set.
434    */
435   function UpgradeableToken(address _upgradeMaster) public {
436     upgradeMaster = _upgradeMaster;
437   }
438 
439   /**
440    * Allow the token holder to upgrade some of their tokens to a new contract.
441    */
442   function upgrade(uint256 value) public {
443 
444     UpgradeState state = getUpgradeState();
445     // Called in a bad state
446     require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
447 
448     // Validate input value.
449     require(value != 0);
450 
451     balances[msg.sender] = balances[msg.sender].sub(value);
452 
453     // Take tokens out from circulation
454     totalSupply = totalSupply.sub(value);
455     totalUpgraded = totalUpgraded.add(value);
456 
457     // Upgrade agent reissues the tokens
458     upgradeAgent.upgradeFrom(msg.sender, value);
459     Upgrade(msg.sender, upgradeAgent, value);
460   }
461 
462   /**
463    * Set an upgrade agent that handles
464    */
465   function setUpgradeAgent(address agent) external {
466 
467     // The token is not yet in a state that we could think upgrading
468     /* require(canUpgrade()); */
469 
470     require(agent != 0x0);
471     // Only a master can designate the next agent
472     require(msg.sender == upgradeMaster);
473     // Upgrade has already begun for an agent
474     require(getUpgradeState() != UpgradeState.Upgrading);
475 
476     upgradeAgent = UpgradeAgent(agent);
477 
478     // Bad interface
479     require(upgradeAgent.isUpgradeAgent());
480     // Make sure that token supplies match in source and target
481     require(upgradeAgent.originalSupply() == totalSupply);
482 
483     UpgradeAgentSet(upgradeAgent);
484   }
485 
486   /**
487    * Get the state of the token upgrade.
488    */
489   function getUpgradeState() public constant returns(UpgradeState) {
490     if(false) return UpgradeState.NotAllowed;
491     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
492     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
493     else return UpgradeState.Upgrading;
494   }
495 
496   /**
497    * Change the upgrade master.
498    *
499    * This allows us to set a new owner for the upgrade mechanism.
500    */
501   function setUpgradeMaster(address master) public {
502     require(master != 0x0);
503     require(msg.sender == upgradeMaster);
504     upgradeMaster = master;
505   }
506   /**
507    * Child contract can enable to provide the condition when the upgrade can begun.
508    */
509   /* conflict with CrowdsaleToken.canUpgrade */
510   /* function canUpgrade() public returns(bool) { */
511   /*    return true; */
512   /* } */
513 
514 }
515 
516 
517 /**
518  * A crowdsaled token.
519  *
520  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
521  *
522  * - The token transfer() is disabled until the crowdsale is over
523  * - The token contract gives an opt-in upgrade path to a new contract
524  * - The same token can be part of several crowdsales through approve() mechanism
525  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
526  *
527  */
528 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
529 
530   /** Name and symbol were updated. */
531   event UpdatedTokenInformation(string newName, string newSymbol);
532 
533   string public name;
534 
535   string public symbol;
536 
537   uint public decimals;
538 
539   /**
540    * Construct the token.
541    *
542    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
543    *
544    * @param _name Token name
545    * @param _symbol Token symbol - should be all caps
546    * @param _initialSupply How many tokens we start with
547    * @param _decimals Number of decimal places
548    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
549    */
550   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable) public
551     UpgradeableToken(msg.sender) {
552 
553     // Create any address, can be transferred
554     // to team multisig via changeOwner(),
555     // also remember to call setUpgradeMaster()
556     owner = msg.sender;
557 
558     name = _name;
559     symbol = _symbol;
560 
561     totalSupply = _initialSupply;
562 
563     decimals = _decimals;
564 
565     // Create initially all balance on the team multisig
566     balances[owner] = totalSupply;
567 
568     if(totalSupply > 0) {
569       Minted(owner, totalSupply);
570     }
571 
572     // No more new supply allowed after the token creation
573     if(!_mintable) {
574       mintingFinished = true;
575       require(totalSupply != 0);  // Cannot create a token without supply and no minting
576     }
577   }
578 
579   /**
580    * When token is released to be transferable, enforce no new tokens can be created.
581    */
582   function releaseTokenTransfer() public onlyReleaseAgent {
583     mintingFinished = true;
584     super.releaseTokenTransfer();
585   }
586 
587   /**
588    * Allow upgrade agent functionality kick in only if the crowdsale was success.
589    */
590   function canUpgrade() public view returns(bool) {
591     return released;
592     /* return released && super.canUpgrade(); */
593   }
594 
595   /**
596    * Set an upgrade agent that handles
597    */
598   function setUpgradeAgent(address agent) external {
599 
600     // The token is not yet in a state that we could think upgrading
601     require(canUpgrade());
602 
603     require(agent != 0x0);
604     // Only a master can designate the next agent
605     require(msg.sender == upgradeMaster);
606     // Upgrade has already begun for an agent
607     require(getUpgradeState() != UpgradeState.Upgrading);
608 
609     upgradeAgent = UpgradeAgent(agent);
610 
611     // Bad interface
612     require(upgradeAgent.isUpgradeAgent());
613     // Make sure that token supplies match in source and target
614     require(upgradeAgent.originalSupply() == totalSupply);
615 
616     UpgradeAgentSet(upgradeAgent);
617   }
618 
619   /**
620    * Owner can update token information here.
621    *
622    * It is often useful to conceal the actual token association, until
623    * the token operations, like central issuance or reissuance have been completed.
624    *
625    * This function allows the token owner to rename the token after the operations
626    * have been completed and then point the audience to use the token contract.
627    */
628   function setTokenInformation(string _name, string _symbol) public onlyOwner {
629     name = _name;
630     symbol = _symbol;
631 
632     UpdatedTokenInformation(name, symbol);
633   }
634 
635 }
636 
637 contract PPNToken is CrowdsaleToken {
638   uint public maximumSupply;
639 
640   function PPNToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _maximumSupply) public
641     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
642     maximumSupply = _maximumSupply;
643   }
644 
645   /**
646    * Throws if tokens will exceed maximum supply
647    */
648   modifier notExceedMaximumSupply(uint amount) {
649     require(totalSupply.plus(amount) <= maximumSupply);
650     _;
651   }
652 
653   /**
654    * Create new tokens and allocate them to an address..
655    *
656    * Only callably by a crowdsale contract (mint agent).
657    */
658   function mint(address receiver, uint amount) notExceedMaximumSupply(amount) public {
659     super.mint(receiver, amount);
660   }
661 }