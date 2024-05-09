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
243 contract MinterRole is Context {
244     using Roles for Roles.Role;
245 
246     event MinterAdded(address indexed account);
247     event MinterRemoved(address indexed account);
248 
249     Roles.Role private _minters;
250 
251     constructor () internal {
252         _addMinter(_msgSender());
253     }
254 
255     modifier onlyMinter() {
256         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
257         _;
258     }
259 
260     function isMinter(address account) public view returns (bool) {
261         return _minters.has(account);
262     }
263 
264     function addMinter(address account) public onlyMinter {
265         _addMinter(account);
266     }
267 
268     function renounceMinter() public {
269         _removeMinter(_msgSender());
270     }
271 
272     function _addMinter(address account) internal {
273         _minters.add(account);
274         emit MinterAdded(account);
275     }
276 
277     function _removeMinter(address account) internal {
278         _minters.remove(account);
279         emit MinterRemoved(account);
280     }
281 }
282 
283 /**
284  * @title WhitelistAdminRole
285  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
286  */
287 contract WhitelistAdminRole is Context {
288     using Roles for Roles.Role;
289 
290     event WhitelistAdminAdded(address indexed account);
291     event WhitelistAdminRemoved(address indexed account);
292 
293     Roles.Role private _whitelistAdmins;
294 
295     constructor () internal {
296         _addWhitelistAdmin(_msgSender());
297     }
298 
299     modifier onlyWhitelistAdmin() {
300         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
301         _;
302     }
303 
304     function isWhitelistAdmin(address account) public view returns (bool) {
305         return _whitelistAdmins.has(account);
306     }
307 
308     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
309         _addWhitelistAdmin(account);
310     }
311 
312     function renounceWhitelistAdmin() public {
313         _removeWhitelistAdmin(_msgSender());
314     }
315 
316     function _addWhitelistAdmin(address account) internal {
317         _whitelistAdmins.add(account);
318         emit WhitelistAdminAdded(account);
319     }
320 
321     function _removeWhitelistAdmin(address account) internal {
322         _whitelistAdmins.remove(account);
323         emit WhitelistAdminRemoved(account);
324     }
325 }
326 
327 /**
328  * @title ERC165
329  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
330  */
331 interface IERC165 {
332 
333     /**
334      * @notice Query if a contract implements an interface
335      * @dev Interface identification is specified in ERC-165. This function
336      * uses less than 30,000 gas
337      * @param _interfaceId The interface identifier, as specified in ERC-165
338      */
339     function supportsInterface(bytes4 _interfaceId)
340     external
341     view
342     returns (bool);
343 }
344 
345 /**
346  * @title SafeMath
347  * @dev Unsigned math operations with safety checks that revert on error
348  */
349 library SafeMath {
350 
351   /**
352    * @dev Multiplies two unsigned integers, reverts on overflow.
353    */
354   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
355     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
356     // benefit is lost if 'b' is also tested.
357     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
358     if (a == 0) {
359       return 0;
360     }
361 
362     uint256 c = a * b;
363     require(c / a == b, "SafeMath#mul: OVERFLOW");
364 
365     return c;
366   }
367 
368   /**
369    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
370    */
371   function div(uint256 a, uint256 b) internal pure returns (uint256) {
372     // Solidity only automatically asserts when dividing by 0
373     require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
374     uint256 c = a / b;
375     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
376 
377     return c;
378   }
379 
380   /**
381    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
382    */
383   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
384     require(b <= a, "SafeMath#sub: UNDERFLOW");
385     uint256 c = a - b;
386 
387     return c;
388   }
389 
390   /**
391    * @dev Adds two unsigned integers, reverts on overflow.
392    */
393   function add(uint256 a, uint256 b) internal pure returns (uint256) {
394     uint256 c = a + b;
395     require(c >= a, "SafeMath#add: OVERFLOW");
396 
397     return c; 
398   }
399 
400   /**
401    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
402    * reverts when dividing by zero.
403    */
404   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
405     require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
406     return a % b;
407   }
408 
409 }
410 
411 /**
412  * @dev ERC-1155 interface for accepting safe transfers.
413  */
414 interface IERC1155TokenReceiver {
415 
416   /**
417    * @notice Handle the receipt of a single ERC1155 token type
418    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
419    * This function MAY throw to revert and reject the transfer
420    * Return of other amount than the magic value MUST result in the transaction being reverted
421    * Note: The token contract address is always the message sender
422    * @param _operator  The address which called the `safeTransferFrom` function
423    * @param _from      The address which previously owned the token
424    * @param _id        The id of the token being transferred
425    * @param _amount    The amount of tokens being transferred
426    * @param _data      Additional data with no specified format
427    * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
428    */
429   function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4);
430 
431   /**
432    * @notice Handle the receipt of multiple ERC1155 token types
433    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
434    * This function MAY throw to revert and reject the transfer
435    * Return of other amount than the magic value WILL result in the transaction being reverted
436    * Note: The token contract address is always the message sender
437    * @param _operator  The address which called the `safeBatchTransferFrom` function
438    * @param _from      The address which previously owned the token
439    * @param _ids       An array containing ids of each token being transferred
440    * @param _amounts   An array containing amounts of each token being transferred
441    * @param _data      Additional data with no specified format
442    * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
443    */
444   function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4);
445 
446   /**
447    * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
448    * @param  interfaceID The ERC-165 interface ID that is queried for support.s
449    * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
450    *      This function MUST NOT consume more than 5,000 gas.
451    * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
452    */
453   function supportsInterface(bytes4 interfaceID) external view returns (bool);
454 
455 }
456 
457 interface IERC1155 {
458   // Events
459 
460   /**
461    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
462    *   Operator MUST be msg.sender
463    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
464    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
465    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
466    *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
467    */
468   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
469 
470   /**
471    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
472    *   Operator MUST be msg.sender
473    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
474    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
475    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
476    *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
477    */
478   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
479 
480   /**
481    * @dev MUST emit when an approval is updated
482    */
483   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
484 
485   /**
486    * @dev MUST emit when the URI is updated for a token ID
487    *   URIs are defined in RFC 3986
488    *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
489    */
490   event URI(string _amount, uint256 indexed _id);
491 
492   /**
493    * @notice Transfers amount of an _id from the _from address to the _to address specified
494    * @dev MUST emit TransferSingle event on success
495    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
496    * MUST throw if `_to` is the zero address
497    * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
498    * MUST throw on any other error
499    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
500    * @param _from    Source address
501    * @param _to      Target address
502    * @param _id      ID of the token type
503    * @param _amount  Transfered amount
504    * @param _data    Additional data with no specified format, sent in call to `_to`
505    */
506   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
507 
508   /**
509    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
510    * @dev MUST emit TransferBatch event on success
511    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
512    * MUST throw if `_to` is the zero address
513    * MUST throw if length of `_ids` is not the same as length of `_amounts`
514    * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
515    * MUST throw on any other error
516    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
517    * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
518    * @param _from     Source addresses
519    * @param _to       Target addresses
520    * @param _ids      IDs of each token type
521    * @param _amounts  Transfer amounts per token type
522    * @param _data     Additional data with no specified format, sent in call to `_to`
523   */
524   function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
525   
526   /**
527    * @notice Get the balance of an account's Tokens
528    * @param _owner  The address of the token holder
529    * @param _id     ID of the Token
530    * @return        The _owner's balance of the Token type requested
531    */
532   function balanceOf(address _owner, uint256 _id) external view returns (uint256);
533 
534   /**
535    * @notice Get the balance of multiple account/token pairs
536    * @param _owners The addresses of the token holders
537    * @param _ids    ID of the Tokens
538    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
539    */
540   function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
541 
542   /**
543    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
544    * @dev MUST emit the ApprovalForAll event on success
545    * @param _operator  Address to add to the set of authorized operators
546    * @param _approved  True if the operator is approved, false to revoke approval
547    */
548   function setApprovalForAll(address _operator, bool _approved) external;
549 
550   /**
551    * @notice Queries the approval status of an operator for a given owner
552    * @param _owner     The owner of the Tokens
553    * @param _operator  Address of authorized operator
554    * @return           True if the operator is approved, false if not
555    */
556   function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
557 
558 }
559 
560 /**
561  * Copyright 2018 ZeroEx Intl.
562  * Licensed under the Apache License, Version 2.0 (the "License");
563  * you may not use this file except in compliance with the License.
564  * You may obtain a copy of the License at
565  *   http://www.apache.org/licenses/LICENSE-2.0
566  * Unless required by applicable law or agreed to in writing, software
567  * distributed under the License is distributed on an "AS IS" BASIS,
568  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
569  * See the License for the specific language governing permissions and
570  * limitations under the License.
571  */
572 /**
573  * Utility library of inline functions on addresses
574  */
575 library Address {
576 
577   /**
578    * Returns whether the target address is a contract
579    * @dev This function will return false if invoked during the constructor of a contract,
580    * as the code is not actually created until after the constructor finishes.
581    * @param account address of the account to check
582    * @return whether the target address is a contract
583    */
584   function isContract(address account) internal view returns (bool) {
585     bytes32 codehash;
586     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
587 
588     // XXX Currently there is no better way to check if there is a contract in an address
589     // than to check the size of the code at that address.
590     // See https://ethereum.stackexchange.com/a/14016/36603
591     // for more details about how this works.
592     // TODO Check this again before the Serenity release, because all addresses will be
593     // contracts then.
594     assembly { codehash := extcodehash(account) }
595     return (codehash != 0x0 && codehash != accountHash);
596   }
597 
598 }
599 
600 /**
601  * @dev Implementation of Multi-Token Standard contract
602  */
603 contract ERC1155 is IERC165 {
604   using SafeMath for uint256;
605   using Address for address;
606 
607 
608   /***********************************|
609   |        Variables and Events       |
610   |__________________________________*/
611 
612   // onReceive function signatures
613   bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;
614   bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
615 
616   // Objects balances
617   mapping (address => mapping(uint256 => uint256)) internal balances;
618 
619   // Operator Functions
620   mapping (address => mapping(address => bool)) internal operators;
621 
622   // Events
623   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
624   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
625   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
626   event URI(string _uri, uint256 indexed _id);
627 
628 
629   /***********************************|
630   |     Public Transfer Functions     |
631   |__________________________________*/
632 
633   /**
634    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
635    * @param _from    Source address
636    * @param _to      Target address
637    * @param _id      ID of the token type
638    * @param _amount  Transfered amount
639    * @param _data    Additional data with no specified format, sent in call to `_to`
640    */
641   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
642     public
643   {
644     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeTransferFrom: INVALID_OPERATOR");
645     require(_to != address(0),"ERC1155#safeTransferFrom: INVALID_RECIPIENT");
646     // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
647 
648     _safeTransferFrom(_from, _to, _id, _amount);
649     _callonERC1155Received(_from, _to, _id, _amount, _data);
650   }
651 
652   /**
653    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
654    * @param _from     Source addresses
655    * @param _to       Target addresses
656    * @param _ids      IDs of each token type
657    * @param _amounts  Transfer amounts per token type
658    * @param _data     Additional data with no specified format, sent in call to `_to`
659    */
660   function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
661     public
662   {
663     // Requirements
664     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR");
665     require(_to != address(0), "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT");
666 
667     _safeBatchTransferFrom(_from, _to, _ids, _amounts);
668     _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
669   }
670 
671 
672   /***********************************|
673   |    Internal Transfer Functions    |
674   |__________________________________*/
675 
676   /**
677    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
678    * @param _from    Source address
679    * @param _to      Target address
680    * @param _id      ID of the token type
681    * @param _amount  Transfered amount
682    */
683   function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount)
684     internal
685   {
686     // Update balances
687     balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
688     balances[_to][_id] = balances[_to][_id].add(_amount);     // Add amount
689 
690     // Emit event
691     emit TransferSingle(msg.sender, _from, _to, _id, _amount);
692   }
693 
694   /**
695    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
696    */
697   function _callonERC1155Received(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
698     internal
699   {
700     // Check if recipient is contract
701     if (_to.isContract()) {
702       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _amount, _data);
703       require(retval == ERC1155_RECEIVED_VALUE, "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");
704     }
705   }
706 
707   /**
708    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
709    * @param _from     Source addresses
710    * @param _to       Target addresses
711    * @param _ids      IDs of each token type
712    * @param _amounts  Transfer amounts per token type
713    */
714   function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts)
715     internal
716   {
717     require(_ids.length == _amounts.length, "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH");
718 
719     // Number of transfer to execute
720     uint256 nTransfer = _ids.length;
721 
722     // Executing all transfers
723     for (uint256 i = 0; i < nTransfer; i++) {
724       // Update storage balance of previous bin
725       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
726       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
727     }
728 
729     // Emit event
730     emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
731   }
732 
733   /**
734    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
735    */
736   function _callonERC1155BatchReceived(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
737     internal
738   {
739     // Pass data if recipient is contract
740     if (_to.isContract()) {
741       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _amounts, _data);
742       require(retval == ERC1155_BATCH_RECEIVED_VALUE, "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE");
743     }
744   }
745 
746 
747   /***********************************|
748   |         Operator Functions        |
749   |__________________________________*/
750 
751   /**
752    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
753    * @param _operator  Address to add to the set of authorized operators
754    * @param _approved  True if the operator is approved, false to revoke approval
755    */
756   function setApprovalForAll(address _operator, bool _approved)
757     external
758   {
759     // Update operator status
760     operators[msg.sender][_operator] = _approved;
761     emit ApprovalForAll(msg.sender, _operator, _approved);
762   }
763 
764   /**
765    * @notice Queries the approval status of an operator for a given owner
766    * @param _owner     The owner of the Tokens
767    * @param _operator  Address of authorized operator
768    * @return True if the operator is approved, false if not
769    */
770   function isApprovedForAll(address _owner, address _operator)
771     public view returns (bool isOperator)
772   {
773     return operators[_owner][_operator];
774   }
775 
776 
777   /***********************************|
778   |         Balance Functions         |
779   |__________________________________*/
780 
781   /**
782    * @notice Get the balance of an account's Tokens
783    * @param _owner  The address of the token holder
784    * @param _id     ID of the Token
785    * @return The _owner's balance of the Token type requested
786    */
787   function balanceOf(address _owner, uint256 _id)
788     public view returns (uint256)
789   {
790     return balances[_owner][_id];
791   }
792 
793   /**
794    * @notice Get the balance of multiple account/token pairs
795    * @param _owners The addresses of the token holders
796    * @param _ids    ID of the Tokens
797    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
798    */
799   function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
800     public view returns (uint256[] memory)
801   {
802     require(_owners.length == _ids.length, "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH");
803 
804     // Variables
805     uint256[] memory batchBalances = new uint256[](_owners.length);
806 
807     // Iterate over each owner and token ID
808     for (uint256 i = 0; i < _owners.length; i++) {
809       batchBalances[i] = balances[_owners[i]][_ids[i]];
810     }
811 
812     return batchBalances;
813   }
814 
815 
816   /***********************************|
817   |          ERC165 Functions         |
818   |__________________________________*/
819 
820   /**
821    * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
822    */
823   bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
824 
825   /**
826    * INTERFACE_SIGNATURE_ERC1155 =
827    * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
828    * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
829    * bytes4(keccak256("balanceOf(address,uint256)")) ^
830    * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
831    * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
832    * bytes4(keccak256("isApprovedForAll(address,address)"));
833    */
834   bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
835 
836   /**
837    * @notice Query if a contract implements an interface
838    * @param _interfaceID  The interface identifier, as specified in ERC-165
839    * @return `true` if the contract implements `_interfaceID` and
840    */
841   function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
842     if (_interfaceID == INTERFACE_SIGNATURE_ERC165 ||
843         _interfaceID == INTERFACE_SIGNATURE_ERC1155) {
844       return true;
845     }
846     return false;
847   }
848 
849 }
850 
851 /**
852  * @notice Contract that handles metadata related methods.
853  * @dev Methods assume a deterministic generation of URI based on token IDs.
854  *      Methods also assume that URI uses hex representation of token IDs.
855  */
856 contract ERC1155Metadata {
857 
858   // URI's default URI prefix
859   string internal baseMetadataURI;
860   event URI(string _uri, uint256 indexed _id);
861 
862 
863   /***********************************|
864   |     Metadata Public Function s    |
865   |__________________________________*/
866 
867   /**
868    * @notice A distinct Uniform Resource Identifier (URI) for a given token.
869    * @dev URIs are defined in RFC 3986.
870    *      URIs are assumed to be deterministically generated based on token ID
871    *      Token IDs are assumed to be represented in their hex format in URIs
872    * @return URI string
873    */
874   function uri(uint256 _id) public view returns (string memory) {
875     return string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
876   }
877 
878 
879   /***********************************|
880   |    Metadata Internal Functions    |
881   |__________________________________*/
882 
883   /**
884    * @notice Will emit default URI log event for corresponding token _id
885    * @param _tokenIDs Array of IDs of tokens to log default URI
886    */
887   function _logURIs(uint256[] memory _tokenIDs) internal {
888     string memory baseURL = baseMetadataURI;
889     string memory tokenURI;
890 
891     for (uint256 i = 0; i < _tokenIDs.length; i++) {
892       tokenURI = string(abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json"));
893       emit URI(tokenURI, _tokenIDs[i]);
894     }
895   }
896 
897   /**
898    * @notice Will emit a specific URI log event for corresponding token
899    * @param _tokenIDs IDs of the token corresponding to the _uris logged
900    * @param _URIs    The URIs of the specified _tokenIDs
901    */
902   function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs) internal {
903     require(_tokenIDs.length == _URIs.length, "ERC1155Metadata#_logURIs: INVALID_ARRAYS_LENGTH");
904     for (uint256 i = 0; i < _tokenIDs.length; i++) {
905       emit URI(_URIs[i], _tokenIDs[i]);
906     }
907   }
908 
909   /**
910    * @notice Will update the base URL of token's URI
911    * @param _newBaseMetadataURI New base URL of token's URI
912    */
913   function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
914     baseMetadataURI = _newBaseMetadataURI;
915   }
916 
917 
918   /***********************************|
919   |    Utility Internal Functions     |
920   |__________________________________*/
921 
922   /**
923    * @notice Convert uint256 to string
924    * @param _i Unsigned integer to convert to string
925    */
926   function _uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
927     if (_i == 0) {
928       return "0";
929     }
930 
931     uint256 j = _i;
932     uint256 ii = _i;
933     uint256 len;
934 
935     // Get number of bytes
936     while (j != 0) {
937       len++;
938       j /= 10;
939     }
940 
941     bytes memory bstr = new bytes(len);
942     uint256 k = len - 1;
943 
944     // Get each individual ASCII
945     while (ii != 0) {
946       bstr[k--] = byte(uint8(48 + ii % 10));
947       ii /= 10;
948     }
949 
950     // Convert to string
951     return string(bstr);
952   }
953 
954 }
955 
956 /**
957  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
958  *      a parent contract to be executed as they are `internal` functions
959  */
960 contract ERC1155MintBurn is ERC1155 {
961 
962 
963   /****************************************|
964   |            Minting Functions           |
965   |_______________________________________*/
966 
967   /**
968    * @notice Mint _amount of tokens of a given id
969    * @param _to      The address to mint tokens to
970    * @param _id      Token id to mint
971    * @param _amount  The amount to be minted
972    * @param _data    Data to pass if receiver is contract
973    */
974   function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)
975     internal
976   {
977     // Add _amount
978     balances[_to][_id] = balances[_to][_id].add(_amount);
979 
980     // Emit event
981     emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
982 
983     // Calling onReceive method if recipient is contract
984     _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
985   }
986 
987   /**
988    * @notice Mint tokens for each ids in _ids
989    * @param _to       The address to mint tokens to
990    * @param _ids      Array of ids to mint
991    * @param _amounts  Array of amount of tokens to mint per id
992    * @param _data    Data to pass if receiver is contract
993    */
994   function _batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
995     internal
996   {
997     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH");
998 
999     // Number of mints to execute
1000     uint256 nMint = _ids.length;
1001 
1002      // Executing all minting
1003     for (uint256 i = 0; i < nMint; i++) {
1004       // Update storage balance
1005       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
1006     }
1007 
1008     // Emit batch mint event
1009     emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
1010 
1011     // Calling onReceive method if recipient is contract
1012     _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
1013   }
1014 
1015 
1016   /****************************************|
1017   |            Burning Functions           |
1018   |_______________________________________*/
1019 
1020   /**
1021    * @notice Burn _amount of tokens of a given token id
1022    * @param _from    The address to burn tokens from
1023    * @param _id      Token id to burn
1024    * @param _amount  The amount to be burned
1025    */
1026   function _burn(address _from, uint256 _id, uint256 _amount)
1027     internal
1028   {
1029     //Substract _amount
1030     balances[_from][_id] = balances[_from][_id].sub(_amount);
1031 
1032     // Emit event
1033     emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
1034   }
1035 
1036   /**
1037    * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
1038    * @param _from     The address to burn tokens from
1039    * @param _ids      Array of token ids to burn
1040    * @param _amounts  Array of the amount to be burned
1041    */
1042   function _batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts)
1043     internal
1044   {
1045     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH");
1046 
1047     // Number of mints to execute
1048     uint256 nBurn = _ids.length;
1049 
1050      // Executing all minting
1051     for (uint256 i = 0; i < nBurn; i++) {
1052       // Update storage balance
1053       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
1054     }
1055 
1056     // Emit batch mint event
1057     emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
1058   }
1059 
1060 }
1061 
1062 library Strings {
1063 	// via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1064 	function strConcat(
1065 		string memory _a,
1066 		string memory _b,
1067 		string memory _c,
1068 		string memory _d,
1069 		string memory _e
1070 	) internal pure returns (string memory) {
1071 		bytes memory _ba = bytes(_a);
1072 		bytes memory _bb = bytes(_b);
1073 		bytes memory _bc = bytes(_c);
1074 		bytes memory _bd = bytes(_d);
1075 		bytes memory _be = bytes(_e);
1076 		string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1077 		bytes memory babcde = bytes(abcde);
1078 		uint256 k = 0;
1079 		for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1080 		for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1081 		for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1082 		for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1083 		for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1084 		return string(babcde);
1085 	}
1086 
1087 	function strConcat(
1088 		string memory _a,
1089 		string memory _b,
1090 		string memory _c,
1091 		string memory _d
1092 	) internal pure returns (string memory) {
1093 		return strConcat(_a, _b, _c, _d, "");
1094 	}
1095 
1096 	function strConcat(
1097 		string memory _a,
1098 		string memory _b,
1099 		string memory _c
1100 	) internal pure returns (string memory) {
1101 		return strConcat(_a, _b, _c, "", "");
1102 	}
1103 
1104 	function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
1105 		return strConcat(_a, _b, "", "", "");
1106 	}
1107 
1108 	function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
1109 		if (_i == 0) {
1110 			return "0";
1111 		}
1112 		uint256 j = _i;
1113 		uint256 len;
1114 		while (j != 0) {
1115 			len++;
1116 			j /= 10;
1117 		}
1118 		bytes memory bstr = new bytes(len);
1119 		uint256 k = len - 1;
1120 		while (_i != 0) {
1121 			bstr[k--] = bytes1(uint8(48 + (_i % 10)));
1122 			_i /= 10;
1123 		}
1124 		return string(bstr);
1125 	}
1126 }
1127 
1128 contract OwnableDelegateProxy {}
1129 
1130 contract ProxyRegistry {
1131 	mapping(address => OwnableDelegateProxy) public proxies;
1132 }
1133 
1134 /**
1135  * @title ERC1155Tradable
1136  * ERC1155Tradable - ERC1155 contract that whitelists an operator address, 
1137  * has create and mint functionality, and supports useful standards from OpenZeppelin,
1138   like _exists(), name(), symbol(), and totalSupply()
1139  */
1140 contract ERC1155Tradable is ERC1155, ERC1155MintBurn, ERC1155Metadata, Ownable, MinterRole, WhitelistAdminRole {
1141 	using Strings for string;
1142 
1143 	address proxyRegistryAddress;
1144 	uint256 private _currentTokenID = 0;
1145 	mapping(uint256 => address) public creators;
1146 	mapping(uint256 => uint256) public tokenSupply;
1147 	mapping(uint256 => uint256) public tokenMaxSupply;
1148 	// Contract name
1149 	string public name;
1150 	// Contract symbol
1151 	string public symbol;
1152 
1153 	constructor(
1154 		string memory _name,
1155 		string memory _symbol,
1156 		address _proxyRegistryAddress
1157 	) public {
1158 		name = _name;
1159 		symbol = _symbol;
1160 		proxyRegistryAddress = _proxyRegistryAddress;
1161 	}
1162 
1163 	function removeWhitelistAdmin(address account) public onlyOwner {
1164 		_removeWhitelistAdmin(account);
1165 	}
1166 
1167 	function removeMinter(address account) public onlyOwner {
1168 		_removeMinter(account);
1169 	}
1170 
1171 	function uri(uint256 _id) public view returns (string memory) {
1172 		require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1173 		return Strings.strConcat(baseMetadataURI, Strings.uint2str(_id));
1174 	}
1175 
1176 	/**
1177 	 * @dev Returns the total quantity for a token ID
1178 	 * @param _id uint256 ID of the token to query
1179 	 * @return amount of token in existence
1180 	 */
1181 	function totalSupply(uint256 _id) public view returns (uint256) {
1182 		return tokenSupply[_id];
1183 	}
1184 
1185 	/**
1186 	 * @dev Returns the max quantity for a token ID
1187 	 * @param _id uint256 ID of the token to query
1188 	 * @return amount of token in existence
1189 	 */
1190 	function maxSupply(uint256 _id) public view returns (uint256) {
1191 		return tokenMaxSupply[_id];
1192 	}
1193 
1194 	/**
1195 	 * @dev Will update the base URL of token's URI
1196 	 * @param _newBaseMetadataURI New base URL of token's URI
1197 	 */
1198 	function setBaseMetadataURI(string memory _newBaseMetadataURI) public onlyWhitelistAdmin {
1199 		_setBaseMetadataURI(_newBaseMetadataURI);
1200 	}
1201 
1202 	/**
1203 	 * @dev Creates a new token type and assigns _initialSupply to an address
1204 	 * @param _maxSupply max supply allowed
1205 	 * @param _initialSupply Optional amount to supply the first owner
1206 	 * @param _uri Optional URI for this token type
1207 	 * @param _data Optional data to pass if receiver is contract
1208 	 * @return The newly created token ID
1209 	 */
1210 	function create(
1211 		uint256 _maxSupply,
1212 		uint256 _initialSupply,
1213 		string calldata _uri,
1214 		bytes calldata _data
1215 	) external onlyWhitelistAdmin returns (uint256 tokenId) {
1216 		require(_initialSupply <= _maxSupply, "Initial supply cannot be more than max supply");
1217 		uint256 _id = _getNextTokenID();
1218 		_incrementTokenTypeId();
1219 		creators[_id] = msg.sender;
1220 
1221 		if (bytes(_uri).length > 0) {
1222 			emit URI(_uri, _id);
1223 		}
1224 
1225 		if (_initialSupply != 0) _mint(msg.sender, _id, _initialSupply, _data);
1226 		tokenSupply[_id] = _initialSupply;
1227 		tokenMaxSupply[_id] = _maxSupply;
1228 		return _id;
1229 	}
1230 
1231 	/**
1232 	 * @dev Mints some amount of tokens to an address
1233 	 * @param _to          Address of the future owner of the token
1234 	 * @param _id          Token ID to mint
1235 	 * @param _quantity    Amount of tokens to mint
1236 	 * @param _data        Data to pass if receiver is contract
1237 	 */
1238 	function mint(
1239 		address _to,
1240 		uint256 _id,
1241 		uint256 _quantity,
1242 		bytes memory _data
1243 	) public onlyMinter {
1244 		uint256 tokenId = _id;
1245 		require(tokenSupply[tokenId] < tokenMaxSupply[tokenId], "Max supply reached");
1246 		_mint(_to, _id, _quantity, _data);
1247 		tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1248 	}
1249 
1250 	/**
1251 	 * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
1252 	 */
1253 	function isApprovedForAll(address _owner, address _operator) public view returns (bool isOperator) {
1254 		// Whitelist OpenSea proxy contract for easy trading.
1255 		ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1256 		if (address(proxyRegistry.proxies(_owner)) == _operator) {
1257 			return true;
1258 		}
1259 
1260 		return ERC1155.isApprovedForAll(_owner, _operator);
1261 	}
1262 
1263 	/**
1264 	 * @dev Returns whether the specified token exists by checking to see if it has a creator
1265 	 * @param _id uint256 ID of the token to query the existence of
1266 	 * @return bool whether the token exists
1267 	 */
1268 	function _exists(uint256 _id) internal view returns (bool) {
1269 		return creators[_id] != address(0);
1270 	}
1271 
1272 	/**
1273 	 * @dev calculates the next token ID based on value of _currentTokenID
1274 	 * @return uint256 for the next token ID
1275 	 */
1276 	function _getNextTokenID() private view returns (uint256) {
1277 		return _currentTokenID.add(1);
1278 	}
1279 
1280 	/**
1281 	 * @dev increments the value of _currentTokenID
1282 	 */
1283 	function _incrementTokenTypeId() private {
1284 		_currentTokenID++;
1285 	}
1286 }
1287 
1288 contract MemeTokenWrapper {
1289 	using SafeMath for uint256;
1290 	IERC20 public meme;
1291 
1292 	constructor(IERC20 _memeAddress) public {
1293 		meme = IERC20(_memeAddress);
1294 	}
1295 
1296 	uint256 private _totalSupply;
1297 	mapping(address => uint256) private _balances;
1298 
1299 	function totalSupply() public view returns (uint256) {
1300 		return _totalSupply;
1301 	}
1302 
1303 	function balanceOf(address account) public view returns (uint256) {
1304 		return _balances[account];
1305 	}
1306 
1307 	function stake(uint256 amount) public {
1308 		_totalSupply = _totalSupply.add(amount);
1309 		_balances[msg.sender] = _balances[msg.sender].add(amount);
1310 		meme.transferFrom(msg.sender, address(this), amount);
1311 	}
1312 
1313 	function withdraw(uint256 amount) public {
1314 		_totalSupply = _totalSupply.sub(amount);
1315 		_balances[msg.sender] = _balances[msg.sender].sub(amount);
1316 		meme.transfer(msg.sender, amount);
1317 	}
1318 }
1319 
1320 contract GenesisPool is MemeTokenWrapper, Ownable {
1321 	ERC1155Tradable public memes;
1322 
1323 	mapping(address => uint256) public lastUpdateTime;
1324 	mapping(address => uint256) public points;
1325 	mapping(uint256 => uint256) public cards;
1326 
1327 	event CardAdded(uint256 card, uint256 points);
1328 	event Staked(address indexed user, uint256 amount);
1329 	event Withdrawn(address indexed user, uint256 amount);
1330 	event Redeemed(address indexed user, uint256 amount);
1331 
1332 	modifier updateReward(address account) {
1333 		if (account != address(0)) {
1334 			points[account] = earned(account);
1335 			lastUpdateTime[account] = block.timestamp;
1336 		}
1337 		_;
1338 	}
1339 
1340 	constructor(ERC1155Tradable _memesAddress, IERC20 _memeAddress) public MemeTokenWrapper(_memeAddress) {
1341 		memes = _memesAddress;
1342 	}
1343 
1344 	function addCard(uint256 cardId, uint256 amount) public onlyOwner {
1345 		cards[cardId] = amount;
1346 		emit CardAdded(cardId, amount);
1347 	}
1348 
1349 	function earned(address account) public view returns (uint256) {
1350 		uint256 blockTime = block.timestamp;
1351 		return
1352 			points[account].add(
1353 				blockTime.sub(lastUpdateTime[account]).mul(1e18).div(86400).mul(balanceOf(account).div(1e8))
1354 			);
1355 	}
1356 
1357 	// stake visibility is public as overriding MemeTokenWrapper's stake() function
1358 	function stake(uint256 amount) public updateReward(msg.sender) {
1359 		require(amount.add(balanceOf(msg.sender)) <= 500000000, "Cannot stake more than 5 meme");
1360 
1361 		super.stake(amount);
1362 		emit Staked(msg.sender, amount);
1363 	}
1364 
1365 	function withdraw(uint256 amount) public updateReward(msg.sender) {
1366 		require(amount > 0, "Cannot withdraw 0");
1367 
1368 		super.withdraw(amount);
1369 		emit Withdrawn(msg.sender, amount);
1370 	}
1371 
1372 	function exit() external {
1373 		withdraw(balanceOf(msg.sender));
1374 	}
1375 
1376 	function redeem(uint256 card) public updateReward(msg.sender) {
1377 		require(cards[card] != 0, "Card not found");
1378 		require(points[msg.sender] >= cards[card], "Not enough points to redeem for card");
1379 		require(memes.totalSupply(card) < memes.maxSupply(card), "Max cards minted");
1380 
1381 		points[msg.sender] = points[msg.sender].sub(cards[card]);
1382 		memes.mint(msg.sender, card, 1, "");
1383 		emit Redeemed(msg.sender, cards[card]);
1384 	}
1385 }