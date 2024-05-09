1 pragma solidity ^0.4.18;
2 
3 /**
4  * IOwnership
5  *
6  * Perminent ownership
7  *
8  * #created 01/10/2017
9  * #author Frank Bonnet
10  */
11 interface IOwnership {
12 
13     /**
14      * Returns true if `_account` is the current owner
15      *
16      * @param _account The address to test against
17      */
18     function isOwner(address _account) public view returns (bool);
19 
20 
21     /**
22      * Gets the current owner
23      *
24      * @return address The current owner
25      */
26     function getOwner() public view returns (address);
27 }
28 
29 
30 /**
31  * Ownership
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
45      * Access is restricted to the current owner
46      */
47     modifier only_owner() {
48         require(msg.sender == owner);
49         _;
50     }
51 
52 
53     /**
54      * The publisher is the inital owner
55      */
56     function Ownership() public {
57         owner = msg.sender;
58     }
59 
60 
61     /**
62      * Returns true if `_account` is the current owner
63      *
64      * @param _account The address to test against
65      */
66     function isOwner(address _account) public view returns (bool) {
67         return _account == owner;
68     }
69 
70 
71     /**
72      * Gets the current owner
73      *
74      * @return address The current owner
75      */
76     function getOwner() public view returns (address) {
77         return owner;
78     }
79 }
80 
81 
82 /**
83  * ERC20 compatible token interface
84  *
85  * - Implements ERC 20 Token standard
86  * - Implements short address attack fix
87  *
88  * #created 29/09/2017
89  * #author Frank Bonnet
90  */
91 interface IToken { 
92 
93     /** 
94      * Get the total supply of tokens
95      * 
96      * @return The total supply
97      */
98     function totalSupply() public view returns (uint);
99 
100 
101     /** 
102      * Get balance of `_owner` 
103      * 
104      * @param _owner The address from which the balance will be retrieved
105      * @return The balance
106      */
107     function balanceOf(address _owner) public view returns (uint);
108 
109 
110     /** 
111      * Send `_value` token to `_to` from `msg.sender`
112      * 
113      * @param _to The address of the recipient
114      * @param _value The amount of token to be transferred
115      * @return Whether the transfer was successful or not
116      */
117     function transfer(address _to, uint _value) public returns (bool);
118 
119 
120     /** 
121      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
122      * 
123      * @param _from The address of the sender
124      * @param _to The address of the recipient
125      * @param _value The amount of token to be transferred
126      * @return Whether the transfer was successful or not
127      */
128     function transferFrom(address _from, address _to, uint _value) public returns (bool);
129 
130 
131     /** 
132      * `msg.sender` approves `_spender` to spend `_value` tokens
133      * 
134      * @param _spender The address of the account able to transfer the tokens
135      * @param _value The amount of tokens to be approved for transfer
136      * @return Whether the approval was successful or not
137      */
138     function approve(address _spender, uint _value) public returns (bool);
139 
140 
141     /** 
142      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
143      * 
144      * @param _owner The address of the account owning tokens
145      * @param _spender The address of the account able to transfer the tokens
146      * @return Amount of remaining tokens allowed to spent
147      */
148     function allowance(address _owner, address _spender) public view returns (uint);
149 }
150 
151 
152 /**
153  * ITokenObserver
154  *
155  * Allows a token smart-contract to notify observers 
156  * when tokens are received
157  *
158  * #created 09/10/2017
159  * #author Frank Bonnet
160  */
161 interface ITokenObserver {
162 
163 
164     /**
165      * Called by the observed token smart-contract in order 
166      * to notify the token observer when tokens are received
167      *
168      * @param _from The address that the tokens where send from
169      * @param _value The amount of tokens that was received
170      */
171     function notifyTokensReceived(address _from, uint _value) public;
172 }
173 
174 
175 /**
176  * TokenObserver
177  *
178  * Allows observers to be notified by an observed token smart-contract
179  * when tokens are received
180  *
181  * #created 09/10/2017
182  * #author Frank Bonnet
183  */
184 contract TokenObserver is ITokenObserver {
185 
186 
187     /**
188      * Called by the observed token smart-contract in order 
189      * to notify the token observer when tokens are received
190      *
191      * @param _from The address that the tokens where send from
192      * @param _value The amount of tokens that was received
193      */
194     function notifyTokensReceived(address _from, uint _value) public {
195         onTokensReceived(msg.sender, _from, _value);
196     }
197 
198 
199     /**
200      * Event handler
201      * 
202      * Called by `_token` when a token amount is received
203      *
204      * @param _token The token contract that received the transaction
205      * @param _from The account or contract that send the transaction
206      * @param _value The value of tokens that where received
207      */
208     function onTokensReceived(address _token, address _from, uint _value) internal;
209 }
210 
211 
212 /**
213  * ITokenRetriever
214  *
215  * Allows tokens to be retrieved from a contract
216  *
217  * #created 29/09/2017
218  * #author Frank Bonnet
219  */
220 interface ITokenRetriever {
221 
222     /**
223      * Extracts tokens from the contract
224      *
225      * @param _tokenContract The address of ERC20 compatible token
226      */
227     function retrieveTokens(address _tokenContract) public;
228 }
229 
230 
231 /**
232  * TokenRetriever
233  *
234  * Allows tokens to be retrieved from a contract
235  *
236  * #created 18/10/2017
237  * #author Frank Bonnet
238  */
239 contract TokenRetriever is ITokenRetriever {
240 
241     /**
242      * Extracts tokens from the contract
243      *
244      * @param _tokenContract The address of ERC20 compatible token
245      */
246     function retrieveTokens(address _tokenContract) public {
247         IToken tokenInstance = IToken(_tokenContract);
248         uint tokenBalance = tokenInstance.balanceOf(this);
249         if (tokenBalance > 0) {
250             tokenInstance.transfer(msg.sender, tokenBalance);
251         }
252     }
253 }
254 
255 
256 /**
257  * IDcorpCrowdsaleAdapter
258  *
259  * Interface that allows collective contributions from DCORP members
260  * 
261  * DCORP DAO VC & Promotion https://www.dcorp.it
262  *
263  * #created 10/11/2017
264  * #author Frank Bonnet
265  */
266 interface IDcorpCrowdsaleAdapter {
267 
268     /**
269      * Receive Eth and issue tokens to the sender
270      */
271     function isEnded() public view returns (bool);
272 
273 
274     /**
275      * Receive ether and issue tokens to the sender
276      *
277      * @return The accepted ether amount
278      */
279     function contribute() public payable returns (uint);
280 
281 
282     /**
283      * Receive ether and issue tokens to `_beneficiary`
284      *
285      * @param _beneficiary The account that receives the tokens
286      * @return The accepted ether amount
287      */
288     function contributeFor(address _beneficiary) public payable returns (uint);
289 
290 
291     /**
292      * Withdraw allocated tokens
293      */
294     function withdrawTokens() public;
295 
296 
297     /**
298      * Withdraw allocated ether
299      */
300     function withdrawEther() public;
301 
302 
303     /**
304      * Refund in the case of an unsuccessful crowdsale. The 
305      * crowdsale is considered unsuccessful if minAmount was 
306      * not raised before end of the crowdsale
307      */
308     function refund() public;
309 }
310 
311 
312 /**
313  * IDcorpPersonalCrowdsaleProxy
314  *
315  * #created 22/11/2017
316  * #author Frank Bonnet
317  */
318 interface IDcorpPersonalCrowdsaleProxy {
319 
320     /**
321      * Receive ether and issue tokens
322      * 
323      * This function requires that msg.sender is not a contract. This is required because it's 
324      * not possible for a contract to specify a gas amount when calling the (internal) send() 
325      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
326      * 
327      * Contracts can call the contribute() function instead
328      */
329     function () public payable;
330 }
331 
332 
333 /**
334  * DcorpPersonalCrowdsaleProxy
335  *
336  * Proxy that allows collective contributions from DCORP members using 
337  * a unique address
338  * 
339  * DCORP DAO VC & Promotion https://www.dcorp.it
340  *
341  * #created 22/11/2017
342  * #author Frank Bonnet
343  */
344 contract DcorpPersonalCrowdsaleProxy is IDcorpPersonalCrowdsaleProxy {
345 
346     address public member;
347     IDcorpCrowdsaleAdapter public target;
348     
349 
350     /**
351      * Deploy proxy
352      *
353      * @param _member Owner of the proxy
354      * @param _target Target crowdsale
355      */
356     function DcorpPersonalCrowdsaleProxy(address _member, address _target) public {
357         target = IDcorpCrowdsaleAdapter(_target);
358         member = _member;
359     }
360 
361 
362     /**
363      * Receive contribution and forward to the target crowdsale
364      * 
365      * This function requires that msg.sender is not a contract. This is required because it's 
366      * not possible for a contract to specify a gas amount when calling the (internal) send() 
367      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
368      */
369     function () public payable {
370         target.contributeFor.value(msg.value)(member);
371     }
372 }
373 
374 
375 /**
376  * IDcorpCrowdsaleProxy
377  *
378  * #created 23/11/2017
379  * #author Frank Bonnet
380  */
381 interface IDcorpCrowdsaleProxy {
382 
383     /**
384      * Receive ether and issue tokens to the sender
385      * 
386      * This function requires that msg.sender is not a contract. This is required because it's 
387      * not possible for a contract to specify a gas amount when calling the (internal) send() 
388      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
389      * 
390      * Contracts can call the contribute() function instead
391      */
392     function () public payable;
393 
394 
395     /**
396      * Receive ether and issue tokens to the sender
397      *
398      * @return The accepted ether amount
399      */
400     function contribute() public payable returns (uint);
401 
402 
403     /**
404      * Receive ether and issue tokens to `_beneficiary`
405      *
406      * @param _beneficiary The account that receives the tokens
407      * @return The accepted ether amount
408      */
409     function contributeFor(address _beneficiary) public payable returns (uint);
410 }
411 
412 
413 /**
414  * DcorpCrowdsaleProxy
415  *
416  * Proxy that allows collective contributions from DCORP members
417  * 
418  * DCORP DAO VC & Promotion https://www.dcorp.it
419  *
420  * #created 22/11/2017
421  * #author Frank Bonnet
422  */
423 contract DcorpCrowdsaleProxy is IDcorpCrowdsaleProxy, Ownership, TokenObserver, TokenRetriever {
424 
425     enum Stages {
426         Deploying,
427         Attached,
428         Deployed
429     }
430 
431     struct Record {
432         uint weight;
433         uint contributed;
434         uint withdrawnTokens;
435         uint index;
436     }
437 
438     Stages public stage;
439     bool private updating;
440 
441     // Member records
442     mapping (address => Record) private records;
443     address[] private recordIndex;
444 
445     uint public totalContributed;
446     uint public totalTokensReceived;
447     uint public totalTokensWithdrawn;
448     uint public totalWeight;
449 
450     // Weight calculation
451     uint public factorWeight;
452     uint public factorContributed;
453 
454     // Target crowdsale
455     IDcorpCrowdsaleAdapter public crowdsale;
456     IToken public token;
457 
458     // Dcorp tokens
459     IToken public drpsToken;
460     IToken public drpuToken;
461 
462 
463     /**
464      * Throw if at stage other than current stage
465      * 
466      * @param _stage expected stage to test for
467      */
468     modifier at_stage(Stages _stage) {
469         require(stage == _stage);
470         _;
471     }
472 
473 
474     /**
475      * Throw if crowdsale not ended yet
476      */
477     modifier only_when_ended() {
478         require(crowdsale.isEnded());
479         _;
480     }
481 
482 
483     /**
484      * Prevent reentry
485      */
486     modifier only_when_not_updating() {
487         require(!updating);
488         _;
489     }
490 
491 
492     // Events
493     event DcorpProxyCreated(address proxy, address beneficiary);
494 
495 
496     /**
497      * Deploy the proxy
498      */
499     function DcorpCrowdsaleProxy() public {
500         stage = Stages.Deploying;
501     }
502 
503 
504     /**
505      * Setup the proxy
506      *
507      * Share calcuation is based on the drpu and drps token balances and the 
508      * contributed amount of ether. The weight factor and contributed factor 
509      * determin the weight of each factor
510      *
511      * @param _drpsToken 1/2 tokens used for weight calculation
512      * @param _drpuToken 2/2 tokens used for weight calculation
513      * @param _factorWeight Weight of the token balance factor
514      * @param _factorContributed Weight of the contributed amount factor
515      */
516     function setup(address _drpsToken, address _drpuToken, uint _factorWeight, uint _factorContributed) public only_owner at_stage(Stages.Deploying) {
517         drpsToken = IToken(_drpsToken);
518         drpuToken = IToken(_drpuToken);
519         factorWeight = _factorWeight;
520         factorContributed = _factorContributed;
521     }
522 
523     
524     /**
525      * Attach a crowdsale and corresponding token to the proxy. Contributions are 
526      * forwarded to `_crowdsale` and rewards are denoted in tokens located at `_token`
527      *
528      * @param _crowdsale The crowdsale to forward contributions to
529      * @param _token The reward token
530      */
531     function attachCrowdsale(address _crowdsale, address _token) public only_owner at_stage(Stages.Deploying) {
532         stage = Stages.Attached;
533         crowdsale = IDcorpCrowdsaleAdapter(_crowdsale);
534         token = IToken(_token);
535     }
536 
537 
538     /**
539      * After calling the deploy function the proxy's
540      * rules become immutable 
541      */
542     function deploy() public only_owner at_stage(Stages.Attached) {
543         stage = Stages.Deployed;
544     }
545 
546 
547     /**
548      * Deploy a contract that serves as a proxy to 
549      * the crowdsale
550      *
551      * Contributions through this address will be made 
552      * for msg.sender
553      *
554      * @return The address of the deposit address
555      */
556     function createPersonalDepositAddress() public returns (address) {
557         address proxy = new DcorpPersonalCrowdsaleProxy(msg.sender, this);
558         DcorpProxyCreated(proxy, msg.sender);
559         return proxy;
560     }
561 
562 
563     /**
564      * Deploy a contract that serves as a proxy to 
565      * the crowdsale
566      *
567      * Contributions through this address will be made 
568      * for `_beneficiary`
569      *
570      * @param _beneficiary The owner of the proxy
571      * @return The address of the deposit address
572      */
573     function createPersonalDepositAddressFor(address _beneficiary) public returns (address) {
574         address proxy = new DcorpPersonalCrowdsaleProxy(_beneficiary, this);
575         DcorpProxyCreated(proxy, _beneficiary);
576         return proxy;
577     }
578 
579 
580     /**
581      * Returns true if `_member` has a record
582      *
583      * @param _member The account that has contributed
584      * @return True if there is a record that belongs to `_member`
585      */
586     function hasRecord(address _member) public view returns (bool) {
587         return records[_member].index < recordIndex.length && _member == recordIndex[records[_member].index];
588     }
589 
590 
591     /** 
592      * Get the recorded amount of ether that is contributed by `_member`
593      * 
594      * @param _member The address from which the contributed amount will be retrieved
595      * @return The contributed amount
596      */
597     function contributedAmountOf(address _member) public view returns (uint) {
598         return records[_member].contributed;
599     }
600 
601 
602     /** 
603      * Get the allocated token balance of `_member`
604      * 
605      * @param _member The address from which the allocated token balance will be retrieved
606      * @return The allocated token balance
607      */
608     function balanceOf(address _member) public view returns (uint) {
609         Record storage r = records[_member];
610         uint balance = 0;
611         uint share = shareOf(_member);
612         if (share > 0 && r.withdrawnTokens < share) {
613             balance = share - r.withdrawnTokens;
614         }
615 
616         return balance;
617     }
618 
619 
620     /** 
621      * Get the total share of the received tokens of `_member`
622      *
623      * Share calcuation is based on the drpu and drps token balances and the 
624      * contributed amount of ether. The weight factor and contributed factor 
625      * determin the weight of each factor
626      * 
627      * @param _member The address from which the share will be retrieved
628      * @return The total share
629      */
630     function shareOf(address _member) public view returns (uint) {
631         Record storage r = records[_member];
632 
633         // Factored totals
634         uint factoredTotalWeight = totalWeight * factorWeight;
635         uint factoredTotalContributed = totalContributed * factorContributed;
636 
637         // Factored member
638         uint factoredWeight = r.weight * factorWeight;
639         uint factoredContributed = r.contributed * factorContributed;
640 
641         // Calculate share (member / total * tokens)
642         return (factoredWeight + factoredContributed) * totalTokensReceived / (factoredTotalWeight + factoredTotalContributed);
643     }
644 
645 
646     /**
647      * Request tokens from the target crowdsale by calling 
648      * it's withdraw token function
649      */
650     function requestTokensFromCrowdsale() public only_when_not_updating {
651         crowdsale.withdrawTokens();
652     }
653 
654 
655     /**
656      * Update internal token balance
657      * 
658      * Tokens that are received at the proxies address are 
659      * recorded internally
660      */
661     function updateBalances() public only_when_not_updating {
662         updating = true;
663 
664         uint recordedBalance = totalTokensReceived - totalTokensWithdrawn;
665         uint actualBalance = token.balanceOf(this);
666         
667         // Update balance intrnally
668         if (actualBalance > recordedBalance) {
669             totalTokensReceived += actualBalance - recordedBalance;
670         }
671 
672         updating = false;
673     }
674 
675 
676     /**
677      * Withdraw allocated tokens
678      */
679     function withdrawTokens() public only_when_ended only_when_not_updating {
680         address member = msg.sender;
681         uint balance = balanceOf(member);
682 
683         // Record internally
684         records[member].withdrawnTokens += balance;
685         totalTokensWithdrawn += balance;
686 
687         // Transfer share
688         if (!token.transfer(member, balance)) {
689             revert();
690         }
691     }
692 
693 
694     /**
695      * Receive Eth and issue tokens to the sender
696      * 
697      * This function requires that msg.sender is not a contract. This is required because it's 
698      * not possible for a contract to specify a gas amount when calling the (internal) send() 
699      * function. Solidity imposes a maximum amount of gas (2300 gas at the time of writing)
700      * 
701      * Contracts can call the contribute() function instead
702      */
703     function () public payable {
704         require(msg.sender == tx.origin);
705         _handleTransaction(msg.sender);
706     }
707 
708 
709     /**
710      * Receive ether and issue tokens to the sender
711      *
712      * @return The accepted ether amount
713      */
714     function contribute() public payable returns (uint) {
715         return _handleTransaction(msg.sender);
716     }
717 
718 
719     /**
720      * Receive ether and issue tokens to `_beneficiary`
721      *
722      * @param _beneficiary The account that receives the tokens
723      * @return The accepted ether amount
724      */
725     function contributeFor(address _beneficiary) public payable returns (uint) {
726         return _handleTransaction(_beneficiary);
727     }
728 
729 
730     /**
731      * Failsafe mechanism
732      * 
733      * Allows the owner to retrieve tokens from the contract that 
734      * might have been send there by accident
735      *
736      * @param _tokenContract The address of ERC20 compatible token
737      */
738     function retrieveTokens(address _tokenContract) public only_owner {
739         require(_tokenContract != address(token));
740         super.retrieveTokens(_tokenContract);
741     }
742 
743 
744     /**
745      * Event handler that processes the token received event
746      * 
747      * Called by `_token` when a token amount is received on 
748      * the address of this proxy
749      *
750      * @param _token The token contract that received the transaction
751      * @param _from The account or contract that send the transaction
752      * @param _value The value of tokens that where received
753      */
754     function onTokensReceived(address _token, address _from, uint _value) internal {
755         require(_token == msg.sender);
756         require(_token == address(token));
757         require(_from == address(0));
758         
759         // Record deposit
760         totalTokensReceived += _value;
761     }
762 
763 
764     /**
765      * Handle incoming transactions
766      * 
767      * @param _beneficiary Tokens are issued to this account
768      * @return Accepted ether amount
769      */
770     function _handleTransaction(address _beneficiary) private only_when_not_updating at_stage(Stages.Deployed) returns (uint) {
771         uint weight = _getWeight(_beneficiary);
772         uint received = msg.value;
773 
774         // Contribute for beneficiary
775         uint acceptedAmount = crowdsale.contributeFor.value(received)(_beneficiary);
776 
777         // Record transaction
778         if (!hasRecord(_beneficiary)) {
779             records[_beneficiary] = Record(
780                 weight, acceptedAmount, 0, recordIndex.push(_beneficiary) - 1);
781             totalWeight += weight;
782         } else {
783             Record storage r = records[_beneficiary];
784             r.contributed += acceptedAmount;
785             if (weight < r.weight) {
786                 // Adjust weight
787                 r.weight = weight;
788                 totalWeight -= r.weight - weight;
789             }
790         }
791 
792         // Record conribution
793         totalContributed += acceptedAmount;
794         return acceptedAmount;
795     }
796 
797 
798     /**
799      * Retrieve the combined drp balances from the drpu and drps tokens
800      *
801      * @param _account Token owner
802      * @return Weight, drp balance
803      */
804     function _getWeight(address _account) private view returns (uint) {
805         return drpsToken.balanceOf(_account) + drpuToken.balanceOf(_account);
806     }
807 }
808 
809 
810 contract KATXDcorpMemberProxy is DcorpCrowdsaleProxy {
811     function KATXDcorpMemberProxy() public DcorpCrowdsaleProxy() {}
812 }