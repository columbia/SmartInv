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
622 // File: contracts/ERC165.sol
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
645 /**
646  * ERC165 interface required by ERC721 non-fungible token.
647  *
648  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
649  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
650  */
651 interface ERC165 {
652     /// @notice Query if a contract implements an interface
653     /// @param interfaceID The interface identifier, as specified in ERC-165
654     /// @dev Interface identification is specified in ERC-165. This function
655     ///  uses less than 30,000 gas.
656     /// @return `true` if the contract implements `interfaceID` and
657     ///  `interfaceID` is not 0xffffffff, `false` otherwise
658     function supportsInterface(bytes4 interfaceID) external view returns (bool);
659 }
660 
661 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
662 
663 /**
664  * @title ERC20Basic
665  * @dev Simpler version of ERC20 interface
666  * @dev see https://github.com/ethereum/EIPs/issues/179
667  */
668 contract ERC20Basic {
669   function totalSupply() public view returns (uint256);
670   function balanceOf(address who) public view returns (uint256);
671   function transfer(address to, uint256 value) public returns (bool);
672   event Transfer(address indexed from, address indexed to, uint256 value);
673 }
674 
675 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
676 
677 /**
678  * @title ERC20 interface
679  * @dev see https://github.com/ethereum/EIPs/issues/20
680  */
681 contract ERC20 is ERC20Basic {
682   function allowance(address owner, address spender) public view returns (uint256);
683   function transferFrom(address from, address to, uint256 value) public returns (bool);
684   function approve(address spender, uint256 value) public returns (bool);
685   event Approval(address indexed owner, address indexed spender, uint256 value);
686 }
687 
688 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
689 
690 /**
691  * @title ERC721 Non-Fungible Token Standard basic interface
692  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
693  */
694 contract ERC721Basic {
695   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
696   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
697   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);  
698 
699   function balanceOf(address _owner) public view returns (uint256 _balance);
700   function ownerOf(uint256 _tokenId) public view returns (address _owner);
701   function exists(uint256 _tokenId) public view returns (bool _exists);
702   
703   function approve(address _to, uint256 _tokenId) public;
704   function getApproved(uint256 _tokenId) public view returns (address _operator);
705   
706   function setApprovalForAll(address _operator, bool _approved) public;
707   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
708 
709   function transferFrom(address _from, address _to, uint256 _tokenId) public;
710   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;  
711   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
712 }
713 
714 // File: zeppelin-solidity/contracts/token/ERC721/ERC721.sol
715 
716 /**
717  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
718  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
719  */
720 contract ERC721Enumerable is ERC721Basic {
721   function totalSupply() public view returns (uint256);
722   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
723   function tokenByIndex(uint256 _index) public view returns (uint256);
724 }
725 
726 /**
727  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
728  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
729  */
730 contract ERC721Metadata is ERC721Basic {
731   function name() public view returns (string _name);
732   function symbol() public view returns (string _symbol);
733   function tokenURI(uint256 _tokenId) public view returns (string);
734 }
735 
736 /**
737  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
738  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
739  */
740 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
741 }
742 
743 // File: zeppelin-solidity/contracts/token/ERC721/DeprecatedERC721.sol
744 
745 /**
746  * @title ERC-721 methods shipped in OpenZeppelin v1.7.0, removed in the latest version of the standard
747  * @dev Only use this interface for compatibility with previously deployed contracts
748  * @dev Use ERC721 for interacting with new contracts which are standard-compliant
749  */
750 contract DeprecatedERC721 is ERC721 {
751   function takeOwnership(uint256 _tokenId) public;
752   function transfer(address _to, uint256 _tokenId) public;
753   function tokensOf(address _owner) public view returns (uint256[]);
754 }
755 
756 // File: zeppelin-solidity/contracts/AddressUtils.sol
757 
758 /**
759  * Utility library of inline functions on addresses
760  */
761 library AddressUtils {
762 
763   /**
764    * Returns whether there is code in the target address
765    * @dev This function will return false if invoked during the constructor of a contract,
766    *  as the code is not actually created until after the constructor finishes.
767    * @param addr address address to check
768    * @return whether there is code in the target address
769    */
770   function isContract(address addr) internal view returns (bool) {
771     uint256 size;
772     assembly { size := extcodesize(addr) }
773     return size > 0;
774   }
775 
776 }
777 
778 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
779 
780 /**
781  * @title ERC721 token receiver interface
782  * @dev Interface for any contract that wants to support safeTransfers
783  *  from ERC721 asset contracts.
784  */
785 contract ERC721Receiver {
786   /**
787    * @dev Magic value to be returned upon successful reception of an NFT
788    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
789    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
790    */
791   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba; 
792 
793   /**
794    * @notice Handle the receipt of an NFT
795    * @dev The ERC721 smart contract calls this function on the recipient
796    *  after a `safetransfer`. This function MAY throw to revert and reject the
797    *  transfer. This function MUST use 50,000 gas or less. Return of other
798    *  than the magic value MUST result in the transaction being reverted.
799    *  Note: the contract address is always the message sender.
800    * @param _from The sending address 
801    * @param _tokenId The NFT identifier which is being transfered
802    * @param _data Additional data with no specified format
803    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
804    */
805   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
806 }
807 
808 // File: zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
809 
810 /**
811  * @title ERC721 Non-Fungible Token Standard basic implementation
812  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
813  */
814 contract ERC721BasicToken is ERC721Basic {
815   using SafeMath for uint256;
816   using AddressUtils for address;
817   
818   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
819   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
820   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba; 
821 
822   // Mapping from token ID to owner
823   mapping (uint256 => address) internal tokenOwner;
824 
825   // Mapping from token ID to approved address
826   mapping (uint256 => address) internal tokenApprovals;
827 
828   // Mapping from owner to number of owned token
829   mapping (address => uint256) internal ownedTokensCount;
830 
831   // Mapping from owner to operator approvals
832   mapping (address => mapping (address => bool)) internal operatorApprovals;
833 
834   /**
835   * @dev Guarantees msg.sender is owner of the given token
836   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
837   */
838   modifier onlyOwnerOf(uint256 _tokenId) {
839     require(ownerOf(_tokenId) == msg.sender);
840     _;
841   }
842 
843   /**
844   * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
845   * @param _tokenId uint256 ID of the token to validate
846   */
847   modifier canTransfer(uint256 _tokenId) {
848     require(isApprovedOrOwner(msg.sender, _tokenId));
849     _;
850   }
851 
852   /**
853   * @dev Gets the balance of the specified address
854   * @param _owner address to query the balance of
855   * @return uint256 representing the amount owned by the passed address
856   */
857   function balanceOf(address _owner) public view returns (uint256) {
858     require(_owner != address(0));
859     return ownedTokensCount[_owner];
860   }
861 
862   /**
863   * @dev Gets the owner of the specified token ID
864   * @param _tokenId uint256 ID of the token to query the owner of
865   * @return owner address currently marked as the owner of the given token ID
866   */
867   function ownerOf(uint256 _tokenId) public view returns (address) {
868     address owner = tokenOwner[_tokenId];
869     require(owner != address(0));
870     return owner;
871   }
872 
873   /**
874   * @dev Returns whether the specified token exists
875   * @param _tokenId uint256 ID of the token to query the existance of
876   * @return whether the token exists
877   */
878   function exists(uint256 _tokenId) public view returns (bool) {
879     address owner = tokenOwner[_tokenId];
880     return owner != address(0);
881   }
882 
883   /**
884   * @dev Approves another address to transfer the given token ID
885   * @dev The zero address indicates there is no approved address.
886   * @dev There can only be one approved address per token at a given time.
887   * @dev Can only be called by the token owner or an approved operator.
888   * @param _to address to be approved for the given token ID
889   * @param _tokenId uint256 ID of the token to be approved
890   */
891   function approve(address _to, uint256 _tokenId) public {
892     address owner = ownerOf(_tokenId);
893     require(_to != owner);
894     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
895 
896     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
897       tokenApprovals[_tokenId] = _to;
898       Approval(owner, _to, _tokenId);
899     }
900   }
901 
902   /**
903    * @dev Gets the approved address for a token ID, or zero if no address set
904    * @param _tokenId uint256 ID of the token to query the approval of
905    * @return address currently approved for a the given token ID
906    */
907   function getApproved(uint256 _tokenId) public view returns (address) {
908     return tokenApprovals[_tokenId];
909   }
910 
911 
912   /**
913   * @dev Sets or unsets the approval of a given operator
914   * @dev An operator is allowed to transfer all tokens of the sender on their behalf
915   * @param _to operator address to set the approval
916   * @param _approved representing the status of the approval to be set
917   */
918   function setApprovalForAll(address _to, bool _approved) public {
919     require(_to != msg.sender);
920     operatorApprovals[msg.sender][_to] = _approved;
921     ApprovalForAll(msg.sender, _to, _approved);
922   }
923 
924   /**
925    * @dev Tells whether an operator is approved by a given owner
926    * @param _owner owner address which you want to query the approval of
927    * @param _operator operator address which you want to query the approval of
928    * @return bool whether the given operator is approved by the given owner
929    */
930   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
931     return operatorApprovals[_owner][_operator];
932   }
933 
934   /**
935   * @dev Transfers the ownership of a given token ID to another address
936   * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
937   * @dev Requires the msg sender to be the owner, approved, or operator
938   * @param _from current owner of the token
939   * @param _to address to receive the ownership of the given token ID
940   * @param _tokenId uint256 ID of the token to be transferred
941   */
942   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
943     require(_from != address(0));
944     require(_to != address(0));
945 
946     clearApproval(_from, _tokenId);
947     removeTokenFrom(_from, _tokenId);
948     addTokenTo(_to, _tokenId);
949     
950     Transfer(_from, _to, _tokenId);
951   }
952 
953   /**
954   * @dev Safely transfers the ownership of a given token ID to another address
955   * @dev If the target address is a contract, it must implement `onERC721Received`,
956   *  which is called upon a safe transfer, and return the magic value
957   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
958   *  the transfer is reverted.
959   * @dev Requires the msg sender to be the owner, approved, or operator
960   * @param _from current owner of the token
961   * @param _to address to receive the ownership of the given token ID
962   * @param _tokenId uint256 ID of the token to be transferred
963   */
964   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
965     safeTransferFrom(_from, _to, _tokenId, "");
966   }
967 
968   /**
969   * @dev Safely transfers the ownership of a given token ID to another address
970   * @dev If the target address is a contract, it must implement `onERC721Received`,
971   *  which is called upon a safe transfer, and return the magic value
972   *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
973   *  the transfer is reverted.
974   * @dev Requires the msg sender to be the owner, approved, or operator
975   * @param _from current owner of the token
976   * @param _to address to receive the ownership of the given token ID
977   * @param _tokenId uint256 ID of the token to be transferred
978   * @param _data bytes data to send along with a safe transfer check
979   */
980   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public canTransfer(_tokenId) {
981     transferFrom(_from, _to, _tokenId);
982     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
983   }
984 
985   /**
986    * @dev Returns whether the given spender can transfer a given token ID
987    * @param _spender address of the spender to query
988    * @param _tokenId uint256 ID of the token to be transferred
989    * @return bool whether the msg.sender is approved for the given token ID,
990    *  is an operator of the owner, or is the owner of the token
991    */
992   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
993     address owner = ownerOf(_tokenId);
994     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
995   }
996 
997   /**
998   * @dev Internal function to mint a new token
999   * @dev Reverts if the given token ID already exists
1000   * @param _to The address that will own the minted token
1001   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1002   */
1003   function _mint(address _to, uint256 _tokenId) internal {
1004     require(_to != address(0));
1005     addTokenTo(_to, _tokenId);
1006     Transfer(address(0), _to, _tokenId);
1007   }
1008 
1009   /**
1010   * @dev Internal function to burn a specific token
1011   * @dev Reverts if the token does not exist
1012   * @param _tokenId uint256 ID of the token being burned by the msg.sender
1013   */
1014   function _burn(address _owner, uint256 _tokenId) internal {
1015     clearApproval(_owner, _tokenId);
1016     removeTokenFrom(_owner, _tokenId);
1017     Transfer(_owner, address(0), _tokenId);
1018   }
1019 
1020   /**
1021   * @dev Internal function to clear current approval of a given token ID
1022   * @dev Reverts if the given address is not indeed the owner of the token
1023   * @param _owner owner of the token
1024   * @param _tokenId uint256 ID of the token to be transferred
1025   */
1026   function clearApproval(address _owner, uint256 _tokenId) internal {
1027     require(ownerOf(_tokenId) == _owner);
1028     if (tokenApprovals[_tokenId] != address(0)) {
1029       tokenApprovals[_tokenId] = address(0);
1030       Approval(_owner, address(0), _tokenId);
1031     }
1032   }
1033 
1034   /**
1035   * @dev Internal function to add a token ID to the list of a given address
1036   * @param _to address representing the new owner of the given token ID
1037   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1038   */
1039   function addTokenTo(address _to, uint256 _tokenId) internal {
1040     require(tokenOwner[_tokenId] == address(0));
1041     tokenOwner[_tokenId] = _to;
1042     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
1043   }
1044 
1045   /**
1046   * @dev Internal function to remove a token ID from the list of a given address
1047   * @param _from address representing the previous owner of the given token ID
1048   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1049   */
1050   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1051     require(ownerOf(_tokenId) == _from);
1052     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
1053     tokenOwner[_tokenId] = address(0);
1054   }
1055 
1056   /**
1057   * @dev Internal function to invoke `onERC721Received` on a target address
1058   * @dev The call is not executed if the target address is not a contract
1059   * @param _from address representing the previous owner of the given token ID
1060   * @param _to target address that will receive the tokens
1061   * @param _tokenId uint256 ID of the token to be transferred
1062   * @param _data bytes optional data to send along with the call
1063   * @return whether the call correctly returned the expected magic value
1064   */
1065   function checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes _data) internal returns (bool) {
1066     if (!_to.isContract()) {
1067       return true;
1068     }
1069     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
1070     return (retval == ERC721_RECEIVED);
1071   }
1072 }
1073 
1074 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
1075 
1076 /**
1077  * @title Full ERC721 Token
1078  * This implementation includes all the required and some optional functionality of the ERC721 standard
1079  * Moreover, it includes approve all functionality using operator terminology
1080  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1081  */
1082 contract ERC721Token is ERC721, ERC721BasicToken {
1083   // Token name
1084   string internal name_;
1085 
1086   // Token symbol
1087   string internal symbol_;
1088 
1089   // Mapping from owner to list of owned token IDs
1090   mapping (address => uint256[]) internal ownedTokens;
1091 
1092   // Mapping from token ID to index of the owner tokens list
1093   mapping(uint256 => uint256) internal ownedTokensIndex;
1094 
1095   // Array with all token ids, used for enumeration
1096   uint256[] internal allTokens;
1097 
1098   // Mapping from token id to position in the allTokens array
1099   mapping(uint256 => uint256) internal allTokensIndex;
1100 
1101   // Optional mapping for token URIs 
1102   mapping(uint256 => string) internal tokenURIs;
1103 
1104   /**
1105   * @dev Constructor function
1106   */
1107   function ERC721Token(string _name, string _symbol) public {
1108     name_ = _name;
1109     symbol_ = _symbol;
1110   }
1111 
1112   /**
1113   * @dev Gets the token name
1114   * @return string representing the token name
1115   */
1116   function name() public view returns (string) {
1117     return name_;
1118   }
1119 
1120   /**
1121   * @dev Gets the token symbol
1122   * @return string representing the token symbol
1123   */
1124   function symbol() public view returns (string) {
1125     return symbol_;
1126   }
1127 
1128   /**
1129   * @dev Returns an URI for a given token ID
1130   * @dev Throws if the token ID does not exist. May return an empty string.
1131   * @param _tokenId uint256 ID of the token to query
1132   */
1133   function tokenURI(uint256 _tokenId) public view returns (string) {
1134     require(exists(_tokenId));
1135     return tokenURIs[_tokenId];
1136   }
1137 
1138   /**
1139   * @dev Internal function to set the token URI for a given token
1140   * @dev Reverts if the token ID does not exist
1141   * @param _tokenId uint256 ID of the token to set its URI
1142   * @param _uri string URI to assign
1143   */
1144   function _setTokenURI(uint256 _tokenId, string _uri) internal {
1145     require(exists(_tokenId));
1146     tokenURIs[_tokenId] = _uri;
1147   }
1148 
1149   /**
1150   * @dev Gets the token ID at a given index of the tokens list of the requested owner
1151   * @param _owner address owning the tokens list to be accessed
1152   * @param _index uint256 representing the index to be accessed of the requested tokens list
1153   * @return uint256 token ID at the given index of the tokens list owned by the requested address
1154   */
1155   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
1156     require(_index < balanceOf(_owner));
1157     return ownedTokens[_owner][_index];
1158   }
1159 
1160   /**
1161   * @dev Gets the total amount of tokens stored by the contract
1162   * @return uint256 representing the total amount of tokens
1163   */
1164   function totalSupply() public view returns (uint256) {
1165     return allTokens.length;
1166   }
1167 
1168   /**
1169   * @dev Gets the token ID at a given index of all the tokens in this contract
1170   * @dev Reverts if the index is greater or equal to the total number of tokens
1171   * @param _index uint256 representing the index to be accessed of the tokens list
1172   * @return uint256 token ID at the given index of the tokens list
1173   */
1174   function tokenByIndex(uint256 _index) public view returns (uint256) {
1175     require(_index < totalSupply());
1176     return allTokens[_index];
1177   }
1178 
1179   /**
1180   * @dev Internal function to add a token ID to the list of a given address
1181   * @param _to address representing the new owner of the given token ID
1182   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1183   */
1184   function addTokenTo(address _to, uint256 _tokenId) internal {
1185     super.addTokenTo(_to, _tokenId);
1186     uint256 length = ownedTokens[_to].length;
1187     ownedTokens[_to].push(_tokenId);
1188     ownedTokensIndex[_tokenId] = length;
1189   }
1190 
1191   /**
1192   * @dev Internal function to remove a token ID from the list of a given address
1193   * @param _from address representing the previous owner of the given token ID
1194   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1195   */
1196   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1197     super.removeTokenFrom(_from, _tokenId);
1198 
1199     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1200     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1201     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1202 
1203     ownedTokens[_from][tokenIndex] = lastToken;
1204     ownedTokens[_from][lastTokenIndex] = 0;
1205     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1206     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1207     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1208 
1209     ownedTokens[_from].length--;
1210     ownedTokensIndex[_tokenId] = 0;
1211     ownedTokensIndex[lastToken] = tokenIndex;
1212   }
1213 
1214   /**
1215   * @dev Internal function to mint a new token
1216   * @dev Reverts if the given token ID already exists
1217   * @param _to address the beneficiary that will own the minted token
1218   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1219   */
1220   function _mint(address _to, uint256 _tokenId) internal {
1221     super._mint(_to, _tokenId);
1222     
1223     allTokensIndex[_tokenId] = allTokens.length;
1224     allTokens.push(_tokenId);
1225   }
1226 
1227   /**
1228   * @dev Internal function to burn a specific token
1229   * @dev Reverts if the token does not exist
1230   * @param _owner owner of the token to burn
1231   * @param _tokenId uint256 ID of the token being burned by the msg.sender
1232   */
1233   function _burn(address _owner, uint256 _tokenId) internal {
1234     super._burn(_owner, _tokenId);
1235 
1236     // Clear metadata (if any)
1237     if (bytes(tokenURIs[_tokenId]).length != 0) {
1238       delete tokenURIs[_tokenId];
1239     }
1240 
1241     // Reorg all tokens array
1242     uint256 tokenIndex = allTokensIndex[_tokenId];
1243     uint256 lastTokenIndex = allTokens.length.sub(1);
1244     uint256 lastToken = allTokens[lastTokenIndex];
1245 
1246     allTokens[tokenIndex] = lastToken;
1247     allTokens[lastTokenIndex] = 0;
1248 
1249     allTokens.length--;
1250     allTokensIndex[_tokenId] = 0;
1251     allTokensIndex[lastToken] = tokenIndex;
1252   }
1253 
1254 }
1255 
1256 // File: contracts/DebtToken.sol
1257 
1258 /*
1259 
1260   Copyright 2017 Dharma Labs Inc.
1261 
1262   Licensed under the Apache License, Version 2.0 (the "License");
1263   you may not use this file except in compliance with the License.
1264   You may obtain a copy of the License at
1265 
1266     http://www.apache.org/licenses/LICENSE-2.0
1267 
1268   Unless required by applicable law or agreed to in writing, software
1269   distributed under the License is distributed on an "AS IS" BASIS,
1270   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1271   See the License for the specific language governing permissions and
1272   limitations under the License.
1273 
1274 */
1275 
1276 pragma solidity 0.4.18;
1277 
1278 // Internal dependencies.
1279 
1280 
1281 
1282 
1283 // External dependencies.
1284 
1285 
1286 
1287 
1288 
1289 /**
1290  * The DebtToken contract governs all business logic for making a debt agreement
1291  * transferable as an ERC721 non-fungible token.  Additionally, the contract
1292  * allows authorized contracts to trigger the minting of a debt agreement token
1293  * and, in turn, the insertion of a debt issuance into the DebtRegsitry.
1294  *
1295  * Author: Nadav Hollander -- Github: nadavhollander
1296  */
1297 contract DebtToken is ERC721Token, ERC165, Pausable, PermissionEvents {
1298     using PermissionsLib for PermissionsLib.Permissions;
1299 
1300     DebtRegistry public registry;
1301 
1302     PermissionsLib.Permissions internal tokenCreationPermissions;
1303     PermissionsLib.Permissions internal tokenURIPermissions;
1304 
1305     string public constant CREATION_CONTEXT = "debt-token-creation";
1306     string public constant URI_CONTEXT = "debt-token-uri";
1307 
1308     /**
1309      * Constructor that sets the address of the debt registry.
1310      */
1311     function DebtToken(address _registry)
1312         public
1313         ERC721Token("DebtToken", "DDT")
1314     {
1315         registry = DebtRegistry(_registry);
1316     }
1317 
1318     /**
1319      * ERC165 interface.
1320      * Returns true for ERC721, false otherwise
1321      */
1322     function supportsInterface(bytes4 interfaceID)
1323         external
1324         view
1325         returns (bool _isSupported)
1326     {
1327         return interfaceID == 0x80ac58cd; // ERC721
1328     }
1329 
1330     /**
1331      * Mints a unique debt token and inserts the associated issuance into
1332      * the debt registry, if the calling address is authorized to do so.
1333      */
1334     function create(
1335         address _version,
1336         address _beneficiary,
1337         address _debtor,
1338         address _underwriter,
1339         uint _underwriterRiskRating,
1340         address _termsContract,
1341         bytes32 _termsContractParameters,
1342         uint _salt
1343     )
1344         public
1345         whenNotPaused
1346         returns (uint _tokenId)
1347     {
1348         require(tokenCreationPermissions.isAuthorized(msg.sender));
1349 
1350         bytes32 entryHash = registry.insert(
1351             _version,
1352             _beneficiary,
1353             _debtor,
1354             _underwriter,
1355             _underwriterRiskRating,
1356             _termsContract,
1357             _termsContractParameters,
1358             _salt
1359         );
1360 
1361         super._mint(_beneficiary, uint(entryHash));
1362 
1363         return uint(entryHash);
1364     }
1365 
1366     /**
1367      * Adds an address to the list of agents authorized to mint debt tokens.
1368      */
1369     function addAuthorizedMintAgent(address _agent)
1370         public
1371         onlyOwner
1372     {
1373         tokenCreationPermissions.authorize(_agent, CREATION_CONTEXT);
1374     }
1375 
1376     /**
1377      * Removes an address from the list of agents authorized to mint debt tokens
1378      */
1379     function revokeMintAgentAuthorization(address _agent)
1380         public
1381         onlyOwner
1382     {
1383         tokenCreationPermissions.revokeAuthorization(_agent, CREATION_CONTEXT);
1384     }
1385 
1386     /**
1387      * Returns the list of agents authorized to mint debt tokens
1388      */
1389     function getAuthorizedMintAgents()
1390         public
1391         view
1392         returns (address[] _agents)
1393     {
1394         return tokenCreationPermissions.getAuthorizedAgents();
1395     }
1396 
1397     /**
1398      * Adds an address to the list of agents authorized to set token URIs.
1399      */
1400     function addAuthorizedTokenURIAgent(address _agent)
1401         public
1402         onlyOwner
1403     {
1404         tokenURIPermissions.authorize(_agent, URI_CONTEXT);
1405     }
1406 
1407     /**
1408      * Returns the list of agents authorized to set token URIs.
1409      */
1410     function getAuthorizedTokenURIAgents()
1411         public
1412         view
1413         returns (address[] _agents)
1414     {
1415         return tokenURIPermissions.getAuthorizedAgents();
1416     }
1417 
1418     /**
1419      * Removes an address from the list of agents authorized to set token URIs.
1420      */
1421     function revokeTokenURIAuthorization(address _agent)
1422         public
1423         onlyOwner
1424     {
1425         tokenURIPermissions.revokeAuthorization(_agent, URI_CONTEXT);
1426     }
1427 
1428     /**
1429      * We override approval method of the parent ERC721Token
1430      * contract to allow its functionality to be frozen in the case of an emergency
1431      */
1432     function approve(address _to, uint _tokenId)
1433         public
1434         whenNotPaused
1435     {
1436         super.approve(_to, _tokenId);
1437     }
1438 
1439     /**
1440      * We override setApprovalForAll method of the parent ERC721Token
1441      * contract to allow its functionality to be frozen in the case of an emergency
1442      */
1443     function setApprovalForAll(address _to, bool _approved)
1444         public
1445         whenNotPaused
1446     {
1447         super.setApprovalForAll(_to, _approved);
1448     }
1449 
1450     /**
1451      * Support deprecated ERC721 method
1452      */
1453     function transfer(address _to, uint _tokenId)
1454         public
1455     {
1456         safeTransferFrom(msg.sender, _to, _tokenId);
1457     }
1458 
1459     /**
1460      * We override transferFrom methods of the parent ERC721Token
1461      * contract to allow its functionality to be frozen in the case of an emergency
1462      */
1463     function transferFrom(address _from, address _to, uint _tokenId)
1464         public
1465         whenNotPaused
1466     {
1467         _modifyBeneficiary(_tokenId, _to);
1468         super.transferFrom(_from, _to, _tokenId);
1469     }
1470 
1471     /**
1472      * We override safeTransferFrom methods of the parent ERC721Token
1473      * contract to allow its functionality to be frozen in the case of an emergency
1474      */
1475     function safeTransferFrom(address _from, address _to, uint _tokenId)
1476         public
1477         whenNotPaused
1478     {
1479         _modifyBeneficiary(_tokenId, _to);
1480         super.safeTransferFrom(_from, _to, _tokenId);
1481     }
1482 
1483     /**
1484      * We override safeTransferFrom methods of the parent ERC721Token
1485      * contract to allow its functionality to be frozen in the case of an emergency
1486      */
1487     function safeTransferFrom(address _from, address _to, uint _tokenId, bytes _data)
1488         public
1489         whenNotPaused
1490     {
1491         _modifyBeneficiary(_tokenId, _to);
1492         super.safeTransferFrom(_from, _to, _tokenId, _data);
1493     }
1494 
1495     /**
1496      * Allows senders with special permissions to set the token URI for a given debt token.
1497      */
1498     function setTokenURI(uint256 _tokenId, string _uri)
1499         public
1500         whenNotPaused
1501     {
1502         require(tokenURIPermissions.isAuthorized(msg.sender));
1503         super._setTokenURI(_tokenId, _uri);
1504     }
1505 
1506     /**
1507      * _modifyBeneficiary mutates the debt registry. This function should be
1508      * called every time a token is transferred or minted
1509      */
1510     function _modifyBeneficiary(uint _tokenId, address _to)
1511         internal
1512     {
1513         if (registry.getBeneficiary(bytes32(_tokenId)) != _to) {
1514             registry.modifyBeneficiary(bytes32(_tokenId), _to);
1515         }
1516     }
1517 }
1518 
1519 // File: contracts/TermsContract.sol
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
1542 interface TermsContract {
1543      /// When called, the registerTermStart function registers the fact that
1544      ///    the debt agreement has begun.  This method is called as a hook by the
1545      ///    DebtKernel when a debt order associated with `agreementId` is filled.
1546      ///    Method is not required to make any sort of internal state change
1547      ///    upon the debt agreement's start, but MUST return `true` in order to
1548      ///    acknowledge receipt of the transaction.  If, for any reason, the
1549      ///    debt agreement stored at `agreementId` is incompatible with this contract,
1550      ///    MUST return `false`, which will cause the pertinent order fill to fail.
1551      ///    If this method is called for a debt agreement whose term has already begun,
1552      ///    must THROW.  Similarly, if this method is called by any contract other
1553      ///    than the current DebtKernel, must THROW.
1554      /// @param  agreementId bytes32. The agreement id (issuance hash) of the debt agreement to which this pertains.
1555      /// @param  debtor address. The debtor in this particular issuance.
1556      /// @return _success bool. Acknowledgment of whether
1557     function registerTermStart(
1558         bytes32 agreementId,
1559         address debtor
1560     ) public returns (bool _success);
1561 
1562      /// When called, the registerRepayment function records the debtor's
1563      ///  repayment, as well as any auxiliary metadata needed by the contract
1564      ///  to determine ex post facto the value repaid (e.g. current USD
1565      ///  exchange rate)
1566      /// @param  agreementId bytes32. The agreement id (issuance hash) of the debt agreement to which this pertains.
1567      /// @param  payer address. The address of the payer.
1568      /// @param  beneficiary address. The address of the payment's beneficiary.
1569      /// @param  unitsOfRepayment uint. The units-of-value repaid in the transaction.
1570      /// @param  tokenAddress address. The address of the token with which the repayment transaction was executed.
1571     function registerRepayment(
1572         bytes32 agreementId,
1573         address payer,
1574         address beneficiary,
1575         uint256 unitsOfRepayment,
1576         address tokenAddress
1577     ) public returns (bool _success);
1578 
1579      /// Returns the cumulative units-of-value expected to be repaid by a given block timestamp.
1580      ///  Note this is not a constant function -- this value can vary on basis of any number of
1581      ///  conditions (e.g. interest rates can be renegotiated if repayments are delinquent).
1582      /// @param  agreementId bytes32. The agreement id (issuance hash) of the debt agreement to which this pertains.
1583      /// @param  timestamp uint. The timestamp of the block for which repayment expectation is being queried.
1584      /// @return uint256 The cumulative units-of-value expected to be repaid by the time the given timestamp lapses.
1585     function getExpectedRepaymentValue(
1586         bytes32 agreementId,
1587         uint256 timestamp
1588     ) public view returns (uint256);
1589 
1590      /// Returns the cumulative units-of-value repaid by the point at which this method is called.
1591      /// @param  agreementId bytes32. The agreement id (issuance hash) of the debt agreement to which this pertains.
1592      /// @return uint256 The cumulative units-of-value repaid up until now.
1593     function getValueRepaidToDate(
1594         bytes32 agreementId
1595     ) public view returns (uint256);
1596 
1597     /**
1598      * A method that returns a Unix timestamp representing the end of the debt agreement's term.
1599      * contract.
1600      */
1601     function getTermEndTimestamp(
1602         bytes32 _agreementId
1603     ) public view returns (uint);
1604 }
1605 
1606 // File: contracts/TokenTransferProxy.sol
1607 
1608 /*
1609 
1610   Copyright 2017 Dharma Labs Inc.
1611 
1612   Licensed under the Apache License, Version 2.0 (the "License");
1613   you may not use this file except in compliance with the License.
1614   You may obtain a copy of the License at
1615 
1616     http://www.apache.org/licenses/LICENSE-2.0
1617 
1618   Unless required by applicable law or agreed to in writing, software
1619   distributed under the License is distributed on an "AS IS" BASIS,
1620   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1621   See the License for the specific language governing permissions and
1622   limitations under the License.
1623 
1624 */
1625 
1626 pragma solidity 0.4.18;
1627 
1628 
1629 
1630 
1631 
1632 
1633 /**
1634  * The TokenTransferProxy is a proxy contract for transfering principal
1635  * and fee payments and repayments between agents and keepers in the Dharma
1636  * ecosystem.  It is decoupled from the DebtKernel in order to make upgrades to the
1637  * protocol contracts smoother -- if the DebtKernel or RepyamentRouter is upgraded to a new contract,
1638  * creditors will not have to grant new transfer approvals to a new contract's address.
1639  *
1640  * Author: Nadav Hollander -- Github: nadavhollander
1641  */
1642 contract TokenTransferProxy is Pausable, PermissionEvents {
1643     using PermissionsLib for PermissionsLib.Permissions;
1644 
1645     PermissionsLib.Permissions internal tokenTransferPermissions;
1646 
1647     string public constant CONTEXT = "token-transfer-proxy";
1648 
1649     /**
1650      * Add address to list of agents authorized to initiate `transferFrom` calls
1651      */
1652     function addAuthorizedTransferAgent(address _agent)
1653         public
1654         onlyOwner
1655     {
1656         tokenTransferPermissions.authorize(_agent, CONTEXT);
1657     }
1658 
1659     /**
1660      * Remove address from list of agents authorized to initiate `transferFrom` calls
1661      */
1662     function revokeTransferAgentAuthorization(address _agent)
1663         public
1664         onlyOwner
1665     {
1666         tokenTransferPermissions.revokeAuthorization(_agent, CONTEXT);
1667     }
1668 
1669     /**
1670      * Return list of agents authorized to initiate `transferFrom` calls
1671      */
1672     function getAuthorizedTransferAgents()
1673         public
1674         view
1675         returns (address[] authorizedAgents)
1676     {
1677         return tokenTransferPermissions.getAuthorizedAgents();
1678     }
1679 
1680     /**
1681      * Transfer specified token amount from _from address to _to address on give token
1682      */
1683     function transferFrom(
1684         address _token,
1685         address _from,
1686         address _to,
1687         uint _amount
1688     )
1689         public
1690         returns (bool _success)
1691     {
1692         require(tokenTransferPermissions.isAuthorized(msg.sender));
1693 
1694         return ERC20(_token).transferFrom(_from, _to, _amount);
1695     }
1696 }
1697 
1698 // File: contracts/DebtKernel.sol
1699 
1700 /*
1701 
1702   Copyright 2017 Dharma Labs Inc.
1703 
1704   Licensed under the Apache License, Version 2.0 (the "License");
1705   you may not use this file except in compliance with the License.
1706   You may obtain a copy of the License at
1707 
1708     http://www.apache.org/licenses/LICENSE-2.0
1709 
1710   Unless required by applicable law or agreed to in writing, software
1711   distributed under the License is distributed on an "AS IS" BASIS,
1712   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1713   See the License for the specific language governing permissions and
1714   limitations under the License.
1715 
1716 */
1717 
1718 pragma solidity 0.4.18;
1719 
1720 
1721 
1722 
1723 
1724 
1725 
1726 
1727 /**
1728  * The DebtKernel is the hub of all business logic governing how and when
1729  * debt orders can be filled and cancelled.  All logic that determines
1730  * whether a debt order is valid & consensual is contained herein,
1731  * as well as the mechanisms that transfer fees to keepers and
1732  * principal payments to debtors.
1733  *
1734  * Author: Nadav Hollander -- Github: nadavhollander
1735  */
1736 contract DebtKernel is Pausable {
1737     using SafeMath for uint;
1738 
1739     enum Errors {
1740         // Debt has been already been issued
1741         DEBT_ISSUED,
1742         // Order has already expired
1743         ORDER_EXPIRED,
1744         // Debt issuance associated with order has been cancelled
1745         ISSUANCE_CANCELLED,
1746         // Order has been cancelled
1747         ORDER_CANCELLED,
1748         // Order parameters specify amount of creditor / debtor fees
1749         // that is not equivalent to the amount of underwriter / relayer fees
1750         ORDER_INVALID_INSUFFICIENT_OR_EXCESSIVE_FEES,
1751         // Order parameters specify insufficient principal amount for
1752         // debtor to at least be able to meet his fees
1753         ORDER_INVALID_INSUFFICIENT_PRINCIPAL,
1754         // Order parameters specify non zero fee for an unspecified recipient
1755         ORDER_INVALID_UNSPECIFIED_FEE_RECIPIENT,
1756         // Order signatures are mismatched / malformed
1757         ORDER_INVALID_NON_CONSENSUAL,
1758         // Insufficient balance or allowance for principal token transfer
1759         CREDITOR_BALANCE_OR_ALLOWANCE_INSUFFICIENT
1760     }
1761 
1762     DebtToken public debtToken;
1763 
1764     // solhint-disable-next-line var-name-mixedcase
1765     address public TOKEN_TRANSFER_PROXY;
1766     bytes32 constant public NULL_ISSUANCE_HASH = bytes32(0);
1767 
1768     /* NOTE(kayvon): Currently, the `view` keyword does not actually enforce the
1769     static nature of the method; this will change in the future, but for now, in
1770     order to prevent reentrancy we'll need to arbitrarily set an upper bound on
1771     the gas limit allotted for certain method calls. */
1772     uint16 constant public EXTERNAL_QUERY_GAS_LIMIT = 8000;
1773 
1774     mapping (bytes32 => bool) public issuanceCancelled;
1775     mapping (bytes32 => bool) public debtOrderCancelled;
1776 
1777     event LogDebtOrderFilled(
1778         bytes32 indexed _agreementId,
1779         uint _principal,
1780         address _principalToken,
1781         address indexed _underwriter,
1782         uint _underwriterFee,
1783         address indexed _relayer,
1784         uint _relayerFee
1785     );
1786 
1787     event LogIssuanceCancelled(
1788         bytes32 indexed _agreementId,
1789         address indexed _cancelledBy
1790     );
1791 
1792     event LogDebtOrderCancelled(
1793         bytes32 indexed _debtOrderHash,
1794         address indexed _cancelledBy
1795     );
1796 
1797     event LogError(
1798         uint8 indexed _errorId,
1799         bytes32 indexed _orderHash
1800     );
1801 
1802     struct Issuance {
1803         address version;
1804         address debtor;
1805         address underwriter;
1806         uint underwriterRiskRating;
1807         address termsContract;
1808         bytes32 termsContractParameters;
1809         uint salt;
1810         bytes32 agreementId;
1811     }
1812 
1813     struct DebtOrder {
1814         Issuance issuance;
1815         uint underwriterFee;
1816         uint relayerFee;
1817         uint principalAmount;
1818         address principalToken;
1819         uint creditorFee;
1820         uint debtorFee;
1821         address relayer;
1822         uint expirationTimestampInSec;
1823         bytes32 debtOrderHash;
1824     }
1825 
1826     function DebtKernel(address tokenTransferProxyAddress)
1827         public
1828     {
1829         TOKEN_TRANSFER_PROXY = tokenTransferProxyAddress;
1830     }
1831 
1832     ////////////////////////
1833     // EXTERNAL FUNCTIONS //
1834     ////////////////////////
1835 
1836     /**
1837      * Allows contract owner to set the currently used debt token contract.
1838      * Function exists to maximize upgradeability of individual modules
1839      * in the entire system.
1840      */
1841     function setDebtToken(address debtTokenAddress)
1842         public
1843         onlyOwner
1844     {
1845         debtToken = DebtToken(debtTokenAddress);
1846     }
1847 
1848     /**
1849      * Fills a given debt order if it is valid and consensual.
1850      */
1851     function fillDebtOrder(
1852         address creditor,
1853         address[6] orderAddresses,
1854         uint[8] orderValues,
1855         bytes32[1] orderBytes32,
1856         uint8[3] signaturesV,
1857         bytes32[3] signaturesR,
1858         bytes32[3] signaturesS
1859     )
1860         public
1861         whenNotPaused
1862         returns (bytes32 _agreementId)
1863     {
1864         DebtOrder memory debtOrder = getDebtOrder(orderAddresses, orderValues, orderBytes32);
1865 
1866         // Assert order's validity & consensuality
1867         if (!assertDebtOrderValidityInvariants(debtOrder) ||
1868             !assertDebtOrderConsensualityInvariants(
1869                 debtOrder,
1870                 creditor,
1871                 signaturesV,
1872                 signaturesR,
1873                 signaturesS) ||
1874             !assertExternalBalanceAndAllowanceInvariants(creditor, debtOrder)) {
1875             return NULL_ISSUANCE_HASH;
1876         }
1877 
1878         // Mint debt token and finalize debt agreement
1879         issueDebtAgreement(creditor, debtOrder.issuance);
1880 
1881         // Register debt agreement's start with terms contract
1882         // We permit terms contracts to be undefined (for debt agreements which
1883         // may not have terms contracts associated with them), and only
1884         // register a term's start if the terms contract address is defined.
1885         if (debtOrder.issuance.termsContract != address(0)) {
1886             require(
1887                 TermsContract(debtOrder.issuance.termsContract)
1888                     .registerTermStart(
1889                         debtOrder.issuance.agreementId,
1890                         debtOrder.issuance.debtor
1891                     )
1892             );
1893         }
1894 
1895         // Transfer principal to debtor
1896         if (debtOrder.principalAmount > 0) {
1897             require(transferTokensFrom(
1898                 debtOrder.principalToken,
1899                 creditor,
1900                 debtOrder.issuance.debtor,
1901                 debtOrder.principalAmount.sub(debtOrder.debtorFee)
1902             ));
1903         }
1904 
1905         // Transfer underwriter fee to underwriter
1906         if (debtOrder.underwriterFee > 0) {
1907             require(transferTokensFrom(
1908                 debtOrder.principalToken,
1909                 creditor,
1910                 debtOrder.issuance.underwriter,
1911                 debtOrder.underwriterFee
1912             ));
1913         }
1914 
1915         // Transfer relayer fee to relayer
1916         if (debtOrder.relayerFee > 0) {
1917             require(transferTokensFrom(
1918                 debtOrder.principalToken,
1919                 creditor,
1920                 debtOrder.relayer,
1921                 debtOrder.relayerFee
1922             ));
1923         }
1924 
1925         LogDebtOrderFilled(
1926             debtOrder.issuance.agreementId,
1927             debtOrder.principalAmount,
1928             debtOrder.principalToken,
1929             debtOrder.issuance.underwriter,
1930             debtOrder.underwriterFee,
1931             debtOrder.relayer,
1932             debtOrder.relayerFee
1933         );
1934 
1935         return debtOrder.issuance.agreementId;
1936     }
1937 
1938     /**
1939      * Allows both underwriters and debtors to prevent a debt
1940      * issuance in which they're involved from being used in
1941      * a future debt order.
1942      */
1943     function cancelIssuance(
1944         address version,
1945         address debtor,
1946         address termsContract,
1947         bytes32 termsContractParameters,
1948         address underwriter,
1949         uint underwriterRiskRating,
1950         uint salt
1951     )
1952         public
1953         whenNotPaused
1954     {
1955         require(msg.sender == debtor || msg.sender == underwriter);
1956 
1957         Issuance memory issuance = getIssuance(
1958             version,
1959             debtor,
1960             underwriter,
1961             termsContract,
1962             underwriterRiskRating,
1963             salt,
1964             termsContractParameters
1965         );
1966 
1967         issuanceCancelled[issuance.agreementId] = true;
1968 
1969         LogIssuanceCancelled(issuance.agreementId, msg.sender);
1970     }
1971 
1972     /**
1973      * Allows a debtor to cancel a debt order before it's been filled
1974      * -- preventing any counterparty from filling it in the future.
1975      */
1976     function cancelDebtOrder(
1977         address[6] orderAddresses,
1978         uint[8] orderValues,
1979         bytes32[1] orderBytes32
1980     )
1981         public
1982         whenNotPaused
1983     {
1984         DebtOrder memory debtOrder = getDebtOrder(orderAddresses, orderValues, orderBytes32);
1985 
1986         require(msg.sender == debtOrder.issuance.debtor);
1987 
1988         debtOrderCancelled[debtOrder.debtOrderHash] = true;
1989 
1990         LogDebtOrderCancelled(debtOrder.debtOrderHash, msg.sender);
1991     }
1992 
1993     ////////////////////////
1994     // INTERNAL FUNCTIONS //
1995     ////////////////////////
1996 
1997     /**
1998      * Helper function that mints debt token associated with the
1999      * given issuance and grants it to the beneficiary.
2000      */
2001     function issueDebtAgreement(address beneficiary, Issuance issuance)
2002         internal
2003         returns (bytes32 _agreementId)
2004     {
2005         // Mint debt token and finalize debt agreement
2006         uint tokenId = debtToken.create(
2007             issuance.version,
2008             beneficiary,
2009             issuance.debtor,
2010             issuance.underwriter,
2011             issuance.underwriterRiskRating,
2012             issuance.termsContract,
2013             issuance.termsContractParameters,
2014             issuance.salt
2015         );
2016 
2017         assert(tokenId == uint(issuance.agreementId));
2018 
2019         return issuance.agreementId;
2020     }
2021 
2022     /**
2023      * Asserts that a debt order meets all consensuality requirements
2024      * described in the DebtKernel specification document.
2025      */
2026     function assertDebtOrderConsensualityInvariants(
2027         DebtOrder debtOrder,
2028         address creditor,
2029         uint8[3] signaturesV,
2030         bytes32[3] signaturesR,
2031         bytes32[3] signaturesS
2032     )
2033         internal
2034         returns (bool _orderIsConsensual)
2035     {
2036         // Invariant: debtor's signature must be valid, unless debtor is submitting order
2037         if (msg.sender != debtOrder.issuance.debtor) {
2038             if (!isValidSignature(
2039                 debtOrder.issuance.debtor,
2040                 debtOrder.debtOrderHash,
2041                 signaturesV[0],
2042                 signaturesR[0],
2043                 signaturesS[0]
2044             )) {
2045                 LogError(uint8(Errors.ORDER_INVALID_NON_CONSENSUAL), debtOrder.debtOrderHash);
2046                 return false;
2047             }
2048         }
2049 
2050         // Invariant: creditor's signature must be valid, unless creditor is submitting order
2051         if (msg.sender != creditor) {
2052             if (!isValidSignature(
2053                 creditor,
2054                 debtOrder.debtOrderHash,
2055                 signaturesV[1],
2056                 signaturesR[1],
2057                 signaturesS[1]
2058             )) {
2059                 LogError(uint8(Errors.ORDER_INVALID_NON_CONSENSUAL), debtOrder.debtOrderHash);
2060                 return false;
2061             }
2062         }
2063 
2064 
2065         // Invariant: underwriter's signature must be valid (if present)
2066         if (debtOrder.issuance.underwriter != address(0) &&
2067             msg.sender != debtOrder.issuance.underwriter) {
2068             if (!isValidSignature(
2069                 debtOrder.issuance.underwriter,
2070                 getUnderwriterMessageHash(debtOrder),
2071                 signaturesV[2],
2072                 signaturesR[2],
2073                 signaturesS[2]
2074             )) {
2075                 LogError(uint8(Errors.ORDER_INVALID_NON_CONSENSUAL), debtOrder.debtOrderHash);
2076                 return false;
2077             }
2078         }
2079 
2080         return true;
2081     }
2082 
2083     /**
2084      * Asserts that debt order meets all validity requirements described in
2085      * the DebtKernel specification document.
2086      */
2087     function assertDebtOrderValidityInvariants(DebtOrder debtOrder)
2088         internal
2089         returns (bool _orderIsValid)
2090     {
2091         uint totalFees = debtOrder.creditorFee.add(debtOrder.debtorFee);
2092 
2093         // Invariant: the total value of fees contributed by debtors and creditors
2094         //  must be equivalent to that paid out to underwriters and relayers.
2095         if (totalFees != debtOrder.relayerFee.add(debtOrder.underwriterFee)) {
2096             LogError(uint8(Errors.ORDER_INVALID_INSUFFICIENT_OR_EXCESSIVE_FEES), debtOrder.debtOrderHash);
2097             return false;
2098         }
2099 
2100         // Invariant: debtor is given enough principal to cover at least debtorFees
2101         if (debtOrder.principalAmount < debtOrder.debtorFee) {
2102             LogError(uint8(Errors.ORDER_INVALID_INSUFFICIENT_PRINCIPAL), debtOrder.debtOrderHash);
2103             return false;
2104         }
2105 
2106         // Invariant: if no underwriter is specified, underwriter fees must be 0
2107         // Invariant: if no relayer is specified, relayer fees must be 0.
2108         //      Given that relayer fees = total fees - underwriter fees,
2109         //      we assert that total fees = underwriter fees.
2110         if ((debtOrder.issuance.underwriter == address(0) && debtOrder.underwriterFee > 0) ||
2111             (debtOrder.relayer == address(0) && totalFees != debtOrder.underwriterFee)) {
2112             LogError(uint8(Errors.ORDER_INVALID_UNSPECIFIED_FEE_RECIPIENT), debtOrder.debtOrderHash);
2113             return false;
2114         }
2115 
2116         // Invariant: debt order must not be expired
2117         // solhint-disable-next-line not-rely-on-time
2118         if (debtOrder.expirationTimestampInSec < block.timestamp) {
2119             LogError(uint8(Errors.ORDER_EXPIRED), debtOrder.debtOrderHash);
2120             return false;
2121         }
2122 
2123         // Invariant: debt order's issuance must not already be minted as debt token
2124         if (debtToken.exists(uint(debtOrder.issuance.agreementId))) {
2125             LogError(uint8(Errors.DEBT_ISSUED), debtOrder.debtOrderHash);
2126             return false;
2127         }
2128 
2129         // Invariant: debt order's issuance must not have been cancelled
2130         if (issuanceCancelled[debtOrder.issuance.agreementId]) {
2131             LogError(uint8(Errors.ISSUANCE_CANCELLED), debtOrder.debtOrderHash);
2132             return false;
2133         }
2134 
2135         // Invariant: debt order itself must not have been cancelled
2136         if (debtOrderCancelled[debtOrder.debtOrderHash]) {
2137             LogError(uint8(Errors.ORDER_CANCELLED), debtOrder.debtOrderHash);
2138             return false;
2139         }
2140 
2141         return true;
2142     }
2143 
2144     /**
2145      * Assert that the creditor has a sufficient token balance and has
2146      * granted the token transfer proxy contract sufficient allowance to suffice for the principal
2147      * and creditor fee.
2148      */
2149     function assertExternalBalanceAndAllowanceInvariants(
2150         address creditor,
2151         DebtOrder debtOrder
2152     )
2153         internal
2154         returns (bool _isBalanceAndAllowanceSufficient)
2155     {
2156         uint totalCreditorPayment = debtOrder.principalAmount.add(debtOrder.creditorFee);
2157 
2158         if (getBalance(debtOrder.principalToken, creditor) < totalCreditorPayment ||
2159             getAllowance(debtOrder.principalToken, creditor) < totalCreditorPayment) {
2160             LogError(uint8(Errors.CREDITOR_BALANCE_OR_ALLOWANCE_INSUFFICIENT), debtOrder.debtOrderHash);
2161             return false;
2162         }
2163 
2164         return true;
2165     }
2166 
2167     /**
2168      * Helper function transfers a specified amount of tokens between two parties
2169      * using the token transfer proxy contract.
2170      */
2171     function transferTokensFrom(
2172         address token,
2173         address from,
2174         address to,
2175         uint amount
2176     )
2177         internal
2178         returns (bool success)
2179     {
2180         return TokenTransferProxy(TOKEN_TRANSFER_PROXY).transferFrom(
2181             token,
2182             from,
2183             to,
2184             amount
2185         );
2186     }
2187 
2188     /**
2189      * Helper function that constructs a hashed issuance structs from the given
2190      * parameters.
2191      */
2192     function getIssuance(
2193         address version,
2194         address debtor,
2195         address underwriter,
2196         address termsContract,
2197         uint underwriterRiskRating,
2198         uint salt,
2199         bytes32 termsContractParameters
2200     )
2201         internal
2202         pure
2203         returns (Issuance _issuance)
2204     {
2205         Issuance memory issuance = Issuance({
2206             version: version,
2207             debtor: debtor,
2208             underwriter: underwriter,
2209             termsContract: termsContract,
2210             underwriterRiskRating: underwriterRiskRating,
2211             salt: salt,
2212             termsContractParameters: termsContractParameters,
2213             agreementId: getAgreementId(
2214                 version,
2215                 debtor,
2216                 underwriter,
2217                 termsContract,
2218                 underwriterRiskRating,
2219                 salt,
2220                 termsContractParameters
2221             )
2222         });
2223 
2224         return issuance;
2225     }
2226 
2227     /**
2228      * Helper function that constructs a hashed debt order struct given the raw parameters
2229      * of a debt order.
2230      */
2231     function getDebtOrder(address[6] orderAddresses, uint[8] orderValues, bytes32[1] orderBytes32)
2232         internal
2233         view
2234         returns (DebtOrder _debtOrder)
2235     {
2236         DebtOrder memory debtOrder = DebtOrder({
2237             issuance: getIssuance(
2238                 orderAddresses[0],
2239                 orderAddresses[1],
2240                 orderAddresses[2],
2241                 orderAddresses[3],
2242                 orderValues[0],
2243                 orderValues[1],
2244                 orderBytes32[0]
2245             ),
2246             principalToken: orderAddresses[4],
2247             relayer: orderAddresses[5],
2248             principalAmount: orderValues[2],
2249             underwriterFee: orderValues[3],
2250             relayerFee: orderValues[4],
2251             creditorFee: orderValues[5],
2252             debtorFee: orderValues[6],
2253             expirationTimestampInSec: orderValues[7],
2254             debtOrderHash: bytes32(0)
2255         });
2256 
2257         debtOrder.debtOrderHash = getDebtOrderHash(debtOrder);
2258 
2259         return debtOrder;
2260     }
2261 
2262     /**
2263      * Helper function that returns an issuance's hash
2264      */
2265     function getAgreementId(
2266         address version,
2267         address debtor,
2268         address underwriter,
2269         address termsContract,
2270         uint underwriterRiskRating,
2271         uint salt,
2272         bytes32 termsContractParameters
2273     )
2274         internal
2275         pure
2276         returns (bytes32 _agreementId)
2277     {
2278         return keccak256(
2279             version,
2280             debtor,
2281             underwriter,
2282             underwriterRiskRating,
2283             termsContract,
2284             termsContractParameters,
2285             salt
2286         );
2287     }
2288 
2289     /**
2290      * Returns the hash of the parameters which an underwriter is supposed to sign
2291      */
2292     function getUnderwriterMessageHash(DebtOrder debtOrder)
2293         internal
2294         view
2295         returns (bytes32 _underwriterMessageHash)
2296     {
2297         return keccak256(
2298             address(this),
2299             debtOrder.issuance.agreementId,
2300             debtOrder.underwriterFee,
2301             debtOrder.principalAmount,
2302             debtOrder.principalToken,
2303             debtOrder.expirationTimestampInSec
2304         );
2305     }
2306 
2307     /**
2308      * Returns the hash of the debt order.
2309      */
2310     function getDebtOrderHash(DebtOrder debtOrder)
2311         internal
2312         view
2313         returns (bytes32 _debtorMessageHash)
2314     {
2315         return keccak256(
2316             address(this),
2317             debtOrder.issuance.agreementId,
2318             debtOrder.underwriterFee,
2319             debtOrder.principalAmount,
2320             debtOrder.principalToken,
2321             debtOrder.debtorFee,
2322             debtOrder.creditorFee,
2323             debtOrder.relayer,
2324             debtOrder.relayerFee,
2325             debtOrder.expirationTimestampInSec
2326         );
2327     }
2328 
2329     /**
2330      * Given a hashed message, a signer's address, and a signature, returns
2331      * whether the signature is valid.
2332      */
2333     function isValidSignature(
2334         address signer,
2335         bytes32 hash,
2336         uint8 v,
2337         bytes32 r,
2338         bytes32 s
2339     )
2340         internal
2341         pure
2342         returns (bool _valid)
2343     {
2344         return signer == ecrecover(
2345             keccak256("\x19Ethereum Signed Message:\n32", hash),
2346             v,
2347             r,
2348             s
2349         );
2350     }
2351 
2352     /**
2353      * Helper function for querying an address' balance on a given token.
2354      */
2355     function getBalance(
2356         address token,
2357         address owner
2358     )
2359         internal
2360         view
2361         returns (uint _balance)
2362     {
2363         // Limit gas to prevent reentrancy.
2364         return ERC20(token).balanceOf.gas(EXTERNAL_QUERY_GAS_LIMIT)(owner);
2365     }
2366 
2367     /**
2368      * Helper function for querying an address' allowance to the 0x transfer proxy.
2369      */
2370     function getAllowance(
2371         address token,
2372         address owner
2373     )
2374         internal
2375         view
2376         returns (uint _allowance)
2377     {
2378         // Limit gas to prevent reentrancy.
2379         return ERC20(token).allowance.gas(EXTERNAL_QUERY_GAS_LIMIT)(owner, TOKEN_TRANSFER_PROXY);
2380     }
2381 }