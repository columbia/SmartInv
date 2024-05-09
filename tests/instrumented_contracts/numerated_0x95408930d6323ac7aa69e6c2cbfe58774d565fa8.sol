1 pragma solidity ^0.4.13;
2 
3 /*
4     Overflow protected math functions
5 */
6 contract SafeMath {
7     /**
8         constructor
9     */
10     function SafeMath() {
11     }
12 
13     /**
14         @dev returns the sum of _x and _y, asserts if the calculation overflows
15 
16         @param _x   value 1
17         @param _y   value 2
18 
19         @return sum
20     */
21     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
22         uint256 z = _x + _y;
23         assert(z >= _x);
24         return z;
25     }
26 
27     /**
28         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
29 
30         @param _x   minuend
31         @param _y   subtrahend
32 
33         @return difference
34     */
35     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
36         assert(_x >= _y);
37         return _x - _y;
38     }
39 
40     /**
41         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
42 
43         @param _x   factor 1
44         @param _y   factor 2
45 
46         @return product
47     */
48     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
49         uint256 z = _x * _y;
50         assert(_x == 0 || z / _x == _y);
51         return z;
52     }
53 } 
54 
55 /*
56     Owned contract interface
57 */
58 contract IOwned {
59     // this function isn't abstract since the compiler emits automatically generated getter functions as external
60     function owner() public constant returns (address owner) { owner; }
61 
62     function transferOwnership(address _newOwner) public;
63     function acceptOwnership() public;
64 }
65 
66 /*
67     Provides support and utilities for contract ownership
68 */
69 contract Owned is IOwned {
70     address public owner;
71     address public newOwner;
72 
73     event OwnerUpdate(address _prevOwner, address _newOwner);
74 
75     /**
76         @dev constructor
77     */
78     function Owned() {
79         owner = msg.sender;
80     }
81 
82     // allows execution by the owner only
83     modifier ownerOnly {
84         assert(msg.sender == owner);
85         _;
86     }
87 
88     /**
89         @dev allows transferring the contract ownership
90         the new owner still need to accept the transfer
91         can only be called by the contract owner
92 
93         @param _newOwner    new contract owner
94     */
95     function transferOwnership(address _newOwner) public ownerOnly {
96         require(_newOwner != owner);
97         newOwner = _newOwner;
98     }
99 
100     /**
101         @dev used by a new owner to accept an ownership transfer
102     */
103     function acceptOwnership() public {
104         require(msg.sender == newOwner);
105         OwnerUpdate(owner, newOwner);
106         owner = newOwner;
107         newOwner = 0x0;
108     }
109 }
110 
111 /*
112     Token Holder interface
113 */
114 contract ITokenHolder is IOwned {
115     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
116 }
117 
118 /*
119     We consider every contract to be a 'token holder' since it's currently not possible
120     for a contract to deny receiving tokens.
121 
122     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
123     the owner to send tokens that were sent to the contract by mistake back to their sender.
124 */
125 contract TokenHolder is ITokenHolder, Owned {
126     /**
127         @dev constructor
128     */
129     function TokenHolder() {
130     }
131 
132     // validates an address - currently only checks that it isn't null
133     modifier validAddress(address _address) {
134         require(_address != 0x0);
135         _;
136     }
137     // since v0.4.12 of compiler we need this 
138     modifier validAddressForSecond(address _address) {
139         require(_address != 0x0);
140         _;
141     }
142 
143     // verifies that the address is different than this contract address
144     modifier notThis(address _address) {
145         require(_address != address(this));
146         _;
147     }
148 
149     /**
150         @dev withdraws tokens held by the contract and sends them to an account
151         can only be called by the owner
152 
153         @param _token   ERC20 token contract address
154         @param _to      account to receive the new amount
155         @param _amount  amount to withdraw
156     */
157     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
158         public
159         ownerOnly
160         validAddress(_token)
161         validAddressForSecond(_to)
162         notThis(_to)
163     {
164         assert(_token.transfer(_to, _amount));
165     }
166 }
167 
168 /*
169     ERC20 Standard Token interface
170 */
171 contract IERC20Token {
172     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
173     function name() public constant returns (string name) { name; }
174     function symbol() public constant returns (string symbol) { symbol; }
175     function decimals() public constant returns (uint8 decimals) { decimals; }
176     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
177     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
178     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
179     function transfer(address _to, uint256 _value) public returns (bool success);
180     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
181     function approve(address _spender, uint256 _value) public returns (bool success);
182 }
183 
184 /**
185     ERC20 Standard Token implementation
186 */
187 contract ERC20Token is IERC20Token, SafeMath {
188     string public standard = 'Token 0.1';
189     string public name = 'DEBIT Coin Token';
190     string public symbol = 'DBC';
191     uint8 public decimals = 8;
192     uint256 public totalSupply = 0;
193     mapping (address => uint256) public balanceOf;
194     mapping (address => mapping (address => uint256)) public allowance;
195 
196     event Transfer(address indexed _from, address indexed _to, uint256 _value);
197     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
198 
199     /**
200         @dev constructor
201 
202         @param _name        token name
203         @param _symbol      token symbol
204         @param _decimals    decimal points, for display purposes
205     */
206     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
207         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
208 
209         name = _name;
210         symbol = _symbol;
211         decimals = _decimals;
212     }
213 
214     // validates an address - currently only checks that it isn't null
215     modifier validAddress(address _address) {
216         require(_address != 0x0);
217         _;
218     }
219     
220     // since v0.4.12 compiler we need this 
221     modifier validAddressForSecond(address _address) {
222         require(_address != 0x0);
223         _;
224     }
225 
226     /**
227         @dev send coins
228         throws on any error rather then return a false flag to minimize user errors
229 
230         @param _to      target address
231         @param _value   transfer amount
232 
233         @return true if the transfer was successful, false if it wasn't
234     */
235     function transfer(address _to, uint256 _value)
236         public
237         validAddress(_to)
238         returns (bool success)
239     {
240         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
241         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
242         Transfer(msg.sender, _to, _value);
243         return true;
244     }
245 
246     /**
247         @dev an account/contract attempts to get the coins
248         throws on any error rather then return a false flag to minimize user errors
249 
250         @param _from    source address
251         @param _to      target address
252         @param _value   transfer amount
253 
254         @return true if the transfer was successful, false if it wasn't
255     */
256     function transferFrom(address _from, address _to, uint256 _value)
257         public
258         validAddress(_from)
259         validAddressForSecond(_to)
260         returns (bool success)
261     {
262         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
263         balanceOf[_from] = safeSub(balanceOf[_from], _value);
264         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
265         Transfer(_from, _to, _value);
266         return true;
267     }
268 
269     /**
270         @dev allow another account/contract to spend some tokens on your behalf
271         throws on any error rather then return a false flag to minimize user errors
272 
273         also, to minimize the risk of the approve/transferFrom attack vector
274         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
275         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
276 
277         @param _spender approved address
278         @param _value   allowance amount
279 
280         @return true if the approval was successful, false if it wasn't
281     */
282     function approve(address _spender, uint256 _value)
283         public
284         validAddress(_spender)
285         returns (bool success)
286     {
287         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
288         require(_value == 0 || allowance[msg.sender][_spender] == 0);
289 
290         allowance[msg.sender][_spender] = _value;
291         Approval(msg.sender, _spender, _value);
292         return true;
293     }
294 }
295 
296 /*
297     DEBITCoin Token interface
298 */
299 contract IDebitCoinToken is ITokenHolder, IERC20Token {
300     function disableTransfers(bool _disable) public;
301     function issue(address _to, uint256 _amount) public;
302     function destroy(address _from, uint256 _amount) public;
303 }
304 
305 /*
306     DEBITCoin Token v0.2
307 
308     'Owned' is specified here for readability reasons
309 */
310 contract DebitCoinToken is IDebitCoinToken, ERC20Token, Owned, TokenHolder {
311     string public version = '0.2';
312 
313     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
314     uint public MiningRewardPerETHBlock = 5;  // define amount of reaward in DEBITCoin, for miner that found last block in Ethereum BlockChain
315     uint public lastBlockRewarded;
316     
317     // triggered when a DEBITCoin token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
318     event DebitCoinTokenGenesis(address _token);
319     // triggered when the total supply is increased
320     event Issuance(uint256 _amount);
321     // triggered when the total supply is decreased
322     event Destruction(uint256 _amount);
323     // triggered when the amount of reaward for mining are changesd
324     event MiningRewardChanged(uint256 _amount);
325     // triggered when miner get a reward
326     event MiningRewardSent(address indexed _from, address indexed _to, uint256 _value);
327 
328     /**
329         @dev constructor
330 
331         @param _name       token name
332         @param _symbol     token short symbol, 1-6 characters
333         @param _decimals   for display purposes only
334     */
335     function DebitCoinToken(string _name, string _symbol, uint8 _decimals)
336         ERC20Token(_name, _symbol, _decimals)
337     {
338         require(bytes(_symbol).length <= 6); // validate input
339         DebitCoinTokenGenesis(address(this));
340     }
341 
342     // allows execution only when transfers aren't disabled
343     modifier transfersAllowed {
344         assert(transfersEnabled);
345         _;
346     }
347 
348     /**
349         @dev disables/enables transfers
350         can only be called by the contract owner
351 
352         @param _disable    true to disable transfers, false to enable them
353     */
354     function disableTransfers(bool _disable) public ownerOnly {
355         transfersEnabled = !_disable;
356     }
357 
358     /**
359         @dev anyone who finds a block on ethereum would also get a reward in 
360         DEBITCoin, given that anyone calls the reward function on that block
361     */
362     function TransferMinersReward() {
363         require(lastBlockRewarded < block.number);
364         lastBlockRewarded = block.number;
365         totalSupply = safeAdd(totalSupply, MiningRewardPerETHBlock);
366         balanceOf[block.coinbase] = safeAdd(balanceOf[block.coinbase], MiningRewardPerETHBlock);
367         MiningRewardSent(this, block.coinbase, MiningRewardPerETHBlock);
368     }
369     
370     /**
371         @dev change miners reward
372         can only be called by the contract owner
373 
374         @param _amount    amount to increase the supply by
375     */
376     function ChangeMiningReward(uint256 _amount) public ownerOnly {
377         MiningRewardPerETHBlock = _amount;
378         MiningRewardChanged(_amount);
379     }
380     
381     /**
382         @dev increases the token supply and sends the new tokens to an account
383         can only be called by the contract owner
384 
385         @param _to         account to receive the new amount
386         @param _amount     amount to increase the supply by
387     */
388     function issue(address _to, uint256 _amount)
389         public
390         ownerOnly
391         validAddress(_to)
392         notThis(_to)
393     {
394         totalSupply = safeAdd(totalSupply, _amount);
395         balanceOf[_to] = safeAdd(balanceOf[_to], _amount);
396 
397         Issuance(_amount);
398         Transfer(this, _to, _amount);
399     }
400 
401     /**
402         @dev removes tokens from an account and decreases the token supply
403         can only be called by the contract owner
404 
405         @param _from       account to remove the amount from
406         @param _amount     amount to decrease the supply by
407     */
408     function destroy(address _from, uint256 _amount)
409         public
410         ownerOnly
411     {
412         balanceOf[_from] = safeSub(balanceOf[_from], _amount);
413         totalSupply = safeSub(totalSupply, _amount);
414 
415         Transfer(_from, this, _amount);
416         Destruction(_amount);
417     }
418 
419     // ERC20 standard method overrides with some extra functionality
420 
421     /**
422         @dev send coins
423         throws on any error rather then return a false flag to minimize user errors
424         note that when transferring to the smart token's address, the coins are actually destroyed
425 
426         @param _to      target address
427         @param _value   transfer amount
428 
429         @return true if the transfer was successful, false if it wasn't
430     */
431     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
432         assert(super.transfer(_to, _value));
433 
434         // transferring to the contract address destroys tokens
435         if (_to == address(this)) {
436             balanceOf[_to] -= _value;
437             totalSupply -= _value;
438             Destruction(_value);
439         }
440 
441         return true;
442     }
443 
444     /**
445         @dev an account/contract attempts to get the coins
446         throws on any error rather then return a false flag to minimize user errors
447         note that when transferring to the smart token's address, the coins are actually destroyed
448 
449         @param _from    source address
450         @param _to      target address
451         @param _value   transfer amount
452 
453         @return true if the transfer was successful, false if it wasn't
454     */
455     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
456         assert(super.transferFrom(_from, _to, _value));
457 
458         // transferring to the contract address destroys tokens
459         if (_to == address(this)) {
460             balanceOf[_to] -= _value;
461             totalSupply -= _value;
462             Destruction(_value);
463         }
464 
465         return true;
466     }
467 }
468 
469 /**
470  * Upgrade agent interface inspired by Lunyr.
471  *
472  * Upgrade agent transfers tokens to a new contract.
473  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
474  */
475 contract UpgradeAgent {
476 
477   uint public originalSupply;
478 
479   /** Interface marker */
480   function isUpgradeAgent() public constant returns (bool) {
481     return true;
482   }
483 
484   function upgradeFrom(address _from, uint256 _value) public;
485 
486 }
487 
488 
489 /**
490  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
491  *
492  * First envisioned by Golem and Lunyr projects.
493  */
494 contract UpgradeableToken is DebitCoinToken {
495 
496   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
497   address public upgradeMaster;
498 
499   /** The next contract where the tokens will be migrated. */
500   UpgradeAgent public upgradeAgent;
501 
502   /** How many tokens we have upgraded by now. */
503   uint256 public totalUpgraded;
504 
505   /**
506    * Upgrade states.
507    *
508    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
509    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
510    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
511    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
512    *
513    */
514   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
515 
516   /**
517    * Somebody has upgraded some of his tokens.
518    */
519   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
520 
521   /**
522    * New upgrade agent available.
523    */
524   event UpgradeAgentSet(address agent);
525 
526   /**
527    * Do not allow construction without upgrade master set.
528    */
529   function UpgradeableToken(address _upgradeMaster) {
530     upgradeMaster = _upgradeMaster;
531   }
532 
533   /**
534    * Allow the token holder to upgrade some of their tokens to a new contract.
535    */
536   function upgrade(uint256 value) public {
537 
538       UpgradeState state = getUpgradeState();
539       require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
540       // Validate input value.
541       require(value != 0);
542 
543       balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], value);
544 
545       // Take tokens out from circulation
546       totalSupply = safeSub(totalSupply, value);
547       totalUpgraded = safeAdd(totalUpgraded, value);
548 
549       // Upgrade agent reissues the tokens
550       upgradeAgent.upgradeFrom(msg.sender, value);
551       Upgrade(msg.sender, upgradeAgent, value);
552   }
553 
554   /**
555    * Set an upgrade agent that handles
556    */
557   function setUpgradeAgent(address agent) external {
558 
559       require(canUpgrade());
560 
561       require(agent != 0x0);
562       // Only a master can designate the next agent
563       require(msg.sender == upgradeMaster);
564       // Upgrade has already begun for an agent
565       require(getUpgradeState() != UpgradeState.Upgrading);
566 
567       upgradeAgent = UpgradeAgent(agent);
568 
569       // Bad interface
570       require(upgradeAgent.isUpgradeAgent());
571       // Make sure that token supplies match in source and target
572       require(upgradeAgent.originalSupply() == totalSupply);
573 
574       UpgradeAgentSet(upgradeAgent);
575   }
576 
577   /**
578    * Get the state of the token upgrade.
579    */
580   function getUpgradeState() public constant returns(UpgradeState) {
581     if(!canUpgrade()) return UpgradeState.NotAllowed;
582     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
583     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
584     else return UpgradeState.Upgrading;
585   }
586 
587   /**
588    * Change the upgrade master.
589    *
590    * This allows us to set a new owner for the upgrade mechanism.
591    */
592   function setUpgradeMaster(address master) public {
593       require(master != 0x0);
594       require(msg.sender == upgradeMaster);
595       upgradeMaster = master;
596   }
597 
598   /**
599    * Child contract can enable to provide the condition when the upgrade can begun.
600    */
601   function canUpgrade() public constant returns(bool) {
602      return true;
603   }
604 
605 }