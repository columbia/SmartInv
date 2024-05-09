1 pragma solidity ^0.4.21;
2 
3 /** @title  A contract for generating unique identifiers
4   *
5   * @notice  A contract that provides a identifier generation scheme,
6   * guaranteeing uniqueness across all contracts that inherit from it,
7   * as well as unpredictability of future identifiers.
8   *
9   * @dev  This contract is intended to be inherited by any contract that
10   * implements the callback software pattern for cooperative custodianship.
11   *
12   * @author  Gemini Trust Company, LLC
13   */
14 contract LockRequestable {
15 
16     // MEMBERS
17     /// @notice  the count of all invocations of `generateLockId`.
18     uint256 public lockRequestCount;
19 
20     // CONSTRUCTOR
21     function LockRequestable() public {
22         lockRequestCount = 0;
23     }
24 
25     // FUNCTIONS
26     /** @notice  Returns a fresh unique identifier.
27       *
28       * @dev the generation scheme uses three components.
29       * First, the blockhash of the previous block.
30       * Second, the deployed address.
31       * Third, the next value of the counter.
32       * This ensure that identifiers are unique across all contracts
33       * following this scheme, and that future identifiers are
34       * unpredictable.
35       *
36       * @return a 32-byte unique identifier.
37       */
38     function generateLockId() internal returns (bytes32 lockId) {
39         return keccak256(block.blockhash(block.number - 1), address(this), ++lockRequestCount);
40     }
41 }
42 
43 
44 /** @title  A contract to inherit upgradeable custodianship.
45   *
46   * @notice  A contract that provides re-usable code for upgradeable
47   * custodianship. That custodian may be an account or another contract.
48   *
49   * @dev  This contract is intended to be inherited by any contract
50   * requiring a custodian to control some aspect of its functionality.
51   * This contract provides the mechanism for that custodianship to be
52   * passed from one custodian to the next.
53   *
54   * @author  Gemini Trust Company, LLC
55   */
56 contract CustodianUpgradeable is LockRequestable {
57 
58     // TYPES
59     /// @dev  The struct type for pending custodian changes.
60     struct CustodianChangeRequest {
61         address proposedNew;
62     }
63 
64     // MEMBERS
65     /// @dev  The address of the account or contract that acts as the custodian.
66     address public custodian;
67 
68     /// @dev  The map of lock ids to pending custodian changes.
69     mapping (bytes32 => CustodianChangeRequest) public custodianChangeReqs;
70 
71     // CONSTRUCTOR
72     function CustodianUpgradeable(address _custodian)LockRequestable()
73       public
74     {
75         custodian = _custodian;
76     }
77 
78     // MODIFIERS
79     modifier onlyCustodian {
80         require(msg.sender == custodian);
81         _;
82     }
83 
84     // PUBLIC FUNCTIONS
85     // (UPGRADE)
86 
87     /** @notice  Requests a change of the custodian associated with this contract.
88       *
89       * @dev  Returns a unique lock id associated with the request.
90       * Anyone can call this function, but confirming the request is authorized
91       * by the custodian.
92       *
93       * @param  _proposedCustodian  The address of the new custodian.
94       * @return  lockId  A unique identifier for this request.
95       */
96     function requestCustodianChange(address _proposedCustodian) public returns (bytes32 lockId) {
97         require(_proposedCustodian != address(0));
98 
99         lockId = generateLockId();
100 
101         custodianChangeReqs[lockId] = CustodianChangeRequest({
102             proposedNew: _proposedCustodian
103         });
104 
105         emit CustodianChangeRequested(lockId, msg.sender, _proposedCustodian);
106     }
107 
108     /** @notice  Confirms a pending change of the custodian associated with this contract.
109       *
110       * @dev  When called by the current custodian with a lock id associated with a
111       * pending custodian change, the `address custodian` member will be updated with the
112       * requested address.
113       *
114       * @param  _lockId  The identifier of a pending change request.
115       */
116     function confirmCustodianChange(bytes32 _lockId) public onlyCustodian {
117         custodian = getCustodianChangeReq(_lockId);
118 
119         delete custodianChangeReqs[_lockId];
120 
121         emit CustodianChangeConfirmed(_lockId, custodian);
122     }
123 
124     // PRIVATE FUNCTIONS
125     function getCustodianChangeReq(bytes32 _lockId) private view returns (address _proposedNew) {
126         CustodianChangeRequest storage changeRequest = custodianChangeReqs[_lockId];
127 
128         // reject ‘null’ results from the map lookup
129         // this can only be the case if an unknown `_lockId` is received
130         require(changeRequest.proposedNew != 0);
131 
132         return changeRequest.proposedNew;
133     }
134 
135     /// @dev  Emitted by successful `requestCustodianChange` calls.
136     event CustodianChangeRequested(
137         bytes32 _lockId,
138         address _msgSender,
139         address _proposedCustodian
140     );
141 
142     /// @dev Emitted by successful `confirmCustodianChange` calls.
143     event CustodianChangeConfirmed(bytes32 _lockId, address _newCustodian);
144 }
145 
146 
147 /** @title  A contract to inherit upgradeable token implementations.
148   *
149   * @notice  A contract that provides re-usable code for upgradeable
150   * token implementations. It itself inherits from `CustodianUpgradable`
151   * as the upgrade process is controlled by the custodian.
152   *
153   * @dev  This contract is intended to be inherited by any contract
154   * requiring a reference to the active token implementation, either
155   * to delegate calls to it, or authorize calls from it. This contract
156   * provides the mechanism for that implementation to be be replaced,
157   * which constitutes an implementation upgrade.
158   *
159   * @author Gemini Trust Company, LLC
160   */
161 contract ERC20ImplUpgradeable is CustodianUpgradeable  {
162 
163     // TYPES
164     /// @dev  The struct type for pending implementation changes.
165     struct ImplChangeRequest {
166         address proposedNew;
167     }
168 
169     // MEMBERS
170     // @dev  The reference to the active token implementation.
171     ERC20Impl public erc20Impl;
172 
173     /// @dev  The map of lock ids to pending implementation changes.
174     mapping (bytes32 => ImplChangeRequest) public implChangeReqs;
175 
176     // CONSTRUCTOR
177     function ERC20ImplUpgradeable(address _custodian) CustodianUpgradeable(_custodian) public {
178         erc20Impl = ERC20Impl(0x0);
179     }
180 
181     // MODIFIERS
182     modifier onlyImpl {
183         require(msg.sender == address(erc20Impl));
184         _;
185     }
186 
187     // PUBLIC FUNCTIONS
188     // (UPGRADE)
189     /** @notice  Requests a change of the active implementation associated
190       * with this contract.
191       *
192       * @dev  Returns a unique lock id associated with the request.
193       * Anyone can call this function, but confirming the request is authorized
194       * by the custodian.
195       *
196       * @param  _proposedImpl  The address of the new active implementation.
197       * @return  lockId  A unique identifier for this request.
198       */
199     function requestImplChange(address _proposedImpl) public returns (bytes32 lockId) {
200         require(_proposedImpl != address(0));
201 
202         lockId = generateLockId();
203 
204         implChangeReqs[lockId] = ImplChangeRequest({
205             proposedNew: _proposedImpl
206         });
207 
208         emit ImplChangeRequested(lockId, msg.sender, _proposedImpl);
209     }
210 
211     /** @notice  Confirms a pending change of the active implementation
212       * associated with this contract.
213       *
214       * @dev  When called by the custodian with a lock id associated with a
215       * pending change, the `ERC20Impl erc20Impl` member will be updated
216       * with the requested address.
217       *
218       * @param  _lockId  The identifier of a pending change request.
219       */
220     function confirmImplChange(bytes32 _lockId) public onlyCustodian {
221         erc20Impl = getImplChangeReq(_lockId);
222 
223         delete implChangeReqs[_lockId];
224 
225         emit ImplChangeConfirmed(_lockId, address(erc20Impl));
226     }
227 
228     // PRIVATE FUNCTIONS
229     function getImplChangeReq(bytes32 _lockId) private view returns (ERC20Impl _proposedNew) {
230         ImplChangeRequest storage changeRequest = implChangeReqs[_lockId];
231 
232         // reject ‘null’ results from the map lookup
233         // this can only be the case if an unknown `_lockId` is received
234         require(changeRequest.proposedNew != address(0));
235 
236         return ERC20Impl(changeRequest.proposedNew);
237     }
238 
239     /// @dev  Emitted by successful `requestImplChange` calls.
240     event ImplChangeRequested(
241         bytes32 _lockId,
242         address _msgSender,
243         address _proposedImpl
244     );
245 
246     /// @dev Emitted by successful `confirmImplChange` calls.
247     event ImplChangeConfirmed(bytes32 _lockId, address _newImpl);
248 }
249 
250 
251 contract ERC20Interface {
252   // METHODS
253 
254   // NOTE:
255   //   public getter functions are not currently recognised as an
256   //   implementation of the matching abstract function by the compiler.
257 
258   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#name
259   // function name() public view returns (string);
260 
261   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#symbol
262   // function symbol() public view returns (string);
263 
264   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#totalsupply
265   // function decimals() public view returns (uint8);
266 
267   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#totalsupply
268   function totalSupply() public view returns (uint256);
269 
270   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#balanceof
271   function balanceOf(address _owner) public view returns (uint256 balance);
272 
273   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer
274   function transfer(address _to, uint256 _value) public returns (bool success);
275 
276   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transferfrom
277   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
278 
279   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approve
280   function approve(address _spender, uint256 _value) public returns (bool success);
281 
282   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#allowance
283   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
284 
285   // EVENTS
286   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer-1
287   event Transfer(address indexed _from, address indexed _to, uint256 _value);
288 
289   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approval
290   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
291 }
292 
293 
294 /** @title  Public interface to ERC20 compliant token.
295   *
296   * @notice  This contract is a permanent entry point to an ERC20 compliant
297   * system of contracts.
298   *
299   * @dev  This contract contains no business logic and instead
300   * delegates to an instance of ERC20Impl. This contract also has no storage
301   * that constitutes the operational state of the token. This contract is
302   * upgradeable in the sense that the `custodian` can update the
303   * `erc20Impl` address, thus redirecting the delegation of business logic.
304   * The `custodian` is also authorized to pass custodianship.
305   *
306   * @author  Gemini Trust Company, LLC
307   */
308 contract ERC20Proxy is ERC20Interface, ERC20ImplUpgradeable {
309 
310     // MEMBERS
311     /// @notice  Returns the name of the token.
312     string public name;
313 
314     /// @notice  Returns the symbol of the token.
315     string public symbol;
316 
317     /// @notice  Returns the number of decimals the token uses.
318     uint8 public decimals;
319 
320     // CONSTRUCTOR
321     function ERC20Proxy(
322         string _name,
323         string _symbol,
324         uint8 _decimals,
325         address _custodian
326     )
327         ERC20ImplUpgradeable(_custodian)
328         public
329     {
330         name = _name;
331         symbol = _symbol;
332         decimals = _decimals;
333     }
334 
335     // PUBLIC FUNCTIONS
336     // (ERC20Interface)
337     /** @notice  Returns the total token supply.
338       *
339       * @return  the total token supply.
340       */
341     function totalSupply() public view returns (uint256) {
342         return erc20Impl.totalSupply();
343     }
344 
345     /** @notice  Returns the account balance of another account with address
346       * `_owner`.
347       *
348       * @return  balance  the balance of account with address `_owner`.
349       */
350     function balanceOf(address _owner) public view returns (uint256 balance) {
351         return erc20Impl.balanceOf(_owner);
352     }
353 
354     /** @dev Internal use only.
355       */
356     function emitTransfer(address _from, address _to, uint256 _value) public onlyImpl {
357         emit Transfer(_from, _to, _value);
358     }
359 
360     /** @notice  Transfers `_value` amount of tokens to address `_to`.
361       *
362       * @dev Will fire the `Transfer` event. Will revert if the `_from`
363       * account balance does not have enough tokens to spend.
364       *
365       * @return  success  true if transfer completes.
366       */
367     function transfer(address _to, uint256 _value) public returns (bool success) {
368         return erc20Impl.transferWithSender(msg.sender, _to, _value);
369     }
370 
371     /** @notice  Transfers `_value` amount of tokens from address `_from`
372       * to address `_to`.
373       *
374       * @dev  Will fire the `Transfer` event. Will revert unless the `_from`
375       * account has deliberately authorized the sender of the message
376       * via some mechanism.
377       *
378       * @return  success  true if transfer completes.
379       */
380     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
381         return erc20Impl.transferFromWithSender(msg.sender, _from, _to, _value);
382     }
383 
384     /** @dev Internal use only.
385       */
386     function emitApproval(address _owner, address _spender, uint256 _value) public onlyImpl {
387         emit Approval(_owner, _spender, _value);
388     }
389 
390     /** @notice  Allows `_spender` to withdraw from your account multiple times,
391       * up to the `_value` amount. If this function is called again it
392       * overwrites the current allowance with _value.
393       *
394       * @dev  Will fire the `Approval` event.
395       *
396       * @return  success  true if approval completes.
397       */
398     function approve(address _spender, uint256 _value) public returns (bool success) {
399         return erc20Impl.approveWithSender(msg.sender, _spender, _value);
400     }
401 
402     /** @notice Increases the amount `_spender` is allowed to withdraw from
403       * your account.
404       * This function is implemented to avoid the race condition in standard
405       * ERC20 contracts surrounding the `approve` method.
406       *
407       * @dev  Will fire the `Approval` event. This function should be used instead of
408       * `approve`.
409       *
410       * @return  success  true if approval completes.
411       */
412     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
413         return erc20Impl.increaseApprovalWithSender(msg.sender, _spender, _addedValue);
414     }
415 
416     /** @notice  Decreases the amount `_spender` is allowed to withdraw from
417       * your account. This function is implemented to avoid the race
418       * condition in standard ERC20 contracts surrounding the `approve` method.
419       *
420       * @dev  Will fire the `Approval` event. This function should be used
421       * instead of `approve`.
422       *
423       * @return  success  true if approval completes.
424       */
425     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
426         return erc20Impl.decreaseApprovalWithSender(msg.sender, _spender, _subtractedValue);
427     }
428 
429     /** @notice  Returns how much `_spender` is currently allowed to spend from
430       * `_owner`'s balance.
431       *
432       * @return  remaining  the remaining allowance.
433       */
434     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
435         return erc20Impl.allowance(_owner, _spender);
436     }
437 }
438 
439 
440 /** @title  ERC20 compliant token intermediary contract holding core logic.
441   *
442   * @notice  This contract serves as an intermediary between the exposed ERC20
443   * interface in ERC20Proxy and the store of balances in ERC20Store. This
444   * contract contains core logic that the proxy can delegate to
445   * and that the store is called by.
446   *
447   * @dev  This contract contains the core logic to implement the
448   * ERC20 specification as well as several extensions.
449   * 1. Changes to the token supply.
450   * 2. Batched transfers.
451   * 3. Relative changes to spending approvals.
452   * 4. Delegated transfer control ('sweeping').
453   *
454   * @author  Gemini Trust Company, LLC
455   */
456 contract ERC20Impl is CustodianUpgradeable {
457 
458     // TYPES
459     /// @dev  The struct type for pending increases to the token supply (print).
460     struct PendingPrint {
461         address receiver;
462         uint256 value;
463     }
464 
465     // MEMBERS
466     /// @dev  The reference to the proxy.
467     ERC20Proxy public erc20Proxy;
468 
469     /// @dev  The reference to the store.
470     ERC20Store public erc20Store;
471 
472     /// @dev  The sole authorized caller of delegated transfer control ('sweeping').
473     address public sweeper;
474 
475     /** @dev  The static message to be signed by an external account that
476       * signifies their permission to forward their balance to any arbitrary
477       * address. This is used to consolidate the control of all accounts
478       * backed by a shared keychain into the control of a single key.
479       * Initialized as the concatenation of the address of this contract
480       * and the word "sweep". This concatenation is done to prevent a replay
481       * attack in a subsequent contract, where the sweep message could
482       * potentially be replayed to re-enable sweeping ability.
483       */
484     bytes32 public sweepMsg;
485 
486     /** @dev  The mapping that stores whether the address in question has
487       * enabled sweeping its contents to another account or not.
488       * If an address maps to "true", it has already enabled sweeping,
489       * and thus does not need to re-sign the `sweepMsg` to enact the sweep.
490       */
491     mapping (address => bool) public sweptSet;
492 
493     /// @dev  The map of lock ids to pending token increases.
494     mapping (bytes32 => PendingPrint) public pendingPrintMap;
495 
496     // CONSTRUCTOR
497     function ERC20Impl(
498           address _erc20Proxy,
499           address _erc20Store,
500           address _custodian,
501           address _sweeper
502     )
503         CustodianUpgradeable(_custodian)
504         public
505     {
506         require(_sweeper != 0);
507         erc20Proxy = ERC20Proxy(_erc20Proxy);
508         erc20Store = ERC20Store(_erc20Store);
509 
510         sweeper = _sweeper;
511         sweepMsg = keccak256(address(this), "sweep");
512     }
513 
514     // MODIFIERS
515     modifier onlyProxy {
516         require(msg.sender == address(erc20Proxy));
517         _;
518     }
519     modifier onlySweeper {
520         require(msg.sender == sweeper);
521         _;
522     }
523 
524 
525     /** @notice  Core logic of the ERC20 `approve` function.
526       *
527       * @dev  This function can only be called by the referenced proxy,
528       * which has an `approve` function.
529       * Every argument passed to that function as well as the original
530       * `msg.sender` gets passed to this function.
531       * NOTE: approvals for the zero address (unspendable) are disallowed.
532       *
533       * @param  _sender  The address initiating the approval in proxy.
534       */
535     function approveWithSender(
536         address _sender,
537         address _spender,
538         uint256 _value
539     )
540         public
541         onlyProxy
542         returns (bool success)
543     {
544         require(_spender != address(0)); // disallow unspendable approvals
545         erc20Store.setAllowance(_sender, _spender, _value);
546         erc20Proxy.emitApproval(_sender, _spender, _value);
547         return true;
548     }
549 
550     /** @notice  Core logic of the `increaseApproval` function.
551       *
552       * @dev  This function can only be called by the referenced proxy,
553       * which has an `increaseApproval` function.
554       * Every argument passed to that function as well as the original
555       * `msg.sender` gets passed to this function.
556       * NOTE: approvals for the zero address (unspendable) are disallowed.
557       *
558       * @param  _sender  The address initiating the approval.
559       */
560     function increaseApprovalWithSender(
561         address _sender,
562         address _spender,
563         uint256 _addedValue
564     )
565         public
566         onlyProxy
567         returns (bool success)
568     {
569         require(_spender != address(0)); // disallow unspendable approvals
570         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
571         uint256 newAllowance = currentAllowance + _addedValue;
572 
573         require(newAllowance >= currentAllowance);
574 
575         erc20Store.setAllowance(_sender, _spender, newAllowance);
576         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
577         return true;
578     }
579 
580     /** @notice  Core logic of the `decreaseApproval` function.
581       *
582       * @dev  This function can only be called by the referenced proxy,
583       * which has a `decreaseApproval` function.
584       * Every argument passed to that function as well as the original
585       * `msg.sender` gets passed to this function.
586       * NOTE: approvals for the zero address (unspendable) are disallowed.
587       *
588       * @param  _sender  The address initiating the approval.
589       */
590     function decreaseApprovalWithSender(
591         address _sender,
592         address _spender,
593         uint256 _subtractedValue
594     )
595         public
596         onlyProxy
597         returns (bool success)
598     {
599         require(_spender != address(0)); // disallow unspendable approvals
600         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
601         uint256 newAllowance = currentAllowance - _subtractedValue;
602 
603         require(newAllowance <= currentAllowance);
604 
605         erc20Store.setAllowance(_sender, _spender, newAllowance);
606         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
607         return true;
608     }
609 
610     /** @notice  Requests an increase in the token supply, with the newly created
611       * tokens to be added to the balance of the specified account.
612       *
613       * @dev  Returns a unique lock id associated with the request.
614       * Anyone can call this function, but confirming the request is authorized
615       * by the custodian.
616       * NOTE: printing to the zero address is disallowed.
617       *
618       * @param  _receiver  The receiving address of the print, if confirmed.
619       * @param  _value  The number of tokens to add to the total supply and the
620       * balance of the receiving address, if confirmed.
621       *
622       * @return  lockId  A unique identifier for this request.
623       */
624     function requestPrint(address _receiver, uint256 _value) public returns (bytes32 lockId) {
625         require(_receiver != address(0));
626 
627         lockId = generateLockId();
628 
629         pendingPrintMap[lockId] = PendingPrint({
630             receiver: _receiver,
631             value: _value
632         });
633 
634         emit PrintingLocked(lockId, _receiver, _value);
635     }
636 
637     /** @notice  Confirms a pending increase in the token supply.
638       *
639       * @dev  When called by the custodian with a lock id associated with a
640       * pending increase, the amount requested to be printed in the print request
641       * is printed to the receiving address specified in that same request.
642       * NOTE: this function will not execute any print that would overflow the
643       * total supply, but it will not revert either.
644       *
645       * @param  _lockId  The identifier of a pending print request.
646       */
647     function confirmPrint(bytes32 _lockId) public onlyCustodian {
648         PendingPrint storage print = pendingPrintMap[_lockId];
649 
650         // reject ‘null’ results from the map lookup
651         // this can only be the case if an unknown `_lockId` is received
652         address receiver = print.receiver;
653         require (receiver != address(0));
654         uint256 value = print.value;
655 
656         delete pendingPrintMap[_lockId];
657 
658         uint256 supply = erc20Store.totalSupply();
659         uint256 newSupply = supply + value;
660         if (newSupply >= supply) {
661           erc20Store.setTotalSupply(newSupply);
662           erc20Store.addBalance(receiver, value);
663 
664           emit PrintingConfirmed(_lockId, receiver, value);
665           erc20Proxy.emitTransfer(address(0), receiver, value);
666         }
667     }
668 
669     /** @notice  Burns the specified value from the sender's balance.
670       *
671       * @dev  Sender's balanced is subtracted by the amount they wish to burn.
672       *
673       * @param  _value  The amount to burn.
674       *
675       * @return  success  true if the burn succeeded.
676       */
677     function burn(uint256 _value) public returns (bool success) {
678         uint256 balanceOfSender = erc20Store.balances(msg.sender);
679         require(_value <= balanceOfSender);
680 
681         erc20Store.setBalance(msg.sender, balanceOfSender - _value);
682         erc20Store.setTotalSupply(erc20Store.totalSupply() - _value);
683 
684         erc20Proxy.emitTransfer(msg.sender, address(0), _value);
685 
686         return true;
687     }
688 
689     /** @notice  A function for a sender to issue multiple transfers to multiple
690       * different addresses at once. This function is implemented for gas
691       * considerations when someone wishes to transfer, as one transaction is
692       * cheaper than issuing several distinct individual `transfer` transactions.
693       *
694       * @dev  By specifying a set of destination addresses and values, the
695       * sender can issue one transaction to transfer multiple amounts to
696       * distinct addresses, rather than issuing each as a separate
697       * transaction. The `_tos` and `_values` arrays must be equal length, and
698       * an index in one array corresponds to the same index in the other array
699       * (e.g. `_tos[0]` will receive `_values[0]`, `_tos[1]` will receive
700       * `_values[1]`, and so on.)
701       * NOTE: transfers to the zero address are disallowed.
702       *
703       * @param  _tos  The destination addresses to receive the transfers.
704       * @param  _values  The values for each destination address.
705       * @return  success  If transfers succeeded.
706       */
707     function batchTransfer(address[] _tos, uint256[] _values) public returns (bool success) {
708         require(_tos.length == _values.length);
709 
710         uint256 numTransfers = _tos.length;
711         uint256 senderBalance = erc20Store.balances(msg.sender);
712 
713         for (uint256 i = 0; i < numTransfers; i++) {
714           address to = _tos[i];
715           require(to != address(0));
716           uint256 v = _values[i];
717           require(senderBalance >= v);
718 
719           if (msg.sender != to) {
720             senderBalance -= v;
721             erc20Store.addBalance(to, v);
722           }
723           erc20Proxy.emitTransfer(msg.sender, to, v);
724         }
725 
726         erc20Store.setBalance(msg.sender, senderBalance);
727 
728         return true;
729     }
730 
731     /** @notice  Enables the delegation of transfer control for many
732       * accounts to the sweeper account, transferring any balances
733       * as well to the given destination.
734       *
735       * @dev  An account delegates transfer control by signing the
736       * value of `sweepMsg`. The sweeper account is the only authorized
737       * caller of this function, so it must relay signatures on behalf
738       * of accounts that delegate transfer control to it. Enabling
739       * delegation is idempotent and permanent. If the account has a
740       * balance at the time of enabling delegation, its balance is
741       * also transfered to the given destination account `_to`.
742       * NOTE: transfers to the zero address are disallowed.
743       *
744       * @param  _vs  The array of recovery byte components of the ECDSA signatures.
745       * @param  _rs  The array of 'R' components of the ECDSA signatures.
746       * @param  _ss  The array of 'S' components of the ECDSA signatures.
747       * @param  _to  The destination for swept balances.
748       */
749     function enableSweep(uint8[] _vs, bytes32[] _rs, bytes32[] _ss, address _to) public onlySweeper {
750         require(_to != address(0));
751         require((_vs.length == _rs.length) && (_vs.length == _ss.length));
752 
753         uint256 numSignatures = _vs.length;
754         uint256 sweptBalance = 0;
755 
756         for (uint256 i=0; i<numSignatures; ++i) {
757           address from = ecrecover(sweepMsg, _vs[i], _rs[i], _ss[i]);
758 
759           // ecrecover returns 0 on malformed input
760           if (from != address(0)) {
761             sweptSet[from] = true;
762 
763             uint256 fromBalance = erc20Store.balances(from);
764 
765             if (fromBalance > 0) {
766               sweptBalance += fromBalance;
767 
768               erc20Store.setBalance(from, 0);
769 
770               erc20Proxy.emitTransfer(from, _to, fromBalance);
771             }
772           }
773         }
774 
775         if (sweptBalance > 0) {
776           erc20Store.addBalance(_to, sweptBalance);
777         }
778     }
779 
780     /** @notice  For accounts that have delegated, transfer control
781       * to the sweeper, this function transfers their balances to the given
782       * destination.
783       *
784       * @dev The sweeper account is the only authorized caller of
785       * this function. This function accepts an array of addresses to have their
786       * balances transferred for gas efficiency purposes.
787       * NOTE: any address for an account that has not been previously enabled
788       * will be ignored.
789       * NOTE: transfers to the zero address are disallowed.
790       *
791       * @param  _froms  The addresses to have their balances swept.
792       * @param  _to  The destination address of all these transfers.
793       */
794     function replaySweep(address[] _froms, address _to) public onlySweeper {
795         require(_to != address(0));
796         uint256 lenFroms = _froms.length;
797         uint256 sweptBalance = 0;
798 
799         for (uint256 i=0; i<lenFroms; ++i) {
800             address from = _froms[i];
801 
802             if (sweptSet[from]) {
803                 uint256 fromBalance = erc20Store.balances(from);
804 
805                 if (fromBalance > 0) {
806                     sweptBalance += fromBalance;
807 
808                     erc20Store.setBalance(from, 0);
809 
810                     erc20Proxy.emitTransfer(from, _to, fromBalance);
811                 }
812             }
813         }
814 
815         if (sweptBalance > 0) {
816             erc20Store.addBalance(_to, sweptBalance);
817         }
818     }
819 
820     /** @notice  Core logic of the ERC20 `transferFrom` function.
821       *
822       * @dev  This function can only be called by the referenced proxy,
823       * which has a `transferFrom` function.
824       * Every argument passed to that function as well as the original
825       * `msg.sender` gets passed to this function.
826       * NOTE: transfers to the zero address are disallowed.
827       *
828       * @param  _sender  The address initiating the transfer in proxy.
829       */
830     function transferFromWithSender(
831         address _sender,
832         address _from,
833         address _to,
834         uint256 _value
835     )
836         public
837         onlyProxy
838         returns (bool success)
839     {
840         require(_to != address(0)); // ensure burn is the cannonical transfer to 0x0
841 
842         uint256 balanceOfFrom = erc20Store.balances(_from);
843         require(_value <= balanceOfFrom);
844 
845         uint256 senderAllowance = erc20Store.allowed(_from, _sender);
846         require(_value <= senderAllowance);
847 
848         erc20Store.setBalance(_from, balanceOfFrom - _value);
849         erc20Store.addBalance(_to, _value);
850 
851         erc20Store.setAllowance(_from, _sender, senderAllowance - _value);
852 
853         erc20Proxy.emitTransfer(_from, _to, _value);
854 
855         return true;
856     }
857 
858     /** @notice  Core logic of the ERC20 `transfer` function.
859       *
860       * @dev  This function can only be called by the referenced proxy,
861       * which has a `transfer` function.
862       * Every argument passed to that function as well as the original
863       * `msg.sender` gets passed to this function.
864       * NOTE: transfers to the zero address are disallowed.
865       *
866       * @param  _sender  The address initiating the transfer in proxy.
867       */
868     function transferWithSender(
869         address _sender,
870         address _to,
871         uint256 _value
872     )
873         public
874         onlyProxy
875         returns (bool success)
876     {
877         require(_to != address(0)); // ensure burn is the cannonical transfer to 0x0
878 
879         uint256 balanceOfSender = erc20Store.balances(_sender);
880         require(_value <= balanceOfSender);
881 
882         erc20Store.setBalance(_sender, balanceOfSender - _value);
883         erc20Store.addBalance(_to, _value);
884 
885         erc20Proxy.emitTransfer(_sender, _to, _value);
886 
887         return true;
888     }
889 
890     // METHODS (ERC20 sub interface impl.)
891     /// @notice  Core logic of the ERC20 `totalSupply` function.
892     function totalSupply() public view returns (uint256) {
893         return erc20Store.totalSupply();
894     }
895 
896     /// @notice  Core logic of the ERC20 `balanceOf` function.
897     function balanceOf(address _owner) public view returns (uint256 balance) {
898         return erc20Store.balances(_owner);
899     }
900 
901     /// @notice  Core logic of the ERC20 `allowance` function.
902     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
903         return erc20Store.allowed(_owner, _spender);
904     }
905 
906     // EVENTS
907     /// @dev  Emitted by successful `requestPrint` calls.
908     event PrintingLocked(bytes32 _lockId, address _receiver, uint256 _value);
909     /// @dev Emitted by successful `confirmPrint` calls.
910     event PrintingConfirmed(bytes32 _lockId, address _receiver, uint256 _value);
911 }
912 
913 
914 /** @title  ERC20 compliant token balance store.
915   *
916   * @notice  This contract serves as the store of balances, allowances, and
917   * supply for the ERC20 compliant token. No business logic exists here.
918   *
919   * @dev  This contract contains no business logic and instead
920   * is the final destination for any change in balances, allowances, or token
921   * supply. This contract is upgradeable in the sense that its custodian can
922   * update the `erc20Impl` address, thus redirecting the source of logic that
923   * determines how the balances will be updated.
924   *
925   * @author  Gemini Trust Company, LLC
926   */
927 contract ERC20Store is ERC20ImplUpgradeable {
928 
929     // MEMBERS
930     /// @dev  The total token supply.
931     uint256 public totalSupply;
932 
933     /// @dev  The mapping of balances.
934     mapping (address => uint256) public balances;
935 
936     /// @dev  The mapping of allowances.
937     mapping (address => mapping (address => uint256)) public allowed;
938 
939     // CONSTRUCTOR
940     function ERC20Store(address _custodian) ERC20ImplUpgradeable(_custodian) public {
941         totalSupply = 1000000;
942     }
943 
944 
945     // PUBLIC FUNCTIONS
946     // (ERC20 Ledger)
947 
948     /** @notice  The function to set the total supply of tokens.
949       *
950       * @dev  Intended for use by token implementation functions
951       * that update the total supply. The only authorized caller
952       * is the active implementation.
953       *
954       * @param _newTotalSupply the value to set as the new total supply
955       */
956     function setTotalSupply(
957         uint256 _newTotalSupply
958     )
959         public
960         onlyImpl
961     {
962         totalSupply = _newTotalSupply;
963     }
964 
965     /** @notice  Sets how much `_owner` allows `_spender` to transfer on behalf
966       * of `_owner`.
967       *
968       * @dev  Intended for use by token implementation functions
969       * that update spending allowances. The only authorized caller
970       * is the active implementation.
971       *
972       * @param  _owner  The account that will allow an on-behalf-of spend.
973       * @param  _spender  The account that will spend on behalf of the owner.
974       * @param  _value  The limit of what can be spent.
975       */
976     function setAllowance(
977         address _owner,
978         address _spender,
979         uint256 _value
980     )
981         public
982         onlyImpl
983     {
984         allowed[_owner][_spender] = _value;
985     }
986 
987     /** @notice  Sets the balance of `_owner` to `_newBalance`.
988       *
989       * @dev  Intended for use by token implementation functions
990       * that update balances. The only authorized caller
991       * is the active implementation.
992       *
993       * @param  _owner  The account that will hold a new balance.
994       * @param  _newBalance  The balance to set.
995       */
996     function setBalance(
997         address _owner,
998         uint256 _newBalance
999     )
1000         public
1001         onlyImpl
1002     {
1003         balances[_owner] = _newBalance;
1004     }
1005 
1006     /** @notice Adds `_balanceIncrease` to `_owner`'s balance.
1007       *
1008       * @dev  Intended for use by token implementation functions
1009       * that update balances. The only authorized caller
1010       * is the active implementation.
1011       * WARNING: the caller is responsible for preventing overflow.
1012       *
1013       * @param  _owner  The account that will hold a new balance.
1014       * @param  _balanceIncrease  The balance to add.
1015       */
1016     function addBalance(
1017         address _owner,
1018         uint256 _balanceIncrease
1019     )
1020         public
1021         onlyImpl
1022     {
1023         balances[_owner] = balances[_owner] + _balanceIncrease;
1024     }
1025 }