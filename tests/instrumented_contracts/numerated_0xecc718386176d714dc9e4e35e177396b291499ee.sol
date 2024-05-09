1 pragma solidity 0.4.18;
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
709 // File: contracts/TokenRegistry.sol
710 
711 /**
712  * The TokenRegistry is a basic registry mapping token symbols
713  * to their known, deployed addresses on the current blockchain.
714  *
715  * Note that the TokenRegistry does *not* mediate any of the
716  * core protocol's business logic, but, rather, is a helpful
717  * utility for Terms Contracts to use in encoding, decoding, and
718  * resolving the addresses of currently deployed tokens.
719  *
720  * At this point in time, administration of the Token Registry is
721  * under Dharma Labs' control.  With more sophisticated decentralized
722  * governance mechanisms, we intend to shift ownership of this utility
723  * contract to the Dharma community.
724  */
725 contract TokenRegistry is Ownable {
726     mapping (bytes32 => TokenAttributes) public symbolHashToTokenAttributes;
727     string[256] public tokenSymbolList;
728     uint8 public tokenSymbolListLength;
729 
730     struct TokenAttributes {
731         // The ERC20 contract address.
732         address tokenAddress;
733         // The index in `tokenSymbolList` where the token's symbol can be found.
734         uint tokenIndex;
735         // The name of the given token, e.g. "Canonical Wrapped Ether"
736         string name;
737         // The number of digits that come after the decimal place when displaying token value.
738         uint8 numDecimals;
739     }
740 
741     /**
742      * Maps the given symbol to the given token attributes.
743      */
744     function setTokenAttributes(
745         string _symbol,
746         address _tokenAddress,
747         string _tokenName,
748         uint8 _numDecimals
749     )
750         public onlyOwner
751     {
752         bytes32 symbolHash = keccak256(_symbol);
753 
754         // Attempt to retrieve the token's attributes from the registry.
755         TokenAttributes memory attributes = symbolHashToTokenAttributes[symbolHash];
756 
757         if (attributes.tokenAddress == address(0)) {
758             // The token has not yet been added to the registry.
759             attributes.tokenAddress = _tokenAddress;
760             attributes.numDecimals = _numDecimals;
761             attributes.name = _tokenName;
762             attributes.tokenIndex = tokenSymbolListLength;
763 
764             tokenSymbolList[tokenSymbolListLength] = _symbol;
765             tokenSymbolListLength++;
766         } else {
767             // The token has already been added to the registry; update attributes.
768             attributes.tokenAddress = _tokenAddress;
769             attributes.numDecimals = _numDecimals;
770             attributes.name = _tokenName;
771         }
772 
773         // Update this contract's storage.
774         symbolHashToTokenAttributes[symbolHash] = attributes;
775     }
776 
777     /**
778      * Given a symbol, resolves the current address of the token the symbol is mapped to.
779      */
780     function getTokenAddressBySymbol(string _symbol) public view returns (address) {
781         bytes32 symbolHash = keccak256(_symbol);
782 
783         TokenAttributes storage attributes = symbolHashToTokenAttributes[symbolHash];
784 
785         return attributes.tokenAddress;
786     }
787 
788     /**
789      * Given the known index of a token within the registry's symbol list,
790      * returns the address of the token mapped to the symbol at that index.
791      *
792      * This is a useful utility for compactly encoding the address of a token into a
793      * TermsContractParameters string -- by encoding a token by its index in a
794      * a 256 slot array, we can represent a token by a 1 byte uint instead of a 20 byte address.
795      */
796     function getTokenAddressByIndex(uint _index) public view returns (address) {
797         string storage symbol = tokenSymbolList[_index];
798 
799         return getTokenAddressBySymbol(symbol);
800     }
801 
802     /**
803      * Given a symbol, resolves the index of the token the symbol is mapped to within the registry's
804      * symbol list.
805      */
806     function getTokenIndexBySymbol(string _symbol) public view returns (uint) {
807         bytes32 symbolHash = keccak256(_symbol);
808 
809         TokenAttributes storage attributes = symbolHashToTokenAttributes[symbolHash];
810 
811         return attributes.tokenIndex;
812     }
813 
814     /**
815      * Given an index, resolves the symbol of the token at that index in the registry's
816      * token symbol list.
817      */
818     function getTokenSymbolByIndex(uint _index) public view returns (string) {
819         return tokenSymbolList[_index];
820     }
821 
822     /**
823      * Given a symbol, returns the name of the token the symbol is mapped to within the registry's
824      * symbol list.
825      */
826     function getTokenNameBySymbol(string _symbol) public view returns (string) {
827         bytes32 symbolHash = keccak256(_symbol);
828 
829         TokenAttributes storage attributes = symbolHashToTokenAttributes[symbolHash];
830 
831         return attributes.name;
832     }
833 
834     /**
835      * Given the symbol for a token, returns the number of decimals as provided in
836      * the associated TokensAttribute struct.
837      *
838      * Example:
839      *   getNumDecimalsFromSymbol("REP");
840      *   => 18
841      */
842     function getNumDecimalsFromSymbol(string _symbol) public view returns (uint8) {
843         bytes32 symbolHash = keccak256(_symbol);
844 
845         TokenAttributes storage attributes = symbolHashToTokenAttributes[symbolHash];
846 
847         return attributes.numDecimals;
848     }
849 
850     /**
851      * Given the index for a token in the registry, returns the number of decimals as provided in
852      * the associated TokensAttribute struct.
853      *
854      * Example:
855      *   getNumDecimalsByIndex(1);
856      *   => 18
857      */
858     function getNumDecimalsByIndex(uint _index) public view returns (uint8) {
859         string memory symbol = getTokenSymbolByIndex(_index);
860 
861         return getNumDecimalsFromSymbol(symbol);
862     }
863 
864     /**
865      * Given the index for a token in the registry, returns the name of the token as provided in
866      * the associated TokensAttribute struct.
867      *
868      * Example:
869      *   getTokenNameByIndex(1);
870      *   => "Canonical Wrapped Ether"
871      */
872     function getTokenNameByIndex(uint _index) public view returns (string) {
873         string memory symbol = getTokenSymbolByIndex(_index);
874 
875         string memory tokenName = getTokenNameBySymbol(symbol);
876 
877         return tokenName;
878     }
879 
880     /**
881      * Given the symbol for a token in the registry, returns a tuple containing the token's address,
882      * the token's index in the registry, the token's name, and the number of decimals.
883      *
884      * Example:
885      *   getTokenAttributesBySymbol("WETH");
886      *   => ["0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2", 1, "Canonical Wrapped Ether", 18]
887      */
888     function getTokenAttributesBySymbol(string _symbol)
889         public
890         view
891         returns (
892             address,
893             uint,
894             string,
895             uint
896         )
897     {
898         bytes32 symbolHash = keccak256(_symbol);
899 
900         TokenAttributes storage attributes = symbolHashToTokenAttributes[symbolHash];
901 
902         return (
903             attributes.tokenAddress,
904             attributes.tokenIndex,
905             attributes.name,
906             attributes.numDecimals
907         );
908     }
909 
910     /**
911      * Given the index for a token in the registry, returns a tuple containing the token's address,
912      * the token's symbol, the token's name, and the number of decimals.
913      *
914      * Example:
915      *   getTokenAttributesByIndex(1);
916      *   => ["0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2", "WETH", "Canonical Wrapped Ether", 18]
917      */
918     function getTokenAttributesByIndex(uint _index)
919         public
920         view
921         returns (
922             address,
923             string,
924             string,
925             uint8
926         )
927     {
928         string memory symbol = getTokenSymbolByIndex(_index);
929 
930         bytes32 symbolHash = keccak256(symbol);
931 
932         TokenAttributes storage attributes = symbolHashToTokenAttributes[symbolHash];
933 
934         return (
935             attributes.tokenAddress,
936             symbol,
937             attributes.name,
938             attributes.numDecimals
939         );
940     }
941 }
942 
943 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
944 
945 /**
946  * @title ERC20Basic
947  * @dev Simpler version of ERC20 interface
948  * @dev see https://github.com/ethereum/EIPs/issues/179
949  */
950 contract ERC20Basic {
951   function totalSupply() public view returns (uint256);
952   function balanceOf(address who) public view returns (uint256);
953   function transfer(address to, uint256 value) public returns (bool);
954   event Transfer(address indexed from, address indexed to, uint256 value);
955 }
956 
957 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
958 
959 /**
960  * @title ERC20 interface
961  * @dev see https://github.com/ethereum/EIPs/issues/20
962  */
963 contract ERC20 is ERC20Basic {
964   function allowance(address owner, address spender) public view returns (uint256);
965   function transferFrom(address from, address to, uint256 value) public returns (bool);
966   function approve(address spender, uint256 value) public returns (bool);
967   event Approval(address indexed owner, address indexed spender, uint256 value);
968 }
969 
970 // File: contracts/TokenTransferProxy.sol
971 
972 /*
973 
974   Copyright 2017 Dharma Labs Inc.
975 
976   Licensed under the Apache License, Version 2.0 (the "License");
977   you may not use this file except in compliance with the License.
978   You may obtain a copy of the License at
979 
980     http://www.apache.org/licenses/LICENSE-2.0
981 
982   Unless required by applicable law or agreed to in writing, software
983   distributed under the License is distributed on an "AS IS" BASIS,
984   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
985   See the License for the specific language governing permissions and
986   limitations under the License.
987 
988 */
989 
990 pragma solidity 0.4.18;
991 
992 
993 
994 
995 
996 
997 /**
998  * The TokenTransferProxy is a proxy contract for transfering principal
999  * and fee payments and repayments between agents and keepers in the Dharma
1000  * ecosystem.  It is decoupled from the DebtKernel in order to make upgrades to the
1001  * protocol contracts smoother -- if the DebtKernel or RepyamentRouter is upgraded to a new contract,
1002  * creditors will not have to grant new transfer approvals to a new contract's address.
1003  *
1004  * Author: Nadav Hollander -- Github: nadavhollander
1005  */
1006 contract TokenTransferProxy is Pausable, PermissionEvents {
1007     using PermissionsLib for PermissionsLib.Permissions;
1008 
1009     PermissionsLib.Permissions internal tokenTransferPermissions;
1010 
1011     string public constant CONTEXT = "token-transfer-proxy";
1012 
1013     /**
1014      * Add address to list of agents authorized to initiate `transferFrom` calls
1015      */
1016     function addAuthorizedTransferAgent(address _agent)
1017         public
1018         onlyOwner
1019     {
1020         tokenTransferPermissions.authorize(_agent, CONTEXT);
1021     }
1022 
1023     /**
1024      * Remove address from list of agents authorized to initiate `transferFrom` calls
1025      */
1026     function revokeTransferAgentAuthorization(address _agent)
1027         public
1028         onlyOwner
1029     {
1030         tokenTransferPermissions.revokeAuthorization(_agent, CONTEXT);
1031     }
1032 
1033     /**
1034      * Return list of agents authorized to initiate `transferFrom` calls
1035      */
1036     function getAuthorizedTransferAgents()
1037         public
1038         view
1039         returns (address[] authorizedAgents)
1040     {
1041         return tokenTransferPermissions.getAuthorizedAgents();
1042     }
1043 
1044     /**
1045      * Transfer specified token amount from _from address to _to address on give token
1046      */
1047     function transferFrom(
1048         address _token,
1049         address _from,
1050         address _to,
1051         uint _amount
1052     )
1053         public
1054         returns (bool _success)
1055     {
1056         require(tokenTransferPermissions.isAuthorized(msg.sender));
1057 
1058         return ERC20(_token).transferFrom(_from, _to, _amount);
1059     }
1060 }
1061 
1062 // File: contracts/Collateralizer.sol
1063 
1064 /*
1065 
1066   Copyright 2017 Dharma Labs Inc.
1067 
1068   Licensed under the Apache License, Version 2.0 (the "License");
1069   you may not use this file except in compliance with the License.
1070   You may obtain a copy of the License at
1071 
1072     http://www.apache.org/licenses/LICENSE-2.0
1073 
1074   Unless required by applicable law or agreed to in writing, software
1075   distributed under the License is distributed on an "AS IS" BASIS,
1076   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1077   See the License for the specific language governing permissions and
1078   limitations under the License.
1079 
1080 */
1081 
1082 pragma solidity 0.4.18;
1083 
1084 
1085 
1086 
1087 
1088 
1089 
1090 
1091 
1092 /**
1093   * Contains functionality for collateralizing assets, by transferring them from
1094   * a debtor address to this contract as a custodian.
1095   *
1096   * Authors (in no particular order): nadavhollander, saturnial, jdkanani, graemecode
1097   */
1098 contract Collateralizer is Pausable, PermissionEvents {
1099     using PermissionsLib for PermissionsLib.Permissions;
1100     using SafeMath for uint;
1101 
1102     address public debtKernelAddress;
1103 
1104     DebtRegistry public debtRegistry;
1105     TokenRegistry public tokenRegistry;
1106     TokenTransferProxy public tokenTransferProxy;
1107 
1108     // Collateralizer here refers to the owner of the asset that is being collateralized.
1109     mapping(bytes32 => address) public agreementToCollateralizer;
1110 
1111     PermissionsLib.Permissions internal collateralizationPermissions;
1112 
1113     uint public constant SECONDS_IN_DAY = 24*60*60;
1114 
1115     string public constant CONTEXT = "collateralizer";
1116 
1117     event CollateralLocked(
1118         bytes32 indexed agreementID,
1119         address indexed token,
1120         uint amount
1121     );
1122 
1123     event CollateralReturned(
1124         bytes32 indexed agreementID,
1125         address indexed collateralizer,
1126         address token,
1127         uint amount
1128     );
1129 
1130     event CollateralSeized(
1131         bytes32 indexed agreementID,
1132         address indexed beneficiary,
1133         address token,
1134         uint amount
1135     );
1136 
1137     modifier onlyAuthorizedToCollateralize() {
1138         require(collateralizationPermissions.isAuthorized(msg.sender));
1139         _;
1140     }
1141 
1142     function Collateralizer(
1143         address _debtKernel,
1144         address _debtRegistry,
1145         address _tokenRegistry,
1146         address _tokenTransferProxy
1147     ) public {
1148         debtKernelAddress = _debtKernel;
1149         debtRegistry = DebtRegistry(_debtRegistry);
1150         tokenRegistry = TokenRegistry(_tokenRegistry);
1151         tokenTransferProxy = TokenTransferProxy(_tokenTransferProxy);
1152     }
1153 
1154     /**
1155      * Transfers collateral from the debtor to the current contract, as custodian.
1156      *
1157      * @param agreementId bytes32 The debt agreement's ID
1158      * @param collateralizer address The owner of the asset being collateralized
1159      */
1160     function collateralize(
1161         bytes32 agreementId,
1162         address collateralizer
1163     )
1164         public
1165         onlyAuthorizedToCollateralize
1166         whenNotPaused
1167         returns (bool _success)
1168     {
1169         // The token in which collateral is denominated
1170         address collateralToken;
1171         // The amount being put up for collateral
1172         uint collateralAmount;
1173         // The number of days a debtor has after a debt enters default
1174         // before their collateral is eligible for seizure.
1175         uint gracePeriodInDays;
1176         // The terms contract according to which this asset is being collateralized.
1177         TermsContract termsContract;
1178 
1179         // Fetch all relevant collateralization parameters
1180         (
1181             collateralToken,
1182             collateralAmount,
1183             gracePeriodInDays,
1184             termsContract
1185         ) = retrieveCollateralParameters(agreementId);
1186 
1187         require(termsContract == msg.sender);
1188         require(collateralAmount > 0);
1189         require(collateralToken != address(0));
1190 
1191         /*
1192         Ensure that the agreement has not already been collateralized.
1193 
1194         If the agreement has already been collateralized, this check will fail
1195         because any valid collateralization must have some sort of valid
1196         address associated with it as a collateralizer.  Given that it is impossible
1197         to send transactions from address 0x0, this check will only fail
1198         when the agreement is already collateralized.
1199         */
1200         require(agreementToCollateralizer[agreementId] == address(0));
1201 
1202         ERC20 erc20token = ERC20(collateralToken);
1203         address custodian = address(this);
1204 
1205         /*
1206         The collateralizer must have sufficient balance equal to or greater
1207         than the amount being put up for collateral.
1208         */
1209         require(erc20token.balanceOf(collateralizer) >= collateralAmount);
1210 
1211         /*
1212         The proxy must have an allowance granted by the collateralizer equal
1213         to or greater than the amount being put up for collateral.
1214         */
1215         require(erc20token.allowance(collateralizer, tokenTransferProxy) >= collateralAmount);
1216 
1217         // store collaterallizer in mapping, effectively demarcating that the
1218         // agreement is now collateralized.
1219         agreementToCollateralizer[agreementId] = collateralizer;
1220 
1221         // the collateral must be successfully transferred to this contract, via a proxy.
1222         require(tokenTransferProxy.transferFrom(
1223             erc20token,
1224             collateralizer,
1225             custodian,
1226             collateralAmount
1227         ));
1228 
1229         // emit event that collateral has been secured.
1230         CollateralLocked(agreementId, collateralToken, collateralAmount);
1231 
1232         return true;
1233     }
1234 
1235     /**
1236      * Returns collateral to the debt agreement's original collateralizer
1237      * if and only if the debt agreement's term has lapsed and
1238      * the total expected repayment value has been repaid.
1239      *
1240      * @param agreementId bytes32 The debt agreement's ID
1241      */
1242     function returnCollateral(
1243         bytes32 agreementId
1244     )
1245         public
1246         whenNotPaused
1247     {
1248         // The token in which collateral is denominated
1249         address collateralToken;
1250         // The amount being put up for collateral
1251         uint collateralAmount;
1252         // The number of days a debtor has after a debt enters default
1253         // before their collateral is eligible for seizure.
1254         uint gracePeriodInDays;
1255         // The terms contract according to which this asset is being collateralized.
1256         TermsContract termsContract;
1257 
1258         // Fetch all relevant collateralization parameters.
1259         (
1260             collateralToken,
1261             collateralAmount,
1262             gracePeriodInDays,
1263             termsContract
1264         ) = retrieveCollateralParameters(agreementId);
1265 
1266         // Ensure a valid form of collateral is tied to this agreement id
1267         require(collateralAmount > 0);
1268         require(collateralToken != address(0));
1269 
1270         // Withdrawal can only occur if the collateral has yet to be withdrawn.
1271         // When we withdraw collateral, we reset the collateral agreement
1272         // in a gas-efficient manner by resetting the address of the collateralizer to 0
1273         require(agreementToCollateralizer[agreementId] != address(0));
1274 
1275         // Ensure that the debt is not in a state of default
1276         require(
1277             termsContract.getExpectedRepaymentValue(
1278                 agreementId,
1279                 termsContract.getTermEndTimestamp(agreementId)
1280             ) <= termsContract.getValueRepaidToDate(agreementId)
1281         );
1282 
1283         // determine collateralizer of the collateral.
1284         address collateralizer = agreementToCollateralizer[agreementId];
1285 
1286         // Mark agreement's collateral as withdrawn by setting the agreement's
1287         // collateralizer to 0x0.
1288         delete agreementToCollateralizer[agreementId];
1289 
1290         // transfer the collateral this contract was holding in escrow back to collateralizer.
1291         require(
1292             ERC20(collateralToken).transfer(
1293                 collateralizer,
1294                 collateralAmount
1295             )
1296         );
1297 
1298         // log the return event.
1299         CollateralReturned(
1300             agreementId,
1301             collateralizer,
1302             collateralToken,
1303             collateralAmount
1304         );
1305     }
1306 
1307     /**
1308      * Seizes the collateral from the given debt agreement and
1309      * transfers it to the debt agreement's current beneficiary
1310      * (i.e. the person who "owns" the debt).
1311      *
1312      * @param agreementId bytes32 The debt agreement's ID
1313      */
1314     function seizeCollateral(
1315         bytes32 agreementId
1316     )
1317         public
1318         whenNotPaused
1319     {
1320 
1321         // The token in which collateral is denominated
1322         address collateralToken;
1323         // The amount being put up for collateral
1324         uint collateralAmount;
1325         // The number of days a debtor has after a debt enters default
1326         // before their collateral is eligible for seizure.
1327         uint gracePeriodInDays;
1328         // The terms contract according to which this asset is being collateralized.
1329         TermsContract termsContract;
1330 
1331         // Fetch all relevant collateralization parameters
1332         (
1333             collateralToken,
1334             collateralAmount,
1335             gracePeriodInDays,
1336             termsContract
1337         ) = retrieveCollateralParameters(agreementId);
1338 
1339         // Ensure a valid form of collateral is tied to this agreement id
1340         require(collateralAmount > 0);
1341         require(collateralToken != address(0));
1342 
1343         // Seizure can only occur if the collateral has yet to be withdrawn.
1344         // When we withdraw collateral, we reset the collateral agreement
1345         // in a gas-efficient manner by resetting the address of the collateralizer to 0
1346         require(agreementToCollateralizer[agreementId] != address(0));
1347 
1348         // Ensure debt is in a state of default when we account for the
1349         // specified "grace period".  We do this by checking whether the
1350         // *current* value repaid to-date exceeds the expected repayment value
1351         // at the point of time at which the grace period would begin if it ended
1352         // now.  This crucially relies on the assumption that both expected repayment value
1353         /// and value repaid to date monotonically increase over time
1354         require(
1355             termsContract.getExpectedRepaymentValue(
1356                 agreementId,
1357                 timestampAdjustedForGracePeriod(gracePeriodInDays)
1358             ) > termsContract.getValueRepaidToDate(agreementId)
1359         );
1360 
1361         // Mark agreement's collateral as withdrawn by setting the agreement's
1362         // collateralizer to 0x0.
1363         delete agreementToCollateralizer[agreementId];
1364 
1365         // determine beneficiary of the seized collateral.
1366         address beneficiary = debtRegistry.getBeneficiary(agreementId);
1367 
1368         // transfer the collateral this contract was holding in escrow to beneficiary.
1369         require(
1370             ERC20(collateralToken).transfer(
1371                 beneficiary,
1372                 collateralAmount
1373             )
1374         );
1375 
1376         // log the seizure event.
1377         CollateralSeized(
1378             agreementId,
1379             beneficiary,
1380             collateralToken,
1381             collateralAmount
1382         );
1383     }
1384 
1385     /**
1386      * Adds an address to the list of agents authorized
1387      * to invoke the `collateralize` function.
1388      */
1389     function addAuthorizedCollateralizeAgent(address agent)
1390         public
1391         onlyOwner
1392     {
1393         collateralizationPermissions.authorize(agent, CONTEXT);
1394     }
1395 
1396     /**
1397      * Removes an address from the list of agents authorized
1398      * to invoke the `collateralize` function.
1399      */
1400     function revokeCollateralizeAuthorization(address agent)
1401         public
1402         onlyOwner
1403     {
1404         collateralizationPermissions.revokeAuthorization(agent, CONTEXT);
1405     }
1406 
1407     /**
1408     * Returns the list of agents authorized to invoke the 'collateralize' function.
1409     */
1410     function getAuthorizedCollateralizeAgents()
1411         public
1412         view
1413         returns(address[])
1414     {
1415         return collateralizationPermissions.getAuthorizedAgents();
1416     }
1417 
1418     /**
1419      * Unpacks collateralization-specific parameters from their tightly-packed
1420      * representation in a terms contract parameter string.
1421      *
1422      * For collateralized terms contracts, we reserve the lowest order 108 bits
1423      * of the terms contract parameters for parameters relevant to collateralization.
1424      *
1425      * Contracts that inherit from the Collateralized terms contract
1426      * can encode whichever parameter schema they please in the remaining
1427      * space of the terms contract parameters.
1428      * The 108 bits are encoded as follows (from higher order bits to lower order bits):
1429      *
1430      * 8 bits - Collateral Token (encoded by its unsigned integer index in the TokenRegistry contract)
1431      * 92 bits - Collateral Amount (encoded as an unsigned integer)
1432      * 8 bits - Grace Period* Length (encoded as an unsigned integer)
1433      *
1434      * * = The "Grace" Period is the number of days a debtor has between
1435      *      when they fall behind on an expected payment and when their collateral
1436      *      can be seized by the creditor.
1437      */
1438     function unpackCollateralParametersFromBytes(bytes32 parameters)
1439         public
1440         pure
1441         returns (uint, uint, uint)
1442     {
1443         // The first byte of the 108 reserved bits represents the collateral token.
1444         bytes32 collateralTokenIndexShifted =
1445             parameters & 0x0000000000000000000000000000000000000ff0000000000000000000000000;
1446         // The subsequent 92 bits represents the collateral amount, as denominated in the above token.
1447         bytes32 collateralAmountShifted =
1448             parameters & 0x000000000000000000000000000000000000000fffffffffffffffffffffff00;
1449 
1450         // We bit-shift these values, respectively, 100 bits and 8 bits right using
1451         // mathematical operations, so that their 32 byte integer counterparts
1452         // correspond to the intended values packed in the 32 byte string
1453         uint collateralTokenIndex = uint(collateralTokenIndexShifted) / 2 ** 100;
1454         uint collateralAmount = uint(collateralAmountShifted) / 2 ** 8;
1455 
1456         // The last byte of the parameters represents the "grace period" of the loan,
1457         // as defined in terms of days.
1458         // Since this value takes the rightmost place in the parameters string,
1459         // we do not need to bit-shift it.
1460         bytes32 gracePeriodInDays =
1461             parameters & 0x00000000000000000000000000000000000000000000000000000000000000ff;
1462 
1463         return (
1464             collateralTokenIndex,
1465             collateralAmount,
1466             uint(gracePeriodInDays)
1467         );
1468     }
1469 
1470     function timestampAdjustedForGracePeriod(uint gracePeriodInDays)
1471         public
1472         view
1473         returns (uint)
1474     {
1475         return block.timestamp.sub(
1476             SECONDS_IN_DAY.mul(gracePeriodInDays)
1477         );
1478     }
1479 
1480     function retrieveCollateralParameters(bytes32 agreementId)
1481         internal
1482         view
1483         returns (
1484             address _collateralToken,
1485             uint _collateralAmount,
1486             uint _gracePeriodInDays,
1487             TermsContract _termsContract
1488         )
1489     {
1490         address termsContractAddress;
1491         bytes32 termsContractParameters;
1492 
1493         // Pull the terms contract and associated parameters for the agreement
1494         (termsContractAddress, termsContractParameters) = debtRegistry.getTerms(agreementId);
1495 
1496         uint collateralTokenIndex;
1497         uint collateralAmount;
1498         uint gracePeriodInDays;
1499 
1500         // Unpack terms contract parameters in order to get collateralization-specific params
1501         (
1502             collateralTokenIndex,
1503             collateralAmount,
1504             gracePeriodInDays
1505         ) = unpackCollateralParametersFromBytes(termsContractParameters);
1506 
1507         // Resolve address of token associated with this agreement in token registry
1508         address collateralTokenAddress = tokenRegistry.getTokenAddressByIndex(collateralTokenIndex);
1509 
1510         return (
1511             collateralTokenAddress,
1512             collateralAmount,
1513             gracePeriodInDays,
1514             TermsContract(termsContractAddress)
1515         );
1516     }
1517 }