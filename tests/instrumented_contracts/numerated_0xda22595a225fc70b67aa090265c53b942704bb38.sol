1 pragma solidity ^0.5.9;
2 
3 /**
4 * @title Math
5 * @dev Assorted math operations
6 */
7 library Math {
8 /**
9 * @dev Returns the largest of two numbers.
10 */
11 function max(uint256 a, uint256 b) internal pure returns (uint256) {
12 return a >= b ? a : b;
13 }
14 
15 /**
16 * @dev Returns the smallest of two numbers.
17 */
18 function min(uint256 a, uint256 b) internal pure returns (uint256) {
19 return a < b ? a : b;
20 }
21 
22 /**
23 * @dev Calculates the average of two numbers. Since these are integers,
24 * averages of an even and odd number cannot be represented, and will be
25 * rounded down.
26 */
27 function average(uint256 a, uint256 b) internal pure returns (uint256) {
28 // (a + b) / 2 can overflow, so we distribute
29 return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
30 }
31 }
32 
33 
34 /**
35 * @title Roles
36 * @dev Library for managing addresses assigned to a Role.
37 */
38 library Roles {
39 struct Role {
40 mapping (address => bool) bearer;
41 }
42 
43 /**
44 * @dev give an account access to this role
45 */
46 function add(Role storage role, address account) internal {
47 require(account != address(0));
48 require(!has(role, account));
49 
50 role.bearer[account] = true;
51 }
52 
53 /**
54 * @dev remove an account's access to this role
55 */
56 function remove(Role storage role, address account) internal {
57 require(account != address(0));
58 require(has(role, account));
59 
60 role.bearer[account] = false;
61 }
62 
63 /**
64 * @dev check if an account has this role
65 * @return bool
66 */
67 function has(Role storage role, address account) internal view returns (bool) {
68 require(account != address(0));
69 return role.bearer[account];
70 }
71 }
72 
73 
74 /**
75 * @title SafeMath
76 * @dev Unsigned math operations with safety checks that revert on error
77 */
78 library SafeMath {
79 /**
80 * @dev Multiplies two unsigned integers, reverts on overflow.
81 */
82 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83 // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
84 // benefit is lost if 'b' is also tested.
85 // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
86 if (a == 0) {
87 return 0;
88 }
89 
90 uint256 c = a * b;
91 require(c / a == b);
92 
93 return c;
94 }
95 
96 /**
97 * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
98 */
99 function div(uint256 a, uint256 b) internal pure returns (uint256) {
100 // Solidity only automatically asserts when dividing by 0
101 require(b > 0);
102 uint256 c = a / b;
103 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104 
105 return c;
106 }
107 
108 /**
109 * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
110 */
111 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112 require(b <= a);
113 uint256 c = a - b;
114 
115 return c;
116 }
117 
118 /**
119 * @dev Adds two unsigned integers, reverts on overflow.
120 */
121 function add(uint256 a, uint256 b) internal pure returns (uint256) {
122 uint256 c = a + b;
123 require(c >= a);
124 
125 return c;
126 }
127 
128 /**
129 * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
130 * reverts when dividing by zero.
131 */
132 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
133 require(b != 0);
134 return a % b;
135 }
136 }
137 
138 
139 
140 
141 contract MinterRole {
142 using Roles for Roles.Role;
143 
144 event MinterAdded(address indexed account);
145 event MinterRemoved(address indexed account);
146 
147 Roles.Role private _minters;
148 
149 constructor () internal {
150 _addMinter(msg.sender);
151 }
152 
153 modifier onlyMinter() {
154 require(isMinter(msg.sender));
155 _;
156 }
157 
158 function isMinter(address account) public view returns (bool) {
159 return _minters.has(account);
160 }
161 
162 function addMinter(address account) public onlyMinter {
163 _addMinter(account);
164 }
165 
166 function renounceMinter() public {
167 _removeMinter(msg.sender);
168 }
169 
170 function _addMinter(address account) internal {
171 _minters.add(account);
172 emit MinterAdded(account);
173 }
174 
175 function _removeMinter(address account) internal {
176 _minters.remove(account);
177 emit MinterRemoved(account);
178 }
179 }
180 
181 
182 /**
183 * @title ERC20 interface
184 * @dev see https://eips.ethereum.org/EIPS/eip-20
185 */
186 interface IERC20 {
187 function transfer(address to, uint256 value) external returns (bool);
188 
189 function approve(address spender, uint256 value) external returns (bool);
190 
191 function transferFrom(address from, address to, uint256 value) external returns (bool);
192 
193 function totalSupply() external view returns (uint256);
194 
195 function balanceOf(address who) external view returns (uint256);
196 
197 function allowance(address owner, address spender) external view returns (uint256);
198 
199 event Transfer(address indexed from, address indexed to, uint256 value);
200 
201 event Approval(address indexed owner, address indexed spender, uint256 value);
202 }
203 
204 
205 contract ApproveAndCallFallBack {
206 function receiveApproval(address from, uint256 _amount, address _token, bytes memory _data) public;
207 }
208 
209 
210 
211 
212 
213 
214 
215 /**
216 * @title Standard ERC20 token
217 *
218 * @dev Implementation of the basic standard token.
219 * https://eips.ethereum.org/EIPS/eip-20
220 * Originally based on code by FirstBlood:
221 * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
222 *
223 * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
224 * all accounts just by listening to said events. Note that this isn't required by the specification, and other
225 * compliant implementations may not do it.
226 */
227 contract ERC20 is IERC20 {
228 using SafeMath for uint256;
229 
230 mapping (address => uint256) private _balances;
231 
232 mapping (address => mapping (address => uint256)) private _allowed;
233 
234 uint256 private _totalSupply;
235 
236 /**
237 * @dev Total number of tokens in existence
238 */
239 function totalSupply() public view returns (uint256) {
240 return _totalSupply;
241 }
242 
243 /**
244 * @dev Gets the balance of the specified address.
245 * @param owner The address to query the balance of.
246 * @return A uint256 representing the amount owned by the passed address.
247 */
248 function balanceOf(address owner) public view returns (uint256) {
249 return _balances[owner];
250 }
251 
252 /**
253 * @dev Function to check the amount of tokens that an owner allowed to a spender.
254 * @param owner address The address which owns the funds.
255 * @param spender address The address which will spend the funds.
256 * @return A uint256 specifying the amount of tokens still available for the spender.
257 */
258 function allowance(address owner, address spender) public view returns (uint256) {
259 return _allowed[owner][spender];
260 }
261 
262 /**
263 * @dev Transfer token to a specified address
264 * @param to The address to transfer to.
265 * @param value The amount to be transferred.
266 */
267 function transfer(address to, uint256 value) public returns (bool) {
268 _transfer(msg.sender, to, value);
269 return true;
270 }
271 
272 /**
273 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
274 * Beware that changing an allowance with this method brings the risk that someone may use both the old
275 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
276 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
277 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
278 * @param spender The address which will spend the funds.
279 * @param value The amount of tokens to be spent.
280 */
281 function approve(address spender, uint256 value) public returns (bool) {
282 _approve(msg.sender, spender, value);
283 return true;
284 }
285 
286 /**
287 * @dev Transfer tokens from one address to another.
288 * Note that while this function emits an Approval event, this is not required as per the specification,
289 * and other compliant implementations may not emit the event.
290 * @param from address The address which you want to send tokens from
291 * @param to address The address which you want to transfer to
292 * @param value uint256 the amount of tokens to be transferred
293 */
294 function transferFrom(address from, address to, uint256 value) public returns (bool) {
295 _transfer(from, to, value);
296 _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
297 return true;
298 }
299 
300 /**
301 * @dev Increase the amount of tokens that an owner allowed to a spender.
302 * approve should be called when _allowed[msg.sender][spender] == 0. To increment
303 * allowed value is better to use this function to avoid 2 calls (and wait until
304 * the first transaction is mined)
305 * From MonolithDAO Token.sol
306 * Emits an Approval event.
307 * @param spender The address which will spend the funds.
308 * @param addedValue The amount of tokens to increase the allowance by.
309 */
310 function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
311 _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
312 return true;
313 }
314 
315 /**
316 * @dev Decrease the amount of tokens that an owner allowed to a spender.
317 * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
318 * allowed value is better to use this function to avoid 2 calls (and wait until
319 * the first transaction is mined)
320 * From MonolithDAO Token.sol
321 * Emits an Approval event.
322 * @param spender The address which will spend the funds.
323 * @param subtractedValue The amount of tokens to decrease the allowance by.
324 */
325 function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
326 _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
327 return true;
328 }
329 
330 /**
331 * @dev Transfer token for a specified addresses
332 * @param from The address to transfer from.
333 * @param to The address to transfer to.
334 * @param value The amount to be transferred.
335 */
336 function _transfer(address from, address to, uint256 value) internal {
337 require(to != address(0));
338 
339 _balances[from] = _balances[from].sub(value);
340 _balances[to] = _balances[to].add(value);
341 emit Transfer(from, to, value);
342 }
343 
344 /**
345 * @dev Internal function that mints an amount of the token and assigns it to
346 * an account. This encapsulates the modification of balances such that the
347 * proper events are emitted.
348 * @param account The account that will receive the created tokens.
349 * @param value The amount that will be created.
350 */
351 function _mint(address account, uint256 value) internal {
352 require(account != address(0));
353 
354 _totalSupply = _totalSupply.add(value);
355 _balances[account] = _balances[account].add(value);
356 emit Transfer(address(0), account, value);
357 }
358 
359 /**
360 * @dev Internal function that burns an amount of the token of a given
361 * account.
362 * @param account The account whose tokens will be burnt.
363 * @param value The amount that will be burnt.
364 */
365 function _burn(address account, uint256 value) internal {
366 require(account != address(0));
367 
368 _totalSupply = _totalSupply.sub(value);
369 _balances[account] = _balances[account].sub(value);
370 emit Transfer(account, address(0), value);
371 }
372 
373 /**
374 * @dev Approve an address to spend another addresses' tokens.
375 * @param owner The address that owns the tokens.
376 * @param spender The address that will spend the tokens.
377 * @param value The number of tokens that can be spent.
378 */
379 function _approve(address owner, address spender, uint256 value) internal {
380 require(spender != address(0));
381 require(owner != address(0));
382 
383 _allowed[owner][spender] = value;
384 emit Approval(owner, spender, value);
385 }
386 
387 /**
388 * @dev Internal function that burns an amount of the token of a given
389 * account, deducting from the sender's allowance for said account. Uses the
390 * internal burn function.
391 * Emits an Approval event (reflecting the reduced allowance).
392 * @param account The account whose tokens will be burnt.
393 * @param value The amount that will be burnt.
394 */
395 function _burnFrom(address account, uint256 value) internal {
396 _burn(account, value);
397 _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
398 }
399 }
400 
401 
402 
403 /**
404 * @title Ownable
405 * @dev The Ownable contract has an owner address, and provides basic authorization control
406 * functions, this simplifies the implementation of "user permissions".
407 */
408 contract Ownable {
409 address private _owner;
410 
411 event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
412 
413 /**
414 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
415 * account.
416 */
417 constructor () internal {
418 _owner = msg.sender;
419 emit OwnershipTransferred(address(0), _owner);
420 }
421 
422 /**
423 * @return the address of the owner.
424 */
425 function owner() public view returns (address) {
426 return _owner;
427 }
428 
429 /**
430 * @dev Throws if called by any account other than the owner.
431 */
432 modifier onlyOwner() {
433 require(isOwner());
434 _;
435 }
436 
437 /**
438 * @return true if `msg.sender` is the owner of the contract.
439 */
440 function isOwner() public view returns (bool) {
441 return msg.sender == _owner;
442 }
443 
444 /**
445 * @dev Allows the current owner to relinquish control of the contract.
446 * It will not be possible to call the functions with the `onlyOwner`
447 * modifier anymore.
448 * @notice Renouncing ownership will leave the contract without an owner,
449 * thereby removing any functionality that is only available to the owner.
450 */
451 function renounceOwnership() public onlyOwner {
452 emit OwnershipTransferred(_owner, address(0));
453 _owner = address(0);
454 }
455 
456 /**
457 * @dev Allows the current owner to transfer control of the contract to a newOwner.
458 * @param newOwner The address to transfer ownership to.
459 */
460 function transferOwnership(address newOwner) public onlyOwner {
461 _transferOwnership(newOwner);
462 }
463 
464 /**
465 * @dev Transfers control of the contract to a newOwner.
466 * @param newOwner The address to transfer ownership to.
467 */
468 function _transferOwnership(address newOwner) internal {
469 require(newOwner != address(0));
470 emit OwnershipTransferred(_owner, newOwner);
471 _owner = newOwner;
472 }
473 }
474 
475 
476 
477 
478 
479 
480 
481 
482 
483 
484 /**
485 * @title ERC20Detailed token
486 * @dev The decimals are only for visualization purposes.
487 * All the operations are done using the smallest and indivisible token unit,
488 * just as on Ethereum all the operations are done in wei.
489 */
490 contract ERC20Detailed is IERC20 {
491 string private _name;
492 string private _symbol;
493 uint8 private _decimals;
494 
495 constructor (string memory name, string memory symbol, uint8 decimals) public {
496 _name = name;
497 _symbol = symbol;
498 _decimals = decimals;
499 }
500 
501 /**
502 * @return the name of the token.
503 */
504 function name() public view returns (string memory) {
505 return _name;
506 }
507 
508 /**
509 * @return the symbol of the token.
510 */
511 function symbol() public view returns (string memory) {
512 return _symbol;
513 }
514 
515 /**
516 * @return the number of decimals of the token.
517 */
518 function decimals() public view returns (uint8) {
519 return _decimals;
520 }
521 }
522 
523 
524 
525 
526 
527 
528 /**
529 * @title ERC20Mintable
530 * @dev ERC20 minting logic
531 */
532 contract ERC20Mintable is ERC20, MinterRole {
533 /**
534 * @dev Function to mint tokens
535 * @param to The address that will receive the minted tokens.
536 * @param value The amount of tokens to mint.
537 * @return A boolean that indicates if the operation was successful.
538 */
539 function mint(address to, uint256 value) public onlyMinter returns (bool) {
540 _mint(to, value);
541 return true;
542 }
543 }
544 
545 
546 
547 
548 
549 /**
550 * @title Capped token
551 * @dev Mintable token with a token cap.
552 */
553 contract ERC20Capped is ERC20Mintable {
554 uint256 private _cap;
555 
556 constructor (uint256 cap) public {
557 require(cap > 0);
558 _cap = cap;
559 }
560 
561 /**
562 * @return the cap for the token minting.
563 */
564 function cap() public view returns (uint256) {
565 return _cap;
566 }
567 
568 function _mint(address account, uint256 value) internal {
569 require(totalSupply().add(value) <= _cap);
570 super._mint(account, value);
571 }
572 }
573 
574 
575 contract PictosisGenesisToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Capped {
576 address public exchangeContract;
577 
578 constructor()
579 ERC20Capped(125000000000000000000000000)
580 ERC20Mintable()
581 ERC20Detailed("Pictosis Genesis Token", "PICTO-G", 18)
582 ERC20()
583 public
584 {
585 }
586 
587 function burnFrom(address from, uint256 value) public onlyMinter {
588 _burnFrom(from, value);
589 }
590 
591 function setExchangeContract(address _exchangeContract) public onlyMinter {
592 exchangeContract = _exchangeContract;
593 }
594 
595 function completeExchange(address from) public {
596 require(msg.sender == exchangeContract && exchangeContract != address(0), "Only the exchange contract can invoke this function");
597 _burnFrom(from, balanceOf(from));
598 }
599 
600 function transfer(address to, uint256 value) public returns (bool) {
601 revert("Token can only be exchanged for PICTO tokens in the exchange contract");
602 }
603 
604 uint256 constant D160 = 0x0010000000000000000000000000000000000000000;
605 
606 // data is an array of uint256s. Each uint256 represents a transfer.
607 // The 160 LSB is the destination of the address that wants to be sent
608 // The 96 MSB is the amount of tokens that wants to be sent.
609 // i.e. assume we want to mint 1200 tokens for address 0xABCDEFAABBCCDDEEFF1122334455667788990011
610 // 1200 in hex: 0x0000410d586a20a4c00000. Concatenate this value and the address
611 // ["0x0000410d586a20a4c00000ABCDEFAABBCCDDEEFF1122334455667788990011"]
612 function multiMint(uint256[] memory data) public onlyMinter {
613 for (uint256 i = 0; i < data.length; i++) {
614 address addr = address(data[i] & (D160 - 1));
615 uint256 amount = data[i] / D160;
616 _mint(addr, amount);
617 }
618 }
619 
620 /// @notice This method can be used by the minter to extract mistakenly
621 /// sent tokens to this contract.
622 /// @param _token The address of the token contract that you want to recover
623 /// set to 0x0000...0000 in case you want to extract ether.
624 function claimTokens(address _token) public onlyMinter {
625 if (_token == address(0)) {
626 msg.sender.transfer(address(this).balance);
627 return;
628 }
629 
630 ERC20 token = ERC20(_token);
631 uint256 balance = token.balanceOf(address(this));
632 token.transfer(msg.sender, balance);
633 emit ClaimedTokens(_token, msg.sender, balance);
634 }
635 
636 event ClaimedTokens(address indexed _token, address indexed _sender, uint256 _amount);
637 
638 }
639 
640 
641 
642 
643 
644 
645 
646 
647 
648 
649 
650 
651 
652 
653 
654 /**
655 * @title Arrays
656 * @dev Utility library of inline array functions
657 */
658 library Arrays {
659 /**
660 * @dev Upper bound search function which is kind of binary search algorithm. It searches sorted
661 * array to find index of the element value. If element is found then returns its index otherwise
662 * it returns index of first element which is greater than searched value. If searched element is
663 * bigger than any array element function then returns first index after last element (i.e. all
664 * values inside the array are smaller than the target). Complexity O(log n).
665 * @param array The array sorted in ascending order.
666 * @param element The element's value to be found.
667 * @return The calculated index value. Returns 0 for empty array.
668 */
669 function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
670 if (array.length == 0) {
671 return 0;
672 }
673 
674 uint256 low = 0;
675 uint256 high = array.length;
676 
677 while (low < high) {
678 uint256 mid = Math.average(low, high);
679 
680 // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
681 // because Math.average rounds down (it does integer division with truncation).
682 if (array[mid] > element) {
683 high = mid;
684 } else {
685 low = mid + 1;
686 }
687 }
688 
689 // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
690 if (low > 0 && array[low - 1] == element) {
691 return low - 1;
692 } else {
693 return low;
694 }
695 }
696 }
697 
698 
699 
700 
701 
702 /**
703 * @title Counters
704 * @author Matt Condon (@shrugs)
705 * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
706 * of elements in a mapping, issuing ERC721 ids, or counting request ids
707 *
708 * Include with `using Counters for Counters.Counter;`
709 * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
710 * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
711 * directly accessed.
712 */
713 library Counters {
714 using SafeMath for uint256;
715 
716 struct Counter {
717 // This variable should never be directly accessed by users of the library: interactions must be restricted to
718 // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
719 // this feature: see https://github.com/ethereum/solidity/issues/4637
720 uint256 _value; // default: 0
721 }
722 
723 function current(Counter storage counter) internal view returns (uint256) {
724 return counter._value;
725 }
726 
727 function increment(Counter storage counter) internal {
728 counter._value += 1;
729 }
730 
731 function decrement(Counter storage counter) internal {
732 counter._value = counter._value.sub(1);
733 }
734 }
735 
736 
737 
738 /**
739 * @title ERC20 token with snapshots.
740 * @dev Inspired by Jordi Baylina's MiniMeToken to record historical balances:
741 * https://github.com/Giveth/minime/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
742 * When a snapshot is made, the balances and totalSupply at the time of the snapshot are recorded for later
743 * access.
744 *
745 * To make a snapshot, call the `snapshot` function, which will emit the `Snapshot` event and return a snapshot id.
746 * To get the total supply from a snapshot, call the function `totalSupplyAt` with the snapshot id.
747 * To get the balance of an account from a snapshot, call the `balanceOfAt` function with the snapshot id and the
748 * account address.
749 * @author Validity Labs AG <info@validitylabs.org>
750 */
751 contract ERC20Snapshot is ERC20 {
752 using SafeMath for uint256;
753 using Arrays for uint256[];
754 using Counters for Counters.Counter;
755 
756 // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
757 // Snapshot struct, but that would impede usage of functions that work on an array.
758 struct Snapshots {
759 uint256[] ids;
760 uint256[] values;
761 }
762 
763 mapping (address => Snapshots) private _accountBalanceSnapshots;
764 Snapshots private _totalSupplySnaphots;
765 
766 // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
767 Counters.Counter private _currentSnapshotId;
768 
769 event Snapshot(uint256 id);
770 
771 // Creates a new snapshot id. Balances are only stored in snapshots on demand: unless a snapshot was taken, a
772 // balance change will not be recorded. This means the extra added cost of storing snapshotted balances is only paid
773 // when required, but is also flexible enough that it allows for e.g. daily snapshots.
774 function snapshot() public returns (uint256) {
775 _currentSnapshotId.increment();
776 
777 uint256 currentId = _currentSnapshotId.current();
778 emit Snapshot(currentId);
779 return currentId;
780 }
781 
782 function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
783 (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
784 
785 return snapshotted ? value : balanceOf(account);
786 }
787 
788 function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
789 (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnaphots);
790 
791 return snapshotted ? value : totalSupply();
792 }
793 
794 // _transfer, _mint and _burn are the only functions where the balances are modified, so it is there that the
795 // snapshots are updated. Note that the update happens _before_ the balance change, with the pre-modified value.
796 // The same is true for the total supply and _mint and _burn.
797 function _transfer(address from, address to, uint256 value) internal {
798 _updateAccountSnapshot(from);
799 _updateAccountSnapshot(to);
800 
801 super._transfer(from, to, value);
802 }
803 
804 function _mint(address account, uint256 value) internal {
805 _updateAccountSnapshot(account);
806 _updateTotalSupplySnapshot();
807 
808 super._mint(account, value);
809 }
810 
811 function _burn(address account, uint256 value) internal {
812 _updateAccountSnapshot(account);
813 _updateTotalSupplySnapshot();
814 
815 super._burn(account, value);
816 }
817 
818 // When a valid snapshot is queried, there are three possibilities:
819 // a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
820 // created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
821 // to this id is the current one.
822 // b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
823 // requested id, and its value is the one to return.
824 // c) More snapshots were created after the requested one, and the queried value was later modified. There will be
825 // no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
826 // larger than the requested one.
827 //
828 // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
829 // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
830 // exactly this.
831 function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
832 private view returns (bool, uint256)
833 {
834 require(snapshotId > 0);
835 require(snapshotId <= _currentSnapshotId.current());
836 
837 uint256 index = snapshots.ids.findUpperBound(snapshotId);
838 
839 if (index == snapshots.ids.length) {
840 return (false, 0);
841 } else {
842 return (true, snapshots.values[index]);
843 }
844 }
845 
846 function _updateAccountSnapshot(address account) private {
847 _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
848 }
849 
850 function _updateTotalSupplySnapshot() private {
851 _updateSnapshot(_totalSupplySnaphots, totalSupply());
852 }
853 
854 function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
855 uint256 currentId = _currentSnapshotId.current();
856 if (_lastSnapshotId(snapshots.ids) < currentId) {
857 snapshots.ids.push(currentId);
858 snapshots.values.push(currentValue);
859 }
860 }
861 
862 function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
863 if (ids.length == 0) {
864 return 0;
865 } else {
866 return ids[ids.length - 1];
867 }
868 }
869 }
870 
871 
872 
873 
874 contract PictosisToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Capped, ERC20Snapshot, Ownable {
875 uint transfersEnabledDate;
876 
877 modifier onlyTransfersEnabled() {
878 require(block.timestamp >= transfersEnabledDate, "Transfers disabled");
879 _;
880 }
881 
882 constructor(uint _enableTransfersDate, uint _cap)
883 ERC20Capped(_cap)
884 ERC20Mintable()
885 ERC20Detailed("Pictosis Token", "PICTO", 18)
886 ERC20()
887 Ownable()
888 public
889 {
890 transfersEnabledDate = _enableTransfersDate;
891 }
892 
893 function areTransfersEnabled() public view returns(bool) {
894 return block.timestamp >= transfersEnabledDate;
895 }
896 
897 function transfer(
898 address to,
899 uint256 value
900 )
901 public
902 onlyTransfersEnabled
903 returns (bool)
904 {
905 return super.transfer(to, value);
906 }
907 
908 function transferFrom(
909 address from,
910 address to,
911 uint256 value
912 )
913 public
914 onlyTransfersEnabled
915 returns (bool)
916 {
917 return super.transferFrom(from, to, value);
918 }
919 
920 /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
921 /// its behalf, and then a function is triggered in the contract that is
922 /// being approved, `_spender`. This allows users to use their tokens to
923 /// interact with contracts in one function call instead of two
924 /// @param _spender The address of the contract able to transfer the tokens
925 /// @param _amount The amount of tokens to be approved for transfer
926 /// @return True if the function call was successful
927 function approveAndCall(
928 address _spender,
929 uint256 _amount,
930 bytes memory _extraData
931 )
932 public
933 returns (bool success)
934 {
935 require(approve(_spender, _amount), "Couldn't approve spender");
936 
937 ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _amount, address(this), _extraData);
938 
939 return true;
940 }
941 }
942 
943 contract PictosisGenesisExchanger is Ownable {
944 using SafeMath for uint256;
945 
946 mapping (address => uint256) public collected;
947 uint256 public totalCollected;
948 
949 PictosisGenesisToken public genesis;
950 PictosisToken public picto;
951 
952 constructor(address _genesis, address _picto) public {
953 genesis = PictosisGenesisToken(_genesis);
954 picto = PictosisToken(_picto);
955 }
956 
957 /// @notice Can collect tokens;
958 function canCollect() public view returns(bool) {
959 return picto.areTransfersEnabled();
960 }
961 
962 /// @notice This method should be called by the genesis holders to collect their picto token. Requires approval
963 function collect() public {
964 require(picto.areTransfersEnabled(), "Cannot collect tokens yet");
965 
966 uint balance = genesis.balanceOf(msg.sender);
967 uint256 amountToSend = balance.sub(collected[msg.sender]);
968 
969 require(balance >= collected[msg.sender], "Balance must be greater than collected amount");
970 require(amountToSend > 0, "No tokens available or already exchanged");
971 require(picto.balanceOf(address(this)) >= amountToSend, "Exchanger does not have funds available");
972 
973 totalCollected = totalCollected.add(amountToSend);
974 collected[msg.sender] = collected[msg.sender].add(amountToSend);
975 
976 require(picto.transfer(msg.sender, amountToSend), "Transfer failure");
977 
978 emit TokensCollected(msg.sender, amountToSend);
979 }
980 
981 /// @notice This method can be used by the minter to extract mistakenly
982 /// sent tokens to this contract.
983 /// @param _token The address of the token contract that you want to recover
984 /// set to 0x0000...0000 in case you want to extract ether.
985 function claimTokens(address _token) public onlyOwner {
986 if (_token == address(0)) {
987 msg.sender.transfer(address(this).balance);
988 return;
989 }
990 
991 ERC20 token = ERC20(_token);
992 uint256 balance = token.balanceOf(address(this));
993 
994 if(_token == address(picto)){
995 if(balance > genesis.totalSupply()){
996 balance = balance.sub(genesis.totalSupply());
997 }
998 require(balance >= genesis.totalSupply(), "Cannot withdraw PICTO until everyone exchanges the tokens");
999 }
1000 
1001 token.transfer(msg.sender, balance);
1002 emit ClaimedTokens(_token, msg.sender, balance);
1003 }
1004 
1005 event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
1006 event TokensCollected(address indexed _holder, uint256 _amount);
1007 }