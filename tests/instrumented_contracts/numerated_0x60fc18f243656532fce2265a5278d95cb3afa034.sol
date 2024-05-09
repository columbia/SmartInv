1 pragma solidity 0.4.18;
2 
3 // From https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11 
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 
34   function toInt256Safe(uint256 a) internal pure returns (int256) {
35     int256 b = int256(a);
36     assert(b >= 0);
37     return b;
38   }
39 }
40 
41 /**
42  * @title SafeMathInt
43  * @dev Math operations with safety checks that throw on error
44  * @dev SafeMath adapted for int256
45  */
46 library SafeMathInt {
47   function mul(int256 a, int256 b) internal pure returns (int256) {
48     // Prevent overflow when multiplying INT256_MIN with -1
49     // https://github.com/RequestNetwork/requestNetwork/issues/43
50     assert(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
51 
52     int256 c = a * b;
53     assert((b == 0) || (c / b == a));
54     return c;
55   }
56 
57   function div(int256 a, int256 b) internal pure returns (int256) {
58     // Prevent overflow when dividing INT256_MIN by -1
59     // https://github.com/RequestNetwork/requestNetwork/issues/43
60     assert(!(a == - 2**255 && b == -1));
61 
62     // assert(b > 0); // Solidity automatically throws when dividing by 0
63     int256 c = a / b;
64     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65     return c;
66   }
67 
68   function sub(int256 a, int256 b) internal pure returns (int256) {
69     assert((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
70 
71     return a - b;
72   }
73 
74   function add(int256 a, int256 b) internal pure returns (int256) {
75     int256 c = a + b;
76     assert((b >= 0 && c >= a) || (b < 0 && c < a));
77     return c;
78   }
79 
80   function toUint256Safe(int256 a) internal pure returns (uint256) {
81     assert(a>=0);
82     return uint256(a);
83   }
84 }
85 
86 
87 /**
88  * @title SafeMath
89  * @dev Math operations with safety checks that throw on error
90  * @dev SafeMath adapted for uint96
91  */
92 library SafeMathUint96 {
93   function mul(uint96 a, uint96 b) internal pure returns (uint96) {
94     uint96 c = a * b;
95     assert(a == 0 || c / a == b);
96     return c;
97   }
98 
99   function div(uint96 a, uint96 b) internal pure returns (uint96) {
100     // assert(b > 0); // Solidity automatically throws when dividing by 0
101     uint96 c = a / b;
102     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103     return c;
104   }
105 
106   function sub(uint96 a, uint96 b) internal pure returns (uint96) {
107     assert(b <= a);
108     return a - b;
109   }
110 
111   function add(uint96 a, uint96 b) internal pure returns (uint96) {
112     uint96 c = a + b;
113     assert(c >= a);
114     return c;
115   }
116 }
117 
118 
119 /**
120  * @title SafeMath
121  * @dev Math operations with safety checks that throw on error
122  * @dev SafeMath adapted for uint8
123  */
124 library SafeMathUint8 {
125   function mul(uint8 a, uint8 b) internal pure returns (uint8) {
126     uint8 c = a * b;
127     assert(a == 0 || c / a == b);
128     return c;
129   }
130 
131   function div(uint8 a, uint8 b) internal pure returns (uint8) {
132     // assert(b > 0); // Solidity automatically throws when dividing by 0
133     uint8 c = a / b;
134     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135     return c;
136   }
137 
138   function sub(uint8 a, uint8 b) internal pure returns (uint8) {
139     assert(b <= a);
140     return a - b;
141   }
142 
143   function add(uint8 a, uint8 b) internal pure returns (uint8) {
144     uint8 c = a + b;
145     assert(c >= a);
146     return c;
147   }
148 }
149 
150 
151 /**
152  * @title Ownable
153  * @dev The Ownable contract has an owner address, and provides basic authorization control
154  * functions, this simplifies the implementation of "user permissions".
155  */
156 contract Ownable {
157   address public owner;
158 
159 
160   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
161 
162 
163   /**
164    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
165    * account.
166    */
167   function Ownable() public {
168     owner = msg.sender;
169   }
170 
171 
172   /**
173    * @dev Throws if called by any account other than the owner.
174    */
175   modifier onlyOwner() {
176     require(msg.sender == owner);
177     _;
178   }
179 
180 
181   /**
182    * @dev Allows the current owner to transfer control of the contract to a newOwner.
183    * @param newOwner The address to transfer ownership to.
184    */
185   function transferOwnership(address newOwner) onlyOwner public {
186     require(newOwner != address(0));
187     OwnershipTransferred(owner, newOwner);
188     owner = newOwner;
189   }
190 
191 }
192 
193 
194 /**
195  * @title Pausable
196  * @dev Base contract which allows children to implement an emergency stop mechanism.
197  */
198 contract Pausable is Ownable {
199   event Pause();
200   event Unpause();
201 
202   bool public paused = false;
203 
204 
205   /**
206    * @dev Modifier to make a function callable only when the contract is not paused.
207    */
208   modifier whenNotPaused() {
209     require(!paused);
210     _;
211   }
212 
213   /**
214    * @dev Modifier to make a function callable only when the contract is paused.
215    */
216   modifier whenPaused() {
217     require(paused);
218     _;
219   }
220 
221   /**
222    * @dev called by the owner to pause, triggers stopped state
223    */
224   function pause() onlyOwner whenNotPaused public {
225     paused = true;
226     Pause();
227   }
228 
229   /**
230    * @dev called by the owner to unpause, returns to normal state
231    */
232   function unpause() onlyOwner whenPaused public {
233     paused = false;
234     Unpause();
235   }
236 }
237 
238 /**
239  * @title Administrable
240  * @dev Base contract for the administration of Core. Handles whitelisting of currency contracts
241  */
242 contract Administrable is Pausable {
243 
244     // mapping of address of trusted contract
245     mapping(address => uint8) public trustedCurrencyContracts;
246 
247     // Events of the system
248     event NewTrustedContract(address newContract);
249     event RemoveTrustedContract(address oldContract);
250 
251     /**
252      * @dev add a trusted currencyContract 
253      *
254      * @param _newContractAddress The address of the currencyContract
255      */
256     function adminAddTrustedCurrencyContract(address _newContractAddress)
257         external
258         onlyOwner
259     {
260         trustedCurrencyContracts[_newContractAddress] = 1; //Using int instead of boolean in case we need several states in the future.
261         NewTrustedContract(_newContractAddress);
262     }
263 
264     /**
265      * @dev remove a trusted currencyContract 
266      *
267      * @param _oldTrustedContractAddress The address of the currencyContract
268      */
269     function adminRemoveTrustedCurrencyContract(address _oldTrustedContractAddress)
270         external
271         onlyOwner
272     {
273         require(trustedCurrencyContracts[_oldTrustedContractAddress] != 0);
274         trustedCurrencyContracts[_oldTrustedContractAddress] = 0;
275         RemoveTrustedContract(_oldTrustedContractAddress);
276     }
277 
278     /**
279      * @dev get the status of a trusted currencyContract 
280      * @dev Not used today, useful if we have several states in the future.
281      *
282      * @param _contractAddress The address of the currencyContract
283      * @return The status of the currencyContract. If trusted 1, otherwise 0
284      */
285     function getStatusContract(address _contractAddress)
286         view
287         external
288         returns(uint8) 
289     {
290         return trustedCurrencyContracts[_contractAddress];
291     }
292 
293     /**
294      * @dev check if a currencyContract is trusted
295      *
296      * @param _contractAddress The address of the currencyContract
297      * @return bool true if contract is trusted
298      */
299     function isTrustedContract(address _contractAddress)
300         public
301         view
302         returns(bool)
303     {
304         return trustedCurrencyContracts[_contractAddress] == 1;
305     }
306 }
307 
308 
309 /**
310  * @title ERC20Basic
311  * @dev Simpler version of ERC20 interface
312  * @dev see https://github.com/ethereum/EIPs/issues/179
313  */
314 contract ERC20Basic {
315   uint256 public totalSupply;
316   function balanceOf(address who) public constant returns (uint256);
317   function transfer(address to, uint256 value) public returns (bool);
318   event Transfer(address indexed from, address indexed to, uint256 value);
319 }
320 
321 
322 /**
323  * @title ERC20 interface
324  * @dev see https://github.com/ethereum/EIPs/issues/20
325  */
326 contract ERC20 is ERC20Basic {
327   function allowance(address owner, address spender) public constant returns (uint256);
328   function transferFrom(address from, address to, uint256 value) public returns (bool);
329   function approve(address spender, uint256 value) public returns (bool);
330   event Approval(address indexed owner, address indexed spender, uint256 value);
331 }
332 
333 
334 
335 /**
336  * @title RequestCore
337  *
338  * @dev The Core is the main contract which stores all the requests.
339  *
340  * @dev The Core philosophy is to be as much flexible as possible to adapt in the future to any new system
341  * @dev All the important conditions and an important part of the business logic takes place in the currency contracts.
342  * @dev Requests can only be created in the currency contracts
343  * @dev Currency contracts have to be allowed by the Core and respect the business logic.
344  * @dev Request Network will develop one currency contracts per currency and anyone can creates its own currency contracts.
345  */
346 contract RequestCore is Administrable {
347     using SafeMath for uint256;
348     using SafeMathUint96 for uint96;
349     using SafeMathInt for int256;
350     using SafeMathUint8 for uint8;
351 
352     enum State { Created, Accepted, Canceled }
353 
354     struct Request {
355         // ID address of the payer
356         address payer;
357 
358         // Address of the contract managing the request
359         address currencyContract;
360 
361         // State of the request
362         State state;
363 
364         // Main payee
365         Payee payee;
366     }
367 
368     // Structure for the payees. A sub payee is an additional entity which will be paid during the processing of the invoice.
369     // ex: can be used for routing taxes or fees at the moment of the payment.
370     struct Payee {
371         // ID address of the payee
372         address addr;
373 
374         // amount expected for the payee. 
375         // Not uint for evolution (may need negative amounts one day), and simpler operations
376         int256 expectedAmount;
377 
378         // balance of the payee
379         int256 balance;
380     }
381 
382     // Count of request in the mapping. A maximum of 2^96 requests can be created per Core contract.
383     // Integer, incremented for each request of a Core contract, starting from 0
384     // RequestId (256bits) = contract address (160bits) + numRequest
385     uint96 public numRequests; 
386     
387     // Mapping of all the Requests. The key is the request ID.
388     // not anymore public to avoid "UnimplementedFeatureError: Only in-memory reference type can be stored."
389     // https://github.com/ethereum/solidity/issues/3577
390     mapping(bytes32 => Request) requests;
391 
392     // Mapping of subPayees of the requests. The key is the request ID.
393     // This array is outside the Request structure to optimize the gas cost when there is only 1 payee.
394     mapping(bytes32 => Payee[256]) public subPayees;
395 
396     /*
397      *  Events 
398      */
399     event Created(bytes32 indexed requestId, address indexed payee, address indexed payer, address creator, string data);
400     event Accepted(bytes32 indexed requestId);
401     event Canceled(bytes32 indexed requestId);
402 
403     // Event for Payee & subPayees
404     event NewSubPayee(bytes32 indexed requestId, address indexed payee); // Separated from the Created Event to allow a 4th indexed parameter (subpayees)
405     event UpdateExpectedAmount(bytes32 indexed requestId, uint8 payeeIndex, int256 deltaAmount);
406     event UpdateBalance(bytes32 indexed requestId, uint8 payeeIndex, int256 deltaAmount);
407 
408     /*
409      * @dev Function used by currency contracts to create a request in the Core
410      *
411      * @dev _payees and _expectedAmounts must have the same size
412      *
413      * @param _creator Request creator. The creator is the one who initiated the request (create or sign) and not necessarily the one who broadcasted it
414      * @param _payees array of payees address (the index 0 will be the payee the others are subPayees). Size must be smaller than 256.
415      * @param _expectedAmounts array of Expected amount to be received by each payees. Must be in same order than the payees. Size must be smaller than 256.
416      * @param _payer Entity expected to pay
417      * @param _data data of the request
418      * @return Returns the id of the request
419      */
420     function createRequest(
421         address     _creator,
422         address[]   _payees,
423         int256[]    _expectedAmounts,
424         address     _payer,
425         string      _data)
426         external
427         whenNotPaused 
428         returns (bytes32 requestId) 
429     {
430         // creator must not be null
431         require(_creator!=0); // not as modifier to lighten the stack
432         // call must come from a trusted contract
433         require(isTrustedContract(msg.sender)); // not as modifier to lighten the stack
434 
435         // Generate the requestId
436         requestId = generateRequestId();
437 
438         address mainPayee;
439         int256 mainExpectedAmount;
440         // extract the main payee if filled
441         if(_payees.length!=0) {
442             mainPayee = _payees[0];
443             mainExpectedAmount = _expectedAmounts[0];
444         }
445 
446         // Store the new request
447         requests[requestId] = Request(_payer, msg.sender, State.Created, Payee(mainPayee, mainExpectedAmount, 0));
448 
449         // Declare the new request
450         Created(requestId, mainPayee, _payer, _creator, _data);
451         
452         // Store and declare the sub payees (needed in internal function to avoid "stack too deep")
453         initSubPayees(requestId, _payees, _expectedAmounts);
454 
455         return requestId;
456     }
457 
458     /*
459      * @dev Function used by currency contracts to create a request in the Core from bytes
460      * @dev Used to avoid receiving a stack too deep error when called from a currency contract with too many parameters.
461      * @audit Note that to optimize the stack size and the gas cost we do not extract the params and store them in the stack. As a result there is some code redundancy
462      * @param _data bytes containing all the data packed :
463             address(creator)
464             address(payer)
465             uint8(number_of_payees)
466             [
467                 address(main_payee_address)
468                 int256(main_payee_expected_amount)
469                 address(second_payee_address)
470                 int256(second_payee_expected_amount)
471                 ...
472             ]
473             uint8(data_string_size)
474             size(data)
475      * @return Returns the id of the request 
476      */ 
477     function createRequestFromBytes(bytes _data) 
478         external
479         whenNotPaused 
480         returns (bytes32 requestId) 
481     {
482         // call must come from a trusted contract
483         require(isTrustedContract(msg.sender)); // not as modifier to lighten the stack
484 
485         // extract address creator & payer
486         address creator = extractAddress(_data, 0);
487 
488         address payer = extractAddress(_data, 20);
489 
490         // creator must not be null
491         require(creator!=0);
492         
493         // extract the number of payees
494         uint8 payeesCount = uint8(_data[40]);
495 
496         // get the position of the dataSize in the byte (= number_of_payees * (address_payee_size + int256_payee_size) + address_creator_size + address_payer_size + payees_count_size
497         //                                              (= number_of_payees * (20+32) + 20 + 20 + 1 )
498         uint256 offsetDataSize = uint256(payeesCount).mul(52).add(41);
499 
500         // extract the data size and then the data itself
501         uint8 dataSize = uint8(_data[offsetDataSize]);
502         string memory dataStr = extractString(_data, dataSize, offsetDataSize.add(1));
503 
504         address mainPayee;
505         int256 mainExpectedAmount;
506         // extract the main payee if possible
507         if(payeesCount!=0) {
508             mainPayee = extractAddress(_data, 41);
509             mainExpectedAmount = int256(extractBytes32(_data, 61));
510         }
511 
512         // Generate the requestId
513         requestId = generateRequestId();
514 
515         // Store the new request
516         requests[requestId] = Request(payer, msg.sender, State.Created, Payee(mainPayee, mainExpectedAmount, 0));
517 
518         // Declare the new request
519         Created(requestId, mainPayee, payer, creator, dataStr);
520 
521         // Store and declare the sub payees
522         for(uint8 i = 1; i < payeesCount; i = i.add(1)) {
523             address subPayeeAddress = extractAddress(_data, uint256(i).mul(52).add(41));
524 
525             // payees address cannot be 0x0
526             require(subPayeeAddress != 0);
527 
528             subPayees[requestId][i-1] =  Payee(subPayeeAddress, int256(extractBytes32(_data, uint256(i).mul(52).add(61))), 0);
529             NewSubPayee(requestId, subPayeeAddress);
530         }
531 
532         return requestId;
533     }
534 
535     /*
536      * @dev Function used by currency contracts to accept a request in the Core.
537      * @dev callable only by the currency contract of the request
538      * @param _requestId Request id
539      */ 
540     function accept(bytes32 _requestId) 
541         external
542     {
543         Request storage r = requests[_requestId];
544         require(r.currencyContract==msg.sender); 
545         r.state = State.Accepted;
546         Accepted(_requestId);
547     }
548 
549     /*
550      * @dev Function used by currency contracts to cancel a request in the Core. Several reasons can lead to cancel a request, see request life cycle for more info.
551      * @dev callable only by the currency contract of the request
552      * @param _requestId Request id
553      */ 
554     function cancel(bytes32 _requestId)
555         external
556     {
557         Request storage r = requests[_requestId];
558         require(r.currencyContract==msg.sender);
559         r.state = State.Canceled;
560         Canceled(_requestId);
561     }   
562 
563     /*
564      * @dev Function used to update the balance
565      * @dev callable only by the currency contract of the request
566      * @param _requestId Request id
567      * @param _payeeIndex index of the payee (0 = main payee)
568      * @param _deltaAmount modifier amount
569      */ 
570     function updateBalance(bytes32 _requestId, uint8 _payeeIndex, int256 _deltaAmount)
571         external
572     {   
573         Request storage r = requests[_requestId];
574         require(r.currencyContract==msg.sender);
575 
576         if( _payeeIndex == 0 ) {
577             // modify the main payee
578             r.payee.balance = r.payee.balance.add(_deltaAmount);
579         } else {
580             // modify the sub payee
581             Payee storage sp = subPayees[_requestId][_payeeIndex-1];
582             sp.balance = sp.balance.add(_deltaAmount);
583         }
584         UpdateBalance(_requestId, _payeeIndex, _deltaAmount);
585     }
586 
587     /*
588      * @dev Function update the expectedAmount adding additional or subtract
589      * @dev callable only by the currency contract of the request
590      * @param _requestId Request id
591      * @param _payeeIndex index of the payee (0 = main payee)
592      * @param _deltaAmount modifier amount
593      */ 
594     function updateExpectedAmount(bytes32 _requestId, uint8 _payeeIndex, int256 _deltaAmount)
595         external
596     {   
597         Request storage r = requests[_requestId];
598         require(r.currencyContract==msg.sender); 
599 
600         if( _payeeIndex == 0 ) {
601             // modify the main payee
602             r.payee.expectedAmount = r.payee.expectedAmount.add(_deltaAmount);    
603         } else {
604             // modify the sub payee
605             Payee storage sp = subPayees[_requestId][_payeeIndex-1];
606             sp.expectedAmount = sp.expectedAmount.add(_deltaAmount);
607         }
608         UpdateExpectedAmount(_requestId, _payeeIndex, _deltaAmount);
609     }
610 
611     /*
612      * @dev Internal: Init payees for a request (needed to avoid 'stack too deep' in createRequest())
613      * @param _requestId Request id
614      * @param _payees array of payees address
615      * @param _expectedAmounts array of payees initial expected amounts
616      */ 
617     function initSubPayees(bytes32 _requestId, address[] _payees, int256[] _expectedAmounts)
618         internal
619     {
620         require(_payees.length == _expectedAmounts.length);
621      
622         for (uint8 i = 1; i < _payees.length; i = i.add(1))
623         {
624             // payees address cannot be 0x0
625             require(_payees[i] != 0);
626             subPayees[_requestId][i-1] = Payee(_payees[i], _expectedAmounts[i], 0);
627             NewSubPayee(_requestId, _payees[i]);
628         }
629     }
630 
631 
632     /* GETTER */
633     /*
634      * @dev Get address of a payee
635      * @param _requestId Request id
636      * @param _payeeIndex payee index (0 = main payee)
637      * @return payee address
638      */ 
639     function getPayeeAddress(bytes32 _requestId, uint8 _payeeIndex)
640         public
641         constant
642         returns(address)
643     {
644         if(_payeeIndex == 0) {
645             return requests[_requestId].payee.addr;
646         } else {
647             return subPayees[_requestId][_payeeIndex-1].addr;
648         }
649     }
650 
651     /*
652      * @dev Get payer of a request
653      * @param _requestId Request id
654      * @return payer address
655      */ 
656     function getPayer(bytes32 _requestId)
657         public
658         constant
659         returns(address)
660     {
661         return requests[_requestId].payer;
662     }
663 
664     /*
665      * @dev Get amount expected of a payee
666      * @param _requestId Request id
667      * @param _payeeIndex payee index (0 = main payee)
668      * @return amount expected
669      */     
670     function getPayeeExpectedAmount(bytes32 _requestId, uint8 _payeeIndex)
671         public
672         constant
673         returns(int256)
674     {
675         if(_payeeIndex == 0) {
676             return requests[_requestId].payee.expectedAmount;
677         } else {
678             return subPayees[_requestId][_payeeIndex-1].expectedAmount;
679         }
680     }
681 
682     /*
683      * @dev Get number of subPayees for a request
684      * @param _requestId Request id
685      * @return number of subPayees
686      */     
687     function getSubPayeesCount(bytes32 _requestId)
688         public
689         constant
690         returns(uint8)
691     {
692         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1)) {
693             // nothing to do
694         }
695         return i;
696     }
697 
698     /*
699      * @dev Get currencyContract of a request
700      * @param _requestId Request id
701      * @return currencyContract address
702      */
703     function getCurrencyContract(bytes32 _requestId)
704         public
705         constant
706         returns(address)
707     {
708         return requests[_requestId].currencyContract;
709     }
710 
711     /*
712      * @dev Get balance of a payee
713      * @param _requestId Request id
714      * @param _payeeIndex payee index (0 = main payee)
715      * @return balance
716      */     
717     function getPayeeBalance(bytes32 _requestId, uint8 _payeeIndex)
718         public
719         constant
720         returns(int256)
721     {
722         if(_payeeIndex == 0) {
723             return requests[_requestId].payee.balance;    
724         } else {
725             return subPayees[_requestId][_payeeIndex-1].balance;
726         }
727     }
728 
729     /*
730      * @dev Get balance total of a request
731      * @param _requestId Request id
732      * @return balance
733      */     
734     function getBalance(bytes32 _requestId)
735         public
736         constant
737         returns(int256)
738     {
739         int256 balance = requests[_requestId].payee.balance;
740 
741         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1))
742         {
743             balance = balance.add(subPayees[_requestId][i].balance);
744         }
745 
746         return balance;
747     }
748 
749 
750     /*
751      * @dev check if all the payees balances are null
752      * @param _requestId Request id
753      * @return true if all the payees balances are equals to 0
754      */     
755     function areAllBalanceNull(bytes32 _requestId)
756         public
757         constant
758         returns(bool isNull)
759     {
760         isNull = requests[_requestId].payee.balance == 0;
761 
762         for (uint8 i = 0; isNull && subPayees[_requestId][i].addr != address(0); i = i.add(1))
763         {
764             isNull = subPayees[_requestId][i].balance == 0;
765         }
766 
767         return isNull;
768     }
769 
770     /*
771      * @dev Get total expectedAmount of a request
772      * @param _requestId Request id
773      * @return balance
774      */     
775     function getExpectedAmount(bytes32 _requestId)
776         public
777         constant
778         returns(int256)
779     {
780         int256 expectedAmount = requests[_requestId].payee.expectedAmount;
781 
782         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1))
783         {
784             expectedAmount = expectedAmount.add(subPayees[_requestId][i].expectedAmount);
785         }
786 
787         return expectedAmount;
788     }
789 
790     /*
791      * @dev Get state of a request
792      * @param _requestId Request id
793      * @return state
794      */ 
795     function getState(bytes32 _requestId)
796         public
797         constant
798         returns(State)
799     {
800         return requests[_requestId].state;
801     }
802 
803     /*
804      * @dev Get address of a payee
805      * @param _requestId Request id
806      * @return payee index (0 = main payee) or -1 if not address not found
807      */
808     function getPayeeIndex(bytes32 _requestId, address _address)
809         public
810         constant
811         returns(int16)
812     {
813         // return 0 if main payee
814         if(requests[_requestId].payee.addr == _address) return 0;
815 
816         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1))
817         {
818             if(subPayees[_requestId][i].addr == _address) {
819                 // if found return subPayee index + 1 (0 is main payee)
820                 return i+1;
821             }
822         }
823         return -1;
824     }
825 
826     /*
827      * @dev getter of a request
828      * @param _requestId Request id
829      * @return request as a tuple : (address payer, address currencyContract, State state, address payeeAddr, int256 payeeExpectedAmount, int256 payeeBalance)
830      */ 
831     function getRequest(bytes32 _requestId) 
832         external
833         constant
834         returns(address payer, address currencyContract, State state, address payeeAddr, int256 payeeExpectedAmount, int256 payeeBalance)
835     {
836         Request storage r = requests[_requestId];
837         return ( r.payer, 
838                  r.currencyContract, 
839                  r.state, 
840                  r.payee.addr, 
841                  r.payee.expectedAmount, 
842                  r.payee.balance );
843     }
844 
845     /*
846      * @dev extract a string from a bytes. Extracts a sub-part from tha bytes and convert it to string
847      * @param data bytes from where the string will be extracted
848      * @param size string size to extract
849      * @param _offset position of the first byte of the string in bytes
850      * @return string
851      */ 
852     function extractString(bytes data, uint8 size, uint _offset) 
853         internal 
854         pure 
855         returns (string) 
856     {
857         bytes memory bytesString = new bytes(size);
858         for (uint j = 0; j < size; j++) {
859             bytesString[j] = data[_offset+j];
860         }
861         return string(bytesString);
862     }
863 
864     /*
865      * @dev generate a new unique requestId
866      * @return a bytes32 requestId 
867      */ 
868     function generateRequestId()
869         internal
870         returns (bytes32)
871     {
872         // Update numRequest
873         numRequests = numRequests.add(1);
874         // requestId = ADDRESS_CONTRACT_CORE + numRequests (0xADRRESSCONTRACT00000NUMREQUEST)
875         return bytes32((uint256(this) << 96).add(numRequests));
876     }
877 
878     /*
879      * @dev extract an address from a bytes at a given position
880      * @param _data bytes from where the address will be extract
881      * @param _offset position of the first byte of the address
882      * @return address
883      */
884     function extractAddress(bytes _data, uint offset)
885         internal
886         pure
887         returns (address m)
888     {
889         require(offset >=0 && offset + 20 <= _data.length);
890         assembly {
891             m := and( mload(add(_data, add(20, offset))), 
892                       0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
893         }
894     }
895 
896     /*
897      * @dev extract a bytes32 from a bytes
898      * @param data bytes from where the bytes32 will be extract
899      * @param offset position of the first byte of the bytes32
900      * @return address
901      */
902     function extractBytes32(bytes _data, uint offset)
903         public
904         pure
905         returns (bytes32 bs)
906     {
907         require(offset >=0 && offset + 32 <= _data.length);
908         assembly {
909             bs := mload(add(_data, add(32, offset)))
910         }
911     }
912 
913     /**
914      * @dev transfer to owner any tokens send by mistake on this contracts
915      * @param token The address of the token to transfer.
916      * @param amount The amount to be transfered.
917      */
918     function emergencyERC20Drain(ERC20 token, uint amount )
919         public
920         onlyOwner 
921     {
922         token.transfer(owner, amount);
923     }
924 }
925 
926 /**
927  * @title RequestCollectInterface
928  *
929  * @dev RequestCollectInterface is a contract managing the fees for currency contracts
930  */
931 contract RequestCollectInterface is Pausable {
932   using SafeMath for uint256;
933 
934     uint256 public rateFeesNumerator;
935     uint256 public rateFeesDenominator;
936     uint256 public maxFees;
937 
938   // address of the contract that will burn req token (through Kyber)
939   address public requestBurnerContract;
940 
941     /*
942      *  Events 
943      */
944     event UpdateRateFees(uint256 rateFeesNumerator, uint256 rateFeesDenominator);
945     event UpdateMaxFees(uint256 maxFees);
946 
947   /*
948    * @dev Constructor
949    * @param _requestBurnerContract Address of the contract where to send the ethers. 
950    * This burner contract will have a function that can be called by anyone and will exchange ethers to req via Kyber and burn the REQ
951    */  
952   function RequestCollectInterface(address _requestBurnerContract) 
953     public
954   {
955     requestBurnerContract = _requestBurnerContract;
956   }
957 
958   /*
959    * @dev send fees to the request burning address
960    * @param _amount amount to send to the burning address
961    */  
962   function collectForREQBurning(uint256 _amount)
963     internal
964     returns(bool)
965   {
966     return requestBurnerContract.send(_amount);
967   }
968 
969   /*
970    * @dev compute the fees
971    * @param _expectedAmount amount expected for the request
972      * @return the expected amount of fees in wei
973    */  
974   function collectEstimation(int256 _expectedAmount)
975     public
976     view
977     returns(uint256)
978   {
979     if(_expectedAmount<0) return 0;
980 
981     uint256 computedCollect = uint256(_expectedAmount).mul(rateFeesNumerator);
982 
983     if(rateFeesDenominator != 0) {
984       computedCollect = computedCollect.div(rateFeesDenominator);
985     }
986 
987     return computedCollect < maxFees ? computedCollect : maxFees;
988   }
989 
990   /*
991    * @dev set the fees rate
992      * NB: if the _rateFeesDenominator is 0, it will be treated as 1. (in other words, the computation of the fees will not use it)
993    * @param _rateFeesNumerator    numerator rate
994    * @param _rateFeesDenominator    denominator rate
995    */  
996   function setRateFees(uint256 _rateFeesNumerator, uint256 _rateFeesDenominator)
997     external
998     onlyOwner
999   {
1000     rateFeesNumerator = _rateFeesNumerator;
1001         rateFeesDenominator = _rateFeesDenominator;
1002     UpdateRateFees(rateFeesNumerator, rateFeesDenominator);
1003   }
1004 
1005   /*
1006    * @dev set the maximum fees in wei
1007    * @param _newMax new max
1008    */  
1009   function setMaxCollectable(uint256 _newMaxFees) 
1010     external
1011     onlyOwner
1012   {
1013     maxFees = _newMaxFees;
1014     UpdateMaxFees(maxFees);
1015   }
1016 
1017   /*
1018    * @dev set the request burner address
1019    * @param _requestBurnerContract address of the contract that will burn req token (probably through Kyber)
1020    */  
1021   function setRequestBurnerContract(address _requestBurnerContract) 
1022     external
1023     onlyOwner
1024   {
1025     requestBurnerContract=_requestBurnerContract;
1026   }
1027 
1028 }
1029 
1030 
1031 /**
1032  * @title RequestCurrencyContractInterface
1033  *
1034  * @dev RequestCurrencyContractInterface is the currency contract managing the request in Ethereum
1035  * @dev The contract can be paused. In this case, nobody can create Requests anymore but people can still interact with them or withdraw funds.
1036  *
1037  * @dev Requests can be created by the Payee with createRequestAsPayee(), by the payer with createRequestAsPayer() or by the payer from a request signed offchain by the payee with broadcastSignedRequestAsPayer
1038  */
1039 contract RequestCurrencyContractInterface is RequestCollectInterface {
1040     using SafeMath for uint256;
1041     using SafeMathInt for int256;
1042     using SafeMathUint8 for uint8;
1043 
1044     // RequestCore object
1045     RequestCore public requestCore;
1046 
1047     /*
1048      * @dev Constructor
1049      * @param _requestCoreAddress Request Core address
1050      */
1051     function RequestCurrencyContractInterface(address _requestCoreAddress, address _addressBurner) 
1052         RequestCollectInterface(_addressBurner)
1053         public
1054     {
1055         requestCore=RequestCore(_requestCoreAddress);
1056     }
1057 
1058     function createCoreRequestInternal(
1059         address     _payer,
1060         address[]   _payeesIdAddress,
1061         int256[]    _expectedAmounts,
1062         string      _data)
1063         internal
1064         whenNotPaused
1065         returns(bytes32 requestId, int256 totalExpectedAmounts)
1066     {
1067         totalExpectedAmounts = 0;
1068         for (uint8 i = 0; i < _expectedAmounts.length; i = i.add(1))
1069         {
1070             // all expected amount must be positive
1071             require(_expectedAmounts[i]>=0);
1072             // compute the total expected amount of the request
1073             totalExpectedAmounts = totalExpectedAmounts.add(_expectedAmounts[i]);
1074         }
1075 
1076         // store request in the core
1077         requestId= requestCore.createRequest(msg.sender, _payeesIdAddress, _expectedAmounts, _payer, _data);
1078     }
1079 
1080     function acceptAction(bytes32 _requestId)
1081         public
1082         whenNotPaused
1083         onlyRequestPayer(_requestId)
1084     {
1085         // only a created request can be accepted
1086         require(requestCore.getState(_requestId)==RequestCore.State.Created);
1087 
1088         // declare the acceptation in the core
1089         requestCore.accept(_requestId);
1090     }
1091 
1092     function cancelAction(bytes32 _requestId)
1093         public
1094         whenNotPaused
1095     {
1096         // payer can cancel if request is just created
1097         // payee can cancel when request is not canceled yet
1098         require((requestCore.getPayer(_requestId)==msg.sender && requestCore.getState(_requestId)==RequestCore.State.Created)
1099                 || (requestCore.getPayeeAddress(_requestId,0)==msg.sender && requestCore.getState(_requestId)!=RequestCore.State.Canceled));
1100 
1101         // impossible to cancel a Request with any payees balance != 0
1102         require(requestCore.areAllBalanceNull(_requestId));
1103 
1104         // declare the cancellation in the core
1105         requestCore.cancel(_requestId);
1106     }
1107 
1108     function additionalAction(bytes32 _requestId, uint256[] _additionalAmounts)
1109         public
1110         whenNotPaused
1111         onlyRequestPayer(_requestId)
1112     {
1113 
1114         // impossible to make additional if request is canceled
1115         require(requestCore.getState(_requestId)!=RequestCore.State.Canceled);
1116 
1117         // impossible to declare more additionals than the number of payees
1118         require(_additionalAmounts.length <= requestCore.getSubPayeesCount(_requestId).add(1));
1119 
1120         for(uint8 i = 0; i < _additionalAmounts.length; i = i.add(1)) {
1121             // no need to declare a zero as additional 
1122             if(_additionalAmounts[i] != 0) {
1123                 // Store and declare the additional in the core
1124                 requestCore.updateExpectedAmount(_requestId, i, _additionalAmounts[i].toInt256Safe());
1125             }
1126         }
1127     }
1128 
1129     function subtractAction(bytes32 _requestId, uint256[] _subtractAmounts)
1130         public
1131         whenNotPaused
1132         onlyRequestPayee(_requestId)
1133     {
1134         // impossible to make subtracts if request is canceled
1135         require(requestCore.getState(_requestId)!=RequestCore.State.Canceled);
1136 
1137         // impossible to declare more subtracts than the number of payees
1138         require(_subtractAmounts.length <= requestCore.getSubPayeesCount(_requestId).add(1));
1139 
1140         for(uint8 i = 0; i < _subtractAmounts.length; i = i.add(1)) {
1141             // no need to declare a zero as subtracts 
1142             if(_subtractAmounts[i] != 0) {
1143                 // subtract must be equal or lower than amount expected
1144                 require(requestCore.getPayeeExpectedAmount(_requestId,i) >= _subtractAmounts[i].toInt256Safe());
1145                 // Store and declare the subtract in the core
1146                 requestCore.updateExpectedAmount(_requestId, i, -_subtractAmounts[i].toInt256Safe());
1147             }
1148         }
1149     }
1150     // ----------------------------------------------------------------------------------------
1151 
1152     /*
1153      * @dev Modifier to check if msg.sender is the main payee
1154      * @dev Revert if msg.sender is not the main payee
1155      * @param _requestId id of the request
1156      */ 
1157     modifier onlyRequestPayee(bytes32 _requestId)
1158     {
1159         require(requestCore.getPayeeAddress(_requestId, 0)==msg.sender);
1160         _;
1161     }
1162 
1163     /*
1164      * @dev Modifier to check if msg.sender is payer
1165      * @dev Revert if msg.sender is not payer
1166      * @param _requestId id of the request
1167      */ 
1168     modifier onlyRequestPayer(bytes32 _requestId)
1169     {
1170         require(requestCore.getPayer(_requestId)==msg.sender);
1171         _;
1172     }
1173 }
1174 
1175 /**
1176  * @title RequestBitcoinNodesValidation
1177  *
1178  * @dev RequestBitcoinNodesValidation is the currency contract managing the request in Bitcoin
1179  * @dev The contract can be paused. In this case, nobody can create Requests anymore but people can still interact with them or withdraw funds.
1180  *
1181  * @dev Requests can be created by the Payee with createRequestAsPayee(), by the payer with createRequestAsPayer() or by the payer from a request signed offchain by the payee with broadcastSignedRequestAsPayer
1182  */
1183 contract RequestBitcoinNodesValidation is RequestCurrencyContractInterface {
1184     using SafeMath for uint256;
1185     using SafeMathInt for int256;
1186     using SafeMathUint8 for uint8;
1187 
1188     // bitcoin addresses for payment and refund by requestid
1189     // every time a transaction is sent to one of these addresses, it will be interpreted offchain as a payment (index 0 is the main payee, next indexes are for sub-payee)
1190     mapping(bytes32 => string[256]) public payeesPaymentAddress;
1191     // every time a transaction is sent to one of these addresses, it will be interpreted offchain as a refund (index 0 is the main payee, next indexes are for sub-payee)
1192     mapping(bytes32 => string[256]) public payerRefundAddress;
1193 
1194     /*
1195      * @dev Constructor
1196      * @param _requestCoreAddress Request Core address
1197      * @param _requestBurnerAddress Request Burner contract address
1198      */
1199     function RequestBitcoinNodesValidation(address _requestCoreAddress, address _requestBurnerAddress) 
1200         RequestCurrencyContractInterface(_requestCoreAddress, _requestBurnerAddress)
1201         public
1202     {
1203         // nothing to do here
1204     }
1205 
1206     /*
1207      * @dev Function to create a request as payee
1208      *
1209      * @dev msg.sender must be the main payee
1210      *
1211      * @param _payeesIdAddress array of payees address (the index 0 will be the payee - must be msg.sender - the others are subPayees)
1212      * @param _payeesPaymentAddress array of payees bitcoin address for payment as bytes (bitcoin address don't have a fixed size)
1213      *                                           [
1214      *                                            uint8(payee1_bitcoin_address_size)
1215      *                                            string(payee1_bitcoin_address)
1216      *                                            uint8(payee2_bitcoin_address_size)
1217      *                                            string(payee2_bitcoin_address)
1218      *                                            ...
1219      *                                           ]
1220      * @param _expectedAmounts array of Expected amount to be received by each payees
1221      * @param _payer Entity expected to pay
1222      * @param _payerRefundAddress payer bitcoin addresses for refund as bytes (bitcoin address don't have a fixed size)
1223      *                                           [
1224      *                                            uint8(payee1_refund_bitcoin_address_size)
1225      *                                            string(payee1_refund_bitcoin_address)
1226      *                                            uint8(payee2_refund_bitcoin_address_size)
1227      *                                            string(payee2_refund_bitcoin_address)
1228      *                                            ...
1229      *                                           ]
1230      * @param _data Hash linking to additional data on the Request stored on IPFS
1231      *
1232      * @return Returns the id of the request
1233      */
1234     function createRequestAsPayeeAction(
1235         address[]    _payeesIdAddress,
1236         bytes        _payeesPaymentAddress,
1237         int256[]     _expectedAmounts,
1238         address      _payer,
1239         bytes        _payerRefundAddress,
1240         string       _data)
1241         external
1242         payable
1243         whenNotPaused
1244         returns(bytes32 requestId)
1245     {
1246         require(msg.sender == _payeesIdAddress[0] && msg.sender != _payer && _payer != 0);
1247 
1248         int256 totalExpectedAmounts;
1249         (requestId, totalExpectedAmounts) = createCoreRequestInternal(_payer, _payeesIdAddress, _expectedAmounts, _data);
1250         
1251         // compute and send fees
1252         uint256 fees = collectEstimation(totalExpectedAmounts);
1253         require(fees == msg.value && collectForREQBurning(fees));
1254     
1255         extractAndStoreBitcoinAddresses(requestId, _payeesIdAddress.length, _payeesPaymentAddress, _payerRefundAddress);
1256         
1257         return requestId;
1258     }
1259 
1260     /*
1261      * @dev Internal function to extract and store bitcoin addresses from bytes
1262      *
1263      * @param _requestId                id of the request
1264      * @param _payeesCount              number of payees
1265      * @param _payeesPaymentAddress     array of payees bitcoin address for payment as bytes
1266      *                                           [
1267      *                                            uint8(payee1_bitcoin_address_size)
1268      *                                            string(payee1_bitcoin_address)
1269      *                                            uint8(payee2_bitcoin_address_size)
1270      *                                            string(payee2_bitcoin_address)
1271      *                                            ...
1272      *                                           ]
1273      * @param _payerRefundAddress       payer bitcoin addresses for refund as bytes
1274      *                                           [
1275      *                                            uint8(payee1_refund_bitcoin_address_size)
1276      *                                            string(payee1_refund_bitcoin_address)
1277      *                                            uint8(payee2_refund_bitcoin_address_size)
1278      *                                            string(payee2_refund_bitcoin_address)
1279      *                                            ...
1280      *                                           ]
1281      */
1282     function extractAndStoreBitcoinAddresses(
1283         bytes32     _requestId,
1284         uint256     _payeesCount,
1285         bytes       _payeesPaymentAddress,
1286         bytes       _payerRefundAddress) 
1287         internal
1288     {
1289         // set payment addresses for payees
1290         uint256 cursor = 0;
1291         uint8 sizeCurrentBitcoinAddress;
1292         uint8 j;
1293         for (j = 0; j < _payeesCount; j = j.add(1)) {
1294             // get the size of the current bitcoin address
1295             sizeCurrentBitcoinAddress = uint8(_payeesPaymentAddress[cursor]);
1296 
1297             // extract and store the current bitcoin address
1298             payeesPaymentAddress[_requestId][j] = extractString(_payeesPaymentAddress, sizeCurrentBitcoinAddress, ++cursor);
1299 
1300             // move the cursor to the next bicoin address
1301             cursor += sizeCurrentBitcoinAddress;
1302         }
1303 
1304         // set payment address for payer
1305         cursor = 0;
1306         for (j = 0; j < _payeesCount; j = j.add(1)) {
1307             // get the size of the current bitcoin address
1308             sizeCurrentBitcoinAddress = uint8(_payerRefundAddress[cursor]);
1309 
1310             // extract and store the current bitcoin address
1311             payerRefundAddress[_requestId][j] = extractString(_payerRefundAddress, sizeCurrentBitcoinAddress, ++cursor);
1312 
1313             // move the cursor to the next bicoin address
1314             cursor += sizeCurrentBitcoinAddress;
1315         }
1316     }
1317 
1318     /*
1319      * @dev Function to broadcast and accept an offchain signed request (the broadcaster can also pays and makes additionals )
1320      *
1321      * @dev msg.sender will be the _payer
1322      * @dev only the _payer can additionals
1323      *
1324      * @param _requestData nested bytes containing : creator, payer, payees|expectedAmounts, data
1325      * @param _payeesPaymentAddress array of payees bitcoin address for payment as bytes
1326      *                                           [
1327      *                                            uint8(payee1_bitcoin_address_size)
1328      *                                            string(payee1_bitcoin_address)
1329      *                                            uint8(payee2_bitcoin_address_size)
1330      *                                            string(payee2_bitcoin_address)
1331      *                                            ...
1332      *                                           ]
1333      * @param _payerRefundAddress payer bitcoin addresses for refund as bytes
1334      *                                           [
1335      *                                            uint8(payee1_refund_bitcoin_address_size)
1336      *                                            string(payee1_refund_bitcoin_address)
1337      *                                            uint8(payee2_refund_bitcoin_address_size)
1338      *                                            string(payee2_refund_bitcoin_address)
1339      *                                            ...
1340      *                                           ]
1341      * @param _additionals array to increase the ExpectedAmount for payees
1342      * @param _expirationDate timestamp after that the signed request cannot be broadcasted
1343      * @param _signature ECDSA signature in bytes
1344      *
1345      * @return Returns the id of the request
1346      */
1347     function broadcastSignedRequestAsPayerAction(
1348         bytes         _requestData, // gather data to avoid "stack too deep"
1349         bytes         _payeesPaymentAddress,
1350         bytes         _payerRefundAddress,
1351         uint256[]     _additionals,
1352         uint256       _expirationDate,
1353         bytes         _signature)
1354         external
1355         payable
1356         whenNotPaused
1357         returns(bytes32 requestId)
1358     {
1359         // check expiration date
1360         require(_expirationDate >= block.timestamp);
1361 
1362         // check the signature
1363         require(checkRequestSignature(_requestData, _payeesPaymentAddress, _expirationDate, _signature));
1364 
1365         return createAcceptAndAdditionalsFromBytes(_requestData, _payeesPaymentAddress, _payerRefundAddress, _additionals);
1366     }
1367 
1368     /*
1369      * @dev Internal function to create, accept and add additionals to a request as Payer
1370      *
1371      * @dev msg.sender must be _payer
1372      *
1373      * @param _requestData nasty bytes containing : creator, payer, payees|expectedAmounts, data
1374      * @param _payeesPaymentAddress array of payees bitcoin address for payment
1375      * @param _payerRefundAddress payer bitcoin address for refund
1376      * @param _additionals Will increase the ExpectedAmount of the request right after its creation by adding additionals
1377      *
1378      * @return Returns the id of the request
1379      */
1380     function createAcceptAndAdditionalsFromBytes(
1381         bytes         _requestData,
1382         bytes         _payeesPaymentAddress,
1383         bytes         _payerRefundAddress,
1384         uint256[]     _additionals)
1385         internal
1386         returns(bytes32 requestId)
1387     {
1388         // extract main payee
1389         address mainPayee = extractAddress(_requestData, 41);
1390         require(msg.sender != mainPayee && mainPayee != 0);
1391         // creator must be the main payee
1392         require(extractAddress(_requestData, 0) == mainPayee);
1393 
1394         // extract the number of payees
1395         uint8 payeesCount = uint8(_requestData[40]);
1396         int256 totalExpectedAmounts = 0;
1397         for(uint8 i = 0; i < payeesCount; i++) {
1398             // extract the expectedAmount for the payee[i]
1399             int256 expectedAmountTemp = int256(extractBytes32(_requestData, uint256(i).mul(52).add(61)));
1400             // compute the total expected amount of the request
1401             totalExpectedAmounts = totalExpectedAmounts.add(expectedAmountTemp);
1402             // all expected amount must be positive
1403             require(expectedAmountTemp>0);
1404         }
1405 
1406         // compute and send fees
1407         uint256 fees = collectEstimation(totalExpectedAmounts);
1408         // check fees has been well received
1409         require(fees == msg.value && collectForREQBurning(fees));
1410 
1411         // insert the msg.sender as the payer in the bytes
1412         updateBytes20inBytes(_requestData, 20, bytes20(msg.sender));
1413         // store request in the core
1414         requestId = requestCore.createRequestFromBytes(_requestData);
1415         
1416         // set bitcoin addresses
1417         extractAndStoreBitcoinAddresses(requestId, payeesCount, _payeesPaymentAddress, _payerRefundAddress);
1418 
1419         // accept and pay the request with the value remaining after the fee collect
1420         acceptAndAdditionals(requestId, _additionals);
1421 
1422         return requestId;
1423     }
1424 
1425     /*
1426      * @dev Internal function to accept and add additionals to a request as Payer
1427      *
1428      * @param _requestId id of the request
1429      * @param _additionals Will increase the ExpectedAmounts of payees
1430      *
1431      */    
1432     function acceptAndAdditionals(
1433         bytes32     _requestId,
1434         uint256[]   _additionals)
1435         internal
1436     {
1437         acceptAction(_requestId);
1438         
1439         additionalAction(_requestId, _additionals);
1440     }
1441     // -----------------------------------------------------------------------------
1442 
1443     /*
1444      * @dev Check the validity of a signed request & the expiration date
1445      * @param _data bytes containing all the data packed :
1446             address(creator)
1447             address(payer)
1448             uint8(number_of_payees)
1449             [
1450                 address(main_payee_address)
1451                 int256(main_payee_expected_amount)
1452                 address(second_payee_address)
1453                 int256(second_payee_expected_amount)
1454                 ...
1455             ]
1456             uint8(data_string_size)
1457             size(data)
1458      * @param _payeesPaymentAddress array of payees payment addresses (the index 0 will be the payee the others are subPayees)
1459      * @param _expirationDate timestamp after that the signed request cannot be broadcasted
1460        * @param _signature ECDSA signature containing v, r and s as bytes
1461        *
1462      * @return Validity of order signature.
1463      */    
1464     function checkRequestSignature(
1465         bytes         _requestData,
1466         bytes         _payeesPaymentAddress,
1467         uint256       _expirationDate,
1468         bytes         _signature)
1469         public
1470         view
1471         returns (bool)
1472     {
1473         bytes32 hash = getRequestHash(_requestData, _payeesPaymentAddress, _expirationDate);
1474 
1475         // extract "v, r, s" from the signature
1476         uint8 v = uint8(_signature[64]);
1477         v = v < 27 ? v.add(27) : v;
1478         bytes32 r = extractBytes32(_signature, 0);
1479         bytes32 s = extractBytes32(_signature, 32);
1480 
1481         // check signature of the hash with the creator address
1482         return isValidSignature(extractAddress(_requestData, 0), hash, v, r, s);
1483     }
1484 
1485     /*
1486      * @dev Function internal to calculate Keccak-256 hash of a request with specified parameters
1487      *
1488      * @param _data bytes containing all the data packed
1489      * @param _payeesPaymentAddress array of payees payment addresses
1490      * @param _expirationDate timestamp after what the signed request cannot be broadcasted
1491      *
1492      * @return Keccak-256 hash of (this,_requestData, _payeesPaymentAddress, _expirationDate)
1493      */
1494     function getRequestHash(
1495         bytes       _requestData,
1496         bytes       _payeesPaymentAddress,
1497         uint256     _expirationDate)
1498         internal
1499         view
1500         returns(bytes32)
1501     {
1502         return keccak256(this,_requestData, _payeesPaymentAddress, _expirationDate);
1503     }
1504 
1505     /*
1506      * @dev Verifies that a hash signature is valid. 0x style
1507      * @param signer address of signer.
1508      * @param hash Signed Keccak-256 hash.
1509      * @param v ECDSA signature parameter v.
1510      * @param r ECDSA signature parameters r.
1511      * @param s ECDSA signature parameters s.
1512      * @return Validity of order signature.
1513      */
1514     function isValidSignature(
1515         address     signer,
1516         bytes32     hash,
1517         uint8       v,
1518         bytes32     r,
1519         bytes32     s)
1520         public
1521         pure
1522         returns (bool)
1523     {
1524         return signer == ecrecover(
1525             keccak256("\x19Ethereum Signed Message:\n32", hash),
1526             v,
1527             r,
1528             s
1529         );
1530     }
1531 
1532     /*
1533      * @dev extract an address in a bytes
1534      * @param data bytes from where the address will be extract
1535      * @param offset position of the first byte of the address
1536      * @return address
1537      */
1538     function extractAddress(bytes _data, uint offset)
1539         internal
1540         pure
1541         returns (address m) 
1542     {
1543         require(offset >=0 && offset + 20 <= _data.length);
1544         assembly {
1545             m := and( mload(add(_data, add(20, offset))), 
1546                       0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
1547         }
1548     }
1549 
1550     /*
1551      * @dev extract a bytes32 from a bytes
1552      * @param data bytes from where the bytes32 will be extract
1553      * @param offset position of the first byte of the bytes32
1554      * @return address
1555      */
1556     function extractBytes32(bytes _data, uint offset)
1557         public
1558         pure
1559         returns (bytes32 bs)
1560     {
1561         require(offset >=0 && offset + 32 <= _data.length);
1562         assembly {
1563             bs := mload(add(_data, add(32, offset)))
1564         }
1565     }
1566 
1567     /*
1568      * @dev modify 20 bytes in a bytes
1569      * @param data bytes to modify
1570      * @param offset position of the first byte to modify
1571      * @param b bytes20 to insert
1572      * @return address
1573      */
1574     function updateBytes20inBytes(bytes data, uint offset, bytes20 b)
1575         internal
1576         pure
1577     {
1578         require(offset >=0 && offset + 20 <= data.length);
1579         assembly {
1580             let m := mload(add(data, add(20, offset)))
1581             m := and(m, 0xFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000)
1582             m := or(m, div(b, 0x1000000000000000000000000))
1583             mstore(add(data, add(20, offset)), m)
1584         }
1585     }
1586 
1587     /*
1588      * @dev extract a string from a bytes. Extracts a sub-part from tha bytes and convert it to string
1589      * @param data bytes from where the string will be extracted
1590      * @param size string size to extract
1591      * @param _offset position of the first byte of the string in bytes
1592      * @return string
1593      */ 
1594     function extractString(bytes data, uint8 size, uint _offset) 
1595         internal 
1596         pure 
1597         returns (string) 
1598     {
1599         bytes memory bytesString = new bytes(size);
1600         for (uint j = 0; j < size; j++) {
1601             bytesString[j] = data[_offset+j];
1602         }
1603         return string(bytesString);
1604     }
1605 }