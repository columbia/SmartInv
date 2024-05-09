1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @dev Standard math utilities missing in the Solidity language.
6  */
7 library Math {
8     /**
9      * @dev Returns the largest of two numbers.
10      */
11     function max(uint256 a, uint256 b) internal pure returns (uint256) {
12         return a >= b ? a : b;
13     }
14 
15     /**
16      * @dev Returns the smallest of two numbers.
17      */
18     function min(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a < b ? a : b;
20     }
21 
22     /**
23      * @dev Returns the average of two numbers. The result is rounded towards
24      * zero.
25      */
26     function average(uint256 a, uint256 b) internal pure returns (uint256) {
27         // (a + b) / 2 can overflow, so we distribute
28         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
29     }
30 }
31 
32 /*
33  * @dev Provides information about the current execution context, including the
34  * sender of the transaction and its data. While these are generally available
35  * via msg.sender and msg.data, they should not be accessed in such a direct
36  * manner, since when dealing with GSN meta-transactions the account sending and
37  * paying for execution may not be the actual sender (as far as an application
38  * is concerned).
39  *
40  * This contract is only required for intermediate, library-like contracts.
41  */
42 contract Context {
43     // Empty internal constructor, to prevent people from mistakenly deploying
44     // an instance of this contract, which should be used via inheritance.
45     constructor () internal { }
46     // solhint-disable-previous-line no-empty-blocks
47 
48     function _msgSender() internal view returns (address payable) {
49         return msg.sender;
50     }
51 
52     function _msgData() internal view returns (bytes memory) {
53         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
54         return msg.data;
55     }
56 }
57 
58 /**
59  * @dev Contract module which provides a basic access control mechanism, where
60  * there is an account (an owner) that can be granted exclusive access to
61  * specific functions.
62  *
63  * This module is used through inheritance. It will make available the modifier
64  * `onlyOwner`, which can be applied to your functions to restrict their use to
65  * the owner.
66  */
67 contract Ownable is Context {
68     address private _owner;
69 
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     /**
73      * @dev Initializes the contract setting the deployer as the initial owner.
74      */
75     constructor () internal {
76         address msgSender = _msgSender();
77         _owner = msgSender;
78         emit OwnershipTransferred(address(0), msgSender);
79     }
80 
81     /**
82      * @dev Returns the address of the current owner.
83      */
84     function owner() public view returns (address) {
85         return _owner;
86     }
87 
88     /**
89      * @dev Throws if called by any account other than the owner.
90      */
91     modifier onlyOwner() {
92         require(isOwner(), "Ownable: caller is not the owner");
93         _;
94     }
95 
96     /**
97      * @dev Returns true if the caller is the current owner.
98      */
99     function isOwner() public view returns (bool) {
100         return _msgSender() == _owner;
101     }
102 
103     /**
104      * @dev Leaves the contract without owner. It will not be possible to call
105      * `onlyOwner` functions anymore. Can only be called by the current owner.
106      *
107      * NOTE: Renouncing ownership will leave the contract without an owner,
108      * thereby removing any functionality that is only available to the owner.
109      */
110     function renounceOwnership() public onlyOwner {
111         emit OwnershipTransferred(_owner, address(0));
112         _owner = address(0);
113     }
114 
115     /**
116      * @dev Transfers ownership of the contract to a new account (`newOwner`).
117      * Can only be called by the current owner.
118      */
119     function transferOwnership(address newOwner) public onlyOwner {
120         _transferOwnership(newOwner);
121     }
122 
123     /**
124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
125      */
126     function _transferOwnership(address newOwner) internal {
127         require(newOwner != address(0), "Ownable: new owner is the zero address");
128         emit OwnershipTransferred(_owner, newOwner);
129         _owner = newOwner;
130     }
131 }
132 
133 /**
134  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
135  * the optional functions; to access them see {ERC20Detailed}.
136  */
137 interface IERC20 {
138     /**
139      * @dev Returns the amount of tokens in existence.
140      */
141     function totalSupply() external view returns (uint256);
142 
143     /**
144      * @dev Returns the amount of tokens owned by `account`.
145      */
146     function balanceOf(address account) external view returns (uint256);
147 
148     /**
149      * @dev Moves `amount` tokens from the caller's account to `recipient`.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transfer(address recipient, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Returns the remaining number of tokens that `spender` will be
159      * allowed to spend on behalf of `owner` through {transferFrom}. This is
160      * zero by default.
161      *
162      * This value changes when {approve} or {transferFrom} are called.
163      */
164     function allowance(address owner, address spender) external view returns (uint256);
165 
166     /**
167      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * IMPORTANT: Beware that changing an allowance with this method brings the risk
172      * that someone may use both the old and the new allowance by unfortunate
173      * transaction ordering. One possible solution to mitigate this race
174      * condition is to first reduce the spender's allowance to 0 and set the
175      * desired value afterwards:
176      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177      *
178      * Emits an {Approval} event.
179      */
180     function approve(address spender, uint256 amount) external returns (bool);
181 
182     /**
183      * @dev Moves `amount` tokens from `sender` to `recipient` using the
184      * allowance mechanism. `amount` is then deducted from the caller's
185      * allowance.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
192 
193     /**
194      * @dev Emitted when `value` tokens are moved from one account (`from`) to
195      * another (`to`).
196      *
197      * Note that `value` may be zero.
198      */
199     event Transfer(address indexed from, address indexed to, uint256 value);
200 
201     /**
202      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
203      * a call to {approve}. `value` is the new allowance.
204      */
205     event Approval(address indexed owner, address indexed spender, uint256 value);
206 }
207 
208 /**
209  * @title Roles
210  * @dev Library for managing addresses assigned to a Role.
211  */
212 library Roles {
213     struct Role {
214         mapping (address => bool) bearer;
215     }
216 
217     /**
218      * @dev Give an account access to this role.
219      */
220     function add(Role storage role, address account) internal {
221         require(!has(role, account), "Roles: account already has role");
222         role.bearer[account] = true;
223     }
224 
225     /**
226      * @dev Remove an account's access to this role.
227      */
228     function remove(Role storage role, address account) internal {
229         require(has(role, account), "Roles: account does not have role");
230         role.bearer[account] = false;
231     }
232 
233     /**
234      * @dev Check if an account has this role.
235      * @return bool
236      */
237     function has(Role storage role, address account) internal view returns (bool) {
238         require(account != address(0), "Roles: account is the zero address");
239         return role.bearer[account];
240     }
241 }
242 
243 contract PauserRole is Context {
244     using Roles for Roles.Role;
245 
246     event PauserAdded(address indexed account);
247     event PauserRemoved(address indexed account);
248 
249     Roles.Role private _pausers;
250 
251     constructor () internal {
252         _addPauser(_msgSender());
253     }
254 
255     modifier onlyPauser() {
256         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
257         _;
258     }
259 
260     function isPauser(address account) public view returns (bool) {
261         return _pausers.has(account);
262     }
263 
264     function addPauser(address account) public onlyPauser {
265         _addPauser(account);
266     }
267 
268     function renouncePauser() public {
269         _removePauser(_msgSender());
270     }
271 
272     function _addPauser(address account) internal {
273         _pausers.add(account);
274         emit PauserAdded(account);
275     }
276 
277     function _removePauser(address account) internal {
278         _pausers.remove(account);
279         emit PauserRemoved(account);
280     }
281 }
282 
283 /**
284  * @dev Contract module which allows children to implement an emergency stop
285  * mechanism that can be triggered by an authorized account.
286  *
287  * This module is used through inheritance. It will make available the
288  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
289  * the functions of your contract. Note that they will not be pausable by
290  * simply including this module, only once the modifiers are put in place.
291  */
292 contract Pausable is Context, PauserRole {
293     /**
294      * @dev Emitted when the pause is triggered by a pauser (`account`).
295      */
296     event Paused(address account);
297 
298     /**
299      * @dev Emitted when the pause is lifted by a pauser (`account`).
300      */
301     event Unpaused(address account);
302 
303     bool private _paused;
304 
305     /**
306      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
307      * to the deployer.
308      */
309     constructor () internal {
310         _paused = false;
311     }
312 
313     /**
314      * @dev Returns true if the contract is paused, and false otherwise.
315      */
316     function paused() public view returns (bool) {
317         return _paused;
318     }
319 
320     /**
321      * @dev Modifier to make a function callable only when the contract is not paused.
322      */
323     modifier whenNotPaused() {
324         require(!_paused, "Pausable: paused");
325         _;
326     }
327 
328     /**
329      * @dev Modifier to make a function callable only when the contract is paused.
330      */
331     modifier whenPaused() {
332         require(_paused, "Pausable: not paused");
333         _;
334     }
335 
336     /**
337      * @dev Called by a pauser to pause, triggers stopped state.
338      */
339     function pause() public onlyPauser whenNotPaused {
340         _paused = true;
341         emit Paused(_msgSender());
342     }
343 
344     /**
345      * @dev Called by a pauser to unpause, returns to normal state.
346      */
347     function unpause() public onlyPauser whenPaused {
348         _paused = false;
349         emit Unpaused(_msgSender());
350     }
351 }
352 
353 contract MinterRole is Context {
354     using Roles for Roles.Role;
355 
356     event MinterAdded(address indexed account);
357     event MinterRemoved(address indexed account);
358 
359     Roles.Role private _minters;
360 
361     constructor () internal {
362         _addMinter(_msgSender());
363     }
364 
365     modifier onlyMinter() {
366         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
367         _;
368     }
369 
370     function isMinter(address account) public view returns (bool) {
371         return _minters.has(account);
372     }
373 
374     function addMinter(address account) public onlyMinter {
375         _addMinter(account);
376     }
377 
378     function renounceMinter() public {
379         _removeMinter(_msgSender());
380     }
381 
382     function _addMinter(address account) internal {
383         _minters.add(account);
384         emit MinterAdded(account);
385     }
386 
387     function _removeMinter(address account) internal {
388         _minters.remove(account);
389         emit MinterRemoved(account);
390     }
391 }
392 
393 /**
394  * @title WhitelistAdminRole
395  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
396  */
397 contract WhitelistAdminRole is Context {
398     using Roles for Roles.Role;
399 
400     event WhitelistAdminAdded(address indexed account);
401     event WhitelistAdminRemoved(address indexed account);
402 
403     Roles.Role private _whitelistAdmins;
404 
405     constructor () internal {
406         _addWhitelistAdmin(_msgSender());
407     }
408 
409     modifier onlyWhitelistAdmin() {
410         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
411         _;
412     }
413 
414     function isWhitelistAdmin(address account) public view returns (bool) {
415         return _whitelistAdmins.has(account);
416     }
417 
418     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
419         _addWhitelistAdmin(account);
420     }
421 
422     function renounceWhitelistAdmin() public {
423         _removeWhitelistAdmin(_msgSender());
424     }
425 
426     function _addWhitelistAdmin(address account) internal {
427         _whitelistAdmins.add(account);
428         emit WhitelistAdminAdded(account);
429     }
430 
431     function _removeWhitelistAdmin(address account) internal {
432         _whitelistAdmins.remove(account);
433         emit WhitelistAdminRemoved(account);
434     }
435 }
436 
437 /**
438  * @title ERC165
439  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
440  */
441 interface IERC165 {
442 
443     /**
444      * @notice Query if a contract implements an interface
445      * @dev Interface identification is specified in ERC-165. This function
446      * uses less than 30,000 gas
447      * @param _interfaceId The interface identifier, as specified in ERC-165
448      */
449     function supportsInterface(bytes4 _interfaceId)
450     external
451     view
452     returns (bool);
453 }
454 
455 /**
456  * @title SafeMath
457  * @dev Unsigned math operations with safety checks that revert on error
458  */
459 library SafeMath {
460 
461   /**
462    * @dev Multiplies two unsigned integers, reverts on overflow.
463    */
464   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
465     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
466     // benefit is lost if 'b' is also tested.
467     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
468     if (a == 0) {
469       return 0;
470     }
471 
472     uint256 c = a * b;
473     require(c / a == b, "SafeMath#mul: OVERFLOW");
474 
475     return c;
476   }
477 
478   /**
479    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
480    */
481   function div(uint256 a, uint256 b) internal pure returns (uint256) {
482     // Solidity only automatically asserts when dividing by 0
483     require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
484     uint256 c = a / b;
485     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
486 
487     return c;
488   }
489 
490   /**
491    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
492    */
493   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
494     require(b <= a, "SafeMath#sub: UNDERFLOW");
495     uint256 c = a - b;
496 
497     return c;
498   }
499 
500   /**
501    * @dev Adds two unsigned integers, reverts on overflow.
502    */
503   function add(uint256 a, uint256 b) internal pure returns (uint256) {
504     uint256 c = a + b;
505     require(c >= a, "SafeMath#add: OVERFLOW");
506 
507     return c; 
508   }
509 
510   /**
511    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
512    * reverts when dividing by zero.
513    */
514   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
515     require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
516     return a % b;
517   }
518 
519 }
520 
521 /**
522  * @dev ERC-1155 interface for accepting safe transfers.
523  */
524 interface IERC1155TokenReceiver {
525 
526   /**
527    * @notice Handle the receipt of a single ERC1155 token type
528    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
529    * This function MAY throw to revert and reject the transfer
530    * Return of other amount than the magic value MUST result in the transaction being reverted
531    * Note: The token contract address is always the message sender
532    * @param _operator  The address which called the `safeTransferFrom` function
533    * @param _from      The address which previously owned the token
534    * @param _id        The id of the token being transferred
535    * @param _amount    The amount of tokens being transferred
536    * @param _data      Additional data with no specified format
537    * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
538    */
539   function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4);
540 
541   /**
542    * @notice Handle the receipt of multiple ERC1155 token types
543    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
544    * This function MAY throw to revert and reject the transfer
545    * Return of other amount than the magic value WILL result in the transaction being reverted
546    * Note: The token contract address is always the message sender
547    * @param _operator  The address which called the `safeBatchTransferFrom` function
548    * @param _from      The address which previously owned the token
549    * @param _ids       An array containing ids of each token being transferred
550    * @param _amounts   An array containing amounts of each token being transferred
551    * @param _data      Additional data with no specified format
552    * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
553    */
554   function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4);
555 
556   /**
557    * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
558    * @param  interfaceID The ERC-165 interface ID that is queried for support.s
559    * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
560    *      This function MUST NOT consume more than 5,000 gas.
561    * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
562    */
563   function supportsInterface(bytes4 interfaceID) external view returns (bool);
564 
565 }
566 
567 interface IERC1155 {
568   // Events
569 
570   /**
571    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
572    *   Operator MUST be msg.sender
573    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
574    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
575    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
576    *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
577    */
578   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
579 
580   /**
581    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
582    *   Operator MUST be msg.sender
583    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
584    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
585    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
586    *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
587    */
588   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
589 
590   /**
591    * @dev MUST emit when an approval is updated
592    */
593   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
594 
595   /**
596    * @dev MUST emit when the URI is updated for a token ID
597    *   URIs are defined in RFC 3986
598    *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
599    */
600   event URI(string _amount, uint256 indexed _id);
601 
602   /**
603    * @notice Transfers amount of an _id from the _from address to the _to address specified
604    * @dev MUST emit TransferSingle event on success
605    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
606    * MUST throw if `_to` is the zero address
607    * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
608    * MUST throw on any other error
609    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
610    * @param _from    Source address
611    * @param _to      Target address
612    * @param _id      ID of the token type
613    * @param _amount  Transfered amount
614    * @param _data    Additional data with no specified format, sent in call to `_to`
615    */
616   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
617 
618   /**
619    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
620    * @dev MUST emit TransferBatch event on success
621    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
622    * MUST throw if `_to` is the zero address
623    * MUST throw if length of `_ids` is not the same as length of `_amounts`
624    * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
625    * MUST throw on any other error
626    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
627    * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
628    * @param _from     Source addresses
629    * @param _to       Target addresses
630    * @param _ids      IDs of each token type
631    * @param _amounts  Transfer amounts per token type
632    * @param _data     Additional data with no specified format, sent in call to `_to`
633   */
634   function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
635   
636   /**
637    * @notice Get the balance of an account's Tokens
638    * @param _owner  The address of the token holder
639    * @param _id     ID of the Token
640    * @return        The _owner's balance of the Token type requested
641    */
642   function balanceOf(address _owner, uint256 _id) external view returns (uint256);
643 
644   /**
645    * @notice Get the balance of multiple account/token pairs
646    * @param _owners The addresses of the token holders
647    * @param _ids    ID of the Tokens
648    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
649    */
650   function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
651 
652   /**
653    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
654    * @dev MUST emit the ApprovalForAll event on success
655    * @param _operator  Address to add to the set of authorized operators
656    * @param _approved  True if the operator is approved, false to revoke approval
657    */
658   function setApprovalForAll(address _operator, bool _approved) external;
659 
660   /**
661    * @notice Queries the approval status of an operator for a given owner
662    * @param _owner     The owner of the Tokens
663    * @param _operator  Address of authorized operator
664    * @return           True if the operator is approved, false if not
665    */
666   function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
667 
668 }
669 
670 /**
671  * Copyright 2018 ZeroEx Intl.
672  * Licensed under the Apache License, Version 2.0 (the "License");
673  * you may not use this file except in compliance with the License.
674  * You may obtain a copy of the License at
675  *   http://www.apache.org/licenses/LICENSE-2.0
676  * Unless required by applicable law or agreed to in writing, software
677  * distributed under the License is distributed on an "AS IS" BASIS,
678  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
679  * See the License for the specific language governing permissions and
680  * limitations under the License.
681  */
682 /**
683  * Utility library of inline functions on addresses
684  */
685 library Address {
686 
687   /**
688    * Returns whether the target address is a contract
689    * @dev This function will return false if invoked during the constructor of a contract,
690    * as the code is not actually created until after the constructor finishes.
691    * @param account address of the account to check
692    * @return whether the target address is a contract
693    */
694   function isContract(address account) internal view returns (bool) {
695     bytes32 codehash;
696     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
697 
698     // XXX Currently there is no better way to check if there is a contract in an address
699     // than to check the size of the code at that address.
700     // See https://ethereum.stackexchange.com/a/14016/36603
701     // for more details about how this works.
702     // TODO Check this again before the Serenity release, because all addresses will be
703     // contracts then.
704     assembly { codehash := extcodehash(account) }
705     return (codehash != 0x0 && codehash != accountHash);
706   }
707 
708 }
709 
710 /**
711  * @dev Implementation of Multi-Token Standard contract
712  */
713 contract ERC1155 is IERC165 {
714   using SafeMath for uint256;
715   using Address for address;
716 
717 
718   /***********************************|
719   |        Variables and Events       |
720   |__________________________________*/
721 
722   // onReceive function signatures
723   bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;
724   bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
725 
726   // Objects balances
727   mapping (address => mapping(uint256 => uint256)) internal balances;
728 
729   // Operator Functions
730   mapping (address => mapping(address => bool)) internal operators;
731 
732   // Events
733   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
734   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
735   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
736   event URI(string _uri, uint256 indexed _id);
737 
738 
739   /***********************************|
740   |     Public Transfer Functions     |
741   |__________________________________*/
742 
743   /**
744    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
745    * @param _from    Source address
746    * @param _to      Target address
747    * @param _id      ID of the token type
748    * @param _amount  Transfered amount
749    * @param _data    Additional data with no specified format, sent in call to `_to`
750    */
751   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
752     public
753   {
754     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeTransferFrom: INVALID_OPERATOR");
755     require(_to != address(0),"ERC1155#safeTransferFrom: INVALID_RECIPIENT");
756     // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
757 
758     _safeTransferFrom(_from, _to, _id, _amount);
759     _callonERC1155Received(_from, _to, _id, _amount, _data);
760   }
761 
762   /**
763    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
764    * @param _from     Source addresses
765    * @param _to       Target addresses
766    * @param _ids      IDs of each token type
767    * @param _amounts  Transfer amounts per token type
768    * @param _data     Additional data with no specified format, sent in call to `_to`
769    */
770   function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
771     public
772   {
773     // Requirements
774     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR");
775     require(_to != address(0), "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT");
776 
777     _safeBatchTransferFrom(_from, _to, _ids, _amounts);
778     _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
779   }
780 
781 
782   /***********************************|
783   |    Internal Transfer Functions    |
784   |__________________________________*/
785 
786   /**
787    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
788    * @param _from    Source address
789    * @param _to      Target address
790    * @param _id      ID of the token type
791    * @param _amount  Transfered amount
792    */
793   function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount)
794     internal
795   {
796     // Update balances
797     balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
798     balances[_to][_id] = balances[_to][_id].add(_amount);     // Add amount
799 
800     // Emit event
801     emit TransferSingle(msg.sender, _from, _to, _id, _amount);
802   }
803 
804   /**
805    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
806    */
807   function _callonERC1155Received(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
808     internal
809   {
810     // Check if recipient is contract
811     if (_to.isContract()) {
812       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _amount, _data);
813       require(retval == ERC1155_RECEIVED_VALUE, "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");
814     }
815   }
816 
817   /**
818    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
819    * @param _from     Source addresses
820    * @param _to       Target addresses
821    * @param _ids      IDs of each token type
822    * @param _amounts  Transfer amounts per token type
823    */
824   function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts)
825     internal
826   {
827     require(_ids.length == _amounts.length, "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH");
828 
829     // Number of transfer to execute
830     uint256 nTransfer = _ids.length;
831 
832     // Executing all transfers
833     for (uint256 i = 0; i < nTransfer; i++) {
834       // Update storage balance of previous bin
835       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
836       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
837     }
838 
839     // Emit event
840     emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
841   }
842 
843   /**
844    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
845    */
846   function _callonERC1155BatchReceived(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
847     internal
848   {
849     // Pass data if recipient is contract
850     if (_to.isContract()) {
851       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _amounts, _data);
852       require(retval == ERC1155_BATCH_RECEIVED_VALUE, "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE");
853     }
854   }
855 
856 
857   /***********************************|
858   |         Operator Functions        |
859   |__________________________________*/
860 
861   /**
862    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
863    * @param _operator  Address to add to the set of authorized operators
864    * @param _approved  True if the operator is approved, false to revoke approval
865    */
866   function setApprovalForAll(address _operator, bool _approved)
867     external
868   {
869     // Update operator status
870     operators[msg.sender][_operator] = _approved;
871     emit ApprovalForAll(msg.sender, _operator, _approved);
872   }
873 
874   /**
875    * @notice Queries the approval status of an operator for a given owner
876    * @param _owner     The owner of the Tokens
877    * @param _operator  Address of authorized operator
878    * @return True if the operator is approved, false if not
879    */
880   function isApprovedForAll(address _owner, address _operator)
881     public view returns (bool isOperator)
882   {
883     return operators[_owner][_operator];
884   }
885 
886 
887   /***********************************|
888   |         Balance Functions         |
889   |__________________________________*/
890 
891   /**
892    * @notice Get the balance of an account's Tokens
893    * @param _owner  The address of the token holder
894    * @param _id     ID of the Token
895    * @return The _owner's balance of the Token type requested
896    */
897   function balanceOf(address _owner, uint256 _id)
898     public view returns (uint256)
899   {
900     return balances[_owner][_id];
901   }
902 
903   /**
904    * @notice Get the balance of multiple account/token pairs
905    * @param _owners The addresses of the token holders
906    * @param _ids    ID of the Tokens
907    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
908    */
909   function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
910     public view returns (uint256[] memory)
911   {
912     require(_owners.length == _ids.length, "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH");
913 
914     // Variables
915     uint256[] memory batchBalances = new uint256[](_owners.length);
916 
917     // Iterate over each owner and token ID
918     for (uint256 i = 0; i < _owners.length; i++) {
919       batchBalances[i] = balances[_owners[i]][_ids[i]];
920     }
921 
922     return batchBalances;
923   }
924 
925 
926   /***********************************|
927   |          ERC165 Functions         |
928   |__________________________________*/
929 
930   /**
931    * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
932    */
933   bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
934 
935   /**
936    * INTERFACE_SIGNATURE_ERC1155 =
937    * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
938    * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
939    * bytes4(keccak256("balanceOf(address,uint256)")) ^
940    * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
941    * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
942    * bytes4(keccak256("isApprovedForAll(address,address)"));
943    */
944   bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
945 
946   /**
947    * @notice Query if a contract implements an interface
948    * @param _interfaceID  The interface identifier, as specified in ERC-165
949    * @return `true` if the contract implements `_interfaceID` and
950    */
951   function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
952     if (_interfaceID == INTERFACE_SIGNATURE_ERC165 ||
953         _interfaceID == INTERFACE_SIGNATURE_ERC1155) {
954       return true;
955     }
956     return false;
957   }
958 
959 }
960 
961 /**
962  * @notice Contract that handles metadata related methods.
963  * @dev Methods assume a deterministic generation of URI based on token IDs.
964  *      Methods also assume that URI uses hex representation of token IDs.
965  */
966 contract ERC1155Metadata {
967 
968   // URI's default URI prefix
969   string internal baseMetadataURI;
970   event URI(string _uri, uint256 indexed _id);
971 
972 
973   /***********************************|
974   |     Metadata Public Function s    |
975   |__________________________________*/
976 
977   /**
978    * @notice A distinct Uniform Resource Identifier (URI) for a given token.
979    * @dev URIs are defined in RFC 3986.
980    *      URIs are assumed to be deterministically generated based on token ID
981    *      Token IDs are assumed to be represented in their hex format in URIs
982    * @return URI string
983    */
984   function uri(uint256 _id) public view returns (string memory) {
985     return string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
986   }
987 
988 
989   /***********************************|
990   |    Metadata Internal Functions    |
991   |__________________________________*/
992 
993   /**
994    * @notice Will emit default URI log event for corresponding token _id
995    * @param _tokenIDs Array of IDs of tokens to log default URI
996    */
997   function _logURIs(uint256[] memory _tokenIDs) internal {
998     string memory baseURL = baseMetadataURI;
999     string memory tokenURI;
1000 
1001     for (uint256 i = 0; i < _tokenIDs.length; i++) {
1002       tokenURI = string(abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json"));
1003       emit URI(tokenURI, _tokenIDs[i]);
1004     }
1005   }
1006 
1007   /**
1008    * @notice Will emit a specific URI log event for corresponding token
1009    * @param _tokenIDs IDs of the token corresponding to the _uris logged
1010    * @param _URIs    The URIs of the specified _tokenIDs
1011    */
1012   function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs) internal {
1013     require(_tokenIDs.length == _URIs.length, "ERC1155Metadata#_logURIs: INVALID_ARRAYS_LENGTH");
1014     for (uint256 i = 0; i < _tokenIDs.length; i++) {
1015       emit URI(_URIs[i], _tokenIDs[i]);
1016     }
1017   }
1018 
1019   /**
1020    * @notice Will update the base URL of token's URI
1021    * @param _newBaseMetadataURI New base URL of token's URI
1022    */
1023   function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
1024     baseMetadataURI = _newBaseMetadataURI;
1025   }
1026 
1027 
1028   /***********************************|
1029   |    Utility Internal Functions     |
1030   |__________________________________*/
1031 
1032   /**
1033    * @notice Convert uint256 to string
1034    * @param _i Unsigned integer to convert to string
1035    */
1036   function _uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
1037     if (_i == 0) {
1038       return "0";
1039     }
1040 
1041     uint256 j = _i;
1042     uint256 ii = _i;
1043     uint256 len;
1044 
1045     // Get number of bytes
1046     while (j != 0) {
1047       len++;
1048       j /= 10;
1049     }
1050 
1051     bytes memory bstr = new bytes(len);
1052     uint256 k = len - 1;
1053 
1054     // Get each individual ASCII
1055     while (ii != 0) {
1056       bstr[k--] = byte(uint8(48 + ii % 10));
1057       ii /= 10;
1058     }
1059 
1060     // Convert to string
1061     return string(bstr);
1062   }
1063 
1064 }
1065 
1066 /**
1067  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
1068  *      a parent contract to be executed as they are `internal` functions
1069  */
1070 contract ERC1155MintBurn is ERC1155 {
1071 
1072 
1073   /****************************************|
1074   |            Minting Functions           |
1075   |_______________________________________*/
1076 
1077   /**
1078    * @notice Mint _amount of tokens of a given id
1079    * @param _to      The address to mint tokens to
1080    * @param _id      Token id to mint
1081    * @param _amount  The amount to be minted
1082    * @param _data    Data to pass if receiver is contract
1083    */
1084   function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)
1085     internal
1086   {
1087     // Add _amount
1088     balances[_to][_id] = balances[_to][_id].add(_amount);
1089 
1090     // Emit event
1091     emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
1092 
1093     // Calling onReceive method if recipient is contract
1094     _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
1095   }
1096 
1097   /**
1098    * @notice Mint tokens for each ids in _ids
1099    * @param _to       The address to mint tokens to
1100    * @param _ids      Array of ids to mint
1101    * @param _amounts  Array of amount of tokens to mint per id
1102    * @param _data    Data to pass if receiver is contract
1103    */
1104   function _batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
1105     internal
1106   {
1107     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH");
1108 
1109     // Number of mints to execute
1110     uint256 nMint = _ids.length;
1111 
1112      // Executing all minting
1113     for (uint256 i = 0; i < nMint; i++) {
1114       // Update storage balance
1115       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
1116     }
1117 
1118     // Emit batch mint event
1119     emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
1120 
1121     // Calling onReceive method if recipient is contract
1122     _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
1123   }
1124 
1125 
1126   /****************************************|
1127   |            Burning Functions           |
1128   |_______________________________________*/
1129 
1130   /**
1131    * @notice Burn _amount of tokens of a given token id
1132    * @param _from    The address to burn tokens from
1133    * @param _id      Token id to burn
1134    * @param _amount  The amount to be burned
1135    */
1136   function _burn(address _from, uint256 _id, uint256 _amount)
1137     internal
1138   {
1139     //Substract _amount
1140     balances[_from][_id] = balances[_from][_id].sub(_amount);
1141 
1142     // Emit event
1143     emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
1144   }
1145 
1146   /**
1147    * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
1148    * @param _from     The address to burn tokens from
1149    * @param _ids      Array of token ids to burn
1150    * @param _amounts  Array of the amount to be burned
1151    */
1152   function _batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts)
1153     internal
1154   {
1155     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH");
1156 
1157     // Number of mints to execute
1158     uint256 nBurn = _ids.length;
1159 
1160      // Executing all minting
1161     for (uint256 i = 0; i < nBurn; i++) {
1162       // Update storage balance
1163       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
1164     }
1165 
1166     // Emit batch mint event
1167     emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
1168   }
1169 
1170 }
1171 
1172 library Strings {
1173 	// via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1174 	function strConcat(
1175 		string memory _a,
1176 		string memory _b,
1177 		string memory _c,
1178 		string memory _d,
1179 		string memory _e
1180 	) internal pure returns (string memory) {
1181 		bytes memory _ba = bytes(_a);
1182 		bytes memory _bb = bytes(_b);
1183 		bytes memory _bc = bytes(_c);
1184 		bytes memory _bd = bytes(_d);
1185 		bytes memory _be = bytes(_e);
1186 		string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1187 		bytes memory babcde = bytes(abcde);
1188 		uint256 k = 0;
1189 		for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1190 		for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1191 		for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1192 		for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1193 		for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1194 		return string(babcde);
1195 	}
1196 
1197 	function strConcat(
1198 		string memory _a,
1199 		string memory _b,
1200 		string memory _c,
1201 		string memory _d
1202 	) internal pure returns (string memory) {
1203 		return strConcat(_a, _b, _c, _d, "");
1204 	}
1205 
1206 	function strConcat(
1207 		string memory _a,
1208 		string memory _b,
1209 		string memory _c
1210 	) internal pure returns (string memory) {
1211 		return strConcat(_a, _b, _c, "", "");
1212 	}
1213 
1214 	function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
1215 		return strConcat(_a, _b, "", "", "");
1216 	}
1217 
1218 	function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
1219 		if (_i == 0) {
1220 			return "0";
1221 		}
1222 		uint256 j = _i;
1223 		uint256 len;
1224 		while (j != 0) {
1225 			len++;
1226 			j /= 10;
1227 		}
1228 		bytes memory bstr = new bytes(len);
1229 		uint256 k = len - 1;
1230 		while (_i != 0) {
1231 			bstr[k--] = bytes1(uint8(48 + (_i % 10)));
1232 			_i /= 10;
1233 		}
1234 		return string(bstr);
1235 	}
1236 }
1237 
1238 contract OwnableDelegateProxy {}
1239 
1240 contract ProxyRegistry {
1241 	mapping(address => OwnableDelegateProxy) public proxies;
1242 }
1243 
1244 /**
1245  * @title ERC1155Tradable
1246  * ERC1155Tradable - ERC1155 contract that whitelists an operator address, 
1247  * has create and mint functionality, and supports useful standards from OpenZeppelin,
1248   like _exists(), name(), symbol(), and totalSupply()
1249  */
1250 contract ERC1155Tradable is ERC1155, ERC1155MintBurn, ERC1155Metadata, Ownable, MinterRole, WhitelistAdminRole {
1251 	using Strings for string;
1252 
1253 	address proxyRegistryAddress;
1254 	uint256 private _currentTokenID = 0;
1255 	mapping(uint256 => address) public creators;
1256 	mapping(uint256 => uint256) public tokenSupply;
1257 	mapping(uint256 => uint256) public tokenMaxSupply;
1258 	// Contract name
1259 	string public name;
1260 	// Contract symbol
1261 	string public symbol;
1262 
1263 	constructor(
1264 		string memory _name,
1265 		string memory _symbol,
1266 		address _proxyRegistryAddress
1267 	) public {
1268 		name = _name;
1269 		symbol = _symbol;
1270 		proxyRegistryAddress = _proxyRegistryAddress;
1271 	}
1272 
1273 	function removeWhitelistAdmin(address account) public onlyOwner {
1274 		_removeWhitelistAdmin(account);
1275 	}
1276 
1277 	function removeMinter(address account) public onlyOwner {
1278 		_removeMinter(account);
1279 	}
1280 
1281 	function uri(uint256 _id) public view returns (string memory) {
1282 		require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1283 		return Strings.strConcat(baseMetadataURI, Strings.uint2str(_id));
1284 	}
1285 
1286 	/**
1287 	 * @dev Returns the total quantity for a token ID
1288 	 * @param _id uint256 ID of the token to query
1289 	 * @return amount of token in existence
1290 	 */
1291 	function totalSupply(uint256 _id) public view returns (uint256) {
1292 		return tokenSupply[_id];
1293 	}
1294 
1295 	/**
1296 	 * @dev Returns the max quantity for a token ID
1297 	 * @param _id uint256 ID of the token to query
1298 	 * @return amount of token in existence
1299 	 */
1300 	function maxSupply(uint256 _id) public view returns (uint256) {
1301 		return tokenMaxSupply[_id];
1302 	}
1303 
1304 	/**
1305 	 * @dev Will update the base URL of token's URI
1306 	 * @param _newBaseMetadataURI New base URL of token's URI
1307 	 */
1308 	function setBaseMetadataURI(string memory _newBaseMetadataURI) public onlyWhitelistAdmin {
1309 		_setBaseMetadataURI(_newBaseMetadataURI);
1310 	}
1311 
1312 	/**
1313 	 * @dev Creates a new token type and assigns _initialSupply to an address
1314 	 * @param _maxSupply max supply allowed
1315 	 * @param _initialSupply Optional amount to supply the first owner
1316 	 * @param _uri Optional URI for this token type
1317 	 * @param _data Optional data to pass if receiver is contract
1318 	 * @return The newly created token ID
1319 	 */
1320 	function create(
1321 		uint256 _maxSupply,
1322 		uint256 _initialSupply,
1323 		string calldata _uri,
1324 		bytes calldata _data
1325 	) external onlyWhitelistAdmin returns (uint256 tokenId) {
1326 		require(_initialSupply <= _maxSupply, "Initial supply cannot be more than max supply");
1327 		uint256 _id = _getNextTokenID();
1328 		_incrementTokenTypeId();
1329 		creators[_id] = msg.sender;
1330 
1331 		if (bytes(_uri).length > 0) {
1332 			emit URI(_uri, _id);
1333 		}
1334 
1335 		if (_initialSupply != 0) _mint(msg.sender, _id, _initialSupply, _data);
1336 		tokenSupply[_id] = _initialSupply;
1337 		tokenMaxSupply[_id] = _maxSupply;
1338 		return _id;
1339 	}
1340 
1341 	/**
1342 	 * @dev Mints some amount of tokens to an address
1343 	 * @param _to          Address of the future owner of the token
1344 	 * @param _id          Token ID to mint
1345 	 * @param _quantity    Amount of tokens to mint
1346 	 * @param _data        Data to pass if receiver is contract
1347 	 */
1348 	function mint(
1349 		address _to,
1350 		uint256 _id,
1351 		uint256 _quantity,
1352 		bytes memory _data
1353 	) public onlyMinter {
1354 		uint256 tokenId = _id;
1355 		require(tokenSupply[tokenId] < tokenMaxSupply[tokenId], "Max supply reached");
1356 		_mint(_to, _id, _quantity, _data);
1357 		tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1358 	}
1359 
1360 	/**
1361 	 * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
1362 	 */
1363 	function isApprovedForAll(address _owner, address _operator) public view returns (bool isOperator) {
1364 		// Whitelist OpenSea proxy contract for easy trading.
1365 		ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1366 		if (address(proxyRegistry.proxies(_owner)) == _operator) {
1367 			return true;
1368 		}
1369 
1370 		return ERC1155.isApprovedForAll(_owner, _operator);
1371 	}
1372 
1373 	/**
1374 	 * @dev Returns whether the specified token exists by checking to see if it has a creator
1375 	 * @param _id uint256 ID of the token to query the existence of
1376 	 * @return bool whether the token exists
1377 	 */
1378 	function _exists(uint256 _id) internal view returns (bool) {
1379 		return creators[_id] != address(0);
1380 	}
1381 
1382 	/**
1383 	 * @dev calculates the next token ID based on value of _currentTokenID
1384 	 * @return uint256 for the next token ID
1385 	 */
1386 	function _getNextTokenID() private view returns (uint256) {
1387 		return _currentTokenID.add(1);
1388 	}
1389 
1390 	/**
1391 	 * @dev increments the value of _currentTokenID
1392 	 */
1393 	function _incrementTokenTypeId() private {
1394 		_currentTokenID++;
1395 	}
1396 }
1397 
1398 contract MemeTokenWrapper {
1399 	using SafeMath for uint256;
1400 	IERC20 public meme;
1401 
1402 	constructor(IERC20 _memeAddress) public {
1403 		meme = IERC20(_memeAddress);
1404 	}
1405 
1406 	uint256 private _totalSupply;
1407 	mapping(address => uint256) private _balances;
1408 
1409 	function totalSupply() public view returns (uint256) {
1410 		return _totalSupply;
1411 	}
1412 
1413 	function balanceOf(address account) public view returns (uint256) {
1414 		return _balances[account];
1415 	}
1416 
1417 	function stake(uint256 amount) public {
1418 		_totalSupply = _totalSupply.add(amount);
1419 		_balances[msg.sender] = _balances[msg.sender].add(amount);
1420 		meme.transferFrom(msg.sender, address(this), amount);
1421 	}
1422 
1423 	function withdraw(uint256 amount) public {
1424 		_totalSupply = _totalSupply.sub(amount);
1425 		_balances[msg.sender] = _balances[msg.sender].sub(amount);
1426 		meme.transfer(msg.sender, amount);
1427 	}
1428 
1429 	function _rescuePineapples(address account) internal {
1430 		uint256 amount = _balances[account];
1431 
1432 		_totalSupply = _totalSupply.sub(amount);
1433 		_balances[account] = _balances[account].sub(amount);
1434 		meme.transfer(account, amount);
1435 	}
1436 }
1437 
1438 contract MEMELtdPoolV2MintFeeD is MemeTokenWrapper, Ownable, Pausable {
1439 	using SafeMath for uint256;
1440 	ERC1155Tradable public memeLtd;
1441 
1442 	struct Card {
1443 		uint256 points;
1444 		uint256 releaseTime;
1445 		uint256 mintFee;
1446 	}
1447 
1448 	uint256 public periodStart;
1449 	uint256 public maxStake;
1450 	uint256 public rewardRate = 11574074074000; // 1 point per day per staked MEME
1451 	uint256 public totalFeesCollected;
1452 	uint256 public spentPineapples;
1453 	uint256 public controllerShare;
1454 	address public rescuer;
1455 	address public artist;
1456 	address public controller;
1457 
1458 	mapping(address => uint256) public pendingWithdrawals;
1459 	mapping(address => uint256) public lastUpdateTime;
1460 	mapping(address => uint256) public points;
1461 	mapping(uint256 => Card) public cards;
1462 
1463 	event CardAdded(uint256 card, uint256 points, uint256 mintFee, uint256 releaseTime);
1464 	event Staked(address indexed user, uint256 amount);
1465 	event Withdrawn(address indexed user, uint256 amount);
1466 	event Redeemed(address indexed user, uint256 amount);
1467 
1468 	modifier updateReward(address account) {
1469 		if (account != address(0)) {
1470 			points[account] = earned(account);
1471 			lastUpdateTime[account] = block.timestamp;
1472 		}
1473 		_;
1474 	}
1475 
1476 	constructor(
1477 		uint256 _periodStart,
1478 		uint256 _maxStake,
1479 		uint256 _controllerShare,
1480 		address _artist,
1481 		address _controller,
1482 		ERC1155Tradable _memeLtdAddress,
1483 		IERC20 _memeAddress
1484 	) public MemeTokenWrapper(_memeAddress) {
1485 		periodStart = _periodStart;
1486 		maxStake = _maxStake;
1487 		controllerShare = _controllerShare;
1488 		artist = _artist;
1489 		controller = _controller;
1490 		memeLtd = _memeLtdAddress;
1491 	}
1492 
1493 	function cardMintFee(uint256 id) public view returns (uint256) {
1494 		return cards[id].mintFee;
1495 	}
1496 
1497 	function cardReleaseTime(uint256 id) public view returns (uint256) {
1498 		return cards[id].releaseTime;
1499 	}
1500 
1501 	function cardPoints(uint256 id) public view returns (uint256) {
1502 		return cards[id].points;
1503 	}
1504 
1505 	function earned(address account) public view returns (uint256) {
1506 		uint256 blockTime = block.timestamp;
1507 		return
1508 			balanceOf(account).mul(blockTime.sub(lastUpdateTime[account]).mul(rewardRate)).div(1e8).add(
1509 				points[account]
1510 			);
1511 	}
1512 
1513 	// stake visibility is public as overriding MemeTokenWrapper's stake() function
1514 	function stake(uint256 amount) public updateReward(msg.sender) whenNotPaused() {
1515 		require(block.timestamp >= periodStart, "Pool not open");
1516 		require(amount.add(balanceOf(msg.sender)) <= maxStake, "Deposit 5 MEME or less, no whales");
1517 
1518 		super.stake(amount);
1519 		emit Staked(msg.sender, amount);
1520 	}
1521 
1522 	// override MemeTokenWrapper's withdraw() function
1523 	function withdraw(uint256 amount) public updateReward(msg.sender) {
1524 		require(amount > 0, "Cannot withdraw 0");
1525 
1526 		super.withdraw(amount);
1527 		emit Withdrawn(msg.sender, amount);
1528 	}
1529 
1530 	function exit() external {
1531 		withdraw(balanceOf(msg.sender));
1532 	}
1533 
1534 	function redeem(uint256 id) public payable updateReward(msg.sender) {
1535 		require(cards[id].points != 0, "Card not found");
1536 		require(block.timestamp >= cards[id].releaseTime, "Card not released");
1537 		require(points[msg.sender] >= cards[id].points, "Redemption exceeds point balance");
1538 		require(msg.value == cards[id].mintFee, "Support our artists. Send the proper ETH");
1539 
1540 		if (cards[id].mintFee > 0) {
1541 			uint256 _controllerShare = msg.value.mul(controllerShare).div(1000);
1542 			uint256 _artistRoyalty = msg.value.sub(_controllerShare);
1543 			require(_artistRoyalty.add(_controllerShare) == msg.value, "problem with fee");
1544 
1545 			totalFeesCollected = totalFeesCollected.add(cards[id].mintFee);
1546 			pendingWithdrawals[controller] = pendingWithdrawals[controller].add(_controllerShare);
1547 			pendingWithdrawals[artist] = pendingWithdrawals[artist].add(_artistRoyalty);
1548 		}
1549 
1550 		points[msg.sender] = points[msg.sender].sub(cards[id].points);
1551 		spentPineapples = spentPineapples.add(cards[id].points);
1552 		memeLtd.mint(msg.sender, id, 1, "");
1553 		emit Redeemed(msg.sender, cards[id].points);
1554 	}
1555 
1556 	function rescuePineapples(address account) public updateReward(account) returns (uint256) {
1557 		require(msg.sender == rescuer, "!rescuer");
1558 		uint256 earnedPoints = points[account];
1559 		spentPineapples = spentPineapples.add(earnedPoints);
1560 		points[account] = 0;
1561 
1562 		// transfer remaining MEME to the account
1563 		if (balanceOf(account) > 0) {
1564 			_rescuePineapples(account);
1565 		}
1566 
1567 		emit Redeemed(account, earnedPoints);
1568 		return earnedPoints;
1569 	}
1570 
1571 	function setArtist(address _artist) public onlyOwner {
1572 		uint256 amount = pendingWithdrawals[artist];
1573 		pendingWithdrawals[artist] = 0;
1574 		pendingWithdrawals[_artist] = pendingWithdrawals[_artist].add(amount);
1575 		artist = _artist;
1576 	}
1577 
1578 	function setController(address _controller) public onlyOwner {
1579 		uint256 amount = pendingWithdrawals[controller];
1580 		pendingWithdrawals[controller] = 0;
1581 		pendingWithdrawals[_controller] = pendingWithdrawals[_controller].add(amount);
1582 		controller = _controller;
1583 	}
1584 
1585 	function setRescuer(address _rescuer) public onlyOwner {
1586 		rescuer = _rescuer;
1587 	}
1588 
1589 	function setControllerShare(uint256 _controllerShare) public onlyOwner {
1590 		controllerShare = _controllerShare;
1591 	}
1592 
1593 	function createCard(
1594 		uint256 _supply,
1595 		uint256 _points,
1596 		uint256 _mintFee,
1597 		uint256 _releaseTime
1598 	) public onlyOwner returns (uint256) {
1599 		uint256 tokenId = memeLtd.create(_supply, 0, "", "");
1600 		require(tokenId > 0, "ERC1155 create did not succeed");
1601 
1602 		Card storage c = cards[tokenId];
1603 		c.points = _points;
1604 		c.releaseTime = _releaseTime;
1605 		c.mintFee = _mintFee;
1606 		emit CardAdded(tokenId, _points, _mintFee, _releaseTime);
1607 		return tokenId;
1608 	}
1609 
1610 	function withdrawFee() public {
1611 		require(msg.sender == artist || msg.sender == controller, "!artist or !controller");
1612 		uint256 amount = pendingWithdrawals[msg.sender];
1613 		require(amount > 0, "nothing to withdraw");
1614 		pendingWithdrawals[msg.sender] = 0;
1615 		msg.sender.transfer(amount);
1616 	}
1617 }