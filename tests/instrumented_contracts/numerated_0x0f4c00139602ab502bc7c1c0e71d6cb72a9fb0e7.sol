1 //
2 //        __  __    __  ________  _______    ______   ________ 
3 //       /  |/  |  /  |/        |/       \  /      \ /        |
4 //   ____$$ |$$ |  $$ |$$$$$$$$/ $$$$$$$  |/$$$$$$  |$$$$$$$$/ 
5 //  /    $$ |$$ |__$$ |$$ |__    $$ |  $$ |$$ | _$$/ $$ |__    
6 // /$$$$$$$ |$$    $$ |$$    |   $$ |  $$ |$$ |/    |$$    |   
7 // $$ |  $$ |$$$$$$$$ |$$$$$/    $$ |  $$ |$$ |$$$$ |$$$$$/    
8 // $$ \__$$ |$$ |  $$ |$$ |_____ $$ |__$$ |$$ \__$$ |$$ |_____ 
9 // $$    $$ |$$ |  $$ |$$       |$$    $$/ $$    $$/ $$       |
10 //  $$$$$$$/ $$/   $$/ $$$$$$$$/ $$$$$$$/   $$$$$$/  $$$$$$$$/ 
11 //
12 // dHEDGE DAO - https://dhedge.org
13 //
14 // MIT License
15 // ===========
16 //
17 // Copyright (c) 2020 dHEDGE DAO
18 //
19 // Permission is hereby granted, free of charge, to any person obtaining a copy
20 // of this software and associated documentation files (the "Software"), to deal
21 // in the Software without restriction, including without limitation the rights
22 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
23 // copies of the Software, and to permit persons to whom the Software is
24 // furnished to do so, subject to the following conditions:
25 //
26 // The above copyright notice and this permission notice shall be included in all
27 // copies or substantial portions of the Software.
28 //
29 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
30 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
31 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
32 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
33 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
34 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
35 //
36 
37 
38 // File: contracts/ISynthetix.sol
39 
40 pragma solidity ^0.6.2;
41 
42 interface ISynthetix {
43     function exchange(
44         bytes32 sourceCurrencyKey,
45         uint256 sourceAmount,
46         bytes32 destinationCurrencyKey
47     ) external returns (uint256 amountReceived);
48 
49     function exchangeWithTracking(
50         bytes32 sourceCurrencyKey,
51         uint256 sourceAmount,
52         bytes32 destinationCurrencyKey,
53         address originator,
54         bytes32 trackingCode
55     ) external returns (uint256 amountReceived);
56 
57     function synths(bytes32 key)
58         external
59         view
60         returns (address synthTokenAddress);
61 
62     function settle(bytes32 currencyKey)
63         external
64         returns (
65             uint256 reclaimed,
66             uint256 refunded,
67             uint256 numEntriesSettled
68         );
69 }
70 
71 // File: contracts/IExchangeRates.sol
72 
73 pragma solidity ^0.6.2;
74 
75 interface IExchangeRates {
76     function effectiveValue(
77         bytes32 sourceCurrencyKey,
78         uint256 sourceAmount,
79         bytes32 destinationCurrencyKey
80     ) external view returns (uint256);
81 
82     function rateForCurrency(bytes32 currencyKey)
83         external
84         view
85         returns (uint256);
86 }
87 
88 // File: contracts/IAddressResolver.sol
89 
90 pragma solidity ^0.6.2;
91 
92 interface IAddressResolver {
93     function getAddress(bytes32 name) external view returns (address);
94 }
95 
96 // File: contracts/IExchanger.sol
97 
98 pragma solidity ^0.6.2;
99 
100 interface IExchanger {
101 
102     function settle(address from, bytes32 currencyKey)
103         external
104         returns (
105             uint reclaimed,
106             uint refunded,
107             uint numEntries
108         );
109 
110     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) external view returns (uint);
111 
112     function settlementOwing(address account, bytes32 currencyKey)
113         external
114         view
115         returns (
116             uint reclaimAmount,
117             uint rebateAmount,
118             uint numEntries
119         );
120 
121 }
122 
123 // File: contracts/ISynth.sol
124 
125 pragma solidity ^0.6.2;
126 
127 interface ISynth {
128     function proxy() external view returns (address);
129 
130     // Mutative functions
131     function transferAndSettle(address to, uint256 value)
132         external
133         returns (bool);
134 
135     function transferFromAndSettle(
136         address from,
137         address to,
138         uint256 value
139     ) external returns (bool);
140 }
141 
142 // File: contracts/ISystemStatus.sol
143 
144 pragma solidity ^0.6.2;
145 
146 interface ISystemStatus {
147     struct Status {
148         bool canSuspend;
149         bool canResume;
150     }
151 
152     struct Suspension {
153         bool suspended;
154         // reason is an integer code,
155         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
156         uint248 reason;
157     }
158 
159     // Views
160 //    function getSynthExchangeSuspensions(bytes32[] calldata synths)
161 //        external
162 //        view
163 //        returns (bool[] memory exchangeSuspensions, uint256[] memory reasons);
164 
165     function synthExchangeSuspension(bytes32 currencyKey)
166         external
167         view
168         returns (bool suspended, uint248 reason);
169 
170 }
171 
172 // File: @openzeppelin/contracts-ethereum-package/contracts/Initializable.sol
173 
174 pragma solidity >=0.4.24 <0.7.0;
175 
176 
177 /**
178  * @title Initializable
179  *
180  * @dev Helper contract to support initializer functions. To use it, replace
181  * the constructor with a function that has the `initializer` modifier.
182  * WARNING: Unlike constructors, initializer functions must be manually
183  * invoked. This applies both to deploying an Initializable contract, as well
184  * as extending an Initializable contract via inheritance.
185  * WARNING: When used with inheritance, manual care must be taken to not invoke
186  * a parent initializer twice, or ensure that all initializers are idempotent,
187  * because this is not dealt with automatically as with constructors.
188  */
189 contract Initializable {
190 
191   /**
192    * @dev Indicates that the contract has been initialized.
193    */
194   bool private initialized;
195 
196   /**
197    * @dev Indicates that the contract is in the process of being initialized.
198    */
199   bool private initializing;
200 
201   /**
202    * @dev Modifier to use in the initializer function of a contract.
203    */
204   modifier initializer() {
205     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
206 
207     bool isTopLevelCall = !initializing;
208     if (isTopLevelCall) {
209       initializing = true;
210       initialized = true;
211     }
212 
213     _;
214 
215     if (isTopLevelCall) {
216       initializing = false;
217     }
218   }
219 
220   /// @dev Returns true if and only if the function is running in the constructor
221   function isConstructor() private view returns (bool) {
222     // extcodesize checks the size of the code stored in an address, and
223     // address returns the current address. Since the code is still not
224     // deployed when running a constructor, any checks on its code size will
225     // yield zero, making it an effective way to detect if a contract is
226     // under construction or not.
227     address self = address(this);
228     uint256 cs;
229     assembly { cs := extcodesize(self) }
230     return cs == 0;
231   }
232 
233   // Reserved storage space to allow for layout changes in the future.
234   uint256[50] private ______gap;
235 }
236 
237 // File: @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol
238 
239 pragma solidity ^0.6.0;
240 
241 /**
242  * @dev Wrappers over Solidity's arithmetic operations with added overflow
243  * checks.
244  *
245  * Arithmetic operations in Solidity wrap on overflow. This can easily result
246  * in bugs, because programmers usually assume that an overflow raises an
247  * error, which is the standard behavior in high level programming languages.
248  * `SafeMath` restores this intuition by reverting the transaction when an
249  * operation overflows.
250  *
251  * Using this library instead of the unchecked operations eliminates an entire
252  * class of bugs, so it's recommended to use it always.
253  */
254 library SafeMath {
255     /**
256      * @dev Returns the addition of two unsigned integers, reverting on
257      * overflow.
258      *
259      * Counterpart to Solidity's `+` operator.
260      *
261      * Requirements:
262      * - Addition cannot overflow.
263      */
264     function add(uint256 a, uint256 b) internal pure returns (uint256) {
265         uint256 c = a + b;
266         require(c >= a, "SafeMath: addition overflow");
267 
268         return c;
269     }
270 
271     /**
272      * @dev Returns the subtraction of two unsigned integers, reverting on
273      * overflow (when the result is negative).
274      *
275      * Counterpart to Solidity's `-` operator.
276      *
277      * Requirements:
278      * - Subtraction cannot overflow.
279      */
280     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
281         return sub(a, b, "SafeMath: subtraction overflow");
282     }
283 
284     /**
285      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
286      * overflow (when the result is negative).
287      *
288      * Counterpart to Solidity's `-` operator.
289      *
290      * Requirements:
291      * - Subtraction cannot overflow.
292      */
293     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         require(b <= a, errorMessage);
295         uint256 c = a - b;
296 
297         return c;
298     }
299 
300     /**
301      * @dev Returns the multiplication of two unsigned integers, reverting on
302      * overflow.
303      *
304      * Counterpart to Solidity's `*` operator.
305      *
306      * Requirements:
307      * - Multiplication cannot overflow.
308      */
309     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
310         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
311         // benefit is lost if 'b' is also tested.
312         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
313         if (a == 0) {
314             return 0;
315         }
316 
317         uint256 c = a * b;
318         require(c / a == b, "SafeMath: multiplication overflow");
319 
320         return c;
321     }
322 
323     /**
324      * @dev Returns the integer division of two unsigned integers. Reverts on
325      * division by zero. The result is rounded towards zero.
326      *
327      * Counterpart to Solidity's `/` operator. Note: this function uses a
328      * `revert` opcode (which leaves remaining gas untouched) while Solidity
329      * uses an invalid opcode to revert (consuming all remaining gas).
330      *
331      * Requirements:
332      * - The divisor cannot be zero.
333      */
334     function div(uint256 a, uint256 b) internal pure returns (uint256) {
335         return div(a, b, "SafeMath: division by zero");
336     }
337 
338     /**
339      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
340      * division by zero. The result is rounded towards zero.
341      *
342      * Counterpart to Solidity's `/` operator. Note: this function uses a
343      * `revert` opcode (which leaves remaining gas untouched) while Solidity
344      * uses an invalid opcode to revert (consuming all remaining gas).
345      *
346      * Requirements:
347      * - The divisor cannot be zero.
348      */
349     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
350         // Solidity only automatically asserts when dividing by 0
351         require(b > 0, errorMessage);
352         uint256 c = a / b;
353         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
354 
355         return c;
356     }
357 
358     /**
359      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
360      * Reverts when dividing by zero.
361      *
362      * Counterpart to Solidity's `%` operator. This function uses a `revert`
363      * opcode (which leaves remaining gas untouched) while Solidity uses an
364      * invalid opcode to revert (consuming all remaining gas).
365      *
366      * Requirements:
367      * - The divisor cannot be zero.
368      */
369     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
370         return mod(a, b, "SafeMath: modulo by zero");
371     }
372 
373     /**
374      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
375      * Reverts with custom message when dividing by zero.
376      *
377      * Counterpart to Solidity's `%` operator. This function uses a `revert`
378      * opcode (which leaves remaining gas untouched) while Solidity uses an
379      * invalid opcode to revert (consuming all remaining gas).
380      *
381      * Requirements:
382      * - The divisor cannot be zero.
383      */
384     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
385         require(b != 0, errorMessage);
386         return a % b;
387     }
388 }
389 
390 // File: contracts/Managed.sol
391 
392 //
393 //        __  __    __  ________  _______    ______   ________ 
394 //       /  |/  |  /  |/        |/       \  /      \ /        |
395 //   ____$$ |$$ |  $$ |$$$$$$$$/ $$$$$$$  |/$$$$$$  |$$$$$$$$/ 
396 //  /    $$ |$$ |__$$ |$$ |__    $$ |  $$ |$$ | _$$/ $$ |__    
397 // /$$$$$$$ |$$    $$ |$$    |   $$ |  $$ |$$ |/    |$$    |   
398 // $$ |  $$ |$$$$$$$$ |$$$$$/    $$ |  $$ |$$ |$$$$ |$$$$$/    
399 // $$ \__$$ |$$ |  $$ |$$ |_____ $$ |__$$ |$$ \__$$ |$$ |_____ 
400 // $$    $$ |$$ |  $$ |$$       |$$    $$/ $$    $$/ $$       |
401 //  $$$$$$$/ $$/   $$/ $$$$$$$$/ $$$$$$$/   $$$$$$/  $$$$$$$$/ 
402 //
403 // dHEDGE DAO - https://dhedge.org
404 //
405 // MIT License
406 // ===========
407 //
408 // Copyright (c) 2020 dHEDGE DAO
409 //
410 // Permission is hereby granted, free of charge, to any person obtaining a copy
411 // of this software and associated documentation files (the "Software"), to deal
412 // in the Software without restriction, including without limitation the rights
413 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
414 // copies of the Software, and to permit persons to whom the Software is
415 // furnished to do so, subject to the following conditions:
416 //
417 // The above copyright notice and this permission notice shall be included in all
418 // copies or substantial portions of the Software.
419 //
420 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
421 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
422 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
423 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
424 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
425 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
426 //
427 
428 pragma solidity ^0.6.0;
429 
430 
431 
432 
433 contract Managed is Initializable {
434     using SafeMath for uint256;
435 
436     event ManagerUpdated(address newManager, string newManagerName);
437 
438     address private _manager;
439     string private _managerName;
440 
441     address[] private _memberList;
442     mapping(address => uint256) private _memberPosition;
443 
444     address private _trader;
445 
446     function initialize(address manager, string memory managerName)
447         internal
448         initializer
449     {
450         _manager = manager;
451         _managerName = managerName;
452     }
453 
454     modifier onlyManager() {
455         require(msg.sender == _manager, "only manager");
456         _;
457     }
458 
459     modifier onlyManagerOrTrader() {
460         require(msg.sender == _manager || msg.sender == _trader, "only manager or trader");
461         _;
462     }
463 
464     function managerName() public view returns (string memory) {
465         return _managerName;
466     }
467 
468     function manager() public view returns (address) {
469         return _manager;
470     }
471 
472     function isMemberAllowed(address member) public view returns (bool) {
473         return _memberPosition[member] != 0;
474     }
475 
476     function getMembers() public view returns (address[] memory) {
477         return _memberList;
478     }
479 
480     function changeManager(address newManager, string memory newManagerName)
481         public
482         onlyManager
483     {
484         _manager = newManager;
485         _managerName = newManagerName;
486         emit ManagerUpdated(newManager, newManagerName);
487     }
488 
489     function addMembers(address[] memory members) public onlyManager {
490         for (uint256 i = 0; i < members.length; i++) {
491             if (isMemberAllowed(members[i]))
492                 continue;
493 
494             _addMember(members[i]);
495         }
496     }
497 
498     function removeMembers(address[] memory members) public onlyManager {
499         for (uint256 i = 0; i < members.length; i++) {
500             if (!isMemberAllowed(members[i]))
501                 continue;
502 
503             _removeMember(members[i]);
504         }
505     }
506 
507     function addMember(address member) public onlyManager {
508         if (isMemberAllowed(member))
509             return;
510 
511         _addMember(member);
512     }
513 
514     function removeMember(address member) public onlyManager {
515         if (!isMemberAllowed(member))
516             return;
517 
518         _removeMember(member);
519     }
520 
521     function trader() public view returns (address) {
522         return _trader;
523     }
524 
525     function setTrader(address newTrader) public onlyManager {
526         _trader = newTrader;
527     }
528 
529     function removeTrader() public onlyManager {
530         _trader = address(0);
531     }
532 
533     function numberOfMembers() public view returns (uint256) {
534         return _memberList.length;
535     }
536 
537     function _addMember(address member) internal {
538         _memberList.push(member);
539         _memberPosition[member] = _memberList.length;
540     }
541 
542     function _removeMember(address member) internal {
543         uint256 length = _memberList.length;
544         uint256 index = _memberPosition[member].sub(1);
545 
546         address lastMember = _memberList[length.sub(1)];
547 
548         _memberList[index] = lastMember;
549         _memberPosition[lastMember] = index.add(1);
550         _memberPosition[member] = 0;
551 
552         _memberList.pop();
553     }
554 
555     uint256[49] private __gap;
556 }
557 
558 // File: contracts/IHasDaoInfo.sol
559 
560 //
561 //        __  __    __  ________  _______    ______   ________ 
562 //       /  |/  |  /  |/        |/       \  /      \ /        |
563 //   ____$$ |$$ |  $$ |$$$$$$$$/ $$$$$$$  |/$$$$$$  |$$$$$$$$/ 
564 //  /    $$ |$$ |__$$ |$$ |__    $$ |  $$ |$$ | _$$/ $$ |__    
565 // /$$$$$$$ |$$    $$ |$$    |   $$ |  $$ |$$ |/    |$$    |   
566 // $$ |  $$ |$$$$$$$$ |$$$$$/    $$ |  $$ |$$ |$$$$ |$$$$$/    
567 // $$ \__$$ |$$ |  $$ |$$ |_____ $$ |__$$ |$$ \__$$ |$$ |_____ 
568 // $$    $$ |$$ |  $$ |$$       |$$    $$/ $$    $$/ $$       |
569 //  $$$$$$$/ $$/   $$/ $$$$$$$$/ $$$$$$$/   $$$$$$/  $$$$$$$$/ 
570 //
571 // dHEDGE DAO - https://dhedge.org
572 //
573 // MIT License
574 // ===========
575 //
576 // Copyright (c) 2020 dHEDGE DAO
577 //
578 // Permission is hereby granted, free of charge, to any person obtaining a copy
579 // of this software and associated documentation files (the "Software"), to deal
580 // in the Software without restriction, including without limitation the rights
581 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
582 // copies of the Software, and to permit persons to whom the Software is
583 // furnished to do so, subject to the following conditions:
584 //
585 // The above copyright notice and this permission notice shall be included in all
586 // copies or substantial portions of the Software.
587 //
588 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
589 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
590 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
591 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
592 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
593 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
594 //
595 
596 
597 pragma solidity ^0.6.2;
598 
599 interface IHasDaoInfo {
600     function getDaoFee() external view returns (uint256, uint256);
601 
602     function getDaoAddress() external view returns (address);
603 
604     function getAddressResolver() external view returns (IAddressResolver);
605 }
606 
607 // File: contracts/IHasProtocolDaoInfo.sol
608 
609 //
610 //        __  __    __  ________  _______    ______   ________ 
611 //       /  |/  |  /  |/        |/       \  /      \ /        |
612 //   ____$$ |$$ |  $$ |$$$$$$$$/ $$$$$$$  |/$$$$$$  |$$$$$$$$/ 
613 //  /    $$ |$$ |__$$ |$$ |__    $$ |  $$ |$$ | _$$/ $$ |__    
614 // /$$$$$$$ |$$    $$ |$$    |   $$ |  $$ |$$ |/    |$$    |   
615 // $$ |  $$ |$$$$$$$$ |$$$$$/    $$ |  $$ |$$ |$$$$ |$$$$$/    
616 // $$ \__$$ |$$ |  $$ |$$ |_____ $$ |__$$ |$$ \__$$ |$$ |_____ 
617 // $$    $$ |$$ |  $$ |$$       |$$    $$/ $$    $$/ $$       |
618 //  $$$$$$$/ $$/   $$/ $$$$$$$$/ $$$$$$$/   $$$$$$/  $$$$$$$$/ 
619 //
620 // dHEDGE DAO - https://dhedge.org
621 //
622 // MIT License
623 // ===========
624 //
625 // Copyright (c) 2020 dHEDGE DAO
626 //
627 // Permission is hereby granted, free of charge, to any person obtaining a copy
628 // of this software and associated documentation files (the "Software"), to deal
629 // in the Software without restriction, including without limitation the rights
630 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
631 // copies of the Software, and to permit persons to whom the Software is
632 // furnished to do so, subject to the following conditions:
633 //
634 // The above copyright notice and this permission notice shall be included in all
635 // copies or substantial portions of the Software.
636 //
637 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
638 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
639 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
640 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
641 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
642 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
643 //
644 
645 
646 pragma solidity ^0.6.2;
647 
648 interface IHasProtocolDaoInfo {
649     function owner() external view returns (address);
650 }
651 
652 // File: contracts/IHasFeeInfo.sol
653 
654 //
655 //        __  __    __  ________  _______    ______   ________ 
656 //       /  |/  |  /  |/        |/       \  /      \ /        |
657 //   ____$$ |$$ |  $$ |$$$$$$$$/ $$$$$$$  |/$$$$$$  |$$$$$$$$/ 
658 //  /    $$ |$$ |__$$ |$$ |__    $$ |  $$ |$$ | _$$/ $$ |__    
659 // /$$$$$$$ |$$    $$ |$$    |   $$ |  $$ |$$ |/    |$$    |   
660 // $$ |  $$ |$$$$$$$$ |$$$$$/    $$ |  $$ |$$ |$$$$ |$$$$$/    
661 // $$ \__$$ |$$ |  $$ |$$ |_____ $$ |__$$ |$$ \__$$ |$$ |_____ 
662 // $$    $$ |$$ |  $$ |$$       |$$    $$/ $$    $$/ $$       |
663 //  $$$$$$$/ $$/   $$/ $$$$$$$$/ $$$$$$$/   $$$$$$/  $$$$$$$$/ 
664 //
665 // dHEDGE DAO - https://dhedge.org
666 //
667 // MIT License
668 // ===========
669 //
670 // Copyright (c) 2020 dHEDGE DAO
671 //
672 // Permission is hereby granted, free of charge, to any person obtaining a copy
673 // of this software and associated documentation files (the "Software"), to deal
674 // in the Software without restriction, including without limitation the rights
675 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
676 // copies of the Software, and to permit persons to whom the Software is
677 // furnished to do so, subject to the following conditions:
678 //
679 // The above copyright notice and this permission notice shall be included in all
680 // copies or substantial portions of the Software.
681 //
682 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
683 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
684 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
685 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
686 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
687 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
688 //
689 
690 pragma solidity ^0.6.2;
691 
692 interface IHasFeeInfo {
693     // Manager fee
694     function getPoolManagerFee(address pool) external view returns (uint256, uint256);
695     function setPoolManagerFeeNumerator(address pool, uint256 numerator) external;
696 
697     function getMaximumManagerFeeNumeratorChange() external view returns (uint256);
698     function getManagerFeeNumeratorChangeDelay() external view returns (uint256);
699    
700     // Exit fee
701     function getExitFee() external view returns (uint256, uint256);
702     function getExitFeeCooldown() external view returns (uint256);
703 
704     // Synthetix tracking
705     function getTrackingCode() external view returns (bytes32);
706 }
707 
708 // File: contracts/IHasAssetInfo.sol
709 
710 //
711 //        __  __    __  ________  _______    ______   ________ 
712 //       /  |/  |  /  |/        |/       \  /      \ /        |
713 //   ____$$ |$$ |  $$ |$$$$$$$$/ $$$$$$$  |/$$$$$$  |$$$$$$$$/ 
714 //  /    $$ |$$ |__$$ |$$ |__    $$ |  $$ |$$ | _$$/ $$ |__    
715 // /$$$$$$$ |$$    $$ |$$    |   $$ |  $$ |$$ |/    |$$    |   
716 // $$ |  $$ |$$$$$$$$ |$$$$$/    $$ |  $$ |$$ |$$$$ |$$$$$/    
717 // $$ \__$$ |$$ |  $$ |$$ |_____ $$ |__$$ |$$ \__$$ |$$ |_____ 
718 // $$    $$ |$$ |  $$ |$$       |$$    $$/ $$    $$/ $$       |
719 //  $$$$$$$/ $$/   $$/ $$$$$$$$/ $$$$$$$/   $$$$$$/  $$$$$$$$/ 
720 //
721 // dHEDGE DAO - https://dhedge.org
722 //
723 // MIT License
724 // ===========
725 //
726 // Copyright (c) 2020 dHEDGE DAO
727 //
728 // Permission is hereby granted, free of charge, to any person obtaining a copy
729 // of this software and associated documentation files (the "Software"), to deal
730 // in the Software without restriction, including without limitation the rights
731 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
732 // copies of the Software, and to permit persons to whom the Software is
733 // furnished to do so, subject to the following conditions:
734 //
735 // The above copyright notice and this permission notice shall be included in all
736 // copies or substantial portions of the Software.
737 //
738 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
739 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
740 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
741 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
742 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
743 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
744 //
745 
746 pragma solidity ^0.6.2;
747 
748 interface IHasAssetInfo {
749     function getMaximumSupportedAssetCount() external view returns (uint256);
750 }
751 
752 // File: contracts/IReceivesUpgrade.sol
753 
754 //
755 //        __  __    __  ________  _______    ______   ________ 
756 //       /  |/  |  /  |/        |/       \  /      \ /        |
757 //   ____$$ |$$ |  $$ |$$$$$$$$/ $$$$$$$  |/$$$$$$  |$$$$$$$$/ 
758 //  /    $$ |$$ |__$$ |$$ |__    $$ |  $$ |$$ | _$$/ $$ |__    
759 // /$$$$$$$ |$$    $$ |$$    |   $$ |  $$ |$$ |/    |$$    |   
760 // $$ |  $$ |$$$$$$$$ |$$$$$/    $$ |  $$ |$$ |$$$$ |$$$$$/    
761 // $$ \__$$ |$$ |  $$ |$$ |_____ $$ |__$$ |$$ \__$$ |$$ |_____ 
762 // $$    $$ |$$ |  $$ |$$       |$$    $$/ $$    $$/ $$       |
763 //  $$$$$$$/ $$/   $$/ $$$$$$$$/ $$$$$$$/   $$$$$$/  $$$$$$$$/ 
764 //
765 // dHEDGE DAO - https://dhedge.org
766 //
767 // MIT License
768 // ===========
769 //
770 // Copyright (c) 2020 dHEDGE DAO
771 //
772 // Permission is hereby granted, free of charge, to any person obtaining a copy
773 // of this software and associated documentation files (the "Software"), to deal
774 // in the Software without restriction, including without limitation the rights
775 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
776 // copies of the Software, and to permit persons to whom the Software is
777 // furnished to do so, subject to the following conditions:
778 //
779 // The above copyright notice and this permission notice shall be included in all
780 // copies or substantial portions of the Software.
781 //
782 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
783 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
784 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
785 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
786 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
787 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
788 //
789 
790 pragma solidity ^0.6.2;
791 
792 interface IReceivesUpgrade {
793     function receiveUpgrade(uint256 targetVersion) external;
794 }
795 
796 // File: contracts/IHasDhptSwapInfo.sol
797 
798 //
799 //        __  __    __  ________  _______    ______   ________ 
800 //       /  |/  |  /  |/        |/       \  /      \ /        |
801 //   ____$$ |$$ |  $$ |$$$$$$$$/ $$$$$$$  |/$$$$$$  |$$$$$$$$/ 
802 //  /    $$ |$$ |__$$ |$$ |__    $$ |  $$ |$$ | _$$/ $$ |__    
803 // /$$$$$$$ |$$    $$ |$$    |   $$ |  $$ |$$ |/    |$$    |   
804 // $$ |  $$ |$$$$$$$$ |$$$$$/    $$ |  $$ |$$ |$$$$ |$$$$$/    
805 // $$ \__$$ |$$ |  $$ |$$ |_____ $$ |__$$ |$$ \__$$ |$$ |_____ 
806 // $$    $$ |$$ |  $$ |$$       |$$    $$/ $$    $$/ $$       |
807 //  $$$$$$$/ $$/   $$/ $$$$$$$$/ $$$$$$$/   $$$$$$/  $$$$$$$$/ 
808 //
809 // dHEDGE DAO - https://dhedge.org
810 //
811 // MIT License
812 // ===========
813 //
814 // Copyright (c) 2020 dHEDGE DAO
815 //
816 // Permission is hereby granted, free of charge, to any person obtaining a copy
817 // of this software and associated documentation files (the "Software"), to deal
818 // in the Software without restriction, including without limitation the rights
819 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
820 // copies of the Software, and to permit persons to whom the Software is
821 // furnished to do so, subject to the following conditions:
822 //
823 // The above copyright notice and this permission notice shall be included in all
824 // copies or substantial portions of the Software.
825 //
826 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
827 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
828 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
829 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
830 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
831 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
832 //
833 
834 pragma solidity ^0.6.2;
835 
836 interface IHasDhptSwapInfo {
837     // DHPT Swap Address
838     function getDhptSwapAddress() external view returns (address);
839 }
840 
841 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol
842 
843 pragma solidity ^0.6.0;
844 
845 /**
846  * @dev Interface of the ERC20 standard as defined in the EIP.
847  */
848 interface IERC20 {
849     /**
850      * @dev Returns the amount of tokens in existence.
851      */
852     function totalSupply() external view returns (uint256);
853 
854     /**
855      * @dev Returns the amount of tokens owned by `account`.
856      */
857     function balanceOf(address account) external view returns (uint256);
858 
859     /**
860      * @dev Moves `amount` tokens from the caller's account to `recipient`.
861      *
862      * Returns a boolean value indicating whether the operation succeeded.
863      *
864      * Emits a {Transfer} event.
865      */
866     function transfer(address recipient, uint256 amount) external returns (bool);
867 
868     /**
869      * @dev Returns the remaining number of tokens that `spender` will be
870      * allowed to spend on behalf of `owner` through {transferFrom}. This is
871      * zero by default.
872      *
873      * This value changes when {approve} or {transferFrom} are called.
874      */
875     function allowance(address owner, address spender) external view returns (uint256);
876 
877     /**
878      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
879      *
880      * Returns a boolean value indicating whether the operation succeeded.
881      *
882      * IMPORTANT: Beware that changing an allowance with this method brings the risk
883      * that someone may use both the old and the new allowance by unfortunate
884      * transaction ordering. One possible solution to mitigate this race
885      * condition is to first reduce the spender's allowance to 0 and set the
886      * desired value afterwards:
887      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
888      *
889      * Emits an {Approval} event.
890      */
891     function approve(address spender, uint256 amount) external returns (bool);
892 
893     /**
894      * @dev Moves `amount` tokens from `sender` to `recipient` using the
895      * allowance mechanism. `amount` is then deducted from the caller's
896      * allowance.
897      *
898      * Returns a boolean value indicating whether the operation succeeded.
899      *
900      * Emits a {Transfer} event.
901      */
902     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
903 
904     /**
905      * @dev Emitted when `value` tokens are moved from one account (`from`) to
906      * another (`to`).
907      *
908      * Note that `value` may be zero.
909      */
910     event Transfer(address indexed from, address indexed to, uint256 value);
911 
912     /**
913      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
914      * a call to {approve}. `value` is the new allowance.
915      */
916     event Approval(address indexed owner, address indexed spender, uint256 value);
917 }
918 
919 // File: @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol
920 
921 pragma solidity ^0.6.0;
922 
923 
924 /*
925  * @dev Provides information about the current execution context, including the
926  * sender of the transaction and its data. While these are generally available
927  * via msg.sender and msg.data, they should not be accessed in such a direct
928  * manner, since when dealing with GSN meta-transactions the account sending and
929  * paying for execution may not be the actual sender (as far as an application
930  * is concerned).
931  *
932  * This contract is only required for intermediate, library-like contracts.
933  */
934 contract ContextUpgradeSafe is Initializable {
935     // Empty internal constructor, to prevent people from mistakenly deploying
936     // an instance of this contract, which should be used via inheritance.
937 
938     function __Context_init() internal initializer {
939         __Context_init_unchained();
940     }
941 
942     function __Context_init_unchained() internal initializer {
943 
944 
945     }
946 
947 
948     function _msgSender() internal view virtual returns (address payable) {
949         return msg.sender;
950     }
951 
952     function _msgData() internal view virtual returns (bytes memory) {
953         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
954         return msg.data;
955     }
956 
957     uint256[50] private __gap;
958 }
959 
960 // File: @openzeppelin/contracts-ethereum-package/contracts/utils/Address.sol
961 
962 pragma solidity ^0.6.2;
963 
964 /**
965  * @dev Collection of functions related to the address type
966  */
967 library Address {
968     /**
969      * @dev Returns true if `account` is a contract.
970      *
971      * [IMPORTANT]
972      * ====
973      * It is unsafe to assume that an address for which this function returns
974      * false is an externally-owned account (EOA) and not a contract.
975      *
976      * Among others, `isContract` will return false for the following
977      * types of addresses:
978      *
979      *  - an externally-owned account
980      *  - a contract in construction
981      *  - an address where a contract will be created
982      *  - an address where a contract lived, but was destroyed
983      * ====
984      */
985     function isContract(address account) internal view returns (bool) {
986         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
987         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
988         // for accounts without code, i.e. `keccak256('')`
989         bytes32 codehash;
990         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
991         // solhint-disable-next-line no-inline-assembly
992         assembly { codehash := extcodehash(account) }
993         return (codehash != accountHash && codehash != 0x0);
994     }
995 
996     /**
997      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
998      * `recipient`, forwarding all available gas and reverting on errors.
999      *
1000      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1001      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1002      * imposed by `transfer`, making them unable to receive funds via
1003      * `transfer`. {sendValue} removes this limitation.
1004      *
1005      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1006      *
1007      * IMPORTANT: because control is transferred to `recipient`, care must be
1008      * taken to not create reentrancy vulnerabilities. Consider using
1009      * {ReentrancyGuard} or the
1010      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1011      */
1012     function sendValue(address payable recipient, uint256 amount) internal {
1013         require(address(this).balance >= amount, "Address: insufficient balance");
1014 
1015         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1016         (bool success, ) = recipient.call{ value: amount }("");
1017         require(success, "Address: unable to send value, recipient may have reverted");
1018     }
1019 }
1020 
1021 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20.sol
1022 
1023 pragma solidity ^0.6.0;
1024 
1025 
1026 
1027 
1028 
1029 
1030 /**
1031  * @dev Implementation of the {IERC20} interface.
1032  *
1033  * This implementation is agnostic to the way tokens are created. This means
1034  * that a supply mechanism has to be added in a derived contract using {_mint}.
1035  * For a generic mechanism see {ERC20MinterPauser}.
1036  *
1037  * TIP: For a detailed writeup see our guide
1038  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1039  * to implement supply mechanisms].
1040  *
1041  * We have followed general OpenZeppelin guidelines: functions revert instead
1042  * of returning `false` on failure. This behavior is nonetheless conventional
1043  * and does not conflict with the expectations of ERC20 applications.
1044  *
1045  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1046  * This allows applications to reconstruct the allowance for all accounts just
1047  * by listening to said events. Other implementations of the EIP may not emit
1048  * these events, as it isn't required by the specification.
1049  *
1050  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1051  * functions have been added to mitigate the well-known issues around setting
1052  * allowances. See {IERC20-approve}.
1053  */
1054 contract ERC20UpgradeSafe is Initializable, ContextUpgradeSafe, IERC20 {
1055     using SafeMath for uint256;
1056     using Address for address;
1057 
1058     mapping (address => uint256) private _balances;
1059 
1060     mapping (address => mapping (address => uint256)) private _allowances;
1061 
1062     uint256 private _totalSupply;
1063 
1064     string private _name;
1065     string private _symbol;
1066     uint8 private _decimals;
1067 
1068     /**
1069      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1070      * a default value of 18.
1071      *
1072      * To select a different value for {decimals}, use {_setupDecimals}.
1073      *
1074      * All three of these values are immutable: they can only be set once during
1075      * construction.
1076      */
1077 
1078     function __ERC20_init(string memory name, string memory symbol) internal initializer {
1079         __Context_init_unchained();
1080         __ERC20_init_unchained(name, symbol);
1081     }
1082 
1083     function __ERC20_init_unchained(string memory name, string memory symbol) internal initializer {
1084 
1085 
1086         _name = name;
1087         _symbol = symbol;
1088         _decimals = 18;
1089 
1090     }
1091 
1092 
1093     /**
1094      * @dev Returns the name of the token.
1095      */
1096     function name() public view returns (string memory) {
1097         return _name;
1098     }
1099 
1100     /**
1101      * @dev Returns the symbol of the token, usually a shorter version of the
1102      * name.
1103      */
1104     function symbol() public view returns (string memory) {
1105         return _symbol;
1106     }
1107 
1108     /**
1109      * @dev Returns the number of decimals used to get its user representation.
1110      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1111      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1112      *
1113      * Tokens usually opt for a value of 18, imitating the relationship between
1114      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1115      * called.
1116      *
1117      * NOTE: This information is only used for _display_ purposes: it in
1118      * no way affects any of the arithmetic of the contract, including
1119      * {IERC20-balanceOf} and {IERC20-transfer}.
1120      */
1121     function decimals() public view returns (uint8) {
1122         return _decimals;
1123     }
1124 
1125     /**
1126      * @dev See {IERC20-totalSupply}.
1127      */
1128     function totalSupply() public view override returns (uint256) {
1129         return _totalSupply;
1130     }
1131 
1132     /**
1133      * @dev See {IERC20-balanceOf}.
1134      */
1135     function balanceOf(address account) public view override returns (uint256) {
1136         return _balances[account];
1137     }
1138 
1139     /**
1140      * @dev See {IERC20-transfer}.
1141      *
1142      * Requirements:
1143      *
1144      * - `recipient` cannot be the zero address.
1145      * - the caller must have a balance of at least `amount`.
1146      */
1147     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1148         _transfer(_msgSender(), recipient, amount);
1149         return true;
1150     }
1151 
1152     /**
1153      * @dev See {IERC20-allowance}.
1154      */
1155     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1156         return _allowances[owner][spender];
1157     }
1158 
1159     /**
1160      * @dev See {IERC20-approve}.
1161      *
1162      * Requirements:
1163      *
1164      * - `spender` cannot be the zero address.
1165      */
1166     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1167         _approve(_msgSender(), spender, amount);
1168         return true;
1169     }
1170 
1171     /**
1172      * @dev See {IERC20-transferFrom}.
1173      *
1174      * Emits an {Approval} event indicating the updated allowance. This is not
1175      * required by the EIP. See the note at the beginning of {ERC20};
1176      *
1177      * Requirements:
1178      * - `sender` and `recipient` cannot be the zero address.
1179      * - `sender` must have a balance of at least `amount`.
1180      * - the caller must have allowance for ``sender``'s tokens of at least
1181      * `amount`.
1182      */
1183     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1184         _transfer(sender, recipient, amount);
1185         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1186         return true;
1187     }
1188 
1189     /**
1190      * @dev Atomically increases the allowance granted to `spender` by the caller.
1191      *
1192      * This is an alternative to {approve} that can be used as a mitigation for
1193      * problems described in {IERC20-approve}.
1194      *
1195      * Emits an {Approval} event indicating the updated allowance.
1196      *
1197      * Requirements:
1198      *
1199      * - `spender` cannot be the zero address.
1200      */
1201     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1202         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1203         return true;
1204     }
1205 
1206     /**
1207      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1208      *
1209      * This is an alternative to {approve} that can be used as a mitigation for
1210      * problems described in {IERC20-approve}.
1211      *
1212      * Emits an {Approval} event indicating the updated allowance.
1213      *
1214      * Requirements:
1215      *
1216      * - `spender` cannot be the zero address.
1217      * - `spender` must have allowance for the caller of at least
1218      * `subtractedValue`.
1219      */
1220     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1221         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1222         return true;
1223     }
1224 
1225     /**
1226      * @dev Moves tokens `amount` from `sender` to `recipient`.
1227      *
1228      * This is internal function is equivalent to {transfer}, and can be used to
1229      * e.g. implement automatic token fees, slashing mechanisms, etc.
1230      *
1231      * Emits a {Transfer} event.
1232      *
1233      * Requirements:
1234      *
1235      * - `sender` cannot be the zero address.
1236      * - `recipient` cannot be the zero address.
1237      * - `sender` must have a balance of at least `amount`.
1238      */
1239     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1240         require(sender != address(0), "ERC20: transfer from the zero address");
1241         require(recipient != address(0), "ERC20: transfer to the zero address");
1242 
1243         _beforeTokenTransfer(sender, recipient, amount);
1244 
1245         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1246         _balances[recipient] = _balances[recipient].add(amount);
1247         emit Transfer(sender, recipient, amount);
1248     }
1249 
1250     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1251      * the total supply.
1252      *
1253      * Emits a {Transfer} event with `from` set to the zero address.
1254      *
1255      * Requirements
1256      *
1257      * - `to` cannot be the zero address.
1258      */
1259     function _mint(address account, uint256 amount) internal virtual {
1260         require(account != address(0), "ERC20: mint to the zero address");
1261 
1262         _beforeTokenTransfer(address(0), account, amount);
1263 
1264         _totalSupply = _totalSupply.add(amount);
1265         _balances[account] = _balances[account].add(amount);
1266         emit Transfer(address(0), account, amount);
1267     }
1268 
1269     /**
1270      * @dev Destroys `amount` tokens from `account`, reducing the
1271      * total supply.
1272      *
1273      * Emits a {Transfer} event with `to` set to the zero address.
1274      *
1275      * Requirements
1276      *
1277      * - `account` cannot be the zero address.
1278      * - `account` must have at least `amount` tokens.
1279      */
1280     function _burn(address account, uint256 amount) internal virtual {
1281         require(account != address(0), "ERC20: burn from the zero address");
1282 
1283         _beforeTokenTransfer(account, address(0), amount);
1284 
1285         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1286         _totalSupply = _totalSupply.sub(amount);
1287         emit Transfer(account, address(0), amount);
1288     }
1289 
1290     /**
1291      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1292      *
1293      * This is internal function is equivalent to `approve`, and can be used to
1294      * e.g. set automatic allowances for certain subsystems, etc.
1295      *
1296      * Emits an {Approval} event.
1297      *
1298      * Requirements:
1299      *
1300      * - `owner` cannot be the zero address.
1301      * - `spender` cannot be the zero address.
1302      */
1303     function _approve(address owner, address spender, uint256 amount) internal virtual {
1304         require(owner != address(0), "ERC20: approve from the zero address");
1305         require(spender != address(0), "ERC20: approve to the zero address");
1306 
1307         _allowances[owner][spender] = amount;
1308         emit Approval(owner, spender, amount);
1309     }
1310 
1311     /**
1312      * @dev Sets {decimals} to a value other than the default one of 18.
1313      *
1314      * WARNING: This function should only be called from the constructor. Most
1315      * applications that interact with token contracts will not expect
1316      * {decimals} to ever change, and may work incorrectly if it does.
1317      */
1318     function _setupDecimals(uint8 decimals_) internal {
1319         _decimals = decimals_;
1320     }
1321 
1322     /**
1323      * @dev Hook that is called before any transfer of tokens. This includes
1324      * minting and burning.
1325      *
1326      * Calling conditions:
1327      *
1328      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1329      * will be to transferred to `to`.
1330      * - when `from` is zero, `amount` tokens will be minted for `to`.
1331      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1332      * - `from` and `to` are never both zero.
1333      *
1334      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1335      */
1336     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1337 
1338     uint256[44] private __gap;
1339 }
1340 
1341 // File: contracts/DHedge.sol
1342 
1343 //
1344 //        __  __    __  ________  _______    ______   ________ 
1345 //       /  |/  |  /  |/        |/       \  /      \ /        |
1346 //   ____$$ |$$ |  $$ |$$$$$$$$/ $$$$$$$  |/$$$$$$  |$$$$$$$$/ 
1347 //  /    $$ |$$ |__$$ |$$ |__    $$ |  $$ |$$ | _$$/ $$ |__    
1348 // /$$$$$$$ |$$    $$ |$$    |   $$ |  $$ |$$ |/    |$$    |   
1349 // $$ |  $$ |$$$$$$$$ |$$$$$/    $$ |  $$ |$$ |$$$$ |$$$$$/    
1350 // $$ \__$$ |$$ |  $$ |$$ |_____ $$ |__$$ |$$ \__$$ |$$ |_____ 
1351 // $$    $$ |$$ |  $$ |$$       |$$    $$/ $$    $$/ $$       |
1352 //  $$$$$$$/ $$/   $$/ $$$$$$$$/ $$$$$$$/   $$$$$$/  $$$$$$$$/ 
1353 //
1354 // dHEDGE DAO - https://dhedge.org
1355 //
1356 // MIT License
1357 // ===========
1358 //
1359 // Copyright (c) 2020 dHEDGE DAO
1360 //
1361 // Permission is hereby granted, free of charge, to any person obtaining a copy
1362 // of this software and associated documentation files (the "Software"), to deal
1363 // in the Software without restriction, including without limitation the rights
1364 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1365 // copies of the Software, and to permit persons to whom the Software is
1366 // furnished to do so, subject to the following conditions:
1367 //
1368 // The above copyright notice and this permission notice shall be included in all
1369 // copies or substantial portions of the Software.
1370 //
1371 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1372 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1373 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1374 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1375 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1376 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1377 //
1378 
1379 pragma solidity ^0.6.2;
1380 
1381 
1382 
1383 
1384 
1385 
1386 
1387 
1388 
1389 
1390 
1391 
1392 
1393 
1394 
1395 
1396 
1397 
1398 contract DHedge is Initializable, ERC20UpgradeSafe, Managed, IReceivesUpgrade {
1399     using SafeMath for uint256;
1400 
1401     bytes32 constant private _EXCHANGE_RATES_KEY = "ExchangeRates";
1402     bytes32 constant private _SYNTHETIX_KEY = "Synthetix";
1403     bytes32 constant private _EXCHANGER_KEY = "Exchanger";
1404     bytes32 constant private _SYSTEM_STATUS_KEY = "SystemStatus";
1405     bytes32 constant private _SUSD_KEY = "sUSD";
1406 
1407     event Deposit(
1408         address fundAddress,
1409         address investor,
1410         uint256 valueDeposited,
1411         uint256 fundTokensReceived,
1412         uint256 totalInvestorFundTokens,
1413         uint256 fundValue,
1414         uint256 totalSupply,
1415         uint256 time
1416     );
1417     event Withdrawal(
1418         address fundAddress,
1419         address investor,
1420         uint256 valueWithdrawn,
1421         uint256 fundTokensWithdrawn,
1422         uint256 totalInvestorFundTokens,
1423         uint256 fundValue,
1424         uint256 totalSupply,
1425         uint256 time
1426     );
1427     event Exchange(
1428         address fundAddress,
1429         address manager,
1430         bytes32 sourceKey,
1431         uint256 sourceAmount,
1432         bytes32 destinationKey,
1433         uint256 destinationAmount,
1434         uint256 time
1435     );
1436     event AssetAdded(address fundAddress, address manager, bytes32 assetKey);
1437     event AssetRemoved(address fundAddress, address manager, bytes32 assetKey);
1438 
1439     event PoolPrivacyUpdated(bool isPoolPrivate);
1440 
1441     event ManagerFeeMinted(
1442         address pool,
1443         address manager,
1444         uint256 available,
1445         uint256 daoFee,
1446         uint256 managerFee,
1447         uint256 tokenPriceAtLastFeeMint
1448     );
1449 
1450     event ManagerFeeSet(
1451         address fundAddress,
1452         address manager,
1453         uint256 numerator,
1454         uint256 denominator
1455     );
1456 
1457     event ManagerFeeIncreaseAnnounced(
1458         uint256 newNumerator,
1459         uint256 announcedFeeActivationTime);
1460 
1461     event ManagerFeeIncreaseRenounced();
1462 
1463     bool public privatePool;
1464     address public creator;
1465 
1466     uint256 public creationTime;
1467 
1468     IAddressResolver public addressResolver;
1469 
1470     address public factory;
1471 
1472     bytes32[] public supportedAssets;
1473     mapping(bytes32 => uint256) public assetPosition; // maps the asset to its 1-based position
1474 
1475     mapping(bytes32 => bool) public persistentAsset;
1476 
1477     // Manager fees
1478     uint256 public tokenPriceAtLastFeeMint;
1479 
1480     mapping(address => uint256) public lastDeposit;
1481 
1482     // Fee increase announcement
1483     uint256 public announcedFeeIncreaseNumerator;
1484     uint256 public announcedFeeIncreaseTimestamp;
1485 
1486     modifier onlyPrivate() {
1487         require(
1488             msg.sender == manager() ||
1489                 !privatePool ||
1490                 isMemberAllowed(msg.sender),
1491             "only members allowed"
1492         );
1493         _;
1494     }
1495 
1496     function initialize(
1497         address _factory,
1498         bool _privatePool,
1499         address _manager,
1500         string memory _managerName,
1501         string memory _fundName,
1502         string memory _fundSymbol,
1503         IAddressResolver _addressResolver,
1504         bytes32[] memory _supportedAssets
1505     ) public initializer {
1506         ERC20UpgradeSafe.__ERC20_init(_fundName, _fundSymbol);
1507         Managed.initialize(_manager, _managerName);
1508 
1509         factory = _factory;
1510         _setPoolPrivacy(_privatePool);
1511         creator = msg.sender;
1512         creationTime = block.timestamp;
1513         addressResolver = _addressResolver;
1514 
1515         _addToSupportedAssets(_SUSD_KEY);
1516 
1517         for(uint8 i = 0; i < _supportedAssets.length; i++) {
1518             _addToSupportedAssets(_supportedAssets[i]);
1519         }
1520 
1521         // Set persistent assets
1522         persistentAsset[_SUSD_KEY] = true;
1523 
1524         tokenPriceAtLastFeeMint = 10**18;
1525     }
1526 
1527     function _beforeTokenTransfer(address from, address to, uint256 amount)
1528         internal virtual override
1529     {
1530         super._beforeTokenTransfer(from, to, amount);
1531 
1532         require(getExitFeeRemainingCooldown(from) == 0, "cooldown active");
1533     }
1534 
1535     function setPoolPrivate(bool _privatePool) public onlyManager {
1536         require(privatePool != _privatePool, "flag must be different");
1537 
1538         _setPoolPrivacy(_privatePool);
1539     }
1540 
1541     function _setPoolPrivacy(bool _privacy) internal {
1542         privatePool = _privacy;
1543 
1544         emit PoolPrivacyUpdated(_privacy);
1545     }
1546 
1547     function getAssetProxy(bytes32 key) public view returns (address) {
1548         address synth = ISynthetix(addressResolver.getAddress(_SYNTHETIX_KEY))
1549             .synths(key);
1550         require(synth != address(0), "invalid key");
1551         address proxy = ISynth(synth).proxy();
1552         require(proxy != address(0), "invalid proxy");
1553         return proxy;
1554     }
1555 
1556     function isAssetSupported(bytes32 key) public view returns (bool) {
1557         return assetPosition[key] != 0;
1558     }
1559 
1560     function validateAsset(bytes32 key) public view returns (bool) {
1561         address synth = ISynthetix(addressResolver.getAddress(_SYNTHETIX_KEY))
1562             .synths(key);
1563 
1564         if (synth == address(0))
1565             return false;
1566 
1567         address proxy = ISynth(synth).proxy();
1568 
1569         if (proxy == address(0))
1570             return false;
1571 
1572         return true;
1573     }
1574 
1575     function addToSupportedAssets(bytes32 key) public onlyManagerOrTrader {
1576         _addToSupportedAssets(key);
1577     }
1578 
1579     function removeFromSupportedAssets(bytes32 key) public {
1580         require(msg.sender == IHasProtocolDaoInfo(factory).owner() ||
1581             msg.sender == manager() ||
1582             msg.sender == trader(), "only manager, trader or Protocol DAO");
1583 
1584         require(isAssetSupported(key), "asset not supported");
1585 
1586         require(!persistentAsset[key], "persistent assets can't be removed");
1587         
1588         if (validateAsset(key) == true) { // allow removal of depreciated synths
1589             require(
1590                 IERC20(getAssetProxy(key)).balanceOf(address(this)) == 0,
1591                 "non-empty asset cannot be removed"
1592             );
1593         }
1594         
1595 
1596         _removeFromSupportedAssets(key);
1597     }
1598 
1599     function numberOfSupportedAssets() public view returns (uint256) {
1600         return supportedAssets.length;
1601     }
1602 
1603     // Unsafe internal method that assumes we are not adding a duplicate
1604     function _addToSupportedAssets(bytes32 key) internal {
1605         require(supportedAssets.length < IHasAssetInfo(factory).getMaximumSupportedAssetCount(), "maximum assets reached");
1606         require(!isAssetSupported(key), "asset already supported");
1607         require(validateAsset(key) == true, "not an asset");
1608 
1609         supportedAssets.push(key);
1610         assetPosition[key] = supportedAssets.length;
1611 
1612         emit AssetAdded(address(this), manager(), key);
1613     }
1614 
1615     // Unsafe internal method that assumes we are removing an element that exists
1616     function _removeFromSupportedAssets(bytes32 key) internal {
1617         uint256 length = supportedAssets.length;
1618         uint256 index = assetPosition[key].sub(1); // adjusting the index because the map stores 1-based
1619 
1620         bytes32 lastAsset = supportedAssets[length.sub(1)];
1621 
1622         // overwrite the asset to be removed with the last supported asset
1623         supportedAssets[index] = lastAsset;
1624         assetPosition[lastAsset] = index.add(1); // adjusting the index to be 1-based
1625         assetPosition[key] = 0; // update the map
1626 
1627         // delete the last supported asset and resize the array
1628         supportedAssets.pop();
1629 
1630         emit AssetRemoved(address(this), manager(), key);
1631     }
1632 
1633     function exchange(
1634         bytes32 sourceKey,
1635         uint256 sourceAmount,
1636         bytes32 destinationKey
1637     ) public onlyManagerOrTrader {
1638         require(isAssetSupported(sourceKey), "unsupported source currency");
1639         require(
1640             isAssetSupported(destinationKey),
1641             "unsupported destination currency"
1642         );
1643 
1644         ISynthetix sx = ISynthetix(addressResolver.getAddress(_SYNTHETIX_KEY));
1645 
1646         uint256 destinationAmount = sx.exchangeWithTracking(
1647             sourceKey,
1648             sourceAmount,
1649             destinationKey,
1650             IHasDaoInfo(factory).getDaoAddress(),
1651             IHasFeeInfo(factory).getTrackingCode()
1652         );
1653 
1654         emit Exchange(
1655             address(this),
1656             msg.sender,
1657             sourceKey,
1658             sourceAmount,
1659             destinationKey,
1660             destinationAmount,
1661             block.timestamp
1662         );
1663     }
1664 
1665     function totalFundValue() public virtual view returns (uint256) {
1666         uint256 total = 0;
1667         uint256 assetCount = supportedAssets.length;
1668 
1669         for (uint256 i = 0; i < assetCount; i++) {
1670             total = total.add(assetValue(supportedAssets[i]));
1671         }
1672         return total;
1673     }
1674 
1675     function assetValue(bytes32 key) public view returns (uint256) {
1676         return
1677             IExchangeRates(addressResolver.getAddress(_EXCHANGE_RATES_KEY))
1678                 .effectiveValue(
1679                 key,
1680                 IERC20(getAssetProxy(key)).balanceOf(address(this)),
1681                 _SUSD_KEY
1682             );
1683     }
1684 
1685     function deposit(uint256 _susdAmount) public onlyPrivate returns (uint256) {
1686         lastDeposit[msg.sender] = block.timestamp;
1687 
1688         //we need to settle all the assets before determining the total fund value for calculating manager fees
1689         //as an optimisation it also returns current fundValue
1690         uint256 fundValue = mintManagerFee(true);
1691 
1692         uint256 totalSupplyBefore = totalSupply();
1693 
1694         IExchanger sx = IExchanger(addressResolver.getAddress(_EXCHANGER_KEY));
1695 
1696         require(
1697             IERC20(getAssetProxy(_SUSD_KEY)).transferFrom(
1698                 msg.sender,
1699                 address(this),
1700                 _susdAmount
1701             ),
1702             "token transfer failed"
1703         );
1704 
1705         uint256 liquidityMinted;
1706         if (totalSupplyBefore > 0) {
1707             //total balance converted to susd that this contract holds
1708             //need to calculate total value of synths in this contract
1709             liquidityMinted = _susdAmount.mul(totalSupplyBefore).div(fundValue);
1710         } else {
1711             liquidityMinted = _susdAmount;
1712         }
1713 
1714         _mint(msg.sender, liquidityMinted);
1715 
1716         emit Deposit(
1717             address(this),
1718             msg.sender,
1719             _susdAmount,
1720             liquidityMinted,
1721             balanceOf(msg.sender),
1722             fundValue.add(_susdAmount),
1723             totalSupplyBefore.add(liquidityMinted),
1724             block.timestamp
1725         );
1726 
1727         return liquidityMinted;
1728     }
1729 
1730     function _settleAll(bool failOnSuspended) internal {
1731         ISynthetix sx = ISynthetix(addressResolver.getAddress(_SYNTHETIX_KEY));
1732         ISystemStatus status = ISystemStatus(addressResolver.getAddress(_SYSTEM_STATUS_KEY));
1733 
1734         uint256 assetCount = supportedAssets.length;
1735 
1736         for (uint256 i = 0; i < assetCount; i++) {
1737 
1738             address proxy = getAssetProxy(supportedAssets[i]);
1739             uint256 totalAssetBalance = IERC20(proxy).balanceOf(address(this));
1740 
1741             if (totalAssetBalance > 0) {
1742                 sx.settle(supportedAssets[i]);
1743                 if (failOnSuspended) {
1744                     (bool suspended, ) = status.synthExchangeSuspension(supportedAssets[i]);
1745                     require(!suspended , "required asset is suspended");
1746                 }
1747             }
1748 
1749         }
1750     }
1751 
1752     function withdraw(uint256 _fundTokenAmount) public virtual {
1753         require(
1754             balanceOf(msg.sender) >= _fundTokenAmount,
1755             "insufficient balance of fund tokens"
1756         );
1757 
1758         require(
1759             getExitFeeRemainingCooldown(msg.sender) == 0,
1760             "cooldown active"
1761         );
1762 
1763         uint256 fundValue = mintManagerFee(false);
1764         uint256 valueWithdrawn = _fundTokenAmount.mul(fundValue).div(totalSupply());
1765 
1766         //calculate the proportion
1767         uint256 portion = _fundTokenAmount.mul(10**18).div(totalSupply());
1768 
1769         //first return funded tokens
1770         _burn(msg.sender, _fundTokenAmount);
1771 
1772         uint256 assetCount = supportedAssets.length;
1773 
1774         for (uint256 i = 0; i < assetCount; i++) {
1775             address proxy = getAssetProxy(supportedAssets[i]);
1776             uint256 totalAssetBalance = IERC20(proxy).balanceOf(address(this));
1777             uint256 portionOfAssetBalance = totalAssetBalance.mul(portion).div(10**18);
1778 
1779             if (portionOfAssetBalance > 0) {
1780                 IERC20(proxy).transfer(msg.sender, portionOfAssetBalance);
1781             }
1782         }
1783 
1784         emit Withdrawal(
1785             address(this),
1786             msg.sender,
1787             valueWithdrawn,
1788             _fundTokenAmount,
1789             balanceOf(msg.sender),
1790             fundValue.sub(valueWithdrawn),
1791             totalSupply(),
1792             block.timestamp
1793         );
1794     }
1795 
1796     function getFundSummary()
1797         public
1798         view
1799         returns (
1800             string memory,
1801             uint256,
1802             uint256,
1803             address,
1804             string memory,
1805             uint256,
1806             bool,
1807             uint256,
1808             uint256,
1809             uint256,
1810             uint256
1811         )
1812     {
1813 
1814         uint256 managerFeeNumerator;
1815         uint256 managerFeeDenominator;
1816         (managerFeeNumerator, managerFeeDenominator) = IHasFeeInfo(factory).getPoolManagerFee(address(this));
1817 
1818         uint256 exitFeeNumerator = 0;
1819         uint256 exitFeeDenominator = 1;
1820 
1821         return (
1822             name(),
1823             totalSupply(),
1824             totalFundValue(),
1825             manager(),
1826             managerName(),
1827             creationTime,
1828             privatePool,
1829             managerFeeNumerator,
1830             managerFeeDenominator,
1831             exitFeeNumerator,
1832             exitFeeDenominator
1833         );
1834     }
1835 
1836     function getSupportedAssets() public view returns (bytes32[] memory) {
1837         return supportedAssets;
1838     }
1839 
1840     function getFundComposition()
1841         public
1842         view
1843         returns (
1844             bytes32[] memory,
1845             uint256[] memory,
1846             uint256[] memory
1847         )
1848     {
1849         uint256 assetCount = supportedAssets.length;
1850 
1851         bytes32[] memory assets = new bytes32[](assetCount);
1852         uint256[] memory balances = new uint256[](assetCount);
1853         uint256[] memory rates = new uint256[](assetCount);
1854 
1855         IExchangeRates exchangeRates = IExchangeRates(
1856             addressResolver.getAddress(_EXCHANGE_RATES_KEY)
1857         );
1858         for (uint256 i = 0; i < assetCount; i++) {
1859             bytes32 asset = supportedAssets[i];
1860             balances[i] = IERC20(getAssetProxy(asset)).balanceOf(address(this));
1861             assets[i] = asset;
1862             rates[i] = exchangeRates.rateForCurrency(asset);
1863         }
1864         return (assets, balances, rates);
1865     }
1866 
1867     function getWaitingPeriods()
1868         public
1869         view
1870         returns (
1871             bytes32[] memory,
1872             uint256[] memory
1873         )
1874     {
1875         uint256 assetCount = supportedAssets.length;
1876 
1877         bytes32[] memory assets = new bytes32[](assetCount);
1878         uint256[] memory periods = new uint256[](assetCount);
1879 
1880         IExchanger exchanger = IExchanger(addressResolver.getAddress(_EXCHANGER_KEY));
1881 
1882         for (uint256 i = 0; i < assetCount; i++) {
1883             bytes32 asset = supportedAssets[i];
1884             assets[i] = asset;
1885             periods[i] = exchanger.maxSecsLeftInWaitingPeriod(address(this), asset);
1886         }
1887 
1888         return (assets, periods);
1889     }
1890 
1891     // MANAGER FEES
1892 
1893     function tokenPrice() public view returns (uint256) {
1894         uint256 fundValue = totalFundValue();
1895         uint256 tokenSupply = totalSupply();
1896 
1897         return _tokenPrice(fundValue, tokenSupply);
1898     }
1899 
1900     function _tokenPrice(uint256 _fundValue, uint256 _tokenSupply)
1901         internal
1902         pure
1903         returns (uint256)
1904     {
1905         if (_tokenSupply == 0 || _fundValue == 0) return 0;
1906 
1907         return _fundValue.mul(10**18).div(_tokenSupply);
1908     }
1909 
1910     function availableManagerFee() public view returns (uint256) {
1911         uint256 fundValue = totalFundValue();
1912         uint256 tokenSupply = totalSupply();
1913 
1914         uint256 managerFeeNumerator;
1915         uint256 managerFeeDenominator;
1916         (managerFeeNumerator, managerFeeDenominator) = IHasFeeInfo(factory).getPoolManagerFee(address(this));
1917 
1918         return
1919             _availableManagerFee(
1920                 fundValue,
1921                 tokenSupply,
1922                 tokenPriceAtLastFeeMint,
1923                 managerFeeNumerator,
1924                 managerFeeDenominator
1925             );
1926     }
1927 
1928     function _availableManagerFee(
1929         uint256 _fundValue,
1930         uint256 _tokenSupply,
1931         uint256 _lastFeeMintPrice,
1932         uint256 _feeNumerator,
1933         uint256 _feeDenominator
1934     ) internal pure returns (uint256) {
1935         if (_tokenSupply == 0 || _fundValue == 0) return 0;
1936 
1937         uint256 currentTokenPrice = _fundValue.mul(10**18).div(_tokenSupply);
1938 
1939         if (currentTokenPrice <= _lastFeeMintPrice) return 0;
1940 
1941         uint256 available = currentTokenPrice
1942             .sub(_lastFeeMintPrice)
1943             .mul(_tokenSupply)
1944             .mul(_feeNumerator)
1945             .div(_feeDenominator)
1946             .div(currentTokenPrice);
1947 
1948         return available;
1949     }
1950 
1951     //returns uint256 fundValue as a gas optimisation
1952     function mintManagerFee(bool failOnSuspended) public returns (uint256) {
1953         //we need to settle all the assets before minting the manager fee
1954         _settleAll(failOnSuspended);
1955 
1956         uint256 fundValue = totalFundValue();
1957         uint256 tokenSupply = totalSupply();
1958 
1959         uint256 managerFeeNumerator;
1960         uint256 managerFeeDenominator;
1961         (managerFeeNumerator, managerFeeDenominator) = IHasFeeInfo(factory).getPoolManagerFee(address(this));
1962 
1963         uint256 available = _availableManagerFee(
1964             fundValue,
1965             tokenSupply,
1966             tokenPriceAtLastFeeMint,
1967             managerFeeNumerator,
1968             managerFeeDenominator
1969         );
1970 
1971         // Ignore dust when minting performance fees
1972         if (available < 100)
1973             return fundValue;
1974 
1975         address daoAddress = IHasDaoInfo(factory).getDaoAddress();
1976         uint256 daoFeeNumerator;
1977         uint256 daoFeeDenominator;
1978 
1979         (daoFeeNumerator, daoFeeDenominator) = IHasDaoInfo(factory).getDaoFee();
1980 
1981         uint256 daoFee = available.mul(daoFeeNumerator).div(daoFeeDenominator);
1982         uint256 managerFee = available.sub(daoFee);
1983 
1984         if (daoFee > 0) _mint(daoAddress, daoFee);
1985 
1986         if (managerFee > 0) _mint(manager(), managerFee);
1987 
1988         tokenPriceAtLastFeeMint = _tokenPrice(fundValue, tokenSupply);
1989 
1990         emit ManagerFeeMinted(
1991             address(this),
1992             manager(),
1993             available,
1994             daoFee,
1995             managerFee,
1996             tokenPriceAtLastFeeMint
1997         );
1998 
1999         return fundValue;
2000     }
2001 
2002     function getManagerFee() public view returns (uint256, uint256) {
2003         return IHasFeeInfo(factory).getPoolManagerFee(address(this));
2004     }
2005 
2006     function setManagerFeeNumerator(uint256 numerator) public onlyManager {
2007         uint256 managerFeeNumerator;
2008         uint256 managerFeeDenominator;
2009         (managerFeeNumerator, managerFeeDenominator) = IHasFeeInfo(factory).getPoolManagerFee(address(this));
2010 
2011         require(numerator < managerFeeNumerator, "manager fee too high");
2012 
2013         IHasFeeInfo(factory).setPoolManagerFeeNumerator(address(this), numerator);
2014 
2015         emit ManagerFeeSet(
2016             address(this),
2017             manager(),
2018             numerator,
2019             managerFeeDenominator
2020         );
2021     }
2022 
2023     function _setManagerFeeNumerator(uint256 numerator) internal {
2024         IHasFeeInfo(factory).setPoolManagerFeeNumerator(address(this), numerator);
2025         
2026         uint256 managerFeeNumerator;
2027         uint256 managerFeeDenominator;
2028         (managerFeeNumerator, managerFeeDenominator) = IHasFeeInfo(factory).getPoolManagerFee(address(this));
2029 
2030         emit ManagerFeeSet(
2031             address(this),
2032             manager(),
2033             managerFeeNumerator,
2034             managerFeeDenominator
2035         );
2036     }
2037 
2038     function announceManagerFeeIncrease(uint256 numerator) public onlyManager {
2039         uint256 maximumAllowedChange = IHasFeeInfo(factory).getMaximumManagerFeeNumeratorChange();
2040 
2041         uint256 currentFeeNumerator;
2042         (currentFeeNumerator, ) = getManagerFee();
2043 
2044         require (numerator <= currentFeeNumerator.add(maximumAllowedChange), "exceeded allowed increase");
2045 
2046         uint256 feeChangeDelay = IHasFeeInfo(factory).getManagerFeeNumeratorChangeDelay(); 
2047 
2048         announcedFeeIncreaseNumerator = numerator;
2049         announcedFeeIncreaseTimestamp = block.timestamp + feeChangeDelay;
2050         emit ManagerFeeIncreaseAnnounced(numerator, announcedFeeIncreaseTimestamp);
2051     }
2052 
2053     function renounceManagerFeeIncrease() public onlyManager {
2054         announcedFeeIncreaseNumerator = 0;
2055         announcedFeeIncreaseTimestamp = 0;
2056         emit ManagerFeeIncreaseRenounced();
2057     }
2058 
2059     function commitManagerFeeIncrease() public onlyManager {
2060         require(block.timestamp >= announcedFeeIncreaseTimestamp, "fee increase delay active");
2061 
2062         _setManagerFeeNumerator(announcedFeeIncreaseNumerator);
2063 
2064         announcedFeeIncreaseNumerator = 0;
2065         announcedFeeIncreaseTimestamp = 0;
2066     }
2067 
2068     function getManagerFeeIncreaseInfo() public view returns (uint256, uint256) {
2069         return (announcedFeeIncreaseNumerator, announcedFeeIncreaseTimestamp);
2070     }
2071 
2072     // Exit fees
2073 
2074     function getExitFee() external view returns (uint256, uint256) {
2075         return (0, 1);
2076     }
2077 
2078     function getExitFeeCooldown() external view returns (uint256) {
2079         return IHasFeeInfo(factory).getExitFeeCooldown();
2080     }
2081 
2082     function getExitFeeRemainingCooldown(address sender) public view returns (uint256) {
2083         uint256 cooldown = IHasFeeInfo(factory).getExitFeeCooldown();
2084         uint256 cooldownFinished = lastDeposit[sender].add(cooldown);
2085 
2086         if (cooldownFinished < block.timestamp)
2087             return 0;
2088 
2089         return cooldownFinished.sub(block.timestamp);
2090     }
2091     
2092     // Swap contract
2093 
2094     function setLastDeposit(address investor) public onlyDhptSwap {
2095         lastDeposit[investor] = block.timestamp;
2096     }
2097 
2098     modifier onlyDhptSwap() {
2099         address dhptSwapAddress = IHasDhptSwapInfo(factory)
2100             .getDhptSwapAddress();
2101         require(msg.sender == dhptSwapAddress, "only swap contract");
2102         _;
2103     }
2104 
2105     // Upgrade
2106 
2107     function receiveUpgrade(uint256 targetVersion) external override{
2108         require(msg.sender == factory, "no permission");
2109 
2110         if (targetVersion == 1) {
2111             addressResolver = IAddressResolver(0x4E3b31eB0E5CB73641EE1E65E7dCEFe520bA3ef2);
2112             return;
2113         }
2114 
2115         require(false, "upgrade handler not found");
2116     }
2117 
2118     uint256[50] private __gap;
2119 }
2120 
2121 // File: contracts/upgradability/Proxy.sol
2122 
2123 pragma solidity ^0.6.2;
2124 
2125 /**
2126  * @title Proxy
2127  * @dev Implements delegation of calls to other contracts, with proper
2128  * forwarding of return values and bubbling of failures.
2129  * It defines a fallback function that delegates all calls to the address
2130  * returned by the abstract _implementation() internal function.
2131  */
2132 abstract contract Proxy {
2133     /**
2134      * @dev Fallback function.
2135      * Implemented entirely in `_fallback`.
2136      */
2137     fallback() external payable {
2138         _fallback();
2139     }
2140 
2141     receive() external payable {
2142         _fallback();
2143     }
2144 
2145     /**
2146      * @return The Address of the implementation.
2147      */
2148     function _implementation() internal virtual view returns (address);
2149 
2150     /**
2151      * @dev Delegates execution to an implementation contract.
2152      * This is a low level function that doesn't return to its internal call site.
2153      * It will return to the external caller whatever the implementation returns.
2154      * @param implementation Address to delegate.
2155      */
2156     function _delegate(address implementation) internal {
2157         assembly {
2158             // Copy msg.data. We take full control of memory in this inline assembly
2159             // block because it will not return to Solidity code. We overwrite the
2160             // Solidity scratch pad at memory position 0.
2161             calldatacopy(0, 0, calldatasize())
2162 
2163             // Call the implementation.
2164             // out and outsize are 0 because we don't know the size yet.
2165             let result := delegatecall(
2166                 gas(),
2167                 implementation,
2168                 0,
2169                 calldatasize(),
2170                 0,
2171                 0
2172             )
2173 
2174             // Copy the returned data.
2175             returndatacopy(0, 0, returndatasize())
2176 
2177             switch result
2178                 // delegatecall returns 0 on error.
2179                 case 0 {
2180                     revert(0, returndatasize())
2181                 }
2182                 default {
2183                     return(0, returndatasize())
2184                 }
2185         }
2186     }
2187 
2188     /**
2189      * @dev Function that is run as the first thing in the fallback function.
2190      * Can be redefined in derived contracts to add functionality.
2191      * Redefinitions must call super._willFallback().
2192      */
2193     function _willFallback() internal virtual {}
2194 
2195     /**
2196      * @dev fallback implementation.
2197      * Extracted to enable manual triggering.
2198      */
2199     function _fallback() internal {
2200         _willFallback();
2201         _delegate(_implementation());
2202     }
2203 }
2204 
2205 // File: contracts/upgradability/Address.sol
2206 
2207 pragma solidity ^0.6.2;
2208 
2209 /**
2210  * Utility library of inline functions on addresses
2211  *
2212  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
2213  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
2214  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
2215  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
2216  */
2217 library OpenZeppelinUpgradesAddress {
2218     /**
2219      * Returns whether the target address is a contract
2220      * @dev This function will return false if invoked during the constructor of a contract,
2221      * as the code is not actually created until after the constructor finishes.
2222      * @param account address of the account to check
2223      * @return whether the target address is a contract
2224      */
2225     function isContract(address account) internal view returns (bool) {
2226         uint256 size;
2227         // XXX Currently there is no better way to check if there is a contract in an address
2228         // than to check the size of the code at that address.
2229         // See https://ethereum.stackexchange.com/a/14016/36603
2230         // for more details about how this works.
2231         // TODO Check this again before the Serenity release, because all addresses will be
2232         // contracts then.
2233         // solhint-disable-next-line no-inline-assembly
2234         assembly {
2235             size := extcodesize(account)
2236         }
2237         return size > 0;
2238     }
2239 }
2240 
2241 // File: contracts/upgradability/HasLogic.sol
2242 
2243 //
2244 //        __  __    __  ________  _______    ______   ________ 
2245 //       /  |/  |  /  |/        |/       \  /      \ /        |
2246 //   ____$$ |$$ |  $$ |$$$$$$$$/ $$$$$$$  |/$$$$$$  |$$$$$$$$/ 
2247 //  /    $$ |$$ |__$$ |$$ |__    $$ |  $$ |$$ | _$$/ $$ |__    
2248 // /$$$$$$$ |$$    $$ |$$    |   $$ |  $$ |$$ |/    |$$    |   
2249 // $$ |  $$ |$$$$$$$$ |$$$$$/    $$ |  $$ |$$ |$$$$ |$$$$$/    
2250 // $$ \__$$ |$$ |  $$ |$$ |_____ $$ |__$$ |$$ \__$$ |$$ |_____ 
2251 // $$    $$ |$$ |  $$ |$$       |$$    $$/ $$    $$/ $$       |
2252 //  $$$$$$$/ $$/   $$/ $$$$$$$$/ $$$$$$$/   $$$$$$/  $$$$$$$$/ 
2253 //
2254 // dHEDGE DAO - https://dhedge.org
2255 //
2256 // MIT License
2257 // ===========
2258 //
2259 // Copyright (c) 2020 dHEDGE DAO
2260 //
2261 // Permission is hereby granted, free of charge, to any person obtaining a copy
2262 // of this software and associated documentation files (the "Software"), to deal
2263 // in the Software without restriction, including without limitation the rights
2264 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
2265 // copies of the Software, and to permit persons to whom the Software is
2266 // furnished to do so, subject to the following conditions:
2267 //
2268 // The above copyright notice and this permission notice shall be included in all
2269 // copies or substantial portions of the Software.
2270 //
2271 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
2272 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
2273 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
2274 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
2275 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
2276 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
2277 //
2278 
2279 pragma solidity ^0.6.2;
2280 
2281 interface HasLogic {
2282     function getLogic() external view returns (address);
2283 }
2284 
2285 // File: contracts/upgradability/BaseUpgradeabilityProxy.sol
2286 
2287 pragma solidity ^0.6.2;
2288 
2289 
2290 
2291 
2292 /**
2293  * @title BaseUpgradeabilityProxy
2294  * @dev This contract implements a proxy that allows to change the
2295  * implementation address to which it will delegate.
2296  * Such a change is called an implementation upgrade.
2297  */
2298 contract BaseUpgradeabilityProxy is Proxy {
2299     /**
2300      * @dev Emitted when the implementation is upgraded.
2301      * @param implementation Address of the new implementation.
2302      */
2303     event Upgraded(address indexed implementation);
2304 
2305     /**
2306      * @dev Storage slot with the address of the current implementation.
2307      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
2308      * validated in the constructor.
2309      */
2310     bytes32
2311         internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
2312 
2313     /**
2314      * @dev Returns the current implementation.
2315      * @return impl Address of the current implementation
2316      */
2317     function _implementation() internal override view returns (address) {
2318         address factory;
2319         bytes32 slot = IMPLEMENTATION_SLOT;
2320         assembly {
2321             factory := sload(slot)
2322         }
2323 
2324         // Begin custom modification
2325         if (factory == address(0x0)) return address(0x0); // If factory not initialized return empty
2326 
2327         return HasLogic(factory).getLogic();
2328     }
2329 
2330     /**
2331      * @dev Upgrades the proxy to a new implementation.
2332      * @param newImplementation Address of the new implementation.
2333      */
2334     function _upgradeTo(address newImplementation) internal {
2335         _setImplementation(newImplementation);
2336         emit Upgraded(newImplementation);
2337     }
2338 
2339     /**
2340      * @dev Sets the implementation address of the proxy.
2341      * @param newImplementation Address of the new implementation.
2342      */
2343     function _setImplementation(address newImplementation) internal {
2344         require(
2345             OpenZeppelinUpgradesAddress.isContract(newImplementation),
2346             "Cannot set a proxy implementation to a non-contract address"
2347         );
2348 
2349         bytes32 slot = IMPLEMENTATION_SLOT;
2350 
2351         assembly {
2352             sstore(slot, newImplementation)
2353         }
2354     }
2355 }
2356 
2357 // File: contracts/upgradability/InitializableUpgradeabilityProxy.sol
2358 
2359 pragma solidity ^0.6.2;
2360 
2361 
2362 /**
2363  * @title InitializableUpgradeabilityProxy
2364  * @dev Extends BaseUpgradeabilityProxy with an initializer for initializing
2365  * implementation and init data.
2366  */
2367 contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
2368     /**
2369      * @dev Contract initializer.
2370      * @param _factory Address of the factory containing the implementation.
2371      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
2372      * It should include the signature and the parameters of the function to be called, as described in
2373      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
2374      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
2375      */
2376     function initialize(address _factory, bytes memory _data) public payable {
2377         require(_implementation() == address(0), "Impl not zero");
2378         assert(
2379             IMPLEMENTATION_SLOT ==
2380                 bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)
2381         );
2382         _setImplementation(_factory);
2383         if (_data.length > 0) {
2384             (bool success, ) = _implementation().delegatecall(_data);
2385             require(success);
2386         }
2387     }
2388 }
2389 
2390 // File: @openzeppelin/contracts-ethereum-package/contracts/access/Ownable.sol
2391 
2392 pragma solidity ^0.6.0;
2393 
2394 
2395 /**
2396  * @dev Contract module which provides a basic access control mechanism, where
2397  * there is an account (an owner) that can be granted exclusive access to
2398  * specific functions.
2399  *
2400  * By default, the owner account will be the one that deploys the contract. This
2401  * can later be changed with {transferOwnership}.
2402  *
2403  * This module is used through inheritance. It will make available the modifier
2404  * `onlyOwner`, which can be applied to your functions to restrict their use to
2405  * the owner.
2406  */
2407 contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {
2408     address private _owner;
2409 
2410     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2411 
2412     /**
2413      * @dev Initializes the contract setting the deployer as the initial owner.
2414      */
2415 
2416     function __Ownable_init() internal initializer {
2417         __Context_init_unchained();
2418         __Ownable_init_unchained();
2419     }
2420 
2421     function __Ownable_init_unchained() internal initializer {
2422 
2423 
2424         address msgSender = _msgSender();
2425         _owner = msgSender;
2426         emit OwnershipTransferred(address(0), msgSender);
2427 
2428     }
2429 
2430 
2431     /**
2432      * @dev Returns the address of the current owner.
2433      */
2434     function owner() public view returns (address) {
2435         return _owner;
2436     }
2437 
2438     /**
2439      * @dev Throws if called by any account other than the owner.
2440      */
2441     modifier onlyOwner() {
2442         require(_owner == _msgSender(), "Ownable: caller is not the owner");
2443         _;
2444     }
2445 
2446     /**
2447      * @dev Leaves the contract without owner. It will not be possible to call
2448      * `onlyOwner` functions anymore. Can only be called by the current owner.
2449      *
2450      * NOTE: Renouncing ownership will leave the contract without an owner,
2451      * thereby removing any functionality that is only available to the owner.
2452      */
2453     function renounceOwnership() public virtual onlyOwner {
2454         emit OwnershipTransferred(_owner, address(0));
2455         _owner = address(0);
2456     }
2457 
2458     /**
2459      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2460      * Can only be called by the current owner.
2461      */
2462     function transferOwnership(address newOwner) public virtual onlyOwner {
2463         require(newOwner != address(0), "Ownable: new owner is the zero address");
2464         emit OwnershipTransferred(_owner, newOwner);
2465         _owner = newOwner;
2466     }
2467 
2468     uint256[49] private __gap;
2469 }
2470 
2471 // File: contracts/upgradability/ProxyFactory.sol
2472 
2473 //
2474 //        __  __    __  ________  _______    ______   ________ 
2475 //       /  |/  |  /  |/        |/       \  /      \ /        |
2476 //   ____$$ |$$ |  $$ |$$$$$$$$/ $$$$$$$  |/$$$$$$  |$$$$$$$$/ 
2477 //  /    $$ |$$ |__$$ |$$ |__    $$ |  $$ |$$ | _$$/ $$ |__    
2478 // /$$$$$$$ |$$    $$ |$$    |   $$ |  $$ |$$ |/    |$$    |   
2479 // $$ |  $$ |$$$$$$$$ |$$$$$/    $$ |  $$ |$$ |$$$$ |$$$$$/    
2480 // $$ \__$$ |$$ |  $$ |$$ |_____ $$ |__$$ |$$ \__$$ |$$ |_____ 
2481 // $$    $$ |$$ |  $$ |$$       |$$    $$/ $$    $$/ $$       |
2482 //  $$$$$$$/ $$/   $$/ $$$$$$$$/ $$$$$$$/   $$$$$$/  $$$$$$$$/ 
2483 //
2484 // dHEDGE DAO - https://dhedge.org
2485 //
2486 // MIT License
2487 // ===========
2488 //
2489 // Copyright (c) 2020 dHEDGE DAO
2490 //
2491 // Permission is hereby granted, free of charge, to any person obtaining a copy
2492 // of this software and associated documentation files (the "Software"), to deal
2493 // in the Software without restriction, including without limitation the rights
2494 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
2495 // copies of the Software, and to permit persons to whom the Software is
2496 // furnished to do so, subject to the following conditions:
2497 //
2498 // The above copyright notice and this permission notice shall be included in all
2499 // copies or substantial portions of the Software.
2500 //
2501 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
2502 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
2503 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
2504 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
2505 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
2506 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
2507 //
2508 
2509 pragma solidity ^0.6.2;
2510 
2511 
2512 
2513 
2514 contract ProxyFactory is OwnableUpgradeSafe, HasLogic {
2515     event ProxyCreated(address proxy);
2516 
2517     address private _logic;
2518 
2519     function __ProxyFactory_init(address poolLogic) public initializer {
2520         OwnableUpgradeSafe.__Ownable_init();
2521 
2522         _logic = poolLogic;
2523     }
2524 
2525     function setLogic(address logic) public onlyOwner {
2526         _logic = logic;
2527     }
2528 
2529     function getLogic() public override view returns (address) {
2530         return _logic;
2531     }
2532 
2533     function deploy(bytes memory _data) public returns (address) {
2534         return _deployProxy(_data);
2535     }
2536 
2537     function _deployProxy(bytes memory _data) internal returns (address) {
2538         InitializableUpgradeabilityProxy proxy = _createProxy();
2539         emit ProxyCreated(address(proxy));
2540         proxy.initialize(address(this), _data);
2541         return address(proxy);
2542     }
2543 
2544     function _createProxy()
2545         internal
2546         returns (InitializableUpgradeabilityProxy)
2547     {
2548         address payable addr;
2549         bytes memory code = type(InitializableUpgradeabilityProxy).creationCode;
2550 
2551         assembly {
2552             addr := create(0, add(code, 0x20), mload(code))
2553             if iszero(extcodesize(addr)) {
2554                 revert(0, 0)
2555             }
2556         }
2557 
2558         return InitializableUpgradeabilityProxy(addr);
2559     }
2560     
2561     uint256[50] private __gap;
2562 }
2563 
2564 // File: contracts/DHedgeFactory.sol
2565 
2566 //
2567 //        __  __    __  ________  _______    ______   ________ 
2568 //       /  |/  |  /  |/        |/       \  /      \ /        |
2569 //   ____$$ |$$ |  $$ |$$$$$$$$/ $$$$$$$  |/$$$$$$  |$$$$$$$$/ 
2570 //  /    $$ |$$ |__$$ |$$ |__    $$ |  $$ |$$ | _$$/ $$ |__    
2571 // /$$$$$$$ |$$    $$ |$$    |   $$ |  $$ |$$ |/    |$$    |   
2572 // $$ |  $$ |$$$$$$$$ |$$$$$/    $$ |  $$ |$$ |$$$$ |$$$$$/    
2573 // $$ \__$$ |$$ |  $$ |$$ |_____ $$ |__$$ |$$ \__$$ |$$ |_____ 
2574 // $$    $$ |$$ |  $$ |$$       |$$    $$/ $$    $$/ $$       |
2575 //  $$$$$$$/ $$/   $$/ $$$$$$$$/ $$$$$$$/   $$$$$$/  $$$$$$$$/ 
2576 //
2577 // dHEDGE DAO - https://dhedge.org
2578 //
2579 // MIT License
2580 // ===========
2581 //
2582 // Copyright (c) 2020 dHEDGE DAO
2583 //
2584 // Permission is hereby granted, free of charge, to any person obtaining a copy
2585 // of this software and associated documentation files (the "Software"), to deal
2586 // in the Software without restriction, including without limitation the rights
2587 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
2588 // copies of the Software, and to permit persons to whom the Software is
2589 // furnished to do so, subject to the following conditions:
2590 //
2591 // The above copyright notice and this permission notice shall be included in all
2592 // copies or substantial portions of the Software.
2593 //
2594 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
2595 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
2596 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
2597 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
2598 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
2599 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
2600 //
2601 
2602 pragma solidity ^0.6.2;
2603 
2604 
2605 
2606 
2607 
2608 
2609 
2610 
2611 
2612 
2613 
2614 
2615 
2616 contract DHedgeFactory is
2617     ProxyFactory,
2618     IHasDaoInfo,
2619     IHasFeeInfo,
2620     IHasAssetInfo,
2621     IHasDhptSwapInfo
2622 {
2623     using SafeMath for uint256;
2624 
2625     event FundCreated(
2626         address fundAddress,
2627         bool isPoolPrivate,
2628         string fundName,
2629         string managerName,
2630         address manager,
2631         uint256 time,
2632         uint256 managerFeeNumerator,
2633         uint256 managerFeeDenominator
2634     );
2635 
2636     event DaoAddressSet(address dao);
2637     event DaoFeeSet(uint256 numerator, uint256 denominator);
2638 
2639     event ExitFeeSet(uint256 numerator, uint256 denominator);
2640     event ExitFeeCooldownSet(uint256 cooldown);
2641 
2642     event MaximumSupportedAssetCountSet(uint256 count);
2643     
2644     event DhptSwapAddressSet(address dhptSwap);
2645 
2646     IAddressResolver public addressResolver;
2647 
2648     address[] public deployedFunds;
2649 
2650     address internal _daoAddress;
2651     uint256 internal _daoFeeNumerator;
2652     uint256 internal _daoFeeDenominator;
2653 
2654     mapping (address => bool) public isPool;
2655 
2656     uint256 private _MAXIMUM_MANAGER_FEE_NUMERATOR;
2657     uint256 private _MANAGER_FEE_DENOMINATOR;
2658     mapping (address => uint256) public poolManagerFeeNumerator;
2659     mapping (address => uint256) public poolManagerFeeDenominator;
2660 
2661     uint256 internal _exitFeeNumerator;
2662     uint256 internal _exitFeeDenominator;
2663     uint256 internal _exitFeeCooldown;
2664 
2665     uint256 internal _maximumSupportedAssetCount;
2666 
2667     bytes32 internal _trackingCode;
2668     
2669     mapping (address => uint256) public poolVersion;
2670     uint256 public poolStorageVersion;
2671 
2672     address internal _dhptSwapAddress;
2673 
2674     uint256 public maximumManagerFeeNumeratorChange;
2675     uint256 public managerFeeNumeratorChangeDelay;
2676 
2677     function initialize(
2678         IAddressResolver _addressResolver,
2679         address _poolLogic,
2680         address daoAddress
2681     ) public initializer {
2682 
2683         ProxyFactory.__ProxyFactory_init(_poolLogic);
2684 
2685         addressResolver = _addressResolver;
2686 
2687         _setDaoAddress(daoAddress);
2688 
2689         _setMaximumManagerFee(5000, 10000);
2690 
2691         _setDaoFee(10, 100); // 10%
2692         _setExitFee(5, 1000); // 0.5%
2693         _setExitFeeCooldown(1 days);
2694 
2695         _setMaximumSupportedAssetCount(10);
2696 
2697         _setTrackingCode(
2698             0x4448454447450000000000000000000000000000000000000000000000000000
2699         );
2700     }
2701 
2702     function createFund(
2703         bool _privatePool,
2704         address _manager,
2705         string memory _managerName,
2706         string memory _fundName,
2707         string memory _fundSymbol,
2708         uint256 _managerFeeNumerator,
2709         bytes32[] memory _supportedAssets
2710     ) public returns (address) {
2711         bytes memory data = abi.encodeWithSignature(
2712             "initialize(address,bool,address,string,string,string,address,bytes32[])",
2713             address(this),
2714             _privatePool,
2715             _manager,
2716             _managerName,
2717             _fundName,
2718             _fundSymbol,
2719             addressResolver,
2720             _supportedAssets
2721         );
2722 
2723         address fund = deploy(data);
2724 
2725         deployedFunds.push(fund);
2726         isPool[fund] = true;
2727 
2728         poolVersion[fund] = poolStorageVersion;
2729 
2730         _setPoolManagerFee(fund, _managerFeeNumerator, _MANAGER_FEE_DENOMINATOR);
2731 
2732         emit FundCreated(
2733             fund,
2734             _privatePool,
2735             _fundName,
2736             _managerName,
2737             _manager,
2738             block.timestamp,
2739             _managerFeeNumerator,
2740             _MANAGER_FEE_DENOMINATOR
2741         );
2742 
2743         return fund;
2744     }
2745 
2746     function deployedFundsLength() external view returns (uint256) {
2747         return deployedFunds.length;
2748     }
2749 
2750     function setAddressResolver(address _addressResolver) public onlyOwner {
2751         addressResolver = IAddressResolver(_addressResolver);
2752     }
2753 
2754     function getAddressResolver() public override view returns (IAddressResolver) {
2755         return addressResolver;
2756     }
2757 
2758     // DAO info
2759 
2760     function getDaoAddress() public override view returns (address) {
2761         return _daoAddress;
2762     }
2763 
2764     function setDaoAddress(address daoAddress) public onlyOwner {
2765         _setDaoAddress(daoAddress);
2766     }
2767 
2768     function _setDaoAddress(address daoAddress) internal {
2769         _daoAddress = daoAddress;
2770 
2771         emit DaoAddressSet(daoAddress);
2772     }
2773     
2774     function setDaoFee(uint256 numerator, uint256 denominator) public onlyOwner {
2775         _setDaoFee(numerator, denominator);
2776     }
2777 
2778     function _setDaoFee(uint256 numerator, uint256 denominator) internal {
2779         require(numerator <= denominator, "invalid fraction");
2780 
2781         _daoFeeNumerator = numerator;
2782         _daoFeeDenominator = denominator;
2783 
2784         emit DaoFeeSet(numerator, denominator);
2785     }
2786 
2787     function getDaoFee() public override view returns (uint256, uint256) {
2788         return (_daoFeeNumerator, _daoFeeDenominator);
2789     }
2790 
2791     modifier onlyPool() {
2792         require(
2793             isPool[msg.sender] == true,
2794             "Only a pool contract can perform this action"
2795         );
2796         _;
2797     }
2798 
2799     // Manager fees
2800 
2801     function getPoolManagerFee(address pool) external override view returns (uint256, uint256) {
2802         require(isPool[pool] == true, "supplied address is not a pool");
2803 
2804         return (poolManagerFeeNumerator[pool], poolManagerFeeDenominator[pool]);
2805     }
2806 
2807     function setPoolManagerFeeNumerator(address pool, uint256 numerator) external override {
2808         require(pool == msg.sender && isPool[msg.sender] == true, "only a pool can change own fee");
2809         require(isPool[pool] == true, "supplied address is not a pool");
2810         require(numerator <= poolManagerFeeNumerator[pool].add(maximumManagerFeeNumeratorChange), "manager fee too high");
2811 
2812         _setPoolManagerFee(msg.sender, numerator, _MANAGER_FEE_DENOMINATOR);
2813     }
2814 
2815     function _setPoolManagerFee(address pool, uint256 numerator, uint256 denominator) internal {
2816         require(numerator <= denominator && numerator <= _MAXIMUM_MANAGER_FEE_NUMERATOR, "invalid fraction");
2817 
2818         poolManagerFeeNumerator[pool] = numerator;
2819         poolManagerFeeDenominator[pool] = denominator;
2820     }
2821 
2822     function getMaximumManagerFee() public view returns (uint256, uint256) {
2823         return (_MAXIMUM_MANAGER_FEE_NUMERATOR, _MANAGER_FEE_DENOMINATOR);
2824     }
2825 
2826     function _setMaximumManagerFee(uint256 numerator, uint256 denominator) internal {
2827         require(denominator > 0, "denominator must be positive");
2828 
2829         _MAXIMUM_MANAGER_FEE_NUMERATOR = numerator;
2830         _MANAGER_FEE_DENOMINATOR = denominator;
2831     }
2832 
2833     function setMaximumManagerFeeNumeratorChange(uint256 amount) public onlyOwner {
2834         maximumManagerFeeNumeratorChange = amount;
2835     }
2836 
2837     function getMaximumManagerFeeNumeratorChange() public override view returns (uint256) {
2838         return maximumManagerFeeNumeratorChange;
2839     }
2840 
2841     function setManagerFeeNumeratorChangeDelay(uint256 delay) public onlyOwner {
2842         managerFeeNumeratorChangeDelay = delay;
2843     }
2844 
2845     function getManagerFeeNumeratorChangeDelay() public override view returns (uint256) {
2846         return managerFeeNumeratorChangeDelay;
2847     }
2848 
2849     // Exit fees
2850 
2851     function setExitFee(uint256 numerator, uint256 denominator) public onlyOwner {
2852         _setExitFee(numerator, denominator);
2853     }
2854 
2855     function _setExitFee(uint256 numerator, uint256 denominator) internal {
2856         require(numerator <= denominator, "invalid fraction");
2857 
2858         _exitFeeNumerator = numerator;
2859         _exitFeeDenominator = denominator;
2860 
2861         emit ExitFeeSet(numerator, denominator);
2862     }
2863 
2864     function getExitFee() external override view returns (uint256, uint256) {
2865         return (_exitFeeNumerator, _exitFeeDenominator);
2866     }
2867 
2868     function setExitFeeCooldown(uint256 cooldown)
2869         external
2870         onlyOwner
2871     {
2872         _setExitFeeCooldown(cooldown);
2873     }
2874 
2875     function _setExitFeeCooldown(uint256 cooldown) internal {
2876         _exitFeeCooldown = cooldown;
2877 
2878         emit ExitFeeCooldownSet(cooldown);
2879     }
2880 
2881     function getExitFeeCooldown() public override view returns (uint256) {
2882         return _exitFeeCooldown;
2883     }
2884 
2885     // Asset Info
2886 
2887     function setMaximumSupportedAssetCount(uint256 count) external onlyOwner {
2888         _setMaximumSupportedAssetCount(count);
2889     }
2890 
2891     function _setMaximumSupportedAssetCount(uint256 count) internal {
2892         _maximumSupportedAssetCount = count;
2893 
2894         emit MaximumSupportedAssetCountSet(count);
2895     }
2896 
2897     function getMaximumSupportedAssetCount() external virtual view override returns (uint256) {
2898         return _maximumSupportedAssetCount;
2899     }
2900 
2901     // Synthetix tracking
2902 
2903     function setTrackingCode(bytes32 code) external onlyOwner {
2904         _setTrackingCode(code);
2905     }
2906 
2907     function _setTrackingCode(bytes32 code) internal {
2908         _trackingCode = code;
2909     }
2910 
2911     function getTrackingCode() public override view returns (bytes32) {
2912         return _trackingCode;
2913     }
2914     
2915     // DHPT Swap
2916 
2917     function getDhptSwapAddress() public override view returns (address) {
2918         return _dhptSwapAddress;
2919     }
2920 
2921     function setDhptSwapAddress(address dhptSwapAddress) public onlyOwner {
2922         _setDhptSwapAddress(dhptSwapAddress);
2923     }
2924 
2925     function _setDhptSwapAddress(address dhptSwapAddress) internal {
2926         _dhptSwapAddress = dhptSwapAddress;
2927 
2928         emit DhptSwapAddressSet(dhptSwapAddress);
2929     }
2930 
2931     // Upgrade
2932 
2933     function _upgradePool(address pool, uint256 targetVersion) internal {
2934         IReceivesUpgrade(pool).receiveUpgrade(targetVersion);
2935 
2936         poolVersion[pool] = targetVersion;
2937     }
2938 
2939     function upgradePoolBatch(uint256 startIndex, uint256 endIndex, uint256 sourceVersion, uint256 targetVersion) external onlyOwner {
2940         require(startIndex <= endIndex && startIndex < deployedFunds.length && endIndex < deployedFunds.length, "invalid bounds");
2941 
2942         for (uint256 i = startIndex; i <= endIndex; i++) {
2943 
2944             address pool = deployedFunds[i];
2945 
2946             if (poolVersion[pool] != sourceVersion)
2947                 continue;
2948 
2949             _upgradePool(pool, targetVersion);
2950 
2951         }
2952     } 
2953 
2954     function setPoolStorageVersion(uint256 version) external onlyOwner {
2955         require(version > poolStorageVersion, "invalid version");
2956 
2957         poolStorageVersion = version;
2958     }
2959 
2960     uint256[48] private __gap;
2961 }