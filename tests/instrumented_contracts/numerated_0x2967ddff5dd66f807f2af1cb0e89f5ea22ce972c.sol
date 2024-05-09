1 pragma solidity ^0.4.22;
2 
3 
4 contract Token  {
5     event Transfer(address indexed _from, address indexed _to, uint256 _value);
6     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
7 
8     uint256 public totalSupply;
9 
10     function balanceOf(address _owner) public view returns (uint256 balance);
11     function transfer(address _to, uint256 _value) public returns (bool success);
12     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
13     function approve(address _spender, uint256 _value) public returns (bool success);
14     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
15     function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
16     function decreaseApproval (address _spender, uint _subtractedValue)public returns (bool success);
17 }
18 
19 contract EternalStorage {
20 
21     /**** Storage Types *******/
22 
23     address public owner;
24 
25     mapping(bytes32 => uint256)    private uIntStorage;
26     mapping(bytes32 => uint8)      private uInt8Storage;
27     mapping(bytes32 => string)     private stringStorage;
28     mapping(bytes32 => address)    private addressStorage;
29     mapping(bytes32 => bytes)      private bytesStorage;
30     mapping(bytes32 => bool)       private boolStorage;
31     mapping(bytes32 => int256)     private intStorage;
32     mapping(bytes32 => bytes32)    private bytes32Storage;
33 
34 
35     /*** Modifiers ************/
36 
37     /// @dev Only allow access from the latest version of a contract after deployment
38     modifier onlyLatestContract() {
39         require(addressStorage[keccak256(abi.encodePacked("contract.address", msg.sender))] != 0x0 || msg.sender == owner);
40         _;
41     }
42 
43     /// @dev constructor
44     constructor() public {
45         owner = msg.sender;
46         addressStorage[keccak256(abi.encodePacked("contract.address", msg.sender))] = msg.sender;
47     }
48 
49     function setOwner() public {
50         require(msg.sender == owner);
51         addressStorage[keccak256(abi.encodePacked("contract.address", owner))] = 0x0;
52         owner = msg.sender;
53         addressStorage[keccak256(abi.encodePacked("contract.address", msg.sender))] = msg.sender;
54     }
55 
56     /**** Get Methods ***********/
57 
58     /// @param _key The key for the record
59     function getAddress(bytes32 _key) external view returns (address) {
60         return addressStorage[_key];
61     }
62 
63     /// @param _key The key for the record
64     function getUint(bytes32 _key) external view returns (uint) {
65         return uIntStorage[_key];
66     }
67 
68     /// @param _key The key for the record
69     function getUint8(bytes32 _key) external view returns (uint8) {
70         return uInt8Storage[_key];
71     }
72 
73 
74     /// @param _key The key for the record
75     function getString(bytes32 _key) external view returns (string) {
76         return stringStorage[_key];
77     }
78 
79     /// @param _key The key for the record
80     function getBytes(bytes32 _key) external view returns (bytes) {
81         return bytesStorage[_key];
82     }
83 
84     /// @param _key The key for the record
85     function getBytes32(bytes32 _key) external view returns (bytes32) {
86         return bytes32Storage[_key];
87     }
88 
89     /// @param _key The key for the record
90     function getBool(bytes32 _key) external view returns (bool) {
91         return boolStorage[_key];
92     }
93 
94     /// @param _key The key for the record
95     function getInt(bytes32 _key) external view returns (int) {
96         return intStorage[_key];
97     }
98 
99     /**** Set Methods ***********/
100 
101     /// @param _key The key for the record
102     function setAddress(bytes32 _key, address _value) onlyLatestContract external {
103         addressStorage[_key] = _value;
104     }
105 
106     /// @param _key The key for the record
107     function setUint(bytes32 _key, uint _value) onlyLatestContract external {
108         uIntStorage[_key] = _value;
109     }
110 
111     /// @param _key The key for the record
112     function setUint8(bytes32 _key, uint8 _value) onlyLatestContract external {
113         uInt8Storage[_key] = _value;
114     }
115 
116     /// @param _key The key for the record
117     function setString(bytes32 _key, string _value) onlyLatestContract external {
118         stringStorage[_key] = _value;
119     }
120 
121     /// @param _key The key for the record
122     function setBytes(bytes32 _key, bytes _value) onlyLatestContract external {
123         bytesStorage[_key] = _value;
124     }
125 
126     /// @param _key The key for the record
127     function setBytes32(bytes32 _key, bytes32 _value) onlyLatestContract external {
128         bytes32Storage[_key] = _value;
129     }
130 
131     /// @param _key The key for the record
132     function setBool(bytes32 _key, bool _value) onlyLatestContract external {
133         boolStorage[_key] = _value;
134     }
135 
136     /// @param _key The key for the record
137     function setInt(bytes32 _key, int _value) onlyLatestContract external {
138         intStorage[_key] = _value;
139     }
140 
141     /**** Delete Methods ***********/
142 
143     /// @param _key The key for the record
144     function deleteAddress(bytes32 _key) onlyLatestContract external {
145         delete addressStorage[_key];
146     }
147 
148     /// @param _key The key for the record
149     function deleteUint(bytes32 _key) onlyLatestContract external {
150         delete uIntStorage[_key];
151     }
152 
153     /// @param _key The key for the record
154     function deleteUint8(bytes32 _key) onlyLatestContract external {
155         delete uInt8Storage[_key];
156     }
157 
158     /// @param _key The key for the record
159     function deleteString(bytes32 _key) onlyLatestContract external {
160         delete stringStorage[_key];
161     }
162 
163     /// @param _key The key for the record
164     function deleteBytes(bytes32 _key) onlyLatestContract external {
165         delete bytesStorage[_key];
166     }
167 
168     /// @param _key The key for the record
169     function deleteBytes32(bytes32 _key) onlyLatestContract external {
170         delete bytes32Storage[_key];
171     }
172 
173     /// @param _key The key for the record
174     function deleteBool(bytes32 _key) onlyLatestContract external {
175         delete boolStorage[_key];
176     }
177 
178     /// @param _key The key for the record
179     function deleteInt(bytes32 _key) onlyLatestContract external {
180         delete intStorage[_key];
181     }
182 }
183 
184 contract Ownable {
185     address public owner;
186 
187 
188     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190 
191     /**
192      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
193      * account.
194      */
195     constructor() public {
196         owner = msg.sender;
197     }
198 
199     /**
200      * @dev Throws if called by any account other than the owner.
201      */
202     modifier onlyOwner() {
203         require(msg.sender == owner);
204         _;
205     }
206 
207     /**
208      * @dev Allows the current owner to transfer control of the contract to a newOwner.
209      * @param newOwner The address to transfer ownership to.
210      */
211     function transferOwnership(address newOwner) public onlyOwner {
212         require(newOwner != address(0));
213         emit OwnershipTransferred(owner, newOwner);
214         owner = newOwner;
215     }
216 
217 }
218 
219 contract Withdrawable is Ownable {
220     function withdrawEth(uint value) external onlyOwner {
221         require(address(this).balance >= value);
222         msg.sender.transfer(value);
223     }
224 
225     function withdrawToken(address token, uint value) external onlyOwner {
226         require(Token(token).balanceOf(address(this)) >= value, "Not enough tokens");
227         require(Token(token).transfer(msg.sender, value));
228     }
229 }
230 
231 contract EscrowConfig is Ownable {
232 
233     using EscrowConfigLib for address;
234 
235     address public config;
236 
237     constructor(address storageAddress) public {
238         config = storageAddress;
239     }
240 
241     function resetValuesToDefault() external onlyOwner {
242         config.setPaymentFee(2);//%
243     }
244 
245     function setStorageAddress(address storageAddress) external onlyOwner {
246         config = storageAddress;
247     }
248 
249     function getPaymentFee() external view returns (uint8) {
250         return config.getPaymentFee();
251     }
252 
253     //value - % of payment amount
254     function setPaymentFee(uint8 value) external onlyOwner {
255         require(value >= 0 && value < 100, "Fee in % of payment amount must be >= 0 and < 100");
256         config.setPaymentFee(value);
257     }
258 }
259 
260 contract PaymentHolder is Ownable {
261 
262     modifier onlyAllowed() {
263         require(allowed[msg.sender]);
264         _;
265     }
266 
267     modifier onlyUpdater() {
268         require(msg.sender == updater);
269         _;
270     }
271 
272     mapping(address => bool) public allowed;
273     address public updater;
274 
275     /*-----------------MAINTAIN METHODS------------------*/
276 
277     function setUpdater(address _updater)
278     external onlyOwner {
279         updater = _updater;
280     }
281 
282     function migrate(address newHolder, address[] tokens, address[] _allowed)
283     external onlyOwner {
284         require(PaymentHolder(newHolder).update.value(address(this).balance)(_allowed));
285         for (uint256 i = 0; i < tokens.length; i++) {
286             address token = tokens[i];
287             uint256 balance = Token(token).balanceOf(this);
288             if (balance > 0) {
289                 require(Token(token).transfer(newHolder, balance));
290             }
291         }
292     }
293 
294     function update(address[] _allowed)
295     external payable onlyUpdater returns(bool) {
296         for (uint256 i = 0; i < _allowed.length; i++) {
297             allowed[_allowed[i]] = true;
298         }
299         return true;
300     }
301 
302     /*-----------------OWNER FLOW------------------*/
303 
304     function allow(address to) 
305     external onlyOwner { allowed[to] = true; }
306 
307     function prohibit(address to)
308     external onlyOwner { allowed[to] = false; }
309 
310     /*-----------------ALLOWED FLOW------------------*/
311 
312     function depositEth()
313     public payable onlyAllowed returns (bool) {
314         //Default function to receive eth
315         return true;
316     }
317 
318     function withdrawEth(address to, uint256 amount)
319     public onlyAllowed returns(bool) {
320         require(address(this).balance >= amount, "Not enough ETH balance");
321         to.transfer(amount);
322         return true;
323     }
324 
325     function withdrawToken(address to, uint256 amount, address token)
326     public onlyAllowed returns(bool) {
327         require(Token(token).balanceOf(this) >= amount, "Not enough token balance");
328         require(Token(token).transfer(to, amount));
329         return true;
330     }
331 
332 }
333 
334 contract ICourt is Ownable {
335 
336     function getCaseId(address applicant, address respondent, bytes32 deal, uint256 date, bytes32 title, uint256 amount) 
337         public pure returns(bytes32);
338 
339     function getCaseStatus(bytes32 caseId) public view returns(uint8);
340 
341     function getCaseVerdict(bytes32 caseId) public view returns(bool);
342 }
343 
344 library EscrowConfigLib {
345 
346     function getPaymentFee(address storageAddress) public view returns (uint8) {
347         return EternalStorage(storageAddress).getUint8(keccak256(abi.encodePacked("escrow.config.payment.fee")));
348     }
349 
350     function setPaymentFee(address storageAddress, uint8 value) public {
351         EternalStorage(storageAddress).setUint8(keccak256(abi.encodePacked("escrow.config.payment.fee")), value);
352     }
353 }
354 
355 contract IEscrow is Withdrawable {
356 
357     /*----------------------PAYMENT STATUSES----------------------*/
358 
359     //SIGNED status kept for backward compatibility
360     enum PaymentStatus {NONE/*code=0*/, CREATED/*code=1*/, SIGNED/*code=2*/, CONFIRMED/*code=3*/, RELEASED/*code=4*/, RELEASED_BY_DISPUTE /*code=5*/, CLOSED/*code=6*/, CANCELED/*code=7*/}
361     
362     /*----------------------EVENTS----------------------*/
363 
364     event PaymentCreated(bytes32 paymentId, address depositor, address beneficiary, address token, bytes32 deal, uint256 amount, uint8 fee, bool feePayed);
365     event PaymentSigned(bytes32 paymentId, bool confirmed);
366     event PaymentDeposited(bytes32 paymentId, uint256 depositedAmount, bool confirmed);
367     event PaymentReleased(bytes32 paymentId);
368     event PaymentOffer(bytes32 paymentId, uint256 offerAmount);
369     event PaymentOfferCanceled(bytes32 paymentId);
370     event PaymentOwnOfferCanceled(bytes32 paymentId);
371     event PaymentOfferAccepted(bytes32 paymentId, uint256 releaseToBeneficiary, uint256 refundToDepositor);
372     event PaymentWithdrawn(bytes32 paymentId, uint256 amount);
373     event PaymentWithdrawnByDispute(bytes32 paymentId, uint256 amount, bytes32 dispute);
374     event PaymentCanceled(bytes32 paymentId);
375     event PaymentClosed(bytes32 paymentId);
376     event PaymentClosedByDispute(bytes32 paymentId, bytes32 dispute);
377 
378     /*----------------------PUBLIC STATE----------------------*/
379 
380     address public lib;
381     address public courtAddress;
382     address public paymentHolder;
383 
384 
385     /*----------------------CONFIGURATION METHODS (only owner) ----------------------*/
386     function setStorageAddress(address _storageAddress) external;
387 
388     function setCourtAddress(address _courtAddress) external;
389 
390     /*----------------------PUBLIC USER METHODS----------------------*/
391     /** @dev Depositor creates escrow payment. Set token as 0x0 in case of ETH amount.
392       * @param addresses [depositor, beneficiary, token]
393       * @param depositorPayFee If true, depositor have to send (amount + (amount * fee) / 100).
394       */
395     function createPayment(address[3] addresses, bytes32 deal, uint256 amount, bool depositorPayFee) external;
396 
397     /** @dev Beneficiary signs escrow payment as consent for taking part.
398       * @param addresses [depositor, beneficiary, token]
399       */
400     function sign(address[3] addresses, bytes32 deal, uint256 amount) external;
401 
402     /** @dev Depositor deposits payment amount only after it was signed by beneficiary.
403       * @param addresses [depositor, beneficiary, token]
404       */
405     function deposit(address[3] addresses, bytes32 deal, uint256 amount) external payable;
406 
407     /** @dev Depositor or Beneficiary requests payment cancellation after payment was signed by beneficiary.
408       *      Payment is closed, if depositor and beneficiary both request cancellation.
409       * @param addresses [depositor, beneficiary, token]
410       */
411     function cancel(address[3] addresses, bytes32 deal, uint256 amount) external;
412 
413     /** @dev Depositor close payment though transfer payment amount to another party.
414       * @param addresses [depositor, beneficiary, token]
415       */
416     function release(address[3] addresses, bytes32 deal, uint256 amount) external;
417 
418     /** @dev Depositor or beneficiary offers partial closing payment with offerAmount.
419       * @param addresses [depositor, beneficiary, token]
420       * @param offerAmount Amount of partial closing offer in currency of payment (ETH or token).
421       */
422     function offer(address[3] addresses, bytes32 deal, uint256 amount, uint256 offerAmount) external;
423 
424     /** @dev Depositor or beneficiary canceles another party offer.
425       * @param addresses [depositor, beneficiary, token]
426       */
427     function cancelOffer(address[3] addresses, bytes32 deal, uint256 amount) external;
428 
429     /** @dev Depositor or beneficiary cancels own offer.
430       * @param addresses [depositor, beneficiary, token]
431       */
432     function cancelOwnOffer(address[3] addresses, bytes32 deal, uint256 amount) external;
433 
434     /** @dev Depositor or beneficiary accepts opposite party offer.
435       * @param addresses [depositor, beneficiary, token]
436       */
437     function acceptOffer(address[3] addresses, bytes32 deal, uint256 amount) external;
438 
439    
440     /** @dev Depositor or beneficiary withdraw amounts.
441       * @param addresses [depositor, beneficiary, token]
442       */
443     function withdraw(address[3] addresses, bytes32 deal, uint256 amount) external;
444 
445     /** @dev Depositor or Beneficiary withdraw amounts according dispute verdict.
446       * @dev Have to use fucking arrays due to "stack too deep" issue.
447       * @param addresses [depositor, beneficiary, token]
448       * @param disputeParties [applicant, respondent]
449       * @param uints [paymentAmount, disputeAmount, disputeCreatedAt]
450       * @param byts [deal, disputeTitle]
451       */
452     function withdrawByDispute(address[3] addresses, address[2] disputeParties, uint256[3] uints, bytes32[2] byts) external;
453 }
454 
455 library FeeLib {
456 
457     function getTotalFee(address storageAddress, address token)
458     public view returns(uint256) {
459         return EternalStorage(storageAddress).getUint(keccak256(abi.encodePacked("payment.fee.total", token)));
460     }
461 
462     function setTotalFee(address storageAddress, uint256 value, address token)
463     public {
464         EternalStorage(storageAddress).setUint(keccak256(abi.encodePacked("payment.fee.total", token)), value);
465     }
466 
467     function addFee(address storageAddress, uint256 value, address token)
468     public {
469         uint256 newTotalFee = getTotalFee(storageAddress, token) + value;
470         setTotalFee(storageAddress, newTotalFee, token);
471     }
472 
473     
474 }
475 
476 library PaymentLib {
477 
478     function getPaymentId(address[3] addresses, bytes32 deal, uint256 amount) public pure returns (bytes32) {
479         return keccak256(abi.encodePacked(addresses[0], addresses[1], addresses[2], deal, amount));
480     }
481 
482     function createPayment(
483         address storageAddress, bytes32 paymentId, uint8 fee, uint8 status, bool feePayed
484     ) public {
485         setPaymentStatus(storageAddress, paymentId, status);
486         setPaymentFee(storageAddress, paymentId, fee);
487         if (feePayed) {
488             setFeePayed(storageAddress, paymentId, true);
489         }
490     }
491 
492     function isCancelRequested(address storageAddress, bytes32 paymentId, address party)
493     public view returns(bool) {
494         return EternalStorage(storageAddress).getBool(keccak256(abi.encodePacked("payment.cance", paymentId, party)));
495     }
496 
497     function setCancelRequested(address storageAddress, bytes32 paymentId, address party, bool value)
498     public {
499         EternalStorage(storageAddress).setBool(keccak256(abi.encodePacked("payment.cance", paymentId, party)), value);
500     }
501 
502     function getPaymentFee(address storageAddress, bytes32 paymentId)
503     public view returns (uint8) {
504         return EternalStorage(storageAddress).getUint8(keccak256(abi.encodePacked("payment.fee", paymentId)));
505     }
506 
507     function setPaymentFee(address storageAddress, bytes32 paymentId, uint8 value)
508     public {
509         EternalStorage(storageAddress).setUint8(keccak256(abi.encodePacked("payment.fee", paymentId)), value);
510     }
511 
512     function isFeePayed(address storageAddress, bytes32 paymentId)
513     public view returns (bool) {
514         return EternalStorage(storageAddress).getBool(keccak256(abi.encodePacked("payment.fee.payed", paymentId)));
515     }
516 
517     function setFeePayed(address storageAddress, bytes32 paymentId, bool value)
518     public {
519         EternalStorage(storageAddress).setBool(keccak256(abi.encodePacked("payment.fee.payed", paymentId)), value);
520     }
521 
522     function isDeposited(address storageAddress, bytes32 paymentId)
523     public view returns (bool) {
524         return EternalStorage(storageAddress).getBool(keccak256(abi.encodePacked("payment.deposited", paymentId)));
525     }
526 
527     function setDeposited(address storageAddress, bytes32 paymentId, bool value)
528     public {
529         EternalStorage(storageAddress).setBool(keccak256(abi.encodePacked("payment.deposited", paymentId)), value);
530     }
531 
532     function isSigned(address storageAddress, bytes32 paymentId)
533     public view returns (bool) {
534         return EternalStorage(storageAddress).getBool(keccak256(abi.encodePacked("payment.signed", paymentId)));
535     }
536 
537     function setSigned(address storageAddress, bytes32 paymentId, bool value)
538     public {
539         EternalStorage(storageAddress).setBool(keccak256(abi.encodePacked("payment.signed", paymentId)), value);
540     }
541 
542     function getPaymentStatus(address storageAddress, bytes32 paymentId)
543     public view returns (uint8) {
544         return EternalStorage(storageAddress).getUint8(keccak256(abi.encodePacked("payment.status", paymentId)));
545     }
546 
547     function setPaymentStatus(address storageAddress, bytes32 paymentId, uint8 status)
548     public {
549         EternalStorage(storageAddress).setUint8(keccak256(abi.encodePacked("payment.status", paymentId)), status);
550     }
551 
552     function getOfferAmount(address storageAddress, bytes32 paymentId, address user)
553     public view returns (uint256) {
554         return EternalStorage(storageAddress).getUint(keccak256(abi.encodePacked("payment.amount.refund", paymentId, user)));
555     }
556 
557     function setOfferAmount(address storageAddress, bytes32 paymentId, address user, uint256 amount)
558     public {
559         EternalStorage(storageAddress).setUint(keccak256(abi.encodePacked("payment.amount.refund", paymentId, user)), amount);
560     }
561 
562     function getWithdrawAmount(address storageAddress, bytes32 paymentId, address user)
563     public view returns (uint256) {
564         return EternalStorage(storageAddress).getUint(keccak256(abi.encodePacked("payment.amount.withdraw", paymentId, user)));
565     }
566 
567     function setWithdrawAmount(address storageAddress, bytes32 paymentId, address user, uint256 amount)
568     public {
569         EternalStorage(storageAddress).setUint(keccak256(abi.encodePacked("payment.amount.withdraw", paymentId, user)), amount);
570     }
571 
572     function isWithdrawn(address storageAddress, bytes32 paymentId, address user)
573     public view returns (bool) {
574         return EternalStorage(storageAddress).getBool(keccak256(abi.encodePacked("payment.withdrawed", paymentId, user)));
575     }
576 
577     function setWithdrawn(address storageAddress, bytes32 paymentId, address user, bool value)
578     public {
579         EternalStorage(storageAddress).setBool(keccak256(abi.encodePacked("payment.withdrawed", paymentId, user)), value);
580     }
581 
582     function getPayment(address storageAddress, bytes32 paymentId)
583     public view returns(
584         uint8 status, uint8 fee, bool feePayed, bool signed, bool deposited
585     ) {
586         status = uint8(getPaymentStatus(storageAddress, paymentId));
587         fee = getPaymentFee(storageAddress, paymentId);
588         feePayed = isFeePayed(storageAddress, paymentId);
589         signed = isSigned(storageAddress, paymentId);
590         deposited = isDeposited(storageAddress, paymentId);
591     }
592 
593     function getPaymentOffers(address storageAddress, address depositor, address beneficiary, bytes32 paymentId)
594     public view returns(uint256 depositorOffer, uint256 beneficiaryOffer) {
595         depositorOffer = getOfferAmount(storageAddress, paymentId, depositor);
596         beneficiaryOffer = getOfferAmount(storageAddress, paymentId, beneficiary);
597     }
598 }
599 
600 contract Escrow is IEscrow {
601     using PaymentLib for address;
602     using FeeLib for address;
603     using EscrowConfigLib for address;
604 
605     constructor(address storageAddress, address _paymentHolder, address _courtAddress) public {
606         lib = storageAddress;
607         courtAddress = _courtAddress;
608         paymentHolder = _paymentHolder;
609     }
610 
611     /*----------------------CONFIGURATION METHODS----------------------*/
612 
613     function setStorageAddress(address _storageAddress) external onlyOwner {
614         lib = _storageAddress;
615     }
616 
617     function setPaymentHolder(address _paymentHolder) external onlyOwner {
618         paymentHolder = _paymentHolder;
619     }
620 
621     function setCourtAddress(address _courtAddress) external onlyOwner {
622         courtAddress = _courtAddress;
623     }
624 
625     function getTotalFee(address token)
626     public view returns(uint256) {
627         return lib.getTotalFee(token);
628     }
629 
630     function withdrawFee(address to, address token) 
631     external onlyOwner {
632         uint256 totalFee = lib.getTotalFee(token);
633         require(totalFee >= 0, "Can not withdraw 0 total fee");
634         if (token == address(0)) {
635             require(PaymentHolder(paymentHolder).withdrawEth(to, totalFee), "Error during withdraw ETH");
636         } else {
637             require(PaymentHolder(paymentHolder).withdrawToken(to, totalFee, token), "Error during withdraw Token");
638         }
639         lib.setTotalFee(0 ,token);
640     }
641 
642     /*----------------------PUBLIC USER METHODS----------------------*/
643 
644     /** @dev Depositor creates escrow payment. Set token as 0x0 in case of ETH amount.
645       * @param addresses [depositor, beneficiary, token]
646       * @param depositorPayFee If true, depositor have to send (amount + (amount * fee) / 100).
647       */
648     function createPayment(address[3] addresses, bytes32 deal, uint256 amount, bool depositorPayFee)
649     external {
650         onlyParties(addresses);
651         require(addresses[0] != address(0), "Depositor can not be 0x0 address");
652         require(addresses[1] != address(0), "Beneficiary can not be 0x0 address");
653         require(addresses[0] != addresses[1], "Depositor and beneficiary can not be the same");
654         require(deal != 0x0, "deal can not be 0x0");
655         require(amount != 0, "amount can not be 0");
656         bytes32 paymentId = getPaymentId(addresses, deal, amount);
657         checkStatus(paymentId, PaymentStatus.NONE);
658         uint8 fee = lib.getPaymentFee();
659         lib.createPayment(paymentId, fee, uint8(PaymentStatus.CREATED), depositorPayFee);
660         emit PaymentCreated(paymentId, addresses[0], addresses[1], addresses[2], deal, amount, fee, depositorPayFee);
661     }
662 
663     /** @dev Beneficiary signs escrow payment as consent for taking part.
664       * @param addresses [depositor, beneficiary, token]
665       */
666     function sign(address[3] addresses, bytes32 deal, uint256 amount)
667     external {
668         onlyBeneficiary(addresses);
669         bytes32 paymentId = getPaymentId(addresses, deal, amount);
670         require(!lib.isSigned(paymentId), "Payment can be signed only once");
671         checkStatus(paymentId, PaymentStatus.CREATED);
672         lib.setSigned(paymentId, true);
673         bool confirmed = lib.isDeposited(paymentId);
674         if (confirmed) {
675             setPaymentStatus(paymentId, PaymentStatus.CONFIRMED);
676         }
677         emit PaymentSigned(paymentId, confirmed);
678     }
679 
680     /** @dev Depositor deposits payment amount only after it was signed by beneficiary
681       * @param addresses [depositor, beneficiary, token]
682       */
683     function deposit(address[3] addresses, bytes32 deal, uint256 amount)
684     external payable {
685         onlyDepositor(addresses);
686         bytes32 paymentId = getPaymentId(addresses, deal, amount);
687         PaymentStatus status = getPaymentStatus(paymentId);
688         require(!lib.isDeposited(paymentId), "Payment can be deposited only once");
689         require(status == PaymentStatus.CREATED || status == PaymentStatus.SIGNED, "Invalid current payment status");
690         uint256 depositAmount = amount;
691         if (lib.isFeePayed(paymentId)) {
692             depositAmount = amount + calcFee(amount, lib.getPaymentFee(paymentId));
693         }
694         address token = getToken(addresses);
695         if (token == address(0)) {
696             require(msg.value == depositAmount, "ETH amount must be equal amount");
697             require(PaymentHolder(paymentHolder).depositEth.value(msg.value)(), "Not enough eth");
698         } else {
699             require(msg.value == 0, "ETH amount must be 0 for token transfer");
700             require(Token(token).allowance(msg.sender, address(this)) >= depositAmount, "Not enough token allowance");
701             require(Token(token).balanceOf(msg.sender) >= depositAmount, "No enough tokens");
702             require(Token(token).transferFrom(msg.sender, paymentHolder, depositAmount), "Error during transafer tokens");
703         }
704         lib.setDeposited(paymentId, true);
705         bool confirmed = lib.isSigned(paymentId);
706         if (confirmed) {
707             setPaymentStatus(paymentId, PaymentStatus.CONFIRMED);
708         }
709         emit PaymentDeposited(paymentId, depositAmount, confirmed);
710     }
711 
712     /** @dev Depositor or Beneficiary requests payment cancellation after payment was signed by beneficiary.
713       *      Payment is closed, if depositor and beneficiary both request cancellation.
714       * @param addresses [depositor, beneficiary, token]
715       */
716     function cancel(address[3] addresses, bytes32 deal, uint256 amount)
717     external {
718         onlyParties(addresses);
719         bytes32 paymentId = getPaymentId(addresses, deal, amount);
720         checkStatus(paymentId, PaymentStatus.CREATED);
721         setPaymentStatus(paymentId, PaymentStatus.CANCELED);
722         if (lib.isDeposited(paymentId)) {
723             uint256 amountToRefund = amount;
724             if (lib.isFeePayed(paymentId)) {
725                 amountToRefund = amount + calcFee(amount, lib.getPaymentFee(paymentId));
726             }
727             transfer(getDepositor(addresses), amountToRefund, getToken(addresses));
728         }
729         setPaymentStatus(paymentId, PaymentStatus.CANCELED);
730         emit PaymentCanceled(paymentId);
731         emit PaymentCanceled(paymentId);
732     }
733 
734     /** @dev Depositor close payment though transfer payment amount to another party.
735       * @param addresses [depositor, beneficiary, token]
736       */
737     function release(address[3] addresses, bytes32 deal, uint256 amount)
738     external {
739         onlyDepositor(addresses);
740         bytes32 paymentId = getPaymentId(addresses, deal, amount);
741         checkStatus(paymentId, PaymentStatus.CONFIRMED);
742         doRelease(addresses, [amount, 0], paymentId);
743         emit PaymentReleased(paymentId);
744     }
745 
746     /** @dev Depositor or beneficiary offers partial closing payment with offerAmount.
747       * @param addresses [depositor, beneficiary, token]
748       * @param offerAmount Amount of partial closing offer in currency of payment (ETH or token).
749       */
750     function offer(address[3] addresses, bytes32 deal, uint256 amount, uint256 offerAmount)
751     external {
752         onlyParties(addresses);
753         require(offerAmount >= 0 && offerAmount <= amount, "Offer amount must be >= 0 and <= payment amount");
754         bytes32 paymentId = getPaymentId(addresses, deal, amount);
755         uint256 anotherOfferAmount = lib.getOfferAmount(paymentId, getAnotherParty(addresses));
756         require(anotherOfferAmount == 0, "Sender can not make offer if another party has done the same before");
757         lib.setOfferAmount(paymentId, msg.sender, offerAmount);
758         emit PaymentOffer(paymentId, offerAmount);
759     }
760 
761     /** @dev Depositor or beneficiary cancels opposite party offer.
762       * @param addresses [depositor, beneficiary, token]
763       */
764     function cancelOffer(address[3] addresses, bytes32 deal, uint256 amount)
765     external {
766         bytes32 paymentId = doCancelOffer(addresses, deal, amount, getAnotherParty(addresses));
767         emit PaymentOfferCanceled(paymentId);
768     }
769 
770     /** @dev Depositor or beneficiary cancels own offer.
771     * @param addresses [depositor, beneficiary, token]
772     */
773     function cancelOwnOffer(address[3] addresses, bytes32 deal, uint256 amount)
774     external {
775         bytes32 paymentId = doCancelOffer(addresses, deal, amount, msg.sender);
776         emit PaymentOwnOfferCanceled(paymentId);
777     }
778 
779     /** @dev Depositor or beneficiary accepts opposite party offer.
780       * @param addresses [depositor, beneficiary, token]
781       */
782     function acceptOffer(address[3] addresses, bytes32 deal, uint256 amount)
783     external {
784         onlyParties(addresses);
785         bytes32 paymentId = getPaymentId(addresses, deal, amount);
786         checkStatus(paymentId, PaymentStatus.CONFIRMED);
787         uint256 offerAmount = lib.getOfferAmount(paymentId, getAnotherParty(addresses));
788         require(offerAmount != 0, "Sender can not accept another party offer of 0");
789         uint256 toBeneficiary = offerAmount;
790         uint256 toDepositor = amount - offerAmount;
791         //if sender is beneficiary
792         if (msg.sender == addresses[1]) {
793             toBeneficiary = amount - offerAmount;
794             toDepositor = offerAmount;
795         }
796         doRelease(addresses, [toBeneficiary, toDepositor], paymentId);
797         emit PaymentOfferAccepted(paymentId, toBeneficiary, toDepositor);
798     }
799 
800     /** @dev Depositor or beneficiary withdraw amounts.
801       * @param addresses [depositor, beneficiary, token]
802       */
803     function withdraw(address[3] addresses, bytes32 deal, uint256 amount)
804     external {
805         onlyParties(addresses);
806         bytes32 paymentId = getPaymentId(addresses, deal, amount);
807         checkStatus(paymentId, PaymentStatus.RELEASED);
808         require(!lib.isWithdrawn(paymentId, msg.sender), "User can not withdraw twice.");
809         uint256 withdrawAmount = lib.getWithdrawAmount(paymentId, msg.sender);
810         withdrawAmount = transferWithFee(msg.sender, withdrawAmount, addresses[2], paymentId);
811         emit PaymentWithdrawn(paymentId, withdrawAmount);
812         lib.setWithdrawn(paymentId, msg.sender, true);
813         address anotherParty = getAnotherParty(addresses);
814         if (lib.getWithdrawAmount(paymentId, anotherParty) == 0 || lib.isWithdrawn(paymentId, anotherParty)) {
815             setPaymentStatus(paymentId, PaymentStatus.CLOSED);
816             emit PaymentClosed(paymentId);
817         }
818     }
819 
820     /** @dev Depositor or Beneficiary withdraw amounts according dispute verdict.
821       * @dev Have to use fucking arrays due to "stack too deep" issue.
822       * @param addresses [depositor, beneficiary, token]
823       * @param disputeParties [applicant, respondent]
824       * @param uints [paymentAmount, disputeAmount, disputeCreatedAt]
825       * @param byts [deal, disputeTitle]
826       */
827     function withdrawByDispute(address[3] addresses, address[2] disputeParties, uint256[3] uints, bytes32[2] byts)
828     external {
829         onlyParties(addresses);
830         require(
831             addresses[0] == disputeParties[0] && addresses[1] == disputeParties[1] || addresses[0] == disputeParties[1] && addresses[1] == disputeParties[0],
832             "Depositor and beneficiary must be dispute parties"
833         );
834         bytes32 paymentId = getPaymentId(addresses, byts[0], uints[0]);
835         PaymentStatus paymentStatus = getPaymentStatus(paymentId);
836         require(paymentStatus == PaymentStatus.CONFIRMED || paymentStatus == PaymentStatus.RELEASED_BY_DISPUTE, "Invalid current payment status");
837         require(!lib.isWithdrawn(paymentId, msg.sender), "User can not withdraw twice.");
838         bytes32 dispute = ICourt(courtAddress).getCaseId(
839             disputeParties[0] /*applicant*/, disputeParties[1]/*respondent*/,
840             paymentId/*deal*/, uints[2]/*disputeCreatedAt*/,
841             byts[1]/*disputeTitle*/, uints[1]/*disputeAmount*/
842         );
843         require(ICourt(courtAddress).getCaseStatus(dispute) == 3, "Case must be closed");
844         /*[releaseAmount, refundAmount]*/
845         uint256[2] memory withdrawAmounts = [uint256(0), 0];
846         bool won = ICourt(courtAddress).getCaseVerdict(dispute);
847         //depositor == applicant
848         if (won) {
849             //use paymentAmount if disputeAmount is greater
850             withdrawAmounts[0] = uints[1] > uints[0] ? uints[0] : uints[1];
851             withdrawAmounts[1] = uints[0] - withdrawAmounts[0];
852         } else {
853             //make full release
854             withdrawAmounts[1] = uints[0];
855         }
856         if (msg.sender != disputeParties[0]) {
857             withdrawAmounts[0] = withdrawAmounts[0] + withdrawAmounts[1];
858             withdrawAmounts[1] = withdrawAmounts[0] - withdrawAmounts[1];
859             withdrawAmounts[0] = withdrawAmounts[0] - withdrawAmounts[1];
860         }
861         address anotherParty = getAnotherParty(addresses);
862         //if sender is depositor
863         withdrawAmounts[0] = transferWithFee(msg.sender, withdrawAmounts[0], addresses[2], paymentId);
864         emit PaymentWithdrawnByDispute(paymentId, withdrawAmounts[0], dispute);
865         lib.setWithdrawn(paymentId, msg.sender, true);
866         if (withdrawAmounts[1] == 0 || lib.isWithdrawn(paymentId, anotherParty)) {
867             setPaymentStatus(paymentId, PaymentStatus.CLOSED);
868             emit PaymentClosedByDispute(paymentId, dispute);
869         } else {
870             //need to prevent withdraw by another flow, e.g. simple release or offer accepting
871             setPaymentStatus(paymentId, PaymentStatus.RELEASED_BY_DISPUTE);
872         }
873     }
874     
875     /*------------------PRIVATE METHODS----------------------*/
876     function getPaymentId(address[3] addresses, bytes32 deal, uint256 amount)
877     public pure returns (bytes32) {return PaymentLib.getPaymentId(addresses, deal, amount);}
878 
879     function getDepositor(address[3] addresses) private pure returns (address) {return addresses[0];}
880 
881     function getBeneficiary(address[3] addresses) private pure returns (address) {return addresses[1];}
882 
883     function getToken(address[3] addresses) private pure returns (address) {return addresses[2];}
884 
885     function getAnotherParty(address[3] addresses) private view returns (address) {
886         return msg.sender == addresses[0] ? addresses[1] : addresses[0];
887     }
888 
889     function onlyParties(address[3] addresses) private view {require(msg.sender == addresses[0] || msg.sender == addresses[1]);}
890 
891     function onlyDepositor(address[3] addresses) private view {require(msg.sender == addresses[0]);}
892 
893     function onlyBeneficiary(address[3] addresses) private view {require(msg.sender == addresses[1]);}
894 
895     function getPaymentStatus(bytes32 paymentId)
896     private view returns (PaymentStatus) {
897         return PaymentStatus(lib.getPaymentStatus(paymentId));
898     }
899 
900     function setPaymentStatus(bytes32 paymentId, PaymentStatus status)
901     private {
902         lib.setPaymentStatus(paymentId, uint8(status));
903     }
904 
905     function checkStatus(bytes32 paymentId, PaymentStatus status)
906     private view {
907         require(lib.getPaymentStatus(paymentId) == uint8(status), "Required status does not match actual one");
908     }
909 
910     function doCancelOffer(address[3] addresses, bytes32 deal, uint256 amount, address from)
911     private returns(bytes32 paymentId) {
912         onlyParties(addresses);
913         paymentId = getPaymentId(addresses, deal, amount);
914         checkStatus(paymentId, PaymentStatus.CONFIRMED);
915         uint256 offerAmount = lib.getOfferAmount(paymentId, from);
916         require(offerAmount != 0, "Sender can not cancel offer of 0");
917         lib.setOfferAmount(paymentId, from, 0);
918     }
919 
920     /** @param addresses [depositor, beneficiary, token]
921       * @param amounts [releaseAmount, refundAmount]
922       */
923     function doRelease(address[3] addresses, uint256[2] amounts, bytes32 paymentId)
924     private {
925         setPaymentStatus(paymentId, PaymentStatus.RELEASED);
926         lib.setWithdrawAmount(paymentId, getBeneficiary(addresses), amounts[0]);
927         lib.setWithdrawAmount(paymentId, getDepositor(addresses), amounts[1]);
928     }
929 
930     function transferWithFee(address to, uint256 amount, address token, bytes32 paymentId)
931     private returns (uint256 transferAmount) {
932         require(amount != 0, "There is sense to invoke this method if withdraw amount is 0.");
933         uint256 feeAmount = calcFee(amount, lib.getPaymentFee(paymentId));
934         transferAmount = amount;
935         if (!lib.isFeePayed(paymentId)) {
936             transferAmount = amount - feeAmount;
937         }
938         transfer(to, transferAmount, token);
939         if (feeAmount > 0) {
940             lib.addFee(feeAmount, token);
941         }
942     }   
943 
944     function transfer(address to, uint256 amount, address token)
945     private {
946         if (amount == 0) {
947             return;
948         }
949         if (token == address(0)) {
950             require(PaymentHolder(paymentHolder).withdrawEth(to, amount), "Error during withdraw ETH");
951         } else {
952             require(PaymentHolder(paymentHolder).withdrawToken(to, amount, token), "Error during withdraw Token");
953         }
954     }
955 
956     function calcFee(uint amount, uint fee)
957     private pure returns (uint256) {
958         return ((amount * fee) / 100);
959     }
960 
961 }