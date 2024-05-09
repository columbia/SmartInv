1 pragma solidity 0.4.24;
2 
3 /**
4  * @dev Pulled from OpenZeppelin: https://git.io/vbaRf
5  *   When this is in a public release we will switch to not vendoring this file
6  *
7  * @title Eliptic curve signature operations
8  *
9  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
10  */
11 
12 library ECRecovery {
13 
14   /**
15    * @dev Recover signer address from a message by using his signature
16    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
17    * @param sig bytes signature, the signature is generated using web3.eth.sign()
18    */
19   function recover(bytes32 hash, bytes sig) public pure returns (address) {
20     bytes32 r;
21     bytes32 s;
22     uint8 v;
23 
24     //Check the signature length
25     if (sig.length != 65) {
26       return (address(0));
27     }
28 
29     // Extracting these values isn't possible without assembly
30     // solhint-disable no-inline-assembly
31     // Divide the signature in r, s and v variables
32     assembly {
33       r := mload(add(sig, 32))
34       s := mload(add(sig, 64))
35       v := byte(0, mload(add(sig, 96)))
36     }
37 
38     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
39     if (v < 27) {
40       v += 27;
41     }
42 
43     // If the version is correct return the signer address
44     if (v != 27 && v != 28) {
45       return (address(0));
46     } else {
47       return ecrecover(hash, v, r, s);
48     }
49   }
50 
51 }
52 
53 
54 /**
55  * @title SigningLogic is contract implementing signature recovery from typed data signatures
56  * @notice Recovers signatures based on the SignTypedData implementation provided by ethSigUtil
57  * @dev This contract is inherited by other contracts.
58  */
59 contract SigningLogic {
60 
61   // Signatures contain a nonce to make them unique. usedSignatures tracks which signatures
62   //  have been used so they can't be replayed
63   mapping (bytes32 => bool) public usedSignatures;
64 
65   function burnSignatureDigest(bytes32 _signatureDigest, address _sender) internal {
66     bytes32 _txDataHash = keccak256(abi.encode(_signatureDigest, _sender));
67     require(!usedSignatures[_txDataHash], "Signature not unique");
68     usedSignatures[_txDataHash] = true;
69   }
70 
71   bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256(
72     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
73   );
74 
75   bytes32 constant ATTESTATION_REQUEST_TYPEHASH = keccak256(
76     "AttestationRequest(bytes32 dataHash,bytes32 nonce)"
77   );
78 
79   bytes32 constant ADD_ADDRESS_TYPEHASH = keccak256(
80     "AddAddress(address addressToAdd,bytes32 nonce)"
81   );
82 
83   bytes32 constant REMOVE_ADDRESS_TYPEHASH = keccak256(
84     "RemoveAddress(address addressToRemove,bytes32 nonce)"
85   );
86 
87   bytes32 constant PAY_TOKENS_TYPEHASH = keccak256(
88     "PayTokens(address sender,address receiver,uint256 amount,bytes32 nonce)"
89   );
90 
91   bytes32 constant RELEASE_TOKENS_FOR_TYPEHASH = keccak256(
92     "ReleaseTokensFor(address sender,uint256 amount,bytes32 nonce)"
93   );
94 
95   bytes32 constant ATTEST_FOR_TYPEHASH = keccak256(
96     "AttestFor(address subject,address requester,uint256 reward,bytes32 dataHash,bytes32 requestNonce)"
97   );
98 
99   bytes32 constant CONTEST_FOR_TYPEHASH = keccak256(
100     "ContestFor(address requester,uint256 reward,bytes32 requestNonce)"
101   );
102 
103   bytes32 constant REVOKE_ATTESTATION_FOR_TYPEHASH = keccak256(
104     "RevokeAttestationFor(bytes32 link,bytes32 nonce)"
105   );
106 
107   bytes32 constant VOTE_FOR_TYPEHASH = keccak256(
108     "VoteFor(uint16 choice,address voter,bytes32 nonce,address poll)"
109   );
110 
111   bytes32 constant LOCKUP_TOKENS_FOR_TYPEHASH = keccak256(
112     "LockupTokensFor(address sender,uint256 amount,bytes32 nonce)"
113   );
114 
115   bytes32 DOMAIN_SEPARATOR;
116 
117   constructor (string name, string version, uint256 chainId) public {
118     DOMAIN_SEPARATOR = hash(EIP712Domain({
119       name: name,
120       version: version,
121       chainId: chainId,
122       verifyingContract: this
123     }));
124   }
125 
126   struct EIP712Domain {
127       string  name;
128       string  version;
129       uint256 chainId;
130       address verifyingContract;
131   }
132 
133   function hash(EIP712Domain eip712Domain) private pure returns (bytes32) {
134     return keccak256(abi.encode(
135       EIP712DOMAIN_TYPEHASH,
136       keccak256(bytes(eip712Domain.name)),
137       keccak256(bytes(eip712Domain.version)),
138       eip712Domain.chainId,
139       eip712Domain.verifyingContract
140     ));
141   }
142 
143   struct AttestationRequest {
144       bytes32 dataHash;
145       bytes32 nonce;
146   }
147 
148   function hash(AttestationRequest request) private pure returns (bytes32) {
149     return keccak256(abi.encode(
150       ATTESTATION_REQUEST_TYPEHASH,
151       request.dataHash,
152       request.nonce
153     ));
154   }
155 
156   struct AddAddress {
157       address addressToAdd;
158       bytes32 nonce;
159   }
160 
161   function hash(AddAddress request) private pure returns (bytes32) {
162     return keccak256(abi.encode(
163       ADD_ADDRESS_TYPEHASH,
164       request.addressToAdd,
165       request.nonce
166     ));
167   }
168 
169   struct RemoveAddress {
170       address addressToRemove;
171       bytes32 nonce;
172   }
173 
174   function hash(RemoveAddress request) private pure returns (bytes32) {
175     return keccak256(abi.encode(
176       REMOVE_ADDRESS_TYPEHASH,
177       request.addressToRemove,
178       request.nonce
179     ));
180   }
181 
182   struct PayTokens {
183       address sender;
184       address receiver;
185       uint256 amount;
186       bytes32 nonce;
187   }
188 
189   function hash(PayTokens request) private pure returns (bytes32) {
190     return keccak256(abi.encode(
191       PAY_TOKENS_TYPEHASH,
192       request.sender,
193       request.receiver,
194       request.amount,
195       request.nonce
196     ));
197   }
198 
199   struct AttestFor {
200       address subject;
201       address requester;
202       uint256 reward;
203       bytes32 dataHash;
204       bytes32 requestNonce;
205   }
206 
207   function hash(AttestFor request) private pure returns (bytes32) {
208     return keccak256(abi.encode(
209       ATTEST_FOR_TYPEHASH,
210       request.subject,
211       request.requester,
212       request.reward,
213       request.dataHash,
214       request.requestNonce
215     ));
216   }
217 
218   struct ContestFor {
219       address requester;
220       uint256 reward;
221       bytes32 requestNonce;
222   }
223 
224   function hash(ContestFor request) private pure returns (bytes32) {
225     return keccak256(abi.encode(
226       CONTEST_FOR_TYPEHASH,
227       request.requester,
228       request.reward,
229       request.requestNonce
230     ));
231   }
232 
233   struct RevokeAttestationFor {
234       bytes32 link;
235       bytes32 nonce;
236   }
237 
238   function hash(RevokeAttestationFor request) private pure returns (bytes32) {
239     return keccak256(abi.encode(
240       REVOKE_ATTESTATION_FOR_TYPEHASH,
241       request.link,
242       request.nonce
243     ));
244   }
245 
246   struct VoteFor {
247       uint16 choice;
248       address voter;
249       bytes32 nonce;
250       address poll;
251   }
252 
253   function hash(VoteFor request) private pure returns (bytes32) {
254     return keccak256(abi.encode(
255       VOTE_FOR_TYPEHASH,
256       request.choice,
257       request.voter,
258       request.nonce,
259       request.poll
260     ));
261   }
262 
263   struct LockupTokensFor {
264     address sender;
265     uint256 amount;
266     bytes32 nonce;
267   }
268 
269   function hash(LockupTokensFor request) private pure returns (bytes32) {
270     return keccak256(abi.encode(
271       LOCKUP_TOKENS_FOR_TYPEHASH,
272       request.sender,
273       request.amount,
274       request.nonce
275     ));
276   }
277 
278   struct ReleaseTokensFor {
279     address sender;
280     uint256 amount;
281     bytes32 nonce;
282   }
283 
284   function hash(ReleaseTokensFor request) private pure returns (bytes32) {
285     return keccak256(abi.encode(
286       RELEASE_TOKENS_FOR_TYPEHASH,
287       request.sender,
288       request.amount,
289       request.nonce
290     ));
291   }
292 
293   function generateRequestAttestationSchemaHash(
294     bytes32 _dataHash,
295     bytes32 _nonce
296   ) internal view returns (bytes32) {
297     return keccak256(
298       abi.encodePacked(
299         "\x19\x01",
300         DOMAIN_SEPARATOR,
301         hash(AttestationRequest(
302           _dataHash,
303           _nonce
304         ))
305       )
306       );
307   }
308 
309   function generateAddAddressSchemaHash(
310     address _addressToAdd,
311     bytes32 _nonce
312   ) internal view returns (bytes32) {
313     return keccak256(
314       abi.encodePacked(
315         "\x19\x01",
316         DOMAIN_SEPARATOR,
317         hash(AddAddress(
318           _addressToAdd,
319           _nonce
320         ))
321       )
322       );
323   }
324 
325   function generateRemoveAddressSchemaHash(
326     address _addressToRemove,
327     bytes32 _nonce
328   ) internal view returns (bytes32) {
329     return keccak256(
330       abi.encodePacked(
331         "\x19\x01",
332         DOMAIN_SEPARATOR,
333         hash(RemoveAddress(
334           _addressToRemove,
335           _nonce
336         ))
337       )
338       );
339   }
340 
341   function generatePayTokensSchemaHash(
342     address _sender,
343     address _receiver,
344     uint256 _amount,
345     bytes32 _nonce
346   ) internal view returns (bytes32) {
347     return keccak256(
348       abi.encodePacked(
349         "\x19\x01",
350         DOMAIN_SEPARATOR,
351         hash(PayTokens(
352           _sender,
353           _receiver,
354           _amount,
355           _nonce
356         ))
357       )
358       );
359   }
360 
361   function generateAttestForDelegationSchemaHash(
362     address _subject,
363     address _requester,
364     uint256 _reward,
365     bytes32 _dataHash,
366     bytes32 _requestNonce
367   ) internal view returns (bytes32) {
368     return keccak256(
369       abi.encodePacked(
370         "\x19\x01",
371         DOMAIN_SEPARATOR,
372         hash(AttestFor(
373           _subject,
374           _requester,
375           _reward,
376           _dataHash,
377           _requestNonce
378         ))
379       )
380       );
381   }
382 
383   function generateContestForDelegationSchemaHash(
384     address _requester,
385     uint256 _reward,
386     bytes32 _requestNonce
387   ) internal view returns (bytes32) {
388     return keccak256(
389       abi.encodePacked(
390         "\x19\x01",
391         DOMAIN_SEPARATOR,
392         hash(ContestFor(
393           _requester,
394           _reward,
395           _requestNonce
396         ))
397       )
398       );
399   }
400 
401   function generateRevokeAttestationForDelegationSchemaHash(
402     bytes32 _link,
403     bytes32 _nonce
404   ) internal view returns (bytes32) {
405     return keccak256(
406       abi.encodePacked(
407         "\x19\x01",
408         DOMAIN_SEPARATOR,
409         hash(RevokeAttestationFor(
410           _link,
411           _nonce
412         ))
413       )
414       );
415   }
416 
417   function generateVoteForDelegationSchemaHash(
418     uint16 _choice,
419     address _voter,
420     bytes32 _nonce,
421     address _poll
422   ) internal view returns (bytes32) {
423     return keccak256(
424       abi.encodePacked(
425         "\x19\x01",
426         DOMAIN_SEPARATOR,
427         hash(VoteFor(
428           _choice,
429           _voter,
430           _nonce,
431           _poll
432         ))
433       )
434       );
435   }
436 
437   function generateLockupTokensDelegationSchemaHash(
438     address _sender,
439     uint256 _amount,
440     bytes32 _nonce
441   ) internal view returns (bytes32) {
442     return keccak256(
443       abi.encodePacked(
444         "\x19\x01",
445         DOMAIN_SEPARATOR,
446         hash(LockupTokensFor(
447           _sender,
448           _amount,
449           _nonce
450         ))
451       )
452       );
453   }
454 
455   function generateReleaseTokensDelegationSchemaHash(
456     address _sender,
457     uint256 _amount,
458     bytes32 _nonce
459   ) internal view returns (bytes32) {
460     return keccak256(
461       abi.encodePacked(
462         "\x19\x01",
463         DOMAIN_SEPARATOR,
464         hash(ReleaseTokensFor(
465           _sender,
466           _amount,
467           _nonce
468         ))
469       )
470       );
471   }
472 
473   function recoverSigner(bytes32 _hash, bytes _sig) internal pure returns (address) {
474     address signer = ECRecovery.recover(_hash, _sig);
475     require(signer != address(0));
476 
477     return signer;
478   }
479 }
480 
481 
482 /**
483  * @title Initializable
484  * @dev The Initializable contract has an initializer address, and provides basic authorization control
485  * only while in initialization mode. Once changed to production mode the inializer loses authority
486  */
487 contract Initializable {
488   address public initializer;
489   bool public initializing;
490 
491   event InitializationEnded();
492 
493   /**
494    * @dev The Initializable constructor sets the initializer to the provided address
495    */
496   constructor(address _initializer) public {
497     initializer = _initializer;
498     initializing = true;
499   }
500 
501   /**
502    * @dev Throws if called by any account other than the owner.
503    */
504   modifier onlyDuringInitialization() {
505     require(msg.sender == initializer, 'Method can only be called by initializer');
506     require(initializing, 'Method can only be called during initialization');
507     _;
508   }
509 
510   /**
511    * @dev Allows the initializer to end the initialization period
512    */
513   function endInitialization() public onlyDuringInitialization {
514     initializing = false;
515     emit InitializationEnded();
516   }
517 
518 }
519 
520 
521 /**
522  * @title Bloom account registry
523  * @notice Account Registry Logic allows users to link multiple addresses to the same owner
524  *
525  */
526 contract AccountRegistryLogic is Initializable, SigningLogic {
527   /**
528    * @notice The AccountRegistry constructor configures the signing logic implementation
529    */
530   constructor(
531     address _initializer
532   ) public Initializable(_initializer) SigningLogic("Bloom Account Registry", "2", 1) {}
533 
534   event AddressLinked(address indexed currentAddress, address indexed newAddress, uint256 indexed linkId);
535   event AddressUnlinked(address indexed addressToRemove);
536 
537   // Counter to generate unique link Ids
538   uint256 linkCounter;
539   mapping(address => uint256) public linkIds;
540 
541   /**
542    * @notice Add an address to an existing id on behalf of a user to pay the gas costs
543    * @param _currentAddress Address to which user wants to link another address. May currently be linked to another address
544    * @param _currentAddressSig Signed message from address currently associated with account confirming intention
545    * @param _newAddress Address to add to account. Cannot currently be linked to another address
546    * @param _newAddressSig Signed message from new address confirming ownership by the sender
547    * @param _nonce hex string used when generating sigs to make them one time use
548    */
549   function linkAddresses(
550     address _currentAddress,
551     bytes _currentAddressSig,
552     address _newAddress,
553     bytes _newAddressSig,
554     bytes32 _nonce
555     ) external {
556       // Confirm newAddress is not linked to another account
557       require(linkIds[_newAddress] == 0);
558       // Confirm new address is signed by current address and is unused
559       validateLinkSignature(_currentAddress, _newAddress, _nonce, _currentAddressSig);
560 
561       // Confirm current address is signed by new address and is unused
562       validateLinkSignature(_newAddress, _currentAddress, _nonce, _newAddressSig);
563 
564       // Get linkId of current address if exists. Otherwise use incremented linkCounter
565       if (linkIds[_currentAddress] == 0) {
566         linkIds[_currentAddress] = ++linkCounter;
567       }
568       linkIds[_newAddress] = linkIds[_currentAddress];
569 
570       emit AddressLinked(_currentAddress, _newAddress, linkIds[_currentAddress]);
571   }
572 
573   /**
574    * @notice Remove an address from a link relationship
575    * @param _addressToRemove Address to unlink from all other addresses
576    * @param _unlinkSignature Signed message from address currently associated with account confirming intention to unlink
577    * @param _nonce hex string used when generating sigs to make them one time use
578    */
579   function unlinkAddress(
580     address _addressToRemove,
581     bytes32 _nonce,
582     bytes _unlinkSignature
583   ) external {
584     // Confirm unlink request is signed by sender and is unused
585     validateUnlinkSignature(_addressToRemove, _nonce, _unlinkSignature);
586     linkIds[_addressToRemove] = 0;
587 
588     emit AddressUnlinked(_addressToRemove);
589   }
590 
591   /**
592    * @notice Verify link signature is valid and unused V
593    * @param _currentAddress Address signing intention to link
594    * @param _addressToAdd Address being linked
595    * @param _nonce Unique nonce for this request
596    * @param _linkSignature Signature of address a
597    */
598   function validateLinkSignature(
599     address _currentAddress,
600     address _addressToAdd,
601     bytes32 _nonce,
602     bytes _linkSignature
603   ) private {
604     bytes32 _signatureDigest = generateAddAddressSchemaHash(_addressToAdd, _nonce);
605     require(_currentAddress == recoverSigner(_signatureDigest, _linkSignature));
606     burnSignatureDigest(_signatureDigest, _currentAddress);
607   }
608 
609   /**
610    * @notice Verify unlink signature is valid and unused 
611    * @param _addressToRemove Address being unlinked
612    * @param _nonce Unique nonce for this request
613    * @param _unlinkSignature Signature of senderAddress
614    */
615   function validateUnlinkSignature(
616     address _addressToRemove,
617     bytes32 _nonce,
618     bytes _unlinkSignature
619   ) private {
620 
621     // require that address to remove is currently linked to senderAddress
622     require(linkIds[_addressToRemove] != 0, "Address does not have active link");
623 
624     bytes32 _signatureDigest = generateRemoveAddressSchemaHash(_addressToRemove, _nonce);
625 
626     require(_addressToRemove == recoverSigner(_signatureDigest, _unlinkSignature));
627     burnSignatureDigest(_signatureDigest, _addressToRemove);
628   }
629 
630   /**
631    * @notice Submit link completed prior to deployment of this contract
632    * @dev Gives initializer privileges to write links during the initialization period without signatures
633    * @param _currentAddress Address to which user wants to link another address. May currently be linked to another address
634    * @param _newAddress Address to add to account. Cannot currently be linked to another address
635    */
636   function migrateLink(
637     address _currentAddress,
638     address _newAddress
639   ) external onlyDuringInitialization {
640     // Confirm newAddress is not linked to another account
641     require(linkIds[_newAddress] == 0);
642 
643     // Get linkId of current address if exists. Otherwise use incremented linkCounter
644     if (linkIds[_currentAddress] == 0) {
645       linkIds[_currentAddress] = ++linkCounter;
646     }
647     linkIds[_newAddress] = linkIds[_currentAddress];
648 
649     emit AddressLinked(_currentAddress, _newAddress, linkIds[_currentAddress]);
650   }
651 
652 }