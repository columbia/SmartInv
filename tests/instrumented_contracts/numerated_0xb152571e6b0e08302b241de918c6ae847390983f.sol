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
542 // File: monetha-utility-contracts/contracts/SafeDestructible.sol
543 
544 /**
545  * @title SafeDestructible
546  * Base contract that can be destroyed by owner.
547  * Can be destructed if there are no funds on contract balance.
548  */
549 contract SafeDestructible is Ownable {
550     function destroy() onlyOwner public {
551         require(address(this).balance == 0);
552         selfdestruct(owner);
553     }
554 }
555 
556 // File: contracts/MerchantWallet.sol
557 
558 /**
559  *  @title MerchantWallet
560  *  Serves as a public Merchant profile with merchant profile info,
561  *      payment settings and latest reputation value.
562  *  Also MerchantWallet accepts payments for orders.
563  */
564 
565 contract MerchantWallet is Pausable, SafeDestructible, Contactable, Restricted {
566 
567     string constant VERSION = "0.5";
568 
569     /// Address of merchant's account, that can withdraw from wallet
570     address public merchantAccount;
571 
572     /// Address of merchant's fund address.
573     address public merchantFundAddress;
574 
575     /// Unique Merchant identifier hash
576     bytes32 public merchantIdHash;
577 
578     /// profileMap stores general information about the merchant
579     mapping (string=>string) profileMap;
580 
581     /// paymentSettingsMap stores payment and order settings for the merchant
582     mapping (string=>string) paymentSettingsMap;
583 
584     /// compositeReputationMap stores composite reputation, that compraises from several metrics
585     mapping (string=>uint32) compositeReputationMap;
586 
587     /// number of last digits in compositeReputation for fractional part
588     uint8 public constant REPUTATION_DECIMALS = 4;
589 
590     /**
591      *  Restrict methods in such way, that they can be invoked only by merchant account.
592      */
593     modifier onlyMerchant() {
594         require(msg.sender == merchantAccount);
595         _;
596     }
597 
598     /**
599      *  Fund Address should always be Externally Owned Account and not a contract.
600      */
601     modifier isEOA(address _fundAddress) {
602         uint256 _codeLength;
603         assembly {_codeLength := extcodesize(_fundAddress)}
604         require(_codeLength == 0, "sorry humans only");
605         _;
606     }
607 
608     /**
609      *  Restrict methods in such way, that they can be invoked only by merchant account or by monethaAddress account.
610      */
611     modifier onlyMerchantOrMonetha() {
612         require(msg.sender == merchantAccount || isMonethaAddress[msg.sender]);
613         _;
614     }
615 
616     /**
617      *  @param _merchantAccount Address of merchant's account, that can withdraw from wallet
618      *  @param _merchantId Merchant identifier
619      *  @param _fundAddress Merchant's fund address, where amount will be transferred.
620      */
621     constructor(address _merchantAccount, string _merchantId, address _fundAddress) public isEOA(_fundAddress) {
622         require(_merchantAccount != 0x0);
623         require(bytes(_merchantId).length > 0);
624 
625         merchantAccount = _merchantAccount;
626         merchantIdHash = keccak256(abi.encodePacked(_merchantId));
627 
628         merchantFundAddress = _fundAddress;
629     }
630 
631     /**
632      *  Accept payment from MonethaGateway
633      */
634     function () external payable {
635     }
636 
637     /**
638      *  @return profile info by string key
639      */
640     function profile(string key) external constant returns (string) {
641         return profileMap[key];
642     }
643 
644     /**
645      *  @return payment setting by string key
646      */
647     function paymentSettings(string key) external constant returns (string) {
648         return paymentSettingsMap[key];
649     }
650 
651     /**
652      *  @return composite reputation value by string key
653      */
654     function compositeReputation(string key) external constant returns (uint32) {
655         return compositeReputationMap[key];
656     }
657 
658     /**
659      *  Set profile info by string key
660      */
661     function setProfile(
662         string profileKey,
663         string profileValue,
664         string repKey,
665         uint32 repValue
666     )
667         external onlyOwner
668     {
669         profileMap[profileKey] = profileValue;
670 
671         if (bytes(repKey).length != 0) {
672             compositeReputationMap[repKey] = repValue;
673         }
674     }
675 
676     /**
677      *  Set payment setting by string key
678      */
679     function setPaymentSettings(string key, string value) external onlyOwner {
680         paymentSettingsMap[key] = value;
681     }
682 
683     /**
684      *  Set composite reputation value by string key
685      */
686     function setCompositeReputation(string key, uint32 value) external onlyMonetha {
687         compositeReputationMap[key] = value;
688     }
689 
690     /**
691      *  Allows withdrawal of funds to beneficiary address
692      */
693     function doWithdrawal(address beneficiary, uint amount) private {
694         require(beneficiary != 0x0);
695         beneficiary.transfer(amount);
696     }
697 
698     /**
699      *  Allows merchant to withdraw funds to beneficiary address
700      */
701     function withdrawTo(address beneficiary, uint amount) public onlyMerchant whenNotPaused {
702         doWithdrawal(beneficiary, amount);
703     }
704 
705     /**
706      *  Allows merchant to withdraw funds to it's own account
707      */
708     function withdraw(uint amount) external onlyMerchant {
709         withdrawTo(msg.sender, amount);
710     }
711 
712     /**
713      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing funds to deposit address of the exchange
714      */
715     function withdrawToExchange(address depositAccount, uint amount) external onlyMerchantOrMonetha whenNotPaused {
716         doWithdrawal(depositAccount, amount);
717     }
718 
719     /**
720      *  Allows merchant or Monetha to initiate exchange of funds by withdrawing all funds to deposit address of the exchange
721      */
722     function withdrawAllToExchange(address depositAccount, uint min_amount) external onlyMerchantOrMonetha whenNotPaused {
723         require (address(this).balance >= min_amount);
724         doWithdrawal(depositAccount, address(this).balance);
725     }
726 
727     /**
728      *  Allows merchant or Monetha to initiate exchange of tokens by withdrawing all tokens to deposit address of the exchange
729      */
730     function withdrawAllTokensToExchange(address _tokenAddress, address _depositAccount, uint _minAmount) external onlyMerchantOrMonetha whenNotPaused {
731         require(_tokenAddress != address(0));
732         
733         uint balance = GenericERC20(_tokenAddress).balanceOf(address(this));
734         
735         require(balance >= _minAmount);
736         
737         GenericERC20(_tokenAddress).transfer(_depositAccount, balance);
738     }
739 
740     /**
741      *  Allows merchant to change it's account address
742      */
743     function changeMerchantAccount(address newAccount) external onlyMerchant whenNotPaused {
744         merchantAccount = newAccount;
745     }
746 
747     /**
748      *  Allows merchant to change it's fund address.
749      */
750     function changeFundAddress(address newFundAddress) external onlyMerchant isEOA(newFundAddress) {
751         merchantFundAddress = newFundAddress;
752     }
753 }
754 
755 // File: contracts/PrivatePaymentProcessor.sol
756 
757 contract PrivatePaymentProcessor is Pausable, Destructible, Contactable, Restricted {
758 
759     using SafeMath for uint256;
760 
761     string constant VERSION = "0.6";
762 
763     /**
764       *  Payback permille.
765       *  1 permille = 0.1 %
766       */
767     uint public constant PAYBACK_PERMILLE = 2; // 0.2%
768 
769     // Order paid event
770     event OrderPaidInEther(
771         uint indexed _orderId,
772         address indexed _originAddress,
773         uint _price,
774         uint _monethaFee,
775         uint _discount
776     );
777 
778     event OrderPaidInToken(
779         uint indexed _orderId,
780         address indexed _originAddress,
781         address indexed _tokenAddress,
782         uint _price,
783         uint _monethaFee
784     );
785 
786     // Payments have been processed event
787     event PaymentsProcessed(
788         address indexed _merchantAddress,
789         uint _amount,
790         uint _fee
791     );
792 
793     // PaymentRefunding is an event when refunding initialized
794     event PaymentRefunding(
795         uint indexed _orderId,
796         address indexed _clientAddress,
797         uint _amount,
798         string _refundReason
799     );
800 
801     // PaymentWithdrawn event is fired when payment is withdrawn
802     event PaymentWithdrawn(
803         uint indexed _orderId,
804         address indexed _clientAddress,
805         uint amount
806     );
807 
808     /// MonethaGateway contract for payment processing
809     MonethaGateway public monethaGateway;
810 
811     /// Address of MerchantWallet, where merchant reputation and funds are stored
812     MerchantWallet public merchantWallet;
813 
814     /// Merchant identifier hash, that associates with the acceptor
815     bytes32 public merchantIdHash;
816 
817     enum WithdrawState {Null, Pending, Withdrawn}
818 
819     struct Withdraw {
820         WithdrawState state;
821         uint amount;
822         address clientAddress;
823         address tokenAddress;
824     }
825 
826     mapping(uint => Withdraw) public withdrawals;
827 
828     /**
829      *  Private Payment Processor sets Monetha Gateway and Merchant Wallet.
830      *  @param _merchantId Merchant of the acceptor
831      *  @param _monethaGateway Address of MonethaGateway contract for payment processing
832      *  @param _merchantWallet Address of MerchantWallet, where merchant reputation and funds are stored
833      */
834     constructor(
835         string _merchantId,
836         MonethaGateway _monethaGateway,
837         MerchantWallet _merchantWallet
838     )
839     public
840     {
841         require(bytes(_merchantId).length > 0);
842 
843         merchantIdHash = keccak256(abi.encodePacked(_merchantId));
844 
845         setMonethaGateway(_monethaGateway);
846         setMerchantWallet(_merchantWallet);
847     }
848 
849     /**
850      *  payForOrder is used by order wallet/client to pay for the order
851      *  @param _orderId Identifier of the order
852      *  @param _originAddress buyer address
853      *  @param _monethaFee is fee collected by Monetha
854      */
855     function payForOrder(
856         uint _orderId,
857         address _originAddress,
858         uint _monethaFee,
859         uint _vouchersApply
860     )
861     external payable whenNotPaused
862     {
863         require(_orderId > 0);
864         require(_originAddress != 0x0);
865         require(msg.value > 0);
866 
867         address fundAddress;
868         fundAddress = merchantWallet.merchantFundAddress();
869 
870         uint discountWei = 0;
871         if (fundAddress != address(0)) {
872             discountWei = monethaGateway.acceptPayment.value(msg.value)(
873                 fundAddress,
874                 _monethaFee,
875                 _originAddress,
876                 _vouchersApply,
877                 PAYBACK_PERMILLE);
878         } else {
879             discountWei = monethaGateway.acceptPayment.value(msg.value)(
880                 merchantWallet,
881                 _monethaFee,
882                 _originAddress,
883                 _vouchersApply,
884                 PAYBACK_PERMILLE);
885         }
886 
887         // log payment event
888         emit OrderPaidInEther(_orderId, _originAddress, msg.value, _monethaFee, discountWei);
889     }
890 
891     /**
892      *  payForOrderInTokens is used by order wallet/client to pay for the order
893      *  This call requires that token's approve method has been called prior to this.
894      *  @param _orderId Identifier of the order
895      *  @param _originAddress buyer address
896      *  @param _monethaFee is fee collected by Monetha
897      *  @param _tokenAddress is tokens address
898      *  @param _orderValue is order amount
899      */
900     function payForOrderInTokens(
901         uint _orderId,
902         address _originAddress,
903         uint _monethaFee,
904         address _tokenAddress,
905         uint _orderValue
906     )
907     external whenNotPaused
908     {
909         require(_orderId > 0);
910         require(_originAddress != 0x0);
911         require(_orderValue > 0);
912         require(_tokenAddress != address(0));
913 
914         address fundAddress;
915         fundAddress = merchantWallet.merchantFundAddress();
916 
917         GenericERC20(_tokenAddress).transferFrom(msg.sender, address(this), _orderValue);
918 
919         GenericERC20(_tokenAddress).transfer(address(monethaGateway), _orderValue);
920 
921         if (fundAddress != address(0)) {
922             monethaGateway.acceptTokenPayment(fundAddress, _monethaFee, _tokenAddress, _orderValue);
923         } else {
924             monethaGateway.acceptTokenPayment(merchantWallet, _monethaFee, _tokenAddress, _orderValue);
925         }
926 
927         // log payment event
928         emit OrderPaidInToken(_orderId, _originAddress, _tokenAddress, _orderValue, _monethaFee);
929     }
930 
931     /**
932      *  refundPayment used in case order cannot be processed and funds need to be returned
933      *  This function initiate process of funds refunding to the client.
934      *  @param _orderId Identifier of the order
935      *  @param _clientAddress is an address of client
936      *  @param _refundReason Order refund reason
937      */
938     function refundPayment(
939         uint _orderId,
940         address _clientAddress,
941         string _refundReason
942     )
943     external payable onlyMonetha whenNotPaused
944     {
945         require(_orderId > 0);
946         require(_clientAddress != 0x0);
947         require(msg.value > 0);
948         require(WithdrawState.Null == withdrawals[_orderId].state);
949 
950         // create withdraw
951         withdrawals[_orderId] = Withdraw({
952             state : WithdrawState.Pending,
953             amount : msg.value,
954             clientAddress : _clientAddress,
955             tokenAddress: address(0)
956             });
957 
958         // log refunding
959         emit PaymentRefunding(_orderId, _clientAddress, msg.value, _refundReason);
960     }
961 
962     /**
963      *  refundTokenPayment used in case order cannot be processed and tokens need to be returned
964      *  This call requires that token's approve method has been called prior to this.
965      *  This function initiate process of refunding tokens to the client.
966      *  @param _orderId Identifier of the order
967      *  @param _clientAddress is an address of client
968      *  @param _refundReason Order refund reason
969      *  @param _tokenAddress is tokens address
970      *  @param _orderValue is order amount
971      */
972     function refundTokenPayment(
973         uint _orderId,
974         address _clientAddress,
975         string _refundReason,
976         uint _orderValue,
977         address _tokenAddress
978     )
979     external onlyMonetha whenNotPaused
980     {
981         require(_orderId > 0);
982         require(_clientAddress != 0x0);
983         require(_orderValue > 0);
984         require(_tokenAddress != address(0));
985         require(WithdrawState.Null == withdrawals[_orderId].state);
986 
987         GenericERC20(_tokenAddress).transferFrom(msg.sender, address(this), _orderValue);
988 
989         // create withdraw
990         withdrawals[_orderId] = Withdraw({
991             state : WithdrawState.Pending,
992             amount : _orderValue,
993             clientAddress : _clientAddress,
994             tokenAddress : _tokenAddress
995             });
996 
997         // log refunding
998         emit PaymentRefunding(_orderId, _clientAddress, _orderValue, _refundReason);
999     }
1000 
1001     /**
1002      *  withdrawRefund performs fund transfer to the client's account.
1003      *  @param _orderId Identifier of the order
1004      */
1005     function withdrawRefund(uint _orderId)
1006     external whenNotPaused
1007     {
1008         Withdraw storage withdraw = withdrawals[_orderId];
1009         require(WithdrawState.Pending == withdraw.state);
1010         require(withdraw.tokenAddress == address(0));
1011 
1012         address clientAddress = withdraw.clientAddress;
1013         uint amount = withdraw.amount;
1014 
1015         // changing withdraw state before transfer
1016         withdraw.state = WithdrawState.Withdrawn;
1017 
1018         // transfer fund to clients account
1019         clientAddress.transfer(amount);
1020 
1021         // log withdrawn
1022         emit PaymentWithdrawn(_orderId, clientAddress, amount);
1023     }
1024 
1025     /**
1026      *  withdrawTokenRefund performs token transfer to the client's account.
1027      *  @param _orderId Identifier of the order
1028      *  @param _tokenAddress token address
1029      */
1030     function withdrawTokenRefund(uint _orderId, address _tokenAddress)
1031     external whenNotPaused
1032     {
1033         require(_tokenAddress != address(0));
1034 
1035         Withdraw storage withdraw = withdrawals[_orderId];
1036         require(WithdrawState.Pending == withdraw.state);
1037         require(withdraw.tokenAddress == _tokenAddress);
1038 
1039         address clientAddress = withdraw.clientAddress;
1040         uint amount = withdraw.amount;
1041 
1042         // changing withdraw state before transfer
1043         withdraw.state = WithdrawState.Withdrawn;
1044 
1045         // transfer fund to clients account
1046         GenericERC20(_tokenAddress).transfer(clientAddress, amount);
1047 
1048         // log withdrawn
1049         emit PaymentWithdrawn(_orderId, clientAddress, amount);
1050     }
1051 
1052     /**
1053      *  setMonethaGateway allows owner to change address of MonethaGateway.
1054      *  @param _newGateway Address of new MonethaGateway contract
1055      */
1056     function setMonethaGateway(MonethaGateway _newGateway) public onlyOwner {
1057         require(address(_newGateway) != 0x0);
1058 
1059         monethaGateway = _newGateway;
1060     }
1061 
1062     /**
1063      *  setMerchantWallet allows owner to change address of MerchantWallet.
1064      *  @param _newWallet Address of new MerchantWallet contract
1065      */
1066     function setMerchantWallet(MerchantWallet _newWallet) public onlyOwner {
1067         require(address(_newWallet) != 0x0);
1068         require(_newWallet.merchantIdHash() == merchantIdHash);
1069 
1070         merchantWallet = _newWallet;
1071     }
1072 }