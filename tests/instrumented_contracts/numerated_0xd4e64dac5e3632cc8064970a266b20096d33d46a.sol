1 /**
2  *Submitted for verification at Etherscan.io on 2020-06-10
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-06-09
7 */
8 
9 pragma solidity ^0.5.2;
10 pragma experimental "ABIEncoderV2";
11 
12 /**
13  * @title Helps contracts guard against reentrancy attacks.
14  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
15  * @dev If you mark a function `nonReentrant`, you should also
16  * mark it `external`.
17  */
18 contract ReentrancyGuard {
19     /// @dev counter to allow mutex lock with only one SSTORE operation
20     uint256 private _guardCounter;
21 
22     constructor () internal {
23         // The counter starts at one to prevent changing it from zero to a non-zero
24         // value, which is a more expensive operation.
25         _guardCounter = 1;
26     }
27 
28     /**
29      * @dev Prevents a contract from calling itself, directly or indirectly.
30      * Calling a `nonReentrant` function from another `nonReentrant`
31      * function is not supported. It is possible to prevent this from happening
32      * by making the `nonReentrant` function external, and make it call a
33      * `private` function that does the actual work.
34      */
35     modifier nonReentrant() {
36         _guardCounter += 1;
37         uint256 localCounter = _guardCounter;
38         _;
39         require(localCounter == _guardCounter);
40     }
41 }
42 
43 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
44 
45 pragma solidity ^0.5.2;
46 
47 /**
48  * @title SafeMath
49  * @dev Unsigned math operations with safety checks that revert on error
50  */
51 library SafeMath {
52     /**
53      * @dev Multiplies two unsigned integers, reverts on overflow.
54      */
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
57         // benefit is lost if 'b' is also tested.
58         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
59         if (a == 0) {
60             return 0;
61         }
62 
63         uint256 c = a * b;
64         require(c / a == b);
65 
66         return c;
67     }
68 
69     /**
70      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
71      */
72     function div(uint256 a, uint256 b) internal pure returns (uint256) {
73         // Solidity only automatically asserts when dividing by 0
74         require(b > 0);
75         uint256 c = a / b;
76         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77 
78         return c;
79     }
80 
81     /**
82      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
83      */
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b <= a);
86         uint256 c = a - b;
87 
88         return c;
89     }
90 
91     /**
92      * @dev Adds two unsigned integers, reverts on overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         uint256 c = a + b;
96         require(c >= a);
97 
98         return c;
99     }
100 
101     /**
102      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
103      * reverts when dividing by zero.
104      */
105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b != 0);
107         return a % b;
108     }
109 }
110 
111 // File: set-protocol-contract-utils/contracts/lib/CommonMath.sol
112 
113 /*
114     Copyright 2018 Set Labs Inc.
115 
116     Licensed under the Apache License, Version 2.0 (the "License");
117     you may not use this file except in compliance with the License.
118     You may obtain a copy of the License at
119 
120     http://www.apache.org/licenses/LICENSE-2.0
121 
122     Unless required by applicable law or agreed to in writing, software
123     distributed under the License is distributed on an "AS IS" BASIS,
124     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
125     See the License for the specific language governing permissions and
126     limitations under the License.
127 */
128 
129 pragma solidity 0.5.7;
130 
131 
132 
133 library CommonMath {
134     using SafeMath for uint256;
135 
136     uint256 public constant SCALE_FACTOR = 10 ** 18;
137     uint256 public constant MAX_UINT_256 = 2 ** 256 - 1;
138 
139     /**
140      * Returns scale factor equal to 10 ** 18
141      *
142      * @return  10 ** 18
143      */
144     function scaleFactor()
145         internal
146         pure
147         returns (uint256)
148     {
149         return SCALE_FACTOR;
150     }
151 
152     /**
153      * Calculates and returns the maximum value for a uint256
154      *
155      * @return  The maximum value for uint256
156      */
157     function maxUInt256()
158         internal
159         pure
160         returns (uint256)
161     {
162         return MAX_UINT_256;
163     }
164 
165     /**
166      * Increases a value by the scale factor to allow for additional precision
167      * during mathematical operations
168      */
169     function scale(
170         uint256 a
171     )
172         internal
173         pure
174         returns (uint256)
175     {
176         return a.mul(SCALE_FACTOR);
177     }
178 
179     /**
180      * Divides a value by the scale factor to allow for additional precision
181      * during mathematical operations
182     */
183     function deScale(
184         uint256 a
185     )
186         internal
187         pure
188         returns (uint256)
189     {
190         return a.div(SCALE_FACTOR);
191     }
192 
193     /**
194     * @dev Performs the power on a specified value, reverts on overflow.
195     */
196     function safePower(
197         uint256 a,
198         uint256 pow
199     )
200         internal
201         pure
202         returns (uint256)
203     {
204         require(a > 0);
205 
206         uint256 result = 1;
207         for (uint256 i = 0; i < pow; i++){
208             uint256 previousResult = result;
209 
210             // Using safemath multiplication prevents overflows
211             result = previousResult.mul(a);
212         }
213 
214         return result;
215     }
216 
217     /**
218     * @dev Performs division where if there is a modulo, the value is rounded up
219     */
220     function divCeil(uint256 a, uint256 b)
221         internal
222         pure
223         returns(uint256)
224     {
225         return a.mod(b) > 0 ? a.div(b).add(1) : a.div(b);
226     }
227 
228     /**
229      * Checks for rounding errors and returns value of potential partial amounts of a principal
230      *
231      * @param  _principal       Number fractional amount is derived from
232      * @param  _numerator       Numerator of fraction
233      * @param  _denominator     Denominator of fraction
234      * @return uint256          Fractional amount of principal calculated
235      */
236     function getPartialAmount(
237         uint256 _principal,
238         uint256 _numerator,
239         uint256 _denominator
240     )
241         internal
242         pure
243         returns (uint256)
244     {
245         // Get remainder of partial amount (if 0 not a partial amount)
246         uint256 remainder = mulmod(_principal, _numerator, _denominator);
247 
248         // Return if not a partial amount
249         if (remainder == 0) {
250             return _principal.mul(_numerator).div(_denominator);
251         }
252 
253         // Calculate error percentage
254         uint256 errPercentageTimes1000000 = remainder.mul(1000000).div(_numerator.mul(_principal));
255 
256         // Require error percentage is less than 0.1%.
257         require(
258             errPercentageTimes1000000 < 1000,
259             "CommonMath.getPartialAmount: Rounding error exceeds bounds"
260         );
261 
262         return _principal.mul(_numerator).div(_denominator);
263     }
264 
265     /*
266      * Gets the rounded up log10 of passed value
267      *
268      * @param  _value         Value to calculate ceil(log()) on
269      * @return uint256        Output value
270      */
271     function ceilLog10(
272         uint256 _value
273     )
274         internal
275         pure
276         returns (uint256)
277     {
278         // Make sure passed value is greater than 0
279         require (
280             _value > 0,
281             "CommonMath.ceilLog10: Value must be greater than zero."
282         );
283 
284         // Since log10(1) = 0, if _value = 1 return 0
285         if (_value == 1) return 0;
286 
287         // Calcualte ceil(log10())
288         uint256 x = _value - 1;
289 
290         uint256 result = 0;
291 
292         if (x >= 10 ** 64) {
293             x /= 10 ** 64;
294             result += 64;
295         }
296         if (x >= 10 ** 32) {
297             x /= 10 ** 32;
298             result += 32;
299         }
300         if (x >= 10 ** 16) {
301             x /= 10 ** 16;
302             result += 16;
303         }
304         if (x >= 10 ** 8) {
305             x /= 10 ** 8;
306             result += 8;
307         }
308         if (x >= 10 ** 4) {
309             x /= 10 ** 4;
310             result += 4;
311         }
312         if (x >= 100) {
313             x /= 100;
314             result += 2;
315         }
316         if (x >= 10) {
317             result += 1;
318         }
319 
320         return result + 1;
321     }
322 }
323 
324 // File: set-protocol-contract-utils/contracts/lib/CompoundUtils.sol
325 
326 /*
327     Copyright 2020 Set Labs Inc.
328 
329     Licensed under the Apache License, Version 2.0 (the "License");
330     you may not use this file except in compliance with the License.
331     You may obtain a copy of the License at
332 
333     http://www.apache.org/licenses/LICENSE-2.0
334 
335     Unless required by applicable law or agreed to in writing, software
336     distributed under the License is distributed on an "AS IS" BASIS,
337     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
338     See the License for the specific language governing permissions and
339     limitations under the License.
340 */
341 
342 pragma solidity 0.5.7;
343 
344 
345 
346 
347 /**
348  * @title CompoundUtils
349  * @author Set Protocol
350  *
351  * Collection of common Compound functions for use in Set Protocol contracts
352  */
353 library CompoundUtils
354 {
355     using SafeMath for uint256;
356 
357     /*
358      * Utility function to convert a specified amount of cTokens to underlying
359      * token based on the cToken's exchange rate
360      *
361      * @param _cTokenAmount         Amount of cTokens that will be converted to underlying
362      * @param _cTokenExchangeRate   Exchange rate for the cToken
363      * @return underlyingAmount     Amount of underlying ERC20 tokens
364      */
365     function convertCTokenToUnderlying(
366         uint256 _cTokenAmount,
367         uint256 _cTokenExchangeRate
368     )
369     internal
370     pure
371     returns (uint256)
372     {
373         // Underlying units is calculated as cToken quantity * exchangeRate divided by 10 ** 18 and rounded up.
374         uint256 a = _cTokenAmount.mul(_cTokenExchangeRate);
375         uint256 b = CommonMath.scaleFactor();
376 
377         // Round value up
378         return CommonMath.divCeil(a, b);
379     }
380 }
381 
382 // File: contracts/lib/IERC20.sol
383 
384 /*
385     Copyright 2018 Set Labs Inc.
386 
387     Licensed under the Apache License, Version 2.0 (the "License");
388     you may not use this file except in compliance with the License.
389     You may obtain a copy of the License at
390 
391     http://www.apache.org/licenses/LICENSE-2.0
392 
393     Unless required by applicable law or agreed to in writing, software
394     distributed under the License is distributed on an "AS IS" BASIS,
395     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
396     See the License for the specific language governing permissions and
397     limitations under the License.
398 */
399 
400 pragma solidity 0.5.7;
401 
402 
403 /**
404  * @title IERC20
405  * @author Set Protocol
406  *
407  * Interface for using ERC20 Tokens. This interface is needed to interact with tokens that are not
408  * fully ERC20 compliant and return something other than true on successful transfers.
409  */
410 interface IERC20 {
411     function balanceOf(
412         address _owner
413     )
414         external
415         view
416         returns (uint256);
417 
418     function allowance(
419         address _owner,
420         address _spender
421     )
422         external
423         view
424         returns (uint256);
425 
426     function transfer(
427         address _to,
428         uint256 _quantity
429     )
430         external;
431 
432     function transferFrom(
433         address _from,
434         address _to,
435         uint256 _quantity
436     )
437         external;
438 
439     function approve(
440         address _spender,
441         uint256 _quantity
442     )
443         external
444         returns (bool);
445 
446     function totalSupply()
447         external
448         returns (uint256);
449 }
450 
451 // File: contracts/lib/ERC20Wrapper.sol
452 
453 /*
454     Copyright 2018 Set Labs Inc.
455 
456     Licensed under the Apache License, Version 2.0 (the "License");
457     you may not use this file except in compliance with the License.
458     You may obtain a copy of the License at
459 
460     http://www.apache.org/licenses/LICENSE-2.0
461 
462     Unless required by applicable law or agreed to in writing, software
463     distributed under the License is distributed on an "AS IS" BASIS,
464     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
465     See the License for the specific language governing permissions and
466     limitations under the License.
467 */
468 
469 pragma solidity 0.5.7;
470 
471 
472 
473 
474 /**
475  * @title ERC20Wrapper
476  * @author Set Protocol
477  *
478  * This library contains functions for interacting wtih ERC20 tokens, even those not fully compliant.
479  * For all functions we will only accept tokens that return a null or true value, any other values will
480  * cause the operation to revert.
481  */
482 library ERC20Wrapper {
483 
484     // ============ Internal Functions ============
485 
486     /**
487      * Check balance owner's balance of ERC20 token
488      *
489      * @param  _token          The address of the ERC20 token
490      * @param  _owner          The owner who's balance is being checked
491      * @return  uint256        The _owner's amount of tokens
492      */
493     function balanceOf(
494         address _token,
495         address _owner
496     )
497         external
498         view
499         returns (uint256)
500     {
501         return IERC20(_token).balanceOf(_owner);
502     }
503 
504     /**
505      * Checks spender's allowance to use token's on owner's behalf.
506      *
507      * @param  _token          The address of the ERC20 token
508      * @param  _owner          The token owner address
509      * @param  _spender        The address the allowance is being checked on
510      * @return  uint256        The spender's allowance on behalf of owner
511      */
512     function allowance(
513         address _token,
514         address _owner,
515         address _spender
516     )
517         internal
518         view
519         returns (uint256)
520     {
521         return IERC20(_token).allowance(_owner, _spender);
522     }
523 
524     /**
525      * Transfers tokens from an address. Handle's tokens that return true or null.
526      * If other value returned, reverts.
527      *
528      * @param  _token          The address of the ERC20 token
529      * @param  _to             The address to transfer to
530      * @param  _quantity       The amount of tokens to transfer
531      */
532     function transfer(
533         address _token,
534         address _to,
535         uint256 _quantity
536     )
537         external
538     {
539         IERC20(_token).transfer(_to, _quantity);
540 
541         // Check that transfer returns true or null
542         require(
543             checkSuccess(),
544             "ERC20Wrapper.transfer: Bad return value"
545         );
546     }
547 
548     /**
549      * Transfers tokens from an address (that has set allowance on the proxy).
550      * Handle's tokens that return true or null. If other value returned, reverts.
551      *
552      * @param  _token          The address of the ERC20 token
553      * @param  _from           The address to transfer from
554      * @param  _to             The address to transfer to
555      * @param  _quantity       The number of tokens to transfer
556      */
557     function transferFrom(
558         address _token,
559         address _from,
560         address _to,
561         uint256 _quantity
562     )
563         external
564     {
565         IERC20(_token).transferFrom(_from, _to, _quantity);
566 
567         // Check that transferFrom returns true or null
568         require(
569             checkSuccess(),
570             "ERC20Wrapper.transferFrom: Bad return value"
571         );
572     }
573 
574     /**
575      * Grants spender ability to spend on owner's behalf.
576      * Handle's tokens that return true or null. If other value returned, reverts.
577      *
578      * @param  _token          The address of the ERC20 token
579      * @param  _spender        The address to approve for transfer
580      * @param  _quantity       The amount of tokens to approve spender for
581      */
582     function approve(
583         address _token,
584         address _spender,
585         uint256 _quantity
586     )
587         internal
588     {
589         IERC20(_token).approve(_spender, _quantity);
590 
591         // Check that approve returns true or null
592         require(
593             checkSuccess(),
594             "ERC20Wrapper.approve: Bad return value"
595         );
596     }
597 
598     /**
599      * Ensure's the owner has granted enough allowance for system to
600      * transfer tokens.
601      *
602      * @param  _token          The address of the ERC20 token
603      * @param  _owner          The address of the token owner
604      * @param  _spender        The address to grant/check allowance for
605      * @param  _quantity       The amount to see if allowed for
606      */
607     function ensureAllowance(
608         address _token,
609         address _owner,
610         address _spender,
611         uint256 _quantity
612     )
613         internal
614     {
615         uint256 currentAllowance = allowance(_token, _owner, _spender);
616         if (currentAllowance < _quantity) {
617             approve(
618                 _token,
619                 _spender,
620                 CommonMath.maxUInt256()
621             );
622         }
623     }
624 
625     // ============ Private Functions ============
626 
627     /**
628      * Checks the return value of the previous function up to 32 bytes. Returns true if the previous
629      * function returned 0 bytes or 1.
630      */
631     function checkSuccess(
632     )
633         private
634         pure
635         returns (bool)
636     {
637         // default to failure
638         uint256 returnValue = 0;
639 
640         assembly {
641             // check number of bytes returned from last function call
642             switch returndatasize
643 
644             // no bytes returned: assume success
645             case 0x0 {
646                 returnValue := 1
647             }
648 
649             // 32 bytes returned
650             case 0x20 {
651                 // copy 32 bytes into scratch space
652                 returndatacopy(0x0, 0x0, 0x20)
653 
654                 // load those bytes into returnValue
655                 returnValue := mload(0x0)
656             }
657 
658             // not sure what was returned: dont mark as success
659             default { }
660         }
661 
662         // check if returned value is one or nothing
663         return returnValue == 1;
664     }
665 }
666 
667 // File: contracts/core/interfaces/ICToken.sol
668 
669 /*
670     Copyright 2020 Set Labs Inc.
671 
672     Licensed under the Apache License, Version 2.0 (the "License");
673     you may not use this file except in compliance with the License.
674     You may obtain a copy of the License at
675 
676     http://www.apache.org/licenses/LICENSE-2.0
677 
678     Unless required by applicable law or agreed to in writing, software
679     distributed under the License is distributed on an "AS IS" BASIS,
680     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
681     See the License for the specific language governing permissions and
682     limitations under the License.
683 */
684 
685 pragma solidity 0.5.7;
686 
687 
688 /**
689  * @title ICToken
690  * @author Set Protocol
691  *
692  * Interface for interacting with Compound cTokens
693  */
694 interface ICToken {
695 
696     /**
697      * Calculates the exchange rate from the underlying to the CToken
698      *
699      * @notice Accrue interest then return the up-to-date exchange rate
700      * @return Calculated exchange rate scaled by 1e18
701      */
702     function exchangeRateCurrent()
703         external
704         returns (uint256);
705 
706     function exchangeRateStored() external view returns (uint256);
707 
708     function decimals() external view returns(uint8);
709 
710     /**
711      * Sender supplies assets into the market and receives cTokens in exchange
712      *
713      * @notice Accrues interest whether or not the operation succeeds, unless reverted
714      * @param mintAmount The amount of the underlying asset to supply
715      * @return uint 0=success, otherwise a failure
716      */
717     function mint(uint mintAmount) external returns (uint);
718 
719     /**
720      * @notice Sender redeems cTokens in exchange for the underlying asset
721      * @dev Accrues interest whether or not the operation succeeds, unless reverted
722      * @param redeemTokens The number of cTokens to redeem into underlying
723      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
724      */
725     function redeem(uint redeemTokens) external returns (uint);
726 }
727 
728 // File: contracts/core/interfaces/IRebalanceAuctionModule.sol
729 
730 /*
731     Copyright 2019 Set Labs Inc.
732 
733     Licensed under the Apache License, Version 2.0 (the "License");
734     you may not use this file except in compliance with the License.
735     You may obtain a copy of the License at
736 
737     http://www.apache.org/licenses/LICENSE-2.0
738 
739     Unless required by applicable law or agreed to in writing, software
740     distributed under the License is distributed on an "AS IS" BASIS,
741     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
742     See the License for the specific language governing permissions and
743     limitations under the License.
744 */
745 
746 pragma solidity 0.5.7;
747 
748 /**
749  * @title IRebalanceAuctionModule
750  * @author Set Protocol
751  *
752  * The IRebalanceAuctionModule interface provides a light-weight, structured way to interact with the
753  * RebalanceAuctionModule contract from another contract.
754  */
755 
756 interface IRebalanceAuctionModule {
757     /**
758      * Bid on rebalancing a given quantity of sets held by a rebalancing token
759      * The tokens are returned to the user.
760      *
761      * @param  _rebalancingSetToken    Address of the rebalancing token being bid on
762      * @param  _quantity               Number of currentSets to rebalance
763      * @param  _allowPartialFill       Set to true if want to partially fill bid when quantity
764      *                                 is greater than currentRemainingSets
765      */
766     function bidAndWithdraw(
767         address _rebalancingSetToken,
768         uint256 _quantity,
769         bool _allowPartialFill
770     )
771         external;
772 }
773 
774 // File: contracts/core/lib/RebalancingLibrary.sol
775 
776 /*
777     Copyright 2018 Set Labs Inc.
778 
779     Licensed under the Apache License, Version 2.0 (the "License");
780     you may not use this file except in compliance with the License.
781     You may obtain a copy of the License at
782 
783     http://www.apache.org/licenses/LICENSE-2.0
784 
785     Unless required by applicable law or agreed to in writing, software
786     distributed under the License is distributed on an "AS IS" BASIS,
787     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
788     See the License for the specific language governing permissions and
789     limitations under the License.
790 */
791 
792 pragma solidity 0.5.7;
793 
794 
795 /**
796  * @title RebalancingLibrary
797  * @author Set Protocol
798  *
799  * The RebalancingLibrary contains functions for facilitating the rebalancing process for
800  * Rebalancing Set Tokens. Removes the old calculation functions
801  *
802  */
803 library RebalancingLibrary {
804 
805     /* ============ Enums ============ */
806 
807     enum State { Default, Proposal, Rebalance, Drawdown }
808 
809     /* ============ Structs ============ */
810 
811     struct AuctionPriceParameters {
812         uint256 auctionStartTime;
813         uint256 auctionTimeToPivot;
814         uint256 auctionStartPrice;
815         uint256 auctionPivotPrice;
816     }
817 
818     struct BiddingParameters {
819         uint256 minimumBid;
820         uint256 remainingCurrentSets;
821         uint256[] combinedCurrentUnits;
822         uint256[] combinedNextSetUnits;
823         address[] combinedTokenArray;
824     }
825 }
826 
827 // File: contracts/core/interfaces/IRebalancingSetToken.sol
828 
829 /*
830     Copyright 2018 Set Labs Inc.
831 
832     Licensed under the Apache License, Version 2.0 (the "License");
833     you may not use this file except in compliance with the License.
834     You may obtain a copy of the License at
835 
836     http://www.apache.org/licenses/LICENSE-2.0
837 
838     Unless required by applicable law or agreed to in writing, software
839     distributed under the License is distributed on an "AS IS" BASIS,
840     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
841     See the License for the specific language governing permissions and
842     limitations under the License.
843 */
844 
845 pragma solidity 0.5.7;
846 
847 
848 /**
849  * @title IRebalancingSetToken
850  * @author Set Protocol
851  *
852  * The IRebalancingSetToken interface provides a light-weight, structured way to interact with the
853  * RebalancingSetToken contract from another contract.
854  */
855 
856 interface IRebalancingSetToken {
857 
858     /*
859      * Get the auction library contract used for the current rebalance
860      *
861      * @return address    Address of auction library used in the upcoming auction
862      */
863     function auctionLibrary()
864         external
865         view
866         returns (address);
867 
868     /*
869      * Get totalSupply of Rebalancing Set
870      *
871      * @return  totalSupply
872      */
873     function totalSupply()
874         external
875         view
876         returns (uint256);
877 
878     /*
879      * Get proposalTimeStamp of Rebalancing Set
880      *
881      * @return  proposalTimeStamp
882      */
883     function proposalStartTime()
884         external
885         view
886         returns (uint256);
887 
888     /*
889      * Get lastRebalanceTimestamp of Rebalancing Set
890      *
891      * @return  lastRebalanceTimestamp
892      */
893     function lastRebalanceTimestamp()
894         external
895         view
896         returns (uint256);
897 
898     /*
899      * Get rebalanceInterval of Rebalancing Set
900      *
901      * @return  rebalanceInterval
902      */
903     function rebalanceInterval()
904         external
905         view
906         returns (uint256);
907 
908     /*
909      * Get rebalanceState of Rebalancing Set
910      *
911      * @return RebalancingLibrary.State    Current rebalance state of the RebalancingSetToken
912      */
913     function rebalanceState()
914         external
915         view
916         returns (RebalancingLibrary.State);
917 
918     /*
919      * Get the starting amount of current SetToken for the current auction
920      *
921      * @return  rebalanceState
922      */
923     function startingCurrentSetAmount()
924         external
925         view
926         returns (uint256);
927 
928     /**
929      * Gets the balance of the specified address.
930      *
931      * @param owner      The address to query the balance of.
932      * @return           A uint256 representing the amount owned by the passed address.
933      */
934     function balanceOf(
935         address owner
936     )
937         external
938         view
939         returns (uint256);
940 
941     /**
942      * Function used to set the terms of the next rebalance and start the proposal period
943      *
944      * @param _nextSet                      The Set to rebalance into
945      * @param _auctionLibrary               The library used to calculate the Dutch Auction price
946      * @param _auctionTimeToPivot           The amount of time for the auction to go ffrom start to pivot price
947      * @param _auctionStartPrice            The price to start the auction at
948      * @param _auctionPivotPrice            The price at which the price curve switches from linear to exponential
949      */
950     function propose(
951         address _nextSet,
952         address _auctionLibrary,
953         uint256 _auctionTimeToPivot,
954         uint256 _auctionStartPrice,
955         uint256 _auctionPivotPrice
956     )
957         external;
958 
959     /*
960      * Get natural unit of Set
961      *
962      * @return  uint256       Natural unit of Set
963      */
964     function naturalUnit()
965         external
966         view
967         returns (uint256);
968 
969     /**
970      * Returns the address of the current base SetToken with the current allocation
971      *
972      * @return           A address representing the base SetToken
973      */
974     function currentSet()
975         external
976         view
977         returns (address);
978 
979     /**
980      * Returns the address of the next base SetToken with the post auction allocation
981      *
982      * @return  address    Address representing the base SetToken
983      */
984     function nextSet()
985         external
986         view
987         returns (address);
988 
989     /*
990      * Get the unit shares of the rebalancing Set
991      *
992      * @return  unitShares       Unit Shares of the base Set
993      */
994     function unitShares()
995         external
996         view
997         returns (uint256);
998 
999     /*
1000      * Burn set token for given address.
1001      * Can only be called by authorized contracts.
1002      *
1003      * @param  _from        The address of the redeeming account
1004      * @param  _quantity    The number of sets to burn from redeemer
1005      */
1006     function burn(
1007         address _from,
1008         uint256 _quantity
1009     )
1010         external;
1011 
1012     /*
1013      * Place bid during rebalance auction. Can only be called by Core.
1014      *
1015      * @param _quantity                 The amount of currentSet to be rebalanced
1016      * @return combinedTokenArray       Array of token addresses invovled in rebalancing
1017      * @return inflowUnitArray          Array of amount of tokens inserted into system in bid
1018      * @return outflowUnitArray         Array of amount of tokens taken out of system in bid
1019      */
1020     function placeBid(
1021         uint256 _quantity
1022     )
1023         external
1024         returns (address[] memory, uint256[] memory, uint256[] memory);
1025 
1026     /*
1027      * Get combinedTokenArray of Rebalancing Set
1028      *
1029      * @return  combinedTokenArray
1030      */
1031     function getCombinedTokenArrayLength()
1032         external
1033         view
1034         returns (uint256);
1035 
1036     /*
1037      * Get combinedTokenArray of Rebalancing Set
1038      *
1039      * @return  combinedTokenArray
1040      */
1041     function getCombinedTokenArray()
1042         external
1043         view
1044         returns (address[] memory);
1045 
1046     /*
1047      * Get failedAuctionWithdrawComponents of Rebalancing Set
1048      *
1049      * @return  failedAuctionWithdrawComponents
1050      */
1051     function getFailedAuctionWithdrawComponents()
1052         external
1053         view
1054         returns (address[] memory);
1055 
1056     /*
1057      * Get auctionPriceParameters for current auction
1058      *
1059      * @return uint256[4]    AuctionPriceParameters for current rebalance auction
1060      */
1061     function getAuctionPriceParameters()
1062         external
1063         view
1064         returns (uint256[] memory);
1065 
1066     /*
1067      * Get biddingParameters for current auction
1068      *
1069      * @return uint256[2]    BiddingParameters for current rebalance auction
1070      */
1071     function getBiddingParameters()
1072         external
1073         view
1074         returns (uint256[] memory);
1075 
1076     /*
1077      * Get token inflows and outflows required for bid. Also the amount of Rebalancing
1078      * Sets that would be generated.
1079      *
1080      * @param _quantity               The amount of currentSet to be rebalanced
1081      * @return inflowUnitArray        Array of amount of tokens inserted into system in bid
1082      * @return outflowUnitArray       Array of amount of tokens taken out of system in bid
1083      */
1084     function getBidPrice(
1085         uint256 _quantity
1086     )
1087         external
1088         view
1089         returns (uint256[] memory, uint256[] memory);
1090 
1091 }
1092 
1093 // File: contracts/core/interfaces/IFeeCalculator.sol
1094 
1095 /*
1096     Copyright 2019 Set Labs Inc.
1097 
1098     Licensed under the Apache License, Version 2.0 (the "License");
1099     you may not use this file except in compliance with the License.
1100     You may obtain a copy of the License at
1101 
1102     http://www.apache.org/licenses/LICENSE-2.0
1103 
1104     Unless required by applicable law or agreed to in writing, software
1105     distributed under the License is distributed on an "AS IS" BASIS,
1106     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1107     See the License for the specific language governing permissions and
1108     limitations under the License.
1109 */
1110 
1111 pragma solidity 0.5.7;
1112 
1113 /**
1114  * @title IFeeCalculator
1115  * @author Set Protocol
1116  *
1117  */
1118 interface IFeeCalculator {
1119 
1120     /* ============ External Functions ============ */
1121 
1122     function initialize(
1123         bytes calldata _feeCalculatorData
1124     )
1125         external;
1126 
1127     function getFee()
1128         external
1129         view
1130         returns(uint256);
1131 
1132     function updateAndGetFee()
1133         external
1134         returns(uint256);
1135 
1136     function adjustFee(
1137         bytes calldata _newFeeData
1138     )
1139         external;
1140 }
1141 
1142 // File: contracts/core/interfaces/ISetToken.sol
1143 
1144 /*
1145     Copyright 2018 Set Labs Inc.
1146 
1147     Licensed under the Apache License, Version 2.0 (the "License");
1148     you may not use this file except in compliance with the License.
1149     You may obtain a copy of the License at
1150 
1151     http://www.apache.org/licenses/LICENSE-2.0
1152 
1153     Unless required by applicable law or agreed to in writing, software
1154     distributed under the License is distributed on an "AS IS" BASIS,
1155     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1156     See the License for the specific language governing permissions and
1157     limitations under the License.
1158 */
1159 
1160 pragma solidity 0.5.7;
1161 
1162 /**
1163  * @title ISetToken
1164  * @author Set Protocol
1165  *
1166  * The ISetToken interface provides a light-weight, structured way to interact with the
1167  * SetToken contract from another contract.
1168  */
1169 interface ISetToken {
1170 
1171     /* ============ External Functions ============ */
1172 
1173     /*
1174      * Get natural unit of Set
1175      *
1176      * @return  uint256       Natural unit of Set
1177      */
1178     function naturalUnit()
1179         external
1180         view
1181         returns (uint256);
1182 
1183     /*
1184      * Get addresses of all components in the Set
1185      *
1186      * @return  componentAddresses       Array of component tokens
1187      */
1188     function getComponents()
1189         external
1190         view
1191         returns (address[] memory);
1192 
1193     /*
1194      * Get units of all tokens in Set
1195      *
1196      * @return  units       Array of component units
1197      */
1198     function getUnits()
1199         external
1200         view
1201         returns (uint256[] memory);
1202 
1203     /*
1204      * Checks to make sure token is component of Set
1205      *
1206      * @param  _tokenAddress     Address of token being checked
1207      * @return  bool             True if token is component of Set
1208      */
1209     function tokenIsComponent(
1210         address _tokenAddress
1211     )
1212         external
1213         view
1214         returns (bool);
1215 
1216     /*
1217      * Mint set token for given address.
1218      * Can only be called by authorized contracts.
1219      *
1220      * @param  _issuer      The address of the issuing account
1221      * @param  _quantity    The number of sets to attribute to issuer
1222      */
1223     function mint(
1224         address _issuer,
1225         uint256 _quantity
1226     )
1227         external;
1228 
1229     /*
1230      * Burn set token for given address
1231      * Can only be called by authorized contracts
1232      *
1233      * @param  _from        The address of the redeeming account
1234      * @param  _quantity    The number of sets to burn from redeemer
1235      */
1236     function burn(
1237         address _from,
1238         uint256 _quantity
1239     )
1240         external;
1241 
1242     /**
1243     * Transfer token for a specified address
1244     *
1245     * @param to The address to transfer to.
1246     * @param value The amount to be transferred.
1247     */
1248     function transfer(
1249         address to,
1250         uint256 value
1251     )
1252         external;
1253 }
1254 
1255 // File: contracts/core/lib/Rebalance.sol
1256 
1257 /*
1258     Copyright 2019 Set Labs Inc.
1259 
1260     Licensed under the Apache License, Version 2.0 (the "License");
1261     you may not use this file except in compliance with the License.
1262     You may obtain a copy of the License at
1263 
1264     http://www.apache.org/licenses/LICENSE-2.0
1265 
1266     Unless required by applicable law or agreed to in writing, software
1267     distributed under the License is distributed on an "AS IS" BASIS,
1268     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1269     See the License for the specific language governing permissions and
1270     limitations under the License.
1271 */
1272 
1273 pragma solidity 0.5.7;
1274 
1275 
1276 
1277 /**
1278  * @title Rebalance
1279  * @author Set Protocol
1280  *
1281  * Types and functions for Rebalance-related data.
1282  */
1283 library Rebalance {
1284 
1285     struct TokenFlow {
1286         address[] addresses;
1287         uint256[] inflow;
1288         uint256[] outflow;
1289     }
1290 
1291     function composeTokenFlow(
1292         address[] memory _addresses,
1293         uint256[] memory _inflow,
1294         uint256[] memory _outflow
1295     )
1296         internal
1297         pure
1298         returns(TokenFlow memory)
1299     {
1300         return TokenFlow({addresses: _addresses, inflow: _inflow, outflow: _outflow });
1301     }
1302 
1303     function decomposeTokenFlow(TokenFlow memory _tokenFlow)
1304         internal
1305         pure
1306         returns (address[] memory, uint256[] memory, uint256[] memory)
1307     {
1308         return (_tokenFlow.addresses, _tokenFlow.inflow, _tokenFlow.outflow);
1309     }
1310 
1311     function decomposeTokenFlowToBidPrice(TokenFlow memory _tokenFlow)
1312         internal
1313         pure
1314         returns (uint256[] memory, uint256[] memory)
1315     {
1316         return (_tokenFlow.inflow, _tokenFlow.outflow);
1317     }
1318 
1319     /**
1320      * Get token flows array of addresses, inflows and outflows
1321      *
1322      * @param    _rebalancingSetToken   The rebalancing Set Token instance
1323      * @param    _quantity              The amount of currentSet to be rebalanced
1324      * @return   combinedTokenArray     Array of token addresses
1325      * @return   inflowArray            Array of amount of tokens inserted into system in bid
1326      * @return   outflowArray           Array of amount of tokens returned from system in bid
1327      */
1328     function getTokenFlows(
1329         IRebalancingSetToken _rebalancingSetToken,
1330         uint256 _quantity
1331     )
1332         internal
1333         view
1334         returns (address[] memory, uint256[] memory, uint256[] memory)
1335     {
1336         // Get token addresses
1337         address[] memory combinedTokenArray = _rebalancingSetToken.getCombinedTokenArray();
1338 
1339         // Get inflow and outflow arrays for the given bid quantity
1340         (
1341             uint256[] memory inflowArray,
1342             uint256[] memory outflowArray
1343         ) = _rebalancingSetToken.getBidPrice(_quantity);
1344 
1345         return (combinedTokenArray, inflowArray, outflowArray);
1346     }
1347 }
1348 
1349 // File: contracts/core/interfaces/ILiquidator.sol
1350 
1351 /*
1352     Copyright 2019 Set Labs Inc.
1353 
1354     Licensed under the Apache License, Version 2.0 (the "License");
1355     you may not use this file except in compliance with the License.
1356     You may obtain a copy of the License at
1357 
1358     http://www.apache.org/licenses/LICENSE-2.0
1359 
1360     Unless required by applicable law or agreed to in writing, software
1361     distributed under the License is distributed on an "AS IS" BASIS,
1362     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1363     See the License for the specific language governing permissions and
1364     limitations under the License.
1365 */
1366 
1367 pragma solidity 0.5.7;
1368 
1369 
1370 
1371 
1372 /**
1373  * @title ILiquidator
1374  * @author Set Protocol
1375  *
1376  */
1377 interface ILiquidator {
1378 
1379     /* ============ External Functions ============ */
1380 
1381     function startRebalance(
1382         ISetToken _currentSet,
1383         ISetToken _nextSet,
1384         uint256 _startingCurrentSetQuantity,
1385         bytes calldata _liquidatorData
1386     )
1387         external;
1388 
1389     function getBidPrice(
1390         address _set,
1391         uint256 _quantity
1392     )
1393         external
1394         view
1395         returns (Rebalance.TokenFlow memory);
1396 
1397     function placeBid(
1398         uint256 _quantity
1399     )
1400         external
1401         returns (Rebalance.TokenFlow memory);
1402 
1403 
1404     function settleRebalance()
1405         external;
1406 
1407     function endFailedRebalance() external;
1408 
1409     // ----------------------------------------------------------------------
1410     // Auction Price
1411     // ----------------------------------------------------------------------
1412 
1413     function auctionPriceParameters(address _set)
1414         external
1415         view
1416         returns (RebalancingLibrary.AuctionPriceParameters memory);
1417 
1418     // ----------------------------------------------------------------------
1419     // Auction
1420     // ----------------------------------------------------------------------
1421 
1422     function hasRebalanceFailed(address _set) external view returns (bool);
1423     function minimumBid(address _set) external view returns (uint256);
1424     function startingCurrentSets(address _set) external view returns (uint256);
1425     function remainingCurrentSets(address _set) external view returns (uint256);
1426     function getCombinedCurrentSetUnits(address _set) external view returns (uint256[] memory);
1427     function getCombinedNextSetUnits(address _set) external view returns (uint256[] memory);
1428     function getCombinedTokenArray(address _set) external view returns (address[] memory);
1429 }
1430 
1431 // File: contracts/core/interfaces/IRebalancingSetTokenV3.sol
1432 
1433 /*
1434     Copyright 2020 Set Labs Inc.
1435 
1436     Licensed under the Apache License, Version 2.0 (the "License");
1437     you may not use this file except in compliance with the License.
1438     You may obtain a copy of the License at
1439 
1440     http://www.apache.org/licenses/LICENSE-2.0
1441 
1442     Unless required by applicable law or agreed to in writing, software
1443     distributed under the License is distributed on an "AS IS" BASIS,
1444     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1445     See the License for the specific language governing permissions and
1446     limitations under the License.
1447 */
1448 
1449 pragma solidity 0.5.7;
1450 
1451 
1452 
1453 
1454 
1455 /**
1456  * @title IRebalancingSetTokenV2
1457  * @author Set Protocol
1458  *
1459  * The IRebalancingSetTokenV3 interface provides a light-weight, structured way to interact with the
1460  * RebalancingSetTokenV3 contract from another contract.
1461  */
1462 
1463 interface IRebalancingSetTokenV3 {
1464 
1465     /*
1466      * Get totalSupply of Rebalancing Set
1467      *
1468      * @return  totalSupply
1469      */
1470     function totalSupply()
1471         external
1472         view
1473         returns (uint256);
1474 
1475     /**
1476      * Returns liquidator instance
1477      *
1478      * @return  ILiquidator    Liquidator instance
1479      */
1480     function liquidator()
1481         external
1482         view
1483         returns (ILiquidator);
1484 
1485     /*
1486      * Get lastRebalanceTimestamp of Rebalancing Set
1487      *
1488      * @return  lastRebalanceTimestamp
1489      */
1490     function lastRebalanceTimestamp()
1491         external
1492         view
1493         returns (uint256);
1494 
1495     /*
1496      * Get rebalanceStartTime of Rebalancing Set
1497      *
1498      * @return  rebalanceStartTime
1499      */
1500     function rebalanceStartTime()
1501         external
1502         view
1503         returns (uint256);
1504 
1505     /*
1506      * Get startingCurrentSets of RebalancingSetToken
1507      *
1508      * @return  startingCurrentSets
1509      */
1510     function startingCurrentSetAmount()
1511         external
1512         view
1513         returns (uint256);
1514 
1515     /*
1516      * Get rebalanceInterval of Rebalancing Set
1517      *
1518      * @return  rebalanceInterval
1519      */
1520     function rebalanceInterval()
1521         external
1522         view
1523         returns (uint256);
1524 
1525     /*
1526      * Get failAuctionPeriod of Rebalancing Set
1527      *
1528      * @return  failAuctionPeriod
1529      */
1530     function rebalanceFailPeriod()
1531         external
1532         view
1533         returns (uint256);
1534 
1535     /*
1536      * Get array returning [startTime, timeToPivot, startPrice, endPrice]
1537      *
1538      * @return  AuctionPriceParameters
1539      */
1540     function getAuctionPriceParameters() external view returns (uint256[] memory);
1541 
1542     /*
1543      * Get array returning [minimumBid, remainingCurrentSets]
1544      *
1545      * @return  BiddingParameters
1546      */
1547     function getBiddingParameters() external view returns (uint256[] memory);
1548 
1549     /*
1550      * Get rebalanceState of Rebalancing Set
1551      *
1552      * @return RebalancingLibrary.State    Current rebalance state of the RebalancingSetTokenV3
1553      */
1554     function rebalanceState()
1555         external
1556         view
1557         returns (RebalancingLibrary.State);
1558 
1559     /**
1560      * Gets the balance of the specified address.
1561      *
1562      * @param owner      The address to query the balance of.
1563      * @return           A uint256 representing the amount owned by the passed address.
1564      */
1565     function balanceOf(
1566         address owner
1567     )
1568         external
1569         view
1570         returns (uint256);
1571 
1572     /*
1573      * Get manager of Rebalancing Set
1574      *
1575      * @return  manager
1576      */
1577     function manager()
1578         external
1579         view
1580         returns (address);
1581 
1582     /*
1583      * Get feeRecipient of Rebalancing Set
1584      *
1585      * @return  feeRecipient
1586      */
1587     function feeRecipient()
1588         external
1589         view
1590         returns (address);
1591 
1592     /*
1593      * Get entryFee of Rebalancing Set
1594      *
1595      * @return  entryFee
1596      */
1597     function entryFee()
1598         external
1599         view
1600         returns (uint256);
1601 
1602     /*
1603      * Retrieves the current expected fee from the fee calculator
1604      * Value is returned as a scale decimal figure.
1605      */
1606     function rebalanceFee()
1607         external
1608         view
1609         returns (uint256);
1610 
1611     /*
1612      * Get calculator contract used to compute rebalance fees
1613      *
1614      * @return  rebalanceFeeCalculator
1615      */
1616     function rebalanceFeeCalculator()
1617         external
1618         view
1619         returns (IFeeCalculator);
1620 
1621     /*
1622      * Initializes the RebalancingSetToken. Typically called by the Factory during creation
1623      */
1624     function initialize(
1625         bytes calldata _rebalanceFeeCalldata
1626     )
1627         external;
1628 
1629     /*
1630      * Set new liquidator address. Only whitelisted addresses are valid.
1631      */
1632     function setLiquidator(
1633         ILiquidator _newLiquidator
1634     )
1635         external;
1636 
1637     /*
1638      * Set new fee recipient address.
1639      */
1640     function setFeeRecipient(
1641         address _newFeeRecipient
1642     )
1643         external;
1644 
1645     /*
1646      * Set new fee entry fee.
1647      */
1648     function setEntryFee(
1649         uint256 _newEntryFee
1650     )
1651         external;
1652 
1653     /*
1654      * Initiates the rebalance in coordination with the Liquidator contract.
1655      * In this step, we redeem the currentSet and pass relevant information
1656      * to the liquidator.
1657      *
1658      * @param _nextSet                      The Set to rebalance into
1659      * @param _liquidatorData               Bytecode formatted data with liquidator-specific arguments
1660      *
1661      * Can only be called if the rebalance interval has elapsed.
1662      * Can only be called by manager.
1663      */
1664     function startRebalance(
1665         address _nextSet,
1666         bytes calldata _liquidatorData
1667 
1668     )
1669         external;
1670 
1671     /*
1672      * After a successful rebalance, the new Set is issued. If there is a rebalance fee,
1673      * the fee is paid via inflation of the Rebalancing Set to the feeRecipient.
1674      * Full issuance functionality is now returned to set owners.
1675      *
1676      * Anyone can call this function.
1677      */
1678     function settleRebalance()
1679         external;
1680 
1681     /*
1682      * During the Default stage, the incentive / rebalance Fee can be triggered. This will
1683      * retrieve the current inflation fee from the fee calulator and mint the according
1684      * inflation to the feeRecipient. The unit shares is then adjusted based on the new
1685      * supply.
1686      *
1687      * Anyone can call this function.
1688      */
1689     function actualizeFee()
1690         external;
1691 
1692     /*
1693      * Validate then set new streaming fee.
1694      *
1695      * @param  _newFeeData       Fee type and new streaming fee encoded in bytes
1696      */
1697     function adjustFee(
1698         bytes calldata _newFeeData
1699     )
1700         external;
1701 
1702     /*
1703      * Get natural unit of Set
1704      *
1705      * @return  uint256       Natural unit of Set
1706      */
1707     function naturalUnit()
1708         external
1709         view
1710         returns (uint256);
1711 
1712     /**
1713      * Returns the address of the current base SetToken with the current allocation
1714      *
1715      * @return           A address representing the base SetToken
1716      */
1717     function currentSet()
1718         external
1719         view
1720         returns (ISetToken);
1721 
1722     /**
1723      * Returns the address of the next base SetToken with the post auction allocation
1724      *
1725      * @return  address    Address representing the base SetToken
1726      */
1727     function nextSet()
1728         external
1729         view
1730         returns (ISetToken);
1731 
1732     /*
1733      * Get the unit shares of the rebalancing Set
1734      *
1735      * @return  unitShares       Unit Shares of the base Set
1736      */
1737     function unitShares()
1738         external
1739         view
1740         returns (uint256);
1741 
1742     /*
1743      * Place bid during rebalance auction. Can only be called by Core.
1744      *
1745      * @param _quantity                 The amount of currentSet to be rebalanced
1746      * @return combinedTokenArray       Array of token addresses invovled in rebalancing
1747      * @return inflowUnitArray          Array of amount of tokens inserted into system in bid
1748      * @return outflowUnitArray         Array of amount of tokens taken out of system in bid
1749      */
1750     function placeBid(
1751         uint256 _quantity
1752     )
1753         external
1754         returns (address[] memory, uint256[] memory, uint256[] memory);
1755 
1756     /*
1757      * Get token inflows and outflows required for bid. Also the amount of Rebalancing
1758      * Sets that would be generated.
1759      *
1760      * @param _quantity               The amount of currentSet to be rebalanced
1761      * @return inflowUnitArray        Array of amount of tokens inserted into system in bid
1762      * @return outflowUnitArray       Array of amount of tokens taken out of system in bid
1763      */
1764     function getBidPrice(
1765         uint256 _quantity
1766     )
1767         external
1768         view
1769         returns (uint256[] memory, uint256[] memory);
1770 
1771     /*
1772      * Get name of Rebalancing Set
1773      *
1774      * @return  name
1775      */
1776     function name()
1777         external
1778         view
1779         returns (string memory);
1780 
1781     /*
1782      * Get symbol of Rebalancing Set
1783      *
1784      * @return  symbol
1785      */
1786     function symbol()
1787         external
1788         view
1789         returns (string memory);
1790 }
1791 
1792 // File: contracts/core/interfaces/ITransferProxy.sol
1793 
1794 /*
1795     Copyright 2018 Set Labs Inc.
1796 
1797     Licensed under the Apache License, Version 2.0 (the "License");
1798     you may not use this file except in compliance with the License.
1799     You may obtain a copy of the License at
1800 
1801     http://www.apache.org/licenses/LICENSE-2.0
1802 
1803     Unless required by applicable law or agreed to in writing, software
1804     distributed under the License is distributed on an "AS IS" BASIS,
1805     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1806     See the License for the specific language governing permissions and
1807     limitations under the License.
1808 */
1809 
1810 pragma solidity 0.5.7;
1811 
1812 /**
1813  * @title ITransferProxy
1814  * @author Set Protocol
1815  *
1816  * The ITransferProxy interface provides a light-weight, structured way to interact with the
1817  * TransferProxy contract from another contract.
1818  */
1819 interface ITransferProxy {
1820 
1821     /* ============ External Functions ============ */
1822 
1823     /**
1824      * Transfers tokens from an address (that has set allowance on the proxy).
1825      * Can only be called by authorized core contracts.
1826      *
1827      * @param  _token          The address of the ERC20 token
1828      * @param  _quantity       The number of tokens to transfer
1829      * @param  _from           The address to transfer from
1830      * @param  _to             The address to transfer to
1831      */
1832     function transfer(
1833         address _token,
1834         uint256 _quantity,
1835         address _from,
1836         address _to
1837     )
1838         external;
1839 
1840     /**
1841      * Transfers tokens from an address (that has set allowance on the proxy).
1842      * Can only be called by authorized core contracts.
1843      *
1844      * @param  _tokens         The addresses of the ERC20 token
1845      * @param  _quantities     The numbers of tokens to transfer
1846      * @param  _from           The address to transfer from
1847      * @param  _to             The address to transfer to
1848      */
1849     function batchTransfer(
1850         address[] calldata _tokens,
1851         uint256[] calldata _quantities,
1852         address _from,
1853         address _to
1854     )
1855         external;
1856 }
1857 
1858 // File: contracts/core/interfaces/ITWAPAuctionGetters.sol
1859 
1860 /*
1861     Copyright 2019 Set Labs Inc.
1862 
1863     Licensed under the Apache License, Version 2.0 (the "License");
1864     you may not use this file except in compliance with the License.
1865     You may obtain a copy of the License at
1866 
1867     http://www.apache.org/licenses/LICENSE-2.0
1868 
1869     Unless required by applicable law or agreed to in writing, software
1870     distributed under the License is distributed on an "AS IS" BASIS,
1871     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1872     See the License for the specific language governing permissions and
1873     limitations under the License.
1874 */
1875 
1876 pragma solidity 0.5.7;
1877 
1878 
1879 /**
1880  * @title ITWAPAuctionGetters
1881  * @author Set Protocol
1882  *
1883  * Interface for retrieving TWAPState struct
1884  */
1885 interface ITWAPAuctionGetters {
1886 
1887     function getOrderSize(address _set) external view returns (uint256);
1888 
1889     function getOrderRemaining(address _set) external view returns (uint256);
1890 
1891     function getTotalSetsRemaining(address _set) external view returns (uint256);
1892 
1893     function getChunkSize(address _set) external view returns (uint256);
1894 
1895     function getChunkAuctionPeriod(address _set) external view returns (uint256);
1896 
1897     function getLastChunkAuctionEnd(address _set) external view returns (uint256);
1898 }
1899 
1900 // File: contracts/helper/RebalancingSetCTokenBidder.sol
1901 
1902 /*
1903     Copyright 2020 Set Labs Inc.
1904 
1905     Licensed under the Apache License, Version 2.0 (the "License");
1906     you may not use this file except in compliance with the License.
1907     You may obtain a copy of the License at
1908 
1909     http://www.apache.org/licenses/LICENSE-2.0
1910 
1911     Unless required by applicable law or agreed to in writing, software
1912     distributed under the License is distributed on an "AS IS" BASIS,
1913     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1914     See the License for the specific language governing permissions and
1915     limitations under the License.
1916 */
1917 
1918 pragma solidity 0.5.7;
1919 
1920 
1921 
1922 
1923 
1924 
1925 
1926 
1927 
1928 
1929 
1930 
1931 
1932 
1933 /**
1934  * @title RebalancingSetCTokenBidder
1935  * @author Set Protocol
1936  *
1937  * A helper contract that mints a cToken from its underlying or redeems a cToken into
1938  * its underlying used for bidding in the RebalanceAuctionModule.
1939  *
1940  * CHANGELOG 6/8/2020:
1941  * - Remove reentrant modifier on bidAndWithdraw. This modifier is already used in RebalanceAuctionModule
1942  * - Add bidAndWithdrawTWAP function to check that bids can only succeed for the current auction chunk
1943  */
1944 contract RebalancingSetCTokenBidder is
1945     ReentrancyGuard
1946 {
1947     using SafeMath for uint256;
1948 
1949     // Address and instance of RebalanceAuctionModule contract
1950     IRebalanceAuctionModule public rebalanceAuctionModule;
1951 
1952     // Address and instance of TransferProxy contract
1953     ITransferProxy public transferProxy;
1954 
1955     // Mapping of cToken address to underlying address
1956     mapping (address => address) public cTokenToUnderlying;
1957 
1958     string public dataDescription;
1959 
1960     /* ============ Events ============ */
1961 
1962     event BidPlacedCToken(
1963         address indexed rebalancingSetToken,
1964         address indexed bidder,
1965         uint256 quantity
1966     );
1967 
1968     /* ============ Constructor ============ */
1969 
1970     /**
1971      * Constructor function for RebalancingSetCTokenBidder
1972      *
1973      * @param _rebalanceAuctionModule   The address of RebalanceAuctionModule
1974      * @param _transferProxy            The address of TransferProxy
1975      * @param _cTokenArray              The address array of the target cToken
1976      * @param _underlyingArray          The address array of the target cToken's underlying
1977      * @param _dataDescription          Description of contract for Etherscan / other applications
1978      */
1979     constructor(
1980         IRebalanceAuctionModule _rebalanceAuctionModule,
1981         ITransferProxy _transferProxy,
1982         address[] memory _cTokenArray,
1983         address[] memory _underlyingArray,
1984         string memory _dataDescription
1985     )
1986         public
1987     {
1988         rebalanceAuctionModule = _rebalanceAuctionModule;
1989 
1990         transferProxy = _transferProxy;
1991 
1992         dataDescription = _dataDescription;
1993 
1994         require(
1995             _cTokenArray.length == _underlyingArray.length,
1996             "RebalancingSetCTokenBidder.constructor: cToken array and underlying array must be same length"
1997         );
1998 
1999         for (uint256 i = 0; i < _cTokenArray.length; i++) {
2000             address cTokenAddress = _cTokenArray[i];
2001             address underlyingAddress = _underlyingArray[i];
2002 
2003             // Initialize mapping of cToken to underlying
2004             cTokenToUnderlying[cTokenAddress] = underlyingAddress;
2005 
2006             // Add approvals of the underlying token to the cToken contract
2007             ERC20Wrapper.approve(
2008                 underlyingAddress,
2009                 cTokenAddress,
2010                 CommonMath.maxUInt256()
2011             );
2012 
2013             // Add approvals of the cToken to the transferProxy contract
2014             ERC20Wrapper.approve(
2015                 cTokenAddress,
2016                 address(_transferProxy),
2017                 CommonMath.maxUInt256()
2018             );
2019         }
2020     }
2021 
2022     /* ============ External Functions ============ */
2023 
2024     /**
2025      * Bid on rebalancing a given quantity of sets held by a rebalancing token wrapping or unwrapping
2026      * a target cToken involved. The tokens are returned to the user.
2027      *
2028      * @param  _rebalancingSetToken    Instance of the rebalancing token being bid on
2029      * @param  _quantity               Number of currentSets to rebalance
2030      * @param  _allowPartialFill       Set to true if want to partially fill bid when quantity
2031                                        is greater than currentRemainingSets
2032      */
2033 
2034     function bidAndWithdraw(
2035         IRebalancingSetToken _rebalancingSetToken,
2036         uint256 _quantity,
2037         bool _allowPartialFill
2038     )
2039         public
2040     {
2041         // Get token flow arrays for the given bid quantity
2042         (
2043             address[] memory combinedTokenArray,
2044             uint256[] memory inflowUnitsArray,
2045             uint256[] memory outflowUnitsArray
2046         ) = Rebalance.getTokenFlows(_rebalancingSetToken, _quantity);
2047 
2048         // Ensure allowances and transfer auction tokens or underlying from user
2049         depositComponents(
2050             combinedTokenArray,
2051             inflowUnitsArray
2052         );
2053 
2054         // Bid in auction
2055         rebalanceAuctionModule.bidAndWithdraw(
2056             address(_rebalancingSetToken),
2057             _quantity,
2058             _allowPartialFill
2059         );
2060 
2061         // Withdraw auction tokens or underlying to user
2062         withdrawComponentsToSender(
2063             combinedTokenArray
2064         );
2065 
2066         // Log bid placed with Eth event
2067         emit BidPlacedCToken(
2068             address(_rebalancingSetToken),
2069             msg.sender,
2070             _quantity
2071         );
2072     }
2073 
2074     /**
2075      * Bid on rebalancing a given quantity of sets held by a rebalancing token wrapping or unwrapping
2076      * a target cToken involved. The tokens are returned to the user. This function is only compatible with
2077      * Rebalancing Set Tokens that use TWAP liquidators
2078      *
2079      * During a TWAP chunk auction, there is an adverse scenario where a bidder submits a chunk auction bid
2080      * with a low gas price and iterateChunkAuction is called before that transaction is mined. When the bidder’s
2081      * transaction gets mined, it may execute at an unintended price. To combat this, he BidAndWithdrawTWAP
2082      * function checks that a new chunk auction has not been initiated from the point of bidding.
2083      * The intended use case is that the bidder would retrieve the Rebalancing SetToken’s lastChunkAuctionEnd
2084      * variable off-chain and submit it as part of the bid.
2085      *
2086      * @param  _rebalancingSetToken    Instance of the rebalancing token being bid on
2087      * @param  _quantity               Number of currentSets to rebalance
2088      * @param  _lastChunkTimestamp     Timestamp of end of previous chunk auction used to identify which
2089                                        chunk the bidder wants to bid on
2090      * @param  _allowPartialFill       Set to true if want to partially fill bid when quantity
2091                                        is greater than currentRemainingSets
2092      */
2093 
2094     function bidAndWithdrawTWAP(
2095         IRebalancingSetTokenV3 _rebalancingSetToken,
2096         uint256 _quantity,
2097         uint256 _lastChunkTimestamp,
2098         bool _allowPartialFill
2099     )
2100         external
2101     {
2102         address liquidatorAddress = address(_rebalancingSetToken.liquidator());
2103         address rebalancingSetTokenAddress = address(_rebalancingSetToken);
2104 
2105         uint256 lastChunkAuctionEnd = ITWAPAuctionGetters(liquidatorAddress).getLastChunkAuctionEnd(rebalancingSetTokenAddress);
2106 
2107         require(
2108             lastChunkAuctionEnd == _lastChunkTimestamp,
2109             "RebalancingSetCTokenBidder.bidAndWithdrawTWAP: Bid must be for intended chunk"
2110         );
2111 
2112         bidAndWithdraw(
2113             IRebalancingSetToken(rebalancingSetTokenAddress),
2114             _quantity,
2115             _allowPartialFill
2116         );
2117     }
2118 
2119     /*
2120      * Get token inflows and outflows and combined token array denominated in underlying required
2121      * for bid for a given rebalancing Set token.
2122      *
2123      * @param _rebalancingSetToken    The rebalancing Set Token instance
2124      * @param _quantity               The amount of currentSet to be rebalanced
2125      * @return combinedTokenArray     Array of token addresses
2126      * @return inflowUnitsArray       Array of amount of tokens inserted into system in bid
2127      * @return outflowUnitsArray      Array of amount of tokens returned from system in bid
2128      */
2129     function getAddressAndBidPriceArray(
2130         IRebalancingSetToken _rebalancingSetToken,
2131         uint256 _quantity
2132     )
2133         external
2134         view
2135         returns (address[] memory, uint256[] memory, uint256[] memory)
2136     {
2137         // Get token flow arrays for the given bid quantity
2138         (
2139             address[] memory combinedTokenArray,
2140             uint256[] memory inflowUnitsArray,
2141             uint256[] memory outflowUnitsArray
2142         ) = Rebalance.getTokenFlows(_rebalancingSetToken, _quantity);
2143 
2144         // Loop through the combined token addresses array and replace with underlying address
2145         for (uint256 i = 0; i < combinedTokenArray.length; i++) {
2146             address currentComponentAddress = combinedTokenArray[i];
2147 
2148             // Check if current component address is a cToken
2149             address underlyingAddress = cTokenToUnderlying[currentComponentAddress];
2150             if (underlyingAddress != address(0)) {
2151                 combinedTokenArray[i] = underlyingAddress;
2152 
2153                 // Replace inflow and outflow with required amount of underlying.
2154                 // Calculated as cToken quantity * exchangeRate / 10 ** 18.
2155                 uint256 exchangeRate = ICToken(currentComponentAddress).exchangeRateStored();
2156                 uint256 currentInflowQuantity = inflowUnitsArray[i];
2157                 uint256 currentOutflowQuantity = outflowUnitsArray[i];
2158 
2159                 inflowUnitsArray[i] = CompoundUtils.convertCTokenToUnderlying(currentInflowQuantity, exchangeRate);
2160                 outflowUnitsArray[i] = CompoundUtils.convertCTokenToUnderlying(currentOutflowQuantity, exchangeRate);
2161             }
2162         }
2163 
2164         return (combinedTokenArray, inflowUnitsArray, outflowUnitsArray);
2165     }
2166 
2167     /* ============ Private Functions ============ */
2168 
2169     /**
2170      * Before bidding, calculate the required amount of inflow tokens and deposit token components
2171      * into this helper contract.
2172      *
2173      * @param  _combinedTokenArray            Array of token addresses
2174      * @param  _inflowUnitsArray              Array of inflow token units
2175      */
2176     function depositComponents(
2177         address[] memory _combinedTokenArray,
2178         uint256[] memory _inflowUnitsArray
2179     )
2180         private
2181     {
2182         // Loop through the combined token addresses array and deposit inflow amounts
2183         for (uint256 i = 0; i < _combinedTokenArray.length; i++) {
2184             address currentComponentAddress = _combinedTokenArray[i];
2185             uint256 currentComponentQuantity = _inflowUnitsArray[i];
2186 
2187             // Check component inflow is greater than 0
2188             if (currentComponentQuantity > 0) {
2189                 // Ensure allowance for components to transferProxy
2190                 ERC20Wrapper.ensureAllowance(
2191                     currentComponentAddress,
2192                     address(this),
2193                     address(transferProxy),
2194                     currentComponentQuantity
2195                 );
2196 
2197                 // If cToken, calculate required underlying tokens, transfer to contract,
2198                 // ensure underlying allowance to cToken and then mint cTokens
2199                 address underlyingAddress = cTokenToUnderlying[currentComponentAddress];
2200                 if (underlyingAddress != address(0)) {
2201                     ICToken cTokenInstance = ICToken(currentComponentAddress);
2202 
2203                     // Calculate required amount of underlying. Calculated as cToken quantity * exchangeRate / 10 ** 18.
2204                     uint256 exchangeRate = cTokenInstance.exchangeRateCurrent();
2205                     uint256 underlyingQuantity = CompoundUtils.convertCTokenToUnderlying(currentComponentQuantity, exchangeRate);
2206 
2207                     // Transfer underlying tokens to contract
2208                     ERC20Wrapper.transferFrom(
2209                         underlyingAddress,
2210                         msg.sender,
2211                         address(this),
2212                         underlyingQuantity
2213                     );
2214 
2215                     // Ensure allowance for underlying token to cToken contract
2216                     ERC20Wrapper.ensureAllowance(
2217                         underlyingAddress,
2218                         address(this),
2219                         address(cTokenInstance),
2220                         underlyingQuantity
2221                     );
2222 
2223                     // Mint cToken using underlying
2224                     uint256 mintResponse = cTokenInstance.mint(underlyingQuantity);
2225                     require(
2226                         mintResponse == 0,
2227                         "RebalancingSetCTokenBidder.bidAndWithdraw: Error minting cToken"
2228                     );
2229                 } else {
2230                     // Transfer non-cTokens to contract
2231                     ERC20Wrapper.transferFrom(
2232                         currentComponentAddress,
2233                         msg.sender,
2234                         address(this),
2235                         currentComponentQuantity
2236                     );
2237                 }
2238             }
2239         }
2240     }
2241 
2242     /**
2243      * After bidding, loop through token address array and redeem any cTokens
2244      * and transfer token components to user
2245      *
2246      * @param  _combinedTokenArray           Array of token addresses
2247      */
2248     function withdrawComponentsToSender(
2249         address[] memory _combinedTokenArray
2250     )
2251         private
2252     {
2253         // Loop through the combined token addresses array and withdraw leftover amounts
2254         for (uint256 i = 0; i < _combinedTokenArray.length; i++) {
2255             address currentComponentAddress = _combinedTokenArray[i];
2256 
2257             // Get balance of tokens in contract
2258             uint256 currentComponentBalance = ERC20Wrapper.balanceOf(
2259                 currentComponentAddress,
2260                 address(this)
2261             );
2262 
2263             // Check component balance is greater than 0
2264             if (currentComponentBalance > 0) {
2265                 // Check if cToken
2266                 address underlyingAddress = cTokenToUnderlying[currentComponentAddress];
2267                 if (underlyingAddress != address(0)) {
2268                     // Redeem cToken into underlying
2269                     uint256 mintResponse = ICToken(currentComponentAddress).redeem(currentComponentBalance);
2270                     require(
2271                         mintResponse == 0,
2272                         "RebalancingSetCTokenBidder.bidAndWithdraw: Erroring redeeming cToken"
2273                     );
2274 
2275                     // Get balance of underlying in contract
2276                     uint256 underlyingComponentBalance = ERC20Wrapper.balanceOf(
2277                         underlyingAddress,
2278                         address(this)
2279                     );
2280 
2281                     // Withdraw underlying from the contract and send to the user
2282                     ERC20Wrapper.transfer(
2283                         underlyingAddress,
2284                         msg.sender,
2285                         underlyingComponentBalance
2286                     );
2287                 } else {
2288                     // Withdraw non cTokens from the contract and send to the user
2289                     ERC20Wrapper.transfer(
2290                         currentComponentAddress,
2291                         msg.sender,
2292                         currentComponentBalance
2293                     );
2294                 }
2295             }
2296         }
2297     }
2298 }