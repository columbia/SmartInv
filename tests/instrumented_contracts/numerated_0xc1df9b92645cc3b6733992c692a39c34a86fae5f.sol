1 pragma solidity ^0.4.18;
2 
3 // File: contracts/libraries/PermissionsLib.sol
4 
5 /*
6 
7   Copyright 2017 Dharma Labs Inc.
8 
9   Licensed under the Apache License, Version 2.0 (the "License");
10   you may not use this file except in compliance with the License.
11   You may obtain a copy of the License at
12 
13     http://www.apache.org/licenses/LICENSE-2.0
14 
15   Unless required by applicable law or agreed to in writing, software
16   distributed under the License is distributed on an "AS IS" BASIS,
17   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
18   See the License for the specific language governing permissions and
19   limitations under the License.
20 
21 */
22 
23 pragma solidity 0.4.18;
24 
25 
26 /**
27  *  Note(kayvon): these events are emitted by our PermissionsLib, but all contracts that
28  *  depend on the library must also define the events in order for web3 clients to pick them up.
29  *  This topic is discussed in greater detail here (under the section "Events and Libraries"):
30  *  https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736
31  */
32 contract PermissionEvents {
33     event Authorized(address indexed agent, string callingContext);
34     event AuthorizationRevoked(address indexed agent, string callingContext);
35 }
36 
37 
38 library PermissionsLib {
39 
40     // TODO(kayvon): remove these events and inherit from PermissionEvents when libraries are
41     // capable of inheritance.
42     // See relevant github issue here: https://github.com/ethereum/solidity/issues/891
43     event Authorized(address indexed agent, string callingContext);
44     event AuthorizationRevoked(address indexed agent, string callingContext);
45 
46     struct Permissions {
47         mapping (address => bool) authorized;
48         mapping (address => uint) agentToIndex; // ensures O(1) look-up
49         address[] authorizedAgents;
50     }
51 
52     function authorize(
53         Permissions storage self,
54         address agent,
55         string callingContext
56     )
57         internal
58     {
59         require(isNotAuthorized(self, agent));
60 
61         self.authorized[agent] = true;
62         self.authorizedAgents.push(agent);
63         self.agentToIndex[agent] = self.authorizedAgents.length - 1;
64         Authorized(agent, callingContext);
65     }
66 
67     function revokeAuthorization(
68         Permissions storage self,
69         address agent,
70         string callingContext
71     )
72         internal
73     {
74         /* We only want to do work in the case where the agent whose
75         authorization is being revoked had authorization permissions in the
76         first place. */
77         require(isAuthorized(self, agent));
78 
79         uint indexOfAgentToRevoke = self.agentToIndex[agent];
80         uint indexOfAgentToMove = self.authorizedAgents.length - 1;
81         address agentToMove = self.authorizedAgents[indexOfAgentToMove];
82 
83         // Revoke the agent's authorization.
84         delete self.authorized[agent];
85 
86         // Remove the agent from our collection of authorized agents.
87         self.authorizedAgents[indexOfAgentToRevoke] = agentToMove;
88 
89         // Update our indices to reflect the above changes.
90         self.agentToIndex[agentToMove] = indexOfAgentToRevoke;
91         delete self.agentToIndex[agent];
92 
93         // Clean up memory that's no longer being used.
94         delete self.authorizedAgents[indexOfAgentToMove];
95         self.authorizedAgents.length -= 1;
96 
97         AuthorizationRevoked(agent, callingContext);
98     }
99 
100     function isAuthorized(Permissions storage self, address agent)
101         internal
102         view
103         returns (bool)
104     {
105         return self.authorized[agent];
106     }
107 
108     function isNotAuthorized(Permissions storage self, address agent)
109         internal
110         view
111         returns (bool)
112     {
113         return !isAuthorized(self, agent);
114     }
115 
116     function getAuthorizedAgents(Permissions storage self)
117         internal
118         view
119         returns (address[])
120     {
121         return self.authorizedAgents;
122     }
123 }
124 
125 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
126 
127 /**
128  * @title Ownable
129  * @dev The Ownable contract has an owner address, and provides basic authorization control
130  * functions, this simplifies the implementation of "user permissions".
131  */
132 contract Ownable {
133   address public owner;
134 
135 
136   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138 
139   /**
140    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
141    * account.
142    */
143   function Ownable() public {
144     owner = msg.sender;
145   }
146 
147   /**
148    * @dev Throws if called by any account other than the owner.
149    */
150   modifier onlyOwner() {
151     require(msg.sender == owner);
152     _;
153   }
154 
155   /**
156    * @dev Allows the current owner to transfer control of the contract to a newOwner.
157    * @param newOwner The address to transfer ownership to.
158    */
159   function transferOwnership(address newOwner) public onlyOwner {
160     require(newOwner != address(0));
161     OwnershipTransferred(owner, newOwner);
162     owner = newOwner;
163   }
164 
165 }
166 
167 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
168 
169 /**
170  * @title Pausable
171  * @dev Base contract which allows children to implement an emergency stop mechanism.
172  */
173 contract Pausable is Ownable {
174   event Pause();
175   event Unpause();
176 
177   bool public paused = false;
178 
179 
180   /**
181    * @dev Modifier to make a function callable only when the contract is not paused.
182    */
183   modifier whenNotPaused() {
184     require(!paused);
185     _;
186   }
187 
188   /**
189    * @dev Modifier to make a function callable only when the contract is paused.
190    */
191   modifier whenPaused() {
192     require(paused);
193     _;
194   }
195 
196   /**
197    * @dev called by the owner to pause, triggers stopped state
198    */
199   function pause() onlyOwner whenNotPaused public {
200     paused = true;
201     Pause();
202   }
203 
204   /**
205    * @dev called by the owner to unpause, returns to normal state
206    */
207   function unpause() onlyOwner whenPaused public {
208     paused = false;
209     Unpause();
210   }
211 }
212 
213 // File: zeppelin-solidity/contracts/math/SafeMath.sol
214 
215 /**
216  * @title SafeMath
217  * @dev Math operations with safety checks that throw on error
218  */
219 library SafeMath {
220 
221   /**
222   * @dev Multiplies two numbers, throws on overflow.
223   */
224   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
225     if (a == 0) {
226       return 0;
227     }
228     uint256 c = a * b;
229     assert(c / a == b);
230     return c;
231   }
232 
233   /**
234   * @dev Integer division of two numbers, truncating the quotient.
235   */
236   function div(uint256 a, uint256 b) internal pure returns (uint256) {
237     // assert(b > 0); // Solidity automatically throws when dividing by 0
238     uint256 c = a / b;
239     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
240     return c;
241   }
242 
243   /**
244   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
245   */
246   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
247     assert(b <= a);
248     return a - b;
249   }
250 
251   /**
252   * @dev Adds two numbers, throws on overflow.
253   */
254   function add(uint256 a, uint256 b) internal pure returns (uint256) {
255     uint256 c = a + b;
256     assert(c >= a);
257     return c;
258   }
259 }
260 
261 // File: contracts/DebtRegistry.sol
262 
263 /*
264 
265   Copyright 2017 Dharma Labs Inc.
266 
267   Licensed under the Apache License, Version 2.0 (the "License");
268   you may not use this file except in compliance with the License.
269   You may obtain a copy of the License at
270 
271     http://www.apache.org/licenses/LICENSE-2.0
272 
273   Unless required by applicable law or agreed to in writing, software
274   distributed under the License is distributed on an "AS IS" BASIS,
275   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
276   See the License for the specific language governing permissions and
277   limitations under the License.
278 
279 */
280 
281 pragma solidity 0.4.18;
282 
283 
284 
285 
286 
287 /**
288  * The DebtRegistry stores the parameters and beneficiaries of all debt agreements in
289  * Dharma protocol.  It authorizes a limited number of agents to
290  * perform mutations on it -- those agents can be changed at any
291  * time by the contract's owner.
292  *
293  * Author: Nadav Hollander -- Github: nadavhollander
294  */
295 contract DebtRegistry is Pausable, PermissionEvents {
296     using SafeMath for uint;
297     using PermissionsLib for PermissionsLib.Permissions;
298 
299     struct Entry {
300         address version;
301         address beneficiary;
302         address underwriter;
303         uint underwriterRiskRating;
304         address termsContract;
305         bytes32 termsContractParameters;
306         uint issuanceBlockTimestamp;
307     }
308 
309     // Primary registry mapping agreement IDs to their corresponding entries
310     mapping (bytes32 => Entry) internal registry;
311 
312     // Maps debtor addresses to a list of their debts' agreement IDs
313     mapping (address => bytes32[]) internal debtorToDebts;
314 
315     PermissionsLib.Permissions internal entryInsertPermissions;
316     PermissionsLib.Permissions internal entryEditPermissions;
317 
318     string public constant INSERT_CONTEXT = "debt-registry-insert";
319     string public constant EDIT_CONTEXT = "debt-registry-edit";
320 
321     event LogInsertEntry(
322         bytes32 indexed agreementId,
323         address indexed beneficiary,
324         address indexed underwriter,
325         uint underwriterRiskRating,
326         address termsContract,
327         bytes32 termsContractParameters
328     );
329 
330     event LogModifyEntryBeneficiary(
331         bytes32 indexed agreementId,
332         address indexed previousBeneficiary,
333         address indexed newBeneficiary
334     );
335 
336     modifier onlyAuthorizedToInsert() {
337         require(entryInsertPermissions.isAuthorized(msg.sender));
338         _;
339     }
340 
341     modifier onlyAuthorizedToEdit() {
342         require(entryEditPermissions.isAuthorized(msg.sender));
343         _;
344     }
345 
346     modifier onlyExtantEntry(bytes32 agreementId) {
347         require(doesEntryExist(agreementId));
348         _;
349     }
350 
351     modifier nonNullBeneficiary(address beneficiary) {
352         require(beneficiary != address(0));
353         _;
354     }
355 
356     /* Ensures an entry with the specified agreement ID exists within the debt registry. */
357     function doesEntryExist(bytes32 agreementId)
358         public
359         view
360         returns (bool exists)
361     {
362         return registry[agreementId].beneficiary != address(0);
363     }
364 
365     /**
366      * Inserts a new entry into the registry, if the entry is valid and sender is
367      * authorized to make 'insert' mutations to the registry.
368      */
369     function insert(
370         address _version,
371         address _beneficiary,
372         address _debtor,
373         address _underwriter,
374         uint _underwriterRiskRating,
375         address _termsContract,
376         bytes32 _termsContractParameters,
377         uint _salt
378     )
379         public
380         onlyAuthorizedToInsert
381         whenNotPaused
382         nonNullBeneficiary(_beneficiary)
383         returns (bytes32 _agreementId)
384     {
385         Entry memory entry = Entry(
386             _version,
387             _beneficiary,
388             _underwriter,
389             _underwriterRiskRating,
390             _termsContract,
391             _termsContractParameters,
392             block.timestamp
393         );
394 
395         bytes32 agreementId = _getAgreementId(entry, _debtor, _salt);
396 
397         require(registry[agreementId].beneficiary == address(0));
398 
399         registry[agreementId] = entry;
400         debtorToDebts[_debtor].push(agreementId);
401 
402         LogInsertEntry(
403             agreementId,
404             entry.beneficiary,
405             entry.underwriter,
406             entry.underwriterRiskRating,
407             entry.termsContract,
408             entry.termsContractParameters
409         );
410 
411         return agreementId;
412     }
413 
414     /**
415      * Modifies the beneficiary of a debt issuance, if the sender
416      * is authorized to make 'modifyBeneficiary' mutations to
417      * the registry.
418      */
419     function modifyBeneficiary(bytes32 agreementId, address newBeneficiary)
420         public
421         onlyAuthorizedToEdit
422         whenNotPaused
423         onlyExtantEntry(agreementId)
424         nonNullBeneficiary(newBeneficiary)
425     {
426         address previousBeneficiary = registry[agreementId].beneficiary;
427 
428         registry[agreementId].beneficiary = newBeneficiary;
429 
430         LogModifyEntryBeneficiary(
431             agreementId,
432             previousBeneficiary,
433             newBeneficiary
434         );
435     }
436 
437     /**
438      * Adds an address to the list of agents authorized
439      * to make 'insert' mutations to the registry.
440      */
441     function addAuthorizedInsertAgent(address agent)
442         public
443         onlyOwner
444     {
445         entryInsertPermissions.authorize(agent, INSERT_CONTEXT);
446     }
447 
448     /**
449      * Adds an address to the list of agents authorized
450      * to make 'modifyBeneficiary' mutations to the registry.
451      */
452     function addAuthorizedEditAgent(address agent)
453         public
454         onlyOwner
455     {
456         entryEditPermissions.authorize(agent, EDIT_CONTEXT);
457     }
458 
459     /**
460      * Removes an address from the list of agents authorized
461      * to make 'insert' mutations to the registry.
462      */
463     function revokeInsertAgentAuthorization(address agent)
464         public
465         onlyOwner
466     {
467         entryInsertPermissions.revokeAuthorization(agent, INSERT_CONTEXT);
468     }
469 
470     /**
471      * Removes an address from the list of agents authorized
472      * to make 'modifyBeneficiary' mutations to the registry.
473      */
474     function revokeEditAgentAuthorization(address agent)
475         public
476         onlyOwner
477     {
478         entryEditPermissions.revokeAuthorization(agent, EDIT_CONTEXT);
479     }
480 
481     /**
482      * Returns the parameters of a debt issuance in the registry.
483      *
484      * TODO(kayvon): protect this function with our `onlyExtantEntry` modifier once the restriction
485      * on the size of the call stack has been addressed.
486      */
487     function get(bytes32 agreementId)
488         public
489         view
490         returns(address, address, address, uint, address, bytes32, uint)
491     {
492         return (
493             registry[agreementId].version,
494             registry[agreementId].beneficiary,
495             registry[agreementId].underwriter,
496             registry[agreementId].underwriterRiskRating,
497             registry[agreementId].termsContract,
498             registry[agreementId].termsContractParameters,
499             registry[agreementId].issuanceBlockTimestamp
500         );
501     }
502 
503     /**
504      * Returns the beneficiary of a given issuance
505      */
506     function getBeneficiary(bytes32 agreementId)
507         public
508         view
509         onlyExtantEntry(agreementId)
510         returns(address)
511     {
512         return registry[agreementId].beneficiary;
513     }
514 
515     /**
516      * Returns the terms contract address of a given issuance
517      */
518     function getTermsContract(bytes32 agreementId)
519         public
520         view
521         onlyExtantEntry(agreementId)
522         returns (address)
523     {
524         return registry[agreementId].termsContract;
525     }
526 
527     /**
528      * Returns the terms contract parameters of a given issuance
529      */
530     function getTermsContractParameters(bytes32 agreementId)
531         public
532         view
533         onlyExtantEntry(agreementId)
534         returns (bytes32)
535     {
536         return registry[agreementId].termsContractParameters;
537     }
538 
539     /**
540      * Returns a tuple of the terms contract and its associated parameters
541      * for a given issuance
542      */
543     function getTerms(bytes32 agreementId)
544         public
545         view
546         onlyExtantEntry(agreementId)
547         returns(address, bytes32)
548     {
549         return (
550             registry[agreementId].termsContract,
551             registry[agreementId].termsContractParameters
552         );
553     }
554 
555     /**
556      * Returns the timestamp of the block at which a debt agreement was issued.
557      */
558     function getIssuanceBlockTimestamp(bytes32 agreementId)
559         public
560         view
561         onlyExtantEntry(agreementId)
562         returns (uint timestamp)
563     {
564         return registry[agreementId].issuanceBlockTimestamp;
565     }
566 
567     /**
568      * Returns the list of agents authorized to make 'insert' mutations
569      */
570     function getAuthorizedInsertAgents()
571         public
572         view
573         returns(address[])
574     {
575         return entryInsertPermissions.getAuthorizedAgents();
576     }
577 
578     /**
579      * Returns the list of agents authorized to make 'modifyBeneficiary' mutations
580      */
581     function getAuthorizedEditAgents()
582         public
583         view
584         returns(address[])
585     {
586         return entryEditPermissions.getAuthorizedAgents();
587     }
588 
589     /**
590      * Returns the list of debt agreements a debtor is party to,
591      * with each debt agreement listed by agreement ID.
592      */
593     function getDebtorsDebts(address debtor)
594         public
595         view
596         returns(bytes32[])
597     {
598         return debtorToDebts[debtor];
599     }
600 
601     /**
602      * Helper function for computing the hash of a given issuance,
603      * and, in turn, its agreementId
604      */
605     function _getAgreementId(Entry _entry, address _debtor, uint _salt)
606         internal
607         pure
608         returns(bytes32)
609     {
610         return keccak256(
611             _entry.version,
612             _debtor,
613             _entry.underwriter,
614             _entry.underwriterRiskRating,
615             _entry.termsContract,
616             _entry.termsContractParameters,
617             _salt
618         );
619     }
620 }
621 
622 // File: contracts/TermsContract.sol
623 
624 /*
625 
626   Copyright 2017 Dharma Labs Inc.
627 
628   Licensed under the Apache License, Version 2.0 (the "License");
629   you may not use this file except in compliance with the License.
630   You may obtain a copy of the License at
631 
632     http://www.apache.org/licenses/LICENSE-2.0
633 
634   Unless required by applicable law or agreed to in writing, software
635   distributed under the License is distributed on an "AS IS" BASIS,
636   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
637   See the License for the specific language governing permissions and
638   limitations under the License.
639 
640 */
641 
642 pragma solidity 0.4.18;
643 
644 
645 interface TermsContract {
646      /// When called, the registerTermStart function registers the fact that
647      ///    the debt agreement has begun.  This method is called as a hook by the
648      ///    DebtKernel when a debt order associated with `agreementId` is filled.
649      ///    Method is not required to make any sort of internal state change
650      ///    upon the debt agreement's start, but MUST return `true` in order to
651      ///    acknowledge receipt of the transaction.  If, for any reason, the
652      ///    debt agreement stored at `agreementId` is incompatible with this contract,
653      ///    MUST return `false`, which will cause the pertinent order fill to fail.
654      ///    If this method is called for a debt agreement whose term has already begun,
655      ///    must THROW.  Similarly, if this method is called by any contract other
656      ///    than the current DebtKernel, must THROW.
657      /// @param  agreementId bytes32. The agreement id (issuance hash) of the debt agreement to which this pertains.
658      /// @param  debtor address. The debtor in this particular issuance.
659      /// @return _success bool. Acknowledgment of whether
660     function registerTermStart(
661         bytes32 agreementId,
662         address debtor
663     ) public returns (bool _success);
664 
665      /// When called, the registerRepayment function records the debtor's
666      ///  repayment, as well as any auxiliary metadata needed by the contract
667      ///  to determine ex post facto the value repaid (e.g. current USD
668      ///  exchange rate)
669      /// @param  agreementId bytes32. The agreement id (issuance hash) of the debt agreement to which this pertains.
670      /// @param  payer address. The address of the payer.
671      /// @param  beneficiary address. The address of the payment's beneficiary.
672      /// @param  unitsOfRepayment uint. The units-of-value repaid in the transaction.
673      /// @param  tokenAddress address. The address of the token with which the repayment transaction was executed.
674     function registerRepayment(
675         bytes32 agreementId,
676         address payer,
677         address beneficiary,
678         uint256 unitsOfRepayment,
679         address tokenAddress
680     ) public returns (bool _success);
681 
682      /// Returns the cumulative units-of-value expected to be repaid by a given block timestamp.
683      ///  Note this is not a constant function -- this value can vary on basis of any number of
684      ///  conditions (e.g. interest rates can be renegotiated if repayments are delinquent).
685      /// @param  agreementId bytes32. The agreement id (issuance hash) of the debt agreement to which this pertains.
686      /// @param  timestamp uint. The timestamp of the block for which repayment expectation is being queried.
687      /// @return uint256 The cumulative units-of-value expected to be repaid by the time the given timestamp lapses.
688     function getExpectedRepaymentValue(
689         bytes32 agreementId,
690         uint256 timestamp
691     ) public view returns (uint256);
692 
693      /// Returns the cumulative units-of-value repaid by the point at which this method is called.
694      /// @param  agreementId bytes32. The agreement id (issuance hash) of the debt agreement to which this pertains.
695      /// @return uint256 The cumulative units-of-value repaid up until now.
696     function getValueRepaidToDate(
697         bytes32 agreementId
698     ) public view returns (uint256);
699 
700     /**
701      * A method that returns a Unix timestamp representing the end of the debt agreement's term.
702      * contract.
703      */
704     function getTermEndTimestamp(
705         bytes32 _agreementId
706     ) public view returns (uint);
707 }
708 
709 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
710 
711 /**
712  * @title ERC20Basic
713  * @dev Simpler version of ERC20 interface
714  * @dev see https://github.com/ethereum/EIPs/issues/179
715  */
716 contract ERC20Basic {
717   function totalSupply() public view returns (uint256);
718   function balanceOf(address who) public view returns (uint256);
719   function transfer(address to, uint256 value) public returns (bool);
720   event Transfer(address indexed from, address indexed to, uint256 value);
721 }
722 
723 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
724 
725 /**
726  * @title ERC20 interface
727  * @dev see https://github.com/ethereum/EIPs/issues/20
728  */
729 contract ERC20 is ERC20Basic {
730   function allowance(address owner, address spender) public view returns (uint256);
731   function transferFrom(address from, address to, uint256 value) public returns (bool);
732   function approve(address spender, uint256 value) public returns (bool);
733   event Approval(address indexed owner, address indexed spender, uint256 value);
734 }
735 
736 // File: contracts/TokenTransferProxy.sol
737 
738 /*
739 
740   Copyright 2017 Dharma Labs Inc.
741 
742   Licensed under the Apache License, Version 2.0 (the "License");
743   you may not use this file except in compliance with the License.
744   You may obtain a copy of the License at
745 
746     http://www.apache.org/licenses/LICENSE-2.0
747 
748   Unless required by applicable law or agreed to in writing, software
749   distributed under the License is distributed on an "AS IS" BASIS,
750   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
751   See the License for the specific language governing permissions and
752   limitations under the License.
753 
754 */
755 
756 pragma solidity 0.4.18;
757 
758 
759 
760 
761 
762 
763 /**
764  * The TokenTransferProxy is a proxy contract for transfering principal
765  * and fee payments and repayments between agents and keepers in the Dharma
766  * ecosystem.  It is decoupled from the DebtKernel in order to make upgrades to the
767  * protocol contracts smoother -- if the DebtKernel or RepyamentRouter is upgraded to a new contract,
768  * creditors will not have to grant new transfer approvals to a new contract's address.
769  *
770  * Author: Nadav Hollander -- Github: nadavhollander
771  */
772 contract TokenTransferProxy is Pausable, PermissionEvents {
773     using PermissionsLib for PermissionsLib.Permissions;
774 
775     PermissionsLib.Permissions internal tokenTransferPermissions;
776 
777     string public constant CONTEXT = "token-transfer-proxy";
778 
779     /**
780      * Add address to list of agents authorized to initiate `transferFrom` calls
781      */
782     function addAuthorizedTransferAgent(address _agent)
783         public
784         onlyOwner
785     {
786         tokenTransferPermissions.authorize(_agent, CONTEXT);
787     }
788 
789     /**
790      * Remove address from list of agents authorized to initiate `transferFrom` calls
791      */
792     function revokeTransferAgentAuthorization(address _agent)
793         public
794         onlyOwner
795     {
796         tokenTransferPermissions.revokeAuthorization(_agent, CONTEXT);
797     }
798 
799     /**
800      * Return list of agents authorized to initiate `transferFrom` calls
801      */
802     function getAuthorizedTransferAgents()
803         public
804         view
805         returns (address[] authorizedAgents)
806     {
807         return tokenTransferPermissions.getAuthorizedAgents();
808     }
809 
810     /**
811      * Transfer specified token amount from _from address to _to address on give token
812      */
813     function transferFrom(
814         address _token,
815         address _from,
816         address _to,
817         uint _amount
818     )
819         public
820         returns (bool _success)
821     {
822         require(tokenTransferPermissions.isAuthorized(msg.sender));
823 
824         return ERC20(_token).transferFrom(_from, _to, _amount);
825     }
826 }
827 
828 // File: contracts/RepaymentRouter.sol
829 
830 /*
831 
832   Copyright 2017 Dharma Labs Inc.
833 
834   Licensed under the Apache License, Version 2.0 (the "License");
835   you may not use this file except in compliance with the License.
836   You may obtain a copy of the License at
837 
838     http://www.apache.org/licenses/LICENSE-2.0
839 
840   Unless required by applicable law or agreed to in writing, software
841   distributed under the License is distributed on an "AS IS" BASIS,
842   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
843   See the License for the specific language governing permissions and
844   limitations under the License.
845 
846 */
847 
848 pragma solidity 0.4.18;
849 
850 
851 
852 
853 
854 
855 
856 /**
857  * The RepaymentRouter routes allowers payers to make repayments on any
858  * given debt agreement in any given token by routing the payments to
859  * the debt agreement's beneficiary.  Additionally, the router acts
860  * as a trusted oracle to the debt agreement's terms contract, informing
861  * it of exactly what payments have been made in what quantity and in what token.
862  *
863  * Authors: Jaynti Kanani -- Github: jdkanani, Nadav Hollander -- Github: nadavhollander
864  */
865 contract RepaymentRouter is Pausable {
866     DebtRegistry public debtRegistry;
867     TokenTransferProxy public tokenTransferProxy;
868 
869     enum Errors {
870         DEBT_AGREEMENT_NONEXISTENT,
871         PAYER_BALANCE_OR_ALLOWANCE_INSUFFICIENT,
872         REPAYMENT_REJECTED_BY_TERMS_CONTRACT
873     }
874 
875     event LogRepayment(
876         bytes32 indexed _agreementId,
877         address indexed _payer,
878         address indexed _beneficiary,
879         uint _amount,
880         address _token
881     );
882 
883     event LogError(uint8 indexed _errorId, bytes32 indexed _agreementId);
884 
885     /**
886      * Constructor points the repayment router at the deployed registry contract.
887      */
888     function RepaymentRouter (address _debtRegistry, address _tokenTransferProxy) public {
889         debtRegistry = DebtRegistry(_debtRegistry);
890         tokenTransferProxy = TokenTransferProxy(_tokenTransferProxy);
891     }
892 
893     /**
894      * Given an agreement id, routes a repayment
895      * of a given ERC20 token to the debt's current beneficiary, and reports the repayment
896      * to the debt's associated terms contract.
897      */
898     function repay(
899         bytes32 agreementId,
900         uint256 amount,
901         address tokenAddress
902     )
903         public
904         whenNotPaused
905         returns (uint _amountRepaid)
906     {
907         require(tokenAddress != address(0));
908         require(amount > 0);
909 
910         // Ensure agreement exists.
911         if (!debtRegistry.doesEntryExist(agreementId)) {
912             LogError(uint8(Errors.DEBT_AGREEMENT_NONEXISTENT), agreementId);
913             return 0;
914         }
915 
916         // Check payer has sufficient balance and has granted router sufficient allowance.
917         if (ERC20(tokenAddress).balanceOf(msg.sender) < amount ||
918             ERC20(tokenAddress).allowance(msg.sender, tokenTransferProxy) < amount) {
919             LogError(uint8(Errors.PAYER_BALANCE_OR_ALLOWANCE_INSUFFICIENT), agreementId);
920             return 0;
921         }
922 
923         // Notify terms contract
924         address termsContract = debtRegistry.getTermsContract(agreementId);
925         address beneficiary = debtRegistry.getBeneficiary(agreementId);
926         if (!TermsContract(termsContract).registerRepayment(
927             agreementId,
928             msg.sender,
929             beneficiary,
930             amount,
931             tokenAddress
932         )) {
933             LogError(uint8(Errors.REPAYMENT_REJECTED_BY_TERMS_CONTRACT), agreementId);
934             return 0;
935         }
936 
937         // Transfer amount to creditor
938         require(tokenTransferProxy.transferFrom(
939             tokenAddress,
940             msg.sender,
941             beneficiary,
942             amount
943         ));
944 
945         // Log event for repayment
946         LogRepayment(agreementId, msg.sender, beneficiary, amount, tokenAddress);
947 
948         return amount;
949     }
950 }