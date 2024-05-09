1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
120 
121 /**
122  * @title Pausable
123  * @dev Base contract which allows children to implement an emergency stop mechanism.
124  */
125 contract Pausable is Ownable {
126   event Pause();
127   event Unpause();
128 
129   bool public paused = false;
130 
131 
132   /**
133    * @dev Modifier to make a function callable only when the contract is not paused.
134    */
135   modifier whenNotPaused() {
136     require(!paused);
137     _;
138   }
139 
140   /**
141    * @dev Modifier to make a function callable only when the contract is paused.
142    */
143   modifier whenPaused() {
144     require(paused);
145     _;
146   }
147 
148   /**
149    * @dev called by the owner to pause, triggers stopped state
150    */
151   function pause() public onlyOwner whenNotPaused {
152     paused = true;
153     emit Pause();
154   }
155 
156   /**
157    * @dev called by the owner to unpause, returns to normal state
158    */
159   function unpause() public onlyOwner whenPaused {
160     paused = false;
161     emit Unpause();
162   }
163 }
164 
165 // File: openzeppelin-solidity/contracts/lifecycle/Destructible.sol
166 
167 /**
168  * @title Destructible
169  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
170  */
171 contract Destructible is Ownable {
172   /**
173    * @dev Transfers the current balance to the owner and terminates the contract.
174    */
175   function destroy() public onlyOwner {
176     selfdestruct(owner);
177   }
178 
179   function destroyAndSend(address _recipient) public onlyOwner {
180     selfdestruct(_recipient);
181   }
182 }
183 
184 // File: openzeppelin-solidity/contracts/ownership/Contactable.sol
185 
186 /**
187  * @title Contactable token
188  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
189  * contact information.
190  */
191 contract Contactable is Ownable {
192 
193   string public contactInformation;
194 
195   /**
196     * @dev Allows the owner to set a string with their contact information.
197     * @param _info The contact information to attach to the contract.
198     */
199   function setContactInformation(string _info) public onlyOwner {
200     contactInformation = _info;
201   }
202 }
203 
204 // File: monetha-utility-contracts/contracts/Restricted.sol
205 
206 /** @title Restricted
207  *  Exposes onlyMonetha modifier
208  */
209 contract Restricted is Ownable {
210 
211     //MonethaAddress set event
212     event MonethaAddressSet(
213         address _address,
214         bool _isMonethaAddress
215     );
216 
217     mapping (address => bool) public isMonethaAddress;
218 
219     /**
220      *  Restrict methods in such way, that they can be invoked only by monethaAddress account.
221      */
222     modifier onlyMonetha() {
223         require(isMonethaAddress[msg.sender]);
224         _;
225     }
226 
227     /**
228      *  Allows owner to set new monetha address
229      */
230     function setMonethaAddress(address _address, bool _isMonethaAddress) onlyOwner public {
231         isMonethaAddress[_address] = _isMonethaAddress;
232 
233         emit MonethaAddressSet(_address, _isMonethaAddress);
234     }
235 }
236 
237 // File: monetha-loyalty-contracts/contracts/IMonethaVoucher.sol
238 
239 interface IMonethaVoucher {
240     /**
241     * @dev Total number of vouchers in shared pool
242     */
243     function totalInSharedPool() external view returns (uint256);
244 
245     /**
246      * @dev Converts vouchers to equivalent amount of wei.
247      * @param _value amount of vouchers (vouchers) to convert to amount of wei
248      * @return A uint256 specifying the amount of wei.
249      */
250     function toWei(uint256 _value) external view returns (uint256);
251 
252     /**
253      * @dev Converts amount of wei to equivalent amount of vouchers.
254      * @param _value amount of wei to convert to vouchers (vouchers)
255      * @return A uint256 specifying the amount of vouchers.
256      */
257     function fromWei(uint256 _value) external view returns (uint256);
258 
259     /**
260      * @dev Applies discount for address by returning vouchers to shared pool and transferring funds (in wei). May be called only by Monetha.
261      * @param _for address to apply discount for
262      * @param _vouchers amount of vouchers to return to shared pool
263      * @return Actual number of vouchers returned to shared pool and amount of funds (in wei) transferred.
264      */
265     function applyDiscount(address _for, uint256 _vouchers) external returns (uint256 amountVouchers, uint256 amountWei);
266 
267     /**
268      * @dev Applies payback by transferring vouchers from the shared pool to the user.
269      * The amount of transferred vouchers is equivalent to the amount of Ether in the `_amountWei` parameter.
270      * @param _for address to apply payback for
271      * @param _amountWei amount of Ether to estimate the amount of vouchers
272      * @return The number of vouchers added
273      */
274     function applyPayback(address _for, uint256 _amountWei) external returns (uint256 amountVouchers);
275 
276     /**
277      * @dev Function to buy vouchers by transferring equivalent amount in Ether to contract. May be called only by Monetha.
278      * After the vouchers are purchased, they can be sold or released to another user. Purchased vouchers are stored in
279      * a separate pool and may not be expired.
280      * @param _vouchers The amount of vouchers to buy. The caller must also transfer an equivalent amount of Ether.
281      */
282     function buyVouchers(uint256 _vouchers) external payable;
283 
284     /**
285      * @dev The function allows Monetha account to sell previously purchased vouchers and get Ether from the sale.
286      * The equivalent amount of Ether will be transferred to the caller. May be called only by Monetha.
287      * @param _vouchers The amount of vouchers to sell.
288      * @return A uint256 specifying the amount of Ether (in wei) transferred to the caller.
289      */
290     function sellVouchers(uint256 _vouchers) external returns(uint256 weis);
291 
292     /**
293      * @dev Function allows Monetha account to release the purchased vouchers to any address.
294      * The released voucher acquires an expiration property and should be used in Monetha ecosystem within 6 months, otherwise
295      * it will be returned to shared pool. May be called only by Monetha.
296      * @param _to address to release vouchers to.
297      * @param _value the amount of vouchers to release.
298      */
299     function releasePurchasedTo(address _to, uint256 _value) external returns (bool);
300 
301     /**
302      * @dev Function to check the amount of vouchers that an owner (Monetha account) allowed to sell or release to some user.
303      * @param owner The address which owns the funds.
304      * @return A uint256 specifying the amount of vouchers still available for the owner.
305      */
306     function purchasedBy(address owner) external view returns (uint256);
307 }
308 
309 // File: contracts/GenericERC20.sol
310 
311 /**
312 * @title GenericERC20 interface
313 */
314 contract GenericERC20 {
315     function totalSupply() public view returns (uint256);
316 
317     function decimals() public view returns(uint256);
318 
319     function balanceOf(address _who) public view returns (uint256);
320 
321     function allowance(address _owner, address _spender)
322         public view returns (uint256);
323         
324     // Return type not defined intentionally since not all ERC20 tokens return proper result type
325     function transfer(address _to, uint256 _value) public;
326 
327     function approve(address _spender, uint256 _value)
328         public returns (bool);
329 
330     function transferFrom(address _from, address _to, uint256 _value)
331         public returns (bool);
332 
333     event Transfer(
334         address indexed from,
335         address indexed to,
336         uint256 value
337     );
338 
339     event Approval(
340         address indexed owner,
341         address indexed spender,
342         uint256 value
343     );
344 }
345 
346 // File: contracts/MonethaGateway.sol
347 
348 /**
349  *  @title MonethaGateway
350  *
351  *  MonethaGateway forward funds from order payment to merchant's wallet and collects Monetha fee.
352  */
353 contract MonethaGateway is Pausable, Contactable, Destructible, Restricted {
354 
355     using SafeMath for uint256;
356 
357     string constant VERSION = "0.6";
358 
359     /**
360      *  Fee permille of Monetha fee.
361      *  1 permille (‰) = 0.1 percent (%)
362      *  15‰ = 1.5%
363      */
364     uint public constant FEE_PERMILLE = 15;
365 
366 
367     uint public constant PERMILLE_COEFFICIENT = 1000;
368 
369     /**
370      *  Address of Monetha Vault for fee collection
371      */
372     address public monethaVault;
373 
374     /**
375      *  Account for permissions managing
376      */
377     address public admin;
378 
379     /**
380      * Monetha voucher contract
381      */
382     IMonethaVoucher public monethaVoucher;
383 
384     /**
385      *  Max. discount permille.
386      *  10 permille = 1 %
387      */
388     uint public MaxDiscountPermille;
389 
390     event PaymentProcessedEther(address merchantWallet, uint merchantIncome, uint monethaIncome);
391     event PaymentProcessedToken(address tokenAddress, address merchantWallet, uint merchantIncome, uint monethaIncome);
392     event MonethaVoucherChanged(
393         address indexed previousMonethaVoucher,
394         address indexed newMonethaVoucher
395     );
396     event MaxDiscountPermilleChanged(uint prevPermilleValue, uint newPermilleValue);
397 
398     /**
399      *  @param _monethaVault Address of Monetha Vault
400      */
401     constructor(address _monethaVault, address _admin, IMonethaVoucher _monethaVoucher) public {
402         require(_monethaVault != 0x0);
403         monethaVault = _monethaVault;
404 
405         setAdmin(_admin);
406         setMonethaVoucher(_monethaVoucher);
407         setMaxDiscountPermille(700); // 70%
408     }
409 
410     /**
411      *  acceptPayment accept payment from PaymentAcceptor, forwards it to merchant's wallet
412      *      and collects Monetha fee.
413      *  @param _merchantWallet address of merchant's wallet for fund transfer
414      *  @param _monethaFee is a fee collected by Monetha
415      */
416     /**
417      *  acceptPayment accept payment from PaymentAcceptor, forwards it to merchant's wallet
418      *      and collects Monetha fee.
419      *  @param _merchantWallet address of merchant's wallet for fund transfer
420      *  @param _monethaFee is a fee collected by Monetha
421      */
422     function acceptPayment(address _merchantWallet,
423         uint _monethaFee,
424         address _customerAddress,
425         uint _vouchersApply,
426         uint _paybackPermille)
427     external payable onlyMonetha whenNotPaused returns (uint discountWei){
428         require(_merchantWallet != 0x0);
429         uint price = msg.value;
430         // Monetha fee cannot be greater than 1.5% of payment
431         require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(price).div(1000));
432 
433         discountWei = 0;
434         if (monethaVoucher != address(0)) {
435             if (_vouchersApply > 0 && MaxDiscountPermille > 0) {
436                 uint maxDiscountWei = price.mul(MaxDiscountPermille).div(PERMILLE_COEFFICIENT);
437                 uint maxVouchers = monethaVoucher.fromWei(maxDiscountWei);
438                 // limit vouchers to apply
439                 uint vouchersApply = _vouchersApply;
440                 if (vouchersApply > maxVouchers) {
441                     vouchersApply = maxVouchers;
442                 }
443 
444                 (, discountWei) = monethaVoucher.applyDiscount(_customerAddress, vouchersApply);
445             }
446 
447             if (_paybackPermille > 0) {
448                 uint paybackWei = price.sub(discountWei).mul(_paybackPermille).div(PERMILLE_COEFFICIENT);
449                 if (paybackWei > 0) {
450                     monethaVoucher.applyPayback(_customerAddress, paybackWei);
451                 }
452             }
453         }
454 
455         uint merchantIncome = price.sub(_monethaFee);
456 
457         _merchantWallet.transfer(merchantIncome);
458         monethaVault.transfer(_monethaFee);
459 
460         emit PaymentProcessedEther(_merchantWallet, merchantIncome, _monethaFee);
461     }
462 
463     /**
464      *  acceptTokenPayment accept token payment from PaymentAcceptor, forwards it to merchant's wallet
465      *      and collects Monetha fee.
466      *  @param _merchantWallet address of merchant's wallet for fund transfer
467      *  @param _monethaFee is a fee collected by Monetha
468      *  @param _tokenAddress is the token address
469      *  @param _value is the order value
470      */
471     function acceptTokenPayment(
472         address _merchantWallet,
473         uint _monethaFee,
474         address _tokenAddress,
475         uint _value
476     )
477     external onlyMonetha whenNotPaused
478     {
479         require(_merchantWallet != 0x0);
480 
481         // Monetha fee cannot be greater than 1.5% of payment
482         require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(_value).div(1000));
483 
484         uint merchantIncome = _value.sub(_monethaFee);
485 
486         GenericERC20(_tokenAddress).transfer(_merchantWallet, merchantIncome);
487         GenericERC20(_tokenAddress).transfer(monethaVault, _monethaFee);
488 
489         emit PaymentProcessedToken(_tokenAddress, _merchantWallet, merchantIncome, _monethaFee);
490     }
491 
492     /**
493      *  changeMonethaVault allows owner to change address of Monetha Vault.
494      *  @param newVault New address of Monetha Vault
495      */
496     function changeMonethaVault(address newVault) external onlyOwner whenNotPaused {
497         monethaVault = newVault;
498     }
499 
500     /**
501      *  Allows other monetha account or contract to set new monetha address
502      */
503     function setMonethaAddress(address _address, bool _isMonethaAddress) public {
504         require(msg.sender == admin || msg.sender == owner);
505 
506         isMonethaAddress[_address] = _isMonethaAddress;
507 
508         emit MonethaAddressSet(_address, _isMonethaAddress);
509     }
510 
511     /**
512      *  setAdmin allows owner to change address of admin.
513      *  @param _admin New address of admin
514      */
515     function setAdmin(address _admin) public onlyOwner {
516         require(_admin != address(0));
517         admin = _admin;
518     }
519 
520     /**
521      *  setAdmin allows owner to change address of Monetha voucher contract. If set to 0x0 address, discounts and paybacks are disabled.
522      *  @param _monethaVoucher New address of Monetha voucher contract
523      */
524     function setMonethaVoucher(IMonethaVoucher _monethaVoucher) public onlyOwner {
525         if (monethaVoucher != _monethaVoucher) {
526             emit MonethaVoucherChanged(monethaVoucher, _monethaVoucher);
527             monethaVoucher = _monethaVoucher;
528         }
529     }
530 
531     /**
532      *  setMaxDiscountPermille allows Monetha to change max.discount percentage
533      *  @param _maxDiscountPermille New value of max.discount (in permille)
534      */
535     function setMaxDiscountPermille(uint _maxDiscountPermille) public onlyOwner {
536         require(_maxDiscountPermille <= PERMILLE_COEFFICIENT);
537         emit MaxDiscountPermilleChanged(MaxDiscountPermille, _maxDiscountPermille);
538         MaxDiscountPermille = _maxDiscountPermille;
539     }
540 }
541 
542 // File: contracts/MerchantDealsHistory.sol
543 
544 /**
545  *  @title MerchantDealsHistory
546  *  Contract stores hash of Deals conditions together with parties reputation for each deal
547  *  This history enables to see evolution of trust rating for both parties
548  */
549 contract MerchantDealsHistory is Contactable, Restricted {
550 
551     string constant VERSION = "0.3";
552 
553     ///  Merchant identifier hash
554     bytes32 public merchantIdHash;
555     
556     //Deal event
557     event DealCompleted(
558         uint orderId,
559         address clientAddress,
560         uint32 clientReputation,
561         uint32 merchantReputation,
562         bool successful,
563         uint dealHash
564     );
565 
566     //Deal cancellation event
567     event DealCancelationReason(
568         uint orderId,
569         address clientAddress,
570         uint32 clientReputation,
571         uint32 merchantReputation,
572         uint dealHash,
573         string cancelReason
574     );
575 
576     //Deal refund event
577     event DealRefundReason(
578         uint orderId,
579         address clientAddress,
580         uint32 clientReputation,
581         uint32 merchantReputation,
582         uint dealHash,
583         string refundReason
584     );
585 
586     /**
587      *  @param _merchantId Merchant of the acceptor
588      */
589     constructor(string _merchantId) public {
590         require(bytes(_merchantId).length > 0);
591         merchantIdHash = keccak256(abi.encodePacked(_merchantId));
592     }
593 
594     /**
595      *  recordDeal creates an event of completed deal
596      *  @param _orderId Identifier of deal's order
597      *  @param _clientAddress Address of client's account
598      *  @param _clientReputation Updated reputation of the client
599      *  @param _merchantReputation Updated reputation of the merchant
600      *  @param _isSuccess Identifies whether deal was successful or not
601      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
602      */
603     function recordDeal(
604         uint _orderId,
605         address _clientAddress,
606         uint32 _clientReputation,
607         uint32 _merchantReputation,
608         bool _isSuccess,
609         uint _dealHash)
610         external onlyMonetha
611     {
612         emit DealCompleted(
613             _orderId,
614             _clientAddress,
615             _clientReputation,
616             _merchantReputation,
617             _isSuccess,
618             _dealHash
619         );
620     }
621 
622     /**
623      *  recordDealCancelReason creates an event of not paid deal that was cancelled 
624      *  @param _orderId Identifier of deal's order
625      *  @param _clientAddress Address of client's account
626      *  @param _clientReputation Updated reputation of the client
627      *  @param _merchantReputation Updated reputation of the merchant
628      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
629      *  @param _cancelReason deal cancelation reason (text)
630      */
631     function recordDealCancelReason(
632         uint _orderId,
633         address _clientAddress,
634         uint32 _clientReputation,
635         uint32 _merchantReputation,
636         uint _dealHash,
637         string _cancelReason)
638         external onlyMonetha
639     {
640         emit DealCancelationReason(
641             _orderId,
642             _clientAddress,
643             _clientReputation,
644             _merchantReputation,
645             _dealHash,
646             _cancelReason
647         );
648     }
649 
650 /**
651      *  recordDealRefundReason creates an event of not paid deal that was cancelled 
652      *  @param _orderId Identifier of deal's order
653      *  @param _clientAddress Address of client's account
654      *  @param _clientReputation Updated reputation of the client
655      *  @param _merchantReputation Updated reputation of the merchant
656      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
657      *  @param _refundReason deal refund reason (text)
658      */
659     function recordDealRefundReason(
660         uint _orderId,
661         address _clientAddress,
662         uint32 _clientReputation,
663         uint32 _merchantReputation,
664         uint _dealHash,
665         string _refundReason)
666         external onlyMonetha
667     {
668         emit DealRefundReason(
669             _orderId,
670             _clientAddress,
671             _clientReputation,
672             _merchantReputation,
673             _dealHash,
674             _refundReason
675         );
676     }
677 }
678 
679 // File: monetha-utility-contracts/contracts/SafeDestructible.sol
680 
681 /**
682  * @title SafeDestructible
683  * Base contract that can be destroyed by owner.
684  * Can be destructed if there are no funds on contract balance.
685  */
686 contract SafeDestructible is Ownable {
687     function destroy() onlyOwner public {
688         require(address(this).balance == 0);
689         selfdestruct(owner);
690     }
691 }
692 
693 // File: contracts/MerchantWallet.sol
694 
695 /**
696  *  @title MerchantWallet
697  *  Serves as a public Merchant profile with merchant profile info,
698  *      payment settings and latest reputation value.
699  *  Also MerchantWallet accepts payments for orders.
700  */
701 
702 contract MerchantWallet is Pausable, SafeDestructible, Contactable, Restricted {
703 
704     string constant VERSION = "0.5";
705 
706     /// Address of merchant's account, that can withdraw from wallet
707     address public merchantAccount;
708 
709     /// Address of merchant's fund address.
710     address public merchantFundAddress;
711 
712     /// Unique Merchant identifier hash
713     bytes32 public merchantIdHash;
714 
715     /// profileMap stores general information about the merchant
716     mapping (string=>string) profileMap;
717 
718     /// paymentSettingsMap stores payment and order settings for the merchant
719     mapping (string=>string) paymentSettingsMap;
720 
721     /// compositeReputationMap stores composite reputation, that compraises from several metrics
722     mapping (string=>uint32) compositeReputationMap;
723 
724     /// number of last digits in compositeReputation for fractional part
725     uint8 public constant REPUTATION_DECIMALS = 4;
726 
727     /**
728      *  Restrict methods in such way, that they can be invoked only by merchant account.
729      */
730     modifier onlyMerchant() {
731         require(msg.sender == merchantAccount);
732         _;
733     }
734 
735     /**
736      *  Fund Address should always be Externally Owned Account and not a contract.
737      */
738     modifier isEOA(address _fundAddress) {
739         uint256 _codeLength;
740         assembly {_codeLength := extcodesize(_fundAddress)}
741         require(_codeLength == 0, "sorry humans only");
742         _;
743     }
744 
745     /**
746      *  Restrict methods in such way, that they can be invoked only by merchant account or by monethaAddress account.
747      */
748     modifier onlyMerchantOrMonetha() {
749         require(msg.sender == merchantAccount || isMonethaAddress[msg.sender]);
750         _;
751     }
752 
753     /**
754      *  @param _merchantAccount Address of merchant's account, that can withdraw from wallet
755      *  @param _merchantId Merchant identifier
756      *  @param _fundAddress Merchant's fund address, where amount will be transferred.
757      */
758     constructor(address _merchantAccount, string _merchantId, address _fundAddress) public isEOA(_fundAddress) {
759         require(_merchantAccount != 0x0);
760         require(bytes(_merchantId).length > 0);
761 
762         merchantAccount = _merchantAccount;
763         merchantIdHash = keccak256(abi.encodePacked(_merchantId));
764 
765         merchantFundAddress = _fundAddress;
766     }
767 
768     /**
769      *  Accept payment from MonethaGateway
770      */
771     function () external payable {
772     }
773 
774     /**
775      *  @return profile info by string key
776      */
777     function profile(string key) external constant returns (string) {
778         return profileMap[key];
779     }
780 
781     /**
782      *  @return payment setting by string key
783      */
784     function paymentSettings(string key) external constant returns (string) {
785         return paymentSettingsMap[key];
786     }
787 
788     /**
789      *  @return composite reputation value by string key
790      */
791     function compositeReputation(string key) external constant returns (uint32) {
792         return compositeReputationMap[key];
793     }
794 
795     /**
796      *  Set profile info by string key
797      */
798     function setProfile(
799         string profileKey,
800         string profileValue,
801         string repKey,
802         uint32 repValue
803     )
804         external onlyOwner
805     {
806         profileMap[profileKey] = profileValue;
807 
808         if (bytes(repKey).length != 0) {
809             compositeReputationMap[repKey] = repValue;
810         }
811     }
812 
813     /**
814      *  Set payment setting by string key
815      */
816     function setPaymentSettings(string key, string value) external onlyOwner {
817         paymentSettingsMap[key] = value;
818     }
819 
820     /**
821      *  Set composite reputation value by string key
822      */
823     function setCompositeReputation(string key, uint32 value) external onlyMonetha {
824         compositeReputationMap[key] = value;
825     }
826 
827     /**
828      *  Allows withdrawal of funds to beneficiary address
829      */
830     function doWithdrawal(address beneficiary, uint amount) private {
831         require(beneficiary != 0x0);
832         beneficiary.transfer(amount);
833     }
834 
835     /**
836      *  Allows merchant to withdraw funds to beneficiary address
837      */
838     function withdrawTo(address beneficiary, uint amount) public onlyMerchant whenNotPaused {
839         doWithdrawal(beneficiary, amount);
840     }
841 
842     /**
843      *  Allows merchant to withdraw funds to it's own account
844      */
845     function withdraw(uint amount) external onlyMerchant {
846         withdrawTo(msg.sender, amount);
847     }
848 
849     /**
850      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing funds to deposit address of the exchange
851      */
852     function withdrawToExchange(address depositAccount, uint amount) external onlyMerchantOrMonetha whenNotPaused {
853         doWithdrawal(depositAccount, amount);
854     }
855 
856     /**
857      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing all funds to deposit address of the exchange
858      */
859     function withdrawAllToExchange(address depositAccount, uint min_amount) external onlyMerchantOrMonetha whenNotPaused {
860         require (address(this).balance >= min_amount);
861         doWithdrawal(depositAccount, address(this).balance);
862     }
863 
864     /**
865      *  Allows merchant or Monetha to initiate exchange of tokens by withdrawing all tokens to deposit address of the exchange
866      */
867     function withdrawAllTokensToExchange(address _tokenAddress, address _depositAccount, uint _minAmount) external onlyMerchantOrMonetha whenNotPaused {
868         require(_tokenAddress != address(0));
869         
870         uint balance = GenericERC20(_tokenAddress).balanceOf(address(this));
871         
872         require(balance >= _minAmount);
873         
874         GenericERC20(_tokenAddress).transfer(_depositAccount, balance);
875     }
876 
877     /**
878      *  Allows merchant to change it's account address
879      */
880     function changeMerchantAccount(address newAccount) external onlyMerchant whenNotPaused {
881         merchantAccount = newAccount;
882     }
883 
884     /**
885      *  Allows merchant to change it's fund address.
886      */
887     function changeFundAddress(address newFundAddress) external onlyMerchant isEOA(newFundAddress) {
888         merchantFundAddress = newFundAddress;
889     }
890 }
891 
892 // File: contracts/PaymentProcessor.sol
893 
894 /**
895  *  @title PaymentProcessor
896  *  Each Merchant has one PaymentProcessor that ensure payment and order processing with Trust and Reputation
897  *
898  *  Payment Processor State Transitions:
899  *  Null -(addOrder) -> Created
900  *  Created -(securePay) -> Paid
901  *  Created -(cancelOrder) -> Cancelled
902  *  Paid -(refundPayment) -> Refunding
903  *  Paid -(processPayment) -> Finalized
904  *  Refunding -(withdrawRefund) -> Refunded
905  */
906 
907 
908 contract PaymentProcessor is Pausable, Destructible, Contactable, Restricted {
909 
910     using SafeMath for uint256;
911 
912     string constant VERSION = "0.7";
913 
914     /**
915      *  Fee permille of Monetha fee.
916      *  1 permille = 0.1 %
917      *  15 permille = 1.5%
918      */
919     uint public constant FEE_PERMILLE = 15;
920 
921     /**
922      *  Payback permille.
923      *  1 permille = 0.1 %
924      */
925     uint public constant PAYBACK_PERMILLE = 2; // 0.2%
926 
927     uint public constant PERMILLE_COEFFICIENT = 1000;
928 
929     /// MonethaGateway contract for payment processing
930     MonethaGateway public monethaGateway;
931 
932     /// MerchantDealsHistory contract of acceptor's merchant
933     MerchantDealsHistory public merchantHistory;
934 
935     /// Address of MerchantWallet, where merchant reputation and funds are stored
936     MerchantWallet public merchantWallet;
937 
938     /// Merchant identifier hash, that associates with the acceptor
939     bytes32 public merchantIdHash;
940 
941     enum State {Null, Created, Paid, Finalized, Refunding, Refunded, Cancelled}
942 
943     struct Order {
944         State state;
945         uint price;
946         uint fee;
947         address paymentAcceptor;
948         address originAddress;
949         address tokenAddress;
950         uint vouchersApply;
951         uint discount;
952     }
953 
954     mapping(uint => Order) public orders;
955 
956     /**
957      *  Asserts current state.
958      *  @param _state Expected state
959      *  @param _orderId Order Id
960      */
961     modifier atState(uint _orderId, State _state) {
962         require(_state == orders[_orderId].state);
963         _;
964     }
965 
966     /**
967      *  Performs a transition after function execution.
968      *  @param _state Next state
969      *  @param _orderId Order Id
970      */
971     modifier transition(uint _orderId, State _state) {
972         _;
973         orders[_orderId].state = _state;
974     }
975 
976     /**
977      *  payment Processor sets Monetha Gateway
978      *  @param _merchantId Merchant of the acceptor
979      *  @param _merchantHistory Address of MerchantDealsHistory contract of acceptor's merchant
980      *  @param _monethaGateway Address of MonethaGateway contract for payment processing
981      *  @param _merchantWallet Address of MerchantWallet, where merchant reputation and funds are stored
982      */
983     constructor(
984         string _merchantId,
985         MerchantDealsHistory _merchantHistory,
986         MonethaGateway _monethaGateway,
987         MerchantWallet _merchantWallet
988     )
989     public
990     {
991         require(bytes(_merchantId).length > 0);
992 
993         merchantIdHash = keccak256(abi.encodePacked(_merchantId));
994 
995         setMonethaGateway(_monethaGateway);
996         setMerchantWallet(_merchantWallet);
997         setMerchantDealsHistory(_merchantHistory);
998     }
999 
1000     /**
1001      *  Assigns the acceptor to the order (when client initiates order).
1002      *  @param _orderId Identifier of the order
1003      *  @param _price Price of the order 
1004      *  @param _paymentAcceptor order payment acceptor
1005      *  @param _originAddress buyer address
1006      *  @param _fee Monetha fee
1007      */
1008     function addOrder(
1009         uint _orderId,
1010         uint _price,
1011         address _paymentAcceptor,
1012         address _originAddress,
1013         uint _fee,
1014         address _tokenAddress,
1015         uint _vouchersApply
1016     ) external whenNotPaused atState(_orderId, State.Null)
1017     {
1018         require(_orderId > 0);
1019         require(_price > 0);
1020         require(_fee >= 0 && _fee <= FEE_PERMILLE.mul(_price).div(PERMILLE_COEFFICIENT));
1021         // Monetha fee cannot be greater than 1.5% of price
1022         require(_paymentAcceptor != address(0));
1023         require(_originAddress != address(0));
1024         require(orders[_orderId].price == 0 && orders[_orderId].fee == 0);
1025 
1026         orders[_orderId] = Order({
1027             state : State.Created,
1028             price : _price,
1029             fee : _fee,
1030             paymentAcceptor : _paymentAcceptor,
1031             originAddress : _originAddress,
1032             tokenAddress : _tokenAddress,
1033             vouchersApply : _vouchersApply,
1034             discount: 0
1035             });
1036     }
1037 
1038     /**
1039      *  securePay can be used by client if he wants to securely set client address for refund together with payment.
1040      *  This function require more gas, then fallback function.
1041      *  @param _orderId Identifier of the order
1042      */
1043     function securePay(uint _orderId)
1044     external payable whenNotPaused
1045     atState(_orderId, State.Created) transition(_orderId, State.Paid)
1046     {
1047         Order storage order = orders[_orderId];
1048 
1049         require(order.tokenAddress == address(0));
1050         require(msg.sender == order.paymentAcceptor);
1051         require(msg.value == order.price);
1052     }
1053 
1054     /**
1055      *  secureTokenPay can be used by client if he wants to securely set client address for token refund together with token payment.
1056      *  This call requires that token's approve method has been called prior to this.
1057      *  @param _orderId Identifier of the order
1058      */
1059     function secureTokenPay(uint _orderId)
1060     external whenNotPaused
1061     atState(_orderId, State.Created) transition(_orderId, State.Paid)
1062     {
1063         Order storage order = orders[_orderId];
1064 
1065         require(msg.sender == order.paymentAcceptor);
1066         require(order.tokenAddress != address(0));
1067 
1068         GenericERC20(order.tokenAddress).transferFrom(msg.sender, address(this), order.price);
1069     }
1070 
1071     /**
1072      *  cancelOrder is used when client doesn't pay and order need to be cancelled.
1073      *  @param _orderId Identifier of the order
1074      *  @param _clientReputation Updated reputation of the client
1075      *  @param _merchantReputation Updated reputation of the merchant
1076      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
1077      *  @param _cancelReason Order cancel reason
1078      */
1079     function cancelOrder(
1080         uint _orderId,
1081         uint32 _clientReputation,
1082         uint32 _merchantReputation,
1083         uint _dealHash,
1084         string _cancelReason
1085     )
1086     external onlyMonetha whenNotPaused
1087     atState(_orderId, State.Created) transition(_orderId, State.Cancelled)
1088     {
1089         require(bytes(_cancelReason).length > 0);
1090 
1091         Order storage order = orders[_orderId];
1092 
1093         updateDealConditions(
1094             _orderId,
1095             _clientReputation,
1096             _merchantReputation,
1097             false,
1098             _dealHash
1099         );
1100 
1101         merchantHistory.recordDealCancelReason(
1102             _orderId,
1103             order.originAddress,
1104             _clientReputation,
1105             _merchantReputation,
1106             _dealHash,
1107             _cancelReason
1108         );
1109     }
1110 
1111     /**
1112      *  refundPayment used in case order cannot be processed.
1113      *  This function initiate process of funds refunding to the client.
1114      *  @param _orderId Identifier of the order
1115      *  @param _clientReputation Updated reputation of the client
1116      *  @param _merchantReputation Updated reputation of the merchant
1117      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
1118      *  @param _refundReason Order refund reason, order will be moved to State Cancelled after Client withdraws money
1119      */
1120     function refundPayment(
1121         uint _orderId,
1122         uint32 _clientReputation,
1123         uint32 _merchantReputation,
1124         uint _dealHash,
1125         string _refundReason
1126     )
1127     external onlyMonetha whenNotPaused
1128     atState(_orderId, State.Paid) transition(_orderId, State.Refunding)
1129     {
1130         require(bytes(_refundReason).length > 0);
1131 
1132         Order storage order = orders[_orderId];
1133 
1134         updateDealConditions(
1135             _orderId,
1136             _clientReputation,
1137             _merchantReputation,
1138             false,
1139             _dealHash
1140         );
1141 
1142         merchantHistory.recordDealRefundReason(
1143             _orderId,
1144             order.originAddress,
1145             _clientReputation,
1146             _merchantReputation,
1147             _dealHash,
1148             _refundReason
1149         );
1150     }
1151 
1152     /**
1153      *  withdrawRefund performs fund transfer to the client's account.
1154      *  @param _orderId Identifier of the order
1155      */
1156     function withdrawRefund(uint _orderId)
1157     external whenNotPaused
1158     atState(_orderId, State.Refunding) transition(_orderId, State.Refunded)
1159     {
1160         Order storage order = orders[_orderId];
1161         require(order.tokenAddress == address(0));
1162 
1163         order.originAddress.transfer(order.price.sub(order.discount));
1164     }
1165 
1166     /**
1167      *  withdrawTokenRefund performs token transfer to the client's account.
1168      *  @param _orderId Identifier of the order
1169      */
1170     function withdrawTokenRefund(uint _orderId)
1171     external whenNotPaused
1172     atState(_orderId, State.Refunding) transition(_orderId, State.Refunded)
1173     {
1174         require(orders[_orderId].tokenAddress != address(0));
1175 
1176         GenericERC20(orders[_orderId].tokenAddress).transfer(orders[_orderId].originAddress, orders[_orderId].price);
1177     }
1178 
1179     /**
1180      *  processPayment transfer funds/tokens to MonethaGateway and completes the order.
1181      *  @param _orderId Identifier of the order
1182      *  @param _clientReputation Updated reputation of the client
1183      *  @param _merchantReputation Updated reputation of the merchant
1184      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
1185      */
1186     function processPayment(
1187         uint _orderId,
1188         uint32 _clientReputation,
1189         uint32 _merchantReputation,
1190         uint _dealHash
1191     )
1192     external onlyMonetha whenNotPaused
1193     atState(_orderId, State.Paid) transition(_orderId, State.Finalized)
1194     {
1195         Order storage order = orders[_orderId];
1196         address fundAddress = merchantWallet.merchantFundAddress();
1197 
1198         if (order.tokenAddress != address(0)) {
1199             if (fundAddress != address(0)) {
1200                 GenericERC20(order.tokenAddress).transfer(address(monethaGateway), order.price);
1201                 monethaGateway.acceptTokenPayment(fundAddress, order.fee, order.tokenAddress, order.price);
1202             } else {
1203                 GenericERC20(order.tokenAddress).transfer(address(monethaGateway), order.price);
1204                 monethaGateway.acceptTokenPayment(merchantWallet, order.fee, order.tokenAddress, order.price);
1205             }
1206         } else {
1207             uint discountWei = 0;
1208             if (fundAddress != address(0)) {
1209                 discountWei = monethaGateway.acceptPayment.value(order.price)(
1210                     fundAddress,
1211                     order.fee,
1212                     order.originAddress,
1213                     order.vouchersApply,
1214                     PAYBACK_PERMILLE);
1215             } else {
1216                 discountWei = monethaGateway.acceptPayment.value(order.price)(
1217                     merchantWallet,
1218                     order.fee,
1219                     order.originAddress,
1220                     order.vouchersApply,
1221                     PAYBACK_PERMILLE);
1222             }
1223 
1224             if (discountWei > 0) {
1225                 order.discount = discountWei;
1226             }
1227         }
1228 
1229         updateDealConditions(
1230             _orderId,
1231             _clientReputation,
1232             _merchantReputation,
1233             true,
1234             _dealHash
1235         );
1236     }
1237 
1238     /**
1239      *  setMonethaGateway allows owner to change address of MonethaGateway.
1240      *  @param _newGateway Address of new MonethaGateway contract
1241      */
1242     function setMonethaGateway(MonethaGateway _newGateway) public onlyOwner {
1243         require(address(_newGateway) != 0x0);
1244 
1245         monethaGateway = _newGateway;
1246     }
1247 
1248     /**
1249      *  setMerchantWallet allows owner to change address of MerchantWallet.
1250      *  @param _newWallet Address of new MerchantWallet contract
1251      */
1252     function setMerchantWallet(MerchantWallet _newWallet) public onlyOwner {
1253         require(address(_newWallet) != 0x0);
1254         require(_newWallet.merchantIdHash() == merchantIdHash);
1255 
1256         merchantWallet = _newWallet;
1257     }
1258 
1259     /**
1260      *  setMerchantDealsHistory allows owner to change address of MerchantDealsHistory.
1261      *  @param _merchantHistory Address of new MerchantDealsHistory contract
1262      */
1263     function setMerchantDealsHistory(MerchantDealsHistory _merchantHistory) public onlyOwner {
1264         require(address(_merchantHistory) != 0x0);
1265         require(_merchantHistory.merchantIdHash() == merchantIdHash);
1266 
1267         merchantHistory = _merchantHistory;
1268     }
1269 
1270     /**
1271      *  updateDealConditions record finalized deal and updates merchant reputation
1272      *  in future: update Client reputation
1273      *  @param _orderId Identifier of the order
1274      *  @param _clientReputation Updated reputation of the client
1275      *  @param _merchantReputation Updated reputation of the merchant
1276      *  @param _isSuccess Identifies whether deal was successful or not
1277      *  @param _dealHash Hashcode of the deal, describing the order (used for deal verification)
1278      */
1279     function updateDealConditions(
1280         uint _orderId,
1281         uint32 _clientReputation,
1282         uint32 _merchantReputation,
1283         bool _isSuccess,
1284         uint _dealHash
1285     )
1286     internal
1287     {
1288         merchantHistory.recordDeal(
1289             _orderId,
1290             orders[_orderId].originAddress,
1291             _clientReputation,
1292             _merchantReputation,
1293             _isSuccess,
1294             _dealHash
1295         );
1296 
1297         //update parties Reputation
1298         merchantWallet.setCompositeReputation("total", _merchantReputation);
1299     }
1300 }