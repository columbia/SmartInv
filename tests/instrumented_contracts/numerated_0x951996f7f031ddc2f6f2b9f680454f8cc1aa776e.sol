1 pragma solidity 0.4.25;
2 
3 
4 /********************* TPL Extended Jurisdiction - Devcon4 ********************
5  * Use at your own risk, these contracts still need more testing & auditing!  *
6  * For a more production-ready TPL jurisdiction, see the Basic Jurisdiction.  *
7  * Documentation & tests at https://github.com/TPL-protocol/tpl-contracts     *
8  * Implements an Attribute Registry https://github.com/0age/AttributeRegistry *
9  *                                                                            *
10  * Source layout:                                    Line #                   *
11  *  - library ECDSA                                    41                     *
12  *  - library SafeMath                                108                     *
13  *  - library Roles                                   172                     *
14  *  - contract PauserRole                             212                     *
15  *    - using Roles for Roles.Role                                            *
16  *  - contract Pausable                               257                     *
17  *    - is PauserRole                                                         *
18  *  - contract Ownable                                313                     *
19  *  - interface AttributeRegistryInterface            386                     *
20  *  - interface BasicJurisdictionInterface            440                     *
21  *  - interface ExtendedJurisdictionInterface         658                     *
22  *  - ExtendedJurisdiction                            926                     *
23  *    - is Ownable                                                            *
24  *    - is Pausable                                                           *
25  *    - is AttributeRegistryInterface                                         *
26  *    - is BasicJurisdictionInterface                                         *
27  *    - is ExtendedJurisdictionInterface                                      *
28  *    - using ECDSA for bytes32                                               *
29  *    - using SafeMath for uint256                                            *
30  *                                                                            *
31  *  https://github.com/TPL-protocol/tpl-contracts/blob/master/LICENSE.md      *
32  ******************************************************************************/
33 
34 
35 /**
36  * @title Elliptic curve signature operations
37  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
38  * TODO Remove this library once solidity supports passing a signature to ecrecover.
39  * See https://github.com/ethereum/solidity/issues/864
40  */
41 library ECDSA {
42   /**
43    * @dev Recover signer address from a message by using their signature
44    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
45    * @param signature bytes signature, the signature is generated using web3.eth.sign()
46    */
47   function recover(bytes32 hash, bytes signature)
48     internal
49     pure
50     returns (address)
51   {
52     bytes32 r;
53     bytes32 s;
54     uint8 v;
55 
56     // Check the signature length
57     if (signature.length != 65) {
58       return (address(0));
59     }
60 
61     // Divide the signature in r, s and v variables
62     // ecrecover takes the signature parameters, and the only way to get them
63     // currently is to use assembly.
64     // solium-disable-next-line security/no-inline-assembly
65     assembly {
66       r := mload(add(signature, 0x20))
67       s := mload(add(signature, 0x40))
68       v := byte(0, mload(add(signature, 0x60)))
69     }
70 
71     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
72     if (v < 27) {
73       v += 27;
74     }
75 
76     // If the version is correct return the signer address
77     if (v != 27 && v != 28) {
78       return (address(0));
79     } else {
80       // solium-disable-next-line arg-overflow
81       return ecrecover(hash, v, r, s);
82     }
83   }
84 
85   /**
86    * toEthSignedMessageHash
87    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
88    * and hash the result
89    */
90   function toEthSignedMessageHash(bytes32 hash)
91     internal
92     pure
93     returns (bytes32)
94   {
95     // 32 is the length in bytes of hash,
96     // enforced by the type signature above
97     return keccak256(
98       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
99     );
100   }
101 }
102 
103 
104 /**
105  * @title SafeMath
106  * @dev Math operations with safety checks that revert on error
107  */
108 library SafeMath {
109   /**
110   * @dev Multiplies two numbers, reverts on overflow.
111   */
112   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
114     // benefit is lost if 'b' is also tested.
115     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
116     if (a == 0) {
117       return 0;
118     }
119 
120     uint256 c = a * b;
121     require(c / a == b);
122 
123     return c;
124   }
125 
126   /**
127   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
128   */
129   function div(uint256 a, uint256 b) internal pure returns (uint256) {
130     require(b > 0); // Solidity only automatically asserts when dividing by 0
131     uint256 c = a / b;
132     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133 
134     return c;
135   }
136 
137   /**
138   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
139   */
140   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141     require(b <= a);
142     uint256 c = a - b;
143 
144     return c;
145   }
146 
147   /**
148   * @dev Adds two numbers, reverts on overflow.
149   */
150   function add(uint256 a, uint256 b) internal pure returns (uint256) {
151     uint256 c = a + b;
152     require(c >= a);
153 
154     return c;
155   }
156 
157   /**
158   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
159   * reverts when dividing by zero.
160   */
161   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
162     require(b != 0);
163     return a % b;
164   }
165 }
166 
167 
168 /**
169  * @title Roles
170  * @dev Library for managing addresses assigned to a Role.
171  */
172 library Roles {
173   struct Role {
174     mapping (address => bool) bearer;
175   }
176 
177   /**
178    * @dev give an account access to this role
179    */
180   function add(Role storage role, address account) internal {
181     require(account != address(0));
182     require(!has(role, account));
183 
184     role.bearer[account] = true;
185   }
186 
187   /**
188    * @dev remove an account's access to this role
189    */
190   function remove(Role storage role, address account) internal {
191     require(account != address(0));
192     require(has(role, account));
193 
194     role.bearer[account] = false;
195   }
196 
197   /**
198    * @dev check if an account has this role
199    * @return bool
200    */
201   function has(Role storage role, address account)
202     internal
203     view
204     returns (bool)
205   {
206     require(account != address(0));
207     return role.bearer[account];
208   }
209 }
210 
211 
212 contract PauserRole {
213   using Roles for Roles.Role;
214 
215   event PauserAdded(address indexed account);
216   event PauserRemoved(address indexed account);
217 
218   Roles.Role private pausers;
219 
220   constructor() internal {
221     _addPauser(msg.sender);
222   }
223 
224   modifier onlyPauser() {
225     require(isPauser(msg.sender));
226     _;
227   }
228 
229   function isPauser(address account) public view returns (bool) {
230     return pausers.has(account);
231   }
232 
233   function addPauser(address account) public onlyPauser {
234     _addPauser(account);
235   }
236 
237   function renouncePauser() public {
238     _removePauser(msg.sender);
239   }
240 
241   function _addPauser(address account) internal {
242     pausers.add(account);
243     emit PauserAdded(account);
244   }
245 
246   function _removePauser(address account) internal {
247     pausers.remove(account);
248     emit PauserRemoved(account);
249   }
250 }
251 
252 
253 /**
254  * @title Pausable
255  * @dev Base contract which allows children to implement an emergency stop mechanism.
256  */
257 contract Pausable is PauserRole {
258   event Paused(address account);
259   event Unpaused(address account);
260 
261   bool private _paused;
262 
263   constructor() internal {
264     _paused = false;
265   }
266 
267   /**
268    * @return true if the contract is paused, false otherwise.
269    */
270   function paused() public view returns(bool) {
271     return _paused;
272   }
273 
274   /**
275    * @dev Modifier to make a function callable only when the contract is not paused.
276    */
277   modifier whenNotPaused() {
278     require(!_paused);
279     _;
280   }
281 
282   /**
283    * @dev Modifier to make a function callable only when the contract is paused.
284    */
285   modifier whenPaused() {
286     require(_paused);
287     _;
288   }
289 
290   /**
291    * @dev called by the owner to pause, triggers stopped state
292    */
293   function pause() public onlyPauser whenNotPaused {
294     _paused = true;
295     emit Paused(msg.sender);
296   }
297 
298   /**
299    * @dev called by the owner to unpause, returns to normal state
300    */
301   function unpause() public onlyPauser whenPaused {
302     _paused = false;
303     emit Unpaused(msg.sender);
304   }
305 }
306 
307 
308 /**
309  * @title Ownable
310  * @dev The Ownable contract has an owner address, and provides basic authorization control
311  * functions, this simplifies the implementation of "user permissions".
312  */
313 contract Ownable {
314   address private _owner;
315 
316   event OwnershipTransferred(
317     address indexed previousOwner,
318     address indexed newOwner
319   );
320 
321   /**
322    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
323    * account.
324    */
325   constructor() internal {
326     _owner = msg.sender;
327     emit OwnershipTransferred(address(0), _owner);
328   }
329 
330   /**
331    * @return the address of the owner.
332    */
333   function owner() public view returns(address) {
334     return _owner;
335   }
336 
337   /**
338    * @dev Throws if called by any account other than the owner.
339    */
340   modifier onlyOwner() {
341     require(isOwner());
342     _;
343   }
344 
345   /**
346    * @return true if `msg.sender` is the owner of the contract.
347    */
348   function isOwner() public view returns(bool) {
349     return msg.sender == _owner;
350   }
351 
352   /**
353    * @dev Allows the current owner to relinquish control of the contract.
354    * @notice Renouncing to ownership will leave the contract without an owner.
355    * It will not be possible to call the functions with the `onlyOwner`
356    * modifier anymore.
357    */
358   function renounceOwnership() public onlyOwner {
359     emit OwnershipTransferred(_owner, address(0));
360     _owner = address(0);
361   }
362 
363   /**
364    * @dev Allows the current owner to transfer control of the contract to a newOwner.
365    * @param newOwner The address to transfer ownership to.
366    */
367   function transferOwnership(address newOwner) public onlyOwner {
368     _transferOwnership(newOwner);
369   }
370 
371   /**
372    * @dev Transfers control of the contract to a newOwner.
373    * @param newOwner The address to transfer ownership to.
374    */
375   function _transferOwnership(address newOwner) internal {
376     require(newOwner != address(0));
377     emit OwnershipTransferred(_owner, newOwner);
378     _owner = newOwner;
379   }
380 }
381 
382 
383 /**
384  * @title Attribute Registry interface. EIP-165 ID: 0x5f46473f
385  */
386 interface AttributeRegistryInterface {
387   /**
388    * @notice Check if an attribute of the type with ID `attributeTypeID` has
389    * been assigned to the account at `account` and is currently valid.
390    * @param account address The account to check for a valid attribute.
391    * @param attributeTypeID uint256 The ID of the attribute type to check for.
392    * @return True if the attribute is assigned and valid, false otherwise.
393    * @dev This function MUST return either true or false - i.e. calling this
394    * function MUST NOT cause the caller to revert.
395    */
396   function hasAttribute(
397     address account,
398     uint256 attributeTypeID
399   ) external view returns (bool);
400 
401   /**
402    * @notice Retrieve the value of the attribute of the type with ID
403    * `attributeTypeID` on the account at `account`, assuming it is valid.
404    * @param account address The account to check for the given attribute value.
405    * @param attributeTypeID uint256 The ID of the attribute type to check for.
406    * @return The attribute value if the attribute is valid, reverts otherwise.
407    * @dev This function MUST revert if a directly preceding or subsequent
408    * function call to `hasAttribute` with identical `account` and
409    * `attributeTypeID` parameters would return false.
410    */
411   function getAttributeValue(
412     address account,
413     uint256 attributeTypeID
414   ) external view returns (uint256);
415 
416   /**
417    * @notice Count the number of attribute types defined by the registry.
418    * @return The number of available attribute types.
419    * @dev This function MUST return a positive integer value  - i.e. calling
420    * this function MUST NOT cause the caller to revert.
421    */
422   function countAttributeTypes() external view returns (uint256);
423 
424   /**
425    * @notice Get the ID of the attribute type at index `index`.
426    * @param index uint256 The index of the attribute type in question.
427    * @return The ID of the attribute type.
428    * @dev This function MUST revert if the provided `index` value falls outside
429    * of the range of the value returned from a directly preceding or subsequent
430    * function call to `countAttributeTypes`. It MUST NOT revert if the provided
431    * `index` value falls inside said range.
432    */
433   function getAttributeTypeID(uint256 index) external view returns (uint256);
434 }
435 
436 
437 /**
438  * @title Basic TPL Jurisdiction Interface.
439  */
440 interface BasicJurisdictionInterface {
441   // declare events
442   event AttributeTypeAdded(uint256 indexed attributeTypeID, string description);
443   
444   event AttributeTypeRemoved(uint256 indexed attributeTypeID);
445   
446   event ValidatorAdded(address indexed validator, string description);
447   
448   event ValidatorRemoved(address indexed validator);
449   
450   event ValidatorApprovalAdded(
451     address validator,
452     uint256 indexed attributeTypeID
453   );
454 
455   event ValidatorApprovalRemoved(
456     address validator,
457     uint256 indexed attributeTypeID
458   );
459 
460   event AttributeAdded(
461     address validator,
462     address indexed attributee,
463     uint256 attributeTypeID,
464     uint256 attributeValue
465   );
466 
467   event AttributeRemoved(
468     address validator,
469     address indexed attributee,
470     uint256 attributeTypeID
471   );
472 
473   /**
474   * @notice Add an attribute type with ID `ID` and description `description` to
475   * the jurisdiction.
476   * @param ID uint256 The ID of the attribute type to add.
477   * @param description string A description of the attribute type.
478   * @dev Once an attribute type is added with a given ID, the description of the
479   * attribute type cannot be changed, even if the attribute type is removed and
480   * added back later.
481   */
482   function addAttributeType(uint256 ID, string description) external;
483 
484   /**
485   * @notice Remove the attribute type with ID `ID` from the jurisdiction.
486   * @param ID uint256 The ID of the attribute type to remove.
487   * @dev All issued attributes of the given type will become invalid upon
488   * removal, but will become valid again if the attribute is reinstated.
489   */
490   function removeAttributeType(uint256 ID) external;
491 
492   /**
493   * @notice Add account `validator` as a validator with a description
494   * `description` who can be approved to set attributes of specific types.
495   * @param validator address The account to assign as the validator.
496   * @param description string A description of the validator.
497   * @dev Note that the jurisdiction can add iteslf as a validator if desired.
498   */
499   function addValidator(address validator, string description) external;
500 
501   /**
502   * @notice Remove the validator at address `validator` from the jurisdiction.
503   * @param validator address The account of the validator to remove.
504   * @dev Any attributes issued by the validator will become invalid upon their
505   * removal. If the validator is reinstated, those attributes will become valid
506   * again. Any approvals to issue attributes of a given type will need to be
507   * set from scratch in the event a validator is reinstated.
508   */
509   function removeValidator(address validator) external;
510 
511   /**
512   * @notice Approve the validator at address `validator` to issue attributes of
513   * the type with ID `attributeTypeID`.
514   * @param validator address The account of the validator to approve.
515   * @param attributeTypeID uint256 The ID of the approved attribute type.
516   */
517   function addValidatorApproval(
518     address validator,
519     uint256 attributeTypeID
520   ) external;
521 
522   /**
523   * @notice Deny the validator at address `validator` the ability to continue to
524   * issue attributes of the type with ID `attributeTypeID`.
525   * @param validator address The account of the validator with removed approval.
526   * @param attributeTypeID uint256 The ID of the attribute type to unapprove.
527   * @dev Any attributes of the specified type issued by the validator in
528   * question will become invalid once the approval is removed. If the approval
529   * is reinstated, those attributes will become valid again. The approval will
530   * also be removed if the approved validator is removed.
531   */
532   function removeValidatorApproval(
533     address validator,
534     uint256 attributeTypeID
535   ) external;
536 
537   /**
538   * @notice Issue an attribute of the type with ID `attributeTypeID` and a value
539   * of `value` to `account` if `message.caller.address()` is approved validator.
540   * @param account address The account to issue the attribute on.
541   * @param attributeTypeID uint256 The ID of the attribute type to issue.
542   * @param value uint256 An optional value for the issued attribute.
543   * @dev Existing attributes of the given type on the address must be removed
544   * in order to set a new attribute. Be aware that ownership of the account to
545   * which the attribute is assigned may still be transferable - restricting
546   * assignment to externally-owned accounts may partially alleviate this issue.
547   */
548   function issueAttribute(
549     address account,
550     uint256 attributeTypeID,
551     uint256 value
552   ) external payable;
553 
554   /**
555   * @notice Revoke the attribute of the type with ID `attributeTypeID` from
556   * `account` if `message.caller.address()` is the issuing validator.
557   * @param account address The account to issue the attribute on.
558   * @param attributeTypeID uint256 The ID of the attribute type to issue.
559   * @dev Validators may still revoke issued attributes even after they have been
560   * removed or had their approval to issue the attribute type removed - this
561   * enables them to address any objectionable issuances before being reinstated.
562   */
563   function revokeAttribute(
564     address account,
565     uint256 attributeTypeID
566   ) external;
567 
568   /**
569    * @notice Determine if a validator at account `validator` is able to issue
570    * attributes of the type with ID `attributeTypeID`.
571    * @param validator address The account of the validator.
572    * @param attributeTypeID uint256 The ID of the attribute type to check.
573    * @return True if the validator can issue attributes of the given type, false
574    * otherwise.
575    */
576   function canIssueAttributeType(
577     address validator,
578     uint256 attributeTypeID
579   ) external view returns (bool);
580 
581   /**
582    * @notice Get a description of the attribute type with ID `attributeTypeID`.
583    * @param attributeTypeID uint256 The ID of the attribute type to check for.
584    * @return A description of the attribute type.
585    */
586   function getAttributeTypeDescription(
587     uint256 attributeTypeID
588   ) external view returns (string description);
589   
590   /**
591    * @notice Get a description of the validator at account `validator`.
592    * @param validator address The account of the validator in question.
593    * @return A description of the validator.
594    */
595   function getValidatorDescription(
596     address validator
597   ) external view returns (string description);
598 
599   /**
600    * @notice Find the validator that issued the attribute of the type with ID
601    * `attributeTypeID` on the account at `account` and determine if the
602    * validator is still valid.
603    * @param account address The account that contains the attribute be checked.
604    * @param attributeTypeID uint256 The ID of the attribute type in question.
605    * @return The validator and the current status of the validator as it
606    * pertains to the attribute type in question.
607    * @dev if no attribute of the given attribute type exists on the account, the
608    * function will return (address(0), false).
609    */
610   function getAttributeValidator(
611     address account,
612     uint256 attributeTypeID
613   ) external view returns (address validator, bool isStillValid);
614 
615   /**
616    * @notice Count the number of attribute types defined by the jurisdiction.
617    * @return The number of available attribute types.
618    */
619   function countAttributeTypes() external view returns (uint256);
620 
621   /**
622    * @notice Get the ID of the attribute type at index `index`.
623    * @param index uint256 The index of the attribute type in question.
624    * @return The ID of the attribute type.
625    */
626   function getAttributeTypeID(uint256 index) external view returns (uint256);
627 
628   /**
629    * @notice Get the IDs of all available attribute types on the jurisdiction.
630    * @return A dynamic array containing all available attribute type IDs.
631    */
632   function getAttributeTypeIDs() external view returns (uint256[]);
633 
634   /**
635    * @notice Count the number of validators defined by the jurisdiction.
636    * @return The number of defined validators.
637    */
638   function countValidators() external view returns (uint256);
639 
640   /**
641    * @notice Get the account of the validator at index `index`.
642    * @param index uint256 The index of the validator in question.
643    * @return The account of the validator.
644    */
645   function getValidator(uint256 index) external view returns (address);
646 
647   /**
648    * @notice Get the accounts of all available validators on the jurisdiction.
649    * @return A dynamic array containing all available validator accounts.
650    */
651   function getValidators() external view returns (address[]);
652 }
653 
654 /**
655  * @title Extended TPL Jurisdiction Interface.
656  * @dev this extends BasicJurisdictionInterface for additional functionality.
657  */
658 interface ExtendedJurisdictionInterface {
659   // declare events (NOTE: consider which fields should be indexed)
660   event ValidatorSigningKeyModified(
661     address indexed validator,
662     address newSigningKey
663   );
664 
665   event StakeAllocated(
666     address indexed staker,
667     uint256 indexed attribute,
668     uint256 amount
669   );
670 
671   event StakeRefunded(
672     address indexed staker,
673     uint256 indexed attribute,
674     uint256 amount
675   );
676 
677   event FeePaid(
678     address indexed recipient,
679     address indexed payee,
680     uint256 indexed attribute,
681     uint256 amount
682   );
683   
684   event TransactionRebatePaid(
685     address indexed submitter,
686     address indexed payee,
687     uint256 indexed attribute,
688     uint256 amount
689   );
690 
691   /**
692   * @notice Add a restricted attribute type with ID `ID` and description
693   * `description` to the jurisdiction. Restricted attribute types can only be
694   * removed by the issuing validator or the jurisdiction.
695   * @param ID uint256 The ID of the restricted attribute type to add.
696   * @param description string A description of the restricted attribute type.
697   * @dev Once an attribute type is added with a given ID, the description or the
698   * restricted status of the attribute type cannot be changed, even if the
699   * attribute type is removed and added back later.
700   */
701   function addRestrictedAttributeType(uint256 ID, string description) external;
702 
703   /**
704   * @notice Enable or disable a restriction for a given attribute type ID `ID`
705   * that prevents attributes of the given type from being set by operators based
706   * on the provided value for `onlyPersonal`.
707   * @param ID uint256 The attribute type ID in question.
708   * @param onlyPersonal bool Whether the address may only be set personally.
709   */
710   function setAttributeTypeOnlyPersonal(uint256 ID, bool onlyPersonal) external;
711 
712   /**
713   * @notice Set a secondary source for a given attribute type ID `ID`, with an
714   * address `registry` of the secondary source in question and a given
715   * `sourceAttributeTypeID` for attribute type ID to check on the secondary
716   * source. The secondary source will only be checked for the given attribute in
717   * cases where no attribute of the given attribute type ID is assigned locally.
718   * @param ID uint256 The attribute type ID to set the secondary source for.
719   * @param attributeRegistry address The secondary attribute registry account.
720   * @param sourceAttributeTypeID uint256 The attribute type ID on the secondary
721   * source to check.
722   * @dev To remove a secondary source on an attribute type, the registry address
723   * should be set to the null address.
724   */
725   function setAttributeTypeSecondarySource(
726     uint256 ID,
727     address attributeRegistry,
728     uint256 sourceAttributeTypeID
729   ) external;
730 
731   /**
732   * @notice Set a minimum required stake for a given attribute type ID `ID` and
733   * an amount of `stake`, to be locked in the jurisdiction upon assignment of
734   * attributes of the given type. The stake will be applied toward a transaction
735   * rebate in the event the attribute is revoked, with the remainder returned to
736   * the staker.
737   * @param ID uint256 The attribute type ID to set a minimum required stake for.
738   * @param minimumRequiredStake uint256 The minimum required funds to lock up.
739   * @dev To remove a stake requirement from an attribute type, the stake amount
740   * should be set to 0.
741   */
742   function setAttributeTypeMinimumRequiredStake(
743     uint256 ID,
744     uint256 minimumRequiredStake
745   ) external;
746 
747   /**
748   * @notice Set a required fee for a given attribute type ID `ID` and an amount
749   * of `fee`, to be paid to the owner of the jurisdiction upon assignment of
750   * attributes of the given type.
751   * @param ID uint256 The attribute type ID to set the required fee for.
752   * @param fee uint256 The required fee amount to be paid upon assignment.
753   * @dev To remove a fee requirement from an attribute type, the fee amount
754   * should be set to 0.
755   */
756   function setAttributeTypeJurisdictionFee(uint256 ID, uint256 fee) external;
757 
758   /**
759   * @notice Set the public address associated with a validator signing key, used
760   * to sign off-chain attribute approvals, as `newSigningKey`.
761   * @param newSigningKey address The address associated with signing key to set.
762   */
763   function setValidatorSigningKey(address newSigningKey) external;
764 
765   /**
766   * @notice Add an attribute of the type with ID `attributeTypeID`, an attribute
767   * value of `value`, and an associated validator fee of `validatorFee` to
768   * account of `msg.sender` by passing in a signed attribute approval with
769   * signature `signature`.
770   * @param attributeTypeID uint256 The ID of the attribute type to add.
771   * @param value uint256 The value for the attribute to add.
772   * @param validatorFee uint256 The fee to be paid to the issuing validator.
773   * @param signature bytes The signature from the validator attribute approval.
774   */
775   function addAttribute(
776     uint256 attributeTypeID,
777     uint256 value,
778     uint256 validatorFee,
779     bytes signature
780   ) external payable;
781 
782   /**
783   * @notice Remove an attribute of the type with ID `attributeTypeID` from
784   * account of `msg.sender`.
785   * @param attributeTypeID uint256 The ID of the attribute type to remove.
786   */
787   function removeAttribute(uint256 attributeTypeID) external;
788 
789   /**
790   * @notice Add an attribute of the type with ID `attributeTypeID`, an attribute
791   * value of `value`, and an associated validator fee of `validatorFee` to
792   * account `account` by passing in a signed attribute approval with signature
793   * `signature`.
794   * @param account address The account to add the attribute to.
795   * @param attributeTypeID uint256 The ID of the attribute type to add.
796   * @param value uint256 The value for the attribute to add.
797   * @param validatorFee uint256 The fee to be paid to the issuing validator.
798   * @param signature bytes The signature from the validator attribute approval.
799   * @dev Restricted attribute types can only be removed by issuing validators or
800   * the jurisdiction itself.
801   */
802   function addAttributeFor(
803     address account,
804     uint256 attributeTypeID,
805     uint256 value,
806     uint256 validatorFee,
807     bytes signature
808   ) external payable;
809 
810   /**
811   * @notice Remove an attribute of the type with ID `attributeTypeID` from
812   * account of `account`.
813   * @param account address The account to remove the attribute from.
814   * @param attributeTypeID uint256 The ID of the attribute type to remove.
815   * @dev Restricted attribute types can only be removed by issuing validators or
816   * the jurisdiction itself.
817   */
818   function removeAttributeFor(address account, uint256 attributeTypeID) external;
819 
820   /**
821    * @notice Invalidate a signed attribute approval before it has been set by
822    * supplying the hash of the approval `hash` and the signature `signature`.
823    * @param hash bytes32 The hash of the attribute approval.
824    * @param signature bytes The hash's signature, resolving to the signing key.
825    * @dev Attribute approvals can only be removed by issuing validators or the
826    * jurisdiction itself.
827    */
828   function invalidateAttributeApproval(
829     bytes32 hash,
830     bytes signature
831   ) external;
832 
833   /**
834    * @notice Get the hash of a given attribute approval.
835    * @param account address The account specified by the attribute approval.
836    * @param operator address An optional account permitted to submit approval.
837    * @param attributeTypeID uint256 The ID of the attribute type in question.
838    * @param value uint256 The value of the attribute in the approval.
839    * @param fundsRequired uint256 The amount to be included with the approval.
840    * @param validatorFee uint256 The required fee to be paid to the validator.
841    * @return The hash of the attribute approval.
842    */
843   function getAttributeApprovalHash(
844     address account,
845     address operator,
846     uint256 attributeTypeID,
847     uint256 value,
848     uint256 fundsRequired,
849     uint256 validatorFee
850   ) external view returns (bytes32 hash);
851 
852   /**
853    * @notice Check if a given signed attribute approval is currently valid when
854    * submitted directly by `msg.sender`.
855    * @param attributeTypeID uint256 The ID of the attribute type in question.
856    * @param value uint256 The value of the attribute in the approval.
857    * @param fundsRequired uint256 The amount to be included with the approval.
858    * @param validatorFee uint256 The required fee to be paid to the validator.
859    * @param signature bytes The attribute approval signature, based on a hash of
860    * the other parameters and the submitting account.
861    * @return True if the approval is currently valid, false otherwise.
862    */
863   function canAddAttribute(
864     uint256 attributeTypeID,
865     uint256 value,
866     uint256 fundsRequired,
867     uint256 validatorFee,
868     bytes signature
869   ) external view returns (bool);
870 
871   /**
872    * @notice Check if a given signed attribute approval is currently valid for a
873    * given account when submitted by the operator at `msg.sender`.
874    * @param account address The account specified by the attribute approval.
875    * @param attributeTypeID uint256 The ID of the attribute type in question.
876    * @param value uint256 The value of the attribute in the approval.
877    * @param fundsRequired uint256 The amount to be included with the approval.
878    * @param validatorFee uint256 The required fee to be paid to the validator.
879    * @param signature bytes The attribute approval signature, based on a hash of
880    * the other parameters and the submitting account.
881    * @return True if the approval is currently valid, false otherwise.
882    */
883   function canAddAttributeFor(
884     address account,
885     uint256 attributeTypeID,
886     uint256 value,
887     uint256 fundsRequired,
888     uint256 validatorFee,
889     bytes signature
890   ) external view returns (bool);
891 
892   /**
893    * @notice Get comprehensive information on an attribute type with ID
894    * `attributeTypeID`.
895    * @param attributeTypeID uint256 The attribute type ID in question.
896    * @return Information on the attribute type in question.
897    */
898   function getAttributeTypeInformation(
899     uint256 attributeTypeID
900   ) external view returns (
901     string description,
902     bool isRestricted,
903     bool isOnlyPersonal,
904     address secondarySource,
905     uint256 secondaryId,
906     uint256 minimumRequiredStake,
907     uint256 jurisdictionFee
908   );
909   
910   /**
911    * @notice Get a validator's signing key.
912    * @param validator address The account of the validator.
913    * @return The account referencing the public component of the signing key.
914    */
915   function getValidatorSigningKey(
916     address validator
917   ) external view returns (
918     address signingKey
919   );
920 }
921 
922 
923 /**
924  * @title An extended TPL jurisdiction for assigning attributes to addresses.
925  */
926 contract ExtendedJurisdiction is Ownable, Pausable, AttributeRegistryInterface, BasicJurisdictionInterface, ExtendedJurisdictionInterface {
927   using ECDSA for bytes32;
928   using SafeMath for uint256;
929 
930   // validators are entities who can add or authorize addition of new attributes
931   struct Validator {
932     bool exists;
933     uint256 index; // NOTE: consider use of uint88 to pack struct
934     address signingKey;
935     string description;
936   }
937 
938   // attributes are properties that validators associate with specific addresses
939   struct IssuedAttribute {
940     bool exists;
941     bool setPersonally;
942     address operator;
943     address validator;
944     uint256 value;
945     uint256 stake;
946   }
947 
948   // attributes also have associated type - metadata common to each attribute
949   struct AttributeType {
950     bool exists;
951     bool restricted;
952     bool onlyPersonal;
953     uint256 index; // NOTE: consider use of uint72 to pack struct
954     address secondarySource;
955     uint256 secondaryAttributeTypeID;
956     uint256 minimumStake;
957     uint256 jurisdictionFee;
958     string description;
959     mapping(address => bool) approvedValidators;
960   }
961 
962   // top-level information about attribute types is held in a mapping of structs
963   mapping(uint256 => AttributeType) private _attributeTypes;
964 
965   // the jurisdiction retains a mapping of addresses with assigned attributes
966   mapping(address => mapping(uint256 => IssuedAttribute)) private _issuedAttributes;
967 
968   // there is also a mapping to identify all approved validators and their keys
969   mapping(address => Validator) private _validators;
970 
971   // each registered signing key maps back to a specific validator
972   mapping(address => address) private _signingKeys;
973 
974   // once attribute types are assigned to an ID, they cannot be modified
975   mapping(uint256 => bytes32) private _attributeTypeHashes;
976 
977   // submitted attribute approvals are retained to prevent reuse after removal 
978   mapping(bytes32 => bool) private _invalidAttributeApprovalHashes;
979 
980   // attribute approvals by validator are held in a mapping
981   mapping(address => uint256[]) private _validatorApprovals;
982 
983    // attribute approval index by validator is tracked as well
984   mapping(address => mapping(uint256 => uint256)) private _validatorApprovalsIndex;
985 
986   // IDs for all supplied attributes are held in an array (enables enumeration)
987   uint256[] private _attributeIDs;
988 
989   // addresses for all designated validators are also held in an array
990   address[] private _validatorAccounts;
991 
992   /**
993   * @notice Add an attribute type with ID `ID` and description `description` to
994   * the jurisdiction.
995   * @param ID uint256 The ID of the attribute type to add.
996   * @param description string A description of the attribute type.
997   * @dev Once an attribute type is added with a given ID, the description of the
998   * attribute type cannot be changed, even if the attribute type is removed and
999   * added back later.
1000   */
1001   function addAttributeType(
1002     uint256 ID,
1003     string description
1004   ) external onlyOwner whenNotPaused {
1005     // prevent existing attributes with the same id from being overwritten
1006     require(
1007       !isAttributeType(ID),
1008       "an attribute type with the provided ID already exists"
1009     );
1010 
1011     // calculate a hash of the attribute type based on the type's properties
1012     bytes32 hash = keccak256(
1013       abi.encodePacked(
1014         ID, false, description
1015       )
1016     );
1017 
1018     // store hash if attribute type is the first one registered with provided ID
1019     if (_attributeTypeHashes[ID] == bytes32(0)) {
1020       _attributeTypeHashes[ID] = hash;
1021     }
1022 
1023     // prevent addition if different attribute type with the same ID has existed
1024     require(
1025       hash == _attributeTypeHashes[ID],
1026       "attribute type properties must match initial properties assigned to ID"
1027     );
1028 
1029     // set the attribute mapping, assigning the index as the end of attributeID
1030     _attributeTypes[ID] = AttributeType({
1031       exists: true,
1032       restricted: false, // when true: users can't remove attribute
1033       onlyPersonal: false, // when true: operators can't add attribute
1034       index: _attributeIDs.length,
1035       secondarySource: address(0), // the address of a remote registry
1036       secondaryAttributeTypeID: uint256(0), // the attribute type id to query
1037       minimumStake: uint256(0), // when > 0: users must stake ether to set
1038       jurisdictionFee: uint256(0),
1039       description: description
1040       // NOTE: no approvedValidators variable declaration - must be added later
1041     });
1042     
1043     // add the attribute type id to the end of the attributeID array
1044     _attributeIDs.push(ID);
1045 
1046     // log the addition of the attribute type
1047     emit AttributeTypeAdded(ID, description);
1048   }
1049 
1050   /**
1051   * @notice Add a restricted attribute type with ID `ID` and description
1052   * `description` to the jurisdiction. Restricted attribute types can only be
1053   * removed by the issuing validator or the jurisdiction.
1054   * @param ID uint256 The ID of the restricted attribute type to add.
1055   * @param description string A description of the restricted attribute type.
1056   * @dev Once an attribute type is added with a given ID, the description or the
1057   * restricted status of the attribute type cannot be changed, even if the
1058   * attribute type is removed and added back later.
1059   */
1060   function addRestrictedAttributeType(
1061     uint256 ID,
1062     string description
1063   ) external onlyOwner whenNotPaused {
1064     // prevent existing attributes with the same id from being overwritten
1065     require(
1066       !isAttributeType(ID),
1067       "an attribute type with the provided ID already exists"
1068     );
1069 
1070     // calculate a hash of the attribute type based on the type's properties
1071     bytes32 hash = keccak256(
1072       abi.encodePacked(
1073         ID, true, description
1074       )
1075     );
1076 
1077     // store hash if attribute type is the first one registered with provided ID
1078     if (_attributeTypeHashes[ID] == bytes32(0)) {
1079       _attributeTypeHashes[ID] = hash;
1080     }
1081 
1082     // prevent addition if different attribute type with the same ID has existed
1083     require(
1084       hash == _attributeTypeHashes[ID],
1085       "attribute type properties must match initial properties assigned to ID"
1086     );
1087 
1088     // set the attribute mapping, assigning the index as the end of attributeID
1089     _attributeTypes[ID] = AttributeType({
1090       exists: true,
1091       restricted: true, // when true: users can't remove attribute
1092       onlyPersonal: false, // when true: operators can't add attribute
1093       index: _attributeIDs.length,
1094       secondarySource: address(0), // the address of a remote registry
1095       secondaryAttributeTypeID: uint256(0), // the attribute type id to query
1096       minimumStake: uint256(0), // when > 0: users must stake ether to set
1097       jurisdictionFee: uint256(0),
1098       description: description
1099       // NOTE: no approvedValidators variable declaration - must be added later
1100     });
1101     
1102     // add the attribute type id to the end of the attributeID array
1103     _attributeIDs.push(ID);
1104 
1105     // log the addition of the attribute type
1106     emit AttributeTypeAdded(ID, description);
1107   }
1108 
1109   /**
1110   * @notice Enable or disable a restriction for a given attribute type ID `ID`
1111   * that prevents attributes of the given type from being set by operators based
1112   * on the provided value for `onlyPersonal`.
1113   * @param ID uint256 The attribute type ID in question.
1114   * @param onlyPersonal bool Whether the address may only be set personally.
1115   */
1116   function setAttributeTypeOnlyPersonal(uint256 ID, bool onlyPersonal) external {
1117     // if the attribute type ID does not exist, there is nothing to remove
1118     require(
1119       isAttributeType(ID),
1120       "unable to set to only personal, no attribute type with the provided ID"
1121     );
1122 
1123     // modify the attribute type in the mapping
1124     _attributeTypes[ID].onlyPersonal = onlyPersonal;
1125   }
1126 
1127   /**
1128   * @notice Set a secondary source for a given attribute type ID `ID`, with an
1129   * address `registry` of the secondary source in question and a given
1130   * `sourceAttributeTypeID` for attribute type ID to check on the secondary
1131   * source. The secondary source will only be checked for the given attribute in
1132   * cases where no attribute of the given attribute type ID is assigned locally.
1133   * @param ID uint256 The attribute type ID to set the secondary source for.
1134   * @param attributeRegistry address The secondary attribute registry account.
1135   * @param sourceAttributeTypeID uint256 The attribute type ID on the secondary
1136   * source to check.
1137   * @dev To remove a secondary source on an attribute type, the registry address
1138   * should be set to the null address.
1139   */
1140   function setAttributeTypeSecondarySource(
1141     uint256 ID,
1142     address attributeRegistry,
1143     uint256 sourceAttributeTypeID
1144   ) external {
1145     // if the attribute type ID does not exist, there is nothing to remove
1146     require(
1147       isAttributeType(ID),
1148       "unable to set secondary source, no attribute type with the provided ID"
1149     );
1150 
1151     // modify the attribute type in the mapping
1152     _attributeTypes[ID].secondarySource = attributeRegistry;
1153     _attributeTypes[ID].secondaryAttributeTypeID = sourceAttributeTypeID;
1154   }
1155 
1156   /**
1157   * @notice Set a minimum required stake for a given attribute type ID `ID` and
1158   * an amount of `stake`, to be locked in the jurisdiction upon assignment of
1159   * attributes of the given type. The stake will be applied toward a transaction
1160   * rebate in the event the attribute is revoked, with the remainder returned to
1161   * the staker.
1162   * @param ID uint256 The attribute type ID to set a minimum required stake for.
1163   * @param minimumRequiredStake uint256 The minimum required funds to lock up.
1164   * @dev To remove a stake requirement from an attribute type, the stake amount
1165   * should be set to 0.
1166   */
1167   function setAttributeTypeMinimumRequiredStake(
1168     uint256 ID,
1169     uint256 minimumRequiredStake
1170   ) external {
1171     // if the attribute type ID does not exist, there is nothing to remove
1172     require(
1173       isAttributeType(ID),
1174       "unable to set minimum stake, no attribute type with the provided ID"
1175     );
1176 
1177     // modify the attribute type in the mapping
1178     _attributeTypes[ID].minimumStake = minimumRequiredStake;
1179   }
1180 
1181   /**
1182   * @notice Set a required fee for a given attribute type ID `ID` and an amount
1183   * of `fee`, to be paid to the owner of the jurisdiction upon assignment of
1184   * attributes of the given type.
1185   * @param ID uint256 The attribute type ID to set the required fee for.
1186   * @param fee uint256 The required fee amount to be paid upon assignment.
1187   * @dev To remove a fee requirement from an attribute type, the fee amount
1188   * should be set to 0.
1189   */
1190   function setAttributeTypeJurisdictionFee(uint256 ID, uint256 fee) external {
1191     // if the attribute type ID does not exist, there is nothing to remove
1192     require(
1193       isAttributeType(ID),
1194       "unable to set fee, no attribute type with the provided ID"
1195     );
1196 
1197     // modify the attribute type in the mapping
1198     _attributeTypes[ID].jurisdictionFee = fee;
1199   }
1200 
1201   /**
1202   * @notice Remove the attribute type with ID `ID` from the jurisdiction.
1203   * @param ID uint256 The ID of the attribute type to remove.
1204   * @dev All issued attributes of the given type will become invalid upon
1205   * removal, but will become valid again if the attribute is reinstated.
1206   */
1207   function removeAttributeType(uint256 ID) external onlyOwner whenNotPaused {
1208     // if the attribute type ID does not exist, there is nothing to remove
1209     require(
1210       isAttributeType(ID),
1211       "unable to remove, no attribute type with the provided ID"
1212     );
1213 
1214     // get the attribute ID at the last index of the array
1215     uint256 lastAttributeID = _attributeIDs[_attributeIDs.length.sub(1)];
1216 
1217     // set the attributeID at attribute-to-delete.index to the last attribute ID
1218     _attributeIDs[_attributeTypes[ID].index] = lastAttributeID;
1219 
1220     // update the index of the attribute type that was moved
1221     _attributeTypes[lastAttributeID].index = _attributeTypes[ID].index;
1222     
1223     // remove the (now duplicate) attribute ID at the end by trimming the array
1224     _attributeIDs.length--;
1225 
1226     // delete the attribute type's record from the mapping
1227     delete _attributeTypes[ID];
1228 
1229     // log the removal of the attribute type
1230     emit AttributeTypeRemoved(ID);
1231   }
1232 
1233   /**
1234   * @notice Add account `validator` as a validator with a description
1235   * `description` who can be approved to set attributes of specific types.
1236   * @param validator address The account to assign as the validator.
1237   * @param description string A description of the validator.
1238   * @dev Note that the jurisdiction can add iteslf as a validator if desired.
1239   */
1240   function addValidator(
1241     address validator,
1242     string description
1243   ) external onlyOwner whenNotPaused {
1244     // check that an empty address was not provided by mistake
1245     require(validator != address(0), "must supply a valid address");
1246 
1247     // prevent existing validators from being overwritten
1248     require(
1249       !isValidator(validator),
1250       "a validator with the provided address already exists"
1251     );
1252 
1253     // prevent duplicate signing keys from being created
1254     require(
1255       _signingKeys[validator] == address(0),
1256       "a signing key matching the provided address already exists"
1257     );
1258     
1259     // create a record for the validator
1260     _validators[validator] = Validator({
1261       exists: true,
1262       index: _validatorAccounts.length,
1263       signingKey: validator, // NOTE: this will be initially set to same address
1264       description: description
1265     });
1266 
1267     // set the initial signing key (the validator's address) resolving to itself
1268     _signingKeys[validator] = validator;
1269 
1270     // add the validator to the end of the _validatorAccounts array
1271     _validatorAccounts.push(validator);
1272     
1273     // log the addition of the new validator
1274     emit ValidatorAdded(validator, description);
1275   }
1276 
1277   /**
1278   * @notice Remove the validator at address `validator` from the jurisdiction.
1279   * @param validator address The account of the validator to remove.
1280   * @dev Any attributes issued by the validator will become invalid upon their
1281   * removal. If the validator is reinstated, those attributes will become valid
1282   * again. Any approvals to issue attributes of a given type will need to be
1283   * set from scratch in the event a validator is reinstated.
1284   */
1285   function removeValidator(address validator) external onlyOwner whenNotPaused {
1286     // check that a validator exists at the provided address
1287     require(
1288       isValidator(validator),
1289       "unable to remove, no validator located at the provided address"
1290     );
1291 
1292     // first, start removing validator approvals until gas is exhausted
1293     while (_validatorApprovals[validator].length > 0 && gasleft() > 25000) {
1294       // locate the index of last attribute ID in the validator approval group
1295       uint256 lastIndex = _validatorApprovals[validator].length.sub(1);
1296 
1297       // locate the validator approval to be removed
1298       uint256 targetApproval = _validatorApprovals[validator][lastIndex];
1299 
1300       // remove the record of the approval from the associated attribute type
1301       delete _attributeTypes[targetApproval].approvedValidators[validator];
1302 
1303       // remove the record of the index of the approval
1304       delete _validatorApprovalsIndex[validator][targetApproval];
1305 
1306       // drop the last attribute ID from the validator approval group
1307       _validatorApprovals[validator].length--;
1308     }
1309 
1310     // require that all approvals were successfully removed
1311     require(
1312       _validatorApprovals[validator].length == 0,
1313       "Cannot remove validator - first remove any existing validator approvals"
1314     );
1315 
1316     // get the validator address at the last index of the array
1317     address lastAccount = _validatorAccounts[_validatorAccounts.length.sub(1)];
1318 
1319     // set the address at validator-to-delete.index to last validator address
1320     _validatorAccounts[_validators[validator].index] = lastAccount;
1321 
1322     // update the index of the attribute type that was moved
1323     _validators[lastAccount].index = _validators[validator].index;
1324     
1325     // remove (duplicate) validator address at the end by trimming the array
1326     _validatorAccounts.length--;
1327 
1328     // remove the validator's signing key from its mapping
1329     delete _signingKeys[_validators[validator].signingKey];
1330 
1331     // remove the validator record
1332     delete _validators[validator];
1333 
1334     // log the removal of the validator
1335     emit ValidatorRemoved(validator);
1336   }
1337 
1338   /**
1339   * @notice Approve the validator at address `validator` to issue attributes of
1340   * the type with ID `attributeTypeID`.
1341   * @param validator address The account of the validator to approve.
1342   * @param attributeTypeID uint256 The ID of the approved attribute type.
1343   */
1344   function addValidatorApproval(
1345     address validator,
1346     uint256 attributeTypeID
1347   ) external onlyOwner whenNotPaused {
1348     // check that the attribute is predefined and that the validator exists
1349     require(
1350       isValidator(validator) && isAttributeType(attributeTypeID),
1351       "must specify both a valid attribute and an available validator"
1352     );
1353 
1354     // check that the validator is not already approved
1355     require(
1356       !_attributeTypes[attributeTypeID].approvedValidators[validator],
1357       "validator is already approved on the provided attribute"
1358     );
1359 
1360     // set the validator approval status on the attribute
1361     _attributeTypes[attributeTypeID].approvedValidators[validator] = true;
1362 
1363     // add the record of the index of the validator approval to be added
1364     uint256 index = _validatorApprovals[validator].length;
1365     _validatorApprovalsIndex[validator][attributeTypeID] = index;
1366 
1367     // include the attribute type in the validator approval mapping
1368     _validatorApprovals[validator].push(attributeTypeID);
1369 
1370     // log the addition of the validator's attribute type approval
1371     emit ValidatorApprovalAdded(validator, attributeTypeID);
1372   }
1373 
1374   /**
1375   * @notice Deny the validator at address `validator` the ability to continue to
1376   * issue attributes of the type with ID `attributeTypeID`.
1377   * @param validator address The account of the validator with removed approval.
1378   * @param attributeTypeID uint256 The ID of the attribute type to unapprove.
1379   * @dev Any attributes of the specified type issued by the validator in
1380   * question will become invalid once the approval is removed. If the approval
1381   * is reinstated, those attributes will become valid again. The approval will
1382   * also be removed if the approved validator is removed.
1383   */
1384   function removeValidatorApproval(
1385     address validator,
1386     uint256 attributeTypeID
1387   ) external onlyOwner whenNotPaused {
1388     // check that the attribute is predefined and that the validator exists
1389     require(
1390       canValidate(validator, attributeTypeID),
1391       "unable to remove validator approval, attribute is already unapproved"
1392     );
1393 
1394     // remove the validator approval status from the attribute
1395     delete _attributeTypes[attributeTypeID].approvedValidators[validator];
1396 
1397     // locate the index of the last validator approval
1398     uint256 lastIndex = _validatorApprovals[validator].length.sub(1);
1399 
1400     // locate the last attribute ID in the validator approval group
1401     uint256 lastAttributeID = _validatorApprovals[validator][lastIndex];
1402 
1403     // locate the index of the validator approval to be removed
1404     uint256 index = _validatorApprovalsIndex[validator][attributeTypeID];
1405 
1406     // replace the validator approval with the last approval in the array
1407     _validatorApprovals[validator][index] = lastAttributeID;
1408 
1409     // drop the last attribute ID from the validator approval group
1410     _validatorApprovals[validator].length--;
1411 
1412     // update the record of the index of the swapped-in approval
1413     _validatorApprovalsIndex[validator][lastAttributeID] = index;
1414 
1415     // remove the record of the index of the removed approval
1416     delete _validatorApprovalsIndex[validator][attributeTypeID];
1417     
1418     // log the removal of the validator's attribute type approval
1419     emit ValidatorApprovalRemoved(validator, attributeTypeID);
1420   }
1421 
1422   /**
1423   * @notice Set the public address associated with a validator signing key, used
1424   * to sign off-chain attribute approvals, as `newSigningKey`.
1425   * @param newSigningKey address The address associated with signing key to set.
1426   * @dev Consider having the validator submit a signed proof demonstrating that
1427   * the provided signing key is indeed a signing key in their control - this
1428   * helps mitigate the fringe attack vector where a validator could set the
1429   * address of another validator candidate (especially in the case of a deployed
1430   * smart contract) as their "signing key" in order to block them from being
1431   * added to the jurisdiction (due to the required property of signing keys
1432   * being unique, coupled with the fact that new validators are set up with
1433   * their address as the default initial signing key).
1434   */
1435   function setValidatorSigningKey(address newSigningKey) external {
1436     require(
1437       isValidator(msg.sender),
1438       "only validators may modify validator signing keys");
1439  
1440     // prevent duplicate signing keys from being created
1441     require(
1442       _signingKeys[newSigningKey] == address(0),
1443       "a signing key matching the provided address already exists"
1444     );
1445 
1446     // remove validator address as the resolved value for the old key
1447     delete _signingKeys[_validators[msg.sender].signingKey];
1448 
1449     // set the signing key to the new value
1450     _validators[msg.sender].signingKey = newSigningKey;
1451 
1452     // add validator address as the resolved value for the new key
1453     _signingKeys[newSigningKey] = msg.sender;
1454 
1455     // log the modification of the signing key
1456     emit ValidatorSigningKeyModified(msg.sender, newSigningKey);
1457   }
1458 
1459   /**
1460   * @notice Issue an attribute of the type with ID `attributeTypeID` and a value
1461   * of `value` to `account` if `message.caller.address()` is approved validator.
1462   * @param account address The account to issue the attribute on.
1463   * @param attributeTypeID uint256 The ID of the attribute type to issue.
1464   * @param value uint256 An optional value for the issued attribute.
1465   * @dev Existing attributes of the given type on the address must be removed
1466   * in order to set a new attribute. Be aware that ownership of the account to
1467   * which the attribute is assigned may still be transferable - restricting
1468   * assignment to externally-owned accounts may partially alleviate this issue.
1469   */
1470   function issueAttribute(
1471     address account,
1472     uint256 attributeTypeID,
1473     uint256 value
1474   ) external payable whenNotPaused {
1475     require(
1476       canValidate(msg.sender, attributeTypeID),
1477       "only approved validators may assign attributes of this type"
1478     );
1479 
1480     require(
1481       !_issuedAttributes[account][attributeTypeID].exists,
1482       "duplicate attributes are not supported, remove existing attribute first"
1483     );
1484 
1485     // retrieve required minimum stake and jurisdiction fees on attribute type
1486     uint256 minimumStake = _attributeTypes[attributeTypeID].minimumStake;
1487     uint256 jurisdictionFee = _attributeTypes[attributeTypeID].jurisdictionFee;
1488     uint256 stake = msg.value.sub(jurisdictionFee);
1489 
1490     require(
1491       stake >= minimumStake,
1492       "attribute requires a greater value than is currently provided"
1493     );
1494 
1495     // store attribute value and amount of ether staked in correct scope
1496     _issuedAttributes[account][attributeTypeID] = IssuedAttribute({
1497       exists: true,
1498       setPersonally: false,
1499       operator: address(0),
1500       validator: msg.sender,
1501       value: value,
1502       stake: stake
1503     });
1504 
1505     // log the addition of the attribute
1506     emit AttributeAdded(msg.sender, account, attributeTypeID, value);
1507 
1508     // log allocation of staked funds to the attribute if applicable
1509     if (stake > 0) {
1510       emit StakeAllocated(msg.sender, attributeTypeID, stake);
1511     }
1512 
1513     // pay jurisdiction fee to the owner of the jurisdiction if applicable
1514     if (jurisdictionFee > 0) {
1515       // NOTE: send is chosen over transfer to prevent cases where a improperly
1516       // configured fallback function could block addition of an attribute
1517       if (owner().send(jurisdictionFee)) {
1518         emit FeePaid(owner(), msg.sender, attributeTypeID, jurisdictionFee);
1519       }
1520     }
1521   }
1522 
1523   /**
1524   * @notice Revoke the attribute of the type with ID `attributeTypeID` from
1525   * `account` if `message.caller.address()` is the issuing validator.
1526   * @param account address The account to issue the attribute on.
1527   * @param attributeTypeID uint256 The ID of the attribute type to issue.
1528   * @dev Validators may still revoke issued attributes even after they have been
1529   * removed or had their approval to issue the attribute type removed - this
1530   * enables them to address any objectionable issuances before being reinstated.
1531   */
1532   function revokeAttribute(
1533     address account,
1534     uint256 attributeTypeID
1535   ) external whenNotPaused {
1536     // ensure that an attribute with the given account and attribute exists
1537     require(
1538       _issuedAttributes[account][attributeTypeID].exists,
1539       "only existing attributes may be removed"
1540     );
1541 
1542     // determine the assigned validator on the user attribute
1543     address validator = _issuedAttributes[account][attributeTypeID].validator;
1544     
1545     // caller must be either the jurisdiction owner or the assigning validator
1546     require(
1547       msg.sender == validator || msg.sender == owner(),
1548       "only jurisdiction or issuing validators may revoke arbitrary attributes"
1549     );
1550 
1551     // determine if attribute has any stake in order to refund transaction fee
1552     uint256 stake = _issuedAttributes[account][attributeTypeID].stake;
1553 
1554     // determine the correct address to refund the staked amount to
1555     address refundAddress;
1556     if (_issuedAttributes[account][attributeTypeID].setPersonally) {
1557       refundAddress = account;
1558     } else {
1559       address operator = _issuedAttributes[account][attributeTypeID].operator;
1560       if (operator == address(0)) {
1561         refundAddress = validator;
1562       } else {
1563         refundAddress = operator;
1564       }
1565     }
1566 
1567     // remove the attribute from the designated user account
1568     delete _issuedAttributes[account][attributeTypeID];
1569 
1570     // log the removal of the attribute
1571     emit AttributeRemoved(validator, account, attributeTypeID);
1572 
1573     // pay out any refunds and return the excess stake to the user
1574     if (stake > 0 && address(this).balance >= stake) {
1575       // NOTE: send is chosen over transfer to prevent cases where a malicious
1576       // fallback function could forcibly block an attribute's removal. Another
1577       // option is to allow a user to pull the staked amount after the removal.
1578       // NOTE: refine transaction rebate gas calculation! Setting this value too
1579       // high gives validators the incentive to revoke valid attributes. Simply
1580       // checking against gasLeft() & adding the final gas usage won't give the
1581       // correct transaction cost, as freeing space refunds gas upon completion.
1582       uint256 transactionGas = 37700; // <--- WARNING: THIS IS APPROXIMATE
1583       uint256 transactionCost = transactionGas.mul(tx.gasprice);
1584 
1585       // if stake exceeds allocated transaction cost, refund user the difference
1586       if (stake > transactionCost) {
1587         // refund the excess stake to the address that contributed the funds
1588         if (refundAddress.send(stake.sub(transactionCost))) {
1589           emit StakeRefunded(
1590             refundAddress,
1591             attributeTypeID,
1592             stake.sub(transactionCost)
1593           );
1594         }
1595 
1596         // refund the cost of the transaction to the trasaction submitter
1597         if (tx.origin.send(transactionCost)) {
1598           emit TransactionRebatePaid(
1599             tx.origin,
1600             refundAddress,
1601             attributeTypeID,
1602             transactionCost
1603           );
1604         }
1605 
1606       // otherwise, allocate entire stake to partially refunding the transaction
1607       } else if (stake > 0 && address(this).balance >= stake) {
1608         if (tx.origin.send(stake)) {
1609           emit TransactionRebatePaid(
1610             tx.origin,
1611             refundAddress,
1612             attributeTypeID,
1613             stake
1614           );
1615         }
1616       }
1617     }
1618   }
1619 
1620   /**
1621   * @notice Add an attribute of the type with ID `attributeTypeID`, an attribute
1622   * value of `value`, and an associated validator fee of `validatorFee` to
1623   * account of `msg.sender` by passing in a signed attribute approval with
1624   * signature `signature`.
1625   * @param attributeTypeID uint256 The ID of the attribute type to add.
1626   * @param value uint256 The value for the attribute to add.
1627   * @param validatorFee uint256 The fee to be paid to the issuing validator.
1628   * @param signature bytes The signature from the validator attribute approval.
1629   */
1630   function addAttribute(
1631     uint256 attributeTypeID,
1632     uint256 value,
1633     uint256 validatorFee,
1634     bytes signature
1635   ) external payable {
1636     // NOTE: determine best course of action when the attribute already exists
1637     // NOTE: consider utilizing bytes32 type for attributes and values
1638     // NOTE: does not currently support an extraData parameter, consider adding
1639     // NOTE: if msg.sender is a proxy contract, its ownership may be transferred
1640     // at will, circumventing any token transfer restrictions. Restricting usage
1641     // to only externally owned accounts may partially alleviate this concern.
1642     // NOTE: cosider including a salt (or better, nonce) parameter so that when
1643     // a user adds an attribute, then it gets revoked, the user can get a new
1644     // signature from the validator and renew the attribute using that. The main
1645     // downside is that everyone will have to keep track of the extra parameter.
1646     // Another solution is to just modifiy the required stake or fee amount.
1647 
1648     require(
1649       !_issuedAttributes[msg.sender][attributeTypeID].exists,
1650       "duplicate attributes are not supported, remove existing attribute first"
1651     );
1652 
1653     // retrieve required minimum stake and jurisdiction fees on attribute type
1654     uint256 minimumStake = _attributeTypes[attributeTypeID].minimumStake;
1655     uint256 jurisdictionFee = _attributeTypes[attributeTypeID].jurisdictionFee;
1656     uint256 stake = msg.value.sub(validatorFee).sub(jurisdictionFee);
1657 
1658     require(
1659       stake >= minimumStake,
1660       "attribute requires a greater value than is currently provided"
1661     );
1662 
1663     // signed data hash constructed according to EIP-191-0x45 to prevent replays
1664     bytes32 hash = keccak256(
1665       abi.encodePacked(
1666         address(this),
1667         msg.sender,
1668         address(0),
1669         msg.value,
1670         validatorFee,
1671         attributeTypeID,
1672         value
1673       )
1674     );
1675 
1676     require(
1677       !_invalidAttributeApprovalHashes[hash],
1678       "signed attribute approvals from validators may not be reused"
1679     );
1680 
1681     // extract the key used to sign the message hash
1682     address signingKey = hash.toEthSignedMessageHash().recover(signature);
1683 
1684     // retrieve the validator who controls the extracted key
1685     address validator = _signingKeys[signingKey];
1686 
1687     require(
1688       canValidate(validator, attributeTypeID),
1689       "signature does not match an approved validator for given attribute type"
1690     );
1691 
1692     // store attribute value and amount of ether staked in correct scope
1693     _issuedAttributes[msg.sender][attributeTypeID] = IssuedAttribute({
1694       exists: true,
1695       setPersonally: true,
1696       operator: address(0),
1697       validator: validator,
1698       value: value,
1699       stake: stake
1700       // NOTE: no extraData included
1701     });
1702 
1703     // flag the signed approval as invalid once it's been used to set attribute
1704     _invalidAttributeApprovalHashes[hash] = true;
1705 
1706     // log the addition of the attribute
1707     emit AttributeAdded(validator, msg.sender, attributeTypeID, value);
1708 
1709     // log allocation of staked funds to the attribute if applicable
1710     if (stake > 0) {
1711       emit StakeAllocated(msg.sender, attributeTypeID, stake);
1712     }
1713 
1714     // pay jurisdiction fee to the owner of the jurisdiction if applicable
1715     if (jurisdictionFee > 0) {
1716       // NOTE: send is chosen over transfer to prevent cases where a improperly
1717       // configured fallback function could block addition of an attribute
1718       if (owner().send(jurisdictionFee)) {
1719         emit FeePaid(owner(), msg.sender, attributeTypeID, jurisdictionFee);
1720       }
1721     }
1722 
1723     // pay validator fee to the issuing validator's address if applicable
1724     if (validatorFee > 0) {
1725       // NOTE: send is chosen over transfer to prevent cases where a improperly
1726       // configured fallback function could block addition of an attribute
1727       if (validator.send(validatorFee)) {
1728         emit FeePaid(validator, msg.sender, attributeTypeID, validatorFee);
1729       }
1730     }
1731   }
1732 
1733   /**
1734   * @notice Remove an attribute of the type with ID `attributeTypeID` from
1735   * account of `msg.sender`.
1736   * @param attributeTypeID uint256 The ID of the attribute type to remove.
1737   */
1738   function removeAttribute(uint256 attributeTypeID) external {
1739     // attributes may only be removed by the user if they are not restricted
1740     require(
1741       !_attributeTypes[attributeTypeID].restricted,
1742       "only jurisdiction or issuing validator may remove a restricted attribute"
1743     );
1744 
1745     require(
1746       _issuedAttributes[msg.sender][attributeTypeID].exists,
1747       "only existing attributes may be removed"
1748     );
1749 
1750     // determine the assigned validator on the user attribute
1751     address validator = _issuedAttributes[msg.sender][attributeTypeID].validator;
1752 
1753     // determine if the attribute has a staked value
1754     uint256 stake = _issuedAttributes[msg.sender][attributeTypeID].stake;
1755 
1756     // determine the correct address to refund the staked amount to
1757     address refundAddress;
1758     if (_issuedAttributes[msg.sender][attributeTypeID].setPersonally) {
1759       refundAddress = msg.sender;
1760     } else {
1761       address operator = _issuedAttributes[msg.sender][attributeTypeID].operator;
1762       if (operator == address(0)) {
1763         refundAddress = validator;
1764       } else {
1765         refundAddress = operator;
1766       }
1767     }    
1768 
1769     // remove the attribute from the user address
1770     delete _issuedAttributes[msg.sender][attributeTypeID];
1771 
1772     // log the removal of the attribute
1773     emit AttributeRemoved(validator, msg.sender, attributeTypeID);
1774 
1775     // if the attribute has any staked balance, refund it to the user
1776     if (stake > 0 && address(this).balance >= stake) {
1777       // NOTE: send is chosen over transfer to prevent cases where a malicious
1778       // fallback function could forcibly block an attribute's removal
1779       if (refundAddress.send(stake)) {
1780         emit StakeRefunded(refundAddress, attributeTypeID, stake);
1781       }
1782     }
1783   }
1784 
1785   /**
1786   * @notice Add an attribute of the type with ID `attributeTypeID`, an attribute
1787   * value of `value`, and an associated validator fee of `validatorFee` to
1788   * account `account` by passing in a signed attribute approval with signature
1789   * `signature`.
1790   * @param account address The account to add the attribute to.
1791   * @param attributeTypeID uint256 The ID of the attribute type to add.
1792   * @param value uint256 The value for the attribute to add.
1793   * @param validatorFee uint256 The fee to be paid to the issuing validator.
1794   * @param signature bytes The signature from the validator attribute approval.
1795   * @dev Restricted attribute types can only be removed by issuing validators or
1796   * the jurisdiction itself.
1797   */
1798   function addAttributeFor(
1799     address account,
1800     uint256 attributeTypeID,
1801     uint256 value,
1802     uint256 validatorFee,
1803     bytes signature
1804   ) external payable {
1805     // NOTE: determine best course of action when the attribute already exists
1806     // NOTE: consider utilizing bytes32 type for attributes and values
1807     // NOTE: does not currently support an extraData parameter, consider adding
1808     // NOTE: if msg.sender is a proxy contract, its ownership may be transferred
1809     // at will, circumventing any token transfer restrictions. Restricting usage
1810     // to only externally owned accounts may partially alleviate this concern.
1811     // NOTE: consider including a salt (or better, nonce) parameter so that when
1812     // a user adds an attribute, then it gets revoked, the user can get a new
1813     // signature from the validator and renew the attribute using that. The main
1814     // downside is that everyone will have to keep track of the extra parameter.
1815     // Another solution is to just modifiy the required stake or fee amount.
1816 
1817     // attributes may only be added by a third party if onlyPersonal is false
1818     require(
1819       !_attributeTypes[attributeTypeID].onlyPersonal,
1820       "only operatable attributes may be added on behalf of another address"
1821     );
1822 
1823     require(
1824       !_issuedAttributes[account][attributeTypeID].exists,
1825       "duplicate attributes are not supported, remove existing attribute first"
1826     );
1827 
1828     // retrieve required minimum stake and jurisdiction fees on attribute type
1829     uint256 minimumStake = _attributeTypes[attributeTypeID].minimumStake;
1830     uint256 jurisdictionFee = _attributeTypes[attributeTypeID].jurisdictionFee;
1831     uint256 stake = msg.value.sub(validatorFee).sub(jurisdictionFee);
1832 
1833     require(
1834       stake >= minimumStake,
1835       "attribute requires a greater value than is currently provided"
1836     );
1837 
1838     // signed data hash constructed according to EIP-191-0x45 to prevent replays
1839     bytes32 hash = keccak256(
1840       abi.encodePacked(
1841         address(this),
1842         account,
1843         msg.sender,
1844         msg.value,
1845         validatorFee,
1846         attributeTypeID,
1847         value
1848       )
1849     );
1850 
1851     require(
1852       !_invalidAttributeApprovalHashes[hash],
1853       "signed attribute approvals from validators may not be reused"
1854     );
1855 
1856     // extract the key used to sign the message hash
1857     address signingKey = hash.toEthSignedMessageHash().recover(signature);
1858 
1859     // retrieve the validator who controls the extracted key
1860     address validator = _signingKeys[signingKey];
1861 
1862     require(
1863       canValidate(validator, attributeTypeID),
1864       "signature does not match an approved validator for provided attribute"
1865     );
1866 
1867     // store attribute value and amount of ether staked in correct scope
1868     _issuedAttributes[account][attributeTypeID] = IssuedAttribute({
1869       exists: true,
1870       setPersonally: false,
1871       operator: msg.sender,
1872       validator: validator,
1873       value: value,
1874       stake: stake
1875       // NOTE: no extraData included
1876     });
1877 
1878     // flag the signed approval as invalid once it's been used to set attribute
1879     _invalidAttributeApprovalHashes[hash] = true;
1880 
1881     // log the addition of the attribute
1882     emit AttributeAdded(validator, account, attributeTypeID, value);
1883 
1884     // log allocation of staked funds to the attribute if applicable
1885     // NOTE: the staker is the entity that pays the fee here!
1886     if (stake > 0) {
1887       emit StakeAllocated(msg.sender, attributeTypeID, stake);
1888     }
1889 
1890     // pay jurisdiction fee to the owner of the jurisdiction if applicable
1891     if (jurisdictionFee > 0) {
1892       // NOTE: send is chosen over transfer to prevent cases where a improperly
1893       // configured fallback function could block addition of an attribute
1894       if (owner().send(jurisdictionFee)) {
1895         emit FeePaid(owner(), msg.sender, attributeTypeID, jurisdictionFee);
1896       }
1897     }
1898 
1899     // pay validator fee to the issuing validator's address if applicable
1900     if (validatorFee > 0) {
1901       // NOTE: send is chosen over transfer to prevent cases where a improperly
1902       // configured fallback function could block addition of an attribute
1903       if (validator.send(validatorFee)) {
1904         emit FeePaid(validator, msg.sender, attributeTypeID, validatorFee);
1905       }
1906     }
1907   }
1908 
1909   /**
1910   * @notice Remove an attribute of the type with ID `attributeTypeID` from
1911   * account of `account`.
1912   * @param account address The account to remove the attribute from.
1913   * @param attributeTypeID uint256 The ID of the attribute type to remove.
1914   * @dev Restricted attribute types can only be removed by issuing validators or
1915   * the jurisdiction itself.
1916   */
1917   function removeAttributeFor(address account, uint256 attributeTypeID) external {
1918     // attributes may only be removed by the user if they are not restricted
1919     require(
1920       !_attributeTypes[attributeTypeID].restricted,
1921       "only jurisdiction or issuing validator may remove a restricted attribute"
1922     );
1923 
1924     require(
1925       _issuedAttributes[account][attributeTypeID].exists,
1926       "only existing attributes may be removed"
1927     );
1928 
1929     require(
1930       _issuedAttributes[account][attributeTypeID].operator == msg.sender,
1931       "only an assigning operator may remove attribute on behalf of an address"
1932     );
1933 
1934     // determine the assigned validator on the user attribute
1935     address validator = _issuedAttributes[account][attributeTypeID].validator;
1936 
1937     // determine if the attribute has a staked value
1938     uint256 stake = _issuedAttributes[account][attributeTypeID].stake;
1939 
1940     // remove the attribute from the user address
1941     delete _issuedAttributes[account][attributeTypeID];
1942 
1943     // log the removal of the attribute
1944     emit AttributeRemoved(validator, account, attributeTypeID);
1945 
1946     // if the attribute has any staked balance, refund it to the user
1947     if (stake > 0 && address(this).balance >= stake) {
1948       // NOTE: send is chosen over transfer to prevent cases where a malicious
1949       // fallback function could forcibly block an attribute's removal
1950       if (msg.sender.send(stake)) {
1951         emit StakeRefunded(msg.sender, attributeTypeID, stake);
1952       }
1953     }
1954   }
1955 
1956   /**
1957    * @notice Invalidate a signed attribute approval before it has been set by
1958    * supplying the hash of the approval `hash` and the signature `signature`.
1959    * @param hash bytes32 The hash of the attribute approval.
1960    * @param signature bytes The hash's signature, resolving to the signing key.
1961    * @dev Attribute approvals can only be removed by issuing validators or the
1962    * jurisdiction itself.
1963    */
1964   function invalidateAttributeApproval(
1965     bytes32 hash,
1966     bytes signature
1967   ) external {
1968     // determine the assigned validator on the signed attribute approval
1969     address validator = _signingKeys[
1970       hash.toEthSignedMessageHash().recover(signature) // signingKey
1971     ];
1972     
1973     // caller must be either the jurisdiction owner or the assigning validator
1974     require(
1975       msg.sender == validator || msg.sender == owner(),
1976       "only jurisdiction or issuing validator may invalidate attribute approval"
1977     );
1978 
1979     // add the hash to the set of invalid attribute approval hashes
1980     _invalidAttributeApprovalHashes[hash] = true;
1981   }
1982 
1983   /**
1984    * @notice Check if an attribute of the type with ID `attributeTypeID` has
1985    * been assigned to the account at `account` and is currently valid.
1986    * @param account address The account to check for a valid attribute.
1987    * @param attributeTypeID uint256 The ID of the attribute type to check for.
1988    * @return True if the attribute is assigned and valid, false otherwise.
1989    * @dev This function MUST return either true or false - i.e. calling this
1990    * function MUST NOT cause the caller to revert.
1991    */
1992   function hasAttribute(
1993     address account, 
1994     uint256 attributeTypeID
1995   ) external view returns (bool) {
1996     address validator = _issuedAttributes[account][attributeTypeID].validator;
1997     return (
1998       (
1999         _validators[validator].exists &&   // isValidator(validator)
2000         _attributeTypes[attributeTypeID].approvedValidators[validator] &&
2001         _attributeTypes[attributeTypeID].exists //isAttributeType(attributeTypeID)
2002       ) || (
2003         _attributeTypes[attributeTypeID].secondarySource != address(0) &&
2004         secondaryHasAttribute(
2005           _attributeTypes[attributeTypeID].secondarySource,
2006           account,
2007           _attributeTypes[attributeTypeID].secondaryAttributeTypeID
2008         )
2009       )
2010     );
2011   }
2012 
2013   /**
2014    * @notice Retrieve the value of the attribute of the type with ID
2015    * `attributeTypeID` on the account at `account`, assuming it is valid.
2016    * @param account address The account to check for the given attribute value.
2017    * @param attributeTypeID uint256 The ID of the attribute type to check for.
2018    * @return The attribute value if the attribute is valid, reverts otherwise.
2019    * @dev This function MUST revert if a directly preceding or subsequent
2020    * function call to `hasAttribute` with identical `account` and
2021    * `attributeTypeID` parameters would return false.
2022    */
2023   function getAttributeValue(
2024     address account,
2025     uint256 attributeTypeID
2026   ) external view returns (uint256 value) {
2027     // gas optimization: get validator & call canValidate function body directly
2028     address validator = _issuedAttributes[account][attributeTypeID].validator;
2029     if (
2030       _validators[validator].exists &&   // isValidator(validator)
2031       _attributeTypes[attributeTypeID].approvedValidators[validator] &&
2032       _attributeTypes[attributeTypeID].exists //isAttributeType(attributeTypeID)
2033     ) {
2034       return _issuedAttributes[account][attributeTypeID].value;
2035     } else if (
2036       _attributeTypes[attributeTypeID].secondarySource != address(0)
2037     ) {
2038       // first ensure hasAttribute on the secondary source returns true
2039       require(
2040         AttributeRegistryInterface(
2041           _attributeTypes[attributeTypeID].secondarySource
2042         ).hasAttribute(
2043           account, _attributeTypes[attributeTypeID].secondaryAttributeTypeID
2044         ),
2045         "attribute of the provided type is not assigned to the provided account"
2046       );
2047 
2048       return (
2049         AttributeRegistryInterface(
2050           _attributeTypes[attributeTypeID].secondarySource
2051         ).getAttributeValue(
2052           account, _attributeTypes[attributeTypeID].secondaryAttributeTypeID
2053         )
2054       );
2055     }
2056 
2057     // NOTE: checking for values of invalid attributes will revert
2058     revert("could not find an attribute value at the provided account and ID");
2059   }
2060 
2061   /**
2062    * @notice Determine if a validator at account `validator` is able to issue
2063    * attributes of the type with ID `attributeTypeID`.
2064    * @param validator address The account of the validator.
2065    * @param attributeTypeID uint256 The ID of the attribute type to check.
2066    * @return True if the validator can issue attributes of the given type, false
2067    * otherwise.
2068    */
2069   function canIssueAttributeType(
2070     address validator,
2071     uint256 attributeTypeID
2072   ) external view returns (bool) {
2073     return canValidate(validator, attributeTypeID);
2074   }
2075 
2076   /**
2077    * @notice Get a description of the attribute type with ID `attributeTypeID`.
2078    * @param attributeTypeID uint256 The ID of the attribute type to check for.
2079    * @return A description of the attribute type.
2080    */
2081   function getAttributeTypeDescription(
2082     uint256 attributeTypeID
2083   ) external view returns (
2084     string description
2085   ) {
2086     return _attributeTypes[attributeTypeID].description;
2087   }
2088 
2089   /**
2090    * @notice Get comprehensive information on an attribute type with ID
2091    * `attributeTypeID`.
2092    * @param attributeTypeID uint256 The attribute type ID in question.
2093    * @return Information on the attribute type in question.
2094    */
2095   function getAttributeTypeInformation(
2096     uint256 attributeTypeID
2097   ) external view returns (
2098     string description,
2099     bool isRestricted,
2100     bool isOnlyPersonal,
2101     address secondarySource,
2102     uint256 secondaryAttributeTypeID,
2103     uint256 minimumRequiredStake,
2104     uint256 jurisdictionFee
2105   ) {
2106     return (
2107       _attributeTypes[attributeTypeID].description,
2108       _attributeTypes[attributeTypeID].restricted,
2109       _attributeTypes[attributeTypeID].onlyPersonal,
2110       _attributeTypes[attributeTypeID].secondarySource,
2111       _attributeTypes[attributeTypeID].secondaryAttributeTypeID,
2112       _attributeTypes[attributeTypeID].minimumStake,
2113       _attributeTypes[attributeTypeID].jurisdictionFee
2114     );
2115   }
2116 
2117   /**
2118    * @notice Get a description of the validator at account `validator`.
2119    * @param validator address The account of the validator in question.
2120    * @return A description of the validator.
2121    */
2122   function getValidatorDescription(
2123     address validator
2124   ) external view returns (
2125     string description
2126   ) {
2127     return _validators[validator].description;
2128   }
2129 
2130   /**
2131    * @notice Get the signing key of the validator at account `validator`.
2132    * @param validator address The account of the validator in question.
2133    * @return The signing key of the validator.
2134    */
2135   function getValidatorSigningKey(
2136     address validator
2137   ) external view returns (
2138     address signingKey
2139   ) {
2140     return _validators[validator].signingKey;
2141   }
2142 
2143   /**
2144    * @notice Find the validator that issued the attribute of the type with ID
2145    * `attributeTypeID` on the account at `account` and determine if the
2146    * validator is still valid.
2147    * @param account address The account that contains the attribute be checked.
2148    * @param attributeTypeID uint256 The ID of the attribute type in question.
2149    * @return The validator and the current status of the validator as it
2150    * pertains to the attribute type in question.
2151    * @dev if no attribute of the given attribute type exists on the account, the
2152    * function will return (address(0), false).
2153    */
2154   function getAttributeValidator(
2155     address account,
2156     uint256 attributeTypeID
2157   ) external view returns (
2158     address validator,
2159     bool isStillValid
2160   ) {
2161     address issuer = _issuedAttributes[account][attributeTypeID].validator;
2162     return (issuer, canValidate(issuer, attributeTypeID));
2163   }
2164 
2165   /**
2166    * @notice Count the number of attribute types defined by the registry.
2167    * @return The number of available attribute types.
2168    * @dev This function MUST return a positive integer value  - i.e. calling
2169    * this function MUST NOT cause the caller to revert.
2170    */
2171   function countAttributeTypes() external view returns (uint256) {
2172     return _attributeIDs.length;
2173   }
2174 
2175   /**
2176    * @notice Get the ID of the attribute type at index `index`.
2177    * @param index uint256 The index of the attribute type in question.
2178    * @return The ID of the attribute type.
2179    * @dev This function MUST revert if the provided `index` value falls outside
2180    * of the range of the value returned from a directly preceding or subsequent
2181    * function call to `countAttributeTypes`. It MUST NOT revert if the provided
2182    * `index` value falls inside said range.
2183    */
2184   function getAttributeTypeID(uint256 index) external view returns (uint256) {
2185     require(
2186       index < _attributeIDs.length,
2187       "provided index is outside of the range of defined attribute type IDs"
2188     );
2189 
2190     return _attributeIDs[index];
2191   }
2192 
2193   /**
2194    * @notice Get the IDs of all available attribute types on the jurisdiction.
2195    * @return A dynamic array containing all available attribute type IDs.
2196    */
2197   function getAttributeTypeIDs() external view returns (uint256[]) {
2198     return _attributeIDs;
2199   }
2200 
2201   /**
2202    * @notice Count the number of validators defined by the jurisdiction.
2203    * @return The number of defined validators.
2204    */
2205   function countValidators() external view returns (uint256) {
2206     return _validatorAccounts.length;
2207   }
2208 
2209   /**
2210    * @notice Get the account of the validator at index `index`.
2211    * @param index uint256 The index of the validator in question.
2212    * @return The account of the validator.
2213    */
2214   function getValidator(
2215     uint256 index
2216   ) external view returns (address) {
2217     return _validatorAccounts[index];
2218   }
2219 
2220   /**
2221    * @notice Get the accounts of all available validators on the jurisdiction.
2222    * @return A dynamic array containing all available validator accounts.
2223    */
2224   function getValidators() external view returns (address[]) {
2225     return _validatorAccounts;
2226   }
2227 
2228   /**
2229    * @notice Determine if the interface ID `interfaceID` is supported (ERC-165)
2230    * @param interfaceID bytes4 The interface ID in question.
2231    * @return True if the interface is supported, false otherwise.
2232    * @dev this function will produce a compiler warning recommending that the
2233    * visibility be set to pure, but the interface expects a view function.
2234    * Supported interfaces include ERC-165 (0x01ffc9a7) and the attribute
2235    * registry interface (0x5f46473f).
2236    */
2237   function supportsInterface(bytes4 interfaceID) external view returns (bool) {
2238     return (
2239       interfaceID == this.supportsInterface.selector || // ERC165
2240       interfaceID == (
2241         this.hasAttribute.selector 
2242         ^ this.getAttributeValue.selector
2243         ^ this.countAttributeTypes.selector
2244         ^ this.getAttributeTypeID.selector
2245       ) // AttributeRegistryInterface
2246     ); // 0x01ffc9a7 || 0x5f46473f
2247   }
2248 
2249   /**
2250    * @notice Get the hash of a given attribute approval.
2251    * @param account address The account specified by the attribute approval.
2252    * @param operator address An optional account permitted to submit approval.
2253    * @param attributeTypeID uint256 The ID of the attribute type in question.
2254    * @param value uint256 The value of the attribute in the approval.
2255    * @param fundsRequired uint256 The amount to be included with the approval.
2256    * @param validatorFee uint256 The required fee to be paid to the validator.
2257    * @return The hash of the attribute approval.
2258    */
2259   function getAttributeApprovalHash(
2260     address account,
2261     address operator,
2262     uint256 attributeTypeID,
2263     uint256 value,
2264     uint256 fundsRequired,
2265     uint256 validatorFee
2266   ) external view returns (
2267     bytes32 hash
2268   ) {
2269     return calculateAttributeApprovalHash(
2270       account,
2271       operator,
2272       attributeTypeID,
2273       value,
2274       fundsRequired,
2275       validatorFee
2276     );
2277   }
2278 
2279   /**
2280    * @notice Check if a given signed attribute approval is currently valid when
2281    * submitted directly by `msg.sender`.
2282    * @param attributeTypeID uint256 The ID of the attribute type in question.
2283    * @param value uint256 The value of the attribute in the approval.
2284    * @param fundsRequired uint256 The amount to be included with the approval.
2285    * @param validatorFee uint256 The required fee to be paid to the validator.
2286    * @param signature bytes The attribute approval signature, based on a hash of
2287    * the other parameters and the submitting account.
2288    * @return True if the approval is currently valid, false otherwise.
2289    */
2290   function canAddAttribute(
2291     uint256 attributeTypeID,
2292     uint256 value,
2293     uint256 fundsRequired,
2294     uint256 validatorFee,
2295     bytes signature
2296   ) external view returns (bool) {
2297     // signed data hash constructed according to EIP-191-0x45 to prevent replays
2298     bytes32 hash = calculateAttributeApprovalHash(
2299       msg.sender,
2300       address(0),
2301       attributeTypeID,
2302       value,
2303       fundsRequired,
2304       validatorFee
2305     );
2306 
2307     // recover the address associated with the signature of the message hash
2308     address signingKey = hash.toEthSignedMessageHash().recover(signature);
2309     
2310     // retrieve variables necessary to perform checks
2311     address validator = _signingKeys[signingKey];
2312     uint256 minimumStake = _attributeTypes[attributeTypeID].minimumStake;
2313     uint256 jurisdictionFee = _attributeTypes[attributeTypeID].jurisdictionFee;
2314 
2315     // determine if the attribute can currently be added.
2316     // NOTE: consider returning an error code along with the boolean.
2317     return (
2318       fundsRequired >= minimumStake.add(jurisdictionFee).add(validatorFee) &&
2319       !_invalidAttributeApprovalHashes[hash] &&
2320       canValidate(validator, attributeTypeID) &&
2321       !_issuedAttributes[msg.sender][attributeTypeID].exists
2322     );
2323   }
2324 
2325   /**
2326    * @notice Check if a given signed attribute approval is currently valid for a
2327    * given account when submitted by the operator at `msg.sender`.
2328    * @param account address The account specified by the attribute approval.
2329    * @param attributeTypeID uint256 The ID of the attribute type in question.
2330    * @param value uint256 The value of the attribute in the approval.
2331    * @param fundsRequired uint256 The amount to be included with the approval.
2332    * @param validatorFee uint256 The required fee to be paid to the validator.
2333    * @param signature bytes The attribute approval signature, based on a hash of
2334    * the other parameters and the submitting account.
2335    * @return True if the approval is currently valid, false otherwise.
2336    */
2337   function canAddAttributeFor(
2338     address account,
2339     uint256 attributeTypeID,
2340     uint256 value,
2341     uint256 fundsRequired,
2342     uint256 validatorFee,
2343     bytes signature
2344   ) external view returns (bool) {
2345     // signed data hash constructed according to EIP-191-0x45 to prevent replays
2346     bytes32 hash = calculateAttributeApprovalHash(
2347       account,
2348       msg.sender,
2349       attributeTypeID,
2350       value,
2351       fundsRequired,
2352       validatorFee
2353     );
2354 
2355     // recover the address associated with the signature of the message hash
2356     address signingKey = hash.toEthSignedMessageHash().recover(signature);
2357     
2358     // retrieve variables necessary to perform checks
2359     address validator = _signingKeys[signingKey];
2360     uint256 minimumStake = _attributeTypes[attributeTypeID].minimumStake;
2361     uint256 jurisdictionFee = _attributeTypes[attributeTypeID].jurisdictionFee;
2362 
2363     // determine if the attribute can currently be added.
2364     // NOTE: consider returning an error code along with the boolean.
2365     return (
2366       fundsRequired >= minimumStake.add(jurisdictionFee).add(validatorFee) &&
2367       !_invalidAttributeApprovalHashes[hash] &&
2368       canValidate(validator, attributeTypeID) &&
2369       !_issuedAttributes[account][attributeTypeID].exists
2370     );
2371   }
2372 
2373   /**
2374    * @notice Determine if an attribute type with ID `attributeTypeID` is
2375    * currently defined on the jurisdiction.
2376    * @param attributeTypeID uint256 The attribute type ID in question.
2377    * @return True if the attribute type is defined, false otherwise.
2378    */
2379   function isAttributeType(uint256 attributeTypeID) public view returns (bool) {
2380     return _attributeTypes[attributeTypeID].exists;
2381   }
2382 
2383   /**
2384    * @notice Determine if the account `account` is currently assigned as a
2385    * validator on the jurisdiction.
2386    * @param account address The account to check for validator status.
2387    * @return True if the account is assigned as a validator, false otherwise.
2388    */
2389   function isValidator(address account) public view returns (bool) {
2390     return _validators[account].exists;
2391   }
2392 
2393   /**
2394    * @notice Internal function to determine if a validator at account
2395    * `validator` can issue attributes of the type with ID `attributeTypeID`.
2396    * @param validator address The account of the validator.
2397    * @param attributeTypeID uint256 The ID of the attribute type to check.
2398    * @return True if the validator can issue attributes of the given type, false
2399    * otherwise.
2400    */
2401   function canValidate(
2402     address validator,
2403     uint256 attributeTypeID
2404   ) internal view returns (bool) {
2405     return (
2406       _validators[validator].exists &&   // isValidator(validator)
2407       _attributeTypes[attributeTypeID].approvedValidators[validator] &&
2408       _attributeTypes[attributeTypeID].exists // isAttributeType(attributeTypeID)
2409     );
2410   }
2411 
2412   // internal helper function for getting the hash of an attribute approval
2413   function calculateAttributeApprovalHash(
2414     address account,
2415     address operator,
2416     uint256 attributeTypeID,
2417     uint256 value,
2418     uint256 fundsRequired,
2419     uint256 validatorFee
2420   ) internal view returns (bytes32 hash) {
2421     return keccak256(
2422       abi.encodePacked(
2423         address(this),
2424         account,
2425         operator,
2426         fundsRequired,
2427         validatorFee,
2428         attributeTypeID,
2429         value
2430       )
2431     );
2432   }
2433 
2434   // helper function, won't revert calling hasAttribute on secondary registries
2435   function secondaryHasAttribute(
2436     address source,
2437     address account,
2438     uint256 attributeTypeID
2439   ) internal view returns (bool result) {
2440     uint256 maxGas = gasleft() > 20000 ? 20000 : gasleft();
2441     bytes memory encodedParams = abi.encodeWithSelector(
2442       this.hasAttribute.selector,
2443       account,
2444       attributeTypeID
2445     );
2446 
2447     assembly {
2448       let encodedParams_data := add(0x20, encodedParams)
2449       let encodedParams_size := mload(encodedParams)
2450       
2451       let output := mload(0x40) // get storage start from free memory pointer
2452       mstore(output, 0x0)       // set up the location for output of staticcall
2453 
2454       let success := staticcall(
2455         maxGas,                 // maximum of 20k gas can be forwarded
2456         source,                 // address of attribute registry to call
2457         encodedParams_data,     // inputs are stored at pointer location
2458         encodedParams_size,     // inputs are 68 bytes (4 + 32 * 2)
2459         output,                 // return to designated free space
2460         0x20                    // output is one word, or 32 bytes
2461       )
2462 
2463       switch success            // instrumentation bug: use switch instead of if
2464       case 1 {                  // only recognize successful staticcall output 
2465         result := mload(output) // set the output to the return value
2466       }
2467     }
2468   }
2469 }