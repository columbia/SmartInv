1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/utils/Pausable.sol
29 
30 
31 
32 pragma solidity ^0.7.0;
33 
34 
35 /**
36  * @dev Contract module which allows children to implement an emergency stop
37  * mechanism that can be triggered by an authorized account.
38  *
39  * This module is used through inheritance. It will make available the
40  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
41  * the functions of your contract. Note that they will not be pausable by
42  * simply including this module, only once the modifiers are put in place.
43  */
44 abstract contract Pausable is Context {
45     /**
46      * @dev Emitted when the pause is triggered by `account`.
47      */
48     event Paused(address account);
49 
50     /**
51      * @dev Emitted when the pause is lifted by `account`.
52      */
53     event Unpaused(address account);
54 
55     bool private _paused;
56 
57     /**
58      * @dev Initializes the contract in unpaused state.
59      */
60     constructor () {
61         _paused = false;
62     }
63 
64     /**
65      * @dev Returns true if the contract is paused, and false otherwise.
66      */
67     function paused() public view virtual returns (bool) {
68         return _paused;
69     }
70 
71     /**
72      * @dev Modifier to make a function callable only when the contract is not paused.
73      *
74      * Requirements:
75      *
76      * - The contract must not be paused.
77      */
78     modifier whenNotPaused() {
79         require(!paused(), "Pausable: paused");
80         _;
81     }
82 
83     /**
84      * @dev Modifier to make a function callable only when the contract is paused.
85      *
86      * Requirements:
87      *
88      * - The contract must be paused.
89      */
90     modifier whenPaused() {
91         require(paused(), "Pausable: not paused");
92         _;
93     }
94 
95     /**
96      * @dev Triggers stopped state.
97      *
98      * Requirements:
99      *
100      * - The contract must not be paused.
101      */
102     function _pause() internal virtual whenNotPaused {
103         _paused = true;
104         emit Paused(_msgSender());
105     }
106 
107     /**
108      * @dev Returns to normal state.
109      *
110      * Requirements:
111      *
112      * - The contract must be paused.
113      */
114     function _unpause() internal virtual whenPaused {
115         _paused = false;
116         emit Unpaused(_msgSender());
117     }
118 }
119 
120 // File: contracts/Container.sol
121 
122 
123 pragma solidity ^0.7.0;
124 
125 contract Container {
126     struct Item {
127         uint256 itemType;
128         uint256 status;
129         address[] addresses;
130     }
131 
132     uint256 MaxItemAddressNum = 255;
133     mapping(bytes32 => Item) private container;
134 
135     function itemAddressExists(bytes32 _id, address _oneAddress) internal view returns (bool) {
136         for (uint256 i = 0; i < container[_id].addresses.length; i++) {
137             if (container[_id].addresses[i] == _oneAddress)
138                 return true;
139         }
140         return false;
141     }
142 
143     function getItemAddresses(bytes32 _id) internal view returns (address[] memory) {
144         return container[_id].addresses;
145     }
146 
147     function getItemInfo(bytes32 _id) internal view returns (uint256, uint256, uint256) {
148         return (container[_id].itemType, container[_id].status, container[_id].addresses.length);
149     }
150 
151     function getItemAddressCount(bytes32 _id) internal view returns (uint256) {
152         return container[_id].addresses.length;
153     }
154 
155     function setItemInfo(bytes32 _id, uint256 _itemType, uint256 _status) internal {
156         container[_id].itemType = _itemType;
157         container[_id].status = _status;
158     }
159 
160     function addItemAddress(bytes32 _id, address _oneAddress) internal {
161         require(!itemAddressExists(_id, _oneAddress), "Container:dup address added");
162         require(container[_id].addresses.length < MaxItemAddressNum, "Container:too many addresses");
163         container[_id].addresses.push(_oneAddress);
164     }
165 
166     function removeItemAddresses(bytes32 _id) internal {
167         delete container[_id].addresses;
168     }
169 
170     function removeOneItemAddress(bytes32 _id, address _oneAddress) internal {
171         for (uint256 i = 0; i < container[_id].addresses.length; i++) {
172             if (container[_id].addresses[i] == _oneAddress) {
173                 container[_id].addresses[i] = container[_id].addresses[container[_id].addresses.length - 1];
174                 container[_id].addresses.pop();
175                 return;
176             }
177         }
178     }
179 
180     function removeItem(bytes32 _id) internal {
181         delete container[_id];
182     }
183 
184     function replaceItemAddress(bytes32 _id, address _oneAddress, address _anotherAddress) internal {
185         for (uint256 i = 0; i < container[_id].addresses.length; i++) {
186             if (container[_id].addresses[i] == _oneAddress) {
187                 container[_id].addresses[i] = _anotherAddress;
188                 return;
189             }
190         }
191     }
192 
193 }
194 
195 // File: contracts/BridgeAdmin.sol
196 
197 
198 pragma solidity ^0.7.0;
199 
200 
201 contract BridgeAdmin is Container {
202     bytes32 internal constant OWNERHASH = 0x02016836a56b71f0d02689e69e326f4f4c1b9057164ef592671cf0d37c8040c0;
203     bytes32 internal constant OPERATORHASH = 0x46a52cf33029de9f84853745a87af28464c80bf0346df1b32e205fc73319f622;
204     bytes32 internal constant PAUSERHASH = 0x0cc58340b26c619cd4edc70f833d3f4d9d26f3ae7d5ef2965f81fe5495049a4f;
205     bytes32 internal constant STOREHASH = 0xe41d88711b08bdcd7556c5d2d24e0da6fa1f614cf2055f4d7e10206017cd1680;
206     bytes32 internal constant LOGICHASH = 0x397bc5b97f629151e68146caedba62f10b47e426b38db589771a288c0861f182;
207     uint256 internal constant MAXUSERNUM = 255;
208     bytes32[] private classHashArray;
209 
210     uint256 internal ownerRequireNum;
211     uint256 internal operatorRequireNum;
212 
213     event AdminChanged(string TaskType, string class, address oldAddress, address newAddress);
214     event AdminRequiredNumChanged(string TaskType, string class, uint256 previousNum, uint256 requiredNum);
215     event AdminTaskDropped(bytes32 taskHash);
216 
217     modifier validRequirement(uint ownerCount, uint _required) {
218         require(ownerCount <= MaxItemAddressNum && _required <= ownerCount && _required > 0 && ownerCount > 0);
219         _;
220     }
221 
222     modifier onlyOwner() {
223         require(itemAddressExists(OWNERHASH, msg.sender), "BridgeAdmin:only use owner to call");
224         _;
225     }
226 
227     function initAdmin(address[] memory _owners, uint _ownerRequired) internal validRequirement(_owners.length, _ownerRequired) {
228         for (uint i = 0; i < _owners.length; i++) {
229             addItemAddress(OWNERHASH, _owners[i]);
230         }
231         addItemAddress(PAUSERHASH, _owners[0]);
232         // we need an init pauser
233         addItemAddress(LOGICHASH, address(0x0));
234         addItemAddress(STOREHASH, address(0x1));
235 
236         classHashArray.push(OWNERHASH);
237         classHashArray.push(OPERATORHASH);
238         classHashArray.push(PAUSERHASH);
239         classHashArray.push(STOREHASH);
240         classHashArray.push(LOGICHASH);
241         ownerRequireNum = _ownerRequired;
242         operatorRequireNum = 2;
243     }
244 
245     function classHashExist(bytes32 aHash) private view returns (bool) {
246         for (uint256 i = 0; i < classHashArray.length; i++)
247             if (classHashArray[i] == aHash) return true;
248         return false;
249     }
250 
251     function getAdminAddresses(string memory class) public view returns (address[] memory) {
252         bytes32 classHash = getClassHash(class);
253         return getItemAddresses(classHash);
254     }
255 
256     function getOwnerRequireNum() public view returns (uint256) {
257         return ownerRequireNum;
258     }
259 
260     function getOperatorRequireNum() public view returns (uint256) {
261         return operatorRequireNum;
262     }
263 
264     function resetRequiredNum(string memory class, uint256 requiredNum) public onlyOwner returns (bool) {
265         bytes32 classHash = getClassHash(class);
266         require((classHash == OPERATORHASH) || (classHash == OWNERHASH), "BridgeAdmin:wrong class");
267 
268         bytes32 taskHash = keccak256(abi.encodePacked("resetRequiredNum", class, requiredNum));
269         addItemAddress(taskHash, msg.sender);
270 
271         if (getItemAddressCount(taskHash) >= ownerRequireNum) {
272             removeItem(taskHash);
273             uint256 previousNum = 0;
274             if (classHash == OWNERHASH) {
275                 require(getItemAddressCount(classHash) >= requiredNum, "BridgeAdmin:insufficiency addresses");
276                 previousNum = ownerRequireNum;
277                 ownerRequireNum = requiredNum;
278             }
279             else if (classHash == OPERATORHASH) {
280                 previousNum = operatorRequireNum;
281                 operatorRequireNum = requiredNum;
282             } else {
283                 revert("BridgeAdmin:wrong class");
284             }
285             emit AdminRequiredNumChanged("resetRequiredNum", class, previousNum, requiredNum);
286         }
287         return true;
288     }
289 
290     function modifyAddress(string memory class, address oldAddress, address newAddress) internal onlyOwner returns (bool) {
291         bytes32 classHash = getClassHash(class);
292         bytes32 taskHash = keccak256(abi.encodePacked("modifyAddress", class, oldAddress, newAddress));
293         addItemAddress(taskHash, msg.sender);
294         if (getItemAddressCount(taskHash) >= ownerRequireNum) {
295             replaceItemAddress(classHash, oldAddress, newAddress);
296             emit AdminChanged("modifyAddress", class, oldAddress, newAddress);
297             removeItem(taskHash);
298             return true;
299         }
300         return false;
301     }
302 
303     function getClassHash(string memory class) private view returns (bytes32) {
304         bytes32 classHash = keccak256(abi.encodePacked(class));
305         require(classHashExist(classHash), "BridgeAdmin:invalid class");
306         return classHash;
307     }
308 
309     function dropAddress(string memory class, address oneAddress) public onlyOwner returns (bool) {
310         bytes32 classHash = getClassHash(class);
311         require(classHash != STOREHASH && classHash != LOGICHASH, "BridgeAdmin:wrong class");
312         require(itemAddressExists(classHash, oneAddress), "BridgeAdmin:no such address exists");
313 
314         if (classHash == OWNERHASH)
315             require(getItemAddressCount(classHash) > ownerRequireNum, "BridgeAdmin:insufficiency addresses");
316 
317         bytes32 taskHash = keccak256(abi.encodePacked("dropAddress", class, oneAddress));
318         addItemAddress(taskHash, msg.sender);
319         if (getItemAddressCount(taskHash) >= ownerRequireNum) {
320             removeOneItemAddress(classHash, oneAddress);
321             emit AdminChanged("dropAddress", class, oneAddress, oneAddress);
322             removeItem(taskHash);
323             return true;
324         }
325         return false;
326     }
327 
328     function addAddress(string memory class, address oneAddress) public onlyOwner returns (bool) {
329         bytes32 classHash = getClassHash(class);
330         require(classHash != STOREHASH && classHash != LOGICHASH, "BridgeAdmin:wrong class");
331 
332         bytes32 taskHash = keccak256(abi.encodePacked("addAddress", class, oneAddress));
333         addItemAddress(taskHash, msg.sender);
334         if (getItemAddressCount(taskHash) >= ownerRequireNum) {
335             addItemAddress(classHash, oneAddress);
336             emit AdminChanged("addAddress", class, oneAddress, oneAddress);
337             removeItem(taskHash);
338             return true;
339         }
340         return false;
341     }
342 
343     function dropTask(bytes32 taskHash) public onlyOwner returns (bool) {
344         removeItem(taskHash);
345         emit AdminTaskDropped(taskHash);
346         return true;
347     }
348 
349 }
350 
351 // File: @openzeppelin/contracts/math/SafeMath.sol
352 
353 
354 
355 pragma solidity ^0.7.0;
356 
357 /**
358  * @dev Wrappers over Solidity's arithmetic operations with added overflow
359  * checks.
360  *
361  * Arithmetic operations in Solidity wrap on overflow. This can easily result
362  * in bugs, because programmers usually assume that an overflow raises an
363  * error, which is the standard behavior in high level programming languages.
364  * `SafeMath` restores this intuition by reverting the transaction when an
365  * operation overflows.
366  *
367  * Using this library instead of the unchecked operations eliminates an entire
368  * class of bugs, so it's recommended to use it always.
369  */
370 library SafeMath {
371     /**
372      * @dev Returns the addition of two unsigned integers, with an overflow flag.
373      *
374      * _Available since v3.4._
375      */
376     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
377         uint256 c = a + b;
378         if (c < a) return (false, 0);
379         return (true, c);
380     }
381 
382     /**
383      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
384      *
385      * _Available since v3.4._
386      */
387     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
388         if (b > a) return (false, 0);
389         return (true, a - b);
390     }
391 
392     /**
393      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
394      *
395      * _Available since v3.4._
396      */
397     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
398         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
399         // benefit is lost if 'b' is also tested.
400         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
401         if (a == 0) return (true, 0);
402         uint256 c = a * b;
403         if (c / a != b) return (false, 0);
404         return (true, c);
405     }
406 
407     /**
408      * @dev Returns the division of two unsigned integers, with a division by zero flag.
409      *
410      * _Available since v3.4._
411      */
412     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
413         if (b == 0) return (false, 0);
414         return (true, a / b);
415     }
416 
417     /**
418      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
419      *
420      * _Available since v3.4._
421      */
422     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
423         if (b == 0) return (false, 0);
424         return (true, a % b);
425     }
426 
427     /**
428      * @dev Returns the addition of two unsigned integers, reverting on
429      * overflow.
430      *
431      * Counterpart to Solidity's `+` operator.
432      *
433      * Requirements:
434      *
435      * - Addition cannot overflow.
436      */
437     function add(uint256 a, uint256 b) internal pure returns (uint256) {
438         uint256 c = a + b;
439         require(c >= a, "SafeMath: addition overflow");
440         return c;
441     }
442 
443     /**
444      * @dev Returns the subtraction of two unsigned integers, reverting on
445      * overflow (when the result is negative).
446      *
447      * Counterpart to Solidity's `-` operator.
448      *
449      * Requirements:
450      *
451      * - Subtraction cannot overflow.
452      */
453     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
454         require(b <= a, "SafeMath: subtraction overflow");
455         return a - b;
456     }
457 
458     /**
459      * @dev Returns the multiplication of two unsigned integers, reverting on
460      * overflow.
461      *
462      * Counterpart to Solidity's `*` operator.
463      *
464      * Requirements:
465      *
466      * - Multiplication cannot overflow.
467      */
468     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
469         if (a == 0) return 0;
470         uint256 c = a * b;
471         require(c / a == b, "SafeMath: multiplication overflow");
472         return c;
473     }
474 
475     /**
476      * @dev Returns the integer division of two unsigned integers, reverting on
477      * division by zero. The result is rounded towards zero.
478      *
479      * Counterpart to Solidity's `/` operator. Note: this function uses a
480      * `revert` opcode (which leaves remaining gas untouched) while Solidity
481      * uses an invalid opcode to revert (consuming all remaining gas).
482      *
483      * Requirements:
484      *
485      * - The divisor cannot be zero.
486      */
487     function div(uint256 a, uint256 b) internal pure returns (uint256) {
488         require(b > 0, "SafeMath: division by zero");
489         return a / b;
490     }
491 
492     /**
493      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
494      * reverting when dividing by zero.
495      *
496      * Counterpart to Solidity's `%` operator. This function uses a `revert`
497      * opcode (which leaves remaining gas untouched) while Solidity uses an
498      * invalid opcode to revert (consuming all remaining gas).
499      *
500      * Requirements:
501      *
502      * - The divisor cannot be zero.
503      */
504     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
505         require(b > 0, "SafeMath: modulo by zero");
506         return a % b;
507     }
508 
509     /**
510      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
511      * overflow (when the result is negative).
512      *
513      * CAUTION: This function is deprecated because it requires allocating memory for the error
514      * message unnecessarily. For custom revert reasons use {trySub}.
515      *
516      * Counterpart to Solidity's `-` operator.
517      *
518      * Requirements:
519      *
520      * - Subtraction cannot overflow.
521      */
522     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
523         require(b <= a, errorMessage);
524         return a - b;
525     }
526 
527     /**
528      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
529      * division by zero. The result is rounded towards zero.
530      *
531      * CAUTION: This function is deprecated because it requires allocating memory for the error
532      * message unnecessarily. For custom revert reasons use {tryDiv}.
533      *
534      * Counterpart to Solidity's `/` operator. Note: this function uses a
535      * `revert` opcode (which leaves remaining gas untouched) while Solidity
536      * uses an invalid opcode to revert (consuming all remaining gas).
537      *
538      * Requirements:
539      *
540      * - The divisor cannot be zero.
541      */
542     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
543         require(b > 0, errorMessage);
544         return a / b;
545     }
546 
547     /**
548      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
549      * reverting with custom message when dividing by zero.
550      *
551      * CAUTION: This function is deprecated because it requires allocating memory for the error
552      * message unnecessarily. For custom revert reasons use {tryMod}.
553      *
554      * Counterpart to Solidity's `%` operator. This function uses a `revert`
555      * opcode (which leaves remaining gas untouched) while Solidity uses an
556      * invalid opcode to revert (consuming all remaining gas).
557      *
558      * Requirements:
559      *
560      * - The divisor cannot be zero.
561      */
562     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
563         require(b > 0, errorMessage);
564         return a % b;
565     }
566 }
567 
568 // File: contracts/BridgeStorage.sol
569 
570 
571 pragma solidity ^0.7.0;
572 
573 
574 contract BridgeStorage is Container {
575     string public constant name = "BridgeStorage";
576 
577     address private caller;
578 
579     constructor(address aCaller) {
580         caller = aCaller;
581     }
582 
583     modifier onlyCaller() {
584         require(msg.sender == caller, "BridgeStorage:only use main contract to call");
585         _;
586     }
587 
588     function supporterExists(bytes32 taskHash, address user) public view returns (bool) {
589         return itemAddressExists(taskHash, user);
590     }
591 
592     function setTaskInfo(bytes32 taskHash, uint256 taskType, uint256 status) external onlyCaller {
593         setItemInfo(taskHash, taskType, status);
594     }
595 
596     function getTaskInfo(bytes32 taskHash) public view returns (uint256, uint256, uint256) {
597         return getItemInfo(taskHash);
598     }
599 
600     function addSupporter(bytes32 taskHash, address oneAddress) external onlyCaller {
601         addItemAddress(taskHash, oneAddress);
602     }
603 
604     function removeAllSupporter(bytes32 taskHash) external onlyCaller {
605         removeItemAddresses(taskHash);
606     }
607 
608     function removeTask(bytes32 taskHash) external onlyCaller {
609         removeItem(taskHash);
610     }
611 
612 }
613 
614 // File: contracts/BridgeLogic.sol
615 
616 
617 pragma solidity ^0.7.0;
618 
619 
620 
621 contract BridgeLogic {
622     using SafeMath for uint256;
623 
624     string public constant name = "BridgeLogic";
625 
626     bytes32 internal constant OPERATORHASH = 0x46a52cf33029de9f84853745a87af28464c80bf0346df1b32e205fc73319f622;
627     uint256 public constant TASKINIT = 0;
628     uint256 public constant TASKPROCESSING = 1;
629     uint256 public constant TASKCANCELLED = 2;
630     uint256 public constant TASKDONE = 3;
631     uint256 public constant WITHDRAWTASK = 1;
632 
633     address private caller;
634     BridgeStorage private store;
635 
636     constructor(address aCaller) {
637         caller = aCaller;
638     }
639 
640     modifier onlyCaller() {
641         require(msg.sender == caller, "BridgeLogic:only use main contract to call");
642         _;
643     }
644 
645     modifier operatorExists(address operator) {
646         require(store.supporterExists(OPERATORHASH, operator), "BridgeLogic:wrong operator");
647         _;
648     }
649 
650     function resetStoreLogic(address storeAddress) external onlyCaller {
651         store = BridgeStorage(storeAddress);
652     }
653 
654     function getStoreAddress() public view returns (address) {
655         return address(store);
656     }
657 
658     function supportTask(uint256 taskType, bytes32 taskHash, address oneAddress, uint256 requireNum) external onlyCaller returns (uint256) {
659         require(!store.supporterExists(taskHash, oneAddress), "BridgeLogic:supporter already exists");
660         (uint256 theTaskType,uint256 theTaskStatus,uint256 theSupporterNum) = store.getTaskInfo(taskHash);
661         require(theTaskStatus < TASKDONE, "BridgeLogic:wrong status");
662 
663         if (theTaskStatus != TASKINIT)
664             require(theTaskType == taskType, "BridgeLogic:task type not match");
665         store.addSupporter(taskHash, oneAddress);
666         theSupporterNum++;
667         if (theSupporterNum >= requireNum)
668             theTaskStatus = TASKDONE;
669         else
670             theTaskStatus = TASKPROCESSING;
671         store.setTaskInfo(taskHash, taskType, theTaskStatus);
672         return theTaskStatus;
673     }
674 
675     function cancelTask(bytes32 taskHash) external onlyCaller returns (uint256) {
676         (uint256 theTaskType,uint256 theTaskStatus,uint256 theSupporterNum) = store.getTaskInfo(taskHash);
677         require(theTaskStatus == TASKPROCESSING, "BridgeLogic:wrong status");
678         if (theSupporterNum > 0) store.removeAllSupporter(taskHash);
679         theTaskStatus = TASKCANCELLED;
680         store.setTaskInfo(taskHash, theTaskType, theTaskStatus);
681         return theTaskStatus;
682     }
683 
684     function removeTask(bytes32 taskHash) external onlyCaller {
685         store.removeTask(taskHash);
686     }
687 
688 }
689 
690 // File: contracts/Bridge.sol
691 
692 
693 pragma solidity ^0.7.0;
694 
695 
696 
697 
698 contract Bridge is BridgeAdmin, Pausable {
699     using SafeMath for uint256;
700 
701     string public constant name = "Bridge";
702 
703     BridgeLogic private logic;
704     uint256 public swapFee;
705     address public feeTo;
706 
707     struct assetSelector {
708         string selector;
709         bool isValueFirst;
710     }
711 
712     mapping(address => assetSelector)  public depositSelector;
713     mapping(address => assetSelector) public withdrawSelector;
714     mapping(bytes32 => bool) public filledTx;
715 
716     event FeeToTransferred(address indexed previousFeeTo, address indexed newFeeTo);
717     event SwapFeeChanged(uint256 indexed previousSwapFee, uint256 indexed newSwapFee);
718     event DepositNative(address indexed from, uint256 value, string targetAddress, string chain, uint256 feeValue);
719     event DepositToken(address indexed from, uint256 value, address indexed token, string targetAddress, string chain, uint256 feeValue);
720     event WithdrawingNative(address indexed to, uint256 value, string proof);
721     event WithdrawingToken(address indexed to, address indexed token, uint256 value, string proof);
722     event WithdrawDoneNative(address indexed to, uint256 value, string proof);
723     event WithdrawDoneToken(address indexed to, address indexed token, uint256 value, string proof);
724 
725     modifier onlyOperator() {
726         require(itemAddressExists(OPERATORHASH, msg.sender), "Bridge:wrong operator");
727         _;
728     }
729 
730     modifier onlyPauser() {
731         require(itemAddressExists(PAUSERHASH, msg.sender), "Bridge:wrong pauser");
732         _;
733     }
734 
735     modifier positiveValue(uint _value) {
736         require(_value > 0, "Bridge:value need > 0");
737         _;
738     }
739 
740     constructor(address[] memory _owners, uint _ownerRequired) {
741         initAdmin(_owners, _ownerRequired);
742     }
743 
744     function depositNative(string memory _targetAddress, string memory chain) public payable {
745         require(msg.value >= swapFee, "Bridge:insufficient swap fee");
746         if (swapFee != 0) {
747             payable(feeTo).transfer(swapFee);
748         }
749         emit DepositNative(msg.sender, msg.value - swapFee, _targetAddress, chain, swapFee);
750     }
751 
752     function depositToken(address _token, uint value, string memory _targetAddress, string memory chain) public payable returns (bool) {
753         require(msg.value == swapFee, "Bridge:swap fee not equal");
754         if (swapFee != 0) {
755             payable(feeTo).transfer(swapFee);
756         }
757 
758         bool res = depositTokenLogic(_token, msg.sender, value);
759         emit DepositToken(msg.sender, value, _token, _targetAddress, chain, swapFee);
760         return res;
761     }
762 
763     function withdrawNative(address payable to, uint value, string memory proof, bytes32 taskHash) public
764     onlyOperator
765     whenNotPaused
766     positiveValue(value)
767     returns (bool)
768     {
769         require(address(this).balance >= value, "Bridge:not enough native token");
770         require(taskHash == keccak256((abi.encodePacked(to, value, proof))), "Bridge:taskHash is wrong");
771         require(!filledTx[taskHash], "Bridge:tx filled already");
772         uint256 status = logic.supportTask(logic.WITHDRAWTASK(), taskHash, msg.sender, operatorRequireNum);
773 
774         if (status == logic.TASKPROCESSING()) {
775             emit WithdrawingNative(to, value, proof);
776         } else if (status == logic.TASKDONE()) {
777             emit WithdrawingNative(to, value, proof);
778             emit WithdrawDoneNative(to, value, proof);
779             to.transfer(value);
780             filledTx[taskHash] = true;
781             logic.removeTask(taskHash);
782         }
783         return true;
784     }
785 
786     function withdrawToken(address _token, address to, uint value, string memory proof, bytes32 taskHash) public
787     onlyOperator
788     whenNotPaused
789     positiveValue(value)
790     returns (bool)
791     {
792         require(taskHash == keccak256((abi.encodePacked(to, value, proof))), "Bridge:taskHash is wrong");
793         require(!filledTx[taskHash], "Bridge:tx filled already");
794         uint256 status = logic.supportTask(logic.WITHDRAWTASK(), taskHash, msg.sender, operatorRequireNum);
795 
796         if (status == logic.TASKPROCESSING()) {
797             emit WithdrawingToken(to, _token, value, proof);
798         } else if (status == logic.TASKDONE()) {
799             bool res = withdrawTokenLogic(_token, to, value);
800 
801             emit WithdrawingToken(to, _token, value, proof);
802             emit WithdrawDoneToken(to, _token, value, proof);
803             filledTx[taskHash] = true;
804             logic.removeTask(taskHash);
805             return res;
806         }
807         return true;
808     }
809 
810     function modifyAdminAddress(string memory class, address oldAddress, address newAddress) public whenPaused {
811         require(newAddress != address(0x0), "Bridge:wrong address");
812         bool flag = modifyAddress(class, oldAddress, newAddress);
813         if (flag) {
814             bytes32 classHash = keccak256(abi.encodePacked(class));
815             if (classHash == LOGICHASH) {
816                 logic = BridgeLogic(newAddress);
817             } else if (classHash == STOREHASH) {
818                 logic.resetStoreLogic(newAddress);
819             }
820         }
821     }
822 
823     function getLogicAddress() public view returns (address) {
824         return address(logic);
825     }
826 
827     function getStoreAddress() public view returns (address) {
828         return logic.getStoreAddress();
829     }
830 
831     function pause() public onlyPauser {
832         _pause();
833     }
834 
835     function unpause() public onlyPauser {
836         _unpause();
837     }
838 
839     function setDepositSelector(address token, string memory method, bool _isValueFirst) onlyOperator external {
840         depositSelector[token] = assetSelector(method, _isValueFirst);
841     }
842 
843     function setWithdrawSelector(address token, string memory method, bool _isValueFirst) onlyOperator external {
844         withdrawSelector[token] = assetSelector(method, _isValueFirst);
845     }
846 
847     function setSwapFee(uint256 _swapFee) onlyOwner external {
848         emit SwapFeeChanged(swapFee, _swapFee);
849         swapFee = _swapFee;
850     }
851 
852     function setFeeTo(address _feeTo) onlyOwner external {
853         emit FeeToTransferred(feeTo, _feeTo);
854         feeTo = _feeTo;
855     }
856 
857     function depositTokenLogic(address token, address _from, uint256 _value) internal returns (bool) {
858         bool status = false;
859         bytes memory returnedData;
860         if (bytes(depositSelector[token].selector).length == 0) {
861             (status, returnedData) = token.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", _from, this, _value));
862         }
863         else {
864             assetSelector memory aselector = depositSelector[token];
865             if (aselector.isValueFirst) {
866                 (status, returnedData) = token.call(abi.encodeWithSignature(aselector.selector, _value, _from));
867             }
868             else {
869                 (status, returnedData) = token.call(abi.encodeWithSignature(aselector.selector, _from, _value));
870             }
871         }
872         require(status && (returnedData.length == 0 || abi.decode(returnedData, (bool))), 'Bridge:deposit failed');
873         return true;
874     }
875 
876     function withdrawTokenLogic(address token, address _to, uint256 _value) internal returns (bool) {
877         bool status = false;
878         bytes memory returnedData;
879         if (bytes(withdrawSelector[token].selector).length == 0) {
880             (status, returnedData) = token.call(abi.encodeWithSignature("transfer(address,uint256)", _to, _value));
881         }
882         else {
883             assetSelector memory aselector = withdrawSelector[token];
884             if (aselector.isValueFirst) {
885                 (status, returnedData) = token.call(abi.encodeWithSignature(aselector.selector, _value, _to));
886             }
887             else {
888                 (status, returnedData) = token.call(abi.encodeWithSignature(aselector.selector, _to, _value));
889             }
890         }
891 
892         require(status && (returnedData.length == 0 || abi.decode(returnedData, (bool))), 'Bridge:withdraw failed');
893         return true;
894     }
895 
896 }