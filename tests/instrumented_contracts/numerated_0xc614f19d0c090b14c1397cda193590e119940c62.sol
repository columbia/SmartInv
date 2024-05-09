1 pragma solidity ^0.5.10;
2 
3 /** @title  A contract for generating unique identifiers
4   *
5   * @notice  A contract that provides an identifier generation scheme,
6   * guaranteeing uniqueness across all contracts that inherit from it,
7   * as well as the unpredictability of future identifiers.
8   *
9   * @dev  This contract is intended to be inherited by any contract that
10   * implements the callback software pattern for cooperative custodianship.
11   *
12 */
13 contract LockRequestable {
14 
15     // MEMBERS
16     /// @notice  the count of all invocations of `generateLockId`.
17     uint256 public lockRequestCount;
18 
19     // CONSTRUCTOR
20     constructor() public {
21         lockRequestCount = 0;
22     }
23 
24     // FUNCTIONS
25     /** @notice  Returns a fresh unique identifier.
26       *
27       * @dev the generation scheme uses three components.
28       * First, the blockhash of the previous block.
29       * Second, the deployed address.
30       * Third, the next value of the counter.
31       * This ensures that identifiers are unique across all contracts
32       * following this scheme, and that future identifiers are
33       * unpredictable.
34       *
35       * @return a 32-byte unique identifier.
36     */
37     function generateLockId() internal returns (bytes32 lockId) {
38         return keccak256(abi.encodePacked(blockhash(block.number - 1), address(this), ++lockRequestCount));
39     }
40 }
41 
42 contract ERC20Interface {
43 
44     // METHODS
45 
46     // NOTE:
47     //   public getter functions are not currently recognised as an
48     //   implementation of the matching abstract function by the compiler.
49 
50     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#name
51     // function name() public view returns (string);
52 
53     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#symbol
54     // function symbol() public view returns (string);
55 
56     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#totalsupply
57     // function decimals() public view returns (uint8);
58 
59     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#totalsupply
60     function totalSupply() public view returns (uint256);
61 
62     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#balanceof
63     function balanceOf(address _owner) public view returns (uint256 balance);
64 
65     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer
66     function transfer(address _to, uint256 _value) public returns (bool success);
67 
68     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transferfrom
69     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
70 
71     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approve
72     function approve(address _spender, uint256 _value) public returns (bool success);
73 
74     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#allowance
75     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
76 
77     // EVENTS
78     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer-1
79     event Transfer(address indexed _from, address indexed _to, uint256 _value);
80 
81     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approval
82     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83 }
84 
85 /** @title  A dual control contract.
86   *
87   * @notice  A general-purpose contract that implements dual control over
88   * co-operating contracts through a callback mechanism.
89   *
90   * @dev  This contract implements dual control through a 2-of-N
91   * threshold multi-signature scheme. The contract recognizes a set of N signers,
92   * and will unlock requests with signatures from any distinct pair of them.
93   * This contract signals the unlocking through a co-operative callback
94   * scheme.
95   * This contract also provides time lock and revocation features.
96   * Requests made by a 'primary' account have a default time lock applied.
97   * All other requests must pay a 1 ETH stake and have an extended time lock
98   * applied.
99   * A request that is completed will prevent all previous pending requests
100   * that share the same callback from being completed: this is the
101   * revocation feature.
102   *
103   */
104 contract Custodian {
105 
106     // TYPES
107     /** @dev  The `Request` struct stores a pending unlocking.
108       * `callbackAddress` and `callbackSelector` are the data required to
109       * make a callback. The custodian completes the process by
110       * calling `callbackAddress.call(callbackSelector, lockId)`, which
111       * signals to the contract co-operating with the Custodian that
112       * the 2-of-N signatures have been provided and verified.
113       */
114     struct Request {
115         bytes32 lockId;
116         bytes4 callbackSelector;  // bytes4 and address can be packed into 1 word
117         address callbackAddress;
118         uint256 idx;
119         uint256 timestamp;
120         bool extended;
121     }
122 
123     // EVENTS
124     /// @dev  Emitted by successful `requestUnlock` calls.
125     event Requested(
126         bytes32 _lockId,
127         address _callbackAddress,
128         bytes4 _callbackSelector,
129         uint256 _nonce,
130         address _whitelistedAddress,
131         bytes32 _requestMsgHash,
132         uint256 _timeLockExpiry
133     );
134 
135     /// @dev  Emitted by `completeUnlock` calls on requests in the time-locked state.
136     event TimeLocked(
137         uint256 _timeLockExpiry,
138         bytes32 _requestMsgHash
139     );
140 
141     /// @dev  Emitted by successful `completeUnlock` calls.
142     event Completed(
143         bytes32 _lockId,
144         bytes32 _requestMsgHash,
145         address _signer1,
146         address _signer2
147     );
148 
149     /// @dev  Emitted by `completeUnlock` calls where the callback failed.
150     event Failed(
151         bytes32 _lockId,
152         bytes32 _requestMsgHash,
153         address _signer1,
154         address _signer2
155     );
156 
157     /// @dev  Emitted by successful `extendRequestTimeLock` calls.
158     event TimeLockExtended(
159         uint256 _timeLockExpiry,
160         bytes32 _requestMsgHash
161     );
162 
163      // MEMBERS
164     /** @dev  The count of all requests.
165       * This value is used as a nonce, incorporated into the request hash.
166       */
167     uint256 public requestCount;
168 
169     /// @dev  The set of signers: signatures from two signers unlock a pending request.
170     mapping (address => bool) public signerSet;
171 
172     /// @dev  The map of request hashes to pending requests.
173     mapping (bytes32 => Request) public requestMap;
174 
175     /// @dev  The map of callback addresses to callback selectors to request indexes.
176     mapping (address => mapping (bytes4 => uint256)) public lastCompletedIdxs;
177 
178     /** @dev  The default period (in seconds) to time-lock requests.
179       * All requests will be subject to this default time lock, and the duration
180       * is fixed at contract creation.
181       */
182     uint256 public defaultTimeLock;
183 
184     /** @dev  The extended period (in seconds) to time-lock requests.
185       * Requests not from the primary account are subject to this time lock.
186       * The primary account may also elect to extend the time lock on requests
187       * that originally received the default.
188       */
189     uint256 public extendedTimeLock;
190 
191     /// @dev  The primary account is the privileged account for making requests.
192     address public primary;
193 
194     // CONSTRUCTOR
195     constructor(
196         address[] memory _signers,
197         uint256 _defaultTimeLock,
198         uint256 _extendedTimeLock,
199         address _primary
200     )
201         public
202     {
203         // check for at least two `_signers`
204         require(_signers.length >= 2, "at least two `_signers`");
205 
206          // validate time lock params
207         require(_defaultTimeLock <= _extendedTimeLock, "valid timelock params");
208         defaultTimeLock = _defaultTimeLock;
209         extendedTimeLock = _extendedTimeLock;
210 
211         primary = _primary;
212 
213         // explicitly initialize `requestCount` to zero
214         requestCount = 0;
215         // turn the array into a set
216         for (uint i = 0; i < _signers.length; i++) {
217             // no zero addresses or duplicates
218             require(_signers[i] != address(0) && !signerSet[_signers[i]], "no zero addresses or duplicates");
219             signerSet[_signers[i]] = true;
220         }
221     }
222 
223     // MODIFIERS
224     modifier onlyPrimary {
225         require(msg.sender == primary, "only primary");
226         _;
227     }
228 
229      modifier onlySigner {
230         require(signerSet[msg.sender], "only signer");
231         _;
232     }
233 
234     // METHODS
235     /** @notice  Requests an unlocking with a lock identifier and a callback.
236       *
237       * @dev  If called by an account other than the primary a 1 ETH stake
238       * must be paid. When the request is unlocked stake will be transferred to the message sender.
239       * This is an anti-spam measure. As well as the callback
240       * and the lock identifier parameters a 'whitelisted address' is required
241       * for compatibility with existing signature schemes.
242       *
243       * @param  _lockId  The identifier of a pending request in a co-operating contract.
244       * @param  _callbackAddress  The address of a co-operating contract.
245       * @param  _callbackSelector  The function selector of a function within
246       * the co-operating contract at address `_callbackAddress`.
247       * @param  _whitelistedAddress  An address whitelisted in existing
248       * offline control protocols.
249       *
250       * @return  requestMsgHash  The hash of a request message to be signed.
251     */
252     function requestUnlock(
253         bytes32 _lockId,
254         address _callbackAddress,
255         bytes4 _callbackSelector,
256         address _whitelistedAddress
257     )
258         public
259         payable
260         returns (bytes32 requestMsgHash)
261     {
262         require(msg.sender == primary || msg.value >= 1 ether, "sender is primary or stake is paid");
263 
264         // disallow using a zero value for the callback address
265         require(_callbackAddress != address(0), "no zero value for callback address");
266 
267         uint256 requestIdx = ++requestCount;
268         // compute a nonce value
269         // - the blockhash prevents prediction of future nonces
270         // - the address of this contract prevents conflicts with co-operating contracts using this scheme
271         // - the counter prevents conflicts arising from multiple txs within the same block
272         uint256 nonce = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), address(this), requestIdx)));
273 
274         requestMsgHash = keccak256(
275             abi.encodePacked(
276                 nonce,
277                 _whitelistedAddress,
278                 uint256(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
279             )
280         );
281         requestMap[requestMsgHash] = Request({
282             lockId: _lockId,
283             callbackSelector: _callbackSelector,
284             callbackAddress: _callbackAddress,
285             idx: requestIdx,
286             timestamp: block.timestamp,
287             extended: false
288         });
289 
290         // compute the expiry time
291         uint256 timeLockExpiry = block.timestamp;
292         if (msg.sender == primary) {
293             timeLockExpiry += defaultTimeLock;
294         } else {
295             timeLockExpiry += extendedTimeLock;
296 
297             // any sender that is not the creator will get the extended time lock
298             requestMap[requestMsgHash].extended = true;
299         }
300 
301         emit Requested(_lockId, _callbackAddress, _callbackSelector, nonce, _whitelistedAddress, requestMsgHash, timeLockExpiry);
302     }
303 
304     /** @notice  Completes a pending unlocking with two signatures.
305       *
306       * @dev  Given a request message hash as two signatures of it from
307       * two distinct signers in the signer set, this function completes the
308       * unlocking of the pending request by executing the callback.
309       *
310       * @param  _requestMsgHash  The request message hash of a pending request.
311       * @param  _recoveryByte1  The public key recovery byte (27 or 28)
312       * @param  _ecdsaR1  The R component of an ECDSA signature (R, S) pair
313       * @param  _ecdsaS1  The S component of an ECDSA signature (R, S) pair
314       * @param  _recoveryByte2  The public key recovery byte (27 or 28)
315       * @param  _ecdsaR2  The R component of an ECDSA signature (R, S) pair
316       * @param  _ecdsaS2  The S component of an ECDSA signature (R, S) pair
317       *
318       * @return  success  True if the callback successfully executed.
319     */
320     function completeUnlock(
321         bytes32 _requestMsgHash,
322         uint8 _recoveryByte1, bytes32 _ecdsaR1, bytes32 _ecdsaS1,
323         uint8 _recoveryByte2, bytes32 _ecdsaR2, bytes32 _ecdsaS2
324     )
325         public
326         onlySigner
327         returns (bool success)
328     {
329         Request storage request = requestMap[_requestMsgHash];
330 
331         // copy storage to locals before `delete`
332         bytes32 lockId = request.lockId;
333         address callbackAddress = request.callbackAddress;
334         bytes4 callbackSelector = request.callbackSelector;
335 
336         // failing case of the lookup if the callback address is zero
337         require(callbackAddress != address(0), "no zero value for callback address");
338 
339         // reject confirms of earlier withdrawals buried under later confirmed withdrawals
340         require(request.idx > lastCompletedIdxs[callbackAddress][callbackSelector],
341         "reject confirms of earlier withdrawals buried under later confirmed withdrawals");
342 
343         address signer1 = ecrecover(
344             keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _requestMsgHash)),
345             _recoveryByte1,
346             _ecdsaR1,
347             _ecdsaS1
348         );
349         require(signerSet[signer1], "signer is set");
350 
351         address signer2 = ecrecover(
352             keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _requestMsgHash)),
353             _recoveryByte2,
354             _ecdsaR2,
355             _ecdsaS2
356         );
357         require(signerSet[signer2], "signer is set");
358         require(signer1 != signer2, "signers are different");
359 
360         if (request.extended && ((block.timestamp - request.timestamp) < extendedTimeLock)) {
361             emit TimeLocked(request.timestamp + extendedTimeLock, _requestMsgHash);
362             return false;
363         } else if ((block.timestamp - request.timestamp) < defaultTimeLock) {
364             emit TimeLocked(request.timestamp + defaultTimeLock, _requestMsgHash);
365             return false;
366         } else {
367             if (address(this).balance > 0) {
368                 // reward sender with anti-spam payments
369                 msg.sender.transfer(address(this).balance);
370             }
371 
372             // raise the waterline for the last completed unlocking
373             lastCompletedIdxs[callbackAddress][callbackSelector] = request.idx;
374             // and delete the request
375             delete requestMap[_requestMsgHash];
376 
377             // invoke callback
378             (success,) = callbackAddress.call(abi.encodeWithSelector(callbackSelector, lockId));
379 
380             if (success) {
381                 emit Completed(lockId, _requestMsgHash, signer1, signer2);
382             } else {
383                 emit Failed(lockId, _requestMsgHash, signer1, signer2);
384             }
385         }
386     }
387 
388     /** @notice  Reclaim the storage of a pending request that is uncompletable.
389       *
390       * @dev  If a pending request shares the callback (address and selector) of
391       * a later request has been completed, then the request can no longer
392       * be completed. This function will reclaim the contract storage of the
393       * pending request.
394       *
395       * @param  _requestMsgHash  The request message hash of a pending request.
396     */
397     function deleteUncompletableRequest(bytes32 _requestMsgHash) public {
398         Request storage request = requestMap[_requestMsgHash];
399 
400         uint256 idx = request.idx;
401 
402         require(0 < idx && idx < lastCompletedIdxs[request.callbackAddress][request.callbackSelector],
403         "there must be a completed latter request with same callback");
404 
405         delete requestMap[_requestMsgHash];
406     }
407 
408     /** @notice  Extend the time lock of a pending request.
409       *
410       * @dev  Requests made by the primary account receive the default time lock.
411       * This function allows the primary account to apply the extended time lock
412       * to one its own requests.
413       *
414       * @param  _requestMsgHash  The request message hash of a pending request.
415     */
416     function extendRequestTimeLock(bytes32 _requestMsgHash) public onlyPrimary {
417         Request storage request = requestMap[_requestMsgHash];
418 
419         // reject ‘null’ results from the map lookup
420         // this can only be the case if an unknown `_requestMsgHash` is received
421         require(request.callbackAddress != address(0), "reject ‘null’ results from the map lookup");
422 
423         // `extendRequestTimeLock` must be idempotent
424         require(request.extended != true, "`extendRequestTimeLock` must be idempotent");
425 
426         // set the `extended` flag; note that this is never unset
427         request.extended = true;
428 
429         emit TimeLockExtended(request.timestamp + extendedTimeLock, _requestMsgHash);
430     }
431 }
432 
433 /** @title  A contract to inherit upgradeable custodianship.
434   *
435   * @notice  A contract that provides re-usable code for upgradeable
436   * custodianship. That custodian may be an account or another contract.
437   *
438   * @dev  This contract is intended to be inherited by any contract
439   * requiring a custodian to control some aspect of its functionality.
440   * This contract provides the mechanism for that custodianship to be
441   * passed from one custodian to the next.
442   *
443 */
444 contract CustodianUpgradeable is LockRequestable {
445 
446     // TYPES
447     /// @dev  The struct type for pending custodian changes.
448     struct CustodianChangeRequest {
449         address proposedNew;
450     }
451 
452     // MEMBERS
453     /// @dev  The address of the account or contract that acts as the custodian.
454     address public custodian;
455 
456     /// @dev  The map of lock ids to pending custodian changes.
457     mapping (bytes32 => CustodianChangeRequest) public custodianChangeReqs;
458 
459     // CONSTRUCTOR
460     constructor(
461         address _custodian
462     )
463       LockRequestable()
464       public
465     {
466         custodian = _custodian;
467     }
468 
469     // MODIFIERS
470     modifier onlyCustodian {
471         require(msg.sender == custodian, "only custodian");
472         _;
473     }
474 
475     // PUBLIC FUNCTIONS
476     // (UPGRADE)
477 
478     /** @notice  Requests a change of the custodian associated with this contract.
479       *
480       * @dev  Returns a unique lock id associated with the request.
481       * Anyone can call this function, but confirming the request is authorized
482       * by the custodian.
483       *
484       * @param  _proposedCustodian  The address of the new custodian.
485       * @return  lockId  A unique identifier for this request.
486       */
487     function requestCustodianChange(address _proposedCustodian) public returns (bytes32 lockId) {
488         require(_proposedCustodian != address(0), "no null value for `_proposedCustodian`");
489 
490         lockId = generateLockId();
491 
492         custodianChangeReqs[lockId] = CustodianChangeRequest({
493             proposedNew: _proposedCustodian
494         });
495 
496         emit CustodianChangeRequested(lockId, msg.sender, _proposedCustodian);
497     }
498 
499     /** @notice  Confirms a pending change of the custodian associated with this contract.
500       *
501       * @dev  When called by the current custodian with a lock id associated with a
502       * pending custodian change, the `address custodian` member will be updated with the
503       * requested address.
504       *
505       * @param  _lockId  The identifier of a pending change request.
506       */
507     function confirmCustodianChange(bytes32 _lockId) public onlyCustodian {
508         custodian = getCustodianChangeReq(_lockId);
509 
510         delete custodianChangeReqs[_lockId];
511 
512         emit CustodianChangeConfirmed(_lockId, custodian);
513     }
514 
515     // PRIVATE FUNCTIONS
516     function getCustodianChangeReq(bytes32 _lockId) private view returns (address _proposedNew) {
517         CustodianChangeRequest storage changeRequest = custodianChangeReqs[_lockId];
518 
519         // reject ‘null’ results from the map lookup
520         // this can only be the case if an unknown `_lockId` is received
521         require(changeRequest.proposedNew != address(0), "reject ‘null’ results from the map lookup");
522 
523         return changeRequest.proposedNew;
524     }
525 
526     //EVENTS
527     /// @dev  Emitted by successful `requestCustodianChange` calls.
528     event CustodianChangeRequested(
529         bytes32 _lockId,
530         address _msgSender,
531         address _proposedCustodian
532     );
533 
534     /// @dev Emitted by successful `confirmCustodianChange` calls.
535     event CustodianChangeConfirmed(bytes32 _lockId, address _newCustodian);
536 }
537 
538 /** @title  A contract to inherit upgradeable token implementations.
539   *
540   * @notice  A contract that provides re-usable code for upgradeable
541   * token implementations. It itself inherits from `CustodianUpgradable`
542   * as the upgrade process is controlled by the custodian.
543   *
544   * @dev  This contract is intended to be inherited by any contract
545   * requiring a reference to the active token implementation, either
546   * to delegate calls to it, or authorize calls from it. This contract
547   * provides the mechanism for that implementation to be replaced,
548   * which constitutes an implementation upgrade.
549   *
550   */
551 contract ERC20ImplUpgradeable is CustodianUpgradeable  {
552 
553     // TYPES
554     /// @dev  The struct type for pending implementation changes.
555     struct ImplChangeRequest {
556         address proposedNew;
557     }
558 
559     // MEMBERS
560     // @dev  The reference to the active token implementation.
561     ERC20Impl public erc20Impl;
562 
563     /// @dev  The map of lock ids to pending implementation changes.
564     mapping (bytes32 => ImplChangeRequest) public implChangeReqs;
565 
566     // CONSTRUCTOR
567     constructor(address _custodian) CustodianUpgradeable(_custodian) public {
568         erc20Impl = ERC20Impl(0x0);
569     }
570 
571     // MODIFIERS
572     modifier onlyImpl {
573         require(msg.sender == address(erc20Impl), "only ERC20Impl");
574         _;
575     }
576 
577     // PUBLIC FUNCTIONS
578     // (UPGRADE)
579     /** @notice  Requests a change of the active implementation associated
580       * with this contract.
581       *
582       * @dev  Returns a unique lock id associated with the request.
583       * Anyone can call this function, but confirming the request is authorized
584       * by the custodian.
585       *
586       * @param  _proposedImpl  The address of the new active implementation.
587       * @return  lockId  A unique identifier for this request.
588       */
589     function requestImplChange(address _proposedImpl) public returns (bytes32 lockId) {
590         require(_proposedImpl != address(0), "no null value for `_proposedImpl`");
591 
592         lockId = generateLockId();
593 
594         implChangeReqs[lockId] = ImplChangeRequest({
595             proposedNew: _proposedImpl
596         });
597 
598         emit ImplChangeRequested(lockId, msg.sender, _proposedImpl);
599     }
600 
601     /** @notice  Confirms a pending change of the active implementation
602       * associated with this contract.
603       *
604       * @dev  When called by the custodian with a lock id associated with a
605       * pending change, the `ERC20Impl erc20Impl` member will be updated
606       * with the requested address.
607       *
608       * @param  _lockId  The identifier of a pending change request.
609       */
610     function confirmImplChange(bytes32 _lockId) public onlyCustodian {
611         erc20Impl = getImplChangeReq(_lockId);
612 
613         delete implChangeReqs[_lockId];
614 
615         emit ImplChangeConfirmed(_lockId, address(erc20Impl));
616     }
617 
618     // PRIVATE FUNCTIONS
619     function getImplChangeReq(bytes32 _lockId) private view returns (ERC20Impl _proposedNew) {
620         ImplChangeRequest storage changeRequest = implChangeReqs[_lockId];
621 
622         // reject ‘null’ results from the map lookup
623         // this can only be the case if an unknown `_lockId` is received
624         require(changeRequest.proposedNew != address(0), "reject ‘null’ results from the map lookup");
625 
626         return ERC20Impl(changeRequest.proposedNew);
627     }
628 
629     //EVENTS
630     /// @dev  Emitted by successful `requestImplChange` calls.
631     event ImplChangeRequested(
632         bytes32 _lockId,
633         address _msgSender,
634         address _proposedImpl
635     );
636 
637     /// @dev Emitted by successful `confirmImplChange` calls.
638     event ImplChangeConfirmed(bytes32 _lockId, address _newImpl);
639 }
640 
641 /** @title  Public interface to ERC20 compliant token.
642   *
643   * @notice  This contract is a permanent entry point to an ERC20 compliant
644   * system of contracts.
645   *
646   * @dev  This contract contains no business logic and instead
647   * delegates to an instance of ERC20Impl. This contract also has no storage
648   * that constitutes the operational state of the token. This contract is
649   * upgradeable in the sense that the `custodian` can update the
650   * `erc20Impl` address, thus redirecting the delegation of business logic.
651   * The `custodian` is also authorized to pass custodianship.
652   *
653 */
654 contract ERC20Proxy is ERC20Interface, ERC20ImplUpgradeable {
655 
656     // MEMBERS
657     /// @notice  Returns the name of the token.
658     string public name;
659 
660     /// @notice  Returns the symbol of the token.
661     string public symbol;
662 
663     /// @notice  Returns the number of decimals the token uses.
664     uint8 public decimals;
665 
666     // CONSTRUCTOR
667     constructor(
668         string memory _name,
669         string memory _symbol,
670         uint8 _decimals,
671         address _custodian
672     )
673         ERC20ImplUpgradeable(_custodian)
674         public
675     {
676         name = _name;
677         symbol = _symbol;
678         decimals = _decimals;
679     }
680 
681     // PUBLIC FUNCTIONS
682     // (ERC20Interface)
683     /** @notice  Returns the total token supply.
684       *
685       * @return  the total token supply.
686       */
687     function totalSupply() public view returns (uint256) {
688         return erc20Impl.totalSupply();
689     }
690 
691     /** @notice  Returns the account balance of another account with an address
692       * `_owner`.
693       *
694       * @return  balance  the balance of account with address `_owner`.
695       */
696     function balanceOf(address _owner) public view returns (uint256 balance) {
697         return erc20Impl.balanceOf(_owner);
698     }
699 
700     /** @dev Internal use only.
701       */
702     function emitTransfer(address _from, address _to, uint256 _value) public onlyImpl {
703         emit Transfer(_from, _to, _value);
704     }
705 
706     /** @notice  Transfers `_value` amount of tokens to address `_to`.
707       *
708       * @dev Will fire the `Transfer` event. Will revert if the `_from`
709       * account balance does not have enough tokens to spend.
710       *
711       * @return  success  true if transfer completes.
712       */
713     function transfer(address _to, uint256 _value) public returns (bool success) {
714         return erc20Impl.transferWithSender(msg.sender, _to, _value);
715     }
716 
717     /** @notice  Transfers `_value` amount of tokens from address `_from`
718       * to address `_to`.
719       *
720       * @dev  Will fire the `Transfer` event. Will revert unless the `_from`
721       * account has deliberately authorized the sender of the message
722       * via some mechanism.
723       *
724       * @return  success  true if transfer completes.
725       */
726     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
727         return erc20Impl.transferFromWithSender(msg.sender, _from, _to, _value);
728     }
729 
730     /** @dev Internal use only.
731       */
732     function emitApproval(address _owner, address _spender, uint256 _value) public onlyImpl {
733         emit Approval(_owner, _spender, _value);
734     }
735 
736     /** @notice  Allows `_spender` to withdraw from your account multiple times,
737       * up to the `_value` amount. If this function is called again it
738       * overwrites the current allowance with _value.
739       *
740       * @dev  Will fire the `Approval` event.
741       *
742       * @return  success  true if approval completes.
743       */
744     function approve(address _spender, uint256 _value) public returns (bool success) {
745         return erc20Impl.approveWithSender(msg.sender, _spender, _value);
746     }
747 
748     /** @notice Increases the amount `_spender` is allowed to withdraw from
749       * your account.
750       * This function is implemented to avoid the race condition in standard
751       * ERC20 contracts surrounding the `approve` method.
752       *
753       * @dev  Will fire the `Approval` event. This function should be used instead of
754       * `approve`.
755       *
756       * @return  success  true if approval completes.
757       */
758     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
759         return erc20Impl.increaseApprovalWithSender(msg.sender, _spender, _addedValue);
760     }
761 
762     /** @notice  Decreases the amount `_spender` is allowed to withdraw from
763       * your account. This function is implemented to avoid the race
764       * condition in standard ERC20 contracts surrounding the `approve` method.
765       *
766       * @dev  Will fire the `Approval` event. This function should be used
767       * instead of `approve`.
768       *
769       * @return  success  true if approval completes.
770       */
771     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
772         return erc20Impl.decreaseApprovalWithSender(msg.sender, _spender, _subtractedValue);
773     }
774 
775     /** @notice  Returns how much `_spender` is currently allowed to spend from
776       * `_owner`'s balance.
777       *
778       * @return  remaining  the remaining allowance.
779       */
780     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
781         return erc20Impl.allowance(_owner, _spender);
782     }
783 }
784 
785 /** @title  ERC20 compliant token balance store.
786   *
787   * @notice  This contract serves as the store of balances, allowances, and
788   * supply for the ERC20 compliant token. No business logic exists here.
789   *
790   * @dev  This contract contains no business logic and instead
791   * is the final destination for any change in balances, allowances, or token
792   * supply. This contract is upgradeable in the sense that its custodian can
793   * update the `erc20Impl` address, thus redirecting the source of logic that
794   * determines how the balances will be updated.
795   *
796   */
797 contract ERC20Store is ERC20ImplUpgradeable {
798 
799     // MEMBERS
800     /// @dev  The total token supply.
801     uint256 public totalSupply;
802 
803     /// @dev  The mapping of balances.
804     mapping (address => uint256) public balances;
805 
806     /// @dev  The mapping of allowances.
807     mapping (address => mapping (address => uint256)) public allowed;
808 
809     // CONSTRUCTOR
810     constructor(address _custodian) ERC20ImplUpgradeable(_custodian) public {
811         totalSupply = 0;
812     }
813 
814     // PUBLIC FUNCTIONS
815     // (ERC20 Ledger)
816 
817     /** @notice  The function to set the total supply of tokens.
818       *
819       * @dev  Intended for use by token implementation functions
820       * that update the total supply. The only authorized caller
821       * is the active implementation.
822       *
823       * @param _newTotalSupply the value to set as the new total supply
824       */
825     function setTotalSupply(
826         uint256 _newTotalSupply
827     )
828         public
829         onlyImpl
830     {
831         totalSupply = _newTotalSupply;
832     }
833 
834     /** @notice  Sets how much `_owner` allows `_spender` to transfer on behalf
835       * of `_owner`.
836       *
837       * @dev  Intended for use by token implementation functions
838       * that update spending allowances. The only authorized caller
839       * is the active implementation.
840       *
841       * @param  _owner  The account that will allow an on-behalf-of spend.
842       * @param  _spender  The account that will spend on behalf of the owner.
843       * @param  _value  The limit of what can be spent.
844       */
845     function setAllowance(
846         address _owner,
847         address _spender,
848         uint256 _value
849     )
850         public
851         onlyImpl
852     {
853         allowed[_owner][_spender] = _value;
854     }
855 
856     /** @notice  Sets the balance of `_owner` to `_newBalance`.
857       *
858       * @dev  Intended for use by token implementation functions
859       * that update balances. The only authorized caller
860       * is the active implementation.
861       *
862       * @param  _owner  The account that will hold a new balance.
863       * @param  _newBalance  The balance to set.
864       */
865     function setBalance(
866         address _owner,
867         uint256 _newBalance
868     )
869         public
870         onlyImpl
871     {
872         balances[_owner] = _newBalance;
873     }
874 
875     /** @notice Adds `_balanceIncrease` to `_owner`'s balance.
876       *
877       * @dev  Intended for use by token implementation functions
878       * that update balances. The only authorized caller
879       * is the active implementation.
880       * WARNING: the caller is responsible for preventing overflow.
881       *
882       * @param  _owner  The account that will hold a new balance.
883       * @param  _balanceIncrease  The balance to add.
884       */
885     function addBalance(
886         address _owner,
887         uint256 _balanceIncrease
888     )
889         public
890         onlyImpl
891     {
892         balances[_owner] = balances[_owner] + _balanceIncrease;
893     }
894 }
895 
896 /** @title  ERC20 compliant token intermediary contract holding core logic.
897   *
898   * @notice  This contract serves as an intermediary between the exposed ERC20
899   * interface in ERC20Proxy and the store of balances in ERC20Store. This
900   * contract contains core logic that the proxy can delegate to
901   * and that the store is called by.
902   *
903   * @dev  This contract contains the core logic to implement the
904   * ERC20 specification as well as several extensions.
905   * 1. Changes to the token supply.
906   * 2. Batched transfers.
907   * 3. Relative changes to spending approvals.
908   * 4. Delegated transfer control ('sweeping').
909   *
910   */
911 contract ERC20Impl is CustodianUpgradeable {
912 
913     // TYPES
914     /// @dev  The struct type for pending increases to the token supply (print).
915     struct PendingPrint {
916         address receiver;
917         uint256 value;
918     }
919 
920     // MEMBERS
921     /// @dev  The reference to the proxy.
922     ERC20Proxy public erc20Proxy;
923 
924     /// @dev  The reference to the store.
925     ERC20Store public erc20Store;
926 
927     /// @dev  The sole authorized caller of delegated transfer control ('sweeping').
928     address public sweeper;
929 
930     /** @dev  The static message to be signed by an external account that
931       * signifies their permission to forward their balance to any arbitrary
932       * address. This is used to consolidate the control of all accounts
933       * backed by a shared keychain into the control of a single key.
934       * Initialized as the concatenation of the address of this contract
935       * and the word "sweep". This concatenation is done to prevent a replay
936       * attack in a subsequent contract, where the sweeping message could
937       * potentially be replayed to re-enable sweeping ability.
938       */
939     bytes32 public sweepMsg;
940 
941     /** @dev  The mapping that stores whether the address in question has
942       * enabled sweeping its contents to another account or not.
943       * If an address maps to "true", it has already enabled sweeping,
944       * and thus does not need to re-sign the `sweepMsg` to enact the sweep.
945       */
946     mapping (address => bool) public sweptSet;
947 
948     /// @dev  The map of lock ids to pending token increases.
949     mapping (bytes32 => PendingPrint) public pendingPrintMap;
950 
951     /// @dev The map of blocked addresses.
952     mapping (address => bool) public blocked;
953 
954     // CONSTRUCTOR
955     constructor(
956           address _erc20Proxy,
957           address _erc20Store,
958           address _custodian,
959           address _sweeper
960     )
961         CustodianUpgradeable(_custodian)
962         public
963     {
964         require(_sweeper != address(0), "no null value for `_sweeper`");
965         erc20Proxy = ERC20Proxy(_erc20Proxy);
966         erc20Store = ERC20Store(_erc20Store);
967 
968         sweeper = _sweeper;
969         sweepMsg = keccak256(abi.encodePacked(address(this), "sweep"));
970     }
971 
972     // MODIFIERS
973     modifier onlyProxy {
974         require(msg.sender == address(erc20Proxy), "only ERC20Proxy");
975         _;
976     }
977     modifier onlySweeper {
978         require(msg.sender == sweeper, "only sweeper");
979         _;
980     }
981 
982 
983     /** @notice  Core logic of the ERC20 `approve` function.
984       *
985       * @dev  This function can only be called by the referenced proxy,
986       * which has an `approve` function.
987       * Every argument passed to that function as well as the original
988       * `msg.sender` gets passed to this function.
989       * NOTE: approvals for the zero address (unspendable) are disallowed.
990       *
991       * @param  _sender  The address initiating the approval in a proxy.
992       */
993     function approveWithSender(
994         address _sender,
995         address _spender,
996         uint256 _value
997     )
998         public
999         onlyProxy
1000         returns (bool success)
1001     {
1002         require(_spender != address(0), "no null value for `_spender`");
1003         require(blocked[_sender] != true, "_sender must not be blocked");
1004         require(blocked[_spender] != true, "_spender must not be blocked");
1005         erc20Store.setAllowance(_sender, _spender, _value);
1006         erc20Proxy.emitApproval(_sender, _spender, _value);
1007         return true;
1008     }
1009 
1010     /** @notice  Core logic of the `increaseApproval` function.
1011       *
1012       * @dev  This function can only be called by the referenced proxy,
1013       * which has an `increaseApproval` function.
1014       * Every argument passed to that function as well as the original
1015       * `msg.sender` gets passed to this function.
1016       * NOTE: approvals for the zero address (unspendable) are disallowed.
1017       *
1018       * @param  _sender  The address initiating the approval.
1019       */
1020     function increaseApprovalWithSender(
1021         address _sender,
1022         address _spender,
1023         uint256 _addedValue
1024     )
1025         public
1026         onlyProxy
1027         returns (bool success)
1028     {
1029         require(_spender != address(0),"no null value for_spender");
1030         require(blocked[_sender] != true, "_sender must not be blocked");
1031         require(blocked[_spender] != true, "_spender must not be blocked");
1032         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
1033         uint256 newAllowance = currentAllowance + _addedValue;
1034 
1035         require(newAllowance >= currentAllowance, "new allowance must not be smaller than previous");
1036 
1037         erc20Store.setAllowance(_sender, _spender, newAllowance);
1038         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
1039         return true;
1040     }
1041 
1042     /** @notice  Core logic of the `decreaseApproval` function.
1043       *
1044       * @dev  This function can only be called by the referenced proxy,
1045       * which has a `decreaseApproval` function.
1046       * Every argument passed to that function as well as the original
1047       * `msg.sender` gets passed to this function.
1048       * NOTE: approvals for the zero address (unspendable) are disallowed.
1049       *
1050       * @param  _sender  The address initiating the approval.
1051       */
1052     function decreaseApprovalWithSender(
1053         address _sender,
1054         address _spender,
1055         uint256 _subtractedValue
1056     )
1057         public
1058         onlyProxy
1059         returns (bool success)
1060     {
1061         require(_spender != address(0), "no unspendable approvals"); // disallow unspendable approvals
1062         require(blocked[_sender] != true, "_sender must not be blocked");
1063         require(blocked[_spender] != true, "_spender must not be blocked");
1064         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
1065         uint256 newAllowance = currentAllowance - _subtractedValue;
1066 
1067         require(newAllowance <= currentAllowance, "new allowance must not be smaller than previous");
1068 
1069         erc20Store.setAllowance(_sender, _spender, newAllowance);
1070         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
1071         return true;
1072     }
1073 
1074     /** @notice  Requests an increase in the token supply, with the newly created
1075       * tokens to be added to the balance of the specified account.
1076       *
1077       * @dev  Returns a unique lock id associated with the request.
1078       * Anyone can call this function, but confirming the request is authorized
1079       * by the custodian.
1080       * NOTE: printing to the zero address is disallowed.
1081       *
1082       * @param  _receiver  The receiving address of the print, if confirmed.
1083       * @param  _value  The number of tokens to add to the total supply and the
1084       * balance of the receiving address, if confirmed.
1085       *
1086       * @return  lockId  A unique identifier for this request.
1087       */
1088     function requestPrint(address _receiver, uint256 _value) public returns (bytes32 lockId) {
1089         require(_receiver != address(0), "no null value for `_receiver`");
1090         require(blocked[msg.sender] != true, "account blocked");
1091         require(blocked[_receiver] != true, "_receiver must not be blocked");
1092         lockId = generateLockId();
1093 
1094         pendingPrintMap[lockId] = PendingPrint({
1095             receiver: _receiver,
1096             value: _value
1097         });
1098 
1099         emit PrintingLocked(lockId, _receiver, _value);
1100     }
1101 
1102     /** @notice  Confirms a pending increase in the token supply.
1103       *
1104       * @dev  When called by the custodian with a lock id associated with a
1105       * pending increase, the amount requested to be printed in the print request
1106       * is printed to the receiving address specified in that same request.
1107       * NOTE: this function will not execute any print that would overflow the
1108       * total supply, but it will not revert either.
1109       *
1110       * @param  _lockId  The identifier of a pending print request.
1111       */
1112     function confirmPrint(bytes32 _lockId) public onlyCustodian {
1113         PendingPrint storage print = pendingPrintMap[_lockId];
1114 
1115         // reject ‘null’ results from the map lookup
1116         // this can only be the case if an unknown `_lockId` is received
1117         address receiver = print.receiver;
1118         require (receiver != address(0), "unknown `_lockId`");
1119         uint256 value = print.value;
1120 
1121         delete pendingPrintMap[_lockId];
1122 
1123         uint256 supply = erc20Store.totalSupply();
1124         uint256 newSupply = supply + value;
1125         if (newSupply >= supply) {
1126           erc20Store.setTotalSupply(newSupply);
1127           erc20Store.addBalance(receiver, value);
1128 
1129           emit PrintingConfirmed(_lockId, receiver, value);
1130           erc20Proxy.emitTransfer(address(0), receiver, value);
1131         }
1132     }
1133 
1134     /** @notice  Burns the specified value from the sender's balance.
1135       *
1136       * @dev  Sender's balanced is subtracted by the amount they wish to burn.
1137       *
1138       * @param  _value  The amount to burn.
1139       *
1140       * @return success true if the burn succeeded.
1141       */
1142     function burn(uint256 _value) public returns (bool success) {
1143         require(blocked[msg.sender] != true, "account blocked");
1144         uint256 balanceOfSender = erc20Store.balances(msg.sender);
1145         require(_value <= balanceOfSender, "disallow burning more, than amount of the balance");
1146 
1147         erc20Store.setBalance(msg.sender, balanceOfSender - _value);
1148         erc20Store.setTotalSupply(erc20Store.totalSupply() - _value);
1149 
1150         erc20Proxy.emitTransfer(msg.sender, address(0), _value);
1151 
1152         return true;
1153     }
1154 
1155      /** @notice  Burns the specified value from the balance in question.
1156       *
1157       * @dev  Suspected balance is subtracted by the amount which will be burnt.
1158       *
1159       * @dev If the suspected balance has less than the amount requested, it will be set to 0.
1160       *
1161       * @param  _from  The address of suspected balance.
1162       *
1163       * @param  _value  The amount to burn.
1164       *
1165       * @return success true if the burn succeeded.
1166       */
1167     function burn(address _from, uint256 _value) public onlyCustodian returns (bool success) {
1168         uint256 balance = erc20Store.balances(_from);
1169         if(_value <= balance){
1170             erc20Store.setBalance(_from, balance - _value);
1171             erc20Store.setTotalSupply(erc20Store.totalSupply() - _value);
1172             erc20Proxy.emitTransfer(_from, address(0), _value);
1173             emit Wiped(_from, _value, _value, balance - _value);
1174         }
1175         else {
1176             erc20Store.setBalance(_from,0);
1177             erc20Store.setTotalSupply(erc20Store.totalSupply() - balance);
1178             erc20Proxy.emitTransfer(_from, address(0), balance);
1179             emit Wiped(_from, _value, balance, 0);
1180         }
1181         return true;
1182     }
1183 
1184     /** @notice  A function for a sender to issue multiple transfers to multiple
1185       * different addresses at once. This function is implemented for gas
1186       * considerations when someone wishes to transfer, as one transaction is
1187       * cheaper than issuing several distinct individual `transfer` transactions.
1188       *
1189       * @dev  By specifying a set of destination addresses and values, the
1190       * sender can issue one transaction to transfer multiple amounts to
1191       * distinct addresses, rather than issuing each as a separate
1192       * transaction. The `_tos` and `_values` arrays must be equal length, and
1193       * an index in one array corresponds to the same index in the other array
1194       * (e.g. `_tos[0]` will receive `_values[0]`, `_tos[1]` will receive
1195       * `_values[1]`, and so on.)
1196       * NOTE: transfers to the zero address are disallowed.
1197       *
1198       * @param  _tos  The destination addresses to receive the transfers.
1199       * @param  _values  The values for each destination address.
1200       * @return  success  If transfers succeeded.
1201       */
1202     function batchTransfer(address[] memory _tos, uint256[] memory _values) public returns (bool success) {
1203         require(_tos.length == _values.length, "_tos and _values must be the same length");
1204         require(blocked[msg.sender] != true, "account blocked");
1205         uint256 numTransfers = _tos.length;
1206         uint256 senderBalance = erc20Store.balances(msg.sender);
1207 
1208         for (uint256 i = 0; i < numTransfers; i++) {
1209           address to = _tos[i];
1210           require(to != address(0), "no null values for _tos");
1211           require(blocked[to] != true, "_tos must not be blocked");
1212           uint256 v = _values[i];
1213           require(senderBalance >= v, "insufficient funds");
1214 
1215           if (msg.sender != to) {
1216             senderBalance -= v;
1217             erc20Store.addBalance(to, v);
1218           }
1219           erc20Proxy.emitTransfer(msg.sender, to, v);
1220         }
1221 
1222         erc20Store.setBalance(msg.sender, senderBalance);
1223 
1224         return true;
1225     }
1226 
1227     /** @notice  Enables the delegation of transfer control for many
1228       * accounts to the sweeper account, transferring any balances
1229       * as well to the given destination.
1230       *
1231       * @dev  An account delegates transfer control by signing the
1232       * value of `sweepMsg`. The sweeper account is the only authorized
1233       * caller of this function, so it must relay signatures on behalf
1234       * of accounts that delegate transfer control to it. Enabling
1235       * delegation is idempotent and permanent. If the account has a
1236       * balance at the time of enabling delegation, its balance is
1237       * also transferred to the given destination account `_to`.
1238       * NOTE: transfers to the zero address are disallowed.
1239       *
1240       * @param  _vs  The array of recovery byte components of the ECDSA signatures.
1241       * @param  _rs  The array of 'R' components of the ECDSA signatures.
1242       * @param  _ss  The array of 'S' components of the ECDSA signatures.
1243       * @param  _to  The destination for swept balances.
1244       */
1245     function enableSweep(uint8[] memory _vs, bytes32[] memory _rs, bytes32[] memory _ss, address _to) public onlySweeper {
1246         require(_to != address(0), "no null value for `_to`");
1247         require(blocked[_to] != true, "_to must not be blocked");
1248         require((_vs.length == _rs.length) && (_vs.length == _ss.length), "_vs[], _rs[], _ss lengths are different");
1249 
1250         uint256 numSignatures = _vs.length;
1251         uint256 sweptBalance = 0;
1252 
1253         for (uint256 i = 0; i < numSignatures; ++i) {
1254             address from = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32",sweepMsg)), _vs[i], _rs[i], _ss[i]);
1255             require(blocked[from] != true, "_froms must not be blocked");
1256             // ecrecover returns 0 on malformed input
1257             if (from != address(0)) {
1258                 sweptSet[from] = true;
1259 
1260                 uint256 fromBalance = erc20Store.balances(from);
1261 
1262                 if (fromBalance > 0) {
1263                     sweptBalance += fromBalance;
1264 
1265                     erc20Store.setBalance(from, 0);
1266 
1267                     erc20Proxy.emitTransfer(from, _to, fromBalance);
1268                 }
1269             }
1270         }
1271 
1272         if (sweptBalance > 0) {
1273           erc20Store.addBalance(_to, sweptBalance);
1274         }
1275     }
1276 
1277     /** @notice  For accounts that have delegated, transfer control
1278       * to the sweeper, this function transfers their balances to the given
1279       * destination.
1280       *
1281       * @dev The sweeper account is the only authorized caller of
1282       * this function. This function accepts an array of addresses to have their
1283       * balances transferred for gas efficiency purposes.
1284       * NOTE: any address for an account that has not been previously enabled
1285       * will be ignored.
1286       * NOTE: transfers to the zero address are disallowed.
1287       *
1288       * @param  _froms  The addresses to have their balances swept.
1289       * @param  _to  The destination address of all these transfers.
1290       */
1291     function replaySweep(address[] memory _froms, address _to) public onlySweeper {
1292         require(_to != address(0), "no null value for `_to`");
1293         require(blocked[_to] != true, "_to must not be blocked");
1294         uint256 lenFroms = _froms.length;
1295         uint256 sweptBalance = 0;
1296 
1297         for (uint256 i = 0; i < lenFroms; ++i) {
1298             address from = _froms[i];
1299             require(blocked[from] != true, "_froms must not be blocked");
1300             if (sweptSet[from]) {
1301                 uint256 fromBalance = erc20Store.balances(from);
1302 
1303                 if (fromBalance > 0) {
1304                     sweptBalance += fromBalance;
1305 
1306                     erc20Store.setBalance(from, 0);
1307 
1308                     erc20Proxy.emitTransfer(from, _to, fromBalance);
1309                 }
1310             }
1311         }
1312 
1313         if (sweptBalance > 0) {
1314             erc20Store.addBalance(_to, sweptBalance);
1315         }
1316     }
1317 
1318     /** @notice  Core logic of the ERC20 `transferFrom` function.
1319       *
1320       * @dev  This function can only be called by the referenced proxy,
1321       * which has a `transferFrom` function.
1322       * Every argument passed to that function as well as the original
1323       * `msg.sender` gets passed to this function.
1324       * NOTE: transfers to the zero address are disallowed.
1325       *
1326       * @param  _sender  The address initiating the transfer in a proxy.
1327       */
1328     function transferFromWithSender(
1329         address _sender,
1330         address _from,
1331         address _to,
1332         uint256 _value
1333     )
1334         public
1335         onlyProxy
1336         returns (bool success)
1337     {
1338         require(_to != address(0), "no null values for `_to`");
1339         require(blocked[_sender] != true, "_sender must not be blocked");
1340         require(blocked[_from] != true, "_from must not be blocked");
1341         require(blocked[_to] != true, "_to must not be blocked");
1342 
1343         uint256 balanceOfFrom = erc20Store.balances(_from);
1344         require(_value <= balanceOfFrom, "insufficient funds on `_from` balance");
1345 
1346         uint256 senderAllowance = erc20Store.allowed(_from, _sender);
1347         require(_value <= senderAllowance, "insufficient allowance amount");
1348 
1349         erc20Store.setBalance(_from, balanceOfFrom - _value);
1350         erc20Store.addBalance(_to, _value);
1351 
1352         erc20Store.setAllowance(_from, _sender, senderAllowance - _value);
1353 
1354         erc20Proxy.emitTransfer(_from, _to, _value);
1355 
1356         return true;
1357     }
1358 
1359     /** @notice  Core logic of the ERC20 `transfer` function.
1360       *
1361       * @dev  This function can only be called by the referenced proxy,
1362       * which has a `transfer` function.
1363       * Every argument passed to that function as well as the original
1364       * `msg.sender` gets passed to this function.
1365       * NOTE: transfers to the zero address are disallowed.
1366       *
1367       * @param  _sender  The address initiating the transfer in a proxy.
1368       */
1369     function transferWithSender(
1370         address _sender,
1371         address _to,
1372         uint256 _value
1373     )
1374         public
1375         onlyProxy
1376         returns (bool success)
1377     {
1378         require(_to != address(0), "no null value for `_to`");
1379         require(blocked[_sender] != true, "_sender must not be blocked");
1380         require(blocked[_to] != true, "_to must not be blocked");
1381 
1382         uint256 balanceOfSender = erc20Store.balances(_sender);
1383         require(_value <= balanceOfSender, "insufficient funds");
1384 
1385         erc20Store.setBalance(_sender, balanceOfSender - _value);
1386         erc20Store.addBalance(_to, _value);
1387 
1388         erc20Proxy.emitTransfer(_sender, _to, _value);
1389 
1390         return true;
1391     }
1392 
1393     /** @notice  Transfers the specified value from the balance in question.
1394       *
1395       * @dev  Suspected balance is subtracted by the amount which will be transferred.
1396       *
1397       * @dev If the suspected balance has less than the amount requested, it will be set to 0.
1398       *
1399       * @param  _from  The address of suspected balance.
1400       *
1401       * @param  _value  The amount to transfer.
1402       *
1403       * @return success true if the transfer succeeded.
1404       */
1405     function forceTransfer(
1406         address _from,
1407         address _to,
1408         uint256 _value
1409     )
1410         public
1411         onlyCustodian
1412         returns (bool success)
1413     {
1414         require(_to != address(0), "no null value for `_to`");
1415         uint256 balanceOfSender = erc20Store.balances(_from);
1416         if(_value <= balanceOfSender) {
1417             erc20Store.setBalance(_from, balanceOfSender - _value);
1418             erc20Store.addBalance(_to, _value);
1419 
1420             erc20Proxy.emitTransfer(_from, _to, _value);
1421         } else {
1422             erc20Store.setBalance(_from, 0);
1423             erc20Store.addBalance(_to, balanceOfSender);
1424 
1425             erc20Proxy.emitTransfer(_from, _to, balanceOfSender);
1426         }
1427 
1428         return true;
1429     }
1430 
1431     // METHODS (ERC20 sub interface impl.)
1432     /// @notice  Core logic of the ERC20 `totalSupply` function.
1433     function totalSupply() public view returns (uint256) {
1434         return erc20Store.totalSupply();
1435     }
1436 
1437     /// @notice  Core logic of the ERC20 `balanceOf` function.
1438     function balanceOf(address _owner) public view returns (uint256 balance) {
1439         return erc20Store.balances(_owner);
1440     }
1441 
1442     /// @notice  Core logic of the ERC20 `allowance` function.
1443     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
1444         return erc20Store.allowed(_owner, _spender);
1445     }
1446 
1447     /// @dev internal use only.
1448     function blockWallet(address wallet) public onlyCustodian returns (bool success) {
1449         blocked[wallet] = true;
1450         return true;
1451     }
1452 
1453     /// @dev internal use only.
1454     function unblockWallet(address wallet) public onlyCustodian returns (bool success) {
1455         blocked[wallet] = false;
1456         return true;
1457     }
1458 
1459     // EVENTS
1460     /// @dev  Emitted by successful `requestPrint` calls.
1461     event PrintingLocked(bytes32 _lockId, address _receiver, uint256 _value);
1462 
1463     /// @dev Emitted by successful `confirmPrint` calls.
1464     event PrintingConfirmed(bytes32 _lockId, address _receiver, uint256 _value);
1465 
1466     /** @dev Emitted by successful `confirmWipe` calls.
1467       *
1468       * @param _value Amount requested to be burned.
1469       *
1470       * @param _burned Amount which was burned.
1471       *
1472       * @param _balance Amount left on account after burn.
1473       *
1474       * @param _from Account which balance was burned.
1475       */
1476      event Wiped(address _from, uint256 _value, uint256 _burned, uint _balance);
1477 }
1478 
1479 /** @title  A contact to govern hybrid control over increases to the token supply and managing accounts.
1480   *
1481   * @notice  A contract that acts as a custodian of the active token
1482   * implementation, and an intermediary between it and the ‘true’ custodian.
1483   * It preserves the functionality of direct custodianship as well as granting
1484   * limited control of token supply increases to an additional key.
1485   *
1486   * @dev  This contract is a layer of indirection between an instance of
1487   * ERC20Impl and a custodian. The functionality of the custodianship over
1488   * the token implementation is preserved (printing and custodian changes),
1489   * but this contract adds the ability for an additional key
1490   * (the 'controller') to increase the token supply up to a ceiling,
1491   * and this supply ceiling can only be raised by the custodian.
1492   *
1493   */
1494 contract Controller is LockRequestable {
1495 
1496     // TYPES
1497     /// @dev The struct type for pending ceiling raises.
1498     struct PendingCeilingRaise {
1499         uint256 raiseBy;
1500     }
1501 
1502     /// @dev The struct type for pending wipes.
1503     struct wipeAddress {
1504         uint256 value;
1505         address from;
1506     }
1507 
1508     /// @dev The struct type for pending force transfer requests.
1509     struct forceTransferRequest {
1510         uint256 value;
1511         address from;
1512         address to;
1513     }
1514 
1515     // MEMBERS
1516     /// @dev  The reference to the active token implementation.
1517     ERC20Impl public erc20Impl;
1518 
1519     /// @dev  The address of the account or contract that acts as the custodian.
1520     Custodian public custodian;
1521 
1522     /** @dev  The sole authorized caller of limited printing.
1523       * This account is also authorized to lower the supply ceiling and
1524       * wiping suspected accounts or force transferring funds from them.
1525       */
1526     address public controller;
1527 
1528     /** @dev  The maximum that the token supply can be increased to
1529       * through the use of the limited printing feature.
1530       * The difference between the current total supply and the supply
1531       * ceiling is what is available to the 'controller' account.
1532       * The value of the ceiling can only be increased by the custodian.
1533       */
1534     uint256 public totalSupplyCeiling;
1535 
1536     /// @dev  The map of lock ids to pending ceiling raises.
1537     mapping (bytes32 => PendingCeilingRaise) public pendingRaiseMap;
1538 
1539     /// @dev  The map of lock ids to pending wipes.
1540     mapping (bytes32 => wipeAddress[]) public pendingWipeMap;
1541 
1542     /// @dev  The map of lock ids to pending force transfer requests.
1543     mapping (bytes32 => forceTransferRequest) public pendingForceTransferRequestMap;
1544 
1545     // CONSTRUCTOR
1546     constructor(
1547         address _erc20Impl,
1548         address _custodian,
1549         address _controller,
1550         uint256 _initialCeiling
1551     )
1552         public
1553     {
1554         erc20Impl = ERC20Impl(_erc20Impl);
1555         custodian = Custodian(_custodian);
1556         controller = _controller;
1557         totalSupplyCeiling = _initialCeiling;
1558     }
1559 
1560     // MODIFIERS
1561     modifier onlyCustodian {
1562         require(msg.sender == address(custodian), "only custodian");
1563         _;
1564     }
1565     modifier onlyController {
1566         require(msg.sender == controller, "only controller");
1567         _;
1568     }
1569 
1570     modifier onlySigner {
1571         require(custodian.signerSet(msg.sender) == true, "only signer");
1572         _;
1573     }
1574 
1575     /** @notice  Increases the token supply, with the newly created tokens
1576       * being added to the balance of the specified account.
1577       *
1578       * @dev  The function checks that the value to print does not
1579       * exceed the supply ceiling when added to the current total supply.
1580       * NOTE: printing to the zero address is disallowed.
1581       *
1582       * @param  _receiver  The receiving address of the print.
1583       * @param  _value  The number of tokens to add to the total supply and the
1584       * balance of the receiving address.
1585       */
1586     function limitedPrint(address _receiver, uint256 _value) public onlyController {
1587         uint256 totalSupply = erc20Impl.totalSupply();
1588         uint256 newTotalSupply = totalSupply + _value;
1589 
1590         require(newTotalSupply >= totalSupply, "new total supply overflow");
1591         require(newTotalSupply <= totalSupplyCeiling, "total supply ceiling overflow");
1592         erc20Impl.confirmPrint(erc20Impl.requestPrint(_receiver, _value));
1593     }
1594 
1595     /** @notice  Requests wipe of suspected accounts.
1596       *
1597       * @dev  Returns a unique lock id associated with the request.
1598       * Only controller can call this function, and only the custodian
1599       * can confirm the request.
1600       *
1601       * @param  _froms  The array of suspected accounts.
1602       *
1603       * @param  _values  array of amounts by which suspected accounts will be wiped.
1604       *
1605       * @return  lockId  A unique identifier for this request.
1606       */
1607     function requestWipe(address[] memory _froms, uint256[] memory _values) public onlyController returns (bytes32 lockId) {
1608         require(_froms.length == _values.length, "_froms[] and _values[] must be same length");
1609         lockId = generateLockId();
1610         uint256 amount = _froms.length;
1611 
1612         for(uint256 i = 0; i < amount; i++) {
1613             address from = _froms[i];
1614             uint256 value = _values[i];
1615             pendingWipeMap[lockId].push(wipeAddress(value, from));
1616         }
1617 
1618         emit WipeRequested(lockId);
1619 
1620         return lockId;
1621     }
1622 
1623     /** @notice  Confirms a pending wipe of suspected accounts.
1624       *
1625       * @dev  When called by the custodian with a lock id associated with a
1626       * pending wipe, the amount requested is burned from the suspected accounts.
1627       *
1628       * @param  _lockId  The identifier of a pending wipe request.
1629       */
1630     function confirmWipe(bytes32 _lockId) public onlyCustodian {
1631         uint256 amount = pendingWipeMap[_lockId].length;
1632         for(uint256 i = 0; i < amount; i++) {
1633             wipeAddress memory addr = pendingWipeMap[_lockId][i];
1634             address from = addr.from;
1635             uint256 value = addr.value;
1636             erc20Impl.burn(from, value);
1637         }
1638 
1639         delete pendingWipeMap[_lockId];
1640 
1641         emit WipeCompleted(_lockId);
1642     }
1643 
1644     /** @notice  Requests force transfer from the suspected account.
1645       *
1646       * @dev  Returns a unique lock id associated with the request.
1647       * Only controller can call this function, and only the custodian
1648       * can confirm the request.
1649       *
1650       * @param  _from  address of suspected account.
1651       *
1652       * @param  _to  address of reciever.
1653       *
1654       * @param  _value  amount which will be transferred.
1655       *
1656       * @return  lockId  A unique identifier for this request.
1657       */
1658     function requestForceTransfer(address _from, address _to, uint256 _value) public onlyController returns (bytes32 lockId) {
1659         lockId = generateLockId();
1660         require (_value != 0, "no zero value transfers");
1661         pendingForceTransferRequestMap[lockId] = forceTransferRequest(_value, _from, _to);
1662 
1663         emit ForceTransferRequested(lockId, _from, _to, _value);
1664 
1665         return lockId;
1666     }
1667 
1668     /** @notice  Confirms a pending force transfer request.
1669       *
1670       * @dev  When called by the custodian with a lock id associated with a
1671       * pending transfer request, the amount requested is transferred from the suspected account.
1672       *
1673       * @param  _lockId  The identifier of a pending transfer request.
1674       */
1675     function confirmForceTransfer(bytes32 _lockId) public onlyCustodian {
1676         address from = pendingForceTransferRequestMap[_lockId].from;
1677         address to = pendingForceTransferRequestMap[_lockId].to;
1678         uint256 value = pendingForceTransferRequestMap[_lockId].value;
1679 
1680         delete pendingForceTransferRequestMap[_lockId];
1681 
1682         erc20Impl.forceTransfer(from, to, value);
1683 
1684         emit ForceTransferCompleted(_lockId, from, to, value);
1685     }
1686 
1687     /** @notice  Requests an increase to the supply ceiling.
1688       *
1689       * @dev  Returns a unique lock id associated with the request.
1690       * Anyone can call this function, but confirming the request is authorized
1691       * by the custodian.
1692       *
1693       * @param  _raiseBy  The amount by which to raise the ceiling.
1694       *
1695       * @return  lockId  A unique identifier for this request.
1696       */
1697     function requestCeilingRaise(uint256 _raiseBy) public returns (bytes32 lockId) {
1698         require(_raiseBy != 0, "no zero ceiling raise");
1699 
1700         lockId = generateLockId();
1701 
1702         pendingRaiseMap[lockId] = PendingCeilingRaise({
1703             raiseBy: _raiseBy
1704         });
1705 
1706         emit CeilingRaiseLocked(lockId, _raiseBy);
1707     }
1708 
1709     /** @notice  Confirms a pending increase in the token supply.
1710       *
1711       * @dev  When called by the custodian with a lock id associated with a
1712       * pending ceiling increase, the amount requested is added to the
1713       * current supply ceiling.
1714       * NOTE: this function will not execute any raise that would overflow the
1715       * supply ceiling, but it will not revert either.
1716       *
1717       * @param  _lockId  The identifier of a pending ceiling raise request.
1718       */
1719     function confirmCeilingRaise(bytes32 _lockId) public onlyCustodian {
1720         PendingCeilingRaise storage pendingRaise = pendingRaiseMap[_lockId];
1721 
1722         // copy locals of references to struct members
1723         uint256 raiseBy = pendingRaise.raiseBy;
1724         // accounts for a gibberish _lockId
1725         require(raiseBy != 0, "no gibberish _lockId");
1726 
1727         delete pendingRaiseMap[_lockId];
1728 
1729         uint256 newCeiling = totalSupplyCeiling + raiseBy;
1730         // overflow check
1731         if (newCeiling >= totalSupplyCeiling) {
1732             totalSupplyCeiling = newCeiling;
1733 
1734             emit CeilingRaiseConfirmed(_lockId, raiseBy, newCeiling);
1735         }
1736     }
1737 
1738     /** @notice  Lowers the supply ceiling, further constraining the bound of
1739       * what can be printed by the controller.
1740       *
1741       * @dev  The controller is the sole authorized caller of this function,
1742       * so it is the only account that can elect to lower its limit to increase
1743       * the token supply.
1744       *
1745       * @param  _lowerBy  The amount by which to lower the supply ceiling.
1746       */
1747     function lowerCeiling(uint256 _lowerBy) public onlyController {
1748         uint256 newCeiling = totalSupplyCeiling - _lowerBy;
1749         // overflow check
1750         require(newCeiling <= totalSupplyCeiling, "totalSupplyCeiling overflow");
1751         totalSupplyCeiling = newCeiling;
1752 
1753         emit CeilingLowered(_lowerBy, newCeiling);
1754     }
1755 
1756     /** @notice  Pass-through control of print confirmation, allowing this
1757       * contract's custodian to act as the custodian of the associated
1758       * active token implementation.
1759       *
1760       * @dev  This contract is the direct custodian of the active token
1761       * implementation, but this function allows this contract's custodian
1762       * to act as though it were the direct custodian of the active
1763       * token implementation. Therefore the custodian retains control of
1764       * unlimited printing.
1765       *
1766       * @param  _lockId  The identifier of a pending print request in
1767       * the associated active token implementation.
1768       */
1769     function confirmPrintProxy(bytes32 _lockId) public onlyCustodian {
1770         erc20Impl.confirmPrint(_lockId);
1771     }
1772 
1773     /** @notice  Pass-through control of custodian change confirmation,
1774       * allowing this contract's custodian to act as the custodian of
1775       * the associated active token implementation.
1776       *
1777       * @dev  This contract is the direct custodian of the active token
1778       * implementation, but this function allows this contract's custodian
1779       * to act as though it were the direct custodian of the active
1780       * token implementation. Therefore the custodian retains control of
1781       * custodian changes.
1782       *
1783       * @param  _lockId  The identifier of a pending custodian change request
1784       * in the associated active token implementation.
1785       */
1786     function confirmCustodianChangeProxy(bytes32 _lockId) public onlyCustodian {
1787         erc20Impl.confirmCustodianChange(_lockId);
1788     }
1789 
1790     /** @notice  Blocks all transactions with a wallet.
1791       *
1792       * @dev Only signers from custodian are authorized to call this function
1793       *
1794       * @param  wallet account which will be blocked.
1795       */
1796     function blockWallet(address wallet) public onlySigner {
1797         erc20Impl.blockWallet(wallet);
1798         emit Blocked(wallet);
1799     }
1800 
1801     /** @notice Unblocks all transactions with a wallet.
1802       *
1803       * @dev Only signers from custodian are authorized to call this function
1804       *
1805       * @param  wallet account which will be unblocked.
1806       */
1807     function unblockWallet(address wallet) public onlySigner {
1808         erc20Impl.unblockWallet(wallet);
1809         emit Unblocked(wallet);
1810     }
1811 
1812     // EVENTS
1813     /// @dev  Emitted by successful `requestCeilingRaise` calls.
1814     event CeilingRaiseLocked(bytes32 _lockId, uint256 _raiseBy);
1815 
1816     /// @dev  Emitted by successful `confirmCeilingRaise` calls.
1817     event CeilingRaiseConfirmed(bytes32 _lockId, uint256 _raiseBy, uint256 _newCeiling);
1818 
1819     /// @dev  Emitted by successful `lowerCeiling` calls.
1820     event CeilingLowered(uint256 _lowerBy, uint256 _newCeiling);
1821 
1822     /// @dev  Emitted by successful `blockWallet` calls.
1823     event Blocked(address _wallet);
1824 
1825     /// @dev  Emitted by successful `unblockWallet` calls.
1826     event Unblocked(address _wallet);
1827 
1828      /// @dev  Emitted by successful `requestForceTransfer` calls.
1829     event ForceTransferRequested(bytes32 _lockId, address _from, address _to, uint256 _value);
1830 
1831     /// @dev  Emitted by successful `confirmForceTransfer` calls.
1832     event ForceTransferCompleted(bytes32 _lockId, address _from, address _to, uint256 _value);
1833 
1834     /// @dev  Emitted by successful `requestWipe` calls.
1835     event WipeRequested(bytes32 _lockId);
1836 
1837     /// @dev  Emitted by successful `confirmWipe` calls.
1838     event WipeCompleted(bytes32 _lockId);
1839 }