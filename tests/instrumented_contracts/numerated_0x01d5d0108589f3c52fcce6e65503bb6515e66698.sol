1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Ownership interface
5  *
6  * Perminent ownership
7  *
8  * #created 01/10/2017
9  * #author Frank Bonnet
10  */
11 contract IOwnership {
12 
13     /**
14      * Returns true if `_account` is the current owner
15      *
16      * @param _account The address to test against
17      */
18     function isOwner(address _account) constant returns (bool);
19 
20 
21     /**
22      * Gets the current owner
23      *
24      * @return address The current owner
25      */
26     function getOwner() constant returns (address);
27 }
28 
29 
30 /**
31  * @title Ownership
32  *
33  * Perminent ownership
34  *
35  * #created 01/10/2017
36  * #author Frank Bonnet
37  */
38 contract Ownership is IOwnership {
39 
40     // Owner
41     address internal owner;
42 
43 
44     /**
45      * The publisher is the inital owner
46      */
47     function Ownership() {
48         owner = msg.sender;
49     }
50 
51 
52     /**
53      * Access is restricted to the current owner
54      */
55     modifier only_owner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60 
61     /**
62      * Returns true if `_account` is the current owner
63      *
64      * @param _account The address to test against
65      */
66     function isOwner(address _account) public constant returns (bool) {
67         return _account == owner;
68     }
69 
70 
71     /**
72      * Gets the current owner
73      *
74      * @return address The current owner
75      */
76     function getOwner() public constant returns (address) {
77         return owner;
78     }
79 }
80 
81 
82 /**
83  * @title Transferable ownership interface
84  *
85  * Enhances ownership by allowing the current owner to 
86  * transfer ownership to a new owner
87  *
88  * #created 01/10/2017
89  * #author Frank Bonnet
90  */
91 contract ITransferableOwnership {
92     
93 
94     /**
95      * Transfer ownership to `_newOwner`
96      *
97      * @param _newOwner The address of the account that will become the new owner 
98      */
99     function transferOwnership(address _newOwner);
100 }
101 
102 
103 /**
104  * @title Transferable ownership
105  *
106  * Enhances ownership by allowing the current owner to 
107  * transfer ownership to a new owner
108  *
109  * #created 01/10/2017
110  * #author Frank Bonnet
111  */
112 contract TransferableOwnership is ITransferableOwnership, Ownership {
113 
114 
115     /**
116      * Transfer ownership to `_newOwner`
117      *
118      * @param _newOwner The address of the account that will become the new owner 
119      */
120     function transferOwnership(address _newOwner) public only_owner {
121         owner = _newOwner;
122     }
123 }
124 
125 
126 /**
127  * @title Multi-owned interface
128  *
129  * Interface that allows multiple owners
130  *
131  * #created 09/10/2017
132  * #author Frank Bonnet
133  */
134 contract IMultiOwned {
135 
136     /**
137      * Returns true if `_account` is an owner
138      *
139      * @param _account The address to test against
140      */
141     function isOwner(address _account) constant returns (bool);
142 
143 
144     /**
145      * Returns the amount of owners
146      *
147      * @return The amount of owners
148      */
149     function getOwnerCount() constant returns (uint);
150 
151 
152     /**
153      * Gets the owner at `_index`
154      *
155      * @param _index The index of the owner
156      * @return The address of the owner found at `_index`
157      */
158     function getOwnerAt(uint _index) constant returns (address);
159 
160 
161      /**
162      * Adds `_account` as a new owner
163      *
164      * @param _account The account to add as an owner
165      */
166     function addOwner(address _account);
167 
168 
169     /**
170      * Removes `_account` as an owner
171      *
172      * @param _account The account to remove as an owner
173      */
174     function removeOwner(address _account);
175 }
176 
177 
178 /**
179  * @title Token retrieve interface
180  *
181  * Allows tokens to be retrieved from a contract
182  *
183  * #created 29/09/2017
184  * #author Frank Bonnet
185  */
186 contract ITokenRetriever {
187 
188     /**
189      * Extracts tokens from the contract
190      *
191      * @param _tokenContract The address of ERC20 compatible token
192      */
193     function retrieveTokens(address _tokenContract);
194 }
195 
196 
197 /**
198  * @title Token retrieve
199  *
200  * Allows tokens to be retrieved from a contract
201  *
202  * #created 18/10/2017
203  * #author Frank Bonnet
204  */
205 contract TokenRetriever is ITokenRetriever {
206 
207     /**
208      * Extracts tokens from the contract
209      *
210      * @param _tokenContract The address of ERC20 compatible token
211      */
212     function retrieveTokens(address _tokenContract) public {
213         IToken tokenInstance = IToken(_tokenContract);
214         uint tokenBalance = tokenInstance.balanceOf(this);
215         if (tokenBalance > 0) {
216             tokenInstance.transfer(msg.sender, tokenBalance);
217         }
218     }
219 }
220 
221 
222 /**
223  * @title Token observer interface
224  *
225  * Allows a token smart-contract to notify observers 
226  * when tokens are received
227  *
228  * #created 09/10/2017
229  * #author Frank Bonnet
230  */
231 contract ITokenObserver {
232 
233     /**
234      * Called by the observed token smart-contract in order 
235      * to notify the token observer when tokens are received
236      *
237      * @param _from The address that the tokens where send from
238      * @param _value The amount of tokens that was received
239      */
240     function notifyTokensReceived(address _from, uint _value);
241 }
242 
243 
244 /**
245  * @title Abstract token observer
246  *
247  * Allows observers to be notified by an observed token smart-contract
248  * when tokens are received
249  *
250  * #created 09/10/2017
251  * #author Frank Bonnet
252  */
253 contract TokenObserver is ITokenObserver {
254 
255     /**
256      * Called by the observed token smart-contract in order 
257      * to notify the token observer when tokens are received
258      *
259      * @param _from The address that the tokens where send from
260      * @param _value The amount of tokens that was received
261      */
262     function notifyTokensReceived(address _from, uint _value) public {
263         onTokensReceived(msg.sender, _from, _value);
264     }
265 
266 
267     /**
268      * Event handler
269      * 
270      * Called by `_token` when a token amount is received
271      *
272      * @param _token The token contract that received the transaction
273      * @param _from The account or contract that send the transaction
274      * @param _value The value of tokens that where received
275      */
276     function onTokensReceived(address _token, address _from, uint _value) internal;
277 }
278 
279 
280 /**
281  * @title ERC20 compatible token interface
282  *
283  * - Implements ERC 20 Token standard
284  * - Implements short address attack fix
285  *
286  * #created 29/09/2017
287  * #author Frank Bonnet
288  */
289 contract IToken { 
290 
291     /** 
292      * Get the total supply of tokens
293      * 
294      * @return The total supply
295      */
296     function totalSupply() constant returns (uint);
297 
298 
299     /** 
300      * Get balance of `_owner` 
301      * 
302      * @param _owner The address from which the balance will be retrieved
303      * @return The balance
304      */
305     function balanceOf(address _owner) constant returns (uint);
306 
307 
308     /** 
309      * Send `_value` token to `_to` from `msg.sender`
310      * 
311      * @param _to The address of the recipient
312      * @param _value The amount of token to be transferred
313      * @return Whether the transfer was successful or not
314      */
315     function transfer(address _to, uint _value) returns (bool);
316 
317 
318     /** 
319      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
320      * 
321      * @param _from The address of the sender
322      * @param _to The address of the recipient
323      * @param _value The amount of token to be transferred
324      * @return Whether the transfer was successful or not
325      */
326     function transferFrom(address _from, address _to, uint _value) returns (bool);
327 
328 
329     /** 
330      * `msg.sender` approves `_spender` to spend `_value` tokens
331      * 
332      * @param _spender The address of the account able to transfer the tokens
333      * @param _value The amount of tokens to be approved for transfer
334      * @return Whether the approval was successful or not
335      */
336     function approve(address _spender, uint _value) returns (bool);
337 
338 
339     /** 
340      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
341      * 
342      * @param _owner The address of the account owning tokens
343      * @param _spender The address of the account able to transfer the tokens
344      * @return Amount of remaining tokens allowed to spent
345      */
346     function allowance(address _owner, address _spender) constant returns (uint);
347 }
348 
349 
350 /**
351  * @title Dcorp Proxy
352  *
353  * Serves as a placeholder for the Dcorp funds, allowing the community the ability to vote on the acceptance of the VC platform,
354  * and the transfer of token ownership. This mechanism is in place to allow the unlocking of the original DRP token, and to allow token 
355  * holders to convert to DRPU or DRPS.
356 
357  * This proxy is deployed upon receiving the Ether that is currently held by the DRP Crowdsale contract.
358  *
359  * #created 16/10/2017
360  * #author Frank Bonnet
361  */
362 contract DcorpProxy is TokenObserver, TransferableOwnership, TokenRetriever {
363 
364     enum Stages {
365         Deploying,
366         Deployed,
367         Executed
368     }
369 
370     struct Balance {
371         uint drps;
372         uint drpu;
373         uint index;
374     }
375 
376     struct Vote {
377         uint datetime;
378         bool support;
379         uint index;
380     }
381 
382     struct Proposal {
383         uint createdTimestamp;
384         uint supportingWeight;
385         uint rejectingWeight;
386         mapping(address => Vote) votes;
387         address[] voteIndex;
388         uint index;
389     }
390 
391     // State
392     Stages private stage;
393 
394     // Settings
395     uint private constant VOTING_DURATION = 7 days;
396     uint private constant MIN_QUORUM = 5; // 5%
397 
398     // Alocated balances
399     mapping (address => Balance) private allocated;
400     address[] private allocatedIndex;
401 
402     // Proposals
403     mapping(address => Proposal) private proposals;
404     address[] private proposalIndex;
405 
406     // Tokens
407     IToken private drpsToken;
408     IToken private drpuToken;
409 
410     // Crowdsale
411     address private drpCrowdsale;
412     uint public drpCrowdsaleRecordedBalance;
413 
414 
415     /**
416      * Require that the proxy is in `_stage` 
417      */
418     modifier only_at_stage(Stages _stage) {
419         require(stage == _stage);
420         _;
421     }
422 
423 
424     /**
425      * Require `_token` to be one of the drp tokens
426      *
427      * @param _token The address to test against
428      */
429     modifier only_accepted_token(address _token) {
430         require(_token == address(drpsToken) || _token == address(drpuToken));
431         _;
432     }
433 
434 
435     /**
436      * Require that `_token` is not one of the drp tokens
437      *
438      * @param _token The address to test against
439      */
440     modifier not_accepted_token(address _token) {
441         require(_token != address(drpsToken) && _token != address(drpuToken));
442         _;
443     }
444 
445 
446     /**
447      * Require that sender has more than zero tokens 
448      */
449     modifier only_token_holder() {
450         require(allocated[msg.sender].drps > 0 || allocated[msg.sender].drpu > 0);
451         _;
452     }
453 
454 
455     /**
456      * Require `_proposedAddress` to have been proposed already
457      *
458      * @param _proposedAddress Address that needs to be proposed
459      */
460     modifier only_proposed(address _proposedAddress) {
461         require(isProposed(_proposedAddress));
462         _;
463     }
464 
465 
466     /**
467      * Require that the voting period for the proposal has
468      * not yet ended
469      *
470      * @param _proposedAddress Address that was proposed
471      */
472     modifier only_during_voting_period(address _proposedAddress) {
473         require(now <= proposals[_proposedAddress].createdTimestamp + VOTING_DURATION);
474         _;
475     }
476 
477 
478     /**
479      * Require that the voting period for the proposal has ended
480      *
481      * @param _proposedAddress Address that was proposed
482      */
483     modifier only_after_voting_period(address _proposedAddress) {
484         require(now > proposals[_proposedAddress].createdTimestamp + VOTING_DURATION);
485         _;
486     }
487 
488 
489     /**
490      * Require that the proposal is supported
491      *
492      * @param _proposedAddress Address that was proposed
493      */
494     modifier only_when_supported(address _proposedAddress) {
495         require(isSupported(_proposedAddress, false));
496         _;
497     }
498     
499 
500     /**
501      * Construct the proxy
502      *
503      * @param _drpsToken The new security token
504      * @param _drpuToken The new utility token
505      * @param _drpCrowdsale Proxy accepts and requires ether from the crowdsale
506      */
507     function DcorpProxy(address _drpsToken, address _drpuToken, address _drpCrowdsale) {
508         drpsToken = IToken(_drpsToken);
509         drpuToken = IToken(_drpuToken);
510         drpCrowdsale = _drpCrowdsale;
511         drpCrowdsaleRecordedBalance = _drpCrowdsale.balance;
512         stage = Stages.Deploying;
513     }
514 
515 
516     /**
517      * Returns whether the proxy is being deployed
518      *
519      * @return Whether the proxy is in the deploying stage
520      */
521     function isDeploying() public constant returns (bool) {
522         return stage == Stages.Deploying;
523     }
524 
525 
526     /**
527      * Returns whether the proxy is deployed. The proxy is deployed 
528      * when it receives Ether from the drp crowdsale contract
529      *
530      * @return Whether the proxy is deployed
531      */
532     function isDeployed() public constant returns (bool) {
533         return stage == Stages.Deployed;
534     }
535 
536 
537     /**
538      * Returns whether a proposal, and with it the proxy itself, is 
539      * already executed or not
540      *
541      * @return Whether the proxy is executed
542      */
543     function isExecuted() public constant returns (bool) {
544         return stage == Stages.Executed;
545     }
546 
547 
548     /**
549      * Accept eth from the crowdsale while deploying
550      */
551     function () public payable only_at_stage(Stages.Deploying) {
552         require(msg.sender == drpCrowdsale);
553     }
554 
555 
556     /**
557      * Deploy the proxy
558      */
559     function deploy() only_owner only_at_stage(Stages.Deploying) {
560         require(this.balance >= drpCrowdsaleRecordedBalance);
561         stage = Stages.Deployed;
562     }
563 
564 
565     /**
566      * Returns the combined total supply of all drp tokens
567      *
568      * @return The combined total drp supply
569      */
570     function getTotalSupply() public constant returns (uint) {
571         uint sum = 0; 
572         sum += drpsToken.totalSupply();
573         sum += drpuToken.totalSupply();
574         return sum;
575     }
576 
577 
578     /**
579      * Returns true if `_owner` has a balance allocated
580      *
581      * @param _owner The account that the balance is allocated for
582      * @return True if there is a balance that belongs to `_owner`
583      */
584     function hasBalance(address _owner) public constant returns (bool) {
585         return allocatedIndex.length > 0 && _owner == allocatedIndex[allocated[_owner].index];
586     }
587 
588 
589     /** 
590      * Get the allocated drps token balance of `_owner`
591      * 
592      * @param _token The address to test against
593      * @param _owner The address from which the allocated token balance will be retrieved
594      * @return The allocated drps token balance
595      */
596     function balanceOf(address _token, address _owner) public constant returns (uint) {
597         uint balance = 0;
598         if (address(drpsToken) == _token) {
599             balance = allocated[_owner].drps;
600         } 
601         
602         else if (address(drpuToken) == _token) {
603             balance = allocated[_owner].drpu;
604         }
605 
606         return balance;
607     }
608 
609 
610     /**
611      * Returns true if `_proposedAddress` is already proposed
612      *
613      * @param _proposedAddress Address that was proposed
614      * @return Whether `_proposedAddress` is already proposed 
615      */
616     function isProposed(address _proposedAddress) public constant returns (bool) {
617         return proposalIndex.length > 0 && _proposedAddress == proposalIndex[proposals[_proposedAddress].index];
618     }
619 
620 
621     /**
622      * Returns the how many proposals where made
623      *
624      * @return The amount of proposals
625      */
626     function getProposalCount() public constant returns (uint) {
627         return proposalIndex.length;
628     }
629 
630 
631     /**
632      * Propose the transfer token ownership and all funds to `_proposedAddress` 
633      *
634      * @param _proposedAddress The proposed DCORP address 
635      */
636     function propose(address _proposedAddress) public only_owner only_at_stage(Stages.Deployed) {
637         require(!isProposed(_proposedAddress));
638 
639         // Add proposal
640         Proposal storage p = proposals[_proposedAddress];
641         p.createdTimestamp = now;
642         p.index = proposalIndex.push(_proposedAddress) - 1;
643     }
644 
645 
646     /**
647      * Gets the voting duration, the amount of time voting 
648      * is allowed
649      *
650      * @return Voting duration
651      */
652     function getVotingDuration() public constant returns (uint) {              
653         return VOTING_DURATION;
654     }
655 
656 
657     /**
658      * Gets the number of votes towards a proposal
659      *
660      * @param _proposedAddress The proposed DCORP address 
661      * @return uint Vote count
662      */
663     function getVoteCount(address _proposedAddress) public constant returns (uint) {              
664         return proposals[_proposedAddress].voteIndex.length;
665     }
666 
667 
668     /**
669      * Returns true if `_account` has voted on the proposal
670      *
671      * @param _proposedAddress The proposed DCORP address 
672      * @param _account The key (address) that maps to the vote
673      * @return bool Whether `_account` has voted on the proposal
674      */
675     function hasVoted(address _proposedAddress, address _account) public constant returns (bool) {
676         bool voted = false;
677         if (getVoteCount(_proposedAddress) > 0) {
678             Proposal storage p = proposals[_proposedAddress];
679             voted = p.voteIndex[p.votes[_account].index] == _account;
680         }
681 
682         return voted;
683     }
684 
685 
686     /**
687      * Returns true if `_account` supported the proposal and returns 
688      * false if `_account` is opposed to the proposal
689      *
690      * Does not check if `_account` had voted, use hasVoted()
691      *
692      * @param _proposedAddress The proposed DCORP address 
693      * @param _account The key (address) that maps to the vote
694      * @return bool Supported
695      */
696     function getVote(address _proposedAddress, address _account) public constant returns (bool) {
697         return proposals[_proposedAddress].votes[_account].support;
698     }
699 
700 
701     /**
702      * Allows a token holder to vote on a proposal
703      *
704      * @param _proposedAddress The proposed DCORP address 
705      * @param _support True if supported
706      */
707     function vote(address _proposedAddress, bool _support) public only_at_stage(Stages.Deployed) only_proposed(_proposedAddress) only_during_voting_period(_proposedAddress) only_token_holder {    
708         Proposal storage p = proposals[_proposedAddress];
709         Balance storage b = allocated[msg.sender];
710         
711         // Register vote
712         if (!hasVoted(_proposedAddress, msg.sender)) {
713             p.votes[msg.sender] = Vote(
714                 now, _support, p.voteIndex.push(msg.sender) - 1);
715 
716             // Register weight
717             if (_support) {
718                 p.supportingWeight += b.drps + b.drpu;
719             } else {
720                 p.rejectingWeight += b.drps + b.drpu;
721             }
722         } else {
723             Vote storage v = p.votes[msg.sender];
724             if (v.support != _support) {
725 
726                 // Register changed weight
727                 if (_support) {
728                     p.supportingWeight += b.drps + b.drpu;
729                     p.rejectingWeight -= b.drps + b.drpu;
730                 } else {
731                     p.rejectingWeight += b.drps + b.drpu;
732                     p.supportingWeight -= b.drps + b.drpu;
733                 }
734 
735                 v.support = _support;
736                 v.datetime = now;
737             }
738         }
739     }
740 
741 
742     /**
743      * Returns the current voting results for a proposal
744      *
745      * @param _proposedAddress The proposed DCORP address 
746      * @return supported, rejected
747      */
748     function getVotingResult(address _proposedAddress) public constant returns (uint, uint) {      
749         Proposal storage p = proposals[_proposedAddress];    
750         return (p.supportingWeight, p.rejectingWeight);
751     }
752 
753 
754     /**
755      * Returns true if the proposal is supported
756      *
757      * @param _proposedAddress The proposed DCORP address 
758      * @param _strict If set to true the function requires that the voting period is ended
759      * @return bool Supported
760      */
761     function isSupported(address _proposedAddress, bool _strict) public constant returns (bool) {        
762         Proposal storage p = proposals[_proposedAddress];
763         bool supported = false;
764 
765         if (!_strict || now > p.createdTimestamp + VOTING_DURATION) {
766             var (support, reject) = getVotingResult(_proposedAddress);
767             supported = support > reject;
768             if (supported) {
769                 supported = support + reject >= getTotalSupply() * MIN_QUORUM / 100;
770             }
771         }
772         
773         return supported;
774     }
775 
776 
777     /**
778      * Executes the proposal
779      *
780      * Should only be called after the voting period and 
781      * when the proposal is supported
782      *
783      * @param _acceptedAddress The accepted DCORP address 
784      * @return bool Success
785      */
786     function execute(address _acceptedAddress) public only_owner only_at_stage(Stages.Deployed) only_proposed(_acceptedAddress) only_after_voting_period(_acceptedAddress) only_when_supported(_acceptedAddress) {
787         
788         // Mark as executed
789         stage = Stages.Executed;
790 
791         // Add accepted address as token owner
792         IMultiOwned(drpsToken).addOwner(_acceptedAddress);
793         IMultiOwned(drpuToken).addOwner(_acceptedAddress);
794 
795         // Remove self token as owner
796         IMultiOwned(drpsToken).removeOwner(this);
797         IMultiOwned(drpuToken).removeOwner(this);
798 
799         // Transfer Eth (safe because we don't know how much gas is used counting votes)
800         uint balanceBefore = _acceptedAddress.balance;
801         uint balanceToSend = this.balance;
802         _acceptedAddress.transfer(balanceToSend);
803 
804         // Assert balances
805         assert(balanceBefore + balanceToSend == _acceptedAddress.balance);
806         assert(this.balance == 0);
807     }
808 
809 
810     /**
811      * Event handler that initializes the token conversion
812      * 
813      * Called by `_token` when a token amount is received on 
814      * the address of this token changer
815      *
816      * @param _token The token contract that received the transaction
817      * @param _from The account or contract that send the transaction
818      * @param _value The value of tokens that where received
819      */
820     function onTokensReceived(address _token, address _from, uint _value) internal only_at_stage(Stages.Deployed) only_accepted_token(_token) {
821         require(_token == msg.sender);
822 
823         // Allocate tokens
824         if (!hasBalance(_from)) {
825             allocated[_from] = Balance(
826                 0, 0, allocatedIndex.push(_from) - 1);
827         }
828 
829         Balance storage b = allocated[_from];
830         if (_token == address(drpsToken)) {
831             b.drps += _value;
832         } else {
833             b.drpu += _value;
834         }
835 
836         // Increase weight
837         _adjustWeight(_from, _value, true);
838     }
839 
840 
841     /**
842      * Withdraw DRPS tokens from the proxy and reduce the 
843      * owners weight accordingly
844      * 
845      * @param _value The amount of DRPS tokens to withdraw
846      */
847     function withdrawDRPS(uint _value) public {
848         Balance storage b = allocated[msg.sender];
849 
850         // Require sufficient balance
851         require(b.drps >= _value);
852         require(b.drps - _value <= b.drps);
853 
854         // Update balance
855         b.drps -= _value;
856 
857         // Reduce weight
858         _adjustWeight(msg.sender, _value, false);
859 
860         // Call external
861         if (!drpsToken.transfer(msg.sender, _value)) {
862             revert();
863         }
864     }
865 
866 
867     /**
868      * Withdraw DRPU tokens from the proxy and reduce the 
869      * owners weight accordingly
870      * 
871      * @param _value The amount of DRPU tokens to withdraw
872      */
873     function withdrawDRPU(uint _value) public {
874         Balance storage b = allocated[msg.sender];
875 
876         // Require sufficient balance
877         require(b.drpu >= _value);
878         require(b.drpu - _value <= b.drpu);
879 
880         // Update balance
881         b.drpu -= _value;
882 
883         // Reduce weight
884         _adjustWeight(msg.sender, _value, false);
885 
886         // Call external
887         if (!drpuToken.transfer(msg.sender, _value)) {
888             revert();
889         }
890     }
891 
892 
893     /**
894      * Failsafe mechanism
895      * 
896      * Allows the owner to retrieve tokens (other than DRPS and DRPU tokens) from the contract that 
897      * might have been send there by accident
898      *
899      * @param _tokenContract The address of ERC20 compatible token
900      */
901     function retrieveTokens(address _tokenContract) public only_owner not_accepted_token(_tokenContract) {
902         super.retrieveTokens(_tokenContract);
903     }
904 
905 
906     /**
907      * Adjust voting weight in ongoing proposals on which `_owner` 
908      * has already voted
909      * 
910      * @param _owner The owner of the weight
911      * @param _value The amount of weight that is adjusted
912      * @param _increase Indicated whether the weight is increased or decreased
913      */
914     function _adjustWeight(address _owner, uint _value, bool _increase) private {
915         for (uint i = proposalIndex.length; i > 0; i--) {
916             Proposal storage p = proposals[proposalIndex[i - 1]];
917             if (now > p.createdTimestamp + VOTING_DURATION) {
918                 break; // Last active proposal
919             }
920 
921             if (hasVoted(proposalIndex[i - 1], _owner)) {
922                 if (p.votes[_owner].support) {
923                     if (_increase) {
924                         p.supportingWeight += _value;
925                     } else {
926                         p.supportingWeight -= _value;
927                     }
928                 } else {
929                     if (_increase) {
930                         p.rejectingWeight += _value;
931                     } else {
932                         p.rejectingWeight -= _value;
933                     }
934                 }
935             }
936         }
937     }
938 }