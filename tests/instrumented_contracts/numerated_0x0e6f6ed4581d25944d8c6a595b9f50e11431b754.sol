1 pragma solidity ^0.4.22;
2 
3 contract Token  {
4     event Transfer(address indexed _from, address indexed _to, uint256 _value);
5     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
6 
7     uint256 public totalSupply;
8 
9     function balanceOf(address _owner) public view returns (uint256 balance);
10     function transfer(address _to, uint256 _value) public returns (bool success);
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12     function approve(address _spender, uint256 _value) public returns (bool success);
13     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
14     function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
15     function decreaseApproval (address _spender, uint _subtractedValue)public returns (bool success);
16 
17 }
18 
19 contract Ownable {
20     address public owner;
21 
22 
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25 
26     /**
27      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28      * account.
29      */
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     /**
43      * @dev Allows the current owner to transfer control of the contract to a newOwner.
44      * @param newOwner The address to transfer ownership to.
45      */
46     function transferOwnership(address newOwner) public onlyOwner {
47         require(newOwner != address(0));
48         emit OwnershipTransferred(owner, newOwner);
49         owner = newOwner;
50     }
51 
52 }
53 
54 contract EternalStorage {
55 
56     /**** Storage Types *******/
57 
58     address public owner;
59 
60     mapping(bytes32 => uint256)    private uIntStorage;
61     mapping(bytes32 => uint8)      private uInt8Storage;
62     mapping(bytes32 => string)     private stringStorage;
63     mapping(bytes32 => address)    private addressStorage;
64     mapping(bytes32 => bytes)      private bytesStorage;
65     mapping(bytes32 => bool)       private boolStorage;
66     mapping(bytes32 => int256)     private intStorage;
67     mapping(bytes32 => bytes32)    private bytes32Storage;
68 
69 
70     /*** Modifiers ************/
71 
72     /// @dev Only allow access from the latest version of a contract after deployment
73     modifier onlyLatestContract() {
74         require(addressStorage[keccak256(abi.encodePacked("contract.address", msg.sender))] != 0x0 || msg.sender == owner);
75         _;
76     }
77 
78     /// @dev constructor
79     constructor() public {
80         owner = msg.sender;
81         addressStorage[keccak256(abi.encodePacked("contract.address", msg.sender))] = msg.sender;
82     }
83 
84     function setOwner() public {
85         require(msg.sender == owner);
86         addressStorage[keccak256(abi.encodePacked("contract.address", owner))] = 0x0;
87         owner = msg.sender;
88         addressStorage[keccak256(abi.encodePacked("contract.address", msg.sender))] = msg.sender;
89     }
90 
91     /**** Get Methods ***********/
92 
93     /// @param _key The key for the record
94     function getAddress(bytes32 _key) external view returns (address) {
95         return addressStorage[_key];
96     }
97 
98     /// @param _key The key for the record
99     function getUint(bytes32 _key) external view returns (uint) {
100         return uIntStorage[_key];
101     }
102 
103     /// @param _key The key for the record
104     function getUint8(bytes32 _key) external view returns (uint8) {
105         return uInt8Storage[_key];
106     }
107 
108 
109     /// @param _key The key for the record
110     function getString(bytes32 _key) external view returns (string) {
111         return stringStorage[_key];
112     }
113 
114     /// @param _key The key for the record
115     function getBytes(bytes32 _key) external view returns (bytes) {
116         return bytesStorage[_key];
117     }
118 
119     /// @param _key The key for the record
120     function getBytes32(bytes32 _key) external view returns (bytes32) {
121         return bytes32Storage[_key];
122     }
123 
124     /// @param _key The key for the record
125     function getBool(bytes32 _key) external view returns (bool) {
126         return boolStorage[_key];
127     }
128 
129     /// @param _key The key for the record
130     function getInt(bytes32 _key) external view returns (int) {
131         return intStorage[_key];
132     }
133 
134     /**** Set Methods ***********/
135 
136     /// @param _key The key for the record
137     function setAddress(bytes32 _key, address _value) onlyLatestContract external {
138         addressStorage[_key] = _value;
139     }
140 
141     /// @param _key The key for the record
142     function setUint(bytes32 _key, uint _value) onlyLatestContract external {
143         uIntStorage[_key] = _value;
144     }
145 
146     /// @param _key The key for the record
147     function setUint8(bytes32 _key, uint8 _value) onlyLatestContract external {
148         uInt8Storage[_key] = _value;
149     }
150 
151     /// @param _key The key for the record
152     function setString(bytes32 _key, string _value) onlyLatestContract external {
153         stringStorage[_key] = _value;
154     }
155 
156     /// @param _key The key for the record
157     function setBytes(bytes32 _key, bytes _value) onlyLatestContract external {
158         bytesStorage[_key] = _value;
159     }
160 
161     /// @param _key The key for the record
162     function setBytes32(bytes32 _key, bytes32 _value) onlyLatestContract external {
163         bytes32Storage[_key] = _value;
164     }
165 
166     /// @param _key The key for the record
167     function setBool(bytes32 _key, bool _value) onlyLatestContract external {
168         boolStorage[_key] = _value;
169     }
170 
171     /// @param _key The key for the record
172     function setInt(bytes32 _key, int _value) onlyLatestContract external {
173         intStorage[_key] = _value;
174     }
175 
176     /**** Delete Methods ***********/
177 
178     /// @param _key The key for the record
179     function deleteAddress(bytes32 _key) onlyLatestContract external {
180         delete addressStorage[_key];
181     }
182 
183     /// @param _key The key for the record
184     function deleteUint(bytes32 _key) onlyLatestContract external {
185         delete uIntStorage[_key];
186     }
187 
188     /// @param _key The key for the record
189     function deleteUint8(bytes32 _key) onlyLatestContract external {
190         delete uInt8Storage[_key];
191     }
192 
193     /// @param _key The key for the record
194     function deleteString(bytes32 _key) onlyLatestContract external {
195         delete stringStorage[_key];
196     }
197 
198     /// @param _key The key for the record
199     function deleteBytes(bytes32 _key) onlyLatestContract external {
200         delete bytesStorage[_key];
201     }
202 
203     /// @param _key The key for the record
204     function deleteBytes32(bytes32 _key) onlyLatestContract external {
205         delete bytes32Storage[_key];
206     }
207 
208     /// @param _key The key for the record
209     function deleteBool(bytes32 _key) onlyLatestContract external {
210         delete boolStorage[_key];
211     }
212 
213     /// @param _key The key for the record
214     function deleteInt(bytes32 _key) onlyLatestContract external {
215         delete intStorage[_key];
216     }
217 }
218 
219 library PaymentLib {
220 
221     function getPaymentId(address[3] addresses, bytes32 deal, uint256 amount) public pure returns (bytes32) {
222         return keccak256(abi.encodePacked(addresses[0], addresses[1], addresses[2], deal, amount));
223     }
224 
225     function createPayment(
226         address storageAddress, bytes32 paymentId, uint8 fee, uint8 status
227     ) public {
228         setPaymentStatus(storageAddress, paymentId, status);
229         setPaymentFee(storageAddress, paymentId, fee);
230     }
231 
232     function isCancelRequested(address storageAddress, bytes32 paymentId, address party)
233     public view returns(bool) {
234         return EternalStorage(storageAddress).getBool(keccak256(abi.encodePacked("payment.cance", paymentId, party)));
235     }
236 
237     function setCancelRequested(address storageAddress, bytes32 paymentId, address party, bool value)
238     public {
239         EternalStorage(storageAddress).setBool(keccak256(abi.encodePacked("payment.cance", paymentId, party)), value);
240     }
241 
242     function getPaymentFee(address storageAddress, bytes32 paymentId)
243     public view returns (uint8) {
244         return EternalStorage(storageAddress).getUint8(keccak256(abi.encodePacked("payment.fee", paymentId)));
245     }
246 
247     function setPaymentFee(address storageAddress, bytes32 paymentId, uint8 value)
248     public {
249         EternalStorage(storageAddress).setUint8(keccak256(abi.encodePacked("payment.fee", paymentId)), value);
250     }
251 
252     function isFeePayed(address storageAddress, bytes32 paymentId)
253     public view returns (bool) {
254         return EternalStorage(storageAddress).getBool(keccak256(abi.encodePacked("payment.fee.payed", paymentId)));
255     }
256 
257     function setFeePayed(address storageAddress, bytes32 paymentId, bool value)
258     public {
259         EternalStorage(storageAddress).setBool(keccak256(abi.encodePacked("payment.fee.payed", paymentId)), value);
260     }
261 
262     function isDeposited(address storageAddress, bytes32 paymentId)
263     public view returns (bool) {
264         return EternalStorage(storageAddress).getBool(keccak256(abi.encodePacked("payment.deposited", paymentId)));
265     }
266 
267     function setDeposited(address storageAddress, bytes32 paymentId, bool value)
268     public {
269         EternalStorage(storageAddress).setBool(keccak256(abi.encodePacked("payment.deposited", paymentId)), value);
270     }
271 
272     function isSigned(address storageAddress, bytes32 paymentId)
273     public view returns (bool) {
274         return EternalStorage(storageAddress).getBool(keccak256(abi.encodePacked("payment.signed", paymentId)));
275     }
276 
277     function setSigned(address storageAddress, bytes32 paymentId, bool value)
278     public {
279         EternalStorage(storageAddress).setBool(keccak256(abi.encodePacked("payment.signed", paymentId)), value);
280     }
281 
282     function getPaymentStatus(address storageAddress, bytes32 paymentId)
283     public view returns (uint8) {
284         return EternalStorage(storageAddress).getUint8(keccak256(abi.encodePacked("payment.status", paymentId)));
285     }
286 
287     function setPaymentStatus(address storageAddress, bytes32 paymentId, uint8 status)
288     public {
289         EternalStorage(storageAddress).setUint8(keccak256(abi.encodePacked("payment.status", paymentId)), status);
290     }
291 
292     function getOfferAmount(address storageAddress, bytes32 paymentId, address user)
293     public view returns (uint256) {
294         return EternalStorage(storageAddress).getUint(keccak256(abi.encodePacked("payment.amount.refund", paymentId, user)));
295     }
296 
297     function setOfferAmount(address storageAddress, bytes32 paymentId, address user, uint256 amount)
298     public {
299         EternalStorage(storageAddress).setUint(keccak256(abi.encodePacked("payment.amount.refund", paymentId, user)), amount);
300     }
301 
302     function getWithdrawAmount(address storageAddress, bytes32 paymentId, address user)
303     public view returns (uint256) {
304         return EternalStorage(storageAddress).getUint(keccak256(abi.encodePacked("payment.amount.withdraw", paymentId, user)));
305     }
306 
307     function setWithdrawAmount(address storageAddress, bytes32 paymentId, address user, uint256 amount)
308     public {
309         EternalStorage(storageAddress).setUint(keccak256(abi.encodePacked("payment.amount.withdraw", paymentId, user)), amount);
310     }
311 
312     function isWithdrawn(address storageAddress, bytes32 paymentId, address user)
313     public view returns (bool) {
314         return EternalStorage(storageAddress).getBool(keccak256(abi.encodePacked("payment.withdrawed", paymentId, user)));
315     }
316 
317     function setWithdrawn(address storageAddress, bytes32 paymentId, address user, bool value)
318     public {
319         EternalStorage(storageAddress).setBool(keccak256(abi.encodePacked("payment.withdrawed", paymentId, user)), value);
320     }
321 
322     function getPayment(address storageAddress, bytes32 paymentId)
323     public view returns(
324         uint8 status, uint8 fee, bool feePayed, bool signed, bool deposited
325     ) {
326         status = uint8(getPaymentStatus(storageAddress, paymentId));
327         fee = getPaymentFee(storageAddress, paymentId);
328         feePayed = isFeePayed(storageAddress, paymentId);
329         signed = isSigned(storageAddress, paymentId);
330         deposited = isDeposited(storageAddress, paymentId);
331     }
332 
333     function getPaymentOffers(address storageAddress, address depositor, address beneficiary, bytes32 paymentId)
334     public view returns(uint256 depositorOffer, uint256 beneficiaryOffer) {
335         depositorOffer = getOfferAmount(storageAddress, paymentId, depositor);
336         beneficiaryOffer = getOfferAmount(storageAddress, paymentId, beneficiary);
337     }
338 }
339 
340 contract Withdrawable is Ownable {
341     function withdrawEth(uint value) external onlyOwner {
342         require(address(this).balance >= value);
343         msg.sender.transfer(value);
344     }
345 
346     function withdrawToken(address token, uint value) external onlyOwner {
347         require(Token(token).balanceOf(address(this)) >= value, "Not enough tokens");
348         require(Token(token).transfer(msg.sender, value));
349     }
350 }
351 
352 contract IEscrow is Withdrawable {
353 
354     /*----------------------PAYMENT STATUSES----------------------*/
355 
356     //SIGNED status kept for backward compatibility
357     enum PaymentStatus {NONE/*code=0*/, CREATED/*code=1*/, SIGNED/*code=2*/, CONFIRMED/*code=3*/, RELEASED/*code=4*/, RELEASED_BY_DISPUTE /*code=5*/, CLOSED/*code=6*/, CANCELED/*code=7*/}
358     
359     /*----------------------EVENTS----------------------*/
360 
361     event PaymentCreated(bytes32 paymentId, address depositor, address beneficiary, address token, bytes32 deal, uint256 amount, uint8 fee);
362     event PaymentSigned(bytes32 paymentId, bool confirmed);
363     event PaymentDeposited(bytes32 paymentId, uint256 depositedAmount, bool feePayed, bool confirmed);
364     event PaymentReleased(bytes32 paymentId);
365     event PaymentOffer(bytes32 paymentId, uint256 offerAmount);
366     event PaymentOfferCanceled(bytes32 paymentId);
367     event PaymentOwnOfferCanceled(bytes32 paymentId);
368     event PaymentOfferAccepted(bytes32 paymentId, uint256 releaseToBeneficiary, uint256 refundToDepositor);
369     event PaymentWithdrawn(bytes32 paymentId, uint256 amount);
370     event PaymentWithdrawnByDispute(bytes32 paymentId, uint256 amount, bytes32 dispute);
371     event PaymentCanceled(bytes32 paymentId);
372     event PaymentClosed(bytes32 paymentId);
373     event PaymentClosedByDispute(bytes32 paymentId, bytes32 dispute);
374 
375     /*----------------------PUBLIC STATE----------------------*/
376 
377     address public lib;
378     address public courtAddress;
379     address public paymentHolder;
380 
381 
382     /*----------------------CONFIGURATION METHODS (only owner) ----------------------*/
383     function setStorageAddress(address _storageAddress) external;
384 
385     function setCourtAddress(address _courtAddress) external;
386 
387     /*----------------------PUBLIC USER METHODS----------------------*/
388     /** @dev Depositor creates escrow payment. Set token as 0x0 in case of ETH amount.
389       * @param addresses [depositor, beneficiary, token]
390       */
391     function createPayment(address[3] addresses, bytes32 deal, uint256 amount) external;
392 
393     /** @dev Beneficiary signs escrow payment as consent for taking part.
394       * @param addresses [depositor, beneficiary, token]
395       */
396     function sign(address[3] addresses, bytes32 deal, uint256 amount) external;
397 
398     /** @dev Depositor deposits payment amount only after it was signed by beneficiary.
399       * @param addresses [depositor, beneficiary, token]
400       * @param payFee If true, depositor have to send (amount + (amount * fee) / 100).
401       */
402     function deposit(address[3] addresses, bytes32 deal, uint256 amount, bool payFee) external payable;
403 
404     /** @dev Depositor or Beneficiary requests payment cancellation after payment was signed by beneficiary.
405       *      Payment is closed, if depositor and beneficiary both request cancellation.
406       * @param addresses [depositor, beneficiary, token]
407       */
408     function cancel(address[3] addresses, bytes32 deal, uint256 amount) external;
409 
410     /** @dev Depositor close payment though transfer payment amount to another party.
411       * @param addresses [depositor, beneficiary, token]
412       */
413     function release(address[3] addresses, bytes32 deal, uint256 amount) external;
414 
415     /** @dev Depositor or beneficiary offers partial closing payment with offerAmount.
416       * @param addresses [depositor, beneficiary, token]
417       * @param offerAmount Amount of partial closing offer in currency of payment (ETH or token).
418       */
419     function offer(address[3] addresses, bytes32 deal, uint256 amount, uint256 offerAmount) external;
420 
421     /** @dev Depositor or beneficiary canceles another party offer.
422       * @param addresses [depositor, beneficiary, token]
423       */
424     function cancelOffer(address[3] addresses, bytes32 deal, uint256 amount) external;
425 
426     /** @dev Depositor or beneficiary cancels own offer.
427       * @param addresses [depositor, beneficiary, token]
428       */
429     function cancelOwnOffer(address[3] addresses, bytes32 deal, uint256 amount) external;
430 
431     /** @dev Depositor or beneficiary accepts opposite party offer.
432       * @param addresses [depositor, beneficiary, token]
433       */
434     function acceptOffer(address[3] addresses, bytes32 deal, uint256 amount) external;
435 
436    
437     /** @dev Depositor or beneficiary withdraw amounts.
438       * @param addresses [depositor, beneficiary, token]
439       */
440     function withdraw(address[3] addresses, bytes32 deal, uint256 amount) external;
441 
442     /** @dev Depositor or Beneficiary withdraw amounts according dispute verdict.
443       * @dev Have to use fucking arrays due to "stack too deep" issue.
444       * @param addresses [depositor, beneficiary, token]
445       * @param disputeParties [applicant, respondent]
446       * @param uints [paymentAmount, disputeAmount, disputeCreatedAt]
447       * @param byts [deal, disputeTitle]
448       */
449     function withdrawByDispute(address[3] addresses, address[2] disputeParties, uint256[3] uints, bytes32[2] byts) external;
450 }
451 
452 contract PaymentHolder is Ownable {
453 
454     modifier onlyAllowed() {
455         require(allowed[msg.sender]);
456         _;
457     }
458 
459     modifier onlyUpdater() {
460         require(msg.sender == updater);
461         _;
462     }
463 
464     mapping(address => bool) public allowed;
465     address public updater;
466 
467     /*-----------------MAINTAIN METHODS------------------*/
468 
469     function setUpdater(address _updater)
470     external onlyOwner {
471         updater = _updater;
472     }
473 
474     function migrate(address newHolder, address[] tokens, address[] _allowed)
475     external onlyOwner {
476         require(PaymentHolder(newHolder).update.value(address(this).balance)(_allowed));
477         for (uint256 i = 0; i < tokens.length; i++) {
478             address token = tokens[i];
479             uint256 balance = Token(token).balanceOf(this);
480             if (balance > 0) {
481                 require(Token(token).transfer(newHolder, balance));
482             }
483         }
484     }
485 
486     function update(address[] _allowed)
487     external payable onlyUpdater returns(bool) {
488         for (uint256 i = 0; i < _allowed.length; i++) {
489             allowed[_allowed[i]] = true;
490         }
491         return true;
492     }
493 
494     /*-----------------OWNER FLOW------------------*/
495 
496     function allow(address to) 
497     external onlyOwner { allowed[to] = true; }
498 
499     function prohibit(address to)
500     external onlyOwner { allowed[to] = false; }
501 
502     /*-----------------ALLOWED FLOW------------------*/
503 
504     function depositEth()
505     public payable onlyAllowed returns (bool) {
506         //Default function to receive eth
507         return true;
508     }
509 
510     function withdrawEth(address to, uint256 amount)
511     public onlyAllowed returns(bool) {
512         require(address(this).balance >= amount, "Not enough ETH balance");
513         to.transfer(amount);
514         return true;
515     }
516 
517     function withdrawToken(address to, uint256 amount, address token)
518     public onlyAllowed returns(bool) {
519         require(Token(token).balanceOf(this) >= amount, "Not enough token balance");
520         require(Token(token).transfer(to, amount));
521         return true;
522     }
523 
524 }
525 contract EscrowConfig is Ownable {
526 
527     using EscrowConfigLib for address;
528 
529     address public config;
530 
531     constructor(address storageAddress) public {
532         config = storageAddress;
533     }
534 
535     function resetValuesToDefault() external onlyOwner {
536         config.setPaymentFee(2);//%
537     }
538 
539     function setStorageAddress(address storageAddress) external onlyOwner {
540         config = storageAddress;
541     }
542 
543     function getPaymentFee() external view returns (uint8) {
544         return config.getPaymentFee();
545     }
546 
547     //value - % of payment amount
548     function setPaymentFee(uint8 value) external onlyOwner {
549         require(value >= 0 && value < 100, "Fee in % of payment amount must be >= 0 and < 100");
550         config.setPaymentFee(value);
551     }
552 }
553 library EscrowConfigLib {
554 
555     function getPaymentFee(address storageAddress) public view returns (uint8) {
556         return EternalStorage(storageAddress).getUint8(keccak256(abi.encodePacked("escrow.config.payment.fee")));
557     }
558 
559     function setPaymentFee(address storageAddress, uint8 value) public {
560         EternalStorage(storageAddress).setUint8(keccak256(abi.encodePacked("escrow.config.payment.fee")), value);
561     }
562 
563 }
564 contract ICourt is Ownable {
565 
566     function getCaseId(address applicant, address respondent, bytes32 deal, uint256 date, bytes32 title, uint256 amount) 
567         public pure returns(bytes32);
568 
569     function getCaseStatus(bytes32 caseId) public view returns(uint8);
570 
571     function getCaseVerdict(bytes32 caseId) public view returns(bool);
572 }
573 
574 contract Escrow is IEscrow {
575     using PaymentLib for address;
576     using EscrowConfigLib for address;
577 
578     constructor(address storageAddress, address _paymentHolder, address _courtAddress) public {
579         lib = storageAddress;
580         courtAddress = _courtAddress;
581         paymentHolder = _paymentHolder;
582     }
583 
584     /*----------------------CONFIGURATION METHODS----------------------*/
585 
586     function setStorageAddress(address _storageAddress) external onlyOwner {
587         lib = _storageAddress;
588     }
589 
590     function setPaymentHolder(address _paymentHolder) external onlyOwner {
591         paymentHolder = _paymentHolder;
592     }
593 
594     function setCourtAddress(address _courtAddress) external onlyOwner {
595         courtAddress = _courtAddress;
596     }
597 
598     /*----------------------PUBLIC USER METHODS----------------------*/
599 
600     /** @dev Depositor creates escrow payment. Set token as 0x0 in case of ETH amount.
601       * @param addresses [depositor, beneficiary, token]
602       */
603     function createPayment(address[3] addresses, bytes32 deal, uint256 amount)
604     external {
605         onlyParties(addresses);
606         require(addresses[0] != address(0));
607         require(addresses[1] != address(0));
608         require(addresses[0] != addresses[1], "Depositor and beneficiary can not be the same");
609         require(deal != 0x0, "deal can not be 0x0");
610         require(amount != 0, "amount can not be 0");
611         bytes32 paymentId = getPaymentId(addresses, deal, amount);
612         checkStatus(paymentId, PaymentStatus.NONE);
613         uint8 fee = lib.getPaymentFee();
614         lib.createPayment(paymentId, fee, uint8(PaymentStatus.CREATED));
615         emit PaymentCreated(paymentId, addresses[0], addresses[1], addresses[2], deal, amount, fee);
616     }
617 
618     /** @dev Beneficiary signs escrow payment as consent for taking part.
619       * @param addresses [depositor, beneficiary, token]
620       */
621     function sign(address[3] addresses, bytes32 deal, uint256 amount)
622     external {
623         onlyBeneficiary(addresses);
624         bytes32 paymentId = getPaymentId(addresses, deal, amount);
625         checkStatus(paymentId, PaymentStatus.CREATED);
626         lib.setSigned(paymentId, true);
627         bool confirmed = lib.isDeposited(paymentId);
628         if (confirmed) {
629             setPaymentStatus(paymentId, PaymentStatus.CONFIRMED);
630         }
631         emit PaymentSigned(paymentId, confirmed);
632     }
633 
634     /** @dev Depositor deposits payment amount only after it was signed by beneficiary
635       * @param addresses [depositor, beneficiary, token]
636       * @param payFee If true, depositor have to send (amount + (amount * fee) / 100).
637       */
638     function deposit(address[3] addresses, bytes32 deal, uint256 amount, bool payFee)
639     external payable {
640         onlyDepositor(addresses);
641         bytes32 paymentId = getPaymentId(addresses, deal, amount);
642         PaymentStatus status = getPaymentStatus(paymentId);
643         require(status == PaymentStatus.CREATED || status == PaymentStatus.SIGNED);
644         uint256 depositAmount = amount;
645         if (payFee) {
646             depositAmount = amount + calcFee(amount, lib.getPaymentFee(paymentId));
647             lib.setFeePayed(paymentId, true);
648         }
649         address token = getToken(addresses);
650         if (token == address(0)) {
651             require(msg.value == depositAmount, "ETH amount must be equal amount");
652             require(PaymentHolder(paymentHolder).depositEth.value(msg.value)());
653         } else {
654             require(msg.value == 0, "ETH amount must be 0 for token transfer");
655             require(Token(token).allowance(msg.sender, address(this)) >= depositAmount);
656             require(Token(token).balanceOf(msg.sender) >= depositAmount);
657             require(Token(token).transferFrom(msg.sender, paymentHolder, depositAmount));
658         }
659         lib.setDeposited(paymentId, true);
660         bool confirmed = lib.isSigned(paymentId);
661         if (confirmed) {
662             setPaymentStatus(paymentId, PaymentStatus.CONFIRMED);
663         }
664         emit PaymentDeposited(paymentId, depositAmount, payFee, confirmed);
665     }
666 
667     /** @dev Depositor or Beneficiary requests payment cancellation after payment was signed by beneficiary.
668       *      Payment is closed, if depositor and beneficiary both request cancellation.
669       * @param addresses [depositor, beneficiary, token]
670       */
671     function cancel(address[3] addresses, bytes32 deal, uint256 amount)
672     external {
673         onlyParties(addresses);
674         bytes32 paymentId = getPaymentId(addresses, deal, amount);
675         checkStatus(paymentId, PaymentStatus.CREATED);
676         setPaymentStatus(paymentId, PaymentStatus.CANCELED);
677         if (lib.isDeposited(paymentId)) {
678             uint256 amountToRefund = amount;
679             if (lib.isFeePayed(paymentId)) {
680                 amountToRefund = amount + calcFee(amount, lib.getPaymentFee(paymentId));
681             }
682             transfer(getDepositor(addresses), amountToRefund, getToken(addresses));
683         }
684         setPaymentStatus(paymentId, PaymentStatus.CANCELED);
685         emit PaymentCanceled(paymentId);
686         emit PaymentCanceled(paymentId);
687     }
688 
689     /** @dev Depositor close payment though transfer payment amount to another party.
690       * @param addresses [depositor, beneficiary, token]
691       */
692     function release(address[3] addresses, bytes32 deal, uint256 amount)
693     external {
694         onlyDepositor(addresses);
695         bytes32 paymentId = getPaymentId(addresses, deal, amount);
696         checkStatus(paymentId, PaymentStatus.CONFIRMED);
697         doRelease(addresses, [amount, 0], paymentId);
698         emit PaymentReleased(paymentId);
699     }
700 
701     /** @dev Depositor or beneficiary offers partial closing payment with offerAmount.
702       * @param addresses [depositor, beneficiary, token]
703       * @param offerAmount Amount of partial closing offer in currency of payment (ETH or token).
704       */
705     function offer(address[3] addresses, bytes32 deal, uint256 amount, uint256 offerAmount)
706     external {
707         onlyParties(addresses);
708         require(offerAmount >= 0 && offerAmount <= amount, "Offer amount must be >= 0 and <= payment amount");
709         bytes32 paymentId = getPaymentId(addresses, deal, amount);
710         uint256 anotherOfferAmount = lib.getOfferAmount(paymentId, getAnotherParty(addresses));
711         require(anotherOfferAmount == 0, "Sender can not make offer if another party has done the same before");
712         lib.setOfferAmount(paymentId, msg.sender, offerAmount);
713         emit PaymentOffer(paymentId, offerAmount);
714     }
715 
716     /** @dev Depositor or beneficiary cancels opposite party offer.
717       * @param addresses [depositor, beneficiary, token]
718       */
719     function cancelOffer(address[3] addresses, bytes32 deal, uint256 amount)
720     external {
721         bytes32 paymentId = doCancelOffer(addresses, deal, amount, getAnotherParty(addresses));
722         emit PaymentOfferCanceled(paymentId);
723     }
724 
725     /** @dev Depositor or beneficiary cancels own offer.
726     * @param addresses [depositor, beneficiary, token]
727     */
728     function cancelOwnOffer(address[3] addresses, bytes32 deal, uint256 amount)
729     external {
730         bytes32 paymentId = doCancelOffer(addresses, deal, amount, msg.sender);
731         emit PaymentOwnOfferCanceled(paymentId);
732     }
733 
734     /** @dev Depositor or beneficiary accepts opposite party offer.
735       * @param addresses [depositor, beneficiary, token]
736       */
737     function acceptOffer(address[3] addresses, bytes32 deal, uint256 amount)
738     external {
739         onlyParties(addresses);
740         bytes32 paymentId = getPaymentId(addresses, deal, amount);
741         checkStatus(paymentId, PaymentStatus.CONFIRMED);
742         uint256 offerAmount = lib.getOfferAmount(paymentId, getAnotherParty(addresses));
743         require(offerAmount != 0, "Sender can not accept another party offer of 0");
744         uint256 toBeneficiary = offerAmount;
745         uint256 toDepositor = amount - offerAmount;
746         //if sender is beneficiary
747         if (msg.sender == addresses[1]) {
748             toBeneficiary = amount - offerAmount;
749             toDepositor = offerAmount;
750         }
751         doRelease(addresses, [toBeneficiary, toDepositor], paymentId);
752         emit PaymentOfferAccepted(paymentId, toBeneficiary, toDepositor);
753     }
754 
755     /** @dev Depositor or beneficiary withdraw amounts.
756       * @param addresses [depositor, beneficiary, token]
757       */
758     function withdraw(address[3] addresses, bytes32 deal, uint256 amount)
759     external {
760         onlyParties(addresses);
761         bytes32 paymentId = getPaymentId(addresses, deal, amount);
762         checkStatus(paymentId, PaymentStatus.RELEASED);
763         require(!lib.isWithdrawn(paymentId, msg.sender), "User can not withdraw twice.");
764         uint256 withdrawAmount = lib.getWithdrawAmount(paymentId, msg.sender);
765         withdrawAmount = transferWithFee(msg.sender, withdrawAmount, addresses[2], paymentId);
766         emit PaymentWithdrawn(paymentId, withdrawAmount);
767         lib.setWithdrawn(paymentId, msg.sender, true);
768         address anotherParty = getAnotherParty(addresses);
769         if (lib.getWithdrawAmount(paymentId, anotherParty) == 0 || lib.isWithdrawn(paymentId, anotherParty)) {
770             setPaymentStatus(paymentId, PaymentStatus.CLOSED);
771             emit PaymentClosed(paymentId);
772         }
773     }
774 
775     /** @dev Depositor or Beneficiary withdraw amounts according dispute verdict.
776       * @dev Have to use fucking arrays due to "stack too deep" issue.
777       * @param addresses [depositor, beneficiary, token]
778       * @param disputeParties [applicant, respondent]
779       * @param uints [paymentAmount, disputeAmount, disputeCreatedAt]
780       * @param byts [deal, disputeTitle]
781       */
782     function withdrawByDispute(address[3] addresses, address[2] disputeParties, uint256[3] uints, bytes32[2] byts)
783     external {
784         onlyParties(addresses);
785         require(
786             addresses[0] == disputeParties[0] && addresses[1] == disputeParties[1] || addresses[0] == disputeParties[1] && addresses[1] == disputeParties[0],
787             "Depositor and beneficiary must be dispute parties"
788         );
789         bytes32 paymentId = getPaymentId(addresses, byts[0], uints[0]);
790         PaymentStatus paymentStatus = getPaymentStatus(paymentId);
791         require(paymentStatus == PaymentStatus.CONFIRMED || paymentStatus == PaymentStatus.RELEASED_BY_DISPUTE);
792         require(!lib.isWithdrawn(paymentId, msg.sender), "User can not withdraw twice.");
793         bytes32 dispute = ICourt(courtAddress).getCaseId(
794             disputeParties[0] /*applicant*/, disputeParties[1]/*respondent*/,
795             paymentId/*deal*/, uints[2]/*disputeCreatedAt*/,
796             byts[1]/*disputeTitle*/, uints[1]/*disputeAmount*/
797         );
798         require(ICourt(courtAddress).getCaseStatus(dispute) == 3, "Case must be closed");
799         /*[releaseAmount, refundAmount]*/
800         uint256[2] memory withdrawAmounts = [uint256(0), 0];
801         bool won = ICourt(courtAddress).getCaseVerdict(dispute);
802         //depositor == applicant
803         if (won) {
804             //use paymentAmount if disputeAmount is greater
805             withdrawAmounts[0] = uints[1] > uints[0] ? uints[0] : uints[1];
806             withdrawAmounts[1] = uints[0] - withdrawAmounts[0];
807         } else {
808             //make full release
809             withdrawAmounts[1] = uints[0];
810         }
811         if (msg.sender != disputeParties[0]) {
812             withdrawAmounts[0] = withdrawAmounts[0] + withdrawAmounts[1];
813             withdrawAmounts[1] = withdrawAmounts[0] - withdrawAmounts[1];
814             withdrawAmounts[0] = withdrawAmounts[0] - withdrawAmounts[1];
815         }
816         address anotherParty = getAnotherParty(addresses);
817         //if sender is depositor
818         withdrawAmounts[0] = transferWithFee(msg.sender, withdrawAmounts[0], addresses[2], paymentId);
819         emit PaymentWithdrawnByDispute(paymentId, withdrawAmounts[0], dispute);
820         lib.setWithdrawn(paymentId, msg.sender, true);
821         if (withdrawAmounts[1] == 0 || lib.isWithdrawn(paymentId, anotherParty)) {
822             setPaymentStatus(paymentId, PaymentStatus.CLOSED);
823             emit PaymentClosedByDispute(paymentId, dispute);
824         } else {
825             //need to prevent withdraw by another flow, e.g. simple release or offer accepting
826             setPaymentStatus(paymentId, PaymentStatus.RELEASED_BY_DISPUTE);
827         }
828     }
829     
830     /*------------------PRIVATE METHODS----------------------*/
831     function getPaymentId(address[3] addresses, bytes32 deal, uint256 amount)
832     public pure returns (bytes32) {return PaymentLib.getPaymentId(addresses, deal, amount);}
833 
834     function getDepositor(address[3] addresses) private pure returns (address) {return addresses[0];}
835 
836     function getBeneficiary(address[3] addresses) private pure returns (address) {return addresses[1];}
837 
838     function getToken(address[3] addresses) private pure returns (address) {return addresses[2];}
839 
840     function getAnotherParty(address[3] addresses) private view returns (address) {
841         return msg.sender == addresses[0] ? addresses[1] : addresses[0];
842     }
843 
844     function onlyParties(address[3] addresses) private view {require(msg.sender == addresses[0] || msg.sender == addresses[1]);}
845 
846     function onlyDepositor(address[3] addresses) private view {require(msg.sender == addresses[0]);}
847 
848     function onlyBeneficiary(address[3] addresses) private view {require(msg.sender == addresses[1]);}
849 
850     function getPaymentStatus(bytes32 paymentId)
851     private view returns (PaymentStatus) {
852         return PaymentStatus(lib.getPaymentStatus(paymentId));
853     }
854 
855     function setPaymentStatus(bytes32 paymentId, PaymentStatus status)
856     private {
857         lib.setPaymentStatus(paymentId, uint8(status));
858     }
859 
860     function checkStatus(bytes32 paymentId, PaymentStatus status)
861     private view {
862         require(lib.getPaymentStatus(paymentId) == uint8(status), "Required status does not match actual one");
863     }
864 
865     function doCancelOffer(address[3] addresses, bytes32 deal, uint256 amount, address from)
866     private returns(bytes32 paymentId) {
867         onlyParties(addresses);
868         paymentId = getPaymentId(addresses, deal, amount);
869         checkStatus(paymentId, PaymentStatus.CONFIRMED);
870         uint256 offerAmount = lib.getOfferAmount(paymentId, from);
871         require(offerAmount != 0, "Sender can not cancel offer of 0");
872         lib.setOfferAmount(paymentId, from, 0);
873     }
874 
875     /** @param addresses [depositor, beneficiary, token]
876       * @param amounts [releaseAmount, refundAmount]
877       */
878     function doRelease(address[3] addresses, uint256[2] amounts, bytes32 paymentId)
879     private {
880         setPaymentStatus(paymentId, PaymentStatus.RELEASED);
881         lib.setWithdrawAmount(paymentId, getBeneficiary(addresses), amounts[0]);
882         lib.setWithdrawAmount(paymentId, getDepositor(addresses), amounts[1]);
883     }
884 
885     function transferWithFee(address to, uint256 amount, address token, bytes32 paymentId)
886     private returns (uint256 amountMinusFee) {
887         require(amount != 0, "There is sense to invoke this method if withdraw amount is 0.");
888         uint8 fee = 0;
889         if (!lib.isFeePayed(paymentId)) {
890             fee = lib.getPaymentFee(paymentId);
891         }
892         amountMinusFee = amount - calcFee(amount, fee);
893         transfer(to, amountMinusFee, token);
894     }   
895 
896     function transfer(address to, uint256 amount, address token)
897     private {
898         if (amount == 0) {
899             return;
900         }
901         if (token == address(0)) {
902             require(PaymentHolder(paymentHolder).withdrawEth(to, amount));
903         } else {
904             require(PaymentHolder(paymentHolder).withdrawToken(to, amount, token));
905         }
906     }
907 
908     function calcFee(uint amount, uint fee)
909     private pure returns (uint256) {
910         return ((amount * fee) / 100);
911     }
912 }