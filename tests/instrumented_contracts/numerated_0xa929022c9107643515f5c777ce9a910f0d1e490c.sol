1 // Sources flattened with hardhat v2.0.7 https://hardhat.org
2 
3 // File @openzeppelin/contracts/math/SafeMath.sol@v3.3.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, reverting on
25      * overflow.
26      *
27      * Counterpart to Solidity's `+` operator.
28      *
29      * Requirements:
30      *
31      * - Addition cannot overflow.
32      */
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36 
37         return c;
38     }
39 
40     /**
41      * @dev Returns the subtraction of two unsigned integers, reverting on
42      * overflow (when the result is negative).
43      *
44      * Counterpart to Solidity's `-` operator.
45      *
46      * Requirements:
47      *
48      * - Subtraction cannot overflow.
49      */
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         return sub(a, b, "SafeMath: subtraction overflow");
52     }
53 
54     /**
55      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
56      * overflow (when the result is negative).
57      *
58      * Counterpart to Solidity's `-` operator.
59      *
60      * Requirements:
61      *
62      * - Subtraction cannot overflow.
63      */
64     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     /**
72      * @dev Returns the multiplication of two unsigned integers, reverting on
73      * overflow.
74      *
75      * Counterpart to Solidity's `*` operator.
76      *
77      * Requirements:
78      *
79      * - Multiplication cannot overflow.
80      */
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83         // benefit is lost if 'b' is also tested.
84         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b, "SafeMath: multiplication overflow");
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the integer division of two unsigned integers. Reverts on
97      * division by zero. The result is rounded towards zero.
98      *
99      * Counterpart to Solidity's `/` operator. Note: this function uses a
100      * `revert` opcode (which leaves remaining gas untouched) while Solidity
101      * uses an invalid opcode to revert (consuming all remaining gas).
102      *
103      * Requirements:
104      *
105      * - The divisor cannot be zero.
106      */
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, "SafeMath: division by zero");
109     }
110 
111     /**
112      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
113      * division by zero. The result is rounded towards zero.
114      *
115      * Counterpart to Solidity's `/` operator. Note: this function uses a
116      * `revert` opcode (which leaves remaining gas untouched) while Solidity
117      * uses an invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      *
121      * - The divisor cannot be zero.
122      */
123     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
133      * Reverts when dividing by zero.
134      *
135      * Counterpart to Solidity's `%` operator. This function uses a `revert`
136      * opcode (which leaves remaining gas untouched) while Solidity uses an
137      * invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
144         return mod(a, b, "SafeMath: modulo by zero");
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * Reverts with custom message when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b != 0, errorMessage);
161         return a % b;
162     }
163 }
164 
165 
166 // File @openzeppelin/contracts/GSN/Context.sol@v3.3.0
167 
168 
169 
170 pragma solidity >=0.6.0 <0.8.0;
171 
172 /*
173  * @dev Provides information about the current execution context, including the
174  * sender of the transaction and its data. While these are generally available
175  * via msg.sender and msg.data, they should not be accessed in such a direct
176  * manner, since when dealing with GSN meta-transactions the account sending and
177  * paying for execution may not be the actual sender (as far as an application
178  * is concerned).
179  *
180  * This contract is only required for intermediate, library-like contracts.
181  */
182 abstract contract Context {
183     function _msgSender() internal view virtual returns (address payable) {
184         return msg.sender;
185     }
186 
187     function _msgData() internal view virtual returns (bytes memory) {
188         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
189         return msg.data;
190     }
191 }
192 
193 
194 // File @openzeppelin/contracts/utils/Pausable.sol@v3.3.0
195 
196 
197 
198 pragma solidity >=0.6.0 <0.8.0;
199 
200 /**
201  * @dev Contract module which allows children to implement an emergency stop
202  * mechanism that can be triggered by an authorized account.
203  *
204  * This module is used through inheritance. It will make available the
205  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
206  * the functions of your contract. Note that they will not be pausable by
207  * simply including this module, only once the modifiers are put in place.
208  */
209 abstract contract Pausable is Context {
210     /**
211      * @dev Emitted when the pause is triggered by `account`.
212      */
213     event Paused(address account);
214 
215     /**
216      * @dev Emitted when the pause is lifted by `account`.
217      */
218     event Unpaused(address account);
219 
220     bool private _paused;
221 
222     /**
223      * @dev Initializes the contract in unpaused state.
224      */
225     constructor () internal {
226         _paused = false;
227     }
228 
229     /**
230      * @dev Returns true if the contract is paused, and false otherwise.
231      */
232     function paused() public view returns (bool) {
233         return _paused;
234     }
235 
236     /**
237      * @dev Modifier to make a function callable only when the contract is not paused.
238      *
239      * Requirements:
240      *
241      * - The contract must not be paused.
242      */
243     modifier whenNotPaused() {
244         require(!_paused, "Pausable: paused");
245         _;
246     }
247 
248     /**
249      * @dev Modifier to make a function callable only when the contract is paused.
250      *
251      * Requirements:
252      *
253      * - The contract must be paused.
254      */
255     modifier whenPaused() {
256         require(_paused, "Pausable: not paused");
257         _;
258     }
259 
260     /**
261      * @dev Triggers stopped state.
262      *
263      * Requirements:
264      *
265      * - The contract must not be paused.
266      */
267     function _pause() internal virtual whenNotPaused {
268         _paused = true;
269         emit Paused(_msgSender());
270     }
271 
272     /**
273      * @dev Returns to normal state.
274      *
275      * Requirements:
276      *
277      * - The contract must be paused.
278      */
279     function _unpause() internal virtual whenPaused {
280         _paused = false;
281         emit Unpaused(_msgSender());
282     }
283 }
284 
285 
286 // File contracts/Container.sol
287 
288 
289 pragma solidity ^0.7.0;
290 
291 contract Container {
292 
293     struct Item{
294         uint256 itemType;
295         uint256 status;
296         address[] addresses;
297     }
298 
299     uint256 MaxItemAdressNum = 255;
300     mapping (bytes32 => Item) private container;
301     // bool private _nativePaused = false;
302 
303 
304     function itemAddressExists(bytes32 _id, address _oneAddress) internal view returns(bool){
305         for(uint256 i = 0; i < container[_id].addresses.length; i++){
306             if(container[_id].addresses[i] == _oneAddress)
307                 return true;
308         }
309         return false;
310     }
311     function getItemAddresses(bytes32 _id) internal view returns(address[] memory){
312         return container[_id].addresses;
313     }
314 
315     function getItemInfo(bytes32 _id) internal view returns(uint256, uint256, uint256){
316         return (container[_id].itemType, container[_id].status, container[_id].addresses.length);
317     }
318 
319     function getItemAddressCount(bytes32 _id) internal view returns(uint256){
320         return container[_id].addresses.length;
321     }
322 
323     function setItemInfo(bytes32 _id, uint256 _itemType, uint256 _status) internal{
324         container[_id].itemType = _itemType;
325         container[_id].status = _status;
326     }
327 
328     function addItemAddress(bytes32 _id, address _oneAddress) internal{
329         require(!itemAddressExists(_id, _oneAddress), "dup address added");
330         require(container[_id].addresses.length < MaxItemAdressNum, "too many addresses");
331         container[_id].addresses.push(_oneAddress);
332     }
333     function removeItemAddresses(bytes32 _id) internal {
334         delete container[_id].addresses;
335     }
336 
337     function removeOneItemAddress(bytes32 _id, address _oneAddress) internal {
338         for(uint256 i = 0; i < container[_id].addresses.length; i++){
339             if(container[_id].addresses[i] == _oneAddress){
340                 container[_id].addresses[i] = container[_id].addresses[container[_id].addresses.length - 1];
341                 container[_id].addresses.pop();
342                 return;
343             }
344         }
345     }
346 
347     function removeItem(bytes32 _id) internal{
348         delete container[_id];
349     }
350 
351     function replaceItemAddress(bytes32 _id, address _oneAddress, address _anotherAddress) internal {
352         for(uint256 i = 0; i < container[_id].addresses.length; i++){
353             if(container[_id].addresses[i] == _oneAddress){
354                 container[_id].addresses[i] = _anotherAddress;
355                 return;
356             }
357         }
358     }
359 }
360 
361 
362 // File contracts/BridgeStorage.sol
363 
364 
365 pragma solidity ^0.7.0;
366 
367 contract BridgeStorage is Container {
368     string public constant name = "BridgeStorage";
369 
370     address private caller;
371 
372     constructor(address aCaller) {
373         caller = aCaller;
374     }
375 
376     modifier onlyCaller() {
377         require(msg.sender == caller, "only use main contract to call");
378         _;
379     }
380 
381     function supporterExists(bytes32 taskHash, address user) public view returns(bool) {
382         return itemAddressExists(taskHash, user);
383     }
384 
385     function setTaskInfo(bytes32 taskHash, uint256 taskType, uint256 status) external onlyCaller {
386         setItemInfo(taskHash, taskType, status);
387     }
388 
389     function getTaskInfo(bytes32 taskHash) public view returns(uint256, uint256, uint256){
390         return getItemInfo(taskHash);
391     }
392 
393     function addSupporter(bytes32 taskHash, address oneAddress) external onlyCaller{
394         addItemAddress(taskHash, oneAddress);
395     }
396 
397     function removeAllSupporter(bytes32 taskHash) external onlyCaller {
398         removeItemAddresses(taskHash);
399     }
400     function removeTask(bytes32 taskHash)external onlyCaller{
401         removeItem(taskHash);
402     }
403 }
404 
405 
406 // File contracts/BridgeAdmin.sol
407 
408 
409 pragma solidity ^0.7.0;
410 
411 contract BridgeAdmin is Container {
412     bytes32 internal constant OWNERHASH = 0x02016836a56b71f0d02689e69e326f4f4c1b9057164ef592671cf0d37c8040c0;
413     bytes32 internal constant OPERATORHASH = 0x46a52cf33029de9f84853745a87af28464c80bf0346df1b32e205fc73319f622;
414     bytes32 internal constant PAUSERHASH = 0x0cc58340b26c619cd4edc70f833d3f4d9d26f3ae7d5ef2965f81fe5495049a4f;
415     bytes32 internal constant STOREHASH = 0xe41d88711b08bdcd7556c5d2d24e0da6fa1f614cf2055f4d7e10206017cd1680;
416     bytes32 internal constant LOGICHASH = 0x397bc5b97f629151e68146caedba62f10b47e426b38db589771a288c0861f182;
417     uint256 internal constant MAXUSERNUM = 255;
418     bytes32[] private classHashArray;
419 
420     uint256 internal ownerRequireNum;
421     uint256 internal operatorRequireNum;
422 
423     event AdminChanged(string TaskType, string class, address oldAddress, address newAddress);
424     event AdminRequiredNumChanged(string TaskType, string class, uint256 previousNum, uint256 requiredNum);
425     event AdminTaskDropped(bytes32 taskHash);
426 
427     modifier validRequirement(uint ownerCount, uint _required) {
428         require(ownerCount <= MaxItemAdressNum
429         && _required <= ownerCount
430         && _required > 0
431             && ownerCount > 0);
432         _;
433     }
434 
435     modifier onlyOwner() {
436         require(itemAddressExists(OWNERHASH, msg.sender), "only use owner to call");
437         _;
438     }
439 
440     function initAdmin(address[] memory _owners, uint _ownerRequired) internal validRequirement(_owners.length, _ownerRequired) {
441         for (uint i = 0; i < _owners.length; i++) {
442             addItemAddress(OWNERHASH, _owners[i]);
443         }
444         addItemAddress(PAUSERHASH,_owners[0]);// we need an init pauser
445         addItemAddress(LOGICHASH, address(0x0));
446         addItemAddress(STOREHASH, address(0x1));
447 
448         classHashArray.push(OWNERHASH);
449         classHashArray.push(OPERATORHASH);
450         classHashArray.push(PAUSERHASH);
451         classHashArray.push(STOREHASH);
452         classHashArray.push(LOGICHASH);
453         ownerRequireNum = _ownerRequired;
454         operatorRequireNum = 2;
455     }
456 
457     function classHashExist(bytes32 aHash) private view returns (bool) {
458         for (uint256 i = 0; i < classHashArray.length; i++)
459             if (classHashArray[i] == aHash) return true;
460         return false;
461     }
462 
463     function getAdminAddresses(string memory class) public view returns (address[] memory) {
464         bytes32 classHash = getClassHash(class);
465         return getItemAddresses(classHash);
466     }
467 
468     function getOwnerRequireNum() public view returns (uint256){
469         return ownerRequireNum;
470     }
471 
472     function getOperatorRequireNum() public view returns (uint256){
473         return operatorRequireNum;
474     }
475 
476     function resetRequiredNum(string memory class, uint256 requiredNum) public onlyOwner returns (bool){
477         bytes32 classHash = getClassHash(class);
478         require((classHash == OPERATORHASH) || (classHash == OWNERHASH), "wrong class");
479 
480         bytes32 taskHash = keccak256(abi.encodePacked("resetRequiredNum", class, requiredNum));
481         addItemAddress(taskHash, msg.sender);
482 
483         if (getItemAddressCount(taskHash) >= ownerRequireNum) {
484             removeItem(taskHash);
485             uint256 previousNum = 0;
486             if (classHash == OWNERHASH) {
487                 previousNum = ownerRequireNum;
488                 ownerRequireNum = requiredNum;
489             }
490             else if (classHash == OPERATORHASH) {
491                 previousNum = operatorRequireNum;
492                 operatorRequireNum = requiredNum;
493             } else {
494                 revert("wrong class");
495             }
496             emit AdminRequiredNumChanged("resetRequiredNum", class, previousNum, requiredNum);
497         }
498         return true;
499     }
500 
501     function modifyAddress(string memory class, address oldAddress, address newAddress) internal onlyOwner returns (bool){
502         bytes32 classHash = getClassHash(class);
503         bytes32 taskHash = keccak256(abi.encodePacked("modifyAddress", class, oldAddress, newAddress));
504         addItemAddress(taskHash, msg.sender);
505         if (getItemAddressCount(taskHash) >= ownerRequireNum) {
506             replaceItemAddress(classHash, oldAddress, newAddress);
507             emit AdminChanged("modifyAddress", class, oldAddress, newAddress);
508             removeItem(taskHash);
509             return true;
510         }
511         return false;
512     }
513 
514     function getClassHash(string memory class) private view returns (bytes32){
515         bytes32 classHash = keccak256(abi.encodePacked(class));
516         require(classHashExist(classHash), "invalid class");
517         return classHash;
518     }
519 
520     function dropAddress(string memory class, address oneAddress) public onlyOwner returns (bool){
521         bytes32 classHash = getClassHash(class);
522         require(classHash != STOREHASH && classHash != LOGICHASH, "wrong class");
523         require(itemAddressExists(classHash, oneAddress), "no such address exist");
524 
525         if (classHash == OWNERHASH)
526             require(getItemAddressCount(classHash) > ownerRequireNum, "insuffience addresses");
527 
528         bytes32 taskHash = keccak256(abi.encodePacked("dropAddress", class, oneAddress));
529         addItemAddress(taskHash, msg.sender);
530         if (getItemAddressCount(taskHash) >= ownerRequireNum) {
531             removeOneItemAddress(classHash, oneAddress);
532             emit AdminChanged("dropAddress", class, oneAddress, oneAddress);
533             removeItem(taskHash);
534             return true;
535         }
536         return false;
537     }
538 
539     function addAddress(string memory class, address oneAddress) public onlyOwner returns (bool){
540         bytes32 classHash = getClassHash(class);
541         require(classHash != STOREHASH && classHash != LOGICHASH, "wrong class");
542 
543         bytes32 taskHash = keccak256(abi.encodePacked("addAddress", class, oneAddress));
544         addItemAddress(taskHash, msg.sender);
545         if (getItemAddressCount(taskHash) >= ownerRequireNum) {
546             addItemAddress(classHash, oneAddress);
547             emit AdminChanged("addAddress", class, oneAddress, oneAddress);
548             removeItem(taskHash);
549             return true;
550         }
551         return false;
552     }
553 
554     function dropTask(bytes32 taskHash) public onlyOwner returns (bool){
555         removeItem(taskHash);
556         emit AdminTaskDropped(taskHash);
557         return true;
558     }
559 }
560 
561 
562 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.3.0
563 
564 
565 
566 pragma solidity >=0.6.0 <0.8.0;
567 
568 /**
569  * @dev Interface of the ERC20 standard as defined in the EIP.
570  */
571 interface IERC20 {
572     /**
573      * @dev Returns the amount of tokens in existence.
574      */
575     function totalSupply() external view returns (uint256);
576 
577     /**
578      * @dev Returns the amount of tokens owned by `account`.
579      */
580     function balanceOf(address account) external view returns (uint256);
581 
582     /**
583      * @dev Moves `amount` tokens from the caller's account to `recipient`.
584      *
585      * Returns a boolean value indicating whether the operation succeeded.
586      *
587      * Emits a {Transfer} event.
588      */
589     function transfer(address recipient, uint256 amount) external returns (bool);
590 
591     /**
592      * @dev Returns the remaining number of tokens that `spender` will be
593      * allowed to spend on behalf of `owner` through {transferFrom}. This is
594      * zero by default.
595      *
596      * This value changes when {approve} or {transferFrom} are called.
597      */
598     function allowance(address owner, address spender) external view returns (uint256);
599 
600     /**
601      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
602      *
603      * Returns a boolean value indicating whether the operation succeeded.
604      *
605      * IMPORTANT: Beware that changing an allowance with this method brings the risk
606      * that someone may use both the old and the new allowance by unfortunate
607      * transaction ordering. One possible solution to mitigate this race
608      * condition is to first reduce the spender's allowance to 0 and set the
609      * desired value afterwards:
610      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
611      *
612      * Emits an {Approval} event.
613      */
614     function approve(address spender, uint256 amount) external returns (bool);
615 
616     /**
617      * @dev Moves `amount` tokens from `sender` to `recipient` using the
618      * allowance mechanism. `amount` is then deducted from the caller's
619      * allowance.
620      *
621      * Returns a boolean value indicating whether the operation succeeded.
622      *
623      * Emits a {Transfer} event.
624      */
625     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
626 
627     /**
628      * @dev Emitted when `value` tokens are moved from one account (`from`) to
629      * another (`to`).
630      *
631      * Note that `value` may be zero.
632      */
633     event Transfer(address indexed from, address indexed to, uint256 value);
634 
635     /**
636      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
637      * a call to {approve}. `value` is the new allowance.
638      */
639     event Approval(address indexed owner, address indexed spender, uint256 value);
640 }
641 
642 
643 // File contracts/BridgeLogic.sol
644 
645 
646 pragma solidity ^0.7.0;
647 
648 
649 
650 
651 contract BridgeLogic {
652     using SafeMath for uint256;
653 
654     string public constant name = "BridgeLogic";
655 
656     bytes32 internal constant OPERATORHASH = 0x46a52cf33029de9f84853745a87af28464c80bf0346df1b32e205fc73319f622;
657     uint256 public constant TASKINIT = 0;
658     uint256 public constant TASKPROCESSING = 1;
659     uint256 public constant TASKCANCELLED = 2;
660     uint256 public constant TASKDONE = 3;
661     uint256 public constant WITHDRAWTASK = 1;
662 
663     address private caller;
664     BridgeStorage private store;
665 
666     constructor(address aCaller) {
667         caller = aCaller;
668     }
669 
670     modifier onlyCaller(){
671         require(msg.sender == caller, "only main contract can call");
672         _;
673     }
674 
675     modifier operatorExists(address operator) {
676         require(store.supporterExists(OPERATORHASH, operator), "wrong operator");
677         _;
678     }
679 
680     function resetStoreLogic(address storeAddress) external onlyCaller {
681         store = BridgeStorage(storeAddress);
682     }
683 
684     function getStoreAddress() public view returns(address) {
685         return address(store);
686     }
687 
688     function supportTask(uint256 taskType, bytes32 taskHash, address oneAddress, uint256 requireNum) external onlyCaller returns(uint256){
689         require(!store.supporterExists(taskHash, oneAddress), "supporter already exists");
690         (uint256 theTaskType,uint256 theTaskStatus,uint256 theSupporterNum) = store.getTaskInfo(taskHash);
691         require(theTaskStatus < TASKDONE, "wrong status");
692 
693         if (theTaskStatus != TASKINIT)
694             require(theTaskType == taskType, "task type not match");
695         store.addSupporter(taskHash, oneAddress);
696         theSupporterNum++;
697         if(theSupporterNum >= requireNum)
698             theTaskStatus = TASKDONE;
699         else
700             theTaskStatus = TASKPROCESSING;
701         store.setTaskInfo(taskHash, taskType, theTaskStatus);
702         return theTaskStatus;
703     }
704 
705     function cancelTask(bytes32 taskHash)  external onlyCaller returns(uint256) {
706         (uint256 theTaskType,uint256 theTaskStatus,uint256 theSupporterNum) = store.getTaskInfo(taskHash);
707         require(theTaskStatus == TASKPROCESSING, "wrong status");
708         if(theSupporterNum > 0) store.removeAllSupporter(taskHash);
709         theTaskStatus = TASKCANCELLED;
710         store.setTaskInfo(taskHash, theTaskType, theTaskStatus);
711         return theTaskStatus;
712     }
713     function removeTask(bytes32 taskHash)  external onlyCaller {
714         store.removeTask(taskHash);
715 
716     }
717 
718 
719 }
720 
721 
722 // File contracts/ERC20Sample.sol
723 
724 pragma solidity ^0.7.0;
725 
726 
727 abstract contract ERC20Template is IERC20 {
728 
729     function mint(address account, uint256 amount) public{
730     }
731     function burn(address account , uint256 amount) public{
732     }
733     function redeem(address account, uint256 amount)public {
734     }
735     function issue(address account, uint256 amount) public {
736     }
737 }
738 
739 
740 // File contracts/Bridge.sol
741 
742 
743 pragma solidity ^0.7.0;
744 
745 
746 
747 
748 
749 
750 contract Bridge is BridgeAdmin, Pausable {
751 
752     using SafeMath for uint256;
753 
754     string public constant name = "Bridge";
755 
756     BridgeLogic private logic;
757 
758     event DepositNative(address indexed from, uint256 value, string targetAddress, string chain);
759     event DepositToken(address indexed from, uint256 value, address indexed token, string targetAddress, string chain, uint256 nativeValue);
760     event WithdrawingNative(address indexed to, uint256 value, string proof);
761     event WithdrawingToken(address indexed to, address indexed token, uint256 value, string proof);
762     event WithdrawDoneNative(address indexed to, uint256 value, string proof);
763     event WithdrawDoneToken(address indexed to, address indexed token, uint256 value, string proof);
764 
765     modifier onlyOperator() {
766         require(itemAddressExists(OPERATORHASH, msg.sender), "wrong operator");
767         _;
768     }
769 
770     modifier onlyPauser() {
771         require(itemAddressExists(PAUSERHASH, msg.sender), "wrong pauser");
772         _;
773     }
774 
775     modifier positiveValue(uint _value) {
776         require(_value > 0, "value need > 0");
777         _;
778     }
779 
780 
781     constructor(address[] memory _owners, uint _ownerRequired) {
782         initAdmin(_owners, _ownerRequired);
783 
784     }
785 
786     function depositNative(string memory _targetAddress, string memory  chain) public payable {
787         emit DepositNative(msg.sender, msg.value, _targetAddress,chain);
788     }
789 
790     function depositToken(address _token, uint value, string memory _targetAddress, string memory chain) public payable returns (bool){
791         //deposit(address token, address _from, uint256 _value)
792         bool res = depositTokenLogic(_token,  msg.sender, value);
793         emit DepositToken(msg.sender, value, _token, _targetAddress, chain, msg.value);
794         return res;
795     }// 
796 
797     function withdrawNative(address payable to, uint value, string memory proof, bytes32 taskHash) public
798     onlyOperator
799     whenNotPaused
800     positiveValue(value)
801     returns(bool)
802     {
803         require(address(this).balance >= value, "not enough native token");
804         require(taskHash == keccak256((abi.encodePacked(to,value,proof))),"taskHash is wrong");
805         uint256 status = logic.supportTask(logic.WITHDRAWTASK(), taskHash, msg.sender, operatorRequireNum);
806 
807         if (status == logic.TASKPROCESSING()){
808             emit WithdrawingNative(to, value, proof);
809         }else if (status == logic.TASKDONE()) {
810             emit WithdrawingNative(to, value, proof);
811             emit WithdrawDoneNative(to, value, proof);
812             to.transfer(value);
813             logic.removeTask(taskHash);
814         }
815         return true;
816     }
817 
818     function withdrawToken(address _token, address to, uint value, string memory proof, bytes32 taskHash) public
819     onlyOperator
820     whenNotPaused
821     positiveValue(value)
822     returns (bool)
823     {
824         require(taskHash == keccak256((abi.encodePacked(to,value,proof))),"taskHash is wrong");
825         uint256 status = logic.supportTask(logic.WITHDRAWTASK(), taskHash, msg.sender, operatorRequireNum);
826 
827         if (status == logic.TASKPROCESSING()){
828             emit WithdrawingToken(to, _token, value, proof);
829         }else if (status == logic.TASKDONE()) {
830             // withdraw(address token, address _to, address _value)
831             bool res = withdrawTokenLogic( _token, to, value);
832 
833             emit WithdrawingToken(to, _token, value, proof);
834             emit WithdrawDoneToken(to, _token, value, proof);
835             logic.removeTask(taskHash);
836             return res;
837         }
838         return true;
839     }
840 
841     function modifyAdminAddress(string memory class, address oldAddress, address newAddress) public whenPaused {
842         require(newAddress != address(0x0), "wrong address");
843         bool flag = modifyAddress(class, oldAddress, newAddress);
844         if(flag){
845             bytes32 classHash = keccak256(abi.encodePacked(class));
846             if(classHash == LOGICHASH){
847                 logic = BridgeLogic(newAddress);
848             }else if(classHash == STOREHASH){
849                 logic.resetStoreLogic(newAddress);
850             }
851         }
852     }
853     function getLogicAddress() public view returns(address){
854         return address(logic);
855     }
856 
857     function getStoreAddress() public view returns(address){
858         return logic.getStoreAddress();
859     }
860 
861     function pause() public onlyPauser {
862         _pause();
863     }
864 
865     function unpause() public onlyPauser {
866         _unpause();
867     }
868 
869 
870     function transferToken(address token, address to , uint256 value) onlyPauser external{
871         IERC20 atoken = IERC20(token);
872         bool success = atoken.transfer(to,value);
873     }
874 
875 
876     function setDepositSelector(address token, string memory method, bool _isValueFirst) onlyOperator external{
877         depositSelector[token] = assetSelector(method,_isValueFirst);
878     }
879 
880     function setWithdrawSelector(address token, string memory method, bool _isValueFirst) onlyOperator external{
881         withdrawSelector[token] = assetSelector(method,_isValueFirst);
882     }
883 
884 
885     struct assetSelector{
886         string selector;
887         bool isValueFirst;
888     }
889 
890     mapping (address=>assetSelector)  public depositSelector;
891     mapping (address=> assetSelector) public withdrawSelector;
892 
893     function depositTokenLogic(address token, address _from, uint256 _value) internal returns(bool){
894         bool status = false;
895         bytes memory returnedData;
896         if (bytes(depositSelector[token].selector).length == 0){
897             (status,returnedData)= token.call(abi.encodeWithSignature("transferFrom(address,address,uint256)",_from,this,_value));
898         }
899         else{
900             assetSelector memory aselector = depositSelector[token];
901             if (aselector.isValueFirst){
902                 (status, returnedData) = token.call(abi.encodeWithSignature(aselector.selector,_value,_from));
903             }
904             else {
905                 (status,returnedData)= token.call(abi.encodeWithSignature(aselector.selector,_from,_value));
906             }
907         }
908         require(
909             status && (returnedData.length == 0 || abi.decode(returnedData, (bool))),
910             ' transfer failed');
911         return true;
912     }
913 
914     function withdrawTokenLogic(address token, address _to, uint256 _value) internal returns(bool){
915         bool status = false;
916         bytes memory returnedData;
917         if (bytes(withdrawSelector[token].selector).length==0){
918             (status,returnedData)= token.call(abi.encodeWithSignature("transfer(address,uint256)",_to,_value));
919         }
920         else{
921             assetSelector memory aselector = withdrawSelector[token];
922             if (aselector.isValueFirst){
923                 (status,returnedData) = token.call(abi.encodeWithSignature( aselector.selector,_value,_to));
924             }
925             else {
926                 (status,returnedData)= token.call(abi.encodeWithSignature(aselector.selector,_to,_value));
927             }
928         }
929 
930         require(status && (returnedData.length == 0 || abi.decode(returnedData, (bool))),'withdraw failed');
931         return true;
932     }
933 }