1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks
6  */
7 contract SafeMath {
8     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
15         assert(b > 0);
16         uint256 c = a / b;
17         assert(a == b * c + a % b);
18         return c;
19     }
20 
21     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a && c >= b);
29         return c;
30     }
31 }
32 
33 
34 /**
35  * @title ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/20
37  */
38 contract ERC20 {
39     uint256 public totalSupply;
40     function balanceOf(address _owner) public constant returns (uint256 _balance);
41     function allowance(address _owner, address _spender) public constant returns (uint256 _allowance);
42     function transfer(address _to, uint256 _value) public returns (bool _succes);
43     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _succes);
44     function approve(address _spender, uint256 _value) public returns (bool _succes);
45     
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 
51 /**
52  * @title Standard ERC20 token
53  *
54  * @dev Implementation of the basic standard token.
55  */
56 contract StandardToken is ERC20, SafeMath {
57     
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed; 
60     
61     function balanceOf(address _owner) public constant returns (uint256){
62         return balances[_owner];
63     }
64     
65     function allowance(address _owner, address _spender) public constant returns (uint256){
66         return allowed[_owner][_spender];
67     }
68     
69     /**
70     * Fix for the ERC20 short address attack
71     *
72     * http://vessenes.com/the-erc20-short-address-attack-explained/
73     */
74     modifier onlyPayloadSize(uint numwords) {
75         assert(msg.data.length >= numwords * 32 + 4);
76         _;
77     }
78     
79     /*
80      * Internal transfer with security checks, 
81      * only can be called by this contract
82      */
83     function safeTransfer(address _from, address _to, uint256 _value) internal {
84             // Prevent transfer to 0x0 address.
85             require(_to != 0x0);
86             // Prevent transfer to this contract
87             require(_to != address(this));
88             // Check if the sender has enough and subtract from the sender by using safeSub
89             balances[_from] = safeSub(balances[_from], _value);
90             // check for overflows and add the same value to the recipient by using safeAdd
91             balances[_to] = safeAdd(balances[_to], _value);
92             Transfer(_from, _to, _value);
93     }
94 
95     /**
96      * @dev Send `_value` tokens to `_to` from your account
97      * @param _to address The address which you want to transfer to
98      * @param _value uint the amout of tokens to be transfered
99      */
100     function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool) {
101         safeTransfer(msg.sender, _to, _value);
102         return true;
103     }
104 
105     /**
106      * @dev Transfer tokens from one address to another
107      * @param _from address The address which you want to send tokens from
108      * @param _to address The address which you want to transfer to
109      * @param _value uint the amout of tokens to be transfered
110      */
111     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) public returns (bool) {
112         uint256 _allowance = allowed[_from][msg.sender];
113         
114         // Check (_value <= _allowance) is already done in safeSub(_allowance, _value)
115         allowed[_from][msg.sender] = safeSub(_allowance, _value);
116         safeTransfer(_from, _to, _value);
117         return true;
118     }
119 
120     /**
121      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
122      * @param _spender The address which will spend the funds.
123      * @param _value The amount of tokens to be spent.
124      */
125     function approve(address _spender, uint256 _value) onlyPayloadSize(2) public returns (bool) {
126         // To change the approve amount you first have to reduce the addresses`
127         // allowance to zero by calling `approve(_spender, 0)` if it is not
128         // already 0 to mitigate the race condition described here:
129         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131         allowed[msg.sender][_spender] = _value;
132         Approval(msg.sender, _spender, _value);
133         return true;
134     }
135 }
136 
137 
138 contract ApproveAndCallFallBack {
139     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
140 }
141 
142 
143 /**
144  * @title ExtendedERC20
145  * 
146  * @dev Additional functions to ERC20
147  */
148 contract ExtendedERC20 is StandardToken {
149     
150     /**
151      * @dev Increase the amount of tokens that an owner allowed to a spender.
152      *
153      * Instead of creating two transactions and pay the gas price twice by calling approve method
154      * this method allows to increment the allowed value in one step 
155      * without being vulnerable to multiple withdrawals.
156      * From MonolithDAO Token.sol
157      * @param _spender The address which will spend the funds.
158      * @param _addedValue The amount of tokens to increase the allowance by.
159      */
160     function increaseApproval(address _spender, uint256 _addedValue) onlyPayloadSize(2) public returns (bool) {
161         allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);
162         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163         return true;
164     }
165 
166     /**
167      * @dev Decrease the amount of tokens that an owner allowed to a spender.
168      *
169      * Instead of creating two transactions and pay the gas price twice by calling approve method
170      * this method allows to decrease the allowed value in one step 
171      * without being vulnerable to multiple withdrawals.
172      * From MonolithDAO Token.sol
173      * @param _spender The address which will spend the funds.
174      * @param _subtractedValue The amount of tokens to decrease the allowance by.
175      */
176     function decreaseApproval(address _spender, uint256 _subtractedValue) onlyPayloadSize(2) public returns (bool) {
177         uint256 currentValue = allowed[msg.sender][_spender];
178         require(currentValue > 0);
179         if (_subtractedValue > currentValue) {
180             allowed[msg.sender][_spender] = 0;
181         } else {
182             allowed[msg.sender][_spender] = safeSub(currentValue, _subtractedValue);
183         }
184         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185         return true;
186     }
187     
188     /** @dev `msg.sender` approves `_spender` to send `_amount` tokens on
189      *  its behalf, and then a function is triggered in the contract that is
190      *  being approved, `_spender`. This allows users to use their tokens to
191      *  interact with contracts in one function call instead of two
192      * @param _spender The address of the contract able to transfer the tokens
193      * @param _amount The amount of tokens to be approved for transfer
194      */
195     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
196         require(approve(_spender, _amount));
197         ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _amount, this, _extraData);
198         return true;
199     }
200 }
201 
202 
203 /**
204  * Upgrade agent interface inspired by Lunyr.
205  * 
206  * Upgrade agent transfers tokens to a new contract.
207  * Upgrade agent itself can be the token contract, or just a middle man contract 
208  * doing the heavy lifting.
209  */
210 contract UpgradeAgent {
211 
212     uint256 public originalSupply;
213 
214     /** Interface marker */
215     function isUpgradeAgent() public pure returns (bool) {
216         return true;
217     }
218 
219     function upgradeFrom(address _from, uint256 _value) public;
220 }
221 
222 
223 /**
224  * A token upgrade mechanism where users can opt-in amount of tokens to the next 
225  * smart contract revision.
226  *
227  * First envisioned by Golem and Lunyr projects.
228  *
229  */
230 contract UpgradeableToken is StandardToken {
231 
232     /**
233      * Contract / person who can set the upgrade path. 
234      * This can be the same as team multisig wallet, as what it is with its default value. 
235      */
236     address public upgradeMaster;
237 
238     /** The next contract where the tokens will be migrated. */
239     UpgradeAgent public upgradeAgent;
240 
241     /** How many tokens we have upgraded by now. */
242     uint256 public totalUpgraded;
243     
244     /**
245      * Upgrade states.
246      *
247      * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
248      * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
249      * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
250      * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
251      *
252      */
253     enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
254 
255     /**
256      * Somebody has upgraded some of his tokens.
257      */
258     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
259 
260     /**
261      * New upgrade agent available.
262      */
263     event UpgradeAgentSet(address agent);
264 
265     /**
266      * Do not allow construction without upgrade master set.
267      */
268     function UpgradeableToken(address _upgradeMaster) public {
269         upgradeMaster = _upgradeMaster;
270     }
271 
272     /**
273      * Allow the token holder to upgrade some of their tokens to a new contract.
274      */
275     function upgrade(uint256 value) public {
276 
277         UpgradeState state = getUpgradeState();
278         // bad state not allowed
279         require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
280 
281         // Validate input value.
282         require(value != 0);
283 
284         balances[msg.sender] = safeSub(balances[msg.sender], value);
285 
286         // Take tokens out from circulation
287         totalSupply = safeSub(totalSupply, value);
288         totalUpgraded = safeAdd(totalUpgraded, value);
289 
290         // Upgrade agent reissues the tokens
291         upgradeAgent.upgradeFrom(msg.sender, value);
292         Upgrade(msg.sender, upgradeAgent, value);
293     }
294 
295     /**
296      * Set an upgrade agent that handles
297      */
298     function setUpgradeAgent(address agent) external {
299 
300         require(canUpgrade());
301         require(agent != 0x0);
302         // Only a master can designate the next agent
303         require(msg.sender == upgradeMaster);
304         // Upgrade has already begun for an agent
305         require(getUpgradeState() != UpgradeState.Upgrading);
306 
307         upgradeAgent = UpgradeAgent(agent);
308 
309         // Bad interface
310         require(upgradeAgent.isUpgradeAgent());
311         // Make sure that token supplies match in source and target
312         require(upgradeAgent.originalSupply() == totalSupply);
313 
314         UpgradeAgentSet(upgradeAgent);
315     }
316 
317     /**
318      * Get the state of the token upgrade.
319      */
320     function getUpgradeState() public constant returns (UpgradeState) {
321         if(!canUpgrade()) return UpgradeState.NotAllowed;
322         else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
323         else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
324         else return UpgradeState.Upgrading;
325     }
326 
327     /**
328      * Change the upgrade master.
329      *
330      * This allows us to set a new owner for the upgrade mechanism.
331      */
332     function setUpgradeMaster(address master) public {
333         require(master != 0x0);
334         require(msg.sender == upgradeMaster);
335         upgradeMaster = master;
336     }
337 
338     /**
339      * Child contract can enable to provide the condition when the upgrade can begun.
340      */
341     function canUpgrade() public pure returns (bool) {
342         return true;
343     }
344 }
345 
346 
347 /**
348  * @title Ownable
349  * @dev Ownable contract with two owner addresses
350  */
351 contract Ownable {
352     address public ownerOne;
353     address public ownerTwo;
354 
355     /**
356      * @dev The Ownable constructor sets both owners of the contract to the sender account.
357      */
358     function Ownable() public {
359         ownerOne = msg.sender;
360         ownerTwo = msg.sender;
361     }
362 
363     /**
364      * @dev Can only be called by the owners.
365      */
366     modifier onlyOwner {
367         require(msg.sender == ownerOne || msg.sender == ownerTwo);
368         _;
369     }
370 
371     /**
372      * @dev Allows the current owners to transfer control of the contract to a new owner.
373      * @param newOwner The address to transfer ownership to
374      * @param replaceOwnerOne Replace 'ownerOne'?
375      * @param replaceOwnerTwo Replace 'ownerTwo'?
376      */
377     function transferOwnership(address newOwner, bool replaceOwnerOne, bool replaceOwnerTwo) onlyOwner public {
378         require(newOwner != 0x0);
379         require(replaceOwnerOne || replaceOwnerTwo);
380         if(replaceOwnerOne) ownerOne = newOwner;
381         if(replaceOwnerTwo) ownerTwo = newOwner;
382     }
383 }
384 
385 
386 /**
387  * @title Pausable
388  * @dev Allows an emergency stop mechanism.
389  * See https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/lifecycle/Pausable.sol
390  */
391 contract Pausable is Ownable {
392     event Pause();
393     event Unpause();
394 
395     bool public paused = false;
396 
397     /**
398      * @dev modifier to allow actions only when the contract IS paused
399      */
400     modifier whenNotPaused {
401         require(!paused);
402         _;
403     }
404 
405     /**
406      * @dev modifier to allow actions only when the contract IS NOT paused
407      */
408     modifier whenPaused {
409         require(paused);
410         _;
411     }
412 
413     /**
414      * @dev called by the owner to pause, triggers stopped state
415      */
416     function pause() onlyOwner whenNotPaused public returns (bool) {
417         paused = true;
418         Pause();
419         return true;
420     }
421 
422     /**
423      * @dev called by the owner to unpause, returns to normal state
424      */
425     function unpause() onlyOwner whenPaused public returns (bool) {
426         paused = false;
427         Unpause();
428         return true;
429     }
430 }
431 
432 
433 /**
434  * @title PausableToken
435  * @dev StandardToken with pausable transfers
436  */
437 contract PausableToken is StandardToken, Pausable {
438     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
439         // Call StandardToken.transfer()
440         super.transfer(_to, _value);
441         return true;
442     }
443 
444     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {
445         // Call StandardToken.transferFrom()
446         super.transferFrom(_from, _to, _value);
447         return true;
448     }
449 }
450 
451 
452 /**
453  * @title PurchasableToken
454  * @dev Allows buying IPC token from this contract
455  */
456 contract PurchasableToken is StandardToken, Pausable {
457     event PurchaseUnlocked();
458     event PurchaseLocked();
459     event UpdatedExchangeRate(uint256 newRate);
460     
461     bool public purchasable = false;
462     // minimum amount of wei you have to spend to buy some tokens
463     uint256 public minimumWeiAmount;
464     address public vendorWallet;
465     uint256 public exchangeRate; // 'exchangeRate' tokens = 1 ether (consider decimals of token)
466     
467     /**
468      * event for token purchase logging
469      * @param purchaser who paid for the tokens
470      * @param beneficiary who got the tokens
471      * @param value weis paid for purchase
472      * @param amount amount of tokens purchased
473      */
474     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
475     
476     /** 
477      * @dev modifier to allow token purchase only when purchase is unlocked and rate > 0 
478      */
479     modifier isPurchasable {
480         require(purchasable && exchangeRate > 0 && minimumWeiAmount > 0);
481         _;
482     }
483     
484     /** @dev called by the owner to lock purchase of ipc token */
485     function lockPurchase() onlyOwner public returns (bool) {
486         require(purchasable == true);
487         purchasable = false;
488         PurchaseLocked();
489         return true;
490     }
491     
492     /** @dev called by the owner to release purchase of ipc token */
493     function unlockPurchase() onlyOwner public returns (bool) {
494         require(purchasable == false);
495         purchasable = true;
496         PurchaseUnlocked();
497         return true;
498     }
499 
500     /** @dev called by the owner to set a new rate (consider decimals of token) */
501     function setExchangeRate(uint256 newExchangeRate) onlyOwner public returns (bool) {
502         require(newExchangeRate > 0);
503         exchangeRate = newExchangeRate;
504         UpdatedExchangeRate(newExchangeRate);
505         return true;
506     }
507     
508     /** @dev called by the owner to set the minimum wei amount to buy some token */
509     function setMinimumWeiAmount(uint256 newMinimumWeiAmount) onlyOwner public returns (bool) {
510         require(newMinimumWeiAmount > 0);
511         minimumWeiAmount = newMinimumWeiAmount;
512         return true;
513     }
514     
515     /** @dev called by the owner to set a new vendor */
516     function setVendorWallet(address newVendorWallet) onlyOwner public returns (bool) {
517         require(newVendorWallet != 0x0);
518         vendorWallet = newVendorWallet;
519         return true;
520     }
521     
522     /** 
523      * @dev called by the owner to make the purchase preparations 
524      * ('approve' must be called separately from 'vendorWallet') 
525      */
526     function setPurchaseValues( uint256 newExchangeRate, 
527                                 uint256 newMinimumWeiAmount, 
528                                 address newVendorWallet,
529                                 bool releasePurchase) onlyOwner public returns (bool) {
530         setExchangeRate(newExchangeRate);
531         setMinimumWeiAmount(newMinimumWeiAmount);
532         setVendorWallet(newVendorWallet);
533         // if purchase is already unlocked then 'releasePurchase' 
534         // doesn't change anything and can be set to true or false.
535         if (releasePurchase && !purchasable) unlockPurchase();
536         return true;
537     }
538     
539     /** @dev buy token by sending at least 'minimumWeiAmount' wei */
540     function buyToken(address beneficiary) payable isPurchasable whenNotPaused public returns (uint256) {
541         require(beneficiary != address(0));
542         require(beneficiary != address(this));
543         uint256 weiAmount = msg.value;
544         require(weiAmount >= minimumWeiAmount);
545         uint256 tokenAmount = safeMul(weiAmount, exchangeRate);
546         tokenAmount = safeDiv(tokenAmount, 1 ether);
547         uint256 _allowance = allowed[vendorWallet][this];
548         // Check (tokenAmount <= _allowance) is already done in safeSub(_allowance, tokenAmount)
549         allowed[vendorWallet][this] = safeSub(_allowance, tokenAmount);
550         balances[beneficiary] = safeAdd(balances[beneficiary], tokenAmount);
551         balances[vendorWallet] = safeSub(balances[vendorWallet], tokenAmount);
552         vendorWallet.transfer(weiAmount);
553         TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);
554         return tokenAmount; 
555     }
556     
557     function () payable public {
558         buyToken(msg.sender);
559     }
560 }
561 
562 
563 /**
564  * @title CrowdsaleToken
565  * @dev Allows token transfer after the crowdsale has ended
566  */
567 contract CrowdsaleToken is PausableToken {
568     
569     // addresses that will be allowed to transfer tokens before and during crowdsale
570     mapping (address => bool) icoAgents;
571     // token transfer locked until crowdsale is finished
572     bool public crowdsaleLock = true;
573 
574     /**
575      * @dev Can only be called by the icoAgent
576      */
577     modifier onlyIcoAgent {
578         require(isIcoAgent(msg.sender));
579         _;
580     }
581     
582     /**
583      * @dev modifier to allow token transfer only when '_sender' is icoAgent or crowdsale has ended 
584      */
585     modifier canTransfer(address _sender) {
586         require(!crowdsaleLock || isIcoAgent(_sender));
587         _;
588     }
589     
590     /**
591      * @dev Construction with an icoAgent
592      */
593     function CrowdsaleToken(address _icoAgent) public {
594         icoAgents[_icoAgent] = true;
595     }
596     
597     /** @dev called by an icoAgent to release token transfer after crowdsale */
598     function releaseTokenTransfer() onlyIcoAgent public returns (bool) {
599         crowdsaleLock = false;
600         return true;
601     }
602     
603     /** @dev called by the owner to set a new _icoAgent or remove one */
604     function setIcoAgent(address _icoAgent, bool _allowTransfer) onlyOwner public returns (bool) {
605         icoAgents[_icoAgent] = _allowTransfer;
606         return true; 
607     }
608     
609     /** @dev return true if 'address' is an icoAgent */
610     function isIcoAgent(address _address) public view returns (bool) {
611         return icoAgents[_address];
612     }
613 
614     function transfer(address _to, uint _value) canTransfer(msg.sender) public returns (bool) {
615         // Call PausableToken.transfer()
616         return super.transfer(_to, _value);
617     }
618 
619     function transferFrom(address _from, address _to, uint _value) canTransfer(_from) public returns (bool) {
620         // Call PausableToken.transferFrom()
621         return super.transferFrom(_from, _to, _value);
622     }
623 }
624 
625 
626 /**
627  * @title CanSendFromContract
628  * @dev Contract allows to send ether and erc20 compatible tokens
629  */
630 contract CanSendFromContract is Ownable {
631     
632     /** @dev send erc20 token from this contract */
633     function sendToken(address beneficiary, address _token) onlyOwner public {
634         ERC20 token = ERC20(_token);
635         uint256 amount = token.balanceOf(this);
636         require(amount>0);
637         token.transfer(beneficiary, amount);
638     }
639     
640     /** @dev called by the owner to transfer 'weiAmount' wei to 'beneficiary' */
641     function sendEther(address beneficiary, uint256 weiAmount) onlyOwner public {
642         beneficiary.transfer(weiAmount);
643     }
644 }
645 
646 
647 /**
648  * @title IPCToken
649  * @dev IPC Token contract
650  * @author Paysura - <contact@paysura.com>
651  */
652 contract IPCToken is ExtendedERC20, UpgradeableToken, PurchasableToken, CrowdsaleToken, CanSendFromContract {
653 
654     // Public variables of the token
655     string public name = "International PayReward Coin";
656     string public symbol = "IPC";
657     uint8 public decimals = 12;
658     // Distributions of the total supply
659     // 264 mio IPC tokens will be distributed during crowdsale
660     uint256 public cr = 264000000 * (10 ** uint256(decimals));
661     // 110 mio reserved for community in the reward program
662     uint256 public rew = 110000000 * (10 ** uint256(decimals));
663     // 66 mio for advisors and partners
664     uint256 public dev = 66000000 * (10 ** uint256(decimals));
665     // total supply of 440 mio -> 85% for community.
666     uint256 public totalSupply = cr + dev + rew;    
667 
668     event UpdatedTokenInformation(string newName, string newSymbol);
669    
670     /**
671      * Constructor of ipc token
672      * 
673      * @param addressOfCrBen beneficiary of crowdsale
674      * @param addressOfRew reserve for community / reward program
675      * @param addressOfDev reserve remaining amount of ipc for development, partners and advisors
676      */
677     function IPCToken (
678         address addressOfCrBen, 
679         address addressOfRew,
680         address addressOfDev
681         ) public UpgradeableToken(msg.sender) CrowdsaleToken(addressOfCrBen) {
682         // Assign the initial tokens to the addresses
683         balances[addressOfCrBen] = cr;
684         balances[addressOfRew] = rew;
685         balances[addressOfDev] = dev;
686     }
687     
688     /**
689      * Owner can update token information
690      * 
691      * @param _name new token name
692      * @param _symbol new token symbol
693      */
694     function setTokenInformation(string _name, string _symbol) onlyOwner public {
695         name = _name;
696         symbol = _symbol;
697         
698         UpdatedTokenInformation(name, symbol);
699     }
700 }