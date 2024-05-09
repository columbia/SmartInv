1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title ERC721 Non-Fungible Token Standard basic interface
53  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
54  */
55 contract ERC721Basic {
56   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
57   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
58   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);  
59 
60   function balanceOf(address _owner) public view returns (uint256 _balance);
61   function ownerOf(uint256 _tokenId) public view returns (address _owner);
62   function exists(uint256 _tokenId) public view returns (bool _exists);
63   
64   function approve(address _to, uint256 _tokenId) public;
65   function getApproved(uint256 _tokenId) public view returns (address _operator);
66   
67   function setApprovalForAll(address _operator, bool _approved) public;
68   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
69 
70   function transferFrom(address _from, address _to, uint256 _tokenId) public;
71   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;  
72   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
73 }
74 
75 
76 
77 /**
78  * @title ERC20Basic
79  * @dev Simpler version of ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/179
81  */
82 contract ERC20Basic {
83   function totalSupply() public view returns (uint256);
84   function balanceOf(address who) public view returns (uint256);
85   function transfer(address to, uint256 value) public returns (bool);
86   event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 
90 
91 /**
92  * @title Ownable
93  * @dev The Ownable contract has an owner address, and provides basic authorization control
94  * functions, this simplifies the implementation of "user permissions".
95  */
96 contract Ownable {
97   address public owner;
98 
99 
100   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
101 
102 
103   /**
104    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
105    * account.
106    */
107   function Ownable() public {
108     owner = msg.sender;
109   }
110 
111   /**
112    * @dev Throws if called by any account other than the owner.
113    */
114   modifier onlyOwner() {
115     require(msg.sender == owner);
116     _;
117   }
118 
119   /**
120    * @dev Allows the current owner to transfer control of the contract to a newOwner.
121    * @param newOwner The address to transfer ownership to.
122    */
123   function transferOwnership(address newOwner) public onlyOwner {
124     require(newOwner != address(0));
125     OwnershipTransferred(owner, newOwner);
126     owner = newOwner;
127   }
128 
129 }
130 /*
131 
132   Copyright 2017 Dharma Labs Inc.
133 
134   Licensed under the Apache License, Version 2.0 (the "License");
135   you may not use this file except in compliance with the License.
136   You may obtain a copy of the License at
137 
138     http://www.apache.org/licenses/LICENSE-2.0
139 
140   Unless required by applicable law or agreed to in writing, software
141   distributed under the License is distributed on an "AS IS" BASIS,
142   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
143   See the License for the specific language governing permissions and
144   limitations under the License.
145 
146 */
147 
148 
149 
150 
151 /**
152  *  Note(kayvon): these events are emitted by our PermissionsLib, but all contracts that
153  *  depend on the library must also define the events in order for web3 clients to pick them up.
154  *  This topic is discussed in greater detail here (under the section "Events and Libraries"):
155  *  https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736
156  */
157 contract PermissionEvents {
158     event Authorized(address indexed agent, string callingContext);
159     event AuthorizationRevoked(address indexed agent, string callingContext);
160 }
161 
162 
163 library PermissionsLib {
164 
165     // TODO(kayvon): remove these events and inherit from PermissionEvents when libraries are
166     // capable of inheritance.
167     // See relevant github issue here: https://github.com/ethereum/solidity/issues/891
168     event Authorized(address indexed agent, string callingContext);
169     event AuthorizationRevoked(address indexed agent, string callingContext);
170 
171     struct Permissions {
172         mapping (address => bool) authorized;
173         mapping (address => uint) agentToIndex; // ensures O(1) look-up
174         address[] authorizedAgents;
175     }
176 
177     function authorize(
178         Permissions storage self,
179         address agent,
180         string callingContext
181     )
182         internal
183     {
184         require(isNotAuthorized(self, agent));
185 
186         self.authorized[agent] = true;
187         self.authorizedAgents.push(agent);
188         self.agentToIndex[agent] = self.authorizedAgents.length - 1;
189         Authorized(agent, callingContext);
190     }
191 
192     function revokeAuthorization(
193         Permissions storage self,
194         address agent,
195         string callingContext
196     )
197         internal
198     {
199         /* We only want to do work in the case where the agent whose
200         authorization is being revoked had authorization permissions in the
201         first place. */
202         require(isAuthorized(self, agent));
203 
204         uint indexOfAgentToRevoke = self.agentToIndex[agent];
205         uint indexOfAgentToMove = self.authorizedAgents.length - 1;
206         address agentToMove = self.authorizedAgents[indexOfAgentToMove];
207 
208         // Revoke the agent's authorization.
209         delete self.authorized[agent];
210 
211         // Remove the agent from our collection of authorized agents.
212         self.authorizedAgents[indexOfAgentToRevoke] = agentToMove;
213 
214         // Update our indices to reflect the above changes.
215         self.agentToIndex[agentToMove] = indexOfAgentToRevoke;
216         delete self.agentToIndex[agent];
217 
218         // Clean up memory that's no longer being used.
219         delete self.authorizedAgents[indexOfAgentToMove];
220         self.authorizedAgents.length -= 1;
221 
222         AuthorizationRevoked(agent, callingContext);
223     }
224 
225     function isAuthorized(Permissions storage self, address agent)
226         internal
227         view
228         returns (bool)
229     {
230         return self.authorized[agent];
231     }
232 
233     function isNotAuthorized(Permissions storage self, address agent)
234         internal
235         view
236         returns (bool)
237     {
238         return !isAuthorized(self, agent);
239     }
240 
241     function getAuthorizedAgents(Permissions storage self)
242         internal
243         view
244         returns (address[])
245     {
246         return self.authorizedAgents;
247     }
248 }
249 /*
250 
251   Copyright 2017 Dharma Labs Inc.
252 
253   Licensed under the Apache License, Version 2.0 (the "License");
254   you may not use this file except in compliance with the License.
255   You may obtain a copy of the License at
256 
257     http://www.apache.org/licenses/LICENSE-2.0
258 
259   Unless required by applicable law or agreed to in writing, software
260   distributed under the License is distributed on an "AS IS" BASIS,
261   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
262   See the License for the specific language governing permissions and
263   limitations under the License.
264 
265 */
266 
267 
268 
269 // Internal dependencies.
270 /*
271 
272   Copyright 2017 Dharma Labs Inc.
273 
274   Licensed under the Apache License, Version 2.0 (the "License");
275   you may not use this file except in compliance with the License.
276   You may obtain a copy of the License at
277 
278     http://www.apache.org/licenses/LICENSE-2.0
279 
280   Unless required by applicable law or agreed to in writing, software
281   distributed under the License is distributed on an "AS IS" BASIS,
282   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
283   See the License for the specific language governing permissions and
284   limitations under the License.
285 
286 */
287 
288 
289 
290 
291 
292 
293 
294 
295 
296 
297 
298 /**
299  * @title Pausable
300  * @dev Base contract which allows children to implement an emergency stop mechanism.
301  */
302 contract Pausable is Ownable {
303   event Pause();
304   event Unpause();
305 
306   bool public paused = false;
307 
308 
309   /**
310    * @dev Modifier to make a function callable only when the contract is not paused.
311    */
312   modifier whenNotPaused() {
313     require(!paused);
314     _;
315   }
316 
317   /**
318    * @dev Modifier to make a function callable only when the contract is paused.
319    */
320   modifier whenPaused() {
321     require(paused);
322     _;
323   }
324 
325   /**
326    * @dev called by the owner to pause, triggers stopped state
327    */
328   function pause() onlyOwner whenNotPaused public {
329     paused = true;
330     Pause();
331   }
332 
333   /**
334    * @dev called by the owner to unpause, returns to normal state
335    */
336   function unpause() onlyOwner whenPaused public {
337     paused = false;
338     Unpause();
339   }
340 }
341 
342 
343 
344 /**
345  * The DebtRegistry stores the parameters and beneficiaries of all debt agreements in
346  * Dharma protocol.  It authorizes a limited number of agents to
347  * perform mutations on it -- those agents can be changed at any
348  * time by the contract's owner.
349  *
350  * Author: Nadav Hollander -- Github: nadavhollander
351  */
352 contract DebtRegistry is Pausable, PermissionEvents {
353     using SafeMath for uint;
354     using PermissionsLib for PermissionsLib.Permissions;
355 
356     struct Entry {
357         address version;
358         address beneficiary;
359         address underwriter;
360         uint underwriterRiskRating;
361         address termsContract;
362         bytes32 termsContractParameters;
363         uint issuanceBlockTimestamp;
364     }
365 
366     // Primary registry mapping agreement IDs to their corresponding entries
367     mapping (bytes32 => Entry) internal registry;
368 
369     // Maps debtor addresses to a list of their debts' agreement IDs
370     mapping (address => bytes32[]) internal debtorToDebts;
371 
372     PermissionsLib.Permissions internal entryInsertPermissions;
373     PermissionsLib.Permissions internal entryEditPermissions;
374 
375     string public constant INSERT_CONTEXT = "debt-registry-insert";
376     string public constant EDIT_CONTEXT = "debt-registry-edit";
377 
378     event LogInsertEntry(
379         bytes32 indexed agreementId,
380         address indexed beneficiary,
381         address indexed underwriter,
382         uint underwriterRiskRating,
383         address termsContract,
384         bytes32 termsContractParameters
385     );
386 
387     event LogModifyEntryBeneficiary(
388         bytes32 indexed agreementId,
389         address indexed previousBeneficiary,
390         address indexed newBeneficiary
391     );
392 
393     modifier onlyAuthorizedToInsert() {
394         require(entryInsertPermissions.isAuthorized(msg.sender));
395         _;
396     }
397 
398     modifier onlyAuthorizedToEdit() {
399         require(entryEditPermissions.isAuthorized(msg.sender));
400         _;
401     }
402 
403     modifier onlyExtantEntry(bytes32 agreementId) {
404         require(doesEntryExist(agreementId));
405         _;
406     }
407 
408     modifier nonNullBeneficiary(address beneficiary) {
409         require(beneficiary != address(0));
410         _;
411     }
412 
413     /* Ensures an entry with the specified agreement ID exists within the debt registry. */
414     function doesEntryExist(bytes32 agreementId)
415         public
416         view
417         returns (bool exists)
418     {
419         return registry[agreementId].beneficiary != address(0);
420     }
421 
422     /**
423      * Inserts a new entry into the registry, if the entry is valid and sender is
424      * authorized to make 'insert' mutations to the registry.
425      */
426     function insert(
427         address _version,
428         address _beneficiary,
429         address _debtor,
430         address _underwriter,
431         uint _underwriterRiskRating,
432         address _termsContract,
433         bytes32 _termsContractParameters,
434         uint _salt
435     )
436         public
437         onlyAuthorizedToInsert
438         whenNotPaused
439         nonNullBeneficiary(_beneficiary)
440         returns (bytes32 _agreementId)
441     {
442         Entry memory entry = Entry(
443             _version,
444             _beneficiary,
445             _underwriter,
446             _underwriterRiskRating,
447             _termsContract,
448             _termsContractParameters,
449             block.timestamp
450         );
451 
452         bytes32 agreementId = _getAgreementId(entry, _debtor, _salt);
453 
454         require(registry[agreementId].beneficiary == address(0));
455 
456         registry[agreementId] = entry;
457         debtorToDebts[_debtor].push(agreementId);
458 
459         LogInsertEntry(
460             agreementId,
461             entry.beneficiary,
462             entry.underwriter,
463             entry.underwriterRiskRating,
464             entry.termsContract,
465             entry.termsContractParameters
466         );
467 
468         return agreementId;
469     }
470 
471     /**
472      * Modifies the beneficiary of a debt issuance, if the sender
473      * is authorized to make 'modifyBeneficiary' mutations to
474      * the registry.
475      */
476     function modifyBeneficiary(bytes32 agreementId, address newBeneficiary)
477         public
478         onlyAuthorizedToEdit
479         whenNotPaused
480         onlyExtantEntry(agreementId)
481         nonNullBeneficiary(newBeneficiary)
482     {
483         address previousBeneficiary = registry[agreementId].beneficiary;
484 
485         registry[agreementId].beneficiary = newBeneficiary;
486 
487         LogModifyEntryBeneficiary(
488             agreementId,
489             previousBeneficiary,
490             newBeneficiary
491         );
492     }
493 
494     /**
495      * Adds an address to the list of agents authorized
496      * to make 'insert' mutations to the registry.
497      */
498     function addAuthorizedInsertAgent(address agent)
499         public
500         onlyOwner
501     {
502         entryInsertPermissions.authorize(agent, INSERT_CONTEXT);
503     }
504 
505     /**
506      * Adds an address to the list of agents authorized
507      * to make 'modifyBeneficiary' mutations to the registry.
508      */
509     function addAuthorizedEditAgent(address agent)
510         public
511         onlyOwner
512     {
513         entryEditPermissions.authorize(agent, EDIT_CONTEXT);
514     }
515 
516     /**
517      * Removes an address from the list of agents authorized
518      * to make 'insert' mutations to the registry.
519      */
520     function revokeInsertAgentAuthorization(address agent)
521         public
522         onlyOwner
523     {
524         entryInsertPermissions.revokeAuthorization(agent, INSERT_CONTEXT);
525     }
526 
527     /**
528      * Removes an address from the list of agents authorized
529      * to make 'modifyBeneficiary' mutations to the registry.
530      */
531     function revokeEditAgentAuthorization(address agent)
532         public
533         onlyOwner
534     {
535         entryEditPermissions.revokeAuthorization(agent, EDIT_CONTEXT);
536     }
537 
538     /**
539      * Returns the parameters of a debt issuance in the registry.
540      *
541      * TODO(kayvon): protect this function with our `onlyExtantEntry` modifier once the restriction
542      * on the size of the call stack has been addressed.
543      */
544     function get(bytes32 agreementId)
545         public
546         view
547         returns(address, address, address, uint, address, bytes32, uint)
548     {
549         return (
550             registry[agreementId].version,
551             registry[agreementId].beneficiary,
552             registry[agreementId].underwriter,
553             registry[agreementId].underwriterRiskRating,
554             registry[agreementId].termsContract,
555             registry[agreementId].termsContractParameters,
556             registry[agreementId].issuanceBlockTimestamp
557         );
558     }
559 
560     /**
561      * Returns the beneficiary of a given issuance
562      */
563     function getBeneficiary(bytes32 agreementId)
564         public
565         view
566         onlyExtantEntry(agreementId)
567         returns(address)
568     {
569         return registry[agreementId].beneficiary;
570     }
571 
572     /**
573      * Returns the terms contract address of a given issuance
574      */
575     function getTermsContract(bytes32 agreementId)
576         public
577         view
578         onlyExtantEntry(agreementId)
579         returns (address)
580     {
581         return registry[agreementId].termsContract;
582     }
583 
584     /**
585      * Returns the terms contract parameters of a given issuance
586      */
587     function getTermsContractParameters(bytes32 agreementId)
588         public
589         view
590         onlyExtantEntry(agreementId)
591         returns (bytes32)
592     {
593         return registry[agreementId].termsContractParameters;
594     }
595 
596     /**
597      * Returns a tuple of the terms contract and its associated parameters
598      * for a given issuance
599      */
600     function getTerms(bytes32 agreementId)
601         public
602         view
603         onlyExtantEntry(agreementId)
604         returns(address, bytes32)
605     {
606         return (
607             registry[agreementId].termsContract,
608             registry[agreementId].termsContractParameters
609         );
610     }
611 
612     /**
613      * Returns the timestamp of the block at which a debt agreement was issued.
614      */
615     function getIssuanceBlockTimestamp(bytes32 agreementId)
616         public
617         view
618         onlyExtantEntry(agreementId)
619         returns (uint timestamp)
620     {
621         return registry[agreementId].issuanceBlockTimestamp;
622     }
623 
624     /**
625      * Returns the list of agents authorized to make 'insert' mutations
626      */
627     function getAuthorizedInsertAgents()
628         public
629         view
630         returns(address[])
631     {
632         return entryInsertPermissions.getAuthorizedAgents();
633     }
634 
635     /**
636      * Returns the list of agents authorized to make 'modifyBeneficiary' mutations
637      */
638     function getAuthorizedEditAgents()
639         public
640         view
641         returns(address[])
642     {
643         return entryEditPermissions.getAuthorizedAgents();
644     }
645 
646     /**
647      * Returns the list of debt agreements a debtor is party to,
648      * with each debt agreement listed by agreement ID.
649      */
650     function getDebtorsDebts(address debtor)
651         public
652         view
653         returns(bytes32[])
654     {
655         return debtorToDebts[debtor];
656     }
657 
658     /**
659      * Helper function for computing the hash of a given issuance,
660      * and, in turn, its agreementId
661      */
662     function _getAgreementId(Entry _entry, address _debtor, uint _salt)
663         internal
664         pure
665         returns(bytes32)
666     {
667         return keccak256(
668             _entry.version,
669             _debtor,
670             _entry.underwriter,
671             _entry.underwriterRiskRating,
672             _entry.termsContract,
673             _entry.termsContractParameters,
674             _salt
675         );
676     }
677 }
678 
679 /*
680 
681   Copyright 2017 Dharma Labs Inc.
682 
683   Licensed under the Apache License, Version 2.0 (the "License");
684   you may not use this file except in compliance with the License.
685   You may obtain a copy of the License at
686 
687     http://www.apache.org/licenses/LICENSE-2.0
688 
689   Unless required by applicable law or agreed to in writing, software
690   distributed under the License is distributed on an "AS IS" BASIS,
691   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
692   See the License for the specific language governing permissions and
693   limitations under the License.
694 
695 */
696 
697 
698 
699 
700 /**
701  * ERC165 interface required by ERC721 non-fungible token.
702  *
703  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
704  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
705  */
706 interface ERC165 {
707     /// @notice Query if a contract implements an interface
708     /// @param interfaceID The interface identifier, as specified in ERC-165
709     /// @dev Interface identification is specified in ERC-165. This function
710     ///  uses less than 30,000 gas.
711     /// @return `true` if the contract implements `interfaceID` and
712     ///  `interfaceID` is not 0xffffffff, `false` otherwise
713     function supportsInterface(bytes4 interfaceID) external view returns (bool);
714 }
715 
716 
717 
718 // External dependencies.
719 
720 
721 
722 
723 
724 
725 
726 /**
727  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
728  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
729  */
730 contract ERC721Enumerable is ERC721Basic {
731   function totalSupply() public view returns (uint256);
732   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
733   function tokenByIndex(uint256 _index) public view returns (uint256);
734 }
735 
736 /**
737  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
738  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
739  */
740 contract ERC721Metadata is ERC721Basic {
741   function name() public view returns (string _name);
742   function symbol() public view returns (string _symbol);
743   function tokenURI(uint256 _tokenId) public view returns (string);
744 }
745 
746 /**
747  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
748  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
749  */
750 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
751 }
752 
753 
754 
755 
756 
757 /**
758  * @title ERC-721 methods shipped in OpenZeppelin v1.7.0, removed in the latest version of the standard
759  * @dev Only use this interface for compatibility with previously deployed contracts
760  * @dev Use ERC721 for interacting with new contracts which are standard-compliant
761  */
762 contract DeprecatedERC721 is ERC721 {
763   function takeOwnership(uint256 _tokenId) public;
764   function transfer(address _to, uint256 _tokenId) public;
765   function tokensOf(address _owner) public view returns (uint256[]);
766 }
767 
768 
769 
770 
771 
772 
773 
774 /**
775  * @title ERC721 token receiver interface
776  * @dev Interface for any contract that wants to support safeTransfers
777  *  from ERC721 asset contracts.
778  */
779 contract ERC721Receiver {
780   /**
781    * @dev Magic value to be returned upon successful reception of an NFT
782    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
783    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
784    */
785   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba; 
786 
787   /**
788    * @notice Handle the receipt of an NFT
789    * @dev The ERC721 smart contract calls this function on the recipient
790    *  after a `safetransfer`. This function MAY throw to revert and reject the
791    *  transfer. This function MUST use 50,000 gas or less. Return of other
792    *  than the magic value MUST result in the transaction being reverted.
793    *  Note: the contract address is always the message sender.
794    * @param _from The sending address 
795    * @param _tokenId The NFT identifier which is being transfered
796    * @param _data Additional data with no specified format
797    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
798    */
799   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
800 }
801 
802 
803 
804 
805 /**
806  * Utility library of inline functions on addresses
807  */
808 library AddressUtils {
809 
810   /**
811    * Returns whether there is code in the target address
812    * @dev This function will return false if invoked during the constructor of a contract,
813    *  as the code is not actually created until after the constructor finishes.
814    * @param addr address address to check
815    * @return whether there is code in the target address
816    */
817   function isContract(address addr) internal view returns (bool) {
818     uint256 size;
819     assembly { size := extcodesize(addr) }
820     return size > 0;
821   }
822 
823 }
824 
825 
826 /**
827  * @title ERC721 Non-Fungible Token Standard basic implementation
828  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
829  */
830 contract ERC721BasicToken is ERC721Basic {
831   using SafeMath for uint256;
832   using AddressUtils for address;
833   
834   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
835   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
836   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba; 
837 
838   // Mapping from token ID to owner
839   mapping (uint256 => address) internal tokenOwner;
840 
841   // Mapping from token ID to approved address
842   mapping (uint256 => address) internal tokenApprovals;
843 
844   // Mapping from owner to number of owned token
845   mapping (address => uint256) internal ownedTokensCount;
846 
847   // Mapping from owner to operator approvals
848   mapping (address => mapping (address => bool)) internal operatorApprovals;
849 
850   /**
851   * @dev Guarantees msg.sender is owner of the given token
852   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
853   */
854   modifier onlyOwnerOf(uint256 _tokenId) {
855     require(ownerOf(_tokenId) == msg.sender);
856     _;
857   }
858 
859   /**
860   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
861   * @param _tokenId uint256 ID of the token to validate
862   */
863   modifier canTransfer(uint256 _tokenId) {
864     require(isApprovedOrOwner(msg.sender, _tokenId));
865     _;
866   }
867 
868   /**
869   * @dev Gets the balance of the specified address
870   * @param _owner address to query the balance of
871   * @return uint256 representing the amount owned by the passed address
872   */
873   function balanceOf(address _owner) public view returns (uint256) {
874     require(_owner != address(0));
875     return ownedTokensCount[_owner];
876   }
877 
878   /**
879   * @dev Gets the owner of the specified token ID
880   * @param _tokenId uint256 ID of the token to query the owner of
881   * @return owner address currently marked as the owner of the given token ID
882   */
883   function ownerOf(uint256 _tokenId) public view returns (address) {
884     address owner = tokenOwner[_tokenId];
885     require(owner != address(0));
886     return owner;
887   }
888 
889   /**
890   * @dev Returns whether the specified token exists
891   * @param _tokenId uint256 ID of the token to query the existance of
892   * @return whether the token exists
893   */
894   function exists(uint256 _tokenId) public view returns (bool) {
895     address owner = tokenOwner[_tokenId];
896     return owner != address(0);
897   }
898 
899   /**
900   * @dev Approves another address to transfer the given token ID
901   * @dev The zero address indicates there is no approved address.
902   * @dev There can only be one approved address per token at a given time.
903   * @dev Can only be called by the token owner or an approved operator.
904   * @param _to address to be approved for the given token ID
905   * @param _tokenId uint256 ID of the token to be approved
906   */
907   function approve(address _to, uint256 _tokenId) public {
908     address owner = ownerOf(_tokenId);
909     require(_to != owner);
910     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
911 
912     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
913       tokenApprovals[_tokenId] = _to;
914       Approval(owner, _to, _tokenId);
915     }
916   }
917 
918   /**
919    * @dev Gets the approved address for a token ID, or zero if no address set
920    * @param _tokenId uint256 ID of the token to query the approval of
921    * @return address currently approved for a the given token ID
922    */
923   function getApproved(uint256 _tokenId) public view returns (address) {
924     return tokenApprovals[_tokenId];
925   }
926 
927 
928   /**
929   * @dev Sets or unsets the approval of a given operator
930   * @dev An operator is allowed to transfer all tokens of the sender on their behalf
931   * @param _to operator address to set the approval
932   * @param _approved representing the status of the approval to be set
933   */
934   function setApprovalForAll(address _to, bool _approved) public {
935     require(_to != msg.sender);
936     operatorApprovals[msg.sender][_to] = _approved;
937     ApprovalForAll(msg.sender, _to, _approved);
938   }
939 
940   /**
941    * @dev Tells whether an operator is approved by a given owner
942    * @param _owner owner address which you want to query the approval of
943    * @param _operator operator address which you want to query the approval of
944    * @return bool whether the given operator is approved by the given owner
945    */
946   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
947     return operatorApprovals[_owner][_operator];
948   }
949 
950   /**
951   * @dev Transfers the ownership of a given token ID to another address
952   * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
953   * @dev Requires the msg sender to be the owner, approved, or operator
954   * @param _from current owner of the token
955   * @param _to address to receive the ownership of the given token ID
956   * @param _tokenId uint256 ID of the token to be transferred
957   */
958   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
959     require(_from != address(0));
960     require(_to != address(0));
961 
962     clearApproval(_from, _tokenId);
963     removeTokenFrom(_from, _tokenId);
964     addTokenTo(_to, _tokenId);
965     
966     Transfer(_from, _to, _tokenId);
967   }
968 
969   /**
970   * @dev Safely transfers the ownership of a given token ID to another address
971   * @dev If the target address is a contract, it must implement `onERC721Received`,
972   *  which is called upon a safe transfer, and return the magic value
973   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
974   *  the transfer is reverted.
975   * @dev Requires the msg sender to be the owner, approved, or operator
976   * @param _from current owner of the token
977   * @param _to address to receive the ownership of the given token ID
978   * @param _tokenId uint256 ID of the token to be transferred
979   */
980   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
981     safeTransferFrom(_from, _to, _tokenId, "");
982   }
983 
984   /**
985   * @dev Safely transfers the ownership of a given token ID to another address
986   * @dev If the target address is a contract, it must implement `onERC721Received`,
987   *  which is called upon a safe transfer, and return the magic value
988   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
989   *  the transfer is reverted.
990   * @dev Requires the msg sender to be the owner, approved, or operator
991   * @param _from current owner of the token
992   * @param _to address to receive the ownership of the given token ID
993   * @param _tokenId uint256 ID of the token to be transferred
994   * @param _data bytes data to send along with a safe transfer check
995   */
996   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public canTransfer(_tokenId) {
997     transferFrom(_from, _to, _tokenId);
998     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
999   }
1000 
1001   /**
1002    * @dev Returns whether the given spender can transfer a given token ID
1003    * @param _spender address of the spender to query
1004    * @param _tokenId uint256 ID of the token to be transferred
1005    * @return bool whether the msg.sender is approved for the given token ID,
1006    *  is an operator of the owner, or is the owner of the token
1007    */
1008   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
1009     address owner = ownerOf(_tokenId);
1010     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
1011   }
1012 
1013   /**
1014   * @dev Internal function to mint a new token
1015   * @dev Reverts if the given token ID already exists
1016   * @param _to The address that will own the minted token
1017   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1018   */
1019   function _mint(address _to, uint256 _tokenId) internal {
1020     require(_to != address(0));
1021     addTokenTo(_to, _tokenId);
1022     Transfer(address(0), _to, _tokenId);
1023   }
1024 
1025   /**
1026   * @dev Internal function to burn a specific token
1027   * @dev Reverts if the token does not exist
1028   * @param _tokenId uint256 ID of the token being burned by the msg.sender
1029   */
1030   function _burn(address _owner, uint256 _tokenId) internal {
1031     clearApproval(_owner, _tokenId);
1032     removeTokenFrom(_owner, _tokenId);
1033     Transfer(_owner, address(0), _tokenId);
1034   }
1035 
1036   /**
1037   * @dev Internal function to clear current approval of a given token ID
1038   * @dev Reverts if the given address is not indeed the owner of the token
1039   * @param _owner owner of the token
1040   * @param _tokenId uint256 ID of the token to be transferred
1041   */
1042   function clearApproval(address _owner, uint256 _tokenId) internal {
1043     require(ownerOf(_tokenId) == _owner);
1044     if (tokenApprovals[_tokenId] != address(0)) {
1045       tokenApprovals[_tokenId] = address(0);
1046       Approval(_owner, address(0), _tokenId);
1047     }
1048   }
1049 
1050   /**
1051   * @dev Internal function to add a token ID to the list of a given address
1052   * @param _to address representing the new owner of the given token ID
1053   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1054   */
1055   function addTokenTo(address _to, uint256 _tokenId) internal {
1056     require(tokenOwner[_tokenId] == address(0));
1057     tokenOwner[_tokenId] = _to;
1058     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
1059   }
1060 
1061   /**
1062   * @dev Internal function to remove a token ID from the list of a given address
1063   * @param _from address representing the previous owner of the given token ID
1064   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1065   */
1066   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1067     require(ownerOf(_tokenId) == _from);
1068     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
1069     tokenOwner[_tokenId] = address(0);
1070   }
1071 
1072   /**
1073   * @dev Internal function to invoke `onERC721Received` on a target address
1074   * @dev The call is not executed if the target address is not a contract
1075   * @param _from address representing the previous owner of the given token ID
1076   * @param _to target address that will receive the tokens
1077   * @param _tokenId uint256 ID of the token to be transferred
1078   * @param _data bytes optional data to send along with the call
1079   * @return whether the call correctly returned the expected magic value
1080   */
1081   function checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes _data) internal returns (bool) {
1082     if (!_to.isContract()) {
1083       return true;
1084     }
1085     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
1086     return (retval == ERC721_RECEIVED);
1087   }
1088 }
1089 
1090 
1091 
1092 /**
1093  * @title Full ERC721 Token
1094  * This implementation includes all the required and some optional functionality of the ERC721 standard
1095  * Moreover, it includes approve all functionality using operator terminology
1096  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1097  */
1098 contract ERC721Token is ERC721, ERC721BasicToken {
1099   // Token name
1100   string internal name_;
1101 
1102   // Token symbol
1103   string internal symbol_;
1104 
1105   // Mapping from owner to list of owned token IDs
1106   mapping (address => uint256[]) internal ownedTokens;
1107 
1108   // Mapping from token ID to index of the owner tokens list
1109   mapping(uint256 => uint256) internal ownedTokensIndex;
1110 
1111   // Array with all token ids, used for enumeration
1112   uint256[] internal allTokens;
1113 
1114   // Mapping from token id to position in the allTokens array
1115   mapping(uint256 => uint256) internal allTokensIndex;
1116 
1117   // Optional mapping for token URIs 
1118   mapping(uint256 => string) internal tokenURIs;
1119 
1120   /**
1121   * @dev Constructor function
1122   */
1123   function ERC721Token(string _name, string _symbol) public {
1124     name_ = _name;
1125     symbol_ = _symbol;
1126   }
1127 
1128   /**
1129   * @dev Gets the token name
1130   * @return string representing the token name
1131   */
1132   function name() public view returns (string) {
1133     return name_;
1134   }
1135 
1136   /**
1137   * @dev Gets the token symbol
1138   * @return string representing the token symbol
1139   */
1140   function symbol() public view returns (string) {
1141     return symbol_;
1142   }
1143 
1144   /**
1145   * @dev Returns an URI for a given token ID
1146   * @dev Throws if the token ID does not exist. May return an empty string.
1147   * @param _tokenId uint256 ID of the token to query
1148   */
1149   function tokenURI(uint256 _tokenId) public view returns (string) {
1150     require(exists(_tokenId));
1151     return tokenURIs[_tokenId];
1152   }
1153 
1154   /**
1155   * @dev Internal function to set the token URI for a given token
1156   * @dev Reverts if the token ID does not exist
1157   * @param _tokenId uint256 ID of the token to set its URI
1158   * @param _uri string URI to assign
1159   */
1160   function _setTokenURI(uint256 _tokenId, string _uri) internal {
1161     require(exists(_tokenId));
1162     tokenURIs[_tokenId] = _uri;
1163   }
1164 
1165   /**
1166   * @dev Gets the token ID at a given index of the tokens list of the requested owner
1167   * @param _owner address owning the tokens list to be accessed
1168   * @param _index uint256 representing the index to be accessed of the requested tokens list
1169   * @return uint256 token ID at the given index of the tokens list owned by the requested address
1170   */
1171   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
1172     require(_index < balanceOf(_owner));
1173     return ownedTokens[_owner][_index];
1174   }
1175 
1176   /**
1177   * @dev Gets the total amount of tokens stored by the contract
1178   * @return uint256 representing the total amount of tokens
1179   */
1180   function totalSupply() public view returns (uint256) {
1181     return allTokens.length;
1182   }
1183 
1184   /**
1185   * @dev Gets the token ID at a given index of all the tokens in this contract
1186   * @dev Reverts if the index is greater or equal to the total number of tokens
1187   * @param _index uint256 representing the index to be accessed of the tokens list
1188   * @return uint256 token ID at the given index of the tokens list
1189   */
1190   function tokenByIndex(uint256 _index) public view returns (uint256) {
1191     require(_index < totalSupply());
1192     return allTokens[_index];
1193   }
1194 
1195   /**
1196   * @dev Internal function to add a token ID to the list of a given address
1197   * @param _to address representing the new owner of the given token ID
1198   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1199   */
1200   function addTokenTo(address _to, uint256 _tokenId) internal {
1201     super.addTokenTo(_to, _tokenId);
1202     uint256 length = ownedTokens[_to].length;
1203     ownedTokens[_to].push(_tokenId);
1204     ownedTokensIndex[_tokenId] = length;
1205   }
1206 
1207   /**
1208   * @dev Internal function to remove a token ID from the list of a given address
1209   * @param _from address representing the previous owner of the given token ID
1210   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1211   */
1212   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1213     super.removeTokenFrom(_from, _tokenId);
1214 
1215     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1216     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1217     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1218 
1219     ownedTokens[_from][tokenIndex] = lastToken;
1220     ownedTokens[_from][lastTokenIndex] = 0;
1221     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1222     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1223     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1224 
1225     ownedTokens[_from].length--;
1226     ownedTokensIndex[_tokenId] = 0;
1227     ownedTokensIndex[lastToken] = tokenIndex;
1228   }
1229 
1230   /**
1231   * @dev Internal function to mint a new token
1232   * @dev Reverts if the given token ID already exists
1233   * @param _to address the beneficiary that will own the minted token
1234   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1235   */
1236   function _mint(address _to, uint256 _tokenId) internal {
1237     super._mint(_to, _tokenId);
1238     
1239     allTokensIndex[_tokenId] = allTokens.length;
1240     allTokens.push(_tokenId);
1241   }
1242 
1243   /**
1244   * @dev Internal function to burn a specific token
1245   * @dev Reverts if the token does not exist
1246   * @param _owner owner of the token to burn
1247   * @param _tokenId uint256 ID of the token being burned by the msg.sender
1248   */
1249   function _burn(address _owner, uint256 _tokenId) internal {
1250     super._burn(_owner, _tokenId);
1251 
1252     // Clear metadata (if any)
1253     if (bytes(tokenURIs[_tokenId]).length != 0) {
1254       delete tokenURIs[_tokenId];
1255     }
1256 
1257     // Reorg all tokens array
1258     uint256 tokenIndex = allTokensIndex[_tokenId];
1259     uint256 lastTokenIndex = allTokens.length.sub(1);
1260     uint256 lastToken = allTokens[lastTokenIndex];
1261 
1262     allTokens[tokenIndex] = lastToken;
1263     allTokens[lastTokenIndex] = 0;
1264 
1265     allTokens.length--;
1266     allTokensIndex[_tokenId] = 0;
1267     allTokensIndex[lastToken] = tokenIndex;
1268   }
1269 
1270 }
1271 
1272 
1273 
1274 
1275 
1276 
1277 /**
1278  * @title ERC20 interface
1279  * @dev see https://github.com/ethereum/EIPs/issues/20
1280  */
1281 contract ERC20 is ERC20Basic {
1282   function allowance(address owner, address spender) public view returns (uint256);
1283   function transferFrom(address from, address to, uint256 value) public returns (bool);
1284   function approve(address spender, uint256 value) public returns (bool);
1285   event Approval(address indexed owner, address indexed spender, uint256 value);
1286 }
1287 
1288 
1289 
1290 /**
1291  * The DebtToken contract governs all business logic for making a debt agreement
1292  * transferable as an ERC721 non-fungible token.  Additionally, the contract
1293  * allows authorized contracts to trigger the minting of a debt agreement token
1294  * and, in turn, the insertion of a debt issuance into the DebtRegsitry.
1295  *
1296  * Author: Nadav Hollander -- Github: nadavhollander
1297  */
1298 contract DebtToken is ERC721Token, ERC165, Pausable, PermissionEvents {
1299     using PermissionsLib for PermissionsLib.Permissions;
1300 
1301     DebtRegistry public registry;
1302 
1303     PermissionsLib.Permissions internal tokenCreationPermissions;
1304     PermissionsLib.Permissions internal tokenURIPermissions;
1305 
1306     string public constant CREATION_CONTEXT = "debt-token-creation";
1307     string public constant URI_CONTEXT = "debt-token-uri";
1308 
1309     /**
1310      * Constructor that sets the address of the debt registry.
1311      */
1312     function DebtToken(address _registry)
1313         public
1314         ERC721Token("DebtToken", "DDT")
1315     {
1316         registry = DebtRegistry(_registry);
1317     }
1318 
1319     /**
1320      * ERC165 interface.
1321      * Returns true for ERC721, false otherwise
1322      */
1323     function supportsInterface(bytes4 interfaceID)
1324         external
1325         view
1326         returns (bool _isSupported)
1327     {
1328         return interfaceID == 0x80ac58cd; // ERC721
1329     }
1330 
1331     /**
1332      * Mints a unique debt token and inserts the associated issuance into
1333      * the debt registry, if the calling address is authorized to do so.
1334      */
1335     function create(
1336         address _version,
1337         address _beneficiary,
1338         address _debtor,
1339         address _underwriter,
1340         uint _underwriterRiskRating,
1341         address _termsContract,
1342         bytes32 _termsContractParameters,
1343         uint _salt
1344     )
1345         public
1346         whenNotPaused
1347         returns (uint _tokenId)
1348     {
1349         require(tokenCreationPermissions.isAuthorized(msg.sender));
1350 
1351         bytes32 entryHash = registry.insert(
1352             _version,
1353             _beneficiary,
1354             _debtor,
1355             _underwriter,
1356             _underwriterRiskRating,
1357             _termsContract,
1358             _termsContractParameters,
1359             _salt
1360         );
1361 
1362         super._mint(_beneficiary, uint(entryHash));
1363 
1364         return uint(entryHash);
1365     }
1366 
1367     /**
1368      * Adds an address to the list of agents authorized to mint debt tokens.
1369      */
1370     function addAuthorizedMintAgent(address _agent)
1371         public
1372         onlyOwner
1373     {
1374         tokenCreationPermissions.authorize(_agent, CREATION_CONTEXT);
1375     }
1376 
1377     /**
1378      * Removes an address from the list of agents authorized to mint debt tokens
1379      */
1380     function revokeMintAgentAuthorization(address _agent)
1381         public
1382         onlyOwner
1383     {
1384         tokenCreationPermissions.revokeAuthorization(_agent, CREATION_CONTEXT);
1385     }
1386 
1387     /**
1388      * Returns the list of agents authorized to mint debt tokens
1389      */
1390     function getAuthorizedMintAgents()
1391         public
1392         view
1393         returns (address[] _agents)
1394     {
1395         return tokenCreationPermissions.getAuthorizedAgents();
1396     }
1397 
1398     /**
1399      * Adds an address to the list of agents authorized to set token URIs.
1400      */
1401     function addAuthorizedTokenURIAgent(address _agent)
1402         public
1403         onlyOwner
1404     {
1405         tokenURIPermissions.authorize(_agent, URI_CONTEXT);
1406     }
1407 
1408     /**
1409      * Returns the list of agents authorized to set token URIs.
1410      */
1411     function getAuthorizedTokenURIAgents()
1412         public
1413         view
1414         returns (address[] _agents)
1415     {
1416         return tokenURIPermissions.getAuthorizedAgents();
1417     }
1418 
1419     /**
1420      * Removes an address from the list of agents authorized to set token URIs.
1421      */
1422     function revokeTokenURIAuthorization(address _agent)
1423         public
1424         onlyOwner
1425     {
1426         tokenURIPermissions.revokeAuthorization(_agent, URI_CONTEXT);
1427     }
1428 
1429     /**
1430      * We override approval method of the parent ERC721Token
1431      * contract to allow its functionality to be frozen in the case of an emergency
1432      */
1433     function approve(address _to, uint _tokenId)
1434         public
1435         whenNotPaused
1436     {
1437         super.approve(_to, _tokenId);
1438     }
1439 
1440     /**
1441      * We override setApprovalForAll method of the parent ERC721Token
1442      * contract to allow its functionality to be frozen in the case of an emergency
1443      */
1444     function setApprovalForAll(address _to, bool _approved)
1445         public
1446         whenNotPaused
1447     {
1448         super.setApprovalForAll(_to, _approved);
1449     }
1450 
1451     /**
1452      * Support deprecated ERC721 method
1453      */
1454     function transfer(address _to, uint _tokenId)
1455         public
1456     {
1457         safeTransferFrom(msg.sender, _to, _tokenId);
1458     }
1459 
1460     /**
1461      * We override transferFrom methods of the parent ERC721Token
1462      * contract to allow its functionality to be frozen in the case of an emergency
1463      */
1464     function transferFrom(address _from, address _to, uint _tokenId)
1465         public
1466         whenNotPaused
1467     {
1468         _modifyBeneficiary(_tokenId, _to);
1469         super.transferFrom(_from, _to, _tokenId);
1470     }
1471 
1472     /**
1473      * We override safeTransferFrom methods of the parent ERC721Token
1474      * contract to allow its functionality to be frozen in the case of an emergency
1475      */
1476     function safeTransferFrom(address _from, address _to, uint _tokenId)
1477         public
1478         whenNotPaused
1479     {
1480         _modifyBeneficiary(_tokenId, _to);
1481         super.safeTransferFrom(_from, _to, _tokenId);
1482     }
1483 
1484     /**
1485      * We override safeTransferFrom methods of the parent ERC721Token
1486      * contract to allow its functionality to be frozen in the case of an emergency
1487      */
1488     function safeTransferFrom(address _from, address _to, uint _tokenId, bytes _data)
1489         public
1490         whenNotPaused
1491     {
1492         _modifyBeneficiary(_tokenId, _to);
1493         super.safeTransferFrom(_from, _to, _tokenId, _data);
1494     }
1495 
1496     /**
1497      * Allows senders with special permissions to set the token URI for a given debt token.
1498      */
1499     function setTokenURI(uint256 _tokenId, string _uri)
1500         public
1501         whenNotPaused
1502     {
1503         require(tokenURIPermissions.isAuthorized(msg.sender));
1504         super._setTokenURI(_tokenId, _uri);
1505     }
1506 
1507     /**
1508      * _modifyBeneficiary mutates the debt registry. This function should be
1509      * called every time a token is transferred or minted
1510      */
1511     function _modifyBeneficiary(uint _tokenId, address _to)
1512         internal
1513     {
1514         if (registry.getBeneficiary(bytes32(_tokenId)) != _to) {
1515             registry.modifyBeneficiary(bytes32(_tokenId), _to);
1516         }
1517     }
1518 }