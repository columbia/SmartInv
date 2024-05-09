1 pragma solidity ^0.5.2;
2 pragma experimental ABIEncoderV2;
3 
4 // File: @axie/contract-library/contracts/access/HasAdmin.sol
5 
6 contract HasAdmin {
7   event AdminChanged(address indexed _oldAdmin, address indexed _newAdmin);
8   event AdminRemoved(address indexed _oldAdmin);
9 
10   address public admin;
11 
12   modifier onlyAdmin {
13     require(msg.sender == admin);
14     _;
15   }
16 
17   constructor() internal {
18     admin = msg.sender;
19     emit AdminChanged(address(0), admin);
20   }
21 
22   function changeAdmin(address _newAdmin) external onlyAdmin {
23     require(_newAdmin != address(0));
24     emit AdminChanged(admin, _newAdmin);
25     admin = _newAdmin;
26   }
27 
28   function removeAdmin() external onlyAdmin {
29     emit AdminRemoved(admin);
30     admin = address(0);
31   }
32 }
33 
34 // File: @axie/contract-library/contracts/lifecycle/Pausable.sol
35 
36 contract Pausable is HasAdmin {
37   event Paused();
38   event Unpaused();
39 
40   bool public paused;
41 
42   modifier whenNotPaused() {
43     require(!paused);
44     _;
45   }
46 
47   modifier whenPaused() {
48     require(paused);
49     _;
50   }
51 
52   function pause() public onlyAdmin whenNotPaused {
53     paused = true;
54     emit Paused();
55   }
56 
57   function unpause() public onlyAdmin whenPaused {
58     paused = false;
59     emit Unpaused();
60   }
61 }
62 
63 // File: @axie/contract-library/contracts/math/Math.sol
64 
65 library Math {
66   function max(uint256 a, uint256 b) internal pure returns (uint256 c) {
67     return a >= b ? a : b;
68   }
69 
70   function min(uint256 a, uint256 b) internal pure returns (uint256 c) {
71     return a < b ? a : b;
72   }
73 }
74 
75 // File: @axie/contract-library/contracts/token/erc20/IERC20.sol
76 
77 interface IERC20 {
78   event Transfer(address indexed _from, address indexed _to, uint256 _value);
79   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
80 
81   function totalSupply() external view returns (uint256 _supply);
82   function balanceOf(address _owner) external view returns (uint256 _balance);
83 
84   function approve(address _spender, uint256 _value) external returns (bool _success);
85   function allowance(address _owner, address _spender) external view returns (uint256 _value);
86 
87   function transfer(address _to, uint256 _value) external returns (bool _success);
88   function transferFrom(address _from, address _to, uint256 _value) external returns (bool _success);
89 }
90 
91 // File: @axie/contract-library/contracts/ownership/Withdrawable.sol
92 
93 contract Withdrawable is HasAdmin {
94   function withdrawEther() external onlyAdmin {
95     msg.sender.transfer(address(this).balance);
96   }
97 
98   function withdrawToken(IERC20 _token) external onlyAdmin {
99     require(_token.transfer(msg.sender, _token.balanceOf(address(this))));
100   }
101 }
102 
103 // File: @axie/contract-library/contracts/token/erc20/IERC20Receiver.sol
104 
105 interface IERC20Receiver {
106   function receiveApproval(
107     address _from,
108     uint256 _value,
109     address _tokenAddress,
110     bytes calldata _data
111   )
112     external;
113 }
114 
115 // File: @axie/contract-library/contracts/token/swap/IKyber.sol
116 
117 interface IKyber {
118   function getExpectedRate(
119     address _src,
120     address _dest,
121     uint256 _srcAmount
122   )
123     external
124     view
125     returns (
126       uint256 _expectedRate,
127       uint256 _slippageRate
128     );
129 
130   function trade(
131     address _src,
132     uint256 _maxSrcAmount,
133     address _dest,
134     address payable _receiver,
135     uint256 _maxDestAmount,
136     uint256 _minConversionRate,
137     address _wallet
138   )
139     external
140     payable
141     returns (uint256 _destAmount);
142 }
143 
144 // File: @axie/contract-library/contracts/math/SafeMath.sol
145 
146 library SafeMath {
147   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
148     c = a + b;
149     require(c >= a);
150   }
151 
152   function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
153     require(b <= a);
154     return a - b;
155   }
156 
157   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
158     if (a == 0) {
159       return 0;
160     }
161 
162     c = a * b;
163     require(c / a == b);
164   }
165 
166   function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
167     // Since Solidity automatically asserts when dividing by 0,
168     // but we only need it to revert.
169     require(b > 0);
170     return a / b;
171   }
172 
173   function mod(uint256 a, uint256 b) internal pure returns (uint256 c) {
174     // Same reason as `div`.
175     require(b > 0);
176     return a % b;
177   }
178 
179   function ceilingDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
180     return add(div(a, b), mod(a, b) > 0 ? 1 : 0);
181   }
182 
183   function subU64(uint64 a, uint64 b) internal pure returns (uint64 c) {
184     require(b <= a);
185     return a - b;
186   }
187 
188   function addU8(uint8 a, uint8 b) internal pure returns (uint8 c) {
189     c = a + b;
190     require(c >= a);
191   }
192 }
193 
194 // File: @axie/contract-library/contracts/token/erc20/IERC20Detailed.sol
195 
196 interface IERC20Detailed {
197   function name() external view returns (string memory _name);
198   function symbol() external view returns (string memory _symbol);
199   function decimals() external view returns (uint8 _decimals);
200 }
201 
202 // File: @axie/contract-library/contracts/token/swap/KyberTokenDecimals.sol
203 
204 contract KyberTokenDecimals {
205   using SafeMath for uint256;
206 
207   address public ethAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
208 
209   function _getTokenDecimals(address _token) internal view returns (uint8 _decimals) {
210     return _token != ethAddress ? IERC20Detailed(_token).decimals() : 18;
211   }
212 
213   function _fixTokenDecimals(
214     address _src,
215     address _dest,
216     uint256 _unfixedDestAmount,
217     bool _ceiling
218   )
219     internal
220     view
221     returns (uint256 _destTokenAmount)
222   {
223     uint256 _unfixedDecimals = _getTokenDecimals(_src) + 18; // Kyber by default returns rates with 18 decimals.
224     uint256 _decimals = _getTokenDecimals(_dest);
225 
226     if (_unfixedDecimals > _decimals) {
227       // Divide token amount by 10^(_unfixedDecimals - _decimals) to reduce decimals.
228       if (_ceiling) {
229         return _unfixedDestAmount.ceilingDiv(10 ** (_unfixedDecimals - _decimals));
230       } else {
231         return _unfixedDestAmount.div(10 ** (_unfixedDecimals - _decimals));
232       }
233     } else {
234       // Multiply token amount with 10^(_decimals - _unfixedDecimals) to increase decimals.
235       return _unfixedDestAmount.mul(10 ** (_decimals - _unfixedDecimals));
236     }
237   }
238 }
239 
240 // File: @axie/contract-library/contracts/token/swap/KyberAdapter.sol
241 
242 contract KyberAdapter is KyberTokenDecimals {
243   IKyber public kyber = IKyber(0x818E6FECD516Ecc3849DAf6845e3EC868087B755);
244 
245   function() external payable {
246     require(msg.sender == address(kyber));
247   }
248 
249   function _getConversionRate(
250     address _src,
251     uint256 _srcAmount,
252     address _dest
253   )
254     internal
255     view
256     returns (
257       uint256 _expectedRate,
258       uint256 _slippageRate
259     )
260   {
261     return kyber.getExpectedRate(_src, _dest, _srcAmount);
262   }
263 
264   function _convertToken(
265     address _src,
266     uint256 _srcAmount,
267     address _dest
268   )
269     internal
270     view
271     returns (
272       uint256 _expectedAmount,
273       uint256 _slippageAmount
274     )
275   {
276     (uint256 _expectedRate, uint256 _slippageRate) = _getConversionRate(_src, _srcAmount, _dest);
277 
278     return (
279       _fixTokenDecimals(_src, _dest, _srcAmount.mul(_expectedRate), false),
280       _fixTokenDecimals(_src, _dest, _srcAmount.mul(_slippageRate), false)
281     );
282   }
283 
284   function _getTokenBalance(address _token, address _account) internal view returns (uint256 _balance) {
285     return _token != ethAddress ? IERC20(_token).balanceOf(_account) : _account.balance;
286   }
287 
288   function _swapToken(
289     address _src,
290     uint256 _maxSrcAmount,
291     address _dest,
292     uint256 _maxDestAmount,
293     uint256 _minConversionRate,
294     address payable _initiator,
295     address payable _receiver
296   )
297     internal
298     returns (
299       uint256 _srcAmount,
300       uint256 _destAmount
301     )
302   {
303     require(_src != _dest);
304     require(_src == ethAddress ? msg.value >= _maxSrcAmount : msg.value == 0);
305 
306     // Prepare for handling back the change if there is any.
307     uint256 _balanceBefore = _getTokenBalance(_src, address(this));
308 
309     if (_src != ethAddress) {
310       require(IERC20(_src).transferFrom(_initiator, address(this), _maxSrcAmount));
311       require(IERC20(_src).approve(address(kyber), _maxSrcAmount));
312     } else {
313       // Since we are going to transfer the source amount to Kyber.
314       _balanceBefore = _balanceBefore.sub(_maxSrcAmount);
315     }
316 
317     _destAmount = kyber.trade.value(
318       _src == ethAddress ? _maxSrcAmount : 0
319     )(
320       _src,
321       _maxSrcAmount,
322       _dest,
323       _receiver,
324       _maxDestAmount,
325       _minConversionRate,
326       address(0)
327     );
328 
329     uint256 _balanceAfter = _getTokenBalance(_src, address(this));
330     _srcAmount = _maxSrcAmount;
331 
332     // Handle back the change, if there is any, to the message sender.
333     if (_balanceAfter > _balanceBefore) {
334       uint256 _change = _balanceAfter - _balanceBefore;
335       _srcAmount = _srcAmount.sub(_change);
336 
337       if (_src != ethAddress) {
338         require(IERC20(_src).transfer(_initiator, _change));
339       } else {
340         _initiator.transfer(_change);
341       }
342     }
343   }
344 }
345 
346 // File: @axie/contract-library/contracts/token/swap/KyberCustomTokenRates.sol
347 
348 contract KyberCustomTokenRates is HasAdmin, KyberAdapter {
349   struct Rate {
350     address quote;
351     uint256 value;
352   }
353 
354   event CustomTokenRateUpdated(
355     address indexed _tokenAddress,
356     address indexed _quoteTokenAddress,
357     uint256 _rate
358   );
359 
360   mapping (address => Rate) public customTokenRate;
361 
362   function _hasCustomTokenRate(address _tokenAddress) internal view returns (bool _correct) {
363     return customTokenRate[_tokenAddress].value > 0;
364   }
365 
366   function _setCustomTokenRate(address _tokenAddress, address _quoteTokenAddress, uint256 _rate) internal {
367     require(_rate > 0);
368     customTokenRate[_tokenAddress] = Rate({ quote: _quoteTokenAddress, value: _rate });
369     emit CustomTokenRateUpdated(_tokenAddress, _quoteTokenAddress, _rate);
370   }
371 
372   // solium-disable-next-line security/no-assign-params
373   function _getConversionRate(
374     address _src,
375     uint256 _srcAmount,
376     address _dest
377   )
378     internal
379     view
380     returns (
381       uint256 _expectedRate,
382       uint256 _slippageRate
383     )
384   {
385     uint256 _numerator = 1;
386     uint256 _denominator = 1;
387 
388     if (_hasCustomTokenRate(_src)) {
389       Rate storage _rate = customTokenRate[_src];
390 
391       _src = _rate.quote;
392       _srcAmount = _srcAmount.mul(_rate.value).div(10**18);
393 
394       _numerator = _rate.value;
395       _denominator = 10**18;
396     }
397 
398     if (_hasCustomTokenRate(_dest)) {
399       Rate storage _rate = customTokenRate[_dest];
400 
401       _dest = _rate.quote;
402 
403       // solium-disable-next-line whitespace
404       if (_numerator == 1) { _numerator = 10**18; }
405       _denominator = _rate.value;
406     }
407 
408     if (_src != _dest) {
409       (_expectedRate, _slippageRate) = super._getConversionRate(_src, _srcAmount, _dest);
410     } else {
411       _expectedRate = _slippageRate = 10**18;
412     }
413 
414     return (
415       _expectedRate.mul(_numerator).div(_denominator),
416       _slippageRate.mul(_numerator).div(_denominator)
417     );
418   }
419 
420   function _swapToken(
421     address _src,
422     uint256 _maxSrcAmount,
423     address _dest,
424     uint256 _maxDestAmount,
425     uint256 _minConversionRate,
426     address payable _initiator,
427     address payable _receiver
428   )
429     internal
430     returns (
431       uint256 _srcAmount,
432       uint256 _destAmount
433     )
434   {
435     if (_hasCustomTokenRate(_src) || _hasCustomTokenRate(_dest)) {
436       require(_src == ethAddress ? msg.value >= _maxSrcAmount : msg.value == 0);
437       require(_receiver == address(this));
438 
439       (uint256 _expectedRate, ) = _getConversionRate(_src, _srcAmount, _dest);
440       require(_expectedRate >= _minConversionRate);
441 
442       _srcAmount = _maxSrcAmount;
443       _destAmount = _fixTokenDecimals(_src, _dest, _srcAmount.mul(_expectedRate), false);
444 
445       if (_destAmount > _maxDestAmount) {
446         _destAmount = _maxDestAmount;
447         _srcAmount = _fixTokenDecimals(_dest, _src, _destAmount.mul(10**36).ceilingDiv(_expectedRate), true);
448 
449         // To avoid rounding error.
450         if (_srcAmount > _maxSrcAmount) {
451           _srcAmount = _maxSrcAmount;
452         }
453       }
454 
455       if (_src != ethAddress) {
456         require(IERC20(_src).transferFrom(_initiator, address(this), _srcAmount));
457       } else if (msg.value > _srcAmount) {
458         _initiator.transfer(msg.value - _srcAmount);
459       }
460 
461       return (_srcAmount, _destAmount);
462     }
463 
464     return super._swapToken(
465       _src,
466       _maxSrcAmount,
467       _dest,
468       _maxDestAmount,
469       _minConversionRate,
470       _initiator,
471       _receiver
472     );
473   }
474 }
475 
476 // File: @axie/contract-library/contracts/util/AddressUtils.sol
477 
478 library AddressUtils {
479   function toPayable(address _address) internal pure returns (address payable _payable) {
480     return address(uint160(_address));
481   }
482 
483   function isContract(address _address) internal view returns (bool _correct) {
484     uint256 _size;
485     // solium-disable-next-line security/no-inline-assembly
486     assembly { _size := extcodesize(_address) }
487     return _size > 0;
488   }
489 }
490 
491 // File: contracts/land/sale/LandSale.sol
492 
493 contract LandSale is Pausable, Withdrawable, KyberCustomTokenRates, IERC20Receiver {
494   using AddressUtils for address;
495 
496   enum ChestType {
497     Savannah,
498     Forest,
499     Arctic,
500     Mystic
501   }
502 
503   event ChestPurchased(
504     ChestType indexed _chestType,
505     uint256 _chestAmount,
506     address indexed _tokenAddress,
507     uint256 _tokenAmount,
508     uint256 _totalPrice,
509     uint256 _lunaCashbackAmount,
510     address _buyer, // Ran out of indexed fields.
511     address indexed _owner
512   );
513 
514   event ReferralRewarded(
515     address indexed _referrer,
516     uint256 _referralReward
517   );
518 
519   event ReferralPercentageUpdated(
520     address indexed _referrer,
521     uint256 _percentage
522   );
523 
524   address public daiAddress = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
525   address public loomAddress = 0xA4e8C3Ec456107eA67d3075bF9e3DF3A75823DB0;
526 
527   uint256 public startedAt = 1548165600; // Tuesday, January 22, 2019 2:00:00 PM GMT+00:00
528   uint256 public endedAt = 1563804000; // Monday, July 22, 2019 2:00:00 PM GMT+00:00
529 
530   mapping (uint8 => bool) public chestTypeEnabled;
531   mapping (address => bool) public tokenEnabled;
532 
533   uint256 public savannahChestPrice = 0.05 ether;
534   uint256 public forestChestPrice   = 0.16 ether;
535   uint256 public arcticChestPrice   = 0.45 ether;
536   uint256 public mysticChestPrice   = 1.00 ether;
537 
538   uint256 public initialDiscountPercentage = 1000; // 10%.
539   uint256 public initialDiscountDays = 10 days;
540 
541   uint256 public cashbackPercentage = 1000; // 10%.
542 
543   uint256 public defaultReferralPercentage = 500; // 5%.
544   mapping (address => uint256) public referralPercentage;
545 
546   IERC20 public lunaContract;
547   address public lunaBankAddress;
548 
549   modifier whenInSale {
550     // solium-disable-next-line security/no-block-members
551     require(now >= startedAt && now <= endedAt);
552     _;
553   }
554 
555   constructor(IERC20 _lunaContract, address _lunaBankAddress) public {
556     // 1 LUNA = 1/10 DAI (rate has 18 decimals).
557     _setCustomTokenRate(address(_lunaContract), daiAddress, 10**17);
558 
559     lunaContract = _lunaContract;
560     lunaBankAddress = _lunaBankAddress;
561 
562     enableChestType(ChestType.Savannah, true);
563     enableChestType(ChestType.Forest, true);
564     enableChestType(ChestType.Arctic, true);
565     enableChestType(ChestType.Mystic, true);
566 
567     enableToken(ethAddress, true);
568     enableToken(daiAddress, true);
569     enableToken(address(lunaContract), true);
570   }
571 
572   function getPrice(
573     ChestType _chestType,
574     uint256 _chestAmount,
575     address _tokenAddress
576   )
577     external
578     view
579     returns (
580       uint256 _tokenAmount,
581       uint256 _minConversionRate
582     )
583   {
584     uint256 _totalPrice = _getEthPrice(_chestType, _chestAmount, _tokenAddress);
585 
586     if (_tokenAddress != ethAddress) {
587       (_tokenAmount, ) = _convertToken(ethAddress, _totalPrice, _tokenAddress);
588       (, _minConversionRate) = _getConversionRate(_tokenAddress, _tokenAmount, ethAddress);
589       _tokenAmount = _totalPrice.mul(10**36).ceilingDiv(_minConversionRate);
590       _tokenAmount = _fixTokenDecimals(ethAddress, _tokenAddress, _tokenAmount, true);
591     } else {
592       _tokenAmount = _totalPrice;
593     }
594   }
595 
596   function purchase(
597     ChestType _chestType,
598     uint256 _chestAmount,
599     address _tokenAddress,
600     uint256 _maxTokenAmount,
601     uint256 _minConversionRate,
602     address payable _referrer
603   )
604     external
605     payable
606     whenInSale
607     whenNotPaused
608   {
609     _purchase(
610       _chestType,
611       _chestAmount,
612       _tokenAddress,
613       _maxTokenAmount,
614       _minConversionRate,
615       msg.sender,
616       msg.sender,
617       _referrer
618     );
619   }
620 
621   function purchaseFor(
622     ChestType _chestType,
623     uint256 _chestAmount,
624     address _tokenAddress,
625     uint256 _maxTokenAmount,
626     uint256 _minConversionRate,
627     address _owner
628   )
629     external
630     payable
631     whenInSale
632     whenNotPaused
633   {
634     _purchase(
635       _chestType,
636       _chestAmount,
637       _tokenAddress,
638       _maxTokenAmount,
639       _minConversionRate,
640       msg.sender,
641       _owner,
642       msg.sender
643     );
644   }
645 
646   function receiveApproval(
647     address _from,
648     uint256 _value,
649     address _tokenAddress,
650     bytes calldata /* _data */
651   )
652     external
653     whenInSale
654     whenNotPaused
655   {
656     require(msg.sender == _tokenAddress);
657 
658     uint256 _action;
659     ChestType _chestType;
660     uint256 _chestAmount;
661     uint256 _minConversionRate;
662     address payable _referrerOrOwner;
663 
664     // solium-disable-next-line security/no-inline-assembly
665     assembly {
666       _action := calldataload(0xa4)
667       _chestType := calldataload(0xc4)
668       _chestAmount := calldataload(0xe4)
669       _minConversionRate := calldataload(0x104)
670       _referrerOrOwner := calldataload(0x124)
671     }
672 
673     address payable _buyer;
674     address _owner;
675     address payable _referrer;
676 
677     if (_action == 0) { // Purchase.
678       _buyer = _from.toPayable();
679       _owner = _from;
680       _referrer = _referrerOrOwner;
681     } else if (_action == 1) { // Purchase for.
682       _buyer = _from.toPayable();
683       _owner = _referrerOrOwner;
684       _referrer = _from.toPayable();
685     } else {
686       revert();
687     }
688 
689     _purchase(
690       _chestType,
691       _chestAmount,
692       _tokenAddress,
693       _value,
694       _minConversionRate,
695       _buyer,
696       _owner,
697       _referrer
698     );
699   }
700 
701   function setReferralPercentages(address[] calldata _referrers, uint256[] calldata _percentage) external onlyAdmin {
702     for (uint256 i = 0; i < _referrers.length; i++) {
703       referralPercentage[_referrers[i]] = _percentage[i];
704       emit ReferralPercentageUpdated(_referrers[i], _percentage[i]);
705     }
706   }
707 
708   function setCustomTokenRates(address[] memory _tokenAddresses, Rate[] memory _rates) public onlyAdmin {
709     for (uint256 i = 0; i < _tokenAddresses.length; i++) {
710       _setCustomTokenRate(_tokenAddresses[i], _rates[i].quote, _rates[i].value);
711     }
712   }
713 
714   function enableChestType(ChestType _chestType, bool _enabled) public onlyAdmin {
715     chestTypeEnabled[uint8(_chestType)] = _enabled;
716   }
717 
718   function enableToken(address _tokenAddress, bool _enabled) public onlyAdmin {
719     tokenEnabled[_tokenAddress] = _enabled;
720   }
721 
722   function _getPresentPercentage() internal view returns (uint256 _percentage) {
723     // solium-disable-next-line security/no-block-members
724     uint256 _elapsedDays = (now - startedAt).div(1 days).mul(1 days);
725 
726     return uint256(10000) // 100%.
727       .sub(initialDiscountPercentage)
728       .add(
729         initialDiscountPercentage
730           .mul(Math.min(_elapsedDays, initialDiscountDays))
731           .div(initialDiscountDays)
732       );
733   }
734 
735   function _getEthPrice(
736     ChestType _chestType,
737     uint256 _chestAmount,
738     address _tokenAddress
739   )
740     internal
741     view
742     returns (uint256 _price)
743   {
744     // solium-disable-next-line indentation
745          if (_chestType == ChestType.Savannah) { _price = savannahChestPrice; } // solium-disable-line whitespace
746     else if (_chestType == ChestType.Forest  ) { _price = forestChestPrice;   } // solium-disable-line whitespace, lbrace
747     else if (_chestType == ChestType.Arctic  ) { _price = arcticChestPrice;   } // solium-disable-line whitespace, lbrace
748     else if (_chestType == ChestType.Mystic  ) { _price = mysticChestPrice;   } // solium-disable-line whitespace, lbrace
749     else { revert(); } // solium-disable-line whitespace, lbrace
750 
751     _price = _price
752       .mul(_getPresentPercentage())
753       .div(10000)
754       .mul(_chestAmount);
755 
756     if (_tokenAddress == address(lunaContract)) {
757       _price = _price
758         .mul(uint256(10000).sub(cashbackPercentage))
759         .ceilingDiv(10000);
760     }
761   }
762 
763   function _getLunaCashbackAmount(
764     uint256 _ethPrice,
765     address _tokenAddress
766   )
767     internal
768     view
769     returns (uint256 _lunaCashbackAmount)
770   {
771     if (_tokenAddress != address(lunaContract)) {
772       (uint256 _lunaPrice, ) = _convertToken(ethAddress, _ethPrice, address(lunaContract));
773 
774       return _lunaPrice
775         .mul(cashbackPercentage)
776         .div(uint256(10000));
777     }
778   }
779 
780   function _getReferralPercentage(address _referrer, address _owner) internal view returns (uint256 _percentage) {
781     return _referrer != _owner && _referrer != address(0)
782       ? Math.max(referralPercentage[_referrer], defaultReferralPercentage)
783       : 0;
784   }
785 
786   function _purchase(
787     ChestType _chestType,
788     uint256 _chestAmount,
789     address _tokenAddress,
790     uint256 _maxTokenAmount,
791     uint256 _minConversionRate,
792     address payable _buyer,
793     address _owner,
794     address payable _referrer
795   )
796     internal
797   {
798     require(chestTypeEnabled[uint8(_chestType)]);
799     require(tokenEnabled[_tokenAddress]);
800 
801     require(_tokenAddress == ethAddress ? msg.value >= _maxTokenAmount : msg.value == 0);
802 
803     uint256 _totalPrice = _getEthPrice(_chestType, _chestAmount, _tokenAddress);
804     uint256 _lunaCashbackAmount = _getLunaCashbackAmount(_totalPrice, _tokenAddress);
805 
806     uint256 _tokenAmount;
807     uint256 _ethAmount;
808 
809     if (_tokenAddress != ethAddress) {
810       (_tokenAmount, _ethAmount) = _swapToken(
811         _tokenAddress,
812         _maxTokenAmount,
813         ethAddress,
814         _totalPrice,
815         _minConversionRate,
816         _buyer,
817         address(this)
818       );
819     } else {
820       // Check if the buyer allowed to spend that much ETH.
821       require(_maxTokenAmount >= _totalPrice);
822 
823       // Require minimum conversion rate to be 0.
824       require(_minConversionRate == 0);
825 
826       _tokenAmount = _totalPrice;
827       _ethAmount = msg.value;
828     }
829 
830     // Check if we received enough payment.
831     require(_ethAmount >= _totalPrice);
832 
833     // Send back the ETH change, if there is any.
834     if (_ethAmount > _totalPrice) {
835       _buyer.transfer(_ethAmount - _totalPrice);
836     }
837 
838     emit ChestPurchased(
839       _chestType,
840       _chestAmount,
841       _tokenAddress,
842       _tokenAmount,
843       _totalPrice,
844       _lunaCashbackAmount,
845       _buyer,
846       _owner
847     );
848 
849     if (_tokenAddress != address(lunaContract)) {
850       // Send LUNA cashback.
851       require(lunaContract.transferFrom(lunaBankAddress, _owner, _lunaCashbackAmount));
852     }
853 
854     if (!_hasCustomTokenRate(_tokenAddress)) {
855       uint256 _referralReward = _totalPrice
856         .mul(_getReferralPercentage(_referrer, _owner))
857         .div(10000);
858 
859       // If the referral reward cannot be sent because of a referrer's fault, set it to 0.
860       // solium-disable-next-line security/no-send
861       if (_referralReward > 0 && !_referrer.send(_referralReward)) {
862         _referralReward = 0;
863       }
864 
865       if (_referralReward > 0) {
866         emit ReferralRewarded(_referrer, _referralReward);
867       }
868     }
869   }
870 }