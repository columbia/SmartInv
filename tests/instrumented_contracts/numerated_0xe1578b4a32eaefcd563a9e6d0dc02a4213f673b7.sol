1 // hevm: flattened sources of ./contracts/bondingcurve/EthBondingCurve.sol
2 pragma solidity >=0.4.0 >=0.6.0 <0.7.0 >=0.6.0 <0.8.0 >=0.6.2 <0.7.0 >=0.6.2 <0.8.0;
3 pragma experimental ABIEncoderV2;
4 
5 ////// ./contracts/external/SafeMathCopy.sol
6 // SPDX-License-Identifier: MIT
7 
8 /* pragma solidity ^0.6.0; */
9 
10 /**
11  * @dev Wrappers over Solidity's arithmetic operations with added overflow
12  * checks.
13  *
14  * Arithmetic operations in Solidity wrap on overflow. This can easily result
15  * in bugs, because programmers usually assume that an overflow raises an
16  * error, which is the standard behavior in high level programming languages.
17  * `SafeMath` restores this intuition by reverting the transaction when an
18  * operation overflows.
19  *
20  * Using this library instead of the unchecked operations eliminates an entire
21  * class of bugs, so it's recommended to use it always.
22  */
23 library SafeMathCopy { // To avoid namespace collision between openzeppelin safemath and uniswap safemath
24     /**
25      * @dev Returns the addition of two unsigned integers, reverting on
26      * overflow.
27      *
28      * Counterpart to Solidity's `+` operator.
29      *
30      * Requirements:
31      *
32      * - Addition cannot overflow.
33      */
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37 
38         return c;
39     }
40 
41     /**
42      * @dev Returns the subtraction of two unsigned integers, reverting on
43      * overflow (when the result is negative).
44      *
45      * Counterpart to Solidity's `-` operator.
46      *
47      * Requirements:
48      *
49      * - Subtraction cannot overflow.
50      */
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         return sub(a, b, "SafeMath: subtraction overflow");
53     }
54 
55     /**
56      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
57      * overflow (when the result is negative).
58      *
59      * Counterpart to Solidity's `-` operator.
60      *
61      * Requirements:
62      *
63      * - Subtraction cannot overflow.
64      */
65     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b <= a, errorMessage);
67         uint256 c = a - b;
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the multiplication of two unsigned integers, reverting on
74      * overflow.
75      *
76      * Counterpart to Solidity's `*` operator.
77      *
78      * Requirements:
79      *
80      * - Multiplication cannot overflow.
81      */
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
84         // benefit is lost if 'b' is also tested.
85         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
86         if (a == 0) {
87             return 0;
88         }
89 
90         uint256 c = a * b;
91         require(c / a == b, "SafeMath: multiplication overflow");
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the integer division of two unsigned integers. Reverts on
98      * division by zero. The result is rounded towards zero.
99      *
100      * Counterpart to Solidity's `/` operator. Note: this function uses a
101      * `revert` opcode (which leaves remaining gas untouched) while Solidity
102      * uses an invalid opcode to revert (consuming all remaining gas).
103      *
104      * Requirements:
105      *
106      * - The divisor cannot be zero.
107      */
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         return div(a, b, "SafeMath: division by zero");
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator. Note: this function uses a
117      * `revert` opcode (which leaves remaining gas untouched) while Solidity
118      * uses an invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      *
122      * - The divisor cannot be zero.
123      */
124     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
125         require(b > 0, errorMessage);
126         uint256 c = a / b;
127         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
134      * Reverts when dividing by zero.
135      *
136      * Counterpart to Solidity's `%` operator. This function uses a `revert`
137      * opcode (which leaves remaining gas untouched) while Solidity uses an
138      * invalid opcode to revert (consuming all remaining gas).
139      *
140      * Requirements:
141      *
142      * - The divisor cannot be zero.
143      */
144     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
145         return mod(a, b, "SafeMath: modulo by zero");
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
150      * Reverts with custom message when dividing by zero.
151      *
152      * Counterpart to Solidity's `%` operator. This function uses a `revert`
153      * opcode (which leaves remaining gas untouched) while Solidity uses an
154      * invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      *
158      * - The divisor cannot be zero.
159      */
160     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b != 0, errorMessage);
162         return a % b;
163     }
164 }
165 
166 ////// ./contracts/external/Decimal.sol
167 /*
168     Copyright 2019 dYdX Trading Inc.
169     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
170     Licensed under the Apache License, Version 2.0 (the "License");
171     you may not use this file except in compliance with the License.
172     You may obtain a copy of the License at
173     http://www.apache.org/licenses/LICENSE-2.0
174     Unless required by applicable law or agreed to in writing, software
175     distributed under the License is distributed on an "AS IS" BASIS,
176     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
177     See the License for the specific language governing permissions and
178     limitations under the License.
179 */
180 
181 /* pragma solidity ^0.6.0; */
182 /* pragma experimental ABIEncoderV2; */
183 
184 /* import "./SafeMathCopy.sol"; */
185 
186 /**
187  * @title Decimal
188  * @author dYdX
189  *
190  * Library that defines a fixed-point number with 18 decimal places.
191  */
192 library Decimal {
193     using SafeMathCopy for uint256;
194 
195     // ============ Constants ============
196 
197     uint256 private constant BASE = 10**18;
198 
199     // ============ Structs ============
200 
201 
202     struct D256 {
203         uint256 value;
204     }
205 
206     // ============ Static Functions ============
207 
208     function zero()
209     internal
210     pure
211     returns (D256 memory)
212     {
213         return D256({ value: 0 });
214     }
215 
216     function one()
217     internal
218     pure
219     returns (D256 memory)
220     {
221         return D256({ value: BASE });
222     }
223 
224     function from(
225         uint256 a
226     )
227     internal
228     pure
229     returns (D256 memory)
230     {
231         return D256({ value: a.mul(BASE) });
232     }
233 
234     function ratio(
235         uint256 a,
236         uint256 b
237     )
238     internal
239     pure
240     returns (D256 memory)
241     {
242         return D256({ value: getPartial(a, BASE, b) });
243     }
244 
245     // ============ Self Functions ============
246 
247     function add(
248         D256 memory self,
249         uint256 b
250     )
251     internal
252     pure
253     returns (D256 memory)
254     {
255         return D256({ value: self.value.add(b.mul(BASE)) });
256     }
257 
258     function sub(
259         D256 memory self,
260         uint256 b
261     )
262     internal
263     pure
264     returns (D256 memory)
265     {
266         return D256({ value: self.value.sub(b.mul(BASE)) });
267     }
268 
269     function sub(
270         D256 memory self,
271         uint256 b,
272         string memory reason
273     )
274     internal
275     pure
276     returns (D256 memory)
277     {
278         return D256({ value: self.value.sub(b.mul(BASE), reason) });
279     }
280 
281     function mul(
282         D256 memory self,
283         uint256 b
284     )
285     internal
286     pure
287     returns (D256 memory)
288     {
289         return D256({ value: self.value.mul(b) });
290     }
291 
292     function div(
293         D256 memory self,
294         uint256 b
295     )
296     internal
297     pure
298     returns (D256 memory)
299     {
300         return D256({ value: self.value.div(b) });
301     }
302 
303     function pow(
304         D256 memory self,
305         uint256 b
306     )
307     internal
308     pure
309     returns (D256 memory)
310     {
311         if (b == 0) {
312             return from(1);
313         }
314 
315         D256 memory temp = D256({ value: self.value });
316         for (uint256 i = 1; i < b; i++) {
317             temp = mul(temp, self);
318         }
319 
320         return temp;
321     }
322 
323     function add(
324         D256 memory self,
325         D256 memory b
326     )
327     internal
328     pure
329     returns (D256 memory)
330     {
331         return D256({ value: self.value.add(b.value) });
332     }
333 
334     function sub(
335         D256 memory self,
336         D256 memory b
337     )
338     internal
339     pure
340     returns (D256 memory)
341     {
342         return D256({ value: self.value.sub(b.value) });
343     }
344 
345     function sub(
346         D256 memory self,
347         D256 memory b,
348         string memory reason
349     )
350     internal
351     pure
352     returns (D256 memory)
353     {
354         return D256({ value: self.value.sub(b.value, reason) });
355     }
356 
357     function mul(
358         D256 memory self,
359         D256 memory b
360     )
361     internal
362     pure
363     returns (D256 memory)
364     {
365         return D256({ value: getPartial(self.value, b.value, BASE) });
366     }
367 
368     function div(
369         D256 memory self,
370         D256 memory b
371     )
372     internal
373     pure
374     returns (D256 memory)
375     {
376         return D256({ value: getPartial(self.value, BASE, b.value) });
377     }
378 
379     function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
380         return self.value == b.value;
381     }
382 
383     function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
384         return compareTo(self, b) == 2;
385     }
386 
387     function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
388         return compareTo(self, b) == 0;
389     }
390 
391     function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
392         return compareTo(self, b) > 0;
393     }
394 
395     function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
396         return compareTo(self, b) < 2;
397     }
398 
399     function isZero(D256 memory self) internal pure returns (bool) {
400         return self.value == 0;
401     }
402 
403     function asUint256(D256 memory self) internal pure returns (uint256) {
404         return self.value.div(BASE);
405     }
406 
407     // ============ Core Methods ============
408 
409     function getPartial(
410         uint256 target,
411         uint256 numerator,
412         uint256 denominator
413     )
414     private
415     pure
416     returns (uint256)
417     {
418         return target.mul(numerator).div(denominator);
419     }
420 
421     function compareTo(
422         D256 memory a,
423         D256 memory b
424     )
425     private
426     pure
427     returns (uint256)
428     {
429         if (a.value == b.value) {
430             return 1;
431         }
432         return a.value > b.value ? 2 : 0;
433     }
434 }
435 ////// ./contracts/bondingcurve/IBondingCurve.sol
436 /* pragma solidity ^0.6.0; */
437 /* pragma experimental ABIEncoderV2; */
438 
439 /* import "../external/Decimal.sol"; */
440 
441 interface IBondingCurve {
442     // ----------- Events -----------
443 
444     event ScaleUpdate(uint256 _scale);
445 
446     event BufferUpdate(uint256 _buffer);
447 
448     event IncentiveAmountUpdate(uint256 _incentiveAmount);
449 
450     event Purchase(address indexed _to, uint256 _amountIn, uint256 _amountOut);
451 
452     event Allocate(address indexed _caller, uint256 _amount);
453 
454     // ----------- State changing Api -----------
455 
456     function purchase(address to, uint256 amountIn)
457         external
458         payable
459         returns (uint256 amountOut);
460 
461     function allocate() external;
462 
463     // ----------- Governor only state changing api -----------
464 
465     function setBuffer(uint256 _buffer) external;
466 
467     function setScale(uint256 _scale) external;
468 
469     function setAllocation(
470         address[] calldata pcvDeposits,
471         uint256[] calldata ratios
472     ) external;
473 
474     function setIncentiveAmount(uint256 _incentiveAmount) external;
475 
476     function setIncentiveFrequency(uint256 _frequency) external;
477 
478     // ----------- Getters -----------
479 
480     function getCurrentPrice() external view returns (Decimal.D256 memory);
481 
482     function getAverageUSDPrice(uint256 amountIn)
483         external
484         view
485         returns (Decimal.D256 memory);
486 
487     function getAmountOut(uint256 amountIn)
488         external
489         view
490         returns (uint256 amountOut);
491 
492     function scale() external view returns (uint256);
493 
494     function atScale() external view returns (bool);
495 
496     function buffer() external view returns (uint256);
497 
498     function totalPurchased() external view returns (uint256);
499 
500     function getTotalPCVHeld() external view returns (uint256);
501 
502     function incentiveAmount() external view returns (uint256);
503 }
504 
505 ////// /home/brock/git_pkgs/fei-protocol-core/contracts/openzeppelin/contracts/token/ERC20/IERC20.sol
506 // SPDX-License-Identifier: MIT
507 
508 /* pragma solidity >=0.6.0 <0.8.0; */
509 
510 /**
511  * @dev Interface of the ERC20 standard as defined in the EIP.
512  */
513 interface IERC20_5 {
514     /**
515      * @dev Returns the amount of tokens in existence.
516      */
517     function totalSupply() external view returns (uint256);
518 
519     /**
520      * @dev Returns the amount of tokens owned by `account`.
521      */
522     function balanceOf(address account) external view returns (uint256);
523 
524     /**
525      * @dev Moves `amount` tokens from the caller's account to `recipient`.
526      *
527      * Returns a boolean value indicating whether the operation succeeded.
528      *
529      * Emits a {Transfer} event.
530      */
531     function transfer(address recipient, uint256 amount) external returns (bool);
532 
533     /**
534      * @dev Returns the remaining number of tokens that `spender` will be
535      * allowed to spend on behalf of `owner` through {transferFrom}. This is
536      * zero by default.
537      *
538      * This value changes when {approve} or {transferFrom} are called.
539      */
540     function allowance(address owner, address spender) external view returns (uint256);
541 
542     /**
543      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
544      *
545      * Returns a boolean value indicating whether the operation succeeded.
546      *
547      * IMPORTANT: Beware that changing an allowance with this method brings the risk
548      * that someone may use both the old and the new allowance by unfortunate
549      * transaction ordering. One possible solution to mitigate this race
550      * condition is to first reduce the spender's allowance to 0 and set the
551      * desired value afterwards:
552      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
553      *
554      * Emits an {Approval} event.
555      */
556     function approve(address spender, uint256 amount) external returns (bool);
557 
558     /**
559      * @dev Moves `amount` tokens from `sender` to `recipient` using the
560      * allowance mechanism. `amount` is then deducted from the caller's
561      * allowance.
562      *
563      * Returns a boolean value indicating whether the operation succeeded.
564      *
565      * Emits a {Transfer} event.
566      */
567     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
568 
569     /**
570      * @dev Emitted when `value` tokens are moved from one account (`from`) to
571      * another (`to`).
572      *
573      * Note that `value` may be zero.
574      */
575     event Transfer(address indexed from, address indexed to, uint256 value);
576 
577     /**
578      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
579      * a call to {approve}. `value` is the new allowance.
580      */
581     event Approval(address indexed owner, address indexed spender, uint256 value);
582 }
583 
584 ////// ./contracts/pcv/PCVSplitter.sol
585 /* pragma solidity ^0.6.0; */
586 /* pragma experimental ABIEncoderV2; */
587 
588 /* import "../external/SafeMathCopy.sol"; */
589 /* import "/home/brock/git_pkgs/fei-protocol-core/contracts/openzeppelin/contracts/token/ERC20/IERC20.sol"; */
590 
591 /// @title abstract contract for splitting PCV into different deposits
592 /// @author Fei Protocol
593 abstract contract PCVSplitter {
594     using SafeMathCopy for uint256;
595 
596     /// @notice total allocation allowed representing 100%
597     uint256 public constant ALLOCATION_GRANULARITY = 10_000;
598 
599     uint256[] private ratios;
600     address[] private pcvDeposits;
601 
602     event AllocationUpdate(address[] _pcvDeposits, uint256[] _ratios);
603 
604     /// @notice PCVSplitter constructor
605     /// @param _pcvDeposits list of PCV Deposits to split to
606     /// @param _ratios ratios for splitting PCV Deposit allocations
607     constructor(address[] memory _pcvDeposits, uint256[] memory _ratios)
608         public
609     {
610         _setAllocation(_pcvDeposits, _ratios);
611     }
612 
613     /// @notice make sure an allocation has matching lengths and totals the ALLOCATION_GRANULARITY
614     /// @param _pcvDeposits new list of pcv deposits to send to
615     /// @param _ratios new ratios corresponding to the PCV deposits
616     /// @return true if it is a valid allocation
617     function checkAllocation(
618         address[] memory _pcvDeposits,
619         uint256[] memory _ratios
620     ) public pure returns (bool) {
621         require(
622             _pcvDeposits.length == _ratios.length,
623             "PCVSplitter: PCV Deposits and ratios are different lengths"
624         );
625 
626         uint256 total;
627         for (uint256 i; i < _ratios.length; i++) {
628             total = total.add(_ratios[i]);
629         }
630 
631         require(
632             total == ALLOCATION_GRANULARITY,
633             "PCVSplitter: ratios do not total 100%"
634         );
635 
636         return true;
637     }
638 
639     /// @notice gets the pcvDeposits and ratios of the splitter
640     function getAllocation()
641         public
642         view
643         returns (address[] memory, uint256[] memory)
644     {
645         return (pcvDeposits, ratios);
646     }
647 
648     /// @notice distribute funds to single PCV deposit
649     /// @param amount amount of funds to send
650     /// @param pcvDeposit the pcv deposit to send funds
651     function _allocateSingle(uint256 amount, address pcvDeposit)
652         internal
653         virtual;
654 
655     /// @notice sets a new allocation for the splitter
656     /// @param _pcvDeposits new list of pcv deposits to send to
657     /// @param _ratios new ratios corresponding to the PCV deposits. Must total ALLOCATION_GRANULARITY
658     function _setAllocation(
659         address[] memory _pcvDeposits,
660         uint256[] memory _ratios
661     ) internal {
662         checkAllocation(_pcvDeposits, _ratios);
663 
664         pcvDeposits = _pcvDeposits;
665         ratios = _ratios;
666 
667         emit AllocationUpdate(_pcvDeposits, _ratios);
668     }
669 
670     /// @notice distribute funds to all pcv deposits at specified allocation ratios
671     /// @param total amount of funds to send
672     function _allocate(uint256 total) internal {
673         uint256 granularity = ALLOCATION_GRANULARITY;
674         for (uint256 i; i < ratios.length; i++) {
675             uint256 amount = total.mul(ratios[i]) / granularity;
676             _allocateSingle(amount, pcvDeposits[i]);
677         }
678     }
679 }
680 
681 ////// ./contracts/core/IPermissions.sol
682 /* pragma solidity ^0.6.0; */
683 /* pragma experimental ABIEncoderV2; */
684 
685 /// @title Permissions interface
686 /// @author Fei Protocol
687 interface IPermissions {
688     // ----------- Governor only state changing api -----------
689 
690     function createRole(bytes32 role, bytes32 adminRole) external;
691 
692     function grantMinter(address minter) external;
693 
694     function grantBurner(address burner) external;
695 
696     function grantPCVController(address pcvController) external;
697 
698     function grantGovernor(address governor) external;
699 
700     function grantGuardian(address guardian) external;
701 
702     function revokeMinter(address minter) external;
703 
704     function revokeBurner(address burner) external;
705 
706     function revokePCVController(address pcvController) external;
707 
708     function revokeGovernor(address governor) external;
709 
710     function revokeGuardian(address guardian) external;
711 
712     // ----------- Revoker only state changing api -----------
713 
714     function revokeOverride(bytes32 role, address account) external;
715 
716     // ----------- Getters -----------
717 
718     function isBurner(address _address) external view returns (bool);
719 
720     function isMinter(address _address) external view returns (bool);
721 
722     function isGovernor(address _address) external view returns (bool);
723 
724     function isGuardian(address _address) external view returns (bool);
725 
726     function isPCVController(address _address) external view returns (bool);
727 }
728 
729 ////// ./contracts/token/IFei.sol
730 /* pragma solidity ^0.6.2; */
731 
732 /* import "/home/brock/git_pkgs/fei-protocol-core/contracts/openzeppelin/contracts/token/ERC20/IERC20.sol"; */
733 
734 /// @title FEI stablecoin interface
735 /// @author Fei Protocol
736 interface IFei is IERC20_5 {
737     // ----------- Events -----------
738 
739     event Minting(
740         address indexed _to,
741         address indexed _minter,
742         uint256 _amount
743     );
744 
745     event Burning(
746         address indexed _to,
747         address indexed _burner,
748         uint256 _amount
749     );
750 
751     event IncentiveContractUpdate(
752         address indexed _incentivized,
753         address indexed _incentiveContract
754     );
755 
756     // ----------- State changing api -----------
757 
758     function burn(uint256 amount) external;
759 
760     function permit(
761         address owner,
762         address spender,
763         uint256 value,
764         uint256 deadline,
765         uint8 v,
766         bytes32 r,
767         bytes32 s
768     ) external;
769 
770     // ----------- Burner only state changing api -----------
771 
772     function burnFrom(address account, uint256 amount) external;
773 
774     // ----------- Minter only state changing api -----------
775 
776     function mint(address account, uint256 amount) external;
777 
778     // ----------- Governor only state changing api -----------
779 
780     function setIncentiveContract(address account, address incentive) external;
781 
782     // ----------- Getters -----------
783 
784     function incentiveContract(address account) external view returns (address);
785 }
786 
787 ////// ./contracts/core/ICore.sol
788 /* pragma solidity ^0.6.0; */
789 /* pragma experimental ABIEncoderV2; */
790 
791 /* import "./IPermissions.sol"; */
792 /* import "../token/IFei.sol"; */
793 
794 /// @title Core Interface
795 /// @author Fei Protocol
796 interface ICore is IPermissions {
797     // ----------- Events -----------
798 
799     event FeiUpdate(address indexed _fei);
800     event TribeUpdate(address indexed _tribe);
801     event GenesisGroupUpdate(address indexed _genesisGroup);
802     event TribeAllocation(address indexed _to, uint256 _amount);
803     event GenesisPeriodComplete(uint256 _timestamp);
804 
805     // ----------- Governor only state changing api -----------
806 
807     function init() external;
808 
809     // ----------- Governor only state changing api -----------
810 
811     function setFei(address token) external;
812 
813     function setTribe(address token) external;
814 
815     function setGenesisGroup(address _genesisGroup) external;
816 
817     function allocateTribe(address to, uint256 amount) external;
818 
819     // ----------- Genesis Group only state changing api -----------
820 
821     function completeGenesisGroup() external;
822 
823     // ----------- Getters -----------
824 
825     function fei() external view returns (IFei);
826 
827     function tribe() external view returns (IERC20_5);
828 
829     function genesisGroup() external view returns (address);
830 
831     function hasGenesisGroupCompleted() external view returns (bool);
832 }
833 
834 ////// ./contracts/refs/ICoreRef.sol
835 /* pragma solidity ^0.6.0; */
836 /* pragma experimental ABIEncoderV2; */
837 
838 /* import "../core/ICore.sol"; */
839 
840 /// @title CoreRef interface
841 /// @author Fei Protocol
842 interface ICoreRef {
843     // ----------- Events -----------
844 
845     event CoreUpdate(address indexed _core);
846 
847     // ----------- Governor only state changing api -----------
848 
849     function setCore(address core) external;
850 
851     function pause() external;
852 
853     function unpause() external;
854 
855     // ----------- Getters -----------
856 
857     function core() external view returns (ICore);
858 
859     function fei() external view returns (IFei);
860 
861     function tribe() external view returns (IERC20_5);
862 
863     function feiBalance() external view returns (uint256);
864 
865     function tribeBalance() external view returns (uint256);
866 }
867 
868 ////// /home/brock/git_pkgs/fei-protocol-core/contracts/openzeppelin/contracts/utils/Address.sol
869 // SPDX-License-Identifier: MIT
870 
871 /* pragma solidity >=0.6.2 <0.8.0; */
872 
873 /**
874  * @dev Collection of functions related to the address type
875  */
876 library Address_2 {
877     /**
878      * @dev Returns true if `account` is a contract.
879      *
880      * [IMPORTANT]
881      * ====
882      * It is unsafe to assume that an address for which this function returns
883      * false is an externally-owned account (EOA) and not a contract.
884      *
885      * Among others, `isContract` will return false for the following
886      * types of addresses:
887      *
888      *  - an externally-owned account
889      *  - a contract in construction
890      *  - an address where a contract will be created
891      *  - an address where a contract lived, but was destroyed
892      * ====
893      */
894     function isContract(address account) internal view returns (bool) {
895         // This method relies on extcodesize, which returns 0 for contracts in
896         // construction, since the code is only stored at the end of the
897         // constructor execution.
898 
899         uint256 size;
900         // solhint-disable-next-line no-inline-assembly
901         assembly { size := extcodesize(account) }
902         return size > 0;
903     }
904 
905     /**
906      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
907      * `recipient`, forwarding all available gas and reverting on errors.
908      *
909      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
910      * of certain opcodes, possibly making contracts go over the 2300 gas limit
911      * imposed by `transfer`, making them unable to receive funds via
912      * `transfer`. {sendValue} removes this limitation.
913      *
914      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
915      *
916      * IMPORTANT: because control is transferred to `recipient`, care must be
917      * taken to not create reentrancy vulnerabilities. Consider using
918      * {ReentrancyGuard} or the
919      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
920      */
921     function sendValue(address payable recipient, uint256 amount) internal {
922         require(address(this).balance >= amount, "Address: insufficient balance");
923 
924         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
925         (bool success, ) = recipient.call{ value: amount }("");
926         require(success, "Address: unable to send value, recipient may have reverted");
927     }
928 
929     /**
930      * @dev Performs a Solidity function call using a low level `call`. A
931      * plain`call` is an unsafe replacement for a function call: use this
932      * function instead.
933      *
934      * If `target` reverts with a revert reason, it is bubbled up by this
935      * function (like regular Solidity function calls).
936      *
937      * Returns the raw returned data. To convert to the expected return value,
938      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
939      *
940      * Requirements:
941      *
942      * - `target` must be a contract.
943      * - calling `target` with `data` must not revert.
944      *
945      * _Available since v3.1._
946      */
947     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
948       return functionCall(target, data, "Address: low-level call failed");
949     }
950 
951     /**
952      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
953      * `errorMessage` as a fallback revert reason when `target` reverts.
954      *
955      * _Available since v3.1._
956      */
957     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
958         return functionCallWithValue(target, data, 0, errorMessage);
959     }
960 
961     /**
962      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
963      * but also transferring `value` wei to `target`.
964      *
965      * Requirements:
966      *
967      * - the calling contract must have an ETH balance of at least `value`.
968      * - the called Solidity function must be `payable`.
969      *
970      * _Available since v3.1._
971      */
972     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
973         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
974     }
975 
976     /**
977      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
978      * with `errorMessage` as a fallback revert reason when `target` reverts.
979      *
980      * _Available since v3.1._
981      */
982     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
983         require(address(this).balance >= value, "Address: insufficient balance for call");
984         require(isContract(target), "Address: call to non-contract");
985 
986         // solhint-disable-next-line avoid-low-level-calls
987         (bool success, bytes memory returndata) = target.call{ value: value }(data);
988         return _verifyCallResult(success, returndata, errorMessage);
989     }
990 
991     /**
992      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
993      * but performing a static call.
994      *
995      * _Available since v3.3._
996      */
997     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
998         return functionStaticCall(target, data, "Address: low-level static call failed");
999     }
1000 
1001     /**
1002      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1003      * but performing a static call.
1004      *
1005      * _Available since v3.3._
1006      */
1007     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1008         require(isContract(target), "Address: static call to non-contract");
1009 
1010         // solhint-disable-next-line avoid-low-level-calls
1011         (bool success, bytes memory returndata) = target.staticcall(data);
1012         return _verifyCallResult(success, returndata, errorMessage);
1013     }
1014 
1015     /**
1016      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1017      * but performing a delegate call.
1018      *
1019      * _Available since v3.4._
1020      */
1021     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1022         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1023     }
1024 
1025     /**
1026      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1027      * but performing a delegate call.
1028      *
1029      * _Available since v3.4._
1030      */
1031     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1032         require(isContract(target), "Address: delegate call to non-contract");
1033 
1034         // solhint-disable-next-line avoid-low-level-calls
1035         (bool success, bytes memory returndata) = target.delegatecall(data);
1036         return _verifyCallResult(success, returndata, errorMessage);
1037     }
1038 
1039     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1040         if (success) {
1041             return returndata;
1042         } else {
1043             // Look for revert reason and bubble it up if present
1044             if (returndata.length > 0) {
1045                 // The easiest way to bubble the revert reason is using memory via assembly
1046 
1047                 // solhint-disable-next-line no-inline-assembly
1048                 assembly {
1049                     let returndata_size := mload(returndata)
1050                     revert(add(32, returndata), returndata_size)
1051                 }
1052             } else {
1053                 revert(errorMessage);
1054             }
1055         }
1056     }
1057 }
1058 
1059 ////// /home/brock/git_pkgs/fei-protocol-core/contracts/openzeppelin/contracts/utils/Context.sol
1060 // SPDX-License-Identifier: MIT
1061 
1062 /* pragma solidity >=0.6.0 <0.8.0; */
1063 
1064 /*
1065  * @dev Provides information about the current execution context, including the
1066  * sender of the transaction and its data. While these are generally available
1067  * via msg.sender and msg.data, they should not be accessed in such a direct
1068  * manner, since when dealing with GSN meta-transactions the account sending and
1069  * paying for execution may not be the actual sender (as far as an application
1070  * is concerned).
1071  *
1072  * This contract is only required for intermediate, library-like contracts.
1073  */
1074 abstract contract Context_2 {
1075     function _msgSender() internal view virtual returns (address payable) {
1076         return msg.sender;
1077     }
1078 
1079     function _msgData() internal view virtual returns (bytes memory) {
1080         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1081         return msg.data;
1082     }
1083 }
1084 
1085 ////// /home/brock/git_pkgs/fei-protocol-core/contracts/openzeppelin/contracts/utils/Pausable.sol
1086 // SPDX-License-Identifier: MIT
1087 
1088 /* pragma solidity >=0.6.0 <0.8.0; */
1089 
1090 /* import "./Context.sol"; */
1091 
1092 /**
1093  * @dev Contract module which allows children to implement an emergency stop
1094  * mechanism that can be triggered by an authorized account.
1095  *
1096  * This module is used through inheritance. It will make available the
1097  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1098  * the functions of your contract. Note that they will not be pausable by
1099  * simply including this module, only once the modifiers are put in place.
1100  */
1101 abstract contract Pausable_2 is Context_2 {
1102     /**
1103      * @dev Emitted when the pause is triggered by `account`.
1104      */
1105     event Paused(address account);
1106 
1107     /**
1108      * @dev Emitted when the pause is lifted by `account`.
1109      */
1110     event Unpaused(address account);
1111 
1112     bool private _paused;
1113 
1114     /**
1115      * @dev Initializes the contract in unpaused state.
1116      */
1117     constructor () internal {
1118         _paused = false;
1119     }
1120 
1121     /**
1122      * @dev Returns true if the contract is paused, and false otherwise.
1123      */
1124     function paused() public view virtual returns (bool) {
1125         return _paused;
1126     }
1127 
1128     /**
1129      * @dev Modifier to make a function callable only when the contract is not paused.
1130      *
1131      * Requirements:
1132      *
1133      * - The contract must not be paused.
1134      */
1135     modifier whenNotPaused() {
1136         require(!paused(), "Pausable: paused");
1137         _;
1138     }
1139 
1140     /**
1141      * @dev Modifier to make a function callable only when the contract is paused.
1142      *
1143      * Requirements:
1144      *
1145      * - The contract must be paused.
1146      */
1147     modifier whenPaused() {
1148         require(paused(), "Pausable: not paused");
1149         _;
1150     }
1151 
1152     /**
1153      * @dev Triggers stopped state.
1154      *
1155      * Requirements:
1156      *
1157      * - The contract must not be paused.
1158      */
1159     function _pause() internal virtual whenNotPaused {
1160         _paused = true;
1161         emit Paused(_msgSender());
1162     }
1163 
1164     /**
1165      * @dev Returns to normal state.
1166      *
1167      * Requirements:
1168      *
1169      * - The contract must be paused.
1170      */
1171     function _unpause() internal virtual whenPaused {
1172         _paused = false;
1173         emit Unpaused(_msgSender());
1174     }
1175 }
1176 
1177 ////// ./contracts/refs/CoreRef.sol
1178 /* pragma solidity ^0.6.0; */
1179 /* pragma experimental ABIEncoderV2; */
1180 
1181 /* import "./ICoreRef.sol"; */
1182 /* import "/home/brock/git_pkgs/fei-protocol-core/contracts/openzeppelin/contracts/utils/Pausable.sol"; */
1183 /* import "/home/brock/git_pkgs/fei-protocol-core/contracts/openzeppelin/contracts/utils/Address.sol"; */
1184 
1185 /// @title A Reference to Core
1186 /// @author Fei Protocol
1187 /// @notice defines some modifiers and utilities around interacting with Core
1188 abstract contract CoreRef is ICoreRef, Pausable_2 {
1189     ICore private _core;
1190 
1191     /// @notice CoreRef constructor
1192     /// @param core Fei Core to reference
1193     constructor(address core) public {
1194         _core = ICore(core);
1195     }
1196 
1197     modifier ifMinterSelf() {
1198         if (_core.isMinter(address(this))) {
1199             _;
1200         }
1201     }
1202 
1203     modifier ifBurnerSelf() {
1204         if (_core.isBurner(address(this))) {
1205             _;
1206         }
1207     }
1208 
1209     modifier onlyMinter() {
1210         require(_core.isMinter(msg.sender), "CoreRef: Caller is not a minter");
1211         _;
1212     }
1213 
1214     modifier onlyBurner() {
1215         require(_core.isBurner(msg.sender), "CoreRef: Caller is not a burner");
1216         _;
1217     }
1218 
1219     modifier onlyPCVController() {
1220         require(
1221             _core.isPCVController(msg.sender),
1222             "CoreRef: Caller is not a PCV controller"
1223         );
1224         _;
1225     }
1226 
1227     modifier onlyGovernor() {
1228         require(
1229             _core.isGovernor(msg.sender),
1230             "CoreRef: Caller is not a governor"
1231         );
1232         _;
1233     }
1234 
1235     modifier onlyGuardianOrGovernor() {
1236         require(
1237             _core.isGovernor(msg.sender) ||
1238             _core.isGuardian(msg.sender),
1239             "CoreRef: Caller is not a guardian or governor"
1240         );
1241         _;
1242     }
1243 
1244     modifier onlyFei() {
1245         require(msg.sender == address(fei()), "CoreRef: Caller is not FEI");
1246         _;
1247     }
1248 
1249     modifier onlyGenesisGroup() {
1250         require(
1251             msg.sender == _core.genesisGroup(),
1252             "CoreRef: Caller is not GenesisGroup"
1253         );
1254         _;
1255     }
1256 
1257     modifier postGenesis() {
1258         require(
1259             _core.hasGenesisGroupCompleted(),
1260             "CoreRef: Still in Genesis Period"
1261         );
1262         _;
1263     }
1264 
1265     modifier nonContract() {
1266         require(!Address_2.isContract(msg.sender), "CoreRef: Caller is a contract");
1267         _;
1268     }
1269 
1270     /// @notice set new Core reference address
1271     /// @param core the new core address
1272     function setCore(address core) external override onlyGovernor {
1273         _core = ICore(core);
1274         emit CoreUpdate(core);
1275     }
1276 
1277     /// @notice set pausable methods to paused
1278     function pause() public override onlyGuardianOrGovernor {
1279         _pause();
1280     }
1281 
1282     /// @notice set pausable methods to unpaused
1283     function unpause() public override onlyGuardianOrGovernor {
1284         _unpause();
1285     }
1286 
1287     /// @notice address of the Core contract referenced
1288     /// @return ICore implementation address
1289     function core() public view override returns (ICore) {
1290         return _core;
1291     }
1292 
1293     /// @notice address of the Fei contract referenced by Core
1294     /// @return IFei implementation address
1295     function fei() public view override returns (IFei) {
1296         return _core.fei();
1297     }
1298 
1299     /// @notice address of the Tribe contract referenced by Core
1300     /// @return IERC20 implementation address
1301     function tribe() public view override returns (IERC20_5) {
1302         return _core.tribe();
1303     }
1304 
1305     /// @notice fei balance of contract
1306     /// @return fei amount held
1307     function feiBalance() public view override returns (uint256) {
1308         return fei().balanceOf(address(this));
1309     }
1310 
1311     /// @notice tribe balance of contract
1312     /// @return tribe amount held
1313     function tribeBalance() public view override returns (uint256) {
1314         return tribe().balanceOf(address(this));
1315     }
1316 
1317     function _burnFeiHeld() internal {
1318         fei().burn(feiBalance());
1319     }
1320 
1321     function _mintFei(uint256 amount) internal {
1322         fei().mint(address(this), amount);
1323     }
1324 }
1325 
1326 ////// ./contracts/oracle/IOracle.sol
1327 /* pragma solidity ^0.6.0; */
1328 /* pragma experimental ABIEncoderV2; */
1329 
1330 /* import "../external/Decimal.sol"; */
1331 
1332 /// @title generic oracle interface for Fei Protocol
1333 /// @author Fei Protocol
1334 interface IOracle {
1335     // ----------- Events -----------
1336 
1337     event Update(uint256 _peg);
1338 
1339     // ----------- State changing API -----------
1340 
1341     function update() external returns (bool);
1342 
1343     // ----------- Getters -----------
1344 
1345     function read() external view returns (Decimal.D256 memory, bool);
1346 
1347     function isOutdated() external view returns (bool);
1348 
1349 }
1350 
1351 ////// ./contracts/refs/IOracleRef.sol
1352 /* pragma solidity ^0.6.0; */
1353 /* pragma experimental ABIEncoderV2; */
1354 
1355 /* import "../oracle/IOracle.sol"; */
1356 
1357 /// @title OracleRef interface
1358 /// @author Fei Protocol
1359 interface IOracleRef {
1360     // ----------- Events -----------
1361 
1362     event OracleUpdate(address indexed _oracle);
1363 
1364     // ----------- State changing API -----------
1365 
1366     function updateOracle() external returns (bool);
1367 
1368     // ----------- Governor only state changing API -----------
1369 
1370     function setOracle(address _oracle) external;
1371 
1372     // ----------- Getters -----------
1373 
1374     function oracle() external view returns (IOracle);
1375 
1376     function peg() external view returns (Decimal.D256 memory);
1377 
1378     function invert(Decimal.D256 calldata price)
1379         external
1380         pure
1381         returns (Decimal.D256 memory);
1382 }
1383 
1384 ////// ./contracts/refs/OracleRef.sol
1385 /* pragma solidity ^0.6.0; */
1386 /* pragma experimental ABIEncoderV2; */
1387 
1388 /* import "./IOracleRef.sol"; */
1389 /* import "./CoreRef.sol"; */
1390 
1391 /// @title Reference to an Oracle
1392 /// @author Fei Protocol
1393 /// @notice defines some utilities around interacting with the referenced oracle
1394 abstract contract OracleRef is IOracleRef, CoreRef {
1395     using Decimal for Decimal.D256;
1396 
1397     /// @notice the oracle reference by the contract
1398     IOracle public override oracle;
1399 
1400     /// @notice OracleRef constructor
1401     /// @param _core Fei Core to reference
1402     /// @param _oracle oracle to reference
1403     constructor(address _core, address _oracle) public CoreRef(_core) {
1404         _setOracle(_oracle);
1405     }
1406 
1407     /// @notice sets the referenced oracle
1408     /// @param _oracle the new oracle to reference
1409     function setOracle(address _oracle) external override onlyGovernor {
1410         _setOracle(_oracle);
1411     }
1412 
1413     /// @notice invert a peg price
1414     /// @param price the peg price to invert
1415     /// @return the inverted peg as a Decimal
1416     /// @dev the inverted peg would be X per FEI
1417     function invert(Decimal.D256 memory price)
1418         public
1419         pure
1420         override
1421         returns (Decimal.D256 memory)
1422     {
1423         return Decimal.one().div(price);
1424     }
1425 
1426     /// @notice updates the referenced oracle
1427     /// @return true if the update is effective
1428     function updateOracle() public override returns (bool) {
1429         return oracle.update();
1430     }
1431 
1432     /// @notice the peg price of the referenced oracle
1433     /// @return the peg as a Decimal
1434     /// @dev the peg is defined as FEI per X with X being ETH, dollars, etc
1435     function peg() public view override returns (Decimal.D256 memory) {
1436         (Decimal.D256 memory _peg, bool valid) = oracle.read();
1437         require(valid, "OracleRef: oracle invalid");
1438         return _peg;
1439     }
1440 
1441     function _setOracle(address _oracle) internal {
1442         oracle = IOracle(_oracle);
1443         emit OracleUpdate(_oracle);
1444     }
1445 }
1446 
1447 ////// /home/brock/git_pkgs/fei-protocol-core/contracts/uniswap/lib/contracts/libraries/Babylonian.sol
1448 // SPDX-License-Identifier: GPL-3.0-or-later
1449 
1450 /* pragma solidity >=0.4.0; */
1451 
1452 // computes square roots using the babylonian method
1453 // https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method
1454 library Babylonian_3 {
1455     function sqrt(uint y) internal pure returns (uint z) {
1456         if (y > 3) {
1457             z = y;
1458             uint x = y / 2 + 1;
1459             while (x < z) {
1460                 z = x;
1461                 x = (y / x + x) / 2;
1462             }
1463         } else if (y != 0) {
1464             z = 1;
1465         }
1466         // else z = 0
1467     }
1468 }
1469 
1470 ////// ./contracts/utils/Roots.sol
1471 /* pragma solidity ^0.6.0; */
1472 
1473 /* import "/home/brock/git_pkgs/fei-protocol-core/contracts/uniswap/lib/contracts/libraries/Babylonian.sol"; */
1474 
1475 library Roots {
1476     // Newton's method https://en.wikipedia.org/wiki/Cube_root#Numerical_methods
1477     function cubeRoot(uint256 y) internal pure returns (uint256 z) {
1478         if (y > 7) {
1479             z = y;
1480             uint256 x = y / 3 + 1;
1481             while (x < z) {
1482                 z = x;
1483                 x = (y / (x * x) + (2 * x)) / 3;
1484             }
1485         } else if (y != 0) {
1486             z = 1;
1487         }
1488     }
1489 
1490     function sqrt(uint256 y) internal pure returns (uint256) {
1491         return Babylonian_3.sqrt(y);
1492     }
1493 }
1494 
1495 ////// /home/brock/git_pkgs/fei-protocol-core/contracts/openzeppelin/contracts/utils/SafeCast.sol
1496 // SPDX-License-Identifier: MIT
1497 
1498 /* pragma solidity >=0.6.0 <0.8.0; */
1499 
1500 
1501 /**
1502  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
1503  * checks.
1504  *
1505  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
1506  * easily result in undesired exploitation or bugs, since developers usually
1507  * assume that overflows raise errors. `SafeCast` restores this intuition by
1508  * reverting the transaction when such an operation overflows.
1509  *
1510  * Using this library instead of the unchecked operations eliminates an entire
1511  * class of bugs, so it's recommended to use it always.
1512  *
1513  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1514  * all math on `uint256` and `int256` and then downcasting.
1515  */
1516 library SafeCast_2 {
1517 
1518     /**
1519      * @dev Returns the downcasted uint128 from uint256, reverting on
1520      * overflow (when the input is greater than largest uint128).
1521      *
1522      * Counterpart to Solidity's `uint128` operator.
1523      *
1524      * Requirements:
1525      *
1526      * - input must fit into 128 bits
1527      */
1528     function toUint128(uint256 value) internal pure returns (uint128) {
1529         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
1530         return uint128(value);
1531     }
1532 
1533     /**
1534      * @dev Returns the downcasted uint64 from uint256, reverting on
1535      * overflow (when the input is greater than largest uint64).
1536      *
1537      * Counterpart to Solidity's `uint64` operator.
1538      *
1539      * Requirements:
1540      *
1541      * - input must fit into 64 bits
1542      */
1543     function toUint64(uint256 value) internal pure returns (uint64) {
1544         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
1545         return uint64(value);
1546     }
1547 
1548     /**
1549      * @dev Returns the downcasted uint32 from uint256, reverting on
1550      * overflow (when the input is greater than largest uint32).
1551      *
1552      * Counterpart to Solidity's `uint32` operator.
1553      *
1554      * Requirements:
1555      *
1556      * - input must fit into 32 bits
1557      */
1558     function toUint32(uint256 value) internal pure returns (uint32) {
1559         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
1560         return uint32(value);
1561     }
1562 
1563     /**
1564      * @dev Returns the downcasted uint16 from uint256, reverting on
1565      * overflow (when the input is greater than largest uint16).
1566      *
1567      * Counterpart to Solidity's `uint16` operator.
1568      *
1569      * Requirements:
1570      *
1571      * - input must fit into 16 bits
1572      */
1573     function toUint16(uint256 value) internal pure returns (uint16) {
1574         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
1575         return uint16(value);
1576     }
1577 
1578     /**
1579      * @dev Returns the downcasted uint8 from uint256, reverting on
1580      * overflow (when the input is greater than largest uint8).
1581      *
1582      * Counterpart to Solidity's `uint8` operator.
1583      *
1584      * Requirements:
1585      *
1586      * - input must fit into 8 bits.
1587      */
1588     function toUint8(uint256 value) internal pure returns (uint8) {
1589         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
1590         return uint8(value);
1591     }
1592 
1593     /**
1594      * @dev Converts a signed int256 into an unsigned uint256.
1595      *
1596      * Requirements:
1597      *
1598      * - input must be greater than or equal to 0.
1599      */
1600     function toUint256(int256 value) internal pure returns (uint256) {
1601         require(value >= 0, "SafeCast: value must be positive");
1602         return uint256(value);
1603     }
1604 
1605     /**
1606      * @dev Returns the downcasted int128 from int256, reverting on
1607      * overflow (when the input is less than smallest int128 or
1608      * greater than largest int128).
1609      *
1610      * Counterpart to Solidity's `int128` operator.
1611      *
1612      * Requirements:
1613      *
1614      * - input must fit into 128 bits
1615      *
1616      * _Available since v3.1._
1617      */
1618     function toInt128(int256 value) internal pure returns (int128) {
1619         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
1620         return int128(value);
1621     }
1622 
1623     /**
1624      * @dev Returns the downcasted int64 from int256, reverting on
1625      * overflow (when the input is less than smallest int64 or
1626      * greater than largest int64).
1627      *
1628      * Counterpart to Solidity's `int64` operator.
1629      *
1630      * Requirements:
1631      *
1632      * - input must fit into 64 bits
1633      *
1634      * _Available since v3.1._
1635      */
1636     function toInt64(int256 value) internal pure returns (int64) {
1637         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
1638         return int64(value);
1639     }
1640 
1641     /**
1642      * @dev Returns the downcasted int32 from int256, reverting on
1643      * overflow (when the input is less than smallest int32 or
1644      * greater than largest int32).
1645      *
1646      * Counterpart to Solidity's `int32` operator.
1647      *
1648      * Requirements:
1649      *
1650      * - input must fit into 32 bits
1651      *
1652      * _Available since v3.1._
1653      */
1654     function toInt32(int256 value) internal pure returns (int32) {
1655         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
1656         return int32(value);
1657     }
1658 
1659     /**
1660      * @dev Returns the downcasted int16 from int256, reverting on
1661      * overflow (when the input is less than smallest int16 or
1662      * greater than largest int16).
1663      *
1664      * Counterpart to Solidity's `int16` operator.
1665      *
1666      * Requirements:
1667      *
1668      * - input must fit into 16 bits
1669      *
1670      * _Available since v3.1._
1671      */
1672     function toInt16(int256 value) internal pure returns (int16) {
1673         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
1674         return int16(value);
1675     }
1676 
1677     /**
1678      * @dev Returns the downcasted int8 from int256, reverting on
1679      * overflow (when the input is less than smallest int8 or
1680      * greater than largest int8).
1681      *
1682      * Counterpart to Solidity's `int8` operator.
1683      *
1684      * Requirements:
1685      *
1686      * - input must fit into 8 bits.
1687      *
1688      * _Available since v3.1._
1689      */
1690     function toInt8(int256 value) internal pure returns (int8) {
1691         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
1692         return int8(value);
1693     }
1694 
1695     /**
1696      * @dev Converts an unsigned uint256 into a signed int256.
1697      *
1698      * Requirements:
1699      *
1700      * - input must be less than or equal to maxInt256.
1701      */
1702     function toInt256(uint256 value) internal pure returns (int256) {
1703         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
1704         return int256(value);
1705     }
1706 }
1707 
1708 ////// ./contracts/utils/Timed.sol
1709 /* pragma solidity ^0.6.0; */
1710 /* pragma experimental ABIEncoderV2; */
1711 
1712 /* import "/home/brock/git_pkgs/fei-protocol-core/contracts/openzeppelin/contracts/utils/SafeCast.sol"; */
1713 
1714 /// @title an abstract contract for timed events
1715 /// @author Fei Protocol
1716 abstract contract Timed {
1717     using SafeCast_2 for uint256;
1718 
1719     /// @notice the start timestamp of the timed period
1720     uint256 public startTime;
1721 
1722     /// @notice the duration of the timed period
1723     uint256 public duration;
1724 
1725     event DurationUpdate(uint256 _duration);
1726 
1727     event TimerReset(uint256 _startTime);
1728 
1729     constructor(uint256 _duration) public {
1730         _setDuration(_duration);
1731     }
1732 
1733     modifier duringTime() {
1734         require(isTimeStarted(), "Timed: time not started");
1735         require(!isTimeEnded(), "Timed: time ended");
1736         _;
1737     }
1738 
1739     modifier afterTime() {
1740         require(isTimeEnded(), "Timed: time not ended");
1741         _;
1742     }
1743 
1744     /// @notice return true if time period has ended
1745     function isTimeEnded() public view returns (bool) {
1746         return remainingTime() == 0;
1747     }
1748 
1749     /// @notice number of seconds remaining until time is up
1750     /// @return remaining
1751     function remainingTime() public view returns (uint256) {
1752         return duration - timeSinceStart(); // duration always >= timeSinceStart which is on [0,d]
1753     }
1754 
1755     /// @notice number of seconds since contract was initialized
1756     /// @return timestamp
1757     /// @dev will be less than or equal to duration
1758     function timeSinceStart() public view returns (uint256) {
1759         if (!isTimeStarted()) {
1760             return 0; // uninitialized
1761         }
1762         uint256 _duration = duration;
1763         // solhint-disable-next-line not-rely-on-time
1764         uint256 timePassed = block.timestamp - startTime; // block timestamp always >= startTime
1765         return timePassed > _duration ? _duration : timePassed;
1766     }
1767 
1768     function isTimeStarted() public view returns (bool) {
1769         return startTime != 0;
1770     }
1771 
1772     function _initTimed() internal {
1773         // solhint-disable-next-line not-rely-on-time
1774         startTime = block.timestamp;
1775 
1776         // solhint-disable-next-line not-rely-on-time
1777         emit TimerReset(block.timestamp);
1778     }
1779 
1780     function _setDuration(uint _duration) internal {
1781         duration = _duration;
1782         emit DurationUpdate(_duration);
1783     }
1784 }
1785 
1786 ////// /home/brock/git_pkgs/fei-protocol-core/contracts/openzeppelin/contracts/math/Math.sol
1787 // SPDX-License-Identifier: MIT
1788 
1789 /* pragma solidity >=0.6.0 <0.8.0; */
1790 
1791 /**
1792  * @dev Standard math utilities missing in the Solidity language.
1793  */
1794 library Math_4 {
1795     /**
1796      * @dev Returns the largest of two numbers.
1797      */
1798     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1799         return a >= b ? a : b;
1800     }
1801 
1802     /**
1803      * @dev Returns the smallest of two numbers.
1804      */
1805     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1806         return a < b ? a : b;
1807     }
1808 
1809     /**
1810      * @dev Returns the average of two numbers. The result is rounded towards
1811      * zero.
1812      */
1813     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1814         // (a + b) / 2 can overflow, so we distribute
1815         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
1816     }
1817 }
1818 
1819 ////// ./contracts/bondingcurve/BondingCurve.sol
1820 /* pragma solidity ^0.6.0; */
1821 /* pragma experimental ABIEncoderV2; */
1822 
1823 /* import "/home/brock/git_pkgs/fei-protocol-core/contracts/openzeppelin/contracts/math/Math.sol"; */
1824 /* import "./IBondingCurve.sol"; */
1825 /* import "../utils/Roots.sol"; */
1826 /* import "../refs/OracleRef.sol"; */
1827 /* import "../pcv/PCVSplitter.sol"; */
1828 /* import "../utils/Timed.sol"; */
1829 
1830 /// @title an abstract bonding curve for purchasing FEI
1831 /// @author Fei Protocol
1832 abstract contract BondingCurve is IBondingCurve, OracleRef, PCVSplitter, Timed {
1833     using Decimal for Decimal.D256;
1834     using Roots for uint256;
1835 
1836     /// @notice the Scale target at which bonding curve price fixes
1837     uint256 public override scale;
1838 
1839     /// @notice the total amount of FEI purchased on bonding curve. FEI_b from the whitepaper
1840     uint256 public override totalPurchased; // FEI_b for this curve
1841 
1842     /// @notice the buffer applied on top of the peg purchase price once at Scale
1843     uint256 public override buffer = 100;
1844     uint256 public constant BUFFER_GRANULARITY = 10_000;
1845 
1846     /// @notice amount of FEI paid for allocation when incentivized
1847     uint256 public override incentiveAmount;
1848 
1849     /// @notice constructor
1850     /// @param _scale the Scale target where peg fixes
1851     /// @param _core Fei Core to reference
1852     /// @param _pcvDeposits the PCV Deposits for the PCVSplitter
1853     /// @param _ratios the ratios for the PCVSplitter
1854     /// @param _oracle the UniswapOracle to reference
1855     /// @param _duration the duration between incentivizing allocations
1856     /// @param _incentive the amount rewarded to the caller of an allocation
1857     constructor(
1858         uint256 _scale,
1859         address _core,
1860         address[] memory _pcvDeposits,
1861         uint256[] memory _ratios,
1862         address _oracle,
1863         uint256 _duration,
1864         uint256 _incentive
1865     )
1866         public
1867         OracleRef(_core, _oracle)
1868         PCVSplitter(_pcvDeposits, _ratios)
1869         Timed(_duration)
1870     {
1871         _setScale(_scale);
1872         incentiveAmount = _incentive;
1873 
1874         _initTimed();
1875     }
1876 
1877     /// @notice sets the bonding curve Scale target
1878     function setScale(uint256 _scale) external override onlyGovernor {
1879         _setScale(_scale);
1880     }
1881 
1882     /// @notice sets the bonding curve price buffer
1883     function setBuffer(uint256 _buffer) external override onlyGovernor {
1884         require(
1885             _buffer < BUFFER_GRANULARITY,
1886             "BondingCurve: Buffer exceeds or matches granularity"
1887         );
1888         buffer = _buffer;
1889         emit BufferUpdate(_buffer);
1890     }
1891 
1892     /// @notice sets the allocate incentive amount
1893     function setIncentiveAmount(uint256 _incentiveAmount) external override onlyGovernor {
1894         incentiveAmount = _incentiveAmount;
1895         emit IncentiveAmountUpdate(_incentiveAmount);
1896     }
1897 
1898     /// @notice sets the allocate incentive frequency
1899     function setIncentiveFrequency(uint256 _frequency) external override onlyGovernor {
1900         _setDuration(_frequency);
1901     }
1902 
1903     /// @notice sets the allocation of incoming PCV
1904     function setAllocation(
1905         address[] calldata allocations,
1906         uint256[] calldata ratios
1907     ) external override onlyGovernor {
1908         _setAllocation(allocations, ratios);
1909     }
1910 
1911     /// @notice batch allocate held PCV
1912     function allocate() external override postGenesis whenNotPaused {
1913         require((!Address_2.isContract(msg.sender)) || msg.sender == core().genesisGroup(), "BondingCurve: Caller is a contract");
1914         uint256 amount = getTotalPCVHeld();
1915         require(amount != 0, "BondingCurve: No PCV held");
1916 
1917         _allocate(amount);
1918         _incentivize();
1919 
1920         emit Allocate(msg.sender, amount);
1921     }
1922 
1923     /// @notice a boolean signalling whether Scale has been reached
1924     function atScale() public view override returns (bool) {
1925         return totalPurchased >= scale;
1926     }
1927 
1928     /// @notice return current instantaneous bonding curve price
1929     /// @return price reported as FEI per X with X being the underlying asset
1930     /// @dev Can be innacurate if outdated, need to call `oracle().isOutdated()` to check
1931     function getCurrentPrice()
1932         public
1933         view
1934         override
1935         returns (Decimal.D256 memory)
1936     {
1937         if (atScale()) {
1938             return peg().mul(_getBufferMultiplier());
1939         }
1940         return peg().div(_getBondingCurvePriceMultiplier());
1941     }
1942 
1943     /// @notice return amount of FEI received after a bonding curve purchase
1944     /// @param amountIn the amount of underlying used to purchase
1945     /// @return amountOut the amount of FEI received
1946     /// @dev Can be innacurate if outdated, need to call `oracle().isOutdated()` to check
1947     function getAmountOut(uint256 amountIn)
1948         public
1949         view
1950         override
1951         returns (uint256 amountOut)
1952     {
1953         uint256 adjustedAmount = _getAdjustedAmount(amountIn);
1954         amountOut = _getBufferAdjustedAmount(adjustedAmount);
1955         if (atScale()) {
1956             return amountOut;
1957         }
1958         return Math_4.max(amountOut, _getBondingCurveAmountOut(adjustedAmount)); // Cap price at buffer adjusted
1959     }
1960 
1961     /// @notice return the average price of a transaction along bonding curve
1962     /// @param amountIn the amount of underlying used to purchase
1963     /// @return price reported as USD per FEI
1964     /// @dev Can be innacurate if outdated, need to call `oracle().isOutdated()` to check
1965     function getAverageUSDPrice(uint256 amountIn)
1966         public
1967         view
1968         override
1969         returns (Decimal.D256 memory)
1970     {
1971         uint256 adjustedAmount = _getAdjustedAmount(amountIn);
1972         uint256 amountOut = getAmountOut(amountIn);
1973         return Decimal.ratio(adjustedAmount, amountOut);
1974     }
1975 
1976     /// @notice the amount of PCV held in contract and ready to be allocated
1977     function getTotalPCVHeld() public view virtual override returns (uint256);
1978 
1979     /// @notice multiplies amount in by the peg to convert to FEI
1980     function _getAdjustedAmount(uint256 amountIn)
1981         internal
1982         view
1983         returns (uint256)
1984     {
1985         return peg().mul(amountIn).asUint256();
1986     }
1987 
1988     /// @notice mint FEI and send to buyer destination
1989     function _purchase(uint256 amountIn, address to)
1990         internal
1991         returns (uint256 amountOut)
1992     {
1993         updateOracle();
1994 
1995         amountOut = getAmountOut(amountIn);
1996         _incrementTotalPurchased(amountOut);
1997         fei().mint(to, amountOut);
1998 
1999         emit Purchase(to, amountIn, amountOut);
2000 
2001         return amountOut;
2002     }
2003 
2004     function _incrementTotalPurchased(uint256 amount) internal {
2005         totalPurchased = totalPurchased.add(amount);
2006     }
2007 
2008     function _setScale(uint256 _scale) internal {
2009         scale = _scale;
2010         emit ScaleUpdate(_scale);
2011     }
2012 
2013     /// @notice if window has passed, reward caller and reset window
2014     function _incentivize() internal virtual {
2015         if (isTimeEnded()) {
2016             _initTimed(); // reset window
2017             fei().mint(msg.sender, incentiveAmount);
2018         }
2019     }
2020 
2021     /// @notice the bonding curve price multiplier at the current totalPurchased relative to Scale
2022     function _getBondingCurvePriceMultiplier()
2023         internal
2024         view
2025         virtual
2026         returns (Decimal.D256 memory);
2027 
2028     /// @notice returns the integral of the bonding curve solved for the amount of tokens out for a certain amount of value in
2029     /// @param adjustedAmountIn this is the value in FEI of the underlying asset coming in
2030     function _getBondingCurveAmountOut(uint256 adjustedAmountIn)
2031         internal
2032         view
2033         virtual
2034         returns (uint256);
2035 
2036     /// @notice returns the buffer on the post-scale bonding curve price
2037     function _getBufferMultiplier() internal view returns (Decimal.D256 memory) {
2038         uint256 granularity = BUFFER_GRANULARITY;
2039         // uses granularity - buffer (i.e. 1-b) instead of 1+b because the peg is inverted
2040         return Decimal.ratio(granularity - buffer, granularity);
2041     }
2042 
2043     function _getBufferAdjustedAmount(uint256 amountIn)
2044         internal
2045         view
2046         returns (uint256)
2047     {
2048         return _getBufferMultiplier().mul(amountIn).asUint256();
2049     }
2050 }
2051 
2052 ////// ./contracts/pcv/IPCVDeposit.sol
2053 /* pragma solidity ^0.6.2; */
2054 
2055 /// @title a PCV Deposit interface
2056 /// @author Fei Protocol
2057 interface IPCVDeposit {
2058     // ----------- Events -----------
2059     event Deposit(address indexed _from, uint256 _amount);
2060 
2061     event Withdrawal(
2062         address indexed _caller,
2063         address indexed _to,
2064         uint256 _amount
2065     );
2066 
2067     // ----------- State changing api -----------
2068 
2069     function deposit(uint256 amount) external payable;
2070 
2071     // ----------- PCV Controller only state changing api -----------
2072 
2073     function withdraw(address to, uint256 amount) external;
2074 
2075     // ----------- Getters -----------
2076 
2077     function totalValue() external view returns (uint256);
2078 }
2079 
2080 ////// ./contracts/bondingcurve/EthBondingCurve.sol
2081 /* pragma solidity ^0.6.0; */
2082 /* pragma experimental ABIEncoderV2; */
2083 
2084 /* import "./BondingCurve.sol"; */
2085 /* import "../pcv/IPCVDeposit.sol"; */
2086 
2087 /// @title a square root growth bonding curve for purchasing FEI with ETH
2088 /// @author Fei Protocol
2089 contract EthBondingCurve is BondingCurve {
2090     // solhint-disable-next-line var-name-mixedcase
2091     uint256 internal immutable SHIFT; // k shift
2092 
2093     constructor(
2094         uint256 scale,
2095         address core,
2096         address[] memory pcvDeposits,
2097         uint256[] memory ratios,
2098         address oracle,
2099         uint256 duration,
2100         uint256 incentive
2101     )
2102         public
2103         BondingCurve(
2104             scale,
2105             core,
2106             pcvDeposits,
2107             ratios,
2108             oracle,
2109             duration,
2110             incentive
2111         )
2112     {
2113         SHIFT = scale / 3; // Enforces a .50c starting price per bonding curve formula
2114     }
2115 
2116     /// @notice purchase FEI for underlying tokens
2117     /// @param to address to receive FEI
2118     /// @param amountIn amount of underlying tokens input
2119     /// @return amountOut amount of FEI received
2120     function purchase(address to, uint256 amountIn)
2121         external
2122         payable
2123         override
2124         postGenesis
2125         whenNotPaused
2126         returns (uint256 amountOut)
2127     {
2128         require(
2129             msg.value == amountIn,
2130             "Bonding Curve: Sent value does not equal input"
2131         );
2132         return _purchase(amountIn, to);
2133     }
2134 
2135     function getTotalPCVHeld() public view override returns (uint256) {
2136         return address(this).balance;
2137     }
2138 
2139     // Represents the integral solved for upper bound of P(x) = ((k+X)/(k+S))^1/2 * O. Subtracting starting point C
2140     function _getBondingCurveAmountOut(uint256 adjustedAmountIn)
2141         internal
2142         view
2143         override
2144         returns (uint256 amountOut)
2145     {
2146         uint256 shiftTotal = _shift(totalPurchased); // k + C
2147         uint256 shiftTotalCubed = shiftTotal.mul(shiftTotal.mul(shiftTotal));
2148         uint256 radicand =
2149             (adjustedAmountIn.mul(3).mul(_shift(scale).sqrt()) / 2).add(
2150                 shiftTotalCubed.sqrt()
2151             );
2152         return (radicand.cubeRoot() ** 2).sub(shiftTotal); // result - (k + C)
2153     }
2154 
2155     // Bonding curve formula is sqrt(k+x)/sqrt(k+S)
2156     function _getBondingCurvePriceMultiplier()
2157         internal
2158         view
2159         override
2160         returns (Decimal.D256 memory)
2161     {
2162         return
2163             Decimal.ratio(_shift(totalPurchased).sqrt(), _shift(scale).sqrt());
2164     }
2165 
2166     function _allocateSingle(uint256 amount, address pcvDeposit)
2167         internal
2168         override
2169     {
2170         IPCVDeposit(pcvDeposit).deposit{value: amount}(amount);
2171     }
2172 
2173     function _shift(uint256 x) internal view returns (uint256) {
2174         return SHIFT.add(x);
2175     }
2176 }