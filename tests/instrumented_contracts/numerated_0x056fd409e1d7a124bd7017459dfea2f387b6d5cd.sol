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
72     function CustodianUpgradeable(
73         address _custodian
74     )
75       LockRequestable()
76       public
77     {
78         custodian = _custodian;
79     }
80 
81     // MODIFIERS
82     modifier onlyCustodian {
83         require(msg.sender == custodian);
84         _;
85     }
86 
87     // PUBLIC FUNCTIONS
88     // (UPGRADE)
89 
90     /** @notice  Requests a change of the custodian associated with this contract.
91       *
92       * @dev  Returns a unique lock id associated with the request.
93       * Anyone can call this function, but confirming the request is authorized
94       * by the custodian.
95       *
96       * @param  _proposedCustodian  The address of the new custodian.
97       * @return  lockId  A unique identifier for this request.
98       */
99     function requestCustodianChange(address _proposedCustodian) public returns (bytes32 lockId) {
100         require(_proposedCustodian != address(0));
101 
102         lockId = generateLockId();
103 
104         custodianChangeReqs[lockId] = CustodianChangeRequest({
105             proposedNew: _proposedCustodian
106         });
107 
108         emit CustodianChangeRequested(lockId, msg.sender, _proposedCustodian);
109     }
110 
111     /** @notice  Confirms a pending change of the custodian associated with this contract.
112       *
113       * @dev  When called by the current custodian with a lock id associated with a
114       * pending custodian change, the `address custodian` member will be updated with the
115       * requested address.
116       *
117       * @param  _lockId  The identifier of a pending change request.
118       */
119     function confirmCustodianChange(bytes32 _lockId) public onlyCustodian {
120         custodian = getCustodianChangeReq(_lockId);
121 
122         delete custodianChangeReqs[_lockId];
123 
124         emit CustodianChangeConfirmed(_lockId, custodian);
125     }
126 
127     // PRIVATE FUNCTIONS
128     function getCustodianChangeReq(bytes32 _lockId) private view returns (address _proposedNew) {
129         CustodianChangeRequest storage changeRequest = custodianChangeReqs[_lockId];
130 
131         // reject ‘null’ results from the map lookup
132         // this can only be the case if an unknown `_lockId` is received
133         require(changeRequest.proposedNew != 0);
134 
135         return changeRequest.proposedNew;
136     }
137 
138     /// @dev  Emitted by successful `requestCustodianChange` calls.
139     event CustodianChangeRequested(
140         bytes32 _lockId,
141         address _msgSender,
142         address _proposedCustodian
143     );
144 
145     /// @dev Emitted by successful `confirmCustodianChange` calls.
146     event CustodianChangeConfirmed(bytes32 _lockId, address _newCustodian);
147 }
148 
149 
150 /** @title  A contract to inherit upgradeable token implementations.
151   *
152   * @notice  A contract that provides re-usable code for upgradeable
153   * token implementations. It itself inherits from `CustodianUpgradable`
154   * as the upgrade process is controlled by the custodian.
155   *
156   * @dev  This contract is intended to be inherited by any contract
157   * requiring a reference to the active token implementation, either
158   * to delegate calls to it, or authorize calls from it. This contract
159   * provides the mechanism for that implementation to be be replaced,
160   * which constitutes an implementation upgrade.
161   *
162   * @author Gemini Trust Company, LLC
163   */
164 contract ERC20ImplUpgradeable is CustodianUpgradeable  {
165 
166     // TYPES
167     /// @dev  The struct type for pending implementation changes.
168     struct ImplChangeRequest {
169         address proposedNew;
170     }
171 
172     // MEMBERS
173     // @dev  The reference to the active token implementation.
174     ERC20Impl public erc20Impl;
175 
176     /// @dev  The map of lock ids to pending implementation changes.
177     mapping (bytes32 => ImplChangeRequest) public implChangeReqs;
178 
179     // CONSTRUCTOR
180     function ERC20ImplUpgradeable(address _custodian) CustodianUpgradeable(_custodian) public {
181         erc20Impl = ERC20Impl(0x0);
182     }
183 
184     // MODIFIERS
185     modifier onlyImpl {
186         require(msg.sender == address(erc20Impl));
187         _;
188     }
189 
190     // PUBLIC FUNCTIONS
191     // (UPGRADE)
192     /** @notice  Requests a change of the active implementation associated
193       * with this contract.
194       *
195       * @dev  Returns a unique lock id associated with the request.
196       * Anyone can call this function, but confirming the request is authorized
197       * by the custodian.
198       *
199       * @param  _proposedImpl  The address of the new active implementation.
200       * @return  lockId  A unique identifier for this request.
201       */
202     function requestImplChange(address _proposedImpl) public returns (bytes32 lockId) {
203         require(_proposedImpl != address(0));
204 
205         lockId = generateLockId();
206 
207         implChangeReqs[lockId] = ImplChangeRequest({
208             proposedNew: _proposedImpl
209         });
210 
211         emit ImplChangeRequested(lockId, msg.sender, _proposedImpl);
212     }
213 
214     /** @notice  Confirms a pending change of the active implementation
215       * associated with this contract.
216       *
217       * @dev  When called by the custodian with a lock id associated with a
218       * pending change, the `ERC20Impl erc20Impl` member will be updated
219       * with the requested address.
220       *
221       * @param  _lockId  The identifier of a pending change request.
222       */
223     function confirmImplChange(bytes32 _lockId) public onlyCustodian {
224         erc20Impl = getImplChangeReq(_lockId);
225 
226         delete implChangeReqs[_lockId];
227 
228         emit ImplChangeConfirmed(_lockId, address(erc20Impl));
229     }
230 
231     // PRIVATE FUNCTIONS
232     function getImplChangeReq(bytes32 _lockId) private view returns (ERC20Impl _proposedNew) {
233         ImplChangeRequest storage changeRequest = implChangeReqs[_lockId];
234 
235         // reject ‘null’ results from the map lookup
236         // this can only be the case if an unknown `_lockId` is received
237         require(changeRequest.proposedNew != address(0));
238 
239         return ERC20Impl(changeRequest.proposedNew);
240     }
241 
242     /// @dev  Emitted by successful `requestImplChange` calls.
243     event ImplChangeRequested(
244         bytes32 _lockId,
245         address _msgSender,
246         address _proposedImpl
247     );
248 
249     /// @dev Emitted by successful `confirmImplChange` calls.
250     event ImplChangeConfirmed(bytes32 _lockId, address _newImpl);
251 }
252 
253 
254 contract ERC20Interface {
255   // METHODS
256 
257   // NOTE:
258   //   public getter functions are not currently recognised as an
259   //   implementation of the matching abstract function by the compiler.
260 
261   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#name
262   // function name() public view returns (string);
263 
264   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#symbol
265   // function symbol() public view returns (string);
266 
267   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#totalsupply
268   // function decimals() public view returns (uint8);
269 
270   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#totalsupply
271   function totalSupply() public view returns (uint256);
272 
273   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#balanceof
274   function balanceOf(address _owner) public view returns (uint256 balance);
275 
276   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer
277   function transfer(address _to, uint256 _value) public returns (bool success);
278 
279   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transferfrom
280   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
281 
282   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approve
283   function approve(address _spender, uint256 _value) public returns (bool success);
284 
285   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#allowance
286   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
287 
288   // EVENTS
289   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer-1
290   event Transfer(address indexed _from, address indexed _to, uint256 _value);
291 
292   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approval
293   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
294 }
295 
296 
297 /** @title  Public interface to ERC20 compliant token.
298   *
299   * @notice  This contract is a permanent entry point to an ERC20 compliant
300   * system of contracts.
301   *
302   * @dev  This contract contains no business logic and instead
303   * delegates to an instance of ERC20Impl. This contract also has no storage
304   * that constitutes the operational state of the token. This contract is
305   * upgradeable in the sense that the `custodian` can update the
306   * `erc20Impl` address, thus redirecting the delegation of business logic.
307   * The `custodian` is also authorized to pass custodianship.
308   *
309   * @author  Gemini Trust Company, LLC
310   */
311 contract ERC20Proxy is ERC20Interface, ERC20ImplUpgradeable {
312 
313     // MEMBERS
314     /// @notice  Returns the name of the token.
315     string public name;
316 
317     /// @notice  Returns the symbol of the token.
318     string public symbol;
319 
320     /// @notice  Returns the number of decimals the token uses.
321     uint8 public decimals;
322 
323     // CONSTRUCTOR
324     function ERC20Proxy(
325         string _name,
326         string _symbol,
327         uint8 _decimals,
328         address _custodian
329     )
330         ERC20ImplUpgradeable(_custodian)
331         public
332     {
333         name = _name;
334         symbol = _symbol;
335         decimals = _decimals;
336     }
337 
338     // PUBLIC FUNCTIONS
339     // (ERC20Interface)
340     /** @notice  Returns the total token supply.
341       *
342       * @return  the total token supply.
343       */
344     function totalSupply() public view returns (uint256) {
345         return erc20Impl.totalSupply();
346     }
347 
348     /** @notice  Returns the account balance of another account with address
349       * `_owner`.
350       *
351       * @return  balance  the balance of account with address `_owner`.
352       */
353     function balanceOf(address _owner) public view returns (uint256 balance) {
354         return erc20Impl.balanceOf(_owner);
355     }
356 
357     /** @dev Internal use only.
358       */
359     function emitTransfer(address _from, address _to, uint256 _value) public onlyImpl {
360         emit Transfer(_from, _to, _value);
361     }
362 
363     /** @notice  Transfers `_value` amount of tokens to address `_to`.
364       *
365       * @dev Will fire the `Transfer` event. Will revert if the `_from`
366       * account balance does not have enough tokens to spend.
367       *
368       * @return  success  true if transfer completes.
369       */
370     function transfer(address _to, uint256 _value) public returns (bool success) {
371         return erc20Impl.transferWithSender(msg.sender, _to, _value);
372     }
373 
374     /** @notice  Transfers `_value` amount of tokens from address `_from`
375       * to address `_to`.
376       *
377       * @dev  Will fire the `Transfer` event. Will revert unless the `_from`
378       * account has deliberately authorized the sender of the message
379       * via some mechanism.
380       *
381       * @return  success  true if transfer completes.
382       */
383     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
384         return erc20Impl.transferFromWithSender(msg.sender, _from, _to, _value);
385     }
386 
387     /** @dev Internal use only.
388       */
389     function emitApproval(address _owner, address _spender, uint256 _value) public onlyImpl {
390         emit Approval(_owner, _spender, _value);
391     }
392 
393     /** @notice  Allows `_spender` to withdraw from your account multiple times,
394       * up to the `_value` amount. If this function is called again it
395       * overwrites the current allowance with _value.
396       *
397       * @dev  Will fire the `Approval` event.
398       *
399       * @return  success  true if approval completes.
400       */
401     function approve(address _spender, uint256 _value) public returns (bool success) {
402         return erc20Impl.approveWithSender(msg.sender, _spender, _value);
403     }
404 
405     /** @notice Increases the amount `_spender` is allowed to withdraw from
406       * your account.
407       * This function is implemented to avoid the race condition in standard
408       * ERC20 contracts surrounding the `approve` method.
409       *
410       * @dev  Will fire the `Approval` event. This function should be used instead of
411       * `approve`.
412       *
413       * @return  success  true if approval completes.
414       */
415     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
416         return erc20Impl.increaseApprovalWithSender(msg.sender, _spender, _addedValue);
417     }
418 
419     /** @notice  Decreases the amount `_spender` is allowed to withdraw from
420       * your account. This function is implemented to avoid the race
421       * condition in standard ERC20 contracts surrounding the `approve` method.
422       *
423       * @dev  Will fire the `Approval` event. This function should be used
424       * instead of `approve`.
425       *
426       * @return  success  true if approval completes.
427       */
428     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
429         return erc20Impl.decreaseApprovalWithSender(msg.sender, _spender, _subtractedValue);
430     }
431 
432     /** @notice  Returns how much `_spender` is currently allowed to spend from
433       * `_owner`'s balance.
434       *
435       * @return  remaining  the remaining allowance.
436       */
437     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
438         return erc20Impl.allowance(_owner, _spender);
439     }
440 }
441 
442 
443 /** @title  ERC20 compliant token intermediary contract holding core logic.
444   *
445   * @notice  This contract serves as an intermediary between the exposed ERC20
446   * interface in ERC20Proxy and the store of balances in ERC20Store. This
447   * contract contains core logic that the proxy can delegate to
448   * and that the store is called by.
449   *
450   * @dev  This contract contains the core logic to implement the
451   * ERC20 specification as well as several extensions.
452   * 1. Changes to the token supply.
453   * 2. Batched transfers.
454   * 3. Relative changes to spending approvals.
455   * 4. Delegated transfer control ('sweeping').
456   *
457   * @author  Gemini Trust Company, LLC
458   */
459 contract ERC20Impl is CustodianUpgradeable {
460 
461     // TYPES
462     /// @dev  The struct type for pending increases to the token supply (print).
463     struct PendingPrint {
464         address receiver;
465         uint256 value;
466     }
467 
468     // MEMBERS
469     /// @dev  The reference to the proxy.
470     ERC20Proxy public erc20Proxy;
471 
472     /// @dev  The reference to the store.
473     ERC20Store public erc20Store;
474 
475     /// @dev  The sole authorized caller of delegated transfer control ('sweeping').
476     address public sweeper;
477 
478     /** @dev  The static message to be signed by an external account that
479       * signifies their permission to forward their balance to any arbitrary
480       * address. This is used to consolidate the control of all accounts
481       * backed by a shared keychain into the control of a single key.
482       * Initialized as the concatenation of the address of this contract
483       * and the word "sweep". This concatenation is done to prevent a replay
484       * attack in a subsequent contract, where the sweep message could
485       * potentially be replayed to re-enable sweeping ability.
486       */
487     bytes32 public sweepMsg;
488 
489     /** @dev  The mapping that stores whether the address in question has
490       * enabled sweeping its contents to another account or not.
491       * If an address maps to "true", it has already enabled sweeping,
492       * and thus does not need to re-sign the `sweepMsg` to enact the sweep.
493       */
494     mapping (address => bool) public sweptSet;
495 
496     /// @dev  The map of lock ids to pending token increases.
497     mapping (bytes32 => PendingPrint) public pendingPrintMap;
498 
499     // CONSTRUCTOR
500     function ERC20Impl(
501           address _erc20Proxy,
502           address _erc20Store,
503           address _custodian,
504           address _sweeper
505     )
506         CustodianUpgradeable(_custodian)
507         public
508     {
509         require(_sweeper != 0);
510         erc20Proxy = ERC20Proxy(_erc20Proxy);
511         erc20Store = ERC20Store(_erc20Store);
512 
513         sweeper = _sweeper;
514         sweepMsg = keccak256(address(this), "sweep");
515     }
516 
517     // MODIFIERS
518     modifier onlyProxy {
519         require(msg.sender == address(erc20Proxy));
520         _;
521     }
522     modifier onlySweeper {
523         require(msg.sender == sweeper);
524         _;
525     }
526 
527 
528     /** @notice  Core logic of the ERC20 `approve` function.
529       *
530       * @dev  This function can only be called by the referenced proxy,
531       * which has an `approve` function.
532       * Every argument passed to that function as well as the original
533       * `msg.sender` gets passed to this function.
534       * NOTE: approvals for the zero address (unspendable) are disallowed.
535       *
536       * @param  _sender  The address initiating the approval in proxy.
537       */
538     function approveWithSender(
539         address _sender,
540         address _spender,
541         uint256 _value
542     )
543         public
544         onlyProxy
545         returns (bool success)
546     {
547         require(_spender != address(0)); // disallow unspendable approvals
548         erc20Store.setAllowance(_sender, _spender, _value);
549         erc20Proxy.emitApproval(_sender, _spender, _value);
550         return true;
551     }
552 
553     /** @notice  Core logic of the `increaseApproval` function.
554       *
555       * @dev  This function can only be called by the referenced proxy,
556       * which has an `increaseApproval` function.
557       * Every argument passed to that function as well as the original
558       * `msg.sender` gets passed to this function.
559       * NOTE: approvals for the zero address (unspendable) are disallowed.
560       *
561       * @param  _sender  The address initiating the approval.
562       */
563     function increaseApprovalWithSender(
564         address _sender,
565         address _spender,
566         uint256 _addedValue
567     )
568         public
569         onlyProxy
570         returns (bool success)
571     {
572         require(_spender != address(0)); // disallow unspendable approvals
573         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
574         uint256 newAllowance = currentAllowance + _addedValue;
575 
576         require(newAllowance >= currentAllowance);
577 
578         erc20Store.setAllowance(_sender, _spender, newAllowance);
579         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
580         return true;
581     }
582 
583     /** @notice  Core logic of the `decreaseApproval` function.
584       *
585       * @dev  This function can only be called by the referenced proxy,
586       * which has a `decreaseApproval` function.
587       * Every argument passed to that function as well as the original
588       * `msg.sender` gets passed to this function.
589       * NOTE: approvals for the zero address (unspendable) are disallowed.
590       *
591       * @param  _sender  The address initiating the approval.
592       */
593     function decreaseApprovalWithSender(
594         address _sender,
595         address _spender,
596         uint256 _subtractedValue
597     )
598         public
599         onlyProxy
600         returns (bool success)
601     {
602         require(_spender != address(0)); // disallow unspendable approvals
603         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
604         uint256 newAllowance = currentAllowance - _subtractedValue;
605 
606         require(newAllowance <= currentAllowance);
607 
608         erc20Store.setAllowance(_sender, _spender, newAllowance);
609         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
610         return true;
611     }
612 
613     /** @notice  Requests an increase in the token supply, with the newly created
614       * tokens to be added to the balance of the specified account.
615       *
616       * @dev  Returns a unique lock id associated with the request.
617       * Anyone can call this function, but confirming the request is authorized
618       * by the custodian.
619       * NOTE: printing to the zero address is disallowed.
620       *
621       * @param  _receiver  The receiving address of the print, if confirmed.
622       * @param  _value  The number of tokens to add to the total supply and the
623       * balance of the receiving address, if confirmed.
624       *
625       * @return  lockId  A unique identifier for this request.
626       */
627     function requestPrint(address _receiver, uint256 _value) public returns (bytes32 lockId) {
628         require(_receiver != address(0));
629 
630         lockId = generateLockId();
631 
632         pendingPrintMap[lockId] = PendingPrint({
633             receiver: _receiver,
634             value: _value
635         });
636 
637         emit PrintingLocked(lockId, _receiver, _value);
638     }
639 
640     /** @notice  Confirms a pending increase in the token supply.
641       *
642       * @dev  When called by the custodian with a lock id associated with a
643       * pending increase, the amount requested to be printed in the print request
644       * is printed to the receiving address specified in that same request.
645       * NOTE: this function will not execute any print that would overflow the
646       * total supply, but it will not revert either.
647       *
648       * @param  _lockId  The identifier of a pending print request.
649       */
650     function confirmPrint(bytes32 _lockId) public onlyCustodian {
651         PendingPrint storage print = pendingPrintMap[_lockId];
652 
653         // reject ‘null’ results from the map lookup
654         // this can only be the case if an unknown `_lockId` is received
655         address receiver = print.receiver;
656         require (receiver != address(0));
657         uint256 value = print.value;
658 
659         delete pendingPrintMap[_lockId];
660 
661         uint256 supply = erc20Store.totalSupply();
662         uint256 newSupply = supply + value;
663         if (newSupply >= supply) {
664           erc20Store.setTotalSupply(newSupply);
665           erc20Store.addBalance(receiver, value);
666 
667           emit PrintingConfirmed(_lockId, receiver, value);
668           erc20Proxy.emitTransfer(address(0), receiver, value);
669         }
670     }
671 
672     /** @notice  Burns the specified value from the sender's balance.
673       *
674       * @dev  Sender's balanced is subtracted by the amount they wish to burn.
675       *
676       * @param  _value  The amount to burn.
677       *
678       * @return  success  true if the burn succeeded.
679       */
680     function burn(uint256 _value) public returns (bool success) {
681         uint256 balanceOfSender = erc20Store.balances(msg.sender);
682         require(_value <= balanceOfSender);
683 
684         erc20Store.setBalance(msg.sender, balanceOfSender - _value);
685         erc20Store.setTotalSupply(erc20Store.totalSupply() - _value);
686 
687         erc20Proxy.emitTransfer(msg.sender, address(0), _value);
688 
689         return true;
690     }
691 
692     /** @notice  A function for a sender to issue multiple transfers to multiple
693       * different addresses at once. This function is implemented for gas
694       * considerations when someone wishes to transfer, as one transaction is
695       * cheaper than issuing several distinct individual `transfer` transactions.
696       *
697       * @dev  By specifying a set of destination addresses and values, the
698       * sender can issue one transaction to transfer multiple amounts to
699       * distinct addresses, rather than issuing each as a separate
700       * transaction. The `_tos` and `_values` arrays must be equal length, and
701       * an index in one array corresponds to the same index in the other array
702       * (e.g. `_tos[0]` will receive `_values[0]`, `_tos[1]` will receive
703       * `_values[1]`, and so on.)
704       * NOTE: transfers to the zero address are disallowed.
705       *
706       * @param  _tos  The destination addresses to receive the transfers.
707       * @param  _values  The values for each destination address.
708       * @return  success  If transfers succeeded.
709       */
710     function batchTransfer(address[] _tos, uint256[] _values) public returns (bool success) {
711         require(_tos.length == _values.length);
712 
713         uint256 numTransfers = _tos.length;
714         uint256 senderBalance = erc20Store.balances(msg.sender);
715 
716         for (uint256 i = 0; i < numTransfers; i++) {
717           address to = _tos[i];
718           require(to != address(0));
719           uint256 v = _values[i];
720           require(senderBalance >= v);
721 
722           if (msg.sender != to) {
723             senderBalance -= v;
724             erc20Store.addBalance(to, v);
725           }
726           erc20Proxy.emitTransfer(msg.sender, to, v);
727         }
728 
729         erc20Store.setBalance(msg.sender, senderBalance);
730 
731         return true;
732     }
733 
734     /** @notice  Enables the delegation of transfer control for many
735       * accounts to the sweeper account, transferring any balances
736       * as well to the given destination.
737       *
738       * @dev  An account delegates transfer control by signing the
739       * value of `sweepMsg`. The sweeper account is the only authorized
740       * caller of this function, so it must relay signatures on behalf
741       * of accounts that delegate transfer control to it. Enabling
742       * delegation is idempotent and permanent. If the account has a
743       * balance at the time of enabling delegation, its balance is
744       * also transfered to the given destination account `_to`.
745       * NOTE: transfers to the zero address are disallowed.
746       *
747       * @param  _vs  The array of recovery byte components of the ECDSA signatures.
748       * @param  _rs  The array of 'R' components of the ECDSA signatures.
749       * @param  _ss  The array of 'S' components of the ECDSA signatures.
750       * @param  _to  The destination for swept balances.
751       */
752     function enableSweep(uint8[] _vs, bytes32[] _rs, bytes32[] _ss, address _to) public onlySweeper {
753         require(_to != address(0));
754         require((_vs.length == _rs.length) && (_vs.length == _ss.length));
755 
756         uint256 numSignatures = _vs.length;
757         uint256 sweptBalance = 0;
758 
759         for (uint256 i=0; i<numSignatures; ++i) {
760           address from = ecrecover(sweepMsg, _vs[i], _rs[i], _ss[i]);
761 
762           // ecrecover returns 0 on malformed input
763           if (from != address(0)) {
764             sweptSet[from] = true;
765 
766             uint256 fromBalance = erc20Store.balances(from);
767 
768             if (fromBalance > 0) {
769               sweptBalance += fromBalance;
770 
771               erc20Store.setBalance(from, 0);
772 
773               erc20Proxy.emitTransfer(from, _to, fromBalance);
774             }
775           }
776         }
777 
778         if (sweptBalance > 0) {
779           erc20Store.addBalance(_to, sweptBalance);
780         }
781     }
782 
783     /** @notice  For accounts that have delegated, transfer control
784       * to the sweeper, this function transfers their balances to the given
785       * destination.
786       *
787       * @dev The sweeper account is the only authorized caller of
788       * this function. This function accepts an array of addresses to have their
789       * balances transferred for gas efficiency purposes.
790       * NOTE: any address for an account that has not been previously enabled
791       * will be ignored.
792       * NOTE: transfers to the zero address are disallowed.
793       *
794       * @param  _froms  The addresses to have their balances swept.
795       * @param  _to  The destination address of all these transfers.
796       */
797     function replaySweep(address[] _froms, address _to) public onlySweeper {
798         require(_to != address(0));
799         uint256 lenFroms = _froms.length;
800         uint256 sweptBalance = 0;
801 
802         for (uint256 i=0; i<lenFroms; ++i) {
803             address from = _froms[i];
804 
805             if (sweptSet[from]) {
806                 uint256 fromBalance = erc20Store.balances(from);
807 
808                 if (fromBalance > 0) {
809                     sweptBalance += fromBalance;
810 
811                     erc20Store.setBalance(from, 0);
812 
813                     erc20Proxy.emitTransfer(from, _to, fromBalance);
814                 }
815             }
816         }
817 
818         if (sweptBalance > 0) {
819             erc20Store.addBalance(_to, sweptBalance);
820         }
821     }
822 
823     /** @notice  Core logic of the ERC20 `transferFrom` function.
824       *
825       * @dev  This function can only be called by the referenced proxy,
826       * which has a `transferFrom` function.
827       * Every argument passed to that function as well as the original
828       * `msg.sender` gets passed to this function.
829       * NOTE: transfers to the zero address are disallowed.
830       *
831       * @param  _sender  The address initiating the transfer in proxy.
832       */
833     function transferFromWithSender(
834         address _sender,
835         address _from,
836         address _to,
837         uint256 _value
838     )
839         public
840         onlyProxy
841         returns (bool success)
842     {
843         require(_to != address(0)); // ensure burn is the cannonical transfer to 0x0
844 
845         uint256 balanceOfFrom = erc20Store.balances(_from);
846         require(_value <= balanceOfFrom);
847 
848         uint256 senderAllowance = erc20Store.allowed(_from, _sender);
849         require(_value <= senderAllowance);
850 
851         erc20Store.setBalance(_from, balanceOfFrom - _value);
852         erc20Store.addBalance(_to, _value);
853 
854         erc20Store.setAllowance(_from, _sender, senderAllowance - _value);
855 
856         erc20Proxy.emitTransfer(_from, _to, _value);
857 
858         return true;
859     }
860 
861     /** @notice  Core logic of the ERC20 `transfer` function.
862       *
863       * @dev  This function can only be called by the referenced proxy,
864       * which has a `transfer` function.
865       * Every argument passed to that function as well as the original
866       * `msg.sender` gets passed to this function.
867       * NOTE: transfers to the zero address are disallowed.
868       *
869       * @param  _sender  The address initiating the transfer in proxy.
870       */
871     function transferWithSender(
872         address _sender,
873         address _to,
874         uint256 _value
875     )
876         public
877         onlyProxy
878         returns (bool success)
879     {
880         require(_to != address(0)); // ensure burn is the cannonical transfer to 0x0
881 
882         uint256 balanceOfSender = erc20Store.balances(_sender);
883         require(_value <= balanceOfSender);
884 
885         erc20Store.setBalance(_sender, balanceOfSender - _value);
886         erc20Store.addBalance(_to, _value);
887 
888         erc20Proxy.emitTransfer(_sender, _to, _value);
889 
890         return true;
891     }
892 
893     // METHODS (ERC20 sub interface impl.)
894     /// @notice  Core logic of the ERC20 `totalSupply` function.
895     function totalSupply() public view returns (uint256) {
896         return erc20Store.totalSupply();
897     }
898 
899     /// @notice  Core logic of the ERC20 `balanceOf` function.
900     function balanceOf(address _owner) public view returns (uint256 balance) {
901         return erc20Store.balances(_owner);
902     }
903 
904     /// @notice  Core logic of the ERC20 `allowance` function.
905     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
906         return erc20Store.allowed(_owner, _spender);
907     }
908 
909     // EVENTS
910     /// @dev  Emitted by successful `requestPrint` calls.
911     event PrintingLocked(bytes32 _lockId, address _receiver, uint256 _value);
912     /// @dev Emitted by successful `confirmPrint` calls.
913     event PrintingConfirmed(bytes32 _lockId, address _receiver, uint256 _value);
914 }
915 
916 
917 /** @title  ERC20 compliant token balance store.
918   *
919   * @notice  This contract serves as the store of balances, allowances, and
920   * supply for the ERC20 compliant token. No business logic exists here.
921   *
922   * @dev  This contract contains no business logic and instead
923   * is the final destination for any change in balances, allowances, or token
924   * supply. This contract is upgradeable in the sense that its custodian can
925   * update the `erc20Impl` address, thus redirecting the source of logic that
926   * determines how the balances will be updated.
927   *
928   * @author  Gemini Trust Company, LLC
929   */
930 contract ERC20Store is ERC20ImplUpgradeable {
931 
932     // MEMBERS
933     /// @dev  The total token supply.
934     uint256 public totalSupply;
935 
936     /// @dev  The mapping of balances.
937     mapping (address => uint256) public balances;
938 
939     /// @dev  The mapping of allowances.
940     mapping (address => mapping (address => uint256)) public allowed;
941 
942     // CONSTRUCTOR
943     function ERC20Store(address _custodian) ERC20ImplUpgradeable(_custodian) public {
944         totalSupply = 0;
945     }
946 
947 
948     // PUBLIC FUNCTIONS
949     // (ERC20 Ledger)
950 
951     /** @notice  The function to set the total supply of tokens.
952       *
953       * @dev  Intended for use by token implementation functions
954       * that update the total supply. The only authorized caller
955       * is the active implementation.
956       *
957       * @param _newTotalSupply the value to set as the new total supply
958       */
959     function setTotalSupply(
960         uint256 _newTotalSupply
961     )
962         public
963         onlyImpl
964     {
965         totalSupply = _newTotalSupply;
966     }
967 
968     /** @notice  Sets how much `_owner` allows `_spender` to transfer on behalf
969       * of `_owner`.
970       *
971       * @dev  Intended for use by token implementation functions
972       * that update spending allowances. The only authorized caller
973       * is the active implementation.
974       *
975       * @param  _owner  The account that will allow an on-behalf-of spend.
976       * @param  _spender  The account that will spend on behalf of the owner.
977       * @param  _value  The limit of what can be spent.
978       */
979     function setAllowance(
980         address _owner,
981         address _spender,
982         uint256 _value
983     )
984         public
985         onlyImpl
986     {
987         allowed[_owner][_spender] = _value;
988     }
989 
990     /** @notice  Sets the balance of `_owner` to `_newBalance`.
991       *
992       * @dev  Intended for use by token implementation functions
993       * that update balances. The only authorized caller
994       * is the active implementation.
995       *
996       * @param  _owner  The account that will hold a new balance.
997       * @param  _newBalance  The balance to set.
998       */
999     function setBalance(
1000         address _owner,
1001         uint256 _newBalance
1002     )
1003         public
1004         onlyImpl
1005     {
1006         balances[_owner] = _newBalance;
1007     }
1008 
1009     /** @notice Adds `_balanceIncrease` to `_owner`'s balance.
1010       *
1011       * @dev  Intended for use by token implementation functions
1012       * that update balances. The only authorized caller
1013       * is the active implementation.
1014       * WARNING: the caller is responsible for preventing overflow.
1015       *
1016       * @param  _owner  The account that will hold a new balance.
1017       * @param  _balanceIncrease  The balance to add.
1018       */
1019     function addBalance(
1020         address _owner,
1021         uint256 _balanceIncrease
1022     )
1023         public
1024         onlyImpl
1025     {
1026         balances[_owner] = balances[_owner] + _balanceIncrease;
1027     }
1028 }