1 /**
2  * Copyright 2017–2018, bZeroX, LLC. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5  
6 pragma solidity 0.5.3;
7 
8 
9 /**
10  * @title ERC20Basic
11  * @dev Simpler version of ERC20 interface
12  * See https://github.com/ethereum/EIPs/issues/179
13  */
14 contract ERC20Basic {
15   function totalSupply() public view returns (uint256);
16   function balanceOf(address _who) public view returns (uint256);
17   function transfer(address _to, uint256 _value) public returns (bool);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 /**
22  * @title ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/20
24  */
25 contract ERC20 is ERC20Basic {
26   function allowance(address _owner, address _spender)
27     public view returns (uint256);
28 
29   function transferFrom(address _from, address _to, uint256 _value)
30     public returns (bool);
31 
32   function approve(address _spender, uint256 _value) public returns (bool);
33   event Approval(
34     address indexed owner,
35     address indexed spender,
36     uint256 value
37   );
38 }
39 
40 contract EIP20 is ERC20 {
41     string public name;
42     uint8 public decimals;
43     string public symbol;
44 }
45 
46 interface NonCompliantEIP20 {
47     function transfer(address _to, uint256 _value) external;
48     function transferFrom(address _from, address _to, uint256 _value) external;
49     function approve(address _spender, uint256 _value) external;
50 }
51 
52 contract EIP20Wrapper {
53 
54     function eip20Transfer(
55         address token,
56         address to,
57         uint256 value)
58         internal
59         returns (bool result) {
60 
61         NonCompliantEIP20(token).transfer(to, value);
62 
63         assembly {
64             switch returndatasize()   
65             case 0 {                        // non compliant ERC20
66                 result := not(0)            // result is true
67             }
68             case 32 {                       // compliant ERC20
69                 returndatacopy(0, 0, 32) 
70                 result := mload(0)          // result == returndata of external call
71             }
72             default {                       // not an not an ERC20 token
73                 revert(0, 0) 
74             }
75         }
76 
77         require(result, "eip20Transfer failed");
78     }
79 
80     function eip20TransferFrom(
81         address token,
82         address from,
83         address to,
84         uint256 value)
85         internal
86         returns (bool result) {
87 
88         NonCompliantEIP20(token).transferFrom(from, to, value);
89 
90         assembly {
91             switch returndatasize()   
92             case 0 {                        // non compliant ERC20
93                 result := not(0)            // result is true
94             }
95             case 32 {                       // compliant ERC20
96                 returndatacopy(0, 0, 32) 
97                 result := mload(0)          // result == returndata of external call
98             }
99             default {                       // not an not an ERC20 token
100                 revert(0, 0) 
101             }
102         }
103 
104         require(result, "eip20TransferFrom failed");
105     }
106 
107     function eip20Approve(
108         address token,
109         address spender,
110         uint256 value)
111         internal
112         returns (bool result) {
113 
114         NonCompliantEIP20(token).approve(spender, value);
115 
116         assembly {
117             switch returndatasize()   
118             case 0 {                        // non compliant ERC20
119                 result := not(0)            // result is true
120             }
121             case 32 {                       // compliant ERC20
122                 returndatacopy(0, 0, 32) 
123                 result := mload(0)          // result == returndata of external call
124             }
125             default {                       // not an not an ERC20 token
126                 revert(0, 0) 
127             }
128         }
129 
130         require(result, "eip20Approve failed");
131     }
132 }
133 
134 /**
135  * @title SafeMath
136  * @dev Math operations with safety checks that throw on error
137  */
138 library SafeMath {
139 
140   /**
141   * @dev Multiplies two numbers, throws on overflow.
142   */
143   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
144     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
145     // benefit is lost if 'b' is also tested.
146     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
147     if (_a == 0) {
148       return 0;
149     }
150 
151     c = _a * _b;
152     assert(c / _a == _b);
153     return c;
154   }
155 
156   /**
157   * @dev Integer division of two numbers, truncating the quotient.
158   */
159   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
160     // assert(_b > 0); // Solidity automatically throws when dividing by 0
161     // uint256 c = _a / _b;
162     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
163     return _a / _b;
164   }
165 
166   /**
167   * @dev Integer division of two numbers, rounding up and truncating the quotient
168   */
169   function divCeil(uint256 _a, uint256 _b) internal pure returns (uint256) {
170     if (_a == 0) {
171       return 0;
172     }
173 
174     return ((_a - 1) / _b) + 1;
175   }
176 
177   /**
178   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
179   */
180   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
181     assert(_b <= _a);
182     return _a - _b;
183   }
184 
185   /**
186   * @dev Adds two numbers, throws on overflow.
187   */
188   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
189     c = _a + _b;
190     assert(c >= _a);
191     return c;
192   }
193 }
194 
195 /**
196  * @title Ownable
197  * @dev The Ownable contract has an owner address, and provides basic authorization control
198  * functions, this simplifies the implementation of "user permissions".
199  */
200 contract Ownable {
201   address public owner;
202 
203   event OwnershipTransferred(
204     address indexed previousOwner,
205     address indexed newOwner
206   );
207 
208   /**
209    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
210    * account.
211    */
212   constructor() public {
213     owner = msg.sender;
214   }
215 
216   /**
217    * @dev Throws if called by any account other than the owner.
218    */
219   modifier onlyOwner() {
220     require(msg.sender == owner);
221     _;
222   }
223 
224   /**
225    * @dev Allows the current owner to transfer control of the contract to a newOwner.
226    * @param _newOwner The address to transfer ownership to.
227    */
228   function transferOwnership(address _newOwner) public onlyOwner {
229     _transferOwnership(_newOwner);
230   }
231 
232   /**
233    * @dev Transfers control of the contract to a newOwner.
234    * @param _newOwner The address to transfer ownership to.
235    */
236   function _transferOwnership(address _newOwner) internal {
237     require(_newOwner != address(0));
238     emit OwnershipTransferred(owner, _newOwner);
239     owner = _newOwner;
240   }
241 }
242 
243 contract BZxOwnable is Ownable {
244 
245     address public bZxContractAddress;
246 
247     event BZxOwnershipTransferred(address indexed previousBZxContract, address indexed newBZxContract);
248 
249     // modifier reverts if bZxContractAddress isn't set
250     modifier onlyBZx() {
251         require(msg.sender == bZxContractAddress, "only bZx contracts can call this function");
252         _;
253     }
254 
255     /**
256     * @dev Allows the current owner to transfer the bZx contract owner to a new contract address
257     * @param newBZxContractAddress The bZx contract address to transfer ownership to.
258     */
259     function transferBZxOwnership(address newBZxContractAddress) public onlyOwner {
260         require(newBZxContractAddress != address(0) && newBZxContractAddress != owner, "transferBZxOwnership::unauthorized");
261         emit BZxOwnershipTransferred(bZxContractAddress, newBZxContractAddress);
262         bZxContractAddress = newBZxContractAddress;
263     }
264 
265     /**
266     * @dev Allows the current owner to transfer control of the contract to a newOwner.
267     * @param newOwner The address to transfer ownership to.
268     * This overrides transferOwnership in Ownable to prevent setting the new owner the same as the bZxContract
269     */
270     function transferOwnership(address newOwner) public onlyOwner {
271         require(newOwner != address(0) && newOwner != bZxContractAddress, "transferOwnership::unauthorized");
272         emit OwnershipTransferred(owner, newOwner);
273         owner = newOwner;
274     }
275 }
276 
277 interface ExchangeInterface {
278     event LogError(uint8 indexed errorId, bytes32 indexed orderHash);
279 
280     function fillOrder(
281           address[5] calldata orderAddresses,
282           uint256[6] calldata orderValues,
283           uint256 fillTakerTokenAmount,
284           bool shouldThrowOnInsufficientBalanceOrAllowance,
285           uint8 v,
286           bytes32 r,
287           bytes32 s)
288           external
289           returns (uint256 filledTakerTokenAmount);
290 
291     function fillOrdersUpTo(
292         address[5][] calldata orderAddresses,
293         uint256[6][] calldata orderValues,
294         uint256 fillTakerTokenAmount,
295         bool shouldThrowOnInsufficientBalanceOrAllowance,
296         uint8[] calldata v,
297         bytes32[] calldata r,
298         bytes32[] calldata s)
299         external
300         returns (uint256);
301 
302     function isValidSignature(
303         address signer,
304         bytes32 hash,
305         uint8 v,
306         bytes32 r,
307         bytes32 s)
308         external
309         view
310         returns (bool);
311 }
312 
313 contract BZxTo0xShared {
314     using SafeMath for uint256;
315 
316     /// @dev Calculates partial value given a numerator and denominator rounded down.
317     ///      Reverts if rounding error is >= 0.1%
318     /// @param numerator Numerator.
319     /// @param denominator Denominator.
320     /// @param target Value to calculate partial of.
321     /// @return Partial value of target rounded down.
322     function _safeGetPartialAmountFloor(
323         uint256 numerator,
324         uint256 denominator,
325         uint256 target
326     )
327         internal
328         pure
329         returns (uint256 partialAmount)
330     {
331         require(
332             denominator > 0,
333             "DIVISION_BY_ZERO"
334         );
335 
336         require(
337             !_isRoundingErrorFloor(
338                 numerator,
339                 denominator,
340                 target
341             ),
342             "ROUNDING_ERROR"
343         );
344         
345         partialAmount = SafeMath.div(
346             SafeMath.mul(numerator, target),
347             denominator
348         );
349         return partialAmount;
350     }
351 
352     /// @dev Checks if rounding error >= 0.1% when rounding down.
353     /// @param numerator Numerator.
354     /// @param denominator Denominator.
355     /// @param target Value to multiply with numerator/denominator.
356     /// @return Rounding error is present.
357     function _isRoundingErrorFloor(
358         uint256 numerator,
359         uint256 denominator,
360         uint256 target
361     )
362         internal
363         pure
364         returns (bool isError)
365     {
366         require(
367             denominator > 0,
368             "DIVISION_BY_ZERO"
369         );
370         
371         // The absolute rounding error is the difference between the rounded
372         // value and the ideal value. The relative rounding error is the
373         // absolute rounding error divided by the absolute value of the
374         // ideal value. This is undefined when the ideal value is zero.
375         //
376         // The ideal value is `numerator * target / denominator`.
377         // Let's call `numerator * target % denominator` the remainder.
378         // The absolute error is `remainder / denominator`.
379         //
380         // When the ideal value is zero, we require the absolute error to
381         // be zero. Fortunately, this is always the case. The ideal value is
382         // zero iff `numerator == 0` and/or `target == 0`. In this case the
383         // remainder and absolute error are also zero. 
384         if (target == 0 || numerator == 0) {
385             return false;
386         }
387         
388         // Otherwise, we want the relative rounding error to be strictly
389         // less than 0.1%.
390         // The relative error is `remainder / (numerator * target)`.
391         // We want the relative error less than 1 / 1000:
392         //        remainder / (numerator * denominator)  <  1 / 1000
393         // or equivalently:
394         //        1000 * remainder  <  numerator * target
395         // so we have a rounding error iff:
396         //        1000 * remainder  >=  numerator * target
397         uint256 remainder = mulmod(
398             target,
399             numerator,
400             denominator
401         );
402         isError = SafeMath.mul(1000, remainder) >= SafeMath.mul(numerator, target);
403         return isError;
404     }
405 }
406 
407 contract BZxTo0x is BZxTo0xShared, EIP20Wrapper, BZxOwnable {
408     using SafeMath for uint256;
409 
410     address public exchangeContract;
411     address public zrxTokenContract;
412     address public tokenTransferProxyContract;
413 
414     constructor(
415         address _exchange,
416         address _zrxToken,
417         address _proxy)
418         public
419     {
420         exchangeContract = _exchange;
421         zrxTokenContract = _zrxToken;
422         tokenTransferProxyContract = _proxy;
423     }
424 
425     function()
426         external {
427         revert();
428     }
429 
430    function take0xTrade(
431         address trader,
432         address vaultAddress,
433         uint256 sourceTokenAmountToUse,
434         bytes memory orderData0x, // 0x order arguments, converted to hex, padded to 32 bytes and concatenated
435         bytes memory signature0x) // ECDSA of the 0x order
436         public
437         onlyBZx
438         returns (
439             address destTokenAddress,
440             uint256 destTokenAmount,
441             uint256 sourceTokenUsedAmount)
442     {
443         (address[5][] memory orderAddresses0x, uint256[6][] memory orderValues0x) = getOrderValuesFromData(orderData0x);
444 
445         (sourceTokenUsedAmount, destTokenAmount) = _take0xTrade(
446             trader,
447             sourceTokenAmountToUse,
448             orderAddresses0x,
449             orderValues0x,
450             signature0x);
451 
452         if (sourceTokenUsedAmount < sourceTokenAmountToUse) {
453             // all sourceToken has to be traded
454             revert("BZxTo0x::take0xTrade: sourceTokenUsedAmount < sourceTokenAmountToUse");
455         }
456 
457         // transfer the destToken to the vault
458         eip20Transfer(
459             orderAddresses0x[0][2],
460             vaultAddress,
461             destTokenAmount);
462 
463         destTokenAddress = orderAddresses0x[0][2]; // makerToken (aka destTokenAddress)
464     }
465 
466     function getOrderValuesFromData(
467         bytes memory orderData0x)
468         public
469         pure
470         returns (
471             address[5][] memory orderAddresses,
472             uint256[6][] memory orderValues)
473     {
474         address maker;
475         address taker;
476         address makerToken;
477         address takerToken;
478         address feeRecipient;
479         uint256 makerTokenAmount;
480         uint256 takerTokenAmount;
481         uint256 makerFee;
482         uint256 takerFee;
483         uint256 expirationTimestampInSec;
484         uint256 salt;
485         orderAddresses = new address[5][](orderData0x.length/352);
486         orderValues = new uint256[6][](orderData0x.length/352);
487         for (uint256 i = 0; i < orderData0x.length/352; i++) {
488             assembly {
489                 maker := mload(add(orderData0x, add(mul(i, 352), 32)))
490                 taker := mload(add(orderData0x, add(mul(i, 352), 64)))
491                 makerToken := mload(add(orderData0x, add(mul(i, 352), 96)))
492                 takerToken := mload(add(orderData0x, add(mul(i, 352), 128)))
493                 feeRecipient := mload(add(orderData0x, add(mul(i, 352), 160)))
494                 makerTokenAmount := mload(add(orderData0x, add(mul(i, 352), 192)))
495                 takerTokenAmount := mload(add(orderData0x, add(mul(i, 352), 224)))
496                 makerFee := mload(add(orderData0x, add(mul(i, 352), 256)))
497                 takerFee := mload(add(orderData0x, add(mul(i, 352), 288)))
498                 expirationTimestampInSec := mload(add(orderData0x, add(mul(i, 352), 320)))
499                 salt := mload(add(orderData0x, add(mul(i, 352), 352)))
500             }
501             orderAddresses[i] = [
502                 maker,
503                 taker,
504                 makerToken,
505                 takerToken,
506                 feeRecipient
507             ];
508             orderValues[i] = [
509                 makerTokenAmount,
510                 takerTokenAmount,
511                 makerFee,
512                 takerFee,
513                 expirationTimestampInSec,
514                 salt
515             ];
516         }
517     }
518 
519     /// @param signatures ECDSA signatures in raw bytes (rsv).
520     function getSignatureParts(
521         bytes memory signatures)
522         public
523         pure
524         returns (
525             uint8[] memory vs,
526             bytes32[] memory rs,
527             bytes32[] memory ss)
528     {
529         vs = new uint8[](signatures.length/65);
530         rs = new bytes32[](signatures.length/65);
531         ss = new bytes32[](signatures.length/65);
532         for (uint256 i = 0; i < signatures.length/65; i++) {
533             uint8 v;
534             bytes32 r;
535             bytes32 s;
536             assembly {
537                 r := mload(add(signatures, add(mul(i, 65), 32)))
538                 s := mload(add(signatures, add(mul(i, 65), 64)))
539                 v := mload(add(signatures, add(mul(i, 65), 65)))
540             }
541             if (v < 27) {
542                 v = v + 27;
543             }
544             vs[i] = v;
545             rs[i] = r;
546             ss[i] = s;
547         }
548     }
549 
550     function set0xExchange (
551         address _exchange)
552         public
553         onlyOwner
554     {
555         exchangeContract = _exchange;
556     }
557 
558     function setZRXToken (
559         address _zrxToken)
560         public
561         onlyOwner
562     {
563         zrxTokenContract = _zrxToken;
564     }
565 
566     function set0xTokenProxy (
567         address _proxy)
568         public
569         onlyOwner
570     {
571         tokenTransferProxyContract = _proxy;
572     }
573 
574     function approveFor (
575         address token,
576         address spender,
577         uint256 value)
578         public
579         onlyOwner
580         returns (bool)
581     {
582         eip20Approve(
583             token,
584             spender,
585             value);
586 
587         return true;
588     }
589 
590     function _take0xTrade(
591         address trader,
592         uint256 sourceTokenAmountToUse,
593         address[5][] memory orderAddresses0x,
594         uint256[6][] memory orderValues0x,
595         bytes memory signature)
596         internal
597         returns (uint256 sourceTokenUsedAmount, uint256 destTokenAmount)
598     {
599         uint256[4] memory summations; // takerTokenAmountTotal, makerTokenAmountTotal, zrxTokenAmount, takerTokenRemaining
600         summations[3] = sourceTokenAmountToUse; // takerTokenRemaining
601 
602         for (uint256 i = 0; i < orderAddresses0x.length; i++) {
603             // Note: takerToken is confirmed to be the same in 0x for batch orders
604             require(orderAddresses0x[i][2] == orderAddresses0x[0][2], "makerToken must be the same for each order"); // // makerToken (aka destTokenAddress) must be the same for each order
605 
606             summations[0] = summations[0].add(orderValues0x[i][1]); // takerTokenAmountTotal
607             summations[1] = summations[1].add(orderValues0x[i][0]); // makerTokenAmountTotal
608 
609             // calculate required takerFee
610             if (summations[3] > 0 && orderAddresses0x[i][4] != address(0) && // feeRecipient
611                     orderValues0x[i][3] > 0 // takerFee
612             ) {
613                 if (summations[3] >= orderValues0x[i][1]) {
614                     summations[2] = summations[2].add(orderValues0x[i][3]); // takerFee
615                     summations[3] = summations[3].sub(orderValues0x[i][1]); // takerTokenAmount
616                 } else {
617                     summations[2] = summations[2].add(_safeGetPartialAmountFloor(
618                         summations[3],
619                         orderValues0x[i][1], // takerTokenAmount
620                         orderValues0x[i][3] // takerFee
621                     ));
622                     summations[3] = 0;
623                 }
624             }
625         }
626 
627         if (summations[2] > 0) {
628             // The 0x TokenTransferProxy already has unlimited transfer allowance for ZRX from this contract (set during deployment of this contract)
629             eip20TransferFrom(
630                 zrxTokenContract,
631                 trader,
632                 address(this),
633                 summations[2]);
634         }
635 
636         (uint8[] memory v, bytes32[] memory r, bytes32[] memory s) = getSignatureParts(signature);
637 
638         // Make sure there is enough allowance for 0x Exchange Proxy to transfer the sourceToken needed for the 0x trade
639         // orderAddresses0x[0][3] -> takerToken/sourceToken
640         uint256 tempAllowance = EIP20(orderAddresses0x[0][3]).allowance(address(this), tokenTransferProxyContract);
641         if (tempAllowance < sourceTokenAmountToUse) {
642             if (tempAllowance > 0) {
643                 // reset approval to 0
644                 eip20Approve(
645                     orderAddresses0x[0][3],
646                     tokenTransferProxyContract,
647                     0);
648             }
649 
650             eip20Approve(
651                 orderAddresses0x[0][3],
652                 tokenTransferProxyContract,
653                 sourceTokenAmountToUse);
654         }
655 
656         if (orderAddresses0x.length > 1) {
657             sourceTokenUsedAmount = ExchangeInterface(exchangeContract).fillOrdersUpTo(
658                 orderAddresses0x,
659                 orderValues0x,
660                 sourceTokenAmountToUse,
661                 false, // shouldThrowOnInsufficientBalanceOrAllowance
662                 v,
663                 r,
664                 s);
665         } else {
666             sourceTokenUsedAmount = ExchangeInterface(exchangeContract).fillOrder(
667                 orderAddresses0x[0],
668                 orderValues0x[0],
669                 sourceTokenAmountToUse,
670                 false, // shouldThrowOnInsufficientBalanceOrAllowance
671                 v[0],
672                 r[0],
673                 s[0]);
674         }
675 
676         destTokenAmount = _safeGetPartialAmountFloor(
677             sourceTokenUsedAmount,
678             summations[0], // takerTokenAmountTotal (aka sourceTokenAmount)
679             summations[1]  // makerTokenAmountTotal (aka destTokenAmount)
680         );
681     }
682 }