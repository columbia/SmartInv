1 // Sources flattened with hardhat v2.0.6 https://hardhat.org
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
169 pragma solidity >=0.6.0 <0.8.0;
170 
171 /*
172  * @dev Provides information about the current execution context, including the
173  * sender of the transaction and its data. While these are generally available
174  * via msg.sender and msg.data, they should not be accessed in such a direct
175  * manner, since when dealing with GSN meta-transactions the account sending and
176  * paying for execution may not be the actual sender (as far as an application
177  * is concerned).
178  *
179  * This contract is only required for intermediate, library-like contracts.
180  */
181 abstract contract Context {
182     function _msgSender() internal view virtual returns (address payable) {
183         return msg.sender;
184     }
185 
186     function _msgData() internal view virtual returns (bytes memory) {
187         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
188         return msg.data;
189     }
190 }
191 
192 
193 // File @openzeppelin/contracts/utils/Pausable.sol@v3.3.0
194 
195 
196 pragma solidity >=0.6.0 <0.8.0;
197 
198 /**
199  * @dev Contract module which allows children to implement an emergency stop
200  * mechanism that can be triggered by an authorized account.
201  *
202  * This module is used through inheritance. It will make available the
203  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
204  * the functions of your contract. Note that they will not be pausable by
205  * simply including this module, only once the modifiers are put in place.
206  */
207 abstract contract Pausable is Context {
208     /**
209      * @dev Emitted when the pause is triggered by `account`.
210      */
211     event Paused(address account);
212 
213     /**
214      * @dev Emitted when the pause is lifted by `account`.
215      */
216     event Unpaused(address account);
217 
218     bool private _paused;
219 
220     /**
221      * @dev Initializes the contract in unpaused state.
222      */
223     constructor () internal {
224         _paused = false;
225     }
226 
227     /**
228      * @dev Returns true if the contract is paused, and false otherwise.
229      */
230     function paused() public view returns (bool) {
231         return _paused;
232     }
233 
234     /**
235      * @dev Modifier to make a function callable only when the contract is not paused.
236      *
237      * Requirements:
238      *
239      * - The contract must not be paused.
240      */
241     modifier whenNotPaused() {
242         require(!_paused, "Pausable: paused");
243         _;
244     }
245 
246     /**
247      * @dev Modifier to make a function callable only when the contract is paused.
248      *
249      * Requirements:
250      *
251      * - The contract must be paused.
252      */
253     modifier whenPaused() {
254         require(_paused, "Pausable: not paused");
255         _;
256     }
257 
258     /**
259      * @dev Triggers stopped state.
260      *
261      * Requirements:
262      *
263      * - The contract must not be paused.
264      */
265     function _pause() internal virtual whenNotPaused {
266         _paused = true;
267         emit Paused(_msgSender());
268     }
269 
270     /**
271      * @dev Returns to normal state.
272      *
273      * Requirements:
274      *
275      * - The contract must be paused.
276      */
277     function _unpause() internal virtual whenPaused {
278         _paused = false;
279         emit Unpaused(_msgSender());
280     }
281 }
282 
283 
284 // File contracts/Container.sol
285 
286 pragma solidity ^0.7.0;
287 
288 contract Container {
289 
290     struct Item{
291         uint256 itemType;
292         uint256 status;
293         address[] addresses;
294     }
295 
296     uint256 MaxItemAdressNum = 255;
297     mapping (bytes32 => Item) private container;
298     // bool private _nativePaused = false;
299 
300 
301     function itemAddressExists(bytes32 _id, address _oneAddress) internal view returns(bool){
302         for(uint256 i = 0; i < container[_id].addresses.length; i++){
303             if(container[_id].addresses[i] == _oneAddress)
304                 return true;
305         }
306         return false;
307     }
308     function getItemAddresses(bytes32 _id) internal view returns(address[] memory){
309         return container[_id].addresses;
310     }
311 
312     function getItemInfo(bytes32 _id) internal view returns(uint256, uint256, uint256){
313         return (container[_id].itemType, container[_id].status, container[_id].addresses.length);
314     }
315 
316     function getItemAddressCount(bytes32 _id) internal view returns(uint256){
317         return container[_id].addresses.length;
318     }
319 
320     function setItemInfo(bytes32 _id, uint256 _itemType, uint256 _status) internal{
321         container[_id].itemType = _itemType;
322         container[_id].status = _status;
323     }
324 
325     function addItemAddress(bytes32 _id, address _oneAddress) internal{
326         require(!itemAddressExists(_id, _oneAddress), "dup address added");
327         require(container[_id].addresses.length < MaxItemAdressNum, "too many addresses");
328         container[_id].addresses.push(_oneAddress);
329     }
330     function removeItemAddresses(bytes32 _id) internal {
331         delete container[_id].addresses;
332     }
333 
334     function removeOneItemAddress(bytes32 _id, address _oneAddress) internal {
335         for(uint256 i = 0; i < container[_id].addresses.length; i++){
336             if(container[_id].addresses[i] == _oneAddress){
337                 container[_id].addresses[i] = container[_id].addresses[container[_id].addresses.length - 1];
338                 container[_id].addresses.pop();
339                 return;
340             }
341         }
342     }
343 
344     function removeItem(bytes32 _id) internal{
345         delete container[_id];
346     }
347 
348     function replaceItemAddress(bytes32 _id, address _oneAddress, address _anotherAddress) internal {
349         for(uint256 i = 0; i < container[_id].addresses.length; i++){
350             if(container[_id].addresses[i] == _oneAddress){
351                 container[_id].addresses[i] = _anotherAddress;
352                 return;
353             }
354         }
355     }
356 }
357 
358 
359 // File contracts/BridgeAdmin.sol
360 
361 pragma solidity ^0.7.0;
362 
363 contract BridgeAdmin is Container {
364     bytes32 internal constant OWNERHASH = 0x02016836a56b71f0d02689e69e326f4f4c1b9057164ef592671cf0d37c8040c0;
365     bytes32 internal constant OPERATORHASH = 0x46a52cf33029de9f84853745a87af28464c80bf0346df1b32e205fc73319f622;
366     bytes32 internal constant PAUSERHASH = 0x0cc58340b26c619cd4edc70f833d3f4d9d26f3ae7d5ef2965f81fe5495049a4f;
367     bytes32 internal constant STOREHASH = 0xe41d88711b08bdcd7556c5d2d24e0da6fa1f614cf2055f4d7e10206017cd1680;
368     bytes32 internal constant LOGICHASH = 0x397bc5b97f629151e68146caedba62f10b47e426b38db589771a288c0861f182;
369     // keccak256("selector")
370     bytes32 internal constant SELECTORHASH = 0x4c11fe2a708d5242b13f178422d4088cb270c488d9932765064ea92953422272;
371 
372     uint256 internal constant MAXUSERNUM = 255;
373     bytes32[] private classHashArray;
374 
375     uint256 internal ownerRequireNum;
376     uint256 internal operatorRequireNum;
377 
378     event AdminChanged(string TaskType, string class, address oldAddress, address newAddress);
379     event AdminRequiredNumChanged(string TaskType, string class, uint256 previousNum, uint256 requiredNum);
380     event AdminTaskDropped(bytes32 taskHash);
381 
382     modifier validRequirement(uint ownerCount, uint _required) {
383         require(ownerCount <= MaxItemAdressNum
384         && _required <= ownerCount
385         && _required > 0
386             && ownerCount > 0);
387         _;
388     }
389 
390     modifier onlyOwner() {
391         require(itemAddressExists(OWNERHASH, msg.sender), "only use owner to call");
392         _;
393     }
394 
395     function initAdmin(address[] memory _owners, uint _ownerRequired) internal validRequirement(_owners.length, _ownerRequired) {
396         for (uint i = 0; i < _owners.length; i++) {
397             addItemAddress(OWNERHASH, _owners[i]);
398         }
399         addItemAddress(PAUSERHASH,_owners[0]);
400         addItemAddress(SELECTORHASH,_owners[0]);
401         addItemAddress(LOGICHASH, address(0x0));
402         addItemAddress(STOREHASH, address(0x1));
403 
404         classHashArray.push(OWNERHASH);
405         classHashArray.push(OPERATORHASH);
406         classHashArray.push(PAUSERHASH);
407         classHashArray.push(STOREHASH);
408         classHashArray.push(LOGICHASH);
409         classHashArray.push(SELECTORHASH);
410 
411         ownerRequireNum = _ownerRequired;
412         operatorRequireNum = 2;
413     }
414 
415     function classHashExist(bytes32 aHash) private view returns (bool) {
416         for (uint256 i = 0; i < classHashArray.length; i++)
417             if (classHashArray[i] == aHash) return true;
418         return false;
419     }
420 
421     function getAdminAddresses(string memory class) public view returns (address[] memory) {
422         bytes32 classHash = getClassHash(class);
423         return getItemAddresses(classHash);
424     }
425 
426     function getOwnerRequireNum() public view returns (uint256){
427         return ownerRequireNum;
428     }
429 
430     function getOperatorRequireNum() public view returns (uint256){
431         return operatorRequireNum;
432     }
433 
434     function resetRequiredNum(string memory class, uint256 requiredNum) public onlyOwner returns (bool){
435         bytes32 classHash = getClassHash(class);
436         require((classHash == OPERATORHASH) || (classHash == OWNERHASH), "wrong class");
437 
438         bytes32 taskHash = keccak256(abi.encodePacked("resetRequiredNum", class, requiredNum));
439         addItemAddress(taskHash, msg.sender);
440 
441         if (getItemAddressCount(taskHash) >= ownerRequireNum) {
442             removeItem(taskHash);
443             uint256 previousNum = 0;
444             if (classHash == OWNERHASH) {
445                 previousNum = ownerRequireNum;
446                 ownerRequireNum = requiredNum;
447             }
448             else if (classHash == OPERATORHASH) {
449                 previousNum = operatorRequireNum;
450                 operatorRequireNum = requiredNum;
451             } else {
452                 revert("wrong class");
453             }
454             emit AdminRequiredNumChanged("resetRequiredNum", class, previousNum, requiredNum);
455         }
456         return true;
457     }
458 
459     function modifyAddress(string memory class, address oldAddress, address newAddress) internal onlyOwner returns (bool){
460         bytes32 classHash = getClassHash(class);
461         bytes32 taskHash = keccak256(abi.encodePacked("modifyAddress", class, oldAddress, newAddress));
462         addItemAddress(taskHash, msg.sender);
463         if (getItemAddressCount(taskHash) >= ownerRequireNum) {
464             replaceItemAddress(classHash, oldAddress, newAddress);
465             emit AdminChanged("modifyAddress", class, oldAddress, newAddress);
466             removeItem(taskHash);
467             return true;
468         }
469         return false;
470     }
471 
472     function getClassHash(string memory class) private view returns (bytes32){
473         bytes32 classHash = keccak256(abi.encodePacked(class));
474         require(classHashExist(classHash), "invalid class");
475         return classHash;
476     }
477 
478     function dropAddress(string memory class, address oneAddress) public onlyOwner returns (bool){
479         bytes32 classHash = getClassHash(class);
480         require(classHash != STOREHASH && classHash != LOGICHASH, "wrong class");
481         require(itemAddressExists(classHash, oneAddress), "no such address exist");
482 
483         if (classHash == OWNERHASH)
484             require(getItemAddressCount(classHash) > ownerRequireNum, "insuffience addresses");
485 
486         bytes32 taskHash = keccak256(abi.encodePacked("dropAddress", class, oneAddress));
487         addItemAddress(taskHash, msg.sender);
488         if (getItemAddressCount(taskHash) >= ownerRequireNum) {
489             removeOneItemAddress(classHash, oneAddress);
490             emit AdminChanged("dropAddress", class, oneAddress, oneAddress);
491             removeItem(taskHash);
492             return true;
493         }
494         return false;
495     }
496 
497     function addAddress(string memory class, address oneAddress) public onlyOwner returns (bool){
498         bytes32 classHash = getClassHash(class);
499         require(classHash != STOREHASH && classHash != LOGICHASH, "wrong class");
500 
501         bytes32 taskHash = keccak256(abi.encodePacked("addAddress", class, oneAddress));
502         addItemAddress(taskHash, msg.sender);
503         if (getItemAddressCount(taskHash) >= ownerRequireNum) {
504             addItemAddress(classHash, oneAddress);
505             emit AdminChanged("addAddress", class, oneAddress, oneAddress);
506             removeItem(taskHash);
507             return true;
508         }
509         return false;
510     }
511 
512     function dropTask(bytes32 taskHash) public onlyOwner returns (bool){
513         removeItem(taskHash);
514         emit AdminTaskDropped(taskHash);
515         return true;
516     }
517 }
518 
519 
520 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.3.0
521 
522 
523 pragma solidity >=0.6.0 <0.8.0;
524 
525 /**
526  * @dev Interface of the ERC20 standard as defined in the EIP.
527  */
528 interface IERC20 {
529     /**
530      * @dev Returns the amount of tokens in existence.
531      */
532     function totalSupply() external view returns (uint256);
533 
534     /**
535      * @dev Returns the amount of tokens owned by `account`.
536      */
537     function balanceOf(address account) external view returns (uint256);
538 
539     /**
540      * @dev Moves `amount` tokens from the caller's account to `recipient`.
541      *
542      * Returns a boolean value indicating whether the operation succeeded.
543      *
544      * Emits a {Transfer} event.
545      */
546     function transfer(address recipient, uint256 amount) external returns (bool);
547 
548     /**
549      * @dev Returns the remaining number of tokens that `spender` will be
550      * allowed to spend on behalf of `owner` through {transferFrom}. This is
551      * zero by default.
552      *
553      * This value changes when {approve} or {transferFrom} are called.
554      */
555     function allowance(address owner, address spender) external view returns (uint256);
556 
557     /**
558      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
559      *
560      * Returns a boolean value indicating whether the operation succeeded.
561      *
562      * IMPORTANT: Beware that changing an allowance with this method brings the risk
563      * that someone may use both the old and the new allowance by unfortunate
564      * transaction ordering. One possible solution to mitigate this race
565      * condition is to first reduce the spender's allowance to 0 and set the
566      * desired value afterwards:
567      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
568      *
569      * Emits an {Approval} event.
570      */
571     function approve(address spender, uint256 amount) external returns (bool);
572 
573     /**
574      * @dev Moves `amount` tokens from `sender` to `recipient` using the
575      * allowance mechanism. `amount` is then deducted from the caller's
576      * allowance.
577      *
578      * Returns a boolean value indicating whether the operation succeeded.
579      *
580      * Emits a {Transfer} event.
581      */
582     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
583 
584     /**
585      * @dev Emitted when `value` tokens are moved from one account (`from`) to
586      * another (`to`).
587      *
588      * Note that `value` may be zero.
589      */
590     event Transfer(address indexed from, address indexed to, uint256 value);
591 
592     /**
593      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
594      * a call to {approve}. `value` is the new allowance.
595      */
596     event Approval(address indexed owner, address indexed spender, uint256 value);
597 }
598 
599 
600 // File contracts/BridgeStorage.sol
601 
602 pragma solidity ^0.7.0;
603 
604 contract BridgeStorage is Container {
605     string public constant name = "BridgeStorage";
606 
607     address private caller;
608 
609     constructor(address aCaller) {
610         caller = aCaller;
611     }
612 
613     modifier onlyCaller() {
614         require(msg.sender == caller, "only use main contract to call");
615         _;
616     }
617 
618     function supporterExists(bytes32 taskHash, address user) public view returns(bool) {
619         return itemAddressExists(taskHash, user);
620     }
621 
622     function setTaskInfo(bytes32 taskHash, uint256 taskType, uint256 status) external onlyCaller {
623         setItemInfo(taskHash, taskType, status);
624     }
625 
626     function getTaskInfo(bytes32 taskHash) public view returns(uint256, uint256, uint256){
627         return getItemInfo(taskHash);
628     }
629 
630     function addSupporter(bytes32 taskHash, address oneAddress) external onlyCaller{
631         addItemAddress(taskHash, oneAddress);
632     }
633 
634     function removeAllSupporter(bytes32 taskHash) external onlyCaller {
635         removeItemAddresses(taskHash);
636     }
637     function removeTask(bytes32 taskHash)external onlyCaller{
638         removeItem(taskHash);
639     }
640 }
641 
642 
643 // File contracts/BridgeLogic.sol
644 
645 pragma solidity ^0.7.0;
646 
647 
648 
649 contract BridgeLogic {
650     using SafeMath for uint256;
651 
652     string public constant name = "BridgeLogic";
653 
654     bytes32 internal constant OPERATORHASH = 0x46a52cf33029de9f84853745a87af28464c80bf0346df1b32e205fc73319f622;
655     uint256 public constant TASKINIT = 0;
656     uint256 public constant TASKPROCESSING = 1;
657     uint256 public constant TASKCANCELLED = 2;
658     uint256 public constant TASKDONE = 3;
659     uint256 public constant WITHDRAWTASK = 1;
660 
661     address private caller;
662     BridgeStorage private store;
663 
664     mapping(bytes32 => bool) finishedTasks;
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
713 
714     function removeTask(bytes32 taskHash)  external onlyCaller {
715         store.removeTask(taskHash);
716     }
717 
718     function markTaskAsFinished(bytes32 taskHash) external onlyCaller {
719         require(finishedTasks[taskHash] == false, "task finished already");
720 
721         finishedTasks[taskHash] = true;
722     }
723 
724     function taskIsFinshed(bytes32 taskHash) external view returns (bool) {
725         return finishedTasks[taskHash];
726     }
727 
728 }
729 
730 
731 // File contracts/ERC20Sample.sol
732 
733 pragma solidity ^0.7.0;
734 
735 abstract contract ERC20Template is IERC20 {
736 
737     function mint(address account, uint256 amount) public{
738     }
739     function burn(address account , uint256 amount) public{
740     }
741     function redeem(address account, uint256 amount)public {
742     }
743     function issue(address account, uint256 amount) public {
744     }
745 }
746 
747 
748 // File contracts/Bridge.sol
749 
750 pragma solidity ^0.7.0;
751 
752 
753 
754 
755 
756 contract Bridge is BridgeAdmin, Pausable {
757 
758     using SafeMath for uint256;
759 
760     string public constant name = "Bridge";
761 
762     BridgeLogic private logic;
763 
764     event DepositNative(address indexed from, uint256 value, string targetAddress, string chain);
765     event DepositToken(address indexed from, uint256 value, address indexed token, string targetAddress, string chain, uint256 nativeValue);
766     event WithdrawingNative(address indexed to, uint256 value, string proof);
767     event WithdrawingToken(address indexed to, address indexed token, uint256 value, string proof);
768     event WithdrawDoneNative(address indexed to, uint256 value, string proof);
769     event WithdrawDoneToken(address indexed to, address indexed token, uint256 value, string proof);
770 
771     modifier onlyOperator() {
772         require(itemAddressExists(OPERATORHASH, msg.sender), "wrong operator");
773         _;
774     }
775 
776     modifier onlySelectorSetter() {
777         require(itemAddressExists(SELECTORHASH, msg.sender), "only selector setter allowed");
778         _;
779     }
780 
781     modifier onlyPauser() {
782         require(itemAddressExists(PAUSERHASH, msg.sender), "wrong pauser");
783         _;
784     }
785 
786     modifier positiveValue(uint _value) {
787         require(_value > 0, "value need > 0");
788         _;
789     }
790 
791 
792     constructor(address[] memory _owners, uint _ownerRequired) {
793         initAdmin(_owners, _ownerRequired);
794     }
795 
796     function depositNative(string memory _targetAddress, string memory  chain) public payable {
797         emit DepositNative(msg.sender, msg.value, _targetAddress,chain);
798     }
799 
800     function depositToken(address _token, uint value, string memory _targetAddress, string memory chain) public payable returns (bool){
801         //deposit(address token, address _from, uint256 _value)
802         bool res = depositTokenLogic(_token,  msg.sender, value);
803         emit DepositToken(msg.sender, value, _token, _targetAddress, chain, msg.value);
804         return res;
805     }//
806 
807     function withdrawNative(address payable to, uint value, string memory proof, bytes32 taskHash) public
808     onlyOperator
809     whenNotPaused
810     positiveValue(value)
811     returns(bool)
812     {
813         require(address(this).balance >= value, "not enough native token");
814         require(taskHash == keccak256((abi.encodePacked(to,value,proof))),"taskHash is wrong");
815         require(!logic.taskIsFinshed(taskHash), "taskHash is finished");
816 
817         uint256 status = logic.supportTask(logic.WITHDRAWTASK(), taskHash, msg.sender, operatorRequireNum);
818 
819         if (status == logic.TASKPROCESSING()){
820             emit WithdrawingNative(to, value, proof);
821         }else if (status == logic.TASKDONE()) {
822             emit WithdrawingNative(to, value, proof);
823             emit WithdrawDoneNative(to, value, proof);
824 
825             logic.removeTask(taskHash);
826             logic.markTaskAsFinished(taskHash);
827 
828             to.transfer(value);
829         }
830         return true;
831     }
832 
833     function withdrawToken(address _token, address to, uint value, string memory proof, bytes32 taskHash) public
834     onlyOperator
835     whenNotPaused
836     positiveValue(value)
837     returns (bool)
838     {
839         require(taskHash == keccak256((abi.encodePacked(to,value,proof))),"taskHash is wrong");
840         require(!logic.taskIsFinshed(taskHash), "taskHash is finished");
841 
842         uint256 status = logic.supportTask(logic.WITHDRAWTASK(), taskHash, msg.sender, operatorRequireNum);
843 
844         if (status == logic.TASKPROCESSING()){
845             emit WithdrawingToken(to, _token, value, proof);
846         }else if (status == logic.TASKDONE()) {
847             // withdraw(address token, address _to, address _value)
848             bool res = withdrawTokenLogic( _token, to, value);
849 
850             emit WithdrawingToken(to, _token, value, proof);
851             emit WithdrawDoneToken(to, _token, value, proof);
852 
853             logic.removeTask(taskHash);
854             logic.markTaskAsFinished(taskHash);
855             return res;
856         }
857         return true;
858     }
859 
860     function modifyAdminAddress(string memory class, address oldAddress, address newAddress) public whenPaused {
861         require(newAddress != address(0x0), "wrong address");
862         bool flag = modifyAddress(class, oldAddress, newAddress);
863         if(flag){
864             bytes32 classHash = keccak256(abi.encodePacked(class));
865             if(classHash == LOGICHASH){
866                 logic = BridgeLogic(newAddress);
867             }else if(classHash == STOREHASH){
868                 logic.resetStoreLogic(newAddress);
869             }
870         }
871     }
872     function getLogicAddress() public view returns(address){
873         return address(logic);
874     }
875 
876     function getStoreAddress() public view returns(address){
877         return logic.getStoreAddress();
878     }
879 
880     function pause() public onlyPauser {
881         _pause();
882     }
883 
884     function unpause() public onlyPauser {
885         _unpause();
886     }
887 
888 
889     function transferToken(address token, address to , uint256 value) onlyPauser external{
890         IERC20 atoken = IERC20(token);
891         bool success = atoken.transfer(to,value);
892     }
893 
894 
895     function setDepositSelector(address token, string memory method, bool _isValueFirst) onlySelectorSetter external{
896         depositSelector[token] = assetSelector(method,_isValueFirst);
897     }
898 
899     function setWithdrawSelector(address token, string memory method, bool _isValueFirst) onlySelectorSetter external{
900         withdrawSelector[token] = assetSelector(method,_isValueFirst);
901     }
902 
903 
904     struct assetSelector{
905         string selector;
906         bool isValueFirst;
907     }
908 
909     mapping (address=>assetSelector)  public depositSelector;
910     mapping (address=> assetSelector) public withdrawSelector;
911 
912     function depositTokenLogic(address token, address _from, uint256 _value) internal returns(bool){
913         bool status = false;
914         bytes memory returnedData;
915         if (bytes(depositSelector[token].selector).length == 0){
916             (status,returnedData)= token.call(abi.encodeWithSignature("transferFrom(address,address,uint256)",_from,this,_value));
917         }
918         else{
919             assetSelector memory aselector = depositSelector[token];
920             if (aselector.isValueFirst){
921                 (status, returnedData) = token.call(abi.encodeWithSignature(aselector.selector,_value,_from));
922             }
923             else {
924                 (status,returnedData)= token.call(abi.encodeWithSignature(aselector.selector,_from,_value));
925             }
926         }
927         require(
928             status && (returnedData.length == 0 || abi.decode(returnedData, (bool))),
929             ' transfer failed');
930         return true;
931     }
932 
933     function withdrawTokenLogic(address token, address _to, uint256 _value) internal returns(bool){
934         bool status = false;
935         bytes memory returnedData;
936         if (bytes(withdrawSelector[token].selector).length==0){
937             (status,returnedData)= token.call(abi.encodeWithSignature("transfer(address,uint256)",_to,_value));
938         }
939         else{
940             assetSelector memory aselector = withdrawSelector[token];
941             if (aselector.isValueFirst){
942                 (status,returnedData) = token.call(abi.encodeWithSignature( aselector.selector,_value,_to));
943             }
944             else {
945                 (status,returnedData)= token.call(abi.encodeWithSignature(aselector.selector,_to,_value));
946             }
947         }
948 
949         require(status && (returnedData.length == 0 || abi.decode(returnedData, (bool))),'withdraw failed');
950         return true;
951     }
952 }