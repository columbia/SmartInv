1 pragma solidity ^0.4.22;
2 
3 contract Ownable {
4     address public owner;
5     
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7     
8     /**
9      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10      * account.
11      */
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16     /**
17      * @dev Throws if called by any account other than the owner.
18      */
19     modifier onlyOwner() {
20         require(msg.sender == owner);
21         _;
22     }
23 
24     /**
25      * @dev Allows the current owner to transfer control of the contract to a newOwner.
26      * @param newOwner The address to transfer ownership to.
27      */
28     function transferOwnership(address newOwner) public onlyOwner {
29         require(newOwner != address(0));
30         emit OwnershipTransferred(owner, newOwner);
31         owner = newOwner;
32     }
33 
34 }
35 
36 contract Token  {
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40     uint256 public totalSupply;
41 
42     function balanceOf(address _owner) public view returns (uint256 balance);
43     function transfer(address _to, uint256 _value) public returns (bool success);
44     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
45     function approve(address _spender, uint256 _value) public returns (bool success);
46     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
47     function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
48     function decreaseApproval (address _spender, uint _subtractedValue)public returns (bool success);
49 
50 }
51 
52 contract EternalStorage {
53 
54     /**** Storage Types *******/
55 
56     address public owner;
57 
58     mapping(bytes32 => uint256)    private uIntStorage;
59     mapping(bytes32 => uint8)      private uInt8Storage;
60     mapping(bytes32 => string)     private stringStorage;
61     mapping(bytes32 => address)    private addressStorage;
62     mapping(bytes32 => bytes)      private bytesStorage;
63     mapping(bytes32 => bool)       private boolStorage;
64     mapping(bytes32 => int256)     private intStorage;
65     mapping(bytes32 => bytes32)    private bytes32Storage;
66 
67 
68     /*** Modifiers ************/
69 
70     /// @dev Only allow access from the latest version of a contract after deployment
71     modifier onlyLatestContract() {
72         require(addressStorage[keccak256(abi.encodePacked("contract.address", msg.sender))] != 0x0 || msg.sender == owner);
73         _;
74     }
75 
76     /// @dev constructor
77     constructor() public {
78         owner = msg.sender;
79         addressStorage[keccak256(abi.encodePacked("contract.address", msg.sender))] = msg.sender;
80     }
81 
82     function setOwner() public {
83         require(msg.sender == owner);
84         addressStorage[keccak256(abi.encodePacked("contract.address", owner))] = 0x0;
85         owner = msg.sender;
86         addressStorage[keccak256(abi.encodePacked("contract.address", msg.sender))] = msg.sender;
87     }
88 
89     /**** Get Methods ***********/
90 
91     /// @param _key The key for the record
92     function getAddress(bytes32 _key) external view returns (address) {
93         return addressStorage[_key];
94     }
95 
96     /// @param _key The key for the record
97     function getUint(bytes32 _key) external view returns (uint) {
98         return uIntStorage[_key];
99     }
100 
101     /// @param _key The key for the record
102     function getUint8(bytes32 _key) external view returns (uint8) {
103         return uInt8Storage[_key];
104     }
105 
106 
107     /// @param _key The key for the record
108     function getString(bytes32 _key) external view returns (string) {
109         return stringStorage[_key];
110     }
111 
112     /// @param _key The key for the record
113     function getBytes(bytes32 _key) external view returns (bytes) {
114         return bytesStorage[_key];
115     }
116 
117     /// @param _key The key for the record
118     function getBytes32(bytes32 _key) external view returns (bytes32) {
119         return bytes32Storage[_key];
120     }
121 
122     /// @param _key The key for the record
123     function getBool(bytes32 _key) external view returns (bool) {
124         return boolStorage[_key];
125     }
126 
127     /// @param _key The key for the record
128     function getInt(bytes32 _key) external view returns (int) {
129         return intStorage[_key];
130     }
131 
132     /**** Set Methods ***********/
133 
134     /// @param _key The key for the record
135     function setAddress(bytes32 _key, address _value) onlyLatestContract external {
136         addressStorage[_key] = _value;
137     }
138 
139     /// @param _key The key for the record
140     function setUint(bytes32 _key, uint _value) onlyLatestContract external {
141         uIntStorage[_key] = _value;
142     }
143 
144     /// @param _key The key for the record
145     function setUint8(bytes32 _key, uint8 _value) onlyLatestContract external {
146         uInt8Storage[_key] = _value;
147     }
148 
149     /// @param _key The key for the record
150     function setString(bytes32 _key, string _value) onlyLatestContract external {
151         stringStorage[_key] = _value;
152     }
153 
154     /// @param _key The key for the record
155     function setBytes(bytes32 _key, bytes _value) onlyLatestContract external {
156         bytesStorage[_key] = _value;
157     }
158 
159     /// @param _key The key for the record
160     function setBytes32(bytes32 _key, bytes32 _value) onlyLatestContract external {
161         bytes32Storage[_key] = _value;
162     }
163 
164     /// @param _key The key for the record
165     function setBool(bytes32 _key, bool _value) onlyLatestContract external {
166         boolStorage[_key] = _value;
167     }
168 
169     /// @param _key The key for the record
170     function setInt(bytes32 _key, int _value) onlyLatestContract external {
171         intStorage[_key] = _value;
172     }
173 
174     /**** Delete Methods ***********/
175 
176     /// @param _key The key for the record
177     function deleteAddress(bytes32 _key) onlyLatestContract external {
178         delete addressStorage[_key];
179     }
180 
181     /// @param _key The key for the record
182     function deleteUint(bytes32 _key) onlyLatestContract external {
183         delete uIntStorage[_key];
184     }
185 
186     /// @param _key The key for the record
187     function deleteUint8(bytes32 _key) onlyLatestContract external {
188         delete uInt8Storage[_key];
189     }
190 
191     /// @param _key The key for the record
192     function deleteString(bytes32 _key) onlyLatestContract external {
193         delete stringStorage[_key];
194     }
195 
196     /// @param _key The key for the record
197     function deleteBytes(bytes32 _key) onlyLatestContract external {
198         delete bytesStorage[_key];
199     }
200 
201     /// @param _key The key for the record
202     function deleteBytes32(bytes32 _key) onlyLatestContract external {
203         delete bytes32Storage[_key];
204     }
205 
206     /// @param _key The key for the record
207     function deleteBool(bytes32 _key) onlyLatestContract external {
208         delete boolStorage[_key];
209     }
210 
211     /// @param _key The key for the record
212     function deleteInt(bytes32 _key) onlyLatestContract external {
213         delete intStorage[_key];
214     }
215 }
216 
217 contract PaymentHolder is Ownable {
218 
219     modifier onlyAllowed() {
220         require(allowed[msg.sender]);
221         _;
222     }
223 
224     modifier onlyUpdater() {
225         require(msg.sender == updater);
226         _;
227     }
228 
229     mapping(address => bool) public allowed;
230     address public updater;
231 
232     /*-----------------MAINTAIN METHODS------------------*/
233 
234     function setUpdater(address _updater)
235     external onlyOwner {
236         updater = _updater;
237     }
238 
239     function migrate(address newHolder, address[] tokens, address[] _allowed)
240     external onlyOwner {
241         require(PaymentHolder(newHolder).update.value(address(this).balance)(_allowed));
242         for (uint256 i = 0; i < tokens.length; i++) {
243             address token = tokens[i];
244             uint256 balance = Token(token).balanceOf(this);
245             if (balance > 0) {
246                 require(Token(token).transfer(newHolder, balance));
247             }
248         }
249     }
250 
251     function update(address[] _allowed)
252     external payable onlyUpdater returns(bool) {
253         for (uint256 i = 0; i < _allowed.length; i++) {
254             allowed[_allowed[i]] = true;
255         }
256         return true;
257     }
258 
259     /*-----------------OWNER FLOW------------------*/
260 
261     function allow(address to) 
262     external onlyOwner { allowed[to] = true; }
263 
264     function prohibit(address to)
265     external onlyOwner { allowed[to] = false; }
266 
267     /*-----------------ALLOWED FLOW------------------*/
268 
269     function depositEth()
270     public payable onlyAllowed returns (bool) {
271         //Default function to receive eth
272         return true;
273     }
274 
275     function withdrawEth(address to, uint256 amount)
276     public onlyAllowed returns(bool) {
277         require(address(this).balance >= amount, "Not enough ETH balance");
278         to.transfer(amount);
279         return true;
280     }
281 
282     function withdrawToken(address to, uint256 amount, address token)
283     public onlyAllowed returns(bool) {
284         require(Token(token).balanceOf(this) >= amount, "Not enough token balance");
285         require(Token(token).transfer(to, amount));
286         return true;
287     }
288 }
289 
290 library EscrowConfigLib {
291 
292     function getPaymentFee(address storageAddress) public view returns (uint8) {
293         return EternalStorage(storageAddress).getUint8(keccak256(abi.encodePacked("escrow.config.payment.fee")));
294     }
295 
296     function setPaymentFee(address storageAddress, uint8 value) public {
297         EternalStorage(storageAddress).setUint8(keccak256(abi.encodePacked("escrow.config.payment.fee")), value);
298     }
299 
300 }
301 
302 contract ICourt is Ownable {
303 
304     function getCaseId(address applicant, address respondent, bytes32 deal, uint256 date, bytes32 title, uint256 amount) 
305         public pure returns(bytes32);
306 
307     function getCaseStatus(bytes32 caseId) public view returns(uint8);
308 
309     function getCaseVerdict(bytes32 caseId) public view returns(bool);
310 }
311 
312 contract EscrowConfig is Ownable {
313 
314     using EscrowConfigLib for address;
315 
316     address public config;
317 
318     constructor(address storageAddress) public {
319         config = storageAddress;
320     }
321 
322     function resetValuesToDefault() external onlyOwner {
323         config.setPaymentFee(2);//%
324     }
325 
326     function setStorageAddress(address storageAddress) external onlyOwner {
327         config = storageAddress;
328     }
329 
330     function getPaymentFee() external view returns (uint8) {
331         return config.getPaymentFee();
332     }
333 
334     //value - % of payment amount
335     function setPaymentFee(uint8 value) external onlyOwner {
336         require(value >= 0 && value < 100, "Fee in % of payment amount must be >= 0 and < 100");
337         config.setPaymentFee(value);
338     }
339 }
340 
341 contract Withdrawable is Ownable {
342     function withdrawEth(uint value) external onlyOwner {
343         require(address(this).balance >= value);
344         msg.sender.transfer(value);
345     }
346 
347     function withdrawToken(address token, uint value) external onlyOwner {
348         require(Token(token).balanceOf(address(this)) >= value, "Not enough tokens");
349         require(Token(token).transfer(msg.sender, value));
350     }
351 }
352 
353 library PaymentLib {
354 
355     function getPaymentId(address[3] addresses, bytes32 deal, uint256 amount) public pure returns (bytes32) {
356         return keccak256(abi.encodePacked(addresses[0], addresses[1], addresses[2], deal, amount));
357     }
358 
359     function createPayment(
360         address storageAddress, bytes32 paymentId, uint8 fee, uint8 status, bool feePayed
361     ) public {
362         setPaymentStatus(storageAddress, paymentId, status);
363         setPaymentFee(storageAddress, paymentId, fee);
364         if (feePayed) {
365             setFeePayed(storageAddress, paymentId, true);
366         }
367     }
368 
369     function isCancelRequested(address storageAddress, bytes32 paymentId, address party)
370     public view returns(bool) {
371         return EternalStorage(storageAddress).getBool(keccak256(abi.encodePacked("payment.cance", paymentId, party)));
372     }
373 
374     function setCancelRequested(address storageAddress, bytes32 paymentId, address party, bool value)
375     public {
376         EternalStorage(storageAddress).setBool(keccak256(abi.encodePacked("payment.cance", paymentId, party)), value);
377     }
378 
379     function getPaymentFee(address storageAddress, bytes32 paymentId)
380     public view returns (uint8) {
381         return EternalStorage(storageAddress).getUint8(keccak256(abi.encodePacked("payment.fee", paymentId)));
382     }
383 
384     function setPaymentFee(address storageAddress, bytes32 paymentId, uint8 value)
385     public {
386         EternalStorage(storageAddress).setUint8(keccak256(abi.encodePacked("payment.fee", paymentId)), value);
387     }
388 
389     function isFeePayed(address storageAddress, bytes32 paymentId)
390     public view returns (bool) {
391         return EternalStorage(storageAddress).getBool(keccak256(abi.encodePacked("payment.fee.payed", paymentId)));
392     }
393 
394     function setFeePayed(address storageAddress, bytes32 paymentId, bool value)
395     public {
396         EternalStorage(storageAddress).setBool(keccak256(abi.encodePacked("payment.fee.payed", paymentId)), value);
397     }
398 
399     function isDeposited(address storageAddress, bytes32 paymentId)
400     public view returns (bool) {
401         return EternalStorage(storageAddress).getBool(keccak256(abi.encodePacked("payment.deposited", paymentId)));
402     }
403 
404     function setDeposited(address storageAddress, bytes32 paymentId, bool value)
405     public {
406         EternalStorage(storageAddress).setBool(keccak256(abi.encodePacked("payment.deposited", paymentId)), value);
407     }
408 
409     function isSigned(address storageAddress, bytes32 paymentId)
410     public view returns (bool) {
411         return EternalStorage(storageAddress).getBool(keccak256(abi.encodePacked("payment.signed", paymentId)));
412     }
413 
414     function setSigned(address storageAddress, bytes32 paymentId, bool value)
415     public {
416         EternalStorage(storageAddress).setBool(keccak256(abi.encodePacked("payment.signed", paymentId)), value);
417     }
418 
419     function getPaymentStatus(address storageAddress, bytes32 paymentId)
420     public view returns (uint8) {
421         return EternalStorage(storageAddress).getUint8(keccak256(abi.encodePacked("payment.status", paymentId)));
422     }
423 
424     function setPaymentStatus(address storageAddress, bytes32 paymentId, uint8 status)
425     public {
426         EternalStorage(storageAddress).setUint8(keccak256(abi.encodePacked("payment.status", paymentId)), status);
427     }
428 
429     function getOfferAmount(address storageAddress, bytes32 paymentId, address user)
430     public view returns (uint256) {
431         return EternalStorage(storageAddress).getUint(keccak256(abi.encodePacked("payment.amount.refund", paymentId, user)));
432     }
433 
434     function setOfferAmount(address storageAddress, bytes32 paymentId, address user, uint256 amount)
435     public {
436         EternalStorage(storageAddress).setUint(keccak256(abi.encodePacked("payment.amount.refund", paymentId, user)), amount);
437     }
438 
439     function getWithdrawAmount(address storageAddress, bytes32 paymentId, address user)
440     public view returns (uint256) {
441         return EternalStorage(storageAddress).getUint(keccak256(abi.encodePacked("payment.amount.withdraw", paymentId, user)));
442     }
443 
444     function setWithdrawAmount(address storageAddress, bytes32 paymentId, address user, uint256 amount)
445     public {
446         EternalStorage(storageAddress).setUint(keccak256(abi.encodePacked("payment.amount.withdraw", paymentId, user)), amount);
447     }
448 
449     function isWithdrawn(address storageAddress, bytes32 paymentId, address user)
450     public view returns (bool) {
451         return EternalStorage(storageAddress).getBool(keccak256(abi.encodePacked("payment.withdrawed", paymentId, user)));
452     }
453 
454     function setWithdrawn(address storageAddress, bytes32 paymentId, address user, bool value)
455     public {
456         EternalStorage(storageAddress).setBool(keccak256(abi.encodePacked("payment.withdrawed", paymentId, user)), value);
457     }
458 
459     function getPayment(address storageAddress, bytes32 paymentId)
460     public view returns(
461         uint8 status, uint8 fee, bool feePayed, bool signed, bool deposited
462     ) {
463         status = uint8(getPaymentStatus(storageAddress, paymentId));
464         fee = getPaymentFee(storageAddress, paymentId);
465         feePayed = isFeePayed(storageAddress, paymentId);
466         signed = isSigned(storageAddress, paymentId);
467         deposited = isDeposited(storageAddress, paymentId);
468     }
469 
470     function getPaymentOffers(address storageAddress, address depositor, address beneficiary, bytes32 paymentId)
471     public view returns(uint256 depositorOffer, uint256 beneficiaryOffer) {
472         depositorOffer = getOfferAmount(storageAddress, paymentId, depositor);
473         beneficiaryOffer = getOfferAmount(storageAddress, paymentId, beneficiary);
474     }
475 }
476 
477 contract IEscrow is Withdrawable {
478 
479     /*----------------------PAYMENT STATUSES----------------------*/
480 
481     //SIGNED status kept for backward compatibility
482     enum PaymentStatus {NONE/*code=0*/, CREATED/*code=1*/, SIGNED/*code=2*/, CONFIRMED/*code=3*/, RELEASED/*code=4*/, RELEASED_BY_DISPUTE /*code=5*/, CLOSED/*code=6*/, CANCELED/*code=7*/}
483 
484     /*----------------------EVENTS----------------------*/
485 
486     event PaymentCreated(bytes32 paymentId, address depositor, address beneficiary, address token, bytes32 deal, uint256 amount, uint8 fee, bool feePayed);
487     event PaymentSigned(bytes32 paymentId, bool confirmed);
488     event PaymentDeposited(bytes32 paymentId, uint256 depositedAmount, bool confirmed);
489     event PaymentReleased(bytes32 paymentId);
490     event PaymentOffer(bytes32 paymentId, uint256 offerAmount);
491     event PaymentOfferCanceled(bytes32 paymentId);
492     event PaymentOwnOfferCanceled(bytes32 paymentId);
493     event PaymentOfferAccepted(bytes32 paymentId, uint256 releaseToBeneficiary, uint256 refundToDepositor);
494     event PaymentWithdrawn(bytes32 paymentId, uint256 amount);
495     event PaymentWithdrawnByDispute(bytes32 paymentId, uint256 amount, bytes32 dispute);
496     event PaymentCanceled(bytes32 paymentId);
497     event PaymentClosed(bytes32 paymentId);
498     event PaymentClosedByDispute(bytes32 paymentId, bytes32 dispute);
499 
500     /*----------------------PUBLIC STATE----------------------*/
501 
502     address public lib;
503     address public courtAddress;
504     address public paymentHolder;
505 
506 
507     /*----------------------CONFIGURATION METHODS (only owner) ----------------------*/
508     function setStorageAddress(address _storageAddress) external;
509 
510     function setCourtAddress(address _courtAddress) external;
511 
512     /*----------------------PUBLIC USER METHODS----------------------*/
513     /** @dev Depositor creates escrow payment. Set token as 0x0 in case of ETH amount.
514       * @param addresses [depositor, beneficiary, token]
515       * @param depositorPayFee If true, depositor have to send (amount + (amount * fee) / 100).
516       */
517     function createPayment(address[3] addresses, bytes32 deal, uint256 amount, bool depositorPayFee) external;
518 
519     /** @dev Beneficiary signs escrow payment as consent for taking part.
520       * @param addresses [depositor, beneficiary, token]
521       */
522     function sign(address[3] addresses, bytes32 deal, uint256 amount) external;
523 
524     /** @dev Depositor deposits payment amount only after it was signed by beneficiary.
525       * @param addresses [depositor, beneficiary, token]
526       */
527     function deposit(address[3] addresses, bytes32 deal, uint256 amount) external payable;
528 
529     /** @dev Depositor or Beneficiary requests payment cancellation after payment was signed by beneficiary.
530       *      Payment is closed, if depositor and beneficiary both request cancellation.
531       * @param addresses [depositor, beneficiary, token]
532       */
533     function cancel(address[3] addresses, bytes32 deal, uint256 amount) external;
534 
535     /** @dev Depositor close payment though transfer payment amount to another party.
536       * @param addresses [depositor, beneficiary, token]
537       */
538     function release(address[3] addresses, bytes32 deal, uint256 amount) external;
539 
540     /** @dev Depositor or beneficiary offers partial closing payment with offerAmount.
541       * @param addresses [depositor, beneficiary, token]
542       * @param offerAmount Amount of partial closing offer in currency of payment (ETH or token).
543       */
544     function offer(address[3] addresses, bytes32 deal, uint256 amount, uint256 offerAmount) external;
545 
546     /** @dev Depositor or beneficiary canceles another party offer.
547       * @param addresses [depositor, beneficiary, token]
548       */
549     function cancelOffer(address[3] addresses, bytes32 deal, uint256 amount) external;
550 
551     /** @dev Depositor or beneficiary cancels own offer.
552       * @param addresses [depositor, beneficiary, token]
553       */
554     function cancelOwnOffer(address[3] addresses, bytes32 deal, uint256 amount) external;
555 
556     /** @dev Depositor or beneficiary accepts opposite party offer.
557       * @param addresses [depositor, beneficiary, token]
558       */
559     function acceptOffer(address[3] addresses, bytes32 deal, uint256 amount) external;
560 
561 
562     /** @dev Depositor or beneficiary withdraw amounts.
563       * @param addresses [depositor, beneficiary, token]
564       */
565     function withdraw(address[3] addresses, bytes32 deal, uint256 amount) external;
566 
567     /** @dev Depositor or Beneficiary withdraw amounts according dispute verdict.
568       * @dev Have to use fucking arrays due to "stack too deep" issue.
569       * @param addresses [depositor, beneficiary, token]
570       * @param disputeParties [applicant, respondent]
571       * @param uints [paymentAmount, disputeAmount, disputeCreatedAt]
572       * @param byts [deal, disputeTitle]
573       */
574     function withdrawByDispute(address[3] addresses, address[2] disputeParties, uint256[3] uints, bytes32[2] byts) external;
575 }
576 
577 contract Escrow is IEscrow {
578     using PaymentLib for address;
579     using EscrowConfigLib for address;
580 
581     constructor(address storageAddress, address _paymentHolder, address _courtAddress) public {
582         lib = storageAddress;
583         courtAddress = _courtAddress;
584         paymentHolder = _paymentHolder;
585     }
586 
587     /*----------------------CONFIGURATION METHODS----------------------*/
588 
589     function setStorageAddress(address _storageAddress) external onlyOwner {
590         lib = _storageAddress;
591     }
592 
593     function setPaymentHolder(address _paymentHolder) external onlyOwner {
594         paymentHolder = _paymentHolder;
595     }
596 
597     function setCourtAddress(address _courtAddress) external onlyOwner {
598         courtAddress = _courtAddress;
599     }
600 
601     /*----------------------PUBLIC USER METHODS----------------------*/
602 
603     /** @dev Depositor creates escrow payment. Set token as 0x0 in case of ETH amount.
604       * @param addresses [depositor, beneficiary, token]
605       * @param depositorPayFee If true, depositor have to send (amount + (amount * fee) / 100).
606       */
607     function createPayment(address[3] addresses, bytes32 deal, uint256 amount, bool depositorPayFee)
608     external {
609         onlyParties(addresses);
610         require(addresses[0] != address(0), "Depositor can not be 0x0 address");
611         require(addresses[1] != address(0), "Beneficiary can not be 0x0 address");
612         require(addresses[0] != addresses[1], "Depositor and beneficiary can not be the same");
613         require(deal != 0x0, "deal can not be 0x0");
614         require(amount != 0, "amount can not be 0");
615         bytes32 paymentId = getPaymentId(addresses, deal, amount);
616         checkStatus(paymentId, PaymentStatus.NONE);
617         uint8 fee = lib.getPaymentFee();
618         lib.createPayment(paymentId, fee, uint8(PaymentStatus.CREATED), depositorPayFee);
619         emit PaymentCreated(paymentId, addresses[0], addresses[1], addresses[2], deal, amount, fee, depositorPayFee);
620     }
621 
622     /** @dev Beneficiary signs escrow payment as consent for taking part.
623       * @param addresses [depositor, beneficiary, token]
624       */
625     function sign(address[3] addresses, bytes32 deal, uint256 amount)
626     external {
627         onlyBeneficiary(addresses);
628         bytes32 paymentId = getPaymentId(addresses, deal, amount);
629         require(!lib.isSigned(paymentId), "Payment can be signed only once");
630         checkStatus(paymentId, PaymentStatus.CREATED);
631         lib.setSigned(paymentId, true);
632         bool confirmed = lib.isDeposited(paymentId);
633         if (confirmed) {
634             setPaymentStatus(paymentId, PaymentStatus.CONFIRMED);
635         }
636         emit PaymentSigned(paymentId, confirmed);
637     }
638 
639     /** @dev Depositor deposits payment amount only after it was signed by beneficiary
640       * @param addresses [depositor, beneficiary, token]
641       */
642     function deposit(address[3] addresses, bytes32 deal, uint256 amount)
643     external payable {
644         onlyDepositor(addresses);
645         bytes32 paymentId = getPaymentId(addresses, deal, amount);
646         PaymentStatus status = getPaymentStatus(paymentId);
647         require(!lib.isDeposited(paymentId), "Payment can be deposited only once");
648         require(status == PaymentStatus.CREATED || status == PaymentStatus.SIGNED, "Invalid current payment status");
649         uint256 depositAmount = amount;
650         if (lib.isFeePayed(paymentId)) {
651             depositAmount = amount + calcFee(amount, lib.getPaymentFee(paymentId));
652         }
653         address token = getToken(addresses);
654         if (token == address(0)) {
655             require(msg.value == depositAmount, "ETH amount must be equal amount");
656             require(PaymentHolder(paymentHolder).depositEth.value(msg.value)(), "Not enough eth");
657         } else {
658             require(msg.value == 0, "ETH amount must be 0 for token transfer");
659             require(Token(token).allowance(msg.sender, address(this)) >= depositAmount, "Not enough token allowance");
660             require(Token(token).balanceOf(msg.sender) >= depositAmount, "No enough tokens");
661             require(Token(token).transferFrom(msg.sender, paymentHolder, depositAmount), "Error during transafer tokens");
662         }
663         lib.setDeposited(paymentId, true);
664         bool confirmed = lib.isSigned(paymentId);
665         if (confirmed) {
666             setPaymentStatus(paymentId, PaymentStatus.CONFIRMED);
667         }
668         emit PaymentDeposited(paymentId, depositAmount, confirmed);
669     }
670 
671     /** @dev Depositor or Beneficiary requests payment cancellation after payment was signed by beneficiary.
672       *      Payment is closed, if depositor and beneficiary both request cancellation.
673       * @param addresses [depositor, beneficiary, token]
674       */
675     function cancel(address[3] addresses, bytes32 deal, uint256 amount)
676     external {
677         onlyParties(addresses);
678         bytes32 paymentId = getPaymentId(addresses, deal, amount);
679         checkStatus(paymentId, PaymentStatus.CREATED);
680         setPaymentStatus(paymentId, PaymentStatus.CANCELED);
681         if (lib.isDeposited(paymentId)) {
682             uint256 amountToRefund = amount;
683             if (lib.isFeePayed(paymentId)) {
684                 amountToRefund = amount + calcFee(amount, lib.getPaymentFee(paymentId));
685             }
686             transfer(getDepositor(addresses), amountToRefund, getToken(addresses));
687         }
688         setPaymentStatus(paymentId, PaymentStatus.CANCELED);
689         emit PaymentCanceled(paymentId);
690         emit PaymentCanceled(paymentId);
691     }
692 
693     /** @dev Depositor close payment though transfer payment amount to another party.
694       * @param addresses [depositor, beneficiary, token]
695       */
696     function release(address[3] addresses, bytes32 deal, uint256 amount)
697     external {
698         onlyDepositor(addresses);
699         bytes32 paymentId = getPaymentId(addresses, deal, amount);
700         checkStatus(paymentId, PaymentStatus.CONFIRMED);
701         doRelease(addresses, [amount, 0], paymentId);
702         emit PaymentReleased(paymentId);
703     }
704 
705     /** @dev Depositor or beneficiary offers partial closing payment with offerAmount.
706       * @param addresses [depositor, beneficiary, token]
707       * @param offerAmount Amount of partial closing offer in currency of payment (ETH or token).
708       */
709     function offer(address[3] addresses, bytes32 deal, uint256 amount, uint256 offerAmount)
710     external {
711         onlyParties(addresses);
712         require(offerAmount >= 0 && offerAmount <= amount, "Offer amount must be >= 0 and <= payment amount");
713         bytes32 paymentId = getPaymentId(addresses, deal, amount);
714         uint256 anotherOfferAmount = lib.getOfferAmount(paymentId, getAnotherParty(addresses));
715         require(anotherOfferAmount == 0, "Sender can not make offer if another party has done the same before");
716         lib.setOfferAmount(paymentId, msg.sender, offerAmount);
717         emit PaymentOffer(paymentId, offerAmount);
718     }
719 
720     /** @dev Depositor or beneficiary cancels opposite party offer.
721       * @param addresses [depositor, beneficiary, token]
722       */
723     function cancelOffer(address[3] addresses, bytes32 deal, uint256 amount)
724     external {
725         bytes32 paymentId = doCancelOffer(addresses, deal, amount, getAnotherParty(addresses));
726         emit PaymentOfferCanceled(paymentId);
727     }
728 
729     /** @dev Depositor or beneficiary cancels own offer.
730     * @param addresses [depositor, beneficiary, token]
731     */
732     function cancelOwnOffer(address[3] addresses, bytes32 deal, uint256 amount)
733     external {
734         bytes32 paymentId = doCancelOffer(addresses, deal, amount, msg.sender);
735         emit PaymentOwnOfferCanceled(paymentId);
736     }
737 
738     /** @dev Depositor or beneficiary accepts opposite party offer.
739       * @param addresses [depositor, beneficiary, token]
740       */
741     function acceptOffer(address[3] addresses, bytes32 deal, uint256 amount)
742     external {
743         onlyParties(addresses);
744         bytes32 paymentId = getPaymentId(addresses, deal, amount);
745         checkStatus(paymentId, PaymentStatus.CONFIRMED);
746         uint256 offerAmount = lib.getOfferAmount(paymentId, getAnotherParty(addresses));
747         require(offerAmount != 0, "Sender can not accept another party offer of 0");
748         uint256 toBeneficiary = offerAmount;
749         uint256 toDepositor = amount - offerAmount;
750         //if sender is beneficiary
751         if (msg.sender == addresses[1]) {
752             toBeneficiary = amount - offerAmount;
753             toDepositor = offerAmount;
754         }
755         doRelease(addresses, [toBeneficiary, toDepositor], paymentId);
756         emit PaymentOfferAccepted(paymentId, toBeneficiary, toDepositor);
757     }
758 
759     /** @dev Depositor or beneficiary withdraw amounts.
760       * @param addresses [depositor, beneficiary, token]
761       */
762     function withdraw(address[3] addresses, bytes32 deal, uint256 amount)
763     external {
764         onlyParties(addresses);
765         bytes32 paymentId = getPaymentId(addresses, deal, amount);
766         checkStatus(paymentId, PaymentStatus.RELEASED);
767         require(!lib.isWithdrawn(paymentId, msg.sender), "User can not withdraw twice.");
768         uint256 withdrawAmount = lib.getWithdrawAmount(paymentId, msg.sender);
769         withdrawAmount = transferWithFee(msg.sender, withdrawAmount, addresses[2], paymentId);
770         emit PaymentWithdrawn(paymentId, withdrawAmount);
771         lib.setWithdrawn(paymentId, msg.sender, true);
772         address anotherParty = getAnotherParty(addresses);
773         if (lib.getWithdrawAmount(paymentId, anotherParty) == 0 || lib.isWithdrawn(paymentId, anotherParty)) {
774             setPaymentStatus(paymentId, PaymentStatus.CLOSED);
775             emit PaymentClosed(paymentId);
776         }
777     }
778 
779     /** @dev Depositor or Beneficiary withdraw amounts according dispute verdict.
780       * @dev Have to use fucking arrays due to "stack too deep" issue.
781       * @param addresses [depositor, beneficiary, token]
782       * @param disputeParties [applicant, respondent]
783       * @param uints [paymentAmount, disputeAmount, disputeCreatedAt]
784       * @param byts [deal, disputeTitle]
785       */
786     function withdrawByDispute(address[3] addresses, address[2] disputeParties, uint256[3] uints, bytes32[2] byts)
787     external {
788         onlyParties(addresses);
789         require(
790             addresses[0] == disputeParties[0] && addresses[1] == disputeParties[1] || addresses[0] == disputeParties[1] && addresses[1] == disputeParties[0],
791             "Depositor and beneficiary must be dispute parties"
792         );
793         bytes32 paymentId = getPaymentId(addresses, byts[0], uints[0]);
794         PaymentStatus paymentStatus = getPaymentStatus(paymentId);
795         require(paymentStatus == PaymentStatus.CONFIRMED || paymentStatus == PaymentStatus.RELEASED_BY_DISPUTE, "Invalid current payment status");
796         require(!lib.isWithdrawn(paymentId, msg.sender), "User can not withdraw twice.");
797         bytes32 dispute = ICourt(courtAddress).getCaseId(
798             disputeParties[0] /*applicant*/, disputeParties[1]/*respondent*/,
799             paymentId/*deal*/, uints[2]/*disputeCreatedAt*/,
800             byts[1]/*disputeTitle*/, uints[1]/*disputeAmount*/
801         );
802         require(ICourt(courtAddress).getCaseStatus(dispute) == 3, "Case must be closed");
803         /*[releaseAmount, refundAmount]*/
804         uint256[2] memory withdrawAmounts = [uint256(0), 0];
805         bool won = ICourt(courtAddress).getCaseVerdict(dispute);
806         //depositor == applicant
807         if (won) {
808             //use paymentAmount if disputeAmount is greater
809             withdrawAmounts[0] = uints[1] > uints[0] ? uints[0] : uints[1];
810             withdrawAmounts[1] = uints[0] - withdrawAmounts[0];
811         } else {
812             //make full release
813             withdrawAmounts[1] = uints[0];
814         }
815         if (msg.sender != disputeParties[0]) {
816             withdrawAmounts[0] = withdrawAmounts[0] + withdrawAmounts[1];
817             withdrawAmounts[1] = withdrawAmounts[0] - withdrawAmounts[1];
818             withdrawAmounts[0] = withdrawAmounts[0] - withdrawAmounts[1];
819         }
820         address anotherParty = getAnotherParty(addresses);
821         //if sender is depositor
822         withdrawAmounts[0] = transferWithFee(msg.sender, withdrawAmounts[0], addresses[2], paymentId);
823         emit PaymentWithdrawnByDispute(paymentId, withdrawAmounts[0], dispute);
824         lib.setWithdrawn(paymentId, msg.sender, true);
825         if (withdrawAmounts[1] == 0 || lib.isWithdrawn(paymentId, anotherParty)) {
826             setPaymentStatus(paymentId, PaymentStatus.CLOSED);
827             emit PaymentClosedByDispute(paymentId, dispute);
828         } else {
829             //need to prevent withdraw by another flow, e.g. simple release or offer accepting
830             setPaymentStatus(paymentId, PaymentStatus.RELEASED_BY_DISPUTE);
831         }
832     }
833 
834     /*------------------PRIVATE METHODS----------------------*/
835     function getPaymentId(address[3] addresses, bytes32 deal, uint256 amount)
836     public pure returns (bytes32) {return PaymentLib.getPaymentId(addresses, deal, amount);}
837 
838     function getDepositor(address[3] addresses) private pure returns (address) {return addresses[0];}
839 
840     function getBeneficiary(address[3] addresses) private pure returns (address) {return addresses[1];}
841 
842     function getToken(address[3] addresses) private pure returns (address) {return addresses[2];}
843 
844     function getAnotherParty(address[3] addresses) private view returns (address) {
845         return msg.sender == addresses[0] ? addresses[1] : addresses[0];
846     }
847 
848     function onlyParties(address[3] addresses) private view {require(msg.sender == addresses[0] || msg.sender == addresses[1]);}
849 
850     function onlyDepositor(address[3] addresses) private view {require(msg.sender == addresses[0]);}
851 
852     function onlyBeneficiary(address[3] addresses) private view {require(msg.sender == addresses[1]);}
853 
854     function getPaymentStatus(bytes32 paymentId)
855     private view returns (PaymentStatus) {
856         return PaymentStatus(lib.getPaymentStatus(paymentId));
857     }
858 
859     function setPaymentStatus(bytes32 paymentId, PaymentStatus status)
860     private {
861         lib.setPaymentStatus(paymentId, uint8(status));
862     }
863 
864     function checkStatus(bytes32 paymentId, PaymentStatus status)
865     private view {
866         require(lib.getPaymentStatus(paymentId) == uint8(status), "Required status does not match actual one");
867     }
868 
869     function doCancelOffer(address[3] addresses, bytes32 deal, uint256 amount, address from)
870     private returns(bytes32 paymentId) {
871         onlyParties(addresses);
872         paymentId = getPaymentId(addresses, deal, amount);
873         checkStatus(paymentId, PaymentStatus.CONFIRMED);
874         uint256 offerAmount = lib.getOfferAmount(paymentId, from);
875         require(offerAmount != 0, "Sender can not cancel offer of 0");
876         lib.setOfferAmount(paymentId, from, 0);
877     }
878 
879     /** @param addresses [depositor, beneficiary, token]
880       * @param amounts [releaseAmount, refundAmount]
881       */
882     function doRelease(address[3] addresses, uint256[2] amounts, bytes32 paymentId)
883     private {
884         setPaymentStatus(paymentId, PaymentStatus.RELEASED);
885         lib.setWithdrawAmount(paymentId, getBeneficiary(addresses), amounts[0]);
886         lib.setWithdrawAmount(paymentId, getDepositor(addresses), amounts[1]);
887     }
888 
889     function transferWithFee(address to, uint256 amount, address token, bytes32 paymentId)
890     private returns (uint256 amountMinusFee) {
891         require(amount != 0, "There is sense to invoke this method if withdraw amount is 0.");
892         uint8 fee = 0;
893         if (!lib.isFeePayed(paymentId)) {
894             fee = lib.getPaymentFee(paymentId);
895         }
896         amountMinusFee = amount - calcFee(amount, fee);
897         transfer(to, amountMinusFee, token);
898     }
899 
900     function transfer(address to, uint256 amount, address token)
901     private {
902         if (amount == 0) {
903             return;
904         }
905         if (token == address(0)) {
906             require(PaymentHolder(paymentHolder).withdrawEth(to, amount), "Error during withdraw ETH");
907         } else {
908             require(PaymentHolder(paymentHolder).withdrawToken(to, amount, token), "Error during withdraw Token");
909         }
910     }
911 
912     function calcFee(uint amount, uint fee)
913     private pure returns (uint256) {
914         return ((amount * fee) / 100);
915     }
916 }