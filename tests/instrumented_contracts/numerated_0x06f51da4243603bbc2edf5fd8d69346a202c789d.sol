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
11   */
12 contract LockRequestable {
13 
14     // MEMBERS
15     /// @notice  the count of all invocations of `generateLockId`.
16     uint256 public lockRequestCount;
17 
18     // CONSTRUCTOR
19     function LockRequestable() public {
20         lockRequestCount = 0;
21     }
22 
23     // FUNCTIONS
24     /** @notice  Returns a fresh unique identifier.
25       *
26       * @dev the generation scheme uses three components.
27       * First, the blockhash of the previous block.
28       * Second, the deployed address.
29       * Third, the next value of the counter.
30       * This ensure that identifiers are unique across all contracts
31       * following this scheme, and that future identifiers are
32       * unpredictable.
33       *
34       * @return a 32-byte unique identifier.
35       */
36     function generateLockId() internal returns (bytes32 lockId) {
37         return keccak256(block.blockhash(block.number - 1), address(this), ++lockRequestCount);
38     }
39 }
40 
41 
42 /** @title  A contract to inherit upgradeable custodianship.
43   *
44   * @notice  A contract that provides re-usable code for upgradeable
45   * custodianship. That custodian may be an account or another contract.
46   *
47   * @dev  This contract is intended to be inherited by any contract
48   * requiring a custodian to control some aspect of its functionality.
49   * This contract provides the mechanism for that custodianship to be
50   * passed from one custodian to the next.
51   */
52 contract CustodianUpgradeable is LockRequestable {
53 
54     // TYPES
55     /// @dev  The struct type for pending custodian changes.
56     struct CustodianChangeRequest {
57         address proposedNew;
58     }
59 
60     // MEMBERS
61     /// @dev  The address of the account or contract that acts as the custodian.
62     address public custodian;
63 
64     /// @dev  The map of lock ids to pending custodian changes.
65     mapping (bytes32 => CustodianChangeRequest) public custodianChangeReqs;
66 
67     // CONSTRUCTOR
68     function CustodianUpgradeable(
69         address _custodian
70     )
71       LockRequestable()
72       public
73     {
74         custodian = _custodian;
75     }
76 
77     // MODIFIERS
78     modifier onlyCustodian {
79         require(msg.sender == custodian);
80         _;
81     }
82 
83     // PUBLIC FUNCTIONS
84     // (UPGRADE)
85 
86     /** @notice  Requests a change of the custodian associated with this contract.
87       *
88       * @dev  Returns a unique lock id associated with the request.
89       * Anyone can call this function, but confirming the request is authorized
90       * by the custodian.
91       *
92       * @param  _proposedCustodian  The address of the new custodian.
93       * @return  lockId  A unique identifier for this request.
94       */
95     function requestCustodianChange(address _proposedCustodian) public returns (bytes32 lockId) {
96         require(_proposedCustodian != address(0));
97 
98         lockId = generateLockId();
99 
100         custodianChangeReqs[lockId] = CustodianChangeRequest({
101             proposedNew: _proposedCustodian
102         });
103 
104         emit CustodianChangeRequested(lockId, msg.sender, _proposedCustodian);
105     }
106 
107     /** @notice  Confirms a pending change of the custodian associated with this contract.
108       *
109       * @dev  When called by the current custodian with a lock id associated with a
110       * pending custodian change, the `address custodian` member will be updated with the
111       * requested address.
112       *
113       * @param  _lockId  The identifier of a pending change request.
114       */
115     function confirmCustodianChange(bytes32 _lockId) public onlyCustodian {
116         custodian = getCustodianChangeReq(_lockId);
117 
118         delete custodianChangeReqs[_lockId];
119 
120         emit CustodianChangeConfirmed(_lockId, custodian);
121     }
122 
123     // PRIVATE FUNCTIONS
124     function getCustodianChangeReq(bytes32 _lockId) private view returns (address _proposedNew) {
125         CustodianChangeRequest storage changeRequest = custodianChangeReqs[_lockId];
126 
127         // reject ‘null’ results from the map lookup
128         // this can only be the case if an unknown `_lockId` is received
129         require(changeRequest.proposedNew != 0);
130 
131         return changeRequest.proposedNew;
132     }
133 
134     /// @dev  Emitted by successful `requestCustodianChange` calls.
135     event CustodianChangeRequested(
136         bytes32 _lockId,
137         address _msgSender,
138         address _proposedCustodian
139     );
140 
141     /// @dev Emitted by successful `confirmCustodianChange` calls.
142     event CustodianChangeConfirmed(bytes32 _lockId, address _newCustodian);
143 }
144 
145 
146 /** @title  A contract to inherit upgradeable token implementations.
147   *
148   * @notice  A contract that provides re-usable code for upgradeable
149   * token implementations. It itself inherits from `CustodianUpgradable`
150   * as the upgrade process is controlled by the custodian.
151   *
152   * @dev  This contract is intended to be inherited by any contract
153   * requiring a reference to the active token implementation, either
154   * to delegate calls to it, or authorize calls from it. This contract
155   * provides the mechanism for that implementation to be be replaced,
156   * which constitutes an implementation upgrade.
157   */
158 contract ERC20ImplUpgradeable is CustodianUpgradeable  {
159 
160     // TYPES
161     /// @dev  The struct type for pending implementation changes.
162     struct ImplChangeRequest {
163         address proposedNew;
164     }
165 
166     // MEMBERS
167     // @dev  The reference to the active token implementation.
168     ERC20Impl public erc20Impl;
169 
170     /// @dev  The map of lock ids to pending implementation changes.
171     mapping (bytes32 => ImplChangeRequest) public implChangeReqs;
172 
173     // CONSTRUCTOR
174     function ERC20ImplUpgradeable(address _custodian) CustodianUpgradeable(_custodian) public {
175         erc20Impl = ERC20Impl(0x0);
176     }
177 
178     // MODIFIERS
179     modifier onlyImpl {
180         require(msg.sender == address(erc20Impl));
181         _;
182     }
183 
184     // PUBLIC FUNCTIONS
185     // (UPGRADE)
186     /** @notice  Requests a change of the active implementation associated
187       * with this contract.
188       *
189       * @dev  Returns a unique lock id associated with the request.
190       * Anyone can call this function, but confirming the request is authorized
191       * by the custodian.
192       *
193       * @param  _proposedImpl  The address of the new active implementation.
194       * @return  lockId  A unique identifier for this request.
195       */
196     function requestImplChange(address _proposedImpl) public returns (bytes32 lockId) {
197         require(_proposedImpl != address(0));
198 
199         lockId = generateLockId();
200 
201         implChangeReqs[lockId] = ImplChangeRequest({
202             proposedNew: _proposedImpl
203         });
204 
205         emit ImplChangeRequested(lockId, msg.sender, _proposedImpl);
206     }
207 
208     /** @notice  Confirms a pending change of the active implementation
209       * associated with this contract.
210       *
211       * @dev  When called by the custodian with a lock id associated with a
212       * pending change, the `ERC20Impl erc20Impl` member will be updated
213       * with the requested address.
214       *
215       * @param  _lockId  The identifier of a pending change request.
216       */
217     function confirmImplChange(bytes32 _lockId) public onlyCustodian {
218         erc20Impl = getImplChangeReq(_lockId);
219 
220         delete implChangeReqs[_lockId];
221 
222         emit ImplChangeConfirmed(_lockId, address(erc20Impl));
223     }
224 
225     // PRIVATE FUNCTIONS
226     function getImplChangeReq(bytes32 _lockId) private view returns (ERC20Impl _proposedNew) {
227         ImplChangeRequest storage changeRequest = implChangeReqs[_lockId];
228 
229         // reject ‘null’ results from the map lookup
230         // this can only be the case if an unknown `_lockId` is received
231         require(changeRequest.proposedNew != address(0));
232 
233         return ERC20Impl(changeRequest.proposedNew);
234     }
235 
236     /// @dev  Emitted by successful `requestImplChange` calls.
237     event ImplChangeRequested(
238         bytes32 _lockId,
239         address _msgSender,
240         address _proposedImpl
241     );
242 
243     /// @dev Emitted by successful `confirmImplChange` calls.
244     event ImplChangeConfirmed(bytes32 _lockId, address _newImpl);
245 }
246 
247 
248 contract ERC20Interface {
249   // METHODS
250 
251   // NOTE:
252   //   public getter functions are not currently recognised as an
253   //   implementation of the matching abstract function by the compiler.
254 
255   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#name
256   // function name() public view returns (string);
257 
258   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#symbol
259   // function symbol() public view returns (string);
260 
261   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#totalsupply
262   // function decimals() public view returns (uint8);
263 
264   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#totalsupply
265   function totalSupply() public view returns (uint256);
266 
267   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#balanceof
268   function balanceOf(address _owner) public view returns (uint256 balance);
269 
270   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer
271   function transfer(address _to, uint256 _value) public returns (bool success);
272 
273   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transferfrom
274   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
275 
276   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approve
277   function approve(address _spender, uint256 _value) public returns (bool success);
278 
279   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#allowance
280   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
281 
282   // EVENTS
283   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer-1
284   event Transfer(address indexed _from, address indexed _to, uint256 _value);
285 
286   // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approval
287   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
288 }
289 
290 
291 /** @title  Public interface to ERC20 compliant token.
292   *
293   * @notice  This contract is a permanent entry point to an ERC20 compliant
294   * system of contracts.
295   *
296   * @dev  This contract contains no business logic and instead
297   * delegates to an instance of ERC20Impl. This contract also has no storage
298   * that constitutes the operational state of the token. This contract is
299   * upgradeable in the sense that the `custodian` can update the
300   * `erc20Impl` address, thus redirecting the delegation of business logic.
301   * The `custodian` is also authorized to pass custodianship.
302   */
303 contract ERC20Proxy is ERC20Interface, ERC20ImplUpgradeable {
304 
305     // MEMBERS
306     /// @notice  Returns the name of the token.
307     string public name;
308 
309     /// @notice  Returns the symbol of the token.
310     string public symbol;
311 
312     /// @notice  Returns the number of decimals the token uses.
313     uint8 public decimals;
314 
315     // CONSTRUCTOR
316     function ERC20Proxy(
317         string _name,
318         string _symbol,
319         uint8 _decimals,
320         address _custodian
321     )
322         ERC20ImplUpgradeable(_custodian)
323         public
324     {
325         name = _name;
326         symbol = _symbol;
327         decimals = _decimals;
328     }
329 
330     // PUBLIC FUNCTIONS
331     // (ERC20Interface)
332     /** @notice  Returns the total token supply.
333       *
334       * @return  the total token supply.
335       */
336     function totalSupply() public view returns (uint256) {
337         return erc20Impl.totalSupply();
338     }
339 
340     /** @notice  Returns the account balance of another account with address
341       * `_owner`.
342       *
343       * @return  balance  the balance of account with address `_owner`.
344       */
345     function balanceOf(address _owner) public view returns (uint256 balance) {
346         return erc20Impl.balanceOf(_owner);
347     }
348 
349     /** @dev Internal use only.
350       */
351     function emitTransfer(address _from, address _to, uint256 _value) public onlyImpl {
352         emit Transfer(_from, _to, _value);
353     }
354 
355     /** @notice  Transfers `_value` amount of tokens to address `_to`.
356       *
357       * @dev Will fire the `Transfer` event. Will revert if the `_from`
358       * account balance does not have enough tokens to spend.
359       *
360       * @return  success  true if transfer completes.
361       */
362     function transfer(address _to, uint256 _value) public returns (bool success) {
363         return erc20Impl.transferWithSender(msg.sender, _to, _value);
364     }
365 
366     /** @notice  Transfers `_value` amount of tokens from address `_from`
367       * to address `_to`.
368       *
369       * @dev  Will fire the `Transfer` event. Will revert unless the `_from`
370       * account has deliberately authorized the sender of the message
371       * via some mechanism.
372       *
373       * @return  success  true if transfer completes.
374       */
375     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
376         return erc20Impl.transferFromWithSender(msg.sender, _from, _to, _value);
377     }
378 
379     /** @dev Internal use only.
380       */
381     function emitApproval(address _owner, address _spender, uint256 _value) public onlyImpl {
382         emit Approval(_owner, _spender, _value);
383     }
384 
385     /** @notice  Allows `_spender` to withdraw from your account multiple times,
386       * up to the `_value` amount. If this function is called again it
387       * overwrites the current allowance with _value.
388       *
389       * @dev  Will fire the `Approval` event.
390       *
391       * @return  success  true if approval completes.
392       */
393     function approve(address _spender, uint256 _value) public returns (bool success) {
394         return erc20Impl.approveWithSender(msg.sender, _spender, _value);
395     }
396 
397     /** @notice Increases the amount `_spender` is allowed to withdraw from
398       * your account.
399       * This function is implemented to avoid the race condition in standard
400       * ERC20 contracts surrounding the `approve` method.
401       *
402       * @dev  Will fire the `Approval` event. This function should be used instead of
403       * `approve`.
404       *
405       * @return  success  true if approval completes.
406       */
407     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
408         return erc20Impl.increaseApprovalWithSender(msg.sender, _spender, _addedValue);
409     }
410 
411     /** @notice  Decreases the amount `_spender` is allowed to withdraw from
412       * your account. This function is implemented to avoid the race
413       * condition in standard ERC20 contracts surrounding the `approve` method.
414       *
415       * @dev  Will fire the `Approval` event. This function should be used
416       * instead of `approve`.
417       *
418       * @return  success  true if approval completes.
419       */
420     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
421         return erc20Impl.decreaseApprovalWithSender(msg.sender, _spender, _subtractedValue);
422     }
423 
424     /** @notice  Returns how much `_spender` is currently allowed to spend from
425       * `_owner`'s balance.
426       *
427       * @return  remaining  the remaining allowance.
428       */
429     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
430         return erc20Impl.allowance(_owner, _spender);
431     }
432 }
433 
434 
435 /** @title  ERC20 compliant token intermediary contract holding core logic.
436   *
437   * @notice  This contract serves as an intermediary between the exposed ERC20
438   * interface in ERC20Proxy and the store of balances in ERC20Store. This
439   * contract contains core logic that the proxy can delegate to
440   * and that the store is called by.
441   *
442   * @dev  This contract contains the core logic to implement the
443   * ERC20 specification as well as several extensions.
444   * 1. Changes to the token supply.
445   * 2. Batched transfers.
446   * 3. Relative changes to spending approvals.
447   * 4. Delegated transfer control ('sweeping').
448   */
449 contract ERC20Impl is CustodianUpgradeable {
450 
451     // TYPES
452     /// @dev  The struct type for pending increases to the token supply (print).
453     struct PendingPrint {
454         address receiver;
455         uint256 value;
456     }
457 
458     // MEMBERS
459     /// @dev  The reference to the proxy.
460     ERC20Proxy public erc20Proxy;
461 
462     /// @dev  The reference to the store.
463     ERC20Store public erc20Store;
464 
465     /// @dev  The sole authorized caller of delegated transfer control ('sweeping').
466     address public sweeper;
467 
468     /** @dev  The static message to be signed by an external account that
469       * signifies their permission to forward their balance to any arbitrary
470       * address. This is used to consolidate the control of all accounts
471       * backed by a shared keychain into the control of a single key.
472       * Initialized as the concatenation of the address of this contract
473       * and the word "sweep". This concatenation is done to prevent a replay
474       * attack in a subsequent contract, where the sweep message could
475       * potentially be replayed to re-enable sweeping ability.
476       */
477     bytes32 public sweepMsg;
478 
479     /** @dev  The mapping that stores whether the address in question has
480       * enabled sweeping its contents to another account or not.
481       * If an address maps to "true", it has already enabled sweeping,
482       * and thus does not need to re-sign the `sweepMsg` to enact the sweep.
483       */
484     mapping (address => bool) public sweptSet;
485 
486     /// @dev  The map of lock ids to pending token increases.
487     mapping (bytes32 => PendingPrint) public pendingPrintMap;
488 
489     // CONSTRUCTOR
490     function ERC20Impl(
491           address _erc20Proxy,
492           address _erc20Store,
493           address _custodian,
494           address _sweeper
495     )
496         CustodianUpgradeable(_custodian)
497         public
498     {
499         require(_sweeper != 0);
500         erc20Proxy = ERC20Proxy(_erc20Proxy);
501         erc20Store = ERC20Store(_erc20Store);
502 
503         sweeper = _sweeper;
504         sweepMsg = keccak256(address(this), "sweep");
505     }
506 
507     // MODIFIERS
508     modifier onlyProxy {
509         require(msg.sender == address(erc20Proxy));
510         _;
511     }
512     modifier onlySweeper {
513         require(msg.sender == sweeper);
514         _;
515     }
516 
517 
518     /** @notice  Core logic of the ERC20 `approve` function.
519       *
520       * @dev  This function can only be called by the referenced proxy,
521       * which has an `approve` function.
522       * Every argument passed to that function as well as the original
523       * `msg.sender` gets passed to this function.
524       * NOTE: approvals for the zero address (unspendable) are disallowed.
525       *
526       * @param  _sender  The address initiating the approval in proxy.
527       */
528     function approveWithSender(
529         address _sender,
530         address _spender,
531         uint256 _value
532     )
533         public
534         onlyProxy
535         returns (bool success)
536     {
537         require(_spender != address(0)); // disallow unspendable approvals
538         erc20Store.setAllowance(_sender, _spender, _value);
539         erc20Proxy.emitApproval(_sender, _spender, _value);
540         return true;
541     }
542 
543     /** @notice  Core logic of the `increaseApproval` function.
544       *
545       * @dev  This function can only be called by the referenced proxy,
546       * which has an `increaseApproval` function.
547       * Every argument passed to that function as well as the original
548       * `msg.sender` gets passed to this function.
549       * NOTE: approvals for the zero address (unspendable) are disallowed.
550       *
551       * @param  _sender  The address initiating the approval.
552       */
553     function increaseApprovalWithSender(
554         address _sender,
555         address _spender,
556         uint256 _addedValue
557     )
558         public
559         onlyProxy
560         returns (bool success)
561     {
562         require(_spender != address(0)); // disallow unspendable approvals
563         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
564         uint256 newAllowance = currentAllowance + _addedValue;
565 
566         require(newAllowance >= currentAllowance);
567 
568         erc20Store.setAllowance(_sender, _spender, newAllowance);
569         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
570         return true;
571     }
572 
573     /** @notice  Core logic of the `decreaseApproval` function.
574       *
575       * @dev  This function can only be called by the referenced proxy,
576       * which has a `decreaseApproval` function.
577       * Every argument passed to that function as well as the original
578       * `msg.sender` gets passed to this function.
579       * NOTE: approvals for the zero address (unspendable) are disallowed.
580       *
581       * @param  _sender  The address initiating the approval.
582       */
583     function decreaseApprovalWithSender(
584         address _sender,
585         address _spender,
586         uint256 _subtractedValue
587     )
588         public
589         onlyProxy
590         returns (bool success)
591     {
592         require(_spender != address(0)); // disallow unspendable approvals
593         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
594         uint256 newAllowance = currentAllowance - _subtractedValue;
595 
596         require(newAllowance <= currentAllowance);
597 
598         erc20Store.setAllowance(_sender, _spender, newAllowance);
599         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
600         return true;
601     }
602 
603     /** @notice  Requests an increase in the token supply, with the newly created
604       * tokens to be added to the balance of the specified account.
605       *
606       * @dev  Returns a unique lock id associated with the request.
607       * Anyone can call this function, but confirming the request is authorized
608       * by the custodian.
609       * NOTE: printing to the zero address is disallowed.
610       *
611       * @param  _receiver  The receiving address of the print, if confirmed.
612       * @param  _value  The number of tokens to add to the total supply and the
613       * balance of the receiving address, if confirmed.
614       *
615       * @return  lockId  A unique identifier for this request.
616       */
617     function requestPrint(address _receiver, uint256 _value) public returns (bytes32 lockId) {
618         require(_receiver != address(0));
619 
620         lockId = generateLockId();
621 
622         pendingPrintMap[lockId] = PendingPrint({
623             receiver: _receiver,
624             value: _value
625         });
626 
627         emit PrintingLocked(lockId, _receiver, _value);
628     }
629 
630     /** @notice  Confirms a pending increase in the token supply.
631       *
632       * @dev  When called by the custodian with a lock id associated with a
633       * pending increase, the amount requested to be printed in the print request
634       * is printed to the receiving address specified in that same request.
635       * NOTE: this function will not execute any print that would overflow the
636       * total supply, but it will not revert either.
637       *
638       * @param  _lockId  The identifier of a pending print request.
639       */
640     function confirmPrint(bytes32 _lockId) public onlyCustodian {
641         PendingPrint storage print = pendingPrintMap[_lockId];
642 
643         // reject ‘null’ results from the map lookup
644         // this can only be the case if an unknown `_lockId` is received
645         address receiver = print.receiver;
646         require (receiver != address(0));
647         uint256 value = print.value;
648 
649         delete pendingPrintMap[_lockId];
650 
651         uint256 supply = erc20Store.totalSupply();
652         uint256 newSupply = supply + value;
653         if (newSupply >= supply) {
654           erc20Store.setTotalSupply(newSupply);
655           erc20Store.addBalance(receiver, value);
656 
657           emit PrintingConfirmed(_lockId, receiver, value);
658           erc20Proxy.emitTransfer(address(0), receiver, value);
659         }
660     }
661 
662     /** @notice  Burns the specified value from the sender's balance.
663       *
664       * @dev  Sender's balanced is subtracted by the amount they wish to burn.
665       *
666       * @param  _value  The amount to burn.
667       *
668       * @return  success  true if the burn succeeded.
669       */
670     function burn(uint256 _value) public returns (bool success) {
671         uint256 balanceOfSender = erc20Store.balances(msg.sender);
672         require(_value <= balanceOfSender);
673 
674         erc20Store.setBalance(msg.sender, balanceOfSender - _value);
675         erc20Store.setTotalSupply(erc20Store.totalSupply() - _value);
676 
677         erc20Proxy.emitTransfer(msg.sender, address(0), _value);
678 
679         return true;
680     }
681 
682     /** @notice  A function for a sender to issue multiple transfers to multiple
683       * different addresses at once. This function is implemented for gas
684       * considerations when someone wishes to transfer, as one transaction is
685       * cheaper than issuing several distinct individual `transfer` transactions.
686       *
687       * @dev  By specifying a set of destination addresses and values, the
688       * sender can issue one transaction to transfer multiple amounts to
689       * distinct addresses, rather than issuing each as a separate
690       * transaction. The `_tos` and `_values` arrays must be equal length, and
691       * an index in one array corresponds to the same index in the other array
692       * (e.g. `_tos[0]` will receive `_values[0]`, `_tos[1]` will receive
693       * `_values[1]`, and so on.)
694       * NOTE: transfers to the zero address are disallowed.
695       *
696       * @param  _tos  The destination addresses to receive the transfers.
697       * @param  _values  The values for each destination address.
698       * @return  success  If transfers succeeded.
699       */
700     function batchTransfer(address[] _tos, uint256[] _values) public returns (bool success) {
701         require(_tos.length == _values.length);
702 
703         uint256 numTransfers = _tos.length;
704         uint256 senderBalance = erc20Store.balances(msg.sender);
705 
706         for (uint256 i = 0; i < numTransfers; i++) {
707           address to = _tos[i];
708           require(to != address(0));
709           uint256 v = _values[i];
710           require(senderBalance >= v);
711 
712           if (msg.sender != to) {
713             senderBalance -= v;
714             erc20Store.addBalance(to, v);
715           }
716           erc20Proxy.emitTransfer(msg.sender, to, v);
717         }
718 
719         erc20Store.setBalance(msg.sender, senderBalance);
720 
721         return true;
722     }
723 
724     /** @notice  Enables the delegation of transfer control for many
725       * accounts to the sweeper account, transferring any balances
726       * as well to the given destination.
727       *
728       * @dev  An account delegates transfer control by signing the
729       * value of `sweepMsg`. The sweeper account is the only authorized
730       * caller of this function, so it must relay signatures on behalf
731       * of accounts that delegate transfer control to it. Enabling
732       * delegation is idempotent and permanent. If the account has a
733       * balance at the time of enabling delegation, its balance is
734       * also transfered to the given destination account `_to`.
735       * NOTE: transfers to the zero address are disallowed.
736       *
737       * @param  _vs  The array of recovery byte components of the ECDSA signatures.
738       * @param  _rs  The array of 'R' components of the ECDSA signatures.
739       * @param  _ss  The array of 'S' components of the ECDSA signatures.
740       * @param  _to  The destination for swept balances.
741       */
742     function enableSweep(uint8[] _vs, bytes32[] _rs, bytes32[] _ss, address _to) public onlySweeper {
743         require(_to != address(0));
744         require((_vs.length == _rs.length) && (_vs.length == _ss.length));
745 
746         uint256 numSignatures = _vs.length;
747         uint256 sweptBalance = 0;
748 
749         for (uint256 i=0; i<numSignatures; ++i) {
750           address from = ecrecover(sweepMsg, _vs[i], _rs[i], _ss[i]);
751 
752           // ecrecover returns 0 on malformed input
753           if (from != address(0)) {
754             sweptSet[from] = true;
755 
756             uint256 fromBalance = erc20Store.balances(from);
757 
758             if (fromBalance > 0) {
759               sweptBalance += fromBalance;
760 
761               erc20Store.setBalance(from, 0);
762 
763               erc20Proxy.emitTransfer(from, _to, fromBalance);
764             }
765           }
766         }
767 
768         if (sweptBalance > 0) {
769           erc20Store.addBalance(_to, sweptBalance);
770         }
771     }
772 
773     /** @notice  For accounts that have delegated, transfer control
774       * to the sweeper, this function transfers their balances to the given
775       * destination.
776       *
777       * @dev The sweeper account is the only authorized caller of
778       * this function. This function accepts an array of addresses to have their
779       * balances transferred for gas efficiency purposes.
780       * NOTE: any address for an account that has not been previously enabled
781       * will be ignored.
782       * NOTE: transfers to the zero address are disallowed.
783       *
784       * @param  _froms  The addresses to have their balances swept.
785       * @param  _to  The destination address of all these transfers.
786       */
787     function replaySweep(address[] _froms, address _to) public onlySweeper {
788         require(_to != address(0));
789         uint256 lenFroms = _froms.length;
790         uint256 sweptBalance = 0;
791 
792         for (uint256 i=0; i<lenFroms; ++i) {
793             address from = _froms[i];
794 
795             if (sweptSet[from]) {
796                 uint256 fromBalance = erc20Store.balances(from);
797 
798                 if (fromBalance > 0) {
799                     sweptBalance += fromBalance;
800 
801                     erc20Store.setBalance(from, 0);
802 
803                     erc20Proxy.emitTransfer(from, _to, fromBalance);
804                 }
805             }
806         }
807 
808         if (sweptBalance > 0) {
809             erc20Store.addBalance(_to, sweptBalance);
810         }
811     }
812 
813     /** @notice  Core logic of the ERC20 `transferFrom` function.
814       *
815       * @dev  This function can only be called by the referenced proxy,
816       * which has a `transferFrom` function.
817       * Every argument passed to that function as well as the original
818       * `msg.sender` gets passed to this function.
819       * NOTE: transfers to the zero address are disallowed.
820       *
821       * @param  _sender  The address initiating the transfer in proxy.
822       */
823     function transferFromWithSender(
824         address _sender,
825         address _from,
826         address _to,
827         uint256 _value
828     )
829         public
830         onlyProxy
831         returns (bool success)
832     {
833         require(_to != address(0)); // ensure burn is the cannonical transfer to 0x0
834 
835         uint256 balanceOfFrom = erc20Store.balances(_from);
836         require(_value <= balanceOfFrom);
837 
838         uint256 senderAllowance = erc20Store.allowed(_from, _sender);
839         require(_value <= senderAllowance);
840 
841         erc20Store.setBalance(_from, balanceOfFrom - _value);
842         erc20Store.addBalance(_to, _value);
843 
844         erc20Store.setAllowance(_from, _sender, senderAllowance - _value);
845 
846         erc20Proxy.emitTransfer(_from, _to, _value);
847 
848         return true;
849     }
850 
851     /** @notice  Core logic of the ERC20 `transfer` function.
852       *
853       * @dev  This function can only be called by the referenced proxy,
854       * which has a `transfer` function.
855       * Every argument passed to that function as well as the original
856       * `msg.sender` gets passed to this function.
857       * NOTE: transfers to the zero address are disallowed.
858       *
859       * @param  _sender  The address initiating the transfer in proxy.
860       */
861     function transferWithSender(
862         address _sender,
863         address _to,
864         uint256 _value
865     )
866         public
867         onlyProxy
868         returns (bool success)
869     {
870         require(_to != address(0)); // ensure burn is the cannonical transfer to 0x0
871 
872         uint256 balanceOfSender = erc20Store.balances(_sender);
873         require(_value <= balanceOfSender);
874 
875         erc20Store.setBalance(_sender, balanceOfSender - _value);
876         erc20Store.addBalance(_to, _value);
877 
878         erc20Proxy.emitTransfer(_sender, _to, _value);
879 
880         return true;
881     }
882 
883     // METHODS (ERC20 sub interface impl.)
884     /// @notice  Core logic of the ERC20 `totalSupply` function.
885     function totalSupply() public view returns (uint256) {
886         return erc20Store.totalSupply();
887     }
888 
889     /// @notice  Core logic of the ERC20 `balanceOf` function.
890     function balanceOf(address _owner) public view returns (uint256 balance) {
891         return erc20Store.balances(_owner);
892     }
893 
894     /// @notice  Core logic of the ERC20 `allowance` function.
895     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
896         return erc20Store.allowed(_owner, _spender);
897     }
898 
899     // EVENTS
900     /// @dev  Emitted by successful `requestPrint` calls.
901     event PrintingLocked(bytes32 _lockId, address _receiver, uint256 _value);
902     /// @dev Emitted by successful `confirmPrint` calls.
903     event PrintingConfirmed(bytes32 _lockId, address _receiver, uint256 _value);
904 }
905 
906 
907 /** @title  ERC20 compliant token balance store.
908   *
909   * @notice  This contract serves as the store of balances, allowances, and
910   * supply for the ERC20 compliant token. No business logic exists here.
911   *
912   * @dev  This contract contains no business logic and instead
913   * is the final destination for any change in balances, allowances, or token
914   * supply. This contract is upgradeable in the sense that its custodian can
915   * update the `erc20Impl` address, thus redirecting the source of logic that
916   * determines how the balances will be updated.
917   */
918 contract ERC20Store is ERC20ImplUpgradeable {
919 
920     // MEMBERS
921     /// @dev  The total token supply.
922     uint256 public totalSupply;
923 
924     /// @dev  The mapping of balances.
925     mapping (address => uint256) public balances;
926 
927     /// @dev  The mapping of allowances.
928     mapping (address => mapping (address => uint256)) public allowed;
929 
930     // CONSTRUCTOR
931     function ERC20Store(address _custodian) ERC20ImplUpgradeable(_custodian) public {
932         totalSupply = 0;
933     }
934 
935 
936     // PUBLIC FUNCTIONS
937     // (ERC20 Ledger)
938 
939     /** @notice  The function to set the total supply of tokens.
940       *
941       * @dev  Intended for use by token implementation functions
942       * that update the total supply. The only authorized caller
943       * is the active implementation.
944       *
945       * @param _newTotalSupply the value to set as the new total supply
946       */
947     function setTotalSupply(
948         uint256 _newTotalSupply
949     )
950         public
951         onlyImpl
952     {
953         totalSupply = _newTotalSupply;
954     }
955 
956     /** @notice  Sets how much `_owner` allows `_spender` to transfer on behalf
957       * of `_owner`.
958       *
959       * @dev  Intended for use by token implementation functions
960       * that update spending allowances. The only authorized caller
961       * is the active implementation.
962       *
963       * @param  _owner  The account that will allow an on-behalf-of spend.
964       * @param  _spender  The account that will spend on behalf of the owner.
965       * @param  _value  The limit of what can be spent.
966       */
967     function setAllowance(
968         address _owner,
969         address _spender,
970         uint256 _value
971     )
972         public
973         onlyImpl
974     {
975         allowed[_owner][_spender] = _value;
976     }
977 
978     /** @notice  Sets the balance of `_owner` to `_newBalance`.
979       *
980       * @dev  Intended for use by token implementation functions
981       * that update balances. The only authorized caller
982       * is the active implementation.
983       *
984       * @param  _owner  The account that will hold a new balance.
985       * @param  _newBalance  The balance to set.
986       */
987     function setBalance(
988         address _owner,
989         uint256 _newBalance
990     )
991         public
992         onlyImpl
993     {
994         balances[_owner] = _newBalance;
995     }
996 
997     /** @notice Adds `_balanceIncrease` to `_owner`'s balance.
998       *
999       * @dev  Intended for use by token implementation functions
1000       * that update balances. The only authorized caller
1001       * is the active implementation.
1002       * WARNING: the caller is responsible for preventing overflow.
1003       *
1004       * @param  _owner  The account that will hold a new balance.
1005       * @param  _balanceIncrease  The balance to add.
1006       */
1007     function addBalance(
1008         address _owner,
1009         uint256 _balanceIncrease
1010     )
1011         public
1012         onlyImpl
1013     {
1014         balances[_owner] = balances[_owner] + _balanceIncrease;
1015     }
1016 }
1017 
1018 /** @title  A contact to govern hybrid control over increases to the token supply.
1019   *
1020   * @notice  A contract that acts as a custodian of the active token
1021   * implementation, and an intermediary between it and the ‘true’ custodian.
1022   * It preserves the functionality of direct custodianship as well as granting
1023   * limited control of token supply increases to an additional key.
1024   *
1025   * @dev  This contract is a layer of indirection between an instance of
1026   * ERC20Impl and a custodian. The functionality of the custodianship over
1027   * the token implementation is preserved (printing and custodian changes),
1028   * but this contract adds the ability for an additional key
1029   * (the 'limited printer') to increase the token supply up to a ceiling,
1030   * and this supply ceiling can only be raised by the custodian.
1031   */
1032 contract PrintLimiter is LockRequestable {
1033 
1034     // TYPES
1035     /// @dev The struct type for pending ceiling raises.
1036     struct PendingCeilingRaise {
1037         uint256 raiseBy;
1038     }
1039 
1040     // MEMBERS
1041     /// @dev  The reference to the active token implementation.
1042     ERC20Impl public erc20Impl;
1043 
1044     /// @dev  The address of the account or contract that acts as the custodian.
1045     address public custodian;
1046 
1047     /** @dev  The sole authorized caller of limited printing.
1048       * This account is also authorized to lower the supply ceiling.
1049       */
1050     address public limitedPrinter;
1051 
1052     /** @dev  The maximum that the token supply can be increased to
1053       * through use of the limited printing feature.
1054       * The difference between the current total supply and the supply
1055       * ceiling is what is available to the 'limited printer' account.
1056       * The value of the ceiling can only be increased by the custodian.
1057       */
1058     uint256 public totalSupplyCeiling;
1059 
1060     /// @dev  The map of lock ids to pending ceiling raises.
1061     mapping (bytes32 => PendingCeilingRaise) public pendingRaiseMap;
1062 
1063     // CONSTRUCTOR
1064     function PrintLimiter(
1065         address _erc20Impl,
1066         address _custodian,
1067         address _limitedPrinter,
1068         uint256 _initialCeiling
1069     )
1070         public
1071     {
1072         erc20Impl = ERC20Impl(_erc20Impl);
1073         custodian = _custodian;
1074         limitedPrinter = _limitedPrinter;
1075         totalSupplyCeiling = _initialCeiling;
1076     }
1077 
1078     // MODIFIERS
1079     modifier onlyCustodian {
1080         require(msg.sender == custodian);
1081         _;
1082     }
1083     modifier onlyLimitedPrinter {
1084         require(msg.sender == limitedPrinter);
1085         _;
1086     }
1087 
1088     /** @notice  Increases the token supply, with the newly created tokens
1089       * being added to the balance of the specified account.
1090       *
1091       * @dev  The function checks that the value to print does not
1092       * exceed the supply ceiling when added to the current total supply.
1093       * NOTE: printing to the zero address is disallowed.
1094       *
1095       * @param  _receiver  The receiving address of the print.
1096       * @param  _value  The number of tokens to add to the total supply and the
1097       * balance of the receiving address.
1098       */
1099     function limitedPrint(address _receiver, uint256 _value) public onlyLimitedPrinter {
1100         uint256 totalSupply = erc20Impl.totalSupply();
1101         uint256 newTotalSupply = totalSupply + _value;
1102 
1103         require(newTotalSupply >= totalSupply);
1104         require(newTotalSupply <= totalSupplyCeiling);
1105         erc20Impl.confirmPrint(erc20Impl.requestPrint(_receiver, _value));
1106     }
1107 
1108     /** @notice  Requests an increase to the supply ceiling.
1109       *
1110       * @dev  Returns a unique lock id associated with the request.
1111       * Anyone can call this function, but confirming the request is authorized
1112       * by the custodian.
1113       *
1114       * @param  _raiseBy  The amount by which to raise the ceiling.
1115       *
1116       * @return  lockId  A unique identifier for this request.
1117       */
1118     function requestCeilingRaise(uint256 _raiseBy) public returns (bytes32 lockId) {
1119         require(_raiseBy != 0);
1120 
1121         lockId = generateLockId();
1122 
1123         pendingRaiseMap[lockId] = PendingCeilingRaise({
1124             raiseBy: _raiseBy
1125         });
1126 
1127         emit CeilingRaiseLocked(lockId, _raiseBy);
1128     }
1129 
1130     /** @notice  Confirms a pending increase in the token supply.
1131       *
1132       * @dev  When called by the custodian with a lock id associated with a
1133       * pending ceiling increase, the amount requested is added to the
1134       * current supply ceiling.
1135       * NOTE: this function will not execute any raise that would overflow the
1136       * supply ceiling, but it will not revert either.
1137       *
1138       * @param  _lockId  The identifier of a pending ceiling raise request.
1139       */
1140     function confirmCeilingRaise(bytes32 _lockId) public onlyCustodian {
1141         PendingCeilingRaise storage pendingRaise = pendingRaiseMap[_lockId];
1142 
1143         // copy locals of references to struct members
1144         uint256 raiseBy = pendingRaise.raiseBy;
1145         // accounts for a gibberish _lockId
1146         require(raiseBy != 0);
1147 
1148         delete pendingRaiseMap[_lockId];
1149 
1150         uint256 newCeiling = totalSupplyCeiling + raiseBy;
1151         // overflow check
1152         if (newCeiling >= totalSupplyCeiling) {
1153             totalSupplyCeiling = newCeiling;
1154 
1155             emit CeilingRaiseConfirmed(_lockId, raiseBy, newCeiling);
1156         }
1157     }
1158 
1159     /** @notice  Lowers the supply ceiling, further constraining the bound of
1160       * what can be printed by the limited printer.
1161       *
1162       * @dev  The limited printer is the sole authorized caller of this function,
1163       * so it is the only account that can elect to lower its limit to increase
1164       * the token supply.
1165       *
1166       * @param  _lowerBy  The amount by which to lower the supply ceiling.
1167       */
1168     function lowerCeiling(uint256 _lowerBy) public onlyLimitedPrinter {
1169         uint256 newCeiling = totalSupplyCeiling - _lowerBy;
1170         // overflow check
1171         require(newCeiling <= totalSupplyCeiling);
1172         totalSupplyCeiling = newCeiling;
1173 
1174         emit CeilingLowered(_lowerBy, newCeiling);
1175     }
1176 
1177     /** @notice  Pass-through control of print confirmation, allowing this
1178       * contract's custodian to act as the custodian of the associated
1179       * active token implementation.
1180       *
1181       * @dev  This contract is the direct custodian of the active token
1182       * implementation, but this function allows this contract's custodian
1183       * to act as though it were the direct custodian of the active
1184       * token implementation. Therefore the custodian retains control of
1185       * unlimited printing.
1186       *
1187       * @param  _lockId  The identifier of a pending print request in
1188       * the associated active token implementation.
1189       */
1190     function confirmPrintProxy(bytes32 _lockId) public onlyCustodian {
1191         erc20Impl.confirmPrint(_lockId);
1192     }
1193 
1194     /** @notice  Pass-through control of custodian change confirmation,
1195       * allowing this contract's custodian to act as the custodian of
1196       * the associated active token implementation.
1197       *
1198       * @dev  This contract is the direct custodian of the active token
1199       * implementation, but this function allows this contract's custodian
1200       * to act as though it were the direct custodian of the active
1201       * token implementation. Therefore the custodian retains control of
1202       * custodian changes.
1203       *
1204       * @param  _lockId  The identifier of a pending custodian change request
1205       * in the associated active token implementation.
1206       */
1207     function confirmCustodianChangeProxy(bytes32 _lockId) public onlyCustodian {
1208         erc20Impl.confirmCustodianChange(_lockId);
1209     }
1210 
1211     // EVENTS
1212     /// @dev  Emitted by successful `requestCeilingRaise` calls.
1213     event CeilingRaiseLocked(bytes32 _lockId, uint256 _raiseBy);
1214     /// @dev  Emitted by successful `confirmCeilingRaise` calls.
1215     event CeilingRaiseConfirmed(bytes32 _lockId, uint256 _raiseBy, uint256 _newCeiling);
1216 
1217     /// @dev  Emitted by successful `lowerCeiling` calls.
1218     event CeilingLowered(uint256 _lowerBy, uint256 _newCeiling);
1219 }