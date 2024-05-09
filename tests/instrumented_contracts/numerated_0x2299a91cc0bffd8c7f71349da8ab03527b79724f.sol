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
245   function () external payable {
246     // Commented out since Kyber sent Ether from their main contract,
247     // The contract we have here is their proxy contract.
248     // require(msg.sender == address(kyber));
249   }
250 
251   function _getConversionRate(
252     address _src,
253     uint256 _srcAmount,
254     address _dest
255   )
256     internal
257     view
258     returns (
259       uint256 _expectedRate,
260       uint256 _slippageRate
261     )
262   {
263     return kyber.getExpectedRate(_src, _dest, _srcAmount);
264   }
265 
266   function _convertToken(
267     address _src,
268     uint256 _srcAmount,
269     address _dest
270   )
271     internal
272     view
273     returns (
274       uint256 _expectedAmount,
275       uint256 _slippageAmount
276     )
277   {
278     (uint256 _expectedRate, uint256 _slippageRate) = _getConversionRate(_src, _srcAmount, _dest);
279 
280     return (
281       _fixTokenDecimals(_src, _dest, _srcAmount.mul(_expectedRate), false),
282       _fixTokenDecimals(_src, _dest, _srcAmount.mul(_slippageRate), false)
283     );
284   }
285 
286   function _getTokenBalance(address _token, address _account) internal view returns (uint256 _balance) {
287     return _token != ethAddress ? IERC20(_token).balanceOf(_account) : _account.balance;
288   }
289 
290   function _swapToken(
291     address _src,
292     uint256 _maxSrcAmount,
293     address _dest,
294     uint256 _maxDestAmount,
295     uint256 _minConversionRate,
296     address payable _initiator,
297     address payable _receiver
298   )
299     internal
300     returns (
301       uint256 _srcAmount,
302       uint256 _destAmount
303     )
304   {
305     require(_src != _dest);
306     require(_src == ethAddress ? msg.value >= _maxSrcAmount : msg.value == 0);
307 
308     // Prepare for handling back the change if there is any.
309     uint256 _balanceBefore = _getTokenBalance(_src, address(this));
310 
311     if (_src != ethAddress) {
312       require(IERC20(_src).transferFrom(_initiator, address(this), _maxSrcAmount));
313       require(IERC20(_src).approve(address(kyber), _maxSrcAmount));
314     } else {
315       // Since we are going to transfer the source amount to Kyber.
316       _balanceBefore = _balanceBefore.sub(_maxSrcAmount);
317     }
318 
319     _destAmount = kyber.trade.value(
320       _src == ethAddress ? _maxSrcAmount : 0
321     )(
322       _src,
323       _maxSrcAmount,
324       _dest,
325       _receiver,
326       _maxDestAmount,
327       _minConversionRate,
328       address(0)
329     );
330 
331     uint256 _balanceAfter = _getTokenBalance(_src, address(this));
332     _srcAmount = _maxSrcAmount;
333 
334     // Handle back the change, if there is any, to the message sender.
335     if (_balanceAfter > _balanceBefore) {
336       uint256 _change = _balanceAfter - _balanceBefore;
337       _srcAmount = _srcAmount.sub(_change);
338 
339       if (_src != ethAddress) {
340         require(IERC20(_src).transfer(_initiator, _change));
341       } else {
342         _initiator.transfer(_change);
343       }
344     }
345   }
346 }
347 
348 // File: @axie/contract-library/contracts/token/swap/KyberCustomTokenRates.sol
349 
350 contract KyberCustomTokenRates is HasAdmin, KyberAdapter {
351   struct Rate {
352     address quote;
353     uint256 value;
354   }
355 
356   event CustomTokenRateUpdated(
357     address indexed _tokenAddress,
358     address indexed _quoteTokenAddress,
359     uint256 _rate
360   );
361 
362   mapping (address => Rate) public customTokenRate;
363 
364   function _hasCustomTokenRate(address _tokenAddress) internal view returns (bool _correct) {
365     return customTokenRate[_tokenAddress].value > 0;
366   }
367 
368   function _setCustomTokenRate(address _tokenAddress, address _quoteTokenAddress, uint256 _rate) internal {
369     require(_rate > 0);
370     customTokenRate[_tokenAddress] = Rate({ quote: _quoteTokenAddress, value: _rate });
371     emit CustomTokenRateUpdated(_tokenAddress, _quoteTokenAddress, _rate);
372   }
373 
374   // solium-disable-next-line security/no-assign-params
375   function _getConversionRate(
376     address _src,
377     uint256 _srcAmount,
378     address _dest
379   )
380     internal
381     view
382     returns (
383       uint256 _expectedRate,
384       uint256 _slippageRate
385     )
386   {
387     uint256 _numerator = 1;
388     uint256 _denominator = 1;
389 
390     if (_hasCustomTokenRate(_src)) {
391       Rate storage _rate = customTokenRate[_src];
392 
393       _src = _rate.quote;
394       _srcAmount = _srcAmount.mul(_rate.value).div(10**18);
395 
396       _numerator = _rate.value;
397       _denominator = 10**18;
398     }
399 
400     if (_hasCustomTokenRate(_dest)) {
401       Rate storage _rate = customTokenRate[_dest];
402 
403       _dest = _rate.quote;
404 
405       // solium-disable-next-line whitespace
406       if (_numerator == 1) { _numerator = 10**18; }
407       _denominator = _rate.value;
408     }
409 
410     if (_src != _dest) {
411       (_expectedRate, _slippageRate) = super._getConversionRate(_src, _srcAmount, _dest);
412     } else {
413       _expectedRate = _slippageRate = 10**18;
414     }
415 
416     return (
417       _expectedRate.mul(_numerator).div(_denominator),
418       _slippageRate.mul(_numerator).div(_denominator)
419     );
420   }
421 
422   function _swapToken(
423     address _src,
424     uint256 _maxSrcAmount,
425     address _dest,
426     uint256 _maxDestAmount,
427     uint256 _minConversionRate,
428     address payable _initiator,
429     address payable _receiver
430   )
431     internal
432     returns (
433       uint256 _srcAmount,
434       uint256 _destAmount
435     )
436   {
437     if (_hasCustomTokenRate(_src) || _hasCustomTokenRate(_dest)) {
438       require(_src == ethAddress ? msg.value >= _maxSrcAmount : msg.value == 0);
439       require(_receiver == address(this));
440 
441       (uint256 _expectedRate, ) = _getConversionRate(_src, _srcAmount, _dest);
442       require(_expectedRate >= _minConversionRate);
443 
444       _srcAmount = _maxSrcAmount;
445       _destAmount = _fixTokenDecimals(_src, _dest, _srcAmount.mul(_expectedRate), false);
446 
447       if (_destAmount > _maxDestAmount) {
448         _destAmount = _maxDestAmount;
449         _srcAmount = _fixTokenDecimals(_dest, _src, _destAmount.mul(10**36).ceilingDiv(_expectedRate), true);
450 
451         // To avoid rounding error.
452         if (_srcAmount > _maxSrcAmount) {
453           _srcAmount = _maxSrcAmount;
454         }
455       }
456 
457       if (_src != ethAddress) {
458         require(IERC20(_src).transferFrom(_initiator, address(this), _srcAmount));
459       } else if (msg.value > _srcAmount) {
460         _initiator.transfer(msg.value - _srcAmount);
461       }
462 
463       return (_srcAmount, _destAmount);
464     }
465 
466     return super._swapToken(
467       _src,
468       _maxSrcAmount,
469       _dest,
470       _maxDestAmount,
471       _minConversionRate,
472       _initiator,
473       _receiver
474     );
475   }
476 }
477 
478 // File: @axie/contract-library/contracts/util/AddressUtils.sol
479 
480 library AddressUtils {
481   function toPayable(address _address) internal pure returns (address payable _payable) {
482     return address(uint160(_address));
483   }
484 
485   function isContract(address _address) internal view returns (bool _correct) {
486     uint256 _size;
487     // solium-disable-next-line security/no-inline-assembly
488     assembly { _size := extcodesize(_address) }
489     return _size > 0;
490   }
491 }
492 
493 // File: contracts/land/sale/LandSale.sol
494 
495 contract LandSale_v2 is Pausable, Withdrawable, KyberCustomTokenRates, IERC20Receiver {
496   using AddressUtils for address;
497 
498   enum ChestType {
499     Savannah,
500     Forest,
501     Arctic,
502     Mystic
503   }
504 
505   event ChestPurchased(
506     ChestType indexed _chestType,
507     uint256 _chestAmount,
508     address indexed _tokenAddress,
509     uint256 _tokenAmount,
510     uint256 _totalPrice,
511     uint256 _lunaCashbackAmount,
512     address _buyer, // Ran out of indexed fields.
513     address indexed _owner
514   );
515 
516   event ReferralRewarded(
517     address indexed _referrer,
518     uint256 _referralReward
519   );
520 
521   event ReferralPercentageUpdated(
522     address indexed _referrer,
523     uint256 _percentage
524   );
525 
526   address public daiAddress = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
527   address public loomAddress = 0xA4e8C3Ec456107eA67d3075bF9e3DF3A75823DB0;
528 
529   uint256 public startedAt = 1548165600; // Tuesday, January 22, 2019 2:00:00 PM GMT+00:00
530   uint256 public endedAt = 1563804000; // Monday, July 22, 2019 2:00:00 PM GMT+00:00
531 
532   mapping (uint8 => uint256) public chestCap;
533 
534   uint256 public savannahChestPrice = 0.05 ether;
535   uint256 public forestChestPrice   = 0.16 ether;
536   uint256 public arcticChestPrice   = 0.45 ether;
537   uint256 public mysticChestPrice   = 1.00 ether;
538 
539   uint256 public initialDiscountPercentage = 1000; // 10%.
540   uint256 public initialDiscountDays = 10 days;
541 
542   uint256 public cashbackPercentage = 1000; // 10%.
543 
544   uint256 public defaultReferralPercentage = 1000; // 10%.
545   mapping (address => uint256) public referralPercentage;
546 
547   IERC20 public lunaContract;
548   address public lunaBankAddress;
549 
550   modifier whenInSale {
551     // solium-disable-next-line security/no-block-members
552     require(now >= startedAt && now <= endedAt);
553     _;
554   }
555 
556   constructor(IERC20 _lunaContract, address _lunaBankAddress) public {
557     // 1 LUNA = 1/10 DAI (rate has 18 decimals).
558     _setCustomTokenRate(address(_lunaContract), daiAddress, 10**17);
559 
560     lunaContract = _lunaContract;
561     lunaBankAddress = _lunaBankAddress;
562 
563     setChestCap([uint256(5349), 5359, 4171, 2338]);
564   }
565 
566   function getPrice(
567     ChestType _chestType,
568     uint256 _chestAmount,
569     address _tokenAddress
570   )
571     external
572     view
573     returns (
574       uint256 _tokenAmount,
575       uint256 _minConversionRate
576     )
577   {
578     uint256 _totalPrice = _getEthPrice(_chestType, _chestAmount, _tokenAddress);
579 
580     if (_tokenAddress != ethAddress) {
581       (_tokenAmount, ) = _convertToken(ethAddress, _totalPrice, _tokenAddress);
582       (, _minConversionRate) = _getConversionRate(_tokenAddress, _tokenAmount, ethAddress);
583       _tokenAmount = _totalPrice.mul(10**36).ceilingDiv(_minConversionRate);
584       _tokenAmount = _fixTokenDecimals(ethAddress, _tokenAddress, _tokenAmount, true);
585     } else {
586       _tokenAmount = _totalPrice;
587     }
588   }
589 
590   function purchase(
591     ChestType _chestType,
592     uint256 _chestAmount,
593     address _tokenAddress,
594     uint256 _maxTokenAmount,
595     uint256 _minConversionRate,
596     address payable _referrer
597   )
598     external
599     payable
600     whenInSale
601     whenNotPaused
602   {
603     _purchase(
604       _chestType,
605       _chestAmount,
606       _tokenAddress,
607       _maxTokenAmount,
608       _minConversionRate,
609       msg.sender,
610       msg.sender,
611       _referrer
612     );
613   }
614 
615   function purchaseFor(
616     ChestType _chestType,
617     uint256 _chestAmount,
618     address _tokenAddress,
619     uint256 _maxTokenAmount,
620     uint256 _minConversionRate,
621     address _owner
622   )
623     external
624     payable
625     whenInSale
626     whenNotPaused
627   {
628     _purchase(
629       _chestType,
630       _chestAmount,
631       _tokenAddress,
632       _maxTokenAmount,
633       _minConversionRate,
634       msg.sender,
635       _owner,
636       msg.sender
637     );
638   }
639 
640   function receiveApproval(
641     address _from,
642     uint256 _value,
643     address _tokenAddress,
644     bytes calldata /* _data */
645   )
646     external
647     whenInSale
648     whenNotPaused
649   {
650     require(msg.sender == _tokenAddress);
651 
652     uint256 _action;
653     ChestType _chestType;
654     uint256 _chestAmount;
655     uint256 _minConversionRate;
656     address payable _referrerOrOwner;
657 
658     // solium-disable-next-line security/no-inline-assembly
659     assembly {
660       _action := calldataload(0xa4)
661       _chestType := calldataload(0xc4)
662       _chestAmount := calldataload(0xe4)
663       _minConversionRate := calldataload(0x104)
664       _referrerOrOwner := calldataload(0x124)
665     }
666 
667     address payable _buyer;
668     address _owner;
669     address payable _referrer;
670 
671     if (_action == 0) { // Purchase.
672       _buyer = _from.toPayable();
673       _owner = _from;
674       _referrer = _referrerOrOwner;
675     } else if (_action == 1) { // Purchase for.
676       _buyer = _from.toPayable();
677       _owner = _referrerOrOwner;
678       _referrer = _from.toPayable();
679     } else {
680       revert();
681     }
682 
683     _purchase(
684       _chestType,
685       _chestAmount,
686       _tokenAddress,
687       _value,
688       _minConversionRate,
689       _buyer,
690       _owner,
691       _referrer
692     );
693   }
694 
695   function setReferralPercentages(address[] calldata _referrers, uint256[] calldata _percentage) external onlyAdmin {
696     for (uint256 i = 0; i < _referrers.length; i++) {
697       referralPercentage[_referrers[i]] = _percentage[i];
698       emit ReferralPercentageUpdated(_referrers[i], _percentage[i]);
699     }
700   }
701 
702   function setCustomTokenRates(address[] memory _tokenAddresses, Rate[] memory _rates) public onlyAdmin {
703     for (uint256 i = 0; i < _tokenAddresses.length; i++) {
704       _setCustomTokenRate(_tokenAddresses[i], _rates[i].quote, _rates[i].value);
705     }
706   }
707 
708   function setChestCap(uint256[4] memory _chestCap) public onlyAdmin {
709     for (uint8 _chestType = 0; _chestType < 4; _chestType++) {
710       chestCap[_chestType] = _chestCap[_chestType];
711     }
712   }
713 
714   function _getPresentPercentage() internal view returns (uint256 _percentage) {
715     // solium-disable-next-line security/no-block-members
716     uint256 _elapsedDays = (now - startedAt).div(1 days).mul(1 days);
717 
718     return uint256(10000) // 100%.
719       .sub(initialDiscountPercentage)
720       .add(
721         initialDiscountPercentage
722           .mul(Math.min(_elapsedDays, initialDiscountDays))
723           .div(initialDiscountDays)
724       );
725   }
726 
727   function _getEthPrice(
728     ChestType _chestType,
729     uint256 _chestAmount,
730     address _tokenAddress
731   )
732     internal
733     view
734     returns (uint256 _price)
735   {
736     // solium-disable-next-line indentation
737          if (_chestType == ChestType.Savannah) { _price = savannahChestPrice; } // solium-disable-line whitespace
738     else if (_chestType == ChestType.Forest  ) { _price = forestChestPrice;   } // solium-disable-line whitespace, lbrace
739     else if (_chestType == ChestType.Arctic  ) { _price = arcticChestPrice;   } // solium-disable-line whitespace, lbrace
740     else if (_chestType == ChestType.Mystic  ) { _price = mysticChestPrice;   } // solium-disable-line whitespace, lbrace
741     else { revert(); } // solium-disable-line whitespace, lbrace
742 
743     _price = _price
744       .mul(_getPresentPercentage())
745       .div(10000)
746       .mul(_chestAmount);
747 
748     if (_tokenAddress == address(lunaContract)) {
749       _price = _price
750         .mul(uint256(10000).sub(cashbackPercentage))
751         .ceilingDiv(10000);
752     }
753   }
754 
755   function _getLunaCashbackAmount(
756     uint256 _ethPrice,
757     address _tokenAddress
758   )
759     internal
760     view
761     returns (uint256 _lunaCashbackAmount)
762   {
763     if (_tokenAddress != address(lunaContract)) {
764       (uint256 _lunaPrice, ) = _convertToken(ethAddress, _ethPrice, address(lunaContract));
765 
766       return _lunaPrice
767         .mul(cashbackPercentage)
768         .div(uint256(10000));
769     }
770   }
771 
772   function _getReferralPercentage(address _referrer, address _owner) internal view returns (uint256 _percentage) {
773     return _referrer != _owner && _referrer != address(0)
774       ? Math.max(referralPercentage[_referrer], defaultReferralPercentage)
775       : 0;
776   }
777 
778   function _purchase(
779     ChestType _chestType,
780     uint256 _chestAmount,
781     address _tokenAddress,
782     uint256 _maxTokenAmount,
783     uint256 _minConversionRate,
784     address payable _buyer,
785     address _owner,
786     address payable _referrer
787   )
788     internal
789   {
790     require(_chestAmount <= chestCap[uint8(_chestType)]);
791     require(_tokenAddress == ethAddress ? msg.value >= _maxTokenAmount : msg.value == 0);
792 
793     uint256 _totalPrice = _getEthPrice(_chestType, _chestAmount, _tokenAddress);
794     uint256 _lunaCashbackAmount = _getLunaCashbackAmount(_totalPrice, _tokenAddress);
795 
796     uint256 _tokenAmount;
797     uint256 _ethAmount;
798 
799     if (_tokenAddress != ethAddress) {
800       (_tokenAmount, _ethAmount) = _swapToken(
801         _tokenAddress,
802         _maxTokenAmount,
803         ethAddress,
804         _totalPrice,
805         _minConversionRate,
806         _buyer,
807         address(this)
808       );
809     } else {
810       // Check if the buyer allowed to spend that much ETH.
811       require(_maxTokenAmount >= _totalPrice);
812 
813       // Require minimum conversion rate to be 0.
814       require(_minConversionRate == 0);
815 
816       _tokenAmount = _totalPrice;
817       _ethAmount = msg.value;
818     }
819 
820     // Check if we received enough payment.
821     require(_ethAmount >= _totalPrice);
822 
823     // Send back the ETH change, if there is any.
824     if (_ethAmount > _totalPrice) {
825       _buyer.transfer(_ethAmount - _totalPrice);
826     }
827 
828     chestCap[uint8(_chestType)] -= _chestAmount;
829 
830     emit ChestPurchased(
831       _chestType,
832       _chestAmount,
833       _tokenAddress,
834       _tokenAmount,
835       _totalPrice,
836       _lunaCashbackAmount,
837       _buyer,
838       _owner
839     );
840 
841     if (_tokenAddress != address(lunaContract)) {
842       // Send LUNA cashback.
843       require(lunaContract.transferFrom(lunaBankAddress, _owner, _lunaCashbackAmount));
844     }
845 
846     if (!_hasCustomTokenRate(_tokenAddress)) {
847       uint256 _referralReward = _totalPrice
848         .mul(_getReferralPercentage(_referrer, _owner))
849         .div(10000);
850 
851       // If the referral reward cannot be sent because of a referrer's fault, set it to 0.
852       // solium-disable-next-line security/no-send
853       if (_referralReward > 0 && !_referrer.send(_referralReward)) {
854         _referralReward = 0;
855       }
856 
857       if (_referralReward > 0) {
858         emit ReferralRewarded(_referrer, _referralReward);
859       }
860     }
861   }
862 }