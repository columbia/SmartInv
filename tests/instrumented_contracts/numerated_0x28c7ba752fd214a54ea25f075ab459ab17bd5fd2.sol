1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 /**
45  * @dev Pulled from OpenZeppelin: https://git.io/vbaRf
46  *   When this is in a public release we will switch to not vendoring this file
47  *
48  * @title Eliptic curve signature operations
49  *
50  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
51  */
52 
53 library ECRecovery {
54 
55   /**
56    * @dev Recover signer address from a message by using his signature
57    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
58    * @param sig bytes signature, the signature is generated using web3.eth.sign()
59    */
60   function recover(bytes32 hash, bytes sig) public pure returns (address) {
61     bytes32 r;
62     bytes32 s;
63     uint8 v;
64 
65     //Check the signature length
66     if (sig.length != 65) {
67       return (address(0));
68     }
69 
70     // Extracting these values isn't possible without assembly
71     // solhint-disable no-inline-assembly
72     // Divide the signature in r, s and v variables
73     assembly {
74       r := mload(add(sig, 32))
75       s := mload(add(sig, 64))
76       v := byte(0, mload(add(sig, 96)))
77     }
78 
79     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
80     if (v < 27) {
81       v += 27;
82     }
83 
84     // If the version is correct return the signer address
85     if (v != 27 && v != 28) {
86       return (address(0));
87     } else {
88       return ecrecover(hash, v, r, s);
89     }
90   }
91 
92 }
93 
94 
95 /**
96  * @title SigningLogic is contract implementing signature recovery from typed data signatures
97  * @notice Recovers signatures based on the SignTypedData implementation provided by ethSigUtil
98  * @dev This contract is inherited by other contracts.
99  */
100 contract SigningLogic {
101 
102   // Signatures contain a nonce to make them unique. usedSignatures tracks which signatures
103   //  have been used so they can't be replayed
104   mapping (bytes32 => bool) public usedSignatures;
105 
106   function burnSignatureDigest(bytes32 _signatureDigest, address _sender) internal {
107     bytes32 _txDataHash = keccak256(abi.encode(_signatureDigest, _sender));
108     require(!usedSignatures[_txDataHash], "Signature not unique");
109     usedSignatures[_txDataHash] = true;
110   }
111 
112   bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256(
113     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
114   );
115 
116   bytes32 constant ATTESTATION_REQUEST_TYPEHASH = keccak256(
117     "AttestationRequest(bytes32 dataHash,bytes32 nonce)"
118   );
119 
120   bytes32 constant ADD_ADDRESS_TYPEHASH = keccak256(
121     "AddAddress(address addressToAdd,bytes32 nonce)"
122   );
123 
124   bytes32 constant REMOVE_ADDRESS_TYPEHASH = keccak256(
125     "RemoveAddress(address addressToRemove,bytes32 nonce)"
126   );
127 
128   bytes32 constant PAY_TOKENS_TYPEHASH = keccak256(
129     "PayTokens(address sender,address receiver,uint256 amount,bytes32 nonce)"
130   );
131 
132   bytes32 constant RELEASE_TOKENS_FOR_TYPEHASH = keccak256(
133     "ReleaseTokensFor(address sender,uint256 amount,bytes32 nonce)"
134   );
135 
136   bytes32 constant ATTEST_FOR_TYPEHASH = keccak256(
137     "AttestFor(address subject,address requester,uint256 reward,bytes32 dataHash,bytes32 requestNonce)"
138   );
139 
140   bytes32 constant CONTEST_FOR_TYPEHASH = keccak256(
141     "ContestFor(address requester,uint256 reward,bytes32 requestNonce)"
142   );
143 
144   bytes32 constant REVOKE_ATTESTATION_FOR_TYPEHASH = keccak256(
145     "RevokeAttestationFor(bytes32 link,bytes32 nonce)"
146   );
147 
148   bytes32 constant VOTE_FOR_TYPEHASH = keccak256(
149     "VoteFor(uint16 choice,address voter,bytes32 nonce,address poll)"
150   );
151 
152   bytes32 constant LOCKUP_TOKENS_FOR_TYPEHASH = keccak256(
153     "LockupTokensFor(address sender,uint256 amount,bytes32 nonce)"
154   );
155 
156   bytes32 DOMAIN_SEPARATOR;
157 
158   constructor (string name, string version, uint256 chainId) public {
159     DOMAIN_SEPARATOR = hash(EIP712Domain({
160       name: name,
161       version: version,
162       chainId: chainId,
163       verifyingContract: this
164     }));
165   }
166 
167   struct EIP712Domain {
168       string  name;
169       string  version;
170       uint256 chainId;
171       address verifyingContract;
172   }
173 
174   function hash(EIP712Domain eip712Domain) private pure returns (bytes32) {
175     return keccak256(abi.encode(
176       EIP712DOMAIN_TYPEHASH,
177       keccak256(bytes(eip712Domain.name)),
178       keccak256(bytes(eip712Domain.version)),
179       eip712Domain.chainId,
180       eip712Domain.verifyingContract
181     ));
182   }
183 
184   struct AttestationRequest {
185       bytes32 dataHash;
186       bytes32 nonce;
187   }
188 
189   function hash(AttestationRequest request) private pure returns (bytes32) {
190     return keccak256(abi.encode(
191       ATTESTATION_REQUEST_TYPEHASH,
192       request.dataHash,
193       request.nonce
194     ));
195   }
196 
197   struct AddAddress {
198       address addressToAdd;
199       bytes32 nonce;
200   }
201 
202   function hash(AddAddress request) private pure returns (bytes32) {
203     return keccak256(abi.encode(
204       ADD_ADDRESS_TYPEHASH,
205       request.addressToAdd,
206       request.nonce
207     ));
208   }
209 
210   struct RemoveAddress {
211       address addressToRemove;
212       bytes32 nonce;
213   }
214 
215   function hash(RemoveAddress request) private pure returns (bytes32) {
216     return keccak256(abi.encode(
217       REMOVE_ADDRESS_TYPEHASH,
218       request.addressToRemove,
219       request.nonce
220     ));
221   }
222 
223   struct PayTokens {
224       address sender;
225       address receiver;
226       uint256 amount;
227       bytes32 nonce;
228   }
229 
230   function hash(PayTokens request) private pure returns (bytes32) {
231     return keccak256(abi.encode(
232       PAY_TOKENS_TYPEHASH,
233       request.sender,
234       request.receiver,
235       request.amount,
236       request.nonce
237     ));
238   }
239 
240   struct AttestFor {
241       address subject;
242       address requester;
243       uint256 reward;
244       bytes32 dataHash;
245       bytes32 requestNonce;
246   }
247 
248   function hash(AttestFor request) private pure returns (bytes32) {
249     return keccak256(abi.encode(
250       ATTEST_FOR_TYPEHASH,
251       request.subject,
252       request.requester,
253       request.reward,
254       request.dataHash,
255       request.requestNonce
256     ));
257   }
258 
259   struct ContestFor {
260       address requester;
261       uint256 reward;
262       bytes32 requestNonce;
263   }
264 
265   function hash(ContestFor request) private pure returns (bytes32) {
266     return keccak256(abi.encode(
267       CONTEST_FOR_TYPEHASH,
268       request.requester,
269       request.reward,
270       request.requestNonce
271     ));
272   }
273 
274   struct RevokeAttestationFor {
275       bytes32 link;
276       bytes32 nonce;
277   }
278 
279   function hash(RevokeAttestationFor request) private pure returns (bytes32) {
280     return keccak256(abi.encode(
281       REVOKE_ATTESTATION_FOR_TYPEHASH,
282       request.link,
283       request.nonce
284     ));
285   }
286 
287   struct VoteFor {
288       uint16 choice;
289       address voter;
290       bytes32 nonce;
291       address poll;
292   }
293 
294   function hash(VoteFor request) private pure returns (bytes32) {
295     return keccak256(abi.encode(
296       VOTE_FOR_TYPEHASH,
297       request.choice,
298       request.voter,
299       request.nonce,
300       request.poll
301     ));
302   }
303 
304   struct LockupTokensFor {
305     address sender;
306     uint256 amount;
307     bytes32 nonce;
308   }
309 
310   function hash(LockupTokensFor request) private pure returns (bytes32) {
311     return keccak256(abi.encode(
312       LOCKUP_TOKENS_FOR_TYPEHASH,
313       request.sender,
314       request.amount,
315       request.nonce
316     ));
317   }
318 
319   struct ReleaseTokensFor {
320     address sender;
321     uint256 amount;
322     bytes32 nonce;
323   }
324 
325   function hash(ReleaseTokensFor request) private pure returns (bytes32) {
326     return keccak256(abi.encode(
327       RELEASE_TOKENS_FOR_TYPEHASH,
328       request.sender,
329       request.amount,
330       request.nonce
331     ));
332   }
333 
334   function generateRequestAttestationSchemaHash(
335     bytes32 _dataHash,
336     bytes32 _nonce
337   ) internal view returns (bytes32) {
338     return keccak256(
339       abi.encodePacked(
340         "\x19\x01",
341         DOMAIN_SEPARATOR,
342         hash(AttestationRequest(
343           _dataHash,
344           _nonce
345         ))
346       )
347       );
348   }
349 
350   function generateAddAddressSchemaHash(
351     address _addressToAdd,
352     bytes32 _nonce
353   ) internal view returns (bytes32) {
354     return keccak256(
355       abi.encodePacked(
356         "\x19\x01",
357         DOMAIN_SEPARATOR,
358         hash(AddAddress(
359           _addressToAdd,
360           _nonce
361         ))
362       )
363       );
364   }
365 
366   function generateRemoveAddressSchemaHash(
367     address _addressToRemove,
368     bytes32 _nonce
369   ) internal view returns (bytes32) {
370     return keccak256(
371       abi.encodePacked(
372         "\x19\x01",
373         DOMAIN_SEPARATOR,
374         hash(RemoveAddress(
375           _addressToRemove,
376           _nonce
377         ))
378       )
379       );
380   }
381 
382   function generatePayTokensSchemaHash(
383     address _sender,
384     address _receiver,
385     uint256 _amount,
386     bytes32 _nonce
387   ) internal view returns (bytes32) {
388     return keccak256(
389       abi.encodePacked(
390         "\x19\x01",
391         DOMAIN_SEPARATOR,
392         hash(PayTokens(
393           _sender,
394           _receiver,
395           _amount,
396           _nonce
397         ))
398       )
399       );
400   }
401 
402   function generateAttestForDelegationSchemaHash(
403     address _subject,
404     address _requester,
405     uint256 _reward,
406     bytes32 _dataHash,
407     bytes32 _requestNonce
408   ) internal view returns (bytes32) {
409     return keccak256(
410       abi.encodePacked(
411         "\x19\x01",
412         DOMAIN_SEPARATOR,
413         hash(AttestFor(
414           _subject,
415           _requester,
416           _reward,
417           _dataHash,
418           _requestNonce
419         ))
420       )
421       );
422   }
423 
424   function generateContestForDelegationSchemaHash(
425     address _requester,
426     uint256 _reward,
427     bytes32 _requestNonce
428   ) internal view returns (bytes32) {
429     return keccak256(
430       abi.encodePacked(
431         "\x19\x01",
432         DOMAIN_SEPARATOR,
433         hash(ContestFor(
434           _requester,
435           _reward,
436           _requestNonce
437         ))
438       )
439       );
440   }
441 
442   function generateRevokeAttestationForDelegationSchemaHash(
443     bytes32 _link,
444     bytes32 _nonce
445   ) internal view returns (bytes32) {
446     return keccak256(
447       abi.encodePacked(
448         "\x19\x01",
449         DOMAIN_SEPARATOR,
450         hash(RevokeAttestationFor(
451           _link,
452           _nonce
453         ))
454       )
455       );
456   }
457 
458   function generateVoteForDelegationSchemaHash(
459     uint16 _choice,
460     address _voter,
461     bytes32 _nonce,
462     address _poll
463   ) internal view returns (bytes32) {
464     return keccak256(
465       abi.encodePacked(
466         "\x19\x01",
467         DOMAIN_SEPARATOR,
468         hash(VoteFor(
469           _choice,
470           _voter,
471           _nonce,
472           _poll
473         ))
474       )
475       );
476   }
477 
478   function generateLockupTokensDelegationSchemaHash(
479     address _sender,
480     uint256 _amount,
481     bytes32 _nonce
482   ) internal view returns (bytes32) {
483     return keccak256(
484       abi.encodePacked(
485         "\x19\x01",
486         DOMAIN_SEPARATOR,
487         hash(LockupTokensFor(
488           _sender,
489           _amount,
490           _nonce
491         ))
492       )
493       );
494   }
495 
496   function generateReleaseTokensDelegationSchemaHash(
497     address _sender,
498     uint256 _amount,
499     bytes32 _nonce
500   ) internal view returns (bytes32) {
501     return keccak256(
502       abi.encodePacked(
503         "\x19\x01",
504         DOMAIN_SEPARATOR,
505         hash(ReleaseTokensFor(
506           _sender,
507           _amount,
508           _nonce
509         ))
510       )
511       );
512   }
513 
514   function recoverSigner(bytes32 _hash, bytes _sig) internal pure returns (address) {
515     address signer = ECRecovery.recover(_hash, _sig);
516     require(signer != address(0));
517 
518     return signer;
519   }
520 }
521 
522 
523 /**
524  * @title Initializable
525  * @dev The Initializable contract has an initializer address, and provides basic authorization control
526  * only while in initialization mode. Once changed to production mode the inializer loses authority
527  */
528 contract Initializable {
529   address public initializer;
530   bool public initializing;
531 
532   event InitializationEnded();
533 
534   /**
535    * @dev The Initializable constructor sets the initializer to the provided address
536    */
537   constructor(address _initializer) public {
538     initializer = _initializer;
539     initializing = true;
540   }
541 
542   /**
543    * @dev Throws if called by any account other than the owner.
544    */
545   modifier onlyDuringInitialization() {
546     require(msg.sender == initializer, 'Method can only be called by initializer');
547     require(initializing, 'Method can only be called during initialization');
548     _;
549   }
550 
551   /**
552    * @dev Allows the initializer to end the initialization period
553    */
554   function endInitialization() public onlyDuringInitialization {
555     initializing = false;
556     emit InitializationEnded();
557   }
558 
559 }
560 
561 
562 /**
563  * @title Bloom account registry
564  * @notice Account Registry Logic allows users to link multiple addresses to the same owner
565  *
566  */
567 contract AccountRegistryLogic is Initializable, SigningLogic {
568   /**
569    * @notice The AccountRegistry constructor configures the signing logic implementation
570    */
571   constructor(
572     address _initializer
573   ) public Initializable(_initializer) SigningLogic("Bloom Account Registry", "2", 1) {}
574 
575   event AddressLinked(address indexed currentAddress, address indexed newAddress, uint256 indexed linkId);
576   event AddressUnlinked(address indexed addressToRemove);
577 
578   // Counter to generate unique link Ids
579   uint256 linkCounter;
580   mapping(address => uint256) public linkIds;
581 
582   /**
583    * @notice Add an address to an existing id on behalf of a user to pay the gas costs
584    * @param _currentAddress Address to which user wants to link another address. May currently be linked to another address
585    * @param _currentAddressSig Signed message from address currently associated with account confirming intention
586    * @param _newAddress Address to add to account. Cannot currently be linked to another address
587    * @param _newAddressSig Signed message from new address confirming ownership by the sender
588    * @param _nonce hex string used when generating sigs to make them one time use
589    */
590   function linkAddresses(
591     address _currentAddress,
592     bytes _currentAddressSig,
593     address _newAddress,
594     bytes _newAddressSig,
595     bytes32 _nonce
596     ) external {
597       // Confirm newAddress is not linked to another account
598       require(linkIds[_newAddress] == 0);
599       // Confirm new address is signed by current address and is unused
600       validateLinkSignature(_currentAddress, _newAddress, _nonce, _currentAddressSig);
601 
602       // Confirm current address is signed by new address and is unused
603       validateLinkSignature(_newAddress, _currentAddress, _nonce, _newAddressSig);
604 
605       // Get linkId of current address if exists. Otherwise use incremented linkCounter
606       if (linkIds[_currentAddress] == 0) {
607         linkIds[_currentAddress] = ++linkCounter;
608       }
609       linkIds[_newAddress] = linkIds[_currentAddress];
610 
611       emit AddressLinked(_currentAddress, _newAddress, linkIds[_currentAddress]);
612   }
613 
614   /**
615    * @notice Remove an address from a link relationship
616    * @param _addressToRemove Address to unlink from all other addresses
617    * @param _unlinkSignature Signed message from address currently associated with account confirming intention to unlink
618    * @param _nonce hex string used when generating sigs to make them one time use
619    */
620   function unlinkAddress(
621     address _addressToRemove,
622     bytes32 _nonce,
623     bytes _unlinkSignature
624   ) external {
625     // Confirm unlink request is signed by sender and is unused
626     validateUnlinkSignature(_addressToRemove, _nonce, _unlinkSignature);
627     linkIds[_addressToRemove] = 0;
628 
629     emit AddressUnlinked(_addressToRemove);
630   }
631 
632   /**
633    * @notice Verify link signature is valid and unused V
634    * @param _currentAddress Address signing intention to link
635    * @param _addressToAdd Address being linked
636    * @param _nonce Unique nonce for this request
637    * @param _linkSignature Signature of address a
638    */
639   function validateLinkSignature(
640     address _currentAddress,
641     address _addressToAdd,
642     bytes32 _nonce,
643     bytes _linkSignature
644   ) private {
645     bytes32 _signatureDigest = generateAddAddressSchemaHash(_addressToAdd, _nonce);
646     require(_currentAddress == recoverSigner(_signatureDigest, _linkSignature));
647     burnSignatureDigest(_signatureDigest, _currentAddress);
648   }
649 
650   /**
651    * @notice Verify unlink signature is valid and unused 
652    * @param _addressToRemove Address being unlinked
653    * @param _nonce Unique nonce for this request
654    * @param _unlinkSignature Signature of senderAddress
655    */
656   function validateUnlinkSignature(
657     address _addressToRemove,
658     bytes32 _nonce,
659     bytes _unlinkSignature
660   ) private {
661 
662     // require that address to remove is currently linked to senderAddress
663     require(linkIds[_addressToRemove] != 0, "Address does not have active link");
664 
665     bytes32 _signatureDigest = generateRemoveAddressSchemaHash(_addressToRemove, _nonce);
666 
667     require(_addressToRemove == recoverSigner(_signatureDigest, _unlinkSignature));
668     burnSignatureDigest(_signatureDigest, _addressToRemove);
669   }
670 
671   /**
672    * @notice Submit link completed prior to deployment of this contract
673    * @dev Gives initializer privileges to write links during the initialization period without signatures
674    * @param _currentAddress Address to which user wants to link another address. May currently be linked to another address
675    * @param _newAddress Address to add to account. Cannot currently be linked to another address
676    */
677   function migrateLink(
678     address _currentAddress,
679     address _newAddress
680   ) external onlyDuringInitialization {
681     // Confirm newAddress is not linked to another account
682     require(linkIds[_newAddress] == 0);
683 
684     // Get linkId of current address if exists. Otherwise use incremented linkCounter
685     if (linkIds[_currentAddress] == 0) {
686       linkIds[_currentAddress] = ++linkCounter;
687     }
688     linkIds[_newAddress] = linkIds[_currentAddress];
689 
690     emit AddressLinked(_currentAddress, _newAddress, linkIds[_currentAddress]);
691   }
692 
693 }
694 
695 /**
696  * @title AttestationLogic allows users to submit attestations given valid signatures
697  * @notice Attestation Logic Logic provides a public interface for Bloom and
698  *  users to submit attestations.
699  */
700 contract AttestationLogic is Initializable, SigningLogic{
701     TokenEscrowMarketplace public tokenEscrowMarketplace;
702 
703   /**
704    * @notice AttestationLogic constructor sets the implementation address of all related contracts
705    * @param _tokenEscrowMarketplace Address of marketplace holding tokens which are
706    *  released to attesters upon completion of a job
707    */
708   constructor(
709     address _initializer,
710     TokenEscrowMarketplace _tokenEscrowMarketplace
711     ) Initializable(_initializer) SigningLogic("Bloom Attestation Logic", "2", 1) public {
712     tokenEscrowMarketplace = _tokenEscrowMarketplace;
713   }
714 
715   event TraitAttested(
716     address subject,
717     address attester,
718     address requester,
719     bytes32 dataHash
720     );
721   event AttestationRejected(address indexed attester, address indexed requester);
722   event AttestationRevoked(bytes32 link, address attester);
723   event TokenEscrowMarketplaceChanged(address oldTokenEscrowMarketplace, address newTokenEscrowMarketplace);
724 
725   /**
726    * @notice Function for attester to submit attestation from their own account) 
727    * @dev Wrapper for attestForUser using msg.sender
728    * @param _subject User this attestation is about
729    * @param _requester User requesting and paying for this attestation in BLT
730    * @param _reward Payment to attester from requester in BLT
731    * @param _requesterSig Signature authorizing payment from requester to attester
732    * @param _dataHash Hash of data being attested and nonce
733    * @param _requestNonce Nonce in sig signed by subject and requester so they can't be replayed
734    * @param _subjectSig Signed authorization from subject with attestation agreement
735    */
736   function attest(
737     address _subject,
738     address _requester,
739     uint256 _reward,
740     bytes _requesterSig,
741     bytes32 _dataHash,
742     bytes32 _requestNonce,
743     bytes _subjectSig // Sig of subject with requester, attester, dataHash, requestNonce
744   ) external {
745     attestForUser(
746       _subject,
747       msg.sender,
748       _requester,
749       _reward,
750       _requesterSig,
751       _dataHash,
752       _requestNonce,
753       _subjectSig
754     );
755   }
756 
757   /**
758    * @notice Submit attestation for a user in order to pay the gas costs
759    * @dev Recover signer of delegation message. If attester matches delegation signature, add the attestation
760    * @param _subject user this attestation is about
761    * @param _attester user completing the attestation
762    * @param _requester user requesting this attestation be completed and paying for it in BLT
763    * @param _reward payment to attester from requester in BLT wei
764    * @param _requesterSig signature authorizing payment from requester to attester
765    * @param _dataHash hash of data being attested and nonce
766    * @param _requestNonce Nonce in sig signed by subject and requester so they can't be replayed
767    * @param _subjectSig signed authorization from subject with attestation agreement
768    * @param _delegationSig signature authorizing attestation on behalf of attester
769    */
770   function attestFor(
771     address _subject,
772     address _attester,
773     address _requester,
774     uint256 _reward,
775     bytes _requesterSig,
776     bytes32 _dataHash,
777     bytes32 _requestNonce,
778     bytes _subjectSig, // Sig of subject with dataHash and requestNonce
779     bytes _delegationSig
780   ) external {
781     // Confirm attester address matches recovered address from signature
782     validateAttestForSig(_subject, _attester, _requester, _reward, _dataHash, _requestNonce, _delegationSig);
783     attestForUser(
784       _subject,
785       _attester,
786       _requester,
787       _reward,
788       _requesterSig,
789       _dataHash,
790       _requestNonce,
791       _subjectSig
792     );
793   }
794 
795   /**
796    * @notice Perform attestation
797    * @dev Verify valid certainty level and user addresses
798    * @param _subject user this attestation is about
799    * @param _attester user completing the attestation
800    * @param _requester user requesting this attestation be completed and paying for it in BLT
801    * @param _reward payment to attester from requester in BLT wei
802    * @param _requesterSig signature authorizing payment from requester to attester
803    * @param _dataHash hash of data being attested and nonce
804    * @param _requestNonce Nonce in sig signed by subject and requester so they can't be replayed
805    * @param _subjectSig signed authorization from subject with attestation agreement
806    */
807   function attestForUser(
808     address _subject,
809     address _attester,
810     address _requester,
811     uint256 _reward,
812     bytes _requesterSig,
813     bytes32 _dataHash,
814     bytes32 _requestNonce,
815     bytes _subjectSig
816     ) private {
817     
818     validateSubjectSig(
819       _subject,
820       _dataHash,
821       _requestNonce,
822       _subjectSig
823     );
824 
825     emit TraitAttested(
826       _subject,
827       _attester,
828       _requester,
829       _dataHash
830     );
831 
832     if (_reward > 0) {
833       tokenEscrowMarketplace.requestTokenPayment(_requester, _attester, _reward, _requestNonce, _requesterSig);
834     }
835   }
836 
837   /**
838    * @notice Function for attester to reject an attestation and receive payment 
839    *  without associating the negative attestation with the subject's bloomId
840    * @param _requester User requesting and paying for this attestation in BLT
841    * @param _reward Payment to attester from requester in BLT
842    * @param _requestNonce Nonce in sig signed by requester so it can't be replayed
843    * @param _requesterSig Signature authorizing payment from requester to attester
844    */
845   function contest(
846     address _requester,
847     uint256 _reward,
848     bytes32 _requestNonce,
849     bytes _requesterSig
850   ) external {
851     contestForUser(
852       msg.sender,
853       _requester,
854       _reward,
855       _requestNonce,
856       _requesterSig
857     );
858   }
859 
860   /**
861    * @notice Function for attester to reject an attestation and receive payment 
862    *  without associating the negative attestation with the subject's bloomId
863    *  Perform on behalf of attester to pay gas fees
864    * @param _requester User requesting and paying for this attestation in BLT
865    * @param _attester user completing the attestation
866    * @param _reward Payment to attester from requester in BLT
867    * @param _requestNonce Nonce in sig signed by requester so it can't be replayed
868    * @param _requesterSig Signature authorizing payment from requester to attester
869    */
870   function contestFor(
871     address _attester,
872     address _requester,
873     uint256 _reward,
874     bytes32 _requestNonce,
875     bytes _requesterSig,
876     bytes _delegationSig
877   ) external {
878     validateContestForSig(
879       _attester,
880       _requester,
881       _reward,
882       _requestNonce,
883       _delegationSig
884     );
885     contestForUser(
886       _attester,
887       _requester,
888       _reward,
889       _requestNonce,
890       _requesterSig
891     );
892   }
893 
894   /**
895    * @notice Private function for attester to reject an attestation and receive payment 
896    *  without associating the negative attestation with the subject's bloomId
897    * @param _attester user completing the attestation
898    * @param _requester user requesting this attestation be completed and paying for it in BLT
899    * @param _reward payment to attester from requester in BLT wei
900    * @param _requestNonce Nonce in sig signed by requester so it can't be replayed
901    * @param _requesterSig signature authorizing payment from requester to attester
902    */
903   function contestForUser(
904     address _attester,
905     address _requester,
906     uint256 _reward,
907     bytes32 _requestNonce,
908     bytes _requesterSig
909     ) private {
910 
911     if (_reward > 0) {
912       tokenEscrowMarketplace.requestTokenPayment(_requester, _attester, _reward, _requestNonce, _requesterSig);
913     }
914     emit AttestationRejected(_attester, _requester);
915   }
916 
917   /**
918    * @notice Verify subject signature is valid 
919    * @param _subject user this attestation is about
920    * @param _dataHash hash of data being attested and nonce
921    * param _requestNonce Nonce in sig signed by subject so it can't be replayed
922    * @param _subjectSig Signed authorization from subject with attestation agreement
923    */
924   function validateSubjectSig(
925     address _subject,
926     bytes32 _dataHash,
927     bytes32 _requestNonce,
928     bytes _subjectSig
929   ) private {
930     bytes32 _signatureDigest = generateRequestAttestationSchemaHash(_dataHash, _requestNonce);
931     require(_subject == recoverSigner(_signatureDigest, _subjectSig));
932     burnSignatureDigest(_signatureDigest, _subject);
933   }
934 
935   /**
936    * @notice Verify attester delegation signature is valid 
937    * @param _subject user this attestation is about
938    * @param _attester user completing the attestation
939    * @param _requester user requesting this attestation be completed and paying for it in BLT
940    * @param _reward payment to attester from requester in BLT wei
941    * @param _dataHash hash of data being attested and nonce
942    * @param _requestNonce nonce in sig signed by subject so it can't be replayed
943    * @param _delegationSig signature authorizing attestation on behalf of attester
944    */
945   function validateAttestForSig(
946     address _subject,
947     address _attester,
948     address _requester,
949     uint256 _reward,
950     bytes32 _dataHash,
951     bytes32 _requestNonce,
952     bytes _delegationSig
953   ) private {
954     bytes32 _delegationDigest = generateAttestForDelegationSchemaHash(_subject, _requester, _reward, _dataHash, _requestNonce);
955     require(_attester == recoverSigner(_delegationDigest, _delegationSig), 'Invalid AttestFor Signature');
956     burnSignatureDigest(_delegationDigest, _attester);
957   }
958 
959   /**
960    * @notice Verify attester delegation signature is valid 
961    * @param _attester user completing the attestation
962    * @param _requester user requesting this attestation be completed and paying for it in BLT
963    * @param _reward payment to attester from requester in BLT wei
964    * @param _requestNonce nonce referenced in TokenEscrowMarketplace so payment sig can't be replayed
965    * @param _delegationSig signature authorizing attestation on behalf of attester
966    */
967   function validateContestForSig(
968     address _attester,
969     address _requester,
970     uint256 _reward,
971     bytes32 _requestNonce,
972     bytes _delegationSig
973   ) private {
974     bytes32 _delegationDigest = generateContestForDelegationSchemaHash(_requester, _reward, _requestNonce);
975     require(_attester == recoverSigner(_delegationDigest, _delegationSig), 'Invalid ContestFor Signature');
976     burnSignatureDigest(_delegationDigest, _attester);
977   }
978 
979   /**
980    * @notice Submit attestation completed prior to deployment of this contract
981    * @dev Gives initializer privileges to write attestations during the initialization period without signatures
982    * @param _requester user requesting this attestation be completed 
983    * @param _attester user completing the attestation
984    * @param _subject user this attestation is about
985    * @param _dataHash hash of data being attested
986    */
987   function migrateAttestation(
988     address _requester,
989     address _attester,
990     address _subject,
991     bytes32 _dataHash
992   ) public onlyDuringInitialization {
993     emit TraitAttested(
994       _subject,
995       _attester,
996       _requester,
997       _dataHash
998     );
999   }
1000 
1001   /**
1002    * @notice Revoke an attestation
1003    * @dev Link is included in dataHash and cannot be directly connected to a BloomID
1004    * @param _link bytes string embedded in dataHash to link revocation
1005    */
1006   function revokeAttestation(
1007     bytes32 _link
1008     ) external {
1009       revokeAttestationForUser(_link, msg.sender);
1010   }
1011 
1012   /**
1013    * @notice Revoke an attestation
1014    * @dev Link is included in dataHash and cannot be directly connected to a BloomID
1015    * @param _link bytes string embedded in dataHash to link revocation
1016    */
1017   function revokeAttestationFor(
1018     address _sender,
1019     bytes32 _link,
1020     bytes32 _nonce,
1021     bytes _delegationSig
1022     ) external {
1023       validateRevokeForSig(_sender, _link, _nonce, _delegationSig);
1024       revokeAttestationForUser(_link, _sender);
1025   }
1026 
1027   /**
1028    * @notice Verify revocation signature is valid 
1029    * @param _link bytes string embedded in dataHash to link revocation
1030    * @param _sender user revoking attestation
1031    * @param _delegationSig signature authorizing revocation on behalf of revoker
1032    */
1033   function validateRevokeForSig(
1034     address _sender,
1035     bytes32 _link,
1036     bytes32 _nonce,
1037     bytes _delegationSig
1038   ) private {
1039     bytes32 _delegationDigest = generateRevokeAttestationForDelegationSchemaHash(_link, _nonce);
1040     require(_sender == recoverSigner(_delegationDigest, _delegationSig), 'Invalid RevokeFor Signature');
1041     burnSignatureDigest(_delegationDigest, _sender);
1042   }
1043 
1044   /**
1045    * @notice Revoke an attestation
1046    * @dev Link is included in dataHash and cannot be directly connected to a BloomID
1047    * @param _link bytes string embedded in dataHash to link revocation
1048    * @param _sender address identify revoker
1049    */
1050   function revokeAttestationForUser(
1051     bytes32 _link,
1052     address _sender
1053     ) private {
1054       emit AttestationRevoked(_link, _sender);
1055   }
1056 
1057     /**
1058    * @notice Set the implementation of the TokenEscrowMarketplace contract by setting a new address
1059    * @dev Restricted to initializer
1060    * @param _newTokenEscrowMarketplace Address of new SigningLogic implementation
1061    */
1062   function setTokenEscrowMarketplace(TokenEscrowMarketplace _newTokenEscrowMarketplace) external onlyDuringInitialization {
1063     address oldTokenEscrowMarketplace = tokenEscrowMarketplace;
1064     tokenEscrowMarketplace = _newTokenEscrowMarketplace;
1065     emit TokenEscrowMarketplaceChanged(oldTokenEscrowMarketplace, tokenEscrowMarketplace);
1066   }
1067 
1068 }
1069 
1070 
1071 /**
1072  * @title SafeERC20
1073  * @dev Wrappers around ERC20 operations that throw on failure.
1074  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1075  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1076  */
1077 library SafeERC20 {
1078   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
1079     assert(token.transfer(to, value));
1080   }
1081 
1082   function safeTransferFrom(
1083     ERC20 token,
1084     address from,
1085     address to,
1086     uint256 value
1087   )
1088     internal
1089   {
1090     assert(token.transferFrom(from, to, value));
1091   }
1092 
1093   function safeApprove(ERC20 token, address spender, uint256 value) internal {
1094     assert(token.approve(spender, value));
1095   }
1096 }
1097 
1098 
1099 /**
1100  * @title ERC20Basic
1101  * @dev Simpler version of ERC20 interface
1102  * @dev see https://github.com/ethereum/EIPs/issues/179
1103  */
1104 contract ERC20Basic {
1105   function totalSupply() public view returns (uint256);
1106   function balanceOf(address who) public view returns (uint256);
1107   function transfer(address to, uint256 value) public returns (bool);
1108   event Transfer(address indexed from, address indexed to, uint256 value);
1109 }
1110 
1111 
1112 /**
1113  * @title ERC20 interface
1114  * @dev see https://github.com/ethereum/EIPs/issues/20
1115  */
1116 contract ERC20 is ERC20Basic {
1117   function allowance(address owner, address spender) public view returns (uint256);
1118   function transferFrom(address from, address to, uint256 value) public returns (bool);
1119   function approve(address spender, uint256 value) public returns (bool);
1120   event Approval(address indexed owner, address indexed spender, uint256 value);
1121 }
1122 
1123 
1124 
1125 /**
1126  * @title SafeMath
1127  * @dev Math operations with safety checks that throw on error
1128  */
1129 library SafeMath {
1130 
1131   /**
1132   * @dev Multiplies two numbers, throws on overflow.
1133   */
1134   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1135     if (a == 0) {
1136       return 0;
1137     }
1138     c = a * b;
1139     assert(c / a == b);
1140     return c;
1141   }
1142 
1143   /**
1144   * @dev Integer division of two numbers, truncating the quotient.
1145   */
1146   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1147     // assert(b > 0); // Solidity automatically throws when dividing by 0
1148     // uint256 c = a / b;
1149     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1150     return a / b;
1151   }
1152 
1153   /**
1154   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1155   */
1156   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1157     assert(b <= a);
1158     return a - b;
1159   }
1160 
1161   /**
1162   * @dev Adds two numbers, throws on overflow.
1163   */
1164   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1165     c = a + b;
1166     assert(c >= a);
1167     return c;
1168   }
1169 }
1170 
1171 
1172 
1173 /**
1174  * @notice TokenEscrowMarketplace is an ERC20 payment channel that enables users to send BLT by exchanging signatures off-chain
1175  *  Users approve the contract address to transfer BLT on their behalf using the standard ERC20.approve function
1176  *  After approval, either the user or the contract admin initiates the transfer of BLT into the contract
1177  *  Once in the contract, users can send payments via a signed message to another user. 
1178  *  The signature transfers BLT from lockup to the recipient's balance
1179  *  Users can withdraw funds at any time. Or the admin can release them on the user's behalf
1180  *  
1181  *  BLT is stored in the contract by address
1182  *  
1183  *  Only the AttestationLogic contract is authorized to release funds once a jobs is complete
1184  */
1185 contract TokenEscrowMarketplace is SigningLogic {
1186   using SafeERC20 for ERC20;
1187   using SafeMath for uint256;
1188 
1189   address public attestationLogic;
1190 
1191   mapping(address => uint256) public tokenEscrow;
1192   ERC20 public token;
1193 
1194   event TokenMarketplaceWithdrawal(address escrowPayer, uint256 amount);
1195   event TokenMarketplaceEscrowPayment(address escrowPayer, address escrowPayee, uint256 amount);
1196   event TokenMarketplaceDeposit(address escrowPayer, uint256 amount);
1197 
1198   /**
1199    * @notice The TokenEscrowMarketplace constructor initializes the interfaces to the other contracts
1200    * @dev Some actions are restricted to be performed by the attestationLogic contract.
1201    *  Signing logic is upgradeable in case the signTypedData spec changes
1202    * @param _token Address of BLT
1203    * @param _attestationLogic Address of current attestation logic contract
1204    */
1205   constructor(
1206     ERC20 _token,
1207     address _attestationLogic
1208     ) public SigningLogic("Bloom Token Escrow Marketplace", "2", 1) {
1209     token = _token;
1210     attestationLogic = _attestationLogic;
1211   }
1212 
1213   modifier onlyAttestationLogic() {
1214     require(msg.sender == attestationLogic);
1215     _;
1216   }
1217 
1218   /**
1219    * @notice Lockup tokens for set time period on behalf of user. Must be preceeded by approve
1220    * @dev Authorized by a signTypedData signature by sender
1221    *  Sigs can only be used once. They contain a unique nonce
1222    *  So an action can be repeated, with a different signature
1223    * @param _sender User locking up their tokens
1224    * @param _amount Tokens to lock up
1225    * @param _nonce Unique Id so signatures can't be replayed
1226    * @param _delegationSig Signed hash of these input parameters so an admin can submit this on behalf of a user
1227    */
1228   function moveTokensToEscrowLockupFor(
1229     address _sender,
1230     uint256 _amount,
1231     bytes32 _nonce,
1232     bytes _delegationSig
1233     ) external {
1234       validateLockupTokensSig(
1235         _sender,
1236         _amount,
1237         _nonce,
1238         _delegationSig
1239       );
1240       moveTokensToEscrowLockupForUser(_sender, _amount);
1241   }
1242 
1243   /**
1244    * @notice Verify lockup signature is valid
1245    * @param _sender User locking up their tokens
1246    * @param _amount Tokens to lock up
1247    * @param _nonce Unique Id so signatures can't be replayed
1248    * @param _delegationSig Signed hash of these input parameters so an admin can submit this on behalf of a user
1249    */
1250   function validateLockupTokensSig(
1251     address _sender,
1252     uint256 _amount,
1253     bytes32 _nonce,
1254     bytes _delegationSig
1255   ) private {
1256     bytes32 _signatureDigest = generateLockupTokensDelegationSchemaHash(_sender, _amount, _nonce);
1257     require(_sender == recoverSigner(_signatureDigest, _delegationSig), 'Invalid LockupTokens Signature');
1258     burnSignatureDigest(_signatureDigest, _sender);
1259   }
1260 
1261   /**
1262    * @notice Lockup tokens by user. Must be preceeded by approve
1263    * @param _amount Tokens to lock up
1264    */
1265   function moveTokensToEscrowLockup(uint256 _amount) external {
1266     moveTokensToEscrowLockupForUser(msg.sender, _amount);
1267   }
1268 
1269   /**
1270    * @notice Lockup tokens for set time. Must be preceeded by approve
1271    * @dev Private function called by appropriate public function
1272    * @param _sender User locking up their tokens
1273    * @param _amount Tokens to lock up
1274    */
1275   function moveTokensToEscrowLockupForUser(
1276     address _sender,
1277     uint256 _amount
1278     ) private {
1279     token.safeTransferFrom(_sender, this, _amount);
1280     addToEscrow(_sender, _amount);
1281   }
1282 
1283   /**
1284    * @notice Withdraw tokens from escrow back to requester
1285    * @dev Authorized by a signTypedData signature by sender
1286    *  Sigs can only be used once. They contain a unique nonce
1287    *  So an action can be repeated, with a different signature
1288    * @param _sender User withdrawing their tokens
1289    * @param _amount Tokens to withdraw
1290    * @param _nonce Unique Id so signatures can't be replayed
1291    * @param _delegationSig Signed hash of these input parameters so an admin can submit this on behalf of a user
1292    */
1293   function releaseTokensFromEscrowFor(
1294     address _sender,
1295     uint256 _amount,
1296     bytes32 _nonce,
1297     bytes _delegationSig
1298     ) external {
1299       validateReleaseTokensSig(
1300         _sender,
1301         _amount,
1302         _nonce,
1303         _delegationSig
1304       );
1305       releaseTokensFromEscrowForUser(_sender, _amount);
1306   }
1307 
1308   /**
1309    * @notice Verify lockup signature is valid
1310    * @param _sender User withdrawing their tokens
1311    * @param _amount Tokens to lock up
1312    * @param _nonce Unique Id so signatures can't be replayed
1313    * @param _delegationSig Signed hash of these input parameters so an admin can submit this on behalf of a user
1314    */
1315   function validateReleaseTokensSig(
1316     address _sender,
1317     uint256 _amount,
1318     bytes32 _nonce,
1319     bytes _delegationSig
1320 
1321   ) private {
1322     bytes32 _signatureDigest = generateReleaseTokensDelegationSchemaHash(_sender, _amount, _nonce);
1323     require(_sender == recoverSigner(_signatureDigest, _delegationSig), 'Invalid ReleaseTokens Signature');
1324     burnSignatureDigest(_signatureDigest, _sender);
1325   }
1326 
1327   /**
1328    * @notice Release tokens back to payer's available balance if lockup expires
1329    * @dev Token balance retreived by accountId. Can be different address from the one that deposited tokens
1330    * @param _amount Tokens to retreive from escrow
1331    */
1332   function releaseTokensFromEscrow(uint256 _amount) external {
1333     releaseTokensFromEscrowForUser(msg.sender, _amount);
1334   }
1335 
1336   /**
1337    * @notice Release tokens back to payer's available balance
1338    * @param _payer User retreiving tokens from escrow
1339    * @param _amount Tokens to retreive from escrow
1340    */
1341   function releaseTokensFromEscrowForUser(
1342     address _payer,
1343     uint256 _amount
1344     ) private {
1345       subFromEscrow(_payer, _amount);
1346       token.safeTransfer(_payer, _amount);
1347       emit TokenMarketplaceWithdrawal(_payer, _amount);
1348   }
1349 
1350   /**
1351    * @notice Pay from escrow of payer to available balance of receiever
1352    * @dev Private function to modify balances on payment
1353    * @param _payer User with tokens in escrow
1354    * @param _receiver User receiving tokens
1355    * @param _amount Tokens being sent
1356    */
1357   function payTokensFromEscrow(address _payer, address _receiver, uint256 _amount) private {
1358     subFromEscrow(_payer, _amount);
1359     token.safeTransfer(_receiver, _amount);
1360   }
1361 
1362   /**
1363    * @notice Pay tokens to receiver from payer's escrow given a valid signature
1364    * @dev Execution restricted to attestationLogic contract
1365    * @param _payer User paying tokens from escrow
1366    * @param _receiver User receiving payment
1367    * @param _amount Tokens being paid
1368    * @param _nonce Unique Id for sig to make it one-time-use
1369    * @param _paymentSig Signed parameters by payer authorizing payment
1370    */
1371   function requestTokenPayment(
1372     address _payer,
1373     address _receiver,
1374     uint256 _amount,
1375     bytes32 _nonce,
1376     bytes _paymentSig
1377     ) external onlyAttestationLogic {
1378 
1379     validatePaymentSig(
1380       _payer,
1381       _receiver,
1382       _amount,
1383       _nonce,
1384       _paymentSig
1385     );
1386     payTokensFromEscrow(_payer, _receiver, _amount);
1387     emit TokenMarketplaceEscrowPayment(_payer, _receiver, _amount);
1388   }
1389 
1390   /**
1391    * @notice Verify payment signature is valid
1392    * @param _payer User paying tokens from escrow
1393    * @param _receiver User receiving payment
1394    * @param _amount Tokens being paid
1395    * @param _nonce Unique Id for sig to make it one-time-use
1396    * @param _paymentSig Signed parameters by payer authorizing payment
1397    */
1398   function validatePaymentSig(
1399     address _payer,
1400     address _receiver,
1401     uint256 _amount,
1402     bytes32 _nonce,
1403     bytes _paymentSig
1404 
1405   ) private {
1406     bytes32 _signatureDigest = generatePayTokensSchemaHash(_payer, _receiver, _amount, _nonce);
1407     require(_payer == recoverSigner(_signatureDigest, _paymentSig), 'Invalid Payment Signature');
1408     burnSignatureDigest(_signatureDigest, _payer);
1409   }
1410 
1411   /**
1412    * @notice Helper function to add to escrow balance 
1413    * @param _from Account address for escrow mapping
1414    * @param _amount Tokens to lock up
1415    */
1416   function addToEscrow(address _from, uint256 _amount) private {
1417     tokenEscrow[_from] = tokenEscrow[_from].add(_amount);
1418     emit TokenMarketplaceDeposit(_from, _amount);
1419   }
1420 
1421   /**
1422    * Helper function to reduce escrow token balance of user
1423    */
1424   function subFromEscrow(address _from, uint256 _amount) private {
1425     require(tokenEscrow[_from] >= _amount);
1426     tokenEscrow[_from] = tokenEscrow[_from].sub(_amount);
1427   }
1428 }
1429 
1430 contract BatchInitializer is Ownable{
1431 
1432   AccountRegistryLogic public registryLogic;
1433   AttestationLogic public attestationLogic;
1434   address public admin;
1435 
1436   constructor(
1437     AttestationLogic _attestationLogic,
1438     AccountRegistryLogic _registryLogic
1439     ) public {
1440     attestationLogic = _attestationLogic;
1441     registryLogic = _registryLogic;
1442     admin = owner;
1443   }
1444 
1445   event linkSkipped(address currentAddress, address newAddress);
1446 
1447   /**
1448    * @dev Restricted to admin
1449    */
1450   modifier onlyAdmin {
1451     require(msg.sender == admin);
1452     _;
1453   }
1454 
1455   /**
1456    * @notice Change the address of the admin, who has the privilege to create new accounts
1457    * @dev Restricted to AccountRegistry owner and new admin address cannot be 0x0
1458    * @param _newAdmin Address of new admin
1459    */
1460   function setAdmin(address _newAdmin) external onlyOwner {
1461     admin = _newAdmin;
1462   }
1463 
1464   function setRegistryLogic(AccountRegistryLogic _newRegistryLogic) external onlyOwner {
1465     registryLogic = _newRegistryLogic;
1466   }
1467 
1468   function setAttestationLogic(AttestationLogic _newAttestationLogic) external onlyOwner {
1469     attestationLogic = _newAttestationLogic;
1470   }
1471 
1472   function setTokenEscrowMarketplace(TokenEscrowMarketplace _newMarketplace) external onlyOwner {
1473     attestationLogic.setTokenEscrowMarketplace(_newMarketplace);
1474   }
1475 
1476   function endInitialization(Initializable _initializable) external onlyOwner {
1477     _initializable.endInitialization();
1478   }
1479 
1480   function batchLinkAddresses(address[] _currentAddresses, address[] _newAddresses) external onlyAdmin {
1481     require(_currentAddresses.length == _newAddresses.length);
1482     for (uint256 i = 0; i < _currentAddresses.length; i++) {
1483       if (registryLogic.linkIds(_newAddresses[i]) > 0) {
1484         emit linkSkipped(_currentAddresses[i], _newAddresses[i]);
1485       } else {
1486         registryLogic.migrateLink(_currentAddresses[i], _newAddresses[i]);
1487       }
1488     }
1489   }
1490 
1491   function batchMigrateAttestations(
1492     address[] _requesters,
1493     address[] _attesters,
1494     address[] _subjects,
1495     bytes32[] _dataHashes
1496     ) external onlyAdmin {
1497     require(
1498       _requesters.length == _attesters.length &&
1499       _requesters.length == _subjects.length &&
1500       _requesters.length == _dataHashes.length
1501       );
1502     // This loop will fail if args don't all have equal length
1503     for (uint256 i = 0; i < _requesters.length; i++) {
1504       attestationLogic.migrateAttestation(
1505         _requesters[i],
1506         _attesters[i],
1507         _subjects[i],
1508         _dataHashes[i]
1509         );
1510     }
1511   }
1512 }