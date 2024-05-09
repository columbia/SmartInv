1 pragma solidity ^0.4.23;
2 
3 /******* USING Registry **************************
4 
5 Gives the inherting contract access to:
6     .addressOf(bytes32): returns current address mapped to the name.
7     [modifier] .fromOwner(): requires the sender is owner.
8 
9 *************************************************/
10 // Returned by .getRegistry()
11 interface IRegistry {
12     function owner() external view returns (address _addr);
13     function addressOf(bytes32 _name) external view returns (address _addr);
14 }
15 
16 contract UsingRegistry {
17     IRegistry private registry;
18 
19     modifier fromOwner(){
20         require(msg.sender == getOwner());
21         _;
22     }
23 
24     constructor(address _registry)
25         public
26     {
27         require(_registry != 0);
28         registry = IRegistry(_registry);
29     }
30 
31     function addressOf(bytes32 _name)
32         internal
33         view
34         returns(address _addr)
35     {
36         return registry.addressOf(_name);
37     }
38 
39     function getOwner()
40         public
41         view
42         returns (address _addr)
43     {
44         return registry.owner();
45     }
46 
47     function getRegistry()
48         public
49         view
50         returns (IRegistry _addr)
51     {
52         return registry;
53     }
54 }
55 
56 /******* USING ADMIN ***********************
57 
58 Gives the inherting contract access to:
59     .getAdmin(): returns the current address of the admin
60     [modifier] .fromAdmin: requires the sender is the admin
61 
62 *************************************************/
63 contract UsingAdmin is
64     UsingRegistry
65 {
66     constructor(address _registry)
67         UsingRegistry(_registry)
68         public
69     {}
70 
71     modifier fromAdmin(){
72         require(msg.sender == getAdmin());
73         _;
74     }
75     
76     function getAdmin()
77         public
78         constant
79         returns (address _addr)
80     {
81         return addressOf("ADMIN");
82     }
83 }
84 
85 /**
86     This is a simple class that maintains a doubly linked list of
87     address => uint amounts. Address balances can be added to 
88     or removed from via add() and subtract(). All balances can
89     be obtain by calling balances(). If an address has a 0 amount,
90     it is removed from the Ledger.
91 
92     Note: THIS DOES NOT TEST FOR OVERFLOWS, but it's safe to
93           use to track Ether balances.
94 
95     Public methods:
96       - [fromOwner] add()
97       - [fromOwner] subtract()
98     Public views:
99       - total()
100       - size()
101       - balanceOf()
102       - balances()
103       - entries() [to manually iterate]
104 */
105 contract Ledger {
106     uint public total;      // Total amount in Ledger
107 
108     struct Entry {          // Doubly linked list tracks amount per address
109         uint balance;
110         address next;
111         address prev;
112     }
113     mapping (address => Entry) public entries;
114 
115     address public owner;
116     modifier fromOwner() { require(msg.sender==owner); _; }
117 
118     // Constructor sets the owner
119     constructor(address _owner)
120         public
121     {
122         owner = _owner;
123     }
124 
125 
126     /******************************************************/
127     /*************** OWNER METHODS ************************/
128     /******************************************************/
129 
130     function add(address _address, uint _amt)
131         fromOwner
132         public
133     {
134         if (_address == address(0) || _amt == 0) return;
135         Entry storage entry = entries[_address];
136 
137         // If new entry, replace first entry with this one.
138         if (entry.balance == 0) {
139             entry.next = entries[0x0].next;
140             entries[entries[0x0].next].prev = _address;
141             entries[0x0].next = _address;
142         }
143         // Update stats.
144         total += _amt;
145         entry.balance += _amt;
146     }
147 
148     function subtract(address _address, uint _amt)
149         fromOwner
150         public
151         returns (uint _amtRemoved)
152     {
153         if (_address == address(0) || _amt == 0) return;
154         Entry storage entry = entries[_address];
155 
156         uint _maxAmt = entry.balance;
157         if (_maxAmt == 0) return;
158         
159         if (_amt >= _maxAmt) {
160             // Subtract the max amount, and delete entry.
161             total -= _maxAmt;
162             entries[entry.prev].next = entry.next;
163             entries[entry.next].prev = entry.prev;
164             delete entries[_address];
165             return _maxAmt;
166         } else {
167             // Subtract the amount from entry.
168             total -= _amt;
169             entry.balance -= _amt;
170             return _amt;
171         }
172     }
173 
174 
175     /******************************************************/
176     /*************** PUBLIC VIEWS *************************/
177     /******************************************************/
178 
179     function size()
180         public
181         view
182         returns (uint _size)
183     {
184         // Loop once to get the total count.
185         Entry memory _curEntry = entries[0x0];
186         while (_curEntry.next > 0) {
187             _curEntry = entries[_curEntry.next];
188             _size++;
189         }
190         return _size;
191     }
192 
193     function balanceOf(address _address)
194         public
195         view
196         returns (uint _balance)
197     {
198         return entries[_address].balance;
199     }
200 
201     function balances()
202         public
203         view
204         returns (address[] _addresses, uint[] _balances)
205     {
206         // Populate names and addresses
207         uint _size = size();
208         _addresses = new address[](_size);
209         _balances = new uint[](_size);
210         uint _i = 0;
211         Entry memory _curEntry = entries[0x0];
212         while (_curEntry.next > 0) {
213             _addresses[_i] = _curEntry.next;
214             _balances[_i] = entries[_curEntry.next].balance;
215             _curEntry = entries[_curEntry.next];
216             _i++;
217         }
218         return (_addresses, _balances);
219     }
220 }
221 
222 /*
223     This is an abstract contract, inherited by Treasury, that manages
224     creating, cancelling, and executing admin requests that control
225     capital. It provides transparency, governence, and security.
226 
227     In the future, the Admin account can be set to be a DAO.
228     
229     A Request:
230         - can only be created by Admin
231         - can be cancelled by Admin, if not yet executed
232         - can be executed after WAITING_TIME (1 week)
233         - cannot be executed after TIMEOUT_TIME (2 weeks)
234         - contains a type, target, and value
235         - when executed, calls corresponding `execute${type}()` method
236 */
237 contract Requestable is
238     UsingAdmin 
239 {
240     uint32 public constant WAITING_TIME = 60*60*24*7;   // 1 week
241     uint32 public constant TIMEOUT_TIME = 60*60*24*14;  // 2 weeks
242     uint32 public constant MAX_PENDING_REQUESTS = 10;
243 
244     // Requests.
245     enum RequestType {SendCapital, RecallCapital, RaiseCapital, DistributeCapital}
246     struct Request {
247         // Params to handle state and history.
248         uint32 id;
249         uint8 typeId;
250         uint32 dateCreated;
251         uint32 dateCancelled;
252         uint32 dateExecuted;
253         string createdMsg;
254         string cancelledMsg;
255         string executedMsg;
256         bool executedSuccessfully;
257         // Params for execution.
258         address target;
259         uint value;
260     }
261     mapping (uint32 => Request) public requests;
262     uint32 public curRequestId;
263     uint32[] public completedRequestIds;
264     uint32[] public cancelledRequestIds;
265     uint32[] public pendingRequestIds;
266 
267     // Events.
268     event RequestCreated(uint time, uint indexed id, uint indexed typeId, address indexed target, uint value, string msg);
269     event RequestCancelled(uint time, uint indexed id, uint indexed typeId, address indexed target, string msg);
270     event RequestExecuted(uint time, uint indexed id, uint indexed typeId, address indexed target, bool success, string msg);
271 
272     constructor(address _registry)
273         UsingAdmin(_registry)
274         public
275     { }
276 
277     // Creates a request, assigning it the next ID.
278     // Throws if there are already 8 pending requests.
279     function createRequest(uint _typeId, address _target, uint _value, string _msg)
280         public
281         fromAdmin
282     {
283         uint32 _id = ++curRequestId;
284         requests[_id].id = _id;
285         requests[_id].typeId = uint8(RequestType(_typeId));
286         requests[_id].dateCreated = uint32(now);
287         requests[_id].createdMsg = _msg;
288         requests[_id].target = _target;
289         requests[_id].value = _value;
290         _addPendingRequestId(_id);
291         emit RequestCreated(now, _id, _typeId, _target, _value, _msg);
292     }
293 
294     // Cancels a request.
295     // Throws if already cancelled or executed.
296     function cancelRequest(uint32 _id, string _msg)
297         public
298         fromAdmin
299     {
300         // Require Request exists, is not cancelled, is not executed.
301         Request storage r = requests[_id];
302         require(r.id != 0 && r.dateCancelled == 0 && r.dateExecuted == 0);
303         r.dateCancelled = uint32(now);
304         r.cancelledMsg = _msg;
305         _removePendingRequestId(_id);
306         cancelledRequestIds.push(_id);
307         emit RequestCancelled(now, r.id, r.typeId, r.target, _msg);
308     }
309 
310     // Executes (or times out) a request if it is not already cancelled or executed.
311     // Note: This may revert if the executeFn() reverts. It'll time-out eventually.
312     function executeRequest(uint32 _id)
313         public
314     {
315         // Require Request exists, is not cancelled, is not executed.
316         // Also require is past WAITING_TIME since creation.
317         Request storage r = requests[_id];
318         require(r.id != 0 && r.dateCancelled == 0 && r.dateExecuted == 0);
319         require(uint32(now) > r.dateCreated + WAITING_TIME);
320         
321         // If request timed out, cancel it.
322         if (uint32(now) > r.dateCreated + TIMEOUT_TIME) {
323             cancelRequest(_id, "Request timed out.");
324             return;
325         }
326                 
327         // Execute concrete method after setting as executed.
328         r.dateExecuted = uint32(now);
329         string memory _msg;
330         bool _success;
331         RequestType _type = RequestType(r.typeId);
332         if (_type == RequestType.SendCapital) {
333             (_success, _msg) = executeSendCapital(r.target, r.value);
334         } else if (_type == RequestType.RecallCapital) {
335             (_success, _msg) = executeRecallCapital(r.target, r.value);
336         } else if (_type == RequestType.RaiseCapital) {
337             (_success, _msg) = executeRaiseCapital(r.value);
338         } else if (_type == RequestType.DistributeCapital) {
339             (_success, _msg) = executeDistributeCapital(r.value);
340         }
341 
342         // Save results, and emit.
343         r.executedSuccessfully = _success;
344         r.executedMsg = _msg;
345         _removePendingRequestId(_id);
346         completedRequestIds.push(_id);
347         emit RequestExecuted(now, r.id, r.typeId, r.target, _success, _msg);
348     }
349 
350     // Pushes id onto the array, throws if too many.
351     function _addPendingRequestId(uint32 _id)
352         private
353     {
354         require(pendingRequestIds.length != MAX_PENDING_REQUESTS);
355         pendingRequestIds.push(_id);
356     }
357 
358     // Removes id from array, reduces array length by one.
359     // Throws if not found.
360     function _removePendingRequestId(uint32 _id)
361         private
362     {
363         // Find this id in the array, or throw.
364         uint _len = pendingRequestIds.length;
365         uint _foundIndex = MAX_PENDING_REQUESTS;
366         for (uint _i = 0; _i < _len; _i++) {
367             if (pendingRequestIds[_i] == _id) {
368                 _foundIndex = _i;
369                 break;
370             }
371         }
372         require(_foundIndex != MAX_PENDING_REQUESTS);
373 
374         // Swap last element to this index, then delete last element.
375         pendingRequestIds[_foundIndex] = pendingRequestIds[_len-1];
376         pendingRequestIds.length--;
377     }
378 
379     // These methods must be implemented by Treasury /////////////////
380     function executeSendCapital(address _target, uint _value)
381         internal returns (bool _success, string _msg);
382 
383     function executeRecallCapital(address _target, uint _value)
384         internal returns (bool _success, string _msg);
385 
386     function executeRaiseCapital(uint _value)
387         internal returns (bool _success, string _msg);
388 
389     function executeDistributeCapital(uint _value)
390         internal returns (bool _success, string _msg);
391     //////////////////////////////////////////////////////////////////
392 
393     // View that returns a Request as a valid tuple.
394     // Sorry for the formatting, but it's a waste of lines otherwise.
395     function getRequest(uint32 _requestId) public view returns (
396         uint32 _id, uint8 _typeId, address _target, uint _value,
397         bool _executedSuccessfully,
398         uint32 _dateCreated, uint32 _dateCancelled, uint32 _dateExecuted,
399         string _createdMsg, string _cancelledMsg, string _executedMsg       
400     ) {
401         Request memory r = requests[_requestId];
402         return (
403             r.id, r.typeId, r.target, r.value,
404             r.executedSuccessfully,
405             r.dateCreated, r.dateCancelled, r.dateExecuted,
406             r.createdMsg, r.cancelledMsg, r.executedMsg
407         );
408     }
409 
410     function isRequestExecutable(uint32 _requestId)
411         public
412         view
413         returns (bool _isExecutable)
414     {
415         Request memory r = requests[_requestId];
416         _isExecutable = (r.id>0 && r.dateCancelled==0 && r.dateExecuted==0);
417         _isExecutable = _isExecutable && (uint32(now) > r.dateCreated + WAITING_TIME);
418         return _isExecutable;
419     }
420 
421     // Return the lengths of arrays.
422     function numPendingRequests() public view returns (uint _num){
423         return pendingRequestIds.length;
424     }
425     function numCompletedRequests() public view returns (uint _num){
426         return completedRequestIds.length;
427     }
428     function numCancelledRequests() public view returns (uint _num){
429         return cancelledRequestIds.length;
430     }
431 }
432 
433 /*
434 
435 UI: https://www.pennyether.com/status/treasury
436 
437 The Treasury manages 2 balances:
438 
439     * capital: Ether that can be sent to bankrollable contracts.
440         - Is controlled via `Requester` governance, by the Admin (which is mutable)
441             - Capital received by Comptroller is considered "capitalRaised".
442             - A target amount can be set: "capitalRaisedTarget".
443             - Comptroller will sell Tokens to reach capitalRaisedTarget.
444         - Can be sent to Bankrollable contracts.
445         - Can be recalled from Bankrollable contracts.
446         - Allocation in-total and per-contract is available.
447 
448     * profits: Ether received via fallback fn. Can be sent to Token at any time.
449         - Are received via fallback function, typically by bankrolled contracts.
450         - Can be sent to Token at any time, by anyone, via .issueDividend()
451 
452 All Ether entering and leaving Treasury is allocated to one of the three balances.
453 Thus, the balance of Treasury will always equal: capital + profits.
454 
455 Roles:
456     Owner:       can set Comptroller and Token addresses, once.
457     Comptroller: can add and remove "raised" capital
458     Admin:       can trigger requests.
459     Token:       receives profits via .issueDividend().
460     Anybody:     can call .issueDividend()
461                  can call .addCapital()
462 
463 */
464 // Allows Treasury to add/remove capital to/from Bankrollable instances.
465 interface _ITrBankrollable {
466     function removeBankroll(uint _amount, string _callbackFn) external;
467     function addBankroll() external payable;
468 }
469 interface _ITrComptroller {
470     function treasury() external view returns (address);
471     function token() external view returns (address);
472     function wasSaleEnded() external view returns (bool);
473 }
474 
475 contract Treasury is
476     Requestable
477 {
478     // Address that can initComptroller
479     address public owner;
480     // Capital sent from this address is considered "capitalRaised"
481     // This also contains the token that dividends will be sent to.
482     _ITrComptroller public comptroller;
483 
484     // Balances
485     uint public capital;  // Ether held as capital. Sendable/Recallable via Requests
486     uint public profits;  // Ether received via fallback fn. Distributable only to Token.
487     
488     // Capital Management
489     uint public capitalRaised;        // The amount of capital raised from Comptroller.
490     uint public capitalRaisedTarget;  // The target amount of capitalRaised.
491     Ledger public capitalLedger;      // Tracks capital allocated per address
492 
493     // Stats
494     uint public profitsSent;          // Total profits ever sent.
495     uint public profitsTotal;         // Total profits ever received.
496 
497     // EVENTS
498     event Created(uint time);
499     // Admin triggered events
500     event ComptrollerSet(uint time, address comptroller, address token);
501     // capital-related events
502     event CapitalAdded(uint time, address indexed sender, uint amount);
503     event CapitalRemoved(uint time, address indexed recipient, uint amount);
504     event CapitalRaised(uint time, uint amount);
505     // profit-related events
506     event ProfitsReceived(uint time, address indexed sender, uint amount);
507     // request-related events
508     event ExecutedSendCapital(uint time, address indexed bankrollable, uint amount);
509     event ExecutedRecallCapital(uint time, address indexed bankrollable, uint amount);
510     event ExecutedRaiseCapital(uint time, uint amount);
511     event ExecutedDistributeCapital(uint time, uint amount);
512     // dividend events
513     event DividendSuccess(uint time, address token, uint amount);
514     event DividendFailure(uint time, string msg);
515 
516     // `Requester` provides .fromAdmin() and requires implementation of:
517     //   - executeSendCapital
518     //   - executeRecallCapital
519     //   - executeRaiseCapital
520     constructor(address _registry, address _owner)
521         Requestable(_registry)
522         public
523     {
524         owner = _owner;
525         capitalLedger = new Ledger(this);
526         emit Created(now);
527     }
528 
529 
530     /*************************************************************/
531     /*************** OWNER FUNCTIONS *****************************/
532     /*************************************************************/
533 
534     // Callable once to set the Comptroller address
535     function initComptroller(_ITrComptroller _comptroller)
536         public
537     {
538         // only owner can call this.
539         require(msg.sender == owner);
540         // comptroller must not already be set.
541         require(address(comptroller) == address(0));
542         // comptroller's treasury must point to this.
543         require(_comptroller.treasury() == address(this));
544         comptroller = _comptroller;
545         emit ComptrollerSet(now, _comptroller, comptroller.token());
546     }
547 
548 
549     /*************************************************************/
550     /******* PROFITS AND DIVIDENDS *******************************/
551     /*************************************************************/
552 
553     // Can receive Ether from anyone. Typically Bankrollable contracts' profits.
554     function () public payable {
555         profits += msg.value;
556         profitsTotal += msg.value;
557         emit ProfitsReceived(now, msg.sender, msg.value);
558     }
559 
560     // Sends profits to Token
561     function issueDividend()
562         public
563         returns (uint _profits)
564     {
565         // Ensure token is set.
566         if (address(comptroller) == address(0)) {
567             emit DividendFailure(now, "Comptroller not yet set.");
568             return;
569         }
570         // Ensure the CrowdSale is completed
571         if (comptroller.wasSaleEnded() == false) {
572             emit DividendFailure(now, "CrowdSale not yet completed.");
573             return;
574         }
575         // Load _profits to memory (saves gas), and ensure there are profits.
576         _profits = profits;
577         if (_profits <= 0) {
578             emit DividendFailure(now, "No profits to send.");
579             return;
580         }
581 
582         // Set profits to 0, and send to Token
583         address _token = comptroller.token();
584         profits = 0;
585         profitsSent += _profits;
586         require(_token.call.value(_profits)());
587         emit DividendSuccess(now, _token, _profits);
588     }
589 
590 
591     /*************************************************************/
592     /*************** ADDING CAPITAL ******************************/
593     /*************************************************************/ 
594 
595     // Anyone can add capital at any time.
596     // If it comes from Comptroller, it counts as capitalRaised.
597     function addCapital()
598         public
599         payable
600     {
601         capital += msg.value;
602         if (msg.sender == address(comptroller)) {
603             capitalRaised += msg.value;
604             emit CapitalRaised(now, msg.value);
605         }
606         emit CapitalAdded(now, msg.sender, msg.value);
607     }
608 
609 
610     /*************************************************************/
611     /*************** REQUESTER IMPLEMENTATION ********************/
612     /*************************************************************/
613 
614     // Removes from capital, sends it to Bankrollable target.
615     function executeSendCapital(address _bankrollable, uint _value)
616         internal
617         returns (bool _success, string _result)
618     {
619         // Fail if we do not have the capital available.
620         if (_value > capital)
621             return (false, "Not enough capital.");
622         // Fail if target is not Bankrollable
623         if (!_hasCorrectTreasury(_bankrollable))
624             return (false, "Bankrollable does not have correct Treasury.");
625 
626         // Decrease capital, increase bankrolled
627         capital -= _value;
628         capitalLedger.add(_bankrollable, _value);
629 
630         // Send it (this throws on failure). Then emit events.
631         _ITrBankrollable(_bankrollable).addBankroll.value(_value)();
632         emit CapitalRemoved(now, _bankrollable, _value);
633         emit ExecutedSendCapital(now, _bankrollable, _value);
634         return (true, "Sent bankroll to target.");
635     }
636 
637     // Calls ".removeBankroll()" on Bankrollable target.
638     function executeRecallCapital(address _bankrollable, uint _value)
639         internal
640         returns (bool _success, string _result)
641     {
642         // This should call .addCapital(), incrementing capital.
643         uint _prevCapital = capital;
644         _ITrBankrollable(_bankrollable).removeBankroll(_value, "addCapital()");
645         uint _recalled = capital - _prevCapital;
646         capitalLedger.subtract(_bankrollable, _recalled);
647         
648         // Emit and return
649         emit ExecutedRecallCapital(now, _bankrollable, _recalled);
650         return (true, "Received bankoll back from target.");
651     }
652 
653     // Increases capitalRaisedTarget
654     function executeRaiseCapital(uint _value)
655         internal
656         returns (bool _success, string _result)
657     {
658         // Increase target amount.
659         capitalRaisedTarget += _value;
660         emit ExecutedRaiseCapital(now, _value);
661         return (true, "Capital target raised.");
662     }
663 
664     // Moves capital to profits
665     function executeDistributeCapital(uint _value)
666         internal
667         returns (bool _success, string _result)
668     {
669         if (_value > capital)
670             return (false, "Not enough capital.");
671         capital -= _value;
672         profits += _value;
673         profitsTotal += _value;
674         emit CapitalRemoved(now, this, _value);
675         emit ProfitsReceived(now, this, _value);
676         emit ExecutedDistributeCapital(now, _value);
677         return (true, "Capital moved to profits.");
678     }
679 
680 
681     /*************************************************************/
682     /*************** PUBLIC VIEWS ********************************/
683     /*************************************************************/
684 
685     function profitsTotal()
686         public
687         view
688         returns (uint _amount)
689     {
690         return profitsSent + profits;
691     }
692 
693     function profitsSendable()
694         public
695         view
696         returns (uint _amount)
697     {
698         if (address(comptroller)==0) return 0;
699         if (!comptroller.wasSaleEnded()) return 0;
700         return profits;
701     }
702 
703     // Returns the amount of capital needed to reach capitalRaisedTarget.
704     function capitalNeeded()
705         public
706         view
707         returns (uint _amount)
708     {
709         return capitalRaisedTarget > capitalRaised
710             ? capitalRaisedTarget - capitalRaised
711             : 0;
712     }
713 
714     // Returns the total amount of capital allocated
715     function capitalAllocated()
716         public
717         view
718         returns (uint _amount)
719     {
720         return capitalLedger.total();
721     }
722 
723     // Returns amount of capital allocated to an address
724     function capitalAllocatedTo(address _addr)
725         public
726         view
727         returns (uint _amount)
728     {
729         return capitalLedger.balanceOf(_addr);
730     }
731 
732     // Returns the full capital allocation table
733     function capitalAllocation()
734         public
735         view
736         returns (address[] _addresses, uint[] _amounts)
737     {
738         return capitalLedger.balances();
739     }
740 
741     // Returns if _addr.getTreasury() returns this address.
742     // This is not fool-proof, but should prevent accidentally
743     //  sending capital to non-bankrollable addresses.
744     function _hasCorrectTreasury(address _addr)
745         private
746         returns (bool)
747     {
748         bytes32 _sig = bytes4(keccak256("getTreasury()"));
749         bool _success;
750         address _response;
751         assembly {
752             let x := mload(0x40)    // get free memory
753             mstore(x, _sig)         // store signature into it
754             // store if call was successful
755             _success := call(
756                 10000,  // 10k gas
757                 _addr,  // to _addr
758                 0,      // 0 value
759                 x,      // input is x
760                 4,      // input length is 4
761                 x,      // store output to x
762                 32      // store first return value
763             )
764             // store first return value to _response
765             _response := mload(x)
766         }
767         return _success ? _response == address(this) : false;
768     }
769 }