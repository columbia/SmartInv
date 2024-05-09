1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMathInt
6  * @dev Math operations with safety checks that throw on error
7  * @dev SafeMath adapted for int256
8  */
9 library SafeMathInt {
10   function mul(int256 a, int256 b) internal pure returns (int256) {
11     // Prevent overflow when multiplying INT256_MIN with -1
12     // https://github.com/RequestNetwork/requestNetwork/issues/43
13     assert(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
14 
15     int256 c = a * b;
16     assert((b == 0) || (c / b == a));
17     return c;
18   }
19 
20   function div(int256 a, int256 b) internal pure returns (int256) {
21     // Prevent overflow when dividing INT256_MIN by -1
22     // https://github.com/RequestNetwork/requestNetwork/issues/43
23     assert(!(a == - 2**255 && b == -1));
24 
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     int256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(int256 a, int256 b) internal pure returns (int256) {
32     assert((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
33 
34     return a - b;
35   }
36 
37   function add(int256 a, int256 b) internal pure returns (int256) {
38     int256 c = a + b;
39     assert((b >= 0 && c >= a) || (b < 0 && c < a));
40     return c;
41   }
42 
43   function toUint256Safe(int256 a) internal pure returns (uint256) {
44     assert(a>=0);
45     return uint256(a);
46   }
47 }
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  * @dev SafeMath adapted for uint96
53  */
54 library SafeMathUint96 {
55   function mul(uint96 a, uint96 b) internal pure returns (uint96) {
56     uint96 c = a * b;
57     assert(a == 0 || c / a == b);
58     return c;
59   }
60 
61   function div(uint96 a, uint96 b) internal pure returns (uint96) {
62     // assert(b > 0); // Solidity automatically throws when dividing by 0
63     uint96 c = a / b;
64     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65     return c;
66   }
67 
68   function sub(uint96 a, uint96 b) internal pure returns (uint96) {
69     assert(b <= a);
70     return a - b;
71   }
72 
73   function add(uint96 a, uint96 b) internal pure returns (uint96) {
74     uint96 c = a + b;
75     assert(c >= a);
76     return c;
77   }
78 }
79 
80 
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that throw on error
84  * @dev SafeMath adapted for uint8
85  */
86 library SafeMathUint8 {
87   function mul(uint8 a, uint8 b) internal pure returns (uint8) {
88     uint8 c = a * b;
89     assert(a == 0 || c / a == b);
90     return c;
91   }
92 
93   function div(uint8 a, uint8 b) internal pure returns (uint8) {
94     // assert(b > 0); // Solidity automatically throws when dividing by 0
95     uint8 c = a / b;
96     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
97     return c;
98   }
99 
100   function sub(uint8 a, uint8 b) internal pure returns (uint8) {
101     assert(b <= a);
102     return a - b;
103   }
104 
105   function add(uint8 a, uint8 b) internal pure returns (uint8) {
106     uint8 c = a + b;
107     assert(c >= a);
108     return c;
109   }
110 }
111 
112 
113 // From https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
114 /**
115  * @title SafeMath
116  * @dev Math operations with safety checks that throw on error
117  */
118 library SafeMath {
119   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
120     uint256 c = a * b;
121 
122     assert(a == 0 || c / a == b);
123     return c;
124   }
125 
126   function div(uint256 a, uint256 b) internal pure returns (uint256) {
127     // assert(b > 0); // Solidity automatically throws when dividing by 0
128     uint256 c = a / b;
129     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
130     return c;
131   }
132 
133   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134     assert(b <= a);
135     return a - b;
136   }
137 
138   function add(uint256 a, uint256 b) internal pure returns (uint256) {
139     uint256 c = a + b;
140     assert(c >= a);
141     return c;
142   }
143 
144   function toInt256Safe(uint256 a) internal pure returns (int256) {
145     int256 b = int256(a);
146     assert(b >= 0);
147     return b;
148   }
149 }
150 
151 
152 /**
153  * @title Bytes util library.
154  * @notice Collection of utility functions to manipulate bytes for Request.
155  */
156 library Bytes {
157     /**
158      * @notice Extracts an address in a bytes.
159      * @param data bytes from where the address will be extract
160      * @param offset position of the first byte of the address
161      * @return address
162      */
163     function extractAddress(bytes data, uint offset)
164         internal
165         pure
166         returns (address m) 
167     {
168         require(offset >= 0 && offset + 20 <= data.length, "offset value should be in the correct range");
169 
170         // solium-disable-next-line security/no-inline-assembly
171         assembly {
172             m := and(
173                 mload(add(data, add(20, offset))), 
174                 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
175             )
176         }
177     }
178 
179     /**
180      * @notice Extract a bytes32 from a bytes.
181      * @param data bytes from where the bytes32 will be extract
182      * @param offset position of the first byte of the bytes32
183      * @return address
184      */
185     function extractBytes32(bytes data, uint offset)
186         internal
187         pure
188         returns (bytes32 bs)
189     {
190         require(offset >= 0 && offset + 32 <= data.length, "offset value should be in the correct range");
191 
192         // solium-disable-next-line security/no-inline-assembly
193         assembly {
194             bs := mload(add(data, add(32, offset)))
195         }
196     }
197 
198     /**
199      * @notice Modifies 20 bytes in a bytes.
200      * @param data bytes to modify
201      * @param offset position of the first byte to modify
202      * @param b bytes20 to insert
203      * @return address
204      */
205     function updateBytes20inBytes(bytes data, uint offset, bytes20 b)
206         internal
207         pure
208     {
209         require(offset >= 0 && offset + 20 <= data.length, "offset value should be in the correct range");
210 
211         // solium-disable-next-line security/no-inline-assembly
212         assembly {
213             let m := mload(add(data, add(20, offset)))
214             m := and(m, 0xFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000)
215             m := or(m, div(b, 0x1000000000000000000000000))
216             mstore(add(data, add(20, offset)), m)
217         }
218     }
219 
220     /**
221      * @notice Extracts a string from a bytes. Extracts a sub-part from the bytes and convert it to string.
222      * @param data bytes from where the string will be extracted
223      * @param size string size to extract
224      * @param _offset position of the first byte of the string in bytes
225      * @return string
226      */ 
227     function extractString(bytes data, uint8 size, uint _offset) 
228         internal 
229         pure 
230         returns (string) 
231     {
232         bytes memory bytesString = new bytes(size);
233         for (uint j = 0; j < size; j++) {
234             bytesString[j] = data[_offset+j];
235         }
236         return string(bytesString);
237     }
238 }
239 
240 
241 /**
242  * @title Request Signature util library.
243  * @notice Collection of utility functions to handle Request signatures.
244  */
245 library Signature {
246     using SafeMath for uint256;
247     using SafeMathInt for int256;
248     using SafeMathUint8 for uint8;
249 
250     /**
251      * @notice Checks the validity of a signed request & the expiration date.
252      * @param requestData bytes containing all the data packed :
253             address(creator)
254             address(payer)
255             uint8(number_of_payees)
256             [
257                 address(main_payee_address)
258                 int256(main_payee_expected_amount)
259                 address(second_payee_address)
260                 int256(second_payee_expected_amount)
261                 ...
262             ]
263             uint8(data_string_size)
264             size(data)
265      * @param payeesPaymentAddress array of payees payment addresses (the index 0 will be the payee the others are subPayees)
266      * @param expirationDate timestamp after that the signed request cannot be broadcasted
267      * @param signature ECDSA signature containing v, r and s as bytes
268      *
269      * @return Validity of order signature.
270      */ 
271     function checkRequestSignature(
272         bytes       requestData,
273         address[]   payeesPaymentAddress,
274         uint256     expirationDate,
275         bytes       signature)
276         internal
277         view
278         returns (bool)
279     {
280         bytes32 hash = getRequestHash(requestData, payeesPaymentAddress, expirationDate);
281 
282         // extract "v, r, s" from the signature
283         uint8 v = uint8(signature[64]);
284         v = v < 27 ? v.add(27) : v;
285         bytes32 r = Bytes.extractBytes32(signature, 0);
286         bytes32 s = Bytes.extractBytes32(signature, 32);
287 
288         // check signature of the hash with the creator address
289         return isValidSignature(
290             Bytes.extractAddress(requestData, 0),
291             hash,
292             v,
293             r,
294             s
295         );
296     }
297 
298     /**
299      * @notice Checks the validity of a Bitcoin signed request & the expiration date.
300      * @param requestData bytes containing all the data packed :
301             address(creator)
302             address(payer)
303             uint8(number_of_payees)
304             [
305                 address(main_payee_address)
306                 int256(main_payee_expected_amount)
307                 address(second_payee_address)
308                 int256(second_payee_expected_amount)
309                 ...
310             ]
311             uint8(data_string_size)
312             size(data)
313      * @param payeesPaymentAddress array of payees payment addresses (the index 0 will be the payee the others are subPayees)
314      * @param expirationDate timestamp after that the signed request cannot be broadcasted
315      * @param signature ECDSA signature containing v, r and s as bytes
316      *
317      * @return Validity of order signature.
318      */ 
319     function checkBtcRequestSignature(
320         bytes       requestData,
321         bytes       payeesPaymentAddress,
322         uint256     expirationDate,
323         bytes       signature)
324         internal
325         view
326         returns (bool)
327     {
328         bytes32 hash = getBtcRequestHash(requestData, payeesPaymentAddress, expirationDate);
329 
330         // extract "v, r, s" from the signature
331         uint8 v = uint8(signature[64]);
332         v = v < 27 ? v.add(27) : v;
333         bytes32 r = Bytes.extractBytes32(signature, 0);
334         bytes32 s = Bytes.extractBytes32(signature, 32);
335 
336         // check signature of the hash with the creator address
337         return isValidSignature(
338             Bytes.extractAddress(requestData, 0),
339             hash,
340             v,
341             r,
342             s
343         );
344     }
345     
346     /**
347      * @notice Calculates the Keccak-256 hash of a BTC request with specified parameters.
348      *
349      * @param requestData bytes containing all the data packed
350      * @param payeesPaymentAddress array of payees payment addresses
351      * @param expirationDate timestamp after what the signed request cannot be broadcasted
352      *
353      * @return Keccak-256 hash of (this, requestData, payeesPaymentAddress, expirationDate)
354      */
355     function getBtcRequestHash(
356         bytes       requestData,
357         bytes   payeesPaymentAddress,
358         uint256     expirationDate)
359         private
360         view
361         returns(bytes32)
362     {
363         return keccak256(
364             abi.encodePacked(
365                 this,
366                 requestData,
367                 payeesPaymentAddress,
368                 expirationDate
369             )
370         );
371     }
372 
373     /**
374      * @dev Calculates the Keccak-256 hash of a (not BTC) request with specified parameters.
375      *
376      * @param requestData bytes containing all the data packed
377      * @param payeesPaymentAddress array of payees payment addresses
378      * @param expirationDate timestamp after what the signed request cannot be broadcasted
379      *
380      * @return Keccak-256 hash of (this, requestData, payeesPaymentAddress, expirationDate)
381      */
382     function getRequestHash(
383         bytes       requestData,
384         address[]   payeesPaymentAddress,
385         uint256     expirationDate)
386         private
387         view
388         returns(bytes32)
389     {
390         return keccak256(
391             abi.encodePacked(
392                 this,
393                 requestData,
394                 payeesPaymentAddress,
395                 expirationDate
396             )
397         );
398     }
399     
400     /**
401      * @notice Verifies that a hash signature is valid. 0x style.
402      * @param signer address of signer.
403      * @param hash Signed Keccak-256 hash.
404      * @param v ECDSA signature parameter v.
405      * @param r ECDSA signature parameters r.
406      * @param s ECDSA signature parameters s.
407      * @return Validity of order signature.
408      */
409     function isValidSignature(
410         address signer,
411         bytes32 hash,
412         uint8   v,
413         bytes32 r,
414         bytes32 s)
415         private
416         pure
417         returns (bool)
418     {
419         return signer == ecrecover(
420             keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),
421             v,
422             r,
423             s
424         );
425     }
426 }
427 
428 /**
429  * @title Ownable
430  * @dev The Ownable contract has an owner address, and provides basic authorization control
431  * functions, this simplifies the implementation of "user permissions".
432  */
433 contract Ownable {
434   address public owner;
435 
436 
437   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
438 
439 
440   /**
441    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
442    * account.
443    */
444   function Ownable() public {
445     owner = msg.sender;
446   }
447 
448 
449   /**
450    * @dev Throws if called by any account other than the owner.
451    */
452   modifier onlyOwner() {
453     require(msg.sender == owner);
454     _;
455   }
456 
457 
458   /**
459    * @dev Allows the current owner to transfer control of the contract to a newOwner.
460    * @param newOwner The address to transfer ownership to.
461    */
462   function transferOwnership(address newOwner) onlyOwner public {
463     require(newOwner != address(0));
464     OwnershipTransferred(owner, newOwner);
465     owner = newOwner;
466   }
467 
468 }
469 
470 
471 /**
472  * @title Pausable
473  * @dev Base contract which allows children to implement an emergency stop mechanism.
474  */
475 contract Pausable is Ownable {
476     event Pause();
477     event Unpause();
478 
479     bool public paused = false;
480 
481 
482     /**
483      * @dev Modifier to make a function callable only when the contract is not paused.
484      */
485     modifier whenNotPaused() {
486         require(!paused);
487         _;
488     }
489 
490     /**
491      * @dev Modifier to make a function callable only when the contract is paused.
492      */
493     modifier whenPaused() {
494         require(paused);
495         _;
496     }
497 
498     /**
499      * @dev called by the owner to pause, triggers stopped state
500      */
501     function pause() onlyOwner whenNotPaused public {
502         paused = true;
503         Pause();
504     }
505 
506     /**
507      * @dev called by the owner to unpause, returns to normal state
508      */
509     function unpause() onlyOwner whenPaused public {
510         paused = false;
511         Unpause();
512     }
513 }
514 
515 
516 /**
517  * @title FeeCollector
518  *
519  * @notice FeeCollector is a contract managing the fees for currency contracts
520  */
521 contract FeeCollector is Ownable {
522     using SafeMath for uint256;
523 
524     uint256 public rateFeesNumerator;
525     uint256 public rateFeesDenominator;
526     uint256 public maxFees;
527 
528     // address of the contract that will burn req token
529     address public requestBurnerContract;
530 
531     event UpdateRateFees(uint256 rateFeesNumerator, uint256 rateFeesDenominator);
532     event UpdateMaxFees(uint256 maxFees);
533 
534     /**
535      * @param _requestBurnerContract Address of the contract where to send the ether.
536      * This burner contract will have a function that can be called by anyone and will exchange ether to req via Kyber and burn the REQ
537      */  
538     constructor(address _requestBurnerContract) 
539         public
540     {
541         requestBurnerContract = _requestBurnerContract;
542     }
543 
544     /**
545      * @notice Sets the fees rate.
546      * @dev if the _rateFeesDenominator is 0, it will be treated as 1. (in other words, the computation of the fees will not use it)
547      * @param _rateFeesNumerator        numerator rate
548      * @param _rateFeesDenominator      denominator rate
549      */  
550     function setRateFees(uint256 _rateFeesNumerator, uint256 _rateFeesDenominator)
551         external
552         onlyOwner
553     {
554         rateFeesNumerator = _rateFeesNumerator;
555         rateFeesDenominator = _rateFeesDenominator;
556         emit UpdateRateFees(rateFeesNumerator, rateFeesDenominator);
557     }
558 
559     /**
560      * @notice Sets the maximum fees in wei.
561      * @param _newMaxFees new max
562      */  
563     function setMaxCollectable(uint256 _newMaxFees) 
564         external
565         onlyOwner
566     {
567         maxFees = _newMaxFees;
568         emit UpdateMaxFees(maxFees);
569     }
570 
571     /**
572      * @notice Set the request burner address.
573      * @param _requestBurnerContract address of the contract that will burn req token (probably through Kyber)
574      */  
575     function setRequestBurnerContract(address _requestBurnerContract) 
576         external
577         onlyOwner
578     {
579         requestBurnerContract = _requestBurnerContract;
580     }
581 
582     /**
583      * @notice Computes the fees.
584      * @param _expectedAmount amount expected for the request
585      * @return the expected amount of fees in wei
586      */  
587     function collectEstimation(int256 _expectedAmount)
588         public
589         view
590         returns(uint256)
591     {
592         if (_expectedAmount<0) {
593             return 0;
594         }
595 
596         uint256 computedCollect = uint256(_expectedAmount).mul(rateFeesNumerator);
597 
598         if (rateFeesDenominator != 0) {
599             computedCollect = computedCollect.div(rateFeesDenominator);
600         }
601 
602         return computedCollect < maxFees ? computedCollect : maxFees;
603     }
604 
605     /**
606      * @notice Sends fees to the request burning address.
607      * @param _amount amount to send to the burning address
608      */  
609     function collectForREQBurning(uint256 _amount)
610         internal
611     {
612         // .transfer throws on failure
613         requestBurnerContract.transfer(_amount);
614     }
615 }
616 
617 
618 /**
619  * @title ERC20Basic
620  * @dev Simpler version of ERC20 interface
621  * @dev see https://github.com/ethereum/EIPs/issues/179
622  */
623 contract ERC20Basic {
624   uint256 public totalSupply;
625   function balanceOf(address who) public constant returns (uint256);
626   function transfer(address to, uint256 value) public returns (bool);
627   event Transfer(address indexed from, address indexed to, uint256 value);
628 }
629 
630 
631 /**
632  * @title ERC20 interface
633  * @dev see https://github.com/ethereum/EIPs/issues/20
634  */
635 contract ERC20 is ERC20Basic {
636   function allowance(address owner, address spender) public constant returns (uint256);
637   function transferFrom(address from, address to, uint256 value) public returns (bool);
638   function approve(address spender, uint256 value) public returns (bool);
639   event Approval(address indexed owner, address indexed spender, uint256 value);
640 }
641 
642 /**
643  * @title Administrable
644  * @notice Base contract for the administration of Core. Handles whitelisting of currency contracts
645  */
646 contract Administrable is Pausable {
647 
648     // mapping of address of trusted contract
649     mapping(address => uint8) public trustedCurrencyContracts;
650 
651     // Events of the system
652     event NewTrustedContract(address newContract);
653     event RemoveTrustedContract(address oldContract);
654 
655     /**
656      * @notice Adds a trusted currencyContract.
657      *
658      * @param _newContractAddress The address of the currencyContract
659      */
660     function adminAddTrustedCurrencyContract(address _newContractAddress)
661         external
662         onlyOwner
663     {
664         trustedCurrencyContracts[_newContractAddress] = 1; //Using int instead of boolean in case we need several states in the future.
665         emit NewTrustedContract(_newContractAddress);
666     }
667 
668     /**
669      * @notice Removes a trusted currencyContract.
670      *
671      * @param _oldTrustedContractAddress The address of the currencyContract
672      */
673     function adminRemoveTrustedCurrencyContract(address _oldTrustedContractAddress)
674         external
675         onlyOwner
676     {
677         require(trustedCurrencyContracts[_oldTrustedContractAddress] != 0, "_oldTrustedContractAddress should not be 0");
678         trustedCurrencyContracts[_oldTrustedContractAddress] = 0;
679         emit RemoveTrustedContract(_oldTrustedContractAddress);
680     }
681 
682     /**
683      * @notice Gets the status of a trusted currencyContract .
684      * @dev Not used today, useful if we have several states in the future.
685      *
686      * @param _contractAddress The address of the currencyContract
687      * @return The status of the currencyContract. If trusted 1, otherwise 0
688      */
689     function getStatusContract(address _contractAddress)
690         external
691         view
692         returns(uint8) 
693     {
694         return trustedCurrencyContracts[_contractAddress];
695     }
696 
697     /**
698      * @notice Checks if a currencyContract is trusted.
699      *
700      * @param _contractAddress The address of the currencyContract
701      * @return bool true if contract is trusted
702      */
703     function isTrustedContract(address _contractAddress)
704         public
705         view
706         returns(bool)
707     {
708         return trustedCurrencyContracts[_contractAddress] == 1;
709     }
710 }
711 
712 
713 /**
714  * @title RequestCore
715  *
716  * @notice The Core is the main contract which stores all the requests.
717  *
718  * @dev The Core philosophy is to be as much flexible as possible to adapt in the future to any new system
719  * @dev All the important conditions and an important part of the business logic takes place in the currency contracts.
720  * @dev Requests can only be created in the currency contracts
721  * @dev Currency contracts have to be allowed by the Core and respect the business logic.
722  * @dev Request Network will develop one currency contracts per currency and anyone can creates its own currency contracts.
723  */
724 contract RequestCore is Administrable {
725     using SafeMath for uint256;
726     using SafeMathUint96 for uint96;
727     using SafeMathInt for int256;
728     using SafeMathUint8 for uint8;
729 
730     enum State { Created, Accepted, Canceled }
731 
732     struct Request {
733         // ID address of the payer
734         address payer;
735 
736         // Address of the contract managing the request
737         address currencyContract;
738 
739         // State of the request
740         State state;
741 
742         // Main payee
743         Payee payee;
744     }
745 
746     // Structure for the payees. A sub payee is an additional entity which will be paid during the processing of the invoice.
747     // ex: can be used for routing taxes or fees at the moment of the payment.
748     struct Payee {
749         // ID address of the payee
750         address addr;
751 
752         // amount expected for the payee. 
753         // Not uint for evolution (may need negative amounts one day), and simpler operations
754         int256 expectedAmount;
755 
756         // balance of the payee
757         int256 balance;
758     }
759 
760     // Count of request in the mapping. A maximum of 2^96 requests can be created per Core contract.
761     // Integer, incremented for each request of a Core contract, starting from 0
762     // RequestId (256bits) = contract address (160bits) + numRequest
763     uint96 public numRequests; 
764     
765     // Mapping of all the Requests. The key is the request ID.
766     // not anymore public to avoid "UnimplementedFeatureError: Only in-memory reference type can be stored."
767     // https://github.com/ethereum/solidity/issues/3577
768     mapping(bytes32 => Request) requests;
769 
770     // Mapping of subPayees of the requests. The key is the request ID.
771     // This array is outside the Request structure to optimize the gas cost when there is only 1 payee.
772     mapping(bytes32 => Payee[256]) public subPayees;
773 
774     /*
775      *  Events 
776      */
777     event Created(bytes32 indexed requestId, address indexed payee, address indexed payer, address creator, string data);
778     event Accepted(bytes32 indexed requestId);
779     event Canceled(bytes32 indexed requestId);
780 
781     // Event for Payee & subPayees
782     // Separated from the Created Event to allow a 4th indexed parameter (subpayees)
783     event NewSubPayee(bytes32 indexed requestId, address indexed payee); 
784     event UpdateExpectedAmount(bytes32 indexed requestId, uint8 payeeIndex, int256 deltaAmount);
785     event UpdateBalance(bytes32 indexed requestId, uint8 payeeIndex, int256 deltaAmount);
786 
787     /**
788      * @notice Function used by currency contracts to create a request in the Core.
789      *
790      * @dev _payees and _expectedAmounts must have the same size.
791      *
792      * @param _creator Request creator. The creator is the one who initiated the request (create or sign) and not necessarily the one who broadcasted it
793      * @param _payees array of payees address (the index 0 will be the payee the others are subPayees). Size must be smaller than 256.
794      * @param _expectedAmounts array of Expected amount to be received by each payees. Must be in same order than the payees. Size must be smaller than 256.
795      * @param _payer Entity expected to pay
796      * @param _data data of the request
797      * @return Returns the id of the request
798      */
799     function createRequest(
800         address     _creator,
801         address[]   _payees,
802         int256[]    _expectedAmounts,
803         address     _payer,
804         string      _data)
805         external
806         whenNotPaused 
807         returns (bytes32 requestId) 
808     {
809         // creator must not be null
810         require(_creator != 0, "creator should not be 0"); // not as modifier to lighten the stack
811         // call must come from a trusted contract
812         require(isTrustedContract(msg.sender), "caller should be a trusted contract"); // not as modifier to lighten the stack
813 
814         // Generate the requestId
815         requestId = generateRequestId();
816 
817         address mainPayee;
818         int256 mainExpectedAmount;
819         // extract the main payee if filled
820         if (_payees.length!=0) {
821             mainPayee = _payees[0];
822             mainExpectedAmount = _expectedAmounts[0];
823         }
824 
825         // Store the new request
826         requests[requestId] = Request(
827             _payer,
828             msg.sender,
829             State.Created,
830             Payee(
831                 mainPayee,
832                 mainExpectedAmount,
833                 0
834             )
835         );
836 
837         // Declare the new request
838         emit Created(
839             requestId,
840             mainPayee,
841             _payer,
842             _creator,
843             _data
844         );
845         
846         // Store and declare the sub payees (needed in internal function to avoid "stack too deep")
847         initSubPayees(requestId, _payees, _expectedAmounts);
848 
849         return requestId;
850     }
851 
852     /**
853      * @notice Function used by currency contracts to create a request in the Core from bytes.
854      * @dev Used to avoid receiving a stack too deep error when called from a currency contract with too many parameters.
855      * @dev Note that to optimize the stack size and the gas cost we do not extract the params and store them in the stack. As a result there is some code redundancy
856      * @param _data bytes containing all the data packed :
857             address(creator)
858             address(payer)
859             uint8(number_of_payees)
860             [
861                 address(main_payee_address)
862                 int256(main_payee_expected_amount)
863                 address(second_payee_address)
864                 int256(second_payee_expected_amount)
865                 ...
866             ]
867             uint8(data_string_size)
868             size(data)
869      * @return Returns the id of the request 
870      */ 
871     function createRequestFromBytes(bytes _data) 
872         external
873         whenNotPaused 
874         returns (bytes32 requestId) 
875     {
876         // call must come from a trusted contract
877         require(isTrustedContract(msg.sender), "caller should be a trusted contract"); // not as modifier to lighten the stack
878 
879         // extract address creator & payer
880         address creator = extractAddress(_data, 0);
881 
882         address payer = extractAddress(_data, 20);
883 
884         // creator must not be null
885         require(creator!=0, "creator should not be 0");
886         
887         // extract the number of payees
888         uint8 payeesCount = uint8(_data[40]);
889 
890         // get the position of the dataSize in the byte (= number_of_payees * (address_payee_size + int256_payee_size) + address_creator_size + address_payer_size + payees_count_size
891         //                                              (= number_of_payees * (20+32) + 20 + 20 + 1 )
892         uint256 offsetDataSize = uint256(payeesCount).mul(52).add(41);
893 
894         // extract the data size and then the data itself
895         uint8 dataSize = uint8(_data[offsetDataSize]);
896         string memory dataStr = extractString(_data, dataSize, offsetDataSize.add(1));
897 
898         address mainPayee;
899         int256 mainExpectedAmount;
900         // extract the main payee if possible
901         if (payeesCount!=0) {
902             mainPayee = extractAddress(_data, 41);
903             mainExpectedAmount = int256(extractBytes32(_data, 61));
904         }
905 
906         // Generate the requestId
907         requestId = generateRequestId();
908 
909         // Store the new request
910         requests[requestId] = Request(
911             payer,
912             msg.sender,
913             State.Created,
914             Payee(
915                 mainPayee,
916                 mainExpectedAmount,
917                 0
918             )
919         );
920 
921         // Declare the new request
922         emit Created(
923             requestId,
924             mainPayee,
925             payer,
926             creator,
927             dataStr
928         );
929 
930         // Store and declare the sub payees
931         for (uint8 i = 1; i < payeesCount; i = i.add(1)) {
932             address subPayeeAddress = extractAddress(_data, uint256(i).mul(52).add(41));
933 
934             // payees address cannot be 0x0
935             require(subPayeeAddress != 0, "subpayee should not be 0");
936 
937             subPayees[requestId][i-1] = Payee(subPayeeAddress, int256(extractBytes32(_data, uint256(i).mul(52).add(61))), 0);
938             emit NewSubPayee(requestId, subPayeeAddress);
939         }
940 
941         return requestId;
942     }
943 
944     /**
945      * @notice Function used by currency contracts to accept a request in the Core.
946      * @dev callable only by the currency contract of the request
947      * @param _requestId Request id
948      */ 
949     function accept(bytes32 _requestId) 
950         external
951     {
952         Request storage r = requests[_requestId];
953         require(r.currencyContract == msg.sender, "caller should be the currency contract of the request"); 
954         r.state = State.Accepted;
955         emit Accepted(_requestId);
956     }
957 
958     /**
959      * @notice Function used by currency contracts to cancel a request in the Core. Several reasons can lead to cancel a request, see request life cycle for more info.
960      * @dev callable only by the currency contract of the request.
961      * @param _requestId Request id
962      */ 
963     function cancel(bytes32 _requestId)
964         external
965     {
966         Request storage r = requests[_requestId];
967         require(r.currencyContract == msg.sender, "caller should be the currency contract of the request"); 
968         r.state = State.Canceled;
969         emit Canceled(_requestId);
970     }   
971 
972     /**
973      * @notice Function used to update the balance.
974      * @dev callable only by the currency contract of the request.
975      * @param _requestId Request id
976      * @param _payeeIndex index of the payee (0 = main payee)
977      * @param _deltaAmount modifier amount
978      */ 
979     function updateBalance(bytes32 _requestId, uint8 _payeeIndex, int256 _deltaAmount)
980         external
981     {   
982         Request storage r = requests[_requestId];
983         require(r.currencyContract == msg.sender, "caller should be the currency contract of the request"); 
984 
985         if ( _payeeIndex == 0 ) {
986             // modify the main payee
987             r.payee.balance = r.payee.balance.add(_deltaAmount);
988         } else {
989             // modify the sub payee
990             Payee storage sp = subPayees[_requestId][_payeeIndex-1];
991             sp.balance = sp.balance.add(_deltaAmount);
992         }
993         emit UpdateBalance(_requestId, _payeeIndex, _deltaAmount);
994     }
995 
996     /**
997      * @notice Function update the expectedAmount adding additional or subtract.
998      * @dev callable only by the currency contract of the request.
999      * @param _requestId Request id
1000      * @param _payeeIndex index of the payee (0 = main payee)
1001      * @param _deltaAmount modifier amount
1002      */ 
1003     function updateExpectedAmount(bytes32 _requestId, uint8 _payeeIndex, int256 _deltaAmount)
1004         external
1005     {   
1006         Request storage r = requests[_requestId];
1007         require(r.currencyContract == msg.sender, "caller should be the currency contract of the request");  
1008 
1009         if ( _payeeIndex == 0 ) {
1010             // modify the main payee
1011             r.payee.expectedAmount = r.payee.expectedAmount.add(_deltaAmount);    
1012         } else {
1013             // modify the sub payee
1014             Payee storage sp = subPayees[_requestId][_payeeIndex-1];
1015             sp.expectedAmount = sp.expectedAmount.add(_deltaAmount);
1016         }
1017         emit UpdateExpectedAmount(_requestId, _payeeIndex, _deltaAmount);
1018     }
1019 
1020     /**
1021      * @notice Gets a request.
1022      * @param _requestId Request id
1023      * @return request as a tuple : (address payer, address currencyContract, State state, address payeeAddr, int256 payeeExpectedAmount, int256 payeeBalance)
1024      */ 
1025     function getRequest(bytes32 _requestId) 
1026         external
1027         view
1028         returns(address payer, address currencyContract, State state, address payeeAddr, int256 payeeExpectedAmount, int256 payeeBalance)
1029     {
1030         Request storage r = requests[_requestId];
1031         return (
1032             r.payer,
1033             r.currencyContract,
1034             r.state,
1035             r.payee.addr,
1036             r.payee.expectedAmount,
1037             r.payee.balance
1038         );
1039     }
1040 
1041     /**
1042      * @notice Gets address of a payee.
1043      * @param _requestId Request id
1044      * @param _payeeIndex payee index (0 = main payee)
1045      * @return payee address
1046      */ 
1047     function getPayeeAddress(bytes32 _requestId, uint8 _payeeIndex)
1048         public
1049         view
1050         returns(address)
1051     {
1052         if (_payeeIndex == 0) {
1053             return requests[_requestId].payee.addr;
1054         } else {
1055             return subPayees[_requestId][_payeeIndex-1].addr;
1056         }
1057     }
1058 
1059     /**
1060      * @notice Gets payer of a request.
1061      * @param _requestId Request id
1062      * @return payer address
1063      */ 
1064     function getPayer(bytes32 _requestId)
1065         public
1066         view
1067         returns(address)
1068     {
1069         return requests[_requestId].payer;
1070     }
1071 
1072     /**
1073      * @notice Gets amount expected of a payee.
1074      * @param _requestId Request id
1075      * @param _payeeIndex payee index (0 = main payee)
1076      * @return amount expected
1077      */     
1078     function getPayeeExpectedAmount(bytes32 _requestId, uint8 _payeeIndex)
1079         public
1080         view
1081         returns(int256)
1082     {
1083         if (_payeeIndex == 0) {
1084             return requests[_requestId].payee.expectedAmount;
1085         } else {
1086             return subPayees[_requestId][_payeeIndex-1].expectedAmount;
1087         }
1088     }
1089 
1090     /**
1091      * @notice Gets number of subPayees for a request.
1092      * @param _requestId Request id
1093      * @return number of subPayees
1094      */     
1095     function getSubPayeesCount(bytes32 _requestId)
1096         public
1097         view
1098         returns(uint8)
1099     {
1100         // solium-disable-next-line no-empty-blocks
1101         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1)) {}
1102         return i;
1103     }
1104 
1105     /**
1106      * @notice Gets currencyContract of a request.
1107      * @param _requestId Request id
1108      * @return currencyContract address
1109      */
1110     function getCurrencyContract(bytes32 _requestId)
1111         public
1112         view
1113         returns(address)
1114     {
1115         return requests[_requestId].currencyContract;
1116     }
1117 
1118     /**
1119      * @notice Gets balance of a payee.
1120      * @param _requestId Request id
1121      * @param _payeeIndex payee index (0 = main payee)
1122      * @return balance
1123      */     
1124     function getPayeeBalance(bytes32 _requestId, uint8 _payeeIndex)
1125         public
1126         view
1127         returns(int256)
1128     {
1129         if (_payeeIndex == 0) {
1130             return requests[_requestId].payee.balance;    
1131         } else {
1132             return subPayees[_requestId][_payeeIndex-1].balance;
1133         }
1134     }
1135 
1136     /**
1137      * @notice Gets balance total of a request.
1138      * @param _requestId Request id
1139      * @return balance
1140      */     
1141     function getBalance(bytes32 _requestId)
1142         public
1143         view
1144         returns(int256)
1145     {
1146         int256 balance = requests[_requestId].payee.balance;
1147 
1148         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1)) {
1149             balance = balance.add(subPayees[_requestId][i].balance);
1150         }
1151 
1152         return balance;
1153     }
1154 
1155     /**
1156      * @notice Checks if all the payees balances are null.
1157      * @param _requestId Request id
1158      * @return true if all the payees balances are equals to 0
1159      */     
1160     function areAllBalanceNull(bytes32 _requestId)
1161         public
1162         view
1163         returns(bool isNull)
1164     {
1165         isNull = requests[_requestId].payee.balance == 0;
1166 
1167         for (uint8 i = 0; isNull && subPayees[_requestId][i].addr != address(0); i = i.add(1)) {
1168             isNull = subPayees[_requestId][i].balance == 0;
1169         }
1170 
1171         return isNull;
1172     }
1173 
1174     /**
1175      * @notice Gets total expectedAmount of a request.
1176      * @param _requestId Request id
1177      * @return balance
1178      */     
1179     function getExpectedAmount(bytes32 _requestId)
1180         public
1181         view
1182         returns(int256)
1183     {
1184         int256 expectedAmount = requests[_requestId].payee.expectedAmount;
1185 
1186         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1)) {
1187             expectedAmount = expectedAmount.add(subPayees[_requestId][i].expectedAmount);
1188         }
1189 
1190         return expectedAmount;
1191     }
1192 
1193     /**
1194      * @notice Gets state of a request.
1195      * @param _requestId Request id
1196      * @return state
1197      */ 
1198     function getState(bytes32 _requestId)
1199         public
1200         view
1201         returns(State)
1202     {
1203         return requests[_requestId].state;
1204     }
1205 
1206     /**
1207      * @notice Gets address of a payee.
1208      * @param _requestId Request id
1209      * @return payee index (0 = main payee) or -1 if not address not found
1210      */
1211     function getPayeeIndex(bytes32 _requestId, address _address)
1212         public
1213         view
1214         returns(int16)
1215     {
1216         // return 0 if main payee
1217         if (requests[_requestId].payee.addr == _address) {
1218             return 0;
1219         }
1220 
1221         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1)) {
1222             if (subPayees[_requestId][i].addr == _address) {
1223                 // if found return subPayee index + 1 (0 is main payee)
1224                 return i+1;
1225             }
1226         }
1227         return -1;
1228     }
1229 
1230     /**
1231      * @notice Extracts a bytes32 from a bytes.
1232      * @param _data bytes from where the bytes32 will be extract
1233      * @param offset position of the first byte of the bytes32
1234      * @return address
1235      */
1236     function extractBytes32(bytes _data, uint offset)
1237         public
1238         pure
1239         returns (bytes32 bs)
1240     {
1241         require(offset >= 0 && offset + 32 <= _data.length, "offset value should be in the correct range");
1242 
1243         // solium-disable-next-line security/no-inline-assembly
1244         assembly {
1245             bs := mload(add(_data, add(32, offset)))
1246         }
1247     }
1248 
1249     /**
1250      * @notice Transfers to owner any tokens send by mistake on this contracts.
1251      * @param token The address of the token to transfer.
1252      * @param amount The amount to be transfered.
1253      */
1254     function emergencyERC20Drain(ERC20 token, uint amount )
1255         public
1256         onlyOwner 
1257     {
1258         token.transfer(owner, amount);
1259     }
1260 
1261     /**
1262      * @notice Extracts an address from a bytes at a given position.
1263      * @param _data bytes from where the address will be extract
1264      * @param offset position of the first byte of the address
1265      * @return address
1266      */
1267     function extractAddress(bytes _data, uint offset)
1268         internal
1269         pure
1270         returns (address m)
1271     {
1272         require(offset >= 0 && offset + 20 <= _data.length, "offset value should be in the correct range");
1273 
1274         // solium-disable-next-line security/no-inline-assembly
1275         assembly {
1276             m := and( mload(add(_data, add(20, offset))), 
1277                       0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
1278         }
1279     }
1280     
1281     /**
1282      * @dev Internal: Init payees for a request (needed to avoid 'stack too deep' in createRequest()).
1283      * @param _requestId Request id
1284      * @param _payees array of payees address
1285      * @param _expectedAmounts array of payees initial expected amounts
1286      */ 
1287     function initSubPayees(bytes32 _requestId, address[] _payees, int256[] _expectedAmounts)
1288         internal
1289     {
1290         require(_payees.length == _expectedAmounts.length, "payee length should equal expected amount length");
1291      
1292         for (uint8 i = 1; i < _payees.length; i = i.add(1)) {
1293             // payees address cannot be 0x0
1294             require(_payees[i] != 0, "payee should not be 0");
1295             subPayees[_requestId][i-1] = Payee(_payees[i], _expectedAmounts[i], 0);
1296             emit NewSubPayee(_requestId, _payees[i]);
1297         }
1298     }
1299 
1300     /**
1301      * @notice Extracts a string from a bytes. Extracts a sub-part from tha bytes and convert it to string.
1302      * @param data bytes from where the string will be extracted
1303      * @param size string size to extract
1304      * @param _offset position of the first byte of the string in bytes
1305      * @return string
1306      */ 
1307     function extractString(bytes data, uint8 size, uint _offset) 
1308         internal 
1309         pure 
1310         returns (string) 
1311     {
1312         bytes memory bytesString = new bytes(size);
1313         for (uint j = 0; j < size; j++) {
1314             bytesString[j] = data[_offset+j];
1315         }
1316         return string(bytesString);
1317     }
1318 
1319     /**
1320      * @notice Generates a new unique requestId.
1321      * @return a bytes32 requestId 
1322      */ 
1323     function generateRequestId()
1324         internal
1325         returns (bytes32)
1326     {
1327         // Update numRequest
1328         numRequests = numRequests.add(1);
1329         // requestId = ADDRESS_CONTRACT_CORE + numRequests (0xADRRESSCONTRACT00000NUMREQUEST)
1330         return bytes32((uint256(this) << 96).add(numRequests));
1331     }
1332 }
1333 
1334 
1335 /**
1336  * @title CurrencyContract
1337  *
1338  * @notice CurrencyContract is the base for currency contracts. To add a currency to the Request Protocol, create a new currencyContract that inherits from it.
1339  * @dev If currency contract is whitelisted by core & unpaused: All actions possible
1340  * @dev If currency contract is not Whitelisted by core & unpaused: Creation impossible, other actions possible
1341  * @dev If currency contract is paused: Nothing possible
1342  *
1343  * Functions that can be implemented by the currency contracts:
1344  *  - createRequestAsPayeeAction
1345  *  - createRequestAsPayerAction
1346  *  - broadcastSignedRequestAsPayer
1347  *  - paymentActionPayable
1348  *  - paymentAction
1349  *  - accept
1350  *  - cancel
1351  *  - refundAction
1352  *  - subtractAction
1353  *  - additionalAction
1354  */
1355 contract CurrencyContract is Pausable, FeeCollector {
1356     using SafeMath for uint256;
1357     using SafeMathInt for int256;
1358     using SafeMathUint8 for uint8;
1359 
1360     RequestCore public requestCore;
1361 
1362     /**
1363      * @param _requestCoreAddress Request Core address
1364      */
1365     constructor(address _requestCoreAddress, address _addressBurner) 
1366         FeeCollector(_addressBurner)
1367         public
1368     {
1369         requestCore = RequestCore(_requestCoreAddress);
1370     }
1371 
1372     /**
1373      * @notice Function to accept a request.
1374      *
1375      * @notice msg.sender must be _payer, The request must be in the state CREATED (not CANCELED, not ACCEPTED).
1376      *
1377      * @param _requestId id of the request
1378      */
1379     function acceptAction(bytes32 _requestId)
1380         public
1381         whenNotPaused
1382         onlyRequestPayer(_requestId)
1383     {
1384         // only a created request can be accepted
1385         require(requestCore.getState(_requestId) == RequestCore.State.Created, "request should be created");
1386 
1387         // declare the acceptation in the core
1388         requestCore.accept(_requestId);
1389     }
1390 
1391     /**
1392      * @notice Function to cancel a request.
1393      *
1394      * @dev msg.sender must be the _payer or the _payee.
1395      * @dev only request with balance equals to zero can be cancel.
1396      *
1397      * @param _requestId id of the request
1398      */
1399     function cancelAction(bytes32 _requestId)
1400         public
1401         whenNotPaused
1402     {
1403         // payer can cancel if request is just created
1404         // payee can cancel when request is not canceled yet
1405         require(
1406             // solium-disable-next-line indentation
1407             (requestCore.getPayer(_requestId) == msg.sender && requestCore.getState(_requestId) == RequestCore.State.Created) ||
1408             (requestCore.getPayeeAddress(_requestId,0) == msg.sender && requestCore.getState(_requestId) != RequestCore.State.Canceled),
1409             "payer should cancel a newly created request, or payee should cancel a not cancel request"
1410         );
1411 
1412         // impossible to cancel a Request with any payees balance != 0
1413         require(requestCore.areAllBalanceNull(_requestId), "all balanaces should be = 0 to cancel");
1414 
1415         // declare the cancellation in the core
1416         requestCore.cancel(_requestId);
1417     }
1418 
1419     /**
1420      * @notice Function to declare additionals.
1421      *
1422      * @dev msg.sender must be _payer.
1423      * @dev the request must be accepted or created.
1424      *
1425      * @param _requestId id of the request
1426      * @param _additionalAmounts amounts of additional to declare (index 0 is for main payee)
1427      */
1428     function additionalAction(bytes32 _requestId, uint256[] _additionalAmounts)
1429         public
1430         whenNotPaused
1431         onlyRequestPayer(_requestId)
1432     {
1433 
1434         // impossible to make additional if request is canceled
1435         require(requestCore.getState(_requestId) != RequestCore.State.Canceled, "request should not be canceled");
1436 
1437         // impossible to declare more additionals than the number of payees
1438         require(
1439             _additionalAmounts.length <= requestCore.getSubPayeesCount(_requestId).add(1),
1440             "number of amounts should be <= number of payees"
1441         );
1442 
1443         for (uint8 i = 0; i < _additionalAmounts.length; i = i.add(1)) {
1444             // no need to declare a zero as additional 
1445             if (_additionalAmounts[i] != 0) {
1446                 // Store and declare the additional in the core
1447                 requestCore.updateExpectedAmount(_requestId, i, _additionalAmounts[i].toInt256Safe());
1448             }
1449         }
1450     }
1451 
1452     /**
1453      * @notice Function to declare subtracts.
1454      *
1455      * @dev msg.sender must be _payee.
1456      * @dev the request must be accepted or created.
1457      *
1458      * @param _requestId id of the request
1459      * @param _subtractAmounts amounts of subtract to declare (index 0 is for main payee)
1460      */
1461     function subtractAction(bytes32 _requestId, uint256[] _subtractAmounts)
1462         public
1463         whenNotPaused
1464         onlyRequestPayee(_requestId)
1465     {
1466         // impossible to make subtracts if request is canceled
1467         require(requestCore.getState(_requestId) != RequestCore.State.Canceled, "request should not be canceled");
1468 
1469         // impossible to declare more subtracts than the number of payees
1470         require(
1471             _subtractAmounts.length <= requestCore.getSubPayeesCount(_requestId).add(1),
1472             "number of amounts should be <= number of payees"
1473         );
1474 
1475         for (uint8 i = 0; i < _subtractAmounts.length; i = i.add(1)) {
1476             // no need to declare a zero as subtracts 
1477             if (_subtractAmounts[i] != 0) {
1478                 // subtract must be equal or lower than amount expected
1479                 require(
1480                     requestCore.getPayeeExpectedAmount(_requestId,i) >= _subtractAmounts[i].toInt256Safe(),
1481                     "subtract should equal or be lower than amount expected"
1482                 );
1483 
1484                 // Store and declare the subtract in the core
1485                 requestCore.updateExpectedAmount(_requestId, i, -_subtractAmounts[i].toInt256Safe());
1486             }
1487         }
1488     }
1489 
1490     /**
1491      * @notice Base function for request creation.
1492      *
1493      * @dev msg.sender will be the creator.
1494      *
1495      * @param _payer Entity expected to pay
1496      * @param _payeesIdAddress array of payees address (the index 0 will be the payee - must be msg.sender - the others are subPayees)
1497      * @param _expectedAmounts array of Expected amount to be received by each payees
1498      * @param _data Hash linking to additional data on the Request stored on IPFS
1499      *
1500      * @return Returns the id of the request and the collected fees
1501      */
1502     function createCoreRequestInternal(
1503         address     _payer,
1504         address[]   _payeesIdAddress,
1505         int256[]    _expectedAmounts,
1506         string      _data)
1507         internal
1508         whenNotPaused
1509         returns(bytes32 requestId, uint256 collectedFees)
1510     {
1511         int256 totalExpectedAmounts = 0;
1512         for (uint8 i = 0; i < _expectedAmounts.length; i = i.add(1)) {
1513             // all expected amounts must be positive
1514             require(_expectedAmounts[i] >= 0, "expected amounts should be positive");
1515 
1516             // compute the total expected amount of the request
1517             totalExpectedAmounts = totalExpectedAmounts.add(_expectedAmounts[i]);
1518         }
1519 
1520         // store request in the core
1521         requestId = requestCore.createRequest(
1522             msg.sender,
1523             _payeesIdAddress,
1524             _expectedAmounts,
1525             _payer,
1526             _data
1527         );
1528 
1529         // compute and send fees
1530         collectedFees = collectEstimation(totalExpectedAmounts);
1531         collectForREQBurning(collectedFees);
1532     }
1533 
1534     /**
1535      * @notice Modifier to check if msg.sender is the main payee.
1536      * @dev Revert if msg.sender is not the main payee.
1537      * @param _requestId id of the request
1538      */ 
1539     modifier onlyRequestPayee(bytes32 _requestId)
1540     {
1541         require(requestCore.getPayeeAddress(_requestId, 0) == msg.sender, "only the payee should do this action");
1542         _;
1543     }
1544 
1545     /**
1546      * @notice Modifier to check if msg.sender is payer.
1547      * @dev Revert if msg.sender is not payer.
1548      * @param _requestId id of the request
1549      */ 
1550     modifier onlyRequestPayer(bytes32 _requestId)
1551     {
1552         require(requestCore.getPayer(_requestId) == msg.sender, "only the payer should do this action");
1553         _;
1554     }
1555 }
1556 
1557 
1558 /**
1559  * @title RequestBitcoinNodesValidation
1560  * @notice Currency contract managing the requests in Bitcoin
1561  * @dev Requests can be created by the Payee with createRequestAsPayeeAction() or by the payer from a request signed offchain by the payee with broadcastSignedRequestAsPayer
1562  */
1563 contract RequestBitcoinNodesValidation is CurrencyContract {
1564     using SafeMath for uint256;
1565     using SafeMathInt for int256;
1566     using SafeMathUint8 for uint8;
1567 
1568     // bitcoin addresses for payment and refund by requestid
1569     // every time a transaction is sent to one of these addresses, it will be interpreted offchain as a payment (index 0 is the main payee, next indexes are for sub-payee)
1570     mapping(bytes32 => string[256]) public payeesPaymentAddress;
1571 
1572     // every time a transaction is sent to one of these addresses, it will be interpreted offchain as a refund (index 0 is the main payee, next indexes are for sub-payee)
1573     mapping(bytes32 => string[256]) public payerRefundAddress;
1574 
1575     // event triggered when the refund addresses are added after the creation via 'addPayerRefundAddressAction'
1576     event RefundAddressAdded(bytes32 indexed requestId);
1577 
1578     /**
1579      * @param _requestCoreAddress Request Core address
1580      * @param _requestBurnerAddress Request Burner contract address
1581      */
1582     constructor (address _requestCoreAddress, address _requestBurnerAddress) 
1583         CurrencyContract(_requestCoreAddress, _requestBurnerAddress)
1584         public
1585     {
1586         // nothing to do here
1587     }
1588 
1589     /**
1590      * @notice Function to create a request as payee.
1591      *
1592      * @dev msg.sender must be the main payee.
1593      *
1594      * @param _payeesIdAddress array of payees address (the index 0 will be the payee - must be msg.sender - the others are subPayees)
1595      * @param _payeesPaymentAddress array of payees bitcoin address for payment as bytes (bitcoin address don't have a fixed size)
1596      *                                           [
1597      *                                            uint8(payee1_bitcoin_address_size)
1598      *                                            string(payee1_bitcoin_address)
1599      *                                            uint8(payee2_bitcoin_address_size)
1600      *                                            string(payee2_bitcoin_address)
1601      *                                            ...
1602      *                                           ]
1603      * @param _expectedAmounts array of Expected amount to be received by each payees
1604      * @param _payer Entity expected to pay
1605      * @param _payerRefundAddress payer bitcoin addresses for refund as bytes (bitcoin address don't have a fixed size)
1606      *                                           [
1607      *                                            uint8(payee1_refund_bitcoin_address_size)
1608      *                                            string(payee1_refund_bitcoin_address)
1609      *                                            uint8(payee2_refund_bitcoin_address_size)
1610      *                                            string(payee2_refund_bitcoin_address)
1611      *                                            ...
1612      *                                           ]
1613      * @param _data Hash linking to additional data on the Request stored on IPFS
1614      *
1615      * @return Returns the id of the request
1616      */
1617     function createRequestAsPayeeAction(
1618         address[]    _payeesIdAddress,
1619         bytes        _payeesPaymentAddress,
1620         int256[]     _expectedAmounts,
1621         address      _payer,
1622         bytes        _payerRefundAddress,
1623         string       _data)
1624         external
1625         payable
1626         whenNotPaused
1627         returns(bytes32 requestId)
1628     {
1629         require(
1630             msg.sender == _payeesIdAddress[0] && msg.sender != _payer && _payer != 0,
1631             "caller should be the payee"
1632         );
1633 
1634         uint256 collectedFees;
1635         (requestId, collectedFees) = createCoreRequestInternal(
1636             _payer,
1637             _payeesIdAddress,
1638             _expectedAmounts,
1639             _data
1640         );
1641         
1642         // Additional check on the fees: they should be equal to the about of ETH sent
1643         require(collectedFees == msg.value, "fees should be the correct amout");
1644     
1645         extractAndStoreBitcoinAddresses(
1646             requestId,
1647             _payeesIdAddress.length,
1648             _payeesPaymentAddress,
1649             _payerRefundAddress
1650         );
1651         
1652         return requestId;
1653     }
1654 
1655     /**
1656      * @notice Function to broadcast and accept an offchain signed request (the broadcaster can also pays and makes additionals).
1657      *
1658      * @dev msg.sender will be the _payer.
1659      * @dev only the _payer can additionals.
1660      *
1661      * @param _requestData nested bytes containing : creator, payer, payees|expectedAmounts, data
1662      * @param _payeesPaymentAddress array of payees bitcoin address for payment as bytes
1663      *                                           [
1664      *                                            uint8(payee1_bitcoin_address_size)
1665      *                                            string(payee1_bitcoin_address)
1666      *                                            uint8(payee2_bitcoin_address_size)
1667      *                                            string(payee2_bitcoin_address)
1668      *                                            ...
1669      *                                           ]
1670      * @param _payerRefundAddress payer bitcoin addresses for refund as bytes
1671      *                                           [
1672      *                                            uint8(payee1_refund_bitcoin_address_size)
1673      *                                            string(payee1_refund_bitcoin_address)
1674      *                                            uint8(payee2_refund_bitcoin_address_size)
1675      *                                            string(payee2_refund_bitcoin_address)
1676      *                                            ...
1677      *                                           ]
1678      * @param _additionals array to increase the ExpectedAmount for payees
1679      * @param _expirationDate timestamp after that the signed request cannot be broadcasted
1680      * @param _signature ECDSA signature in bytes
1681      *
1682      * @return Returns the id of the request
1683      */
1684     function broadcastSignedRequestAsPayerAction(
1685         bytes         _requestData, // gather data to avoid "stack too deep"
1686         bytes         _payeesPaymentAddress,
1687         bytes         _payerRefundAddress,
1688         uint256[]     _additionals,
1689         uint256       _expirationDate,
1690         bytes         _signature)
1691         external
1692         payable
1693         whenNotPaused
1694         returns(bytes32 requestId)
1695     {
1696         // check expiration date
1697         // solium-disable-next-line security/no-block-members
1698         require(_expirationDate >= block.timestamp, "expiration should be after current time");
1699 
1700         // check the signature
1701         require(
1702             Signature.checkBtcRequestSignature(
1703                 _requestData,
1704                 _payeesPaymentAddress,
1705                 _expirationDate,
1706                 _signature
1707             ),
1708             "signature should be correct"
1709         );
1710 
1711         return createAcceptAndAdditionalsFromBytes(
1712             _requestData,
1713             _payeesPaymentAddress,
1714             _payerRefundAddress,
1715             _additionals
1716         );
1717     }
1718 
1719     /**
1720      * @dev function to add refund address for payer
1721      *
1722      * @notice msg.sender must be _payer
1723      * @notice the refund addresses must not have been already provided 
1724      *
1725      * @param _requestId                id of the request
1726      * @param _payerRefundAddress       payer bitcoin addresses for refund as bytes
1727      *                                           [
1728      *                                            uint8(payee1_refund_bitcoin_address_size)
1729      *                                            string(payee1_refund_bitcoin_address)
1730      *                                            uint8(payee2_refund_bitcoin_address_size)
1731      *                                            string(payee2_refund_bitcoin_address)
1732      *                                            ...
1733      *                                           ]
1734      */
1735     function addPayerRefundAddressAction(
1736         bytes32     _requestId,
1737         bytes       _payerRefundAddress)
1738         external
1739         whenNotPaused
1740         onlyRequestPayer(_requestId)
1741     {
1742         // get the number of payees
1743         uint8 payeesCount = requestCore.getSubPayeesCount(_requestId).add(1);
1744 
1745         // set payment addresses for payees
1746         // index of the byte read in _payerRefundAddress
1747         uint256 cursor = 0;
1748         uint8 sizeCurrentBitcoinAddress;
1749         uint8 j;
1750 
1751         // set payment address for payer
1752         for (j = 0; j < payeesCount; j = j.add(1)) {
1753             // payer refund address cannot be overridden
1754             require(bytes(payerRefundAddress[_requestId][cursor]).length == 0, "payer refund address must not be already given");
1755 
1756             // get the size of the current bitcoin address
1757             sizeCurrentBitcoinAddress = uint8(_payerRefundAddress[cursor]);
1758 
1759             // extract and store the current bitcoin address
1760             payerRefundAddress[_requestId][j] = Bytes.extractString(_payerRefundAddress, sizeCurrentBitcoinAddress, ++cursor);
1761 
1762             // move the cursor to the next bicoin address
1763             cursor += sizeCurrentBitcoinAddress;
1764         }
1765         emit RefundAddressAdded(_requestId);
1766     }
1767 
1768     /**
1769      * @dev Internal function to extract and store bitcoin addresses from bytes.
1770      *
1771      * @param _requestId                id of the request
1772      * @param _payeesCount              number of payees
1773      * @param _payeesPaymentAddress     array of payees bitcoin address for payment as bytes
1774      *                                           [
1775      *                                            uint8(payee1_bitcoin_address_size)
1776      *                                            string(payee1_bitcoin_address)
1777      *                                            uint8(payee2_bitcoin_address_size)
1778      *                                            string(payee2_bitcoin_address)
1779      *                                            ...
1780      *                                           ]
1781      * @param _payerRefundAddress       payer bitcoin addresses for refund as bytes
1782      *                                           [
1783      *                                            uint8(payee1_refund_bitcoin_address_size)
1784      *                                            string(payee1_refund_bitcoin_address)
1785      *                                            uint8(payee2_refund_bitcoin_address_size)
1786      *                                            string(payee2_refund_bitcoin_address)
1787      *                                            ...
1788      *                                           ]
1789      */
1790     function extractAndStoreBitcoinAddresses(
1791         bytes32     _requestId,
1792         uint256     _payeesCount,
1793         bytes       _payeesPaymentAddress,
1794         bytes       _payerRefundAddress) 
1795         internal
1796     {
1797         // set payment addresses for payees
1798         uint256 cursor = 0;
1799         uint8 sizeCurrentBitcoinAddress;
1800         uint8 j;
1801         for (j = 0; j < _payeesCount; j = j.add(1)) {
1802             // get the size of the current bitcoin address
1803             sizeCurrentBitcoinAddress = uint8(_payeesPaymentAddress[cursor]);
1804 
1805             // extract and store the current bitcoin address
1806             payeesPaymentAddress[_requestId][j] = Bytes.extractString(_payeesPaymentAddress, sizeCurrentBitcoinAddress, ++cursor);
1807 
1808             // move the cursor to the next bicoin address
1809             cursor += sizeCurrentBitcoinAddress;
1810         }
1811 
1812         // set payment address for payer
1813         if (_payerRefundAddress.length != 0) {
1814             cursor = 0;
1815             for (j = 0; j < _payeesCount; j = j.add(1)) {
1816                 // get the size of the current bitcoin address
1817                 sizeCurrentBitcoinAddress = uint8(_payerRefundAddress[cursor]);
1818 
1819                 // extract and store the current bitcoin address
1820                 payerRefundAddress[_requestId][j] = Bytes.extractString(_payerRefundAddress, sizeCurrentBitcoinAddress, ++cursor);
1821 
1822                 // move the cursor to the next bicoin address
1823                 cursor += sizeCurrentBitcoinAddress;
1824             }
1825         }
1826     }
1827 
1828     /**
1829      * @dev Internal function to create, accept and add additionals to a request as Payer.
1830      *
1831      * @dev msg.sender must be _payer
1832      *
1833      * @param _requestData nasty bytes containing : creator, payer, payees|expectedAmounts, data
1834      * @param _payeesPaymentAddress array of payees bitcoin address for payment
1835      * @param _payerRefundAddress payer bitcoin address for refund
1836      * @param _additionals Will increase the ExpectedAmount of the request right after its creation by adding additionals
1837      *
1838      * @return Returns the id of the request
1839      */
1840     function createAcceptAndAdditionalsFromBytes(
1841         bytes         _requestData,
1842         bytes         _payeesPaymentAddress,
1843         bytes         _payerRefundAddress,
1844         uint256[]     _additionals)
1845         internal
1846         returns(bytes32 requestId)
1847     {
1848         // extract main payee
1849         address mainPayee = Bytes.extractAddress(_requestData, 41);
1850         require(msg.sender != mainPayee && mainPayee != 0, "caller should not be the main payee");
1851         // creator must be the main payee
1852         require(Bytes.extractAddress(_requestData, 0) == mainPayee, "creator should be the main payee");
1853 
1854         // extract the number of payees
1855         uint8 payeesCount = uint8(_requestData[40]);
1856         int256 totalExpectedAmounts = 0;
1857         for (uint8 i = 0; i < payeesCount; i++) {
1858             // extract the expectedAmount for the payee[i]
1859             int256 expectedAmountTemp = int256(Bytes.extractBytes32(_requestData, uint256(i).mul(52).add(61)));
1860             
1861             // compute the total expected amount of the request
1862             totalExpectedAmounts = totalExpectedAmounts.add(expectedAmountTemp);
1863             
1864             // all expected amount must be positive
1865             require(expectedAmountTemp > 0, "expected amount should be > 0");
1866         }
1867 
1868         // compute and send fees
1869         uint256 fees = collectEstimation(totalExpectedAmounts);
1870         require(fees == msg.value, "fees should be the correct amout");
1871         collectForREQBurning(fees);
1872 
1873         // insert the msg.sender as the payer in the bytes
1874         Bytes.updateBytes20inBytes(_requestData, 20, bytes20(msg.sender));
1875         // store request in the core
1876         requestId = requestCore.createRequestFromBytes(_requestData);
1877         
1878         // set bitcoin addresses
1879         extractAndStoreBitcoinAddresses(
1880             requestId,
1881             payeesCount,
1882             _payeesPaymentAddress,
1883             _payerRefundAddress
1884         );
1885 
1886         // accept and pay the request with the value remaining after the fee collect
1887         acceptAndAdditionals(requestId, _additionals);
1888 
1889         return requestId;
1890     }
1891 
1892     /**
1893      * @dev Internal function to accept and add additionals to a request as Payer
1894      *
1895      * @param _requestId id of the request
1896      * @param _additionals Will increase the ExpectedAmounts of payees
1897      *
1898      */    
1899     function acceptAndAdditionals(
1900         bytes32     _requestId,
1901         uint256[]   _additionals)
1902         internal
1903     {
1904         acceptAction(_requestId);
1905         
1906         additionalAction(_requestId, _additionals);
1907     }
1908 }