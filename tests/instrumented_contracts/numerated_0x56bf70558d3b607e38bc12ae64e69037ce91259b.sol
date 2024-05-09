1 /**
2  * Copyright 2017–2018, bZeroX, LLC. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5  
6 pragma solidity 0.5.3;
7 pragma experimental ABIEncoderV2;
8 
9 
10 /**
11  * @title ERC20Basic
12  * @dev Simpler version of ERC20 interface
13  * See https://github.com/ethereum/EIPs/issues/179
14  */
15 contract ERC20Basic {
16   function totalSupply() public view returns (uint256);
17   function balanceOf(address _who) public view returns (uint256);
18   function transfer(address _to, uint256 _value) public returns (bool);
19   event Transfer(address indexed from, address indexed to, uint256 value);
20 }
21 
22 /**
23  * @title ERC20 interface
24  * @dev see https://github.com/ethereum/EIPs/issues/20
25  */
26 contract ERC20 is ERC20Basic {
27   function allowance(address _owner, address _spender)
28     public view returns (uint256);
29 
30   function transferFrom(address _from, address _to, uint256 _value)
31     public returns (bool);
32 
33   function approve(address _spender, uint256 _value) public returns (bool);
34   event Approval(
35     address indexed owner,
36     address indexed spender,
37     uint256 value
38   );
39 }
40 
41 contract EIP20 is ERC20 {
42     string public name;
43     uint8 public decimals;
44     string public symbol;
45 }
46 
47 interface NonCompliantEIP20 {
48     function transfer(address _to, uint256 _value) external;
49     function transferFrom(address _from, address _to, uint256 _value) external;
50     function approve(address _spender, uint256 _value) external;
51 }
52 
53 contract EIP20Wrapper {
54 
55     function eip20Transfer(
56         address token,
57         address to,
58         uint256 value)
59         internal
60         returns (bool result) {
61 
62         NonCompliantEIP20(token).transfer(to, value);
63 
64         assembly {
65             switch returndatasize()   
66             case 0 {                        // non compliant ERC20
67                 result := not(0)            // result is true
68             }
69             case 32 {                       // compliant ERC20
70                 returndatacopy(0, 0, 32) 
71                 result := mload(0)          // result == returndata of external call
72             }
73             default {                       // not an not an ERC20 token
74                 revert(0, 0) 
75             }
76         }
77 
78         require(result, "eip20Transfer failed");
79     }
80 
81     function eip20TransferFrom(
82         address token,
83         address from,
84         address to,
85         uint256 value)
86         internal
87         returns (bool result) {
88 
89         NonCompliantEIP20(token).transferFrom(from, to, value);
90 
91         assembly {
92             switch returndatasize()   
93             case 0 {                        // non compliant ERC20
94                 result := not(0)            // result is true
95             }
96             case 32 {                       // compliant ERC20
97                 returndatacopy(0, 0, 32) 
98                 result := mload(0)          // result == returndata of external call
99             }
100             default {                       // not an not an ERC20 token
101                 revert(0, 0) 
102             }
103         }
104 
105         require(result, "eip20TransferFrom failed");
106     }
107 
108     function eip20Approve(
109         address token,
110         address spender,
111         uint256 value)
112         internal
113         returns (bool result) {
114 
115         NonCompliantEIP20(token).approve(spender, value);
116 
117         assembly {
118             switch returndatasize()   
119             case 0 {                        // non compliant ERC20
120                 result := not(0)            // result is true
121             }
122             case 32 {                       // compliant ERC20
123                 returndatacopy(0, 0, 32) 
124                 result := mload(0)          // result == returndata of external call
125             }
126             default {                       // not an not an ERC20 token
127                 revert(0, 0) 
128             }
129         }
130 
131         require(result, "eip20Approve failed");
132     }
133 }
134 
135 /**
136  * @title SafeMath
137  * @dev Math operations with safety checks that throw on error
138  */
139 library SafeMath {
140 
141   /**
142   * @dev Multiplies two numbers, throws on overflow.
143   */
144   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
145     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
146     // benefit is lost if 'b' is also tested.
147     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
148     if (_a == 0) {
149       return 0;
150     }
151 
152     c = _a * _b;
153     assert(c / _a == _b);
154     return c;
155   }
156 
157   /**
158   * @dev Integer division of two numbers, truncating the quotient.
159   */
160   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
161     // assert(_b > 0); // Solidity automatically throws when dividing by 0
162     // uint256 c = _a / _b;
163     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
164     return _a / _b;
165   }
166 
167   /**
168   * @dev Integer division of two numbers, rounding up and truncating the quotient
169   */
170   function divCeil(uint256 _a, uint256 _b) internal pure returns (uint256) {
171     if (_a == 0) {
172       return 0;
173     }
174 
175     return ((_a - 1) / _b) + 1;
176   }
177 
178   /**
179   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
180   */
181   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
182     assert(_b <= _a);
183     return _a - _b;
184   }
185 
186   /**
187   * @dev Adds two numbers, throws on overflow.
188   */
189   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
190     c = _a + _b;
191     assert(c >= _a);
192     return c;
193   }
194 }
195 
196 /**
197  * @title Ownable
198  * @dev The Ownable contract has an owner address, and provides basic authorization control
199  * functions, this simplifies the implementation of "user permissions".
200  */
201 contract Ownable {
202   address public owner;
203 
204   event OwnershipTransferred(
205     address indexed previousOwner,
206     address indexed newOwner
207   );
208 
209   /**
210    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
211    * account.
212    */
213   constructor() public {
214     owner = msg.sender;
215   }
216 
217   /**
218    * @dev Throws if called by any account other than the owner.
219    */
220   modifier onlyOwner() {
221     require(msg.sender == owner);
222     _;
223   }
224 
225   /**
226    * @dev Allows the current owner to transfer control of the contract to a newOwner.
227    * @param _newOwner The address to transfer ownership to.
228    */
229   function transferOwnership(address _newOwner) public onlyOwner {
230     _transferOwnership(_newOwner);
231   }
232 
233   /**
234    * @dev Transfers control of the contract to a newOwner.
235    * @param _newOwner The address to transfer ownership to.
236    */
237   function _transferOwnership(address _newOwner) internal {
238     require(_newOwner != address(0));
239     emit OwnershipTransferred(owner, _newOwner);
240     owner = _newOwner;
241   }
242 }
243 
244 contract BZxOwnable is Ownable {
245 
246     address public bZxContractAddress;
247 
248     event BZxOwnershipTransferred(address indexed previousBZxContract, address indexed newBZxContract);
249 
250     // modifier reverts if bZxContractAddress isn't set
251     modifier onlyBZx() {
252         require(msg.sender == bZxContractAddress, "only bZx contracts can call this function");
253         _;
254     }
255 
256     /**
257     * @dev Allows the current owner to transfer the bZx contract owner to a new contract address
258     * @param newBZxContractAddress The bZx contract address to transfer ownership to.
259     */
260     function transferBZxOwnership(address newBZxContractAddress) public onlyOwner {
261         require(newBZxContractAddress != address(0) && newBZxContractAddress != owner, "transferBZxOwnership::unauthorized");
262         emit BZxOwnershipTransferred(bZxContractAddress, newBZxContractAddress);
263         bZxContractAddress = newBZxContractAddress;
264     }
265 
266     /**
267     * @dev Allows the current owner to transfer control of the contract to a newOwner.
268     * @param newOwner The address to transfer ownership to.
269     * This overrides transferOwnership in Ownable to prevent setting the new owner the same as the bZxContract
270     */
271     function transferOwnership(address newOwner) public onlyOwner {
272         require(newOwner != address(0) && newOwner != bZxContractAddress, "transferOwnership::unauthorized");
273         emit OwnershipTransferred(owner, newOwner);
274         owner = newOwner;
275     }
276 }
277 
278 contract ExchangeV2Interface {
279 
280     struct OrderV2 {
281         address makerAddress;           // Address that created the order.
282         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.
283         address feeRecipientAddress;    // Address that will recieve fees when order is filled.
284         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
285         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.
286         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.
287         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
288         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
289         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.
290         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.
291         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
292         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
293     }
294 
295     struct FillResults {
296         uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.
297         uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.
298         uint256 makerFeePaid;            // Total amount of ZRX paid by maker(s) to feeRecipient(s).
299         uint256 takerFeePaid;            // Total amount of ZRX paid by taker to feeRecipients(s).
300     }
301 
302     /// @dev Fills the input order.
303     ///      Returns false if the transaction would otherwise revert.
304     /// @param order Order struct containing order specifications.
305     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
306     /// @param signature Proof that order has been created by maker.
307     /// @return Amounts filled and fees paid by maker and taker.
308     function fillOrderNoThrow(
309         OrderV2 memory order,
310         uint256 takerAssetFillAmount,
311         bytes memory signature)
312         public
313         returns (FillResults memory fillResults);
314 
315     /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
316     ///      Returns false if the transaction would otherwise revert.
317     /// @param orders Array of order specifications.
318     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
319     /// @param signatures Proofs that orders have been signed by makers.
320     /// @return Amounts filled and fees paid by makers and taker.
321     function marketSellOrdersNoThrow(
322         OrderV2[] memory orders,
323         uint256 takerAssetFillAmount,
324         bytes[] memory signatures)
325         public
326         returns (FillResults memory totalFillResults);
327 
328 
329     /// @dev Verifies that a signature is valid.
330     /// @param hash Message hash that is signed.
331     /// @param signerAddress Address that should have signed the given hash.
332     /// @param signature Proof of signing.
333     /// @return Validity of order signature.
334     function isValidSignature(
335         bytes32 hash,
336         address signerAddress,
337         bytes calldata signature)
338         external
339         view
340         returns (bool isValid);
341 }
342 
343 contract BZxTo0xShared {
344     using SafeMath for uint256;
345 
346     /// @dev Calculates partial value given a numerator and denominator rounded down.
347     ///      Reverts if rounding error is >= 0.1%
348     /// @param numerator Numerator.
349     /// @param denominator Denominator.
350     /// @param target Value to calculate partial of.
351     /// @return Partial value of target rounded down.
352     function _safeGetPartialAmountFloor(
353         uint256 numerator,
354         uint256 denominator,
355         uint256 target
356     )
357         internal
358         pure
359         returns (uint256 partialAmount)
360     {
361         require(
362             denominator > 0,
363             "DIVISION_BY_ZERO"
364         );
365 
366         require(
367             !_isRoundingErrorFloor(
368                 numerator,
369                 denominator,
370                 target
371             ),
372             "ROUNDING_ERROR"
373         );
374         
375         partialAmount = SafeMath.div(
376             SafeMath.mul(numerator, target),
377             denominator
378         );
379         return partialAmount;
380     }
381 
382     /// @dev Checks if rounding error >= 0.1% when rounding down.
383     /// @param numerator Numerator.
384     /// @param denominator Denominator.
385     /// @param target Value to multiply with numerator/denominator.
386     /// @return Rounding error is present.
387     function _isRoundingErrorFloor(
388         uint256 numerator,
389         uint256 denominator,
390         uint256 target
391     )
392         internal
393         pure
394         returns (bool isError)
395     {
396         require(
397             denominator > 0,
398             "DIVISION_BY_ZERO"
399         );
400         
401         // The absolute rounding error is the difference between the rounded
402         // value and the ideal value. The relative rounding error is the
403         // absolute rounding error divided by the absolute value of the
404         // ideal value. This is undefined when the ideal value is zero.
405         //
406         // The ideal value is `numerator * target / denominator`.
407         // Let's call `numerator * target % denominator` the remainder.
408         // The absolute error is `remainder / denominator`.
409         //
410         // When the ideal value is zero, we require the absolute error to
411         // be zero. Fortunately, this is always the case. The ideal value is
412         // zero iff `numerator == 0` and/or `target == 0`. In this case the
413         // remainder and absolute error are also zero. 
414         if (target == 0 || numerator == 0) {
415             return false;
416         }
417         
418         // Otherwise, we want the relative rounding error to be strictly
419         // less than 0.1%.
420         // The relative error is `remainder / (numerator * target)`.
421         // We want the relative error less than 1 / 1000:
422         //        remainder / (numerator * denominator)  <  1 / 1000
423         // or equivalently:
424         //        1000 * remainder  <  numerator * target
425         // so we have a rounding error iff:
426         //        1000 * remainder  >=  numerator * target
427         uint256 remainder = mulmod(
428             target,
429             numerator,
430             denominator
431         );
432         isError = SafeMath.mul(1000, remainder) >= SafeMath.mul(numerator, target);
433         return isError;
434     }
435 }
436 
437 contract BZxTo0xV2 is BZxTo0xShared, EIP20Wrapper, BZxOwnable {
438     using SafeMath for uint256;
439 
440     event LogFillResults(
441         uint256 makerAssetFilledAmount,
442         uint256 takerAssetFilledAmount,
443         uint256 makerFeePaid,
444         uint256 takerFeePaid
445     );
446 
447     bool public DEBUG = false;
448 
449     address public exchangeV2Contract;
450     address public zrxTokenContract;
451     address public erc20ProxyContract;
452 
453     constructor(
454         address _exchangeV2,
455         address _zrxToken,
456         address _proxy)
457         public
458     {
459         exchangeV2Contract = _exchangeV2;
460         zrxTokenContract = _zrxToken;
461         erc20ProxyContract = _proxy;
462     }
463 
464     function()
465         external {
466         revert();
467     }
468 
469     // 0xc78429c4 == "take0xV2Trade(address,address,uint256,(address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes)[],bytes[])"
470     function take0xV2Trade(
471         address trader,
472         address vaultAddress,
473         uint256 sourceTokenAmountToUse,
474         ExchangeV2Interface.OrderV2[] memory orders0x, // Array of 0x V2 order structs
475         bytes[] memory signatures0x) // Array of signatures for each of the V2 orders
476         public
477         onlyBZx
478         returns (
479             address destTokenAddress,
480             uint256 destTokenAmount,
481             uint256 sourceTokenUsedAmount)
482     {
483         address sourceTokenAddress;
484 
485         //destTokenAddress==makerToken, sourceTokenAddress==takerToken
486         (destTokenAddress, sourceTokenAddress) = getV2Tokens(orders0x[0]);
487 
488         (sourceTokenUsedAmount, destTokenAmount) = _take0xV2Trade(
489             trader,
490             sourceTokenAddress,
491             sourceTokenAmountToUse,
492             orders0x,
493             signatures0x);
494 
495         if (sourceTokenUsedAmount < sourceTokenAmountToUse) {
496             // all sourceToken has to be traded
497             revert("BZxTo0xV2::take0xTrade: sourceTokenUsedAmount < sourceTokenAmountToUse");
498         }
499 
500         // transfer the destToken to the vault
501         eip20Transfer(
502             destTokenAddress,
503             vaultAddress,
504             destTokenAmount);
505     }
506 
507     /// @dev Calculates partial value given a numerator and denominator.
508     /// @param numerator Numerator.
509     /// @param denominator Denominator.
510     /// @param target Value to calculate partial of.
511     /// @return Partial value of target.
512     function getPartialAmount(uint256 numerator, uint256 denominator, uint256 target)
513         public
514         pure
515         returns (uint256)
516     {
517         return SafeMath.div(SafeMath.mul(numerator, target), denominator);
518     }
519 
520     /// @dev Extracts the maker and taker token addresses from the 0x V2 order object.
521     /// @param order 0x V2 order object.
522     /// @return makerTokenAddress and takerTokenAddress.
523     function getV2Tokens(
524         ExchangeV2Interface.OrderV2 memory order)
525         public
526         pure
527         returns (
528             address makerTokenAddress,
529             address takerTokenAddress)
530     {
531         bytes memory makerAssetData = order.makerAssetData;
532         bytes memory takerAssetData = order.takerAssetData;
533         bytes4 makerProxyID;
534         bytes4 takerProxyID;
535 
536         // example data: 0xf47261b00000000000000000000000001dc4c1cefef38a777b15aa20260a54e584b16c48
537         assembly {
538             makerProxyID := mload(add(makerAssetData, 32))
539             takerProxyID := mload(add(takerAssetData, 32))
540 
541             makerTokenAddress := mload(add(makerAssetData, 36))
542             takerTokenAddress := mload(add(takerAssetData, 36))
543         }
544 
545         // ERC20 Proxy ID -> bytes4(keccak256("ERC20Token(address)")) = 0xf47261b0
546         require(makerProxyID == 0xf47261b0 && takerProxyID == 0xf47261b0, "BZxTo0xV2::getV2Tokens: 0x V2 orders must use ERC20 tokens");
547     }
548 
549     function set0xV2Exchange (
550         address _exchange)
551         public
552         onlyOwner
553     {
554         exchangeV2Contract = _exchange;
555     }
556 
557     function setZRXToken (
558         address _zrxToken)
559         public
560         onlyOwner
561     {
562         zrxTokenContract = _zrxToken;
563     }
564 
565     function set0xTokenProxy (
566         address _proxy)
567         public
568         onlyOwner
569     {
570         erc20ProxyContract = _proxy;
571     }
572 
573     function approveFor (
574         address token,
575         address spender,
576         uint256 value)
577         public
578         onlyOwner
579         returns (bool)
580     {
581         eip20Approve(
582             token,
583             spender,
584             value);
585 
586         return true;
587     }
588 
589     function toggleDebug (
590         bool isDebug)
591         public
592         onlyOwner
593     {
594         DEBUG = isDebug;
595     }
596 
597     function _take0xV2Trade(
598         address trader,
599         address sourceTokenAddress,
600         uint256 sourceTokenAmountToUse,
601         ExchangeV2Interface.OrderV2[] memory orders0x, // Array of 0x V2 order structs
602         bytes[] memory signatures0x)
603         internal
604         returns (uint256 sourceTokenUsedAmount, uint256 destTokenAmount)
605     {
606         uint256 zrxTokenAmount = 0;
607         uint256 takerAssetRemaining = sourceTokenAmountToUse;
608         for (uint256 i = 0; i < orders0x.length; i++) {
609             // Note: takerAssetData (sourceToken) is confirmed to be the same in 0x for batch orders
610             // To confirm makerAssetData is the same for each order, rather than doing a more expensive per order bytes
611             // comparison, we will simply set makerAssetData the same in each order to the first value observed. The 0x
612             // trade will fail for invalid orders.
613             if (i > 0)
614                 orders0x[i].makerAssetData = orders0x[0].makerAssetData;
615 
616             // calculate required takerFee
617             if (takerAssetRemaining > 0 && orders0x[i].takerFee > 0) { // takerFee
618                 if (takerAssetRemaining >= orders0x[i].takerAssetAmount) {
619                     zrxTokenAmount = zrxTokenAmount.add(orders0x[i].takerFee);
620                     takerAssetRemaining = takerAssetRemaining.sub(orders0x[i].takerAssetAmount);
621                 } else {
622                     zrxTokenAmount = zrxTokenAmount.add(_safeGetPartialAmountFloor(
623                         takerAssetRemaining,
624                         orders0x[i].takerAssetAmount,
625                         orders0x[i].takerFee
626                     ));
627                     takerAssetRemaining = 0;
628                 }
629             }
630         }
631 
632         if (zrxTokenAmount > 0) {
633             // The 0x erc20ProxyContract already has unlimited transfer allowance for ZRX from this contract (set during deployment of this contract)
634             eip20TransferFrom(
635                 zrxTokenContract,
636                 trader,
637                 address(this),
638                 zrxTokenAmount);
639         }
640 
641         // Make sure there is enough allowance for 0x Exchange Proxy to transfer the sourceToken needed for the 0x trade
642         uint256 tempAllowance = EIP20(sourceTokenAddress).allowance(address(this), erc20ProxyContract);
643         if (tempAllowance < sourceTokenAmountToUse) {
644             if (tempAllowance > 0) {
645                 // reset approval to 0
646                 eip20Approve(
647                     sourceTokenAddress,
648                     erc20ProxyContract,
649                     0);
650             }
651 
652             eip20Approve(
653                 sourceTokenAddress,
654                 erc20ProxyContract,
655                 sourceTokenAmountToUse);
656         }
657 
658         ExchangeV2Interface.FillResults memory fillResults;
659         if (orders0x.length > 1) {
660             fillResults = ExchangeV2Interface(exchangeV2Contract).marketSellOrdersNoThrow(
661                 orders0x,
662                 sourceTokenAmountToUse,
663                 signatures0x);
664         } else {
665             fillResults = ExchangeV2Interface(exchangeV2Contract).fillOrderNoThrow(
666                 orders0x[0],
667                 sourceTokenAmountToUse,
668                 signatures0x[0]);
669         }
670 
671         if (zrxTokenAmount > 0 && fillResults.takerFeePaid < zrxTokenAmount) {
672             // refund unused ZRX token (if any)
673             eip20Transfer(
674                 zrxTokenContract,
675                 trader,
676                 zrxTokenAmount.sub(fillResults.takerFeePaid));
677         }
678 
679         if (DEBUG) {
680             emit LogFillResults(
681                 fillResults.makerAssetFilledAmount,
682                 fillResults.takerAssetFilledAmount,
683                 fillResults.makerFeePaid,
684                 fillResults.takerFeePaid
685             );
686         }
687 
688         sourceTokenUsedAmount = fillResults.takerAssetFilledAmount;
689         destTokenAmount = fillResults.makerAssetFilledAmount;
690     }
691 }