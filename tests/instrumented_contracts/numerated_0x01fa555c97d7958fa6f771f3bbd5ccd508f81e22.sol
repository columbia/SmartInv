1 // File: contracts/zeppelin-solidity/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to relinquish control of the contract.
40    * @notice Renouncing to ownership will leave the contract without an owner.
41    * It will not be possible to call the functions with the `onlyOwner`
42    * modifier anymore.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 // File: contracts/token/Managed.sol
69 
70 pragma solidity ^0.4.24;
71 
72 
73 contract Managed is Ownable {
74   mapping (address => bool) public managers;
75 
76   modifier onlyManager () {
77     require(isManager(), "Only managers may perform this action");
78     _;
79   }
80 
81   modifier onlyManagerOrOwner () {
82     require(
83       checkManagerStatus(msg.sender) || msg.sender == owner,
84       "Only managers or owners may perform this action"
85     );
86     _;
87   }
88 
89   function checkManagerStatus (address managerAddress) public view returns (bool) {
90     return managers[managerAddress];
91   }
92 
93   function isManager () public view returns (bool) {
94     return checkManagerStatus(msg.sender);
95   }
96 
97   function addManager (address managerAddress) public onlyOwner {
98     managers[managerAddress] = true;
99   }
100 
101   function removeManager (address managerAddress) public onlyOwner {
102     managers[managerAddress] = false;
103   }
104 }
105 
106 // File: contracts/token/ManagedWhitelist.sol
107 
108 pragma solidity ^0.4.24;
109 
110 
111 contract ManagedWhitelist is Managed {
112   // CORE - addresses that are controller by Civil Foundation, Civil Media, or Civil Newsrooms
113   mapping (address => bool) public coreList;
114   // CIVILIAN - addresses that have completed the tutorial
115   mapping (address => bool) public civilianList;
116   // UNLOCKED - addresses that have completed "proof of use" requirements
117   mapping (address => bool) public unlockedList;
118   // VERIFIED - addresses that have completed KYC verification
119   mapping (address => bool) public verifiedList;
120   // STOREFRONT - addresses that will sell tokens on behalf of the Civil Foundation. these addresses can only transfer to VERIFIED users
121   mapping (address => bool) public storefrontList;
122   // NEWSROOM - multisig addresses created by the NewsroomFactory
123   mapping (address => bool) public newsroomMultisigList;
124 
125   // addToCore allows a manager to add an address to the CORE list
126   function addToCore (address operator) public onlyManagerOrOwner {
127     coreList[operator] = true;
128   }
129 
130   // removeFromCore allows a manager to remove an address frin the CORE list
131   function removeFromCore (address operator) public onlyManagerOrOwner {
132     coreList[operator] = false;
133   }
134 
135   // addToCivilians allows a manager to add an address to the CORE list
136   function addToCivilians (address operator) public onlyManagerOrOwner {
137     civilianList[operator] = true;
138   }
139 
140   // removeFromCivilians allows a manager to remove an address from the CORE list
141   function removeFromCivilians (address operator) public onlyManagerOrOwner {
142     civilianList[operator] = false;
143   }
144   // addToUnlocked allows a manager to add an address to the UNLOCKED list
145   function addToUnlocked (address operator) public onlyManagerOrOwner {
146     unlockedList[operator] = true;
147   }
148 
149   // removeFromUnlocked allows a manager to remove an address from the UNLOCKED list
150   function removeFromUnlocked (address operator) public onlyManagerOrOwner {
151     unlockedList[operator] = false;
152   }
153 
154   // addToVerified allows a manager to add an address to the VERIFIED list
155   function addToVerified (address operator) public onlyManagerOrOwner {
156     verifiedList[operator] = true;
157   }
158   // removeFromVerified allows a manager to remove an address from the VERIFIED list
159   function removeFromVerified (address operator) public onlyManagerOrOwner {
160     verifiedList[operator] = false;
161   }
162 
163   // addToStorefront allows a manager to add an address to the STOREFRONT list
164   function addToStorefront (address operator) public onlyManagerOrOwner {
165     storefrontList[operator] = true;
166   }
167   // removeFromStorefront allows a manager to remove an address from the STOREFRONT list
168   function removeFromStorefront (address operator) public onlyManagerOrOwner {
169     storefrontList[operator] = false;
170   }
171 
172   // addToNewsroomMultisigs allows a manager to remove an address from the STOREFRONT list
173   function addToNewsroomMultisigs (address operator) public onlyManagerOrOwner {
174     newsroomMultisigList[operator] = true;
175   }
176   // removeFromNewsroomMultisigs allows a manager to remove an address from the STOREFRONT list
177   function removeFromNewsroomMultisigs (address operator) public onlyManagerOrOwner {
178     newsroomMultisigList[operator] = false;
179   }
180 
181   function checkProofOfUse (address operator) public {
182 
183   }
184 
185 }
186 
187 // File: contracts/token/ERC1404/ERC1404.sol
188 
189 pragma solidity ^0.4.24;
190 
191 contract ERC1404 {
192   /// @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
193   /// @param from Sending address
194   /// @param to Receiving address
195   /// @param value Amount of tokens being transferred
196   /// @return Code by which to reference message for rejection reasoning
197   /// @dev Overwrite with your custom transfer restriction logic
198   function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8);
199 
200   /// @notice Returns a human-readable message for a given restriction code
201   /// @param restrictionCode Identifier for looking up a message
202   /// @return Text showing the restriction's reasoning
203   /// @dev Overwrite with your custom message and restrictionCode handling
204   function messageForTransferRestriction (uint8 restrictionCode) public view returns (string);
205 }
206 
207 // File: contracts/token/ERC1404/MessagesAndCodes.sol
208 
209 pragma solidity ^0.4.24;
210 
211 library MessagesAndCodes {
212   string public constant EMPTY_MESSAGE_ERROR = "Message cannot be empty string";
213   string public constant CODE_RESERVED_ERROR = "Given code is already pointing to a message";
214   string public constant CODE_UNASSIGNED_ERROR = "Given code does not point to a message";
215 
216   struct Data {
217     mapping (uint8 => string) messages;
218     uint8[] codes;
219   }
220 
221   function messageIsEmpty (string _message)
222       internal
223       pure
224       returns (bool isEmpty)
225   {
226     isEmpty = bytes(_message).length == 0;
227   }
228 
229   function messageExists (Data storage self, uint8 _code)
230       internal
231       view
232       returns (bool exists)
233   {
234     exists = bytes(self.messages[_code]).length > 0;
235   }
236 
237   function addMessage (Data storage self, uint8 _code, string _message)
238       public
239       returns (uint8 code)
240   {
241     require(!messageIsEmpty(_message), EMPTY_MESSAGE_ERROR);
242     require(!messageExists(self, _code), CODE_RESERVED_ERROR);
243 
244     // enter message at code and push code onto storage
245     self.messages[_code] = _message;
246     self.codes.push(_code);
247     code = _code;
248   }
249 
250   function autoAddMessage (Data storage self, string _message)
251       public
252       returns (uint8 code)
253   {
254     require(!messageIsEmpty(_message), EMPTY_MESSAGE_ERROR);
255 
256     // find next available code to store the message at
257     code = 0;
258     while (messageExists(self, code)) {
259       code++;
260     }
261 
262     // add message at the auto-generated code
263     addMessage(self, code, _message);
264   }
265 
266   function removeMessage (Data storage self, uint8 _code)
267       public
268       returns (uint8 code)
269   {
270     require(messageExists(self, _code), CODE_UNASSIGNED_ERROR);
271 
272     // find index of code
273     uint8 indexOfCode = 0;
274     while (self.codes[indexOfCode] != _code) {
275       indexOfCode++;
276     }
277 
278     // remove code from storage by shifting codes in array
279     for (uint8 i = indexOfCode; i < self.codes.length - 1; i++) {
280       self.codes[i] = self.codes[i + 1];
281     }
282     self.codes.length--;
283 
284     // remove message from storage
285     self.messages[_code] = "";
286     code = _code;
287   }
288 
289   function updateMessage (Data storage self, uint8 _code, string _message)
290       public
291       returns (uint8 code)
292   {
293     require(!messageIsEmpty(_message), EMPTY_MESSAGE_ERROR);
294     require(messageExists(self, _code), CODE_UNASSIGNED_ERROR);
295 
296     // update message at code
297     self.messages[_code] = _message;
298     code = _code;
299   }
300 }
301 
302 // File: contracts/multisig/Factory.sol
303 
304 pragma solidity ^0.4.19;
305 
306 contract Factory {
307 
308   /*
309     *  Events
310     */
311   event ContractInstantiation(address sender, address instantiation);
312 
313   /*
314     *  Storage
315     */
316   mapping(address => bool) public isInstantiation;
317   mapping(address => address[]) public instantiations;
318 
319   /*
320     * Public functions
321     */
322   /// @dev Returns number of instantiations by creator.
323   /// @param creator Contract creator.
324   /// @return Returns number of instantiations by creator.
325   function getInstantiationCount(address creator)
326     public
327     view
328     returns (uint)
329   {
330     return instantiations[creator].length;
331   }
332 
333   /*
334     * Internal functions
335     */
336   /// @dev Registers contract in factory registry.
337   /// @param instantiation Address of contract instantiation.
338   function register(address instantiation)
339       internal
340   {
341     isInstantiation[instantiation] = true;
342     instantiations[msg.sender].push(instantiation);
343     emit ContractInstantiation(msg.sender, instantiation);
344   }
345 }
346 
347 // File: contracts/interfaces/IMultiSigWalletFactory.sol
348 
349 pragma solidity ^0.4.19;
350 
351 interface IMultiSigWalletFactory {
352   function create(address[] _owners, uint _required) public returns (address wallet);
353 }
354 
355 // File: contracts/newsroom/ACL.sol
356 
357 pragma solidity ^0.4.19;
358 
359 
360 /**
361 @title String-based Access Control List
362 @author The Civil Media Company
363 @dev The owner of this smart-contract overrides any role requirement in the requireRole modifier,
364 and so it is important to use the modifier instead of checking hasRole when creating actual requirements.
365 The internal functions are not secured in any way and should be extended in the deriving contracts to define
366 requirements that suit that specific domain.
367 */
368 contract ACL is Ownable {
369   event RoleAdded(address indexed granter, address indexed grantee, string role);
370   event RoleRemoved(address indexed granter, address indexed grantee, string role);
371 
372   mapping(string => RoleData) private roles;
373 
374   modifier requireRole(string role) {
375     require(isOwner(msg.sender) || hasRole(msg.sender, role));
376     _;
377   }
378 
379   function ACL() Ownable() public {
380   }
381 
382   /**
383   @notice Returns whether a specific addres has a role. Keep in mind that the owner can override role checks
384   @param user The address for which role check is done
385   @param role A constant name of the role being checked
386   */
387   function hasRole(address user, string role) public view returns (bool) {
388     return roles[role].actors[user];
389   }
390 
391   /**
392   @notice Returns if the specified address is owner of this smart-contract and thus can override any role checks
393   @param user The checked address
394   */
395   function isOwner(address user) public view returns (bool) {
396     return user == owner;
397   }
398 
399   function _addRole(address grantee, string role) internal {
400     roles[role].actors[grantee] = true;
401     emit RoleAdded(msg.sender, grantee, role);
402   }
403 
404   function _removeRole(address grantee, string role) internal {
405     delete roles[role].actors[grantee];
406     emit RoleRemoved(msg.sender, grantee, role);
407   }
408 
409   struct RoleData {
410     mapping(address => bool) actors;
411   }
412 }
413 
414 // File: contracts/zeppelin-solidity/ECRecovery.sol
415 
416 pragma solidity ^0.4.24;
417 
418 
419 /**
420  * @title Elliptic curve signature operations
421  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
422  * TODO Remove this library once solidity supports passing a signature to ecrecover.
423  * See https://github.com/ethereum/solidity/issues/864
424  */
425 
426 library ECRecovery {
427 
428   /**
429    * @dev Recover signer address from a message by using their signature
430    * @param _hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
431    * @param _sig bytes signature, the signature is generated using web3.eth.sign()
432    */
433   function recover(bytes32 _hash, bytes _sig)
434     internal
435     pure
436     returns (address)
437   {
438     bytes32 r;
439     bytes32 s;
440     uint8 v;
441 
442     // Check the signature length
443     if (_sig.length != 65) {
444       return (address(0));
445     }
446 
447     // Divide the signature in r, s and v variables
448     // ecrecover takes the signature parameters, and the only way to get them
449     // currently is to use assembly.
450     // solium-disable-next-line security/no-inline-assembly
451     assembly {
452       r := mload(add(_sig, 32))
453       s := mload(add(_sig, 64))
454       v := byte(0, mload(add(_sig, 96)))
455     }
456 
457     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
458     if (v < 27) {
459       v += 27;
460     }
461 
462     // If the version is correct return the signer address
463     if (v != 27 && v != 28) {
464       return (address(0));
465     } else {
466       // solium-disable-next-line arg-overflow
467       return ecrecover(_hash, v, r, s);
468     }
469   }
470 
471   /**
472    * toEthSignedMessageHash
473    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
474    * and hash the result
475    */
476   function toEthSignedMessageHash(bytes32 _hash)
477     internal
478     pure
479     returns (bytes32)
480   {
481     // 32 is the length in bytes of hash,
482     // enforced by the type signature above
483     return keccak256(
484       abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
485     );
486   }
487 }
488 
489 // File: contracts/newsroom/Newsroom.sol
490 
491 pragma solidity ^0.4.19;
492 
493 
494 
495 /**
496 @title Newsroom - Smart-contract allowing for Newsroom-like goverance and content publishing
497 
498 @dev The content number 0 is created automatically and it's use is reserved for the Newsroom charter / about page
499 
500 Roles that are currently supported are:
501 - "editor" -> which can publish content, update revisions and add/remove more editors
502 
503 To post cryptographicaly pre-approved content on the Newsroom, the author's signature must be included and
504 "Signed"-suffix functions used. Here are the steps to generate authors signature:
505 1. Take the address of this newsroom and the contentHash as bytes32 and tightly pack them
506 2. Calculate the keccak256 of tightly packed of above
507 3. Take the keccak and prepend it with the standard "Ethereum signed message" preffix (see ECRecovery and Ethereum's JSON PRC).
508   a. Note - if you're using Ethereum's node instead of manual private key signing, that message shall be prepended by the Node itself
509 4. Take a keccak256 of that signed messaged
510 5. Verification can be done by using EC recovery algorithm using the authors signature
511 The verification can be seen in the internal `verifyRevisionsSignature` function.
512 The signing can be seen in (at)joincivil/utils package, function prepareNewsroomMessage function (and web3.eth.sign() it afterwards)
513 */
514 contract Newsroom is ACL {
515   using ECRecovery for bytes32;
516 
517   event ContentPublished(address indexed editor, uint indexed contentId, string uri);
518   event RevisionSigned(uint indexed contentId, uint indexed revisionId, address indexed author);
519   event RevisionUpdated(address indexed editor, uint indexed contentId, uint indexed revisionId, string uri);
520   event NameChanged(string newName);
521 
522   string private constant ROLE_EDITOR = "editor";
523 
524   mapping(uint => Content) private contents;
525   /*
526   Maps the revision hash to original contentId where it was first used.
527   This is used to prevent replay attacks in which a bad actor reuses an already used signature to sign a new revision of new content.
528   New revisions with the same contentID can reuse signatures by design -> this is to allow the Editors to change the canonical URL (eg, website change).
529   The end-client of those smart-contracts MUST (RFC-Like) verify the content to it's hash and the the hash to the signature.
530   */
531   mapping(bytes32 => UsedSignature) private usedSignatures;
532 
533   /**
534   @notice The number of different contents in this Newsroom, indexed in <0, contentCount) (exclusive) range
535   */
536   uint public contentCount;
537   /**
538   @notice User readable name of this Newsroom
539   */
540   string public name;
541 
542   function Newsroom(string newsroomName, string charterUri, bytes32 charterHash) ACL() public {
543     setName(newsroomName);
544     publishContent(charterUri, charterHash, address(0), "");
545   }
546 
547   /**
548   @notice Gets the latest revision of the content at id contentId
549   */
550   function getContent(uint contentId) external view returns (bytes32 contentHash, string uri, uint timestamp, address author, bytes signature) {
551     return getRevision(contentId, contents[contentId].revisions.length - 1);
552   }
553 
554   /**
555   @notice Gets a specific revision of the content. Each revision increases the ID from the previous one
556   @param contentId Which content to get
557   @param revisionId Which revision in that get content to get
558   */
559   function getRevision(
560     uint contentId,
561     uint revisionId
562   ) public view returns (bytes32 contentHash, string uri, uint timestamp, address author, bytes signature)
563   {
564     Content storage content = contents[contentId];
565     require(content.revisions.length > revisionId);
566 
567     Revision storage revision = content.revisions[revisionId];
568 
569     return (revision.contentHash, revision.uri, revision.timestamp, content.author, revision.signature);
570   }
571 
572   /**
573   @return Number of revisions for a this content, 0 if never published
574   */
575   function revisionCount(uint contentId) external view returns (uint) {
576     return contents[contentId].revisions.length;
577   }
578 
579   /**
580   @notice Returns if the latest revision of the content at ID has the author's signature associated with it
581   */
582   function isContentSigned(uint contentId) public view returns (bool) {
583     return isRevisionSigned(contentId, contents[contentId].revisions.length - 1);
584   }
585 
586   /**
587   @notice Returns if that specific revision of the content has the author's signature
588   */
589   function isRevisionSigned(uint contentId, uint revisionId) public view returns (bool) {
590     Revision[] storage revisions = contents[contentId].revisions;
591     require(revisions.length > revisionId);
592     return revisions[revisionId].signature.length != 0;
593   }
594 
595   /**
596   @notice Changes the user-readable name of this contract.
597   This function can be only called by the owner of the Newsroom
598   */
599   function setName(string newName) public onlyOwner() {
600     require(bytes(newName).length > 0);
601     name = newName;
602 
603     emit NameChanged(name);
604   }
605 
606   /**
607   @notice Adds a string-based role to the specific address, requires ROLE_EDITOR to use
608   */
609   function addRole(address who, string role) external requireRole(ROLE_EDITOR) {
610     _addRole(who, role);
611   }
612 
613   function addEditor(address who) external requireRole(ROLE_EDITOR) {
614     _addRole(who, ROLE_EDITOR);
615   }
616 
617   /**
618   @notice Removes a string-based role from the specific address, requires ROLE_EDITOR to use
619   */
620   function removeRole(address who, string role) external requireRole(ROLE_EDITOR) {
621     _removeRole(who, role);
622   }
623 
624   /**
625   @notice Saves the content's URI and it's hash into this Newsroom, this creates a new Content and Revision number 0.
626   This function requires ROLE_EDITOR or owner to use.
627   The content can be cryptographicaly secured / approved by author as per signing procedure
628   @param contentUri Canonical URI to access the content. The client should then verify that the content has the same hash
629   @param contentHash Keccak256 hash of the content that is linked
630   @param author Author that cryptographically signs the content. Null if not signed
631   @param signature Cryptographic signature of the author. Empty if not signed
632   @return Content ID of the newly published content
633 
634   @dev Emits `ContentPublished`, `RevisionUpdated` and optionaly `ContentSigned` events
635   */
636   function publishContent(
637     string contentUri,
638     bytes32 contentHash,
639     address author,
640     bytes signature
641   ) public requireRole(ROLE_EDITOR) returns (uint)
642   {
643     uint contentId = contentCount;
644     contentCount++;
645 
646     require((author == address(0) && signature.length == 0) || (author != address(0) && signature.length != 0));
647     contents[contentId].author = author;
648     pushRevision(contentId, contentUri, contentHash, signature);
649 
650     emit ContentPublished(msg.sender, contentId, contentUri);
651     return contentId;
652   }
653 
654   /**
655   @notice Updates the existing content with a new revision, the content id stays the same while revision id increases afterwards
656   Requires that the content was first published
657   This function can be only called by ROLE_EDITOR or the owner.
658   The new revision can be left unsigned, even if the previous revisions were signed.
659   If the new revision is also signed, it has to be approved by the same author that has signed the first revision.
660   No signing can be done for articles that were published without any cryptographic author in the first place
661   @param signature Signature that cryptographically approves this revision. Empty if not approved
662   @return Newest revision id
663 
664   @dev Emits `RevisionUpdated`  event
665   */
666   function updateRevision(uint contentId, string contentUri, bytes32 contentHash, bytes signature) external requireRole(ROLE_EDITOR) {
667     pushRevision(contentId, contentUri, contentHash, signature);
668   }
669 
670   /**
671   @notice Allows to backsign a revision by the author. This is indented when an author didn't have time to access
672   to their private key but after time they do.
673   The author must be the same as the one during publishing.
674   If there was no author during publishing this functions allows to update the null author to a real one.
675   Once done, the author can't be changed afterwards
676 
677   @dev Emits `RevisionSigned` event
678   */
679   function signRevision(uint contentId, uint revisionId, address author, bytes signature) external requireRole(ROLE_EDITOR) {
680     require(contentId < contentCount);
681 
682     Content storage content = contents[contentId];
683 
684     require(content.author == address(0) || content.author == author);
685     require(content.revisions.length > revisionId);
686 
687     if (contentId == 0) {
688       require(isOwner(msg.sender));
689     }
690 
691     content.author = author;
692 
693     Revision storage revision = content.revisions[revisionId];
694     revision.signature = signature;
695 
696     require(verifyRevisionSignature(author, contentId, revision));
697 
698     emit RevisionSigned(contentId, revisionId, author);
699   }
700 
701   function verifyRevisionSignature(address author, uint contentId, Revision storage revision) internal returns (bool isSigned) {
702     if (author == address(0) || revision.signature.length == 0) {
703       require(revision.signature.length == 0);
704       return false;
705     } else {
706       // The url is is not used in the cryptography by design,
707       // the rationale is that the Author can approve the content and the Editor might need to set the url
708       // after the fact, or things like DNS change, meaning there would be a question of canonical url for that article
709       //
710       // The end-client of this smart-contract MUST (RFC-like) compare the authenticity of the content behind the URL with the hash of the revision
711       bytes32 hashedMessage = keccak256(
712         address(this),
713         revision.contentHash
714       ).toEthSignedMessageHash();
715 
716       require(hashedMessage.recover(revision.signature) == author);
717 
718       // Prevent replay attacks
719       UsedSignature storage lastUsed = usedSignatures[hashedMessage];
720       require(lastUsed.wasUsed == false || lastUsed.contentId == contentId);
721 
722       lastUsed.wasUsed = true;
723       lastUsed.contentId = contentId;
724 
725       return true;
726     }
727   }
728 
729   function pushRevision(uint contentId, string contentUri, bytes32 contentHash, bytes signature) internal returns (uint) {
730     require(contentId < contentCount);
731 
732     if (contentId == 0) {
733       require(isOwner(msg.sender));
734     }
735 
736     Content storage content = contents[contentId];
737 
738     uint revisionId = content.revisions.length;
739 
740     content.revisions.push(Revision(
741       contentHash,
742       contentUri,
743       now,
744       signature
745     ));
746 
747     if (verifyRevisionSignature(content.author, contentId, content.revisions[revisionId])) {
748       emit RevisionSigned(contentId, revisionId, content.author);
749     }
750 
751     emit RevisionUpdated(msg.sender, contentId, revisionId, contentUri);
752   }
753 
754   struct Content {
755     Revision[] revisions;
756     address author;
757   }
758 
759   struct Revision {
760     bytes32 contentHash;
761     string uri;
762     uint timestamp;
763     bytes signature;
764   }
765 
766   // Since all uints are 0x0 by default, we require additional bool to confirm that the contentID is not equal to content with actualy ID 0x0
767   struct UsedSignature {
768     bool wasUsed;
769     uint contentId;
770   }
771 }
772 
773 // File: contracts/newsroom/NewsroomFactory.sol
774 
775 pragma solidity ^0.4.19;
776 // TODO(ritave): Think of a way to not require contracts out of package
777 
778 
779 
780 
781 /**
782 @title Newsroom with Board of Directors factory
783 @notice This smart-contract creates the full multi-smart-contract structure of a Newsroom in a single transaction
784 After creation the Newsroom is owned by the Board of Directors which is represented by a multisig-gnosis-based wallet
785 */
786 contract NewsroomFactory is Factory {
787   IMultiSigWalletFactory public multisigFactory;
788   mapping (address => address) public multisigNewsrooms;
789 
790   function NewsroomFactory(address multisigFactoryAddr) public {
791     multisigFactory = IMultiSigWalletFactory(multisigFactoryAddr);
792   }
793 
794   /**
795   @notice Creates a fully-set-up newsroom, a multisig wallet and transfers it's ownership straight to the wallet at hand
796   */
797   function create(string name, string charterUri, bytes32 charterHash, address[] initialOwners, uint initialRequired)
798     public
799     returns (Newsroom newsroom)
800   {
801     address wallet = multisigFactory.create(initialOwners, initialRequired);
802     newsroom = new Newsroom(name, charterUri, charterHash);
803     newsroom.addEditor(msg.sender);
804     newsroom.transferOwnership(wallet);
805     multisigNewsrooms[wallet] = newsroom;
806     register(newsroom);
807   }
808 }
809 
810 // File: contracts/proof-of-use/telemetry/TokenTelemetryI.sol
811 
812 pragma solidity ^0.4.23;
813 
814 interface TokenTelemetryI {
815   function onRequestVotingRights(address user, uint tokenAmount) external;
816 }
817 
818 // File: contracts/token/CivilTokenController.sol
819 
820 pragma solidity ^0.4.24;
821 
822 
823 
824 
825 
826 
827 contract CivilTokenController is ManagedWhitelist, ERC1404, TokenTelemetryI {
828   using MessagesAndCodes for MessagesAndCodes.Data;
829   MessagesAndCodes.Data internal messagesAndCodes;
830 
831   uint8 public constant SUCCESS_CODE = 0;
832   string public constant SUCCESS_MESSAGE = "SUCCESS";
833 
834   uint8 public constant MUST_BE_A_CIVILIAN_CODE = 1;
835   string public constant MUST_BE_A_CIVILIAN_ERROR = "MUST_BE_A_CIVILIAN";
836 
837   uint8 public constant MUST_BE_UNLOCKED_CODE = 2;
838   string public constant MUST_BE_UNLOCKED_ERROR = "MUST_BE_UNLOCKED";
839 
840   uint8 public constant MUST_BE_VERIFIED_CODE = 3;
841   string public constant MUST_BE_VERIFIED_ERROR = "MUST_BE_VERIFIED";
842 
843   constructor () public {
844     messagesAndCodes.addMessage(SUCCESS_CODE, SUCCESS_MESSAGE);
845     messagesAndCodes.addMessage(MUST_BE_A_CIVILIAN_CODE, MUST_BE_A_CIVILIAN_ERROR);
846     messagesAndCodes.addMessage(MUST_BE_UNLOCKED_CODE, MUST_BE_UNLOCKED_ERROR);
847     messagesAndCodes.addMessage(MUST_BE_VERIFIED_CODE, MUST_BE_VERIFIED_ERROR);
848 
849   }
850 
851   function detectTransferRestriction (address from, address to, uint value)
852       public
853       view
854       returns (uint8)
855   {
856     // FROM is core or users that have proved use
857     if (coreList[from] || unlockedList[from]) {
858       return SUCCESS_CODE;
859     } else if (storefrontList[from]) { // FROM is a storefront wallet
860       // allow if this is going to a verified user or a core address
861       if (verifiedList[to] || coreList[to]) {
862         return SUCCESS_CODE;
863       } else {
864         // Storefront cannot transfer to wallets that have not been KYCed
865         return MUST_BE_VERIFIED_CODE;
866       }
867     } else if (newsroomMultisigList[from]) { // FROM is a newsroom multisig
868       // TO is CORE or CIVILIAN
869       if ( coreList[to] || civilianList[to]) {
870         return SUCCESS_CODE;
871       } else {
872         return MUST_BE_UNLOCKED_CODE;
873       }
874     } else if (civilianList[from]) { // FROM is a civilian
875       // FROM is sending TO a core address or a newsroom
876       if (coreList[to] || newsroomMultisigList[to]) {
877         return SUCCESS_CODE;
878       } else {
879         // otherwise fail
880         return MUST_BE_UNLOCKED_CODE;
881       }
882     } else {
883       // reject if FROM is not a civilian
884       return MUST_BE_A_CIVILIAN_CODE;
885     }
886   }
887 
888   function messageForTransferRestriction (uint8 restrictionCode)
889     public
890     view
891     returns (string message)
892   {
893     message = messagesAndCodes.messages[restrictionCode];
894   }
895 
896   function onRequestVotingRights(address user, uint tokenAmount) external {
897     addToUnlocked(user);
898   }
899 }
900 
901 // File: contracts/zeppelin-solidity/token/ERC20/IERC20.sol
902 
903 pragma solidity ^0.4.24;
904 
905 /**
906  * @title ERC20 interface
907  * @dev see https://github.com/ethereum/EIPs/issues/20
908  */
909 interface IERC20 {
910     function totalSupply() external view returns (uint256);
911 
912     function balanceOf(address who) external view returns (uint256);
913 
914     function allowance(address owner, address spender) external view returns (uint256);
915 
916     function transfer(address to, uint256 value) external returns (bool);
917 
918     function approve(address spender, uint256 value) external returns (bool);
919 
920     function transferFrom(address from, address to, uint256 value) external returns (bool);
921 
922     event Transfer(address indexed from, address indexed to, uint256 value);
923 
924     event Approval(address indexed owner, address indexed spender, uint256 value);
925 }
926 
927 // File: contracts/zeppelin-solidity/math/SafeMath.sol
928 
929 pragma solidity ^0.4.24;
930 
931 
932 /**
933  * @title SafeMath
934  * @dev Math operations with safety checks that throw on error
935  */
936 library SafeMath {
937 
938   /**
939   * @dev Multiplies two numbers, throws on overflow.
940   */
941   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
942     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
943     // benefit is lost if 'b' is also tested.
944     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
945     if (_a == 0) {
946       return 0;
947     }
948 
949     c = _a * _b;
950     assert(c / _a == _b);
951     return c;
952   }
953 
954   /**
955   * @dev Integer division of two numbers, truncating the quotient.
956   */
957   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
958     // assert(_b > 0); // Solidity automatically throws when dividing by 0
959     // uint256 c = _a / _b;
960     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
961     return _a / _b;
962   }
963 
964   /**
965   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
966   */
967   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
968     assert(_b <= _a);
969     return _a - _b;
970   }
971 
972   /**
973   * @dev Adds two numbers, throws on overflow.
974   */
975   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
976     c = _a + _b;
977     assert(c >= _a);
978     return c;
979   }
980 }
981 
982 // File: contracts/zeppelin-solidity/token/ERC20/ERC20.sol
983 
984 pragma solidity ^0.4.24;
985 
986 
987 
988 /**
989  * @title Standard ERC20 token
990  *
991  * @dev Implementation of the basic standard token.
992  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
993  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
994  */
995 contract ERC20 is IERC20 {
996   using SafeMath for uint256;
997 
998   mapping (address => uint256) private _balances;
999 
1000   mapping (address => mapping (address => uint256)) private _allowed;
1001 
1002   uint256 private _totalSupply;
1003 
1004   /**
1005   * @dev Total number of tokens in existence
1006   */
1007   function totalSupply() public view returns (uint256) {
1008     return _totalSupply;
1009   }
1010 
1011   /**
1012   * @dev Gets the balance of the specified address.
1013   * @param owner The address to query the balance of.
1014   * @return An uint256 representing the amount owned by the passed address.
1015   */
1016   function balanceOf(address owner) public view returns (uint256) {
1017     return _balances[owner];
1018   }
1019 
1020   /**
1021     * @dev Function to check the amount of tokens that an owner allowed to a spender.
1022     * @param owner address The address which owns the funds.
1023     * @param spender address The address which will spend the funds.
1024     * @return A uint256 specifying the amount of tokens still available for the spender.
1025     */
1026   function allowance(address owner, address spender) public view returns (uint256) {
1027     return _allowed[owner][spender];
1028   }
1029 
1030   /**
1031   * @dev Transfer token for a specified address
1032   * @param to The address to transfer to.
1033   * @param value The amount to be transferred.
1034   */
1035   function transfer(address to, uint256 value) public returns (bool) {
1036     _transfer(msg.sender, to, value);
1037     return true;
1038   }
1039 
1040   /**
1041     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1042     * Beware that changing an allowance with this method brings the risk that someone may use both the old
1043     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1044     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1045     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1046     * @param spender The address which will spend the funds.
1047     * @param value The amount of tokens to be spent.
1048     */
1049   function approve(address spender, uint256 value) public returns (bool) {
1050     require(spender != address(0));
1051 
1052     _allowed[msg.sender][spender] = value;
1053     emit Approval(msg.sender, spender, value);
1054     return true;
1055   }
1056 
1057   /**
1058     * @dev Transfer tokens from one address to another
1059     * @param from address The address which you want to send tokens from
1060     * @param to address The address which you want to transfer to
1061     * @param value uint256 the amount of tokens to be transferred
1062     */
1063   function transferFrom(address from, address to, uint256 value) public returns (bool) {
1064     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
1065     _transfer(from, to, value);
1066     return true;
1067   }
1068 
1069   /**
1070     * @dev Increase the amount of tokens that an owner allowed to a spender.
1071     * approve should be called when allowed_[_spender] == 0. To increment
1072     * allowed value is better to use this function to avoid 2 calls (and wait until
1073     * the first transaction is mined)
1074     * From MonolithDAO Token.sol
1075     * @param spender The address which will spend the funds.
1076     * @param addedValue The amount of tokens to increase the allowance by.
1077     */
1078   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
1079     require(spender != address(0));
1080 
1081     _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
1082     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
1083     return true;
1084   }
1085 
1086   /**
1087     * @dev Decrease the amount of tokens that an owner allowed to a spender.
1088     * approve should be called when allowed_[_spender] == 0. To decrement
1089     * allowed value is better to use this function to avoid 2 calls (and wait until
1090     * the first transaction is mined)
1091     * From MonolithDAO Token.sol
1092     * @param spender The address which will spend the funds.
1093     * @param subtractedValue The amount of tokens to decrease the allowance by.
1094     */
1095   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
1096     require(spender != address(0));
1097 
1098     _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
1099     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
1100     return true;
1101   }
1102 
1103   /**
1104   * @dev Transfer token for a specified addresses
1105   * @param from The address to transfer from.
1106   * @param to The address to transfer to.
1107   * @param value The amount to be transferred.
1108   */
1109   function _transfer(address from, address to, uint256 value) internal {
1110     require(to != address(0));
1111 
1112     _balances[from] = _balances[from].sub(value);
1113     _balances[to] = _balances[to].add(value);
1114     emit Transfer(from, to, value);
1115   }
1116 
1117   /**
1118     * @dev Internal function that mints an amount of the token and assigns it to
1119     * an account. This encapsulates the modification of balances such that the
1120     * proper events are emitted.
1121     * @param account The account that will receive the created tokens.
1122     * @param value The amount that will be created.
1123     */
1124   function _mint(address account, uint256 value) internal {
1125     require(account != address(0));
1126 
1127     _totalSupply = _totalSupply.add(value);
1128     _balances[account] = _balances[account].add(value);
1129     emit Transfer(address(0), account, value);
1130   }
1131 
1132   /**
1133     * @dev Internal function that burns an amount of the token of a given
1134     * account.
1135     * @param account The account whose tokens will be burnt.
1136     * @param value The amount that will be burnt.
1137     */
1138   function _burn(address account, uint256 value) internal {
1139     require(account != address(0));
1140 
1141     _totalSupply = _totalSupply.sub(value);
1142     _balances[account] = _balances[account].sub(value);
1143     emit Transfer(account, address(0), value);
1144   }
1145 
1146   /**
1147     * @dev Internal function that burns an amount of the token of a given
1148     * account, deducting from the sender's allowance for said account. Uses the
1149     * internal burn function.
1150     * @param account The account whose tokens will be burnt.
1151     * @param value The amount that will be burnt.
1152     */
1153   function _burnFrom(address account, uint256 value) internal {
1154     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
1155     // this function needs to emit an event with the updated approval.
1156     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
1157     _burn(account, value);
1158   }
1159 }
1160 
1161 // File: contracts/zeppelin-solidity/token/ERC20/ERC20Detailed.sol
1162 
1163 pragma solidity ^0.4.24;
1164 
1165 
1166 /**
1167  * @title ERC20Detailed token
1168  * @dev The decimals are only for visualization purposes.
1169  * All the operations are done using the smallest and indivisible token unit,
1170  * just as on Ethereum all the operations are done in wei.
1171  */
1172 contract ERC20Detailed is IERC20 {
1173   string private _name;
1174   string private _symbol;
1175   uint8 private _decimals;
1176 
1177   constructor (string name, string symbol, uint8 decimals) public {
1178     _name = name;
1179     _symbol = symbol;
1180     _decimals = decimals;
1181   }
1182 
1183   /**
1184     * @return the name of the token.
1185     */
1186   function name() public view returns (string) {
1187     return _name;
1188   }
1189 
1190   /**
1191     * @return the symbol of the token.
1192     */
1193   function symbol() public view returns (string) {
1194     return _symbol;
1195   }
1196 
1197   /**
1198     * @return the number of decimals of the token.
1199     */
1200   function decimals() public view returns (uint8) {
1201     return _decimals;
1202   }
1203 }
1204 
1205 // File: contracts/token/CVLToken.sol
1206 
1207 pragma solidity ^0.4.24;
1208 
1209 
1210 
1211 
1212 
1213 
1214 /// @title Extendable reference implementation for the ERC-1404 token
1215 /// @dev Inherit from this contract to implement your own ERC-1404 token
1216 contract CVLToken is ERC20, ERC20Detailed, Ownable, ERC1404 {
1217 
1218   ERC1404 public controller;
1219 
1220   constructor (uint256 _initialAmount,
1221     string _tokenName,
1222     uint8 _decimalUnits,
1223     string _tokenSymbol,
1224     ERC1404 _controller
1225     ) public ERC20Detailed(_tokenName, _tokenSymbol, _decimalUnits) {
1226     require(address(_controller) != address(0), "controller not provided");
1227     controller = _controller;
1228     _mint(msg.sender, _initialAmount);              // Give the creator all initial tokens
1229   }
1230 
1231   modifier onlyOwner () {
1232     require(msg.sender == owner, "not owner");
1233     _;
1234   }
1235 
1236   function changeController(ERC1404 _controller) public onlyOwner {
1237     require(address(_controller) != address(0), "controller not provided");
1238     controller = _controller;
1239   }
1240 
1241   modifier notRestricted (address from, address to, uint256 value) {
1242     require(controller.detectTransferRestriction(from, to, value) == 0, "token transfer restricted");
1243     _;
1244   }
1245 
1246   function transfer (address to, uint256 value)
1247       public
1248       notRestricted(msg.sender, to, value)
1249       returns (bool success)
1250   {
1251     success = super.transfer(to, value);
1252   }
1253 
1254   function transferFrom (address from, address to, uint256 value)
1255       public
1256       notRestricted(from, to, value)
1257       returns (bool success)
1258   {
1259     success = super.transferFrom(from, to, value);
1260   }
1261 
1262   function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8) {
1263     return controller.detectTransferRestriction(from, to, value);
1264   }
1265 
1266   function messageForTransferRestriction (uint8 restrictionCode) public view returns (string) {
1267     return controller.messageForTransferRestriction(restrictionCode);
1268   }
1269 
1270 
1271 }