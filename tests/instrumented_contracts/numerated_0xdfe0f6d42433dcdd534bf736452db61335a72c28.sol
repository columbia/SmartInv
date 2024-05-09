1 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title Helps contracts guard against reentrancy attacks.
7  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
8  * @dev If you mark a function `nonReentrant`, you should also
9  * mark it `external`.
10  */
11 contract ReentrancyGuard {
12     /// @dev counter to allow mutex lock with only one SSTORE operation
13     uint256 private _guardCounter;
14 
15     constructor () internal {
16         // The counter starts at one to prevent changing it from zero to a non-zero
17         // value, which is a more expensive operation.
18         _guardCounter = 1;
19     }
20 
21     /**
22      * @dev Prevents a contract from calling itself, directly or indirectly.
23      * Calling a `nonReentrant` function from another `nonReentrant`
24      * function is not supported. It is possible to prevent this from happening
25      * by making the `nonReentrant` function external, and make it call a
26      * `private` function that does the actual work.
27      */
28     modifier nonReentrant() {
29         _guardCounter += 1;
30         uint256 localCounter = _guardCounter;
31         _;
32         require(localCounter == _guardCounter);
33     }
34 }
35 
36 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
37 
38 pragma solidity ^0.5.2;
39 
40 /**
41  * @title SafeMath
42  * @dev Unsigned math operations with safety checks that revert on error
43  */
44 library SafeMath {
45     /**
46      * @dev Multiplies two unsigned integers, reverts on overflow.
47      */
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50         // benefit is lost if 'b' is also tested.
51         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
52         if (a == 0) {
53             return 0;
54         }
55 
56         uint256 c = a * b;
57         require(c / a == b);
58 
59         return c;
60     }
61 
62     /**
63      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
64      */
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         // Solidity only automatically asserts when dividing by 0
67         require(b > 0);
68         uint256 c = a / b;
69         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71         return c;
72     }
73 
74     /**
75      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76      */
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         require(b <= a);
79         uint256 c = a - b;
80 
81         return c;
82     }
83 
84     /**
85      * @dev Adds two unsigned integers, reverts on overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a);
90 
91         return c;
92     }
93 
94     /**
95      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
96      * reverts when dividing by zero.
97      */
98     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99         require(b != 0);
100         return a % b;
101     }
102 }
103 
104 // File: contracts/lib/CommonMath.sol
105 
106 /*
107     Copyright 2018 Set Labs Inc.
108 
109     Licensed under the Apache License, Version 2.0 (the "License");
110     you may not use this file except in compliance with the License.
111     You may obtain a copy of the License at
112 
113     http://www.apache.org/licenses/LICENSE-2.0
114 
115     Unless required by applicable law or agreed to in writing, software
116     distributed under the License is distributed on an "AS IS" BASIS,
117     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
118     See the License for the specific language governing permissions and
119     limitations under the License.
120 */
121 
122 pragma solidity 0.5.7;
123 
124 
125 
126 library CommonMath {
127     using SafeMath for uint256;
128 
129     uint256 public constant SCALE_FACTOR = 10 ** 18;
130     uint256 public constant MAX_UINT_256 = 2 ** 256 - 1;
131 
132     /**
133      * Returns scale factor equal to 10 ** 18
134      *
135      * @return  10 ** 18
136      */
137     function scaleFactor()
138         internal
139         pure
140         returns (uint256)
141     {
142         return SCALE_FACTOR;
143     }
144 
145     /**
146      * Calculates and returns the maximum value for a uint256
147      *
148      * @return  The maximum value for uint256
149      */
150     function maxUInt256()
151         internal
152         pure
153         returns (uint256)
154     {
155         return MAX_UINT_256;
156     }
157 
158     /**
159      * Increases a value by the scale factor to allow for additional precision
160      * during mathematical operations
161      */
162     function scale(
163         uint256 a
164     )
165         internal
166         pure
167         returns (uint256)
168     {
169         return a.mul(SCALE_FACTOR);
170     }
171 
172     /**
173      * Divides a value by the scale factor to allow for additional precision
174      * during mathematical operations
175     */
176     function deScale(
177         uint256 a
178     )
179         internal
180         pure
181         returns (uint256)
182     {
183         return a.div(SCALE_FACTOR);
184     }
185 
186     /**
187     * @dev Performs the power on a specified value, reverts on overflow.
188     */
189     function safePower(
190         uint256 a,
191         uint256 pow
192     )
193         internal
194         pure
195         returns (uint256)
196     {
197         require(a > 0);
198 
199         uint256 result = 1;
200         for (uint256 i = 0; i < pow; i++){
201             uint256 previousResult = result;
202 
203             // Using safemath multiplication prevents overflows
204             result = previousResult.mul(a);
205         }
206 
207         return result;
208     }
209 
210     /**
211     * @dev Performs division where if there is a modulo, the value is rounded up
212     */
213     function divCeil(uint256 a, uint256 b)
214         internal
215         pure
216         returns(uint256)
217     {
218         return a.mod(b) > 0 ? a.div(b).add(1) : a.div(b);
219     }
220 
221     /**
222      * Checks for rounding errors and returns value of potential partial amounts of a principal
223      *
224      * @param  _principal       Number fractional amount is derived from
225      * @param  _numerator       Numerator of fraction
226      * @param  _denominator     Denominator of fraction
227      * @return uint256          Fractional amount of principal calculated
228      */
229     function getPartialAmount(
230         uint256 _principal,
231         uint256 _numerator,
232         uint256 _denominator
233     )
234         internal
235         pure
236         returns (uint256)
237     {
238         // Get remainder of partial amount (if 0 not a partial amount)
239         uint256 remainder = mulmod(_principal, _numerator, _denominator);
240 
241         // Return if not a partial amount
242         if (remainder == 0) {
243             return _principal.mul(_numerator).div(_denominator);
244         }
245 
246         // Calculate error percentage
247         uint256 errPercentageTimes1000000 = remainder.mul(1000000).div(_numerator.mul(_principal));
248 
249         // Require error percentage is less than 0.1%.
250         require(
251             errPercentageTimes1000000 < 1000,
252             "CommonMath.getPartialAmount: Rounding error exceeds bounds"
253         );
254 
255         return _principal.mul(_numerator).div(_denominator);
256     }
257 
258     /*
259      * Gets the rounded up log10 of passed value
260      *
261      * @param  _value         Value to calculate ceil(log()) on
262      * @return uint256        Output value
263      */
264     function ceilLog10(
265         uint256 _value
266     )
267         internal
268         pure
269         returns (uint256)
270     {
271         // Make sure passed value is greater than 0
272         require (
273             _value > 0,
274             "CommonMath.ceilLog10: Value must be greater than zero."
275         );
276 
277         // Since log10(1) = 0, if _value = 1 return 0
278         if (_value == 1) return 0;
279 
280         // Calcualte ceil(log10())
281         uint256 x = _value - 1;
282 
283         uint256 result = 0;
284 
285         if (x >= 10 ** 64) {
286             x /= 10 ** 64;
287             result += 64;
288         }
289         if (x >= 10 ** 32) {
290             x /= 10 ** 32;
291             result += 32;
292         }
293         if (x >= 10 ** 16) {
294             x /= 10 ** 16;
295             result += 16;
296         }
297         if (x >= 10 ** 8) {
298             x /= 10 ** 8;
299             result += 8;
300         }
301         if (x >= 10 ** 4) {
302             x /= 10 ** 4;
303             result += 4;
304         }
305         if (x >= 100) {
306             x /= 100;
307             result += 2;
308         }
309         if (x >= 10) {
310             result += 1;
311         }
312 
313         return result + 1;
314     }
315 }
316 
317 // File: contracts/lib/CompoundUtils.sol
318 
319 /*
320     Copyright 2020 Set Labs Inc.
321 
322     Licensed under the Apache License, Version 2.0 (the "License");
323     you may not use this file except in compliance with the License.
324     You may obtain a copy of the License at
325 
326     http://www.apache.org/licenses/LICENSE-2.0
327 
328     Unless required by applicable law or agreed to in writing, software
329     distributed under the License is distributed on an "AS IS" BASIS,
330     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
331     See the License for the specific language governing permissions and
332     limitations under the License.
333 */
334 
335 pragma solidity 0.5.7;
336 
337 
338 
339 
340 /**
341  * @title CompoundUtils
342  * @author Set Protocol
343  *
344  * Collection of common Compound functions for use in Set Protocol contracts
345  */
346 library CompoundUtils
347 {
348     using SafeMath for uint256;
349 
350     /*
351      * Utility function to convert a specified amount of cTokens to underlying
352      * token based on the cToken's exchange rate
353      *
354      * @param _cTokenAmount         Amount of cTokens that will be converted to underlying
355      * @param _cTokenExchangeRate   Exchange rate for the cToken
356      * @return underlyingAmount     Amount of underlying ERC20 tokens
357      */
358     function convertCTokenToUnderlying(
359         uint256 _cTokenAmount,
360         uint256 _cTokenExchangeRate
361     )
362     internal
363     pure
364     returns (uint256)
365     {
366         // Underlying units is calculated as cToken quantity * exchangeRate divided by 10 ** 18 and rounded up.
367         uint256 a = _cTokenAmount.mul(_cTokenExchangeRate);
368         uint256 b = CommonMath.scaleFactor();
369 
370         // Round value up
371         return CommonMath.divCeil(a, b);
372     }
373 }
374 
375 // File: contracts/lib/IERC20.sol
376 
377 /*
378     Copyright 2018 Set Labs Inc.
379 
380     Licensed under the Apache License, Version 2.0 (the "License");
381     you may not use this file except in compliance with the License.
382     You may obtain a copy of the License at
383 
384     http://www.apache.org/licenses/LICENSE-2.0
385 
386     Unless required by applicable law or agreed to in writing, software
387     distributed under the License is distributed on an "AS IS" BASIS,
388     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
389     See the License for the specific language governing permissions and
390     limitations under the License.
391 */
392 
393 pragma solidity 0.5.7;
394 
395 
396 /**
397  * @title IERC20
398  * @author Set Protocol
399  *
400  * Interface for using ERC20 Tokens. This interface is needed to interact with tokens that are not
401  * fully ERC20 compliant and return something other than true on successful transfers.
402  */
403 interface IERC20 {
404     function balanceOf(
405         address _owner
406     )
407         external
408         view
409         returns (uint256);
410 
411     function allowance(
412         address _owner,
413         address _spender
414     )
415         external
416         view
417         returns (uint256);
418 
419     function transfer(
420         address _to,
421         uint256 _quantity
422     )
423         external;
424 
425     function transferFrom(
426         address _from,
427         address _to,
428         uint256 _quantity
429     )
430         external;
431 
432     function approve(
433         address _spender,
434         uint256 _quantity
435     )
436         external
437         returns (bool);
438 
439     function totalSupply()
440         external
441         returns (uint256);
442 }
443 
444 // File: contracts/lib/ERC20Wrapper.sol
445 
446 /*
447     Copyright 2018 Set Labs Inc.
448 
449     Licensed under the Apache License, Version 2.0 (the "License");
450     you may not use this file except in compliance with the License.
451     You may obtain a copy of the License at
452 
453     http://www.apache.org/licenses/LICENSE-2.0
454 
455     Unless required by applicable law or agreed to in writing, software
456     distributed under the License is distributed on an "AS IS" BASIS,
457     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
458     See the License for the specific language governing permissions and
459     limitations under the License.
460 */
461 
462 pragma solidity 0.5.7;
463 
464 
465 
466 
467 /**
468  * @title ERC20Wrapper
469  * @author Set Protocol
470  *
471  * This library contains functions for interacting wtih ERC20 tokens, even those not fully compliant.
472  * For all functions we will only accept tokens that return a null or true value, any other values will
473  * cause the operation to revert.
474  */
475 library ERC20Wrapper {
476 
477     // ============ Internal Functions ============
478 
479     /**
480      * Check balance owner's balance of ERC20 token
481      *
482      * @param  _token          The address of the ERC20 token
483      * @param  _owner          The owner who's balance is being checked
484      * @return  uint256        The _owner's amount of tokens
485      */
486     function balanceOf(
487         address _token,
488         address _owner
489     )
490         external
491         view
492         returns (uint256)
493     {
494         return IERC20(_token).balanceOf(_owner);
495     }
496 
497     /**
498      * Checks spender's allowance to use token's on owner's behalf.
499      *
500      * @param  _token          The address of the ERC20 token
501      * @param  _owner          The token owner address
502      * @param  _spender        The address the allowance is being checked on
503      * @return  uint256        The spender's allowance on behalf of owner
504      */
505     function allowance(
506         address _token,
507         address _owner,
508         address _spender
509     )
510         internal
511         view
512         returns (uint256)
513     {
514         return IERC20(_token).allowance(_owner, _spender);
515     }
516 
517     /**
518      * Transfers tokens from an address. Handle's tokens that return true or null.
519      * If other value returned, reverts.
520      *
521      * @param  _token          The address of the ERC20 token
522      * @param  _to             The address to transfer to
523      * @param  _quantity       The amount of tokens to transfer
524      */
525     function transfer(
526         address _token,
527         address _to,
528         uint256 _quantity
529     )
530         external
531     {
532         IERC20(_token).transfer(_to, _quantity);
533 
534         // Check that transfer returns true or null
535         require(
536             checkSuccess(),
537             "ERC20Wrapper.transfer: Bad return value"
538         );
539     }
540 
541     /**
542      * Transfers tokens from an address (that has set allowance on the proxy).
543      * Handle's tokens that return true or null. If other value returned, reverts.
544      *
545      * @param  _token          The address of the ERC20 token
546      * @param  _from           The address to transfer from
547      * @param  _to             The address to transfer to
548      * @param  _quantity       The number of tokens to transfer
549      */
550     function transferFrom(
551         address _token,
552         address _from,
553         address _to,
554         uint256 _quantity
555     )
556         external
557     {
558         IERC20(_token).transferFrom(_from, _to, _quantity);
559 
560         // Check that transferFrom returns true or null
561         require(
562             checkSuccess(),
563             "ERC20Wrapper.transferFrom: Bad return value"
564         );
565     }
566 
567     /**
568      * Grants spender ability to spend on owner's behalf.
569      * Handle's tokens that return true or null. If other value returned, reverts.
570      *
571      * @param  _token          The address of the ERC20 token
572      * @param  _spender        The address to approve for transfer
573      * @param  _quantity       The amount of tokens to approve spender for
574      */
575     function approve(
576         address _token,
577         address _spender,
578         uint256 _quantity
579     )
580         internal
581     {
582         IERC20(_token).approve(_spender, _quantity);
583 
584         // Check that approve returns true or null
585         require(
586             checkSuccess(),
587             "ERC20Wrapper.approve: Bad return value"
588         );
589     }
590 
591     /**
592      * Ensure's the owner has granted enough allowance for system to
593      * transfer tokens.
594      *
595      * @param  _token          The address of the ERC20 token
596      * @param  _owner          The address of the token owner
597      * @param  _spender        The address to grant/check allowance for
598      * @param  _quantity       The amount to see if allowed for
599      */
600     function ensureAllowance(
601         address _token,
602         address _owner,
603         address _spender,
604         uint256 _quantity
605     )
606         internal
607     {
608         uint256 currentAllowance = allowance(_token, _owner, _spender);
609         if (currentAllowance < _quantity) {
610             approve(
611                 _token,
612                 _spender,
613                 CommonMath.maxUInt256()
614             );
615         }
616     }
617 
618     // ============ Private Functions ============
619 
620     /**
621      * Checks the return value of the previous function up to 32 bytes. Returns true if the previous
622      * function returned 0 bytes or 1.
623      */
624     function checkSuccess(
625     )
626         private
627         pure
628         returns (bool)
629     {
630         // default to failure
631         uint256 returnValue = 0;
632 
633         assembly {
634             // check number of bytes returned from last function call
635             switch returndatasize
636 
637             // no bytes returned: assume success
638             case 0x0 {
639                 returnValue := 1
640             }
641 
642             // 32 bytes returned
643             case 0x20 {
644                 // copy 32 bytes into scratch space
645                 returndatacopy(0x0, 0x0, 0x20)
646 
647                 // load those bytes into returnValue
648                 returnValue := mload(0x0)
649             }
650 
651             // not sure what was returned: dont mark as success
652             default { }
653         }
654 
655         // check if returned value is one or nothing
656         return returnValue == 1;
657     }
658 }
659 
660 // File: contracts/core/interfaces/ICToken.sol
661 
662 /*
663     Copyright 2020 Set Labs Inc.
664 
665     Licensed under the Apache License, Version 2.0 (the "License");
666     you may not use this file except in compliance with the License.
667     You may obtain a copy of the License at
668 
669     http://www.apache.org/licenses/LICENSE-2.0
670 
671     Unless required by applicable law or agreed to in writing, software
672     distributed under the License is distributed on an "AS IS" BASIS,
673     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
674     See the License for the specific language governing permissions and
675     limitations under the License.
676 */
677 
678 pragma solidity 0.5.7;
679 
680 
681 /**
682  * @title ICToken
683  * @author Set Protocol
684  *
685  * Interface for interacting with Compound cTokens
686  */
687 interface ICToken {
688 
689     /**
690      * Calculates the exchange rate from the underlying to the CToken
691      *
692      * @notice Accrue interest then return the up-to-date exchange rate
693      * @return Calculated exchange rate scaled by 1e18
694      */
695     function exchangeRateCurrent()
696         external
697         returns (uint256);
698 
699     function exchangeRateStored() external view returns (uint256);
700 
701     function decimals() external view returns(uint8);
702 
703     /**
704      * Sender supplies assets into the market and receives cTokens in exchange
705      *
706      * @notice Accrues interest whether or not the operation succeeds, unless reverted
707      * @param mintAmount The amount of the underlying asset to supply
708      * @return uint 0=success, otherwise a failure
709      */
710     function mint(uint mintAmount) external returns (uint);
711 
712     /**
713      * @notice Sender redeems cTokens in exchange for the underlying asset
714      * @dev Accrues interest whether or not the operation succeeds, unless reverted
715      * @param redeemTokens The number of cTokens to redeem into underlying
716      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
717      */
718     function redeem(uint redeemTokens) external returns (uint);
719 }
720 
721 // File: contracts/core/interfaces/IRebalanceAuctionModule.sol
722 
723 /*
724     Copyright 2019 Set Labs Inc.
725 
726     Licensed under the Apache License, Version 2.0 (the "License");
727     you may not use this file except in compliance with the License.
728     You may obtain a copy of the License at
729 
730     http://www.apache.org/licenses/LICENSE-2.0
731 
732     Unless required by applicable law or agreed to in writing, software
733     distributed under the License is distributed on an "AS IS" BASIS,
734     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
735     See the License for the specific language governing permissions and
736     limitations under the License.
737 */
738 
739 pragma solidity 0.5.7;
740 pragma experimental "ABIEncoderV2";
741 
742 /**
743  * @title IRebalanceAuctionModule
744  * @author Set Protocol
745  *
746  * The IRebalanceAuctionModule interface provides a light-weight, structured way to interact with the
747  * RebalanceAuctionModule contract from another contract.
748  */
749 
750 interface IRebalanceAuctionModule {
751     /**
752      * Bid on rebalancing a given quantity of sets held by a rebalancing token
753      * The tokens are returned to the user.
754      *
755      * @param  _rebalancingSetToken    Address of the rebalancing token being bid on
756      * @param  _quantity               Number of currentSets to rebalance
757      * @param  _allowPartialFill       Set to true if want to partially fill bid when quantity
758      *                                 is greater than currentRemainingSets
759      */
760     function bidAndWithdraw(
761         address _rebalancingSetToken,
762         uint256 _quantity,
763         bool _allowPartialFill
764     )
765         external;
766 }
767 
768 // File: contracts/core/lib/RebalancingLibrary.sol
769 
770 /*
771     Copyright 2018 Set Labs Inc.
772 
773     Licensed under the Apache License, Version 2.0 (the "License");
774     you may not use this file except in compliance with the License.
775     You may obtain a copy of the License at
776 
777     http://www.apache.org/licenses/LICENSE-2.0
778 
779     Unless required by applicable law or agreed to in writing, software
780     distributed under the License is distributed on an "AS IS" BASIS,
781     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
782     See the License for the specific language governing permissions and
783     limitations under the License.
784 */
785 
786 pragma solidity 0.5.7;
787 
788 
789 /**
790  * @title RebalancingLibrary
791  * @author Set Protocol
792  *
793  * The RebalancingLibrary contains functions for facilitating the rebalancing process for
794  * Rebalancing Set Tokens. Removes the old calculation functions
795  *
796  */
797 library RebalancingLibrary {
798 
799     /* ============ Enums ============ */
800 
801     enum State { Default, Proposal, Rebalance, Drawdown }
802 
803     /* ============ Structs ============ */
804 
805     struct AuctionPriceParameters {
806         uint256 auctionStartTime;
807         uint256 auctionTimeToPivot;
808         uint256 auctionStartPrice;
809         uint256 auctionPivotPrice;
810     }
811 
812     struct BiddingParameters {
813         uint256 minimumBid;
814         uint256 remainingCurrentSets;
815         uint256[] combinedCurrentUnits;
816         uint256[] combinedNextSetUnits;
817         address[] combinedTokenArray;
818     }
819 }
820 
821 // File: contracts/core/interfaces/IRebalancingSetToken.sol
822 
823 /*
824     Copyright 2018 Set Labs Inc.
825 
826     Licensed under the Apache License, Version 2.0 (the "License");
827     you may not use this file except in compliance with the License.
828     You may obtain a copy of the License at
829 
830     http://www.apache.org/licenses/LICENSE-2.0
831 
832     Unless required by applicable law or agreed to in writing, software
833     distributed under the License is distributed on an "AS IS" BASIS,
834     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
835     See the License for the specific language governing permissions and
836     limitations under the License.
837 */
838 
839 pragma solidity 0.5.7;
840 
841 
842 /**
843  * @title IRebalancingSetToken
844  * @author Set Protocol
845  *
846  * The IRebalancingSetToken interface provides a light-weight, structured way to interact with the
847  * RebalancingSetToken contract from another contract.
848  */
849 
850 interface IRebalancingSetToken {
851 
852     /*
853      * Get the auction library contract used for the current rebalance
854      *
855      * @return address    Address of auction library used in the upcoming auction
856      */
857     function auctionLibrary()
858         external
859         view
860         returns (address);
861 
862     /*
863      * Get totalSupply of Rebalancing Set
864      *
865      * @return  totalSupply
866      */
867     function totalSupply()
868         external
869         view
870         returns (uint256);
871 
872     /*
873      * Get proposalTimeStamp of Rebalancing Set
874      *
875      * @return  proposalTimeStamp
876      */
877     function proposalStartTime()
878         external
879         view
880         returns (uint256);
881 
882     /*
883      * Get lastRebalanceTimestamp of Rebalancing Set
884      *
885      * @return  lastRebalanceTimestamp
886      */
887     function lastRebalanceTimestamp()
888         external
889         view
890         returns (uint256);
891 
892     /*
893      * Get rebalanceInterval of Rebalancing Set
894      *
895      * @return  rebalanceInterval
896      */
897     function rebalanceInterval()
898         external
899         view
900         returns (uint256);
901 
902     /*
903      * Get rebalanceState of Rebalancing Set
904      *
905      * @return RebalancingLibrary.State    Current rebalance state of the RebalancingSetToken
906      */
907     function rebalanceState()
908         external
909         view
910         returns (RebalancingLibrary.State);
911 
912     /*
913      * Get the starting amount of current SetToken for the current auction
914      *
915      * @return  rebalanceState
916      */
917     function startingCurrentSetAmount()
918         external
919         view
920         returns (uint256);
921 
922     /**
923      * Gets the balance of the specified address.
924      *
925      * @param owner      The address to query the balance of.
926      * @return           A uint256 representing the amount owned by the passed address.
927      */
928     function balanceOf(
929         address owner
930     )
931         external
932         view
933         returns (uint256);
934 
935     /**
936      * Function used to set the terms of the next rebalance and start the proposal period
937      *
938      * @param _nextSet                      The Set to rebalance into
939      * @param _auctionLibrary               The library used to calculate the Dutch Auction price
940      * @param _auctionTimeToPivot           The amount of time for the auction to go ffrom start to pivot price
941      * @param _auctionStartPrice            The price to start the auction at
942      * @param _auctionPivotPrice            The price at which the price curve switches from linear to exponential
943      */
944     function propose(
945         address _nextSet,
946         address _auctionLibrary,
947         uint256 _auctionTimeToPivot,
948         uint256 _auctionStartPrice,
949         uint256 _auctionPivotPrice
950     )
951         external;
952 
953     /*
954      * Get natural unit of Set
955      *
956      * @return  uint256       Natural unit of Set
957      */
958     function naturalUnit()
959         external
960         view
961         returns (uint256);
962 
963     /**
964      * Returns the address of the current base SetToken with the current allocation
965      *
966      * @return           A address representing the base SetToken
967      */
968     function currentSet()
969         external
970         view
971         returns (address);
972 
973     /**
974      * Returns the address of the next base SetToken with the post auction allocation
975      *
976      * @return  address    Address representing the base SetToken
977      */
978     function nextSet()
979         external
980         view
981         returns (address);
982 
983     /*
984      * Get the unit shares of the rebalancing Set
985      *
986      * @return  unitShares       Unit Shares of the base Set
987      */
988     function unitShares()
989         external
990         view
991         returns (uint256);
992 
993     /*
994      * Burn set token for given address.
995      * Can only be called by authorized contracts.
996      *
997      * @param  _from        The address of the redeeming account
998      * @param  _quantity    The number of sets to burn from redeemer
999      */
1000     function burn(
1001         address _from,
1002         uint256 _quantity
1003     )
1004         external;
1005 
1006     /*
1007      * Place bid during rebalance auction. Can only be called by Core.
1008      *
1009      * @param _quantity                 The amount of currentSet to be rebalanced
1010      * @return combinedTokenArray       Array of token addresses invovled in rebalancing
1011      * @return inflowUnitArray          Array of amount of tokens inserted into system in bid
1012      * @return outflowUnitArray         Array of amount of tokens taken out of system in bid
1013      */
1014     function placeBid(
1015         uint256 _quantity
1016     )
1017         external
1018         returns (address[] memory, uint256[] memory, uint256[] memory);
1019 
1020     /*
1021      * Get combinedTokenArray of Rebalancing Set
1022      *
1023      * @return  combinedTokenArray
1024      */
1025     function getCombinedTokenArrayLength()
1026         external
1027         view
1028         returns (uint256);
1029 
1030     /*
1031      * Get combinedTokenArray of Rebalancing Set
1032      *
1033      * @return  combinedTokenArray
1034      */
1035     function getCombinedTokenArray()
1036         external
1037         view
1038         returns (address[] memory);
1039 
1040     /*
1041      * Get failedAuctionWithdrawComponents of Rebalancing Set
1042      *
1043      * @return  failedAuctionWithdrawComponents
1044      */
1045     function getFailedAuctionWithdrawComponents()
1046         external
1047         view
1048         returns (address[] memory);
1049 
1050     /*
1051      * Get auctionPriceParameters for current auction
1052      *
1053      * @return uint256[4]    AuctionPriceParameters for current rebalance auction
1054      */
1055     function getAuctionPriceParameters()
1056         external
1057         view
1058         returns (uint256[] memory);
1059 
1060     /*
1061      * Get biddingParameters for current auction
1062      *
1063      * @return uint256[2]    BiddingParameters for current rebalance auction
1064      */
1065     function getBiddingParameters()
1066         external
1067         view
1068         returns (uint256[] memory);
1069 
1070     /*
1071      * Get token inflows and outflows required for bid. Also the amount of Rebalancing
1072      * Sets that would be generated.
1073      *
1074      * @param _quantity               The amount of currentSet to be rebalanced
1075      * @return inflowUnitArray        Array of amount of tokens inserted into system in bid
1076      * @return outflowUnitArray       Array of amount of tokens taken out of system in bid
1077      */
1078     function getBidPrice(
1079         uint256 _quantity
1080     )
1081         external
1082         view
1083         returns (uint256[] memory, uint256[] memory);
1084 
1085 }
1086 
1087 // File: contracts/core/interfaces/ITransferProxy.sol
1088 
1089 /*
1090     Copyright 2018 Set Labs Inc.
1091 
1092     Licensed under the Apache License, Version 2.0 (the "License");
1093     you may not use this file except in compliance with the License.
1094     You may obtain a copy of the License at
1095 
1096     http://www.apache.org/licenses/LICENSE-2.0
1097 
1098     Unless required by applicable law or agreed to in writing, software
1099     distributed under the License is distributed on an "AS IS" BASIS,
1100     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1101     See the License for the specific language governing permissions and
1102     limitations under the License.
1103 */
1104 
1105 pragma solidity 0.5.7;
1106 
1107 /**
1108  * @title ITransferProxy
1109  * @author Set Protocol
1110  *
1111  * The ITransferProxy interface provides a light-weight, structured way to interact with the
1112  * TransferProxy contract from another contract.
1113  */
1114 interface ITransferProxy {
1115 
1116     /* ============ External Functions ============ */
1117 
1118     /**
1119      * Transfers tokens from an address (that has set allowance on the proxy).
1120      * Can only be called by authorized core contracts.
1121      *
1122      * @param  _token          The address of the ERC20 token
1123      * @param  _quantity       The number of tokens to transfer
1124      * @param  _from           The address to transfer from
1125      * @param  _to             The address to transfer to
1126      */
1127     function transfer(
1128         address _token,
1129         uint256 _quantity,
1130         address _from,
1131         address _to
1132     )
1133         external;
1134 
1135     /**
1136      * Transfers tokens from an address (that has set allowance on the proxy).
1137      * Can only be called by authorized core contracts.
1138      *
1139      * @param  _tokens         The addresses of the ERC20 token
1140      * @param  _quantities     The numbers of tokens to transfer
1141      * @param  _from           The address to transfer from
1142      * @param  _to             The address to transfer to
1143      */
1144     function batchTransfer(
1145         address[] calldata _tokens,
1146         uint256[] calldata _quantities,
1147         address _from,
1148         address _to
1149     )
1150         external;
1151 }
1152 
1153 // File: contracts/core/lib/Rebalance.sol
1154 
1155 /*
1156     Copyright 2019 Set Labs Inc.
1157 
1158     Licensed under the Apache License, Version 2.0 (the "License");
1159     you may not use this file except in compliance with the License.
1160     You may obtain a copy of the License at
1161 
1162     http://www.apache.org/licenses/LICENSE-2.0
1163 
1164     Unless required by applicable law or agreed to in writing, software
1165     distributed under the License is distributed on an "AS IS" BASIS,
1166     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1167     See the License for the specific language governing permissions and
1168     limitations under the License.
1169 */
1170 
1171 pragma solidity 0.5.7;
1172 
1173 
1174 
1175 /**
1176  * @title Rebalance
1177  * @author Set Protocol
1178  *
1179  * Types and functions for Rebalance-related data.
1180  */
1181 library Rebalance {
1182 
1183     struct TokenFlow {
1184         address[] addresses;
1185         uint256[] inflow;
1186         uint256[] outflow;
1187     }
1188 
1189     function composeTokenFlow(
1190         address[] memory _addresses,
1191         uint256[] memory _inflow,
1192         uint256[] memory _outflow
1193     )
1194         internal
1195         pure
1196         returns(TokenFlow memory)
1197     {
1198         return TokenFlow({addresses: _addresses, inflow: _inflow, outflow: _outflow });
1199     }
1200 
1201     function decomposeTokenFlow(TokenFlow memory _tokenFlow)
1202         internal
1203         pure
1204         returns (address[] memory, uint256[] memory, uint256[] memory)
1205     {
1206         return (_tokenFlow.addresses, _tokenFlow.inflow, _tokenFlow.outflow);
1207     }
1208 
1209     function decomposeTokenFlowToBidPrice(TokenFlow memory _tokenFlow)
1210         internal
1211         pure
1212         returns (uint256[] memory, uint256[] memory)
1213     {
1214         return (_tokenFlow.inflow, _tokenFlow.outflow);
1215     }
1216 
1217     /**
1218      * Get token flows array of addresses, inflows and outflows
1219      *
1220      * @param    _rebalancingSetToken   The rebalancing Set Token instance
1221      * @param    _quantity              The amount of currentSet to be rebalanced
1222      * @return   combinedTokenArray     Array of token addresses
1223      * @return   inflowArray            Array of amount of tokens inserted into system in bid
1224      * @return   outflowArray           Array of amount of tokens returned from system in bid
1225      */
1226     function getTokenFlows(
1227         IRebalancingSetToken _rebalancingSetToken,
1228         uint256 _quantity
1229     )
1230         internal
1231         view
1232         returns (address[] memory, uint256[] memory, uint256[] memory)
1233     {
1234         // Get token addresses
1235         address[] memory combinedTokenArray = _rebalancingSetToken.getCombinedTokenArray();
1236 
1237         // Get inflow and outflow arrays for the given bid quantity
1238         (
1239             uint256[] memory inflowArray,
1240             uint256[] memory outflowArray
1241         ) = _rebalancingSetToken.getBidPrice(_quantity);
1242 
1243         return (combinedTokenArray, inflowArray, outflowArray);
1244     }
1245 }
1246 
1247 // File: contracts/helper/RebalancingSetCTokenBidder.sol
1248 
1249 /*
1250     Copyright 2020 Set Labs Inc.
1251 
1252     Licensed under the Apache License, Version 2.0 (the "License");
1253     you may not use this file except in compliance with the License.
1254     You may obtain a copy of the License at
1255 
1256     http://www.apache.org/licenses/LICENSE-2.0
1257 
1258     Unless required by applicable law or agreed to in writing, software
1259     distributed under the License is distributed on an "AS IS" BASIS,
1260     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1261     See the License for the specific language governing permissions and
1262     limitations under the License.
1263 */
1264 
1265 pragma solidity 0.5.7;
1266 
1267 
1268 
1269 
1270 
1271 
1272 
1273 
1274 
1275 
1276 
1277 
1278 /**
1279  * @title RebalancingSetCTokenBidder
1280  * @author Set Protocol
1281  *
1282  * A helper contract that mints a cToken from its underlying or redeems a cToken into
1283  * its underlying used for bidding in the RebalanceAuctionModule.
1284  */
1285 contract RebalancingSetCTokenBidder is
1286     ReentrancyGuard
1287 {
1288     using SafeMath for uint256;
1289 
1290     // Address and instance of RebalanceAuctionModule contract
1291     IRebalanceAuctionModule public rebalanceAuctionModule;
1292 
1293     // Address and instance of TransferProxy contract
1294     ITransferProxy public transferProxy;
1295 
1296     // Mapping of cToken address to underlying address
1297     mapping (address => address) public cTokenToUnderlying;
1298 
1299     string public dataDescription;
1300 
1301     /* ============ Events ============ */
1302 
1303     event BidPlacedCToken(
1304         address indexed rebalancingSetToken,
1305         address indexed bidder,
1306         uint256 quantity
1307     );
1308 
1309     /* ============ Constructor ============ */
1310 
1311     /**
1312      * Constructor function for RebalancingSetCTokenBidder
1313      *
1314      * @param _rebalanceAuctionModule   The address of RebalanceAuctionModule
1315      * @param _transferProxy            The address of TransferProxy
1316      * @param _cTokenArray              The address array of the target cToken
1317      * @param _underlyingArray          The address array of the target cToken's underlying
1318      * @param _dataDescription          Description of contract for Etherscan / other applications
1319      */
1320     constructor(
1321         IRebalanceAuctionModule _rebalanceAuctionModule,
1322         ITransferProxy _transferProxy,
1323         address[] memory _cTokenArray,
1324         address[] memory _underlyingArray,
1325         string memory _dataDescription
1326     )
1327         public
1328     {
1329         rebalanceAuctionModule = _rebalanceAuctionModule;
1330 
1331         transferProxy = _transferProxy;
1332 
1333         dataDescription = _dataDescription;
1334 
1335         require(
1336             _cTokenArray.length == _underlyingArray.length,
1337             "RebalancingSetCTokenBidder.constructor: cToken array and underlying array must be same length"
1338         );
1339 
1340         for (uint256 i = 0; i < _cTokenArray.length; i++) {
1341             address cTokenAddress = _cTokenArray[i];
1342             address underlyingAddress = _underlyingArray[i];
1343 
1344             // Initialize mapping of cToken to underlying
1345             cTokenToUnderlying[cTokenAddress] = underlyingAddress;
1346 
1347             // Add approvals of the underlying token to the cToken contract
1348             ERC20Wrapper.approve(
1349                 underlyingAddress,
1350                 cTokenAddress,
1351                 CommonMath.maxUInt256()
1352             );
1353 
1354             // Add approvals of the cToken to the transferProxy contract
1355             ERC20Wrapper.approve(
1356                 cTokenAddress,
1357                 address(_transferProxy),
1358                 CommonMath.maxUInt256()
1359             );
1360         }
1361     }
1362 
1363     /* ============ External Functions ============ */
1364 
1365     /**
1366      * Bid on rebalancing a given quantity of sets held by a rebalancing token wrapping or unwrapping
1367      * a target cToken involved. The tokens are returned to the user.
1368      *
1369      * @param  _rebalancingSetToken    Instance of the rebalancing token being bid on
1370      * @param  _quantity               Number of currentSets to rebalance
1371      * @param  _allowPartialFill       Set to true if want to partially fill bid when quantity
1372                                        is greater than currentRemainingSets
1373      */
1374 
1375     function bidAndWithdraw(
1376         IRebalancingSetToken _rebalancingSetToken,
1377         uint256 _quantity,
1378         bool _allowPartialFill
1379     )
1380         external
1381         nonReentrant
1382     {
1383         // Get token flow arrays for the given bid quantity
1384         (
1385             address[] memory combinedTokenArray,
1386             uint256[] memory inflowUnitsArray,
1387             uint256[] memory outflowUnitsArray
1388         ) = Rebalance.getTokenFlows(_rebalancingSetToken, _quantity);
1389 
1390         // Ensure allowances and transfer auction tokens or underlying from user
1391         depositComponents(
1392             combinedTokenArray,
1393             inflowUnitsArray
1394         );
1395 
1396         // Bid in auction
1397         rebalanceAuctionModule.bidAndWithdraw(
1398             address(_rebalancingSetToken),
1399             _quantity,
1400             _allowPartialFill
1401         );
1402 
1403         // Withdraw auction tokens or underlying to user
1404         withdrawComponentsToSender(
1405             combinedTokenArray
1406         );
1407 
1408         // Log bid placed with Eth event
1409         emit BidPlacedCToken(
1410             address(_rebalancingSetToken),
1411             msg.sender,
1412             _quantity
1413         );
1414     }
1415 
1416     /*
1417      * Get token inflows and outflows and combined token array denominated in underlying required
1418      * for bid for a given rebalancing Set token.
1419      *
1420      * @param _rebalancingSetToken    The rebalancing Set Token instance
1421      * @param _quantity               The amount of currentSet to be rebalanced
1422      * @return combinedTokenArray     Array of token addresses
1423      * @return inflowUnitsArray       Array of amount of tokens inserted into system in bid
1424      * @return outflowUnitsArray      Array of amount of tokens returned from system in bid
1425      */
1426     function getAddressAndBidPriceArray(
1427         IRebalancingSetToken _rebalancingSetToken,
1428         uint256 _quantity
1429     )
1430         external
1431         view
1432         returns (address[] memory, uint256[] memory, uint256[] memory)
1433     {
1434         // Get token flow arrays for the given bid quantity
1435         (
1436             address[] memory combinedTokenArray,
1437             uint256[] memory inflowUnitsArray,
1438             uint256[] memory outflowUnitsArray
1439         ) = Rebalance.getTokenFlows(_rebalancingSetToken, _quantity);
1440 
1441         // Loop through the combined token addresses array and replace with underlying address
1442         for (uint256 i = 0; i < combinedTokenArray.length; i++) {
1443             address currentComponentAddress = combinedTokenArray[i];
1444 
1445             // Check if current component address is a cToken
1446             address underlyingAddress = cTokenToUnderlying[currentComponentAddress];
1447             if (underlyingAddress != address(0)) {
1448                 combinedTokenArray[i] = underlyingAddress;
1449 
1450                 // Replace inflow and outflow with required amount of underlying.
1451                 // Calculated as cToken quantity * exchangeRate / 10 ** 18.
1452                 uint256 exchangeRate = ICToken(currentComponentAddress).exchangeRateStored();
1453                 uint256 currentInflowQuantity = inflowUnitsArray[i];
1454                 uint256 currentOutflowQuantity = outflowUnitsArray[i];
1455 
1456                 inflowUnitsArray[i] = CompoundUtils.convertCTokenToUnderlying(currentInflowQuantity, exchangeRate);
1457                 outflowUnitsArray[i] = CompoundUtils.convertCTokenToUnderlying(currentOutflowQuantity, exchangeRate);
1458             }
1459         }
1460 
1461         return (combinedTokenArray, inflowUnitsArray, outflowUnitsArray);
1462     }
1463 
1464     /* ============ Private Functions ============ */
1465 
1466     /**
1467      * Before bidding, calculate the required amount of inflow tokens and deposit token components
1468      * into this helper contract.
1469      *
1470      * @param  _combinedTokenArray            Array of token addresses
1471      * @param  _inflowUnitsArray              Array of inflow token units
1472      */
1473     function depositComponents(
1474         address[] memory _combinedTokenArray,
1475         uint256[] memory _inflowUnitsArray
1476     )
1477         private
1478     {
1479         // Loop through the combined token addresses array and deposit inflow amounts
1480         for (uint256 i = 0; i < _combinedTokenArray.length; i++) {
1481             address currentComponentAddress = _combinedTokenArray[i];
1482             uint256 currentComponentQuantity = _inflowUnitsArray[i];
1483 
1484             // Check component inflow is greater than 0
1485             if (currentComponentQuantity > 0) {
1486                 // Ensure allowance for components to transferProxy
1487                 ERC20Wrapper.ensureAllowance(
1488                     currentComponentAddress,
1489                     address(this),
1490                     address(transferProxy),
1491                     currentComponentQuantity
1492                 );
1493 
1494                 // If cToken, calculate required underlying tokens, transfer to contract,
1495                 // ensure underlying allowance to cToken and then mint cTokens
1496                 address underlyingAddress = cTokenToUnderlying[currentComponentAddress];
1497                 if (underlyingAddress != address(0)) {
1498                     ICToken cTokenInstance = ICToken(currentComponentAddress);
1499 
1500                     // Calculate required amount of underlying. Calculated as cToken quantity * exchangeRate / 10 ** 18.
1501                     uint256 exchangeRate = cTokenInstance.exchangeRateCurrent();
1502                     uint256 underlyingQuantity = CompoundUtils.convertCTokenToUnderlying(currentComponentQuantity, exchangeRate);
1503 
1504                     // Transfer underlying tokens to contract
1505                     ERC20Wrapper.transferFrom(
1506                         underlyingAddress,
1507                         msg.sender,
1508                         address(this),
1509                         underlyingQuantity
1510                     );
1511 
1512                     // Ensure allowance for underlying token to cToken contract
1513                     ERC20Wrapper.ensureAllowance(
1514                         underlyingAddress,
1515                         address(this),
1516                         address(cTokenInstance),
1517                         underlyingQuantity
1518                     );
1519 
1520                     // Mint cToken using underlying
1521                     uint256 mintResponse = cTokenInstance.mint(underlyingQuantity);
1522                     require(
1523                         mintResponse == 0,
1524                         "RebalancingSetCTokenBidder.bidAndWithdraw: Error minting cToken"
1525                     );
1526                 } else {
1527                     // Transfer non-cTokens to contract
1528                     ERC20Wrapper.transferFrom(
1529                         currentComponentAddress,
1530                         msg.sender,
1531                         address(this),
1532                         currentComponentQuantity
1533                     );
1534                 }
1535             }
1536         }
1537     }
1538 
1539     /**
1540      * After bidding, loop through token address array and redeem any cTokens
1541      * and transfer token components to user
1542      *
1543      * @param  _combinedTokenArray           Array of token addresses
1544      */
1545     function withdrawComponentsToSender(
1546         address[] memory _combinedTokenArray
1547     )
1548         private
1549     {
1550         // Loop through the combined token addresses array and withdraw leftover amounts
1551         for (uint256 i = 0; i < _combinedTokenArray.length; i++) {
1552             address currentComponentAddress = _combinedTokenArray[i];
1553 
1554             // Get balance of tokens in contract
1555             uint256 currentComponentBalance = ERC20Wrapper.balanceOf(
1556                 currentComponentAddress,
1557                 address(this)
1558             );
1559 
1560             // Check component balance is greater than 0
1561             if (currentComponentBalance > 0) {
1562                 // Check if cToken
1563                 address underlyingAddress = cTokenToUnderlying[currentComponentAddress];
1564                 if (underlyingAddress != address(0)) {
1565                     // Redeem cToken into underlying
1566                     uint256 mintResponse = ICToken(currentComponentAddress).redeem(currentComponentBalance);
1567                     require(
1568                         mintResponse == 0,
1569                         "RebalancingSetCTokenBidder.bidAndWithdraw: Erroring redeeming cToken"
1570                     );
1571 
1572                     // Get balance of underlying in contract
1573                     uint256 underlyingComponentBalance = ERC20Wrapper.balanceOf(
1574                         underlyingAddress,
1575                         address(this)
1576                     );
1577 
1578                     // Withdraw underlying from the contract and send to the user
1579                     ERC20Wrapper.transfer(
1580                         underlyingAddress,
1581                         msg.sender,
1582                         underlyingComponentBalance
1583                     );
1584                 } else {
1585                     // Withdraw non cTokens from the contract and send to the user
1586                     ERC20Wrapper.transfer(
1587                         currentComponentAddress,
1588                         msg.sender,
1589                         currentComponentBalance
1590                     );
1591                 }
1592             }
1593         }
1594     }
1595 }