1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     require(newOwner != address(0));
69     OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 
75 contract AbstractPaymentEscrow is Ownable {
76 
77     address public wallet;
78 
79     mapping (uint => uint) public deposits;
80 
81     event Payment(address indexed _customer, uint indexed _projectId, uint value);
82     event Withdraw(address indexed _wallet, uint value);
83 
84     function withdrawFunds() public;
85 
86     /**
87      * @dev Change the wallet
88      * @param _wallet address of the wallet where fees will be transfered when spent
89      */
90     function changeWallet(address _wallet)
91         public
92         onlyOwner()
93     {
94         wallet = _wallet;
95     }
96 
97     /**
98      * @dev Get the amount deposited for the provided project, returns 0 if there's no deposit for that project or the amount in wei
99      * @param _projectId The id of the project
100      * @return 0 if there's either no deposit for _projectId, otherwise returns the deposited amount in wei
101      */
102     function getDeposit(uint _projectId)
103         public
104         constant
105         returns (uint)
106     {
107         return deposits[_projectId];
108     }
109 }
110 
111 contract TokitRegistry is Ownable {
112 
113     struct ProjectContracts {
114         address token;
115         address fund;
116         address campaign;
117     }
118 
119     // registrar => true/false
120     mapping (address => bool) public registrars;
121 
122     // customer => project_id => token/campaign
123     mapping (address => mapping(uint => ProjectContracts)) public registry;
124     // project_id => token/campaign
125     mapping (uint => ProjectContracts) public project_registry;
126 
127     event RegisteredToken(address indexed _projectOwner, uint indexed _projectId, address _token, address _fund);
128     event RegisteredCampaign(address indexed _projectOwner, uint indexed _projectId, address _campaign);
129 
130     modifier onlyRegistrars() {
131         require(registrars[msg.sender]);
132         _;
133     }
134 
135     function TokitRegistry(address _owner) {
136         setRegistrar(_owner, true);
137         transferOwnership(_owner);
138     }
139 
140     function register(address _customer, uint _projectId, address _token, address _fund)
141         onlyRegistrars()
142     {
143         registry[_customer][_projectId].token = _token;
144         registry[_customer][_projectId].fund = _fund;
145 
146         project_registry[_projectId].token = _token;
147         project_registry[_projectId].fund = _fund;
148 
149         RegisteredToken(_customer, _projectId, _token, _fund);
150     }
151 
152     function register(address _customer, uint _projectId, address _campaign)
153         onlyRegistrars()
154     {
155         registry[_customer][_projectId].campaign = _campaign;
156 
157         project_registry[_projectId].campaign = _campaign;
158 
159         RegisteredCampaign(_customer, _projectId, _campaign);
160     }
161 
162     function lookup(address _customer, uint _projectId)
163         constant
164         returns (address token, address fund, address campaign)
165     {
166         return (
167             registry[_customer][_projectId].token,
168             registry[_customer][_projectId].fund,
169             registry[_customer][_projectId].campaign
170         );
171     }
172 
173     function lookupByProject(uint _projectId)
174         constant
175         returns (address token, address fund, address campaign)
176     {
177         return (
178             project_registry[_projectId].token,
179             project_registry[_projectId].fund,
180             project_registry[_projectId].campaign
181         );
182     }
183 
184     function setRegistrar(address _registrar, bool enabled)
185         onlyOwner()
186     {
187         registrars[_registrar] = enabled;
188     }
189 }
190 
191 // Abstract contract for the full ERC 20 Token standard
192 // https://github.com/ethereum/EIPs/issues/20
193 
194 contract Token {
195     /* This is a slight change to the ERC20 base standard.
196     function totalSupply() constant returns (uint256 supply);
197     is replaced with:
198     uint256 public totalSupply;
199     This automatically creates a getter function for the totalSupply.
200     This is moved to the base contract since public getter functions are not
201     currently recognised as an implementation of the matching abstract
202     function by the compiler.
203     */
204     /// total amount of tokens
205     uint256 public totalSupply;
206 
207     /// @param _owner The address from which the balance will be retrieved
208     /// @return The balance
209     function balanceOf(address _owner) constant returns (uint256 balance);
210 
211     /// @notice send `_value` token to `_to` from `msg.sender`
212     /// @param _to The address of the recipient
213     /// @param _value The amount of token to be transferred
214     /// @return Whether the transfer was successful or not
215     function transfer(address _to, uint256 _value) returns (bool success);
216 
217     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
218     /// @param _from The address of the sender
219     /// @param _to The address of the recipient
220     /// @param _value The amount of token to be transferred
221     /// @return Whether the transfer was successful or not
222     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
223 
224     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
225     /// @param _spender The address of the account able to transfer the tokens
226     /// @param _value The amount of tokens to be approved for transfer
227     /// @return Whether the approval was successful or not
228     function approve(address _spender, uint256 _value) returns (bool success);
229 
230     /// @param _owner The address of the account owning tokens
231     /// @param _spender The address of the account able to transfer the tokens
232     /// @return Amount of remaining tokens allowed to spent
233     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
234 
235     event Transfer(address indexed _from, address indexed _to, uint256 _value);
236     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
237 }
238 
239 contract AbstractSingularDTVToken is Token {
240 }
241 
242 /// @title Fund contract - Implements reward distribution.
243 /// @author Stefan George - <stefan.george@consensys.net>
244 /// @author Milad Mostavi - <milad.mostavi@consensys.net>
245 contract SingularDTVFund {
246     string public version = "0.1.0";
247 
248     /*
249      *  External contracts
250      */
251     AbstractSingularDTVToken public singularDTVToken;
252 
253     /*
254      *  Storage
255      */
256     address public owner;
257     uint public totalReward;
258 
259     // User's address => Reward at time of withdraw
260     mapping (address => uint) public rewardAtTimeOfWithdraw;
261 
262     // User's address => Reward which can be withdrawn
263     mapping (address => uint) public owed;
264 
265     modifier onlyOwner() {
266         // Only guard is allowed to do this action.
267         if (msg.sender != owner) {
268             revert();
269         }
270         _;
271     }
272 
273     /*
274      *  Contract functions
275      */
276     /// @dev Deposits reward. Returns success.
277     function depositReward()
278         public
279         payable
280         returns (bool)
281     {
282         totalReward += msg.value;
283         return true;
284     }
285 
286     /// @dev Withdraws reward for user. Returns reward.
287     /// @param forAddress user's address.
288     function calcReward(address forAddress) private returns (uint) {
289         return singularDTVToken.balanceOf(forAddress) * (totalReward - rewardAtTimeOfWithdraw[forAddress]) / singularDTVToken.totalSupply();
290     }
291 
292     /// @dev Withdraws reward for user. Returns reward.
293     function withdrawReward()
294         public
295         returns (uint)
296     {
297         uint value = calcReward(msg.sender) + owed[msg.sender];
298         rewardAtTimeOfWithdraw[msg.sender] = totalReward;
299         owed[msg.sender] = 0;
300         if (value > 0 && !msg.sender.send(value)) {
301             revert();
302         }
303         return value;
304     }
305 
306     /// @dev Credits reward to owed balance.
307     /// @param forAddress user's address.
308     function softWithdrawRewardFor(address forAddress)
309         external
310         returns (uint)
311     {
312         uint value = calcReward(forAddress);
313         rewardAtTimeOfWithdraw[forAddress] = totalReward;
314         owed[forAddress] += value;
315         return value;
316     }
317 
318     /// @dev Setup function sets external token address.
319     /// @param singularDTVTokenAddress Token address.
320     function setup(address singularDTVTokenAddress)
321         external
322         onlyOwner
323         returns (bool)
324     {
325         if (address(singularDTVToken) == 0) {
326             singularDTVToken = AbstractSingularDTVToken(singularDTVTokenAddress);
327             return true;
328         }
329         return false;
330     }
331 
332     /// @dev Contract constructor function sets guard address.
333     function SingularDTVFund() {
334         // Set owner address
335         owner = msg.sender;
336     }
337 
338     /// @dev Fallback function acts as depositReward()
339     function ()
340         public
341         payable
342     {
343         if (msg.value == 0) {
344             withdrawReward();
345         } else {
346             depositReward();
347         }
348     }
349 }
350 
351 /// @title Token Creation contract - Implements token creation functionality.
352 /// @author Stefan George - <stefan.george@consensys.net>
353 /// @author Razvan Pop - <razvan.pop@consensys.net>
354 /// @author Milad Mostavi - <milad.mostavi@consensys.net>
355 contract SingularDTVLaunch {
356     string public version = "0.1.0";
357 
358     event Contributed(address indexed contributor, uint contribution, uint tokens);
359 
360     /*
361      *  External contracts
362      */
363     AbstractSingularDTVToken public singularDTVToken;
364     address public workshop;
365     address public SingularDTVWorkshop = 0xc78310231aA53bD3D0FEA2F8c705C67730929D8f;
366     uint public SingularDTVWorkshopFee;
367 
368     /*
369      *  Constants
370      */
371     uint public CAP; // in wei scale of tokens
372     uint public DURATION; // in seconds
373     uint public TOKEN_TARGET; // Goal threshold in wei scale of tokens
374 
375     /*
376      *  Enums
377      */
378     enum Stages {
379         Deployed,
380         GoingAndGoalNotReached,
381         EndedAndGoalNotReached,
382         GoingAndGoalReached,
383         EndedAndGoalReached
384     }
385 
386     /*
387      *  Storage
388      */
389     address public owner;
390     uint public startDate;
391     uint public fundBalance;
392     uint public valuePerToken; //in wei
393     uint public tokensSent;
394 
395     // participant address => value in Wei
396     mapping (address => uint) public contributions;
397 
398     // participant address => token amount in wei scale
399     mapping (address => uint) public sentTokens;
400 
401     // Initialize stage
402     Stages public stage = Stages.Deployed;
403 
404     modifier onlyOwner() {
405         // Only owner is allowed to do this action.
406         if (msg.sender != owner) {
407             revert();
408         }
409         _;
410     }
411 
412     modifier atStage(Stages _stage) {
413         if (stage != _stage) {
414             revert();
415         }
416         _;
417     }
418 
419     modifier atStageOR(Stages _stage1, Stages _stage2) {
420         if (stage != _stage1 && stage != _stage2) {
421             revert();
422         }
423         _;
424     }
425 
426     modifier timedTransitions() {
427         uint timeElapsed = now - startDate;
428 
429         if (timeElapsed >= DURATION) {
430             if (stage == Stages.GoingAndGoalNotReached) {
431                 stage = Stages.EndedAndGoalNotReached;
432             } else if (stage == Stages.GoingAndGoalReached) {
433                 stage = Stages.EndedAndGoalReached;
434             }
435         }
436         _;
437     }
438 
439     /*
440      *  Contract functions
441      */
442     /// dev Validates invariants.
443     function checkInvariants() constant internal {
444         if (fundBalance > this.balance) {
445             revert();
446         }
447     }
448 
449     /// @dev Can be triggered if an invariant fails.
450     function emergencyCall()
451         public
452         returns (bool)
453     {
454         if (fundBalance > this.balance) {
455             if (this.balance > 0 && !SingularDTVWorkshop.send(this.balance)) {
456                 revert();
457             }
458             return true;
459         }
460         return false;
461     }
462 
463     /// @dev Allows user to create tokens if token creation is still going and cap not reached. Returns token count.
464     function fund()
465         public
466         timedTransitions
467         atStageOR(Stages.GoingAndGoalNotReached, Stages.GoingAndGoalReached)
468         payable
469         returns (uint)
470     {
471         uint tokenCount = (msg.value * (10**18)) / valuePerToken; // Token count in wei is rounded down. Sent ETH should be multiples of valuePerToken.
472         require(tokenCount > 0);
473         if (tokensSent + tokenCount > CAP) {
474             // User wants to create more tokens than available. Set tokens to possible maximum.
475             tokenCount = CAP - tokensSent;
476         }
477         tokensSent += tokenCount;
478 
479         uint contribution = (tokenCount * valuePerToken) / (10**18); // Ether spent by user.
480         // Send change back to user.
481         if (msg.value > contribution && !msg.sender.send(msg.value - contribution)) {
482             revert();
483         }
484         // Update fund and user's balance and total supply of tokens.
485         fundBalance += contribution;
486         contributions[msg.sender] += contribution;
487         sentTokens[msg.sender] += tokenCount;
488         if (!singularDTVToken.transfer(msg.sender, tokenCount)) {
489             // Tokens could not be issued.
490             revert();
491         }
492         // Update stage
493         if (stage == Stages.GoingAndGoalNotReached) {
494             if (tokensSent >= TOKEN_TARGET) {
495                 stage = Stages.GoingAndGoalReached;
496             }
497         }
498         // not an else clause for the edge case that the CAP and TOKEN_TARGET are reached in one call
499         if (stage == Stages.GoingAndGoalReached) {
500             if (tokensSent == CAP) {
501                 stage = Stages.EndedAndGoalReached;
502             }
503         }
504         checkInvariants();
505 
506         Contributed(msg.sender, contribution, tokenCount);
507 
508         return tokenCount;
509     }
510 
511     /// @dev Allows user to withdraw ETH if token creation period ended and target was not reached. Returns contribution.
512     function withdrawContribution()
513         public
514         timedTransitions
515         atStage(Stages.EndedAndGoalNotReached)
516         returns (uint)
517     {
518         // We get back the tokens from the contributor before giving back his contribution
519         uint tokensReceived = sentTokens[msg.sender];
520         sentTokens[msg.sender] = 0;
521         if (!singularDTVToken.transferFrom(msg.sender, owner, tokensReceived)) {
522             revert();
523         }
524 
525         // Update fund's and user's balance and total supply of tokens.
526         uint contribution = contributions[msg.sender];
527         contributions[msg.sender] = 0;
528         fundBalance -= contribution;
529         // Send ETH back to user.
530         if (contribution > 0) {
531             msg.sender.transfer(contribution);
532         }
533         checkInvariants();
534         return contribution;
535     }
536 
537     /// @dev Withdraws ETH to workshop address. Returns success.
538     function withdrawForWorkshop()
539         public
540         timedTransitions
541         atStage(Stages.EndedAndGoalReached)
542         returns (bool)
543     {
544         uint value = fundBalance;
545         fundBalance = 0;
546 
547         require(value > 0);
548 
549         uint networkFee = value * SingularDTVWorkshopFee / 100;
550         workshop.transfer(value - networkFee);
551         SingularDTVWorkshop.transfer(networkFee);
552 
553         uint remainingTokens = CAP - tokensSent;
554         if (remainingTokens > 0 && !singularDTVToken.transfer(owner, remainingTokens)) {
555             revert();
556         }
557 
558         checkInvariants();
559         return true;
560     }
561 
562     /// @dev Allows owner to get back unsent tokens in case of launch failure (EndedAndGoalNotReached).
563     function withdrawUnsentTokensForOwner()
564         public
565         timedTransitions
566         atStage(Stages.EndedAndGoalNotReached)
567         returns (uint)
568     {
569         uint remainingTokens = CAP - tokensSent;
570         if (remainingTokens > 0 && !singularDTVToken.transfer(owner, remainingTokens)) {
571             revert();
572         }
573 
574         checkInvariants();
575         return remainingTokens;
576     }
577 
578     /// @dev Sets token value in Wei.
579     /// @param valueInWei New value.
580     function changeValuePerToken(uint valueInWei)
581         public
582         onlyOwner
583         atStage(Stages.Deployed)
584         returns (bool)
585     {
586         valuePerToken = valueInWei;
587         return true;
588     }
589 
590     // updateStage allows calls to receive correct stage. It can be used for transactions but is not part of the regular token creation routine.
591     // It is not marked as constant because timedTransitions modifier is altering state and constant is not yet enforced by solc.
592     /// @dev returns correct stage, even if a function with timedTransitions modifier has not yet been called successfully.
593     function updateStage()
594         public
595         timedTransitions
596         returns (Stages)
597     {
598         return stage;
599     }
600 
601     function start()
602         public
603         onlyOwner
604         atStage(Stages.Deployed)
605         returns (uint)
606     {
607         if (!singularDTVToken.transferFrom(msg.sender, this, CAP)) {
608             revert();
609         }
610 
611         startDate = now;
612         stage = Stages.GoingAndGoalNotReached;
613 
614         checkInvariants();
615         return startDate;
616     }
617 
618     /// @dev Contract constructor function sets owner and start date.
619     function SingularDTVLaunch(
620         address singularDTVTokenAddress,
621         address _workshop,
622         address _owner,
623         uint _total,
624         uint _unit_price,
625         uint _duration,
626         uint _threshold,
627         uint _singulardtvwoskhop_fee
628         ) {
629         singularDTVToken = AbstractSingularDTVToken(singularDTVTokenAddress);
630         workshop = _workshop;
631         owner = _owner;
632         CAP = _total; // Total number of tokens (wei scale)
633         valuePerToken = _unit_price; // wei per token
634         DURATION = _duration; // in seconds
635         TOKEN_TARGET = _threshold; // Goal threshold
636         SingularDTVWorkshopFee = _singulardtvwoskhop_fee;
637     }
638 
639     /// @dev Fallback function acts as fund() when stage GoingAndGoalNotReached
640     /// or GoingAndGoalReached. And act as withdrawFunding() when EndedAndGoalNotReached.
641     /// otherwise throw.
642     function ()
643         public
644         payable
645     {
646         if (stage == Stages.GoingAndGoalNotReached || stage == Stages.GoingAndGoalReached)
647             fund();
648         else if (stage == Stages.EndedAndGoalNotReached)
649             withdrawContribution();
650         else
651             revert();
652     }
653 }
654 
655 contract AbstractSingularDTVFund {
656     function softWithdrawRewardFor(address forAddress) returns (uint);
657 }
658 
659 contract StandardToken is Token {
660 
661     function transfer(address _to, uint256 _value) returns (bool success) {
662         //Default assumes totalSupply can't be over max (2^256 - 1).
663         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
664         //Replace the if with this one instead.
665         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
666         require(balances[msg.sender] >= _value);
667         balances[msg.sender] -= _value;
668         balances[_to] += _value;
669         Transfer(msg.sender, _to, _value);
670         return true;
671     }
672 
673     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
674         //same as above. Replace this line with the following if you want to protect against wrapping uints.
675         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
676         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
677         balances[_to] += _value;
678         balances[_from] -= _value;
679         allowed[_from][msg.sender] -= _value;
680         Transfer(_from, _to, _value);
681         return true;
682     }
683 
684     function balanceOf(address _owner) constant returns (uint256 balance) {
685         return balances[_owner];
686     }
687 
688     function approve(address _spender, uint256 _value) returns (bool success) {
689         allowed[msg.sender][_spender] = _value;
690         Approval(msg.sender, _spender, _value);
691         return true;
692     }
693 
694     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
695       return allowed[_owner][_spender];
696     }
697 
698     /* Approves and then calls the receiving contract */
699     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
700         allowed[msg.sender][_spender] = _value;
701         Approval(msg.sender, _spender, _value);
702 
703         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
704         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
705         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
706         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
707         return true;
708     }
709 
710     mapping (address => uint256) balances;
711     mapping (address => mapping (address => uint256)) allowed;
712 }
713 
714 /// @title Token contract - Implements token issuance.
715 /// @author Stefan George - <stefan.george@consensys.net>
716 /// @author Milad Mostavi - <milad.mostavi@consensys.net>
717 contract SingularDTVToken is StandardToken {
718     string public version = "0.1.0";
719 
720     /*
721      *  External contracts
722      */
723     AbstractSingularDTVFund public singularDTVFund;
724 
725     /*
726      *  Token meta data
727      */
728     string public name;
729     string public symbol;
730     uint8 public constant decimals = 18;
731 
732     /// @dev Transfers sender's tokens to a given address. Returns success.
733     /// @param to Address of token receiver.
734     /// @param value Number of tokens to transfer.
735     function transfer(address to, uint256 value)
736         returns (bool)
737     {
738         // Both parties withdraw their reward first
739         singularDTVFund.softWithdrawRewardFor(msg.sender);
740         singularDTVFund.softWithdrawRewardFor(to);
741         return super.transfer(to, value);
742     }
743 
744     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
745     /// @param from Address from where tokens are withdrawn.
746     /// @param to Address to where tokens are sent.
747     /// @param value Number of tokens to transfer.
748     function transferFrom(address from, address to, uint256 value)
749         returns (bool)
750     {
751         // Both parties withdraw their reward first
752         singularDTVFund.softWithdrawRewardFor(from);
753         singularDTVFund.softWithdrawRewardFor(to);
754         return super.transferFrom(from, to, value);
755     }
756 
757     function SingularDTVToken(address sDTVFundAddr, address _wallet, string _name, string _symbol, uint _totalSupply) {
758         if(sDTVFundAddr == 0 || _wallet == 0) {
759             // Fund and Wallet addresses should not be null.
760             revert();
761         }
762 
763         balances[_wallet] = _totalSupply;
764         totalSupply = _totalSupply;
765 
766         name = _name;
767         symbol = _symbol;
768 
769         singularDTVFund = AbstractSingularDTVFund(sDTVFundAddr);
770 
771         Transfer(this, _wallet, _totalSupply);
772     }
773 }
774 
775 contract TokitDeployer is Ownable {
776 
777     TokitRegistry public registry;
778 
779     // payment_type => payment_contract
780     mapping (uint8 => AbstractPaymentEscrow) public paymentContracts;
781 
782     event DeployedToken(address indexed _customer, uint indexed _projectId, address _token, address _fund);
783     event DeployedCampaign(address indexed _customer, uint indexed _projectId, address _campaign);
784 
785 
786     function TokitDeployer(address _owner, address _registry) {
787         transferOwnership(_owner);
788         registry = TokitRegistry(_registry);
789     }
790 
791     function deployToken(
792         address _customer, uint _projectId, uint8 _payedWith, uint _amountNeeded,
793         // SingularDTVToken
794         address _wallet, string _name, string _symbol, uint _totalSupply
795     )
796         onlyOwner()
797     {
798         // payed for
799         require(AbstractPaymentEscrow(paymentContracts[_payedWith]).getDeposit(_projectId) >= _amountNeeded);
800 
801         var (t,,) = registry.lookup(_customer, _projectId);
802         // not deployed yet
803         require(t == address(0));
804 
805 
806         SingularDTVFund fund = new SingularDTVFund();
807         SingularDTVToken token = new SingularDTVToken(fund, _wallet, _name, _symbol, _totalSupply);
808         fund.setup(token);
809 
810         registry.register(_customer, _projectId, token, fund);
811 
812         DeployedToken(_customer, _projectId, token, fund);
813     }
814 
815     function deployCampaign(
816         address _customer, uint _projectId,
817         // SingularDTVLaunch
818         address _workshop, uint _total, uint _unitPrice, uint _duration, uint _threshold, uint _networkFee
819     )
820         onlyOwner()
821     {
822         var (t,f,c) = registry.lookup(_customer, _projectId);
823         // not deployed yet
824         require(c == address(0));
825 
826         // payed for, token & fund deployed
827         require(t != address(0) && f != address(0));
828 
829         SingularDTVLaunch campaign = new SingularDTVLaunch(t, _workshop, _customer, _total, _unitPrice, _duration, _threshold, _networkFee);
830 
831         registry.register(_customer, _projectId, campaign);
832 
833         DeployedCampaign(_customer, _projectId, campaign);
834     }
835 
836     function setRegistryContract(address _registry)
837         onlyOwner()
838     {
839         registry = TokitRegistry(_registry);
840     }
841 
842     function setPaymentContract(uint8 _paymentType, address _paymentContract)
843         onlyOwner()
844     {
845         paymentContracts[_paymentType] = AbstractPaymentEscrow(_paymentContract);
846     }
847 
848     function deletePaymentContract(uint8 _paymentType)
849         onlyOwner()
850     {
851         delete paymentContracts[_paymentType];
852     }
853 }