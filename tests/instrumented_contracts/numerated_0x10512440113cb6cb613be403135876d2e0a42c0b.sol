1 pragma solidity 0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/math/SafeMath.sol
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     if (a == 0) {
58       return 0;
59     }
60     uint256 c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   /**
76   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) public view returns (uint256);
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 // File: contracts/TermsContract.sol
121 
122 /*
123 
124   Copyright 2017 Dharma Labs Inc.
125 
126   Licensed under the Apache License, Version 2.0 (the "License");
127   you may not use this file except in compliance with the License.
128   You may obtain a copy of the License at
129 
130     http://www.apache.org/licenses/LICENSE-2.0
131 
132   Unless required by applicable law or agreed to in writing, software
133   distributed under the License is distributed on an "AS IS" BASIS,
134   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
135   See the License for the specific language governing permissions and
136   limitations under the License.
137 
138 */
139 
140 pragma solidity 0.4.18;
141 
142 
143 interface TermsContract {
144      /// When called, the registerTermStart function registers the fact that
145      ///    the debt agreement has begun.  This method is called as a hook by the
146      ///    DebtKernel when a debt order associated with `agreementId` is filled.
147      ///    Method is not required to make any sort of internal state change
148      ///    upon the debt agreement's start, but MUST return `true` in order to
149      ///    acknowledge receipt of the transaction.  If, for any reason, the
150      ///    debt agreement stored at `agreementId` is incompatible with this contract,
151      ///    MUST return `false`, which will cause the pertinent order fill to fail.
152      ///    If this method is called for a debt agreement whose term has already begun,
153      ///    must THROW.  Similarly, if this method is called by any contract other
154      ///    than the current DebtKernel, must THROW.
155      /// @param  agreementId bytes32. The agreement id (issuance hash) of the debt agreement to which this pertains.
156      /// @param  debtor address. The debtor in this particular issuance.
157      /// @return _success bool. Acknowledgment of whether
158     function registerTermStart(
159         bytes32 agreementId,
160         address debtor
161     ) public returns (bool _success);
162 
163      /// When called, the registerRepayment function records the debtor's
164      ///  repayment, as well as any auxiliary metadata needed by the contract
165      ///  to determine ex post facto the value repaid (e.g. current USD
166      ///  exchange rate)
167      /// @param  agreementId bytes32. The agreement id (issuance hash) of the debt agreement to which this pertains.
168      /// @param  payer address. The address of the payer.
169      /// @param  beneficiary address. The address of the payment's beneficiary.
170      /// @param  unitsOfRepayment uint. The units-of-value repaid in the transaction.
171      /// @param  tokenAddress address. The address of the token with which the repayment transaction was executed.
172     function registerRepayment(
173         bytes32 agreementId,
174         address payer,
175         address beneficiary,
176         uint256 unitsOfRepayment,
177         address tokenAddress
178     ) public returns (bool _success);
179 
180      /// Returns the cumulative units-of-value expected to be repaid by a given block timestamp.
181      ///  Note this is not a constant function -- this value can vary on basis of any number of
182      ///  conditions (e.g. interest rates can be renegotiated if repayments are delinquent).
183      /// @param  agreementId bytes32. The agreement id (issuance hash) of the debt agreement to which this pertains.
184      /// @param  timestamp uint. The timestamp of the block for which repayment expectation is being queried.
185      /// @return uint256 The cumulative units-of-value expected to be repaid by the time the given timestamp lapses.
186     function getExpectedRepaymentValue(
187         bytes32 agreementId,
188         uint256 timestamp
189     ) public view returns (uint256);
190 
191      /// Returns the cumulative units-of-value repaid by the point at which this method is called.
192      /// @param  agreementId bytes32. The agreement id (issuance hash) of the debt agreement to which this pertains.
193      /// @return uint256 The cumulative units-of-value repaid up until now.
194     function getValueRepaidToDate(
195         bytes32 agreementId
196     ) public view returns (uint256);
197 
198     /**
199      * A method that returns a Unix timestamp representing the end of the debt agreement's term.
200      * contract.
201      */
202     function getTermEndTimestamp(
203         bytes32 _agreementId
204     ) public view returns (uint);
205 }
206 
207 // File: contracts/libraries/PermissionsLib.sol
208 
209 /*
210 
211   Copyright 2017 Dharma Labs Inc.
212 
213   Licensed under the Apache License, Version 2.0 (the "License");
214   you may not use this file except in compliance with the License.
215   You may obtain a copy of the License at
216 
217     http://www.apache.org/licenses/LICENSE-2.0
218 
219   Unless required by applicable law or agreed to in writing, software
220   distributed under the License is distributed on an "AS IS" BASIS,
221   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
222   See the License for the specific language governing permissions and
223   limitations under the License.
224 
225 */
226 
227 pragma solidity 0.4.18;
228 
229 
230 /**
231  *  Note(kayvon): these events are emitted by our PermissionsLib, but all contracts that
232  *  depend on the library must also define the events in order for web3 clients to pick them up.
233  *  This topic is discussed in greater detail here (under the section "Events and Libraries"):
234  *  https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736
235  */
236 contract PermissionEvents {
237     event Authorized(address indexed agent, string callingContext);
238     event AuthorizationRevoked(address indexed agent, string callingContext);
239 }
240 
241 
242 library PermissionsLib {
243 
244     // TODO(kayvon): remove these events and inherit from PermissionEvents when libraries are
245     // capable of inheritance.
246     // See relevant github issue here: https://github.com/ethereum/solidity/issues/891
247     event Authorized(address indexed agent, string callingContext);
248     event AuthorizationRevoked(address indexed agent, string callingContext);
249 
250     struct Permissions {
251         mapping (address => bool) authorized;
252         mapping (address => uint) agentToIndex; // ensures O(1) look-up
253         address[] authorizedAgents;
254     }
255 
256     function authorize(
257         Permissions storage self,
258         address agent,
259         string callingContext
260     )
261         internal
262     {
263         require(isNotAuthorized(self, agent));
264 
265         self.authorized[agent] = true;
266         self.authorizedAgents.push(agent);
267         self.agentToIndex[agent] = self.authorizedAgents.length - 1;
268         Authorized(agent, callingContext);
269     }
270 
271     function revokeAuthorization(
272         Permissions storage self,
273         address agent,
274         string callingContext
275     )
276         internal
277     {
278         /* We only want to do work in the case where the agent whose
279         authorization is being revoked had authorization permissions in the
280         first place. */
281         require(isAuthorized(self, agent));
282 
283         uint indexOfAgentToRevoke = self.agentToIndex[agent];
284         uint indexOfAgentToMove = self.authorizedAgents.length - 1;
285         address agentToMove = self.authorizedAgents[indexOfAgentToMove];
286 
287         // Revoke the agent's authorization.
288         delete self.authorized[agent];
289 
290         // Remove the agent from our collection of authorized agents.
291         self.authorizedAgents[indexOfAgentToRevoke] = agentToMove;
292 
293         // Update our indices to reflect the above changes.
294         self.agentToIndex[agentToMove] = indexOfAgentToRevoke;
295         delete self.agentToIndex[agent];
296 
297         // Clean up memory that's no longer being used.
298         delete self.authorizedAgents[indexOfAgentToMove];
299         self.authorizedAgents.length -= 1;
300 
301         AuthorizationRevoked(agent, callingContext);
302     }
303 
304     function isAuthorized(Permissions storage self, address agent)
305         internal
306         view
307         returns (bool)
308     {
309         return self.authorized[agent];
310     }
311 
312     function isNotAuthorized(Permissions storage self, address agent)
313         internal
314         view
315         returns (bool)
316     {
317         return !isAuthorized(self, agent);
318     }
319 
320     function getAuthorizedAgents(Permissions storage self)
321         internal
322         view
323         returns (address[])
324     {
325         return self.authorizedAgents;
326     }
327 }
328 
329 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
330 
331 /**
332  * @title Pausable
333  * @dev Base contract which allows children to implement an emergency stop mechanism.
334  */
335 contract Pausable is Ownable {
336   event Pause();
337   event Unpause();
338 
339   bool public paused = false;
340 
341 
342   /**
343    * @dev Modifier to make a function callable only when the contract is not paused.
344    */
345   modifier whenNotPaused() {
346     require(!paused);
347     _;
348   }
349 
350   /**
351    * @dev Modifier to make a function callable only when the contract is paused.
352    */
353   modifier whenPaused() {
354     require(paused);
355     _;
356   }
357 
358   /**
359    * @dev called by the owner to pause, triggers stopped state
360    */
361   function pause() onlyOwner whenNotPaused public {
362     paused = true;
363     Pause();
364   }
365 
366   /**
367    * @dev called by the owner to unpause, returns to normal state
368    */
369   function unpause() onlyOwner whenPaused public {
370     paused = false;
371     Unpause();
372   }
373 }
374 
375 // File: contracts/DebtRegistry.sol
376 
377 /*
378 
379   Copyright 2017 Dharma Labs Inc.
380 
381   Licensed under the Apache License, Version 2.0 (the "License");
382   you may not use this file except in compliance with the License.
383   You may obtain a copy of the License at
384 
385     http://www.apache.org/licenses/LICENSE-2.0
386 
387   Unless required by applicable law or agreed to in writing, software
388   distributed under the License is distributed on an "AS IS" BASIS,
389   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
390   See the License for the specific language governing permissions and
391   limitations under the License.
392 
393 */
394 
395 pragma solidity 0.4.18;
396 
397 
398 
399 
400 
401 /**
402  * The DebtRegistry stores the parameters and beneficiaries of all debt agreements in
403  * Dharma protocol.  It authorizes a limited number of agents to
404  * perform mutations on it -- those agents can be changed at any
405  * time by the contract's owner.
406  *
407  * Author: Nadav Hollander -- Github: nadavhollander
408  */
409 contract DebtRegistry is Pausable, PermissionEvents {
410     using SafeMath for uint;
411     using PermissionsLib for PermissionsLib.Permissions;
412 
413     struct Entry {
414         address version;
415         address beneficiary;
416         address underwriter;
417         uint underwriterRiskRating;
418         address termsContract;
419         bytes32 termsContractParameters;
420         uint issuanceBlockTimestamp;
421     }
422 
423     // Primary registry mapping agreement IDs to their corresponding entries
424     mapping (bytes32 => Entry) internal registry;
425 
426     // Maps debtor addresses to a list of their debts' agreement IDs
427     mapping (address => bytes32[]) internal debtorToDebts;
428 
429     PermissionsLib.Permissions internal entryInsertPermissions;
430     PermissionsLib.Permissions internal entryEditPermissions;
431 
432     string public constant INSERT_CONTEXT = "debt-registry-insert";
433     string public constant EDIT_CONTEXT = "debt-registry-edit";
434 
435     event LogInsertEntry(
436         bytes32 indexed agreementId,
437         address indexed beneficiary,
438         address indexed underwriter,
439         uint underwriterRiskRating,
440         address termsContract,
441         bytes32 termsContractParameters
442     );
443 
444     event LogModifyEntryBeneficiary(
445         bytes32 indexed agreementId,
446         address indexed previousBeneficiary,
447         address indexed newBeneficiary
448     );
449 
450     modifier onlyAuthorizedToInsert() {
451         require(entryInsertPermissions.isAuthorized(msg.sender));
452         _;
453     }
454 
455     modifier onlyAuthorizedToEdit() {
456         require(entryEditPermissions.isAuthorized(msg.sender));
457         _;
458     }
459 
460     modifier onlyExtantEntry(bytes32 agreementId) {
461         require(doesEntryExist(agreementId));
462         _;
463     }
464 
465     modifier nonNullBeneficiary(address beneficiary) {
466         require(beneficiary != address(0));
467         _;
468     }
469 
470     /* Ensures an entry with the specified agreement ID exists within the debt registry. */
471     function doesEntryExist(bytes32 agreementId)
472         public
473         view
474         returns (bool exists)
475     {
476         return registry[agreementId].beneficiary != address(0);
477     }
478 
479     /**
480      * Inserts a new entry into the registry, if the entry is valid and sender is
481      * authorized to make 'insert' mutations to the registry.
482      */
483     function insert(
484         address _version,
485         address _beneficiary,
486         address _debtor,
487         address _underwriter,
488         uint _underwriterRiskRating,
489         address _termsContract,
490         bytes32 _termsContractParameters,
491         uint _salt
492     )
493         public
494         onlyAuthorizedToInsert
495         whenNotPaused
496         nonNullBeneficiary(_beneficiary)
497         returns (bytes32 _agreementId)
498     {
499         Entry memory entry = Entry(
500             _version,
501             _beneficiary,
502             _underwriter,
503             _underwriterRiskRating,
504             _termsContract,
505             _termsContractParameters,
506             block.timestamp
507         );
508 
509         bytes32 agreementId = _getAgreementId(entry, _debtor, _salt);
510 
511         require(registry[agreementId].beneficiary == address(0));
512 
513         registry[agreementId] = entry;
514         debtorToDebts[_debtor].push(agreementId);
515 
516         LogInsertEntry(
517             agreementId,
518             entry.beneficiary,
519             entry.underwriter,
520             entry.underwriterRiskRating,
521             entry.termsContract,
522             entry.termsContractParameters
523         );
524 
525         return agreementId;
526     }
527 
528     /**
529      * Modifies the beneficiary of a debt issuance, if the sender
530      * is authorized to make 'modifyBeneficiary' mutations to
531      * the registry.
532      */
533     function modifyBeneficiary(bytes32 agreementId, address newBeneficiary)
534         public
535         onlyAuthorizedToEdit
536         whenNotPaused
537         onlyExtantEntry(agreementId)
538         nonNullBeneficiary(newBeneficiary)
539     {
540         address previousBeneficiary = registry[agreementId].beneficiary;
541 
542         registry[agreementId].beneficiary = newBeneficiary;
543 
544         LogModifyEntryBeneficiary(
545             agreementId,
546             previousBeneficiary,
547             newBeneficiary
548         );
549     }
550 
551     /**
552      * Adds an address to the list of agents authorized
553      * to make 'insert' mutations to the registry.
554      */
555     function addAuthorizedInsertAgent(address agent)
556         public
557         onlyOwner
558     {
559         entryInsertPermissions.authorize(agent, INSERT_CONTEXT);
560     }
561 
562     /**
563      * Adds an address to the list of agents authorized
564      * to make 'modifyBeneficiary' mutations to the registry.
565      */
566     function addAuthorizedEditAgent(address agent)
567         public
568         onlyOwner
569     {
570         entryEditPermissions.authorize(agent, EDIT_CONTEXT);
571     }
572 
573     /**
574      * Removes an address from the list of agents authorized
575      * to make 'insert' mutations to the registry.
576      */
577     function revokeInsertAgentAuthorization(address agent)
578         public
579         onlyOwner
580     {
581         entryInsertPermissions.revokeAuthorization(agent, INSERT_CONTEXT);
582     }
583 
584     /**
585      * Removes an address from the list of agents authorized
586      * to make 'modifyBeneficiary' mutations to the registry.
587      */
588     function revokeEditAgentAuthorization(address agent)
589         public
590         onlyOwner
591     {
592         entryEditPermissions.revokeAuthorization(agent, EDIT_CONTEXT);
593     }
594 
595     /**
596      * Returns the parameters of a debt issuance in the registry.
597      *
598      * TODO(kayvon): protect this function with our `onlyExtantEntry` modifier once the restriction
599      * on the size of the call stack has been addressed.
600      */
601     function get(bytes32 agreementId)
602         public
603         view
604         returns(address, address, address, uint, address, bytes32, uint)
605     {
606         return (
607             registry[agreementId].version,
608             registry[agreementId].beneficiary,
609             registry[agreementId].underwriter,
610             registry[agreementId].underwriterRiskRating,
611             registry[agreementId].termsContract,
612             registry[agreementId].termsContractParameters,
613             registry[agreementId].issuanceBlockTimestamp
614         );
615     }
616 
617     /**
618      * Returns the beneficiary of a given issuance
619      */
620     function getBeneficiary(bytes32 agreementId)
621         public
622         view
623         onlyExtantEntry(agreementId)
624         returns(address)
625     {
626         return registry[agreementId].beneficiary;
627     }
628 
629     /**
630      * Returns the terms contract address of a given issuance
631      */
632     function getTermsContract(bytes32 agreementId)
633         public
634         view
635         onlyExtantEntry(agreementId)
636         returns (address)
637     {
638         return registry[agreementId].termsContract;
639     }
640 
641     /**
642      * Returns the terms contract parameters of a given issuance
643      */
644     function getTermsContractParameters(bytes32 agreementId)
645         public
646         view
647         onlyExtantEntry(agreementId)
648         returns (bytes32)
649     {
650         return registry[agreementId].termsContractParameters;
651     }
652 
653     /**
654      * Returns a tuple of the terms contract and its associated parameters
655      * for a given issuance
656      */
657     function getTerms(bytes32 agreementId)
658         public
659         view
660         onlyExtantEntry(agreementId)
661         returns(address, bytes32)
662     {
663         return (
664             registry[agreementId].termsContract,
665             registry[agreementId].termsContractParameters
666         );
667     }
668 
669     /**
670      * Returns the timestamp of the block at which a debt agreement was issued.
671      */
672     function getIssuanceBlockTimestamp(bytes32 agreementId)
673         public
674         view
675         onlyExtantEntry(agreementId)
676         returns (uint timestamp)
677     {
678         return registry[agreementId].issuanceBlockTimestamp;
679     }
680 
681     /**
682      * Returns the list of agents authorized to make 'insert' mutations
683      */
684     function getAuthorizedInsertAgents()
685         public
686         view
687         returns(address[])
688     {
689         return entryInsertPermissions.getAuthorizedAgents();
690     }
691 
692     /**
693      * Returns the list of agents authorized to make 'modifyBeneficiary' mutations
694      */
695     function getAuthorizedEditAgents()
696         public
697         view
698         returns(address[])
699     {
700         return entryEditPermissions.getAuthorizedAgents();
701     }
702 
703     /**
704      * Returns the list of debt agreements a debtor is party to,
705      * with each debt agreement listed by agreement ID.
706      */
707     function getDebtorsDebts(address debtor)
708         public
709         view
710         returns(bytes32[])
711     {
712         return debtorToDebts[debtor];
713     }
714 
715     /**
716      * Helper function for computing the hash of a given issuance,
717      * and, in turn, its agreementId
718      */
719     function _getAgreementId(Entry _entry, address _debtor, uint _salt)
720         internal
721         pure
722         returns(bytes32)
723     {
724         return keccak256(
725             _entry.version,
726             _debtor,
727             _entry.underwriter,
728             _entry.underwriterRiskRating,
729             _entry.termsContract,
730             _entry.termsContractParameters,
731             _salt
732         );
733     }
734 }
735 
736 // File: contracts/TokenRegistry.sol
737 
738 /**
739  * The TokenRegistry is a basic registry mapping token symbols
740  * to their known, deployed addresses on the current blockchain.
741  *
742  * Note that the TokenRegistry does *not* mediate any of the
743  * core protocol's business logic, but, rather, is a helpful
744  * utility for Terms Contracts to use in encoding, decoding, and
745  * resolving the addresses of currently deployed tokens.
746  *
747  * At this point in time, administration of the Token Registry is
748  * under Dharma Labs' control.  With more sophisticated decentralized
749  * governance mechanisms, we intend to shift ownership of this utility
750  * contract to the Dharma community.
751  */
752 contract TokenRegistry is Ownable {
753     mapping (bytes32 => TokenAttributes) public symbolHashToTokenAttributes;
754     string[256] public tokenSymbolList;
755     uint8 public tokenSymbolListLength;
756 
757     struct TokenAttributes {
758         // The ERC20 contract address.
759         address tokenAddress;
760         // The index in `tokenSymbolList` where the token's symbol can be found.
761         uint tokenIndex;
762         // The name of the given token, e.g. "Canonical Wrapped Ether"
763         string name;
764         // The number of digits that come after the decimal place when displaying token value.
765         uint8 numDecimals;
766     }
767 
768     /**
769      * Maps the given symbol to the given token attributes.
770      */
771     function setTokenAttributes(
772         string _symbol,
773         address _tokenAddress,
774         string _tokenName,
775         uint8 _numDecimals
776     )
777         public onlyOwner
778     {
779         bytes32 symbolHash = keccak256(_symbol);
780 
781         // Attempt to retrieve the token's attributes from the registry.
782         TokenAttributes memory attributes = symbolHashToTokenAttributes[symbolHash];
783 
784         if (attributes.tokenAddress == address(0)) {
785             // The token has not yet been added to the registry.
786             attributes.tokenAddress = _tokenAddress;
787             attributes.numDecimals = _numDecimals;
788             attributes.name = _tokenName;
789             attributes.tokenIndex = tokenSymbolListLength;
790 
791             tokenSymbolList[tokenSymbolListLength] = _symbol;
792             tokenSymbolListLength++;
793         } else {
794             // The token has already been added to the registry; update attributes.
795             attributes.tokenAddress = _tokenAddress;
796             attributes.numDecimals = _numDecimals;
797             attributes.name = _tokenName;
798         }
799 
800         // Update this contract's storage.
801         symbolHashToTokenAttributes[symbolHash] = attributes;
802     }
803 
804     /**
805      * Given a symbol, resolves the current address of the token the symbol is mapped to.
806      */
807     function getTokenAddressBySymbol(string _symbol) public view returns (address) {
808         bytes32 symbolHash = keccak256(_symbol);
809 
810         TokenAttributes storage attributes = symbolHashToTokenAttributes[symbolHash];
811 
812         return attributes.tokenAddress;
813     }
814 
815     /**
816      * Given the known index of a token within the registry's symbol list,
817      * returns the address of the token mapped to the symbol at that index.
818      *
819      * This is a useful utility for compactly encoding the address of a token into a
820      * TermsContractParameters string -- by encoding a token by its index in a
821      * a 256 slot array, we can represent a token by a 1 byte uint instead of a 20 byte address.
822      */
823     function getTokenAddressByIndex(uint _index) public view returns (address) {
824         string storage symbol = tokenSymbolList[_index];
825 
826         return getTokenAddressBySymbol(symbol);
827     }
828 
829     /**
830      * Given a symbol, resolves the index of the token the symbol is mapped to within the registry's
831      * symbol list.
832      */
833     function getTokenIndexBySymbol(string _symbol) public view returns (uint) {
834         bytes32 symbolHash = keccak256(_symbol);
835 
836         TokenAttributes storage attributes = symbolHashToTokenAttributes[symbolHash];
837 
838         return attributes.tokenIndex;
839     }
840 
841     /**
842      * Given an index, resolves the symbol of the token at that index in the registry's
843      * token symbol list.
844      */
845     function getTokenSymbolByIndex(uint _index) public view returns (string) {
846         return tokenSymbolList[_index];
847     }
848 
849     /**
850      * Given a symbol, returns the name of the token the symbol is mapped to within the registry's
851      * symbol list.
852      */
853     function getTokenNameBySymbol(string _symbol) public view returns (string) {
854         bytes32 symbolHash = keccak256(_symbol);
855 
856         TokenAttributes storage attributes = symbolHashToTokenAttributes[symbolHash];
857 
858         return attributes.name;
859     }
860 
861     /**
862      * Given the symbol for a token, returns the number of decimals as provided in
863      * the associated TokensAttribute struct.
864      *
865      * Example:
866      *   getNumDecimalsFromSymbol("REP");
867      *   => 18
868      */
869     function getNumDecimalsFromSymbol(string _symbol) public view returns (uint8) {
870         bytes32 symbolHash = keccak256(_symbol);
871 
872         TokenAttributes storage attributes = symbolHashToTokenAttributes[symbolHash];
873 
874         return attributes.numDecimals;
875     }
876 
877     /**
878      * Given the index for a token in the registry, returns the number of decimals as provided in
879      * the associated TokensAttribute struct.
880      *
881      * Example:
882      *   getNumDecimalsByIndex(1);
883      *   => 18
884      */
885     function getNumDecimalsByIndex(uint _index) public view returns (uint8) {
886         string memory symbol = getTokenSymbolByIndex(_index);
887 
888         return getNumDecimalsFromSymbol(symbol);
889     }
890 
891     /**
892      * Given the index for a token in the registry, returns the name of the token as provided in
893      * the associated TokensAttribute struct.
894      *
895      * Example:
896      *   getTokenNameByIndex(1);
897      *   => "Canonical Wrapped Ether"
898      */
899     function getTokenNameByIndex(uint _index) public view returns (string) {
900         string memory symbol = getTokenSymbolByIndex(_index);
901 
902         string memory tokenName = getTokenNameBySymbol(symbol);
903 
904         return tokenName;
905     }
906 
907     /**
908      * Given the symbol for a token in the registry, returns a tuple containing the token's address,
909      * the token's index in the registry, the token's name, and the number of decimals.
910      *
911      * Example:
912      *   getTokenAttributesBySymbol("WETH");
913      *   => ["0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2", 1, "Canonical Wrapped Ether", 18]
914      */
915     function getTokenAttributesBySymbol(string _symbol)
916         public
917         view
918         returns (
919             address,
920             uint,
921             string,
922             uint
923         )
924     {
925         bytes32 symbolHash = keccak256(_symbol);
926 
927         TokenAttributes storage attributes = symbolHashToTokenAttributes[symbolHash];
928 
929         return (
930             attributes.tokenAddress,
931             attributes.tokenIndex,
932             attributes.name,
933             attributes.numDecimals
934         );
935     }
936 
937     /**
938      * Given the index for a token in the registry, returns a tuple containing the token's address,
939      * the token's symbol, the token's name, and the number of decimals.
940      *
941      * Example:
942      *   getTokenAttributesByIndex(1);
943      *   => ["0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2", "WETH", "Canonical Wrapped Ether", 18]
944      */
945     function getTokenAttributesByIndex(uint _index)
946         public
947         view
948         returns (
949             address,
950             string,
951             string,
952             uint8
953         )
954     {
955         string memory symbol = getTokenSymbolByIndex(_index);
956 
957         bytes32 symbolHash = keccak256(symbol);
958 
959         TokenAttributes storage attributes = symbolHashToTokenAttributes[symbolHash];
960 
961         return (
962             attributes.tokenAddress,
963             symbol,
964             attributes.name,
965             attributes.numDecimals
966         );
967     }
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
1518 
1519 // File: contracts/ERC165.sol
1520 
1521 /*
1522 
1523   Copyright 2017 Dharma Labs Inc.
1524 
1525   Licensed under the Apache License, Version 2.0 (the "License");
1526   you may not use this file except in compliance with the License.
1527   You may obtain a copy of the License at
1528 
1529     http://www.apache.org/licenses/LICENSE-2.0
1530 
1531   Unless required by applicable law or agreed to in writing, software
1532   distributed under the License is distributed on an "AS IS" BASIS,
1533   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1534   See the License for the specific language governing permissions and
1535   limitations under the License.
1536 
1537 */
1538 
1539 pragma solidity 0.4.18;
1540 
1541 
1542 /**
1543  * ERC165 interface required by ERC721 non-fungible token.
1544  *
1545  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1546  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
1547  */
1548 interface ERC165 {
1549     /// @notice Query if a contract implements an interface
1550     /// @param interfaceID The interface identifier, as specified in ERC-165
1551     /// @dev Interface identification is specified in ERC-165. This function
1552     ///  uses less than 30,000 gas.
1553     /// @return `true` if the contract implements `interfaceID` and
1554     ///  `interfaceID` is not 0xffffffff, `false` otherwise
1555     function supportsInterface(bytes4 interfaceID) external view returns (bool);
1556 }
1557 
1558 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
1559 
1560 /**
1561  * @title ERC721 Non-Fungible Token Standard basic interface
1562  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1563  */
1564 contract ERC721Basic {
1565   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
1566   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
1567   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);  
1568 
1569   function balanceOf(address _owner) public view returns (uint256 _balance);
1570   function ownerOf(uint256 _tokenId) public view returns (address _owner);
1571   function exists(uint256 _tokenId) public view returns (bool _exists);
1572   
1573   function approve(address _to, uint256 _tokenId) public;
1574   function getApproved(uint256 _tokenId) public view returns (address _operator);
1575   
1576   function setApprovalForAll(address _operator, bool _approved) public;
1577   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
1578 
1579   function transferFrom(address _from, address _to, uint256 _tokenId) public;
1580   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;  
1581   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
1582 }
1583 
1584 // File: zeppelin-solidity/contracts/token/ERC721/ERC721.sol
1585 
1586 /**
1587  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1588  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1589  */
1590 contract ERC721Enumerable is ERC721Basic {
1591   function totalSupply() public view returns (uint256);
1592   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
1593   function tokenByIndex(uint256 _index) public view returns (uint256);
1594 }
1595 
1596 /**
1597  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1598  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1599  */
1600 contract ERC721Metadata is ERC721Basic {
1601   function name() public view returns (string _name);
1602   function symbol() public view returns (string _symbol);
1603   function tokenURI(uint256 _tokenId) public view returns (string);
1604 }
1605 
1606 /**
1607  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
1608  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1609  */
1610 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
1611 }
1612 
1613 // File: zeppelin-solidity/contracts/token/ERC721/DeprecatedERC721.sol
1614 
1615 /**
1616  * @title ERC-721 methods shipped in OpenZeppelin v1.7.0, removed in the latest version of the standard
1617  * @dev Only use this interface for compatibility with previously deployed contracts
1618  * @dev Use ERC721 for interacting with new contracts which are standard-compliant
1619  */
1620 contract DeprecatedERC721 is ERC721 {
1621   function takeOwnership(uint256 _tokenId) public;
1622   function transfer(address _to, uint256 _tokenId) public;
1623   function tokensOf(address _owner) public view returns (uint256[]);
1624 }
1625 
1626 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
1627 
1628 /**
1629  * @title ERC721 token receiver interface
1630  * @dev Interface for any contract that wants to support safeTransfers
1631  *  from ERC721 asset contracts.
1632  */
1633 contract ERC721Receiver {
1634   /**
1635    * @dev Magic value to be returned upon successful reception of an NFT
1636    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
1637    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
1638    */
1639   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba; 
1640 
1641   /**
1642    * @notice Handle the receipt of an NFT
1643    * @dev The ERC721 smart contract calls this function on the recipient
1644    *  after a `safetransfer`. This function MAY throw to revert and reject the
1645    *  transfer. This function MUST use 50,000 gas or less. Return of other
1646    *  than the magic value MUST result in the transaction being reverted.
1647    *  Note: the contract address is always the message sender.
1648    * @param _from The sending address 
1649    * @param _tokenId The NFT identifier which is being transfered
1650    * @param _data Additional data with no specified format
1651    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
1652    */
1653   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
1654 }
1655 
1656 // File: zeppelin-solidity/contracts/AddressUtils.sol
1657 
1658 /**
1659  * Utility library of inline functions on addresses
1660  */
1661 library AddressUtils {
1662 
1663   /**
1664    * Returns whether there is code in the target address
1665    * @dev This function will return false if invoked during the constructor of a contract,
1666    *  as the code is not actually created until after the constructor finishes.
1667    * @param addr address address to check
1668    * @return whether there is code in the target address
1669    */
1670   function isContract(address addr) internal view returns (bool) {
1671     uint256 size;
1672     assembly { size := extcodesize(addr) }
1673     return size > 0;
1674   }
1675 
1676 }
1677 
1678 // File: zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
1679 
1680 /**
1681  * @title ERC721 Non-Fungible Token Standard basic implementation
1682  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1683  */
1684 contract ERC721BasicToken is ERC721Basic {
1685   using SafeMath for uint256;
1686   using AddressUtils for address;
1687   
1688   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
1689   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
1690   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba; 
1691 
1692   // Mapping from token ID to owner
1693   mapping (uint256 => address) internal tokenOwner;
1694 
1695   // Mapping from token ID to approved address
1696   mapping (uint256 => address) internal tokenApprovals;
1697 
1698   // Mapping from owner to number of owned token
1699   mapping (address => uint256) internal ownedTokensCount;
1700 
1701   // Mapping from owner to operator approvals
1702   mapping (address => mapping (address => bool)) internal operatorApprovals;
1703 
1704   /**
1705   * @dev Guarantees msg.sender is owner of the given token
1706   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
1707   */
1708   modifier onlyOwnerOf(uint256 _tokenId) {
1709     require(ownerOf(_tokenId) == msg.sender);
1710     _;
1711   }
1712 
1713   /**
1714   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
1715   * @param _tokenId uint256 ID of the token to validate
1716   */
1717   modifier canTransfer(uint256 _tokenId) {
1718     require(isApprovedOrOwner(msg.sender, _tokenId));
1719     _;
1720   }
1721 
1722   /**
1723   * @dev Gets the balance of the specified address
1724   * @param _owner address to query the balance of
1725   * @return uint256 representing the amount owned by the passed address
1726   */
1727   function balanceOf(address _owner) public view returns (uint256) {
1728     require(_owner != address(0));
1729     return ownedTokensCount[_owner];
1730   }
1731 
1732   /**
1733   * @dev Gets the owner of the specified token ID
1734   * @param _tokenId uint256 ID of the token to query the owner of
1735   * @return owner address currently marked as the owner of the given token ID
1736   */
1737   function ownerOf(uint256 _tokenId) public view returns (address) {
1738     address owner = tokenOwner[_tokenId];
1739     require(owner != address(0));
1740     return owner;
1741   }
1742 
1743   /**
1744   * @dev Returns whether the specified token exists
1745   * @param _tokenId uint256 ID of the token to query the existance of
1746   * @return whether the token exists
1747   */
1748   function exists(uint256 _tokenId) public view returns (bool) {
1749     address owner = tokenOwner[_tokenId];
1750     return owner != address(0);
1751   }
1752 
1753   /**
1754   * @dev Approves another address to transfer the given token ID
1755   * @dev The zero address indicates there is no approved address.
1756   * @dev There can only be one approved address per token at a given time.
1757   * @dev Can only be called by the token owner or an approved operator.
1758   * @param _to address to be approved for the given token ID
1759   * @param _tokenId uint256 ID of the token to be approved
1760   */
1761   function approve(address _to, uint256 _tokenId) public {
1762     address owner = ownerOf(_tokenId);
1763     require(_to != owner);
1764     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
1765 
1766     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
1767       tokenApprovals[_tokenId] = _to;
1768       Approval(owner, _to, _tokenId);
1769     }
1770   }
1771 
1772   /**
1773    * @dev Gets the approved address for a token ID, or zero if no address set
1774    * @param _tokenId uint256 ID of the token to query the approval of
1775    * @return address currently approved for a the given token ID
1776    */
1777   function getApproved(uint256 _tokenId) public view returns (address) {
1778     return tokenApprovals[_tokenId];
1779   }
1780 
1781 
1782   /**
1783   * @dev Sets or unsets the approval of a given operator
1784   * @dev An operator is allowed to transfer all tokens of the sender on their behalf
1785   * @param _to operator address to set the approval
1786   * @param _approved representing the status of the approval to be set
1787   */
1788   function setApprovalForAll(address _to, bool _approved) public {
1789     require(_to != msg.sender);
1790     operatorApprovals[msg.sender][_to] = _approved;
1791     ApprovalForAll(msg.sender, _to, _approved);
1792   }
1793 
1794   /**
1795    * @dev Tells whether an operator is approved by a given owner
1796    * @param _owner owner address which you want to query the approval of
1797    * @param _operator operator address which you want to query the approval of
1798    * @return bool whether the given operator is approved by the given owner
1799    */
1800   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
1801     return operatorApprovals[_owner][_operator];
1802   }
1803 
1804   /**
1805   * @dev Transfers the ownership of a given token ID to another address
1806   * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1807   * @dev Requires the msg sender to be the owner, approved, or operator
1808   * @param _from current owner of the token
1809   * @param _to address to receive the ownership of the given token ID
1810   * @param _tokenId uint256 ID of the token to be transferred
1811   */
1812   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
1813     require(_from != address(0));
1814     require(_to != address(0));
1815 
1816     clearApproval(_from, _tokenId);
1817     removeTokenFrom(_from, _tokenId);
1818     addTokenTo(_to, _tokenId);
1819     
1820     Transfer(_from, _to, _tokenId);
1821   }
1822 
1823   /**
1824   * @dev Safely transfers the ownership of a given token ID to another address
1825   * @dev If the target address is a contract, it must implement `onERC721Received`,
1826   *  which is called upon a safe transfer, and return the magic value
1827   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
1828   *  the transfer is reverted.
1829   * @dev Requires the msg sender to be the owner, approved, or operator
1830   * @param _from current owner of the token
1831   * @param _to address to receive the ownership of the given token ID
1832   * @param _tokenId uint256 ID of the token to be transferred
1833   */
1834   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
1835     safeTransferFrom(_from, _to, _tokenId, "");
1836   }
1837 
1838   /**
1839   * @dev Safely transfers the ownership of a given token ID to another address
1840   * @dev If the target address is a contract, it must implement `onERC721Received`,
1841   *  which is called upon a safe transfer, and return the magic value
1842   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
1843   *  the transfer is reverted.
1844   * @dev Requires the msg sender to be the owner, approved, or operator
1845   * @param _from current owner of the token
1846   * @param _to address to receive the ownership of the given token ID
1847   * @param _tokenId uint256 ID of the token to be transferred
1848   * @param _data bytes data to send along with a safe transfer check
1849   */
1850   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public canTransfer(_tokenId) {
1851     transferFrom(_from, _to, _tokenId);
1852     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
1853   }
1854 
1855   /**
1856    * @dev Returns whether the given spender can transfer a given token ID
1857    * @param _spender address of the spender to query
1858    * @param _tokenId uint256 ID of the token to be transferred
1859    * @return bool whether the msg.sender is approved for the given token ID,
1860    *  is an operator of the owner, or is the owner of the token
1861    */
1862   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
1863     address owner = ownerOf(_tokenId);
1864     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
1865   }
1866 
1867   /**
1868   * @dev Internal function to mint a new token
1869   * @dev Reverts if the given token ID already exists
1870   * @param _to The address that will own the minted token
1871   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1872   */
1873   function _mint(address _to, uint256 _tokenId) internal {
1874     require(_to != address(0));
1875     addTokenTo(_to, _tokenId);
1876     Transfer(address(0), _to, _tokenId);
1877   }
1878 
1879   /**
1880   * @dev Internal function to burn a specific token
1881   * @dev Reverts if the token does not exist
1882   * @param _tokenId uint256 ID of the token being burned by the msg.sender
1883   */
1884   function _burn(address _owner, uint256 _tokenId) internal {
1885     clearApproval(_owner, _tokenId);
1886     removeTokenFrom(_owner, _tokenId);
1887     Transfer(_owner, address(0), _tokenId);
1888   }
1889 
1890   /**
1891   * @dev Internal function to clear current approval of a given token ID
1892   * @dev Reverts if the given address is not indeed the owner of the token
1893   * @param _owner owner of the token
1894   * @param _tokenId uint256 ID of the token to be transferred
1895   */
1896   function clearApproval(address _owner, uint256 _tokenId) internal {
1897     require(ownerOf(_tokenId) == _owner);
1898     if (tokenApprovals[_tokenId] != address(0)) {
1899       tokenApprovals[_tokenId] = address(0);
1900       Approval(_owner, address(0), _tokenId);
1901     }
1902   }
1903 
1904   /**
1905   * @dev Internal function to add a token ID to the list of a given address
1906   * @param _to address representing the new owner of the given token ID
1907   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1908   */
1909   function addTokenTo(address _to, uint256 _tokenId) internal {
1910     require(tokenOwner[_tokenId] == address(0));
1911     tokenOwner[_tokenId] = _to;
1912     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
1913   }
1914 
1915   /**
1916   * @dev Internal function to remove a token ID from the list of a given address
1917   * @param _from address representing the previous owner of the given token ID
1918   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1919   */
1920   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1921     require(ownerOf(_tokenId) == _from);
1922     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
1923     tokenOwner[_tokenId] = address(0);
1924   }
1925 
1926   /**
1927   * @dev Internal function to invoke `onERC721Received` on a target address
1928   * @dev The call is not executed if the target address is not a contract
1929   * @param _from address representing the previous owner of the given token ID
1930   * @param _to target address that will receive the tokens
1931   * @param _tokenId uint256 ID of the token to be transferred
1932   * @param _data bytes optional data to send along with the call
1933   * @return whether the call correctly returned the expected magic value
1934   */
1935   function checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes _data) internal returns (bool) {
1936     if (!_to.isContract()) {
1937       return true;
1938     }
1939     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
1940     return (retval == ERC721_RECEIVED);
1941   }
1942 }
1943 
1944 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
1945 
1946 /**
1947  * @title Full ERC721 Token
1948  * This implementation includes all the required and some optional functionality of the ERC721 standard
1949  * Moreover, it includes approve all functionality using operator terminology
1950  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1951  */
1952 contract ERC721Token is ERC721, ERC721BasicToken {
1953   // Token name
1954   string internal name_;
1955 
1956   // Token symbol
1957   string internal symbol_;
1958 
1959   // Mapping from owner to list of owned token IDs
1960   mapping (address => uint256[]) internal ownedTokens;
1961 
1962   // Mapping from token ID to index of the owner tokens list
1963   mapping(uint256 => uint256) internal ownedTokensIndex;
1964 
1965   // Array with all token ids, used for enumeration
1966   uint256[] internal allTokens;
1967 
1968   // Mapping from token id to position in the allTokens array
1969   mapping(uint256 => uint256) internal allTokensIndex;
1970 
1971   // Optional mapping for token URIs 
1972   mapping(uint256 => string) internal tokenURIs;
1973 
1974   /**
1975   * @dev Constructor function
1976   */
1977   function ERC721Token(string _name, string _symbol) public {
1978     name_ = _name;
1979     symbol_ = _symbol;
1980   }
1981 
1982   /**
1983   * @dev Gets the token name
1984   * @return string representing the token name
1985   */
1986   function name() public view returns (string) {
1987     return name_;
1988   }
1989 
1990   /**
1991   * @dev Gets the token symbol
1992   * @return string representing the token symbol
1993   */
1994   function symbol() public view returns (string) {
1995     return symbol_;
1996   }
1997 
1998   /**
1999   * @dev Returns an URI for a given token ID
2000   * @dev Throws if the token ID does not exist. May return an empty string.
2001   * @param _tokenId uint256 ID of the token to query
2002   */
2003   function tokenURI(uint256 _tokenId) public view returns (string) {
2004     require(exists(_tokenId));
2005     return tokenURIs[_tokenId];
2006   }
2007 
2008   /**
2009   * @dev Internal function to set the token URI for a given token
2010   * @dev Reverts if the token ID does not exist
2011   * @param _tokenId uint256 ID of the token to set its URI
2012   * @param _uri string URI to assign
2013   */
2014   function _setTokenURI(uint256 _tokenId, string _uri) internal {
2015     require(exists(_tokenId));
2016     tokenURIs[_tokenId] = _uri;
2017   }
2018 
2019   /**
2020   * @dev Gets the token ID at a given index of the tokens list of the requested owner
2021   * @param _owner address owning the tokens list to be accessed
2022   * @param _index uint256 representing the index to be accessed of the requested tokens list
2023   * @return uint256 token ID at the given index of the tokens list owned by the requested address
2024   */
2025   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
2026     require(_index < balanceOf(_owner));
2027     return ownedTokens[_owner][_index];
2028   }
2029 
2030   /**
2031   * @dev Gets the total amount of tokens stored by the contract
2032   * @return uint256 representing the total amount of tokens
2033   */
2034   function totalSupply() public view returns (uint256) {
2035     return allTokens.length;
2036   }
2037 
2038   /**
2039   * @dev Gets the token ID at a given index of all the tokens in this contract
2040   * @dev Reverts if the index is greater or equal to the total number of tokens
2041   * @param _index uint256 representing the index to be accessed of the tokens list
2042   * @return uint256 token ID at the given index of the tokens list
2043   */
2044   function tokenByIndex(uint256 _index) public view returns (uint256) {
2045     require(_index < totalSupply());
2046     return allTokens[_index];
2047   }
2048 
2049   /**
2050   * @dev Internal function to add a token ID to the list of a given address
2051   * @param _to address representing the new owner of the given token ID
2052   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
2053   */
2054   function addTokenTo(address _to, uint256 _tokenId) internal {
2055     super.addTokenTo(_to, _tokenId);
2056     uint256 length = ownedTokens[_to].length;
2057     ownedTokens[_to].push(_tokenId);
2058     ownedTokensIndex[_tokenId] = length;
2059   }
2060 
2061   /**
2062   * @dev Internal function to remove a token ID from the list of a given address
2063   * @param _from address representing the previous owner of the given token ID
2064   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
2065   */
2066   function removeTokenFrom(address _from, uint256 _tokenId) internal {
2067     super.removeTokenFrom(_from, _tokenId);
2068 
2069     uint256 tokenIndex = ownedTokensIndex[_tokenId];
2070     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
2071     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
2072 
2073     ownedTokens[_from][tokenIndex] = lastToken;
2074     ownedTokens[_from][lastTokenIndex] = 0;
2075     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
2076     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
2077     // the lastToken to the first position, and then dropping the element placed in the last position of the list
2078 
2079     ownedTokens[_from].length--;
2080     ownedTokensIndex[_tokenId] = 0;
2081     ownedTokensIndex[lastToken] = tokenIndex;
2082   }
2083 
2084   /**
2085   * @dev Internal function to mint a new token
2086   * @dev Reverts if the given token ID already exists
2087   * @param _to address the beneficiary that will own the minted token
2088   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
2089   */
2090   function _mint(address _to, uint256 _tokenId) internal {
2091     super._mint(_to, _tokenId);
2092     
2093     allTokensIndex[_tokenId] = allTokens.length;
2094     allTokens.push(_tokenId);
2095   }
2096 
2097   /**
2098   * @dev Internal function to burn a specific token
2099   * @dev Reverts if the token does not exist
2100   * @param _owner owner of the token to burn
2101   * @param _tokenId uint256 ID of the token being burned by the msg.sender
2102   */
2103   function _burn(address _owner, uint256 _tokenId) internal {
2104     super._burn(_owner, _tokenId);
2105 
2106     // Clear metadata (if any)
2107     if (bytes(tokenURIs[_tokenId]).length != 0) {
2108       delete tokenURIs[_tokenId];
2109     }
2110 
2111     // Reorg all tokens array
2112     uint256 tokenIndex = allTokensIndex[_tokenId];
2113     uint256 lastTokenIndex = allTokens.length.sub(1);
2114     uint256 lastToken = allTokens[lastTokenIndex];
2115 
2116     allTokens[tokenIndex] = lastToken;
2117     allTokens[lastTokenIndex] = 0;
2118 
2119     allTokens.length--;
2120     allTokensIndex[_tokenId] = 0;
2121     allTokensIndex[lastToken] = tokenIndex;
2122   }
2123 
2124 }
2125 
2126 // File: contracts/DebtToken.sol
2127 
2128 /*
2129 
2130   Copyright 2017 Dharma Labs Inc.
2131 
2132   Licensed under the Apache License, Version 2.0 (the "License");
2133   you may not use this file except in compliance with the License.
2134   You may obtain a copy of the License at
2135 
2136     http://www.apache.org/licenses/LICENSE-2.0
2137 
2138   Unless required by applicable law or agreed to in writing, software
2139   distributed under the License is distributed on an "AS IS" BASIS,
2140   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2141   See the License for the specific language governing permissions and
2142   limitations under the License.
2143 
2144 */
2145 
2146 pragma solidity 0.4.18;
2147 
2148 // Internal dependencies.
2149 
2150 
2151 
2152 
2153 // External dependencies.
2154 
2155 
2156 
2157 
2158 
2159 /**
2160  * The DebtToken contract governs all business logic for making a debt agreement
2161  * transferable as an ERC721 non-fungible token.  Additionally, the contract
2162  * allows authorized contracts to trigger the minting of a debt agreement token
2163  * and, in turn, the insertion of a debt issuance into the DebtRegsitry.
2164  *
2165  * Author: Nadav Hollander -- Github: nadavhollander
2166  */
2167 contract DebtToken is ERC721Token, ERC165, Pausable, PermissionEvents {
2168     using PermissionsLib for PermissionsLib.Permissions;
2169 
2170     DebtRegistry public registry;
2171 
2172     PermissionsLib.Permissions internal tokenCreationPermissions;
2173     PermissionsLib.Permissions internal tokenURIPermissions;
2174 
2175     string public constant CREATION_CONTEXT = "debt-token-creation";
2176     string public constant URI_CONTEXT = "debt-token-uri";
2177 
2178     /**
2179      * Constructor that sets the address of the debt registry.
2180      */
2181     function DebtToken(address _registry)
2182         public
2183         ERC721Token("DebtToken", "DDT")
2184     {
2185         registry = DebtRegistry(_registry);
2186     }
2187 
2188     /**
2189      * ERC165 interface.
2190      * Returns true for ERC721, false otherwise
2191      */
2192     function supportsInterface(bytes4 interfaceID)
2193         external
2194         view
2195         returns (bool _isSupported)
2196     {
2197         return interfaceID == 0x80ac58cd; // ERC721
2198     }
2199 
2200     /**
2201      * Mints a unique debt token and inserts the associated issuance into
2202      * the debt registry, if the calling address is authorized to do so.
2203      */
2204     function create(
2205         address _version,
2206         address _beneficiary,
2207         address _debtor,
2208         address _underwriter,
2209         uint _underwriterRiskRating,
2210         address _termsContract,
2211         bytes32 _termsContractParameters,
2212         uint _salt
2213     )
2214         public
2215         whenNotPaused
2216         returns (uint _tokenId)
2217     {
2218         require(tokenCreationPermissions.isAuthorized(msg.sender));
2219 
2220         bytes32 entryHash = registry.insert(
2221             _version,
2222             _beneficiary,
2223             _debtor,
2224             _underwriter,
2225             _underwriterRiskRating,
2226             _termsContract,
2227             _termsContractParameters,
2228             _salt
2229         );
2230 
2231         super._mint(_beneficiary, uint(entryHash));
2232 
2233         return uint(entryHash);
2234     }
2235 
2236     /**
2237      * Adds an address to the list of agents authorized to mint debt tokens.
2238      */
2239     function addAuthorizedMintAgent(address _agent)
2240         public
2241         onlyOwner
2242     {
2243         tokenCreationPermissions.authorize(_agent, CREATION_CONTEXT);
2244     }
2245 
2246     /**
2247      * Removes an address from the list of agents authorized to mint debt tokens
2248      */
2249     function revokeMintAgentAuthorization(address _agent)
2250         public
2251         onlyOwner
2252     {
2253         tokenCreationPermissions.revokeAuthorization(_agent, CREATION_CONTEXT);
2254     }
2255 
2256     /**
2257      * Returns the list of agents authorized to mint debt tokens
2258      */
2259     function getAuthorizedMintAgents()
2260         public
2261         view
2262         returns (address[] _agents)
2263     {
2264         return tokenCreationPermissions.getAuthorizedAgents();
2265     }
2266 
2267     /**
2268      * Adds an address to the list of agents authorized to set token URIs.
2269      */
2270     function addAuthorizedTokenURIAgent(address _agent)
2271         public
2272         onlyOwner
2273     {
2274         tokenURIPermissions.authorize(_agent, URI_CONTEXT);
2275     }
2276 
2277     /**
2278      * Returns the list of agents authorized to set token URIs.
2279      */
2280     function getAuthorizedTokenURIAgents()
2281         public
2282         view
2283         returns (address[] _agents)
2284     {
2285         return tokenURIPermissions.getAuthorizedAgents();
2286     }
2287 
2288     /**
2289      * Removes an address from the list of agents authorized to set token URIs.
2290      */
2291     function revokeTokenURIAuthorization(address _agent)
2292         public
2293         onlyOwner
2294     {
2295         tokenURIPermissions.revokeAuthorization(_agent, URI_CONTEXT);
2296     }
2297 
2298     /**
2299      * We override approval method of the parent ERC721Token
2300      * contract to allow its functionality to be frozen in the case of an emergency
2301      */
2302     function approve(address _to, uint _tokenId)
2303         public
2304         whenNotPaused
2305     {
2306         super.approve(_to, _tokenId);
2307     }
2308 
2309     /**
2310      * We override setApprovalForAll method of the parent ERC721Token
2311      * contract to allow its functionality to be frozen in the case of an emergency
2312      */
2313     function setApprovalForAll(address _to, bool _approved)
2314         public
2315         whenNotPaused
2316     {
2317         super.setApprovalForAll(_to, _approved);
2318     }
2319 
2320     /**
2321      * Support deprecated ERC721 method
2322      */
2323     function transfer(address _to, uint _tokenId)
2324         public
2325     {
2326         safeTransferFrom(msg.sender, _to, _tokenId);
2327     }
2328 
2329     /**
2330      * We override transferFrom methods of the parent ERC721Token
2331      * contract to allow its functionality to be frozen in the case of an emergency
2332      */
2333     function transferFrom(address _from, address _to, uint _tokenId)
2334         public
2335         whenNotPaused
2336     {
2337         _modifyBeneficiary(_tokenId, _to);
2338         super.transferFrom(_from, _to, _tokenId);
2339     }
2340 
2341     /**
2342      * We override safeTransferFrom methods of the parent ERC721Token
2343      * contract to allow its functionality to be frozen in the case of an emergency
2344      */
2345     function safeTransferFrom(address _from, address _to, uint _tokenId)
2346         public
2347         whenNotPaused
2348     {
2349         _modifyBeneficiary(_tokenId, _to);
2350         super.safeTransferFrom(_from, _to, _tokenId);
2351     }
2352 
2353     /**
2354      * We override safeTransferFrom methods of the parent ERC721Token
2355      * contract to allow its functionality to be frozen in the case of an emergency
2356      */
2357     function safeTransferFrom(address _from, address _to, uint _tokenId, bytes _data)
2358         public
2359         whenNotPaused
2360     {
2361         _modifyBeneficiary(_tokenId, _to);
2362         super.safeTransferFrom(_from, _to, _tokenId, _data);
2363     }
2364 
2365     /**
2366      * Allows senders with special permissions to set the token URI for a given debt token.
2367      */
2368     function setTokenURI(uint256 _tokenId, string _uri)
2369         public
2370         whenNotPaused
2371     {
2372         require(tokenURIPermissions.isAuthorized(msg.sender));
2373         super._setTokenURI(_tokenId, _uri);
2374     }
2375 
2376     /**
2377      * _modifyBeneficiary mutates the debt registry. This function should be
2378      * called every time a token is transferred or minted
2379      */
2380     function _modifyBeneficiary(uint _tokenId, address _to)
2381         internal
2382     {
2383         if (registry.getBeneficiary(bytes32(_tokenId)) != _to) {
2384             registry.modifyBeneficiary(bytes32(_tokenId), _to);
2385         }
2386     }
2387 }
2388 
2389 // File: contracts/DebtKernel.sol
2390 
2391 /*
2392 
2393   Copyright 2017 Dharma Labs Inc.
2394 
2395   Licensed under the Apache License, Version 2.0 (the "License");
2396   you may not use this file except in compliance with the License.
2397   You may obtain a copy of the License at
2398 
2399     http://www.apache.org/licenses/LICENSE-2.0
2400 
2401   Unless required by applicable law or agreed to in writing, software
2402   distributed under the License is distributed on an "AS IS" BASIS,
2403   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2404   See the License for the specific language governing permissions and
2405   limitations under the License.
2406 
2407 */
2408 
2409 pragma solidity 0.4.18;
2410 
2411 
2412 
2413 
2414 
2415 
2416 
2417 
2418 /**
2419  * The DebtKernel is the hub of all business logic governing how and when
2420  * debt orders can be filled and cancelled.  All logic that determines
2421  * whether a debt order is valid & consensual is contained herein,
2422  * as well as the mechanisms that transfer fees to keepers and
2423  * principal payments to debtors.
2424  *
2425  * Author: Nadav Hollander -- Github: nadavhollander
2426  */
2427 contract DebtKernel is Pausable {
2428     using SafeMath for uint;
2429 
2430     enum Errors {
2431         // Debt has been already been issued
2432         DEBT_ISSUED,
2433         // Order has already expired
2434         ORDER_EXPIRED,
2435         // Debt issuance associated with order has been cancelled
2436         ISSUANCE_CANCELLED,
2437         // Order has been cancelled
2438         ORDER_CANCELLED,
2439         // Order parameters specify amount of creditor / debtor fees
2440         // that is not equivalent to the amount of underwriter / relayer fees
2441         ORDER_INVALID_INSUFFICIENT_OR_EXCESSIVE_FEES,
2442         // Order parameters specify insufficient principal amount for
2443         // debtor to at least be able to meet his fees
2444         ORDER_INVALID_INSUFFICIENT_PRINCIPAL,
2445         // Order parameters specify non zero fee for an unspecified recipient
2446         ORDER_INVALID_UNSPECIFIED_FEE_RECIPIENT,
2447         // Order signatures are mismatched / malformed
2448         ORDER_INVALID_NON_CONSENSUAL,
2449         // Insufficient balance or allowance for principal token transfer
2450         CREDITOR_BALANCE_OR_ALLOWANCE_INSUFFICIENT
2451     }
2452 
2453     DebtToken public debtToken;
2454 
2455     // solhint-disable-next-line var-name-mixedcase
2456     address public TOKEN_TRANSFER_PROXY;
2457     bytes32 constant public NULL_ISSUANCE_HASH = bytes32(0);
2458 
2459     /* NOTE(kayvon): Currently, the `view` keyword does not actually enforce the
2460     static nature of the method; this will change in the future, but for now, in
2461     order to prevent reentrancy we'll need to arbitrarily set an upper bound on
2462     the gas limit allotted for certain method calls. */
2463     uint16 constant public EXTERNAL_QUERY_GAS_LIMIT = 8000;
2464 
2465     mapping (bytes32 => bool) public issuanceCancelled;
2466     mapping (bytes32 => bool) public debtOrderCancelled;
2467 
2468     event LogDebtOrderFilled(
2469         bytes32 indexed _agreementId,
2470         uint _principal,
2471         address _principalToken,
2472         address indexed _underwriter,
2473         uint _underwriterFee,
2474         address indexed _relayer,
2475         uint _relayerFee
2476     );
2477 
2478     event LogIssuanceCancelled(
2479         bytes32 indexed _agreementId,
2480         address indexed _cancelledBy
2481     );
2482 
2483     event LogDebtOrderCancelled(
2484         bytes32 indexed _debtOrderHash,
2485         address indexed _cancelledBy
2486     );
2487 
2488     event LogError(
2489         uint8 indexed _errorId,
2490         bytes32 indexed _orderHash
2491     );
2492 
2493     struct Issuance {
2494         address version;
2495         address debtor;
2496         address underwriter;
2497         uint underwriterRiskRating;
2498         address termsContract;
2499         bytes32 termsContractParameters;
2500         uint salt;
2501         bytes32 agreementId;
2502     }
2503 
2504     struct DebtOrder {
2505         Issuance issuance;
2506         uint underwriterFee;
2507         uint relayerFee;
2508         uint principalAmount;
2509         address principalToken;
2510         uint creditorFee;
2511         uint debtorFee;
2512         address relayer;
2513         uint expirationTimestampInSec;
2514         bytes32 debtOrderHash;
2515     }
2516 
2517     function DebtKernel(address tokenTransferProxyAddress)
2518         public
2519     {
2520         TOKEN_TRANSFER_PROXY = tokenTransferProxyAddress;
2521     }
2522 
2523     ////////////////////////
2524     // EXTERNAL FUNCTIONS //
2525     ////////////////////////
2526 
2527     /**
2528      * Allows contract owner to set the currently used debt token contract.
2529      * Function exists to maximize upgradeability of individual modules
2530      * in the entire system.
2531      */
2532     function setDebtToken(address debtTokenAddress)
2533         public
2534         onlyOwner
2535     {
2536         debtToken = DebtToken(debtTokenAddress);
2537     }
2538 
2539     /**
2540      * Fills a given debt order if it is valid and consensual.
2541      */
2542     function fillDebtOrder(
2543         address creditor,
2544         address[6] orderAddresses,
2545         uint[8] orderValues,
2546         bytes32[1] orderBytes32,
2547         uint8[3] signaturesV,
2548         bytes32[3] signaturesR,
2549         bytes32[3] signaturesS
2550     )
2551         public
2552         whenNotPaused
2553         returns (bytes32 _agreementId)
2554     {
2555         DebtOrder memory debtOrder = getDebtOrder(orderAddresses, orderValues, orderBytes32);
2556 
2557         // Assert order's validity & consensuality
2558         if (!assertDebtOrderValidityInvariants(debtOrder) ||
2559             !assertDebtOrderConsensualityInvariants(
2560                 debtOrder,
2561                 creditor,
2562                 signaturesV,
2563                 signaturesR,
2564                 signaturesS) ||
2565             !assertExternalBalanceAndAllowanceInvariants(creditor, debtOrder)) {
2566             return NULL_ISSUANCE_HASH;
2567         }
2568 
2569         // Mint debt token and finalize debt agreement
2570         issueDebtAgreement(creditor, debtOrder.issuance);
2571 
2572         // Register debt agreement's start with terms contract
2573         // We permit terms contracts to be undefined (for debt agreements which
2574         // may not have terms contracts associated with them), and only
2575         // register a term's start if the terms contract address is defined.
2576         if (debtOrder.issuance.termsContract != address(0)) {
2577             require(
2578                 TermsContract(debtOrder.issuance.termsContract)
2579                     .registerTermStart(
2580                         debtOrder.issuance.agreementId,
2581                         debtOrder.issuance.debtor
2582                     )
2583             );
2584         }
2585 
2586         // Transfer principal to debtor
2587         if (debtOrder.principalAmount > 0) {
2588             require(transferTokensFrom(
2589                 debtOrder.principalToken,
2590                 creditor,
2591                 debtOrder.issuance.debtor,
2592                 debtOrder.principalAmount.sub(debtOrder.debtorFee)
2593             ));
2594         }
2595 
2596         // Transfer underwriter fee to underwriter
2597         if (debtOrder.underwriterFee > 0) {
2598             require(transferTokensFrom(
2599                 debtOrder.principalToken,
2600                 creditor,
2601                 debtOrder.issuance.underwriter,
2602                 debtOrder.underwriterFee
2603             ));
2604         }
2605 
2606         // Transfer relayer fee to relayer
2607         if (debtOrder.relayerFee > 0) {
2608             require(transferTokensFrom(
2609                 debtOrder.principalToken,
2610                 creditor,
2611                 debtOrder.relayer,
2612                 debtOrder.relayerFee
2613             ));
2614         }
2615 
2616         LogDebtOrderFilled(
2617             debtOrder.issuance.agreementId,
2618             debtOrder.principalAmount,
2619             debtOrder.principalToken,
2620             debtOrder.issuance.underwriter,
2621             debtOrder.underwriterFee,
2622             debtOrder.relayer,
2623             debtOrder.relayerFee
2624         );
2625 
2626         return debtOrder.issuance.agreementId;
2627     }
2628 
2629     /**
2630      * Allows both underwriters and debtors to prevent a debt
2631      * issuance in which they're involved from being used in
2632      * a future debt order.
2633      */
2634     function cancelIssuance(
2635         address version,
2636         address debtor,
2637         address termsContract,
2638         bytes32 termsContractParameters,
2639         address underwriter,
2640         uint underwriterRiskRating,
2641         uint salt
2642     )
2643         public
2644         whenNotPaused
2645     {
2646         require(msg.sender == debtor || msg.sender == underwriter);
2647 
2648         Issuance memory issuance = getIssuance(
2649             version,
2650             debtor,
2651             underwriter,
2652             termsContract,
2653             underwriterRiskRating,
2654             salt,
2655             termsContractParameters
2656         );
2657 
2658         issuanceCancelled[issuance.agreementId] = true;
2659 
2660         LogIssuanceCancelled(issuance.agreementId, msg.sender);
2661     }
2662 
2663     /**
2664      * Allows a debtor to cancel a debt order before it's been filled
2665      * -- preventing any counterparty from filling it in the future.
2666      */
2667     function cancelDebtOrder(
2668         address[6] orderAddresses,
2669         uint[8] orderValues,
2670         bytes32[1] orderBytes32
2671     )
2672         public
2673         whenNotPaused
2674     {
2675         DebtOrder memory debtOrder = getDebtOrder(orderAddresses, orderValues, orderBytes32);
2676 
2677         require(msg.sender == debtOrder.issuance.debtor);
2678 
2679         debtOrderCancelled[debtOrder.debtOrderHash] = true;
2680 
2681         LogDebtOrderCancelled(debtOrder.debtOrderHash, msg.sender);
2682     }
2683 
2684     ////////////////////////
2685     // INTERNAL FUNCTIONS //
2686     ////////////////////////
2687 
2688     /**
2689      * Helper function that mints debt token associated with the
2690      * given issuance and grants it to the beneficiary.
2691      */
2692     function issueDebtAgreement(address beneficiary, Issuance issuance)
2693         internal
2694         returns (bytes32 _agreementId)
2695     {
2696         // Mint debt token and finalize debt agreement
2697         uint tokenId = debtToken.create(
2698             issuance.version,
2699             beneficiary,
2700             issuance.debtor,
2701             issuance.underwriter,
2702             issuance.underwriterRiskRating,
2703             issuance.termsContract,
2704             issuance.termsContractParameters,
2705             issuance.salt
2706         );
2707 
2708         assert(tokenId == uint(issuance.agreementId));
2709 
2710         return issuance.agreementId;
2711     }
2712 
2713     /**
2714      * Asserts that a debt order meets all consensuality requirements
2715      * described in the DebtKernel specification document.
2716      */
2717     function assertDebtOrderConsensualityInvariants(
2718         DebtOrder debtOrder,
2719         address creditor,
2720         uint8[3] signaturesV,
2721         bytes32[3] signaturesR,
2722         bytes32[3] signaturesS
2723     )
2724         internal
2725         returns (bool _orderIsConsensual)
2726     {
2727         // Invariant: debtor's signature must be valid, unless debtor is submitting order
2728         if (msg.sender != debtOrder.issuance.debtor) {
2729             if (!isValidSignature(
2730                 debtOrder.issuance.debtor,
2731                 debtOrder.debtOrderHash,
2732                 signaturesV[0],
2733                 signaturesR[0],
2734                 signaturesS[0]
2735             )) {
2736                 LogError(uint8(Errors.ORDER_INVALID_NON_CONSENSUAL), debtOrder.debtOrderHash);
2737                 return false;
2738             }
2739         }
2740 
2741         // Invariant: creditor's signature must be valid, unless creditor is submitting order
2742         if (msg.sender != creditor) {
2743             if (!isValidSignature(
2744                 creditor,
2745                 debtOrder.debtOrderHash,
2746                 signaturesV[1],
2747                 signaturesR[1],
2748                 signaturesS[1]
2749             )) {
2750                 LogError(uint8(Errors.ORDER_INVALID_NON_CONSENSUAL), debtOrder.debtOrderHash);
2751                 return false;
2752             }
2753         }
2754 
2755 
2756         // Invariant: underwriter's signature must be valid (if present)
2757         if (debtOrder.issuance.underwriter != address(0) &&
2758             msg.sender != debtOrder.issuance.underwriter) {
2759             if (!isValidSignature(
2760                 debtOrder.issuance.underwriter,
2761                 getUnderwriterMessageHash(debtOrder),
2762                 signaturesV[2],
2763                 signaturesR[2],
2764                 signaturesS[2]
2765             )) {
2766                 LogError(uint8(Errors.ORDER_INVALID_NON_CONSENSUAL), debtOrder.debtOrderHash);
2767                 return false;
2768             }
2769         }
2770 
2771         return true;
2772     }
2773 
2774     /**
2775      * Asserts that debt order meets all validity requirements described in
2776      * the DebtKernel specification document.
2777      */
2778     function assertDebtOrderValidityInvariants(DebtOrder debtOrder)
2779         internal
2780         returns (bool _orderIsValid)
2781     {
2782         uint totalFees = debtOrder.creditorFee.add(debtOrder.debtorFee);
2783 
2784         // Invariant: the total value of fees contributed by debtors and creditors
2785         //  must be equivalent to that paid out to underwriters and relayers.
2786         if (totalFees != debtOrder.relayerFee.add(debtOrder.underwriterFee)) {
2787             LogError(uint8(Errors.ORDER_INVALID_INSUFFICIENT_OR_EXCESSIVE_FEES), debtOrder.debtOrderHash);
2788             return false;
2789         }
2790 
2791         // Invariant: debtor is given enough principal to cover at least debtorFees
2792         if (debtOrder.principalAmount < debtOrder.debtorFee) {
2793             LogError(uint8(Errors.ORDER_INVALID_INSUFFICIENT_PRINCIPAL), debtOrder.debtOrderHash);
2794             return false;
2795         }
2796 
2797         // Invariant: if no underwriter is specified, underwriter fees must be 0
2798         // Invariant: if no relayer is specified, relayer fees must be 0.
2799         //      Given that relayer fees = total fees - underwriter fees,
2800         //      we assert that total fees = underwriter fees.
2801         if ((debtOrder.issuance.underwriter == address(0) && debtOrder.underwriterFee > 0) ||
2802             (debtOrder.relayer == address(0) && totalFees != debtOrder.underwriterFee)) {
2803             LogError(uint8(Errors.ORDER_INVALID_UNSPECIFIED_FEE_RECIPIENT), debtOrder.debtOrderHash);
2804             return false;
2805         }
2806 
2807         // Invariant: debt order must not be expired
2808         // solhint-disable-next-line not-rely-on-time
2809         if (debtOrder.expirationTimestampInSec < block.timestamp) {
2810             LogError(uint8(Errors.ORDER_EXPIRED), debtOrder.debtOrderHash);
2811             return false;
2812         }
2813 
2814         // Invariant: debt order's issuance must not already be minted as debt token
2815         if (debtToken.exists(uint(debtOrder.issuance.agreementId))) {
2816             LogError(uint8(Errors.DEBT_ISSUED), debtOrder.debtOrderHash);
2817             return false;
2818         }
2819 
2820         // Invariant: debt order's issuance must not have been cancelled
2821         if (issuanceCancelled[debtOrder.issuance.agreementId]) {
2822             LogError(uint8(Errors.ISSUANCE_CANCELLED), debtOrder.debtOrderHash);
2823             return false;
2824         }
2825 
2826         // Invariant: debt order itself must not have been cancelled
2827         if (debtOrderCancelled[debtOrder.debtOrderHash]) {
2828             LogError(uint8(Errors.ORDER_CANCELLED), debtOrder.debtOrderHash);
2829             return false;
2830         }
2831 
2832         return true;
2833     }
2834 
2835     /**
2836      * Assert that the creditor has a sufficient token balance and has
2837      * granted the token transfer proxy contract sufficient allowance to suffice for the principal
2838      * and creditor fee.
2839      */
2840     function assertExternalBalanceAndAllowanceInvariants(
2841         address creditor,
2842         DebtOrder debtOrder
2843     )
2844         internal
2845         returns (bool _isBalanceAndAllowanceSufficient)
2846     {
2847         uint totalCreditorPayment = debtOrder.principalAmount.add(debtOrder.creditorFee);
2848 
2849         if (getBalance(debtOrder.principalToken, creditor) < totalCreditorPayment ||
2850             getAllowance(debtOrder.principalToken, creditor) < totalCreditorPayment) {
2851             LogError(uint8(Errors.CREDITOR_BALANCE_OR_ALLOWANCE_INSUFFICIENT), debtOrder.debtOrderHash);
2852             return false;
2853         }
2854 
2855         return true;
2856     }
2857 
2858     /**
2859      * Helper function transfers a specified amount of tokens between two parties
2860      * using the token transfer proxy contract.
2861      */
2862     function transferTokensFrom(
2863         address token,
2864         address from,
2865         address to,
2866         uint amount
2867     )
2868         internal
2869         returns (bool success)
2870     {
2871         return TokenTransferProxy(TOKEN_TRANSFER_PROXY).transferFrom(
2872             token,
2873             from,
2874             to,
2875             amount
2876         );
2877     }
2878 
2879     /**
2880      * Helper function that constructs a hashed issuance structs from the given
2881      * parameters.
2882      */
2883     function getIssuance(
2884         address version,
2885         address debtor,
2886         address underwriter,
2887         address termsContract,
2888         uint underwriterRiskRating,
2889         uint salt,
2890         bytes32 termsContractParameters
2891     )
2892         internal
2893         pure
2894         returns (Issuance _issuance)
2895     {
2896         Issuance memory issuance = Issuance({
2897             version: version,
2898             debtor: debtor,
2899             underwriter: underwriter,
2900             termsContract: termsContract,
2901             underwriterRiskRating: underwriterRiskRating,
2902             salt: salt,
2903             termsContractParameters: termsContractParameters,
2904             agreementId: getAgreementId(
2905                 version,
2906                 debtor,
2907                 underwriter,
2908                 termsContract,
2909                 underwriterRiskRating,
2910                 salt,
2911                 termsContractParameters
2912             )
2913         });
2914 
2915         return issuance;
2916     }
2917 
2918     /**
2919      * Helper function that constructs a hashed debt order struct given the raw parameters
2920      * of a debt order.
2921      */
2922     function getDebtOrder(address[6] orderAddresses, uint[8] orderValues, bytes32[1] orderBytes32)
2923         internal
2924         view
2925         returns (DebtOrder _debtOrder)
2926     {
2927         DebtOrder memory debtOrder = DebtOrder({
2928             issuance: getIssuance(
2929                 orderAddresses[0],
2930                 orderAddresses[1],
2931                 orderAddresses[2],
2932                 orderAddresses[3],
2933                 orderValues[0],
2934                 orderValues[1],
2935                 orderBytes32[0]
2936             ),
2937             principalToken: orderAddresses[4],
2938             relayer: orderAddresses[5],
2939             principalAmount: orderValues[2],
2940             underwriterFee: orderValues[3],
2941             relayerFee: orderValues[4],
2942             creditorFee: orderValues[5],
2943             debtorFee: orderValues[6],
2944             expirationTimestampInSec: orderValues[7],
2945             debtOrderHash: bytes32(0)
2946         });
2947 
2948         debtOrder.debtOrderHash = getDebtOrderHash(debtOrder);
2949 
2950         return debtOrder;
2951     }
2952 
2953     /**
2954      * Helper function that returns an issuance's hash
2955      */
2956     function getAgreementId(
2957         address version,
2958         address debtor,
2959         address underwriter,
2960         address termsContract,
2961         uint underwriterRiskRating,
2962         uint salt,
2963         bytes32 termsContractParameters
2964     )
2965         internal
2966         pure
2967         returns (bytes32 _agreementId)
2968     {
2969         return keccak256(
2970             version,
2971             debtor,
2972             underwriter,
2973             underwriterRiskRating,
2974             termsContract,
2975             termsContractParameters,
2976             salt
2977         );
2978     }
2979 
2980     /**
2981      * Returns the hash of the parameters which an underwriter is supposed to sign
2982      */
2983     function getUnderwriterMessageHash(DebtOrder debtOrder)
2984         internal
2985         view
2986         returns (bytes32 _underwriterMessageHash)
2987     {
2988         return keccak256(
2989             address(this),
2990             debtOrder.issuance.agreementId,
2991             debtOrder.underwriterFee,
2992             debtOrder.principalAmount,
2993             debtOrder.principalToken,
2994             debtOrder.expirationTimestampInSec
2995         );
2996     }
2997 
2998     /**
2999      * Returns the hash of the debt order.
3000      */
3001     function getDebtOrderHash(DebtOrder debtOrder)
3002         internal
3003         view
3004         returns (bytes32 _debtorMessageHash)
3005     {
3006         return keccak256(
3007             address(this),
3008             debtOrder.issuance.agreementId,
3009             debtOrder.underwriterFee,
3010             debtOrder.principalAmount,
3011             debtOrder.principalToken,
3012             debtOrder.debtorFee,
3013             debtOrder.creditorFee,
3014             debtOrder.relayer,
3015             debtOrder.relayerFee,
3016             debtOrder.expirationTimestampInSec
3017         );
3018     }
3019 
3020     /**
3021      * Given a hashed message, a signer's address, and a signature, returns
3022      * whether the signature is valid.
3023      */
3024     function isValidSignature(
3025         address signer,
3026         bytes32 hash,
3027         uint8 v,
3028         bytes32 r,
3029         bytes32 s
3030     )
3031         internal
3032         pure
3033         returns (bool _valid)
3034     {
3035         return signer == ecrecover(
3036             keccak256("\x19Ethereum Signed Message:\n32", hash),
3037             v,
3038             r,
3039             s
3040         );
3041     }
3042 
3043     /**
3044      * Helper function for querying an address' balance on a given token.
3045      */
3046     function getBalance(
3047         address token,
3048         address owner
3049     )
3050         internal
3051         view
3052         returns (uint _balance)
3053     {
3054         // Limit gas to prevent reentrancy.
3055         return ERC20(token).balanceOf.gas(EXTERNAL_QUERY_GAS_LIMIT)(owner);
3056     }
3057 
3058     /**
3059      * Helper function for querying an address' allowance to the 0x transfer proxy.
3060      */
3061     function getAllowance(
3062         address token,
3063         address owner
3064     )
3065         internal
3066         view
3067         returns (uint _allowance)
3068     {
3069         // Limit gas to prevent reentrancy.
3070         return ERC20(token).allowance.gas(EXTERNAL_QUERY_GAS_LIMIT)(owner, TOKEN_TRANSFER_PROXY);
3071     }
3072 }
3073 
3074 // File: contracts/RepaymentRouter.sol
3075 
3076 /*
3077 
3078   Copyright 2017 Dharma Labs Inc.
3079 
3080   Licensed under the Apache License, Version 2.0 (the "License");
3081   you may not use this file except in compliance with the License.
3082   You may obtain a copy of the License at
3083 
3084     http://www.apache.org/licenses/LICENSE-2.0
3085 
3086   Unless required by applicable law or agreed to in writing, software
3087   distributed under the License is distributed on an "AS IS" BASIS,
3088   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3089   See the License for the specific language governing permissions and
3090   limitations under the License.
3091 
3092 */
3093 
3094 pragma solidity 0.4.18;
3095 
3096 
3097 
3098 
3099 
3100 
3101 
3102 /**
3103  * The RepaymentRouter routes allowers payers to make repayments on any
3104  * given debt agreement in any given token by routing the payments to
3105  * the debt agreement's beneficiary.  Additionally, the router acts
3106  * as a trusted oracle to the debt agreement's terms contract, informing
3107  * it of exactly what payments have been made in what quantity and in what token.
3108  *
3109  * Authors: Jaynti Kanani -- Github: jdkanani, Nadav Hollander -- Github: nadavhollander
3110  */
3111 contract RepaymentRouter is Pausable {
3112     DebtRegistry public debtRegistry;
3113     TokenTransferProxy public tokenTransferProxy;
3114 
3115     enum Errors {
3116         DEBT_AGREEMENT_NONEXISTENT,
3117         PAYER_BALANCE_OR_ALLOWANCE_INSUFFICIENT,
3118         REPAYMENT_REJECTED_BY_TERMS_CONTRACT
3119     }
3120 
3121     event LogRepayment(
3122         bytes32 indexed _agreementId,
3123         address indexed _payer,
3124         address indexed _beneficiary,
3125         uint _amount,
3126         address _token
3127     );
3128 
3129     event LogError(uint8 indexed _errorId, bytes32 indexed _agreementId);
3130 
3131     /**
3132      * Constructor points the repayment router at the deployed registry contract.
3133      */
3134     function RepaymentRouter (address _debtRegistry, address _tokenTransferProxy) public {
3135         debtRegistry = DebtRegistry(_debtRegistry);
3136         tokenTransferProxy = TokenTransferProxy(_tokenTransferProxy);
3137     }
3138 
3139     /**
3140      * Given an agreement id, routes a repayment
3141      * of a given ERC20 token to the debt's current beneficiary, and reports the repayment
3142      * to the debt's associated terms contract.
3143      */
3144     function repay(
3145         bytes32 agreementId,
3146         uint256 amount,
3147         address tokenAddress
3148     )
3149         public
3150         whenNotPaused
3151         returns (uint _amountRepaid)
3152     {
3153         require(tokenAddress != address(0));
3154         require(amount > 0);
3155 
3156         // Ensure agreement exists.
3157         if (!debtRegistry.doesEntryExist(agreementId)) {
3158             LogError(uint8(Errors.DEBT_AGREEMENT_NONEXISTENT), agreementId);
3159             return 0;
3160         }
3161 
3162         // Check payer has sufficient balance and has granted router sufficient allowance.
3163         if (ERC20(tokenAddress).balanceOf(msg.sender) < amount ||
3164             ERC20(tokenAddress).allowance(msg.sender, tokenTransferProxy) < amount) {
3165             LogError(uint8(Errors.PAYER_BALANCE_OR_ALLOWANCE_INSUFFICIENT), agreementId);
3166             return 0;
3167         }
3168 
3169         // Notify terms contract
3170         address termsContract = debtRegistry.getTermsContract(agreementId);
3171         address beneficiary = debtRegistry.getBeneficiary(agreementId);
3172         if (!TermsContract(termsContract).registerRepayment(
3173             agreementId,
3174             msg.sender, 
3175             beneficiary,
3176             amount,
3177             tokenAddress
3178         )) {
3179             LogError(uint8(Errors.REPAYMENT_REJECTED_BY_TERMS_CONTRACT), agreementId);
3180             return 0;
3181         }
3182 
3183         // Transfer amount to creditor
3184         require(tokenTransferProxy.transferFrom(
3185             tokenAddress,
3186             msg.sender,
3187             beneficiary,
3188             amount
3189         ));
3190 
3191         // Log event for repayment
3192         LogRepayment(agreementId, msg.sender, beneficiary, amount, tokenAddress);
3193 
3194         return amount;
3195     }
3196 }
3197 
3198 // File: contracts/ContractRegistry.sol
3199 
3200 contract ContractRegistry is Ownable {
3201 
3202     event ContractAddressUpdated(
3203         ContractType indexed contractType,
3204         address indexed oldAddress,
3205         address indexed newAddress
3206     );
3207 
3208     enum ContractType {
3209         Collateralizer,
3210         DebtKernel,
3211         DebtRegistry,
3212         DebtToken,
3213         RepaymentRouter,
3214         TokenRegistry,
3215         TokenTransferProxy
3216     }
3217 
3218     Collateralizer public collateralizer;
3219     DebtKernel public debtKernel;
3220     DebtRegistry public  debtRegistry;
3221     DebtToken public debtToken;
3222     RepaymentRouter public repaymentRouter;
3223     TokenRegistry public tokenRegistry;
3224     TokenTransferProxy public tokenTransferProxy;
3225 
3226     function ContractRegistry(
3227         address _collateralizer,
3228         address _debtKernel,
3229         address _debtRegistry,
3230         address _debtToken,
3231         address _repaymentRouter,
3232         address _tokenRegistry,
3233         address _tokenTransferProxy
3234     )
3235         public
3236     {
3237         collateralizer = Collateralizer(_collateralizer);
3238         debtKernel = DebtKernel(_debtKernel);
3239         debtRegistry = DebtRegistry(_debtRegistry);
3240         debtToken = DebtToken(_debtToken);
3241         repaymentRouter = RepaymentRouter(_repaymentRouter);
3242         tokenRegistry = TokenRegistry(_tokenRegistry);
3243         tokenTransferProxy = TokenTransferProxy(_tokenTransferProxy);
3244     }
3245 
3246     function updateAddress(
3247         ContractType contractType,
3248         address newAddress
3249     )
3250         public
3251         onlyOwner
3252     {
3253         address oldAddress;
3254 
3255         if (contractType == ContractType.Collateralizer) {
3256             oldAddress = address(collateralizer);
3257             validateNewAddress(newAddress, oldAddress);
3258             collateralizer = Collateralizer(newAddress);
3259         } else if (contractType == ContractType.DebtKernel) {
3260             oldAddress = address(debtKernel);
3261             validateNewAddress(newAddress, oldAddress);
3262             debtKernel = DebtKernel(newAddress);
3263         } else if (contractType == ContractType.DebtRegistry) {
3264             oldAddress = address(debtRegistry);
3265             validateNewAddress(newAddress, oldAddress);
3266             debtRegistry = DebtRegistry(newAddress);
3267         } else if (contractType == ContractType.DebtToken) {
3268             oldAddress = address(debtToken);
3269             validateNewAddress(newAddress, oldAddress);
3270             debtToken = DebtToken(newAddress);
3271         } else if (contractType == ContractType.RepaymentRouter) {
3272             oldAddress = address(repaymentRouter);
3273             validateNewAddress(newAddress, oldAddress);
3274             repaymentRouter = RepaymentRouter(newAddress);
3275         } else if (contractType == ContractType.TokenRegistry) {
3276             oldAddress = address(tokenRegistry);
3277             validateNewAddress(newAddress, oldAddress);
3278             tokenRegistry = TokenRegistry(newAddress);
3279         } else if (contractType == ContractType.TokenTransferProxy) {
3280             oldAddress = address(tokenTransferProxy);
3281             validateNewAddress(newAddress, oldAddress);
3282             tokenTransferProxy = TokenTransferProxy(newAddress);
3283         } else {
3284             revert();
3285         }
3286 
3287         ContractAddressUpdated(contractType, oldAddress, newAddress);
3288     }
3289 
3290     function validateNewAddress(
3291         address newAddress,
3292         address oldAddress
3293     )
3294         internal
3295         pure
3296     {
3297         require(newAddress != address(0)); // new address cannot be null address.
3298         require(newAddress != oldAddress); // new address cannot be existing address.
3299     }
3300 }