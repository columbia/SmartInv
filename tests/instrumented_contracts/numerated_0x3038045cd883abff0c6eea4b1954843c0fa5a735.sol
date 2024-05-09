1 pragma solidity 0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     Unpause();
88   }
89 }
90 
91 
92 /**
93  * @title SafeMath
94  * @dev Math operations with safety checks that throw on error
95  */
96 library SafeMath {
97   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98     uint256 c = a * b;
99 
100     assert(a == 0 || c / a == b);
101     return c;
102   }
103 
104   function div(uint256 a, uint256 b) internal pure returns (uint256) {
105     // assert(b > 0); // Solidity automatically throws when dividing by 0
106     uint256 c = a / b;
107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108     return c;
109   }
110 
111   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112     assert(b <= a);
113     return a - b;
114   }
115 
116   function add(uint256 a, uint256 b) internal pure returns (uint256) {
117     uint256 c = a + b;
118     assert(c >= a);
119     return c;
120   }
121 
122   function toInt256Safe(uint256 a) internal pure returns (int256) {
123     int256 b = int256(a);
124     assert(b >= 0);
125     return b;
126   }
127 }
128 
129 
130 /**
131  * @title SafeMathInt
132  * @dev Math operations with safety checks that throw on error
133  * @dev SafeMath adapted for int256
134  */
135 library SafeMathInt {
136   function mul(int256 a, int256 b) internal pure returns (int256) {
137     // Prevent overflow when multiplying INT256_MIN with -1
138     // https://github.com/RequestNetwork/requestNetwork/issues/43
139     assert(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
140 
141     int256 c = a * b;
142     assert((b == 0) || (c / b == a));
143     return c;
144   }
145 
146   function div(int256 a, int256 b) internal pure returns (int256) {
147     // Prevent overflow when dividing INT256_MIN by -1
148     // https://github.com/RequestNetwork/requestNetwork/issues/43
149     assert(!(a == - 2**255 && b == -1));
150 
151     // assert(b > 0); // Solidity automatically throws when dividing by 0
152     int256 c = a / b;
153     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154     return c;
155   }
156 
157   function sub(int256 a, int256 b) internal pure returns (int256) {
158     assert((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
159 
160     return a - b;
161   }
162 
163   function add(int256 a, int256 b) internal pure returns (int256) {
164     int256 c = a + b;
165     assert((b >= 0 && c >= a) || (b < 0 && c < a));
166     return c;
167   }
168 
169   function toUint256Safe(int256 a) internal pure returns (uint256) {
170     assert(a>=0);
171     return uint256(a);
172   }
173 }
174 
175 /**
176  * @title SafeMath
177  * @dev Math operations with safety checks that throw on error
178  * @dev SafeMath adapted for uint8
179  */
180 library SafeMathUint8 {
181   function mul(uint8 a, uint8 b) internal pure returns (uint8) {
182     uint8 c = a * b;
183     assert(a == 0 || c / a == b);
184     return c;
185   }
186 
187   function div(uint8 a, uint8 b) internal pure returns (uint8) {
188     // assert(b > 0); // Solidity automatically throws when dividing by 0
189     uint8 c = a / b;
190     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
191     return c;
192   }
193 
194   function sub(uint8 a, uint8 b) internal pure returns (uint8) {
195     assert(b <= a);
196     return a - b;
197   }
198 
199   function add(uint8 a, uint8 b) internal pure returns (uint8) {
200     uint8 c = a + b;
201     assert(c >= a);
202     return c;
203   }
204 }
205 
206 /**
207  * @title SafeMath
208  * @dev Math operations with safety checks that throw on error
209  * @dev SafeMath adapted for uint96
210  */
211 library SafeMathUint96 {
212   function mul(uint96 a, uint96 b) internal pure returns (uint96) {
213     uint96 c = a * b;
214     assert(a == 0 || c / a == b);
215     return c;
216   }
217 
218   function div(uint96 a, uint96 b) internal pure returns (uint96) {
219     // assert(b > 0); // Solidity automatically throws when dividing by 0
220     uint96 c = a / b;
221     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222     return c;
223   }
224 
225   function sub(uint96 a, uint96 b) internal pure returns (uint96) {
226     assert(b <= a);
227     return a - b;
228   }
229 
230   function add(uint96 a, uint96 b) internal pure returns (uint96) {
231     uint96 c = a + b;
232     assert(c >= a);
233     return c;
234   }
235 }
236 
237 /**
238  * @title ERC20Basic
239  * @dev Simpler version of ERC20 interface
240  * @dev see https://github.com/ethereum/EIPs/issues/179
241  */
242 contract ERC20Basic {
243   uint256 public totalSupply;
244   function balanceOf(address who) public constant returns (uint256);
245   function transfer(address to, uint256 value) public returns (bool);
246   event Transfer(address indexed from, address indexed to, uint256 value);
247 }
248 
249 
250 /**
251  * @title ERC20 interface
252  * @dev see https://github.com/ethereum/EIPs/issues/20
253  */
254 contract ERC20 is ERC20Basic {
255   function allowance(address owner, address spender) public constant returns (uint256);
256   function transferFrom(address from, address to, uint256 value) public returns (bool);
257   function approve(address spender, uint256 value) public returns (bool);
258   event Approval(address indexed owner, address indexed spender, uint256 value);
259 }
260 
261 
262 /**
263  * @title Administrable
264  * @dev Base contract for the administration of Core. Handles whitelisting of currency contracts
265  */
266 contract Administrable is Pausable {
267 
268     // mapping of address of trusted contract
269     mapping(address => uint8) public trustedCurrencyContracts;
270 
271     // Events of the system
272     event NewTrustedContract(address newContract);
273     event RemoveTrustedContract(address oldContract);
274 
275     /**
276      * @dev add a trusted currencyContract 
277      *
278      * @param _newContractAddress The address of the currencyContract
279      */
280     function adminAddTrustedCurrencyContract(address _newContractAddress)
281         external
282         onlyOwner
283     {
284         trustedCurrencyContracts[_newContractAddress] = 1; //Using int instead of boolean in case we need several states in the future.
285         NewTrustedContract(_newContractAddress);
286     }
287 
288     /**
289      * @dev remove a trusted currencyContract 
290      *
291      * @param _oldTrustedContractAddress The address of the currencyContract
292      */
293     function adminRemoveTrustedCurrencyContract(address _oldTrustedContractAddress)
294         external
295         onlyOwner
296     {
297         require(trustedCurrencyContracts[_oldTrustedContractAddress] != 0);
298         trustedCurrencyContracts[_oldTrustedContractAddress] = 0;
299         RemoveTrustedContract(_oldTrustedContractAddress);
300     }
301 
302     /**
303      * @dev get the status of a trusted currencyContract 
304      * @dev Not used today, useful if we have several states in the future.
305      *
306      * @param _contractAddress The address of the currencyContract
307      * @return The status of the currencyContract. If trusted 1, otherwise 0
308      */
309     function getStatusContract(address _contractAddress)
310         view
311         external
312         returns(uint8) 
313     {
314         return trustedCurrencyContracts[_contractAddress];
315     }
316 
317     /**
318      * @dev check if a currencyContract is trusted
319      *
320      * @param _contractAddress The address of the currencyContract
321      * @return bool true if contract is trusted
322      */
323     function isTrustedContract(address _contractAddress)
324         public
325         view
326         returns(bool)
327     {
328         return trustedCurrencyContracts[_contractAddress] == 1;
329     }
330 }
331 
332 /**
333  * @title RequestCore
334  *
335  * @dev The Core is the main contract which stores all the requests.
336  *
337  * @dev The Core philosophy is to be as much flexible as possible to adapt in the future to any new system
338  * @dev All the important conditions and an important part of the business logic takes place in the currency contracts.
339  * @dev Requests can only be created in the currency contracts
340  * @dev Currency contracts have to be allowed by the Core and respect the business logic.
341  * @dev Request Network will develop one currency contracts per currency and anyone can creates its own currency contracts.
342  */
343 contract RequestCore is Administrable {
344     using SafeMath for uint256;
345     using SafeMathUint96 for uint96;
346     using SafeMathInt for int256;
347     using SafeMathUint8 for uint8;
348 
349     enum State { Created, Accepted, Canceled }
350 
351     struct Request {
352         // ID address of the payer
353         address payer;
354 
355         // Address of the contract managing the request
356         address currencyContract;
357 
358         // State of the request
359         State state;
360 
361         // Main payee
362         Payee payee;
363     }
364 
365     // Structure for the payees. A sub payee is an additional entity which will be paid during the processing of the invoice.
366     // ex: can be used for routing taxes or fees at the moment of the payment.
367     struct Payee {
368         // ID address of the payee
369         address addr;
370 
371         // amount expected for the payee. 
372         // Not uint for evolution (may need negative amounts one day), and simpler operations
373         int256 expectedAmount;
374 
375         // balance of the payee
376         int256 balance;
377     }
378 
379     // Count of request in the mapping. A maximum of 2^96 requests can be created per Core contract.
380     // Integer, incremented for each request of a Core contract, starting from 0
381     // RequestId (256bits) = contract address (160bits) + numRequest
382     uint96 public numRequests; 
383     
384     // Mapping of all the Requests. The key is the request ID.
385     // not anymore public to avoid "UnimplementedFeatureError: Only in-memory reference type can be stored."
386     // https://github.com/ethereum/solidity/issues/3577
387     mapping(bytes32 => Request) requests;
388 
389     // Mapping of subPayees of the requests. The key is the request ID.
390     // This array is outside the Request structure to optimize the gas cost when there is only 1 payee.
391     mapping(bytes32 => Payee[256]) public subPayees;
392 
393     /*
394      *  Events 
395      */
396     event Created(bytes32 indexed requestId, address indexed payee, address indexed payer, address creator, string data);
397     event Accepted(bytes32 indexed requestId);
398     event Canceled(bytes32 indexed requestId);
399 
400     // Event for Payee & subPayees
401     event NewSubPayee(bytes32 indexed requestId, address indexed payee); // Separated from the Created Event to allow a 4th indexed parameter (subpayees)
402     event UpdateExpectedAmount(bytes32 indexed requestId, uint8 payeeIndex, int256 deltaAmount);
403     event UpdateBalance(bytes32 indexed requestId, uint8 payeeIndex, int256 deltaAmount);
404 
405     /*
406      * @dev Function used by currency contracts to create a request in the Core
407      *
408      * @dev _payees and _expectedAmounts must have the same size
409      *
410      * @param _creator Request creator. The creator is the one who initiated the request (create or sign) and not necessarily the one who broadcasted it
411      * @param _payees array of payees address (the index 0 will be the payee the others are subPayees). Size must be smaller than 256.
412      * @param _expectedAmounts array of Expected amount to be received by each payees. Must be in same order than the payees. Size must be smaller than 256.
413      * @param _payer Entity expected to pay
414      * @param _data data of the request
415      * @return Returns the id of the request
416      */
417     function createRequest(
418         address     _creator,
419         address[]   _payees,
420         int256[]    _expectedAmounts,
421         address     _payer,
422         string      _data)
423         external
424         whenNotPaused 
425         returns (bytes32 requestId) 
426     {
427         // creator must not be null
428         require(_creator!=0); // not as modifier to lighten the stack
429         // call must come from a trusted contract
430         require(isTrustedContract(msg.sender)); // not as modifier to lighten the stack
431 
432         // Generate the requestId
433         requestId = generateRequestId();
434 
435         address mainPayee;
436         int256 mainExpectedAmount;
437         // extract the main payee if filled
438         if(_payees.length!=0) {
439             mainPayee = _payees[0];
440             mainExpectedAmount = _expectedAmounts[0];
441         }
442 
443         // Store the new request
444         requests[requestId] = Request(_payer, msg.sender, State.Created, Payee(mainPayee, mainExpectedAmount, 0));
445 
446         // Declare the new request
447         Created(requestId, mainPayee, _payer, _creator, _data);
448         
449         // Store and declare the sub payees (needed in internal function to avoid "stack too deep")
450         initSubPayees(requestId, _payees, _expectedAmounts);
451 
452         return requestId;
453     }
454 
455     /*
456      * @dev Function used by currency contracts to create a request in the Core from bytes
457      * @dev Used to avoid receiving a stack too deep error when called from a currency contract with too many parameters.
458      * @audit Note that to optimize the stack size and the gas cost we do not extract the params and store them in the stack. As a result there is some code redundancy
459      * @param _data bytes containing all the data packed :
460             address(creator)
461             address(payer)
462             uint8(number_of_payees)
463             [
464                 address(main_payee_address)
465                 int256(main_payee_expected_amount)
466                 address(second_payee_address)
467                 int256(second_payee_expected_amount)
468                 ...
469             ]
470             uint8(data_string_size)
471             size(data)
472      * @return Returns the id of the request 
473      */ 
474     function createRequestFromBytes(bytes _data) 
475         external
476         whenNotPaused 
477         returns (bytes32 requestId) 
478     {
479         // call must come from a trusted contract
480         require(isTrustedContract(msg.sender)); // not as modifier to lighten the stack
481 
482         // extract address creator & payer
483         address creator = extractAddress(_data, 0);
484 
485         address payer = extractAddress(_data, 20);
486 
487         // creator must not be null
488         require(creator!=0);
489         
490         // extract the number of payees
491         uint8 payeesCount = uint8(_data[40]);
492 
493         // get the position of the dataSize in the byte (= number_of_payees * (address_payee_size + int256_payee_size) + address_creator_size + address_payer_size + payees_count_size
494         //                                              (= number_of_payees * (20+32) + 20 + 20 + 1 )
495         uint256 offsetDataSize = uint256(payeesCount).mul(52).add(41);
496 
497         // extract the data size and then the data itself
498         uint8 dataSize = uint8(_data[offsetDataSize]);
499         string memory dataStr = extractString(_data, dataSize, offsetDataSize.add(1));
500 
501         address mainPayee;
502         int256 mainExpectedAmount;
503         // extract the main payee if possible
504         if(payeesCount!=0) {
505             mainPayee = extractAddress(_data, 41);
506             mainExpectedAmount = int256(extractBytes32(_data, 61));
507         }
508 
509         // Generate the requestId
510         requestId = generateRequestId();
511 
512         // Store the new request
513         requests[requestId] = Request(payer, msg.sender, State.Created, Payee(mainPayee, mainExpectedAmount, 0));
514 
515         // Declare the new request
516         Created(requestId, mainPayee, payer, creator, dataStr);
517 
518         // Store and declare the sub payees
519         for(uint8 i = 1; i < payeesCount; i = i.add(1)) {
520             address subPayeeAddress = extractAddress(_data, uint256(i).mul(52).add(41));
521 
522             // payees address cannot be 0x0
523             require(subPayeeAddress != 0);
524 
525             subPayees[requestId][i-1] =  Payee(subPayeeAddress, int256(extractBytes32(_data, uint256(i).mul(52).add(61))), 0);
526             NewSubPayee(requestId, subPayeeAddress);
527         }
528 
529         return requestId;
530     }
531 
532     /*
533      * @dev Function used by currency contracts to accept a request in the Core.
534      * @dev callable only by the currency contract of the request
535      * @param _requestId Request id
536      */ 
537     function accept(bytes32 _requestId) 
538         external
539     {
540         Request storage r = requests[_requestId];
541         require(r.currencyContract==msg.sender); 
542         r.state = State.Accepted;
543         Accepted(_requestId);
544     }
545 
546     /*
547      * @dev Function used by currency contracts to cancel a request in the Core. Several reasons can lead to cancel a request, see request life cycle for more info.
548      * @dev callable only by the currency contract of the request
549      * @param _requestId Request id
550      */ 
551     function cancel(bytes32 _requestId)
552         external
553     {
554         Request storage r = requests[_requestId];
555         require(r.currencyContract==msg.sender);
556         r.state = State.Canceled;
557         Canceled(_requestId);
558     }   
559 
560     /*
561      * @dev Function used to update the balance
562      * @dev callable only by the currency contract of the request
563      * @param _requestId Request id
564      * @param _payeeIndex index of the payee (0 = main payee)
565      * @param _deltaAmount modifier amount
566      */ 
567     function updateBalance(bytes32 _requestId, uint8 _payeeIndex, int256 _deltaAmount)
568         external
569     {   
570         Request storage r = requests[_requestId];
571         require(r.currencyContract==msg.sender);
572 
573         if( _payeeIndex == 0 ) {
574             // modify the main payee
575             r.payee.balance = r.payee.balance.add(_deltaAmount);
576         } else {
577             // modify the sub payee
578             Payee storage sp = subPayees[_requestId][_payeeIndex-1];
579             sp.balance = sp.balance.add(_deltaAmount);
580         }
581         UpdateBalance(_requestId, _payeeIndex, _deltaAmount);
582     }
583 
584     /*
585      * @dev Function update the expectedAmount adding additional or subtract
586      * @dev callable only by the currency contract of the request
587      * @param _requestId Request id
588      * @param _payeeIndex index of the payee (0 = main payee)
589      * @param _deltaAmount modifier amount
590      */ 
591     function updateExpectedAmount(bytes32 _requestId, uint8 _payeeIndex, int256 _deltaAmount)
592         external
593     {   
594         Request storage r = requests[_requestId];
595         require(r.currencyContract==msg.sender); 
596 
597         if( _payeeIndex == 0 ) {
598             // modify the main payee
599             r.payee.expectedAmount = r.payee.expectedAmount.add(_deltaAmount);    
600         } else {
601             // modify the sub payee
602             Payee storage sp = subPayees[_requestId][_payeeIndex-1];
603             sp.expectedAmount = sp.expectedAmount.add(_deltaAmount);
604         }
605         UpdateExpectedAmount(_requestId, _payeeIndex, _deltaAmount);
606     }
607 
608     /*
609      * @dev Internal: Init payees for a request (needed to avoid 'stack too deep' in createRequest())
610      * @param _requestId Request id
611      * @param _payees array of payees address
612      * @param _expectedAmounts array of payees initial expected amounts
613      */ 
614     function initSubPayees(bytes32 _requestId, address[] _payees, int256[] _expectedAmounts)
615         internal
616     {
617         require(_payees.length == _expectedAmounts.length);
618      
619         for (uint8 i = 1; i < _payees.length; i = i.add(1))
620         {
621             // payees address cannot be 0x0
622             require(_payees[i] != 0);
623             subPayees[_requestId][i-1] = Payee(_payees[i], _expectedAmounts[i], 0);
624             NewSubPayee(_requestId, _payees[i]);
625         }
626     }
627 
628 
629     /* GETTER */
630     /*
631      * @dev Get address of a payee
632      * @param _requestId Request id
633      * @param _payeeIndex payee index (0 = main payee)
634      * @return payee address
635      */ 
636     function getPayeeAddress(bytes32 _requestId, uint8 _payeeIndex)
637         public
638         constant
639         returns(address)
640     {
641         if(_payeeIndex == 0) {
642             return requests[_requestId].payee.addr;
643         } else {
644             return subPayees[_requestId][_payeeIndex-1].addr;
645         }
646     }
647 
648     /*
649      * @dev Get payer of a request
650      * @param _requestId Request id
651      * @return payer address
652      */ 
653     function getPayer(bytes32 _requestId)
654         public
655         constant
656         returns(address)
657     {
658         return requests[_requestId].payer;
659     }
660 
661     /*
662      * @dev Get amount expected of a payee
663      * @param _requestId Request id
664      * @param _payeeIndex payee index (0 = main payee)
665      * @return amount expected
666      */     
667     function getPayeeExpectedAmount(bytes32 _requestId, uint8 _payeeIndex)
668         public
669         constant
670         returns(int256)
671     {
672         if(_payeeIndex == 0) {
673             return requests[_requestId].payee.expectedAmount;
674         } else {
675             return subPayees[_requestId][_payeeIndex-1].expectedAmount;
676         }
677     }
678 
679     /*
680      * @dev Get number of subPayees for a request
681      * @param _requestId Request id
682      * @return number of subPayees
683      */     
684     function getSubPayeesCount(bytes32 _requestId)
685         public
686         constant
687         returns(uint8)
688     {
689         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1)) {
690             // nothing to do
691         }
692         return i;
693     }
694 
695     /*
696      * @dev Get currencyContract of a request
697      * @param _requestId Request id
698      * @return currencyContract address
699      */
700     function getCurrencyContract(bytes32 _requestId)
701         public
702         constant
703         returns(address)
704     {
705         return requests[_requestId].currencyContract;
706     }
707 
708     /*
709      * @dev Get balance of a payee
710      * @param _requestId Request id
711      * @param _payeeIndex payee index (0 = main payee)
712      * @return balance
713      */     
714     function getPayeeBalance(bytes32 _requestId, uint8 _payeeIndex)
715         public
716         constant
717         returns(int256)
718     {
719         if(_payeeIndex == 0) {
720             return requests[_requestId].payee.balance;    
721         } else {
722             return subPayees[_requestId][_payeeIndex-1].balance;
723         }
724     }
725 
726     /*
727      * @dev Get balance total of a request
728      * @param _requestId Request id
729      * @return balance
730      */     
731     function getBalance(bytes32 _requestId)
732         public
733         constant
734         returns(int256)
735     {
736         int256 balance = requests[_requestId].payee.balance;
737 
738         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1))
739         {
740             balance = balance.add(subPayees[_requestId][i].balance);
741         }
742 
743         return balance;
744     }
745 
746 
747     /*
748      * @dev check if all the payees balances are null
749      * @param _requestId Request id
750      * @return true if all the payees balances are equals to 0
751      */     
752     function areAllBalanceNull(bytes32 _requestId)
753         public
754         constant
755         returns(bool isNull)
756     {
757         isNull = requests[_requestId].payee.balance == 0;
758 
759         for (uint8 i = 0; isNull && subPayees[_requestId][i].addr != address(0); i = i.add(1))
760         {
761             isNull = subPayees[_requestId][i].balance == 0;
762         }
763 
764         return isNull;
765     }
766 
767     /*
768      * @dev Get total expectedAmount of a request
769      * @param _requestId Request id
770      * @return balance
771      */     
772     function getExpectedAmount(bytes32 _requestId)
773         public
774         constant
775         returns(int256)
776     {
777         int256 expectedAmount = requests[_requestId].payee.expectedAmount;
778 
779         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1))
780         {
781             expectedAmount = expectedAmount.add(subPayees[_requestId][i].expectedAmount);
782         }
783 
784         return expectedAmount;
785     }
786 
787     /*
788      * @dev Get state of a request
789      * @param _requestId Request id
790      * @return state
791      */ 
792     function getState(bytes32 _requestId)
793         public
794         constant
795         returns(State)
796     {
797         return requests[_requestId].state;
798     }
799 
800     /*
801      * @dev Get address of a payee
802      * @param _requestId Request id
803      * @return payee index (0 = main payee) or -1 if not address not found
804      */
805     function getPayeeIndex(bytes32 _requestId, address _address)
806         public
807         constant
808         returns(int16)
809     {
810         // return 0 if main payee
811         if(requests[_requestId].payee.addr == _address) return 0;
812 
813         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1))
814         {
815             if(subPayees[_requestId][i].addr == _address) {
816                 // if found return subPayee index + 1 (0 is main payee)
817                 return i+1;
818             }
819         }
820         return -1;
821     }
822 
823     /*
824      * @dev getter of a request
825      * @param _requestId Request id
826      * @return request as a tuple : (address payer, address currencyContract, State state, address payeeAddr, int256 payeeExpectedAmount, int256 payeeBalance)
827      */ 
828     function getRequest(bytes32 _requestId) 
829         external
830         constant
831         returns(address payer, address currencyContract, State state, address payeeAddr, int256 payeeExpectedAmount, int256 payeeBalance)
832     {
833         Request storage r = requests[_requestId];
834         return ( r.payer, 
835                  r.currencyContract, 
836                  r.state, 
837                  r.payee.addr, 
838                  r.payee.expectedAmount, 
839                  r.payee.balance );
840     }
841 
842     /*
843      * @dev extract a string from a bytes. Extracts a sub-part from tha bytes and convert it to string
844      * @param data bytes from where the string will be extracted
845      * @param size string size to extract
846      * @param _offset position of the first byte of the string in bytes
847      * @return string
848      */ 
849     function extractString(bytes data, uint8 size, uint _offset) 
850         internal 
851         pure 
852         returns (string) 
853     {
854         bytes memory bytesString = new bytes(size);
855         for (uint j = 0; j < size; j++) {
856             bytesString[j] = data[_offset+j];
857         }
858         return string(bytesString);
859     }
860 
861     /*
862      * @dev generate a new unique requestId
863      * @return a bytes32 requestId 
864      */ 
865     function generateRequestId()
866         internal
867         returns (bytes32)
868     {
869         // Update numRequest
870         numRequests = numRequests.add(1);
871         // requestId = ADDRESS_CONTRACT_CORE + numRequests (0xADRRESSCONTRACT00000NUMREQUEST)
872         return bytes32((uint256(this) << 96).add(numRequests));
873     }
874 
875     /*
876      * @dev extract an address from a bytes at a given position
877      * @param _data bytes from where the address will be extract
878      * @param _offset position of the first byte of the address
879      * @return address
880      */
881     function extractAddress(bytes _data, uint offset)
882         internal
883         pure
884         returns (address m)
885     {
886         require(offset >=0 && offset + 20 <= _data.length);
887         assembly {
888             m := and( mload(add(_data, add(20, offset))), 
889                       0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
890         }
891     }
892 
893     /*
894      * @dev extract a bytes32 from a bytes
895      * @param data bytes from where the bytes32 will be extract
896      * @param offset position of the first byte of the bytes32
897      * @return address
898      */
899     function extractBytes32(bytes _data, uint offset)
900         public
901         pure
902         returns (bytes32 bs)
903     {
904         require(offset >=0 && offset + 32 <= _data.length);
905         assembly {
906             bs := mload(add(_data, add(32, offset)))
907         }
908     }
909 
910     /**
911      * @dev transfer to owner any tokens send by mistake on this contracts
912      * @param token The address of the token to transfer.
913      * @param amount The amount to be transfered.
914      */
915     function emergencyERC20Drain(ERC20 token, uint amount )
916         public
917         onlyOwner 
918     {
919         token.transfer(owner, amount);
920     }
921 }
922 
923 /**
924  * @title RequestEthereumCollect
925  *
926  * @dev RequestEthereumCollect is a contract managing the fees for ethereum currency contract
927  */
928 contract RequestEthereumCollect is Pausable {
929     using SafeMath for uint256;
930 
931     // fees percentage (per 10 000)
932     uint256 public feesPer10000;
933 
934     // maximum fees in wei
935     uint256 public maxFees;
936 
937     // address of the contract that will burn req token (probably through Kyber)
938     address public requestBurnerContract;
939 
940     /*
941      * @dev Constructor
942      * @param _requestBurnerContract Address of the contract where to send the ethers. 
943      * This burner contract will have a function that can be called by anyone and will exchange ethers to req via Kyber and burn the REQ
944      */  
945     function RequestEthereumCollect(address _requestBurnerContract) 
946         public
947     {
948         requestBurnerContract = _requestBurnerContract;
949     }
950 
951     /*
952      * @dev send fees to the request burning address
953      * @param _amount amount to send to the burning address
954      */  
955     function collectForREQBurning(uint256 _amount)
956         internal
957         returns(bool)
958     {
959         return requestBurnerContract.send(_amount);
960     }
961 
962     /*
963      * @dev compute the fees
964      * @param _expectedAmount amount expected for the request
965      * @return 
966      */  
967     function collectEstimation(int256 _expectedAmount)
968         public
969         view
970         returns(uint256)
971     {
972         // Force potential negative number to 0
973         if (_expectedAmount <= 0) {
974             return 0;
975         }
976         uint256 computedCollect = uint256(_expectedAmount).mul(feesPer10000).div(10000);
977         return computedCollect < maxFees ? computedCollect : maxFees;
978     }
979 
980     /*
981      * @dev set the fees rate (per 10 000)
982      * @param _newRate new rate
983      * @return 
984      */  
985     function setFeesPerTenThousand(uint256 _newRate) 
986         external
987         onlyOwner
988     {
989         feesPer10000=_newRate;
990     }
991 
992     /*
993      * @dev set the maximum fees in wei
994      * @param _newMax new max
995      * @return 
996      */  
997     function setMaxCollectable(uint256 _newMax) 
998         external
999         onlyOwner
1000     {
1001         maxFees=_newMax;
1002     }
1003 
1004     /*
1005      * @dev set the request burner address
1006      * @param _requestBurnerContract address of the contract that will burn req token (probably through Kyber)
1007      * @return 
1008      */  
1009     function setRequestBurnerContract(address _requestBurnerContract) 
1010         external
1011         onlyOwner
1012     {
1013         requestBurnerContract=_requestBurnerContract;
1014     }
1015 }
1016 
1017 
1018 
1019 /**
1020  * @title RequestEthereum
1021  *
1022  * @dev RequestEthereum is the currency contract managing the request in Ethereum
1023  * @dev The contract can be paused. In this case, nobody can create Requests anymore but people can still interact with them.
1024  *
1025  * @dev Requests can be created by the Payee with createRequestAsPayee(), by the payer with createRequestAsPayer() or by the payer from a request signed offchain by the payee with broadcastSignedRequestAsPayer()
1026  */
1027 contract RequestEthereum is RequestEthereumCollect {
1028     using SafeMath for uint256;
1029     using SafeMathInt for int256;
1030     using SafeMathUint8 for uint8;
1031 
1032     // RequestCore object
1033     RequestCore public requestCore;
1034 
1035     // payment addresses by requestId (optional). We separate the Identity of the payee/payer (in the core) and the wallet address in the currency contract
1036     mapping(bytes32 => address[256]) public payeesPaymentAddress;
1037     mapping(bytes32 => address) public payerRefundAddress;
1038 
1039     /*
1040      * @dev Constructor
1041      * @param _requestCoreAddress Request Core address
1042      * @param _requestBurnerAddress Request Burner contract address
1043      */
1044     function RequestEthereum(address _requestCoreAddress, address _requestBurnerAddress) RequestEthereumCollect(_requestBurnerAddress) public
1045     {
1046         requestCore=RequestCore(_requestCoreAddress);
1047     }
1048 
1049     /*
1050      * @dev Function to create a request as payee
1051      *
1052      * @dev msg.sender will be the payee
1053      * @dev if _payeesPaymentAddress.length > _payeesIdAddress.length, the extra addresses will be stored but never used
1054      * @dev If a contract is given as a payee make sure it is payable. Otherwise, the request will not be payable.
1055      *
1056      * @param _payeesIdAddress array of payees address (the index 0 will be the payee - must be msg.sender - the others are subPayees)
1057      * @param _payeesPaymentAddress array of payees address for payment (optional)
1058      * @param _expectedAmounts array of Expected amount to be received by each payees
1059      * @param _payer Entity expected to pay
1060      * @param _payerRefundAddress Address of refund for the payer (optional)
1061      * @param _data Hash linking to additional data on the Request stored on IPFS
1062      *
1063      * @return Returns the id of the request
1064      */
1065     function createRequestAsPayee(
1066         address[]   _payeesIdAddress,
1067         address[]   _payeesPaymentAddress,
1068         int256[]    _expectedAmounts,
1069         address     _payer,
1070         address     _payerRefundAddress,
1071         string      _data)
1072         external
1073         payable
1074         whenNotPaused
1075         returns(bytes32 requestId)
1076     {
1077         require(msg.sender == _payeesIdAddress[0] && msg.sender != _payer && _payer != 0);
1078 
1079         uint256 fees;
1080         (requestId, fees) = createRequest(_payer, _payeesIdAddress, _payeesPaymentAddress, _expectedAmounts, _payerRefundAddress, _data);
1081 
1082         // check if the value send match exactly the fees (no under or over payment allowed)
1083         require(fees == msg.value);
1084 
1085         return requestId;
1086     }
1087 
1088     /*
1089      * @dev Function to create a request as payer. The request is payed if _payeeAmounts > 0.
1090      *
1091      * @dev msg.sender will be the payer
1092      * @dev If a contract is given as a payee make sure it is payable. Otherwise, the request will not be payable.
1093      *
1094      * @param _payeesIdAddress array of payees address (the index 0 will be the payee the others are subPayees)
1095      * @param _expectedAmounts array of Expected amount to be received by each payees
1096      * @param _payerRefundAddress Address of refund for the payer (optional)
1097      * @param _payeeAmounts array of amount repartition for the payment
1098      * @param _additionals array to increase the ExpectedAmount for payees
1099      * @param _data Hash linking to additional data on the Request stored on IPFS
1100      *
1101      * @return Returns the id of the request
1102      */
1103     function createRequestAsPayer(
1104         address[]   _payeesIdAddress,
1105         int256[]    _expectedAmounts,
1106         address     _payerRefundAddress,
1107         uint256[]   _payeeAmounts,
1108         uint256[]   _additionals,
1109         string      _data)
1110         external
1111         payable
1112         whenNotPaused
1113         returns(bytes32 requestId)
1114     {
1115         require(msg.sender != _payeesIdAddress[0] && _payeesIdAddress[0] != 0);
1116 
1117         // payeesPaymentAddress is not offered as argument here to avoid scam
1118         address[] memory emptyPayeesPaymentAddress = new address[](0);
1119         uint256 fees;
1120         (requestId, fees) = createRequest(msg.sender, _payeesIdAddress, emptyPayeesPaymentAddress, _expectedAmounts, _payerRefundAddress, _data);
1121 
1122         // accept and pay the request with the value remaining after the fee collect
1123         acceptAndPay(requestId, _payeeAmounts, _additionals, msg.value.sub(fees));
1124 
1125         return requestId;
1126     }
1127 
1128 
1129     /*
1130      * @dev Function to broadcast and accept an offchain signed request (can be paid and additionals also)
1131      *
1132      * @dev _payer will be set msg.sender
1133      * @dev if _payeesPaymentAddress.length > _requestData.payeesIdAddress.length, the extra addresses will be stored but never used
1134      * @dev If a contract is given as a payee make sure it is payable. Otherwise, the request will not be payable.
1135      *
1136      * @param _requestData nested bytes containing : creator, payer, payees, expectedAmounts, data
1137      * @param _payeesPaymentAddress array of payees address for payment (optional) 
1138      * @param _payeeAmounts array of amount repartition for the payment
1139      * @param _additionals array to increase the ExpectedAmount for payees
1140      * @param _expirationDate timestamp after that the signed request cannot be broadcasted
1141      * @param _signature ECDSA signature in bytes
1142      *
1143      * @return Returns the id of the request
1144      */
1145     function broadcastSignedRequestAsPayer(
1146         bytes       _requestData, // gather data to avoid "stack too deep"
1147         address[]   _payeesPaymentAddress,
1148         uint256[]   _payeeAmounts,
1149         uint256[]   _additionals,
1150         uint256     _expirationDate,
1151         bytes       _signature)
1152         external
1153         payable
1154         whenNotPaused
1155         returns(bytes32)
1156     {
1157         // check expiration date
1158         require(_expirationDate >= block.timestamp);
1159 
1160         // check the signature
1161         require(checkRequestSignature(_requestData, _payeesPaymentAddress, _expirationDate, _signature));
1162 
1163         // create accept and pay the request
1164         return createAcceptAndPayFromBytes(_requestData,  _payeesPaymentAddress, _payeeAmounts, _additionals);
1165     }
1166 
1167     /*
1168      * @dev Internal function to create, accept, add additionals and pay a request as Payer
1169      *
1170      * @dev msg.sender must be _payer
1171      *
1172      * @param _requestData nasty bytes containing : creator, payer, payees|expectedAmounts, data
1173      * @param _payeesPaymentAddress array of payees address for payment (optional)
1174      * @param _payeeAmounts array of amount repartition for the payment
1175      * @param _additionals Will increase the ExpectedAmount of the request right after its creation by adding additionals
1176      *
1177      * @return Returns the id of the request
1178      */
1179     function createAcceptAndPayFromBytes(
1180         bytes       _requestData,
1181         address[]   _payeesPaymentAddress,
1182         uint256[]   _payeeAmounts,
1183         uint256[]   _additionals)
1184         internal
1185         returns(bytes32 requestId)
1186     {
1187         // extract main payee
1188         address mainPayee = extractAddress(_requestData, 41);
1189         require(msg.sender != mainPayee && mainPayee != 0);
1190         // creator must be the main payee
1191         require(extractAddress(_requestData, 0) == mainPayee);
1192 
1193         // extract the number of payees
1194         uint8 payeesCount = uint8(_requestData[40]);
1195         int256 totalExpectedAmounts = 0;
1196         for(uint8 i = 0; i < payeesCount; i++) {
1197             // extract the expectedAmount for the payee[i]
1198             // NB: no need of SafeMath here because 0 < i < 256 (uint8)
1199             int256 expectedAmountTemp = int256(extractBytes32(_requestData, 61 + 52 * uint256(i)));
1200             // compute the total expected amount of the request
1201             totalExpectedAmounts = totalExpectedAmounts.add(expectedAmountTemp);
1202             // all expected amount must be positibe
1203             require(expectedAmountTemp>0);
1204         }
1205 
1206         // collect the fees
1207         uint256 fees = collectEstimation(totalExpectedAmounts);
1208 
1209         // check fees has been well received
1210         // do the action and assertion in one to save a variable
1211         require(collectForREQBurning(fees));
1212 
1213         // insert the msg.sender as the payer in the bytes
1214         updateBytes20inBytes(_requestData, 20, bytes20(msg.sender));
1215         // store request in the core,
1216         requestId = requestCore.createRequestFromBytes(_requestData);
1217 
1218         // set payment addresses for payees
1219         for (uint8 j = 0; j < _payeesPaymentAddress.length; j = j.add(1)) {
1220             payeesPaymentAddress[requestId][j] = _payeesPaymentAddress[j];
1221         }
1222 
1223         // accept and pay the request with the value remaining after the fee collect
1224         acceptAndPay(requestId, _payeeAmounts, _additionals, msg.value.sub(fees));
1225 
1226         return requestId;
1227     }
1228 
1229 
1230     /*
1231      * @dev Internal function to create a request
1232      *
1233      * @dev msg.sender is the creator of the request
1234      *
1235      * @param _payer Payer identity address
1236      * @param _payees Payees identity address
1237      * @param _payeesPaymentAddress Payees payment address
1238      * @param _expectedAmounts Expected amounts to be received by payees
1239      * @param _payerRefundAddress payer refund address
1240      * @param _data Hash linking to additional data on the Request stored on IPFS
1241      *
1242      * @return Returns the id of the request
1243      */
1244     function createRequest(
1245         address     _payer,
1246         address[]   _payees,
1247         address[]   _payeesPaymentAddress,
1248         int256[]    _expectedAmounts,
1249         address     _payerRefundAddress,
1250         string      _data)
1251         internal
1252         returns(bytes32 requestId, uint256 fees)
1253     {
1254         int256 totalExpectedAmounts = 0;
1255         for (uint8 i = 0; i < _expectedAmounts.length; i = i.add(1))
1256         {
1257             // all expected amount must be positive
1258             require(_expectedAmounts[i]>=0);
1259             // compute the total expected amount of the request
1260             totalExpectedAmounts = totalExpectedAmounts.add(_expectedAmounts[i]);
1261         }
1262 
1263         // collect the fees
1264         fees = collectEstimation(totalExpectedAmounts);
1265         // check fees has been well received
1266         require(collectForREQBurning(fees));
1267 
1268         // store request in the core
1269         requestId= requestCore.createRequest(msg.sender, _payees, _expectedAmounts, _payer, _data);
1270 
1271         // set payment addresses for payees
1272         for (uint8 j = 0; j < _payeesPaymentAddress.length; j = j.add(1)) {
1273             payeesPaymentAddress[requestId][j] = _payeesPaymentAddress[j];
1274         }
1275         // set payment address for payer
1276         if(_payerRefundAddress != 0) {
1277             payerRefundAddress[requestId] = _payerRefundAddress;
1278         }
1279     }
1280 
1281     /*
1282      * @dev Internal function to accept, add additionals and pay a request as Payer
1283      *
1284      * @param _requestId id of the request
1285      * @param _payeesAmounts Amount to pay to payees (sum must be equals to _amountPaid)
1286      * @param _additionals Will increase the ExpectedAmounts of payees
1287      * @param _amountPaid amount in msg.value minus the fees
1288      *
1289      */ 
1290     function acceptAndPay(
1291         bytes32 _requestId,
1292         uint256[] _payeeAmounts,
1293         uint256[] _additionals,
1294         uint256 _amountPaid)
1295         internal
1296     {
1297         requestCore.accept(_requestId);
1298         
1299         additionalInternal(_requestId, _additionals);
1300 
1301         if(_amountPaid > 0) {
1302             paymentInternal(_requestId, _payeeAmounts, _amountPaid);
1303         }
1304     }
1305 
1306     // ---- INTERFACE FUNCTIONS ------------------------------------------------------------------------------------
1307 
1308     /*
1309      * @dev Function to accept a request
1310      *
1311      * @dev msg.sender must be _payer
1312      * @dev A request can also be accepted by using directly the payment function on a request in the Created status
1313      *
1314      * @param _requestId id of the request
1315      */
1316     function accept(bytes32 _requestId)
1317         external
1318         whenNotPaused
1319         condition(requestCore.getPayer(_requestId)==msg.sender)
1320         condition(requestCore.getState(_requestId)==RequestCore.State.Created)
1321     {
1322         requestCore.accept(_requestId);
1323     }
1324 
1325     /*
1326      * @dev Function to cancel a request
1327      *
1328      * @dev msg.sender must be the _payer or the _payee.
1329      * @dev only request with balance equals to zero can be cancel
1330      *
1331      * @param _requestId id of the request
1332      */
1333     function cancel(bytes32 _requestId)
1334         external
1335         whenNotPaused
1336     {
1337         // payer can cancel if request is just created
1338         bool isPayerAndCreated = requestCore.getPayer(_requestId)==msg.sender && requestCore.getState(_requestId)==RequestCore.State.Created;
1339 
1340         // payee can cancel when request is not canceled yet
1341         bool isPayeeAndNotCanceled = requestCore.getPayeeAddress(_requestId,0)==msg.sender && requestCore.getState(_requestId)!=RequestCore.State.Canceled;
1342 
1343         require(isPayerAndCreated || isPayeeAndNotCanceled);
1344 
1345         // impossible to cancel a Request with any payees balance != 0
1346         require(requestCore.areAllBalanceNull(_requestId));
1347 
1348         requestCore.cancel(_requestId);
1349     }
1350 
1351     // ----------------------------------------------------------------------------------------
1352 
1353 
1354     // ---- CONTRACT FUNCTIONS ------------------------------------------------------------------------------------
1355     /*
1356      * @dev Function PAYABLE to pay a request in ether.
1357      *
1358      * @dev the request will be automatically accepted if msg.sender==payer.
1359      *
1360      * @param _requestId id of the request
1361      * @param _payeesAmounts Amount to pay to payees (sum must be equal to msg.value) in wei
1362      * @param _additionalsAmount amount of additionals per payee in wei to declare
1363      */
1364     function paymentAction(
1365         bytes32 _requestId,
1366         uint256[] _payeeAmounts,
1367         uint256[] _additionalAmounts)
1368         external
1369         whenNotPaused
1370         payable
1371         condition(requestCore.getState(_requestId)!=RequestCore.State.Canceled)
1372         condition(_additionalAmounts.length == 0 || msg.sender == requestCore.getPayer(_requestId))
1373     {
1374         // automatically accept request if request is created and msg.sender is payer
1375         if(requestCore.getState(_requestId)==RequestCore.State.Created && msg.sender == requestCore.getPayer(_requestId)) {
1376             requestCore.accept(_requestId);
1377         }
1378 
1379         additionalInternal(_requestId, _additionalAmounts);
1380 
1381         paymentInternal(_requestId, _payeeAmounts, msg.value);
1382     }
1383 
1384     /*
1385      * @dev Function PAYABLE to pay back in ether a request to the payer
1386      *
1387      * @dev msg.sender must be one of the payees
1388      * @dev the request must be created or accepted
1389      *
1390      * @param _requestId id of the request
1391      */
1392     function refundAction(bytes32 _requestId)
1393         external
1394         whenNotPaused
1395         payable
1396     {
1397         refundInternal(_requestId, msg.sender, msg.value);
1398     }
1399 
1400     /*
1401      * @dev Function to declare a subtract
1402      *
1403      * @dev msg.sender must be _payee
1404      * @dev the request must be accepted or created
1405      *
1406      * @param _requestId id of the request
1407      * @param _subtractAmounts amounts of subtract in wei to declare (index 0 is for main payee)
1408      */
1409     function subtractAction(bytes32 _requestId, uint256[] _subtractAmounts)
1410         external
1411         whenNotPaused
1412         condition(requestCore.getState(_requestId)!=RequestCore.State.Canceled)
1413         onlyRequestPayee(_requestId)
1414     {
1415         for(uint8 i = 0; i < _subtractAmounts.length; i = i.add(1)) {
1416             if(_subtractAmounts[i] != 0) {
1417                 // subtract must be equal or lower than amount expected
1418                 require(requestCore.getPayeeExpectedAmount(_requestId,i) >= _subtractAmounts[i].toInt256Safe());
1419                 // store and declare the subtract in the core
1420                 requestCore.updateExpectedAmount(_requestId, i, -_subtractAmounts[i].toInt256Safe());
1421             }
1422         }
1423     }
1424 
1425     /*
1426      * @dev Function to declare an additional
1427      *
1428      * @dev msg.sender must be _payer
1429      * @dev the request must be accepted or created
1430      *
1431      * @param _requestId id of the request
1432      * @param _additionalAmounts amounts of additional in wei to declare (index 0 is for main payee)
1433      */
1434     function additionalAction(bytes32 _requestId, uint256[] _additionalAmounts)
1435         external
1436         whenNotPaused
1437         condition(requestCore.getState(_requestId)!=RequestCore.State.Canceled)
1438         onlyRequestPayer(_requestId)
1439     {
1440         additionalInternal(_requestId, _additionalAmounts);
1441     }
1442     // ----------------------------------------------------------------------------------------
1443 
1444 
1445     // ---- INTERNAL FUNCTIONS ------------------------------------------------------------------------------------
1446     /*
1447      * @dev Function internal to manage additional declaration
1448      *
1449      * @param _requestId id of the request
1450      * @param _additionalAmounts amount of additional to declare
1451      */
1452     function additionalInternal(bytes32 _requestId, uint256[] _additionalAmounts)
1453         internal
1454     {
1455         // we cannot have more additional amounts declared than actual payees but we can have fewer
1456         require(_additionalAmounts.length <= requestCore.getSubPayeesCount(_requestId).add(1));
1457 
1458         for(uint8 i = 0; i < _additionalAmounts.length; i = i.add(1)) {
1459             if(_additionalAmounts[i] != 0) {
1460                 // Store and declare the additional in the core
1461                 requestCore.updateExpectedAmount(_requestId, i, _additionalAmounts[i].toInt256Safe());
1462             }
1463         }
1464     }
1465 
1466     /*
1467      * @dev Function internal to manage payment declaration
1468      *
1469      * @param _requestId id of the request
1470      * @param _payeesAmounts Amount to pay to payees (sum must be equals to msg.value)
1471      * @param _value amount paid
1472      */
1473     function paymentInternal(
1474         bytes32     _requestId,
1475         uint256[]   _payeeAmounts,
1476         uint256     _value)
1477         internal
1478     {
1479         // we cannot have more amounts declared than actual payees
1480         require(_payeeAmounts.length <= requestCore.getSubPayeesCount(_requestId).add(1));
1481 
1482         uint256 totalPayeeAmounts = 0;
1483 
1484         for(uint8 i = 0; i < _payeeAmounts.length; i = i.add(1)) {
1485             if(_payeeAmounts[i] != 0) {
1486                 // compute the total amount declared
1487                 totalPayeeAmounts = totalPayeeAmounts.add(_payeeAmounts[i]);
1488 
1489                 // Store and declare the payment to the core
1490                 requestCore.updateBalance(_requestId, i, _payeeAmounts[i].toInt256Safe());
1491 
1492                 // pay the payment address if given, the id address otherwise
1493                 address addressToPay;
1494                 if(payeesPaymentAddress[_requestId][i] == 0) {
1495                     addressToPay = requestCore.getPayeeAddress(_requestId, i);
1496                 } else {
1497                     addressToPay = payeesPaymentAddress[_requestId][i];
1498                 }
1499 
1500                 //payment done, the money was sent
1501                 fundOrderInternal(addressToPay, _payeeAmounts[i]);
1502             }
1503         }
1504 
1505         // check if payment repartition match the value paid
1506         require(_value==totalPayeeAmounts);
1507     }
1508 
1509     /*
1510      * @dev Function internal to manage refund declaration
1511      *
1512      * @param _requestId id of the request
1513 
1514      * @param _fromAddress address from where the refund has been done
1515      * @param _amount amount of the refund in wei to declare
1516      *
1517      * @return true if the refund is done, false otherwise
1518      */
1519     function refundInternal(
1520         bytes32 _requestId,
1521         address _fromAddress,
1522         uint256 _amount)
1523         condition(requestCore.getState(_requestId)!=RequestCore.State.Canceled)
1524         internal
1525     {
1526         // Check if the _fromAddress is a payeesId
1527         // int16 to allow -1 value
1528         int16 payeeIndex = requestCore.getPayeeIndex(_requestId, _fromAddress);
1529         if(payeeIndex < 0) {
1530             uint8 payeesCount = requestCore.getSubPayeesCount(_requestId).add(1);
1531 
1532             // if not ID addresses maybe in the payee payments addresses
1533             for (uint8 i = 0; i < payeesCount && payeeIndex == -1; i = i.add(1)) {
1534                 if(payeesPaymentAddress[_requestId][i] == _fromAddress) {
1535                     // get the payeeIndex
1536                     payeeIndex = int16(i);
1537                 }
1538             }
1539         }
1540         // the address must be found somewhere
1541         require(payeeIndex >= 0); 
1542 
1543         // Casting to uin8 doesn't lose bits because payeeIndex < 256. payeeIndex was declared int16 to allow -1
1544         requestCore.updateBalance(_requestId, uint8(payeeIndex), -_amount.toInt256Safe());
1545 
1546         // refund to the payment address if given, the id address otherwise
1547         address addressToPay = payerRefundAddress[_requestId];
1548         if(addressToPay == 0) {
1549             addressToPay = requestCore.getPayer(_requestId);
1550         }
1551 
1552         // refund declared, the money is ready to be sent to the payer
1553         fundOrderInternal(addressToPay, _amount);
1554     }
1555 
1556     /*
1557      * @dev Function internal to manage fund mouvement
1558      * @dev We had to chose between a withdrawal pattern, a transfer pattern or a transfer+withdrawal pattern and chose the transfer pattern.
1559      * @dev The withdrawal pattern would make UX difficult. The transfer+withdrawal pattern would make contracts interacting with the request protocol complex.
1560      * @dev N.B.: The transfer pattern will have to be clearly explained to users. It enables a payee to create unpayable requests.
1561      *
1562      * @param _recipient address where the wei has to be sent to
1563      * @param _amount amount in wei to send
1564      *
1565      */
1566     function fundOrderInternal(
1567         address _recipient,
1568         uint256 _amount)
1569         internal
1570     {
1571         _recipient.transfer(_amount);
1572     }
1573 
1574     /*
1575      * @dev Function internal to calculate Keccak-256 hash of a request with specified parameters
1576      *
1577      * @param _data bytes containing all the data packed
1578      * @param _payeesPaymentAddress array of payees payment addresses
1579      * @param _expirationDate timestamp after what the signed request cannot be broadcasted
1580      *
1581      * @return Keccak-256 hash of (this,_requestData, _payeesPaymentAddress, _expirationDate)
1582      */
1583     function getRequestHash(
1584         // _requestData is from the core
1585         bytes       _requestData,
1586 
1587         // _payeesPaymentAddress and _expirationDate are not from the core but needs to be signed
1588         address[]   _payeesPaymentAddress,
1589         uint256     _expirationDate)
1590         internal
1591         view
1592         returns(bytes32)
1593     {
1594         return keccak256(this, _requestData, _payeesPaymentAddress, _expirationDate);
1595     }
1596 
1597     /*
1598      * @dev Verifies that a hash signature is valid. 0x style
1599      * @param signer address of signer.
1600      * @param hash Signed Keccak-256 hash.
1601      * @param v ECDSA signature parameter v.
1602      * @param r ECDSA signature parameters r.
1603      * @param s ECDSA signature parameters s.
1604      * @return Validity of order signature.
1605      */
1606     function isValidSignature(
1607         address signer,
1608         bytes32 hash,
1609         uint8   v,
1610         bytes32 r,
1611         bytes32 s)
1612         public
1613         pure
1614         returns (bool)
1615     {
1616         return signer == ecrecover(
1617             keccak256("\x19Ethereum Signed Message:\n32", hash),
1618             v,
1619             r,
1620             s
1621         );
1622     }
1623 
1624     /*
1625      * @dev Check the validity of a signed request & the expiration date
1626      * @param _data bytes containing all the data packed :
1627             address(creator)
1628             address(payer)
1629             uint8(number_of_payees)
1630             [
1631                 address(main_payee_address)
1632                 int256(main_payee_expected_amount)
1633                 address(second_payee_address)
1634                 int256(second_payee_expected_amount)
1635                 ...
1636             ]
1637             uint8(data_string_size)
1638             size(data)
1639      * @param _payeesPaymentAddress array of payees payment addresses (the index 0 will be the payee the others are subPayees)
1640      * @param _expirationDate timestamp after that the signed request cannot be broadcasted
1641      * @param _signature ECDSA signature containing v, r and s as bytes
1642      *
1643      * @return Validity of order signature.
1644      */ 
1645     function checkRequestSignature(
1646         bytes       _requestData,
1647         address[]   _payeesPaymentAddress,
1648         uint256     _expirationDate,
1649         bytes       _signature)
1650         public
1651         view
1652         returns (bool)
1653     {
1654         bytes32 hash = getRequestHash(_requestData, _payeesPaymentAddress, _expirationDate);
1655 
1656         // extract "v, r, s" from the signature
1657         uint8 v = uint8(_signature[64]);
1658         v = v < 27 ? v.add(27) : v;
1659         bytes32 r = extractBytes32(_signature, 0);
1660         bytes32 s = extractBytes32(_signature, 32);
1661 
1662         // check signature of the hash with the creator address
1663         return isValidSignature(extractAddress(_requestData, 0), hash, v, r, s);
1664     }
1665 
1666     //modifier
1667     modifier condition(bool c)
1668     {
1669         require(c);
1670         _;
1671     }
1672 
1673     /*
1674      * @dev Modifier to check if msg.sender is payer
1675      * @dev Revert if msg.sender is not payer
1676      * @param _requestId id of the request
1677      */ 
1678     modifier onlyRequestPayer(bytes32 _requestId)
1679     {
1680         require(requestCore.getPayer(_requestId)==msg.sender);
1681         _;
1682     }
1683     
1684     /*
1685      * @dev Modifier to check if msg.sender is the main payee
1686      * @dev Revert if msg.sender is not the main payee
1687      * @param _requestId id of the request
1688      */ 
1689     modifier onlyRequestPayee(bytes32 _requestId)
1690     {
1691         require(requestCore.getPayeeAddress(_requestId, 0)==msg.sender);
1692         _;
1693     }
1694 
1695     /*
1696      * @dev modify 20 bytes in a bytes
1697      * @param data bytes to modify
1698      * @param offset position of the first byte to modify
1699      * @param b bytes20 to insert
1700      * @return address
1701      */
1702     function updateBytes20inBytes(bytes data, uint offset, bytes20 b)
1703         internal
1704         pure
1705     {
1706         require(offset >=0 && offset + 20 <= data.length);
1707         assembly {
1708             let m := mload(add(data, add(20, offset)))
1709             m := and(m, 0xFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000)
1710             m := or(m, div(b, 0x1000000000000000000000000))
1711             mstore(add(data, add(20, offset)), m)
1712         }
1713     }
1714 
1715     /*
1716      * @dev extract an address in a bytes
1717      * @param data bytes from where the address will be extract
1718      * @param offset position of the first byte of the address
1719      * @return address
1720      */
1721     function extractAddress(bytes _data, uint offset)
1722         internal
1723         pure
1724         returns (address m) 
1725     {
1726         require(offset >=0 && offset + 20 <= _data.length);
1727         assembly {
1728             m := and( mload(add(_data, add(20, offset))), 
1729                       0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
1730         }
1731     }
1732 
1733     /*
1734      * @dev extract a bytes32 from a bytes
1735      * @param data bytes from where the bytes32 will be extract
1736      * @param offset position of the first byte of the bytes32
1737      * @return address
1738      */
1739     function extractBytes32(bytes _data, uint offset)
1740         public
1741         pure
1742         returns (bytes32 bs)
1743     {
1744         require(offset >=0 && offset + 32 <= _data.length);
1745         assembly {
1746             bs := mload(add(_data, add(32, offset)))
1747         }
1748     }
1749 
1750 
1751     /**
1752      * @dev transfer to owner any tokens send by mistake on this contracts
1753      * @param token The address of the token to transfer.
1754      * @param amount The amount to be transfered.
1755      */
1756     function emergencyERC20Drain(ERC20 token, uint amount )
1757         public
1758         onlyOwner 
1759     {
1760         token.transfer(owner, amount);
1761     }
1762 }