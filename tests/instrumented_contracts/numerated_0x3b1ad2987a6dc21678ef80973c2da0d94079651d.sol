1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     uint256 public totalSupply;
11     function balanceOf(address who) public view returns (uint256);
12     function transfer(address to, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21     function allowance(address owner, address spender) public view returns (uint256);
22     function transferFrom(address from, address to, uint256 value) public returns (bool);
23     function approve(address spender, uint256 value) public returns (bool);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 /**
28  * Safe unsigned safe math.
29  *
30  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
31  *
32  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
33  *
34  * Maintained here until merged to mainline zeppelin-solidity.
35  *
36  */
37 library SafeMathLibExt {
38 
39     function times(uint a, uint b) public pure returns (uint) {
40         uint c = a * b;
41         assert(a == 0 || c / a == b);
42         return c;
43     }
44 
45     function divides(uint a, uint b) public pure returns (uint) {
46         assert(b > 0);
47         uint c = a / b;
48         assert(a == b * c + a % b);
49         return c;
50     }
51 
52     function minus(uint a, uint b) public pure returns (uint) {
53         assert(b <= a);
54         return a - b;
55     }
56 
57     function plus(uint a, uint b) public pure returns (uint) {
58         uint c = a + b;
59         assert(c >= a);
60         return c;
61     }
62 
63 }
64 
65 /**
66  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
67  *
68  * Based on code by FirstBlood:
69  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
70  */
71 contract StandardToken is ERC20 {
72 
73     using SafeMathLibExt for uint;
74     /* Token supply got increased and a new owner received these tokens */
75     event Minted(address receiver, uint amount);
76 
77     /* Actual balances of token holders */
78     mapping(address => uint) public balances;
79 
80     /* approve() allowances */
81     mapping (address => mapping (address => uint)) public allowed;
82 
83     /* Interface declaration */
84     function isToken() public pure returns (bool weAre) {
85         return true;
86     }
87 
88     function transfer(address _to, uint _value) public returns (bool success) {
89         balances[msg.sender] = balances[msg.sender].minus(_value);
90         balances[_to] = balances[_to].plus(_value);
91         emit Transfer(msg.sender, _to, _value);
92         return true;
93     }
94 
95     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
96         uint _allowance = allowed[_from][msg.sender];
97 
98         balances[_to] = balances[_to].plus(_value);
99         balances[_from] = balances[_from].minus(_value);
100         allowed[_from][msg.sender] = _allowance.minus(_value);
101         emit Transfer(_from, _to, _value);
102         return true;
103     }
104 
105     function balanceOf(address _owner) public view returns (uint balance) {
106         return balances[_owner];
107     }
108 
109     function approve(address _spender, uint _value) public returns (bool success) {
110 
111         // To change the approve amount you first have to reduce the addresses`
112         //  allowance to zero by calling `approve(_spender, 0)` if it is not
113         //  already 0 to mitigate the race condition described here:
114         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
115         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
116 
117         allowed[msg.sender][_spender] = _value;
118         emit Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122     function allowance(address _owner, address _spender) public view returns (uint remaining) {
123         return allowed[_owner][_spender];
124     }
125 
126 }
127 
128 /**
129  * Upgrade agent interface inspired by Lunyr.
130  *
131  * Upgrade agent transfers tokens to a new contract.
132  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
133  */
134 contract UpgradeAgent {
135 
136     uint public originalSupply;
137 
138     /** Interface marker */
139     function isUpgradeAgent() public pure returns (bool) {
140         return true;
141     }
142 
143     function upgradeFrom(address _from, uint256 _value) public;
144 
145 }
146 
147 /**
148  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
149  *
150  * First envisioned by Golem and Lunyr projects.
151  */
152 contract UpgradeableToken is StandardToken {
153 
154     /** Contract / person who can set the upgrade path. 
155         This can be the same as team multisig wallet, as what it is with its default value. */
156     address public upgradeMaster;
157 
158     /** The next contract where the tokens will be migrated. */
159     UpgradeAgent public upgradeAgent;
160 
161     /** How many tokens we have upgraded by now. */
162     uint256 public totalUpgraded;
163 
164     /**
165     * Upgrade states.
166     *
167     * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
168     * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
169     * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
170     * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
171     *
172     */
173     enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
174 
175     /**
176     * Somebody has upgraded some of his tokens.
177     */
178     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
179 
180     /**
181     * New upgrade agent available.
182     */
183     event UpgradeAgentSet(address agent);
184 
185     /**
186     * Do not allow construction without upgrade master set.
187     */
188     constructor(address _upgradeMaster) public {
189         upgradeMaster = _upgradeMaster;
190     }
191 
192     /**
193     * Allow the token holder to upgrade some of their tokens to a new contract.
194     */
195     function upgrade(uint256 value) public {
196 
197         UpgradeState state = getUpgradeState();
198         if (!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
199             // Called in a bad state
200             revert();
201         }
202 
203         // Validate input value.
204         if (value == 0) revert();
205 
206         balances[msg.sender] = balances[msg.sender].minus(value);
207 
208         // Take tokens out from circulation
209         totalSupply = totalSupply.minus(value);
210         totalUpgraded = totalUpgraded.plus(value);
211 
212         // Upgrade agent reissues the tokens
213         upgradeAgent.upgradeFrom(msg.sender, value);
214         emit Upgrade(msg.sender, upgradeAgent, value);
215     }
216 
217     /**
218     * Child contract can enable to provide the condition when the upgrade can begun.
219     */
220     function canUpgrade() public view returns(bool) {
221         return true;
222     }
223 
224     /**
225     * Set an upgrade agent that handles
226     */
227     function setUpgradeAgent(address agent) external {
228         if (!canUpgrade()) {
229             // The token is not yet in a state that we could think upgrading
230             revert();
231         }
232 
233         if (agent == 0x0) revert();
234         // Only a master can designate the next agent
235         if (msg.sender != upgradeMaster) revert();
236         // Upgrade has already begun for an agent
237         if (getUpgradeState() == UpgradeState.Upgrading) revert();
238 
239         upgradeAgent = UpgradeAgent(agent);
240 
241         // Bad interface
242         if (!upgradeAgent.isUpgradeAgent()) revert();      
243 
244         emit UpgradeAgentSet(upgradeAgent);
245     }
246 
247     /**
248     * Get the state of the token upgrade.
249     */
250     function getUpgradeState() public view returns(UpgradeState) {
251         if (!canUpgrade()) return UpgradeState.NotAllowed;
252         else if (address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
253         else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
254         else return UpgradeState.Upgrading;
255     }
256 
257     /**
258     * Change the upgrade master.
259     *
260     * This allows us to set a new owner for the upgrade mechanism.
261     */
262     function setUpgradeMaster(address master) public {
263         if (master == 0x0) revert();
264         if (msg.sender != upgradeMaster) revert();
265         upgradeMaster = master;
266     }
267 }
268 
269 /**
270  * @title Ownable
271  * @dev The Ownable contract has an owner address, and provides basic authorization control
272  * functions, this simplifies the implementation of "user permissions".
273  */
274 contract Ownable {
275     address public owner;
276 
277     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
278 
279     /**
280     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
281     * account.
282     */
283     constructor () public {
284         owner = msg.sender;
285     }
286 
287     /**
288     * @dev Throws if called by any account other than the owner.
289     */
290     modifier onlyOwner() {
291         require(msg.sender == owner);
292         _;
293     }
294 
295     /**
296     * @dev Allows the current owner to transfer control of the contract to a newOwner.
297     * @param newOwner The address to transfer ownership to.
298     */
299     function transferOwnership(address newOwner) public onlyOwner {
300         require(newOwner != address(0));
301         emit OwnershipTransferred(owner, newOwner);
302         owner = newOwner;
303     }
304 }
305 
306  /**
307   * Define interface for releasing the token transfer after a successful crowdsale.
308   */
309 contract ReleasableToken is ERC20, Ownable {
310 
311     /* The finalizer contract that allows unlift the transfer limits on this token */
312     address public releaseAgent;
313 
314     /** A crowdsale contract can release us to the wild if ICO success. 
315         If false we are are in transfer lock up period.*/
316     bool public released = false;
317 
318     /** Map of agents that are allowed to transfer tokens regardless of the lock down period. 
319         These are crowdsale contracts and possible the team multisig itself. */
320     mapping (address => bool) public transferAgents;
321 
322     /**
323     * Limit token transfer until the crowdsale is over.
324     *
325     */
326     modifier canTransfer(address _sender) {
327 
328         if (!released) {
329             if (!transferAgents[_sender]) {
330                 revert();
331             }
332         }
333         _;
334     }
335 
336     /**
337     * Set the contract that can call release and make the token transferable.
338     *
339     * Design choice. Allow reset the release agent to fix fat finger mistakes.
340     */
341     function setReleaseAgent(address addr) public onlyOwner inReleaseState(false) {
342         // We don't do interface check here as we might want to a normal wallet address to act as a release agent
343         releaseAgent = addr;
344     }
345 
346     /**
347     * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
348     */
349     function setTransferAgent(address addr, bool state) public onlyOwner inReleaseState(false) {
350         transferAgents[addr] = state;
351     }
352 
353     /**
354     * One way function to release the tokens to the wild.
355     *
356     * Can be called only from the release agent that is the final ICO contract. 
357     * It is only called if the crowdsale has been success (first milestone reached).
358     */
359     function releaseTokenTransfer() public onlyReleaseAgent {
360         released = true;
361     }
362 
363     /** The function can be called only before or after the tokens have been releasesd */
364     modifier inReleaseState(bool releaseState) {
365         if (releaseState != released) {
366             revert();
367         }
368         _;
369     }
370 
371     /** The function can be called only by a whitelisted release agent. */
372     modifier onlyReleaseAgent() {
373         if (msg.sender != releaseAgent) {
374             revert();
375         }
376         _;
377     }
378 
379     function transfer(address _to, uint _value) public canTransfer(msg.sender) returns (bool success) {
380         // Call StandardToken.transfer()
381         return super.transfer(_to, _value);
382     }
383 
384     function transferFrom(address _from, address _to, uint _value) public canTransfer(_from) returns (bool success) {
385         // Call StandardToken.transferForm()
386         return super.transferFrom(_from, _to, _value);
387     }
388 
389 }
390 
391 /**
392  * A token that can increase its supply by another contract.
393  *
394  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
395  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
396  *
397  */
398 contract MintableTokenExt is StandardToken, Ownable {
399 
400     using SafeMathLibExt for uint;
401 
402     bool public mintingFinished = false;
403 
404     /** List of agents that are allowed to create new tokens */
405     mapping (address => bool) public mintAgents;
406 
407     event MintingAgentChanged(address addr, bool state  );
408 
409     /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
410     * For example, for reserved tokens in percents 2.54%
411     * inPercentageUnit = 254
412     * inPercentageDecimals = 2
413     */
414     struct ReservedTokensData {
415         uint inTokens;
416         uint inPercentageUnit;
417         uint inPercentageDecimals;
418         bool isReserved;
419         bool isDistributed;
420         bool isVested;
421     }
422 
423     mapping (address => ReservedTokensData) public reservedTokensList;
424     address[] public reservedTokensDestinations;
425     uint public reservedTokensDestinationsLen = 0;
426     bool private reservedTokensDestinationsAreSet = false;
427 
428     modifier onlyMintAgent() {
429         // Only crowdsale contracts are allowed to mint new tokens
430         if (!mintAgents[msg.sender]) {
431             revert();
432         }
433         _;
434     }
435 
436     /** Make sure we are not done yet. */
437     modifier canMint() {
438         if (mintingFinished) revert();
439         _;
440     }
441 
442     function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
443         ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
444         reservedTokensData.isDistributed = true;
445     }
446 
447     function isAddressReserved(address addr) public view returns (bool isReserved) {
448         return reservedTokensList[addr].isReserved;
449     }
450 
451     function areTokensDistributedForAddress(address addr) public view returns (bool isDistributed) {
452         return reservedTokensList[addr].isDistributed;
453     }
454 
455     function getReservedTokens(address addr) public view returns (uint inTokens) {
456         return reservedTokensList[addr].inTokens;
457     }
458 
459     function getReservedPercentageUnit(address addr) public view returns (uint inPercentageUnit) {
460         return reservedTokensList[addr].inPercentageUnit;
461     }
462 
463     function getReservedPercentageDecimals(address addr) public view returns (uint inPercentageDecimals) {
464         return reservedTokensList[addr].inPercentageDecimals;
465     }
466 
467     function getReservedIsVested(address addr) public view returns (bool isVested) {
468         return reservedTokensList[addr].isVested;
469     }
470 
471     function setReservedTokensListMultiple(
472         address[] addrs, 
473         uint[] inTokens, 
474         uint[] inPercentageUnit, 
475         uint[] inPercentageDecimals,
476         bool[] isVested
477         ) public canMint onlyOwner {
478         assert(!reservedTokensDestinationsAreSet);
479         assert(addrs.length == inTokens.length);
480         assert(inTokens.length == inPercentageUnit.length);
481         assert(inPercentageUnit.length == inPercentageDecimals.length);
482         for (uint iterator = 0; iterator < addrs.length; iterator++) {
483             if (addrs[iterator] != address(0)) {
484                 setReservedTokensList(
485                     addrs[iterator],
486                     inTokens[iterator],
487                     inPercentageUnit[iterator],
488                     inPercentageDecimals[iterator],
489                     isVested[iterator]
490                     );
491             }
492         }
493         reservedTokensDestinationsAreSet = true;
494     }
495 
496     /**
497     * Create new tokens and allocate them to an address..
498     *
499     * Only callably by a crowdsale contract (mint agent).
500     */
501     function mint(address receiver, uint amount) public onlyMintAgent canMint {
502         totalSupply = totalSupply.plus(amount);
503         balances[receiver] = balances[receiver].plus(amount);
504 
505         // This will make the mint transaction apper in EtherScan.io
506         // We can remove this after there is a standardized minting event
507         emit Transfer(0, receiver, amount);
508     }
509 
510     /**
511     * Owner can allow a crowdsale contract to mint new tokens.
512     */
513     function setMintAgent(address addr, bool state) public onlyOwner canMint {
514         mintAgents[addr] = state;
515         emit MintingAgentChanged(addr, state);
516     }
517 
518     function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals,bool isVested) 
519     private canMint onlyOwner {
520         assert(addr != address(0));
521         if (!isAddressReserved(addr)) {
522             reservedTokensDestinations.push(addr);
523             reservedTokensDestinationsLen++;
524         }
525 
526         reservedTokensList[addr] = ReservedTokensData({
527             inTokens: inTokens,
528             inPercentageUnit: inPercentageUnit,
529             inPercentageDecimals: inPercentageDecimals,
530             isReserved: true,
531             isDistributed: false,
532             isVested:isVested
533         });
534     }
535 }
536 
537 /**
538  * A crowdsaled token.
539  *
540  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
541  *
542  * - The token transfer() is disabled until the crowdsale is over
543  * - The token contract gives an opt-in upgrade path to a new contract
544  * - The same token can be part of several crowdsales through approve() mechanism
545  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
546  *
547  */
548 contract CrowdsaleTokenExt is ReleasableToken, MintableTokenExt, UpgradeableToken {
549 
550     /** Name and symbol were updated. */
551     event UpdatedTokenInformation(string newName, string newSymbol);
552 
553     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
554 
555     string public name;
556 
557     string public symbol;
558 
559     uint public decimals;
560 
561     /* Minimum ammount of tokens every buyer can buy. */
562     uint public minCap;
563 
564     /**
565     * Construct the token.
566     *
567     * This token must be created through a team multisig wallet, so that it is owned by that wallet.
568     *
569     * @param _name Token name
570     * @param _symbol Token symbol - should be all caps
571     * @param _initialSupply How many tokens we start with
572     * @param _decimals Number of decimal places
573     * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? 
574     * Note that when the token becomes transferable the minting always ends.
575     */
576     constructor(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap) 
577     public UpgradeableToken(msg.sender) {
578 
579         // Create any address, can be transferred
580         // to team multisig via changeOwner(),
581         // also remember to call setUpgradeMaster()
582         owner = msg.sender;
583 
584         name = _name;
585         symbol = _symbol;
586 
587         totalSupply = _initialSupply;
588 
589         decimals = _decimals;
590 
591         minCap = _globalMinCap;
592 
593         // Create initially all balance on the team multisig
594         balances[owner] = totalSupply;
595 
596         if (totalSupply > 0) {
597             emit Minted(owner, totalSupply);
598         }
599 
600         // No more new supply allowed after the token creation
601         if (!_mintable) {
602             mintingFinished = true;
603             if (totalSupply == 0) {
604                 revert(); // Cannot create a token without supply and no minting
605             }
606         }
607     }
608 
609     /**
610     * When token is released to be transferable, enforce no new tokens can be created.
611     */
612     function releaseTokenTransfer() public onlyReleaseAgent {
613         mintingFinished = true;
614         super.releaseTokenTransfer();
615     }
616 
617     /**
618     * Allow upgrade agent functionality kick in only if the crowdsale was success.
619     */
620     function canUpgrade() public view returns(bool) {
621         return released && super.canUpgrade();
622     }
623 
624     /**
625     * Owner can update token information here.
626     *
627     * It is often useful to conceal the actual token association, until
628     * the token operations, like central issuance or reissuance have been completed.
629     *
630     * This function allows the token owner to rename the token after the operations
631     * have been completed and then point the audience to use the token contract.
632     */
633     function setTokenInformation(string _name, string _symbol) public onlyOwner {
634         name = _name;
635         symbol = _symbol;
636 
637         emit UpdatedTokenInformation(name, symbol);
638     }
639 
640     /**
641     * Claim tokens that were accidentally sent to this contract.
642     *
643     * @param _token The address of the token contract that you want to recover.
644     */
645     function claimTokens(address _token) public onlyOwner {
646         require(_token != address(0));
647 
648         ERC20 token = ERC20(_token);
649         uint balance = token.balanceOf(this);
650         token.transfer(owner, balance);
651 
652         emit ClaimedTokens(_token, owner, balance);
653     }
654 
655 }
656 
657 /**
658  * A crowdsaled token.
659  *
660  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
661  *
662  * - The token transfer() is disabled until the crowdsale is over
663  * - The token contract gives an opt-in upgrade path to a new contract
664  * - The same token can be part of several crowdsales through approve() mechanism
665  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
666  *
667  */
668 contract CrowdsaleTokenExtv1 is CrowdsaleTokenExt {
669 
670     uint public originalSupply;
671 
672     address public oldTokenAddress;
673 
674     bool public isUpgradeAgent = false;
675     /**
676     * Construct the token.
677     *
678     * This token must be created through a team multisig wallet, so that it is owned by that wallet.
679     *
680     * @param _name Token name
681     * @param _symbol Token symbol - should be all caps
682     * @param _initialSupply How many tokens we start with
683     * @param _decimals Number of decimal places
684     * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? 
685     * Note that when the token becomes transferable the minting always ends.
686     */
687     constructor(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, 
688     uint _globalMinCap, address _oldTokenAddress, uint _originalSupply) 
689     public CrowdsaleTokenExt(_name, _symbol, _initialSupply, _decimals, _mintable, _globalMinCap) {    
690         originalSupply = _originalSupply;
691         oldTokenAddress = _oldTokenAddress;
692         isUpgradeAgent = true;    
693     }
694 
695     function upgradeFrom(address _from, uint256 value) public {
696         // Make sure the call is from old token contract
697         require(msg.sender == oldTokenAddress);
698         // Validate input value.
699         balances[_from] = balances[_from].plus(value);
700         // Take tokens out from circulation
701         totalSupply = totalSupply.plus(value);
702     }
703 
704 }