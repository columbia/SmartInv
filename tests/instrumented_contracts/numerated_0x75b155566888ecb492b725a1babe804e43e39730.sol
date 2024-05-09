1 pragma solidity ^0.4.21;
2 
3 // File: contracts/ISimpleCrowdsale.sol
4 
5 interface ISimpleCrowdsale {
6     function getSoftCap() external view returns(uint256);
7 }
8 
9 // File: contracts/ownership/Ownable.sol
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17     address public owner;
18     address public newOwner;
19 
20     event OwnershipTransferred(address previousOwner, address newOwner);
21 
22     /**
23     * @dev The Ownable constructor sets the original `owner` of the contract.
24     */
25     function Ownable(address _owner) public {
26         owner = _owner == address(0) ? msg.sender : _owner;
27     }
28 
29     /**
30     * @dev Throws if called by any account other than the owner.
31     */
32     modifier onlyOwner() {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     /**
38     * @dev Allows the current owner to transfer control of the contract to a newOwner.
39     * @param _newOwner The address to transfer ownership to.
40     */
41     function transferOwnership(address _newOwner) public onlyOwner {
42         require(_newOwner != owner);
43         newOwner = _newOwner;
44     }
45 
46     /**
47     * @dev confirm ownership by a new owner
48     */
49     function confirmOwnership() public {
50         require(msg.sender == newOwner);
51         OwnershipTransferred(owner, newOwner);
52         owner = newOwner;
53         newOwner = 0x0;
54     }
55 }
56 
57 // File: contracts/Pausable.sol
58 
59 /**
60  * @title Pausable
61  * @dev Base contract which allows children to implement an emergency stop mechanism.
62  */
63 contract Pausable is Ownable {
64     event Pause();
65     event Unpause();
66 
67     bool public paused = false;
68 
69 
70     /**
71      * @dev Modifier to make a function callable only when the contract is not paused.
72      */
73     modifier whenNotPaused() {
74         require(!paused);
75         _;
76     }
77 
78     /**
79      * @dev Modifier to make a function callable only when the contract is paused.
80      */
81     modifier whenPaused() {
82         require(paused);
83         _;
84     }
85 
86     /**
87      * @dev called by the owner to pause, triggers stopped state
88      */
89     function pause() onlyOwner whenNotPaused public {
90         paused = true;
91         Pause();
92     }
93 
94     /**
95      * @dev called by the owner to unpause, returns to normal state
96      */
97     function unpause() onlyOwner whenPaused public {
98         paused = false;
99         Unpause();
100     }
101 }
102 
103 // File: contracts/fund/ICrowdsaleFund.sol
104 
105 /**
106  * @title ICrowdsaleFund
107  * @dev Fund methods used by crowdsale contract
108  */
109 interface ICrowdsaleFund {
110     /**
111     * @dev Function accepts user`s contributed ether and logs contribution
112     * @param contributor Contributor wallet address.
113     */
114     function processContribution(address contributor) external payable;
115     /**
116     * @dev Function is called on the end of successful crowdsale
117     */
118     function onCrowdsaleEnd() external;
119     /**
120     * @dev Function is called if crowdsale failed to reach soft cap
121     */
122     function enableCrowdsaleRefund() external;
123 }
124 
125 
126 // File: contracts/token/IERC20Token.sol
127 
128 /**
129  * @title IERC20Token - ERC20 interface
130  * @dev see https://github.com/ethereum/EIPs/issues/20
131  */
132 contract IERC20Token {
133     string public name;
134     string public symbol;
135     uint8 public decimals;
136     uint256 public totalSupply;
137 
138     function balanceOf(address _owner) public constant returns (uint256 balance);
139     function transfer(address _to, uint256 _value)  public returns (bool success);
140     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);
141     function approve(address _spender, uint256 _value)  public returns (bool success);
142     function allowance(address _owner, address _spender)  public constant returns (uint256 remaining);
143 
144     event Transfer(address indexed _from, address indexed _to, uint256 _value);
145     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
146 }
147 
148 // File: contracts/math/SafeMath.sol
149 
150 /**
151  * @title SafeMath
152  * @dev Math operations with safety checks that throw on error
153  */
154 contract SafeMath {
155     /**
156     * @dev constructor
157     */
158     function SafeMath() public {
159     }
160 
161     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
162         uint256 c = a * b;
163         assert(a == 0 || c / a == b);
164         return c;
165     }
166 
167     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
168         uint256 c = a / b;
169         return c;
170     }
171 
172     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
173         assert(a >= b);
174         return a - b;
175     }
176 
177     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
178         uint256 c = a + b;
179         assert(c >= a);
180         return c;
181     }
182 }
183 
184 // File: contracts/token/LockedTokens.sol
185 
186 /**
187  * @title LockedTokens
188  * @dev Lock tokens for certain period of time
189  */
190 contract LockedTokens is SafeMath {
191     struct Tokens {
192         uint256 amount;
193         uint256 lockEndTime;
194         bool released;
195     }
196 
197     event TokensUnlocked(address _to, uint256 _value);
198 
199     IERC20Token public token;
200     address public crowdsaleAddress;
201     mapping(address => Tokens[]) public walletTokens;
202 
203     /**
204      * @dev LockedTokens constructor
205      * @param _token ERC20 compatible token contract
206      * @param _crowdsaleAddress Crowdsale contract address
207      */
208     function LockedTokens(IERC20Token _token, address _crowdsaleAddress) public {
209         token = _token;
210         crowdsaleAddress = _crowdsaleAddress;
211     }
212 
213     /**
214      * @dev Functions locks tokens
215      * @param _to Wallet address to transfer tokens after _lockEndTime
216      * @param _amount Amount of tokens to lock
217      * @param _lockEndTime End of lock period
218      */
219     function addTokens(address _to, uint256 _amount, uint256 _lockEndTime) external {
220         require(msg.sender == crowdsaleAddress);
221         walletTokens[_to].push(Tokens({amount: _amount, lockEndTime: _lockEndTime, released: false}));
222     }
223 
224     /**
225      * @dev Called by owner of locked tokens to release them
226      */
227     function releaseTokens() public {
228         require(walletTokens[msg.sender].length > 0);
229 
230         for(uint256 i = 0; i < walletTokens[msg.sender].length; i++) {
231             if(!walletTokens[msg.sender][i].released && now >= walletTokens[msg.sender][i].lockEndTime) {
232                 walletTokens[msg.sender][i].released = true;
233                 token.transfer(msg.sender, walletTokens[msg.sender][i].amount);
234                 TokensUnlocked(msg.sender, walletTokens[msg.sender][i].amount);
235             }
236         }
237     }
238 }
239 
240 // File: contracts/ownership/MultiOwnable.sol
241 
242 /**
243  * @title MultiOwnable
244  * @dev The MultiOwnable contract has owners addresses and provides basic authorization control
245  * functions, this simplifies the implementation of "users permissions".
246  */
247 contract MultiOwnable {
248     address public manager; // address used to set owners
249     address[] public owners;
250     mapping(address => bool) public ownerByAddress;
251 
252     event SetOwners(address[] owners);
253 
254     modifier onlyOwner() {
255         require(ownerByAddress[msg.sender] == true);
256         _;
257     }
258 
259     /**
260      * @dev MultiOwnable constructor sets the manager
261      */
262     function MultiOwnable() public {
263         manager = msg.sender;
264     }
265 
266     /**
267      * @dev Function to set owners addresses
268      */
269     function setOwners(address[] _owners) public {
270         require(msg.sender == manager);
271         _setOwners(_owners);
272 
273     }
274 
275     function _setOwners(address[] _owners) internal {
276         for(uint256 i = 0; i < owners.length; i++) {
277             ownerByAddress[owners[i]] = false;
278         }
279 
280 
281         for(uint256 j = 0; j < _owners.length; j++) {
282             ownerByAddress[_owners[j]] = true;
283         }
284         owners = _owners;
285         SetOwners(_owners);
286     }
287 
288     function getOwners() public constant returns (address[]) {
289         return owners;
290     }
291 }
292 
293 // File: contracts/token/ERC20Token.sol
294 
295 /**
296  * @title ERC20Token - ERC20 base implementation
297  * @dev see https://github.com/ethereum/EIPs/issues/20
298  */
299 contract ERC20Token is IERC20Token, SafeMath {
300     mapping (address => uint256) public balances;
301     mapping (address => mapping (address => uint256)) public allowed;
302 
303     function transfer(address _to, uint256 _value) public returns (bool) {
304         require(_to != address(0));
305         require(balances[msg.sender] >= _value);
306 
307         balances[msg.sender] = safeSub(balances[msg.sender], _value);
308         balances[_to] = safeAdd(balances[_to], _value);
309         Transfer(msg.sender, _to, _value);
310         return true;
311     }
312 
313     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
314         require(_to != address(0));
315         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
316 
317         balances[_to] = safeAdd(balances[_to], _value);
318         balances[_from] = safeSub(balances[_from], _value);
319         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
320         Transfer(_from, _to, _value);
321         return true;
322     }
323 
324     function balanceOf(address _owner) public constant returns (uint256) {
325         return balances[_owner];
326     }
327 
328     function approve(address _spender, uint256 _value) public returns (bool) {
329         allowed[msg.sender][_spender] = _value;
330         Approval(msg.sender, _spender, _value);
331         return true;
332     }
333 
334     function allowance(address _owner, address _spender) public constant returns (uint256) {
335       return allowed[_owner][_spender];
336     }
337 }
338 
339 // File: contracts/token/ITokenEventListener.sol
340 
341 /**
342  * @title ITokenEventListener
343  * @dev Interface which should be implemented by token listener
344  */
345 interface ITokenEventListener {
346     /**
347      * @dev Function is called after token transfer/transferFrom
348      * @param _from Sender address
349      * @param _to Receiver address
350      * @param _value Amount of tokens
351      */
352     function onTokenTransfer(address _from, address _to, uint256 _value) external;
353 }
354 
355 // File: contracts/token/ManagedToken.sol
356 
357 /**
358  * @title ManagedToken
359  * @dev ERC20 compatible token with issue and destroy facilities
360  * @dev All transfers can be monitored by token event listener
361  */
362 contract ManagedToken is ERC20Token, MultiOwnable {
363     bool public allowTransfers = false;
364     bool public issuanceFinished = false;
365 
366     ITokenEventListener public eventListener;
367 
368     event AllowTransfersChanged(bool _newState);
369     event Issue(address indexed _to, uint256 _value);
370     event Destroy(address indexed _from, uint256 _value);
371     event IssuanceFinished();
372 
373     modifier transfersAllowed() {
374         require(allowTransfers);
375         _;
376     }
377 
378     modifier canIssue() {
379         require(!issuanceFinished);
380         _;
381     }
382 
383     /**
384      * @dev ManagedToken constructor
385      * @param _listener Token listener(address can be 0x0)
386      * @param _owners Owners list
387      */
388     function ManagedToken(address _listener, address[] _owners) public {
389         if(_listener != address(0)) {
390             eventListener = ITokenEventListener(_listener);
391         }
392         _setOwners(_owners);
393     }
394 
395     /**
396      * @dev Enable/disable token transfers. Can be called only by owners
397      * @param _allowTransfers True - allow False - disable
398      */
399     function setAllowTransfers(bool _allowTransfers) external onlyOwner {
400         allowTransfers = _allowTransfers;
401         AllowTransfersChanged(_allowTransfers);
402     }
403 
404     /**
405      * @dev Set/remove token event listener
406      * @param _listener Listener address (Contract must implement ITokenEventListener interface)
407      */
408     function setListener(address _listener) public onlyOwner {
409         if(_listener != address(0)) {
410             eventListener = ITokenEventListener(_listener);
411         } else {
412             delete eventListener;
413         }
414     }
415 
416     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool) {
417         bool success = super.transfer(_to, _value);
418         if(hasListener() && success) {
419             eventListener.onTokenTransfer(msg.sender, _to, _value);
420         }
421         return success;
422     }
423 
424     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool) {
425         bool success = super.transferFrom(_from, _to, _value);
426         if(hasListener() && success) {
427             eventListener.onTokenTransfer(_from, _to, _value);
428         }
429         return success;
430     }
431 
432     function hasListener() internal view returns(bool) {
433         if(eventListener == address(0)) {
434             return false;
435         }
436         return true;
437     }
438 
439     /**
440      * @dev Issue tokens to specified wallet
441      * @param _to Wallet address
442      * @param _value Amount of tokens
443      */
444     function issue(address _to, uint256 _value) external onlyOwner canIssue {
445         totalSupply = safeAdd(totalSupply, _value);
446         balances[_to] = safeAdd(balances[_to], _value);
447         Issue(_to, _value);
448         Transfer(address(0), _to, _value);
449     }
450 
451     /**
452      * @dev Destroy tokens on specified address (Called by owner or token holder)
453      * @dev Fund contract address must be in the list of owners to burn token during refund
454      * @param _from Wallet address
455      * @param _value Amount of tokens to destroy
456      */
457     function destroy(address _from, uint256 _value) external {
458         require(ownerByAddress[msg.sender] || msg.sender == _from);
459         require(balances[_from] >= _value);
460         totalSupply = safeSub(totalSupply, _value);
461         balances[_from] = safeSub(balances[_from], _value);
462         Transfer(_from, address(0), _value);
463         Destroy(_from, _value);
464     }
465 
466     /**
467      * @dev Increase the amount of tokens that an owner allowed to a spender.
468      *
469      * approve should be called when allowed[_spender] == 0. To increment
470      * allowed value is better to use this function to avoid 2 calls (and wait until
471      * the first transaction is mined)
472      * From OpenZeppelin StandardToken.sol
473      * @param _spender The address which will spend the funds.
474      * @param _addedValue The amount of tokens to increase the allowance by.
475      */
476     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
477         allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);
478         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
479         return true;
480     }
481 
482     /**
483      * @dev Decrease the amount of tokens that an owner allowed to a spender.
484      *
485      * approve should be called when allowed[_spender] == 0. To decrement
486      * allowed value is better to use this function to avoid 2 calls (and wait until
487      * the first transaction is mined)
488      * From OpenZeppelin StandardToken.sol
489      * @param _spender The address which will spend the funds.
490      * @param _subtractedValue The amount of tokens to decrease the allowance by.
491      */
492     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
493         uint oldValue = allowed[msg.sender][_spender];
494         if (_subtractedValue > oldValue) {
495             allowed[msg.sender][_spender] = 0;
496         } else {
497             allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);
498         }
499         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
500         return true;
501     }
502 
503     /**
504      * @dev Finish token issuance
505      * @return True if success
506      */
507     function finishIssuance() public onlyOwner returns (bool) {
508         issuanceFinished = true;
509         IssuanceFinished();
510         return true;
511     }
512 }
513 
514 // File: contracts/token/TransferLimitedToken.sol
515 
516 /**
517  * @title TransferLimitedToken
518  * @dev Token with ability to limit transfers within wallets included in limitedWallets list for certain period of time
519  */
520 contract TransferLimitedToken is ManagedToken {
521     uint256 public constant LIMIT_TRANSFERS_PERIOD = 365 days;
522 
523     mapping(address => bool) public limitedWallets;
524     uint256 public limitEndDate;
525     address public limitedWalletsManager;
526     bool public isLimitEnabled;
527 
528     event TransfersEnabled();
529 
530     modifier onlyManager() {
531         require(msg.sender == limitedWalletsManager);
532         _;
533     }
534 
535     /**
536      * @dev Check if transfer between addresses is available
537      * @param _from From address
538      * @param _to To address
539      */
540     modifier canTransfer(address _from, address _to)  {
541         require(now >= limitEndDate || !isLimitEnabled || (!limitedWallets[_from] && !limitedWallets[_to]));
542         _;
543     }
544 
545     /**
546      * @dev TransferLimitedToken constructor
547      * @param _limitStartDate Limit start date
548      * @param _listener Token listener(address can be 0x0)
549      * @param _owners Owners list
550      * @param _limitedWalletsManager Address used to add/del wallets from limitedWallets
551      */
552     function TransferLimitedToken(
553         uint256 _limitStartDate,
554         address _listener,
555         address[] _owners,
556         address _limitedWalletsManager
557     ) public ManagedToken(_listener, _owners)
558     {
559         limitEndDate = _limitStartDate + LIMIT_TRANSFERS_PERIOD;
560         isLimitEnabled = true;
561         limitedWalletsManager = _limitedWalletsManager;
562     }
563 
564     /**
565      * @dev Enable token transfers
566      */
567     function enableTransfers() public {
568         require(msg.sender == limitedWalletsManager);
569         allowTransfers = true;
570         TransfersEnabled();
571     }
572 
573     /**
574      * @dev Add address to limitedWallets
575      * @dev Can be called only by manager
576      */
577     function addLimitedWalletAddress(address _wallet) public {
578         require(msg.sender == limitedWalletsManager || ownerByAddress[msg.sender]);
579         limitedWallets[_wallet] = true;
580     }
581 
582     /**
583      * @dev Del address from limitedWallets
584      * @dev Can be called only by manager
585      */
586     function delLimitedWalletAddress(address _wallet) public onlyManager {
587         limitedWallets[_wallet] = false;
588     }
589 
590     /**
591      * @dev Disable transfer limit manually. Can be called only by manager
592      */
593     function disableLimit() public onlyManager {
594         isLimitEnabled = false;
595     }
596 
597     function transfer(address _to, uint256 _value) public canTransfer(msg.sender, _to) returns (bool) {
598         return super.transfer(_to, _value);
599     }
600 
601     function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from, _to) returns (bool) {
602         return super.transferFrom(_from, _to, _value);
603     }
604 
605     function approve(address _spender, uint256 _value) public canTransfer(msg.sender, _spender) returns (bool) {
606         return super.approve(_spender,_value);
607     }
608 }
609 
610 // File: contracts/Crowdsale.sol
611 
612 contract TheEvolthDAICO is Ownable, SafeMath, Pausable, ISimpleCrowdsale {
613     enum AdditionalBonusState {
614         Unavailable,
615         Active,
616         Applied
617     }
618 
619     uint256 public constant ADDITIONAL_BONUS_NUM = 3;
620     uint256 public constant ADDITIONAL_BONUS_DENOM = 100;
621 
622     uint256 public constant ETHER_MIN_CONTRIB = 0.2 ether;
623     uint256 public constant ETHER_MAX_CONTRIB = 20 ether;
624 
625     uint256 public constant SALE_START_TIME = 1536566400; // 10.09.2018 08:00:00 UTC
626     uint256 public constant SALE_END_TIME = 1538956800; // 08.10.2018 08:00:00 UTC
627 
628     uint256 public constant BONUS_WINDOW_1_END_TIME = SALE_START_TIME + 3 days;
629     uint256 public constant BONUS_WINDOW_2_END_TIME = SALE_START_TIME + 8 days;
630     uint256 public constant BONUS_WINDOW_3_END_TIME = SALE_START_TIME + 14 days;
631     uint256 public constant BONUS_WINDOW_4_END_TIME = SALE_START_TIME + 21 days;
632 
633     uint256 public constant MAX_CONTRIB_CHECK_END_TIME = SALE_START_TIME + 1 days;
634 
635     uint256 public tokenPriceNum = 0;
636     uint256 public tokenPriceDenom = 0;
637     
638     TransferLimitedToken public token;
639     ICrowdsaleFund public fund;
640     LockedTokens public lockedTokens;
641 
642     mapping(address => AdditionalBonusState) public additionalBonusOwnerState;
643     mapping(address => uint256) public userTotalContributed;
644 
645     address public mainSaleTokenWallet;
646     address public foundationTokenWallet;
647     address public advisorsTokenWallet;
648     address public teamTokenWallet;
649     address public marketingTokenWallet;
650 
651     uint256 public totalEtherContributed = 0;
652     uint256 public rawTokenSupply = 0;
653 
654     uint256 public hardCap = 0; // World hard cap will be set right before Token Sale
655     uint256 public softCap = 0; // World soft cap will be set right before Token Sale
656 
657     uint256 public tokenMaxSupply;
658 
659     event LogContribution(address contributor, uint256 amountWei, uint256 tokenAmount, uint256 tokenBonus, bool additionalBonusApplied, uint256 timestamp);
660 
661     modifier checkContribution() {
662         require(isValidContribution());
663         _;
664     }
665 
666     modifier checkCap() {
667         require(validateCap());
668         _;
669     }
670 
671     modifier checkTime() {
672         require(now >= SALE_START_TIME && now <= SALE_END_TIME);
673         _;
674     }
675 
676     function TheEvolthDAICO(
677         address tokenAddress,
678         address fundAddress,
679         address _mainSaleTokenWallet,
680         address _foundationTokenWallet,
681         address _advisorsTokenWallet,
682         address _teamTokenWallet,
683         address _marketingTokenWallet,
684         address _owner
685     ) public
686         Ownable(_owner)
687     {
688         require(tokenAddress != address(0));
689 
690         token = TransferLimitedToken(tokenAddress);
691         fund = ICrowdsaleFund(fundAddress);
692 
693         mainSaleTokenWallet = _mainSaleTokenWallet;
694         foundationTokenWallet = _foundationTokenWallet;
695         advisorsTokenWallet = _advisorsTokenWallet;
696         teamTokenWallet = _teamTokenWallet;
697         marketingTokenWallet = _marketingTokenWallet;
698 
699         tokenMaxSupply = 100*10**25; // 1B
700     }
701 
702     /**
703      * @dev check contribution amount and time
704      */
705     function isValidContribution() internal view returns(bool) {
706         uint256 currentUserContribution = safeAdd(msg.value, userTotalContributed[msg.sender]);
707         if(msg.value >= ETHER_MIN_CONTRIB) {
708             if(now <= MAX_CONTRIB_CHECK_END_TIME && currentUserContribution > ETHER_MAX_CONTRIB ) {
709                     return false;
710             }
711             return true;
712 
713         }
714 
715         return false;
716     }
717 
718     /**
719      * @dev Check hard cap overflow
720      */
721     function validateCap() internal view returns(bool){
722         if(msg.value <= safeSub(hardCap, totalEtherContributed)) {
723             return true;
724         }
725         return false;
726     }
727 
728     /**
729      * @dev Set token price once before start of crowdsale
730      */
731     function setTokenPrice(uint256 _tokenPriceNum, uint256 _tokenPriceDenom) public onlyOwner {
732         require(tokenPriceNum == 0 && tokenPriceDenom == 0);
733         require(_tokenPriceNum > 0 && _tokenPriceDenom > 0);
734         tokenPriceNum = _tokenPriceNum;
735         tokenPriceDenom = _tokenPriceDenom;
736     }
737 
738     /**
739      * @dev Set hard cap.
740      * @param _hardCap - Hard cap value
741      */
742     function setHardCap(uint256 _hardCap) public onlyOwner {
743         require(hardCap == 0);
744         hardCap = _hardCap;
745     }
746 
747     /**
748      * @dev Set soft cap.
749      * @param _softCap - Soft cap value
750      */
751     function setSoftCap(uint256 _softCap) public onlyOwner {
752         require(softCap == 0);
753         softCap = _softCap;
754     }
755 
756     /**
757      * @dev Get soft cap amount
758      **/
759     function getSoftCap() external view returns(uint256) {
760         return softCap;
761     }
762 
763     /**
764      * @dev Calc bonus amount by contribution time
765      */
766     function getBonus() internal constant returns (uint256, uint256) {
767         uint256 numerator = 0;
768         uint256 denominator = 100;
769 
770         if(now < BONUS_WINDOW_1_END_TIME) {
771             numerator = 30;
772         } else if(now < BONUS_WINDOW_2_END_TIME) {
773             numerator = 20;
774         } else if(now < BONUS_WINDOW_3_END_TIME) {
775             numerator = 10;
776         } else if(now < BONUS_WINDOW_4_END_TIME) {
777             numerator = 5;
778         } else {
779             numerator = 0;
780         }
781 
782         return (numerator, denominator);
783     }
784 
785     function addToLists(
786         address _wallet,
787         bool isInLimitedList,
788         bool hasAdditionalBonus
789     ) public onlyOwner {
790         if(isInLimitedList) {
791             token.addLimitedWalletAddress(_wallet);
792         }
793         if(hasAdditionalBonus) {
794             additionalBonusOwnerState[_wallet] = AdditionalBonusState.Active;
795         }
796     }
797 
798 
799     /**
800      * @dev Add wallet to additional bonus members. For contract owner only.
801      */
802     function addAdditionalBonusMember(address _wallet) public onlyOwner {
803         additionalBonusOwnerState[_wallet] = AdditionalBonusState.Active;
804     }
805 
806     /**
807      * @dev Set LockedTokens contract address
808      */
809     function setLockedTokens(address lockedTokensAddress) public onlyOwner {
810         lockedTokens = LockedTokens(lockedTokensAddress);
811     }
812 
813     /**
814      * @dev Fallback function to receive ether contributions
815      */
816     function () payable public whenNotPaused {
817         processContribution(msg.sender, msg.value);
818     }
819 
820     /**
821      * @dev Process ether contribution. Calc bonuses and issue tokens to contributor.
822      */
823     function processContribution(address contributor, uint256 amount) private checkTime checkContribution checkCap {
824         bool additionalBonusApplied = false;
825         uint256 bonusNum = 0;
826         uint256 bonusDenom = 100;
827         (bonusNum, bonusDenom) = getBonus();
828         uint256 tokenBonusAmount = 0;
829 
830         uint256 tokenAmount = safeDiv(safeMul(amount, tokenPriceNum), tokenPriceDenom);
831         rawTokenSupply = safeAdd(rawTokenSupply, tokenAmount);
832 
833         if(bonusNum > 0) {
834             tokenBonusAmount = safeDiv(safeMul(tokenAmount, bonusNum), bonusDenom);
835         }
836 
837         if(additionalBonusOwnerState[contributor] ==  AdditionalBonusState.Active) {
838             additionalBonusOwnerState[contributor] = AdditionalBonusState.Applied;
839             uint256 additionalBonus = safeDiv(safeMul(tokenAmount, ADDITIONAL_BONUS_NUM), ADDITIONAL_BONUS_DENOM);
840             tokenBonusAmount = safeAdd(tokenBonusAmount, additionalBonus);
841             additionalBonusApplied = true;
842         }
843 
844         processPayment(contributor, amount, tokenAmount, tokenBonusAmount, additionalBonusApplied);
845     }
846 
847     function processPayment(address contributor, uint256 etherAmount, uint256 tokenAmount, uint256 tokenBonusAmount, bool additionalBonusApplied) internal {
848         uint256 tokenTotalAmount = safeAdd(tokenAmount, tokenBonusAmount);
849 
850         token.issue(contributor, tokenTotalAmount);
851         fund.processContribution.value(etherAmount)(contributor);
852         totalEtherContributed = safeAdd(totalEtherContributed, etherAmount);
853         userTotalContributed[contributor] = safeAdd(userTotalContributed[contributor], etherAmount);
854         LogContribution(contributor, etherAmount, tokenAmount, tokenBonusAmount, additionalBonusApplied, now);
855     }
856 
857     /**
858      * @dev Force crowdsale refund
859      */
860     function forceCrowdsaleRefund() public onlyOwner {
861         pause();
862         fund.enableCrowdsaleRefund();
863         token.finishIssuance();
864     }
865 
866     /**
867      * @dev Finalize crowdsale if we reached hard cap or current time > SALE_END_TIME
868      */
869     function finalizeCrowdsale() public onlyOwner {
870         if(
871             totalEtherContributed >= hardCap ||
872             (now >= SALE_END_TIME && totalEtherContributed >= softCap)
873         ) {
874             fund.onCrowdsaleEnd();
875 
876             uint256 mintedTokenAmount = token.totalSupply();
877             uint256 unmintedTokenAmount = safeSub(tokenMaxSupply, mintedTokenAmount);
878 
879             // Main Sale
880             uint256 mainSaleTokenAmount = safeDiv(safeMul(unmintedTokenAmount, 4), 10); // 40 %
881             token.issue(address(lockedTokens), mainSaleTokenAmount);
882             lockedTokens.addTokens(mainSaleTokenWallet, mainSaleTokenAmount, now + 90 days);
883 
884             // Foundation
885             uint256 foundationTokenAmount = safeDiv(safeMul(unmintedTokenAmount, 4), 10); // 40%
886             token.issue(foundationTokenWallet, foundationTokenAmount);
887 
888             // Advisors
889             uint256 advisorsTokenAmount = safeDiv(safeMul(unmintedTokenAmount, 5), 100); // 5%
890             token.issue(address(lockedTokens), advisorsTokenAmount);
891             lockedTokens.addTokens(advisorsTokenWallet, advisorsTokenAmount, now + 365 days);
892 
893             // Team
894             uint256 teamTokenAmount = safeDiv(safeMul(unmintedTokenAmount, 5), 100); // 5%
895             token.issue(address(lockedTokens), teamTokenAmount);
896             lockedTokens.addTokens(teamTokenWallet, teamTokenAmount, now + 365 days);
897 
898             // Marketing
899             uint256 maketingTokenAmount = safeDiv(safeMul(unmintedTokenAmount, 1), 10); // 10%
900             token.issue(marketingTokenWallet, maketingTokenAmount);
901 
902             token.finishIssuance();
903 
904         } else if(now >= SALE_END_TIME) {
905             // Enable fund`s crowdsale refund if soft cap is not reached
906             fund.enableCrowdsaleRefund();
907             token.finishIssuance();
908         }
909     }
910 
911 }