1 pragma solidity 0.4.24;
2 
3 
4 
5 /**
6  * @dev Pulled from OpenZeppelin: https://git.io/vbaRf
7  *   When this is in a public release we will switch to not vendoring this file
8  *
9  * @title Eliptic curve signature operations
10  *
11  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
12  */
13 
14 library ECRecovery {
15 
16   /**
17    * @dev Recover signer address from a message by using his signature
18    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
19    * @param sig bytes signature, the signature is generated using web3.eth.sign()
20    */
21   function recover(bytes32 hash, bytes sig) public pure returns (address) {
22     bytes32 r;
23     bytes32 s;
24     uint8 v;
25 
26     //Check the signature length
27     if (sig.length != 65) {
28       return (address(0));
29     }
30 
31     // Extracting these values isn't possible without assembly
32     // solhint-disable no-inline-assembly
33     // Divide the signature in r, s and v variables
34     assembly {
35       r := mload(add(sig, 32))
36       s := mload(add(sig, 64))
37       v := byte(0, mload(add(sig, 96)))
38     }
39 
40     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
41     if (v < 27) {
42       v += 27;
43     }
44 
45     // If the version is correct return the signer address
46     if (v != 27 && v != 28) {
47       return (address(0));
48     } else {
49       return ecrecover(hash, v, r, s);
50     }
51   }
52 
53 }
54 
55 
56 /**
57  * @title SigningLogic is contract implementing signature recovery from typed data signatures
58  * @notice Recovers signatures based on the SignTypedData implementation provided by ethSigUtil
59  * @dev This contract is inherited by other contracts.
60  */
61 contract SigningLogic {
62 
63   // Signatures contain a nonce to make them unique. usedSignatures tracks which signatures
64   //  have been used so they can't be replayed
65   mapping (bytes32 => bool) public usedSignatures;
66 
67   function burnSignatureDigest(bytes32 _signatureDigest, address _sender) internal {
68     bytes32 _txDataHash = keccak256(abi.encode(_signatureDigest, _sender));
69     require(!usedSignatures[_txDataHash], "Signature not unique");
70     usedSignatures[_txDataHash] = true;
71   }
72 
73   bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256(
74     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
75   );
76 
77   bytes32 constant ATTESTATION_REQUEST_TYPEHASH = keccak256(
78     "AttestationRequest(bytes32 dataHash,bytes32 nonce)"
79   );
80 
81   bytes32 constant ADD_ADDRESS_TYPEHASH = keccak256(
82     "AddAddress(address addressToAdd,bytes32 nonce)"
83   );
84 
85   bytes32 constant REMOVE_ADDRESS_TYPEHASH = keccak256(
86     "RemoveAddress(address addressToRemove,bytes32 nonce)"
87   );
88 
89   bytes32 constant PAY_TOKENS_TYPEHASH = keccak256(
90     "PayTokens(address sender,address receiver,uint256 amount,bytes32 nonce)"
91   );
92 
93   bytes32 constant RELEASE_TOKENS_FOR_TYPEHASH = keccak256(
94     "ReleaseTokensFor(address sender,uint256 amount,bytes32 nonce)"
95   );
96 
97   bytes32 constant ATTEST_FOR_TYPEHASH = keccak256(
98     "AttestFor(address subject,address requester,uint256 reward,bytes32 dataHash,bytes32 requestNonce)"
99   );
100 
101   bytes32 constant CONTEST_FOR_TYPEHASH = keccak256(
102     "ContestFor(address requester,uint256 reward,bytes32 requestNonce)"
103   );
104 
105   bytes32 constant REVOKE_ATTESTATION_FOR_TYPEHASH = keccak256(
106     "RevokeAttestationFor(bytes32 link,bytes32 nonce)"
107   );
108 
109   bytes32 constant VOTE_FOR_TYPEHASH = keccak256(
110     "VoteFor(uint16 choice,address voter,bytes32 nonce,address poll)"
111   );
112 
113   bytes32 constant LOCKUP_TOKENS_FOR_TYPEHASH = keccak256(
114     "LockupTokensFor(address sender,uint256 amount,bytes32 nonce)"
115   );
116 
117   bytes32 DOMAIN_SEPARATOR;
118 
119   constructor (string name, string version, uint256 chainId) public {
120     DOMAIN_SEPARATOR = hash(EIP712Domain({
121       name: name,
122       version: version,
123       chainId: chainId,
124       verifyingContract: this
125     }));
126   }
127 
128   struct EIP712Domain {
129       string  name;
130       string  version;
131       uint256 chainId;
132       address verifyingContract;
133   }
134 
135   function hash(EIP712Domain eip712Domain) private pure returns (bytes32) {
136     return keccak256(abi.encode(
137       EIP712DOMAIN_TYPEHASH,
138       keccak256(bytes(eip712Domain.name)),
139       keccak256(bytes(eip712Domain.version)),
140       eip712Domain.chainId,
141       eip712Domain.verifyingContract
142     ));
143   }
144 
145   struct AttestationRequest {
146       bytes32 dataHash;
147       bytes32 nonce;
148   }
149 
150   function hash(AttestationRequest request) private pure returns (bytes32) {
151     return keccak256(abi.encode(
152       ATTESTATION_REQUEST_TYPEHASH,
153       request.dataHash,
154       request.nonce
155     ));
156   }
157 
158   struct AddAddress {
159       address addressToAdd;
160       bytes32 nonce;
161   }
162 
163   function hash(AddAddress request) private pure returns (bytes32) {
164     return keccak256(abi.encode(
165       ADD_ADDRESS_TYPEHASH,
166       request.addressToAdd,
167       request.nonce
168     ));
169   }
170 
171   struct RemoveAddress {
172       address addressToRemove;
173       bytes32 nonce;
174   }
175 
176   function hash(RemoveAddress request) private pure returns (bytes32) {
177     return keccak256(abi.encode(
178       REMOVE_ADDRESS_TYPEHASH,
179       request.addressToRemove,
180       request.nonce
181     ));
182   }
183 
184   struct PayTokens {
185       address sender;
186       address receiver;
187       uint256 amount;
188       bytes32 nonce;
189   }
190 
191   function hash(PayTokens request) private pure returns (bytes32) {
192     return keccak256(abi.encode(
193       PAY_TOKENS_TYPEHASH,
194       request.sender,
195       request.receiver,
196       request.amount,
197       request.nonce
198     ));
199   }
200 
201   struct AttestFor {
202       address subject;
203       address requester;
204       uint256 reward;
205       bytes32 dataHash;
206       bytes32 requestNonce;
207   }
208 
209   function hash(AttestFor request) private pure returns (bytes32) {
210     return keccak256(abi.encode(
211       ATTEST_FOR_TYPEHASH,
212       request.subject,
213       request.requester,
214       request.reward,
215       request.dataHash,
216       request.requestNonce
217     ));
218   }
219 
220   struct ContestFor {
221       address requester;
222       uint256 reward;
223       bytes32 requestNonce;
224   }
225 
226   function hash(ContestFor request) private pure returns (bytes32) {
227     return keccak256(abi.encode(
228       CONTEST_FOR_TYPEHASH,
229       request.requester,
230       request.reward,
231       request.requestNonce
232     ));
233   }
234 
235   struct RevokeAttestationFor {
236       bytes32 link;
237       bytes32 nonce;
238   }
239 
240   function hash(RevokeAttestationFor request) private pure returns (bytes32) {
241     return keccak256(abi.encode(
242       REVOKE_ATTESTATION_FOR_TYPEHASH,
243       request.link,
244       request.nonce
245     ));
246   }
247 
248   struct VoteFor {
249       uint16 choice;
250       address voter;
251       bytes32 nonce;
252       address poll;
253   }
254 
255   function hash(VoteFor request) private pure returns (bytes32) {
256     return keccak256(abi.encode(
257       VOTE_FOR_TYPEHASH,
258       request.choice,
259       request.voter,
260       request.nonce,
261       request.poll
262     ));
263   }
264 
265   struct LockupTokensFor {
266     address sender;
267     uint256 amount;
268     bytes32 nonce;
269   }
270 
271   function hash(LockupTokensFor request) private pure returns (bytes32) {
272     return keccak256(abi.encode(
273       LOCKUP_TOKENS_FOR_TYPEHASH,
274       request.sender,
275       request.amount,
276       request.nonce
277     ));
278   }
279 
280   struct ReleaseTokensFor {
281     address sender;
282     uint256 amount;
283     bytes32 nonce;
284   }
285 
286   function hash(ReleaseTokensFor request) private pure returns (bytes32) {
287     return keccak256(abi.encode(
288       RELEASE_TOKENS_FOR_TYPEHASH,
289       request.sender,
290       request.amount,
291       request.nonce
292     ));
293   }
294 
295   function generateRequestAttestationSchemaHash(
296     bytes32 _dataHash,
297     bytes32 _nonce
298   ) internal view returns (bytes32) {
299     return keccak256(
300       abi.encodePacked(
301         "\x19\x01",
302         DOMAIN_SEPARATOR,
303         hash(AttestationRequest(
304           _dataHash,
305           _nonce
306         ))
307       )
308       );
309   }
310 
311   function generateAddAddressSchemaHash(
312     address _addressToAdd,
313     bytes32 _nonce
314   ) internal view returns (bytes32) {
315     return keccak256(
316       abi.encodePacked(
317         "\x19\x01",
318         DOMAIN_SEPARATOR,
319         hash(AddAddress(
320           _addressToAdd,
321           _nonce
322         ))
323       )
324       );
325   }
326 
327   function generateRemoveAddressSchemaHash(
328     address _addressToRemove,
329     bytes32 _nonce
330   ) internal view returns (bytes32) {
331     return keccak256(
332       abi.encodePacked(
333         "\x19\x01",
334         DOMAIN_SEPARATOR,
335         hash(RemoveAddress(
336           _addressToRemove,
337           _nonce
338         ))
339       )
340       );
341   }
342 
343   function generatePayTokensSchemaHash(
344     address _sender,
345     address _receiver,
346     uint256 _amount,
347     bytes32 _nonce
348   ) internal view returns (bytes32) {
349     return keccak256(
350       abi.encodePacked(
351         "\x19\x01",
352         DOMAIN_SEPARATOR,
353         hash(PayTokens(
354           _sender,
355           _receiver,
356           _amount,
357           _nonce
358         ))
359       )
360       );
361   }
362 
363   function generateAttestForDelegationSchemaHash(
364     address _subject,
365     address _requester,
366     uint256 _reward,
367     bytes32 _dataHash,
368     bytes32 _requestNonce
369   ) internal view returns (bytes32) {
370     return keccak256(
371       abi.encodePacked(
372         "\x19\x01",
373         DOMAIN_SEPARATOR,
374         hash(AttestFor(
375           _subject,
376           _requester,
377           _reward,
378           _dataHash,
379           _requestNonce
380         ))
381       )
382       );
383   }
384 
385   function generateContestForDelegationSchemaHash(
386     address _requester,
387     uint256 _reward,
388     bytes32 _requestNonce
389   ) internal view returns (bytes32) {
390     return keccak256(
391       abi.encodePacked(
392         "\x19\x01",
393         DOMAIN_SEPARATOR,
394         hash(ContestFor(
395           _requester,
396           _reward,
397           _requestNonce
398         ))
399       )
400       );
401   }
402 
403   function generateRevokeAttestationForDelegationSchemaHash(
404     bytes32 _link,
405     bytes32 _nonce
406   ) internal view returns (bytes32) {
407     return keccak256(
408       abi.encodePacked(
409         "\x19\x01",
410         DOMAIN_SEPARATOR,
411         hash(RevokeAttestationFor(
412           _link,
413           _nonce
414         ))
415       )
416       );
417   }
418 
419   function generateVoteForDelegationSchemaHash(
420     uint16 _choice,
421     address _voter,
422     bytes32 _nonce,
423     address _poll
424   ) internal view returns (bytes32) {
425     return keccak256(
426       abi.encodePacked(
427         "\x19\x01",
428         DOMAIN_SEPARATOR,
429         hash(VoteFor(
430           _choice,
431           _voter,
432           _nonce,
433           _poll
434         ))
435       )
436       );
437   }
438 
439   function generateLockupTokensDelegationSchemaHash(
440     address _sender,
441     uint256 _amount,
442     bytes32 _nonce
443   ) internal view returns (bytes32) {
444     return keccak256(
445       abi.encodePacked(
446         "\x19\x01",
447         DOMAIN_SEPARATOR,
448         hash(LockupTokensFor(
449           _sender,
450           _amount,
451           _nonce
452         ))
453       )
454       );
455   }
456 
457   function generateReleaseTokensDelegationSchemaHash(
458     address _sender,
459     uint256 _amount,
460     bytes32 _nonce
461   ) internal view returns (bytes32) {
462     return keccak256(
463       abi.encodePacked(
464         "\x19\x01",
465         DOMAIN_SEPARATOR,
466         hash(ReleaseTokensFor(
467           _sender,
468           _amount,
469           _nonce
470         ))
471       )
472       );
473   }
474 
475   function recoverSigner(bytes32 _hash, bytes _sig) internal pure returns (address) {
476     address signer = ECRecovery.recover(_hash, _sig);
477     require(signer != address(0));
478 
479     return signer;
480   }
481 }
482 pragma solidity ^0.4.21;
483 
484 
485 /**
486  * @title ERC20Basic
487  * @dev Simpler version of ERC20 interface
488  * @dev see https://github.com/ethereum/EIPs/issues/179
489  */
490 contract ERC20Basic {
491   function totalSupply() public view returns (uint256);
492   function balanceOf(address who) public view returns (uint256);
493   function transfer(address to, uint256 value) public returns (bool);
494   event Transfer(address indexed from, address indexed to, uint256 value);
495 }
496 
497 
498 /**
499  * @title ERC20 interface
500  * @dev see https://github.com/ethereum/EIPs/issues/20
501  */
502 contract ERC20 is ERC20Basic {
503   function allowance(address owner, address spender) public view returns (uint256);
504   function transferFrom(address from, address to, uint256 value) public returns (bool);
505   function approve(address spender, uint256 value) public returns (bool);
506   event Approval(address indexed owner, address indexed spender, uint256 value);
507 }
508 
509 
510 /**
511  * @title SafeMath
512  * @dev Math operations with safety checks that throw on error
513  */
514 library SafeMath {
515 
516   /**
517   * @dev Multiplies two numbers, throws on overflow.
518   */
519   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
520     if (a == 0) {
521       return 0;
522     }
523     c = a * b;
524     assert(c / a == b);
525     return c;
526   }
527 
528   /**
529   * @dev Integer division of two numbers, truncating the quotient.
530   */
531   function div(uint256 a, uint256 b) internal pure returns (uint256) {
532     // assert(b > 0); // Solidity automatically throws when dividing by 0
533     // uint256 c = a / b;
534     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
535     return a / b;
536   }
537 
538   /**
539   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
540   */
541   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
542     assert(b <= a);
543     return a - b;
544   }
545 
546   /**
547   * @dev Adds two numbers, throws on overflow.
548   */
549   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
550     c = a + b;
551     assert(c >= a);
552     return c;
553   }
554 }
555 
556 
557 
558 /**
559  * @title SafeERC20
560  * @dev Wrappers around ERC20 operations that throw on failure.
561  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
562  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
563  */
564 library SafeERC20 {
565   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
566     assert(token.transfer(to, value));
567   }
568 
569   function safeTransferFrom(
570     ERC20 token,
571     address from,
572     address to,
573     uint256 value
574   )
575     internal
576   {
577     assert(token.transferFrom(from, to, value));
578   }
579 
580   function safeApprove(ERC20 token, address spender, uint256 value) internal {
581     assert(token.approve(spender, value));
582   }
583 }
584 
585 
586 /**
587  * @notice TokenEscrowMarketplace is an ERC20 payment channel that enables users to send BLT by exchanging signatures off-chain
588  *  Users approve the contract address to transfer BLT on their behalf using the standard ERC20.approve function
589  *  After approval, either the user or the contract admin initiates the transfer of BLT into the contract
590  *  Once in the contract, users can send payments via a signed message to another user. 
591  *  The signature transfers BLT from lockup to the recipient's balance
592  *  Users can withdraw funds at any time. Or the admin can release them on the user's behalf
593  *  
594  *  BLT is stored in the contract by address
595  *  
596  *  Only the AttestationLogic contract is authorized to release funds once a jobs is complete
597  */
598 contract TokenEscrowMarketplace is SigningLogic {
599   using SafeERC20 for ERC20;
600   using SafeMath for uint256;
601 
602   address public attestationLogic;
603 
604   mapping(address => uint256) public tokenEscrow;
605   ERC20 public token;
606 
607   event TokenMarketplaceWithdrawal(address escrowPayer, uint256 amount);
608   event TokenMarketplaceEscrowPayment(address escrowPayer, address escrowPayee, uint256 amount);
609   event TokenMarketplaceDeposit(address escrowPayer, uint256 amount);
610 
611   /**
612    * @notice The TokenEscrowMarketplace constructor initializes the interfaces to the other contracts
613    * @dev Some actions are restricted to be performed by the attestationLogic contract.
614    *  Signing logic is upgradeable in case the signTypedData spec changes
615    * @param _token Address of BLT
616    * @param _attestationLogic Address of current attestation logic contract
617    */
618   constructor(
619     ERC20 _token,
620     address _attestationLogic
621     ) public SigningLogic("Bloom Token Escrow Marketplace", "2", 1) {
622     token = _token;
623     attestationLogic = _attestationLogic;
624   }
625 
626   modifier onlyAttestationLogic() {
627     require(msg.sender == attestationLogic);
628     _;
629   }
630 
631   /**
632    * @notice Lockup tokens for set time period on behalf of user. Must be preceeded by approve
633    * @dev Authorized by a signTypedData signature by sender
634    *  Sigs can only be used once. They contain a unique nonce
635    *  So an action can be repeated, with a different signature
636    * @param _sender User locking up their tokens
637    * @param _amount Tokens to lock up
638    * @param _nonce Unique Id so signatures can't be replayed
639    * @param _delegationSig Signed hash of these input parameters so an admin can submit this on behalf of a user
640    */
641   function moveTokensToEscrowLockupFor(
642     address _sender,
643     uint256 _amount,
644     bytes32 _nonce,
645     bytes _delegationSig
646     ) external {
647       validateLockupTokensSig(
648         _sender,
649         _amount,
650         _nonce,
651         _delegationSig
652       );
653       moveTokensToEscrowLockupForUser(_sender, _amount);
654   }
655 
656   /**
657    * @notice Verify lockup signature is valid
658    * @param _sender User locking up their tokens
659    * @param _amount Tokens to lock up
660    * @param _nonce Unique Id so signatures can't be replayed
661    * @param _delegationSig Signed hash of these input parameters so an admin can submit this on behalf of a user
662    */
663   function validateLockupTokensSig(
664     address _sender,
665     uint256 _amount,
666     bytes32 _nonce,
667     bytes _delegationSig
668   ) private {
669     bytes32 _signatureDigest = generateLockupTokensDelegationSchemaHash(_sender, _amount, _nonce);
670     require(_sender == recoverSigner(_signatureDigest, _delegationSig), 'Invalid LockupTokens Signature');
671     burnSignatureDigest(_signatureDigest, _sender);
672   }
673 
674   /**
675    * @notice Lockup tokens by user. Must be preceeded by approve
676    * @param _amount Tokens to lock up
677    */
678   function moveTokensToEscrowLockup(uint256 _amount) external {
679     moveTokensToEscrowLockupForUser(msg.sender, _amount);
680   }
681 
682   /**
683    * @notice Lockup tokens for set time. Must be preceeded by approve
684    * @dev Private function called by appropriate public function
685    * @param _sender User locking up their tokens
686    * @param _amount Tokens to lock up
687    */
688   function moveTokensToEscrowLockupForUser(
689     address _sender,
690     uint256 _amount
691     ) private {
692     token.safeTransferFrom(_sender, this, _amount);
693     addToEscrow(_sender, _amount);
694   }
695 
696   /**
697    * @notice Withdraw tokens from escrow back to requester
698    * @dev Authorized by a signTypedData signature by sender
699    *  Sigs can only be used once. They contain a unique nonce
700    *  So an action can be repeated, with a different signature
701    * @param _sender User withdrawing their tokens
702    * @param _amount Tokens to withdraw
703    * @param _nonce Unique Id so signatures can't be replayed
704    * @param _delegationSig Signed hash of these input parameters so an admin can submit this on behalf of a user
705    */
706   function releaseTokensFromEscrowFor(
707     address _sender,
708     uint256 _amount,
709     bytes32 _nonce,
710     bytes _delegationSig
711     ) external {
712       validateReleaseTokensSig(
713         _sender,
714         _amount,
715         _nonce,
716         _delegationSig
717       );
718       releaseTokensFromEscrowForUser(_sender, _amount);
719   }
720 
721   /**
722    * @notice Verify lockup signature is valid
723    * @param _sender User withdrawing their tokens
724    * @param _amount Tokens to lock up
725    * @param _nonce Unique Id so signatures can't be replayed
726    * @param _delegationSig Signed hash of these input parameters so an admin can submit this on behalf of a user
727    */
728   function validateReleaseTokensSig(
729     address _sender,
730     uint256 _amount,
731     bytes32 _nonce,
732     bytes _delegationSig
733 
734   ) private {
735     bytes32 _signatureDigest = generateReleaseTokensDelegationSchemaHash(_sender, _amount, _nonce);
736     require(_sender == recoverSigner(_signatureDigest, _delegationSig), 'Invalid ReleaseTokens Signature');
737     burnSignatureDigest(_signatureDigest, _sender);
738   }
739 
740   /**
741    * @notice Release tokens back to payer's available balance if lockup expires
742    * @dev Token balance retreived by accountId. Can be different address from the one that deposited tokens
743    * @param _amount Tokens to retreive from escrow
744    */
745   function releaseTokensFromEscrow(uint256 _amount) external {
746     releaseTokensFromEscrowForUser(msg.sender, _amount);
747   }
748 
749   /**
750    * @notice Release tokens back to payer's available balance
751    * @param _payer User retreiving tokens from escrow
752    * @param _amount Tokens to retreive from escrow
753    */
754   function releaseTokensFromEscrowForUser(
755     address _payer,
756     uint256 _amount
757     ) private {
758       subFromEscrow(_payer, _amount);
759       token.safeTransfer(_payer, _amount);
760       emit TokenMarketplaceWithdrawal(_payer, _amount);
761   }
762 
763   /**
764    * @notice Pay from escrow of payer to available balance of receiever
765    * @dev Private function to modify balances on payment
766    * @param _payer User with tokens in escrow
767    * @param _receiver User receiving tokens
768    * @param _amount Tokens being sent
769    */
770   function payTokensFromEscrow(address _payer, address _receiver, uint256 _amount) private {
771     subFromEscrow(_payer, _amount);
772     token.safeTransfer(_receiver, _amount);
773   }
774 
775   /**
776    * @notice Pay tokens to receiver from payer's escrow given a valid signature
777    * @dev Execution restricted to attestationLogic contract
778    * @param _payer User paying tokens from escrow
779    * @param _receiver User receiving payment
780    * @param _amount Tokens being paid
781    * @param _nonce Unique Id for sig to make it one-time-use
782    * @param _paymentSig Signed parameters by payer authorizing payment
783    */
784   function requestTokenPayment(
785     address _payer,
786     address _receiver,
787     uint256 _amount,
788     bytes32 _nonce,
789     bytes _paymentSig
790     ) external onlyAttestationLogic {
791 
792     validatePaymentSig(
793       _payer,
794       _receiver,
795       _amount,
796       _nonce,
797       _paymentSig
798     );
799     payTokensFromEscrow(_payer, _receiver, _amount);
800     emit TokenMarketplaceEscrowPayment(_payer, _receiver, _amount);
801   }
802 
803   /**
804    * @notice Verify payment signature is valid
805    * @param _payer User paying tokens from escrow
806    * @param _receiver User receiving payment
807    * @param _amount Tokens being paid
808    * @param _nonce Unique Id for sig to make it one-time-use
809    * @param _paymentSig Signed parameters by payer authorizing payment
810    */
811   function validatePaymentSig(
812     address _payer,
813     address _receiver,
814     uint256 _amount,
815     bytes32 _nonce,
816     bytes _paymentSig
817 
818   ) private {
819     bytes32 _signatureDigest = generatePayTokensSchemaHash(_payer, _receiver, _amount, _nonce);
820     require(_payer == recoverSigner(_signatureDigest, _paymentSig), 'Invalid Payment Signature');
821     burnSignatureDigest(_signatureDigest, _payer);
822   }
823 
824   /**
825    * @notice Helper function to add to escrow balance 
826    * @param _from Account address for escrow mapping
827    * @param _amount Tokens to lock up
828    */
829   function addToEscrow(address _from, uint256 _amount) private {
830     tokenEscrow[_from] = tokenEscrow[_from].add(_amount);
831     emit TokenMarketplaceDeposit(_from, _amount);
832   }
833 
834   /**
835    * Helper function to reduce escrow token balance of user
836    */
837   function subFromEscrow(address _from, uint256 _amount) private {
838     require(tokenEscrow[_from] >= _amount);
839     tokenEscrow[_from] = tokenEscrow[_from].sub(_amount);
840   }
841 }
842 
843 /**
844  * @title Initializable
845  * @dev The Initializable contract has an initializer address, and provides basic authorization control
846  * only while in initialization mode. Once changed to production mode the inializer loses authority
847  */
848 contract Initializable {
849   address public initializer;
850   bool public initializing;
851 
852   event InitializationEnded();
853 
854   /**
855    * @dev The Initializable constructor sets the initializer to the provided address
856    */
857   constructor(address _initializer) public {
858     initializer = _initializer;
859     initializing = true;
860   }
861 
862   /**
863    * @dev Throws if called by any account other than the owner.
864    */
865   modifier onlyDuringInitialization() {
866     require(msg.sender == initializer, 'Method can only be called by initializer');
867     require(initializing, 'Method can only be called during initialization');
868     _;
869   }
870 
871   /**
872    * @dev Allows the initializer to end the initialization period
873    */
874   function endInitialization() public onlyDuringInitialization {
875     initializing = false;
876     emit InitializationEnded();
877   }
878 
879 }
880 
881 
882 /**
883  * @title AttestationLogic allows users to submit attestations given valid signatures
884  * @notice Attestation Logic Logic provides a public interface for Bloom and
885  *  users to submit attestations.
886  */
887 contract AttestationLogic is Initializable, SigningLogic{
888     TokenEscrowMarketplace public tokenEscrowMarketplace;
889 
890   /**
891    * @notice AttestationLogic constructor sets the implementation address of all related contracts
892    * @param _tokenEscrowMarketplace Address of marketplace holding tokens which are
893    *  released to attesters upon completion of a job
894    */
895   constructor(
896     address _initializer,
897     TokenEscrowMarketplace _tokenEscrowMarketplace
898     ) Initializable(_initializer) SigningLogic("Bloom Attestation Logic", "2", 1) public {
899     tokenEscrowMarketplace = _tokenEscrowMarketplace;
900   }
901 
902   event TraitAttested(
903     address subject,
904     address attester,
905     address requester,
906     bytes32 dataHash
907     );
908   event AttestationRejected(address indexed attester, address indexed requester);
909   event AttestationRevoked(bytes32 link, address attester);
910   event TokenEscrowMarketplaceChanged(address oldTokenEscrowMarketplace, address newTokenEscrowMarketplace);
911 
912   /**
913    * @notice Function for attester to submit attestation from their own account) 
914    * @dev Wrapper for attestForUser using msg.sender
915    * @param _subject User this attestation is about
916    * @param _requester User requesting and paying for this attestation in BLT
917    * @param _reward Payment to attester from requester in BLT
918    * @param _requesterSig Signature authorizing payment from requester to attester
919    * @param _dataHash Hash of data being attested and nonce
920    * @param _requestNonce Nonce in sig signed by subject and requester so they can't be replayed
921    * @param _subjectSig Signed authorization from subject with attestation agreement
922    */
923   function attest(
924     address _subject,
925     address _requester,
926     uint256 _reward,
927     bytes _requesterSig,
928     bytes32 _dataHash,
929     bytes32 _requestNonce,
930     bytes _subjectSig // Sig of subject with requester, attester, dataHash, requestNonce
931   ) external {
932     attestForUser(
933       _subject,
934       msg.sender,
935       _requester,
936       _reward,
937       _requesterSig,
938       _dataHash,
939       _requestNonce,
940       _subjectSig
941     );
942   }
943 
944   /**
945    * @notice Submit attestation for a user in order to pay the gas costs
946    * @dev Recover signer of delegation message. If attester matches delegation signature, add the attestation
947    * @param _subject user this attestation is about
948    * @param _attester user completing the attestation
949    * @param _requester user requesting this attestation be completed and paying for it in BLT
950    * @param _reward payment to attester from requester in BLT wei
951    * @param _requesterSig signature authorizing payment from requester to attester
952    * @param _dataHash hash of data being attested and nonce
953    * @param _requestNonce Nonce in sig signed by subject and requester so they can't be replayed
954    * @param _subjectSig signed authorization from subject with attestation agreement
955    * @param _delegationSig signature authorizing attestation on behalf of attester
956    */
957   function attestFor(
958     address _subject,
959     address _attester,
960     address _requester,
961     uint256 _reward,
962     bytes _requesterSig,
963     bytes32 _dataHash,
964     bytes32 _requestNonce,
965     bytes _subjectSig, // Sig of subject with dataHash and requestNonce
966     bytes _delegationSig
967   ) external {
968     // Confirm attester address matches recovered address from signature
969     validateAttestForSig(_subject, _attester, _requester, _reward, _dataHash, _requestNonce, _delegationSig);
970     attestForUser(
971       _subject,
972       _attester,
973       _requester,
974       _reward,
975       _requesterSig,
976       _dataHash,
977       _requestNonce,
978       _subjectSig
979     );
980   }
981 
982   /**
983    * @notice Perform attestation
984    * @dev Verify valid certainty level and user addresses
985    * @param _subject user this attestation is about
986    * @param _attester user completing the attestation
987    * @param _requester user requesting this attestation be completed and paying for it in BLT
988    * @param _reward payment to attester from requester in BLT wei
989    * @param _requesterSig signature authorizing payment from requester to attester
990    * @param _dataHash hash of data being attested and nonce
991    * @param _requestNonce Nonce in sig signed by subject and requester so they can't be replayed
992    * @param _subjectSig signed authorization from subject with attestation agreement
993    */
994   function attestForUser(
995     address _subject,
996     address _attester,
997     address _requester,
998     uint256 _reward,
999     bytes _requesterSig,
1000     bytes32 _dataHash,
1001     bytes32 _requestNonce,
1002     bytes _subjectSig
1003     ) private {
1004     
1005     validateSubjectSig(
1006       _subject,
1007       _dataHash,
1008       _requestNonce,
1009       _subjectSig
1010     );
1011 
1012     emit TraitAttested(
1013       _subject,
1014       _attester,
1015       _requester,
1016       _dataHash
1017     );
1018 
1019     if (_reward > 0) {
1020       tokenEscrowMarketplace.requestTokenPayment(_requester, _attester, _reward, _requestNonce, _requesterSig);
1021     }
1022   }
1023 
1024   /**
1025    * @notice Function for attester to reject an attestation and receive payment 
1026    *  without associating the negative attestation with the subject's bloomId
1027    * @param _requester User requesting and paying for this attestation in BLT
1028    * @param _reward Payment to attester from requester in BLT
1029    * @param _requestNonce Nonce in sig signed by requester so it can't be replayed
1030    * @param _requesterSig Signature authorizing payment from requester to attester
1031    */
1032   function contest(
1033     address _requester,
1034     uint256 _reward,
1035     bytes32 _requestNonce,
1036     bytes _requesterSig
1037   ) external {
1038     contestForUser(
1039       msg.sender,
1040       _requester,
1041       _reward,
1042       _requestNonce,
1043       _requesterSig
1044     );
1045   }
1046 
1047   /**
1048    * @notice Function for attester to reject an attestation and receive payment 
1049    *  without associating the negative attestation with the subject's bloomId
1050    *  Perform on behalf of attester to pay gas fees
1051    * @param _requester User requesting and paying for this attestation in BLT
1052    * @param _attester user completing the attestation
1053    * @param _reward Payment to attester from requester in BLT
1054    * @param _requestNonce Nonce in sig signed by requester so it can't be replayed
1055    * @param _requesterSig Signature authorizing payment from requester to attester
1056    */
1057   function contestFor(
1058     address _attester,
1059     address _requester,
1060     uint256 _reward,
1061     bytes32 _requestNonce,
1062     bytes _requesterSig,
1063     bytes _delegationSig
1064   ) external {
1065     validateContestForSig(
1066       _attester,
1067       _requester,
1068       _reward,
1069       _requestNonce,
1070       _delegationSig
1071     );
1072     contestForUser(
1073       _attester,
1074       _requester,
1075       _reward,
1076       _requestNonce,
1077       _requesterSig
1078     );
1079   }
1080 
1081   /**
1082    * @notice Private function for attester to reject an attestation and receive payment 
1083    *  without associating the negative attestation with the subject's bloomId
1084    * @param _attester user completing the attestation
1085    * @param _requester user requesting this attestation be completed and paying for it in BLT
1086    * @param _reward payment to attester from requester in BLT wei
1087    * @param _requestNonce Nonce in sig signed by requester so it can't be replayed
1088    * @param _requesterSig signature authorizing payment from requester to attester
1089    */
1090   function contestForUser(
1091     address _attester,
1092     address _requester,
1093     uint256 _reward,
1094     bytes32 _requestNonce,
1095     bytes _requesterSig
1096     ) private {
1097 
1098     if (_reward > 0) {
1099       tokenEscrowMarketplace.requestTokenPayment(_requester, _attester, _reward, _requestNonce, _requesterSig);
1100     }
1101     emit AttestationRejected(_attester, _requester);
1102   }
1103 
1104   /**
1105    * @notice Verify subject signature is valid 
1106    * @param _subject user this attestation is about
1107    * @param _dataHash hash of data being attested and nonce
1108    * param _requestNonce Nonce in sig signed by subject so it can't be replayed
1109    * @param _subjectSig Signed authorization from subject with attestation agreement
1110    */
1111   function validateSubjectSig(
1112     address _subject,
1113     bytes32 _dataHash,
1114     bytes32 _requestNonce,
1115     bytes _subjectSig
1116   ) private {
1117     bytes32 _signatureDigest = generateRequestAttestationSchemaHash(_dataHash, _requestNonce);
1118     require(_subject == recoverSigner(_signatureDigest, _subjectSig));
1119     burnSignatureDigest(_signatureDigest, _subject);
1120   }
1121 
1122   /**
1123    * @notice Verify attester delegation signature is valid 
1124    * @param _subject user this attestation is about
1125    * @param _attester user completing the attestation
1126    * @param _requester user requesting this attestation be completed and paying for it in BLT
1127    * @param _reward payment to attester from requester in BLT wei
1128    * @param _dataHash hash of data being attested and nonce
1129    * @param _requestNonce nonce in sig signed by subject so it can't be replayed
1130    * @param _delegationSig signature authorizing attestation on behalf of attester
1131    */
1132   function validateAttestForSig(
1133     address _subject,
1134     address _attester,
1135     address _requester,
1136     uint256 _reward,
1137     bytes32 _dataHash,
1138     bytes32 _requestNonce,
1139     bytes _delegationSig
1140   ) private {
1141     bytes32 _delegationDigest = generateAttestForDelegationSchemaHash(_subject, _requester, _reward, _dataHash, _requestNonce);
1142     require(_attester == recoverSigner(_delegationDigest, _delegationSig), 'Invalid AttestFor Signature');
1143     burnSignatureDigest(_delegationDigest, _attester);
1144   }
1145 
1146   /**
1147    * @notice Verify attester delegation signature is valid 
1148    * @param _attester user completing the attestation
1149    * @param _requester user requesting this attestation be completed and paying for it in BLT
1150    * @param _reward payment to attester from requester in BLT wei
1151    * @param _requestNonce nonce referenced in TokenEscrowMarketplace so payment sig can't be replayed
1152    * @param _delegationSig signature authorizing attestation on behalf of attester
1153    */
1154   function validateContestForSig(
1155     address _attester,
1156     address _requester,
1157     uint256 _reward,
1158     bytes32 _requestNonce,
1159     bytes _delegationSig
1160   ) private {
1161     bytes32 _delegationDigest = generateContestForDelegationSchemaHash(_requester, _reward, _requestNonce);
1162     require(_attester == recoverSigner(_delegationDigest, _delegationSig), 'Invalid ContestFor Signature');
1163     burnSignatureDigest(_delegationDigest, _attester);
1164   }
1165 
1166   /**
1167    * @notice Submit attestation completed prior to deployment of this contract
1168    * @dev Gives initializer privileges to write attestations during the initialization period without signatures
1169    * @param _requester user requesting this attestation be completed 
1170    * @param _attester user completing the attestation
1171    * @param _subject user this attestation is about
1172    * @param _dataHash hash of data being attested
1173    */
1174   function migrateAttestation(
1175     address _requester,
1176     address _attester,
1177     address _subject,
1178     bytes32 _dataHash
1179   ) public onlyDuringInitialization {
1180     emit TraitAttested(
1181       _subject,
1182       _attester,
1183       _requester,
1184       _dataHash
1185     );
1186   }
1187 
1188   /**
1189    * @notice Revoke an attestation
1190    * @dev Link is included in dataHash and cannot be directly connected to a BloomID
1191    * @param _link bytes string embedded in dataHash to link revocation
1192    */
1193   function revokeAttestation(
1194     bytes32 _link
1195     ) external {
1196       revokeAttestationForUser(_link, msg.sender);
1197   }
1198 
1199   /**
1200    * @notice Revoke an attestation
1201    * @dev Link is included in dataHash and cannot be directly connected to a BloomID
1202    * @param _link bytes string embedded in dataHash to link revocation
1203    */
1204   function revokeAttestationFor(
1205     address _sender,
1206     bytes32 _link,
1207     bytes32 _nonce,
1208     bytes _delegationSig
1209     ) external {
1210       validateRevokeForSig(_sender, _link, _nonce, _delegationSig);
1211       revokeAttestationForUser(_link, _sender);
1212   }
1213 
1214   /**
1215    * @notice Verify revocation signature is valid 
1216    * @param _link bytes string embedded in dataHash to link revocation
1217    * @param _sender user revoking attestation
1218    * @param _delegationSig signature authorizing revocation on behalf of revoker
1219    */
1220   function validateRevokeForSig(
1221     address _sender,
1222     bytes32 _link,
1223     bytes32 _nonce,
1224     bytes _delegationSig
1225   ) private {
1226     bytes32 _delegationDigest = generateRevokeAttestationForDelegationSchemaHash(_link, _nonce);
1227     require(_sender == recoverSigner(_delegationDigest, _delegationSig), 'Invalid RevokeFor Signature');
1228     burnSignatureDigest(_delegationDigest, _sender);
1229   }
1230 
1231   /**
1232    * @notice Revoke an attestation
1233    * @dev Link is included in dataHash and cannot be directly connected to a BloomID
1234    * @param _link bytes string embedded in dataHash to link revocation
1235    * @param _sender address identify revoker
1236    */
1237   function revokeAttestationForUser(
1238     bytes32 _link,
1239     address _sender
1240     ) private {
1241       emit AttestationRevoked(_link, _sender);
1242   }
1243 
1244     /**
1245    * @notice Set the implementation of the TokenEscrowMarketplace contract by setting a new address
1246    * @dev Restricted to initializer
1247    * @param _newTokenEscrowMarketplace Address of new SigningLogic implementation
1248    */
1249   function setTokenEscrowMarketplace(TokenEscrowMarketplace _newTokenEscrowMarketplace) external onlyDuringInitialization {
1250     address oldTokenEscrowMarketplace = tokenEscrowMarketplace;
1251     tokenEscrowMarketplace = _newTokenEscrowMarketplace;
1252     emit TokenEscrowMarketplaceChanged(oldTokenEscrowMarketplace, tokenEscrowMarketplace);
1253   }
1254 
1255 }