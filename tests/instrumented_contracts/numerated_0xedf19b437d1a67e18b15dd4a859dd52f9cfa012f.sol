1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * See https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127   function totalSupply() public view returns (uint256);
128   function balanceOf(address who) public view returns (uint256);
129   function transfer(address to, uint256 value) public returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 
133 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
134 
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  */
139 contract ERC20 is ERC20Basic {
140   function allowance(address owner, address spender)
141     public view returns (uint256);
142 
143   function transferFrom(address from, address to, uint256 value)
144     public returns (bool);
145 
146   function approve(address spender, uint256 value) public returns (bool);
147   event Approval(
148     address indexed owner,
149     address indexed spender,
150     uint256 value
151   );
152 }
153 
154 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
155 
156 /**
157  * @title SafeERC20
158  * @dev Wrappers around ERC20 operations that throw on failure.
159  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
160  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
161  */
162 library SafeERC20 {
163   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
164     require(token.transfer(to, value));
165   }
166 
167   function safeTransferFrom(
168     ERC20 token,
169     address from,
170     address to,
171     uint256 value
172   )
173     internal
174   {
175     require(token.transferFrom(from, to, value));
176   }
177 
178   function safeApprove(ERC20 token, address spender, uint256 value) internal {
179     require(token.approve(spender, value));
180   }
181 }
182 
183 // Custom smart contracts developed or adapted for OrcaCrowdsale
184 // -------------------------------------------------------------
185 
186 contract TokenRecoverable is Ownable {
187     using SafeERC20 for ERC20Basic;
188 
189     function recoverTokens(ERC20Basic token, address to, uint256 amount) public onlyOwner {
190         uint256 balance = token.balanceOf(address(this));
191         require(balance >= amount);
192         token.safeTransfer(to, amount);
193     }
194 }
195 
196 contract ERC820Registry {
197     function getManager(address addr) public view returns(address);
198     function setManager(address addr, address newManager) public;
199     function getInterfaceImplementer(address addr, bytes32 iHash) public constant returns (address);
200     function setInterfaceImplementer(address addr, bytes32 iHash, address implementer) public;
201 }
202 
203 contract ERC820Implementer {
204     ERC820Registry erc820Registry = ERC820Registry(0x991a1bcb077599290d7305493c9A630c20f8b798);
205 
206     function setInterfaceImplementation(string ifaceLabel, address impl) internal {
207         bytes32 ifaceHash = keccak256(abi.encodePacked(ifaceLabel));
208         erc820Registry.setInterfaceImplementer(this, ifaceHash, impl);
209     }
210 
211     function interfaceAddr(address addr, string ifaceLabel) internal constant returns(address) {
212         bytes32 ifaceHash = keccak256(abi.encodePacked(ifaceLabel));
213         return erc820Registry.getInterfaceImplementer(addr, ifaceHash);
214     }
215 
216     function delegateManagement(address newManager) internal {
217         erc820Registry.setManager(this, newManager);
218     }
219 }
220 
221 contract ERC777Token {
222     function name() public view returns (string);
223     function symbol() public view returns (string);
224     function totalSupply() public view returns (uint256);
225     function balanceOf(address owner) public view returns (uint256);
226     function granularity() public view returns (uint256);
227 
228     function defaultOperators() public view returns (address[]);
229     function isOperatorFor(address operator, address tokenHolder) public view returns (bool);
230     function authorizeOperator(address operator) public;
231     function revokeOperator(address operator) public;
232 
233     function send(address to, uint256 amount, bytes holderData) public;
234     function operatorSend(address from, address to, uint256 amount, bytes holderData, bytes operatorData) public;
235 
236     function burn(uint256 amount, bytes holderData) public;
237     function operatorBurn(address from, uint256 amount, bytes holderData, bytes operatorData) public;
238 
239     event Sent(
240         address indexed operator,
241         address indexed from,
242         address indexed to,
243         uint256 amount,
244         bytes holderData,
245         bytes operatorData
246     ); // solhint-disable-next-line separate-by-one-line-in-contract
247     event Minted(address indexed operator, address indexed to, uint256 amount, bytes operatorData);
248     event Burned(address indexed operator, address indexed from, uint256 amount, bytes holderData, bytes operatorData);
249     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
250     event RevokedOperator(address indexed operator, address indexed tokenHolder);
251 }
252 
253 contract ERC777TokensRecipient {
254     function tokensReceived(
255         address operator,
256         address from,
257         address to,
258         uint amount,
259         bytes userData,
260         bytes operatorData
261     ) public;
262 }
263 
264 contract CommunityLock is ERC777TokensRecipient, ERC820Implementer, TokenRecoverable {
265 
266     ERC777Token public token;
267 
268     constructor(address _token) public {
269         setInterfaceImplementation("ERC777TokensRecipient", this);
270         address tokenAddress = interfaceAddr(_token, "ERC777Token");
271         require(tokenAddress != address(0));
272         token = ERC777Token(tokenAddress);
273     }
274 
275     function burn(uint256 _amount) public onlyOwner {
276         require(_amount > 0);
277         token.burn(_amount, '');
278     }
279 
280     function tokensReceived(address, address, address, uint256, bytes, bytes) public {
281         require(msg.sender == address(token));
282     }
283 }
284 
285 contract Debuggable {
286     event LogUI(string message, uint256 value);
287 
288     function logUI(string message, uint256 value) internal {
289         emit LogUI(message, value);
290     }
291 }
292 
293 contract ERC777TokenScheduledTimelock is ERC820Implementer, ERC777TokensRecipient, Ownable {
294     using SafeMath for uint256;
295 
296     ERC777Token public token;
297     uint256 public totalVested;
298 
299     struct Timelock {
300         uint256 till;
301         uint256 amount;
302     }
303 
304     mapping(address => Timelock[]) public schedule;
305 
306     event Released(address to, uint256 amount);
307 
308     constructor(address _token) public {
309         setInterfaceImplementation("ERC777TokensRecipient", this);
310         address tokenAddress = interfaceAddr(_token, "ERC777Token");
311         require(tokenAddress != address(0));
312         token = ERC777Token(tokenAddress);
313     }
314 
315     function scheduleTimelock(address _beneficiary, uint256 _lockTokenAmount, uint256 _lockTill) public onlyOwner {
316         require(_beneficiary != address(0));
317         require(_lockTill > getNow());
318         require(token.balanceOf(address(this)) >= totalVested.add(_lockTokenAmount));
319         totalVested = totalVested.add(_lockTokenAmount);
320 
321         schedule[_beneficiary].push(Timelock({ till: _lockTill, amount: _lockTokenAmount }));
322     }
323 
324     function release(address _to) public {
325         Timelock[] storage timelocks = schedule[_to];
326         uint256 tokens = 0;
327         uint256 till;
328         uint256 n = timelocks.length;
329         uint256 timestamp = getNow();
330         for (uint256 i = 0; i < n; i++) {
331             Timelock storage timelock = timelocks[i];
332             till = timelock.till;
333             if (till > 0 && till <= timestamp) {
334                 tokens = tokens.add(timelock.amount);
335                 timelock.amount = 0;
336                 timelock.till = 0;
337             }
338         }
339         if (tokens > 0) {
340             totalVested = totalVested.sub(tokens);
341             token.send(_to, tokens, '');
342             emit Released(_to, tokens);
343         }
344     }
345 
346     function releaseBatch(address[] _to) public {
347         require(_to.length > 0 && _to.length < 100);
348 
349         for (uint256 i = 0; i < _to.length; i++) {
350             release(_to[i]);
351         }
352     }
353 
354     function tokensReceived(address, address, address, uint256, bytes, bytes) public {}
355 
356     function getScheduledTimelockCount(address _beneficiary) public view returns (uint256) {
357         return schedule[_beneficiary].length;
358     }
359 
360     function getNow() internal view returns (uint256) {
361         return now; // solhint-disable-line
362     }
363 }
364 
365 contract ExchangeRateConsumer is Ownable {
366 
367     uint8 public constant EXCHANGE_RATE_DECIMALS = 3; // 3 digits precision for exchange rate
368 
369     uint256 public exchangeRate = 600000; // by default exchange rate is $600 with EXCHANGE_RATE_DECIMALS precision
370 
371     address public exchangeRateOracle;
372 
373     function setExchangeRateOracle(address _exchangeRateOracle) public onlyOwner {
374         require(_exchangeRateOracle != address(0));
375         exchangeRateOracle = _exchangeRateOracle;
376     }
377 
378     function setExchangeRate(uint256 _exchangeRate) public {
379         require(msg.sender == exchangeRateOracle || msg.sender == owner);
380         require(_exchangeRate > 0);
381         exchangeRate = _exchangeRate;
382     }
383 }
384 
385 contract OrcaToken is Ownable  {
386     using SafeMath for uint256;
387 
388     string private constant name_ = "ORCA Token";
389     string private constant symbol_ = "ORCA";
390     uint256 private constant granularity_ = 1;
391 
392     function mint(address _tokenHolder, uint256 _amount, bytes _operatorData) public;
393     function burn(uint256 _amount, bytes _holderData) public;
394     function finishMinting() public;
395 }
396 
397 contract Whitelist {
398     mapping(address => uint256) public whitelist;
399 }
400 
401 contract OrcaCrowdsale is TokenRecoverable, ExchangeRateConsumer, Debuggable {
402     using SafeMath for uint256;
403 
404     // Wallet where all ether will be stored
405     address internal constant WALLET = 0x0909Fb46D48eea996197573415446A26c001994a;
406     // Partner wallet
407     address internal constant PARTNER_WALLET = 0x536ba70cA19DF9982487e555E335e7d91Da4A474;
408     // Team wallet
409     address internal constant TEAM_WALLET = 0x5d6aF05d440326AE861100962e861CFF09203556;
410     // Advisors wallet
411     address internal constant ADVISORS_WALLET = 0xf44e377F35998a6b7776954c64a84fAf420C467B;
412 
413     uint256 internal constant TEAM_TOKENS = 58200000e18;      // 58 200 000 tokens
414     uint256 internal constant ADVISORS_TOKENS = 20000000e18;  // 20 000 000 tokens
415     uint256 internal constant PARTNER_TOKENS = 82800000e18;   // 82 800 000 tokens
416     uint256 internal constant COMMUNITY_TOKENS = 92000000e18; // 92 000 000 tokens
417 
418     uint256 internal constant TOKEN_PRICE = 6; // Token costs 0.06 USD
419     uint256 internal constant TEAM_TOKEN_LOCK_DATE = 1565049600; // 2019/08/06 00:00 UTC
420 
421     struct Stage {
422         uint256 startDate;
423         uint256 endDate;
424         uint256 priorityDate; // allow priority users to purchase tokens until this date
425         uint256 cap;
426         uint64 bonus;
427         uint64 maxPriorityId;
428     }
429 
430     uint256 public icoTokensLeft = 193200000e18;   // 193 200 000 tokens for ICO
431     uint256 public bountyTokensLeft = 13800000e18; // 13 800 000 bounty tokens
432     uint256 public preSaleTokens = 0;
433 
434     Stage[] public stages;
435 
436     // The token being sold
437     OrcaToken public token;
438     Whitelist public whitelist;
439     ERC777TokenScheduledTimelock public timelock;
440     CommunityLock public communityLock;
441 
442     mapping(address => uint256) public bountyBalances;
443 
444     address public tokenMinter;
445 
446     uint8 public currentStage = 0;
447     bool public initialized = false;
448     bool public isFinalized = false;
449     bool public isPreSaleTokenSet = false;
450 
451     /**
452     * event for token purchase logging
453     * @param purchaser who paid for the tokens
454     * @param beneficiary who got the tokens
455     * @param weis paid for purchase
456     * @param usd paid for purchase
457     * @param amount amount of tokens purchased
458     */
459     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 weis, uint256 usd, uint256 rate, uint256 amount);
460 
461     event Finalized();
462     /**
463      * When there no tokens left to mint and token minter tries to manually mint tokens
464      * this event is raised to signal how many tokens we have to charge back to purchaser
465      */
466     event ManualTokenMintRequiresRefund(address indexed purchaser, uint256 value);
467 
468     modifier onlyInitialized() {
469         require(initialized);
470         _;
471     }
472 
473     constructor(address _token, address _whitelist) public {
474         require(_token != address(0));
475         require(_whitelist != address(0));
476 
477         uint256 stageCap = 30000000e18; // 30 000 000 tokens
478 
479         stages.push(Stage({
480             startDate: 1533546000, // 6th of August, 9:00 UTC
481             endDate: 1534150800, // 13th of August, 9:00 UTC
482             cap: stageCap,
483             bonus: 20,
484             maxPriorityId: 5000,
485             priorityDate: uint256(1533546000).add(48 hours) // 6th of August, 9:00 UTC + 48 hours
486         }));
487 
488         icoTokensLeft = icoTokensLeft.sub(stageCap);
489 
490         token = OrcaToken(_token);
491         whitelist = Whitelist(_whitelist);
492         timelock = new ERC777TokenScheduledTimelock(_token);
493     }
494 
495     function initialize() public onlyOwner {
496         require(!initialized);
497 
498         token.mint(timelock, TEAM_TOKENS, '');
499         timelock.scheduleTimelock(TEAM_WALLET, TEAM_TOKENS, TEAM_TOKEN_LOCK_DATE);
500 
501         token.mint(ADVISORS_WALLET, ADVISORS_TOKENS, '');
502         token.mint(PARTNER_WALLET, PARTNER_TOKENS, '');
503 
504         communityLock = new CommunityLock(token);
505         token.mint(communityLock, COMMUNITY_TOKENS, '');
506 
507         initialized = true;
508     }
509 
510     function () external payable {
511         buyTokens(msg.sender);
512     }
513 
514     function mintPreSaleTokens(address[] _receivers, uint256[] _amounts, uint256[] _lockPeroids) external onlyInitialized {
515         require(msg.sender == tokenMinter || msg.sender == owner);
516         require(_receivers.length > 0 && _receivers.length <= 100);
517         require(_receivers.length == _amounts.length);
518         require(_receivers.length == _lockPeroids.length);
519         require(!isFinalized);
520         uint256 tokensInBatch = 0;
521         for (uint256 i = 0; i < _amounts.length; i++) {
522             tokensInBatch = tokensInBatch.add(_amounts[i]);
523         }
524         require(preSaleTokens >= tokensInBatch);
525 
526         preSaleTokens = preSaleTokens.sub(tokensInBatch);
527         token.mint(timelock, tokensInBatch, '');
528 
529         address receiver;
530         uint256 lockTill;
531         uint256 timestamp = getNow();
532         for (i = 0; i < _receivers.length; i++) {
533             receiver = _receivers[i];
534             require(receiver != address(0));
535 
536             lockTill = _lockPeroids[i];
537             require(lockTill > timestamp);
538 
539             timelock.scheduleTimelock(receiver, _amounts[i], lockTill);
540         }
541     }
542 
543     function mintToken(address _receiver, uint256 _amount) external onlyInitialized {
544         require(msg.sender == tokenMinter || msg.sender == owner);
545         require(!isFinalized);
546         require(_receiver != address(0));
547         require(_amount > 0);
548 
549         ensureCurrentStage();
550 
551         uint256 excessTokens = updateStageCap(_amount);
552 
553         token.mint(_receiver, _amount.sub(excessTokens), '');
554 
555         if (excessTokens > 0) {
556             emit ManualTokenMintRequiresRefund(_receiver, excessTokens); // solhint-disable-line
557         }
558     }
559 
560     function mintTokens(address[] _receivers, uint256[] _amounts) external onlyInitialized {
561         require(msg.sender == tokenMinter || msg.sender == owner);
562         require(_receivers.length > 0 && _receivers.length <= 100);
563         require(_receivers.length == _amounts.length);
564         require(!isFinalized);
565 
566         ensureCurrentStage();
567 
568         address receiver;
569         uint256 amount;
570         uint256 excessTokens;
571 
572         for (uint256 i = 0; i < _receivers.length; i++) {
573             receiver = _receivers[i];
574             amount = _amounts[i];
575 
576             require(receiver != address(0));
577             require(amount > 0);
578 
579             excessTokens = updateStageCap(amount);
580 
581             uint256 tokens = amount.sub(excessTokens);
582 
583             token.mint(receiver, tokens, '');
584 
585             if (excessTokens > 0) {
586                 emit ManualTokenMintRequiresRefund(receiver, excessTokens); // solhint-disable-line
587             }
588         }
589     }
590 
591     function mintBounty(address[] _receivers, uint256[] _amounts) external onlyInitialized {
592         require(msg.sender == tokenMinter || msg.sender == owner);
593         require(_receivers.length > 0 && _receivers.length <= 100);
594         require(_receivers.length == _amounts.length);
595         require(!isFinalized);
596         require(bountyTokensLeft > 0);
597 
598         uint256 tokensLeft = bountyTokensLeft;
599         address receiver;
600         uint256 amount;
601         for (uint256 i = 0; i < _receivers.length; i++) {
602             receiver = _receivers[i];
603             amount = _amounts[i];
604 
605             require(receiver != address(0));
606             require(amount > 0);
607 
608             tokensLeft = tokensLeft.sub(amount);
609             bountyBalances[receiver] = bountyBalances[receiver].add(amount);
610         }
611 
612         bountyTokensLeft = tokensLeft;
613     }
614 
615     function buyTokens(address _beneficiary) public payable onlyInitialized {
616         require(_beneficiary != address(0));
617         ensureCurrentStage();
618         validatePurchase();
619         uint256 weiReceived = msg.value;
620         uint256 usdReceived = weiToUsd(weiReceived);
621 
622         uint8 stageIndex = currentStage;
623 
624         uint256 tokens = usdToTokens(usdReceived, stageIndex);
625         uint256 weiToReturn = 0;
626 
627         uint256 excessTokens = updateStageCap(tokens);
628 
629         if (excessTokens > 0) {
630             uint256 usdToReturn = tokensToUsd(excessTokens, stageIndex);
631             usdReceived = usdReceived.sub(usdToReturn);
632             weiToReturn = weiToReturn.add(usdToWei(usdToReturn));
633             weiReceived = weiReceived.sub(weiToReturn);
634             tokens = tokens.sub(excessTokens);
635         }
636 
637         token.mint(_beneficiary, tokens, '');
638 
639         WALLET.transfer(weiReceived);
640         emit TokenPurchase(msg.sender, _beneficiary, weiReceived, usdReceived, exchangeRate, tokens); // solhint-disable-line
641         if (weiToReturn > 0) {
642             msg.sender.transfer(weiToReturn);
643         }
644     }
645 
646     function ensureCurrentStage() internal {
647         uint256 currentTime = getNow();
648         uint256 stageCount = stages.length;
649 
650         uint8 curStage = currentStage;
651         uint8 nextStage = curStage + 1;
652 
653         while (nextStage < stageCount && stages[nextStage].startDate <= currentTime) {
654             stages[nextStage].cap = stages[nextStage].cap.add(stages[curStage].cap);
655             curStage = nextStage;
656             nextStage = nextStage + 1;
657         }
658         if (currentStage != curStage) {
659             currentStage = curStage;
660         }
661     }
662 
663     /**
664     * @dev Must be called after crowdsale ends, to do some extra finalization
665     * work. Calls the contract's finalization function.
666     */
667     function finalize() public onlyOwner onlyInitialized {
668         require(!isFinalized);
669         require(preSaleTokens == 0);
670         Stage storage lastStage = stages[stages.length - 1];
671         require(getNow() >= lastStage.endDate || (lastStage.cap == 0 && icoTokensLeft == 0));
672 
673         token.finishMinting();
674         token.transferOwnership(owner);
675         communityLock.transferOwnership(owner); // only in finalize just to be sure that it is the same owner as crowdsale
676 
677         emit Finalized(); // solhint-disable-line
678 
679         isFinalized = true;
680     }
681 
682     function setTokenMinter(address _tokenMinter) public onlyOwner onlyInitialized {
683         require(_tokenMinter != address(0));
684         tokenMinter = _tokenMinter;
685     }
686 
687     function claimBounty(address beneficiary) public onlyInitialized {
688         uint256 balance = bountyBalances[beneficiary];
689         require(balance > 0);
690         bountyBalances[beneficiary] = 0;
691 
692         token.mint(beneficiary, balance, '');
693     }
694 
695     /// @notice Updates current stage cap and returns amount of excess tokens if ICO does not have enough tokens
696     function updateStageCap(uint256 _tokens) internal returns (uint256) {
697         Stage storage stage = stages[currentStage];
698         uint256 cap = stage.cap;
699         // normal situation, early exit
700         if (cap >= _tokens) {
701             stage.cap = cap.sub(_tokens);
702             return 0;
703         }
704 
705         stage.cap = 0;
706         uint256 excessTokens = _tokens.sub(cap);
707         if (icoTokensLeft >= excessTokens) {
708             icoTokensLeft = icoTokensLeft.sub(excessTokens);
709             return 0;
710         }
711         icoTokensLeft = 0;
712         return excessTokens.sub(icoTokensLeft);
713     }
714 
715     function weiToUsd(uint256 _wei) internal view returns (uint256) {
716         return _wei.mul(exchangeRate).div(10 ** uint256(EXCHANGE_RATE_DECIMALS));
717     }
718 
719     function usdToWei(uint256 _usd) internal view returns (uint256) {
720         return _usd.mul(10 ** uint256(EXCHANGE_RATE_DECIMALS)).div(exchangeRate);
721     }
722 
723     function usdToTokens(uint256 _usd, uint8 _stage) internal view returns (uint256) {
724         return _usd.mul(stages[_stage].bonus + 100).div(TOKEN_PRICE);
725     }
726 
727     function tokensToUsd(uint256 _tokens, uint8 _stage) internal view returns (uint256) {
728         return _tokens.mul(TOKEN_PRICE).div(stages[_stage].bonus + 100);
729     }
730 
731     function addStage(uint256 startDate, uint256 endDate, uint256 cap, uint64 bonus, uint64 maxPriorityId, uint256 priorityTime) public onlyOwner onlyInitialized {
732         require(!isFinalized);
733         require(startDate > getNow());
734         require(endDate > startDate);
735         Stage storage lastStage = stages[stages.length - 1];
736         require(startDate > lastStage.endDate);
737         require(startDate.add(priorityTime) <= endDate);
738         require(icoTokensLeft >= cap);
739         require(maxPriorityId >= lastStage.maxPriorityId);
740 
741         stages.push(Stage({
742             startDate: startDate,
743             endDate: endDate,
744             cap: cap,
745             bonus: bonus,
746             maxPriorityId: maxPriorityId,
747             priorityDate: startDate.add(priorityTime)
748         }));
749     }
750 
751     function validatePurchase() internal view {
752         require(!isFinalized);
753         require(msg.value != 0);
754 
755         require(currentStage < stages.length);
756         Stage storage stage = stages[currentStage];
757         require(stage.cap > 0);
758 
759         uint256 currentTime = getNow();
760         require(stage.startDate <= currentTime && currentTime <= stage.endDate);
761 
762         uint256 userId = whitelist.whitelist(msg.sender);
763         require(userId > 0);
764         if (stage.priorityDate > currentTime) {
765             require(userId < stage.maxPriorityId);
766         }
767     }
768 
769     function setPreSaleTokens(uint256 amount) public onlyOwner onlyInitialized {
770         require(!isPreSaleTokenSet);
771         require(amount > 0);
772         preSaleTokens = amount;
773         isPreSaleTokenSet = true;
774     }
775 
776     function getStageCount() public view returns (uint256) {
777         return stages.length;
778     }
779 
780     function getNow() internal view returns (uint256) {
781         return now; // solhint-disable-line
782     }
783 }