1 pragma solidity ^0.4.15;
2 
3 
4 
5 
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13     address public owner;
14 
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     function Ownable() {
21         owner = msg.sender;
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32     /**
33      * @dev Allows the current owner to transfer control of the contract to a newOwner.
34      * @param newOwner The address to transfer ownership to.
35      */
36     function transferOwnership(address newOwner) onlyOwner public {
37         require(newOwner != address(0));
38         OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40     }
41 
42 }
43 
44 
45 /**
46  * @title Pausable
47  * @dev Base contract which allows children to implement an emergency stop mechanism.
48  */
49 contract Pausable is Ownable {
50     event Pause();
51 
52     event Unpause();
53 
54     bool public paused = false;
55 
56 
57     /**
58      * @dev Modifier to make a function callable only when the contract is not paused.
59      */
60     modifier whenNotPaused() {
61         require(!paused);
62         _;
63     }
64 
65     /**
66      * @dev Modifier to make a function callable only when the contract is paused.
67      */
68     modifier whenPaused() {
69         require(paused);
70         _;
71     }
72 
73     /**
74      * @dev called by the owner to pause, triggers stopped state
75      */
76     function pause() onlyOwner whenNotPaused public {
77         paused = true;
78         Pause();
79     }
80 
81     /**
82      * @dev called by the owner to unpause, returns to normal state
83      */
84     function unpause() onlyOwner whenPaused public {
85         paused = false;
86         Unpause();
87     }
88 }
89 
90 
91 
92 
93 
94 
95 
96 
97 /**
98  * @title ERC20Basic
99  * @dev Simpler version of ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/179
101  */
102 contract ERC20Basic {
103     uint256 public totalSupply;
104 
105     function balanceOf(address who) public constant returns (uint256);
106 
107     function transfer(address to, uint256 value) public returns (bool);
108 
109     event Transfer(address indexed from, address indexed to, uint256 value);
110 }
111 
112 
113 
114 
115 
116 
117 
118 
119 /**
120  * @title ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/20
122  */
123 contract ERC20 is ERC20Basic {
124     function allowance(address owner, address spender) public constant returns (uint256);
125 
126     function transferFrom(address from, address to, uint256 value) public returns (bool);
127 
128     function approve(address spender, uint256 value) public returns (bool);
129 
130     event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 
133 
134 
135 
136 
137 
138 
139 
140 
141 /**
142  * @title Basic token
143  * @dev Basic version of StandardToken, with no allowances.
144  */
145 contract BasicToken is ERC20Basic {
146     using SafeMath for uint256;
147 
148     mapping (address => uint256) balances;
149 
150     /**
151     * @dev transfer token for a specified address
152     * @param _to The address to transfer to.
153     * @param _value The amount to be transferred.
154     */
155     function transfer(address _to, uint256 _value) public returns (bool) {
156         require(_to != address(0));
157 
158         // SafeMath.sub will throw if there is not enough balance.
159         balances[msg.sender] = balances[msg.sender].sub(_value);
160         balances[_to] = balances[_to].add(_value);
161         Transfer(msg.sender, _to, _value);
162         return true;
163     }
164 
165     /**
166     * @dev Gets the balance of the specified address.
167     * @param _owner The address to query the the balance of.
168     * @return An uint256 representing the amount owned by the passed address.
169     */
170     function balanceOf(address _owner) public constant returns (uint256 balance) {
171         return balances[_owner];
172     }
173 
174 }
175 
176 
177 
178 
179 
180 
181 
182 
183 /**
184  * @title Standard ERC20 token
185  *
186  * @dev Implementation of the basic standard token.
187  * @dev https://github.com/ethereum/EIPs/issues/20
188  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
189  */
190 contract StandardToken is ERC20, BasicToken {
191 
192     mapping (address => mapping (address => uint256)) allowed;
193 
194 
195     /**
196      * @dev Transfer tokens from one address to another
197      * @param _from address The address which you want to send tokens from
198      * @param _to address The address which you want to transfer to
199      * @param _value uint256 the amount of tokens to be transferred
200      */
201     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
202         require(_to != address(0));
203 
204         uint256 _allowance = allowed[_from][msg.sender];
205 
206         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
207         // require (_value <= _allowance);
208 
209         balances[_from] = balances[_from].sub(_value);
210         balances[_to] = balances[_to].add(_value);
211         allowed[_from][msg.sender] = _allowance.sub(_value);
212         Transfer(_from, _to, _value);
213         return true;
214     }
215 
216     /**
217      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218      *
219      * Beware that changing an allowance with this method brings the risk that someone may use both the old
220      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223      * @param _spender The address which will spend the funds.
224      * @param _value The amount of tokens to be spent.
225      */
226     function approve(address _spender, uint256 _value) public returns (bool) {
227         allowed[msg.sender][_spender] = _value;
228         Approval(msg.sender, _spender, _value);
229         return true;
230     }
231 
232     /**
233      * @dev Function to check the amount of tokens that an owner allowed to a spender.
234      * @param _owner address The address which owns the funds.
235      * @param _spender address The address which will spend the funds.
236      * @return A uint256 specifying the amount of tokens still available for the spender.
237      */
238     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
239         return allowed[_owner][_spender];
240     }
241 
242     /**
243      * approve should be called when allowed[_spender] == 0. To increment
244      * allowed value is better to use this function to avoid 2 calls (and wait until
245      * the first transaction is mined)
246      * From MonolithDAO Token.sol
247      */
248     function increaseApproval(address _spender, uint _addedValue)
249     returns (bool success) {
250         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
251         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252         return true;
253     }
254 
255     function decreaseApproval(address _spender, uint _subtractedValue)
256     returns (bool success) {
257         uint oldValue = allowed[msg.sender][_spender];
258         if (_subtractedValue > oldValue) {
259             allowed[msg.sender][_spender] = 0;
260         }
261         else {
262             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
263         }
264         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265         return true;
266     }
267 
268 }
269 
270 
271 
272 
273 
274 /**
275  * @title SafeMath
276  * @dev Math operations with safety checks that throw on error
277  */
278 library SafeMath {
279     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
280         uint256 c = a * b;
281         if (a != 0 && c / a != b) revert();
282         return c;
283     }
284 
285     function div(uint256 a, uint256 b) internal constant returns (uint256) {
286         // assert(b > 0); // Solidity automatically throws when dividing by 0
287         uint256 c = a / b;
288         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
289         return c;
290     }
291 
292     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
293         if (b > a) revert();
294         return a - b;
295     }
296 
297     function add(uint256 a, uint256 b) internal constant returns (uint256) {
298         uint256 c = a + b;
299         if (c < a) revert();
300         return c;
301     }
302 }
303 
304 
305 /**
306  * @title VLBTokens
307  * @dev VLB Token contract based on Zeppelin StandardToken contract
308  */
309 contract VLBToken is StandardToken, Ownable {
310     using SafeMath for uint256;
311 
312     /**
313      * @dev ERC20 descriptor variables
314      */
315     string public constant name = "VLB Tokens";
316     string public constant symbol = "VLB";
317     uint8 public decimals = 18;
318 
319     /**
320      * @dev 220 millions is the initial Tokensale supply
321      */
322     uint256 public constant publicTokens = 220 * 10 ** 24;
323 
324     /**
325      * @dev 20 millions for the team
326      */
327     uint256 public constant teamTokens = 20 * 10 ** 24;
328 
329     /**
330      * @dev 10 millions as a bounty reward
331      */
332     uint256 public constant bountyTokens = 10 * 10 ** 24;
333 
334     /**
335      * @dev 2.5 millions as an initial wings.ai reward reserv
336      */
337     uint256 public constant wingsTokensReserv = 25 * 10 ** 23;
338     
339     /**
340      * @dev wings.ai reward calculated on tokensale finalization
341      */
342     uint256 public wingsTokensReward = 0;
343 
344     // TODO: TestRPC addresses, replace to real
345     address public constant teamTokensWallet = 0x6a6AcA744caDB8C56aEC51A8ce86EFCaD59989CF;
346     address public constant bountyTokensWallet = 0x91A7DE4ce8e8da6889d790B7911246B71B4c82ca;
347     address public constant crowdsaleTokensWallet = 0x5e671ceD703f3dDcE79B13F82Eb73F25bad9340e;
348     
349     /**
350      * @dev wings.ai wallet for reward collecting
351      */
352     address public constant wingsWallet = 0xcbF567D39A737653C569A8B7dFAb617E327a7aBD;
353 
354 
355     /**
356      * @dev Address of Crowdsale contract which will be compared
357      *       against in the appropriate modifier check
358      */
359     address public crowdsaleContractAddress;
360 
361     /**
362      * @dev variable that holds flag of ended tokensake 
363      */
364     bool isFinished = false;
365 
366     /**
367      * @dev Modifier that allow only the Crowdsale contract to be sender
368      */
369     modifier onlyCrowdsaleContract() {
370         require(msg.sender == crowdsaleContractAddress);
371         _;
372     }
373 
374     /**
375      * @dev event for the burnt tokens after crowdsale logging
376      * @param tokens amount of tokens available for crowdsale
377      */
378     event TokensBurnt(uint256 tokens);
379 
380     /**
381      * @dev event for the tokens contract move to the active state logging
382      * @param supply amount of tokens left after all the unsold was burned
383      */
384     event Live(uint256 supply);
385 
386     /**
387      * @dev event for bounty tone transfer logging
388      * @param from the address of bounty tokens wallet
389      * @param to the address of beneficiary tokens wallet
390      * @param value amount of tokens
391      */
392     event BountyTransfer(address indexed from, address indexed to, uint256 value);
393 
394     /**
395      * @dev Contract constructor
396      */
397     function VLBToken() {
398         // Issue team tokens
399         balances[teamTokensWallet] = balanceOf(teamTokensWallet).add(teamTokens);
400         Transfer(address(0), teamTokensWallet, teamTokens);
401 
402         // Issue bounty tokens
403         balances[bountyTokensWallet] = balanceOf(bountyTokensWallet).add(bountyTokens);
404         Transfer(address(0), bountyTokensWallet, bountyTokens);
405 
406         // Issue crowdsale tokens minus initial wings reward.
407         // see endTokensale for more details about final wings.ai reward
408         uint256 crowdsaleTokens = publicTokens.sub(wingsTokensReserv);
409         balances[crowdsaleTokensWallet] = balanceOf(crowdsaleTokensWallet).add(crowdsaleTokens);
410         Transfer(address(0), crowdsaleTokensWallet, crowdsaleTokens);
411 
412         // 250 millions tokens overall
413         totalSupply = publicTokens.add(bountyTokens).add(teamTokens);
414     }
415 
416     /**
417      * @dev back link VLBToken contract with VLBCrowdsale one
418      * @param _crowdsaleAddress non zero address of VLBCrowdsale contract
419      */
420     function setCrowdsaleAddress(address _crowdsaleAddress) onlyOwner external {
421         require(_crowdsaleAddress != address(0));
422         crowdsaleContractAddress = _crowdsaleAddress;
423 
424         // Allow crowdsale contract 
425         uint256 balance = balanceOf(crowdsaleTokensWallet);
426         allowed[crowdsaleTokensWallet][crowdsaleContractAddress] = balance;
427         Approval(crowdsaleTokensWallet, crowdsaleContractAddress, balance);
428     }
429 
430     /**
431      * @dev called only by linked VLBCrowdsale contract to end crowdsale.
432      *      all the unsold tokens will be burned and totalSupply updated
433      *      but wings.ai reward will be secured in advance
434      */
435     function endTokensale() onlyCrowdsaleContract external {
436         require(!isFinished);
437         uint256 crowdsaleLeftovers = balanceOf(crowdsaleTokensWallet);
438         
439         if (crowdsaleLeftovers > 0) {
440             totalSupply = totalSupply.sub(crowdsaleLeftovers).sub(wingsTokensReserv);
441             wingsTokensReward = totalSupply.div(100);
442             totalSupply = totalSupply.add(wingsTokensReward);
443 
444             balances[crowdsaleTokensWallet] = 0;
445             Transfer(crowdsaleTokensWallet, address(0), crowdsaleLeftovers);
446             TokensBurnt(crowdsaleLeftovers);
447         } else {
448             wingsTokensReward = wingsTokensReserv;
449         }
450         
451         balances[wingsWallet] = balanceOf(wingsWallet).add(wingsTokensReward);
452         Transfer(crowdsaleTokensWallet, wingsWallet, wingsTokensReward);
453 
454         isFinished = true;
455 
456         Live(totalSupply);
457     }
458 }
459 
460 
461 
462 
463 
464 
465 
466 
467 /*
468  * !!!IMPORTANT!!!
469  * Based on Open Zeppelin Refund Vault contract
470  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/crowdsale/RefundVault.sol
471  * the only thing that differs is a hardcoded wallet address
472  */
473 
474 /**
475  * @title RefundVault.
476  * @dev This contract is used for storing funds while a crowdsale
477  * is in progress. Supports refunding the money if crowdsale fails,
478  * and forwarding it if crowdsale is successful.
479  */
480 contract VLBRefundVault is Ownable {
481     using SafeMath for uint256;
482 
483     enum State {Active, Refunding, Closed}
484     State public state;
485 
486     mapping (address => uint256) public deposited;
487 
488     address public constant wallet = 0x02D408bc203921646ECA69b555524DF3c7f3a8d7;
489 
490     address crowdsaleContractAddress;
491 
492     event Closed();
493     event RefundsEnabled();
494     event Refunded(address indexed beneficiary, uint256 weiAmount);
495 
496     function VLBRefundVault() {
497         state = State.Active;
498     }
499 
500     modifier onlyCrowdsaleContract() {
501         require(msg.sender == crowdsaleContractAddress);
502         _;
503     }
504 
505     function setCrowdsaleAddress(address _crowdsaleAddress) external onlyOwner {
506         require(_crowdsaleAddress != address(0));
507         crowdsaleContractAddress = _crowdsaleAddress;
508     }
509 
510     function deposit(address investor) onlyCrowdsaleContract external payable {
511         require(state == State.Active);
512         deposited[investor] = deposited[investor].add(msg.value);
513     }
514 
515     function close(address _wingsWallet) onlyCrowdsaleContract external {
516         require(_wingsWallet != address(0));
517         require(state == State.Active);
518         state = State.Closed;
519         Closed();
520         uint256 wingsReward = this.balance.div(100);
521         _wingsWallet.transfer(wingsReward);
522         wallet.transfer(this.balance);
523     }
524 
525     function enableRefunds() onlyCrowdsaleContract external {
526         require(state == State.Active);
527         state = State.Refunding;
528         RefundsEnabled();
529     }
530 
531     function refund(address investor) public {
532         require(state == State.Refunding);
533         uint256 depositedValue = deposited[investor];
534         deposited[investor] = 0;
535         investor.transfer(depositedValue);
536         Refunded(investor, depositedValue);
537     }
538 
539     /**
540      * @dev killer method that can bu used by owner to
541      *      kill the contract and send funds to owner
542      */
543     function kill() onlyOwner {
544         require(state == State.Closed);
545         selfdestruct(owner);
546     }
547 }
548 
549 
550 
551 /**
552  * @title VLBCrowdsale
553  * @dev VLB crowdsale contract borrows Zeppelin Finalized, Capped and Refundable crowdsales implementations
554  */
555 contract VLBCrowdsale is Ownable, Pausable {
556     using SafeMath for uint;
557 
558     /**
559      * @dev token contract
560      */
561     VLBToken public token;
562 
563     /**
564      * @dev refund vault used to hold funds while crowdsale is running
565      */
566     VLBRefundVault public vault;
567 
568     /**
569      * @dev tokensale(presale) start time: Nov 22, 2017, 12:00:00 UTC (1511352000)
570      */
571     uint startTime = 1511352000;
572 
573     /**
574      * @dev tokensale end time: Dec 17, 2017 12:00:00 UTC (1513512000), or the date when
575      *       300’000 ether have been collected, whichever occurs first. see hasEnded()
576      *       for more details
577      */
578     uint endTime = 1513512000;
579 
580     /**
581      * @dev minimum purchase amount for presale
582      */
583     uint256 public constant minPresaleAmount = 100 * 10**18; // 100 ether
584 
585     /**
586      * @dev minimum and maximum amount of funds to be raised in weis
587      */
588     uint256 public constant goal = 25 * 10**21;  // 25 Kether
589     uint256 public constant cap  = 300 * 10**21; // 300 Kether
590 
591     /**
592      * @dev amount of raised money in wei
593      */
594     uint256 public weiRaised;
595 
596     /**
597      * @dev tokensale finalization flag
598      */
599     bool public isFinalized = false;
600 
601     /**
602      * @dev event for token purchase logging
603      * @param purchaser who paid for the tokens
604      * @param beneficiary who got the tokens
605      * @param value weis paid for purchase
606      * @param amount amount of tokens purchased
607      */
608     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
609 
610     /**
611      * @dev event for tokensale final logging
612      */
613     event Finalized();
614 
615     /**
616      * @dev Crowdsale in the constructor takes addresses of
617      *      the just deployed VLBToken and VLBRefundVault contracts
618      * @param _tokenAddress address of the VLBToken deployed contract
619      * @param _vaultAddress address of the VLBRefundVault deployed contract
620      */
621     function VLBCrowdsale(address _tokenAddress, address _vaultAddress) {
622         require(_tokenAddress != address(0));
623         require(_vaultAddress != address(0));
624 
625         // VLBToken and VLBRefundVault was deployed separately
626         token = VLBToken(_tokenAddress);
627         vault = VLBRefundVault(_vaultAddress);
628     }
629 
630     /**
631      * @dev fallback function can be used to buy tokens
632      */
633     function() payable {
634         buyTokens(msg.sender);
635     }
636 
637     /**
638      * @dev main function to buy tokens
639      * @param beneficiary target wallet for tokens can vary from the sender one
640      */
641     function buyTokens(address beneficiary) whenNotPaused public payable {
642         require(beneficiary != address(0));
643         require(validPurchase(msg.value));
644 
645         uint256 weiAmount = msg.value;
646 
647         // buyer and beneficiary could be two different wallets
648         address buyer = msg.sender;
649 
650         // calculate token amount to be created
651         uint256 tokens = weiAmount.mul(getConversionRate());
652 
653         weiRaised = weiRaised.add(weiAmount);
654 
655         if (!token.transferFrom(token.crowdsaleTokensWallet(), beneficiary, tokens)) {
656             revert();
657         }
658 
659         TokenPurchase(buyer, beneficiary, weiAmount, tokens);
660 
661         vault.deposit.value(weiAmount)(buyer);
662     }
663 
664     /**
665      * @dev check if the current purchase valid based on time and amount of passed ether
666      * @param _value amount of passed ether
667      * @return true if investors can buy at the moment
668      */
669     function validPurchase(uint256 _value) internal constant returns (bool) {
670         bool nonZeroPurchase = _value != 0;
671         bool withinPeriod = now >= startTime && now <= endTime;
672         bool withinCap = weiRaised.add(_value) <= cap;
673         // For presale we want to decline all payments less then minPresaleAmount
674         bool withinAmount = now >= startTime + 5 days || msg.value >= minPresaleAmount;
675 
676         return nonZeroPurchase && withinPeriod && withinCap && withinAmount;
677     }
678 
679     /**
680      * @dev check if crowdsale still active based on current time and cap
681      * @return true if crowdsale event has ended
682      */
683     function hasEnded() public constant returns (bool) {
684         bool capReached = weiRaised >= cap;
685         bool timeIsUp = now > endTime;
686         return timeIsUp || capReached;
687     }
688 
689     /**
690      * @dev if crowdsale is unsuccessful, investors can claim refunds here
691      */
692     function claimRefund() public {
693         require(isFinalized);
694         require(!goalReached());
695 
696         vault.refund(msg.sender);
697     }
698 
699     /**
700      * @dev finalize crowdsale. this method triggers vault and token finalization
701      */
702     function finalize() onlyOwner public {
703         require(!isFinalized);
704         require(hasEnded());
705 
706         // trigger vault and token finalization
707         if (goalReached()) {
708             vault.close(token.wingsWallet());
709         } else {
710             vault.enableRefunds();
711         }
712 
713         token.endTokensale();
714         isFinalized = true;
715 
716         Finalized();
717     }
718 
719     /**
720      * @dev check if hard cap goal is reached
721      */
722     function goalReached() public constant returns (bool) {
723         return weiRaised >= goal;
724     }
725 
726     /**
727      * @dev returns current token price based on current presale time frame
728      */
729     function getConversionRate() public constant returns (uint256) {
730         if (now >= startTime + 20 days) {
731             return 650;
732             // 650        Crowdasle Part 4
733         } else if (now >= startTime + 15 days) {
734             return 715;
735             // 650 + 10%. Crowdasle Part 3
736         } else if (now >= startTime + 10 days) {
737             return 780;
738             // 650 + 20%. Crowdasle Part 2
739         } else if (now >= startTime + 5 days) {
740             return 845;
741             // 650 + 30%. Crowdasle Part 1
742         } else if (now >= startTime) {
743             return 910;
744             // 650 + 40%. Presale
745         }
746         return 0;
747     }
748 
749     /**
750      * @dev killer method that can bu used by owner to
751      *      kill the contract and send funds to owner
752      */
753     function kill() onlyOwner whenPaused {
754         selfdestruct(owner);
755     }
756 }