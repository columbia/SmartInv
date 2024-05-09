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
326   constructor() internal {
327     _owner = msg.sender;
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
1005   * @notice Add an attribute type with ID `ID` and description `description` to
1006   * the jurisdiction.
1007   * @param ID uint256 The ID of the attribute type to add.
1008   * @param description string A description of the attribute type.
1009   * @dev Once an attribute type is added with a given ID, the description of the
1010   * attribute type cannot be changed, even if the attribute type is removed and
1011   * added back later.
1012   */
1013   function addAttributeType(
1014     uint256 ID,
1015     string description
1016   ) external onlyOwner whenNotPaused {
1017     // prevent existing attributes with the same id from being overwritten
1018     require(
1019       !isAttributeType(ID),
1020       "an attribute type with the provided ID already exists"
1021     );
1022 
1023     // calculate a hash of the attribute type based on the type's properties
1024     bytes32 hash = keccak256(
1025       abi.encodePacked(
1026         ID, false, description
1027       )
1028     );
1029 
1030     // store hash if attribute type is the first one registered with provided ID
1031     if (_attributeTypeHashes[ID] == bytes32(0)) {
1032       _attributeTypeHashes[ID] = hash;
1033     }
1034 
1035     // prevent addition if different attribute type with the same ID has existed
1036     require(
1037       hash == _attributeTypeHashes[ID],
1038       "attribute type properties must match initial properties assigned to ID"
1039     );
1040 
1041     // set the attribute mapping, assigning the index as the end of attributeID
1042     _attributeTypes[ID] = AttributeType({
1043       exists: true,
1044       restricted: false, // when true: users can't remove attribute
1045       onlyPersonal: false, // when true: operators can't add attribute
1046       index: _attributeIDs.length,
1047       secondarySource: address(0), // the address of a remote registry
1048       secondaryAttributeTypeID: uint256(0), // the attribute type id to query
1049       minimumStake: uint256(0), // when > 0: users must stake ether to set
1050       jurisdictionFee: uint256(0),
1051       description: description
1052       // NOTE: no approvedValidators variable declaration - must be added later
1053     });
1054     
1055     // add the attribute type id to the end of the attributeID array
1056     _attributeIDs.push(ID);
1057 
1058     // log the addition of the attribute type
1059     emit AttributeTypeAdded(ID, description);
1060   }
1061 
1062   /**
1063   * @notice Add a restricted attribute type with ID `ID` and description
1064   * `description` to the jurisdiction. Restricted attribute types can only be
1065   * removed by the issuing validator or the jurisdiction.
1066   * @param ID uint256 The ID of the restricted attribute type to add.
1067   * @param description string A description of the restricted attribute type.
1068   * @dev Once an attribute type is added with a given ID, the description or the
1069   * restricted status of the attribute type cannot be changed, even if the
1070   * attribute type is removed and added back later.
1071   */
1072   function addRestrictedAttributeType(
1073     uint256 ID,
1074     string description
1075   ) external onlyOwner whenNotPaused {
1076     // prevent existing attributes with the same id from being overwritten
1077     require(
1078       !isAttributeType(ID),
1079       "an attribute type with the provided ID already exists"
1080     );
1081 
1082     // calculate a hash of the attribute type based on the type's properties
1083     bytes32 hash = keccak256(
1084       abi.encodePacked(
1085         ID, true, description
1086       )
1087     );
1088 
1089     // store hash if attribute type is the first one registered with provided ID
1090     if (_attributeTypeHashes[ID] == bytes32(0)) {
1091       _attributeTypeHashes[ID] = hash;
1092     }
1093 
1094     // prevent addition if different attribute type with the same ID has existed
1095     require(
1096       hash == _attributeTypeHashes[ID],
1097       "attribute type properties must match initial properties assigned to ID"
1098     );
1099 
1100     // set the attribute mapping, assigning the index as the end of attributeID
1101     _attributeTypes[ID] = AttributeType({
1102       exists: true,
1103       restricted: true, // when true: users can't remove attribute
1104       onlyPersonal: false, // when true: operators can't add attribute
1105       index: _attributeIDs.length,
1106       secondarySource: address(0), // the address of a remote registry
1107       secondaryAttributeTypeID: uint256(0), // the attribute type id to query
1108       minimumStake: uint256(0), // when > 0: users must stake ether to set
1109       jurisdictionFee: uint256(0),
1110       description: description
1111       // NOTE: no approvedValidators variable declaration - must be added later
1112     });
1113     
1114     // add the attribute type id to the end of the attributeID array
1115     _attributeIDs.push(ID);
1116 
1117     // log the addition of the attribute type
1118     emit AttributeTypeAdded(ID, description);
1119   }
1120 
1121   /**
1122   * @notice Enable or disable a restriction for a given attribute type ID `ID`
1123   * that prevents attributes of the given type from being set by operators based
1124   * on the provided value for `onlyPersonal`.
1125   * @param ID uint256 The attribute type ID in question.
1126   * @param onlyPersonal bool Whether the address may only be set personally.
1127   */
1128   function setAttributeTypeOnlyPersonal(uint256 ID, bool onlyPersonal) external {
1129     // if the attribute type ID does not exist, there is nothing to remove
1130     require(
1131       isAttributeType(ID),
1132       "unable to set to only personal, no attribute type with the provided ID"
1133     );
1134 
1135     // modify the attribute type in the mapping
1136     _attributeTypes[ID].onlyPersonal = onlyPersonal;
1137   }
1138 
1139   /**
1140   * @notice Set a secondary source for a given attribute type ID `ID`, with an
1141   * address `registry` of the secondary source in question and a given
1142   * `sourceAttributeTypeID` for attribute type ID to check on the secondary
1143   * source. The secondary source will only be checked for the given attribute in
1144   * cases where no attribute of the given attribute type ID is assigned locally.
1145   * @param ID uint256 The attribute type ID to set the secondary source for.
1146   * @param attributeRegistry address The secondary attribute registry account.
1147   * @param sourceAttributeTypeID uint256 The attribute type ID on the secondary
1148   * source to check.
1149   * @dev To remove a secondary source on an attribute type, the registry address
1150   * should be set to the null address.
1151   */
1152   function setAttributeTypeSecondarySource(
1153     uint256 ID,
1154     address attributeRegistry,
1155     uint256 sourceAttributeTypeID
1156   ) external {
1157     // if the attribute type ID does not exist, there is nothing to remove
1158     require(
1159       isAttributeType(ID),
1160       "unable to set secondary source, no attribute type with the provided ID"
1161     );
1162 
1163     // modify the attribute type in the mapping
1164     _attributeTypes[ID].secondarySource = attributeRegistry;
1165     _attributeTypes[ID].secondaryAttributeTypeID = sourceAttributeTypeID;
1166   }
1167 
1168   /**
1169   * @notice Set a minimum required stake for a given attribute type ID `ID` and
1170   * an amount of `stake`, to be locked in the jurisdiction upon assignment of
1171   * attributes of the given type. The stake will be applied toward a transaction
1172   * rebate in the event the attribute is revoked, with the remainder returned to
1173   * the staker.
1174   * @param ID uint256 The attribute type ID to set a minimum required stake for.
1175   * @param minimumRequiredStake uint256 The minimum required funds to lock up.
1176   * @dev To remove a stake requirement from an attribute type, the stake amount
1177   * should be set to 0.
1178   */
1179   function setAttributeTypeMinimumRequiredStake(
1180     uint256 ID,
1181     uint256 minimumRequiredStake
1182   ) external {
1183     // if the attribute type ID does not exist, there is nothing to remove
1184     require(
1185       isAttributeType(ID),
1186       "unable to set minimum stake, no attribute type with the provided ID"
1187     );
1188 
1189     // modify the attribute type in the mapping
1190     _attributeTypes[ID].minimumStake = minimumRequiredStake;
1191   }
1192 
1193   /**
1194   * @notice Set a required fee for a given attribute type ID `ID` and an amount
1195   * of `fee`, to be paid to the owner of the jurisdiction upon assignment of
1196   * attributes of the given type.
1197   * @param ID uint256 The attribute type ID to set the required fee for.
1198   * @param fee uint256 The required fee amount to be paid upon assignment.
1199   * @dev To remove a fee requirement from an attribute type, the fee amount
1200   * should be set to 0.
1201   */
1202   function setAttributeTypeJurisdictionFee(uint256 ID, uint256 fee) external {
1203     // if the attribute type ID does not exist, there is nothing to remove
1204     require(
1205       isAttributeType(ID),
1206       "unable to set fee, no attribute type with the provided ID"
1207     );
1208 
1209     // modify the attribute type in the mapping
1210     _attributeTypes[ID].jurisdictionFee = fee;
1211   }
1212 
1213   /**
1214   * @notice Remove the attribute type with ID `ID` from the jurisdiction.
1215   * @param ID uint256 The ID of the attribute type to remove.
1216   * @dev All issued attributes of the given type will become invalid upon
1217   * removal, but will become valid again if the attribute is reinstated.
1218   */
1219   function removeAttributeType(uint256 ID) external onlyOwner whenNotPaused {
1220     // if the attribute type ID does not exist, there is nothing to remove
1221     require(
1222       isAttributeType(ID),
1223       "unable to remove, no attribute type with the provided ID"
1224     );
1225 
1226     // get the attribute ID at the last index of the array
1227     uint256 lastAttributeID = _attributeIDs[_attributeIDs.length.sub(1)];
1228 
1229     // set the attributeID at attribute-to-delete.index to the last attribute ID
1230     _attributeIDs[_attributeTypes[ID].index] = lastAttributeID;
1231 
1232     // update the index of the attribute type that was moved
1233     _attributeTypes[lastAttributeID].index = _attributeTypes[ID].index;
1234     
1235     // remove the (now duplicate) attribute ID at the end by trimming the array
1236     _attributeIDs.length--;
1237 
1238     // delete the attribute type's record from the mapping
1239     delete _attributeTypes[ID];
1240 
1241     // log the removal of the attribute type
1242     emit AttributeTypeRemoved(ID);
1243   }
1244 
1245   /**
1246   * @notice Add account `validator` as a validator with a description
1247   * `description` who can be approved to set attributes of specific types.
1248   * @param validator address The account to assign as the validator.
1249   * @param description string A description of the validator.
1250   * @dev Note that the jurisdiction can add iteslf as a validator if desired.
1251   */
1252   function addValidator(
1253     address validator,
1254     string description
1255   ) external onlyOwner whenNotPaused {
1256     // check that an empty address was not provided by mistake
1257     require(validator != address(0), "must supply a valid address");
1258 
1259     // prevent existing validators from being overwritten
1260     require(
1261       !isValidator(validator),
1262       "a validator with the provided address already exists"
1263     );
1264 
1265     // prevent duplicate signing keys from being created
1266     require(
1267       _signingKeys[validator] == address(0),
1268       "a signing key matching the provided address already exists"
1269     );
1270     
1271     // create a record for the validator
1272     _validators[validator] = Validator({
1273       exists: true,
1274       index: _validatorAccounts.length,
1275       signingKey: validator, // NOTE: this will be initially set to same address
1276       description: description
1277     });
1278 
1279     // set the initial signing key (the validator's address) resolving to itself
1280     _signingKeys[validator] = validator;
1281 
1282     // add the validator to the end of the _validatorAccounts array
1283     _validatorAccounts.push(validator);
1284     
1285     // log the addition of the new validator
1286     emit ValidatorAdded(validator, description);
1287   }
1288 
1289   /**
1290   * @notice Remove the validator at address `validator` from the jurisdiction.
1291   * @param validator address The account of the validator to remove.
1292   * @dev Any attributes issued by the validator will become invalid upon their
1293   * removal. If the validator is reinstated, those attributes will become valid
1294   * again. Any approvals to issue attributes of a given type will need to be
1295   * set from scratch in the event a validator is reinstated.
1296   */
1297   function removeValidator(address validator) external onlyOwner whenNotPaused {
1298     // check that a validator exists at the provided address
1299     require(
1300       isValidator(validator),
1301       "unable to remove, no validator located at the provided address"
1302     );
1303 
1304     // first, start removing validator approvals until gas is exhausted
1305     while (_validatorApprovals[validator].length > 0 && gasleft() > 25000) {
1306       // locate the index of last attribute ID in the validator approval group
1307       uint256 lastIndex = _validatorApprovals[validator].length.sub(1);
1308 
1309       // locate the validator approval to be removed
1310       uint256 targetApproval = _validatorApprovals[validator][lastIndex];
1311 
1312       // remove the record of the approval from the associated attribute type
1313       delete _attributeTypes[targetApproval].approvedValidators[validator];
1314 
1315       // remove the record of the index of the approval
1316       delete _validatorApprovalsIndex[validator][targetApproval];
1317 
1318       // drop the last attribute ID from the validator approval group
1319       _validatorApprovals[validator].length--;
1320     }
1321 
1322     // require that all approvals were successfully removed
1323     require(
1324       _validatorApprovals[validator].length == 0,
1325       "Cannot remove validator - first remove any existing validator approvals"
1326     );
1327 
1328     // get the validator address at the last index of the array
1329     address lastAccount = _validatorAccounts[_validatorAccounts.length.sub(1)];
1330 
1331     // set the address at validator-to-delete.index to last validator address
1332     _validatorAccounts[_validators[validator].index] = lastAccount;
1333 
1334     // update the index of the attribute type that was moved
1335     _validators[lastAccount].index = _validators[validator].index;
1336     
1337     // remove (duplicate) validator address at the end by trimming the array
1338     _validatorAccounts.length--;
1339 
1340     // remove the validator's signing key from its mapping
1341     delete _signingKeys[_validators[validator].signingKey];
1342 
1343     // remove the validator record
1344     delete _validators[validator];
1345 
1346     // log the removal of the validator
1347     emit ValidatorRemoved(validator);
1348   }
1349 
1350   /**
1351   * @notice Approve the validator at address `validator` to issue attributes of
1352   * the type with ID `attributeTypeID`.
1353   * @param validator address The account of the validator to approve.
1354   * @param attributeTypeID uint256 The ID of the approved attribute type.
1355   */
1356   function addValidatorApproval(
1357     address validator,
1358     uint256 attributeTypeID
1359   ) external onlyOwner whenNotPaused {
1360     // check that the attribute is predefined and that the validator exists
1361     require(
1362       isValidator(validator) && isAttributeType(attributeTypeID),
1363       "must specify both a valid attribute and an available validator"
1364     );
1365 
1366     // check that the validator is not already approved
1367     require(
1368       !_attributeTypes[attributeTypeID].approvedValidators[validator],
1369       "validator is already approved on the provided attribute"
1370     );
1371 
1372     // set the validator approval status on the attribute
1373     _attributeTypes[attributeTypeID].approvedValidators[validator] = true;
1374 
1375     // add the record of the index of the validator approval to be added
1376     uint256 index = _validatorApprovals[validator].length;
1377     _validatorApprovalsIndex[validator][attributeTypeID] = index;
1378 
1379     // include the attribute type in the validator approval mapping
1380     _validatorApprovals[validator].push(attributeTypeID);
1381 
1382     // log the addition of the validator's attribute type approval
1383     emit ValidatorApprovalAdded(validator, attributeTypeID);
1384   }
1385 
1386   /**
1387   * @notice Deny the validator at address `validator` the ability to continue to
1388   * issue attributes of the type with ID `attributeTypeID`.
1389   * @param validator address The account of the validator with removed approval.
1390   * @param attributeTypeID uint256 The ID of the attribute type to unapprove.
1391   * @dev Any attributes of the specified type issued by the validator in
1392   * question will become invalid once the approval is removed. If the approval
1393   * is reinstated, those attributes will become valid again. The approval will
1394   * also be removed if the approved validator is removed.
1395   */
1396   function removeValidatorApproval(
1397     address validator,
1398     uint256 attributeTypeID
1399   ) external onlyOwner whenNotPaused {
1400     // check that the attribute is predefined and that the validator exists
1401     require(
1402       canValidate(validator, attributeTypeID),
1403       "unable to remove validator approval, attribute is already unapproved"
1404     );
1405 
1406     // remove the validator approval status from the attribute
1407     delete _attributeTypes[attributeTypeID].approvedValidators[validator];
1408 
1409     // locate the index of the last validator approval
1410     uint256 lastIndex = _validatorApprovals[validator].length.sub(1);
1411 
1412     // locate the last attribute ID in the validator approval group
1413     uint256 lastAttributeID = _validatorApprovals[validator][lastIndex];
1414 
1415     // locate the index of the validator approval to be removed
1416     uint256 index = _validatorApprovalsIndex[validator][attributeTypeID];
1417 
1418     // replace the validator approval with the last approval in the array
1419     _validatorApprovals[validator][index] = lastAttributeID;
1420 
1421     // drop the last attribute ID from the validator approval group
1422     _validatorApprovals[validator].length--;
1423 
1424     // update the record of the index of the swapped-in approval
1425     _validatorApprovalsIndex[validator][lastAttributeID] = index;
1426 
1427     // remove the record of the index of the removed approval
1428     delete _validatorApprovalsIndex[validator][attributeTypeID];
1429     
1430     // log the removal of the validator's attribute type approval
1431     emit ValidatorApprovalRemoved(validator, attributeTypeID);
1432   }
1433 
1434   /**
1435   * @notice Set the public address associated with a validator signing key, used
1436   * to sign off-chain attribute approvals, as `newSigningKey`.
1437   * @param newSigningKey address The address associated with signing key to set.
1438   * @dev Consider having the validator submit a signed proof demonstrating that
1439   * the provided signing key is indeed a signing key in their control - this
1440   * helps mitigate the fringe attack vector where a validator could set the
1441   * address of another validator candidate (especially in the case of a deployed
1442   * smart contract) as their "signing key" in order to block them from being
1443   * added to the jurisdiction (due to the required property of signing keys
1444   * being unique, coupled with the fact that new validators are set up with
1445   * their address as the default initial signing key).
1446   */
1447   function setValidatorSigningKey(address newSigningKey) external {
1448     require(
1449       isValidator(msg.sender),
1450       "only validators may modify validator signing keys");
1451  
1452     // prevent duplicate signing keys from being created
1453     require(
1454       _signingKeys[newSigningKey] == address(0),
1455       "a signing key matching the provided address already exists"
1456     );
1457 
1458     // remove validator address as the resolved value for the old key
1459     delete _signingKeys[_validators[msg.sender].signingKey];
1460 
1461     // set the signing key to the new value
1462     _validators[msg.sender].signingKey = newSigningKey;
1463 
1464     // add validator address as the resolved value for the new key
1465     _signingKeys[newSigningKey] = msg.sender;
1466 
1467     // log the modification of the signing key
1468     emit ValidatorSigningKeyModified(msg.sender, newSigningKey);
1469   }
1470 
1471   /**
1472   * @notice Issue an attribute of the type with ID `attributeTypeID` and a value
1473   * of `value` to `account` if `message.caller.address()` is approved validator.
1474   * @param account address The account to issue the attribute on.
1475   * @param attributeTypeID uint256 The ID of the attribute type to issue.
1476   * @param value uint256 An optional value for the issued attribute.
1477   * @dev Existing attributes of the given type on the address must be removed
1478   * in order to set a new attribute. Be aware that ownership of the account to
1479   * which the attribute is assigned may still be transferable - restricting
1480   * assignment to externally-owned accounts may partially alleviate this issue.
1481   */
1482   function issueAttribute(
1483     address account,
1484     uint256 attributeTypeID,
1485     uint256 value
1486   ) external payable whenNotPaused {
1487     require(
1488       canValidate(msg.sender, attributeTypeID),
1489       "only approved validators may assign attributes of this type"
1490     );
1491 
1492     require(
1493       !_issuedAttributes[account][attributeTypeID].exists,
1494       "duplicate attributes are not supported, remove existing attribute first"
1495     );
1496 
1497     // retrieve required minimum stake and jurisdiction fees on attribute type
1498     uint256 minimumStake = _attributeTypes[attributeTypeID].minimumStake;
1499     uint256 jurisdictionFee = _attributeTypes[attributeTypeID].jurisdictionFee;
1500     uint256 stake = msg.value.sub(jurisdictionFee);
1501 
1502     require(
1503       stake >= minimumStake,
1504       "attribute requires a greater value than is currently provided"
1505     );
1506 
1507     // store attribute value and amount of ether staked in correct scope
1508     _issuedAttributes[account][attributeTypeID] = IssuedAttribute({
1509       exists: true,
1510       setPersonally: false,
1511       operator: address(0),
1512       validator: msg.sender,
1513       value: value,
1514       stake: stake
1515     });
1516 
1517     // log the addition of the attribute
1518     emit AttributeAdded(msg.sender, account, attributeTypeID, value);
1519 
1520     // log allocation of staked funds to the attribute if applicable
1521     if (stake > 0) {
1522       emit StakeAllocated(msg.sender, attributeTypeID, stake);
1523     }
1524 
1525     // pay jurisdiction fee to the owner of the jurisdiction if applicable
1526     if (jurisdictionFee > 0) {
1527       // NOTE: send is chosen over transfer to prevent cases where a improperly
1528       // configured fallback function could block addition of an attribute
1529       if (owner().send(jurisdictionFee)) {
1530         emit FeePaid(owner(), msg.sender, attributeTypeID, jurisdictionFee);
1531       } else {
1532         _recoverableFunds = _recoverableFunds.add(jurisdictionFee);
1533       }
1534     }
1535   }
1536 
1537   /**
1538   * @notice Revoke the attribute of the type with ID `attributeTypeID` from
1539   * `account` if `message.caller.address()` is the issuing validator.
1540   * @param account address The account to issue the attribute on.
1541   * @param attributeTypeID uint256 The ID of the attribute type to issue.
1542   * @dev Validators may still revoke issued attributes even after they have been
1543   * removed or had their approval to issue the attribute type removed - this
1544   * enables them to address any objectionable issuances before being reinstated.
1545   */
1546   function revokeAttribute(
1547     address account,
1548     uint256 attributeTypeID
1549   ) external whenNotPaused {
1550     // ensure that an attribute with the given account and attribute exists
1551     require(
1552       _issuedAttributes[account][attributeTypeID].exists,
1553       "only existing attributes may be removed"
1554     );
1555 
1556     // determine the assigned validator on the user attribute
1557     address validator = _issuedAttributes[account][attributeTypeID].validator;
1558     
1559     // caller must be either the jurisdiction owner or the assigning validator
1560     require(
1561       msg.sender == validator || msg.sender == owner(),
1562       "only jurisdiction or issuing validators may revoke arbitrary attributes"
1563     );
1564 
1565     // determine if attribute has any stake in order to refund transaction fee
1566     uint256 stake = _issuedAttributes[account][attributeTypeID].stake;
1567 
1568     // determine the correct address to refund the staked amount to
1569     address refundAddress;
1570     if (_issuedAttributes[account][attributeTypeID].setPersonally) {
1571       refundAddress = account;
1572     } else {
1573       address operator = _issuedAttributes[account][attributeTypeID].operator;
1574       if (operator == address(0)) {
1575         refundAddress = validator;
1576       } else {
1577         refundAddress = operator;
1578       }
1579     }
1580 
1581     // remove the attribute from the designated user account
1582     delete _issuedAttributes[account][attributeTypeID];
1583 
1584     // log the removal of the attribute
1585     emit AttributeRemoved(validator, account, attributeTypeID);
1586 
1587     // pay out any refunds and return the excess stake to the user
1588     if (stake > 0 && address(this).balance >= stake) {
1589       // NOTE: send is chosen over transfer to prevent cases where a malicious
1590       // fallback function could forcibly block an attribute's removal. Another
1591       // option is to allow a user to pull the staked amount after the removal.
1592       // NOTE: refine transaction rebate gas calculation! Setting this value too
1593       // high gives validators the incentive to revoke valid attributes. Simply
1594       // checking against gasLeft() & adding the final gas usage won't give the
1595       // correct transaction cost, as freeing space refunds gas upon completion.
1596       uint256 transactionGas = 37700; // <--- WARNING: THIS IS APPROXIMATE
1597       uint256 transactionCost = transactionGas.mul(tx.gasprice);
1598 
1599       // if stake exceeds allocated transaction cost, refund user the difference
1600       if (stake > transactionCost) {
1601         // refund the excess stake to the address that contributed the funds
1602         if (refundAddress.send(stake.sub(transactionCost))) {
1603           emit StakeRefunded(
1604             refundAddress,
1605             attributeTypeID,
1606             stake.sub(transactionCost)
1607           );
1608         } else {
1609           _recoverableFunds = _recoverableFunds.add(stake.sub(transactionCost));
1610         }
1611 
1612         // emit an event for the payment of the transaction rebate
1613         emit TransactionRebatePaid(
1614           tx.origin,
1615           refundAddress,
1616           attributeTypeID,
1617           transactionCost
1618         );
1619 
1620         // refund the cost of the transaction to the trasaction submitter
1621         tx.origin.transfer(transactionCost);
1622 
1623       // otherwise, allocate entire stake to partially refunding the transaction
1624       } else {
1625         // emit an event for the payment of the partial transaction rebate
1626         emit TransactionRebatePaid(
1627           tx.origin,
1628           refundAddress,
1629           attributeTypeID,
1630           stake
1631         );
1632 
1633         // refund the partial cost of the transaction to trasaction submitter
1634         tx.origin.transfer(stake);
1635       }
1636     }
1637   }
1638 
1639   /**
1640   * @notice Add an attribute of the type with ID `attributeTypeID`, an attribute
1641   * value of `value`, and an associated validator fee of `validatorFee` to
1642   * account of `msg.sender` by passing in a signed attribute approval with
1643   * signature `signature`.
1644   * @param attributeTypeID uint256 The ID of the attribute type to add.
1645   * @param value uint256 The value for the attribute to add.
1646   * @param validatorFee uint256 The fee to be paid to the issuing validator.
1647   * @param signature bytes The signature from the validator attribute approval.
1648   */
1649   function addAttribute(
1650     uint256 attributeTypeID,
1651     uint256 value,
1652     uint256 validatorFee,
1653     bytes signature
1654   ) external payable {
1655     // NOTE: determine best course of action when the attribute already exists
1656     // NOTE: consider utilizing bytes32 type for attributes and values
1657     // NOTE: does not currently support an extraData parameter, consider adding
1658     // NOTE: if msg.sender is a proxy contract, its ownership may be transferred
1659     // at will, circumventing any token transfer restrictions. Restricting usage
1660     // to only externally owned accounts may partially alleviate this concern.
1661     // NOTE: cosider including a salt (or better, nonce) parameter so that when
1662     // a user adds an attribute, then it gets revoked, the user can get a new
1663     // signature from the validator and renew the attribute using that. The main
1664     // downside is that everyone will have to keep track of the extra parameter.
1665     // Another solution is to just modifiy the required stake or fee amount.
1666 
1667     require(
1668       !_issuedAttributes[msg.sender][attributeTypeID].exists,
1669       "duplicate attributes are not supported, remove existing attribute first"
1670     );
1671 
1672     // retrieve required minimum stake and jurisdiction fees on attribute type
1673     uint256 minimumStake = _attributeTypes[attributeTypeID].minimumStake;
1674     uint256 jurisdictionFee = _attributeTypes[attributeTypeID].jurisdictionFee;
1675     uint256 stake = msg.value.sub(validatorFee).sub(jurisdictionFee);
1676 
1677     require(
1678       stake >= minimumStake,
1679       "attribute requires a greater value than is currently provided"
1680     );
1681 
1682     // signed data hash constructed according to EIP-191-0x45 to prevent replays
1683     bytes32 hash = keccak256(
1684       abi.encodePacked(
1685         address(this),
1686         msg.sender,
1687         address(0),
1688         msg.value,
1689         validatorFee,
1690         attributeTypeID,
1691         value
1692       )
1693     );
1694 
1695     require(
1696       !_invalidAttributeApprovalHashes[hash],
1697       "signed attribute approvals from validators may not be reused"
1698     );
1699 
1700     // extract the key used to sign the message hash
1701     address signingKey = hash.toEthSignedMessageHash().recover(signature);
1702 
1703     // retrieve the validator who controls the extracted key
1704     address validator = _signingKeys[signingKey];
1705 
1706     require(
1707       canValidate(validator, attributeTypeID),
1708       "signature does not match an approved validator for given attribute type"
1709     );
1710 
1711     // store attribute value and amount of ether staked in correct scope
1712     _issuedAttributes[msg.sender][attributeTypeID] = IssuedAttribute({
1713       exists: true,
1714       setPersonally: true,
1715       operator: address(0),
1716       validator: validator,
1717       value: value,
1718       stake: stake
1719       // NOTE: no extraData included
1720     });
1721 
1722     // flag the signed approval as invalid once it's been used to set attribute
1723     _invalidAttributeApprovalHashes[hash] = true;
1724 
1725     // log the addition of the attribute
1726     emit AttributeAdded(validator, msg.sender, attributeTypeID, value);
1727 
1728     // log allocation of staked funds to the attribute if applicable
1729     if (stake > 0) {
1730       emit StakeAllocated(msg.sender, attributeTypeID, stake);
1731     }
1732 
1733     // pay jurisdiction fee to the owner of the jurisdiction if applicable
1734     if (jurisdictionFee > 0) {
1735       // NOTE: send is chosen over transfer to prevent cases where a improperly
1736       // configured fallback function could block addition of an attribute
1737       if (owner().send(jurisdictionFee)) {
1738         emit FeePaid(owner(), msg.sender, attributeTypeID, jurisdictionFee);
1739       } else {
1740         _recoverableFunds = _recoverableFunds.add(jurisdictionFee);
1741       }
1742     }
1743 
1744     // pay validator fee to the issuing validator's address if applicable
1745     if (validatorFee > 0) {
1746       // NOTE: send is chosen over transfer to prevent cases where a improperly
1747       // configured fallback function could block addition of an attribute
1748       if (validator.send(validatorFee)) {
1749         emit FeePaid(validator, msg.sender, attributeTypeID, validatorFee);
1750       } else {
1751         _recoverableFunds = _recoverableFunds.add(validatorFee);
1752       }
1753     }
1754   }
1755 
1756   /**
1757   * @notice Remove an attribute of the type with ID `attributeTypeID` from
1758   * account of `msg.sender`.
1759   * @param attributeTypeID uint256 The ID of the attribute type to remove.
1760   */
1761   function removeAttribute(uint256 attributeTypeID) external {
1762     // attributes may only be removed by the user if they are not restricted
1763     require(
1764       !_attributeTypes[attributeTypeID].restricted,
1765       "only jurisdiction or issuing validator may remove a restricted attribute"
1766     );
1767 
1768     require(
1769       _issuedAttributes[msg.sender][attributeTypeID].exists,
1770       "only existing attributes may be removed"
1771     );
1772 
1773     // determine the assigned validator on the user attribute
1774     address validator = _issuedAttributes[msg.sender][attributeTypeID].validator;
1775 
1776     // determine if the attribute has a staked value
1777     uint256 stake = _issuedAttributes[msg.sender][attributeTypeID].stake;
1778 
1779     // determine the correct address to refund the staked amount to
1780     address refundAddress;
1781     if (_issuedAttributes[msg.sender][attributeTypeID].setPersonally) {
1782       refundAddress = msg.sender;
1783     } else {
1784       address operator = _issuedAttributes[msg.sender][attributeTypeID].operator;
1785       if (operator == address(0)) {
1786         refundAddress = validator;
1787       } else {
1788         refundAddress = operator;
1789       }
1790     }    
1791 
1792     // remove the attribute from the user address
1793     delete _issuedAttributes[msg.sender][attributeTypeID];
1794 
1795     // log the removal of the attribute
1796     emit AttributeRemoved(validator, msg.sender, attributeTypeID);
1797 
1798     // if the attribute has any staked balance, refund it to the user
1799     if (stake > 0 && address(this).balance >= stake) {
1800       // NOTE: send is chosen over transfer to prevent cases where a malicious
1801       // fallback function could forcibly block an attribute's removal
1802       if (refundAddress.send(stake)) {
1803         emit StakeRefunded(refundAddress, attributeTypeID, stake);
1804       } else {
1805         _recoverableFunds = _recoverableFunds.add(stake);
1806       }
1807     }
1808   }
1809 
1810   /**
1811   * @notice Add an attribute of the type with ID `attributeTypeID`, an attribute
1812   * value of `value`, and an associated validator fee of `validatorFee` to
1813   * account `account` by passing in a signed attribute approval with signature
1814   * `signature`.
1815   * @param account address The account to add the attribute to.
1816   * @param attributeTypeID uint256 The ID of the attribute type to add.
1817   * @param value uint256 The value for the attribute to add.
1818   * @param validatorFee uint256 The fee to be paid to the issuing validator.
1819   * @param signature bytes The signature from the validator attribute approval.
1820   * @dev Restricted attribute types can only be removed by issuing validators or
1821   * the jurisdiction itself.
1822   */
1823   function addAttributeFor(
1824     address account,
1825     uint256 attributeTypeID,
1826     uint256 value,
1827     uint256 validatorFee,
1828     bytes signature
1829   ) external payable {
1830     // NOTE: determine best course of action when the attribute already exists
1831     // NOTE: consider utilizing bytes32 type for attributes and values
1832     // NOTE: does not currently support an extraData parameter, consider adding
1833     // NOTE: if msg.sender is a proxy contract, its ownership may be transferred
1834     // at will, circumventing any token transfer restrictions. Restricting usage
1835     // to only externally owned accounts may partially alleviate this concern.
1836     // NOTE: consider including a salt (or better, nonce) parameter so that when
1837     // a user adds an attribute, then it gets revoked, the user can get a new
1838     // signature from the validator and renew the attribute using that. The main
1839     // downside is that everyone will have to keep track of the extra parameter.
1840     // Another solution is to just modifiy the required stake or fee amount.
1841 
1842     // attributes may only be added by a third party if onlyPersonal is false
1843     require(
1844       !_attributeTypes[attributeTypeID].onlyPersonal,
1845       "only operatable attributes may be added on behalf of another address"
1846     );
1847 
1848     require(
1849       !_issuedAttributes[account][attributeTypeID].exists,
1850       "duplicate attributes are not supported, remove existing attribute first"
1851     );
1852 
1853     // retrieve required minimum stake and jurisdiction fees on attribute type
1854     uint256 minimumStake = _attributeTypes[attributeTypeID].minimumStake;
1855     uint256 jurisdictionFee = _attributeTypes[attributeTypeID].jurisdictionFee;
1856     uint256 stake = msg.value.sub(validatorFee).sub(jurisdictionFee);
1857 
1858     require(
1859       stake >= minimumStake,
1860       "attribute requires a greater value than is currently provided"
1861     );
1862 
1863     // signed data hash constructed according to EIP-191-0x45 to prevent replays
1864     bytes32 hash = keccak256(
1865       abi.encodePacked(
1866         address(this),
1867         account,
1868         msg.sender,
1869         msg.value,
1870         validatorFee,
1871         attributeTypeID,
1872         value
1873       )
1874     );
1875 
1876     require(
1877       !_invalidAttributeApprovalHashes[hash],
1878       "signed attribute approvals from validators may not be reused"
1879     );
1880 
1881     // extract the key used to sign the message hash
1882     address signingKey = hash.toEthSignedMessageHash().recover(signature);
1883 
1884     // retrieve the validator who controls the extracted key
1885     address validator = _signingKeys[signingKey];
1886 
1887     require(
1888       canValidate(validator, attributeTypeID),
1889       "signature does not match an approved validator for provided attribute"
1890     );
1891 
1892     // store attribute value and amount of ether staked in correct scope
1893     _issuedAttributes[account][attributeTypeID] = IssuedAttribute({
1894       exists: true,
1895       setPersonally: false,
1896       operator: msg.sender,
1897       validator: validator,
1898       value: value,
1899       stake: stake
1900       // NOTE: no extraData included
1901     });
1902 
1903     // flag the signed approval as invalid once it's been used to set attribute
1904     _invalidAttributeApprovalHashes[hash] = true;
1905 
1906     // log the addition of the attribute
1907     emit AttributeAdded(validator, account, attributeTypeID, value);
1908 
1909     // log allocation of staked funds to the attribute if applicable
1910     // NOTE: the staker is the entity that pays the fee here!
1911     if (stake > 0) {
1912       emit StakeAllocated(msg.sender, attributeTypeID, stake);
1913     }
1914 
1915     // pay jurisdiction fee to the owner of the jurisdiction if applicable
1916     if (jurisdictionFee > 0) {
1917       // NOTE: send is chosen over transfer to prevent cases where a improperly
1918       // configured fallback function could block addition of an attribute
1919       if (owner().send(jurisdictionFee)) {
1920         emit FeePaid(owner(), msg.sender, attributeTypeID, jurisdictionFee);
1921       } else {
1922         _recoverableFunds = _recoverableFunds.add(jurisdictionFee);
1923       }
1924     }
1925 
1926     // pay validator fee to the issuing validator's address if applicable
1927     if (validatorFee > 0) {
1928       // NOTE: send is chosen over transfer to prevent cases where a improperly
1929       // configured fallback function could block addition of an attribute
1930       if (validator.send(validatorFee)) {
1931         emit FeePaid(validator, msg.sender, attributeTypeID, validatorFee);
1932       } else {
1933         _recoverableFunds = _recoverableFunds.add(validatorFee);
1934       }
1935     }
1936   }
1937 
1938   /**
1939   * @notice Remove an attribute of the type with ID `attributeTypeID` from
1940   * account of `account`.
1941   * @param account address The account to remove the attribute from.
1942   * @param attributeTypeID uint256 The ID of the attribute type to remove.
1943   * @dev Restricted attribute types can only be removed by issuing validators or
1944   * the jurisdiction itself.
1945   */
1946   function removeAttributeFor(address account, uint256 attributeTypeID) external {
1947     // attributes may only be removed by the user if they are not restricted
1948     require(
1949       !_attributeTypes[attributeTypeID].restricted,
1950       "only jurisdiction or issuing validator may remove a restricted attribute"
1951     );
1952 
1953     require(
1954       _issuedAttributes[account][attributeTypeID].exists,
1955       "only existing attributes may be removed"
1956     );
1957 
1958     require(
1959       _issuedAttributes[account][attributeTypeID].operator == msg.sender,
1960       "only an assigning operator may remove attribute on behalf of an address"
1961     );
1962 
1963     // determine the assigned validator on the user attribute
1964     address validator = _issuedAttributes[account][attributeTypeID].validator;
1965 
1966     // determine if the attribute has a staked value
1967     uint256 stake = _issuedAttributes[account][attributeTypeID].stake;
1968 
1969     // remove the attribute from the user address
1970     delete _issuedAttributes[account][attributeTypeID];
1971 
1972     // log the removal of the attribute
1973     emit AttributeRemoved(validator, account, attributeTypeID);
1974 
1975     // if the attribute has any staked balance, refund it to the user
1976     if (stake > 0 && address(this).balance >= stake) {
1977       // NOTE: send is chosen over transfer to prevent cases where a malicious
1978       // fallback function could forcibly block an attribute's removal
1979       if (msg.sender.send(stake)) {
1980         emit StakeRefunded(msg.sender, attributeTypeID, stake);
1981       } else {
1982         _recoverableFunds = _recoverableFunds.add(stake);
1983       }
1984     }
1985   }
1986 
1987   /**
1988    * @notice Invalidate a signed attribute approval before it has been set by
1989    * supplying the hash of the approval `hash` and the signature `signature`.
1990    * @param hash bytes32 The hash of the attribute approval.
1991    * @param signature bytes The hash's signature, resolving to the signing key.
1992    * @dev Attribute approvals can only be removed by issuing validators or the
1993    * jurisdiction itself.
1994    */
1995   function invalidateAttributeApproval(
1996     bytes32 hash,
1997     bytes signature
1998   ) external {
1999     // determine the assigned validator on the signed attribute approval
2000     address validator = _signingKeys[
2001       hash.toEthSignedMessageHash().recover(signature) // signingKey
2002     ];
2003     
2004     // caller must be either the jurisdiction owner or the assigning validator
2005     require(
2006       msg.sender == validator || msg.sender == owner(),
2007       "only jurisdiction or issuing validator may invalidate attribute approval"
2008     );
2009 
2010     // add the hash to the set of invalid attribute approval hashes
2011     _invalidAttributeApprovalHashes[hash] = true;
2012   }
2013 
2014   /**
2015    * @notice Check if an attribute of the type with ID `attributeTypeID` has
2016    * been assigned to the account at `account` and is currently valid.
2017    * @param account address The account to check for a valid attribute.
2018    * @param attributeTypeID uint256 The ID of the attribute type to check for.
2019    * @return True if the attribute is assigned and valid, false otherwise.
2020    * @dev This function MUST return either true or false - i.e. calling this
2021    * function MUST NOT cause the caller to revert.
2022    */
2023   function hasAttribute(
2024     address account, 
2025     uint256 attributeTypeID
2026   ) external view returns (bool) {
2027     address validator = _issuedAttributes[account][attributeTypeID].validator;
2028     return (
2029       (
2030         _validators[validator].exists &&   // isValidator(validator)
2031         _attributeTypes[attributeTypeID].approvedValidators[validator] &&
2032         _attributeTypes[attributeTypeID].exists //isAttributeType(attributeTypeID)
2033       ) || (
2034         _attributeTypes[attributeTypeID].secondarySource != address(0) &&
2035         secondaryHasAttribute(
2036           _attributeTypes[attributeTypeID].secondarySource,
2037           account,
2038           _attributeTypes[attributeTypeID].secondaryAttributeTypeID
2039         )
2040       )
2041     );
2042   }
2043 
2044   /**
2045    * @notice Retrieve the value of the attribute of the type with ID
2046    * `attributeTypeID` on the account at `account`, assuming it is valid.
2047    * @param account address The account to check for the given attribute value.
2048    * @param attributeTypeID uint256 The ID of the attribute type to check for.
2049    * @return The attribute value if the attribute is valid, reverts otherwise.
2050    * @dev This function MUST revert if a directly preceding or subsequent
2051    * function call to `hasAttribute` with identical `account` and
2052    * `attributeTypeID` parameters would return false.
2053    */
2054   function getAttributeValue(
2055     address account,
2056     uint256 attributeTypeID
2057   ) external view returns (uint256 value) {
2058     // gas optimization: get validator & call canValidate function body directly
2059     address validator = _issuedAttributes[account][attributeTypeID].validator;
2060     if (
2061       _validators[validator].exists &&   // isValidator(validator)
2062       _attributeTypes[attributeTypeID].approvedValidators[validator] &&
2063       _attributeTypes[attributeTypeID].exists //isAttributeType(attributeTypeID)
2064     ) {
2065       return _issuedAttributes[account][attributeTypeID].value;
2066     } else if (
2067       _attributeTypes[attributeTypeID].secondarySource != address(0)
2068     ) {
2069       // if attributeTypeID = uint256 of 'wyre-yes-token', use special handling
2070       if (_attributeTypes[attributeTypeID].secondaryAttributeTypeID == 2423228754106148037712574142965102) {
2071         require(
2072           IERC20(
2073             _attributeTypes[attributeTypeID].secondarySource
2074           ).balanceOf(account) >= 1,
2075           "no Yes Token has been issued to the provided account"
2076         );
2077         return 1; // this could also return a specific yes token's country code?
2078       }
2079 
2080       // first ensure hasAttribute on the secondary source returns true
2081       require(
2082         AttributeRegistryInterface(
2083           _attributeTypes[attributeTypeID].secondarySource
2084         ).hasAttribute(
2085           account, _attributeTypes[attributeTypeID].secondaryAttributeTypeID
2086         ),
2087         "attribute of the provided type is not assigned to the provided account"
2088       );
2089 
2090       return (
2091         AttributeRegistryInterface(
2092           _attributeTypes[attributeTypeID].secondarySource
2093         ).getAttributeValue(
2094           account, _attributeTypes[attributeTypeID].secondaryAttributeTypeID
2095         )
2096       );
2097     }
2098 
2099     // NOTE: checking for values of invalid attributes will revert
2100     revert("could not find an attribute value at the provided account and ID");
2101   }
2102 
2103   /**
2104    * @notice Determine if a validator at account `validator` is able to issue
2105    * attributes of the type with ID `attributeTypeID`.
2106    * @param validator address The account of the validator.
2107    * @param attributeTypeID uint256 The ID of the attribute type to check.
2108    * @return True if the validator can issue attributes of the given type, false
2109    * otherwise.
2110    */
2111   function canIssueAttributeType(
2112     address validator,
2113     uint256 attributeTypeID
2114   ) external view returns (bool) {
2115     return canValidate(validator, attributeTypeID);
2116   }
2117 
2118   /**
2119    * @notice Get a description of the attribute type with ID `attributeTypeID`.
2120    * @param attributeTypeID uint256 The ID of the attribute type to check for.
2121    * @return A description of the attribute type.
2122    */
2123   function getAttributeTypeDescription(
2124     uint256 attributeTypeID
2125   ) external view returns (
2126     string description
2127   ) {
2128     return _attributeTypes[attributeTypeID].description;
2129   }
2130 
2131   /**
2132    * @notice Get comprehensive information on an attribute type with ID
2133    * `attributeTypeID`.
2134    * @param attributeTypeID uint256 The attribute type ID in question.
2135    * @return Information on the attribute type in question.
2136    */
2137   function getAttributeTypeInformation(
2138     uint256 attributeTypeID
2139   ) external view returns (
2140     string description,
2141     bool isRestricted,
2142     bool isOnlyPersonal,
2143     address secondarySource,
2144     uint256 secondaryAttributeTypeID,
2145     uint256 minimumRequiredStake,
2146     uint256 jurisdictionFee
2147   ) {
2148     return (
2149       _attributeTypes[attributeTypeID].description,
2150       _attributeTypes[attributeTypeID].restricted,
2151       _attributeTypes[attributeTypeID].onlyPersonal,
2152       _attributeTypes[attributeTypeID].secondarySource,
2153       _attributeTypes[attributeTypeID].secondaryAttributeTypeID,
2154       _attributeTypes[attributeTypeID].minimumStake,
2155       _attributeTypes[attributeTypeID].jurisdictionFee
2156     );
2157   }
2158 
2159   /**
2160    * @notice Get a description of the validator at account `validator`.
2161    * @param validator address The account of the validator in question.
2162    * @return A description of the validator.
2163    */
2164   function getValidatorDescription(
2165     address validator
2166   ) external view returns (
2167     string description
2168   ) {
2169     return _validators[validator].description;
2170   }
2171 
2172   /**
2173    * @notice Get the signing key of the validator at account `validator`.
2174    * @param validator address The account of the validator in question.
2175    * @return The signing key of the validator.
2176    */
2177   function getValidatorSigningKey(
2178     address validator
2179   ) external view returns (
2180     address signingKey
2181   ) {
2182     return _validators[validator].signingKey;
2183   }
2184 
2185   /**
2186    * @notice Find the validator that issued the attribute of the type with ID
2187    * `attributeTypeID` on the account at `account` and determine if the
2188    * validator is still valid.
2189    * @param account address The account that contains the attribute be checked.
2190    * @param attributeTypeID uint256 The ID of the attribute type in question.
2191    * @return The validator and the current status of the validator as it
2192    * pertains to the attribute type in question.
2193    * @dev if no attribute of the given attribute type exists on the account, the
2194    * function will return (address(0), false).
2195    */
2196   function getAttributeValidator(
2197     address account,
2198     uint256 attributeTypeID
2199   ) external view returns (
2200     address validator,
2201     bool isStillValid
2202   ) {
2203     address issuer = _issuedAttributes[account][attributeTypeID].validator;
2204     return (issuer, canValidate(issuer, attributeTypeID));
2205   }
2206 
2207   /**
2208    * @notice Count the number of attribute types defined by the registry.
2209    * @return The number of available attribute types.
2210    * @dev This function MUST return a positive integer value  - i.e. calling
2211    * this function MUST NOT cause the caller to revert.
2212    */
2213   function countAttributeTypes() external view returns (uint256) {
2214     return _attributeIDs.length;
2215   }
2216 
2217   /**
2218    * @notice Get the ID of the attribute type at index `index`.
2219    * @param index uint256 The index of the attribute type in question.
2220    * @return The ID of the attribute type.
2221    * @dev This function MUST revert if the provided `index` value falls outside
2222    * of the range of the value returned from a directly preceding or subsequent
2223    * function call to `countAttributeTypes`. It MUST NOT revert if the provided
2224    * `index` value falls inside said range.
2225    */
2226   function getAttributeTypeID(uint256 index) external view returns (uint256) {
2227     require(
2228       index < _attributeIDs.length,
2229       "provided index is outside of the range of defined attribute type IDs"
2230     );
2231 
2232     return _attributeIDs[index];
2233   }
2234 
2235   /**
2236    * @notice Get the IDs of all available attribute types on the jurisdiction.
2237    * @return A dynamic array containing all available attribute type IDs.
2238    */
2239   function getAttributeTypeIDs() external view returns (uint256[]) {
2240     return _attributeIDs;
2241   }
2242 
2243   /**
2244    * @notice Count the number of validators defined by the jurisdiction.
2245    * @return The number of defined validators.
2246    */
2247   function countValidators() external view returns (uint256) {
2248     return _validatorAccounts.length;
2249   }
2250 
2251   /**
2252    * @notice Get the account of the validator at index `index`.
2253    * @param index uint256 The index of the validator in question.
2254    * @return The account of the validator.
2255    */
2256   function getValidator(
2257     uint256 index
2258   ) external view returns (address) {
2259     return _validatorAccounts[index];
2260   }
2261 
2262   /**
2263    * @notice Get the accounts of all available validators on the jurisdiction.
2264    * @return A dynamic array containing all available validator accounts.
2265    */
2266   function getValidators() external view returns (address[]) {
2267     return _validatorAccounts;
2268   }
2269 
2270   /**
2271    * @notice Determine if the interface ID `interfaceID` is supported (ERC-165)
2272    * @param interfaceID bytes4 The interface ID in question.
2273    * @return True if the interface is supported, false otherwise.
2274    * @dev this function will produce a compiler warning recommending that the
2275    * visibility be set to pure, but the interface expects a view function.
2276    * Supported interfaces include ERC-165 (0x01ffc9a7) and the attribute
2277    * registry interface (0x5f46473f).
2278    */
2279   function supportsInterface(bytes4 interfaceID) external view returns (bool) {
2280     return (
2281       interfaceID == this.supportsInterface.selector || // ERC165
2282       interfaceID == (
2283         this.hasAttribute.selector 
2284         ^ this.getAttributeValue.selector
2285         ^ this.countAttributeTypes.selector
2286         ^ this.getAttributeTypeID.selector
2287       ) // AttributeRegistryInterface
2288     ); // 0x01ffc9a7 || 0x5f46473f
2289   }
2290 
2291   /**
2292    * @notice Get the hash of a given attribute approval.
2293    * @param account address The account specified by the attribute approval.
2294    * @param operator address An optional account permitted to submit approval.
2295    * @param attributeTypeID uint256 The ID of the attribute type in question.
2296    * @param value uint256 The value of the attribute in the approval.
2297    * @param fundsRequired uint256 The amount to be included with the approval.
2298    * @param validatorFee uint256 The required fee to be paid to the validator.
2299    * @return The hash of the attribute approval.
2300    */
2301   function getAttributeApprovalHash(
2302     address account,
2303     address operator,
2304     uint256 attributeTypeID,
2305     uint256 value,
2306     uint256 fundsRequired,
2307     uint256 validatorFee
2308   ) external view returns (
2309     bytes32 hash
2310   ) {
2311     return calculateAttributeApprovalHash(
2312       account,
2313       operator,
2314       attributeTypeID,
2315       value,
2316       fundsRequired,
2317       validatorFee
2318     );
2319   }
2320 
2321   /**
2322    * @notice Check if a given signed attribute approval is currently valid when
2323    * submitted directly by `msg.sender`.
2324    * @param attributeTypeID uint256 The ID of the attribute type in question.
2325    * @param value uint256 The value of the attribute in the approval.
2326    * @param fundsRequired uint256 The amount to be included with the approval.
2327    * @param validatorFee uint256 The required fee to be paid to the validator.
2328    * @param signature bytes The attribute approval signature, based on a hash of
2329    * the other parameters and the submitting account.
2330    * @return True if the approval is currently valid, false otherwise.
2331    */
2332   function canAddAttribute(
2333     uint256 attributeTypeID,
2334     uint256 value,
2335     uint256 fundsRequired,
2336     uint256 validatorFee,
2337     bytes signature
2338   ) external view returns (bool) {
2339     // signed data hash constructed according to EIP-191-0x45 to prevent replays
2340     bytes32 hash = calculateAttributeApprovalHash(
2341       msg.sender,
2342       address(0),
2343       attributeTypeID,
2344       value,
2345       fundsRequired,
2346       validatorFee
2347     );
2348 
2349     // recover the address associated with the signature of the message hash
2350     address signingKey = hash.toEthSignedMessageHash().recover(signature);
2351     
2352     // retrieve variables necessary to perform checks
2353     address validator = _signingKeys[signingKey];
2354     uint256 minimumStake = _attributeTypes[attributeTypeID].minimumStake;
2355     uint256 jurisdictionFee = _attributeTypes[attributeTypeID].jurisdictionFee;
2356 
2357     // determine if the attribute can currently be added.
2358     // NOTE: consider returning an error code along with the boolean.
2359     return (
2360       fundsRequired >= minimumStake.add(jurisdictionFee).add(validatorFee) &&
2361       !_invalidAttributeApprovalHashes[hash] &&
2362       canValidate(validator, attributeTypeID) &&
2363       !_issuedAttributes[msg.sender][attributeTypeID].exists
2364     );
2365   }
2366 
2367   /**
2368    * @notice Check if a given signed attribute approval is currently valid for a
2369    * given account when submitted by the operator at `msg.sender`.
2370    * @param account address The account specified by the attribute approval.
2371    * @param attributeTypeID uint256 The ID of the attribute type in question.
2372    * @param value uint256 The value of the attribute in the approval.
2373    * @param fundsRequired uint256 The amount to be included with the approval.
2374    * @param validatorFee uint256 The required fee to be paid to the validator.
2375    * @param signature bytes The attribute approval signature, based on a hash of
2376    * the other parameters and the submitting account.
2377    * @return True if the approval is currently valid, false otherwise.
2378    */
2379   function canAddAttributeFor(
2380     address account,
2381     uint256 attributeTypeID,
2382     uint256 value,
2383     uint256 fundsRequired,
2384     uint256 validatorFee,
2385     bytes signature
2386   ) external view returns (bool) {
2387     // signed data hash constructed according to EIP-191-0x45 to prevent replays
2388     bytes32 hash = calculateAttributeApprovalHash(
2389       account,
2390       msg.sender,
2391       attributeTypeID,
2392       value,
2393       fundsRequired,
2394       validatorFee
2395     );
2396 
2397     // recover the address associated with the signature of the message hash
2398     address signingKey = hash.toEthSignedMessageHash().recover(signature);
2399     
2400     // retrieve variables necessary to perform checks
2401     address validator = _signingKeys[signingKey];
2402     uint256 minimumStake = _attributeTypes[attributeTypeID].minimumStake;
2403     uint256 jurisdictionFee = _attributeTypes[attributeTypeID].jurisdictionFee;
2404 
2405     // determine if the attribute can currently be added.
2406     // NOTE: consider returning an error code along with the boolean.
2407     return (
2408       fundsRequired >= minimumStake.add(jurisdictionFee).add(validatorFee) &&
2409       !_invalidAttributeApprovalHashes[hash] &&
2410       canValidate(validator, attributeTypeID) &&
2411       !_issuedAttributes[account][attributeTypeID].exists
2412     );
2413   }
2414 
2415   /**
2416    * @notice Determine if an attribute type with ID `attributeTypeID` is
2417    * currently defined on the jurisdiction.
2418    * @param attributeTypeID uint256 The attribute type ID in question.
2419    * @return True if the attribute type is defined, false otherwise.
2420    */
2421   function isAttributeType(uint256 attributeTypeID) public view returns (bool) {
2422     return _attributeTypes[attributeTypeID].exists;
2423   }
2424 
2425   /**
2426    * @notice Determine if the account `account` is currently assigned as a
2427    * validator on the jurisdiction.
2428    * @param account address The account to check for validator status.
2429    * @return True if the account is assigned as a validator, false otherwise.
2430    */
2431   function isValidator(address account) public view returns (bool) {
2432     return _validators[account].exists;
2433   }
2434 
2435   /**
2436    * @notice Check for recoverable funds that have become locked in the
2437    * jurisdiction as a result of improperly configured receivers for payments of
2438    * fees or remaining stake. Note that funds sent into the jurisdiction as a 
2439    * result of coinbase assignment or as the recipient of a selfdestruct will
2440    * not be recoverable.
2441    * @return The total tracked recoverable funds.
2442    */
2443   function recoverableFunds() public view returns (uint256) {
2444     // return the total tracked recoverable funds.
2445     return _recoverableFunds;
2446   }
2447 
2448   /**
2449    * @notice Check for recoverable tokens that are owned by the jurisdiction at
2450    * the token contract address of `token`.
2451    * @param token address The account where token contract is located.
2452    * @return The total recoverable tokens.
2453    */
2454   function recoverableTokens(address token) public view returns (uint256) {
2455     // return the total tracked recoverable tokens.
2456     return IERC20(token).balanceOf(address(this));
2457   }
2458 
2459   /**
2460    * @notice Recover funds that have become locked in the jurisdiction as a
2461    * result of improperly configured receivers for payments of fees or remaining
2462    * stake by transferring an amount of `value` to the address at `account`.
2463    * Note that funds sent into the jurisdiction as a result of coinbase
2464    * assignment or as the recipient of a selfdestruct will not be recoverable.
2465    * @param account address The account to send recovered tokens.
2466    * @param value uint256 The amount of tokens to be sent.
2467    */
2468   function recoverFunds(address account, uint256 value) public onlyOwner {    
2469     // safely deduct the value from the total tracked recoverable funds.
2470     _recoverableFunds = _recoverableFunds.sub(value);
2471     
2472     // transfer the value to the specified account & revert if any error occurs.
2473     account.transfer(value);
2474   }
2475 
2476   /**
2477    * @notice Recover tokens that are owned by the jurisdiction at the token
2478    * contract address of `token`, transferring an amount of `value` to the
2479    * address at `account`.
2480    * @param token address The account where token contract is located.
2481    * @param account address The account to send recovered funds.
2482    * @param value uint256 The amount of ether to be sent.
2483    */
2484   function recoverTokens(
2485     address token,
2486     address account,
2487     uint256 value
2488   ) public onlyOwner {
2489     // transfer the value to the specified account & revert if any error occurs.
2490     require(IERC20(token).transfer(account, value));
2491   }
2492 
2493   /**
2494    * @notice Internal function to determine if a validator at account
2495    * `validator` can issue attributes of the type with ID `attributeTypeID`.
2496    * @param validator address The account of the validator.
2497    * @param attributeTypeID uint256 The ID of the attribute type to check.
2498    * @return True if the validator can issue attributes of the given type, false
2499    * otherwise.
2500    */
2501   function canValidate(
2502     address validator,
2503     uint256 attributeTypeID
2504   ) internal view returns (bool) {
2505     return (
2506       _validators[validator].exists &&   // isValidator(validator)
2507       _attributeTypes[attributeTypeID].approvedValidators[validator] &&
2508       _attributeTypes[attributeTypeID].exists // isAttributeType(attributeTypeID)
2509     );
2510   }
2511 
2512   // internal helper function for getting the hash of an attribute approval
2513   function calculateAttributeApprovalHash(
2514     address account,
2515     address operator,
2516     uint256 attributeTypeID,
2517     uint256 value,
2518     uint256 fundsRequired,
2519     uint256 validatorFee
2520   ) internal view returns (bytes32 hash) {
2521     return keccak256(
2522       abi.encodePacked(
2523         address(this),
2524         account,
2525         operator,
2526         fundsRequired,
2527         validatorFee,
2528         attributeTypeID,
2529         value
2530       )
2531     );
2532   }
2533 
2534   // helper function, won't revert calling hasAttribute on secondary registries
2535   function secondaryHasAttribute(
2536     address source,
2537     address account,
2538     uint256 attributeTypeID
2539   ) internal view returns (bool result) {
2540     // if attributeTypeID = uint256 of 'wyre-yes-token', use special handling
2541     if (attributeTypeID == 2423228754106148037712574142965102) {
2542       return (IERC20(source).balanceOf(account) >= 1);
2543     }
2544 
2545     uint256 maxGas = gasleft() > 20000 ? 20000 : gasleft();
2546     bytes memory encodedParams = abi.encodeWithSelector(
2547       this.hasAttribute.selector,
2548       account,
2549       attributeTypeID
2550     );
2551 
2552     assembly {
2553       let encodedParams_data := add(0x20, encodedParams)
2554       let encodedParams_size := mload(encodedParams)
2555       
2556       let output := mload(0x40) // get storage start from free memory pointer
2557       mstore(output, 0x0)       // set up the location for output of staticcall
2558 
2559       let success := staticcall(
2560         maxGas,                 // maximum of 20k gas can be forwarded
2561         source,                 // address of attribute registry to call
2562         encodedParams_data,     // inputs are stored at pointer location
2563         encodedParams_size,     // inputs are 68 bytes (4 + 32 * 2)
2564         output,                 // return to designated free space
2565         0x20                    // output is one word, or 32 bytes
2566       )
2567 
2568       switch success            // instrumentation bug: use switch instead of if
2569       case 1 {                  // only recognize successful staticcall output 
2570         result := mload(output) // set the output to the return value
2571       }
2572     }
2573   }
2574 }