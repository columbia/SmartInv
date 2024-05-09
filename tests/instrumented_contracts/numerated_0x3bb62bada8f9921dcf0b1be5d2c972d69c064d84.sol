1 pragma solidity ^0.4.15;
2 
3 
4 contract Token {
5     /* This is a slight change to the ERC20 base standard.
6     function totalSupply() constant returns (uint256 supply);
7     is replaced with:
8     uint256 public totalSupply;
9     This automatically creates a getter function for the totalSupply.
10     This is moved to the base contract since public getter functions are not
11     currently recognised as an implementation of the matching abstract
12     function by the compiler.
13     */
14     /// total amount of tokens
15     uint256 public totalSupply;
16 
17     /// @param _owner The address from which the balance will be retrieved
18     /// @return The balance
19     function balanceOf(address _owner) constant returns (uint256 balance);
20 
21     /// @notice send `_value` token to `_to` from `msg.sender`
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transfer(address _to, uint256 _value) returns (bool success);
26 
27     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
28     /// @param _from The address of the sender
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
33 
34     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @param _value The amount of tokens to be approved for transfer
37     /// @return Whether the approval was successful or not
38     function approve(address _spender, uint256 _value) returns (bool success);
39 
40     /// @param _owner The address of the account owning tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @return Amount of remaining tokens allowed to spent
43     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
44 
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 }
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54   address public owner;
55 
56 
57   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   function Ownable() {
65     owner = msg.sender;
66   }
67 
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) onlyOwner public {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 /**
90  * @title SafeMath
91  * @dev Math operations with safety checks that throw on error
92  */
93 library SafeMath {
94   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
95     uint256 c = a * b;
96     assert(a == 0 || c / a == b);
97     return c;
98   }
99 
100   function div(uint256 a, uint256 b) internal constant returns (uint256) {
101     // assert(b > 0); // Solidity automatically throws when dividing by 0
102     uint256 c = a / b;
103     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104     return c;
105   }
106 
107   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
108     assert(b <= a);
109     return a - b;
110   }
111 
112   function add(uint256 a, uint256 b) internal constant returns (uint256) {
113     uint256 c = a + b;
114     assert(c >= a);
115     return c;
116   }
117 }
118 
119 
120 
121 contract AbstractPaymentEscrow is Ownable {
122 
123     address public wallet;
124 
125     mapping (uint => uint) public deposits;
126 
127     event Payment(address indexed _customer, uint indexed _projectId, uint value);
128     event Withdraw(address indexed _wallet, uint value);
129 
130     function withdrawFunds() public;
131 
132     /**
133      * @dev Change the wallet
134      * @param _wallet address of the wallet where fees will be transfered when spent
135      */
136     function changeWallet(address _wallet)
137         public
138         onlyOwner()
139     {
140         wallet = _wallet;
141     }
142 
143     /**
144      * @dev Get the amount deposited for the provided project, returns 0 if there's no deposit for that project or the amount in wei
145      * @param _projectId The id of the project
146      * @return 0 if there's either no deposit for _projectId, otherwise returns the deposited amount in wei
147      */
148     function getDeposit(uint _projectId)
149         public
150         constant
151         returns (uint)
152     {
153         return deposits[_projectId];
154     }
155 }
156 
157 
158 
159 
160 contract TokitRegistry is Ownable {
161 
162     struct ProjectContracts {
163         address token;
164         address fund;
165         address campaign;
166     }
167 
168     // registrar => true/false
169     mapping (address => bool) public registrars;
170 
171     // customer => project_id => token/campaign
172     mapping (address => mapping(uint => ProjectContracts)) public registry;
173     // project_id => token/campaign
174     mapping (uint => ProjectContracts) public project_registry;
175 
176     event RegisteredToken(address indexed _projectOwner, uint indexed _projectId, address _token, address _fund);
177     event RegisteredCampaign(address indexed _projectOwner, uint indexed _projectId, address _campaign);
178 
179     modifier onlyRegistrars() {
180         require(registrars[msg.sender]);
181         _;
182     }
183 
184     function TokitRegistry(address _owner) {
185         setRegistrar(_owner, true);
186         transferOwnership(_owner);
187     }
188 
189     function register(address _customer, uint _projectId, address _token, address _fund)
190         onlyRegistrars()
191     {
192         registry[_customer][_projectId].token = _token;
193         registry[_customer][_projectId].fund = _fund;
194 
195         project_registry[_projectId].token = _token;
196         project_registry[_projectId].fund = _fund;
197 
198         RegisteredToken(_customer, _projectId, _token, _fund);
199     }
200 
201     function register(address _customer, uint _projectId, address _campaign)
202         onlyRegistrars()
203     {
204         registry[_customer][_projectId].campaign = _campaign;
205 
206         project_registry[_projectId].campaign = _campaign;
207 
208         RegisteredCampaign(_customer, _projectId, _campaign);
209     }
210 
211     function lookup(address _customer, uint _projectId)
212         constant
213         returns (address token, address fund, address campaign)
214     {
215         return (
216             registry[_customer][_projectId].token,
217             registry[_customer][_projectId].fund,
218             registry[_customer][_projectId].campaign
219         );
220     }
221 
222     function lookupByProject(uint _projectId)
223         constant
224         returns (address token, address fund, address campaign)
225     {
226         return (
227             project_registry[_projectId].token,
228             project_registry[_projectId].fund,
229             project_registry[_projectId].campaign
230         );
231     }
232 
233     function setRegistrar(address _registrar, bool enabled)
234         onlyOwner()
235     {
236         registrars[_registrar] = enabled;
237     }
238 }
239 
240 
241 
242 
243 
244 /// @title Fund contract - Implements reward distribution.
245 /// @author Stefan George - <stefan.george@consensys.net>
246 /// @author Milad Mostavi - <milad.mostavi@consensys.net>
247 contract SingularDTVFund {
248     string public version = "0.1.0";
249 
250     /*
251      *  External contracts
252      */
253     AbstractSingularDTVToken public singularDTVToken;
254 
255     /*
256      *  Storage
257      */
258     address public owner;
259     uint public totalReward;
260 
261     // User's address => Reward at time of withdraw
262     mapping (address => uint) public rewardAtTimeOfWithdraw;
263 
264     // User's address => Reward which can be withdrawn
265     mapping (address => uint) public owed;
266 
267     modifier onlyOwner() {
268         // Only guard is allowed to do this action.
269         if (msg.sender != owner) {
270             revert();
271         }
272         _;
273     }
274 
275     /*
276      *  Contract functions
277      */
278     /// @dev Deposits reward. Returns success.
279     function depositReward()
280         public
281         payable
282         returns (bool)
283     {
284         totalReward += msg.value;
285         return true;
286     }
287 
288     /// @dev Withdraws reward for user. Returns reward.
289     /// @param forAddress user's address.
290     function calcReward(address forAddress) private returns (uint) {
291         return singularDTVToken.balanceOf(forAddress) * (totalReward - rewardAtTimeOfWithdraw[forAddress]) / singularDTVToken.totalSupply();
292     }
293 
294     /// @dev Withdraws reward for user. Returns reward.
295     function withdrawReward()
296         public
297         returns (uint)
298     {
299         uint value = calcReward(msg.sender) + owed[msg.sender];
300         rewardAtTimeOfWithdraw[msg.sender] = totalReward;
301         owed[msg.sender] = 0;
302         if (value > 0 && !msg.sender.send(value)) {
303             revert();
304         }
305         return value;
306     }
307 
308     /// @dev Credits reward to owed balance.
309     /// @param forAddress user's address.
310     function softWithdrawRewardFor(address forAddress)
311         external
312         returns (uint)
313     {
314         uint value = calcReward(forAddress);
315         rewardAtTimeOfWithdraw[forAddress] = totalReward;
316         owed[forAddress] += value;
317         return value;
318     }
319 
320     /// @dev Setup function sets external token address.
321     /// @param singularDTVTokenAddress Token address.
322     function setup(address singularDTVTokenAddress)
323         external
324         onlyOwner
325         returns (bool)
326     {
327         if (address(singularDTVToken) == 0) {
328             singularDTVToken = AbstractSingularDTVToken(singularDTVTokenAddress);
329             return true;
330         }
331         return false;
332     }
333 
334     /// @dev Contract constructor function sets guard address.
335     function SingularDTVFund() {
336         // Set owner address
337         owner = msg.sender;
338     }
339 
340     /// @dev Fallback function acts as depositReward()
341     function ()
342         public
343         payable
344     {
345         if (msg.value == 0) {
346             withdrawReward();
347         } else {
348             depositReward();
349         }
350     }
351 }
352 
353 
354 
355 
356 
357 
358 
359 contract StandardToken is Token {
360 
361     function transfer(address _to, uint256 _value) returns (bool success) {
362         //Default assumes totalSupply can't be over max (2^256 - 1).
363         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
364         //Replace the if with this one instead.
365         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
366         require(balances[msg.sender] >= _value);
367         balances[msg.sender] -= _value;
368         balances[_to] += _value;
369         Transfer(msg.sender, _to, _value);
370         return true;
371     }
372 
373     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
374         //same as above. Replace this line with the following if you want to protect against wrapping uints.
375         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
376         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
377         balances[_to] += _value;
378         balances[_from] -= _value;
379         allowed[_from][msg.sender] -= _value;
380         Transfer(_from, _to, _value);
381         return true;
382     }
383 
384     function balanceOf(address _owner) constant returns (uint256 balance) {
385         return balances[_owner];
386     }
387 
388     function approve(address _spender, uint256 _value) returns (bool success) {
389         allowed[msg.sender][_spender] = _value;
390         Approval(msg.sender, _spender, _value);
391         return true;
392     }
393 
394     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
395       return allowed[_owner][_spender];
396     }
397 
398     /* Approves and then calls the receiving contract */
399     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
400         allowed[msg.sender][_spender] = _value;
401         Approval(msg.sender, _spender, _value);
402 
403         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
404         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
405         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
406         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
407         return true;
408     }
409 
410     mapping (address => uint256) balances;
411     mapping (address => mapping (address => uint256)) allowed;
412 }
413 
414 
415 
416 contract AbstractSingularDTVFund {
417     function softWithdrawRewardFor(address forAddress) returns (uint);
418 }
419 
420 /// @title Token contract - Implements token issuance.
421 /// @author Stefan George - <stefan.george@consensys.net>
422 /// @author Milad Mostavi - <milad.mostavi@consensys.net>
423 contract SingularDTVToken is StandardToken {
424     string public version = "0.1.0";
425 
426     /*
427      *  External contracts
428      */
429     AbstractSingularDTVFund public singularDTVFund;
430 
431     /*
432      *  Token meta data
433      */
434     string public name;
435     string public symbol;
436     uint8 public constant decimals = 18;
437 
438     /// @dev Transfers sender's tokens to a given address. Returns success.
439     /// @param to Address of token receiver.
440     /// @param value Number of tokens to transfer.
441     function transfer(address to, uint256 value)
442         returns (bool)
443     {
444         // Both parties withdraw their reward first
445         singularDTVFund.softWithdrawRewardFor(msg.sender);
446         singularDTVFund.softWithdrawRewardFor(to);
447         return super.transfer(to, value);
448     }
449 
450     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
451     /// @param from Address from where tokens are withdrawn.
452     /// @param to Address to where tokens are sent.
453     /// @param value Number of tokens to transfer.
454     function transferFrom(address from, address to, uint256 value)
455         returns (bool)
456     {
457         // Both parties withdraw their reward first
458         singularDTVFund.softWithdrawRewardFor(from);
459         singularDTVFund.softWithdrawRewardFor(to);
460         return super.transferFrom(from, to, value);
461     }
462 
463     function SingularDTVToken(address sDTVFundAddr, address _wallet, string _name, string _symbol, uint _totalSupply) {
464         if(sDTVFundAddr == 0 || _wallet == 0) {
465             // Fund and Wallet addresses should not be null.
466             revert();
467         }
468 
469         balances[_wallet] = _totalSupply;
470         totalSupply = _totalSupply;
471 
472         name = _name;
473         symbol = _symbol;
474 
475         singularDTVFund = AbstractSingularDTVFund(sDTVFundAddr);
476 
477         Transfer(this, _wallet, _totalSupply);
478     }
479 }
480 
481 
482 
483 
484 
485 
486 
487 
488 contract AbstractSingularDTVToken is Token {
489 
490 }
491 
492 
493 /// @title Token Creation contract - Implements token creation functionality.
494 /// @author Stefan George - <stefan.george@consensys.net>
495 /// @author Razvan Pop - <razvan.pop@consensys.net>
496 /// @author Milad Mostavi - <milad.mostavi@consensys.net>
497 contract SingularDTVLaunch {
498     string public version = "0.1.0";
499 
500     event Contributed(address indexed contributor, uint contribution, uint tokens);
501 
502     /*
503      *  External contracts
504      */
505     AbstractSingularDTVToken public singularDTVToken;
506     address public workshop;
507     address public SingularDTVWorkshop = 0xc78310231aA53bD3D0FEA2F8c705C67730929D8f;
508     uint public SingularDTVWorkshopFee;
509 
510     /*
511      *  Constants
512      */
513     uint public CAP; // in wei scale of tokens
514     uint public DURATION; // in seconds
515     uint public TOKEN_TARGET; // Goal threshold in wei scale of tokens
516 
517     /*
518      *  Enums
519      */
520     enum Stages {
521         Deployed,
522         GoingAndGoalNotReached,
523         EndedAndGoalNotReached,
524         GoingAndGoalReached,
525         EndedAndGoalReached
526     }
527 
528     /*
529      *  Storage
530      */
531     address public owner;
532     uint public startDate;
533     uint public fundBalance;
534     uint public valuePerToken; //in wei
535     uint public tokensSent;
536 
537     // participant address => value in Wei
538     mapping (address => uint) public contributions;
539 
540     // participant address => token amount in wei scale
541     mapping (address => uint) public sentTokens;
542 
543     // Initialize stage
544     Stages public stage = Stages.Deployed;
545 
546     modifier onlyOwner() {
547         // Only owner is allowed to do this action.
548         if (msg.sender != owner) {
549             revert();
550         }
551         _;
552     }
553 
554     modifier atStage(Stages _stage) {
555         if (stage != _stage) {
556             revert();
557         }
558         _;
559     }
560 
561     modifier atStageOR(Stages _stage1, Stages _stage2) {
562         if (stage != _stage1 && stage != _stage2) {
563             revert();
564         }
565         _;
566     }
567 
568     modifier timedTransitions() {
569         uint timeElapsed = now - startDate;
570 
571         if (timeElapsed >= DURATION) {
572             if (stage == Stages.GoingAndGoalNotReached) {
573                 stage = Stages.EndedAndGoalNotReached;
574             } else if (stage == Stages.GoingAndGoalReached) {
575                 stage = Stages.EndedAndGoalReached;
576             }
577         }
578         _;
579     }
580 
581     /*
582      *  Contract functions
583      */
584     /// dev Validates invariants.
585     function checkInvariants() constant internal {
586         if (fundBalance > this.balance) {
587             revert();
588         }
589     }
590 
591     /// @dev Can be triggered if an invariant fails.
592     function emergencyCall()
593         public
594         returns (bool)
595     {
596         if (fundBalance > this.balance) {
597             if (this.balance > 0 && !SingularDTVWorkshop.send(this.balance)) {
598                 revert();
599             }
600             return true;
601         }
602         return false;
603     }
604 
605     /// @dev Allows user to create tokens if token creation is still going and cap not reached. Returns token count.
606     function fund()
607         public
608         timedTransitions
609         atStageOR(Stages.GoingAndGoalNotReached, Stages.GoingAndGoalReached)
610         payable
611         returns (uint)
612     {
613         uint tokenCount = (msg.value * (10**18)) / valuePerToken; // Token count in wei is rounded down. Sent ETH should be multiples of valuePerToken.
614         require(tokenCount > 0);
615         if (tokensSent + tokenCount > CAP) {
616             // User wants to create more tokens than available. Set tokens to possible maximum.
617             tokenCount = CAP - tokensSent;
618         }
619         tokensSent += tokenCount;
620 
621         uint contribution = (tokenCount * valuePerToken) / (10**18); // Ether spent by user.
622         // Send change back to user.
623         if (msg.value > contribution && !msg.sender.send(msg.value - contribution)) {
624             revert();
625         }
626         // Update fund and user's balance and total supply of tokens.
627         fundBalance += contribution;
628         contributions[msg.sender] += contribution;
629         sentTokens[msg.sender] += tokenCount;
630         if (!singularDTVToken.transfer(msg.sender, tokenCount)) {
631             // Tokens could not be issued.
632             revert();
633         }
634         // Update stage
635         if (stage == Stages.GoingAndGoalNotReached) {
636             if (tokensSent >= TOKEN_TARGET) {
637                 stage = Stages.GoingAndGoalReached;
638             }
639         }
640         // not an else clause for the edge case that the CAP and TOKEN_TARGET are reached in one call
641         if (stage == Stages.GoingAndGoalReached) {
642             if (tokensSent == CAP) {
643                 stage = Stages.EndedAndGoalReached;
644             }
645         }
646         checkInvariants();
647 
648         Contributed(msg.sender, contribution, tokenCount);
649 
650         return tokenCount;
651     }
652 
653     /// @dev Allows user to withdraw ETH if token creation period ended and target was not reached. Returns contribution.
654     function withdrawContribution()
655         public
656         timedTransitions
657         atStage(Stages.EndedAndGoalNotReached)
658         returns (uint)
659     {
660         // We get back the tokens from the contributor before giving back his contribution
661         uint tokensReceived = sentTokens[msg.sender];
662         sentTokens[msg.sender] = 0;
663         if (!singularDTVToken.transferFrom(msg.sender, owner, tokensReceived)) {
664             revert();
665         }
666 
667         // Update fund's and user's balance and total supply of tokens.
668         uint contribution = contributions[msg.sender];
669         contributions[msg.sender] = 0;
670         fundBalance -= contribution;
671         // Send ETH back to user.
672         if (contribution > 0) {
673             msg.sender.transfer(contribution);
674         }
675         checkInvariants();
676         return contribution;
677     }
678 
679     /// @dev Withdraws ETH to workshop address. Returns success.
680     function withdrawForWorkshop()
681         public
682         timedTransitions
683         atStage(Stages.EndedAndGoalReached)
684         returns (bool)
685     {
686         uint value = fundBalance;
687         fundBalance = 0;
688 
689         require(value > 0);
690 
691         uint networkFee = value * SingularDTVWorkshopFee / 100;
692         workshop.transfer(value - networkFee);
693         SingularDTVWorkshop.transfer(networkFee);
694 
695         uint remainingTokens = CAP - tokensSent;
696         if (remainingTokens > 0 && !singularDTVToken.transfer(owner, remainingTokens)) {
697             revert();
698         }
699 
700         checkInvariants();
701         return true;
702     }
703 
704     /// @dev Allows owner to get back unsent tokens in case of launch failure (EndedAndGoalNotReached).
705     function withdrawUnsentTokensForOwner()
706         public
707         timedTransitions
708         atStage(Stages.EndedAndGoalNotReached)
709         returns (uint)
710     {
711         uint remainingTokens = CAP - tokensSent;
712         if (remainingTokens > 0 && !singularDTVToken.transfer(owner, remainingTokens)) {
713             revert();
714         }
715 
716         checkInvariants();
717         return remainingTokens;
718     }
719 
720     /// @dev Sets token value in Wei.
721     /// @param valueInWei New value.
722     function changeValuePerToken(uint valueInWei)
723         public
724         onlyOwner
725         atStage(Stages.Deployed)
726         returns (bool)
727     {
728         valuePerToken = valueInWei;
729         return true;
730     }
731 
732     // updateStage allows calls to receive correct stage. It can be used for transactions but is not part of the regular token creation routine.
733     // It is not marked as constant because timedTransitions modifier is altering state and constant is not yet enforced by solc.
734     /// @dev returns correct stage, even if a function with timedTransitions modifier has not yet been called successfully.
735     function updateStage()
736         public
737         timedTransitions
738         returns (Stages)
739     {
740         return stage;
741     }
742 
743     function start()
744         public
745         onlyOwner
746         atStage(Stages.Deployed)
747         returns (uint)
748     {
749         if (!singularDTVToken.transferFrom(msg.sender, this, CAP)) {
750             revert();
751         }
752 
753         startDate = now;
754         stage = Stages.GoingAndGoalNotReached;
755 
756         checkInvariants();
757         return startDate;
758     }
759 
760     /// @dev Contract constructor function sets owner and start date.
761     function SingularDTVLaunch(
762         address singularDTVTokenAddress,
763         address _workshop,
764         address _owner,
765         uint _total,
766         uint _unit_price,
767         uint _duration,
768         uint _threshold,
769         uint _singulardtvwoskhop_fee
770         ) {
771         singularDTVToken = AbstractSingularDTVToken(singularDTVTokenAddress);
772         workshop = _workshop;
773         owner = _owner;
774         CAP = _total; // Total number of tokens (wei scale)
775         valuePerToken = _unit_price; // wei per token
776         DURATION = _duration; // in seconds
777         TOKEN_TARGET = _threshold; // Goal threshold
778         SingularDTVWorkshopFee = _singulardtvwoskhop_fee;
779     }
780 
781     /// @dev Fallback function acts as fund() when stage GoingAndGoalNotReached
782     /// or GoingAndGoalReached. And act as withdrawFunding() when EndedAndGoalNotReached.
783     /// otherwise throw.
784     function ()
785         public
786         payable
787     {
788         if (stage == Stages.GoingAndGoalNotReached || stage == Stages.GoingAndGoalReached)
789             fund();
790         else if (stage == Stages.EndedAndGoalNotReached)
791             withdrawContribution();
792         else
793             revert();
794     }
795 }
796 
797 
798 
799 
800 
801 
802 
803 contract TokitDeployer is Ownable {
804 
805     TokitRegistry public registry;
806 
807     // payment_type => payment_contract
808     mapping (uint8 => AbstractPaymentEscrow) public paymentContracts;
809 
810     event DeployedToken(address indexed _customer, uint indexed _projectId, address _token, address _fund);
811     event DeployedCampaign(address indexed _customer, uint indexed _projectId, address _campaign);
812 
813 
814     function TokitDeployer(address _owner, address _registry) {
815         transferOwnership(_owner);
816         registry = TokitRegistry(_registry);
817     }
818 
819     function deployToken(
820         address _customer, uint _projectId, uint8 _payedWith, uint _amountNeeded,
821         // SingularDTVToken
822         address _wallet, string _name, string _symbol, uint _totalSupply
823     )
824         onlyOwner()
825     {
826         // payed for
827         require(AbstractPaymentEscrow(paymentContracts[_payedWith]).getDeposit(_projectId) >= _amountNeeded);
828 
829         var (t,,) = registry.lookup(_customer, _projectId);
830         // not deployed yet
831         require(t == address(0));
832 
833 
834         SingularDTVFund fund = new SingularDTVFund();
835         SingularDTVToken token = new SingularDTVToken(fund, _wallet, _name, _symbol, _totalSupply);
836         fund.setup(token);
837 
838         registry.register(_customer, _projectId, token, fund);
839 
840         DeployedToken(_customer, _projectId, token, fund);
841     }
842 
843     function deployCampaign(
844         address _customer, uint _projectId,
845         // SingularDTVLaunch
846         address _workshop, uint _total, uint _unitPrice, uint _duration, uint _threshold, uint _networkFee
847     )
848         onlyOwner()
849     {
850         var (t,f,c) = registry.lookup(_customer, _projectId);
851         // not deployed yet
852         require(c == address(0));
853 
854         // payed for, token & fund deployed
855         require(t != address(0) && f != address(0));
856 
857         SingularDTVLaunch campaign = new SingularDTVLaunch(t, _workshop, _customer, _total, _unitPrice, _duration, _threshold, _networkFee);
858 
859         registry.register(_customer, _projectId, campaign);
860 
861         DeployedCampaign(_customer, _projectId, campaign);
862     }
863 
864     function setRegistryContract(address _registry)
865         onlyOwner()
866     {
867         registry = TokitRegistry(_registry);
868     }
869 
870     function setPaymentContract(uint8 _paymentType, address _paymentContract)
871         onlyOwner()
872     {
873         paymentContracts[_paymentType] = AbstractPaymentEscrow(_paymentContract);
874     }
875 
876     function deletePaymentContract(uint8 _paymentType)
877         onlyOwner()
878     {
879         delete paymentContracts[_paymentType];
880     }
881 }