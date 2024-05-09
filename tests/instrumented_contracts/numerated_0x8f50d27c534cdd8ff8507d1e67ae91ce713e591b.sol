1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.0;
3 
4 
5 /**
6  * @dev Standard math utilities missing in the Solidity language.
7  */
8 library Math {
9     /**
10      * @dev Returns the largest of two numbers.
11      */
12     function max(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a >= b ? a : b;
14     }
15 
16     /**
17      * @dev Returns the smallest of two numbers.
18      */
19     function min(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a < b ? a : b;
21     }
22 
23     /**
24      * @dev Returns the average of two numbers. The result is rounded towards
25      * zero.
26      */
27     function average(uint256 a, uint256 b) internal pure returns (uint256) {
28         // (a + b) / 2 can overflow, so we distribute
29         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
30     }
31 }
32 
33 /*
34  * @dev Provides information about the current execution context, including the
35  * sender of the transaction and its data. While these are generally available
36  * via msg.sender and msg.data, they should not be accessed in such a direct
37  * manner, since when dealing with GSN meta-transactions the account sending and
38  * paying for execution may not be the actual sender (as far as an application
39  * is concerned).
40  *
41  * This contract is only required for intermediate, library-like contracts.
42  */
43 contract Context {
44     // Empty internal constructor, to prevent people from mistakenly deploying
45     // an instance of this contract, which should be used via inheritance.
46     constructor () internal { }
47     // solhint-disable-previous-line no-empty-blocks
48 
49     function _msgSender() internal view returns (address payable) {
50         return msg.sender;
51     }
52 
53     function _msgData() internal view returns (bytes memory) {
54         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
55         return msg.data;
56     }
57 }
58 
59 /**
60  * @dev Contract module which provides a basic access control mechanism, where
61  * there is an account (an owner) that can be granted exclusive access to
62  * specific functions.
63  *
64  * This module is used through inheritance. It will make available the modifier
65  * `onlyOwner`, which can be applied to your functions to restrict their use to
66  * the owner.
67  */
68 contract Ownable is Context {
69     address private _owner;
70 
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     /**
74      * @dev Initializes the contract setting the deployer as the initial owner.
75      */
76     constructor () internal {
77         address msgSender = _msgSender();
78         _owner = msgSender;
79         emit OwnershipTransferred(address(0), msgSender);
80     }
81 
82     /**
83      * @dev Returns the address of the current owner.
84      */
85     function owner() public view returns (address) {
86         return _owner;
87     }
88 
89     /**
90      * @dev Throws if called by any account other than the owner.
91      */
92     modifier onlyOwner() {
93         require(isOwner(), "Ownable: caller is not the owner");
94         _;
95     }
96 
97     /**
98      * @dev Returns true if the caller is the current owner.
99      */
100     function isOwner() public view returns (bool) {
101         return _msgSender() == _owner;
102     }
103 
104     /**
105      * @dev Leaves the contract without owner. It will not be possible to call
106      * `onlyOwner` functions anymore. Can only be called by the current owner.
107      *
108      * NOTE: Renouncing ownership will leave the contract without an owner,
109      * thereby removing any functionality that is only available to the owner.
110      */
111     function renounceOwnership() public onlyOwner {
112         emit OwnershipTransferred(_owner, address(0));
113         _owner = address(0);
114     }
115 
116     /**
117      * @dev Transfers ownership of the contract to a new account (`newOwner`).
118      * Can only be called by the current owner.
119      */
120     function transferOwnership(address newOwner) public onlyOwner {
121         _transferOwnership(newOwner);
122     }
123 
124     /**
125      * @dev Transfers ownership of the contract to a new account (`newOwner`).
126      */
127     function _transferOwnership(address newOwner) internal {
128         require(newOwner != address(0), "Ownable: new owner is the zero address");
129         emit OwnershipTransferred(_owner, newOwner);
130         _owner = newOwner;
131     }
132 }
133 
134 /**
135  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
136  * the optional functions; to access them see {ERC20Detailed}.
137  */
138 interface IERC20 {
139     /**
140      * @dev Returns the amount of tokens in existence.
141      */
142     function totalSupply() external view returns (uint256);
143 
144     /**
145      * @dev Returns the amount of tokens owned by `account`.
146      */
147     function balanceOf(address account) external view returns (uint256);
148 
149     /**
150      * @dev Moves `amount` tokens from the caller's account to `recipient`.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * Emits a {Transfer} event.
155      */
156     function transfer(address recipient, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Returns the remaining number of tokens that `spender` will be
160      * allowed to spend on behalf of `owner` through {transferFrom}. This is
161      * zero by default.
162      *
163      * This value changes when {approve} or {transferFrom} are called.
164      */
165     function allowance(address owner, address spender) external view returns (uint256);
166 
167     /**
168      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * IMPORTANT: Beware that changing an allowance with this method brings the risk
173      * that someone may use both the old and the new allowance by unfortunate
174      * transaction ordering. One possible solution to mitigate this race
175      * condition is to first reduce the spender's allowance to 0 and set the
176      * desired value afterwards:
177      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178      *
179      * Emits an {Approval} event.
180      */
181     function approve(address spender, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Moves `amount` tokens from `sender` to `recipient` using the
185      * allowance mechanism. `amount` is then deducted from the caller's
186      * allowance.
187      *
188      * Returns a boolean value indicating whether the operation succeeded.
189      *
190      * Emits a {Transfer} event.
191      */
192     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
193 
194     /**
195      * @dev Emitted when `value` tokens are moved from one account (`from`) to
196      * another (`to`).
197      *
198      * Note that `value` may be zero.
199      */
200     event Transfer(address indexed from, address indexed to, uint256 value);
201 
202     /**
203      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
204      * a call to {approve}. `value` is the new allowance.
205      */
206     event Approval(address indexed owner, address indexed spender, uint256 value);
207 }
208 
209 /**
210  * @title Roles
211  * @dev Library for managing addresses assigned to a Role.
212  */
213 library Roles {
214     struct Role {
215         mapping (address => bool) bearer;
216     }
217 
218     /**
219      * @dev Give an account access to this role.
220      */
221     function add(Role storage role, address account) internal {
222         require(!has(role, account), "Roles: account already has role");
223         role.bearer[account] = true;
224     }
225 
226     /**
227      * @dev Remove an account's access to this role.
228      */
229     function remove(Role storage role, address account) internal {
230         require(has(role, account), "Roles: account does not have role");
231         role.bearer[account] = false;
232     }
233 
234     /**
235      * @dev Check if an account has this role.
236      * @return bool
237      */
238     function has(Role storage role, address account) internal view returns (bool) {
239         require(account != address(0), "Roles: account is the zero address");
240         return role.bearer[account];
241     }
242 }
243 
244 contract MinterRole is Context {
245     using Roles for Roles.Role;
246 
247     event MinterAdded(address indexed account);
248     event MinterRemoved(address indexed account);
249 
250     Roles.Role private _minters;
251 
252     constructor () internal {
253         _addMinter(_msgSender());
254     }
255 
256     modifier onlyMinter() {
257         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
258         _;
259     }
260 
261     function isMinter(address account) public view returns (bool) {
262         return _minters.has(account);
263     }
264 
265     function addMinter(address account) public onlyMinter {
266         _addMinter(account);
267     }
268 
269     function renounceMinter() public {
270         _removeMinter(_msgSender());
271     }
272 
273     function _addMinter(address account) internal {
274         _minters.add(account);
275         emit MinterAdded(account);
276     }
277 
278     function _removeMinter(address account) internal {
279         _minters.remove(account);
280         emit MinterRemoved(account);
281     }
282 }
283 
284 /**
285  * @title WhitelistAdminRole
286  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
287  */
288 contract WhitelistAdminRole is Context {
289     using Roles for Roles.Role;
290 
291     event WhitelistAdminAdded(address indexed account);
292     event WhitelistAdminRemoved(address indexed account);
293 
294     Roles.Role private _whitelistAdmins;
295 
296     constructor () internal {
297         _addWhitelistAdmin(_msgSender());
298     }
299 
300     modifier onlyWhitelistAdmin() {
301         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
302         _;
303     }
304 
305     function isWhitelistAdmin(address account) public view returns (bool) {
306         return _whitelistAdmins.has(account);
307     }
308 
309     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
310         _addWhitelistAdmin(account);
311     }
312 
313     function renounceWhitelistAdmin() public {
314         _removeWhitelistAdmin(_msgSender());
315     }
316 
317     function _addWhitelistAdmin(address account) internal {
318         _whitelistAdmins.add(account);
319         emit WhitelistAdminAdded(account);
320     }
321 
322     function _removeWhitelistAdmin(address account) internal {
323         _whitelistAdmins.remove(account);
324         emit WhitelistAdminRemoved(account);
325     }
326 }
327 
328 /**
329  * @title ERC165
330  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
331  */
332 interface IERC165 {
333 
334     /**
335      * @notice Query if a contract implements an interface
336      * @dev Interface identification is specified in ERC-165. This function
337      * uses less than 30,000 gas
338      * @param _interfaceId The interface identifier, as specified in ERC-165
339      */
340     function supportsInterface(bytes4 _interfaceId)
341     external
342     view
343     returns (bool);
344 }
345 
346 /**
347  * @title SafeMath
348  * @dev Unsigned math operations with safety checks that revert on error
349  */
350 library SafeMath {
351 
352   /**
353    * @dev Multiplies two unsigned integers, reverts on overflow.
354    */
355   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
356     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
357     // benefit is lost if 'b' is also tested.
358     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
359     if (a == 0) {
360       return 0;
361     }
362 
363     uint256 c = a * b;
364     require(c / a == b, "SafeMath#mul: OVERFLOW");
365 
366     return c;
367   }
368 
369   /**
370    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
371    */
372   function div(uint256 a, uint256 b) internal pure returns (uint256) {
373     // Solidity only automatically asserts when dividing by 0
374     require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
375     uint256 c = a / b;
376     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
377 
378     return c;
379   }
380 
381   /**
382    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
383    */
384   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
385     require(b <= a, "SafeMath#sub: UNDERFLOW");
386     uint256 c = a - b;
387 
388     return c;
389   }
390 
391   /**
392    * @dev Adds two unsigned integers, reverts on overflow.
393    */
394   function add(uint256 a, uint256 b) internal pure returns (uint256) {
395     uint256 c = a + b;
396     require(c >= a, "SafeMath#add: OVERFLOW");
397 
398     return c; 
399   }
400 
401   /**
402    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
403    * reverts when dividing by zero.
404    */
405   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
406     require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
407     return a % b;
408   }
409 
410 }
411 
412 /**
413  * @dev ERC-1155 interface for accepting safe transfers.
414  */
415 interface IERC1155TokenReceiver {
416 
417   /**
418    * @notice Handle the receipt of a single ERC1155 token type
419    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
420    * This function MAY throw to revert and reject the transfer
421    * Return of other amount than the magic value MUST result in the transaction being reverted
422    * Note: The token contract address is always the message sender
423    * @param _operator  The address which called the `safeTransferFrom` function
424    * @param _from      The address which previously owned the token
425    * @param _id        The id of the token being transferred
426    * @param _amount    The amount of tokens being transferred
427    * @param _data      Additional data with no specified format
428    * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
429    */
430   function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4);
431 
432   /**
433    * @notice Handle the receipt of multiple ERC1155 token types
434    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
435    * This function MAY throw to revert and reject the transfer
436    * Return of other amount than the magic value WILL result in the transaction being reverted
437    * Note: The token contract address is always the message sender
438    * @param _operator  The address which called the `safeBatchTransferFrom` function
439    * @param _from      The address which previously owned the token
440    * @param _ids       An array containing ids of each token being transferred
441    * @param _amounts   An array containing amounts of each token being transferred
442    * @param _data      Additional data with no specified format
443    * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
444    */
445   function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4);
446 
447   /**
448    * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
449    * @param  interfaceID The ERC-165 interface ID that is queried for support.s
450    * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
451    *      This function MUST NOT consume more than 5,000 gas.
452    * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
453    */
454   function supportsInterface(bytes4 interfaceID) external view returns (bool);
455 
456 }
457 
458 interface IERC1155 {
459   // Events
460 
461   /**
462    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
463    *   Operator MUST be msg.sender
464    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
465    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
466    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
467    *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
468    */
469   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
470 
471   /**
472    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
473    *   Operator MUST be msg.sender
474    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
475    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
476    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
477    *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
478    */
479   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
480 
481   /**
482    * @dev MUST emit when an approval is updated
483    */
484   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
485 
486   /**
487    * @dev MUST emit when the URI is updated for a token ID
488    *   URIs are defined in RFC 3986
489    *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
490    */
491   event URI(string _amount, uint256 indexed _id);
492 
493   /**
494    * @notice Transfers amount of an _id from the _from address to the _to address specified
495    * @dev MUST emit TransferSingle event on success
496    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
497    * MUST throw if `_to` is the zero address
498    * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
499    * MUST throw on any other error
500    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
501    * @param _from    Source address
502    * @param _to      Target address
503    * @param _id      ID of the token type
504    * @param _amount  Transfered amount
505    * @param _data    Additional data with no specified format, sent in call to `_to`
506    */
507   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
508 
509   /**
510    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
511    * @dev MUST emit TransferBatch event on success
512    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
513    * MUST throw if `_to` is the zero address
514    * MUST throw if length of `_ids` is not the same as length of `_amounts`
515    * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
516    * MUST throw on any other error
517    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
518    * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
519    * @param _from     Source addresses
520    * @param _to       Target addresses
521    * @param _ids      IDs of each token type
522    * @param _amounts  Transfer amounts per token type
523    * @param _data     Additional data with no specified format, sent in call to `_to`
524   */
525   function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
526   
527   /**
528    * @notice Get the balance of an account's Tokens
529    * @param _owner  The address of the token holder
530    * @param _id     ID of the Token
531    * @return        The _owner's balance of the Token type requested
532    */
533   function balanceOf(address _owner, uint256 _id) external view returns (uint256);
534 
535   /**
536    * @notice Get the balance of multiple account/token pairs
537    * @param _owners The addresses of the token holders
538    * @param _ids    ID of the Tokens
539    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
540    */
541   function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
542 
543   /**
544    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
545    * @dev MUST emit the ApprovalForAll event on success
546    * @param _operator  Address to add to the set of authorized operators
547    * @param _approved  True if the operator is approved, false to revoke approval
548    */
549   function setApprovalForAll(address _operator, bool _approved) external;
550 
551   /**
552    * @notice Queries the approval status of an operator for a given owner
553    * @param _owner     The owner of the Tokens
554    * @param _operator  Address of authorized operator
555    * @return isOperator           True if the operator is approved, false if not
556    */
557   function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
558 
559 }
560 
561 /**
562  * Copyright 2018 ZeroEx Intl.
563  * Licensed under the Apache License, Version 2.0 (the "License");
564  * you may not use this file except in compliance with the License.
565  * You may obtain a copy of the License at
566  *   http://www.apache.org/licenses/LICENSE-2.0
567  * Unless required by applicable law or agreed to in writing, software
568  * distributed under the License is distributed on an "AS IS" BASIS,
569  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
570  * See the License for the specific language governing permissions and
571  * limitations under the License.
572  */
573 /**
574  * Utility library of inline functions on addresses
575  */
576 library Address {
577 
578   /**
579    * Returns whether the target address is a contract
580    * @dev This function will return false if invoked during the constructor of a contract,
581    * as the code is not actually created until after the constructor finishes.
582    * @param account address of the account to check
583    * @return whether the target address is a contract
584    */
585   function isContract(address account) internal view returns (bool) {
586     bytes32 codehash;
587     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
588 
589     // XXX Currently there is no better way to check if there is a contract in an address
590     // than to check the size of the code at that address.
591     // See https://ethereum.stackexchange.com/a/14016/36603
592     // for more details about how this works.
593     // TODO Check this again before the Serenity release, because all addresses will be
594     // contracts then.
595     assembly { codehash := extcodehash(account) }
596     return (codehash != 0x0 && codehash != accountHash);
597   }
598 
599 }
600 
601 /**
602  * @dev Implementation of Multi-Token Standard contract
603  */
604 contract ERC1155 is IERC165 {
605   using SafeMath for uint256;
606   using Address for address;
607 
608 
609   /***********************************|
610   |        Variables and Events       |
611   |__________________________________*/
612 
613   // onReceive function signatures
614   bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;
615   bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
616 
617   // Objects balances
618   mapping (address => mapping(uint256 => uint256)) internal balances;
619 
620   // Operator Functions
621   mapping (address => mapping(address => bool)) internal operators;
622 
623   // Events
624   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
625   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
626   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
627   event URI(string _uri, uint256 indexed _id);
628 
629 
630   /***********************************|
631   |     Public Transfer Functions     |
632   |__________________________________*/
633 
634   /**
635    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
636    * @param _from    Source address
637    * @param _to      Target address
638    * @param _id      ID of the token type
639    * @param _amount  Transfered amount
640    * @param _data    Additional data with no specified format, sent in call to `_to`
641    */
642   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
643     public
644   {
645     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeTransferFrom: INVALID_OPERATOR");
646     require(_to != address(0),"ERC1155#safeTransferFrom: INVALID_RECIPIENT");
647     // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
648 
649     _safeTransferFrom(_from, _to, _id, _amount);
650     _callonERC1155Received(_from, _to, _id, _amount, _data);
651   }
652 
653   /**
654    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
655    * @param _from     Source addresses
656    * @param _to       Target addresses
657    * @param _ids      IDs of each token type
658    * @param _amounts  Transfer amounts per token type
659    * @param _data     Additional data with no specified format, sent in call to `_to`
660    */
661   function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
662     public
663   {
664     // Requirements
665     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR");
666     require(_to != address(0), "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT");
667 
668     _safeBatchTransferFrom(_from, _to, _ids, _amounts);
669     _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
670   }
671 
672 
673   /***********************************|
674   |    Internal Transfer Functions    |
675   |__________________________________*/
676 
677   /**
678    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
679    * @param _from    Source address
680    * @param _to      Target address
681    * @param _id      ID of the token type
682    * @param _amount  Transfered amount
683    */
684   function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount)
685     internal
686   {
687     // Update balances
688     balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
689     balances[_to][_id] = balances[_to][_id].add(_amount);     // Add amount
690 
691     // Emit event
692     emit TransferSingle(msg.sender, _from, _to, _id, _amount);
693   }
694 
695   /**
696    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
697    */
698   function _callonERC1155Received(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
699     internal
700   {
701     // Check if recipient is contract
702     if (_to.isContract()) {
703       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _amount, _data);
704       require(retval == ERC1155_RECEIVED_VALUE, "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");
705     }
706   }
707 
708   /**
709    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
710    * @param _from     Source addresses
711    * @param _to       Target addresses
712    * @param _ids      IDs of each token type
713    * @param _amounts  Transfer amounts per token type
714    */
715   function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts)
716     internal
717   {
718     require(_ids.length == _amounts.length, "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH");
719 
720     // Number of transfer to execute
721     uint256 nTransfer = _ids.length;
722 
723     // Executing all transfers
724     for (uint256 i = 0; i < nTransfer; i++) {
725       // Update storage balance of previous bin
726       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
727       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
728     }
729 
730     // Emit event
731     emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
732   }
733 
734   /**
735    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
736    */
737   function _callonERC1155BatchReceived(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
738     internal
739   {
740     // Pass data if recipient is contract
741     if (_to.isContract()) {
742       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _amounts, _data);
743       require(retval == ERC1155_BATCH_RECEIVED_VALUE, "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE");
744     }
745   }
746 
747 
748   /***********************************|
749   |         Operator Functions        |
750   |__________________________________*/
751 
752   /**
753    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
754    * @param _operator  Address to add to the set of authorized operators
755    * @param _approved  True if the operator is approved, false to revoke approval
756    */
757   function setApprovalForAll(address _operator, bool _approved)
758     external
759   {
760     // Update operator status
761     operators[msg.sender][_operator] = _approved;
762     emit ApprovalForAll(msg.sender, _operator, _approved);
763   }
764 
765   /**
766    * @notice Queries the approval status of an operator for a given owner
767    * @param _owner     The owner of the Tokens
768    * @param _operator  Address of authorized operator
769    * @return isOperator True if the operator is approved, false if not
770    */
771   function isApprovedForAll(address _owner, address _operator)
772     virtual public view returns (bool isOperator)
773   {
774     return operators[_owner][_operator];
775   }
776 
777 
778   /***********************************|
779   |         Balance Functions         |
780   |__________________________________*/
781 
782   /**
783    * @notice Get the balance of an account's Tokens
784    * @param _owner  The address of the token holder
785    * @param _id     ID of the Token
786    * @return The _owner's balance of the Token type requested
787    */
788   function balanceOf(address _owner, uint256 _id)
789     public view returns (uint256)
790   {
791     return balances[_owner][_id];
792   }
793 
794   /**
795    * @notice Get the balance of multiple account/token pairs
796    * @param _owners The addresses of the token holders
797    * @param _ids    ID of the Tokens
798    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
799    */
800   function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
801     public view returns (uint256[] memory)
802   {
803     require(_owners.length == _ids.length, "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH");
804 
805     // Variables
806     uint256[] memory batchBalances = new uint256[](_owners.length);
807 
808     // Iterate over each owner and token ID
809     for (uint256 i = 0; i < _owners.length; i++) {
810       batchBalances[i] = balances[_owners[i]][_ids[i]];
811     }
812 
813     return batchBalances;
814   }
815 
816 
817   /***********************************|
818   |          ERC165 Functions         |
819   |__________________________________*/
820 
821   /**
822    * @dev
823    * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
824    */
825   bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
826 
827   /**
828    * @dev
829    * INTERFACE_SIGNATURE_ERC1155 =
830    * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
831    * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
832    * bytes4(keccak256("balanceOf(address,uint256)")) ^
833    * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
834    * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
835    * bytes4(keccak256("isApprovedForAll(address,address)"));
836    */
837   bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
838 
839   /**
840    * @notice Query if a contract implements an interface
841    * @param _interfaceID  The interface identifier, as specified in ERC-165
842    * @return `true` if the contract implements `_interfaceID` and
843    */
844   function supportsInterface(bytes4 _interfaceID) override external view returns (bool) {
845     if (_interfaceID == INTERFACE_SIGNATURE_ERC165 ||
846         _interfaceID == INTERFACE_SIGNATURE_ERC1155) {
847       return true;
848     }
849     return false;
850   }
851 
852 }
853 
854 /**
855  * @notice Contract that handles metadata related methods.
856  * @dev Methods assume a deterministic generation of URI based on token IDs.
857  *      Methods also assume that URI uses hex representation of token IDs.
858  */
859 contract ERC1155Metadata {
860 
861   // URI's default URI prefix
862   string internal baseMetadataURI;
863   event URI(string _uri, uint256 indexed _id);
864 
865 
866   /***********************************|
867   |     Metadata Public Function s    |
868   |__________________________________*/
869 
870   /**
871    * @notice A distinct Uniform Resource Identifier (URI) for a given token.
872    * @dev URIs are defined in RFC 3986.
873    *      URIs are assumed to be deterministically generated based on token ID
874    *      Token IDs are assumed to be represented in their hex format in URIs
875    * @return URI string
876    */
877   function uri(uint256 _id) virtual public view returns (string memory) {
878     return string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
879   }
880 
881 
882   /***********************************|
883   |    Metadata Internal Functions    |
884   |__________________________________*/
885 
886   /**
887    * @notice Will emit default URI log event for corresponding token _id
888    * @param _tokenIDs Array of IDs of tokens to log default URI
889    */
890   function _logURIs(uint256[] memory _tokenIDs) internal {
891     string memory baseURL = baseMetadataURI;
892     string memory tokenURI;
893 
894     for (uint256 i = 0; i < _tokenIDs.length; i++) {
895       tokenURI = string(abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json"));
896       emit URI(tokenURI, _tokenIDs[i]);
897     }
898   }
899 
900   /**
901    * @notice Will emit a specific URI log event for corresponding token
902    * @param _tokenIDs IDs of the token corresponding to the _uris logged
903    * @param _URIs    The URIs of the specified _tokenIDs
904    */
905   function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs) internal {
906     require(_tokenIDs.length == _URIs.length, "ERC1155Metadata#_logURIs: INVALID_ARRAYS_LENGTH");
907     for (uint256 i = 0; i < _tokenIDs.length; i++) {
908       emit URI(_URIs[i], _tokenIDs[i]);
909     }
910   }
911 
912   /**
913    * @notice Will update the base URL of token's URI
914    * @param _newBaseMetadataURI New base URL of token's URI
915    */
916   function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
917     baseMetadataURI = _newBaseMetadataURI;
918   }
919 
920 
921   /***********************************|
922   |    Utility Internal Functions     |
923   |__________________________________*/
924 
925   /**
926    * @notice Convert uint256 to string
927    * @param _i Unsigned integer to convert to string
928    */
929   function _uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
930     if (_i == 0) {
931       return "0";
932     }
933 
934     uint256 j = _i;
935     uint256 ii = _i;
936     uint256 len;
937 
938     // Get number of bytes
939     while (j != 0) {
940       len++;
941       j /= 10;
942     }
943 
944     bytes memory bstr = new bytes(len);
945     uint256 k = len - 1;
946 
947     // Get each individual ASCII
948     while (ii != 0) {
949       bstr[k--] = byte(uint8(48 + ii % 10));
950       ii /= 10;
951     }
952 
953     // Convert to string
954     return string(bstr);
955   }
956 
957 }
958 
959 /**
960  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
961  *      a parent contract to be executed as they are `internal` functions
962  */
963 contract ERC1155MintBurn is ERC1155 {
964 
965 
966   /****************************************|
967   |            Minting Functions           |
968   |_______________________________________*/
969 
970   /**
971    * @notice Mint _amount of tokens of a given id
972    * @param _to      The address to mint tokens to
973    * @param _id      Token id to mint
974    * @param _amount  The amount to be minted
975    * @param _data    Data to pass if receiver is contract
976    */
977   function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)
978     internal
979   {
980     // Add _amount
981     balances[_to][_id] = balances[_to][_id].add(_amount);
982 
983     // Emit event
984     emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
985 
986     // Calling onReceive method if recipient is contract
987     _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
988   }
989 
990   /**
991    * @notice Mint tokens for each ids in _ids
992    * @param _to       The address to mint tokens to
993    * @param _ids      Array of ids to mint
994    * @param _amounts  Array of amount of tokens to mint per id
995    * @param _data    Data to pass if receiver is contract
996    */
997   function _batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
998     internal
999   {
1000     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH");
1001 
1002     // Number of mints to execute
1003     uint256 nMint = _ids.length;
1004 
1005      // Executing all minting
1006     for (uint256 i = 0; i < nMint; i++) {
1007       // Update storage balance
1008       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
1009     }
1010 
1011     // Emit batch mint event
1012     emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
1013 
1014     // Calling onReceive method if recipient is contract
1015     _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
1016   }
1017 
1018 
1019   /****************************************|
1020   |            Burning Functions           |
1021   |_______________________________________*/
1022 
1023   /**
1024    * @notice Burn _amount of tokens of a given token id
1025    * @param _from    The address to burn tokens from
1026    * @param _id      Token id to burn
1027    * @param _amount  The amount to be burned
1028    */
1029   function _burn(address _from, uint256 _id, uint256 _amount)
1030     internal
1031   {
1032     //Substract _amount
1033     balances[_from][_id] = balances[_from][_id].sub(_amount);
1034 
1035     // Emit event
1036     emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
1037   }
1038 
1039   /**
1040    * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
1041    * @param _from     The address to burn tokens from
1042    * @param _ids      Array of token ids to burn
1043    * @param _amounts  Array of the amount to be burned
1044    */
1045   function _batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts)
1046     internal
1047   {
1048     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH");
1049 
1050     // Number of mints to execute
1051     uint256 nBurn = _ids.length;
1052 
1053      // Executing all minting
1054     for (uint256 i = 0; i < nBurn; i++) {
1055       // Update storage balance
1056       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
1057     }
1058 
1059     // Emit batch mint event
1060     emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
1061   }
1062 
1063 }
1064 
1065 library Strings {
1066   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1067   function strConcat(
1068     string memory _a,
1069     string memory _b,
1070     string memory _c,
1071     string memory _d,
1072     string memory _e
1073   ) internal pure returns (string memory) {
1074     bytes memory _ba = bytes(_a);
1075     bytes memory _bb = bytes(_b);
1076     bytes memory _bc = bytes(_c);
1077     bytes memory _bd = bytes(_d);
1078     bytes memory _be = bytes(_e);
1079     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1080     bytes memory babcde = bytes(abcde);
1081     uint256 k = 0;
1082     for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1083     for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1084     for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1085     for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1086     for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1087     return string(babcde);
1088   }
1089 
1090   function strConcat(
1091     string memory _a,
1092     string memory _b,
1093     string memory _c,
1094     string memory _d
1095   ) internal pure returns (string memory) {
1096     return strConcat(_a, _b, _c, _d, "");
1097   }
1098 
1099   function strConcat(
1100     string memory _a,
1101     string memory _b,
1102     string memory _c
1103   ) internal pure returns (string memory) {
1104     return strConcat(_a, _b, _c, "", "");
1105   }
1106 
1107   function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
1108     return strConcat(_a, _b, "", "", "");
1109   }
1110 
1111   function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
1112     if (_i == 0) {
1113       return "0";
1114     }
1115     uint256 j = _i;
1116     uint256 len;
1117     while (j != 0) {
1118       len++;
1119       j /= 10;
1120     }
1121     bytes memory bstr = new bytes(len);
1122     uint256 k = len - 1;
1123     while (_i != 0) {
1124       bstr[k--] = bytes1(uint8(48 + (_i % 10)));
1125       _i /= 10;
1126     }
1127     return string(bstr);
1128   }
1129 }
1130 
1131 contract OwnableDelegateProxy {}
1132 
1133 contract ProxyRegistry {
1134   mapping(address => OwnableDelegateProxy) public proxies;
1135 }
1136 
1137 /**
1138  * @title ERC1155Tradable
1139  * ERC1155Tradable - ERC1155 contract that whitelists an operator address, 
1140  * has create and mint functionality, and supports useful standards from OpenZeppelin,
1141   like _exists(), name(), symbol(), and totalSupply()
1142  */
1143 contract ERC1155Tradable is ERC1155, ERC1155MintBurn, ERC1155Metadata, Ownable, MinterRole, WhitelistAdminRole {
1144   using Strings for string;
1145 
1146   address proxyRegistryAddress;
1147   uint256 private _currentTokenID = 0;
1148   mapping(uint256 => address) public creators;
1149   mapping(uint256 => uint256) public tokenSupply;
1150   mapping(uint256 => uint256) public tokenMaxSupply;
1151   // Contract name
1152   string public name;
1153   // Contract symbol
1154   string public symbol;
1155 
1156   constructor(
1157     string memory _name,
1158     string memory _symbol,
1159     address _proxyRegistryAddress
1160   ) public {
1161     name = _name;
1162     symbol = _symbol;
1163     proxyRegistryAddress = _proxyRegistryAddress;
1164   }
1165 
1166   function removeWhitelistAdmin(address account) public onlyOwner {
1167     _removeWhitelistAdmin(account);
1168   }
1169 
1170   function removeMinter(address account) public onlyOwner {
1171     _removeMinter(account);
1172   }
1173 
1174   function uri(uint256 _id) override public view returns (string memory) {
1175     require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1176     return Strings.strConcat(baseMetadataURI, Strings.uint2str(_id));
1177   }
1178 
1179   /**
1180    * @dev Returns the total quantity for a token ID
1181    * @param _id uint256 ID of the token to query
1182    * @return amount of token in existence
1183    */
1184   function totalSupply(uint256 _id) public view returns (uint256) {
1185     return tokenSupply[_id];
1186   }
1187 
1188   /**
1189    * @dev Returns the max quantity for a token ID
1190    * @param _id uint256 ID of the token to query
1191    * @return amount of token in existence
1192    */
1193   function maxSupply(uint256 _id) public view returns (uint256) {
1194     return tokenMaxSupply[_id];
1195   }
1196 
1197   /**
1198    * @dev Will update the base URL of token's URI
1199    * @param _newBaseMetadataURI New base URL of token's URI
1200    */
1201   function setBaseMetadataURI(string memory _newBaseMetadataURI) public onlyWhitelistAdmin {
1202     _setBaseMetadataURI(_newBaseMetadataURI);
1203   }
1204 
1205   /**
1206    * @dev Creates a new token type and assigns _initialSupply to an address
1207    * @param _maxSupply max supply allowed
1208    * @param _initialSupply Optional amount to supply the first owner
1209    * @param _uri Optional URI for this token type
1210    * @param _data Optional data to pass if receiver is contract
1211    * @return tokenId The newly created token ID
1212    */
1213   function create(
1214     uint256 _maxSupply,
1215     uint256 _initialSupply,
1216     string calldata _uri,
1217     bytes calldata _data
1218   ) external onlyWhitelistAdmin returns (uint256 tokenId) {
1219     require(_initialSupply <= _maxSupply, "Initial supply cannot be more than max supply");
1220     uint256 _id = _getNextTokenID();
1221     _incrementTokenTypeId();
1222     creators[_id] = msg.sender;
1223 
1224     if (bytes(_uri).length > 0) {
1225       emit URI(_uri, _id);
1226     }
1227 
1228     if (_initialSupply != 0) _mint(msg.sender, _id, _initialSupply, _data);
1229     tokenSupply[_id] = _initialSupply;
1230     tokenMaxSupply[_id] = _maxSupply;
1231     return _id;
1232   }
1233 
1234   /**
1235    * @dev Mints some amount of tokens to an address
1236    * @param _to          Address of the future owner of the token
1237    * @param _id          Token ID to mint
1238    * @param _quantity    Amount of tokens to mint
1239    * @param _data        Data to pass if receiver is contract
1240    */
1241   function mint(
1242     address _to,
1243     uint256 _id,
1244     uint256 _quantity,
1245     bytes memory _data
1246   ) public onlyMinter {
1247     uint256 tokenId = _id;
1248     require(tokenSupply[tokenId] < tokenMaxSupply[tokenId], "Max supply reached");
1249     _mint(_to, _id, _quantity, _data);
1250     tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1251   }
1252 
1253   /**
1254    * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
1255    */
1256   function isApprovedForAll(address _owner, address _operator) override public view returns (bool isOperator) {
1257     // Whitelist OpenSea proxy contract for easy trading.
1258     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1259     if (address(proxyRegistry.proxies(_owner)) == _operator) {
1260       return true;
1261     }
1262 
1263     return ERC1155.isApprovedForAll(_owner, _operator);
1264   }
1265 
1266   /**
1267    * @dev Returns whether the specified token exists by checking to see if it has a creator
1268    * @param _id uint256 ID of the token to query the existence of
1269    * @return bool whether the token exists
1270    */
1271   function _exists(uint256 _id) internal view returns (bool) {
1272     return creators[_id] != address(0);
1273   }
1274 
1275   /**
1276    * @dev calculates the next token ID based on value of _currentTokenID
1277    * @return uint256 for the next token ID
1278    */
1279   function _getNextTokenID() private view returns (uint256) {
1280     return _currentTokenID.add(1);
1281   }
1282 
1283   /**
1284    * @dev increments the value of _currentTokenID
1285    */
1286   function _incrementTokenTypeId() private {
1287     _currentTokenID++;
1288   }
1289 }
1290 
1291 contract TokenWrapper {
1292   using SafeMath for uint256;
1293   IERC20 public token;
1294 
1295   constructor(IERC20 _tokenAddress) public {
1296     token = IERC20(_tokenAddress);
1297   }
1298 
1299   uint256 private _totalSupply;
1300   mapping(address => uint256) private _balances;
1301 
1302   function totalSupply() public view returns (uint256) {
1303     return _totalSupply;
1304   }
1305 
1306   function balanceOf(address account) public view returns (uint256) {
1307     return _balances[account];
1308   }
1309 
1310   function stake(uint256 amount) virtual public {
1311     require(amount > 0, "amount cannot be 0");
1312     _totalSupply = _totalSupply.add(amount);
1313     _balances[msg.sender] = _balances[msg.sender].add(amount);
1314     token.transferFrom(msg.sender, address(this), amount);
1315   }
1316 
1317   function withdraw(uint256 amount) virtual public {
1318     _totalSupply = _totalSupply.sub(amount);
1319     _balances[msg.sender] = _balances[msg.sender].sub(amount);
1320     token.transfer(msg.sender, amount);
1321   }
1322 }
1323 
1324 interface ISalePoolUtils {
1325   function getMinStake() external pure returns(uint);
1326   function getProduction(uint _stacked) external pure returns(uint);
1327 }
1328 
1329 contract SalePool is TokenWrapper, Ownable {
1330   ERC1155Tradable public nfts;
1331   ISalePoolUtils public utils;
1332 
1333   mapping(address => uint256) public lastUpdateTime;
1334   mapping(address => uint256) public points;
1335   mapping(uint256 => uint256) public cards;
1336 
1337   event CardAdded(uint256 card, uint256 points);
1338   event Staked(address indexed user, uint256 amount);
1339   event Withdrawn(address indexed user, uint256 amount);
1340   event Redeemed(address indexed user, uint256 amount);
1341 
1342   modifier updateReward(address account) {
1343     if (account != address(0)) {
1344       points[account] = earned(account);
1345       lastUpdateTime[account] = block.timestamp;
1346     }
1347     _;
1348   }
1349 
1350   constructor(ERC1155Tradable _nftsAddress, IERC20 _tokenAddress, ISalePoolUtils _utils) public TokenWrapper(_tokenAddress) {
1351     nfts = _nftsAddress;
1352     utils = _utils;
1353   }
1354 
1355   function addCard(uint256 cardId, uint256 amount) public onlyOwner {
1356     cards[cardId] = amount;
1357     emit CardAdded(cardId, amount);
1358   }
1359 
1360   function earned(address account) public view returns (uint256) {
1361     uint256 blockTime = block.timestamp;
1362     return points[account].add(blockTime.sub(lastUpdateTime[account]).mul(utils.getProduction(balanceOf(account))));
1363   }
1364 
1365   function stake(uint256 amount) override public updateReward(msg.sender) {
1366     uint endBalance = balanceOf(msg.sender).add(amount);
1367     require(endBalance >= utils.getMinStake(), "min stake - 300 LMT");
1368     require(endBalance <= 1000000e18, "total stake cannot be more 1 million LMT");
1369     super.stake(amount);
1370     emit Staked(msg.sender, amount);
1371   }
1372 
1373   function withdraw(uint256 amount) override public updateReward(msg.sender) {
1374     require(amount > 0, "Cannot withdraw 0");
1375     uint endBalance = balanceOf(msg.sender).sub(amount);
1376     require(endBalance == 0 || endBalance >= utils.getMinStake(), "cannot withdraw if stake less 300 LMT");
1377 
1378     super.withdraw(amount);
1379     emit Withdrawn(msg.sender, amount);
1380   }
1381 
1382   function exit() external {
1383     withdraw(balanceOf(msg.sender));
1384   }
1385 
1386   function redeem(uint256 card) public updateReward(msg.sender) {
1387     require(cards[card] != 0, "Card not found");
1388     require(points[msg.sender] >= cards[card], "Not enough points to redeem for card");
1389     require(nfts.totalSupply(card) < nfts.maxSupply(card), "Max cards minted");
1390 
1391     points[msg.sender] = points[msg.sender].sub(cards[card]);
1392     nfts.mint(msg.sender, card, 1, "");
1393     emit Redeemed(msg.sender, cards[card]);
1394   }
1395 }