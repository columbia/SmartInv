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
104 // File: contracts/core/lib/RebalancingLibraryV2.sol
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
126 /**
127  * @title RebalancingLibrary
128  * @author Set Protocol
129  *
130  * The RebalancingLibrary contains functions for facilitating the rebalancing process for
131  * Rebalancing Set Tokens. Removes the old calculation functions
132  *
133  */
134 library RebalancingLibraryV2 {
135     using SafeMath for uint256;
136 
137     /* ============ Enums ============ */
138 
139     enum State { Default, Proposal, Rebalance, Drawdown }
140 
141     /* ============ Structs ============ */
142 
143     struct AuctionPriceParameters {
144         uint256 auctionStartTime;
145         uint256 auctionTimeToPivot;
146         uint256 auctionStartPrice;
147         uint256 auctionPivotPrice;
148     }
149 
150     struct BiddingParameters {
151         uint256 minimumBid;
152         uint256 remainingCurrentSets;
153         uint256[] combinedCurrentUnits;
154         uint256[] combinedNextSetUnits;
155         address[] combinedTokenArray;
156     }
157 }
158 
159 // File: contracts/core/interfaces/IRebalancingSetTokenV2.sol
160 
161 /*
162     Copyright 2018 Set Labs Inc.
163 
164     Licensed under the Apache License, Version 2.0 (the "License");
165     you may not use this file except in compliance with the License.
166     You may obtain a copy of the License at
167 
168     http://www.apache.org/licenses/LICENSE-2.0
169 
170     Unless required by applicable law or agreed to in writing, software
171     distributed under the License is distributed on an "AS IS" BASIS,
172     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
173     See the License for the specific language governing permissions and
174     limitations under the License.
175 */
176 
177 pragma solidity 0.5.7;
178 
179 
180 /**
181  * @title IRebalancingSetTokenV2
182  * @author Set Protocol
183  *
184  * The IRebalancingSetToken interface provides a light-weight, structured way to interact with the
185  * RebalancingSetToken contract from another contract.
186  */
187 
188 interface IRebalancingSetTokenV2 {
189 
190     /*
191      * Get totalSupply of Rebalancing Set
192      *
193      * @return  totalSupply
194      */
195     function totalSupply()
196         external
197         view
198         returns (uint256);
199 
200     /*
201      * Get lastRebalanceTimestamp of Rebalancing Set
202      *
203      * @return  lastRebalanceTimestamp
204      */
205     function lastRebalanceTimestamp()
206         external
207         view
208         returns (uint256);
209 
210     /*
211      * Get rebalanceInterval of Rebalancing Set
212      *
213      * @return  rebalanceInterval
214      */
215     function rebalanceInterval()
216         external
217         view
218         returns (uint256);
219 
220     /*
221      * Get rebalanceState of Rebalancing Set
222      *
223      * @return  rebalanceState
224      */
225     function rebalanceState()
226         external
227         view
228         returns (RebalancingLibraryV2.State);
229 
230     /**
231      * Gets the balance of the specified address.
232      *
233      * @param owner      The address to query the balance of.
234      * @return           A uint256 representing the amount owned by the passed address.
235      */
236     function balanceOf(
237         address owner
238     )
239         external
240         view
241         returns (uint256);
242 
243     /**
244      * Function used to set the terms of the next rebalance and start the proposal period
245      *
246      * @param _nextSet                      The Set to rebalance into
247      * @param _auctionLibrary               The library used to calculate the Dutch Auction price
248      * @param _auctionTimeToPivot           The amount of time for the auction to go ffrom start to pivot price
249      * @param _auctionStartPrice            The price to start the auction at
250      * @param _auctionPivotPrice            The price at which the price curve switches from linear to exponential
251      */
252     function propose(
253         address _nextSet,
254         address _auctionLibrary,
255         uint256 _auctionTimeToPivot,
256         uint256 _auctionStartPrice,
257         uint256 _auctionPivotPrice
258     )
259         external;
260 
261     /*
262      * Get natural unit of Set
263      *
264      * @return  uint256       Natural unit of Set
265      */
266     function naturalUnit()
267         external
268         view
269         returns (uint256);
270 
271     /**
272      * Returns the address of the current Base Set
273      *
274      * @return           A address representing the base Set Token
275      */
276     function currentSet()
277         external
278         view
279         returns (address);
280 
281     /*
282      * Get the unit shares of the rebalancing Set
283      *
284      * @return  unitShares       Unit Shares of the base Set
285      */
286     function unitShares()
287         external
288         view
289         returns (uint256);
290 
291     /*
292      * Burn set token for given address.
293      * Can only be called by authorized contracts.
294      *
295      * @param  _from        The address of the redeeming account
296      * @param  _quantity    The number of sets to burn from redeemer
297      */
298     function burn(
299         address _from,
300         uint256 _quantity
301     )
302         external;
303 
304     /*
305      * Place bid during rebalance auction. Can only be called by Core.
306      *
307      * @param _quantity                 The amount of currentSet to be rebalanced
308      * @return combinedTokenArray       Array of token addresses invovled in rebalancing
309      * @return inflowUnitArray          Array of amount of tokens inserted into system in bid
310      * @return outflowUnitArray         Array of amount of tokens taken out of system in bid
311      */
312     function placeBid(
313         uint256 _quantity
314     )
315         external
316         returns (address[] memory, uint256[] memory, uint256[] memory);
317 
318     /*
319      * Get combinedTokenArray of Rebalancing Set
320      *
321      * @return  combinedTokenArray
322      */
323     function getCombinedTokenArrayLength()
324         external
325         view
326         returns (uint256);
327 
328     /*
329      * Get combinedTokenArray of Rebalancing Set
330      *
331      * @return  combinedTokenArray
332      */
333     function getCombinedTokenArray()
334         external
335         view
336         returns (address[] memory);
337 
338     /*
339      * Get failedAuctionWithdrawComponents of Rebalancing Set
340      *
341      * @return  failedAuctionWithdrawComponents
342      */
343     function getFailedAuctionWithdrawComponents()
344         external
345         view
346         returns (address[] memory);
347 
348     /*
349      * Get biddingParameters for current auction
350      *
351      * @return  biddingParameters
352      */
353     function getBiddingParameters()
354         external
355         view
356         returns (uint256[] memory);
357 
358 }
359 
360 // File: contracts/core/interfaces/ISetToken.sol
361 
362 /*
363     Copyright 2018 Set Labs Inc.
364 
365     Licensed under the Apache License, Version 2.0 (the "License");
366     you may not use this file except in compliance with the License.
367     You may obtain a copy of the License at
368 
369     http://www.apache.org/licenses/LICENSE-2.0
370 
371     Unless required by applicable law or agreed to in writing, software
372     distributed under the License is distributed on an "AS IS" BASIS,
373     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
374     See the License for the specific language governing permissions and
375     limitations under the License.
376 */
377 
378 pragma solidity 0.5.7;
379 
380 /**
381  * @title ISetToken
382  * @author Set Protocol
383  *
384  * The ISetToken interface provides a light-weight, structured way to interact with the
385  * SetToken contract from another contract.
386  */
387 interface ISetToken {
388 
389     /* ============ External Functions ============ */
390 
391     /*
392      * Get natural unit of Set
393      *
394      * @return  uint256       Natural unit of Set
395      */
396     function naturalUnit()
397         external
398         view
399         returns (uint256);
400 
401     /*
402      * Get addresses of all components in the Set
403      *
404      * @return  componentAddresses       Array of component tokens
405      */
406     function getComponents()
407         external
408         view
409         returns (address[] memory);
410 
411     /*
412      * Get units of all tokens in Set
413      *
414      * @return  units       Array of component units
415      */
416     function getUnits()
417         external
418         view
419         returns (uint256[] memory);
420 
421     /*
422      * Checks to make sure token is component of Set
423      *
424      * @param  _tokenAddress     Address of token being checked
425      * @return  bool             True if token is component of Set
426      */
427     function tokenIsComponent(
428         address _tokenAddress
429     )
430         external
431         view
432         returns (bool);
433 
434     /*
435      * Mint set token for given address.
436      * Can only be called by authorized contracts.
437      *
438      * @param  _issuer      The address of the issuing account
439      * @param  _quantity    The number of sets to attribute to issuer
440      */
441     function mint(
442         address _issuer,
443         uint256 _quantity
444     )
445         external;
446 
447     /*
448      * Burn set token for given address
449      * Can only be called by authorized contracts
450      *
451      * @param  _from        The address of the redeeming account
452      * @param  _quantity    The number of sets to burn from redeemer
453      */
454     function burn(
455         address _from,
456         uint256 _quantity
457     )
458         external;
459 
460     /**
461     * Transfer token for a specified address
462     *
463     * @param to The address to transfer to.
464     * @param value The amount to be transferred.
465     */
466     function transfer(
467         address to,
468         uint256 value
469     )
470         external;
471 }
472 
473 // File: contracts/lib/IWETH.sol
474 
475 /*
476     Copyright 2018 Set Labs Inc.
477 
478     Licensed under the Apache License, Version 2.0 (the "License");
479     you may not use this file except in compliance with the License.
480     You may obtain a copy of the License at
481 
482     http://www.apache.org/licenses/LICENSE-2.0
483 
484     Unless required by applicable law or agreed to in writing, software
485     distributed under the License is distributed on an "AS IS" BASIS,
486     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
487     See the License for the specific language governing permissions and
488     limitations under the License.
489 */
490 
491 pragma solidity 0.5.7;
492 
493 
494 /**
495  * @title IWETH
496  * @author Set Protocol
497  *
498  * Interface for Wrapped Ether. This interface allows for interaction for wrapped ether's deposit and withdrawal
499  * functionality.
500  */
501 interface IWETH {
502     function deposit()
503         external
504         payable;
505 
506     function withdraw(
507         uint256 wad
508     )
509         external;
510 }
511 
512 // File: contracts/lib/CommonMath.sol
513 
514 /*
515     Copyright 2018 Set Labs Inc.
516 
517     Licensed under the Apache License, Version 2.0 (the "License");
518     you may not use this file except in compliance with the License.
519     You may obtain a copy of the License at
520 
521     http://www.apache.org/licenses/LICENSE-2.0
522 
523     Unless required by applicable law or agreed to in writing, software
524     distributed under the License is distributed on an "AS IS" BASIS,
525     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
526     See the License for the specific language governing permissions and
527     limitations under the License.
528 */
529 
530 pragma solidity 0.5.7;
531 
532 
533 
534 library CommonMath {
535     using SafeMath for uint256;
536 
537     /**
538      * Calculates and returns the maximum value for a uint256
539      *
540      * @return  The maximum value for uint256
541      */
542     function maxUInt256()
543         internal
544         pure
545         returns (uint256)
546     {
547         return 2 ** 256 - 1;
548     }
549 
550     /**
551     * @dev Performs the power on a specified value, reverts on overflow.
552     */
553     function safePower(
554         uint256 a,
555         uint256 pow
556     )
557         internal
558         pure
559         returns (uint256)
560     {
561         require(a > 0);
562 
563         uint256 result = 1;
564         for (uint256 i = 0; i < pow; i++){
565             uint256 previousResult = result;
566 
567             // Using safemath multiplication prevents overflows
568             result = previousResult.mul(a);
569         }
570 
571         return result;
572     }
573 
574     /**
575      * Checks for rounding errors and returns value of potential partial amounts of a principal
576      *
577      * @param  _principal       Number fractional amount is derived from
578      * @param  _numerator       Numerator of fraction
579      * @param  _denominator     Denominator of fraction
580      * @return uint256          Fractional amount of principal calculated
581      */
582     function getPartialAmount(
583         uint256 _principal,
584         uint256 _numerator,
585         uint256 _denominator
586     )
587         internal
588         pure
589         returns (uint256)
590     {
591         // Get remainder of partial amount (if 0 not a partial amount)
592         uint256 remainder = mulmod(_principal, _numerator, _denominator);
593 
594         // Return if not a partial amount
595         if (remainder == 0) {
596             return _principal.mul(_numerator).div(_denominator);
597         }
598 
599         // Calculate error percentage
600         uint256 errPercentageTimes1000000 = remainder.mul(1000000).div(_numerator.mul(_principal));
601 
602         // Require error percentage is less than 0.1%.
603         require(
604             errPercentageTimes1000000 < 1000,
605             "CommonMath.getPartialAmount: Rounding error exceeds bounds"
606         );
607 
608         return _principal.mul(_numerator).div(_denominator);
609     }
610 
611 }
612 
613 // File: contracts/lib/IERC20.sol
614 
615 /*
616     Copyright 2018 Set Labs Inc.
617 
618     Licensed under the Apache License, Version 2.0 (the "License");
619     you may not use this file except in compliance with the License.
620     You may obtain a copy of the License at
621 
622     http://www.apache.org/licenses/LICENSE-2.0
623 
624     Unless required by applicable law or agreed to in writing, software
625     distributed under the License is distributed on an "AS IS" BASIS,
626     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
627     See the License for the specific language governing permissions and
628     limitations under the License.
629 */
630 
631 pragma solidity 0.5.7;
632 
633 
634 /**
635  * @title IERC20
636  * @author Set Protocol
637  *
638  * Interface for using ERC20 Tokens. This interface is needed to interact with tokens that are not
639  * fully ERC20 compliant and return something other than true on successful transfers.
640  */
641 interface IERC20 {
642     function balanceOf(
643         address _owner
644     )
645         external
646         view
647         returns (uint256);
648 
649     function allowance(
650         address _owner,
651         address _spender
652     )
653         external
654         view
655         returns (uint256);
656 
657     function transfer(
658         address _to,
659         uint256 _quantity
660     )
661         external;
662 
663     function transferFrom(
664         address _from,
665         address _to,
666         uint256 _quantity
667     )
668         external;
669 
670     function approve(
671         address _spender,
672         uint256 _quantity
673     )
674         external
675         returns (bool);
676 }
677 
678 // File: contracts/lib/ERC20Wrapper.sol
679 
680 /*
681     Copyright 2018 Set Labs Inc.
682 
683     Licensed under the Apache License, Version 2.0 (the "License");
684     you may not use this file except in compliance with the License.
685     You may obtain a copy of the License at
686 
687     http://www.apache.org/licenses/LICENSE-2.0
688 
689     Unless required by applicable law or agreed to in writing, software
690     distributed under the License is distributed on an "AS IS" BASIS,
691     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
692     See the License for the specific language governing permissions and
693     limitations under the License.
694 */
695 
696 pragma solidity 0.5.7;
697 
698 
699 
700 
701 /**
702  * @title ERC20Wrapper
703  * @author Set Protocol
704  *
705  * This library contains functions for interacting wtih ERC20 tokens, even those not fully compliant.
706  * For all functions we will only accept tokens that return a null or true value, any other values will
707  * cause the operation to revert.
708  */
709 library ERC20Wrapper {
710 
711     // ============ Internal Functions ============
712 
713     /**
714      * Check balance owner's balance of ERC20 token
715      *
716      * @param  _token          The address of the ERC20 token
717      * @param  _owner          The owner who's balance is being checked
718      * @return  uint256        The _owner's amount of tokens
719      */
720     function balanceOf(
721         address _token,
722         address _owner
723     )
724         external
725         view
726         returns (uint256)
727     {
728         return IERC20(_token).balanceOf(_owner);
729     }
730 
731     /**
732      * Checks spender's allowance to use token's on owner's behalf.
733      *
734      * @param  _token          The address of the ERC20 token
735      * @param  _owner          The token owner address
736      * @param  _spender        The address the allowance is being checked on
737      * @return  uint256        The spender's allowance on behalf of owner
738      */
739     function allowance(
740         address _token,
741         address _owner,
742         address _spender
743     )
744         internal
745         view
746         returns (uint256)
747     {
748         return IERC20(_token).allowance(_owner, _spender);
749     }
750 
751     /**
752      * Transfers tokens from an address. Handle's tokens that return true or null.
753      * If other value returned, reverts.
754      *
755      * @param  _token          The address of the ERC20 token
756      * @param  _to             The address to transfer to
757      * @param  _quantity       The amount of tokens to transfer
758      */
759     function transfer(
760         address _token,
761         address _to,
762         uint256 _quantity
763     )
764         external
765     {
766         IERC20(_token).transfer(_to, _quantity);
767 
768         // Check that transfer returns true or null
769         require(
770             checkSuccess(),
771             "ERC20Wrapper.transfer: Bad return value"
772         );
773     }
774 
775     /**
776      * Transfers tokens from an address (that has set allowance on the proxy).
777      * Handle's tokens that return true or null. If other value returned, reverts.
778      *
779      * @param  _token          The address of the ERC20 token
780      * @param  _from           The address to transfer from
781      * @param  _to             The address to transfer to
782      * @param  _quantity       The number of tokens to transfer
783      */
784     function transferFrom(
785         address _token,
786         address _from,
787         address _to,
788         uint256 _quantity
789     )
790         external
791     {
792         IERC20(_token).transferFrom(_from, _to, _quantity);
793 
794         // Check that transferFrom returns true or null
795         require(
796             checkSuccess(),
797             "ERC20Wrapper.transferFrom: Bad return value"
798         );
799     }
800 
801     /**
802      * Grants spender ability to spend on owner's behalf.
803      * Handle's tokens that return true or null. If other value returned, reverts.
804      *
805      * @param  _token          The address of the ERC20 token
806      * @param  _spender        The address to approve for transfer
807      * @param  _quantity       The amount of tokens to approve spender for
808      */
809     function approve(
810         address _token,
811         address _spender,
812         uint256 _quantity
813     )
814         internal
815     {
816         IERC20(_token).approve(_spender, _quantity);
817 
818         // Check that approve returns true or null
819         require(
820             checkSuccess(),
821             "ERC20Wrapper.approve: Bad return value"
822         );
823     }
824 
825     /**
826      * Ensure's the owner has granted enough allowance for system to
827      * transfer tokens.
828      *
829      * @param  _token          The address of the ERC20 token
830      * @param  _owner          The address of the token owner
831      * @param  _spender        The address to grant/check allowance for
832      * @param  _quantity       The amount to see if allowed for
833      */
834     function ensureAllowance(
835         address _token,
836         address _owner,
837         address _spender,
838         uint256 _quantity
839     )
840         internal
841     {
842         uint256 currentAllowance = allowance(_token, _owner, _spender);
843         if (currentAllowance < _quantity) {
844             approve(
845                 _token,
846                 _spender,
847                 CommonMath.maxUInt256()
848             );
849         }
850     }
851 
852     // ============ Private Functions ============
853 
854     /**
855      * Checks the return value of the previous function up to 32 bytes. Returns true if the previous
856      * function returned 0 bytes or 1.
857      */
858     function checkSuccess(
859     )
860         private
861         pure
862         returns (bool)
863     {
864         // default to failure
865         uint256 returnValue = 0;
866 
867         assembly {
868             // check number of bytes returned from last function call
869             switch returndatasize
870 
871             // no bytes returned: assume success
872             case 0x0 {
873                 returnValue := 1
874             }
875 
876             // 32 bytes returned
877             case 0x20 {
878                 // copy 32 bytes into scratch space
879                 returndatacopy(0x0, 0x0, 0x20)
880 
881                 // load those bytes into returnValue
882                 returnValue := mload(0x0)
883             }
884 
885             // not sure what was returned: dont mark as success
886             default { }
887         }
888 
889         // check if returned value is one or nothing
890         return returnValue == 1;
891     }
892 }
893 
894 // File: contracts/core/interfaces/ICore.sol
895 
896 /*
897     Copyright 2018 Set Labs Inc.
898 
899     Licensed under the Apache License, Version 2.0 (the "License");
900     you may not use this file except in compliance with the License.
901     You may obtain a copy of the License at
902 
903     http://www.apache.org/licenses/LICENSE-2.0
904 
905     Unless required by applicable law or agreed to in writing, software
906     distributed under the License is distributed on an "AS IS" BASIS,
907     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
908     See the License for the specific language governing permissions and
909     limitations under the License.
910 */
911 
912 pragma solidity 0.5.7;
913 
914 
915 /**
916  * @title ICore
917  * @author Set Protocol
918  *
919  * The ICore Contract defines all the functions exposed in the Core through its
920  * various extensions and is a light weight way to interact with the contract.
921  */
922 interface ICore {
923     /**
924      * Return transferProxy address.
925      *
926      * @return address       transferProxy address
927      */
928     function transferProxy()
929         external
930         view
931         returns (address);
932 
933     /**
934      * Return vault address.
935      *
936      * @return address       vault address
937      */
938     function vault()
939         external
940         view
941         returns (address);
942 
943     /**
944      * Return address belonging to given exchangeId.
945      *
946      * @param  _exchangeId       ExchangeId number
947      * @return address           Address belonging to given exchangeId
948      */
949     function exchangeIds(
950         uint8 _exchangeId
951     )
952         external
953         view
954         returns (address);
955 
956     /*
957      * Returns if valid set
958      *
959      * @return  bool      Returns true if Set created through Core and isn't disabled
960      */
961     function validSets(address)
962         external
963         view
964         returns (bool);
965 
966     /*
967      * Returns if valid module
968      *
969      * @return  bool      Returns true if valid module
970      */
971     function validModules(address)
972         external
973         view
974         returns (bool);
975 
976     /**
977      * Return boolean indicating if address is a valid Rebalancing Price Library.
978      *
979      * @param  _priceLibrary    Price library address
980      * @return bool             Boolean indicating if valid Price Library
981      */
982     function validPriceLibraries(
983         address _priceLibrary
984     )
985         external
986         view
987         returns (bool);
988 
989     /**
990      * Exchanges components for Set Tokens
991      *
992      * @param  _set          Address of set to issue
993      * @param  _quantity     Quantity of set to issue
994      */
995     function issue(
996         address _set,
997         uint256 _quantity
998     )
999         external;
1000 
1001     /**
1002      * Issues a specified Set for a specified quantity to the recipient
1003      * using the caller's components from the wallet and vault.
1004      *
1005      * @param  _recipient    Address to issue to
1006      * @param  _set          Address of the Set to issue
1007      * @param  _quantity     Number of tokens to issue
1008      */
1009     function issueTo(
1010         address _recipient,
1011         address _set,
1012         uint256 _quantity
1013     )
1014         external;
1015 
1016     /**
1017      * Converts user's components into Set Tokens held directly in Vault instead of user's account
1018      *
1019      * @param _set          Address of the Set
1020      * @param _quantity     Number of tokens to redeem
1021      */
1022     function issueInVault(
1023         address _set,
1024         uint256 _quantity
1025     )
1026         external;
1027 
1028     /**
1029      * Function to convert Set Tokens into underlying components
1030      *
1031      * @param _set          The address of the Set token
1032      * @param _quantity     The number of tokens to redeem. Should be multiple of natural unit.
1033      */
1034     function redeem(
1035         address _set,
1036         uint256 _quantity
1037     )
1038         external;
1039 
1040     /**
1041      * Redeem Set token and return components to specified recipient. The components
1042      * are left in the vault
1043      *
1044      * @param _recipient    Recipient of Set being issued
1045      * @param _set          Address of the Set
1046      * @param _quantity     Number of tokens to redeem
1047      */
1048     function redeemTo(
1049         address _recipient,
1050         address _set,
1051         uint256 _quantity
1052     )
1053         external;
1054 
1055     /**
1056      * Function to convert Set Tokens held in vault into underlying components
1057      *
1058      * @param _set          The address of the Set token
1059      * @param _quantity     The number of tokens to redeem. Should be multiple of natural unit.
1060      */
1061     function redeemInVault(
1062         address _set,
1063         uint256 _quantity
1064     )
1065         external;
1066 
1067     /**
1068      * Composite method to redeem and withdraw with a single transaction
1069      *
1070      * Normally, you should expect to be able to withdraw all of the tokens.
1071      * However, some have central abilities to freeze transfers (e.g. EOS). _toExclude
1072      * allows you to optionally specify which component tokens to exclude when
1073      * redeeming. They will remain in the vault under the users' addresses.
1074      *
1075      * @param _set          Address of the Set
1076      * @param _to           Address to withdraw or attribute tokens to
1077      * @param _quantity     Number of tokens to redeem
1078      * @param _toExclude    Mask of indexes of tokens to exclude from withdrawing
1079      */
1080     function redeemAndWithdrawTo(
1081         address _set,
1082         address _to,
1083         uint256 _quantity,
1084         uint256 _toExclude
1085     )
1086         external;
1087 
1088     /**
1089      * Deposit multiple tokens to the vault. Quantities should be in the
1090      * order of the addresses of the tokens being deposited.
1091      *
1092      * @param  _tokens           Array of the addresses of the ERC20 tokens
1093      * @param  _quantities       Array of the number of tokens to deposit
1094      */
1095     function batchDeposit(
1096         address[] calldata _tokens,
1097         uint256[] calldata _quantities
1098     )
1099         external;
1100 
1101     /**
1102      * Withdraw multiple tokens from the vault. Quantities should be in the
1103      * order of the addresses of the tokens being withdrawn.
1104      *
1105      * @param  _tokens            Array of the addresses of the ERC20 tokens
1106      * @param  _quantities        Array of the number of tokens to withdraw
1107      */
1108     function batchWithdraw(
1109         address[] calldata _tokens,
1110         uint256[] calldata _quantities
1111     )
1112         external;
1113 
1114     /**
1115      * Deposit any quantity of tokens into the vault.
1116      *
1117      * @param  _token           The address of the ERC20 token
1118      * @param  _quantity        The number of tokens to deposit
1119      */
1120     function deposit(
1121         address _token,
1122         uint256 _quantity
1123     )
1124         external;
1125 
1126     /**
1127      * Withdraw a quantity of tokens from the vault.
1128      *
1129      * @param  _token           The address of the ERC20 token
1130      * @param  _quantity        The number of tokens to withdraw
1131      */
1132     function withdraw(
1133         address _token,
1134         uint256 _quantity
1135     )
1136         external;
1137 
1138     /**
1139      * Transfer tokens associated with the sender's account in vault to another user's
1140      * account in vault.
1141      *
1142      * @param  _token           Address of token being transferred
1143      * @param  _to              Address of user receiving tokens
1144      * @param  _quantity        Amount of tokens being transferred
1145      */
1146     function internalTransfer(
1147         address _token,
1148         address _to,
1149         uint256 _quantity
1150     )
1151         external;
1152 
1153     /**
1154      * Deploys a new Set Token and adds it to the valid list of SetTokens
1155      *
1156      * @param  _factory              The address of the Factory to create from
1157      * @param  _components           The address of component tokens
1158      * @param  _units                The units of each component token
1159      * @param  _naturalUnit          The minimum unit to be issued or redeemed
1160      * @param  _name                 The bytes32 encoded name of the new Set
1161      * @param  _symbol               The bytes32 encoded symbol of the new Set
1162      * @param  _callData             Byte string containing additional call parameters
1163      * @return setTokenAddress       The address of the new Set
1164      */
1165     function createSet(
1166         address _factory,
1167         address[] calldata _components,
1168         uint256[] calldata _units,
1169         uint256 _naturalUnit,
1170         bytes32 _name,
1171         bytes32 _symbol,
1172         bytes calldata _callData
1173     )
1174         external
1175         returns (address);
1176 
1177     /**
1178      * Exposes internal function that deposits a quantity of tokens to the vault and attributes
1179      * the tokens respectively, to system modules.
1180      *
1181      * @param  _from            Address to transfer tokens from
1182      * @param  _to              Address to credit for deposit
1183      * @param  _token           Address of token being deposited
1184      * @param  _quantity        Amount of tokens to deposit
1185      */
1186     function depositModule(
1187         address _from,
1188         address _to,
1189         address _token,
1190         uint256 _quantity
1191     )
1192         external;
1193 
1194     /**
1195      * Exposes internal function that withdraws a quantity of tokens from the vault and
1196      * deattributes the tokens respectively, to system modules.
1197      *
1198      * @param  _from            Address to decredit for withdraw
1199      * @param  _to              Address to transfer tokens to
1200      * @param  _token           Address of token being withdrawn
1201      * @param  _quantity        Amount of tokens to withdraw
1202      */
1203     function withdrawModule(
1204         address _from,
1205         address _to,
1206         address _token,
1207         uint256 _quantity
1208     )
1209         external;
1210 
1211     /**
1212      * Exposes internal function that deposits multiple tokens to the vault, to system
1213      * modules. Quantities should be in the order of the addresses of the tokens being
1214      * deposited.
1215      *
1216      * @param  _from              Address to transfer tokens from
1217      * @param  _to                Address to credit for deposits
1218      * @param  _tokens            Array of the addresses of the tokens being deposited
1219      * @param  _quantities        Array of the amounts of tokens to deposit
1220      */
1221     function batchDepositModule(
1222         address _from,
1223         address _to,
1224         address[] calldata _tokens,
1225         uint256[] calldata _quantities
1226     )
1227         external;
1228 
1229     /**
1230      * Exposes internal function that withdraws multiple tokens from the vault, to system
1231      * modules. Quantities should be in the order of the addresses of the tokens being withdrawn.
1232      *
1233      * @param  _from              Address to decredit for withdrawals
1234      * @param  _to                Address to transfer tokens to
1235      * @param  _tokens            Array of the addresses of the tokens being withdrawn
1236      * @param  _quantities        Array of the amounts of tokens to withdraw
1237      */
1238     function batchWithdrawModule(
1239         address _from,
1240         address _to,
1241         address[] calldata _tokens,
1242         uint256[] calldata _quantities
1243     )
1244         external;
1245 
1246     /**
1247      * Expose internal function that exchanges components for Set tokens,
1248      * accepting any owner, to system modules
1249      *
1250      * @param  _owner        Address to use tokens from
1251      * @param  _recipient    Address to issue Set to
1252      * @param  _set          Address of the Set to issue
1253      * @param  _quantity     Number of tokens to issue
1254      */
1255     function issueModule(
1256         address _owner,
1257         address _recipient,
1258         address _set,
1259         uint256 _quantity
1260     )
1261         external;
1262 
1263     /**
1264      * Expose internal function that exchanges Set tokens for components,
1265      * accepting any owner, to system modules
1266      *
1267      * @param  _burnAddress         Address to burn token from
1268      * @param  _incrementAddress    Address to increment component tokens to
1269      * @param  _set                 Address of the Set to redeem
1270      * @param  _quantity            Number of tokens to redeem
1271      */
1272     function redeemModule(
1273         address _burnAddress,
1274         address _incrementAddress,
1275         address _set,
1276         uint256 _quantity
1277     )
1278         external;
1279 
1280     /**
1281      * Expose vault function that increments user's balance in the vault.
1282      * Available to system modules
1283      *
1284      * @param  _tokens          The addresses of the ERC20 tokens
1285      * @param  _owner           The address of the token owner
1286      * @param  _quantities      The numbers of tokens to attribute to owner
1287      */
1288     function batchIncrementTokenOwnerModule(
1289         address[] calldata _tokens,
1290         address _owner,
1291         uint256[] calldata _quantities
1292     )
1293         external;
1294 
1295     /**
1296      * Expose vault function that decrement user's balance in the vault
1297      * Only available to system modules.
1298      *
1299      * @param  _tokens          The addresses of the ERC20 tokens
1300      * @param  _owner           The address of the token owner
1301      * @param  _quantities      The numbers of tokens to attribute to owner
1302      */
1303     function batchDecrementTokenOwnerModule(
1304         address[] calldata _tokens,
1305         address _owner,
1306         uint256[] calldata _quantities
1307     )
1308         external;
1309 
1310     /**
1311      * Expose vault function that transfer vault balances between users
1312      * Only available to system modules.
1313      *
1314      * @param  _tokens           Addresses of tokens being transferred
1315      * @param  _from             Address tokens being transferred from
1316      * @param  _to               Address tokens being transferred to
1317      * @param  _quantities       Amounts of tokens being transferred
1318      */
1319     function batchTransferBalanceModule(
1320         address[] calldata _tokens,
1321         address _from,
1322         address _to,
1323         uint256[] calldata _quantities
1324     )
1325         external;
1326 
1327     /**
1328      * Transfers token from one address to another using the transfer proxy.
1329      * Only available to system modules.
1330      *
1331      * @param  _token          The address of the ERC20 token
1332      * @param  _quantity       The number of tokens to transfer
1333      * @param  _from           The address to transfer from
1334      * @param  _to             The address to transfer to
1335      */
1336     function transferModule(
1337         address _token,
1338         uint256 _quantity,
1339         address _from,
1340         address _to
1341     )
1342         external;
1343 
1344     /**
1345      * Expose transfer proxy function to transfer tokens from one address to another
1346      * Only available to system modules.
1347      *
1348      * @param  _tokens         The addresses of the ERC20 token
1349      * @param  _quantities     The numbers of tokens to transfer
1350      * @param  _from           The address to transfer from
1351      * @param  _to             The address to transfer to
1352      */
1353     function batchTransferModule(
1354         address[] calldata _tokens,
1355         uint256[] calldata _quantities,
1356         address _from,
1357         address _to
1358     )
1359         external;
1360 }
1361 
1362 // File: contracts/core/interfaces/ITransferProxy.sol
1363 
1364 /*
1365     Copyright 2018 Set Labs Inc.
1366 
1367     Licensed under the Apache License, Version 2.0 (the "License");
1368     you may not use this file except in compliance with the License.
1369     You may obtain a copy of the License at
1370 
1371     http://www.apache.org/licenses/LICENSE-2.0
1372 
1373     Unless required by applicable law or agreed to in writing, software
1374     distributed under the License is distributed on an "AS IS" BASIS,
1375     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1376     See the License for the specific language governing permissions and
1377     limitations under the License.
1378 */
1379 
1380 pragma solidity 0.5.7;
1381 
1382 /**
1383  * @title ITransferProxy
1384  * @author Set Protocol
1385  *
1386  * The ITransferProxy interface provides a light-weight, structured way to interact with the
1387  * TransferProxy contract from another contract.
1388  */
1389 interface ITransferProxy {
1390 
1391     /* ============ External Functions ============ */
1392 
1393     /**
1394      * Transfers tokens from an address (that has set allowance on the proxy).
1395      * Can only be called by authorized core contracts.
1396      *
1397      * @param  _token          The address of the ERC20 token
1398      * @param  _quantity       The number of tokens to transfer
1399      * @param  _from           The address to transfer from
1400      * @param  _to             The address to transfer to
1401      */
1402     function transfer(
1403         address _token,
1404         uint256 _quantity,
1405         address _from,
1406         address _to
1407     )
1408         external;
1409 
1410     /**
1411      * Transfers tokens from an address (that has set allowance on the proxy).
1412      * Can only be called by authorized core contracts.
1413      *
1414      * @param  _tokens         The addresses of the ERC20 token
1415      * @param  _quantities     The numbers of tokens to transfer
1416      * @param  _from           The address to transfer from
1417      * @param  _to             The address to transfer to
1418      */
1419     function batchTransfer(
1420         address[] calldata _tokens,
1421         uint256[] calldata _quantities,
1422         address _from,
1423         address _to
1424     )
1425         external;
1426 }
1427 
1428 // File: contracts/core/interfaces/IVault.sol
1429 
1430 /*
1431     Copyright 2018 Set Labs Inc.
1432 
1433     Licensed under the Apache License, Version 2.0 (the "License");
1434     you may not use this file except in compliance with the License.
1435     You may obtain a copy of the License at
1436 
1437     http://www.apache.org/licenses/LICENSE-2.0
1438 
1439     Unless required by applicable law or agreed to in writing, software
1440     distributed under the License is distributed on an "AS IS" BASIS,
1441     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1442     See the License for the specific language governing permissions and
1443     limitations under the License.
1444 */
1445 
1446 pragma solidity 0.5.7;
1447 
1448 /**
1449  * @title IVault
1450  * @author Set Protocol
1451  *
1452  * The IVault interface provides a light-weight, structured way to interact with the Vault
1453  * contract from another contract.
1454  */
1455 interface IVault {
1456 
1457     /*
1458      * Withdraws user's unassociated tokens to user account. Can only be
1459      * called by authorized core contracts.
1460      *
1461      * @param  _token          The address of the ERC20 token
1462      * @param  _to             The address to transfer token to
1463      * @param  _quantity       The number of tokens to transfer
1464      */
1465     function withdrawTo(
1466         address _token,
1467         address _to,
1468         uint256 _quantity
1469     )
1470         external;
1471 
1472     /*
1473      * Increment quantity owned of a token for a given address. Can
1474      * only be called by authorized core contracts.
1475      *
1476      * @param  _token           The address of the ERC20 token
1477      * @param  _owner           The address of the token owner
1478      * @param  _quantity        The number of tokens to attribute to owner
1479      */
1480     function incrementTokenOwner(
1481         address _token,
1482         address _owner,
1483         uint256 _quantity
1484     )
1485         external;
1486 
1487     /*
1488      * Decrement quantity owned of a token for a given address. Can only
1489      * be called by authorized core contracts.
1490      *
1491      * @param  _token           The address of the ERC20 token
1492      * @param  _owner           The address of the token owner
1493      * @param  _quantity        The number of tokens to deattribute to owner
1494      */
1495     function decrementTokenOwner(
1496         address _token,
1497         address _owner,
1498         uint256 _quantity
1499     )
1500         external;
1501 
1502     /**
1503      * Transfers tokens associated with one account to another account in the vault
1504      *
1505      * @param  _token          Address of token being transferred
1506      * @param  _from           Address token being transferred from
1507      * @param  _to             Address token being transferred to
1508      * @param  _quantity       Amount of tokens being transferred
1509      */
1510 
1511     function transferBalance(
1512         address _token,
1513         address _from,
1514         address _to,
1515         uint256 _quantity
1516     )
1517         external;
1518 
1519 
1520     /*
1521      * Withdraws user's unassociated tokens to user account. Can only be
1522      * called by authorized core contracts.
1523      *
1524      * @param  _tokens          The addresses of the ERC20 tokens
1525      * @param  _owner           The address of the token owner
1526      * @param  _quantities      The numbers of tokens to attribute to owner
1527      */
1528     function batchWithdrawTo(
1529         address[] calldata _tokens,
1530         address _to,
1531         uint256[] calldata _quantities
1532     )
1533         external;
1534 
1535     /*
1536      * Increment quantites owned of a collection of tokens for a given address. Can
1537      * only be called by authorized core contracts.
1538      *
1539      * @param  _tokens          The addresses of the ERC20 tokens
1540      * @param  _owner           The address of the token owner
1541      * @param  _quantities      The numbers of tokens to attribute to owner
1542      */
1543     function batchIncrementTokenOwner(
1544         address[] calldata _tokens,
1545         address _owner,
1546         uint256[] calldata _quantities
1547     )
1548         external;
1549 
1550     /*
1551      * Decrements quantites owned of a collection of tokens for a given address. Can
1552      * only be called by authorized core contracts.
1553      *
1554      * @param  _tokens          The addresses of the ERC20 tokens
1555      * @param  _owner           The address of the token owner
1556      * @param  _quantities      The numbers of tokens to attribute to owner
1557      */
1558     function batchDecrementTokenOwner(
1559         address[] calldata _tokens,
1560         address _owner,
1561         uint256[] calldata _quantities
1562     )
1563         external;
1564 
1565    /**
1566      * Transfers tokens associated with one account to another account in the vault
1567      *
1568      * @param  _tokens           Addresses of tokens being transferred
1569      * @param  _from             Address tokens being transferred from
1570      * @param  _to               Address tokens being transferred to
1571      * @param  _quantities       Amounts of tokens being transferred
1572      */
1573     function batchTransferBalance(
1574         address[] calldata _tokens,
1575         address _from,
1576         address _to,
1577         uint256[] calldata _quantities
1578     )
1579         external;
1580 
1581     /*
1582      * Get balance of particular contract for owner.
1583      *
1584      * @param  _token    The address of the ERC20 token
1585      * @param  _owner    The address of the token owner
1586      */
1587     function getOwnerBalance(
1588         address _token,
1589         address _owner
1590     )
1591         external
1592         view
1593         returns (uint256);
1594 }
1595 
1596 // File: contracts/core/modules/lib/ModuleCoreState.sol
1597 
1598 /*
1599     Copyright 2018 Set Labs Inc.
1600 
1601     Licensed under the Apache License, Version 2.0 (the "License");
1602     you may not use this file except in compliance with the License.
1603     You may obtain a copy of the License at
1604 
1605     http://www.apache.org/licenses/LICENSE-2.0
1606 
1607     Unless required by applicable law or agreed to in writing, software
1608     distributed under the License is distributed on an "AS IS" BASIS,
1609     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1610     See the License for the specific language governing permissions and
1611     limitations under the License.
1612 */
1613 
1614 pragma solidity 0.5.7;
1615 
1616 
1617 
1618 
1619 
1620 /**
1621  * @title ModuleCoreState
1622  * @author Set Protocol
1623  *
1624  * The ModuleCoreState library maintains Core-related state for modules
1625  */
1626 contract ModuleCoreState {
1627 
1628     /* ============ State Variables ============ */
1629 
1630     // Address of core contract
1631     address public core;
1632 
1633     // Address of vault contract
1634     address public vault;
1635 
1636     // Instance of core contract
1637     ICore public coreInstance;
1638 
1639     // Instance of vault contract
1640     IVault public vaultInstance;
1641 
1642     /* ============ Public Getters ============ */
1643 
1644     /**
1645      * Constructor function for ModuleCoreState
1646      *
1647      * @param _core                The address of Core
1648      * @param _vault               The address of Vault
1649      */
1650     constructor(
1651         address _core,
1652         address _vault
1653     )
1654         public
1655     {
1656         // Commit passed address to core state variable
1657         core = _core;
1658 
1659         // Commit passed address to coreInstance state variable
1660         coreInstance = ICore(_core);
1661 
1662         // Commit passed address to vault state variable
1663         vault = _vault;
1664 
1665         // Commit passed address to vaultInstance state variable
1666         vaultInstance = IVault(_vault);
1667     }
1668 }
1669 
1670 // File: contracts/lib/AddressArrayUtils.sol
1671 
1672 // Pulled in from Cryptofin Solidity package in order to control Solidity compiler version
1673 // https://github.com/cryptofinlabs/cryptofin-solidity/blob/master/contracts/array-utils/AddressArrayUtils.sol
1674 
1675 pragma solidity 0.5.7;
1676 
1677 
1678 library AddressArrayUtils {
1679 
1680     /**
1681      * Finds the index of the first occurrence of the given element.
1682      * @param A The input array to search
1683      * @param a The value to find
1684      * @return Returns (index and isIn) for the first occurrence starting from index 0
1685      */
1686     function indexOf(address[] memory A, address a) internal pure returns (uint256, bool) {
1687         uint256 length = A.length;
1688         for (uint256 i = 0; i < length; i++) {
1689             if (A[i] == a) {
1690                 return (i, true);
1691             }
1692         }
1693         return (0, false);
1694     }
1695 
1696     /**
1697     * Returns true if the value is present in the list. Uses indexOf internally.
1698     * @param A The input array to search
1699     * @param a The value to find
1700     * @return Returns isIn for the first occurrence starting from index 0
1701     */
1702     function contains(address[] memory A, address a) internal pure returns (bool) {
1703         bool isIn;
1704         (, isIn) = indexOf(A, a);
1705         return isIn;
1706     }
1707 
1708     /// @return Returns index and isIn for the first occurrence starting from
1709     /// end
1710     function indexOfFromEnd(address[] memory A, address a) internal pure returns (uint256, bool) {
1711         uint256 length = A.length;
1712         for (uint256 i = length; i > 0; i--) {
1713             if (A[i - 1] == a) {
1714                 return (i, true);
1715             }
1716         }
1717         return (0, false);
1718     }
1719 
1720     /**
1721      * Returns the combination of the two arrays
1722      * @param A The first array
1723      * @param B The second array
1724      * @return Returns A extended by B
1725      */
1726     function extend(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
1727         uint256 aLength = A.length;
1728         uint256 bLength = B.length;
1729         address[] memory newAddresses = new address[](aLength + bLength);
1730         for (uint256 i = 0; i < aLength; i++) {
1731             newAddresses[i] = A[i];
1732         }
1733         for (uint256 j = 0; j < bLength; j++) {
1734             newAddresses[aLength + j] = B[j];
1735         }
1736         return newAddresses;
1737     }
1738 
1739     /**
1740      * Returns the array with a appended to A.
1741      * @param A The first array
1742      * @param a The value to append
1743      * @return Returns A appended by a
1744      */
1745     function append(address[] memory A, address a) internal pure returns (address[] memory) {
1746         address[] memory newAddresses = new address[](A.length + 1);
1747         for (uint256 i = 0; i < A.length; i++) {
1748             newAddresses[i] = A[i];
1749         }
1750         newAddresses[A.length] = a;
1751         return newAddresses;
1752     }
1753 
1754     /**
1755      * Returns the combination of two storage arrays.
1756      * @param A The first array
1757      * @param B The second array
1758      * @return Returns A appended by a
1759      */
1760     function sExtend(address[] storage A, address[] storage B) internal {
1761         uint256 length = B.length;
1762         for (uint256 i = 0; i < length; i++) {
1763             A.push(B[i]);
1764         }
1765     }
1766 
1767     /**
1768      * Returns the intersection of two arrays. Arrays are treated as collections, so duplicates are kept.
1769      * @param A The first array
1770      * @param B The second array
1771      * @return The intersection of the two arrays
1772      */
1773     function intersect(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
1774         uint256 length = A.length;
1775         bool[] memory includeMap = new bool[](length);
1776         uint256 newLength = 0;
1777         for (uint256 i = 0; i < length; i++) {
1778             if (contains(B, A[i])) {
1779                 includeMap[i] = true;
1780                 newLength++;
1781             }
1782         }
1783         address[] memory newAddresses = new address[](newLength);
1784         uint256 j = 0;
1785         for (uint256 k = 0; k < length; k++) {
1786             if (includeMap[k]) {
1787                 newAddresses[j] = A[k];
1788                 j++;
1789             }
1790         }
1791         return newAddresses;
1792     }
1793 
1794     /**
1795      * Returns the union of the two arrays. Order is not guaranteed.
1796      * @param A The first array
1797      * @param B The second array
1798      * @return The union of the two arrays
1799      */
1800     function union(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
1801         address[] memory leftDifference = difference(A, B);
1802         address[] memory rightDifference = difference(B, A);
1803         address[] memory intersection = intersect(A, B);
1804         return extend(leftDifference, extend(intersection, rightDifference));
1805     }
1806 
1807     /**
1808      * Alternate implementation
1809      * Assumes there are no duplicates
1810      */
1811     function unionB(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
1812         bool[] memory includeMap = new bool[](A.length + B.length);
1813         uint256 count = 0;
1814         for (uint256 i = 0; i < A.length; i++) {
1815             includeMap[i] = true;
1816             count++;
1817         }
1818         for (uint256 j = 0; j < B.length; j++) {
1819             if (!contains(A, B[j])) {
1820                 includeMap[A.length + j] = true;
1821                 count++;
1822             }
1823         }
1824         address[] memory newAddresses = new address[](count);
1825         uint256 k = 0;
1826         for (uint256 m = 0; m < A.length; m++) {
1827             if (includeMap[m]) {
1828                 newAddresses[k] = A[m];
1829                 k++;
1830             }
1831         }
1832         for (uint256 n = 0; n < B.length; n++) {
1833             if (includeMap[A.length + n]) {
1834                 newAddresses[k] = B[n];
1835                 k++;
1836             }
1837         }
1838         return newAddresses;
1839     }
1840 
1841     /**
1842      * Computes the difference of two arrays. Assumes there are no duplicates.
1843      * @param A The first array
1844      * @param B The second array
1845      * @return The difference of the two arrays
1846      */
1847     function difference(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
1848         uint256 length = A.length;
1849         bool[] memory includeMap = new bool[](length);
1850         uint256 count = 0;
1851         // First count the new length because can't push for in-memory arrays
1852         for (uint256 i = 0; i < length; i++) {
1853             address e = A[i];
1854             if (!contains(B, e)) {
1855                 includeMap[i] = true;
1856                 count++;
1857             }
1858         }
1859         address[] memory newAddresses = new address[](count);
1860         uint256 j = 0;
1861         for (uint256 k = 0; k < length; k++) {
1862             if (includeMap[k]) {
1863                 newAddresses[j] = A[k];
1864                 j++;
1865             }
1866         }
1867         return newAddresses;
1868     }
1869 
1870     /**
1871     * @dev Reverses storage array in place
1872     */
1873     function sReverse(address[] storage A) internal {
1874         address t;
1875         uint256 length = A.length;
1876         for (uint256 i = 0; i < length / 2; i++) {
1877             t = A[i];
1878             A[i] = A[A.length - i - 1];
1879             A[A.length - i - 1] = t;
1880         }
1881     }
1882 
1883     /**
1884     * Removes specified index from array
1885     * Resulting ordering is not guaranteed
1886     * @return Returns the new array and the removed entry
1887     */
1888     function pop(address[] memory A, uint256 index)
1889         internal
1890         pure
1891         returns (address[] memory, address)
1892     {
1893         uint256 length = A.length;
1894         address[] memory newAddresses = new address[](length - 1);
1895         for (uint256 i = 0; i < index; i++) {
1896             newAddresses[i] = A[i];
1897         }
1898         for (uint256 j = index + 1; j < length; j++) {
1899             newAddresses[j - 1] = A[j];
1900         }
1901         return (newAddresses, A[index]);
1902     }
1903 
1904     /**
1905      * @return Returns the new array
1906      */
1907     function remove(address[] memory A, address a)
1908         internal
1909         pure
1910         returns (address[] memory)
1911     {
1912         (uint256 index, bool isIn) = indexOf(A, a);
1913         if (!isIn) {
1914             revert();
1915         } else {
1916             (address[] memory _A,) = pop(A, index);
1917             return _A;
1918         }
1919     }
1920 
1921     function sPop(address[] storage A, uint256 index) internal returns (address) {
1922         uint256 length = A.length;
1923         if (index >= length) {
1924             revert("Error: index out of bounds");
1925         }
1926         address entry = A[index];
1927         for (uint256 i = index; i < length - 1; i++) {
1928             A[i] = A[i + 1];
1929         }
1930         A.length--;
1931         return entry;
1932     }
1933 
1934     /**
1935     * Deletes address at index and fills the spot with the last address.
1936     * Order is not preserved.
1937     * @return Returns the removed entry
1938     */
1939     function sPopCheap(address[] storage A, uint256 index) internal returns (address) {
1940         uint256 length = A.length;
1941         if (index >= length) {
1942             revert("Error: index out of bounds");
1943         }
1944         address entry = A[index];
1945         if (index != length - 1) {
1946             A[index] = A[length - 1];
1947             delete A[length - 1];
1948         }
1949         A.length--;
1950         return entry;
1951     }
1952 
1953     /**
1954      * Deletes address at index. Works by swapping it with the last address, then deleting.
1955      * Order is not preserved
1956      * @param A Storage array to remove from
1957      */
1958     function sRemoveCheap(address[] storage A, address a) internal {
1959         (uint256 index, bool isIn) = indexOf(A, a);
1960         if (!isIn) {
1961             revert("Error: entry not found");
1962         } else {
1963             sPopCheap(A, index);
1964             return;
1965         }
1966     }
1967 
1968     /**
1969      * Returns whether or not there's a duplicate. Runs in O(n^2).
1970      * @param A Array to search
1971      * @return Returns true if duplicate, false otherwise
1972      */
1973     function hasDuplicate(address[] memory A) internal pure returns (bool) {
1974         if (A.length == 0) {
1975             return false;
1976         }
1977         for (uint256 i = 0; i < A.length - 1; i++) {
1978             for (uint256 j = i + 1; j < A.length; j++) {
1979                 if (A[i] == A[j]) {
1980                     return true;
1981                 }
1982             }
1983         }
1984         return false;
1985     }
1986 
1987     /**
1988      * Returns whether the two arrays are equal.
1989      * @param A The first array
1990      * @param B The second array
1991      * @return True is the arrays are equal, false if not.
1992      */
1993     function isEqual(address[] memory A, address[] memory B) internal pure returns (bool) {
1994         if (A.length != B.length) {
1995             return false;
1996         }
1997         for (uint256 i = 0; i < A.length; i++) {
1998             if (A[i] != B[i]) {
1999                 return false;
2000             }
2001         }
2002         return true;
2003     }
2004 
2005     /**
2006      * Returns the elements indexed at indexArray.
2007      * @param A The array to index
2008      * @param indexArray The array to use to index
2009      * @return Returns array containing elements indexed at indexArray
2010      */
2011     function argGet(address[] memory A, uint256[] memory indexArray)
2012         internal
2013         pure
2014         returns (address[] memory)
2015     {
2016         address[] memory array = new address[](indexArray.length);
2017         for (uint256 i = 0; i < indexArray.length; i++) {
2018             array[i] = A[indexArray[i]];
2019         }
2020         return array;
2021     }
2022 
2023 }
2024 
2025 // File: contracts/core/modules/lib/RebalancingSetIssuance.sol
2026 
2027 /*
2028     Copyright 2019 Set Labs Inc.
2029 
2030     Licensed under the Apache License, Version 2.0 (the "License");
2031     you may not use this file except in compliance with the License.
2032     You may obtain a copy of the License at
2033 
2034     http://www.apache.org/licenses/LICENSE-2.0
2035 
2036     Unless required by applicable law or agreed to in writing, software
2037     distributed under the License is distributed on an "AS IS" BASIS,
2038     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2039     See the License for the specific language governing permissions and
2040     limitations under the License.
2041 */
2042 
2043 pragma solidity 0.5.7;
2044 
2045 
2046 
2047 
2048 
2049 
2050 
2051 
2052 /**
2053  * @title RebalancingSetIssuance
2054  * @author Set Protocol
2055  *
2056  * The RebalancingSetIssuance contains utility functions used in rebalancing SetToken
2057  * issuance
2058  */
2059 contract RebalancingSetIssuance is
2060     ModuleCoreState
2061 {
2062     using SafeMath for uint256;
2063     using AddressArrayUtils for address[];
2064 
2065     // ============ Internal ============
2066 
2067     /**
2068      * Validates that wrapped Ether is a component of the SetToken
2069      *
2070      * @param  _setAddress            Address of the SetToken
2071      * @param  _wrappedEtherAddress   Address of wrapped Ether
2072      */
2073     function validateWETHIsAComponentOfSet(
2074         address _setAddress,
2075         address _wrappedEtherAddress
2076     )
2077         internal
2078         view
2079     {
2080         require(
2081             ISetToken(_setAddress).tokenIsComponent(_wrappedEtherAddress),
2082             "RebalancingSetIssuance.validateWETHIsAComponentOfSet: Components must contain weth"
2083         );
2084     }
2085 
2086     /**
2087      * Validates that the passed in address is tracked by Core and that the quantity
2088      * is a multiple of the natural unit
2089      *
2090      * @param  _rebalancingSetAddress    Address of the rebalancing SetToken to issue/redeem
2091      * @param  _rebalancingSetQuantity   The issuance quantity of rebalancing SetToken
2092      */
2093     function validateRebalancingSetIssuance(
2094         address _rebalancingSetAddress,
2095         uint256 _rebalancingSetQuantity
2096     )
2097         internal
2098         view
2099     {
2100         // Expect rebalancing SetToken to be valid and enabled SetToken
2101         require(
2102             coreInstance.validSets(_rebalancingSetAddress),
2103             "RebalancingSetIssuance.validateRebalancingIssuance: Invalid or disabled SetToken address"
2104         );
2105 
2106         // Make sure Issuance quantity is multiple of the rebalancing SetToken natural unit
2107         require(
2108             _rebalancingSetQuantity.mod(ISetToken(_rebalancingSetAddress).naturalUnit()) == 0,
2109             "RebalancingSetIssuance.validateRebalancingIssuance: Quantity must be multiple of natural unit"
2110         );
2111     }
2112 
2113     /**
2114      * Given a rebalancing SetToken and a desired issue quantity, calculates the
2115      * minimum issuable quantity of the base SetToken. If the calculated quantity is initially
2116      * not a multiple of the base SetToken's natural unit, the quantity is rounded up
2117      * to the next base set natural unit.
2118      *
2119      * @param  _rebalancingSetAddress    Address of the rebalancing SetToken to issue
2120      * @param  _rebalancingSetQuantity   The issuance quantity of rebalancing SetToken
2121      * @return requiredBaseSetQuantity   The quantity of base SetToken to issue
2122      */
2123     function getBaseSetIssuanceRequiredQuantity(
2124         address _rebalancingSetAddress,
2125         uint256 _rebalancingSetQuantity
2126     )
2127         internal
2128         view
2129         returns (uint256)
2130     {
2131         IRebalancingSetTokenV2 rebalancingSet = IRebalancingSetTokenV2(_rebalancingSetAddress);
2132 
2133         uint256 unitShares = rebalancingSet.unitShares();
2134         uint256 naturalUnit = rebalancingSet.naturalUnit();
2135 
2136         uint256 requiredBaseSetQuantity = _rebalancingSetQuantity.div(naturalUnit).mul(unitShares);
2137 
2138         address baseSet = rebalancingSet.currentSet();
2139         uint256 baseSetNaturalUnit = ISetToken(baseSet).naturalUnit();
2140 
2141         // If there is a mismatch between the required quantity and the base SetToken natural unit,
2142         // round up to the next base SetToken natural unit if required.
2143         uint256 roundDownQuantity = requiredBaseSetQuantity.mod(baseSetNaturalUnit);
2144         if (roundDownQuantity > 0) {
2145             requiredBaseSetQuantity = requiredBaseSetQuantity.sub(roundDownQuantity).add(baseSetNaturalUnit);
2146         }
2147 
2148         return requiredBaseSetQuantity;
2149     }
2150 
2151 
2152     /**
2153      * Given a rebalancing SetToken address, retrieve the base SetToken quantity redeem quantity based on the quantity
2154      * held in the Vault. Rounds down to the nearest base SetToken natural unit
2155      *
2156      * @param _baseSetAddress             The address of the base SetToken
2157      * @return baseSetRedeemQuantity      The quantity of base SetToken to redeem
2158      */
2159     function getBaseSetRedeemQuantity(
2160         address _baseSetAddress
2161     )
2162         internal
2163         view
2164         returns (uint256)
2165     {
2166         // Get base SetToken Details from the rebalancing SetToken
2167         uint256 baseSetNaturalUnit = ISetToken(_baseSetAddress).naturalUnit();
2168         uint256 baseSetBalance = vaultInstance.getOwnerBalance(
2169             _baseSetAddress,
2170             address(this)
2171         );
2172 
2173         // Round the balance down to the base SetToken natural unit and return
2174         return baseSetBalance.sub(baseSetBalance.mod(baseSetNaturalUnit));
2175     }
2176 
2177     /**
2178      * Checks the base SetToken balances in the Vault and on the contract.
2179      * Sends any positive quantity to the user directly or into the Vault
2180      * depending on the keepChangeInVault flag.
2181      *
2182      * @param _baseSetAddress             The address of the base SetToken
2183      * @param _transferProxyAddress       The address of the TransferProxy
2184      * @param  _keepChangeInVault         Boolean signifying whether excess base SetToken is transferred to the user
2185      *                                     or left in the vault
2186      */
2187     function returnExcessBaseSet(
2188         address _baseSetAddress,
2189         address _transferProxyAddress,
2190         bool _keepChangeInVault
2191     )
2192         internal
2193     {
2194         returnExcessBaseSetFromContract(_baseSetAddress, _transferProxyAddress, _keepChangeInVault);
2195 
2196         returnExcessBaseSetInVault(_baseSetAddress, _keepChangeInVault);
2197     }
2198 
2199     /**
2200      * Checks the base SetToken balances on the contract and sends
2201      * any positive quantity to the user directly or into the Vault
2202      * depending on the keepChangeInVault flag.
2203      *
2204      * @param _baseSetAddress             The address of the base SetToken
2205      * @param _transferProxyAddress       The address of the TransferProxy
2206      * @param  _keepChangeInVault         Boolean signifying whether excess base SetToken is transfered to the user
2207      *                                     or left in the vault
2208      */
2209     function returnExcessBaseSetFromContract(
2210         address _baseSetAddress,
2211         address _transferProxyAddress,
2212         bool _keepChangeInVault
2213     )
2214         internal
2215     {
2216         uint256 baseSetQuantity = ERC20Wrapper.balanceOf(_baseSetAddress, address(this));
2217 
2218         if (baseSetQuantity == 0) {
2219             return;
2220         } else if (_keepChangeInVault) {
2221             // Ensure base SetToken allowance
2222             ERC20Wrapper.ensureAllowance(
2223                 _baseSetAddress,
2224                 address(this),
2225                 _transferProxyAddress,
2226                 baseSetQuantity
2227             );
2228 
2229             // Deposit base SetToken to the user
2230             coreInstance.depositModule(
2231                 address(this),
2232                 msg.sender,
2233                 _baseSetAddress,
2234                 baseSetQuantity
2235             );
2236         } else {
2237             // Transfer directly to the user
2238             ERC20Wrapper.transfer(
2239                 _baseSetAddress,
2240                 msg.sender,
2241                 baseSetQuantity
2242             );
2243         }
2244     }
2245 
2246     /**
2247      * Checks the base SetToken balances in the Vault and sends
2248      * any positive quantity to the user directly or into the Vault
2249      * depending on the keepChangeInVault flag.
2250      *
2251      * @param _baseSetAddress             The address of the base SetToken
2252      * @param  _keepChangeInVault         Boolean signifying whether excess base SetToken is transfered to the user
2253      *                                     or left in the vault
2254      */
2255     function returnExcessBaseSetInVault(
2256         address _baseSetAddress,
2257         bool _keepChangeInVault
2258     )
2259         internal
2260     {
2261         // Return base SetToken if any that are in the Vault
2262         uint256 baseSetQuantityInVault = vaultInstance.getOwnerBalance(
2263             _baseSetAddress,
2264             address(this)
2265         );
2266 
2267         if (baseSetQuantityInVault == 0) {
2268             return;
2269         } else if (_keepChangeInVault) {
2270             // Transfer ownership within the vault to the user
2271             coreInstance.internalTransfer(
2272                 _baseSetAddress,
2273                 msg.sender,
2274                 baseSetQuantityInVault
2275             );
2276         } else {
2277             // Transfer ownership directly to the user
2278             coreInstance.withdrawModule(
2279                 address(this),
2280                 msg.sender,
2281                 _baseSetAddress,
2282                 baseSetQuantityInVault
2283             );
2284         }
2285     }
2286 }
2287 
2288 // File: contracts/core/modules/RebalancingSetIssuanceModule.sol
2289 
2290 /*
2291     Copyright 2019 Set Labs Inc.
2292 
2293     Licensed under the Apache License, Version 2.0 (the "License");
2294     you may not use this file except in compliance with the License.
2295     You may obtain a copy of the License at
2296 
2297     http://www.apache.org/licenses/LICENSE-2.0
2298 
2299     Unless required by applicable law or agreed to in writing, software
2300     distributed under the License is distributed on an "AS IS" BASIS,
2301     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2302     See the License for the specific language governing permissions and
2303     limitations under the License.
2304 */
2305 
2306 pragma solidity 0.5.7;
2307 
2308 
2309 
2310 
2311 
2312 
2313 
2314 
2315 
2316 
2317 /**
2318  * @title RebalancingSetIssuanceModule
2319  * @author Set Protocol
2320  *
2321  * A module that includes functions for issuing / redeeming rebalancing SetToken to/from its base components and ether.
2322  */
2323 contract RebalancingSetIssuanceModule is
2324     ModuleCoreState,
2325     RebalancingSetIssuance,
2326     ReentrancyGuard
2327 {
2328     using SafeMath for uint256;
2329 
2330     // Address and instance of TransferProxy contract
2331     address public transferProxy;
2332 
2333     // Address and instance of Wrapped Ether contract
2334     IWETH public weth;
2335 
2336     /* ============ Events ============ */
2337 
2338     event LogRebalancingSetIssue(
2339         address indexed rebalancingSetAddress,
2340         address indexed callerAddress,
2341         uint256 rebalancingSetQuantity
2342     );
2343 
2344     event LogRebalancingSetRedeem(
2345         address indexed rebalancingSetAddress,
2346         address indexed callerAddress,
2347         uint256 rebalancingSetQuantity
2348     );
2349 
2350     /* ============ Constructor ============ */
2351 
2352     /**
2353      * Constructor function for RebalancingSetIssuanceModule
2354      *
2355      * @param _core                The address of Core
2356      * @param _vault               The address of Vault
2357      * @param _transferProxy       The address of TransferProxy
2358      * @param _weth                The address of Wrapped Ether
2359      */
2360     constructor(
2361         address _core,
2362         address _vault,
2363         address _transferProxy,
2364         IWETH _weth
2365     )
2366         public
2367         ModuleCoreState(
2368             _core,
2369             _vault
2370         )
2371     {
2372         // Commit the WETH instance
2373         weth = _weth;
2374 
2375         // Commit the transferProxy instance
2376         transferProxy = _transferProxy;
2377     }
2378 
2379     /**
2380      * Fallback function. Disallows ether to be sent to this contract without data except when
2381      * unwrapping WETH.
2382      */
2383     function ()
2384         external
2385         payable
2386     {
2387         require(
2388             msg.sender == address(weth),
2389             "RebalancingSetIssuanceModule.fallback: Cannot receive ETH directly unless unwrapping WETH"
2390         );
2391     }
2392 
2393     /* ============ External Functions ============ */
2394 
2395     /**
2396      * Issue a rebalancing SetToken using the base components of the base SetToken.
2397      * The base SetToken is then issued into the rebalancing SetToken. The base SetToken quantity issued is calculated
2398      * by taking the rebalancing SetToken's quantity, unit shares, and natural unit. If the calculated quantity is not
2399      * a multiple of the natural unit of the base SetToken, the quantity is rounded up to the base SetToken natural unit.
2400      * NOTE: Potential to receive more baseSet than expected if someone transfers some to this module.
2401      * Be careful with balance checks.
2402      *
2403      * @param  _rebalancingSetAddress    Address of the rebalancing SetToken to issue
2404      * @param  _rebalancingSetQuantity   The issuance quantity of rebalancing SetToken
2405      * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transfered to the user
2406      *                                     or left in the vault
2407      */
2408     function issueRebalancingSet(
2409         address _rebalancingSetAddress,
2410         uint256 _rebalancingSetQuantity,
2411         bool _keepChangeInVault
2412     )
2413         external
2414         nonReentrant
2415     {
2416         // Get baseSet address and quantity required for issuance of Rebalancing Set
2417         (
2418             address baseSetAddress,
2419             uint256 requiredBaseSetQuantity
2420         ) = getBaseSetAddressAndQuantity(_rebalancingSetAddress, _rebalancingSetQuantity);
2421 
2422         // Issue base SetToken to this contract, held in this contract
2423         coreInstance.issueModule(
2424             msg.sender,
2425             address(this),
2426             baseSetAddress,
2427             requiredBaseSetQuantity
2428         );
2429 
2430         // Ensure base SetToken allowance to the transferProxy
2431         ERC20Wrapper.ensureAllowance(
2432             baseSetAddress,
2433             address(this),
2434             transferProxy,
2435             requiredBaseSetQuantity
2436         );
2437 
2438         // Issue rebalancing SetToken to the sender and return any excess base to sender
2439         issueRebalancingSetAndReturnExcessBase(
2440             _rebalancingSetAddress,
2441             baseSetAddress,
2442             _rebalancingSetQuantity,
2443             _keepChangeInVault
2444         );
2445     }
2446 
2447     /**
2448      * Issue a rebalancing SetToken using the base components and ether of the base SetToken. The ether is wrapped
2449      * into wrapped Ether and utilized in issuance.
2450      * The base SetToken is then issued and reissued into the rebalancing SetToken. Read more about base SetToken quantity
2451      * in the issueRebalancingSet function.
2452      * NOTE: Potential to receive more baseSet and ether dust than expected if someone transfers some to this module.
2453      * Be careful with balance checks.
2454      *
2455      * @param  _rebalancingSetAddress    Address of the rebalancing SetToken to issue
2456      * @param  _rebalancingSetQuantity   The issuance quantity of rebalancing SetToken
2457      * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transfered to the user
2458      *                                     or left in the vault
2459      */
2460     function issueRebalancingSetWrappingEther(
2461         address _rebalancingSetAddress,
2462         uint256 _rebalancingSetQuantity,
2463         bool _keepChangeInVault
2464     )
2465         external
2466         payable
2467         nonReentrant
2468     {
2469         // Get baseSet address and quantity required for issuance of Rebalancing Set
2470         (
2471             address baseSetAddress,
2472             uint256 requiredBaseSetQuantity
2473         ) = getBaseSetAddressAndQuantity(_rebalancingSetAddress, _rebalancingSetQuantity);
2474 
2475         // Validate that WETH is a component of baseSet
2476         validateWETHIsAComponentOfSet(baseSetAddress, address(weth));
2477 
2478         // Deposit all the required non-weth components to the vault under the name of this contract
2479         // The required ether is wrapped and approved to the transferProxy
2480         depositComponentsAndHandleEth(
2481             baseSetAddress,
2482             requiredBaseSetQuantity
2483         );
2484 
2485         // Issue base SetToken to this contract, with the base SetToken held in the Vault
2486         coreInstance.issueInVault(
2487             baseSetAddress,
2488             requiredBaseSetQuantity
2489         );
2490 
2491         // Note: Don't need to set allowance of the base SetToken as the base SetToken is already in the vault
2492 
2493         // Issue rebalancing SetToken to the sender and return any excess base to sender
2494         issueRebalancingSetAndReturnExcessBase(
2495             _rebalancingSetAddress,
2496             baseSetAddress,
2497             _rebalancingSetQuantity,
2498             _keepChangeInVault
2499         );
2500 
2501         // Any eth that is not wrapped is sent back to the user
2502         // Only the amount required for the base SetToken issuance is wrapped.
2503         uint256 leftoverEth = address(this).balance;
2504         if (leftoverEth > 0) {
2505             msg.sender.transfer(leftoverEth);
2506         }
2507     }
2508 
2509     /**
2510      * Redeems a rebalancing SetToken into the base components of the base SetToken.
2511      * NOTE: Potential to receive more baseSet than expected if someone transfers some to this module.
2512      * Be careful with balance checks.
2513      *
2514      * @param  _rebalancingSetAddress    Address of the rebalancing SetToken to redeem
2515      * @param  _rebalancingSetQuantity   The Quantity of the rebalancing SetToken to redeem
2516      * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transfered to the user
2517      *                                     or left in the vault
2518      */
2519     function redeemRebalancingSet(
2520         address _rebalancingSetAddress,
2521         uint256 _rebalancingSetQuantity,
2522         bool _keepChangeInVault
2523     )
2524         external
2525         nonReentrant
2526     {
2527         // Validate the rebalancing SetToken is valid and the quantity is a multiple of the natural unit
2528         validateRebalancingSetIssuance(_rebalancingSetAddress, _rebalancingSetQuantity);
2529 
2530         // Redeem RB Set to the vault attributed to this contract
2531         coreInstance.redeemModule(
2532             msg.sender,
2533             address(this),
2534             _rebalancingSetAddress,
2535             _rebalancingSetQuantity
2536         );
2537 
2538         // Calculate the base SetToken Redeem quantity
2539         address baseSetAddress = IRebalancingSetTokenV2(_rebalancingSetAddress).currentSet();
2540         uint256 baseSetRedeemQuantity = getBaseSetRedeemQuantity(baseSetAddress);
2541 
2542         // Withdraw base SetToken to this contract
2543         coreInstance.withdraw(
2544             baseSetAddress,
2545             baseSetRedeemQuantity
2546         );
2547 
2548         // Redeem base SetToken and send components to the the user
2549         // Set exclude to 0, as tokens in rebalancing SetToken are already whitelisted
2550         coreInstance.redeemAndWithdrawTo(
2551             baseSetAddress,
2552             msg.sender,
2553             baseSetRedeemQuantity,
2554             0
2555         );
2556 
2557         // Transfer any change of the base SetToken to the end user
2558         returnExcessBaseSet(baseSetAddress, transferProxy, _keepChangeInVault);
2559 
2560         // Log RebalancingSetRedeem
2561         emit LogRebalancingSetRedeem(
2562             _rebalancingSetAddress,
2563             msg.sender,
2564             _rebalancingSetQuantity
2565         );
2566     }
2567 
2568     /**
2569      * Redeems a rebalancing SetToken into the base components of the base SetToken. Unwraps
2570      * wrapped ether and sends eth to the user. If no wrapped ether in Set then will REVERT.
2571      * NOTE: Potential to receive more baseSet and ether dust than expected if someone transfers some to this module.
2572      * Be careful with balance checks.
2573      *
2574      * @param  _rebalancingSetAddress    Address of the rebalancing SetToken to redeem
2575      * @param  _rebalancingSetQuantity   The Quantity of the rebalancing SetToken to redeem
2576      * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transferred to the user
2577      *                                   or left in the vault
2578      */
2579     function redeemRebalancingSetUnwrappingEther(
2580         address _rebalancingSetAddress,
2581         uint256 _rebalancingSetQuantity,
2582         bool _keepChangeInVault
2583     )
2584         external
2585         nonReentrant
2586     {
2587         // Validate the rebalancing SetToken is valid and the quantity is a multiple of the natural unit
2588         validateRebalancingSetIssuance(_rebalancingSetAddress, _rebalancingSetQuantity);
2589 
2590         address baseSetAddress = IRebalancingSetTokenV2(_rebalancingSetAddress).currentSet();
2591 
2592         validateWETHIsAComponentOfSet(baseSetAddress, address(weth));
2593 
2594         // Redeem rebalancing SetToken to the vault attributed to this contract
2595         coreInstance.redeemModule(
2596             msg.sender,
2597             address(this),
2598             _rebalancingSetAddress,
2599             _rebalancingSetQuantity
2600         );
2601 
2602         // Calculate the base SetToken Redeem quantity
2603         uint256 baseSetRedeemQuantity = getBaseSetRedeemQuantity(baseSetAddress);
2604 
2605         // Withdraw base SetToken to this contract
2606         coreInstance.withdraw(
2607             baseSetAddress,
2608             baseSetRedeemQuantity
2609         );
2610 
2611         // Redeem the base SetToken. The components stay in the vault
2612         coreInstance.redeem(
2613             baseSetAddress,
2614             baseSetRedeemQuantity
2615         );
2616 
2617         // Loop through the base SetToken components and transfer to sender.
2618         withdrawComponentsToSenderWithEther(baseSetAddress);
2619 
2620         // Transfer any change of the base SetToken to the end user
2621         returnExcessBaseSet(baseSetAddress, transferProxy, _keepChangeInVault);
2622 
2623         // Log RebalancingSetRedeem
2624         emit LogRebalancingSetRedeem(
2625             _rebalancingSetAddress,
2626             msg.sender,
2627             _rebalancingSetQuantity
2628         );
2629     }
2630 
2631     /* ============ Private Functions ============ */
2632 
2633     /**
2634      * Gets base set address from rebalancing set token and calculates amount of base set needed
2635      * for issuance.
2636      *
2637      * @param  _rebalancingSetAddress    Address of the RebalancingSetToken to issue
2638      * @param  _rebalancingSetQuantity   The Quantity of the rebalancing SetToken to issue
2639      * @return baseSetAddress            The address of RebalancingSet's base SetToken
2640      * @return requiredBaseSetQuantity   The quantity of base SetToken to issue
2641      */
2642     function getBaseSetAddressAndQuantity(
2643         address _rebalancingSetAddress,
2644         uint256 _rebalancingSetQuantity
2645     )
2646         internal
2647         view
2648         returns (address, uint256)
2649     {
2650         // Validate the rebalancing SetToken is valid and the quantity is a multiple of the natural unit
2651         validateRebalancingSetIssuance(_rebalancingSetAddress, _rebalancingSetQuantity);
2652 
2653         address baseSetAddress = IRebalancingSetTokenV2(_rebalancingSetAddress).currentSet();
2654 
2655         // Calculate required base SetToken quantity
2656         uint256 requiredBaseSetQuantity = getBaseSetIssuanceRequiredQuantity(
2657             _rebalancingSetAddress,
2658             _rebalancingSetQuantity
2659         );
2660 
2661         return (baseSetAddress, requiredBaseSetQuantity);
2662     }
2663 
2664     /**
2665      * Issues the rebalancing set token to sender and returns any excess baseSet.
2666      *
2667      * @param  _rebalancingSetAddress    Address of the rebalancing SetToken to issue
2668      * @param  _baseSetAddress           Address of the rebalancing SetToken's base set
2669      * @param  _rebalancingSetQuantity   The Quantity of the rebalancing SetToken to redeem
2670      * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transferred to the user
2671      *                                   or left in the vault
2672      */
2673     function issueRebalancingSetAndReturnExcessBase(
2674         address _rebalancingSetAddress,
2675         address _baseSetAddress,
2676         uint256 _rebalancingSetQuantity,
2677         bool _keepChangeInVault
2678     )
2679         internal
2680     {
2681         // Issue rebalancing SetToken to the sender
2682         coreInstance.issueTo(
2683             msg.sender,
2684             _rebalancingSetAddress,
2685             _rebalancingSetQuantity
2686         );
2687 
2688         // Return any excess base SetToken token to the sender
2689         returnExcessBaseSet(_baseSetAddress, transferProxy, _keepChangeInVault);
2690 
2691         // Log RebalancingSetIssue
2692         emit LogRebalancingSetIssue(
2693             _rebalancingSetAddress,
2694             msg.sender,
2695             _rebalancingSetQuantity
2696         );
2697     }
2698 
2699     /**
2700      * During issuance, deposit the required quantity of base SetToken, wrap Ether, and deposit components
2701      * (excluding Ether, which is deposited during issuance) to the Vault in the name of the module.
2702      *
2703      * @param  _baseSetAddress           Address of the base SetToken token
2704      * @param  _baseSetQuantity          The Quantity of the base SetToken token to issue
2705      */
2706     function depositComponentsAndHandleEth(
2707         address _baseSetAddress,
2708         uint256 _baseSetQuantity
2709     )
2710         private
2711     {
2712         ISetToken baseSet = ISetToken(_baseSetAddress);
2713 
2714         address[] memory baseSetComponents = baseSet.getComponents();
2715         uint256[] memory baseSetUnits = baseSet.getUnits();
2716         uint256 baseSetNaturalUnit = baseSet.naturalUnit();
2717 
2718        // Loop through the base SetToken components and deposit components
2719         for (uint256 i = 0; i < baseSetComponents.length; i++) {
2720             address currentComponent = baseSetComponents[i];
2721             uint256 currentUnit = baseSetUnits[i];
2722 
2723             // Calculate required component quantity
2724             uint256 currentComponentQuantity = _baseSetQuantity.div(baseSetNaturalUnit).mul(currentUnit);
2725 
2726             // If address is weth, deposit weth and transfer eth
2727             if (currentComponent == address(weth)) {
2728                 // Expect the ether included exceeds the required Weth quantity
2729                 require(
2730                     msg.value >= currentComponentQuantity,
2731                     "RebalancingSetIssuanceModule.depositComponentsAndHandleEth: Not enough ether included for base SetToken"
2732                 );
2733 
2734                 // wrap the required ether quantity
2735                 weth.deposit.value(currentComponentQuantity)();
2736 
2737                 // Ensure weth allowance
2738                 ERC20Wrapper.ensureAllowance(
2739                     address(weth),
2740                     address(this),
2741                     transferProxy,
2742                     currentComponentQuantity
2743                 );
2744             } else {
2745                 // Deposit components to the vault in the name of the contract
2746                 coreInstance.depositModule(
2747                     msg.sender,
2748                     address(this),
2749                     currentComponent,
2750                     currentComponentQuantity
2751                 );
2752             }
2753         }
2754     }
2755 
2756     /**
2757      * During redemption, withdraw the required quantity of base SetToken, unwrapping Ether, and withdraw
2758      * components to the sender
2759      *
2760      * @param  _baseSetAddress           Address of the base SetToken
2761      */
2762     function withdrawComponentsToSenderWithEther(
2763         address _baseSetAddress
2764     )
2765         private
2766     {
2767         address[] memory baseSetComponents = ISetToken(_baseSetAddress).getComponents();
2768 
2769         // Loop through the base SetToken components.
2770         for (uint256 i = 0; i < baseSetComponents.length; i++) {
2771             address currentComponent = baseSetComponents[i];
2772             uint256 currentComponentQuantity = vaultInstance.getOwnerBalance(
2773                 currentComponent,
2774                 address(this)
2775             );
2776 
2777             // If address is weth, withdraw weth and transfer eth to sender
2778             if (currentComponent == address(weth)) {
2779                 // Transfer the wrapped ether to this address from the Vault
2780                 coreInstance.withdrawModule(
2781                     address(this),
2782                     address(this),
2783                     address(weth),
2784                     currentComponentQuantity
2785                 );
2786 
2787                 // Unwrap wrapped ether
2788                 weth.withdraw(currentComponentQuantity);
2789 
2790                 // Transfer to recipient
2791                 msg.sender.transfer(currentComponentQuantity);
2792             } else {
2793                 // Withdraw component from the Vault and send to the user
2794                 coreInstance.withdrawModule(
2795                     address(this),
2796                     msg.sender,
2797                     currentComponent,
2798                     currentComponentQuantity
2799                 );
2800             }
2801         }
2802     }
2803 }