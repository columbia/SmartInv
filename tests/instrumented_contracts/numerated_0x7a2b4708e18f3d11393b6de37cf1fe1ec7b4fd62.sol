1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  *
7  * Subtraction and addition only here.
8  */
9 library SafeMath {
10 
11     /**
12      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
13      */
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         require(b <= a);
16         uint256 c = a - b;
17         return c;
18     }
19 
20     /**
21      * @dev Adds two unsigned integers, reverts on overflow.
22      */
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a);
26         return c;
27     }
28 }
29 
30 /**
31  * @title A contract for generating unique identifiers for any requests.
32  * @dev Any contract that supports requesting inherits this contract to
33  * ensure request to be unique.
34  */
35 contract RequestUid {
36 
37     /**
38      * MEMBER: counter for request.
39     */
40     uint256 public requestCount;
41 
42     /**
43      * CONSTRUCTOR: initial counter with 0.
44      */
45     constructor() public {
46         requestCount = 0;
47     }
48     
49     /**
50      * METHOD: generate a new identifier.
51      * @dev 3 parameters as inputs:
52      * 1. blockhash of previous block;
53      * 2. the address of the initialized contract which is requested;
54      * 3. the value of counter.
55      * @return a 32-byte uid.
56      */
57     function generateRequestUid() internal returns (bytes32 uid) {
58         return keccak256(abi.encodePacked(blockhash(block.number - uint256(1)), address(this), ++requestCount));
59     }
60 }
61 
62 /**
63  * @dev This contract makes the inheritor have the functionality if the
64  * inheritor authorize the admin.
65  */
66 contract AdminUpgradeable is RequestUid {
67     
68     /**
69      * Event
70      * @dev After requesting of admin change, emit an event.
71      */
72     event AdminChangeRequested(bytes32 _uid, address _msgSender, address _newAdmin);
73     
74     /**
75      * Event
76      * @dev After confirming a request of admin change, emit an event.
77      */
78     event AdminChangeConfirmed(bytes32 _uid, address _newAdmin);
79     
80     /**
81      * STRUCT: A struct defined to store an request of admin change.
82      */
83     struct AdminChangeRequest {
84         address newAdminAddress;
85     }
86     
87     /**
88      * MEMBER: admin address(account address or contract address) which
89      * is authorize by the inheritor.
90      */
91     address public admin;
92     
93     /**
94      * MEMBER: a list of requests submitted.
95      */
96     mapping (bytes32 => AdminChangeRequest) public adminChangeReqs;
97     
98     /**
99      * MODIFIER: The operations from admin is allowed only.
100      */
101     modifier adminOperations {
102         require(msg.sender == admin, "admin can call this method only");
103         _;
104     }
105     
106     /**
107      * CONSTRUCTOR: Initialize with an admin address.
108      */
109     constructor (address _admin) public RequestUid() {
110         admin = _admin;
111     }
112     
113     /**
114      * METHOD: Upgrade the admin ---- request.
115      * @dev Request changing the admin address authorized.
116      * Anyone can call this method to submit a request to change
117      * the admin address. It will be pending until admin address
118      * comfirming the request, and the admin changes.
119      * @param _newAdmin The address of new admin, account or contract.
120      * @return uid The unique id of the request.
121      */
122     function requestAdminChange(address _newAdmin) public returns (bytes32 uid) {
123         require(_newAdmin != address(0), "admin is not 0 address");
124 
125         uid = generateRequestUid();
126 
127         adminChangeReqs[uid] = AdminChangeRequest({
128             newAdminAddress: _newAdmin
129             });
130 
131         emit AdminChangeRequested(uid, msg.sender, _newAdmin);
132     }
133     
134     /**
135      * METHOD: Upgrade the admin ---- confirm.
136      * @dev Confirm a reqeust of admin change storing in the mapping
137      * of `adminChangeReqs`. The operation is authorized to the old
138      * admin only. The new admin will be authorized after the method
139      * called successfully.
140      * @param _uid The uid of request to change admin.
141      */
142     function confirmAdminChange(bytes32 _uid) public adminOperations {
143         admin = getAdminChangeReq(_uid);
144 
145         delete adminChangeReqs[_uid];
146 
147         emit AdminChangeConfirmed(_uid, admin);
148     }
149     
150     /**
151      * METHOD: Get the address of an admin request by uid.
152      * @dev It is a private method which gets address of an admin
153      * in the mapping `adminChangeReqs`
154      * @param _uid The uid of request to change admin.
155      * @return _newAdminAddress The address of new admin in the pending requests
156      */
157     function getAdminChangeReq(bytes32 _uid) private view returns (address _newAdminAddress) {
158         AdminChangeRequest storage changeRequest = adminChangeReqs[_uid];
159 
160         require(changeRequest.newAdminAddress != address(0));
161 
162         return changeRequest.newAdminAddress;
163     }
164 }
165 
166 /**
167  * @dev This is a contract which will be inherited by BICAProxy and BICALedger.
168  */
169 contract BICALogicUpgradeable is AdminUpgradeable  {
170 
171     /**
172      * Event
173      * @dev After requesting of logic contract address change, emit an event.
174      */
175     event LogicChangeRequested(bytes32 _uid, address _msgSender, address _newLogic);
176 
177     /**
178      * Event
179      * @dev After confirming a request of logic contract address change, emit an event.
180      */
181     event LogicChangeConfirmed(bytes32 _uid, address _newLogic);
182 
183     /**
184      * STRUCT: A struct defined to store an request of Logic contract address change.
185      */
186     struct LogicChangeRequest {
187         address newLogicAddress;
188     }
189 
190     /**
191      * MEMBER: BICALogic address(a contract address) which implements logics of token.
192      */
193     BICALogic public bicaLogic;
194 
195     /**
196      * MEMBER: a list of requests of logic change submitted
197      */
198     mapping (bytes32 => LogicChangeRequest) public logicChangeReqs;
199 
200     /**
201      * MODIFIER: The call from bicaLogic is allowed only.
202      */
203     modifier onlyLogic {
204         require(msg.sender == address(bicaLogic), "only logic contract is authorized");
205         _;
206     }
207 
208     /**
209      * CONSTRUCTOR: Initialize with an admin address which is authorized to change
210      * the value of bicaLogic.
211      */
212     constructor (address _admin) public AdminUpgradeable(_admin) {
213         bicaLogic = BICALogic(0x0);
214     }
215 
216     /**
217      * METHOD: Upgrade the logic contract ---- request.
218      * @dev Request changing the logic contract address authorized.
219      * Anyone can call this method to submit a request to change
220      * the logic address. It will be pending until admin address
221      * comfirming the request, and the logic contract address changes, i.e.
222      * the value of bicaLogic changes.
223      * @param _newLogic The address of new logic contract.
224      * @return uid The unique id of the request.
225      */
226     function requestLogicChange(address _newLogic) public returns (bytes32 uid) {
227         require(_newLogic != address(0), "new logic address can not be 0");
228 
229         uid = generateRequestUid();
230 
231         logicChangeReqs[uid] = LogicChangeRequest({
232             newLogicAddress: _newLogic
233             });
234 
235         emit LogicChangeRequested(uid, msg.sender, _newLogic);
236     }
237 
238     /**
239      * METHOD: Upgrade the logic contract ---- confirm.
240      * @dev Confirm a reqeust of logic contract change storing in the
241      * mapping of `logicChangeReqs`. The operation is authorized to
242      * the admin only.
243      * @param _uid The uid of request to change logic contract.
244      */
245     function confirmLogicChange(bytes32 _uid) public adminOperations {
246         bicaLogic = getLogicChangeReq(_uid);
247 
248         delete logicChangeReqs[_uid];
249 
250         emit LogicChangeConfirmed(_uid, address(bicaLogic));
251     }
252 
253     /**
254      * METHOD: Get the address of an logic contract address request by uid.
255      * @dev It is a private method which gets address of an address
256      * in the mapping `adminChangeReqs`
257      * @param _uid The uid of request to change logic contract address.
258      * @return _newLogicAddress The address of new logic contract address
259      * in the pending requests
260      */
261     function getLogicChangeReq(bytes32 _uid) private view returns (BICALogic _newLogicAddress) {
262         LogicChangeRequest storage changeRequest = logicChangeReqs[_uid];
263 
264         require(changeRequest.newLogicAddress != address(0));
265 
266         return BICALogic(changeRequest.newLogicAddress);
267     }
268 }
269 
270 /**
271  * @dev This contract is the core contract of all logic. It links `bicaProxy`
272  * and `bicaLedger`. It implements the issue of new amount of token, burn some
273  * value of someone's token.
274  */
275 contract BICALogic is AdminUpgradeable {
276 
277     using SafeMath for uint256;
278 
279     /**
280      * Event
281      * @dev After issuing an ammout of BICA, emit an event for the value of requester.
282      */
283     event Requester(address _supplyAddress, address _receiver, uint256 _valueRequested);
284 
285     /**
286      * Event
287      * @dev After issuing an ammout of BICA, emit an event of paying margin.
288      */
289     event PayMargin(address _supplyAddress, address _marginAddress, uint256 _marginValue);
290 
291 
292     /**
293      * Event
294      * @dev After issuing an ammout of BICA, emit an event of paying interest.
295      */
296     event PayInterest(address _supplyAddress, address _interestAddress, uint256 _interestValue);
297 
298 
299     /**
300      * Event
301      * @dev After issuing an ammout of BICA, emit an event of paying multi fee.
302      */
303     event PayMultiFee(address _supplyAddress, address _feeAddress, uint256 _feeValue);
304 
305     /**
306      * Event
307      * @dev After freezing a user address, emit an event in logic contract.
308      */
309     event AddressFrozenInLogic(address indexed addr);
310 
311     /**
312      * Event
313      * @dev After unfreezing a user address, emit an event in logic contract.
314      */
315     event AddressUnfrozenInLogic(address indexed addr);
316 
317     /**
318      * MEMBER: A reference to the proxy contract.
319      * It links the proxy contract in one direction.
320      */
321     BICAProxy public bicaProxy;
322 
323     /**
324      * MEMBER: A reference to the ledger contract.
325      * It links the ledger contract in one direction.
326      */
327     BICALedger public bicaLedger;
328 
329     /**
330      * MODIFIER: The call from bicaProxy is allowed only.
331      */
332     modifier onlyProxy {
333         require(msg.sender == address(bicaProxy), "only the proxy contract allowed only");
334         _;
335     }
336 
337     /**
338      * CONSTRUCTOR: Initialize with the proxy contract address, the ledger
339      * contract and an admin address.
340      */
341     constructor (address _bicaProxy, address _bicaLedger, address _admin) public  AdminUpgradeable(_admin) {
342         bicaProxy = BICAProxy(_bicaProxy);
343         bicaLedger = BICALedger(_bicaLedger);
344     }
345     
346     /**
347      * METHOD: `approve` operation in logic contract.
348      * @dev Receive the call request of `approve` from proxy contract and
349      * request approve operation to ledger contract. Need to check the sender
350      * and spender are not frozen
351      * @param _sender The address initiating the approval in proxy.
352      * @return success or not.
353      */
354     function approveWithSender(address _sender, address _spender, uint256 _value) public onlyProxy returns (bool success){
355         require(_spender != address(0));
356 
357         bool senderFrozen = bicaLedger.getFrozenByAddress(_sender);
358         require(!senderFrozen, "Sender is frozen");
359 
360         bool spenderFrozen = bicaLedger.getFrozenByAddress(_spender);
361         require(!spenderFrozen, "Spender is frozen");
362 
363         bicaLedger.setAllowance(_sender, _spender, _value);
364         bicaProxy.emitApproval(_sender, _spender, _value);
365         return true;
366     }
367 
368     /**
369      * METHOD: Core logic of the `increaseApproval` method in proxy contract.
370      * @dev Receive the call request of `increaseApproval` from proxy contract
371      * and request increasing value of allownce to ledger contract. Need to
372      * check the sender
373      * and spender are not frozen
374      * @param _sender The address initiating the approval in proxy.
375      * @return success or not.
376      */
377     function increaseApprovalWithSender(address _sender, address _spender, uint256 _addedValue) public onlyProxy returns (bool success) {
378         require(_spender != address(0));
379 
380         bool senderFrozen = bicaLedger.getFrozenByAddress(_sender);
381         require(!senderFrozen, "Sender is frozen");
382 
383         bool spenderFrozen = bicaLedger.getFrozenByAddress(_spender);
384         require(!spenderFrozen, "Spender is frozen");
385 
386         uint256 currentAllowance = bicaLedger.allowed(_sender, _spender);
387         uint256 newAllowance = currentAllowance.add(_addedValue);
388 
389         require(newAllowance >= currentAllowance);
390 
391         bicaLedger.setAllowance(_sender, _spender, newAllowance);
392         bicaProxy.emitApproval(_sender, _spender, newAllowance);
393         return true;
394     }
395 
396     /**
397     * METHOD: Core logic of the `decreaseApproval` method in proxy contract.
398     * @dev Receive the call request of `decreaseApproval` from proxy contract
399     * and request decreasing value of allownce to ledger contract. Need to
400     * check the sender and spender are not frozen
401     * @param _sender The address initiating the approval in proxy.
402     * @return success or not.
403     */
404     function decreaseApprovalWithSender(address _sender, address _spender, uint256 _subtractedValue) public onlyProxy returns (bool success) {
405         require(_spender != address(0));
406 
407         bool senderFrozen = bicaLedger.getFrozenByAddress(_sender);
408         require(!senderFrozen, "Sender is frozen");
409 
410         bool spenderFrozen = bicaLedger.getFrozenByAddress(_spender);
411         require(!spenderFrozen, "Spender is frozen");
412         
413         uint256 currentAllowance = bicaLedger.allowed(_sender, _spender);
414         uint256 newAllowance = currentAllowance.sub(_subtractedValue);
415 
416         require(newAllowance <= currentAllowance);
417 
418         bicaLedger.setAllowance(_sender, _spender, newAllowance);
419         bicaProxy.emitApproval(_sender, _spender, newAllowance);
420         return true;
421     }
422 
423 
424     /**
425      * METHOD: Core logic of comfirming request of issuetoken to a specified receiver.
426      * @dev Admin can issue an ammout of BICA only.
427      * @param _requesterAccount The address of request account.
428      * @param _requestValue The value of requester.
429      * @param _marginAccount The address of margin account.
430      * @param _marginValue The value of token to pay to margin account.
431      * @param _interestAccount The address accepting interest.
432      * @param _interestValue The value of interest.
433      * @param _otherFeeAddress The address accepting multi fees.
434      * @param _otherFeeValue The value of other fees.
435      */
436     function issue(address _requesterAccount, uint256 _requestValue,
437         address _marginAccount, uint256 _marginValue,
438         address _interestAccount, uint256 _interestValue,
439         address _otherFeeAddress, uint256 _otherFeeValue) public adminOperations {
440 
441         require(_requesterAccount != address(0));
442         require(_marginAccount != address(0));
443         require(_interestAccount != address(0));
444         require(_otherFeeAddress != address(0));
445 
446         require(!bicaLedger.getFrozenByAddress(_requesterAccount), "Requester is frozen");
447         require(!bicaLedger.getFrozenByAddress(_marginAccount), "Margin account is frozen");
448         require(!bicaLedger.getFrozenByAddress(_interestAccount), "Interest account is frozen");
449         require(!bicaLedger.getFrozenByAddress(_otherFeeAddress), "Other fee account is frozen");
450 
451         uint256 requestTotalValue = _marginValue.add(_interestValue).add(_otherFeeValue).add(_requestValue);
452 
453         uint256 supply = bicaLedger.totalSupply();
454         uint256 newSupply = supply.add(requestTotalValue);
455 
456         if (newSupply >= supply) {
457             bicaLedger.setTotalSupply(newSupply);
458             bicaLedger.addBalance(_marginAccount, _marginValue);
459             bicaLedger.addBalance(_interestAccount, _interestValue);
460             if ( _otherFeeValue > 0 ){
461                 bicaLedger.addBalance(_otherFeeAddress, _otherFeeValue);
462             }
463             bicaLedger.addBalance(_requesterAccount, _requestValue);
464 
465             emit Requester(msg.sender, _requesterAccount, _requestValue);
466             emit PayMargin(msg.sender, _marginAccount, _marginValue);
467             emit PayInterest(msg.sender, _interestAccount, _interestValue);
468             emit PayMultiFee(msg.sender, _otherFeeAddress, _otherFeeValue);
469 
470             bicaProxy.emitTransfer(address(0), _marginAccount, _marginValue);
471             bicaProxy.emitTransfer(address(0), _interestAccount, _interestValue);
472             bicaProxy.emitTransfer(address(0), _otherFeeAddress, _otherFeeValue);
473             bicaProxy.emitTransfer(address(0), _requesterAccount, _requestValue);
474         }
475     }
476 
477     /**
478      * METHOD: Burn the specified value of the message sender's balance.
479      * @dev Admin can call this method to burn some amount of BICA.
480      * @param _value The amount of token to be burned.
481      * @return success or not.
482      */
483     function burn(uint256 _value) public adminOperations returns (bool success) {
484         bool burnerFrozen = bicaLedger.getFrozenByAddress(msg.sender);
485         require(!burnerFrozen, "Burner is frozen");
486 
487         uint256 balanceOfSender = bicaLedger.balances(msg.sender);
488         require(_value <= balanceOfSender);
489 
490         bicaLedger.setBalance(msg.sender, balanceOfSender.sub(_value));
491         bicaLedger.setTotalSupply(bicaLedger.totalSupply().sub(_value));
492 
493         bicaProxy.emitTransfer(msg.sender, address(0), _value);
494 
495         return true;
496     }
497 
498     /**
499      * METHOD: Freeze a user address.
500      * @dev Admin can call this method to freeze a user account.
501      * @param _user user address.
502      */
503     function freeze(address _user) public adminOperations {
504         require(_user != address(0), "the address to be frozen cannot be 0");
505         bicaLedger.freezeByAddress(_user);
506         emit AddressFrozenInLogic(_user);
507     }
508 
509     /**
510      * METHOD: Unfreeze a user address.
511      * @dev Admin can call this method to unfreeze a user account.
512      * @param _user user address.
513      */
514     function unfreeze(address _user) public adminOperations {
515         require(_user != address(0), "the address to be unfrozen cannot be 0");
516         bicaLedger.unfreezeByAddress(_user);
517         emit AddressUnfrozenInLogic(_user);
518     }
519 
520     /**
521      * METHOD: Core logic of `transferFrom` interface method in ERC20 token standard.
522      * @dev It can only be called by the `bicaProxy` contract.
523      * @param _sender The address initiating the approval in proxy.
524      * @return success or not.
525      */
526     function transferFromWithSender(address _sender, address _from, address _to, uint256 _value) public onlyProxy returns (bool success){
527         require(_to != address(0));
528 
529         bool senderFrozen = bicaLedger.getFrozenByAddress(_sender);
530         require(!senderFrozen, "Sender is frozen");
531         bool fromFrozen = bicaLedger.getFrozenByAddress(_from);
532         require(!fromFrozen, "`from` is frozen");
533         bool toFrozen = bicaLedger.getFrozenByAddress(_to);
534         require(!toFrozen, "`to` is frozen");
535 
536         uint256 balanceOfFrom = bicaLedger.balances(_from);
537         require(_value <= balanceOfFrom);
538 
539         uint256 senderAllowance = bicaLedger.allowed(_from, _sender);
540         require(_value <= senderAllowance);
541 
542         bicaLedger.setBalance(_from, balanceOfFrom.sub(_value));
543 
544         bicaLedger.addBalance(_to, _value);
545 
546         bicaLedger.setAllowance(_from, _sender, senderAllowance.sub(_value));
547 
548         bicaProxy.emitTransfer(_from, _to, _value);
549 
550         return true;
551     }
552 
553     /**
554     * METHOD: Core logic of `transfer` interface method in ERC20 token standard.
555     * @dev It can only be called by the `bicaProxy` contract.
556     * @param _sender The address initiating the approval in proxy.
557     * @return success or not.
558     */
559     function transferWithSender(address _sender, address _to, uint256 _value) public onlyProxy returns (bool success){
560         require(_to != address(0));
561 
562         bool senderFrozen = bicaLedger.getFrozenByAddress(_sender);
563         require(!senderFrozen, "sender is frozen");
564         bool toFrozen = bicaLedger.getFrozenByAddress(_to);
565         require(!toFrozen, "to is frozen");
566 
567         uint256 balanceOfSender = bicaLedger.balances(_sender);
568         require(_value <= balanceOfSender);
569 
570         bicaLedger.setBalance(_sender, balanceOfSender.sub(_value));
571 
572         bicaLedger.addBalance(_to, _value);
573 
574         bicaProxy.emitTransfer(_sender, _to, _value);
575 
576         return true;
577     }
578 
579     /**
580      * METHOD: Core logic of `totalSupply` interface method in ERC20 token standard.
581      */
582     function totalSupply() public view returns (uint256) {
583         return bicaLedger.totalSupply();
584     }
585 
586     /**
587      * METHOD: Core logic of `balanceOf` interface method in ERC20 token standard.
588      */
589     function balanceOf(address _owner) public view returns (uint256 balance) {
590         return bicaLedger.balances(_owner);
591     }
592 
593     /**
594      * METHOD: Core logic of `allowance` interface method in ERC20 token standard.
595      */
596     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
597         return bicaLedger.allowed(_owner, _spender);
598     }
599 }
600 
601 /**
602  * @dev This contract is the core storage contract of ERC20 token ledger.
603  * It defines some operations of data in the storage.
604  */
605 contract BICALedger is BICALogicUpgradeable {
606 
607     using SafeMath for uint256;
608 
609     /**
610      * MEMBER: The total supply of the token.
611      */
612     uint256 public totalSupply;
613 
614     /**
615      * MEMBER: The mapping of balance of users.
616      */
617     mapping (address => uint256) public balances;
618 
619     /**
620      * MEMBER: The mapping of allowance of users.
621      */
622     mapping (address => mapping (address => uint256)) public allowed;
623 
624     /**
625      * MEMBER: The mapping of frozen addresses.
626      */
627     mapping(address => bool) public frozen;
628 
629     /**
630      * Event
631      * @dev After freezing a user address, emit an event in ledger contract.
632      */
633     event AddressFrozen(address indexed addr);
634 
635     /**
636      * Event
637      * @dev After unfreezing a user address, emit an event in ledger contract.
638      */
639     event AddressUnfrozen(address indexed addr);
640 
641     /**
642      * CONSTRUCTOR: Initialize with an admin address.
643      */
644     constructor (address _admin) public BICALogicUpgradeable(_admin) {
645         totalSupply = 0;
646     }
647 
648     /**
649      * METHOD: Check an address is frozen or not.
650      * @dev check an address is frozen or not. It can be call by logic contract only.
651      * @param _user user addree.
652      */
653     function getFrozenByAddress(address _user) public view onlyLogic returns (bool frozenOrNot) {
654         // frozenOrNot = false;
655         return frozen[_user];
656     }
657 
658     /**
659      * METHOD: Freeze an address.
660      * @dev Freeze an address. It can be called by logic contract only.
661      * @param _user user addree.
662      */
663     function freezeByAddress(address _user) public onlyLogic {
664         require(!frozen[_user], "user already frozen");
665         frozen[_user] = true;
666         emit AddressFrozen(_user);
667     }
668 
669     /**
670      * METHOD: Unfreeze an address.
671      * @dev Unfreeze an address. It can be called by logic contract only.
672      * @param _user user addree.
673      */
674     function unfreezeByAddress(address _user) public onlyLogic {
675         require(frozen[_user], "address already unfrozen");
676         frozen[_user] = false;
677         emit AddressUnfrozen(_user);
678     }
679 
680 
681     /**
682      * METHOD: Set `totalSupply` in the ledger contract.
683      * @dev It will be called when a new issue is confirmed. It can be called
684      * by logic contract only.
685      * @param _newTotalSupply The value of new total supply.
686      */
687     function setTotalSupply(uint256 _newTotalSupply) public onlyLogic {
688         totalSupply = _newTotalSupply;
689     }
690 
691     /**
692      * METHOD: Set allowance for owner to a spender in the ledger contract.
693      * @dev It will be called when the owner modify the allowance to the
694      * spender. It can be called by logic contract only.
695      * @param _owner The address allow spender to spend.
696      * @param _spender The address allowed to spend.
697      * @param _value The limit of how much can be spent by `_spender`.
698      */
699     function setAllowance(address _owner, address _spender, uint256 _value) public onlyLogic {
700         allowed[_owner][_spender] = _value;
701     }
702 
703     /**
704      * METHOD: Set balance of the owner in the ledger contract.
705      * @dev It will be called when the owner modify the balance of owner
706      * in logic. It can be called by logic contract only.
707      * @param _owner The address who owns the balance.
708      * @param _newBalance The balance to be set.
709      */
710     function setBalance(address _owner, uint256 _newBalance) public onlyLogic {
711         balances[_owner] = _newBalance;
712     }
713 
714     /**
715      * METHOD: Add balance of the owner in the ledger contract.
716      * @dev It will be called when the balance of owner increases.
717      * It can be called by logic contract only.
718      * @param _owner The address who owns the balance.
719      * @param _balanceIncrease The balance to be add.
720      */
721     function addBalance(address _owner, uint256 _balanceIncrease) public onlyLogic {
722         balances[_owner] = balances[_owner].add(_balanceIncrease);
723     }
724 }
725 
726 contract ERC20Interface {
727 
728     function totalSupply() public view returns (uint256);
729 
730     function balanceOf(address _owner) public view returns (uint256 balance);
731 
732     function transfer(address _to, uint256 _value) public returns (bool success);
733 
734     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
735 
736     function approve(address _spender, uint256 _value) public returns (bool success);
737 
738     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
739 
740     event Transfer(address indexed _from, address indexed _to, uint256 _value);
741 
742     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
743 }
744 
745 /**
746  * @dev This contract is a viewer of ERC20 token standard.
747  * It includes no logic and data.
748  */
749 contract BICAProxy is ERC20Interface, BICALogicUpgradeable {
750 
751     /**
752      * MEMBER: The name of the token.
753      */
754     string public name;
755 
756     /**
757      * MEMBER: The symbol of the token.
758      */
759     string public symbol;
760 
761     /**
762      * MEMBER: The number of decimals of the token.
763      */
764     uint public decimals;
765 
766     /**
767      * CONSTRUCTOR: Initialize with an admin address.
768      */
769     constructor (address _admin) public BICALogicUpgradeable(_admin){
770         name = "BitCapital Coin";
771         symbol = 'BICA';
772         decimals = 2;
773     }
774     
775     /**
776      * METHOD: Get `totalSupply` of token.
777      * @dev It is the standard method of ERC20.
778      * @return The total token supply.
779      */
780     function totalSupply() public view returns (uint256) {
781         return bicaLogic.totalSupply();
782     }
783 
784     /**
785      * METHOD: Get the balance of a owner.
786      * @dev It is the standard method of ERC20.
787      * @return The balance of a owner.
788      */
789     function balanceOf(address _owner) public view returns (uint256 balance) {
790         return bicaLogic.balanceOf(_owner);
791     }
792 
793     /**
794      * METHOD: Emit a Transfer event in proxy contract.
795      */
796     function emitTransfer(address _from, address _to, uint256 _value) public onlyLogic {
797         emit Transfer(_from, _to, _value);
798     }
799 
800     /**
801      * METHOD: The message sender sends some amount of token to receiver.
802      * @dev It will call the logic contract to send some token to receiver.
803      * It is the standard method of ERC20.
804      * @return success or not
805      */
806     function transfer(address _to, uint256 _value) public returns (bool success) {
807         return bicaLogic.transferWithSender(msg.sender, _to, _value);
808     }
809 
810     /**
811      * METHOD: Transfer amount of tokens from `_from` to `_to`.
812      * @dev It is the standard method of ERC20.
813      * @return success or not
814      */
815     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
816         return bicaLogic.transferFromWithSender(msg.sender, _from, _to, _value);
817     }
818 
819     /**
820      * METHOD: Emit a Approval event in proxy contract.
821      */
822     function emitApproval(address _owner, address _spender, uint256 _value) public onlyLogic {
823         emit Approval(_owner, _spender, _value);
824     }
825 
826     /**
827      * METHOD: Allow `_spender` to be able to spend `_value` token.
828      * @dev It is the standard method of ERC20.
829      * @return success or not
830      */
831     function approve(address _spender, uint256 _value) public returns (bool success) {
832         return bicaLogic.approveWithSender(msg.sender, _spender, _value);
833     }
834 
835     /**
836      * METHOD: Increase allowance value of message sender to `_spender`.
837      * @return success or not
838      */
839     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
840         return bicaLogic.increaseApprovalWithSender(msg.sender, _spender, _addedValue);
841     }
842 
843     /**
844      * METHOD: Decrease allowance value of message sender to `_spender`.
845      * @return success or not
846      */
847     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
848         return bicaLogic.decreaseApprovalWithSender(msg.sender, _spender, _subtractedValue);
849     }
850 
851     /**
852      * METHOD: Return the allowance value of `_owner` to `_spender`.
853      */
854     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
855         return bicaLogic.allowance(_owner, _spender);
856     }
857 }