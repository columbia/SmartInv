1 pragma solidity ^0.5.10;
2 
3 
4 contract Custodian {
5 
6   
7     struct Request {
8         bytes32 lockId;
9         bytes4 callbackSelector;
10         address callbackAddress;
11         uint256 idx;
12         uint256 timestamp;
13         bool extended;
14     }
15 
16   
17     event Requested(
18         bytes32 _lockId,
19         address _callbackAddress,
20         bytes4 _callbackSelector,
21         uint256 _nonce,
22         address _whitelistedAddress,
23         bytes32 _requestMsgHash,
24         uint256 _timeLockExpiry
25     );
26 
27   
28     event TimeLocked(
29         uint256 _timeLockExpiry,
30         bytes32 _requestMsgHash
31     );
32 
33     
34     event Completed(
35         bytes32 _lockId,
36         bytes32 _requestMsgHash,
37         address _signer1,
38         address _signer2
39     );
40 
41   
42     event Failed(
43         bytes32 _lockId,
44         bytes32 _requestMsgHash,
45         address _signer1,
46         address _signer2
47     );
48 
49    
50     event TimeLockExtended(
51         uint256 _timeLockExpiry,
52         bytes32 _requestMsgHash
53     );
54 
55   
56     uint256 public requestCount;
57 
58    
59     mapping (address => bool) public signerSet;
60 
61     
62     mapping (bytes32 => Request) public requestMap;
63 
64    
65     mapping (address => mapping (bytes4 => uint256)) public lastCompletedIdxs;
66 
67    
68     uint256 public defaultTimeLock;
69 
70    
71     uint256 public extendedTimeLock;
72 
73    
74     address public primary;
75 
76   
77     constructor(
78         address[] memory _signers,
79         uint256 _defaultTimeLock,
80         uint256 _extendedTimeLock,
81         address _primary
82     )
83         public
84     {
85         
86         require(_signers.length >= 2);
87 
88       
89         require(_defaultTimeLock <= _extendedTimeLock);
90         defaultTimeLock = _defaultTimeLock;
91         extendedTimeLock = _extendedTimeLock;
92 
93         primary = _primary;
94 
95         
96         requestCount = 0;
97         
98         for (uint i = 0; i < _signers.length; i++) {
99             
100             require(_signers[i] != address(0) && !signerSet[_signers[i]]);
101             signerSet[_signers[i]] = true;
102         }
103     }
104 
105    
106     modifier onlyPrimary {
107         require(msg.sender == primary);
108         _;
109     }
110 
111   
112     function requestUnlock(
113         bytes32 _lockId,
114         address _callbackAddress,
115         bytes4 _callbackSelector,
116         address _whitelistedAddress
117     )
118         public
119         payable
120         returns (bytes32 requestMsgHash)
121     {
122         require(msg.sender == primary || msg.value >= 1 ether);
123 
124        
125         require(_callbackAddress != address(0));
126 
127         uint256 requestIdx = ++requestCount;
128       
129         uint256 nonce = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), address(this), requestIdx)));
130 
131         requestMsgHash = keccak256(abi.encodePacked(nonce, _whitelistedAddress, uint256(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)));
132         requestMap[requestMsgHash] = Request({
133             lockId: _lockId,
134             callbackSelector: _callbackSelector,
135             callbackAddress: _callbackAddress,
136             idx: requestIdx,
137             timestamp: block.timestamp,
138             extended: false
139         });
140 
141       
142         uint256 timeLockExpiry = block.timestamp;
143         if (msg.sender == primary) {
144             timeLockExpiry += defaultTimeLock;
145         } else {
146             timeLockExpiry += extendedTimeLock;
147 
148           
149             requestMap[requestMsgHash].extended = true;
150         }
151 
152         emit Requested(_lockId, _callbackAddress, _callbackSelector, nonce, _whitelistedAddress, requestMsgHash, timeLockExpiry);
153     }
154 
155     
156     function completeUnlock(
157         bytes32 _requestMsgHash,
158         uint8 _recoveryByte1, bytes32 _ecdsaR1, bytes32 _ecdsaS1,
159         uint8 _recoveryByte2, bytes32 _ecdsaR2, bytes32 _ecdsaS2
160     )
161         public
162         returns (bool success)
163     {
164         Request storage request = requestMap[_requestMsgHash];
165 
166         bytes32 lockId = request.lockId;
167         address callbackAddress = request.callbackAddress;
168         bytes4 callbackSelector = request.callbackSelector;
169 
170        
171         require(callbackAddress != address(0));
172 
173       
174         require(request.idx > lastCompletedIdxs[callbackAddress][callbackSelector]);
175         
176         address signer1 =  ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _requestMsgHash)), _recoveryByte1,_ecdsaR1, _ecdsaS1);
177         require(signerSet[signer1]);
178 
179         address signer2 =  ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _requestMsgHash)), _recoveryByte2, _ecdsaR2, _ecdsaS2);
180         require(signerSet[signer2]);
181         require(signer1 != signer2);
182 
183         if (request.extended && ((block.timestamp - request.timestamp) < extendedTimeLock)) {
184             emit TimeLocked(request.timestamp + extendedTimeLock, _requestMsgHash);
185             return false;
186         } else if ((block.timestamp - request.timestamp) < defaultTimeLock) {
187             emit TimeLocked(request.timestamp + defaultTimeLock, _requestMsgHash);
188             return false;
189         } else {
190             if (address(this).balance > 0) {
191                 
192                 success = msg.sender.send(address(this).balance);
193             }
194 
195          
196             lastCompletedIdxs[callbackAddress][callbackSelector] = request.idx;
197            
198             delete requestMap[_requestMsgHash];
199 
200            
201             (success,) = callbackAddress.call(abi.encodeWithSelector(callbackSelector, lockId));
202 
203             if (success) {
204                 emit Completed(lockId, _requestMsgHash, signer1, signer2);
205             } else {
206                 emit Failed(lockId, _requestMsgHash, signer1, signer2);
207             }
208         }
209     }
210 
211     function deleteUncompletableRequest(bytes32 _requestMsgHash) public {
212         Request storage request = requestMap[_requestMsgHash];
213 
214         uint256 idx = request.idx;
215 
216         require(0 < idx && idx < lastCompletedIdxs[request.callbackAddress][request.callbackSelector]);
217 
218         delete requestMap[_requestMsgHash];
219     }
220 
221   
222     function extendRequestTimeLock(bytes32 _requestMsgHash) public onlyPrimary {
223         Request storage request = requestMap[_requestMsgHash];
224 
225      
226         require(request.callbackAddress != address(0));
227 
228        
229         require(request.extended != true);
230 
231         
232         request.extended = true;
233 
234         emit TimeLockExtended(request.timestamp + extendedTimeLock, _requestMsgHash);
235     }
236 }
237 
238 contract LockRequestable {
239 
240    
241     uint256 public lockRequestCount;
242 
243     
244     constructor() public {
245         lockRequestCount = 0;
246     }
247 
248     function generateLockId() internal returns (bytes32 lockId) {
249         return keccak256(abi.encodePacked(blockhash(block.number - 1), address(this), ++lockRequestCount));
250     }
251 }
252 
253 contract ERC20Interface {
254  
255   function totalSupply() public view returns (uint256);
256 
257  
258   function balanceOf(address _owner) public view returns (uint256 balance);
259 
260   
261   function transfer(address _to, uint256 _value) public returns (bool success);
262 
263  
264   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
265 
266   
267   function approve(address _spender, uint256 _value) public returns (bool success);
268 
269  
270   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
271 
272   
273   event Transfer(address indexed _from, address indexed _to, uint256 _value);
274 
275   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
276 }
277 
278 contract CustodianUpgradeable is LockRequestable {
279 
280     
281     struct CustodianChangeRequest {
282         address proposedNew;
283     }
284 
285   
286     address public custodian;
287 
288     
289     mapping (bytes32 => CustodianChangeRequest) public custodianChangeReqs;
290 
291   
292     constructor(
293         address _custodian
294     )
295       LockRequestable()
296       public
297     {
298         custodian = _custodian;
299     }
300 
301    
302     modifier onlyCustodian {
303         require(msg.sender == custodian);
304         _;
305     }
306 
307     function requestCustodianChange(address _proposedCustodian) public returns (bytes32 lockId) {
308         require(_proposedCustodian != address(0));
309 
310         lockId = generateLockId();
311 
312         custodianChangeReqs[lockId] = CustodianChangeRequest({
313             proposedNew: _proposedCustodian
314         });
315 
316         emit CustodianChangeRequested(lockId, msg.sender, _proposedCustodian);
317     }
318 
319    
320     function confirmCustodianChange(bytes32 _lockId) public onlyCustodian {
321         custodian = getCustodianChangeReq(_lockId);
322 
323         delete custodianChangeReqs[_lockId];
324 
325         emit CustodianChangeConfirmed(_lockId, custodian);
326     }
327 
328    
329     function getCustodianChangeReq(bytes32 _lockId) private view returns (address _proposedNew) {
330         CustodianChangeRequest storage changeRequest = custodianChangeReqs[_lockId];
331 
332        
333         require(changeRequest.proposedNew != address(0));
334 
335         return changeRequest.proposedNew;
336     }
337    
338     event CustodianChangeRequested(
339         bytes32 _lockId,
340         address _msgSender,
341         address _proposedCustodian
342     );
343 
344     event CustodianChangeConfirmed(bytes32 _lockId, address _newCustodian);
345 }
346 
347 contract ERC20ImplUpgradeable is CustodianUpgradeable  {
348 
349    
350     struct ImplChangeRequest {
351         address proposedNew;
352     }
353 
354    
355     ERC20Impl public erc20Impl;
356 
357    
358     mapping (bytes32 => ImplChangeRequest) public implChangeReqs;
359 
360    
361     constructor(address _custodian) CustodianUpgradeable(_custodian) public {
362         erc20Impl = ERC20Impl(0x0);
363     }
364 
365    
366     modifier onlyImpl {
367         require(msg.sender == address(erc20Impl));
368         _;
369     }
370 
371     
372     function requestImplChange(address _proposedImpl) public returns (bytes32 lockId) {
373         require(_proposedImpl != address(0));
374 
375         lockId = generateLockId();
376 
377         implChangeReqs[lockId] = ImplChangeRequest({
378             proposedNew: _proposedImpl
379         });
380 
381         emit ImplChangeRequested(lockId, msg.sender, _proposedImpl);
382     }
383 
384    
385     function confirmImplChange(bytes32 _lockId) public onlyCustodian {
386         erc20Impl = getImplChangeReq(_lockId);
387 
388         delete implChangeReqs[_lockId];
389 
390         emit ImplChangeConfirmed(_lockId, address(erc20Impl));
391     }
392 
393     
394     function getImplChangeReq(bytes32 _lockId) private view returns (ERC20Impl _proposedNew) {
395         ImplChangeRequest storage changeRequest = implChangeReqs[_lockId];
396 
397      
398         require(changeRequest.proposedNew != address(0));
399 
400         return ERC20Impl(changeRequest.proposedNew);
401     }
402 
403   
404     event ImplChangeRequested(
405         bytes32 _lockId,
406         address _msgSender,
407         address _proposedImpl
408     );
409 
410     
411     event ImplChangeConfirmed(bytes32 _lockId, address _newImpl);
412 }
413 
414 contract ERC20Proxy is ERC20Interface, ERC20ImplUpgradeable {
415 
416    
417     string public name;
418 
419     
420     string public symbol;
421 
422     
423     uint8 public decimals;
424 
425     
426     constructor(
427         string memory _name,
428         string memory _symbol,
429         uint8 _decimals,
430         address _custodian
431     )
432         ERC20ImplUpgradeable(_custodian)
433         public
434     {
435         name = _name;
436         symbol = _symbol;
437         decimals = _decimals;
438     }
439 
440     
441     function totalSupply() public view returns (uint256) {
442         return erc20Impl.totalSupply();
443     }
444 
445    
446     function balanceOf(address _owner) public view returns (uint256 balance) {
447         return erc20Impl.balanceOf(_owner);
448     }
449 
450     
451     function emitTransfer(address _from, address _to, uint256 _value) public onlyImpl {
452         emit Transfer(_from, _to, _value);
453     }
454 
455     
456     function transfer(address _to, uint256 _value) public returns (bool success) {
457         return erc20Impl.transferWithSender(msg.sender, _to, _value);
458     }
459 
460     
461     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
462         return erc20Impl.transferFromWithSender(msg.sender, _from, _to, _value);
463     }
464 
465     function emitApproval(address _owner, address _spender, uint256 _value) public onlyImpl {
466         emit Approval(_owner, _spender, _value);
467     }
468 
469     function approve(address _spender, uint256 _value) public returns (bool success) {
470         return erc20Impl.approveWithSender(msg.sender, _spender, _value);
471     }
472  
473     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
474         return erc20Impl.increaseApprovalWithSender(msg.sender, _spender, _addedValue);
475     }
476 
477     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
478         return erc20Impl.decreaseApprovalWithSender(msg.sender, _spender, _subtractedValue);
479     }
480 
481     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
482         return erc20Impl.allowance(_owner, _spender);
483     }
484 }
485 
486 contract ERC20Store is ERC20ImplUpgradeable {
487 
488     uint256 public totalSupply;
489 
490    
491     mapping (address => uint256) public balances;
492 
493    
494     mapping (address => mapping (address => uint256)) public allowed;
495 
496     
497     constructor(address _custodian) ERC20ImplUpgradeable(_custodian) public {
498         totalSupply = 0;
499     }
500 
501     function setTotalSupply(
502         uint256 _newTotalSupply
503     )
504         public
505         onlyImpl
506     {
507         totalSupply = _newTotalSupply;
508     }
509 
510     function setAllowance(
511         address _owner,
512         address _spender,
513         uint256 _value
514     )
515         public
516         onlyImpl
517     {
518         allowed[_owner][_spender] = _value;
519     }
520 
521     function setBalance(
522         address _owner,
523         uint256 _newBalance
524     )
525         public
526         onlyImpl
527     {
528         balances[_owner] = _newBalance;
529     }
530 
531     function addBalance(
532         address _owner,
533         uint256 _balanceIncrease
534     )
535         public
536         onlyImpl
537     {
538         balances[_owner] = balances[_owner] + _balanceIncrease;
539     }
540 }
541 
542 contract ERC20Impl is CustodianUpgradeable {
543 
544   
545     struct PendingPrint {
546         address receiver;
547         uint256 value;
548     }
549 
550     ERC20Proxy public erc20Proxy;
551 
552 
553     ERC20Store public erc20Store;
554 
555    
556     address public sweeper;
557 
558     
559     bytes32 public sweepMsg;
560 
561     
562     mapping (address => bool) public sweptSet;
563 
564     
565     mapping (bytes32 => PendingPrint) public pendingPrintMap;
566 
567    
568     constructor(
569           address _erc20Proxy,
570           address _erc20Store,
571           address _custodian,
572           address _sweeper
573     )
574         CustodianUpgradeable(_custodian)
575         public
576     {
577         require(_sweeper != address(0));
578         erc20Proxy = ERC20Proxy(_erc20Proxy);
579         erc20Store = ERC20Store(_erc20Store);
580 
581         sweeper = _sweeper;
582         sweepMsg = keccak256(abi.encodePacked(address(this), "sweep"));
583     }
584 
585    
586     modifier onlyProxy {
587         require(msg.sender == address(erc20Proxy));
588         _;
589     }
590     modifier onlySweeper {
591         require(msg.sender == sweeper);
592         _;
593     }
594 
595 
596    
597     function approveWithSender(
598         address _sender,
599         address _spender,
600         uint256 _value
601     )
602         public
603         onlyProxy
604         returns (bool success)
605     {
606         require(_spender != address(0));
607         erc20Store.setAllowance(_sender, _spender, _value);
608         erc20Proxy.emitApproval(_sender, _spender, _value);
609         return true;
610     }
611 
612    
613     function increaseApprovalWithSender(
614         address _sender,
615         address _spender,
616         uint256 _addedValue
617     )
618         public
619         onlyProxy
620         returns (bool success)
621     {
622         require(_spender != address(0)); 
623         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
624         uint256 newAllowance = currentAllowance + _addedValue;
625 
626         require(newAllowance >= currentAllowance);
627 
628         erc20Store.setAllowance(_sender, _spender, newAllowance);
629         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
630         return true;
631     }
632 
633     
634     function decreaseApprovalWithSender(
635         address _sender,
636         address _spender,
637         uint256 _subtractedValue
638     )
639         public
640         onlyProxy
641         returns (bool success)
642     {
643         require(_spender != address(0)); 
644         uint256 currentAllowance = erc20Store.allowed(_sender, _spender);
645         uint256 newAllowance = currentAllowance - _subtractedValue;
646 
647         require(newAllowance <= currentAllowance);
648 
649         erc20Store.setAllowance(_sender, _spender, newAllowance);
650         erc20Proxy.emitApproval(_sender, _spender, newAllowance);
651         return true;
652     }
653 
654     
655     function requestPrint(address _receiver, uint256 _value) public returns (bytes32 lockId) {
656         require(_receiver != address(0));
657 
658         lockId = generateLockId();
659 
660         pendingPrintMap[lockId] = PendingPrint({
661             receiver: _receiver,
662             value: _value
663         });
664 
665         emit PrintingLocked(lockId, _receiver, _value);
666     }
667 
668    
669     function confirmPrint(bytes32 _lockId) public onlyCustodian {
670         PendingPrint storage print = pendingPrintMap[_lockId];
671 
672      
673         address receiver = print.receiver;
674         require (receiver != address(0));
675         uint256 value = print.value;
676 
677         delete pendingPrintMap[_lockId];
678 
679         uint256 supply = erc20Store.totalSupply();
680         uint256 newSupply = supply + value;
681         if (newSupply >= supply) {
682           erc20Store.setTotalSupply(newSupply);
683           erc20Store.addBalance(receiver, value);
684 
685           emit PrintingConfirmed(_lockId, receiver, value);
686           erc20Proxy.emitTransfer(address(0), receiver, value);
687         }
688     }
689 
690  
691     function burn(uint256 _value) public returns (bool success) {
692         uint256 balanceOfSender = erc20Store.balances(msg.sender);
693         require(_value <= balanceOfSender);
694 
695         erc20Store.setBalance(msg.sender, balanceOfSender - _value);
696         erc20Store.setTotalSupply(erc20Store.totalSupply() - _value);
697 
698         erc20Proxy.emitTransfer(msg.sender, address(0), _value);
699 
700         return true;
701     }
702 
703   
704     function batchTransfer(address[] memory _tos, uint256[] memory _values) public returns (bool success) {
705         require(_tos.length == _values.length);
706 
707         uint256 numTransfers = _tos.length;
708         uint256 senderBalance = erc20Store.balances(msg.sender);
709 
710         for (uint256 i = 0; i < numTransfers; i++) {
711           address to = _tos[i];
712           require(to != address(0));
713           uint256 v = _values[i];
714           require(senderBalance >= v);
715 
716           if (msg.sender != to) {
717             senderBalance -= v;
718             erc20Store.addBalance(to, v);
719           }
720           erc20Proxy.emitTransfer(msg.sender, to, v);
721         }
722 
723         erc20Store.setBalance(msg.sender, senderBalance);
724 
725         return true;
726     }
727 
728     
729     function enableSweep(uint8[] memory _vs, bytes32[] memory _rs, bytes32[] memory _ss, address _to) public onlySweeper {
730         require(_to != address(0));
731         require((_vs.length == _rs.length) && (_vs.length == _ss.length));
732 
733         uint256 numSignatures = _vs.length;
734         uint256 sweptBalance = 0;
735 
736         for (uint256 i=0; i<numSignatures; ++i) {
737           address from = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32",sweepMsg)), _vs[i], _rs[i], _ss[i]);
738 
739       
740           if (from != address(0)) {
741             sweptSet[from] = true;
742 
743             uint256 fromBalance = erc20Store.balances(from);
744 
745             if (fromBalance > 0) {
746               sweptBalance += fromBalance;
747 
748               erc20Store.setBalance(from, 0);
749 
750               erc20Proxy.emitTransfer(from, _to, fromBalance);
751             }
752           }
753         }
754 
755         if (sweptBalance > 0) {
756           erc20Store.addBalance(_to, sweptBalance);
757         }
758     }
759 
760     
761     function replaySweep(address[] memory _froms, address _to) public onlySweeper {
762         require(_to != address(0));
763         uint256 lenFroms = _froms.length;
764         uint256 sweptBalance = 0;
765 
766         for (uint256 i=0; i<lenFroms; ++i) {
767             address from = _froms[i];
768 
769             if (sweptSet[from]) {
770                 uint256 fromBalance = erc20Store.balances(from);
771 
772                 if (fromBalance > 0) {
773                     sweptBalance += fromBalance;
774 
775                     erc20Store.setBalance(from, 0);
776 
777                     erc20Proxy.emitTransfer(from, _to, fromBalance);
778                 }
779             }
780         }
781 
782         if (sweptBalance > 0) {
783             erc20Store.addBalance(_to, sweptBalance);
784         }
785     }
786 
787    
788     function transferFromWithSender(
789         address _sender,
790         address _from,
791         address _to,
792         uint256 _value
793     )
794         public
795         onlyProxy
796         returns (bool success)
797     {
798         require(_to != address(0)); 
799 
800         uint256 balanceOfFrom = erc20Store.balances(_from);
801         require(_value <= balanceOfFrom);
802 
803         uint256 senderAllowance = erc20Store.allowed(_from, _sender);
804         require(_value <= senderAllowance);
805 
806         erc20Store.setBalance(_from, balanceOfFrom - _value);
807         erc20Store.addBalance(_to, _value);
808 
809         erc20Store.setAllowance(_from, _sender, senderAllowance - _value);
810 
811         erc20Proxy.emitTransfer(_from, _to, _value);
812 
813         return true;
814     }
815 
816     function transferWithSender(
817         address _sender,
818         address _to,
819         uint256 _value
820     )
821         public
822         onlyProxy
823         returns (bool success)
824     {
825         require(_to != address(0)); 
826         uint256 balanceOfSender = erc20Store.balances(_sender);
827         require(_value <= balanceOfSender);
828 
829         erc20Store.setBalance(_sender, balanceOfSender - _value);
830         erc20Store.addBalance(_to, _value);
831 
832         erc20Proxy.emitTransfer(_sender, _to, _value);
833 
834         return true;
835     }
836 
837     
838     function totalSupply() public view returns (uint256) {
839         return erc20Store.totalSupply();
840     }
841 
842    
843     function balanceOf(address _owner) public view returns (uint256 balance) {
844         return erc20Store.balances(_owner);
845     }
846 
847    
848     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
849         return erc20Store.allowed(_owner, _spender);
850     }
851 
852    
853     event PrintingLocked(bytes32 _lockId, address _receiver, uint256 _value);
854   
855     event PrintingConfirmed(bytes32 _lockId, address _receiver, uint256 _value);
856 }
857 
858 contract PrintLimiter is LockRequestable {
859 
860    
861     struct PendingCeilingRaise {
862         uint256 raiseBy;
863     }
864 
865   
866     ERC20Impl public erc20Impl;
867 
868    
869     address public custodian;
870 
871     address public limitedPrinter;
872 
873     uint256 public totalSupplyCeiling;
874 
875     mapping (bytes32 => PendingCeilingRaise) public pendingRaiseMap;
876 
877     constructor(
878         address _erc20Impl,
879         address _custodian,
880         address _limitedPrinter,
881         uint256 _initialCeiling
882     )
883         public
884     {
885         erc20Impl = ERC20Impl(_erc20Impl);
886         custodian = _custodian;
887         limitedPrinter = _limitedPrinter;
888         totalSupplyCeiling = _initialCeiling;
889     }
890 
891    
892     modifier onlyCustodian {
893         require(msg.sender == custodian);
894         _;
895     }
896     modifier onlyLimitedPrinter {
897         require(msg.sender == limitedPrinter);
898         _;
899     }
900 
901     function limitedPrint(address _receiver, uint256 _value) public onlyLimitedPrinter {
902         uint256 totalSupply = erc20Impl.totalSupply();
903         uint256 newTotalSupply = totalSupply + _value;
904 
905         require(newTotalSupply >= totalSupply);
906         require(newTotalSupply <= totalSupplyCeiling);
907         erc20Impl.confirmPrint(erc20Impl.requestPrint(_receiver, _value));
908     }
909 
910     function requestCeilingRaise(uint256 _raiseBy) public returns (bytes32 lockId) {
911         require(_raiseBy != 0);
912 
913         lockId = generateLockId();
914 
915         pendingRaiseMap[lockId] = PendingCeilingRaise({
916             raiseBy: _raiseBy
917         });
918 
919         emit CeilingRaiseLocked(lockId, _raiseBy);
920     }
921 
922     function confirmCeilingRaise(bytes32 _lockId) public onlyCustodian {
923         PendingCeilingRaise storage pendingRaise = pendingRaiseMap[_lockId];
924 
925       
926         uint256 raiseBy = pendingRaise.raiseBy;
927 
928         require(raiseBy != 0);
929 
930         delete pendingRaiseMap[_lockId];
931 
932         uint256 newCeiling = totalSupplyCeiling + raiseBy;
933         if (newCeiling >= totalSupplyCeiling) {
934             totalSupplyCeiling = newCeiling;
935 
936             emit CeilingRaiseConfirmed(_lockId, raiseBy, newCeiling);
937         }
938     }
939 
940   
941     function lowerCeiling(uint256 _lowerBy) public onlyLimitedPrinter {
942         uint256 newCeiling = totalSupplyCeiling - _lowerBy;
943         // overflow check
944         require(newCeiling <= totalSupplyCeiling);
945         totalSupplyCeiling = newCeiling;
946 
947         emit CeilingLowered(_lowerBy, newCeiling);
948     }
949 
950    
951     function confirmPrintProxy(bytes32 _lockId) public onlyCustodian {
952         erc20Impl.confirmPrint(_lockId);
953     }
954 
955    
956     function confirmCustodianChangeProxy(bytes32 _lockId) public onlyCustodian {
957         erc20Impl.confirmCustodianChange(_lockId);
958     }
959 
960    
961     event CeilingRaiseLocked(bytes32 _lockId, uint256 _raiseBy);
962   
963     event CeilingRaiseConfirmed(bytes32 _lockId, uint256 _raiseBy, uint256 _newCeiling);
964 
965    
966     event CeilingLowered(uint256 _lowerBy, uint256 _newCeiling);
967 }