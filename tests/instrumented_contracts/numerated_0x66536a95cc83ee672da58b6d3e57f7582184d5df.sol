1 // File: @axie/contract-library/contracts/access/HasAdmin.sol
2 
3 pragma solidity ^0.5.2;
4 
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
36 pragma solidity ^0.5.2;
37 
38 
39 
40 contract Pausable is HasAdmin {
41   event Paused();
42   event Unpaused();
43 
44   bool public paused;
45 
46   modifier whenNotPaused() {
47     require(!paused);
48     _;
49   }
50 
51   modifier whenPaused() {
52     require(paused);
53     _;
54   }
55 
56   function pause() public onlyAdmin whenNotPaused {
57     paused = true;
58     emit Paused();
59   }
60 
61   function unpause() public onlyAdmin whenPaused {
62     paused = false;
63     emit Unpaused();
64   }
65 }
66 
67 // File: @axie/contract-library/contracts/math/Math.sol
68 
69 pragma solidity ^0.5.2;
70 
71 
72 library Math {
73   function max(uint256 a, uint256 b) internal pure returns (uint256 c) {
74     return a >= b ? a : b;
75   }
76 
77   function min(uint256 a, uint256 b) internal pure returns (uint256 c) {
78     return a < b ? a : b;
79   }
80 }
81 
82 // File: @axie/contract-library/contracts/token/erc20/IERC20.sol
83 
84 pragma solidity ^0.5.2;
85 
86 
87 interface IERC20 {
88   event Transfer(address indexed _from, address indexed _to, uint256 _value);
89   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
90 
91   function totalSupply() external view returns (uint256 _supply);
92   function balanceOf(address _owner) external view returns (uint256 _balance);
93 
94   function approve(address _spender, uint256 _value) external returns (bool _success);
95   function allowance(address _owner, address _spender) external view returns (uint256 _value);
96 
97   function transfer(address _to, uint256 _value) external returns (bool _success);
98   function transferFrom(address _from, address _to, uint256 _value) external returns (bool _success);
99 }
100 
101 // File: @axie/contract-library/contracts/ownership/Withdrawable.sol
102 
103 pragma solidity ^0.5.2;
104 
105 
106 
107 
108 contract Withdrawable is HasAdmin {
109   function withdrawEther() external onlyAdmin {
110     msg.sender.transfer(address(this).balance);
111   }
112 
113   function withdrawToken(IERC20 _token) external onlyAdmin {
114     require(_token.transfer(msg.sender, _token.balanceOf(address(this))));
115   }
116 }
117 
118 // File: @axie/contract-library/contracts/token/erc20/IERC20Receiver.sol
119 
120 pragma solidity ^0.5.2;
121 
122 
123 interface IERC20Receiver {
124   function receiveApproval(
125     address _from,
126     uint256 _value,
127     address _tokenAddress,
128     bytes calldata _data
129   )
130     external;
131 }
132 
133 // File: @axie/contract-library/contracts/token/swap/IKyber.sol
134 
135 pragma solidity ^0.5.2;
136 
137 
138 interface IKyber {
139   function getExpectedRate(
140     address _src,
141     address _dest,
142     uint256 _srcAmount
143   )
144     external
145     view
146     returns (
147       uint256 _expectedRate,
148       uint256 _slippageRate
149     );
150 
151   function trade(
152     address _src,
153     uint256 _maxSrcAmount,
154     address _dest,
155     address payable _receiver,
156     uint256 _maxDestAmount,
157     uint256 _minConversionRate,
158     address _wallet
159   )
160     external
161     payable
162     returns (uint256 _destAmount);
163 }
164 
165 // File: @axie/contract-library/contracts/math/SafeMath.sol
166 
167 pragma solidity ^0.5.2;
168 
169 
170 library SafeMath {
171   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
172     c = a + b;
173     require(c >= a);
174   }
175 
176   function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
177     require(b <= a);
178     return a - b;
179   }
180 
181   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
182     if (a == 0) {
183       return 0;
184     }
185 
186     c = a * b;
187     require(c / a == b);
188   }
189 
190   function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
191     // Since Solidity automatically asserts when dividing by 0,
192     // but we only need it to revert.
193     require(b > 0);
194     return a / b;
195   }
196 
197   function mod(uint256 a, uint256 b) internal pure returns (uint256 c) {
198     // Same reason as `div`.
199     require(b > 0);
200     return a % b;
201   }
202 
203   function ceilingDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
204     return add(div(a, b), mod(a, b) > 0 ? 1 : 0);
205   }
206 
207   function subU64(uint64 a, uint64 b) internal pure returns (uint64 c) {
208     require(b <= a);
209     return a - b;
210   }
211 
212   function addU8(uint8 a, uint8 b) internal pure returns (uint8 c) {
213     c = a + b;
214     require(c >= a);
215   }
216 }
217 
218 // File: @axie/contract-library/contracts/token/erc20/IERC20Detailed.sol
219 
220 pragma solidity ^0.5.2;
221 
222 
223 interface IERC20Detailed {
224   function name() external view returns (string memory _name);
225   function symbol() external view returns (string memory _symbol);
226   function decimals() external view returns (uint8 _decimals);
227 }
228 
229 // File: @axie/contract-library/contracts/token/swap/KyberTokenDecimals.sol
230 
231 pragma solidity ^0.5.2;
232 
233 
234 
235 
236 contract KyberTokenDecimals {
237   using SafeMath for uint256;
238 
239   address public ethAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
240 
241   function _getTokenDecimals(address _token) internal view returns (uint8 _decimals) {
242     return _token != ethAddress ? IERC20Detailed(_token).decimals() : 18;
243   }
244 
245   function _fixTokenDecimals(
246     address _src,
247     address _dest,
248     uint256 _unfixedDestAmount,
249     bool _ceiling
250   )
251     internal
252     view
253     returns (uint256 _destTokenAmount)
254   {
255     uint256 _unfixedDecimals = _getTokenDecimals(_src) + 18; // Kyber by default returns rates with 18 decimals.
256     uint256 _decimals = _getTokenDecimals(_dest);
257 
258     if (_unfixedDecimals > _decimals) {
259       // Divide token amount by 10^(_unfixedDecimals - _decimals) to reduce decimals.
260       if (_ceiling) {
261         return _unfixedDestAmount.ceilingDiv(10 ** (_unfixedDecimals - _decimals));
262       } else {
263         return _unfixedDestAmount.div(10 ** (_unfixedDecimals - _decimals));
264       }
265     } else {
266       // Multiply token amount with 10^(_decimals - _unfixedDecimals) to increase decimals.
267       return _unfixedDestAmount.mul(10 ** (_decimals - _unfixedDecimals));
268     }
269   }
270 }
271 
272 // File: @axie/contract-library/contracts/token/swap/KyberAdapter.sol
273 
274 pragma solidity ^0.5.2;
275 
276 
277 
278 
279 
280 contract KyberAdapter is KyberTokenDecimals {
281   IKyber public kyber = IKyber(0x818E6FECD516Ecc3849DAf6845e3EC868087B755);
282 
283   function () external payable {
284     // Commented out since Kyber sent Ether from their main contract,
285     // The contract we have here is their proxy contract.
286     // require(msg.sender == address(kyber));
287   }
288 
289   function _getConversionRate(
290     address _src,
291     uint256 _srcAmount,
292     address _dest
293   )
294     internal
295     view
296     returns (
297       uint256 _expectedRate,
298       uint256 _slippageRate
299     )
300   {
301     return kyber.getExpectedRate(_src, _dest, _srcAmount);
302   }
303 
304   function _convertToken(
305     address _src,
306     uint256 _srcAmount,
307     address _dest
308   )
309     internal
310     view
311     returns (
312       uint256 _expectedAmount,
313       uint256 _slippageAmount
314     )
315   {
316     (uint256 _expectedRate, uint256 _slippageRate) = _getConversionRate(_src, _srcAmount, _dest);
317 
318     return (
319       _fixTokenDecimals(_src, _dest, _srcAmount.mul(_expectedRate), false),
320       _fixTokenDecimals(_src, _dest, _srcAmount.mul(_slippageRate), false)
321     );
322   }
323 
324   function _getTokenBalance(address _token, address _account) internal view returns (uint256 _balance) {
325     return _token != ethAddress ? IERC20(_token).balanceOf(_account) : _account.balance;
326   }
327 
328   function _swapToken(
329     address _src,
330     uint256 _maxSrcAmount,
331     address _dest,
332     uint256 _maxDestAmount,
333     uint256 _minConversionRate,
334     address payable _initiator,
335     address payable _receiver
336   )
337     internal
338     returns (
339       uint256 _srcAmount,
340       uint256 _destAmount
341     )
342   {
343     require(_src != _dest);
344     require(_src == ethAddress ? msg.value >= _maxSrcAmount : msg.value == 0);
345 
346     // Prepare for handling back the change if there is any.
347     uint256 _balanceBefore = _getTokenBalance(_src, address(this));
348 
349     if (_src != ethAddress) {
350       require(IERC20(_src).transferFrom(_initiator, address(this), _maxSrcAmount));
351       require(IERC20(_src).approve(address(kyber), _maxSrcAmount));
352     } else {
353       // Since we are going to transfer the source amount to Kyber.
354       _balanceBefore = _balanceBefore.sub(_maxSrcAmount);
355     }
356 
357     _destAmount = kyber.trade.value(
358       _src == ethAddress ? _maxSrcAmount : 0
359     )(
360       _src,
361       _maxSrcAmount,
362       _dest,
363       _receiver,
364       _maxDestAmount,
365       _minConversionRate,
366       address(0)
367     );
368 
369     uint256 _balanceAfter = _getTokenBalance(_src, address(this));
370     _srcAmount = _maxSrcAmount;
371 
372     // Handle back the change, if there is any, to the message sender.
373     if (_balanceAfter > _balanceBefore) {
374       uint256 _change = _balanceAfter - _balanceBefore;
375       _srcAmount = _srcAmount.sub(_change);
376 
377       if (_src != ethAddress) {
378         require(IERC20(_src).transfer(_initiator, _change));
379       } else {
380         _initiator.transfer(_change);
381       }
382     }
383   }
384 }
385 
386 // File: @axie/contract-library/contracts/token/swap/KyberCustomTokenRates.sol
387 
388 pragma solidity ^0.5.2;
389 
390 
391 contract KyberCustomTokenRates is HasAdmin, KyberAdapter {
392   struct Rate {
393     address quote;
394     uint256 value;
395   }
396 
397   event CustomTokenRateUpdated(
398     address indexed _tokenAddress,
399     address indexed _quoteTokenAddress,
400     uint256 _rate
401   );
402 
403   mapping (address => Rate) public customTokenRate;
404 
405   function _hasCustomTokenRate(address _tokenAddress) internal view returns (bool _correct) {
406     return customTokenRate[_tokenAddress].value > 0;
407   }
408 
409   function _setCustomTokenRate(address _tokenAddress, address _quoteTokenAddress, uint256 _rate) internal {
410     require(_rate > 0);
411     customTokenRate[_tokenAddress] = Rate({ quote: _quoteTokenAddress, value: _rate });
412     emit CustomTokenRateUpdated(_tokenAddress, _quoteTokenAddress, _rate);
413   }
414 
415   // solium-disable-next-line security/no-assign-params
416   function _getConversionRate(
417     address _src,
418     uint256 _srcAmount,
419     address _dest
420   )
421     internal
422     view
423     returns (
424       uint256 _expectedRate,
425       uint256 _slippageRate
426     )
427   {
428     uint256 _numerator = 1;
429     uint256 _denominator = 1;
430 
431     if (_hasCustomTokenRate(_src)) {
432       Rate storage _rate = customTokenRate[_src];
433 
434       _src = _rate.quote;
435       _srcAmount = _srcAmount.mul(_rate.value).div(10**18);
436 
437       _numerator = _rate.value;
438       _denominator = 10**18;
439     }
440 
441     if (_hasCustomTokenRate(_dest)) {
442       Rate storage _rate = customTokenRate[_dest];
443 
444       _dest = _rate.quote;
445 
446       // solium-disable-next-line whitespace
447       if (_numerator == 1) { _numerator = 10**18; }
448       _denominator = _rate.value;
449     }
450 
451     if (_src != _dest) {
452       (_expectedRate, _slippageRate) = super._getConversionRate(_src, _srcAmount, _dest);
453     } else {
454       _expectedRate = _slippageRate = 10**18;
455     }
456 
457     return (
458       _expectedRate.mul(_numerator).div(_denominator),
459       _slippageRate.mul(_numerator).div(_denominator)
460     );
461   }
462 
463   function _swapToken(
464     address _src,
465     uint256 _maxSrcAmount,
466     address _dest,
467     uint256 _maxDestAmount,
468     uint256 _minConversionRate,
469     address payable _initiator,
470     address payable _receiver
471   )
472     internal
473     returns (
474       uint256 _srcAmount,
475       uint256 _destAmount
476     )
477   {
478     if (_hasCustomTokenRate(_src) || _hasCustomTokenRate(_dest)) {
479       require(_src == ethAddress ? msg.value >= _maxSrcAmount : msg.value == 0);
480       require(_receiver == address(this));
481 
482       (uint256 _expectedRate, ) = _getConversionRate(_src, _maxSrcAmount, _dest);
483       require(_expectedRate >= _minConversionRate);
484 
485       _srcAmount = _maxSrcAmount;
486       _destAmount = _fixTokenDecimals(_src, _dest, _srcAmount.mul(_expectedRate), false);
487 
488       if (_destAmount > _maxDestAmount) {
489         _destAmount = _maxDestAmount;
490         _srcAmount = _fixTokenDecimals(_dest, _src, _destAmount.mul(10**36).ceilingDiv(_expectedRate), true);
491 
492         // To avoid rounding error.
493         if (_srcAmount > _maxSrcAmount) {
494           _srcAmount = _maxSrcAmount;
495         }
496       }
497 
498       if (_src != ethAddress) {
499         require(IERC20(_src).transferFrom(_initiator, address(this), _srcAmount));
500       } else if (msg.value > _srcAmount) {
501         _initiator.transfer(msg.value - _srcAmount);
502       }
503 
504       return (_srcAmount, _destAmount);
505     }
506 
507     return super._swapToken(
508       _src,
509       _maxSrcAmount,
510       _dest,
511       _maxDestAmount,
512       _minConversionRate,
513       _initiator,
514       _receiver
515     );
516   }
517 }
518 
519 // File: @axie/contract-library/contracts/util/AddressUtils.sol
520 
521 pragma solidity ^0.5.2;
522 
523 
524 library AddressUtils {
525   function toPayable(address _address) internal pure returns (address payable _payable) {
526     return address(uint160(_address));
527   }
528 
529   function isContract(address _address) internal view returns (bool _correct) {
530     uint256 _size;
531     // solium-disable-next-line security/no-inline-assembly
532     assembly { _size := extcodesize(_address) }
533     return _size > 0;
534   }
535 }
536 
537 // File: LandSale.sol
538 
539 pragma solidity ^0.5.2;
540 pragma experimental ABIEncoderV2;
541 
542 
543 
544 
545 
546 
547 
548 
549 
550 contract LandSale is Pausable, Withdrawable, KyberCustomTokenRates, IERC20Receiver {
551   using AddressUtils for address;
552 
553   enum ChestType {
554     Savannah,
555     Forest,
556     Arctic,
557     Mystic
558   }
559 
560   event ChestPurchased(
561     ChestType indexed _chestType,
562     uint256 _chestAmount,
563     address indexed _tokenAddress,
564     uint256 _tokenAmount,
565     uint256 _totalPrice,
566     uint256 _lunaCashbackAmount,
567     address _buyer, // Ran out of indexed fields.
568     address indexed _owner
569   );
570 
571   event ReferralRewarded(
572     address indexed _referrer,
573     uint256 _referralReward
574   );
575 
576   event ReferralPercentageUpdated(
577     address indexed _referrer,
578     uint256 _percentage
579   );
580 
581   address public daiAddress = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
582   address public loomAddress = 0xA4e8C3Ec456107eA67d3075bF9e3DF3A75823DB0;
583 
584   uint256 public startedAt = 1548165600; // Tuesday, January 22, 2019 2:00:00 PM GMT+00:00
585   uint256 public endedAt = 1577800800; // Tuesday, December 31, 2019 2:00:00 PM GMT+00:00
586 
587   mapping (uint8 => uint256) public chestCap;
588 
589   uint256 public savannahChestPrice = 0.05 ether;
590   uint256 public forestChestPrice   = 0.16 ether;
591   uint256 public arcticChestPrice   = 0.45 ether;
592   uint256 public mysticChestPrice   = 1.00 ether;
593 
594   uint256 public initialDiscountPercentage = 1000; // 10%.
595   uint256 public initialDiscountDays = 10 days;
596 
597   uint256 public cashbackPercentage = 1000; // 10%.
598 
599   uint256 public defaultReferralPercentage = 1000; // 10%.
600   mapping (address => uint256) public referralPercentage;
601 
602   IERC20 public lunaContract;
603   address public lunaBankAddress;
604 
605   modifier whenInSale {
606     // solium-disable-next-line security/no-block-members
607     require(now >= startedAt && now <= endedAt);
608     _;
609   }
610 
611   constructor(IERC20 _lunaContract, address _lunaBankAddress, uint256[4] memory _chestCap) public {
612     // 1 LUNA = 1/10 DAI (rate has 18 decimals).
613     _setCustomTokenRate(address(_lunaContract), daiAddress, 10**17);
614 
615     lunaContract = _lunaContract;
616     lunaBankAddress = _lunaBankAddress;
617 
618     setChestCap(_chestCap);
619   }
620 
621   function getPrice(
622     ChestType _chestType,
623     uint256 _chestAmount,
624     address _tokenAddress
625   )
626     external
627     view
628     returns (
629       uint256 _tokenAmount,
630       uint256 _minConversionRate
631     )
632   {
633     uint256 _totalPrice = _getEthPrice(_chestType, _chestAmount, _tokenAddress);
634 
635     if (_tokenAddress != ethAddress) {
636       (_tokenAmount, ) = _convertToken(ethAddress, _totalPrice, _tokenAddress);
637       (, _minConversionRate) = _getConversionRate(_tokenAddress, _tokenAmount, ethAddress);
638       _tokenAmount = _totalPrice.mul(10**36).ceilingDiv(_minConversionRate);
639       _tokenAmount = _fixTokenDecimals(ethAddress, _tokenAddress, _tokenAmount, true);
640     } else {
641       _tokenAmount = _totalPrice;
642     }
643   }
644 
645   function purchase(
646     ChestType _chestType,
647     uint256 _chestAmount,
648     address _tokenAddress,
649     uint256 _maxTokenAmount,
650     uint256 _minConversionRate,
651     address payable _referrer
652   )
653     external
654     payable
655     whenInSale
656     whenNotPaused
657   {
658     _purchase(
659       _chestType,
660       _chestAmount,
661       _tokenAddress,
662       _maxTokenAmount,
663       _minConversionRate,
664       msg.sender,
665       msg.sender,
666       _referrer
667     );
668   }
669 
670   function purchaseFor(
671     ChestType _chestType,
672     uint256 _chestAmount,
673     address _tokenAddress,
674     uint256 _maxTokenAmount,
675     uint256 _minConversionRate,
676     address _owner
677   )
678     external
679     payable
680     whenInSale
681     whenNotPaused
682   {
683     _purchase(
684       _chestType,
685       _chestAmount,
686       _tokenAddress,
687       _maxTokenAmount,
688       _minConversionRate,
689       msg.sender,
690       _owner,
691       msg.sender
692     );
693   }
694 
695   function receiveApproval(
696     address _from,
697     uint256 _value,
698     address _tokenAddress,
699     bytes calldata /* _data */
700   )
701     external
702     whenInSale
703     whenNotPaused
704   {
705     require(msg.sender == _tokenAddress);
706 
707     uint256 _action;
708     ChestType _chestType;
709     uint256 _chestAmount;
710     uint256 _minConversionRate;
711     address payable _referrerOrOwner;
712 
713     // solium-disable-next-line security/no-inline-assembly
714     assembly {
715       _action := calldataload(0xa4)
716       _chestType := calldataload(0xc4)
717       _chestAmount := calldataload(0xe4)
718       _minConversionRate := calldataload(0x104)
719       _referrerOrOwner := calldataload(0x124)
720     }
721 
722     address payable _buyer;
723     address _owner;
724     address payable _referrer;
725 
726     if (_action == 0) { // Purchase.
727       _buyer = _from.toPayable();
728       _owner = _from;
729       _referrer = _referrerOrOwner;
730     } else if (_action == 1) { // Purchase for.
731       _buyer = _from.toPayable();
732       _owner = _referrerOrOwner;
733       _referrer = _from.toPayable();
734     } else {
735       revert();
736     }
737 
738     _purchase(
739       _chestType,
740       _chestAmount,
741       _tokenAddress,
742       _value,
743       _minConversionRate,
744       _buyer,
745       _owner,
746       _referrer
747     );
748   }
749 
750   function setReferralPercentages(address[] calldata _referrers, uint256[] calldata _percentage) external onlyAdmin {
751     for (uint256 i = 0; i < _referrers.length; i++) {
752       referralPercentage[_referrers[i]] = _percentage[i];
753       emit ReferralPercentageUpdated(_referrers[i], _percentage[i]);
754     }
755   }
756 
757   function setCustomTokenRates(address[] memory _tokenAddresses, Rate[] memory _rates) public onlyAdmin {
758     for (uint256 i = 0; i < _tokenAddresses.length; i++) {
759       _setCustomTokenRate(_tokenAddresses[i], _rates[i].quote, _rates[i].value);
760     }
761   }
762 
763   function setChestCap(uint256[4] memory _chestCap) public onlyAdmin {
764     for (uint8 _chestType = 0; _chestType < 4; _chestType++) {
765       chestCap[_chestType] = _chestCap[_chestType];
766     }
767   }
768 
769   function setEndedAt(uint256 _endedAt) public onlyAdmin {
770     endedAt = _endedAt;
771   }
772 
773   function _getPresentPercentage() internal view returns (uint256 _percentage) {
774     // solium-disable-next-line security/no-block-members
775     uint256 _elapsedDays = (now - startedAt).div(1 days).mul(1 days);
776 
777     return uint256(10000) // 100%.
778       .sub(initialDiscountPercentage)
779       .add(
780         initialDiscountPercentage
781           .mul(Math.min(_elapsedDays, initialDiscountDays))
782           .div(initialDiscountDays)
783       );
784   }
785 
786   function _getEthPrice(
787     ChestType _chestType,
788     uint256 _chestAmount,
789     address _tokenAddress
790   )
791     internal
792     view
793     returns (uint256 _price)
794   {
795     // solium-disable-next-line indentation
796          if (_chestType == ChestType.Savannah) { _price = savannahChestPrice; } // solium-disable-line whitespace
797     else if (_chestType == ChestType.Forest  ) { _price = forestChestPrice;   } // solium-disable-line whitespace, lbrace
798     else if (_chestType == ChestType.Arctic  ) { _price = arcticChestPrice;   } // solium-disable-line whitespace, lbrace
799     else if (_chestType == ChestType.Mystic  ) { _price = mysticChestPrice;   } // solium-disable-line whitespace, lbrace
800     else { revert(); } // solium-disable-line whitespace, lbrace
801 
802     _price = _price
803       .mul(_getPresentPercentage())
804       .div(10000)
805       .mul(_chestAmount);
806 
807     if (_tokenAddress == address(lunaContract)) {
808       _price = _price
809         .mul(uint256(10000).sub(cashbackPercentage))
810         .ceilingDiv(10000);
811     }
812   }
813 
814   function _getLunaCashbackAmount(
815     uint256 _ethPrice,
816     address _tokenAddress
817   )
818     internal
819     view
820     returns (uint256 _lunaCashbackAmount)
821   {
822     if (_tokenAddress != address(lunaContract)) {
823       (uint256 _lunaPrice, ) = _convertToken(ethAddress, _ethPrice, address(lunaContract));
824 
825       return _lunaPrice
826         .mul(cashbackPercentage)
827         .div(uint256(10000));
828     }
829   }
830 
831   function _getReferralPercentage(address _referrer, address _owner) internal view returns (uint256 _percentage) {
832     return _referrer != _owner && _referrer != address(0)
833       ? Math.max(referralPercentage[_referrer], defaultReferralPercentage)
834       : 0;
835   }
836 
837   function _purchase(
838     ChestType _chestType,
839     uint256 _chestAmount,
840     address _tokenAddress,
841     uint256 _maxTokenAmount,
842     uint256 _minConversionRate,
843     address payable _buyer,
844     address _owner,
845     address payable _referrer
846   )
847     internal
848   {
849     require(_chestAmount <= chestCap[uint8(_chestType)]);
850     require(_tokenAddress == ethAddress ? msg.value >= _maxTokenAmount : msg.value == 0);
851 
852     uint256 _totalPrice = _getEthPrice(_chestType, _chestAmount, _tokenAddress);
853     uint256 _lunaCashbackAmount = _getLunaCashbackAmount(_totalPrice, _tokenAddress);
854 
855     uint256 _tokenAmount;
856     uint256 _ethAmount;
857 
858     if (_tokenAddress != ethAddress) {
859       (_tokenAmount, _ethAmount) = _swapToken(
860         _tokenAddress,
861         _maxTokenAmount,
862         ethAddress,
863         _totalPrice,
864         _minConversionRate,
865         _buyer,
866         address(this)
867       );
868     } else {
869       // Check if the buyer allowed to spend that much ETH.
870       require(_maxTokenAmount >= _totalPrice);
871 
872       // Require minimum conversion rate to be 0.
873       require(_minConversionRate == 0);
874 
875       _tokenAmount = _totalPrice;
876       _ethAmount = msg.value;
877     }
878 
879     // Check if we received enough payment.
880     require(_ethAmount >= _totalPrice);
881 
882     // Send back the ETH change, if there is any.
883     if (_ethAmount > _totalPrice) {
884       _buyer.transfer(_ethAmount - _totalPrice);
885     }
886 
887     chestCap[uint8(_chestType)] -= _chestAmount;
888 
889     emit ChestPurchased(
890       _chestType,
891       _chestAmount,
892       _tokenAddress,
893       _tokenAmount,
894       _totalPrice,
895       _lunaCashbackAmount,
896       _buyer,
897       _owner
898     );
899 
900     if (_tokenAddress != address(lunaContract)) {
901       // Send LUNA cashback.
902       require(lunaContract.transferFrom(lunaBankAddress, _owner, _lunaCashbackAmount));
903     }
904 
905     if (!_hasCustomTokenRate(_tokenAddress)) {
906       uint256 _referralReward = _totalPrice
907         .mul(_getReferralPercentage(_referrer, _owner))
908         .div(10000);
909 
910       // If the referral reward cannot be sent because of a referrer's fault, set it to 0.
911       // solium-disable-next-line security/no-send
912       if (_referralReward > 0 && !_referrer.send(_referralReward)) {
913         _referralReward = 0;
914       }
915 
916       if (_referralReward > 0) {
917         emit ReferralRewarded(_referrer, _referralReward);
918       }
919     }
920   }
921 }