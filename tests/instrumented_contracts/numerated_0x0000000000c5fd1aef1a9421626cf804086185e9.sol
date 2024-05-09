1 pragma solidity 0.4.26; // optimization enabled, runs: 500
2 
3 
4 /************** TPL Extended Jurisdiction - YES token integration *************
5  * This digital jurisdiction supports assigning YES token, or other contracts *
6  * with a similar validation mechanism, as additional attribute validators.   *
7  * https://github.com/TPL-protocol/tpl-contracts/tree/yes-token-integration   *
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
22  *  - interface IERC20 (partial)                      926                     *
23  *  - ExtendedJurisdiction                            934                     *
24  *    - is Ownable                                                            *
25  *    - is Pausable                                                           *
26  *    - is AttributeRegistryInterface                                         *
27  *    - is BasicJurisdictionInterface                                         *
28  *    - is ExtendedJurisdictionInterface                                      *
29  *    - using ECDSA for bytes32                                               *
30  *    - using SafeMath for uint256                                            *
31  *                                                                            *
32  *  https://github.com/TPL-protocol/tpl-contracts/blob/master/LICENSE.md      *
33  ******************************************************************************/
34 
35 
36 /**
37  * @title Elliptic curve signature operations
38  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
39  * TODO Remove this library once solidity supports passing a signature to ecrecover.
40  * See https://github.com/ethereum/solidity/issues/864
41  */
42 library ECDSA {
43   /**
44    * @dev Recover signer address from a message by using their signature
45    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
46    * @param signature bytes signature, the signature is generated using web3.eth.sign()
47    */
48   function recover(bytes32 hash, bytes signature)
49     internal
50     pure
51     returns (address)
52   {
53     bytes32 r;
54     bytes32 s;
55     uint8 v;
56 
57     // Check the signature length
58     if (signature.length != 65) {
59       return (address(0));
60     }
61 
62     // Divide the signature in r, s and v variables
63     // ecrecover takes the signature parameters, and the only way to get them
64     // currently is to use assembly.
65     // solium-disable-next-line security/no-inline-assembly
66     assembly {
67       r := mload(add(signature, 0x20))
68       s := mload(add(signature, 0x40))
69       v := byte(0, mload(add(signature, 0x60)))
70     }
71 
72     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
73     if (v < 27) {
74       v += 27;
75     }
76 
77     // If the version is correct return the signer address
78     if (v != 27 && v != 28) {
79       return (address(0));
80     } else {
81       // solium-disable-next-line arg-overflow
82       return ecrecover(hash, v, r, s);
83     }
84   }
85 
86   /**
87    * toEthSignedMessageHash
88    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
89    * and hash the result
90    */
91   function toEthSignedMessageHash(bytes32 hash)
92     internal
93     pure
94     returns (bytes32)
95   {
96     // 32 is the length in bytes of hash,
97     // enforced by the type signature above
98     return keccak256(
99       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
100     );
101   }
102 }
103 
104 
105 /**
106  * @title SafeMath
107  * @dev Math operations with safety checks that revert on error
108  */
109 library SafeMath {
110   /**
111   * @dev Multiplies two numbers, reverts on overflow.
112   */
113   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
115     // benefit is lost if 'b' is also tested.
116     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
117     if (a == 0) {
118       return 0;
119     }
120 
121     uint256 c = a * b;
122     require(c / a == b);
123 
124     return c;
125   }
126 
127   /**
128   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
129   */
130   function div(uint256 a, uint256 b) internal pure returns (uint256) {
131     require(b > 0); // Solidity only automatically asserts when dividing by 0
132     uint256 c = a / b;
133     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134 
135     return c;
136   }
137 
138   /**
139   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
140   */
141   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142     require(b <= a);
143     uint256 c = a - b;
144 
145     return c;
146   }
147 
148   /**
149   * @dev Adds two numbers, reverts on overflow.
150   */
151   function add(uint256 a, uint256 b) internal pure returns (uint256) {
152     uint256 c = a + b;
153     require(c >= a);
154 
155     return c;
156   }
157 
158   /**
159   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
160   * reverts when dividing by zero.
161   */
162   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
163     require(b != 0);
164     return a % b;
165   }
166 }
167 
168 
169 /**
170  * @title Roles
171  * @dev Library for managing addresses assigned to a Role.
172  */
173 library Roles {
174   struct Role {
175     mapping (address => bool) bearer;
176   }
177 
178   /**
179    * @dev give an account access to this role
180    */
181   function add(Role storage role, address account) internal {
182     require(account != address(0));
183     require(!has(role, account));
184 
185     role.bearer[account] = true;
186   }
187 
188   /**
189    * @dev remove an account's access to this role
190    */
191   function remove(Role storage role, address account) internal {
192     require(account != address(0));
193     require(has(role, account));
194 
195     role.bearer[account] = false;
196   }
197 
198   /**
199    * @dev check if an account has this role
200    * @return bool
201    */
202   function has(Role storage role, address account)
203     internal
204     view
205     returns (bool)
206   {
207     require(account != address(0));
208     return role.bearer[account];
209   }
210 }
211 
212 
213 contract PauserRole {
214   using Roles for Roles.Role;
215 
216   event PauserAdded(address indexed account);
217   event PauserRemoved(address indexed account);
218 
219   Roles.Role private pausers;
220 
221   constructor() internal {
222     _addPauser(msg.sender);
223   }
224 
225   modifier onlyPauser() {
226     require(isPauser(msg.sender));
227     _;
228   }
229 
230   function isPauser(address account) public view returns (bool) {
231     return pausers.has(account);
232   }
233 
234   function addPauser(address account) public onlyPauser {
235     _addPauser(account);
236   }
237 
238   function renouncePauser() public {
239     _removePauser(msg.sender);
240   }
241 
242   function _addPauser(address account) internal {
243     pausers.add(account);
244     emit PauserAdded(account);
245   }
246 
247   function _removePauser(address account) internal {
248     pausers.remove(account);
249     emit PauserRemoved(account);
250   }
251 }
252 
253 
254 /**
255  * @title Pausable
256  * @dev Base contract which allows children to implement an emergency stop mechanism.
257  */
258 contract Pausable is PauserRole {
259   event Paused(address account);
260   event Unpaused(address account);
261 
262   bool private _paused;
263 
264   constructor() internal {
265     _paused = false;
266   }
267 
268   /**
269    * @return true if the contract is paused, false otherwise.
270    */
271   function paused() public view returns(bool) {
272     return _paused;
273   }
274 
275   /**
276    * @dev Modifier to make a function callable only when the contract is not paused.
277    */
278   modifier whenNotPaused() {
279     require(!_paused);
280     _;
281   }
282 
283   /**
284    * @dev Modifier to make a function callable only when the contract is paused.
285    */
286   modifier whenPaused() {
287     require(_paused);
288     _;
289   }
290 
291   /**
292    * @dev called by the owner to pause, triggers stopped state
293    */
294   function pause() public onlyPauser whenNotPaused {
295     _paused = true;
296     emit Paused(msg.sender);
297   }
298 
299   /**
300    * @dev called by the owner to unpause, returns to normal state
301    */
302   function unpause() public onlyPauser whenPaused {
303     _paused = false;
304     emit Unpaused(msg.sender);
305   }
306 }
307 
308 
309 /**
310  * @title Ownable
311  * @dev The Ownable contract has an owner address, and provides basic authorization control
312  * functions, this simplifies the implementation of "user permissions".
313  */
314 contract Ownable {
315   address private _owner;
316 
317   event OwnershipTransferred(
318     address indexed previousOwner,
319     address indexed newOwner
320   );
321 
322   /**
323    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
324    * account.
325    */
326   constructor(address owner) internal {
327     _owner = owner;
328     emit OwnershipTransferred(address(0), _owner);
329   }
330 
331   /**
332    * @return the address of the owner.
333    */
334   function owner() public view returns(address) {
335     return _owner;
336   }
337 
338   /**
339    * @dev Throws if called by any account other than the owner.
340    */
341   modifier onlyOwner() {
342     require(isOwner());
343     _;
344   }
345 
346   /**
347    * @return true if `msg.sender` is the owner of the contract.
348    */
349   function isOwner() public view returns(bool) {
350     return msg.sender == _owner;
351   }
352 
353   /**
354    * @dev Allows the current owner to relinquish control of the contract.
355    * @notice Renouncing to ownership will leave the contract without an owner.
356    * It will not be possible to call the functions with the `onlyOwner`
357    * modifier anymore.
358    */
359   function renounceOwnership() public onlyOwner {
360     emit OwnershipTransferred(_owner, address(0));
361     _owner = address(0);
362   }
363 
364   /**
365    * @dev Allows the current owner to transfer control of the contract to a newOwner.
366    * @param newOwner The address to transfer ownership to.
367    */
368   function transferOwnership(address newOwner) public onlyOwner {
369     _transferOwnership(newOwner);
370   }
371 
372   /**
373    * @dev Transfers control of the contract to a newOwner.
374    * @param newOwner The address to transfer ownership to.
375    */
376   function _transferOwnership(address newOwner) internal {
377     require(newOwner != address(0));
378     emit OwnershipTransferred(_owner, newOwner);
379     _owner = newOwner;
380   }
381 }
382 
383 
384 /**
385  * @title Attribute Registry interface. EIP-165 ID: 0x5f46473f
386  */
387 interface AttributeRegistryInterface {
388   /**
389    * @notice Check if an attribute of the type with ID `attributeTypeID` has
390    * been assigned to the account at `account` and is currently valid.
391    * @param account address The account to check for a valid attribute.
392    * @param attributeTypeID uint256 The ID of the attribute type to check for.
393    * @return True if the attribute is assigned and valid, false otherwise.
394    * @dev This function MUST return either true or false - i.e. calling this
395    * function MUST NOT cause the caller to revert.
396    */
397   function hasAttribute(
398     address account,
399     uint256 attributeTypeID
400   ) external view returns (bool);
401 
402   /**
403    * @notice Retrieve the value of the attribute of the type with ID
404    * `attributeTypeID` on the account at `account`, assuming it is valid.
405    * @param account address The account to check for the given attribute value.
406    * @param attributeTypeID uint256 The ID of the attribute type to check for.
407    * @return The attribute value if the attribute is valid, reverts otherwise.
408    * @dev This function MUST revert if a directly preceding or subsequent
409    * function call to `hasAttribute` with identical `account` and
410    * `attributeTypeID` parameters would return false.
411    */
412   function getAttributeValue(
413     address account,
414     uint256 attributeTypeID
415   ) external view returns (uint256);
416 
417   /**
418    * @notice Count the number of attribute types defined by the registry.
419    * @return The number of available attribute types.
420    * @dev This function MUST return a positive integer value  - i.e. calling
421    * this function MUST NOT cause the caller to revert.
422    */
423   function countAttributeTypes() external view returns (uint256);
424 
425   /**
426    * @notice Get the ID of the attribute type at index `index`.
427    * @param index uint256 The index of the attribute type in question.
428    * @return The ID of the attribute type.
429    * @dev This function MUST revert if the provided `index` value falls outside
430    * of the range of the value returned from a directly preceding or subsequent
431    * function call to `countAttributeTypes`. It MUST NOT revert if the provided
432    * `index` value falls inside said range.
433    */
434   function getAttributeTypeID(uint256 index) external view returns (uint256);
435 }
436 
437 
438 /**
439  * @title Basic TPL Jurisdiction Interface.
440  */
441 interface BasicJurisdictionInterface {
442   // declare events
443   event AttributeTypeAdded(uint256 indexed attributeTypeID, string description);
444   
445   event AttributeTypeRemoved(uint256 indexed attributeTypeID);
446   
447   event ValidatorAdded(address indexed validator, string description);
448   
449   event ValidatorRemoved(address indexed validator);
450   
451   event ValidatorApprovalAdded(
452     address validator,
453     uint256 indexed attributeTypeID
454   );
455 
456   event ValidatorApprovalRemoved(
457     address validator,
458     uint256 indexed attributeTypeID
459   );
460 
461   event AttributeAdded(
462     address validator,
463     address indexed attributee,
464     uint256 attributeTypeID,
465     uint256 attributeValue
466   );
467 
468   event AttributeRemoved(
469     address validator,
470     address indexed attributee,
471     uint256 attributeTypeID
472   );
473 
474   /**
475   * @notice Add an attribute type with ID `ID` and description `description` to
476   * the jurisdiction.
477   * @param ID uint256 The ID of the attribute type to add.
478   * @param description string A description of the attribute type.
479   * @dev Once an attribute type is added with a given ID, the description of the
480   * attribute type cannot be changed, even if the attribute type is removed and
481   * added back later.
482   */
483   function addAttributeType(uint256 ID, string description) external;
484 
485   /**
486   * @notice Remove the attribute type with ID `ID` from the jurisdiction.
487   * @param ID uint256 The ID of the attribute type to remove.
488   * @dev All issued attributes of the given type will become invalid upon
489   * removal, but will become valid again if the attribute is reinstated.
490   */
491   function removeAttributeType(uint256 ID) external;
492 
493   /**
494   * @notice Add account `validator` as a validator with a description
495   * `description` who can be approved to set attributes of specific types.
496   * @param validator address The account to assign as the validator.
497   * @param description string A description of the validator.
498   * @dev Note that the jurisdiction can add iteslf as a validator if desired.
499   */
500   function addValidator(address validator, string description) external;
501 
502   /**
503   * @notice Remove the validator at address `validator` from the jurisdiction.
504   * @param validator address The account of the validator to remove.
505   * @dev Any attributes issued by the validator will become invalid upon their
506   * removal. If the validator is reinstated, those attributes will become valid
507   * again. Any approvals to issue attributes of a given type will need to be
508   * set from scratch in the event a validator is reinstated.
509   */
510   function removeValidator(address validator) external;
511 
512   /**
513   * @notice Approve the validator at address `validator` to issue attributes of
514   * the type with ID `attributeTypeID`.
515   * @param validator address The account of the validator to approve.
516   * @param attributeTypeID uint256 The ID of the approved attribute type.
517   */
518   function addValidatorApproval(
519     address validator,
520     uint256 attributeTypeID
521   ) external;
522 
523   /**
524   * @notice Deny the validator at address `validator` the ability to continue to
525   * issue attributes of the type with ID `attributeTypeID`.
526   * @param validator address The account of the validator with removed approval.
527   * @param attributeTypeID uint256 The ID of the attribute type to unapprove.
528   * @dev Any attributes of the specified type issued by the validator in
529   * question will become invalid once the approval is removed. If the approval
530   * is reinstated, those attributes will become valid again. The approval will
531   * also be removed if the approved validator is removed.
532   */
533   function removeValidatorApproval(
534     address validator,
535     uint256 attributeTypeID
536   ) external;
537 
538   /**
539   * @notice Issue an attribute of the type with ID `attributeTypeID` and a value
540   * of `value` to `account` if `message.caller.address()` is approved validator.
541   * @param account address The account to issue the attribute on.
542   * @param attributeTypeID uint256 The ID of the attribute type to issue.
543   * @param value uint256 An optional value for the issued attribute.
544   * @dev Existing attributes of the given type on the address must be removed
545   * in order to set a new attribute. Be aware that ownership of the account to
546   * which the attribute is assigned may still be transferable - restricting
547   * assignment to externally-owned accounts may partially alleviate this issue.
548   */
549   function issueAttribute(
550     address account,
551     uint256 attributeTypeID,
552     uint256 value
553   ) external payable;
554 
555   /**
556   * @notice Revoke the attribute of the type with ID `attributeTypeID` from
557   * `account` if `message.caller.address()` is the issuing validator.
558   * @param account address The account to issue the attribute on.
559   * @param attributeTypeID uint256 The ID of the attribute type to issue.
560   * @dev Validators may still revoke issued attributes even after they have been
561   * removed or had their approval to issue the attribute type removed - this
562   * enables them to address any objectionable issuances before being reinstated.
563   */
564   function revokeAttribute(
565     address account,
566     uint256 attributeTypeID
567   ) external;
568 
569   /**
570    * @notice Determine if a validator at account `validator` is able to issue
571    * attributes of the type with ID `attributeTypeID`.
572    * @param validator address The account of the validator.
573    * @param attributeTypeID uint256 The ID of the attribute type to check.
574    * @return True if the validator can issue attributes of the given type, false
575    * otherwise.
576    */
577   function canIssueAttributeType(
578     address validator,
579     uint256 attributeTypeID
580   ) external view returns (bool);
581 
582   /**
583    * @notice Get a description of the attribute type with ID `attributeTypeID`.
584    * @param attributeTypeID uint256 The ID of the attribute type to check for.
585    * @return A description of the attribute type.
586    */
587   function getAttributeTypeDescription(
588     uint256 attributeTypeID
589   ) external view returns (string description);
590   
591   /**
592    * @notice Get a description of the validator at account `validator`.
593    * @param validator address The account of the validator in question.
594    * @return A description of the validator.
595    */
596   function getValidatorDescription(
597     address validator
598   ) external view returns (string description);
599 
600   /**
601    * @notice Find the validator that issued the attribute of the type with ID
602    * `attributeTypeID` on the account at `account` and determine if the
603    * validator is still valid.
604    * @param account address The account that contains the attribute be checked.
605    * @param attributeTypeID uint256 The ID of the attribute type in question.
606    * @return The validator and the current status of the validator as it
607    * pertains to the attribute type in question.
608    * @dev if no attribute of the given attribute type exists on the account, the
609    * function will return (address(0), false).
610    */
611   function getAttributeValidator(
612     address account,
613     uint256 attributeTypeID
614   ) external view returns (address validator, bool isStillValid);
615 
616   /**
617    * @notice Count the number of attribute types defined by the jurisdiction.
618    * @return The number of available attribute types.
619    */
620   function countAttributeTypes() external view returns (uint256);
621 
622   /**
623    * @notice Get the ID of the attribute type at index `index`.
624    * @param index uint256 The index of the attribute type in question.
625    * @return The ID of the attribute type.
626    */
627   function getAttributeTypeID(uint256 index) external view returns (uint256);
628 
629   /**
630    * @notice Get the IDs of all available attribute types on the jurisdiction.
631    * @return A dynamic array containing all available attribute type IDs.
632    */
633   function getAttributeTypeIDs() external view returns (uint256[]);
634 
635   /**
636    * @notice Count the number of validators defined by the jurisdiction.
637    * @return The number of defined validators.
638    */
639   function countValidators() external view returns (uint256);
640 
641   /**
642    * @notice Get the account of the validator at index `index`.
643    * @param index uint256 The index of the validator in question.
644    * @return The account of the validator.
645    */
646   function getValidator(uint256 index) external view returns (address);
647 
648   /**
649    * @notice Get the accounts of all available validators on the jurisdiction.
650    * @return A dynamic array containing all available validator accounts.
651    */
652   function getValidators() external view returns (address[]);
653 }
654 
655 /**
656  * @title Extended TPL Jurisdiction Interface.
657  * @dev this extends BasicJurisdictionInterface for additional functionality.
658  */
659 interface ExtendedJurisdictionInterface {
660   // declare events (NOTE: consider which fields should be indexed)
661   event ValidatorSigningKeyModified(
662     address indexed validator,
663     address newSigningKey
664   );
665 
666   event StakeAllocated(
667     address indexed staker,
668     uint256 indexed attribute,
669     uint256 amount
670   );
671 
672   event StakeRefunded(
673     address indexed staker,
674     uint256 indexed attribute,
675     uint256 amount
676   );
677 
678   event FeePaid(
679     address indexed recipient,
680     address indexed payee,
681     uint256 indexed attribute,
682     uint256 amount
683   );
684   
685   event TransactionRebatePaid(
686     address indexed submitter,
687     address indexed payee,
688     uint256 indexed attribute,
689     uint256 amount
690   );
691 
692   /**
693   * @notice Add a restricted attribute type with ID `ID` and description
694   * `description` to the jurisdiction. Restricted attribute types can only be
695   * removed by the issuing validator or the jurisdiction.
696   * @param ID uint256 The ID of the restricted attribute type to add.
697   * @param description string A description of the restricted attribute type.
698   * @dev Once an attribute type is added with a given ID, the description or the
699   * restricted status of the attribute type cannot be changed, even if the
700   * attribute type is removed and added back later.
701   */
702   function addRestrictedAttributeType(uint256 ID, string description) external;
703 
704   /**
705   * @notice Enable or disable a restriction for a given attribute type ID `ID`
706   * that prevents attributes of the given type from being set by operators based
707   * on the provided value for `onlyPersonal`.
708   * @param ID uint256 The attribute type ID in question.
709   * @param onlyPersonal bool Whether the address may only be set personally.
710   */
711   function setAttributeTypeOnlyPersonal(uint256 ID, bool onlyPersonal) external;
712 
713   /**
714   * @notice Set a secondary source for a given attribute type ID `ID`, with an
715   * address `registry` of the secondary source in question and a given
716   * `sourceAttributeTypeID` for attribute type ID to check on the secondary
717   * source. The secondary source will only be checked for the given attribute in
718   * cases where no attribute of the given attribute type ID is assigned locally.
719   * @param ID uint256 The attribute type ID to set the secondary source for.
720   * @param attributeRegistry address The secondary attribute registry account.
721   * @param sourceAttributeTypeID uint256 The attribute type ID on the secondary
722   * source to check.
723   * @dev To remove a secondary source on an attribute type, the registry address
724   * should be set to the null address.
725   */
726   function setAttributeTypeSecondarySource(
727     uint256 ID,
728     address attributeRegistry,
729     uint256 sourceAttributeTypeID
730   ) external;
731 
732   /**
733   * @notice Set a minimum required stake for a given attribute type ID `ID` and
734   * an amount of `stake`, to be locked in the jurisdiction upon assignment of
735   * attributes of the given type. The stake will be applied toward a transaction
736   * rebate in the event the attribute is revoked, with the remainder returned to
737   * the staker.
738   * @param ID uint256 The attribute type ID to set a minimum required stake for.
739   * @param minimumRequiredStake uint256 The minimum required funds to lock up.
740   * @dev To remove a stake requirement from an attribute type, the stake amount
741   * should be set to 0.
742   */
743   function setAttributeTypeMinimumRequiredStake(
744     uint256 ID,
745     uint256 minimumRequiredStake
746   ) external;
747 
748   /**
749   * @notice Set a required fee for a given attribute type ID `ID` and an amount
750   * of `fee`, to be paid to the owner of the jurisdiction upon assignment of
751   * attributes of the given type.
752   * @param ID uint256 The attribute type ID to set the required fee for.
753   * @param fee uint256 The required fee amount to be paid upon assignment.
754   * @dev To remove a fee requirement from an attribute type, the fee amount
755   * should be set to 0.
756   */
757   function setAttributeTypeJurisdictionFee(uint256 ID, uint256 fee) external;
758 
759   /**
760   * @notice Set the public address associated with a validator signing key, used
761   * to sign off-chain attribute approvals, as `newSigningKey`.
762   * @param newSigningKey address The address associated with signing key to set.
763   */
764   function setValidatorSigningKey(address newSigningKey) external;
765 
766   /**
767   * @notice Add an attribute of the type with ID `attributeTypeID`, an attribute
768   * value of `value`, and an associated validator fee of `validatorFee` to
769   * account of `msg.sender` by passing in a signed attribute approval with
770   * signature `signature`.
771   * @param attributeTypeID uint256 The ID of the attribute type to add.
772   * @param value uint256 The value for the attribute to add.
773   * @param validatorFee uint256 The fee to be paid to the issuing validator.
774   * @param signature bytes The signature from the validator attribute approval.
775   */
776   function addAttribute(
777     uint256 attributeTypeID,
778     uint256 value,
779     uint256 validatorFee,
780     bytes signature
781   ) external payable;
782 
783   /**
784   * @notice Remove an attribute of the type with ID `attributeTypeID` from
785   * account of `msg.sender`.
786   * @param attributeTypeID uint256 The ID of the attribute type to remove.
787   */
788   function removeAttribute(uint256 attributeTypeID) external;
789 
790   /**
791   * @notice Add an attribute of the type with ID `attributeTypeID`, an attribute
792   * value of `value`, and an associated validator fee of `validatorFee` to
793   * account `account` by passing in a signed attribute approval with signature
794   * `signature`.
795   * @param account address The account to add the attribute to.
796   * @param attributeTypeID uint256 The ID of the attribute type to add.
797   * @param value uint256 The value for the attribute to add.
798   * @param validatorFee uint256 The fee to be paid to the issuing validator.
799   * @param signature bytes The signature from the validator attribute approval.
800   * @dev Restricted attribute types can only be removed by issuing validators or
801   * the jurisdiction itself.
802   */
803   function addAttributeFor(
804     address account,
805     uint256 attributeTypeID,
806     uint256 value,
807     uint256 validatorFee,
808     bytes signature
809   ) external payable;
810 
811   /**
812   * @notice Remove an attribute of the type with ID `attributeTypeID` from
813   * account of `account`.
814   * @param account address The account to remove the attribute from.
815   * @param attributeTypeID uint256 The ID of the attribute type to remove.
816   * @dev Restricted attribute types can only be removed by issuing validators or
817   * the jurisdiction itself.
818   */
819   function removeAttributeFor(address account, uint256 attributeTypeID) external;
820 
821   /**
822    * @notice Invalidate a signed attribute approval before it has been set by
823    * supplying the hash of the approval `hash` and the signature `signature`.
824    * @param hash bytes32 The hash of the attribute approval.
825    * @param signature bytes The hash's signature, resolving to the signing key.
826    * @dev Attribute approvals can only be removed by issuing validators or the
827    * jurisdiction itself.
828    */
829   function invalidateAttributeApproval(
830     bytes32 hash,
831     bytes signature
832   ) external;
833 
834   /**
835    * @notice Get the hash of a given attribute approval.
836    * @param account address The account specified by the attribute approval.
837    * @param operator address An optional account permitted to submit approval.
838    * @param attributeTypeID uint256 The ID of the attribute type in question.
839    * @param value uint256 The value of the attribute in the approval.
840    * @param fundsRequired uint256 The amount to be included with the approval.
841    * @param validatorFee uint256 The required fee to be paid to the validator.
842    * @return The hash of the attribute approval.
843    */
844   function getAttributeApprovalHash(
845     address account,
846     address operator,
847     uint256 attributeTypeID,
848     uint256 value,
849     uint256 fundsRequired,
850     uint256 validatorFee
851   ) external view returns (bytes32 hash);
852 
853   /**
854    * @notice Check if a given signed attribute approval is currently valid when
855    * submitted directly by `msg.sender`.
856    * @param attributeTypeID uint256 The ID of the attribute type in question.
857    * @param value uint256 The value of the attribute in the approval.
858    * @param fundsRequired uint256 The amount to be included with the approval.
859    * @param validatorFee uint256 The required fee to be paid to the validator.
860    * @param signature bytes The attribute approval signature, based on a hash of
861    * the other parameters and the submitting account.
862    * @return True if the approval is currently valid, false otherwise.
863    */
864   function canAddAttribute(
865     uint256 attributeTypeID,
866     uint256 value,
867     uint256 fundsRequired,
868     uint256 validatorFee,
869     bytes signature
870   ) external view returns (bool);
871 
872   /**
873    * @notice Check if a given signed attribute approval is currently valid for a
874    * given account when submitted by the operator at `msg.sender`.
875    * @param account address The account specified by the attribute approval.
876    * @param attributeTypeID uint256 The ID of the attribute type in question.
877    * @param value uint256 The value of the attribute in the approval.
878    * @param fundsRequired uint256 The amount to be included with the approval.
879    * @param validatorFee uint256 The required fee to be paid to the validator.
880    * @param signature bytes The attribute approval signature, based on a hash of
881    * the other parameters and the submitting account.
882    * @return True if the approval is currently valid, false otherwise.
883    */
884   function canAddAttributeFor(
885     address account,
886     uint256 attributeTypeID,
887     uint256 value,
888     uint256 fundsRequired,
889     uint256 validatorFee,
890     bytes signature
891   ) external view returns (bool);
892 
893   /**
894    * @notice Get comprehensive information on an attribute type with ID
895    * `attributeTypeID`.
896    * @param attributeTypeID uint256 The attribute type ID in question.
897    * @return Information on the attribute type in question.
898    */
899   function getAttributeTypeInformation(
900     uint256 attributeTypeID
901   ) external view returns (
902     string description,
903     bool isRestricted,
904     bool isOnlyPersonal,
905     address secondarySource,
906     uint256 secondaryId,
907     uint256 minimumRequiredStake,
908     uint256 jurisdictionFee
909   );
910   
911   /**
912    * @notice Get a validator's signing key.
913    * @param validator address The account of the validator.
914    * @return The account referencing the public component of the signing key.
915    */
916   function getValidatorSigningKey(
917     address validator
918   ) external view returns (
919     address signingKey
920   );
921 }
922 
923 /**
924  * @title Interface for checking attribute assignment on YES token and for token
925  * recovery.
926  */
927 interface IERC20 {
928   function balanceOf(address) external view returns (uint256);
929   function transfer(address, uint256) external returns (bool);
930 }
931 
932 /**
933  * @title An extended TPL jurisdiction for assigning attributes to addresses.
934  */
935 contract ExtendedJurisdiction is Ownable, Pausable, AttributeRegistryInterface, BasicJurisdictionInterface, ExtendedJurisdictionInterface {
936   using ECDSA for bytes32;
937   using SafeMath for uint256;
938 
939   // validators are entities who can add or authorize addition of new attributes
940   struct Validator {
941     bool exists;
942     uint256 index; // NOTE: consider use of uint88 to pack struct
943     address signingKey;
944     string description;
945   }
946 
947   // attributes are properties that validators associate with specific addresses
948   struct IssuedAttribute {
949     bool exists;
950     bool setPersonally;
951     address operator;
952     address validator;
953     uint256 value;
954     uint256 stake;
955   }
956 
957   // attributes also have associated type - metadata common to each attribute
958   struct AttributeType {
959     bool exists;
960     bool restricted;
961     bool onlyPersonal;
962     uint256 index; // NOTE: consider use of uint72 to pack struct
963     address secondarySource;
964     uint256 secondaryAttributeTypeID;
965     uint256 minimumStake;
966     uint256 jurisdictionFee;
967     string description;
968     mapping(address => bool) approvedValidators;
969   }
970 
971   // top-level information about attribute types is held in a mapping of structs
972   mapping(uint256 => AttributeType) private _attributeTypes;
973 
974   // the jurisdiction retains a mapping of addresses with assigned attributes
975   mapping(address => mapping(uint256 => IssuedAttribute)) private _issuedAttributes;
976 
977   // there is also a mapping to identify all approved validators and their keys
978   mapping(address => Validator) private _validators;
979 
980   // each registered signing key maps back to a specific validator
981   mapping(address => address) private _signingKeys;
982 
983   // once attribute types are assigned to an ID, they cannot be modified
984   mapping(uint256 => bytes32) private _attributeTypeHashes;
985 
986   // submitted attribute approvals are retained to prevent reuse after removal 
987   mapping(bytes32 => bool) private _invalidAttributeApprovalHashes;
988 
989   // attribute approvals by validator are held in a mapping
990   mapping(address => uint256[]) private _validatorApprovals;
991 
992    // attribute approval index by validator is tracked as well
993   mapping(address => mapping(uint256 => uint256)) private _validatorApprovalsIndex;
994 
995   // IDs for all supplied attributes are held in an array (enables enumeration)
996   uint256[] private _attributeIDs;
997 
998   // addresses for all designated validators are also held in an array
999   address[] private _validatorAccounts;
1000 
1001   // track any recoverable funds locked in the contract 
1002   uint256 private _recoverableFunds;
1003 
1004   /**
1005   * @notice Set the original owner of the jurisdiction using a supplied
1006   * constructor argument.
1007   */
1008   constructor(address owner) public Ownable(owner) {}
1009 
1010   /**
1011   * @notice Add an attribute type with ID `ID` and description `description` to
1012   * the jurisdiction.
1013   * @param ID uint256 The ID of the attribute type to add.
1014   * @param description string A description of the attribute type.
1015   * @dev Once an attribute type is added with a given ID, the description of the
1016   * attribute type cannot be changed, even if the attribute type is removed and
1017   * added back later.
1018   */
1019   function addAttributeType(
1020     uint256 ID,
1021     string description
1022   ) external onlyOwner whenNotPaused {
1023     // prevent existing attributes with the same id from being overwritten
1024     require(
1025       !isAttributeType(ID),
1026       "an attribute type with the provided ID already exists"
1027     );
1028 
1029     // calculate a hash of the attribute type based on the type's properties
1030     bytes32 hash = keccak256(
1031       abi.encodePacked(
1032         ID, false, description
1033       )
1034     );
1035 
1036     // store hash if attribute type is the first one registered with provided ID
1037     if (_attributeTypeHashes[ID] == bytes32(0)) {
1038       _attributeTypeHashes[ID] = hash;
1039     }
1040 
1041     // prevent addition if different attribute type with the same ID has existed
1042     require(
1043       hash == _attributeTypeHashes[ID],
1044       "attribute type properties must match initial properties assigned to ID"
1045     );
1046 
1047     // set the attribute mapping, assigning the index as the end of attributeID
1048     _attributeTypes[ID] = AttributeType({
1049       exists: true,
1050       restricted: false, // when true: users can't remove attribute
1051       onlyPersonal: false, // when true: operators can't add attribute
1052       index: _attributeIDs.length,
1053       secondarySource: address(0), // the address of a remote registry
1054       secondaryAttributeTypeID: uint256(0), // the attribute type id to query
1055       minimumStake: uint256(0), // when > 0: users must stake ether to set
1056       jurisdictionFee: uint256(0),
1057       description: description
1058       // NOTE: no approvedValidators variable declaration - must be added later
1059     });
1060     
1061     // add the attribute type id to the end of the attributeID array
1062     _attributeIDs.push(ID);
1063 
1064     // log the addition of the attribute type
1065     emit AttributeTypeAdded(ID, description);
1066   }
1067 
1068   /**
1069   * @notice Add a restricted attribute type with ID `ID` and description
1070   * `description` to the jurisdiction. Restricted attribute types can only be
1071   * removed by the issuing validator or the jurisdiction.
1072   * @param ID uint256 The ID of the restricted attribute type to add.
1073   * @param description string A description of the restricted attribute type.
1074   * @dev Once an attribute type is added with a given ID, the description or the
1075   * restricted status of the attribute type cannot be changed, even if the
1076   * attribute type is removed and added back later.
1077   */
1078   function addRestrictedAttributeType(
1079     uint256 ID,
1080     string description
1081   ) external onlyOwner whenNotPaused {
1082     // prevent existing attributes with the same id from being overwritten
1083     require(
1084       !isAttributeType(ID),
1085       "an attribute type with the provided ID already exists"
1086     );
1087 
1088     // calculate a hash of the attribute type based on the type's properties
1089     bytes32 hash = keccak256(
1090       abi.encodePacked(
1091         ID, true, description
1092       )
1093     );
1094 
1095     // store hash if attribute type is the first one registered with provided ID
1096     if (_attributeTypeHashes[ID] == bytes32(0)) {
1097       _attributeTypeHashes[ID] = hash;
1098     }
1099 
1100     // prevent addition if different attribute type with the same ID has existed
1101     require(
1102       hash == _attributeTypeHashes[ID],
1103       "attribute type properties must match initial properties assigned to ID"
1104     );
1105 
1106     // set the attribute mapping, assigning the index as the end of attributeID
1107     _attributeTypes[ID] = AttributeType({
1108       exists: true,
1109       restricted: true, // when true: users can't remove attribute
1110       onlyPersonal: false, // when true: operators can't add attribute
1111       index: _attributeIDs.length,
1112       secondarySource: address(0), // the address of a remote registry
1113       secondaryAttributeTypeID: uint256(0), // the attribute type id to query
1114       minimumStake: uint256(0), // when > 0: users must stake ether to set
1115       jurisdictionFee: uint256(0),
1116       description: description
1117       // NOTE: no approvedValidators variable declaration - must be added later
1118     });
1119     
1120     // add the attribute type id to the end of the attributeID array
1121     _attributeIDs.push(ID);
1122 
1123     // log the addition of the attribute type
1124     emit AttributeTypeAdded(ID, description);
1125   }
1126 
1127   /**
1128   * @notice Enable or disable a restriction for a given attribute type ID `ID`
1129   * that prevents attributes of the given type from being set by operators based
1130   * on the provided value for `onlyPersonal`.
1131   * @param ID uint256 The attribute type ID in question.
1132   * @param onlyPersonal bool Whether the address may only be set personally.
1133   */
1134   function setAttributeTypeOnlyPersonal(uint256 ID, bool onlyPersonal) external {
1135     // if the attribute type ID does not exist, there is nothing to remove
1136     require(
1137       isAttributeType(ID),
1138       "unable to set to only personal, no attribute type with the provided ID"
1139     );
1140 
1141     // modify the attribute type in the mapping
1142     _attributeTypes[ID].onlyPersonal = onlyPersonal;
1143   }
1144 
1145   /**
1146   * @notice Set a secondary source for a given attribute type ID `ID`, with an
1147   * address `registry` of the secondary source in question and a given
1148   * `sourceAttributeTypeID` for attribute type ID to check on the secondary
1149   * source. The secondary source will only be checked for the given attribute in
1150   * cases where no attribute of the given attribute type ID is assigned locally.
1151   * @param ID uint256 The attribute type ID to set the secondary source for.
1152   * @param attributeRegistry address The secondary attribute registry account.
1153   * @param sourceAttributeTypeID uint256 The attribute type ID on the secondary
1154   * source to check.
1155   * @dev To remove a secondary source on an attribute type, the registry address
1156   * should be set to the null address.
1157   */
1158   function setAttributeTypeSecondarySource(
1159     uint256 ID,
1160     address attributeRegistry,
1161     uint256 sourceAttributeTypeID
1162   ) external {
1163     // if the attribute type ID does not exist, there is nothing to remove
1164     require(
1165       isAttributeType(ID),
1166       "unable to set secondary source, no attribute type with the provided ID"
1167     );
1168 
1169     // modify the attribute type in the mapping
1170     _attributeTypes[ID].secondarySource = attributeRegistry;
1171     _attributeTypes[ID].secondaryAttributeTypeID = sourceAttributeTypeID;
1172   }
1173 
1174   /**
1175   * @notice Set a minimum required stake for a given attribute type ID `ID` and
1176   * an amount of `stake`, to be locked in the jurisdiction upon assignment of
1177   * attributes of the given type. The stake will be applied toward a transaction
1178   * rebate in the event the attribute is revoked, with the remainder returned to
1179   * the staker.
1180   * @param ID uint256 The attribute type ID to set a minimum required stake for.
1181   * @param minimumRequiredStake uint256 The minimum required funds to lock up.
1182   * @dev To remove a stake requirement from an attribute type, the stake amount
1183   * should be set to 0.
1184   */
1185   function setAttributeTypeMinimumRequiredStake(
1186     uint256 ID,
1187     uint256 minimumRequiredStake
1188   ) external {
1189     // if the attribute type ID does not exist, there is nothing to remove
1190     require(
1191       isAttributeType(ID),
1192       "unable to set minimum stake, no attribute type with the provided ID"
1193     );
1194 
1195     // modify the attribute type in the mapping
1196     _attributeTypes[ID].minimumStake = minimumRequiredStake;
1197   }
1198 
1199   /**
1200   * @notice Set a required fee for a given attribute type ID `ID` and an amount
1201   * of `fee`, to be paid to the owner of the jurisdiction upon assignment of
1202   * attributes of the given type.
1203   * @param ID uint256 The attribute type ID to set the required fee for.
1204   * @param fee uint256 The required fee amount to be paid upon assignment.
1205   * @dev To remove a fee requirement from an attribute type, the fee amount
1206   * should be set to 0.
1207   */
1208   function setAttributeTypeJurisdictionFee(uint256 ID, uint256 fee) external {
1209     // if the attribute type ID does not exist, there is nothing to remove
1210     require(
1211       isAttributeType(ID),
1212       "unable to set fee, no attribute type with the provided ID"
1213     );
1214 
1215     // modify the attribute type in the mapping
1216     _attributeTypes[ID].jurisdictionFee = fee;
1217   }
1218 
1219   /**
1220   * @notice Remove the attribute type with ID `ID` from the jurisdiction.
1221   * @param ID uint256 The ID of the attribute type to remove.
1222   * @dev All issued attributes of the given type will become invalid upon
1223   * removal, but will become valid again if the attribute is reinstated.
1224   */
1225   function removeAttributeType(uint256 ID) external onlyOwner whenNotPaused {
1226     // if the attribute type ID does not exist, there is nothing to remove
1227     require(
1228       isAttributeType(ID),
1229       "unable to remove, no attribute type with the provided ID"
1230     );
1231 
1232     // get the attribute ID at the last index of the array
1233     uint256 lastAttributeID = _attributeIDs[_attributeIDs.length.sub(1)];
1234 
1235     // set the attributeID at attribute-to-delete.index to the last attribute ID
1236     _attributeIDs[_attributeTypes[ID].index] = lastAttributeID;
1237 
1238     // update the index of the attribute type that was moved
1239     _attributeTypes[lastAttributeID].index = _attributeTypes[ID].index;
1240     
1241     // remove the (now duplicate) attribute ID at the end by trimming the array
1242     _attributeIDs.length--;
1243 
1244     // delete the attribute type's record from the mapping
1245     delete _attributeTypes[ID];
1246 
1247     // log the removal of the attribute type
1248     emit AttributeTypeRemoved(ID);
1249   }
1250 
1251   /**
1252   * @notice Add account `validator` as a validator with a description
1253   * `description` who can be approved to set attributes of specific types.
1254   * @param validator address The account to assign as the validator.
1255   * @param description string A description of the validator.
1256   * @dev Note that the jurisdiction can add iteslf as a validator if desired.
1257   */
1258   function addValidator(
1259     address validator,
1260     string description
1261   ) external onlyOwner whenNotPaused {
1262     // check that an empty address was not provided by mistake
1263     require(validator != address(0), "must supply a valid address");
1264 
1265     // prevent existing validators from being overwritten
1266     require(
1267       !isValidator(validator),
1268       "a validator with the provided address already exists"
1269     );
1270 
1271     // prevent duplicate signing keys from being created
1272     require(
1273       _signingKeys[validator] == address(0),
1274       "a signing key matching the provided address already exists"
1275     );
1276     
1277     // create a record for the validator
1278     _validators[validator] = Validator({
1279       exists: true,
1280       index: _validatorAccounts.length,
1281       signingKey: validator, // NOTE: this will be initially set to same address
1282       description: description
1283     });
1284 
1285     // set the initial signing key (the validator's address) resolving to itself
1286     _signingKeys[validator] = validator;
1287 
1288     // add the validator to the end of the _validatorAccounts array
1289     _validatorAccounts.push(validator);
1290     
1291     // log the addition of the new validator
1292     emit ValidatorAdded(validator, description);
1293   }
1294 
1295   /**
1296   * @notice Remove the validator at address `validator` from the jurisdiction.
1297   * @param validator address The account of the validator to remove.
1298   * @dev Any attributes issued by the validator will become invalid upon their
1299   * removal. If the validator is reinstated, those attributes will become valid
1300   * again. Any approvals to issue attributes of a given type will need to be
1301   * set from scratch in the event a validator is reinstated.
1302   */
1303   function removeValidator(address validator) external onlyOwner whenNotPaused {
1304     // check that a validator exists at the provided address
1305     require(
1306       isValidator(validator),
1307       "unable to remove, no validator located at the provided address"
1308     );
1309 
1310     // first, start removing validator approvals until gas is exhausted
1311     while (_validatorApprovals[validator].length > 0 && gasleft() > 25000) {
1312       // locate the index of last attribute ID in the validator approval group
1313       uint256 lastIndex = _validatorApprovals[validator].length.sub(1);
1314 
1315       // locate the validator approval to be removed
1316       uint256 targetApproval = _validatorApprovals[validator][lastIndex];
1317 
1318       // remove the record of the approval from the associated attribute type
1319       delete _attributeTypes[targetApproval].approvedValidators[validator];
1320 
1321       // remove the record of the index of the approval
1322       delete _validatorApprovalsIndex[validator][targetApproval];
1323 
1324       // drop the last attribute ID from the validator approval group
1325       _validatorApprovals[validator].length--;
1326     }
1327 
1328     // require that all approvals were successfully removed
1329     require(
1330       _validatorApprovals[validator].length == 0,
1331       "Cannot remove validator - first remove any existing validator approvals"
1332     );
1333 
1334     // get the validator address at the last index of the array
1335     address lastAccount = _validatorAccounts[_validatorAccounts.length.sub(1)];
1336 
1337     // set the address at validator-to-delete.index to last validator address
1338     _validatorAccounts[_validators[validator].index] = lastAccount;
1339 
1340     // update the index of the attribute type that was moved
1341     _validators[lastAccount].index = _validators[validator].index;
1342     
1343     // remove (duplicate) validator address at the end by trimming the array
1344     _validatorAccounts.length--;
1345 
1346     // remove the validator's signing key from its mapping
1347     delete _signingKeys[_validators[validator].signingKey];
1348 
1349     // remove the validator record
1350     delete _validators[validator];
1351 
1352     // log the removal of the validator
1353     emit ValidatorRemoved(validator);
1354   }
1355 
1356   /**
1357   * @notice Approve the validator at address `validator` to issue attributes of
1358   * the type with ID `attributeTypeID`.
1359   * @param validator address The account of the validator to approve.
1360   * @param attributeTypeID uint256 The ID of the approved attribute type.
1361   */
1362   function addValidatorApproval(
1363     address validator,
1364     uint256 attributeTypeID
1365   ) external onlyOwner whenNotPaused {
1366     // check that the attribute is predefined and that the validator exists
1367     require(
1368       isValidator(validator) && isAttributeType(attributeTypeID),
1369       "must specify both a valid attribute and an available validator"
1370     );
1371 
1372     // check that the validator is not already approved
1373     require(
1374       !_attributeTypes[attributeTypeID].approvedValidators[validator],
1375       "validator is already approved on the provided attribute"
1376     );
1377 
1378     // set the validator approval status on the attribute
1379     _attributeTypes[attributeTypeID].approvedValidators[validator] = true;
1380 
1381     // add the record of the index of the validator approval to be added
1382     uint256 index = _validatorApprovals[validator].length;
1383     _validatorApprovalsIndex[validator][attributeTypeID] = index;
1384 
1385     // include the attribute type in the validator approval mapping
1386     _validatorApprovals[validator].push(attributeTypeID);
1387 
1388     // log the addition of the validator's attribute type approval
1389     emit ValidatorApprovalAdded(validator, attributeTypeID);
1390   }
1391 
1392   /**
1393   * @notice Deny the validator at address `validator` the ability to continue to
1394   * issue attributes of the type with ID `attributeTypeID`.
1395   * @param validator address The account of the validator with removed approval.
1396   * @param attributeTypeID uint256 The ID of the attribute type to unapprove.
1397   * @dev Any attributes of the specified type issued by the validator in
1398   * question will become invalid once the approval is removed. If the approval
1399   * is reinstated, those attributes will become valid again. The approval will
1400   * also be removed if the approved validator is removed.
1401   */
1402   function removeValidatorApproval(
1403     address validator,
1404     uint256 attributeTypeID
1405   ) external onlyOwner whenNotPaused {
1406     // check that the attribute is predefined and that the validator exists
1407     require(
1408       canValidate(validator, attributeTypeID),
1409       "unable to remove validator approval, attribute is already unapproved"
1410     );
1411 
1412     // remove the validator approval status from the attribute
1413     delete _attributeTypes[attributeTypeID].approvedValidators[validator];
1414 
1415     // locate the index of the last validator approval
1416     uint256 lastIndex = _validatorApprovals[validator].length.sub(1);
1417 
1418     // locate the last attribute ID in the validator approval group
1419     uint256 lastAttributeID = _validatorApprovals[validator][lastIndex];
1420 
1421     // locate the index of the validator approval to be removed
1422     uint256 index = _validatorApprovalsIndex[validator][attributeTypeID];
1423 
1424     // replace the validator approval with the last approval in the array
1425     _validatorApprovals[validator][index] = lastAttributeID;
1426 
1427     // drop the last attribute ID from the validator approval group
1428     _validatorApprovals[validator].length--;
1429 
1430     // update the record of the index of the swapped-in approval
1431     _validatorApprovalsIndex[validator][lastAttributeID] = index;
1432 
1433     // remove the record of the index of the removed approval
1434     delete _validatorApprovalsIndex[validator][attributeTypeID];
1435     
1436     // log the removal of the validator's attribute type approval
1437     emit ValidatorApprovalRemoved(validator, attributeTypeID);
1438   }
1439 
1440   /**
1441   * @notice Set the public address associated with a validator signing key, used
1442   * to sign off-chain attribute approvals, as `newSigningKey`.
1443   * @param newSigningKey address The address associated with signing key to set.
1444   * @dev Consider having the validator submit a signed proof demonstrating that
1445   * the provided signing key is indeed a signing key in their control - this
1446   * helps mitigate the fringe attack vector where a validator could set the
1447   * address of another validator candidate (especially in the case of a deployed
1448   * smart contract) as their "signing key" in order to block them from being
1449   * added to the jurisdiction (due to the required property of signing keys
1450   * being unique, coupled with the fact that new validators are set up with
1451   * their address as the default initial signing key).
1452   */
1453   function setValidatorSigningKey(address newSigningKey) external {
1454     require(
1455       isValidator(msg.sender),
1456       "only validators may modify validator signing keys");
1457  
1458     // prevent duplicate signing keys from being created
1459     require(
1460       _signingKeys[newSigningKey] == address(0),
1461       "a signing key matching the provided address already exists"
1462     );
1463 
1464     // remove validator address as the resolved value for the old key
1465     delete _signingKeys[_validators[msg.sender].signingKey];
1466 
1467     // set the signing key to the new value
1468     _validators[msg.sender].signingKey = newSigningKey;
1469 
1470     // add validator address as the resolved value for the new key
1471     _signingKeys[newSigningKey] = msg.sender;
1472 
1473     // log the modification of the signing key
1474     emit ValidatorSigningKeyModified(msg.sender, newSigningKey);
1475   }
1476 
1477   /**
1478   * @notice Issue an attribute of the type with ID `attributeTypeID` and a value
1479   * of `value` to `account` if `message.caller.address()` is approved validator.
1480   * @param account address The account to issue the attribute on.
1481   * @param attributeTypeID uint256 The ID of the attribute type to issue.
1482   * @param value uint256 An optional value for the issued attribute.
1483   * @dev Existing attributes of the given type on the address must be removed
1484   * in order to set a new attribute. Be aware that ownership of the account to
1485   * which the attribute is assigned may still be transferable - restricting
1486   * assignment to externally-owned accounts may partially alleviate this issue.
1487   */
1488   function issueAttribute(
1489     address account,
1490     uint256 attributeTypeID,
1491     uint256 value
1492   ) external payable whenNotPaused {
1493     require(
1494       canValidate(msg.sender, attributeTypeID),
1495       "only approved validators may assign attributes of this type"
1496     );
1497 
1498     require(
1499       !_issuedAttributes[account][attributeTypeID].exists,
1500       "duplicate attributes are not supported, remove existing attribute first"
1501     );
1502 
1503     // retrieve required minimum stake and jurisdiction fees on attribute type
1504     uint256 minimumStake = _attributeTypes[attributeTypeID].minimumStake;
1505     uint256 jurisdictionFee = _attributeTypes[attributeTypeID].jurisdictionFee;
1506     uint256 stake = msg.value.sub(jurisdictionFee);
1507 
1508     require(
1509       stake >= minimumStake,
1510       "attribute requires a greater value than is currently provided"
1511     );
1512 
1513     // store attribute value and amount of ether staked in correct scope
1514     _issuedAttributes[account][attributeTypeID] = IssuedAttribute({
1515       exists: true,
1516       setPersonally: false,
1517       operator: address(0),
1518       validator: msg.sender,
1519       value: value,
1520       stake: stake
1521     });
1522 
1523     // log the addition of the attribute
1524     emit AttributeAdded(msg.sender, account, attributeTypeID, value);
1525 
1526     // log allocation of staked funds to the attribute if applicable
1527     if (stake > 0) {
1528       emit StakeAllocated(msg.sender, attributeTypeID, stake);
1529     }
1530 
1531     // pay jurisdiction fee to the owner of the jurisdiction if applicable
1532     if (jurisdictionFee > 0) {
1533       // NOTE: send is chosen over transfer to prevent cases where a improperly
1534       // configured fallback function could block addition of an attribute
1535       if (owner().send(jurisdictionFee)) {
1536         emit FeePaid(owner(), msg.sender, attributeTypeID, jurisdictionFee);
1537       } else {
1538         _recoverableFunds = _recoverableFunds.add(jurisdictionFee);
1539       }
1540     }
1541   }
1542 
1543   /**
1544   * @notice Revoke the attribute of the type with ID `attributeTypeID` from
1545   * `account` if `message.caller.address()` is the issuing validator.
1546   * @param account address The account to issue the attribute on.
1547   * @param attributeTypeID uint256 The ID of the attribute type to issue.
1548   * @dev Validators may still revoke issued attributes even after they have been
1549   * removed or had their approval to issue the attribute type removed - this
1550   * enables them to address any objectionable issuances before being reinstated.
1551   */
1552   function revokeAttribute(
1553     address account,
1554     uint256 attributeTypeID
1555   ) external whenNotPaused {
1556     // ensure that an attribute with the given account and attribute exists
1557     require(
1558       _issuedAttributes[account][attributeTypeID].exists,
1559       "only existing attributes may be removed"
1560     );
1561 
1562     // determine the assigned validator on the user attribute
1563     address validator = _issuedAttributes[account][attributeTypeID].validator;
1564     
1565     // caller must be either the jurisdiction owner or the assigning validator
1566     require(
1567       msg.sender == validator || msg.sender == owner(),
1568       "only jurisdiction or issuing validators may revoke arbitrary attributes"
1569     );
1570 
1571     // determine if attribute has any stake in order to refund transaction fee
1572     uint256 stake = _issuedAttributes[account][attributeTypeID].stake;
1573 
1574     // determine the correct address to refund the staked amount to
1575     address refundAddress;
1576     if (_issuedAttributes[account][attributeTypeID].setPersonally) {
1577       refundAddress = account;
1578     } else {
1579       address operator = _issuedAttributes[account][attributeTypeID].operator;
1580       if (operator == address(0)) {
1581         refundAddress = validator;
1582       } else {
1583         refundAddress = operator;
1584       }
1585     }
1586 
1587     // remove the attribute from the designated user account
1588     delete _issuedAttributes[account][attributeTypeID];
1589 
1590     // log the removal of the attribute
1591     emit AttributeRemoved(validator, account, attributeTypeID);
1592 
1593     // pay out any refunds and return the excess stake to the user
1594     if (stake > 0 && address(this).balance >= stake) {
1595       // NOTE: send is chosen over transfer to prevent cases where a malicious
1596       // fallback function could forcibly block an attribute's removal. Another
1597       // option is to allow a user to pull the staked amount after the removal.
1598       // NOTE: refine transaction rebate gas calculation! Setting this value too
1599       // high gives validators the incentive to revoke valid attributes. Simply
1600       // checking against gasLeft() & adding the final gas usage won't give the
1601       // correct transaction cost, as freeing space refunds gas upon completion.
1602       uint256 transactionGas = 37700; // <--- WARNING: THIS IS APPROXIMATE
1603       uint256 transactionCost = transactionGas.mul(tx.gasprice);
1604 
1605       // if stake exceeds allocated transaction cost, refund user the difference
1606       if (stake > transactionCost) {
1607         // refund the excess stake to the address that contributed the funds
1608         if (refundAddress.send(stake.sub(transactionCost))) {
1609           emit StakeRefunded(
1610             refundAddress,
1611             attributeTypeID,
1612             stake.sub(transactionCost)
1613           );
1614         } else {
1615           _recoverableFunds = _recoverableFunds.add(stake.sub(transactionCost));
1616         }
1617 
1618         // emit an event for the payment of the transaction rebate
1619         emit TransactionRebatePaid(
1620           tx.origin,
1621           refundAddress,
1622           attributeTypeID,
1623           transactionCost
1624         );
1625 
1626         // refund the cost of the transaction to the trasaction submitter
1627         tx.origin.transfer(transactionCost);
1628 
1629       // otherwise, allocate entire stake to partially refunding the transaction
1630       } else {
1631         // emit an event for the payment of the partial transaction rebate
1632         emit TransactionRebatePaid(
1633           tx.origin,
1634           refundAddress,
1635           attributeTypeID,
1636           stake
1637         );
1638 
1639         // refund the partial cost of the transaction to trasaction submitter
1640         tx.origin.transfer(stake);
1641       }
1642     }
1643   }
1644 
1645   /**
1646   * @notice Add an attribute of the type with ID `attributeTypeID`, an attribute
1647   * value of `value`, and an associated validator fee of `validatorFee` to
1648   * account of `msg.sender` by passing in a signed attribute approval with
1649   * signature `signature`.
1650   * @param attributeTypeID uint256 The ID of the attribute type to add.
1651   * @param value uint256 The value for the attribute to add.
1652   * @param validatorFee uint256 The fee to be paid to the issuing validator.
1653   * @param signature bytes The signature from the validator attribute approval.
1654   */
1655   function addAttribute(
1656     uint256 attributeTypeID,
1657     uint256 value,
1658     uint256 validatorFee,
1659     bytes signature
1660   ) external payable {
1661     // NOTE: determine best course of action when the attribute already exists
1662     // NOTE: consider utilizing bytes32 type for attributes and values
1663     // NOTE: does not currently support an extraData parameter, consider adding
1664     // NOTE: if msg.sender is a proxy contract, its ownership may be transferred
1665     // at will, circumventing any token transfer restrictions. Restricting usage
1666     // to only externally owned accounts may partially alleviate this concern.
1667     // NOTE: cosider including a salt (or better, nonce) parameter so that when
1668     // a user adds an attribute, then it gets revoked, the user can get a new
1669     // signature from the validator and renew the attribute using that. The main
1670     // downside is that everyone will have to keep track of the extra parameter.
1671     // Another solution is to just modifiy the required stake or fee amount.
1672 
1673     require(
1674       !_issuedAttributes[msg.sender][attributeTypeID].exists,
1675       "duplicate attributes are not supported, remove existing attribute first"
1676     );
1677 
1678     // retrieve required minimum stake and jurisdiction fees on attribute type
1679     uint256 minimumStake = _attributeTypes[attributeTypeID].minimumStake;
1680     uint256 jurisdictionFee = _attributeTypes[attributeTypeID].jurisdictionFee;
1681     uint256 stake = msg.value.sub(validatorFee).sub(jurisdictionFee);
1682 
1683     require(
1684       stake >= minimumStake,
1685       "attribute requires a greater value than is currently provided"
1686     );
1687 
1688     // signed data hash constructed according to EIP-191-0x45 to prevent replays
1689     bytes32 hash = keccak256(
1690       abi.encodePacked(
1691         address(this),
1692         msg.sender,
1693         address(0),
1694         msg.value,
1695         validatorFee,
1696         attributeTypeID,
1697         value
1698       )
1699     );
1700 
1701     require(
1702       !_invalidAttributeApprovalHashes[hash],
1703       "signed attribute approvals from validators may not be reused"
1704     );
1705 
1706     // extract the key used to sign the message hash
1707     address signingKey = hash.toEthSignedMessageHash().recover(signature);
1708 
1709     // retrieve the validator who controls the extracted key
1710     address validator = _signingKeys[signingKey];
1711 
1712     require(
1713       canValidate(validator, attributeTypeID),
1714       "signature does not match an approved validator for given attribute type"
1715     );
1716 
1717     // store attribute value and amount of ether staked in correct scope
1718     _issuedAttributes[msg.sender][attributeTypeID] = IssuedAttribute({
1719       exists: true,
1720       setPersonally: true,
1721       operator: address(0),
1722       validator: validator,
1723       value: value,
1724       stake: stake
1725       // NOTE: no extraData included
1726     });
1727 
1728     // flag the signed approval as invalid once it's been used to set attribute
1729     _invalidAttributeApprovalHashes[hash] = true;
1730 
1731     // log the addition of the attribute
1732     emit AttributeAdded(validator, msg.sender, attributeTypeID, value);
1733 
1734     // log allocation of staked funds to the attribute if applicable
1735     if (stake > 0) {
1736       emit StakeAllocated(msg.sender, attributeTypeID, stake);
1737     }
1738 
1739     // pay jurisdiction fee to the owner of the jurisdiction if applicable
1740     if (jurisdictionFee > 0) {
1741       // NOTE: send is chosen over transfer to prevent cases where a improperly
1742       // configured fallback function could block addition of an attribute
1743       if (owner().send(jurisdictionFee)) {
1744         emit FeePaid(owner(), msg.sender, attributeTypeID, jurisdictionFee);
1745       } else {
1746         _recoverableFunds = _recoverableFunds.add(jurisdictionFee);
1747       }
1748     }
1749 
1750     // pay validator fee to the issuing validator's address if applicable
1751     if (validatorFee > 0) {
1752       // NOTE: send is chosen over transfer to prevent cases where a improperly
1753       // configured fallback function could block addition of an attribute
1754       if (validator.send(validatorFee)) {
1755         emit FeePaid(validator, msg.sender, attributeTypeID, validatorFee);
1756       } else {
1757         _recoverableFunds = _recoverableFunds.add(validatorFee);
1758       }
1759     }
1760   }
1761 
1762   /**
1763   * @notice Remove an attribute of the type with ID `attributeTypeID` from
1764   * account of `msg.sender`.
1765   * @param attributeTypeID uint256 The ID of the attribute type to remove.
1766   */
1767   function removeAttribute(uint256 attributeTypeID) external {
1768     // attributes may only be removed by the user if they are not restricted
1769     require(
1770       !_attributeTypes[attributeTypeID].restricted,
1771       "only jurisdiction or issuing validator may remove a restricted attribute"
1772     );
1773 
1774     require(
1775       _issuedAttributes[msg.sender][attributeTypeID].exists,
1776       "only existing attributes may be removed"
1777     );
1778 
1779     // determine the assigned validator on the user attribute
1780     address validator = _issuedAttributes[msg.sender][attributeTypeID].validator;
1781 
1782     // determine if the attribute has a staked value
1783     uint256 stake = _issuedAttributes[msg.sender][attributeTypeID].stake;
1784 
1785     // determine the correct address to refund the staked amount to
1786     address refundAddress;
1787     if (_issuedAttributes[msg.sender][attributeTypeID].setPersonally) {
1788       refundAddress = msg.sender;
1789     } else {
1790       address operator = _issuedAttributes[msg.sender][attributeTypeID].operator;
1791       if (operator == address(0)) {
1792         refundAddress = validator;
1793       } else {
1794         refundAddress = operator;
1795       }
1796     }    
1797 
1798     // remove the attribute from the user address
1799     delete _issuedAttributes[msg.sender][attributeTypeID];
1800 
1801     // log the removal of the attribute
1802     emit AttributeRemoved(validator, msg.sender, attributeTypeID);
1803 
1804     // if the attribute has any staked balance, refund it to the user
1805     if (stake > 0 && address(this).balance >= stake) {
1806       // NOTE: send is chosen over transfer to prevent cases where a malicious
1807       // fallback function could forcibly block an attribute's removal
1808       if (refundAddress.send(stake)) {
1809         emit StakeRefunded(refundAddress, attributeTypeID, stake);
1810       } else {
1811         _recoverableFunds = _recoverableFunds.add(stake);
1812       }
1813     }
1814   }
1815 
1816   /**
1817   * @notice Add an attribute of the type with ID `attributeTypeID`, an attribute
1818   * value of `value`, and an associated validator fee of `validatorFee` to
1819   * account `account` by passing in a signed attribute approval with signature
1820   * `signature`.
1821   * @param account address The account to add the attribute to.
1822   * @param attributeTypeID uint256 The ID of the attribute type to add.
1823   * @param value uint256 The value for the attribute to add.
1824   * @param validatorFee uint256 The fee to be paid to the issuing validator.
1825   * @param signature bytes The signature from the validator attribute approval.
1826   * @dev Restricted attribute types can only be removed by issuing validators or
1827   * the jurisdiction itself.
1828   */
1829   function addAttributeFor(
1830     address account,
1831     uint256 attributeTypeID,
1832     uint256 value,
1833     uint256 validatorFee,
1834     bytes signature
1835   ) external payable {
1836     // NOTE: determine best course of action when the attribute already exists
1837     // NOTE: consider utilizing bytes32 type for attributes and values
1838     // NOTE: does not currently support an extraData parameter, consider adding
1839     // NOTE: if msg.sender is a proxy contract, its ownership may be transferred
1840     // at will, circumventing any token transfer restrictions. Restricting usage
1841     // to only externally owned accounts may partially alleviate this concern.
1842     // NOTE: consider including a salt (or better, nonce) parameter so that when
1843     // a user adds an attribute, then it gets revoked, the user can get a new
1844     // signature from the validator and renew the attribute using that. The main
1845     // downside is that everyone will have to keep track of the extra parameter.
1846     // Another solution is to just modifiy the required stake or fee amount.
1847 
1848     // attributes may only be added by a third party if onlyPersonal is false
1849     require(
1850       !_attributeTypes[attributeTypeID].onlyPersonal,
1851       "only operatable attributes may be added on behalf of another address"
1852     );
1853 
1854     require(
1855       !_issuedAttributes[account][attributeTypeID].exists,
1856       "duplicate attributes are not supported, remove existing attribute first"
1857     );
1858 
1859     // retrieve required minimum stake and jurisdiction fees on attribute type
1860     uint256 minimumStake = _attributeTypes[attributeTypeID].minimumStake;
1861     uint256 jurisdictionFee = _attributeTypes[attributeTypeID].jurisdictionFee;
1862     uint256 stake = msg.value.sub(validatorFee).sub(jurisdictionFee);
1863 
1864     require(
1865       stake >= minimumStake,
1866       "attribute requires a greater value than is currently provided"
1867     );
1868 
1869     // signed data hash constructed according to EIP-191-0x45 to prevent replays
1870     bytes32 hash = keccak256(
1871       abi.encodePacked(
1872         address(this),
1873         account,
1874         msg.sender,
1875         msg.value,
1876         validatorFee,
1877         attributeTypeID,
1878         value
1879       )
1880     );
1881 
1882     require(
1883       !_invalidAttributeApprovalHashes[hash],
1884       "signed attribute approvals from validators may not be reused"
1885     );
1886 
1887     // extract the key used to sign the message hash
1888     address signingKey = hash.toEthSignedMessageHash().recover(signature);
1889 
1890     // retrieve the validator who controls the extracted key
1891     address validator = _signingKeys[signingKey];
1892 
1893     require(
1894       canValidate(validator, attributeTypeID),
1895       "signature does not match an approved validator for provided attribute"
1896     );
1897 
1898     // store attribute value and amount of ether staked in correct scope
1899     _issuedAttributes[account][attributeTypeID] = IssuedAttribute({
1900       exists: true,
1901       setPersonally: false,
1902       operator: msg.sender,
1903       validator: validator,
1904       value: value,
1905       stake: stake
1906       // NOTE: no extraData included
1907     });
1908 
1909     // flag the signed approval as invalid once it's been used to set attribute
1910     _invalidAttributeApprovalHashes[hash] = true;
1911 
1912     // log the addition of the attribute
1913     emit AttributeAdded(validator, account, attributeTypeID, value);
1914 
1915     // log allocation of staked funds to the attribute if applicable
1916     // NOTE: the staker is the entity that pays the fee here!
1917     if (stake > 0) {
1918       emit StakeAllocated(msg.sender, attributeTypeID, stake);
1919     }
1920 
1921     // pay jurisdiction fee to the owner of the jurisdiction if applicable
1922     if (jurisdictionFee > 0) {
1923       // NOTE: send is chosen over transfer to prevent cases where a improperly
1924       // configured fallback function could block addition of an attribute
1925       if (owner().send(jurisdictionFee)) {
1926         emit FeePaid(owner(), msg.sender, attributeTypeID, jurisdictionFee);
1927       } else {
1928         _recoverableFunds = _recoverableFunds.add(jurisdictionFee);
1929       }
1930     }
1931 
1932     // pay validator fee to the issuing validator's address if applicable
1933     if (validatorFee > 0) {
1934       // NOTE: send is chosen over transfer to prevent cases where a improperly
1935       // configured fallback function could block addition of an attribute
1936       if (validator.send(validatorFee)) {
1937         emit FeePaid(validator, msg.sender, attributeTypeID, validatorFee);
1938       } else {
1939         _recoverableFunds = _recoverableFunds.add(validatorFee);
1940       }
1941     }
1942   }
1943 
1944   /**
1945   * @notice Remove an attribute of the type with ID `attributeTypeID` from
1946   * account of `account`.
1947   * @param account address The account to remove the attribute from.
1948   * @param attributeTypeID uint256 The ID of the attribute type to remove.
1949   * @dev Restricted attribute types can only be removed by issuing validators or
1950   * the jurisdiction itself.
1951   */
1952   function removeAttributeFor(address account, uint256 attributeTypeID) external {
1953     // attributes may only be removed by the user if they are not restricted
1954     require(
1955       !_attributeTypes[attributeTypeID].restricted,
1956       "only jurisdiction or issuing validator may remove a restricted attribute"
1957     );
1958 
1959     require(
1960       _issuedAttributes[account][attributeTypeID].exists,
1961       "only existing attributes may be removed"
1962     );
1963 
1964     require(
1965       _issuedAttributes[account][attributeTypeID].operator == msg.sender,
1966       "only an assigning operator may remove attribute on behalf of an address"
1967     );
1968 
1969     // determine the assigned validator on the user attribute
1970     address validator = _issuedAttributes[account][attributeTypeID].validator;
1971 
1972     // determine if the attribute has a staked value
1973     uint256 stake = _issuedAttributes[account][attributeTypeID].stake;
1974 
1975     // remove the attribute from the user address
1976     delete _issuedAttributes[account][attributeTypeID];
1977 
1978     // log the removal of the attribute
1979     emit AttributeRemoved(validator, account, attributeTypeID);
1980 
1981     // if the attribute has any staked balance, refund it to the user
1982     if (stake > 0 && address(this).balance >= stake) {
1983       // NOTE: send is chosen over transfer to prevent cases where a malicious
1984       // fallback function could forcibly block an attribute's removal
1985       if (msg.sender.send(stake)) {
1986         emit StakeRefunded(msg.sender, attributeTypeID, stake);
1987       } else {
1988         _recoverableFunds = _recoverableFunds.add(stake);
1989       }
1990     }
1991   }
1992 
1993   /**
1994    * @notice Invalidate a signed attribute approval before it has been set by
1995    * supplying the hash of the approval `hash` and the signature `signature`.
1996    * @param hash bytes32 The hash of the attribute approval.
1997    * @param signature bytes The hash's signature, resolving to the signing key.
1998    * @dev Attribute approvals can only be removed by issuing validators or the
1999    * jurisdiction itself.
2000    */
2001   function invalidateAttributeApproval(
2002     bytes32 hash,
2003     bytes signature
2004   ) external {
2005     // determine the assigned validator on the signed attribute approval
2006     address validator = _signingKeys[
2007       hash.toEthSignedMessageHash().recover(signature) // signingKey
2008     ];
2009     
2010     // caller must be either the jurisdiction owner or the assigning validator
2011     require(
2012       msg.sender == validator || msg.sender == owner(),
2013       "only jurisdiction or issuing validator may invalidate attribute approval"
2014     );
2015 
2016     // add the hash to the set of invalid attribute approval hashes
2017     _invalidAttributeApprovalHashes[hash] = true;
2018   }
2019 
2020   /**
2021    * @notice Check if an attribute of the type with ID `attributeTypeID` has
2022    * been assigned to the account at `account` and is currently valid.
2023    * @param account address The account to check for a valid attribute.
2024    * @param attributeTypeID uint256 The ID of the attribute type to check for.
2025    * @return True if the attribute is assigned and valid, false otherwise.
2026    * @dev This function MUST return either true or false - i.e. calling this
2027    * function MUST NOT cause the caller to revert.
2028    */
2029   function hasAttribute(
2030     address account, 
2031     uint256 attributeTypeID
2032   ) external view returns (bool) {
2033     address validator = _issuedAttributes[account][attributeTypeID].validator;
2034     return (
2035       (
2036         _validators[validator].exists &&   // isValidator(validator)
2037         _attributeTypes[attributeTypeID].approvedValidators[validator] &&
2038         _attributeTypes[attributeTypeID].exists //isAttributeType(attributeTypeID)
2039       ) || (
2040         _attributeTypes[attributeTypeID].secondarySource != address(0) &&
2041         secondaryHasAttribute(
2042           _attributeTypes[attributeTypeID].secondarySource,
2043           account,
2044           _attributeTypes[attributeTypeID].secondaryAttributeTypeID
2045         )
2046       )
2047     );
2048   }
2049 
2050   /**
2051    * @notice Retrieve the value of the attribute of the type with ID
2052    * `attributeTypeID` on the account at `account`, assuming it is valid.
2053    * @param account address The account to check for the given attribute value.
2054    * @param attributeTypeID uint256 The ID of the attribute type to check for.
2055    * @return The attribute value if the attribute is valid, reverts otherwise.
2056    * @dev This function MUST revert if a directly preceding or subsequent
2057    * function call to `hasAttribute` with identical `account` and
2058    * `attributeTypeID` parameters would return false.
2059    */
2060   function getAttributeValue(
2061     address account,
2062     uint256 attributeTypeID
2063   ) external view returns (uint256 value) {
2064     // gas optimization: get validator & call canValidate function body directly
2065     address validator = _issuedAttributes[account][attributeTypeID].validator;
2066     if (
2067       _validators[validator].exists &&   // isValidator(validator)
2068       _attributeTypes[attributeTypeID].approvedValidators[validator] &&
2069       _attributeTypes[attributeTypeID].exists //isAttributeType(attributeTypeID)
2070     ) {
2071       return _issuedAttributes[account][attributeTypeID].value;
2072     } else if (
2073       _attributeTypes[attributeTypeID].secondarySource != address(0)
2074     ) {
2075       // if attributeTypeID = uint256 of 'wyre-yes-token', use special handling
2076       if (_attributeTypes[attributeTypeID].secondaryAttributeTypeID == 2423228754106148037712574142965102) {
2077         require(
2078           IERC20(
2079             _attributeTypes[attributeTypeID].secondarySource
2080           ).balanceOf(account) >= 1,
2081           "no Yes Token has been issued to the provided account"
2082         );
2083         return 1; // this could also return a specific yes token's country code?
2084       }
2085 
2086       // first ensure hasAttribute on the secondary source returns true
2087       require(
2088         AttributeRegistryInterface(
2089           _attributeTypes[attributeTypeID].secondarySource
2090         ).hasAttribute(
2091           account, _attributeTypes[attributeTypeID].secondaryAttributeTypeID
2092         ),
2093         "attribute of the provided type is not assigned to the provided account"
2094       );
2095 
2096       return (
2097         AttributeRegistryInterface(
2098           _attributeTypes[attributeTypeID].secondarySource
2099         ).getAttributeValue(
2100           account, _attributeTypes[attributeTypeID].secondaryAttributeTypeID
2101         )
2102       );
2103     }
2104 
2105     // NOTE: checking for values of invalid attributes will revert
2106     revert("could not find an attribute value at the provided account and ID");
2107   }
2108 
2109   /**
2110    * @notice Determine if a validator at account `validator` is able to issue
2111    * attributes of the type with ID `attributeTypeID`.
2112    * @param validator address The account of the validator.
2113    * @param attributeTypeID uint256 The ID of the attribute type to check.
2114    * @return True if the validator can issue attributes of the given type, false
2115    * otherwise.
2116    */
2117   function canIssueAttributeType(
2118     address validator,
2119     uint256 attributeTypeID
2120   ) external view returns (bool) {
2121     return canValidate(validator, attributeTypeID);
2122   }
2123 
2124   /**
2125    * @notice Get a description of the attribute type with ID `attributeTypeID`.
2126    * @param attributeTypeID uint256 The ID of the attribute type to check for.
2127    * @return A description of the attribute type.
2128    */
2129   function getAttributeTypeDescription(
2130     uint256 attributeTypeID
2131   ) external view returns (
2132     string description
2133   ) {
2134     return _attributeTypes[attributeTypeID].description;
2135   }
2136 
2137   /**
2138    * @notice Get comprehensive information on an attribute type with ID
2139    * `attributeTypeID`.
2140    * @param attributeTypeID uint256 The attribute type ID in question.
2141    * @return Information on the attribute type in question.
2142    */
2143   function getAttributeTypeInformation(
2144     uint256 attributeTypeID
2145   ) external view returns (
2146     string description,
2147     bool isRestricted,
2148     bool isOnlyPersonal,
2149     address secondarySource,
2150     uint256 secondaryAttributeTypeID,
2151     uint256 minimumRequiredStake,
2152     uint256 jurisdictionFee
2153   ) {
2154     return (
2155       _attributeTypes[attributeTypeID].description,
2156       _attributeTypes[attributeTypeID].restricted,
2157       _attributeTypes[attributeTypeID].onlyPersonal,
2158       _attributeTypes[attributeTypeID].secondarySource,
2159       _attributeTypes[attributeTypeID].secondaryAttributeTypeID,
2160       _attributeTypes[attributeTypeID].minimumStake,
2161       _attributeTypes[attributeTypeID].jurisdictionFee
2162     );
2163   }
2164 
2165   /**
2166    * @notice Get a description of the validator at account `validator`.
2167    * @param validator address The account of the validator in question.
2168    * @return A description of the validator.
2169    */
2170   function getValidatorDescription(
2171     address validator
2172   ) external view returns (
2173     string description
2174   ) {
2175     return _validators[validator].description;
2176   }
2177 
2178   /**
2179    * @notice Get the signing key of the validator at account `validator`.
2180    * @param validator address The account of the validator in question.
2181    * @return The signing key of the validator.
2182    */
2183   function getValidatorSigningKey(
2184     address validator
2185   ) external view returns (
2186     address signingKey
2187   ) {
2188     return _validators[validator].signingKey;
2189   }
2190 
2191   /**
2192    * @notice Find the validator that issued the attribute of the type with ID
2193    * `attributeTypeID` on the account at `account` and determine if the
2194    * validator is still valid.
2195    * @param account address The account that contains the attribute be checked.
2196    * @param attributeTypeID uint256 The ID of the attribute type in question.
2197    * @return The validator and the current status of the validator as it
2198    * pertains to the attribute type in question.
2199    * @dev if no attribute of the given attribute type exists on the account, the
2200    * function will return (address(0), false).
2201    */
2202   function getAttributeValidator(
2203     address account,
2204     uint256 attributeTypeID
2205   ) external view returns (
2206     address validator,
2207     bool isStillValid
2208   ) {
2209     address issuer = _issuedAttributes[account][attributeTypeID].validator;
2210     return (issuer, canValidate(issuer, attributeTypeID));
2211   }
2212 
2213   /**
2214    * @notice Count the number of attribute types defined by the registry.
2215    * @return The number of available attribute types.
2216    * @dev This function MUST return a positive integer value  - i.e. calling
2217    * this function MUST NOT cause the caller to revert.
2218    */
2219   function countAttributeTypes() external view returns (uint256) {
2220     return _attributeIDs.length;
2221   }
2222 
2223   /**
2224    * @notice Get the ID of the attribute type at index `index`.
2225    * @param index uint256 The index of the attribute type in question.
2226    * @return The ID of the attribute type.
2227    * @dev This function MUST revert if the provided `index` value falls outside
2228    * of the range of the value returned from a directly preceding or subsequent
2229    * function call to `countAttributeTypes`. It MUST NOT revert if the provided
2230    * `index` value falls inside said range.
2231    */
2232   function getAttributeTypeID(uint256 index) external view returns (uint256) {
2233     require(
2234       index < _attributeIDs.length,
2235       "provided index is outside of the range of defined attribute type IDs"
2236     );
2237 
2238     return _attributeIDs[index];
2239   }
2240 
2241   /**
2242    * @notice Get the IDs of all available attribute types on the jurisdiction.
2243    * @return A dynamic array containing all available attribute type IDs.
2244    */
2245   function getAttributeTypeIDs() external view returns (uint256[]) {
2246     return _attributeIDs;
2247   }
2248 
2249   /**
2250    * @notice Count the number of validators defined by the jurisdiction.
2251    * @return The number of defined validators.
2252    */
2253   function countValidators() external view returns (uint256) {
2254     return _validatorAccounts.length;
2255   }
2256 
2257   /**
2258    * @notice Get the account of the validator at index `index`.
2259    * @param index uint256 The index of the validator in question.
2260    * @return The account of the validator.
2261    */
2262   function getValidator(
2263     uint256 index
2264   ) external view returns (address) {
2265     return _validatorAccounts[index];
2266   }
2267 
2268   /**
2269    * @notice Get the accounts of all available validators on the jurisdiction.
2270    * @return A dynamic array containing all available validator accounts.
2271    */
2272   function getValidators() external view returns (address[]) {
2273     return _validatorAccounts;
2274   }
2275 
2276   /**
2277    * @notice Determine if the interface ID `interfaceID` is supported (ERC-165)
2278    * @param interfaceID bytes4 The interface ID in question.
2279    * @return True if the interface is supported, false otherwise.
2280    * @dev this function will produce a compiler warning recommending that the
2281    * visibility be set to pure, but the interface expects a view function.
2282    * Supported interfaces include ERC-165 (0x01ffc9a7) and the attribute
2283    * registry interface (0x5f46473f).
2284    */
2285   function supportsInterface(bytes4 interfaceID) external view returns (bool) {
2286     return (
2287       interfaceID == this.supportsInterface.selector || // ERC165
2288       interfaceID == (
2289         this.hasAttribute.selector 
2290         ^ this.getAttributeValue.selector
2291         ^ this.countAttributeTypes.selector
2292         ^ this.getAttributeTypeID.selector
2293       ) // AttributeRegistryInterface
2294     ); // 0x01ffc9a7 || 0x5f46473f
2295   }
2296 
2297   /**
2298    * @notice Get the hash of a given attribute approval.
2299    * @param account address The account specified by the attribute approval.
2300    * @param operator address An optional account permitted to submit approval.
2301    * @param attributeTypeID uint256 The ID of the attribute type in question.
2302    * @param value uint256 The value of the attribute in the approval.
2303    * @param fundsRequired uint256 The amount to be included with the approval.
2304    * @param validatorFee uint256 The required fee to be paid to the validator.
2305    * @return The hash of the attribute approval.
2306    */
2307   function getAttributeApprovalHash(
2308     address account,
2309     address operator,
2310     uint256 attributeTypeID,
2311     uint256 value,
2312     uint256 fundsRequired,
2313     uint256 validatorFee
2314   ) external view returns (
2315     bytes32 hash
2316   ) {
2317     return calculateAttributeApprovalHash(
2318       account,
2319       operator,
2320       attributeTypeID,
2321       value,
2322       fundsRequired,
2323       validatorFee
2324     );
2325   }
2326 
2327   /**
2328    * @notice Check if a given signed attribute approval is currently valid when
2329    * submitted directly by `msg.sender`.
2330    * @param attributeTypeID uint256 The ID of the attribute type in question.
2331    * @param value uint256 The value of the attribute in the approval.
2332    * @param fundsRequired uint256 The amount to be included with the approval.
2333    * @param validatorFee uint256 The required fee to be paid to the validator.
2334    * @param signature bytes The attribute approval signature, based on a hash of
2335    * the other parameters and the submitting account.
2336    * @return True if the approval is currently valid, false otherwise.
2337    */
2338   function canAddAttribute(
2339     uint256 attributeTypeID,
2340     uint256 value,
2341     uint256 fundsRequired,
2342     uint256 validatorFee,
2343     bytes signature
2344   ) external view returns (bool) {
2345     // signed data hash constructed according to EIP-191-0x45 to prevent replays
2346     bytes32 hash = calculateAttributeApprovalHash(
2347       msg.sender,
2348       address(0),
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
2369       !_issuedAttributes[msg.sender][attributeTypeID].exists
2370     );
2371   }
2372 
2373   /**
2374    * @notice Check if a given signed attribute approval is currently valid for a
2375    * given account when submitted by the operator at `msg.sender`.
2376    * @param account address The account specified by the attribute approval.
2377    * @param attributeTypeID uint256 The ID of the attribute type in question.
2378    * @param value uint256 The value of the attribute in the approval.
2379    * @param fundsRequired uint256 The amount to be included with the approval.
2380    * @param validatorFee uint256 The required fee to be paid to the validator.
2381    * @param signature bytes The attribute approval signature, based on a hash of
2382    * the other parameters and the submitting account.
2383    * @return True if the approval is currently valid, false otherwise.
2384    */
2385   function canAddAttributeFor(
2386     address account,
2387     uint256 attributeTypeID,
2388     uint256 value,
2389     uint256 fundsRequired,
2390     uint256 validatorFee,
2391     bytes signature
2392   ) external view returns (bool) {
2393     // signed data hash constructed according to EIP-191-0x45 to prevent replays
2394     bytes32 hash = calculateAttributeApprovalHash(
2395       account,
2396       msg.sender,
2397       attributeTypeID,
2398       value,
2399       fundsRequired,
2400       validatorFee
2401     );
2402 
2403     // recover the address associated with the signature of the message hash
2404     address signingKey = hash.toEthSignedMessageHash().recover(signature);
2405     
2406     // retrieve variables necessary to perform checks
2407     address validator = _signingKeys[signingKey];
2408     uint256 minimumStake = _attributeTypes[attributeTypeID].minimumStake;
2409     uint256 jurisdictionFee = _attributeTypes[attributeTypeID].jurisdictionFee;
2410 
2411     // determine if the attribute can currently be added.
2412     // NOTE: consider returning an error code along with the boolean.
2413     return (
2414       fundsRequired >= minimumStake.add(jurisdictionFee).add(validatorFee) &&
2415       !_invalidAttributeApprovalHashes[hash] &&
2416       canValidate(validator, attributeTypeID) &&
2417       !_issuedAttributes[account][attributeTypeID].exists
2418     );
2419   }
2420 
2421   /**
2422    * @notice Determine if an attribute type with ID `attributeTypeID` is
2423    * currently defined on the jurisdiction.
2424    * @param attributeTypeID uint256 The attribute type ID in question.
2425    * @return True if the attribute type is defined, false otherwise.
2426    */
2427   function isAttributeType(uint256 attributeTypeID) public view returns (bool) {
2428     return _attributeTypes[attributeTypeID].exists;
2429   }
2430 
2431   /**
2432    * @notice Determine if the account `account` is currently assigned as a
2433    * validator on the jurisdiction.
2434    * @param account address The account to check for validator status.
2435    * @return True if the account is assigned as a validator, false otherwise.
2436    */
2437   function isValidator(address account) public view returns (bool) {
2438     return _validators[account].exists;
2439   }
2440 
2441   /**
2442    * @notice Check for recoverable funds that have become locked in the
2443    * jurisdiction as a result of improperly configured receivers for payments of
2444    * fees or remaining stake. Note that funds sent into the jurisdiction as a 
2445    * result of coinbase assignment or as the recipient of a selfdestruct will
2446    * not be recoverable.
2447    * @return The total tracked recoverable funds.
2448    */
2449   function recoverableFunds() public view returns (uint256) {
2450     // return the total tracked recoverable funds.
2451     return _recoverableFunds;
2452   }
2453 
2454   /**
2455    * @notice Check for recoverable tokens that are owned by the jurisdiction at
2456    * the token contract address of `token`.
2457    * @param token address The account where token contract is located.
2458    * @return The total recoverable tokens.
2459    */
2460   function recoverableTokens(address token) public view returns (uint256) {
2461     // return the total tracked recoverable tokens.
2462     return IERC20(token).balanceOf(address(this));
2463   }
2464 
2465   /**
2466    * @notice Recover funds that have become locked in the jurisdiction as a
2467    * result of improperly configured receivers for payments of fees or remaining
2468    * stake by transferring an amount of `value` to the address at `account`.
2469    * Note that funds sent into the jurisdiction as a result of coinbase
2470    * assignment or as the recipient of a selfdestruct will not be recoverable.
2471    * @param account address The account to send recovered tokens.
2472    * @param value uint256 The amount of tokens to be sent.
2473    */
2474   function recoverFunds(address account, uint256 value) public onlyOwner {    
2475     // safely deduct the value from the total tracked recoverable funds.
2476     _recoverableFunds = _recoverableFunds.sub(value);
2477     
2478     // transfer the value to the specified account & revert if any error occurs.
2479     account.transfer(value);
2480   }
2481 
2482   /**
2483    * @notice Recover tokens that are owned by the jurisdiction at the token
2484    * contract address of `token`, transferring an amount of `value` to the
2485    * address at `account`.
2486    * @param token address The account where token contract is located.
2487    * @param account address The account to send recovered funds.
2488    * @param value uint256 The amount of ether to be sent.
2489    */
2490   function recoverTokens(
2491     address token,
2492     address account,
2493     uint256 value
2494   ) public onlyOwner {
2495     // transfer the value to the specified account & revert if any error occurs.
2496     require(IERC20(token).transfer(account, value));
2497   }
2498 
2499   /**
2500    * @notice Internal function to determine if a validator at account
2501    * `validator` can issue attributes of the type with ID `attributeTypeID`.
2502    * @param validator address The account of the validator.
2503    * @param attributeTypeID uint256 The ID of the attribute type to check.
2504    * @return True if the validator can issue attributes of the given type, false
2505    * otherwise.
2506    */
2507   function canValidate(
2508     address validator,
2509     uint256 attributeTypeID
2510   ) internal view returns (bool) {
2511     return (
2512       _validators[validator].exists &&   // isValidator(validator)
2513       _attributeTypes[attributeTypeID].approvedValidators[validator] &&
2514       _attributeTypes[attributeTypeID].exists // isAttributeType(attributeTypeID)
2515     );
2516   }
2517 
2518   // internal helper function for getting the hash of an attribute approval
2519   function calculateAttributeApprovalHash(
2520     address account,
2521     address operator,
2522     uint256 attributeTypeID,
2523     uint256 value,
2524     uint256 fundsRequired,
2525     uint256 validatorFee
2526   ) internal view returns (bytes32 hash) {
2527     return keccak256(
2528       abi.encodePacked(
2529         address(this),
2530         account,
2531         operator,
2532         fundsRequired,
2533         validatorFee,
2534         attributeTypeID,
2535         value
2536       )
2537     );
2538   }
2539 
2540   // helper function, won't revert calling hasAttribute on secondary registries
2541   function secondaryHasAttribute(
2542     address source,
2543     address account,
2544     uint256 attributeTypeID
2545   ) internal view returns (bool result) {
2546     // if attributeTypeID = uint256 of 'wyre-yes-token', use special handling
2547     if (attributeTypeID == 2423228754106148037712574142965102) {
2548       return (IERC20(source).balanceOf(account) >= 1);
2549     }
2550 
2551     uint256 maxGas = gasleft() > 20000 ? 20000 : gasleft();
2552     bytes memory encodedParams = abi.encodeWithSelector(
2553       this.hasAttribute.selector,
2554       account,
2555       attributeTypeID
2556     );
2557 
2558     assembly {
2559       let encodedParams_data := add(0x20, encodedParams)
2560       let encodedParams_size := mload(encodedParams)
2561       
2562       let output := mload(0x40) // get storage start from free memory pointer
2563       mstore(output, 0x0)       // set up the location for output of staticcall
2564 
2565       let success := staticcall(
2566         maxGas,                 // maximum of 20k gas can be forwarded
2567         source,                 // address of attribute registry to call
2568         encodedParams_data,     // inputs are stored at pointer location
2569         encodedParams_size,     // inputs are 68 bytes (4 + 32 * 2)
2570         output,                 // return to designated free space
2571         0x20                    // output is one word, or 32 bytes
2572       )
2573 
2574       switch success            // instrumentation bug: use switch instead of if
2575       case 1 {                  // only recognize successful staticcall output 
2576         result := mload(output) // set the output to the return value
2577       }
2578     }
2579   }
2580 }