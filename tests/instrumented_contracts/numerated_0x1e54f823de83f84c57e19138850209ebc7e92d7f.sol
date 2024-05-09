1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-26
3 */
4 
5 pragma solidity >=0.5.0;
6 
7 
8 /**
9  * @dev Standard math utilities missing in the Solidity language.
10  */
11 library Math {
12     /**
13      * @dev Returns the largest of two numbers.
14      */
15     function max(uint256 a, uint256 b) internal pure returns (uint256) {
16         return a >= b ? a : b;
17     }
18 
19     /**
20      * @dev Returns the smallest of two numbers.
21      */
22     function min(uint256 a, uint256 b) internal pure returns (uint256) {
23         return a < b ? a : b;
24     }
25 
26     /**
27      * @dev Returns the average of two numbers. The result is rounded towards
28      * zero.
29      */
30     function average(uint256 a, uint256 b) internal pure returns (uint256) {
31         // (a + b) / 2 can overflow, so we distribute
32         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
33     }
34 }
35 
36 /*
37  * @dev Provides information about the current execution context, including the
38  * sender of the transaction and its data. While these are generally available
39  * via msg.sender and msg.data, they should not be accessed in such a direct
40  * manner, since when dealing with GSN meta-transactions the account sending and
41  * paying for execution may not be the actual sender (as far as an application
42  * is concerned).
43  *
44  * This contract is only required for intermediate, library-like contracts.
45  */
46 contract Context {
47     function _msgSender() internal view returns (address payable) {
48         return msg.sender;
49     }
50 
51     function _msgData() internal view returns (bytes memory) {
52         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
53         return msg.data;
54     }
55 }
56 
57 /**
58  * @dev Contract module which provides a basic access control mechanism, where
59  * there is an account (an owner) that can be granted exclusive access to
60  * specific functions.
61  *
62  * This module is used through inheritance. It will make available the modifier
63  * `onlyOwner`, which can be applied to your functions to restrict their use to
64  * the owner.
65  */
66 contract Ownable is Context {
67     address private _owner;
68 
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     /**
72      * @dev Initializes the contract setting the deployer as the initial owner.
73      */
74     constructor () public {
75         address msgSender = _msgSender();
76         _owner = msgSender;
77         emit OwnershipTransferred(address(0), msgSender);
78     }
79 
80     /**
81      * @dev Returns the address of the current owner.
82      */
83     function owner() public view returns (address) {
84         return _owner;
85     }
86 
87     /**
88      * @dev Throws if called by any account other than the owner.
89      */
90     modifier onlyOwner() {
91         require(isOwner(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     /**
96      * @dev Returns true if the caller is the current owner.
97      */
98     function isOwner() public view returns (bool) {
99         return _msgSender() == _owner;
100     }
101 
102     /**
103      * @dev Leaves the contract without owner. It will not be possible to call
104      * `onlyOwner` functions anymore. Can only be called by the current owner.
105      *
106      * NOTE: Renouncing ownership will leave the contract without an owner,
107      * thereby removing any functionality that is only available to the owner.
108      */
109     function renounceOwnership() public onlyOwner {
110         emit OwnershipTransferred(_owner, address(0));
111         _owner = address(0);
112     }
113 
114     /**
115      * @dev Transfers ownership of the contract to a new account (`newOwner`).
116      * Can only be called by the current owner.
117      */
118     function transferOwnership(address newOwner) public onlyOwner {
119         _transferOwnership(newOwner);
120     }
121 
122     /**
123      * @dev Transfers ownership of the contract to a new account (`newOwner`).
124      */
125     function _transferOwnership(address newOwner) internal {
126         require(newOwner != address(0), "Ownable: new owner is the zero address");
127         emit OwnershipTransferred(_owner, newOwner);
128         _owner = newOwner;
129     }
130 }
131 
132 /**
133  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
134  * the optional functions; to access them see {ERC20Detailed}.
135  */
136 interface IERC20 {
137     /**
138      * @dev Returns the amount of tokens in existence.
139      */
140     function totalSupply() external view returns (uint256);
141 
142     /**
143      * @dev Returns the amount of tokens owned by `account`.
144      */
145     function balanceOf(address account) external view returns (uint256);
146 
147     /**
148      * @dev Moves `amount` tokens from the caller's account to `recipient`.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * Emits a {Transfer} event.
153      */
154     function transfer(address recipient, uint256 amount) external returns (bool);
155 
156     /**
157      * @dev Returns the remaining number of tokens that `spender` will be
158      * allowed to spend on behalf of `owner` through {transferFrom}. This is
159      * zero by default.
160      *
161      * This value changes when {approve} or {transferFrom} are called.
162      */
163     function allowance(address owner, address spender) external view returns (uint256);
164 
165     /**
166      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * IMPORTANT: Beware that changing an allowance with this method brings the risk
171      * that someone may use both the old and the new allowance by unfortunate
172      * transaction ordering. One possible solution to mitigate this race
173      * condition is to first reduce the spender's allowance to 0 and set the
174      * desired value afterwards:
175      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176      *
177      * Emits an {Approval} event.
178      */
179     function approve(address spender, uint256 amount) external returns (bool);
180 
181     /**
182      * @dev Moves `amount` tokens from `sender` to `recipient` using the
183      * allowance mechanism. `amount` is then deducted from the caller's
184      * allowance.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
191 
192     /**
193      * @dev Emitted when `value` tokens are moved from one account (`from`) to
194      * another (`to`).
195      *
196      * Note that `value` may be zero.
197      */
198     event Transfer(address indexed from, address indexed to, uint256 value);
199 
200     /**
201      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
202      * a call to {approve}. `value` is the new allowance.
203      */
204     event Approval(address indexed owner, address indexed spender, uint256 value);
205 }
206 
207 /**
208  * @title Roles
209  * @dev Library for managing addresses assigned to a Role.
210  */
211 library Roles {
212     struct Role {
213         mapping (address => bool) bearer;
214     }
215 
216     /**
217      * @dev Give an account access to this role.
218      */
219     function add(Role storage role, address account) internal {
220         require(!has(role, account), "Roles: account already has role");
221         role.bearer[account] = true;
222     }
223 
224     /**
225      * @dev Remove an account's access to this role.
226      */
227     function remove(Role storage role, address account) internal {
228         require(has(role, account), "Roles: account does not have role");
229         role.bearer[account] = false;
230     }
231 
232     /**
233      * @dev Check if an account has this role.
234      * @return bool
235      */
236     function has(Role storage role, address account) internal view returns (bool) {
237         require(account != address(0), "Roles: account is the zero address");
238         return role.bearer[account];
239     }
240 }
241 
242 contract MinterRole is Context {
243     using Roles for Roles.Role;
244 
245     event MinterAdded(address indexed account);
246     event MinterRemoved(address indexed account);
247 
248     Roles.Role private _minters;
249 
250     constructor () public {
251         _addMinter(_msgSender());
252     }
253 
254     modifier onlyMinter() {
255         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
256         _;
257     }
258 
259     function isMinter(address account) public view returns (bool) {
260         return _minters.has(account);
261     }
262 
263     function addMinter(address account) public onlyMinter {
264         _addMinter(account);
265     }
266 
267     function renounceMinter() public {
268         _removeMinter(_msgSender());
269     }
270 
271     function _addMinter(address account) internal {
272         _minters.add(account);
273         emit MinterAdded(account);
274     }
275 
276     function _removeMinter(address account) internal {
277         _minters.remove(account);
278         emit MinterRemoved(account);
279     }
280 }
281 
282 /**
283  * @title WhitelistAdminRole
284  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
285  */
286 contract WhitelistAdminRole is Context {
287     using Roles for Roles.Role;
288 
289     event WhitelistAdminAdded(address indexed account);
290     event WhitelistAdminRemoved(address indexed account);
291 
292     Roles.Role private _whitelistAdmins;
293 
294     constructor () public {
295         _addWhitelistAdmin(_msgSender());
296     }
297 
298     modifier onlyWhitelistAdmin() {
299         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
300         _;
301     }
302 
303     function isWhitelistAdmin(address account) public view returns (bool) {
304         return _whitelistAdmins.has(account);
305     }
306 
307     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
308         _addWhitelistAdmin(account);
309     }
310 
311     function renounceWhitelistAdmin() public {
312         _removeWhitelistAdmin(_msgSender());
313     }
314 
315     function _addWhitelistAdmin(address account) internal {
316         _whitelistAdmins.add(account);
317         emit WhitelistAdminAdded(account);
318     }
319 
320     function _removeWhitelistAdmin(address account) internal {
321         _whitelistAdmins.remove(account);
322         emit WhitelistAdminRemoved(account);
323     }
324 }
325 
326 /**
327  * @title ERC165
328  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
329  */
330 interface IERC165 {
331 
332     /**
333      * @notice Query if a contract implements an interface
334      * @dev Interface identification is specified in ERC-165. This function
335      * uses less than 30,000 gas
336      * @param _interfaceId The interface identifier, as specified in ERC-165
337      */
338     function supportsInterface(bytes4 _interfaceId)
339     external
340     view
341     returns (bool);
342 }
343 
344 /**
345  * @title SafeMath
346  * @dev Unsigned math operations with safety checks that revert on error
347  */
348 library SafeMath {
349 
350   /**
351    * @dev Multiplies two unsigned integers, reverts on overflow.
352    */
353   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
354     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
355     // benefit is lost if 'b' is also tested.
356     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
357     if (a == 0) {
358       return 0;
359     }
360 
361     uint256 c = a * b;
362     require(c / a == b, "SafeMath#mul: OVERFLOW");
363 
364     return c;
365   }
366 
367   /**
368    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
369    */
370   function div(uint256 a, uint256 b) internal pure returns (uint256) {
371     // Solidity only automatically asserts when dividing by 0
372     require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
373     uint256 c = a / b;
374     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
375 
376     return c;
377   }
378 
379   /**
380    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
381    */
382   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
383     require(b <= a, "SafeMath#sub: UNDERFLOW");
384     uint256 c = a - b;
385 
386     return c;
387   }
388 
389   /**
390    * @dev Adds two unsigned integers, reverts on overflow.
391    */
392   function add(uint256 a, uint256 b) internal pure returns (uint256) {
393     uint256 c = a + b;
394     require(c >= a, "SafeMath#add: OVERFLOW");
395 
396     return c; 
397   }
398 
399   /**
400    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
401    * reverts when dividing by zero.
402    */
403   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
404     require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
405     return a % b;
406   }
407 
408 }
409 
410 /**
411  * @dev ERC-1155 interface for accepting safe transfers.
412  */
413 interface IERC1155TokenReceiver {
414 
415   /**
416    * @notice Handle the receipt of a single ERC1155 token type
417    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
418    * This function MAY throw to revert and reject the transfer
419    * Return of other amount than the magic value MUST result in the transaction being reverted
420    * Note: The token contract address is always the message sender
421    * @param _operator  The address which called the `safeTransferFrom` function
422    * @param _from      The address which previously owned the token
423    * @param _id        The id of the token being transferred
424    * @param _amount    The amount of tokens being transferred
425    * @param _data      Additional data with no specified format
426    * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
427    */
428   function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4);
429 
430   /**
431    * @notice Handle the receipt of multiple ERC1155 token types
432    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
433    * This function MAY throw to revert and reject the transfer
434    * Return of other amount than the magic value WILL result in the transaction being reverted
435    * Note: The token contract address is always the message sender
436    * @param _operator  The address which called the `safeBatchTransferFrom` function
437    * @param _from      The address which previously owned the token
438    * @param _ids       An array containing ids of each token being transferred
439    * @param _amounts   An array containing amounts of each token being transferred
440    * @param _data      Additional data with no specified format
441    * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
442    */
443   function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4);
444 
445   /**
446    * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
447    * @param  interfaceID The ERC-165 interface ID that is queried for support.s
448    * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
449    *      This function MUST NOT consume more than 5,000 gas.
450    * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
451    */
452   function supportsInterface(bytes4 interfaceID) external view returns (bool);
453 
454 }
455 
456 interface IERC1155 {
457   // Events
458 
459   /**
460    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
461    *   Operator MUST be msg.sender
462    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
463    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
464    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
465    *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
466    */
467   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
468 
469   /**
470    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
471    *   Operator MUST be msg.sender
472    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
473    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
474    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
475    *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
476    */
477   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
478 
479   /**
480    * @dev MUST emit when an approval is updated
481    */
482   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
483 
484   /**
485    * @dev MUST emit when the URI is updated for a token ID
486    *   URIs are defined in RFC 3986
487    *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
488    */
489   event URI(string _amount, uint256 indexed _id);
490 
491   /**
492    * @notice Transfers amount of an _id from the _from address to the _to address specified
493    * @dev MUST emit TransferSingle event on success
494    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
495    * MUST throw if `_to` is the zero address
496    * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
497    * MUST throw on any other error
498    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
499    * @param _from    Source address
500    * @param _to      Target address
501    * @param _id      ID of the token type
502    * @param _amount  Transfered amount
503    * @param _data    Additional data with no specified format, sent in call to `_to`
504    */
505   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
506 
507   /**
508    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
509    * @dev MUST emit TransferBatch event on success
510    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
511    * MUST throw if `_to` is the zero address
512    * MUST throw if length of `_ids` is not the same as length of `_amounts`
513    * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
514    * MUST throw on any other error
515    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
516    * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
517    * @param _from     Source addresses
518    * @param _to       Target addresses
519    * @param _ids      IDs of each token type
520    * @param _amounts  Transfer amounts per token type
521    * @param _data     Additional data with no specified format, sent in call to `_to`
522   */
523   function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
524   
525   /**
526    * @notice Get the balance of an account's Tokens
527    * @param _owner  The address of the token holder
528    * @param _id     ID of the Token
529    * @return        The _owner's balance of the Token type requested
530    */
531   function balanceOf(address _owner, uint256 _id) external view returns (uint256);
532 
533   /**
534    * @notice Get the balance of multiple account/token pairs
535    * @param _owners The addresses of the token holders
536    * @param _ids    ID of the Tokens
537    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
538    */
539   function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
540 
541   /**
542    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
543    * @dev MUST emit the ApprovalForAll event on success
544    * @param _operator  Address to add to the set of authorized operators
545    * @param _approved  True if the operator is approved, false to revoke approval
546    */
547   function setApprovalForAll(address _operator, bool _approved) external;
548 
549   /**
550    * @notice Queries the approval status of an operator for a given owner
551    * @param _owner     The owner of the Tokens
552    * @param _operator  Address of authorized operator
553    */
554   function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
555 
556 }
557 
558 /**
559  * Copyright 2018 ZeroEx Intl.
560  * Licensed under the Apache License, Version 2.0 (the "License");
561  * you may not use this file except in compliance with the License.
562  * You may obtain a copy of the License at
563  *   http://www.apache.org/licenses/LICENSE-2.0
564  * Unless required by applicable law or agreed to in writing, software
565  * distributed under the License is distributed on an "AS IS" BASIS,
566  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
567  * See the License for the specific language governing permissions and
568  * limitations under the License.
569  */
570 /**
571  * Utility library of inline functions on addresses
572  */
573 library Address {
574 
575   /**
576    * Returns whether the target address is a contract
577    * @dev This function will return false if invoked during the constructor of a contract,
578    * as the code is not actually created until after the constructor finishes.
579    * @param account address of the account to check
580    * @return whether the target address is a contract
581    */
582   function isContract(address account) internal view returns (bool) {
583     bytes32 codehash;
584     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
585 
586     // XXX Currently there is no better way to check if there is a contract in an address
587     // than to check the size of the code at that address.
588     // See https://ethereum.stackexchange.com/a/14016/36603
589     // for more details about how this works.
590     // TODO Check this again before the Serenity release, because all addresses will be
591     // contracts then.
592     assembly { codehash := extcodehash(account) }
593     return (codehash != 0x0 && codehash != accountHash);
594   }
595 
596 }
597 
598 /**
599  * @dev Implementation of Multi-Token Standard contract
600  */
601 contract ERC1155 is IERC165 {
602   using SafeMath for uint256;
603   using Address for address;
604 
605 
606   /***********************************|
607   |        Variables and Events       |
608   |__________________________________*/
609 
610   // onReceive function signatures
611   bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;
612   bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
613 
614   // Objects balances
615   mapping (address => mapping(uint256 => uint256)) internal balances;
616 
617   // Operator Functions
618   mapping (address => mapping(address => bool)) internal operators;
619 
620   // Events
621   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
622   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
623   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
624   event URI(string _uri, uint256 indexed _id);
625 
626 
627   /***********************************|
628   |     Public Transfer Functions     |
629   |__________________________________*/
630 
631   /**
632    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
633    * @param _from    Source address
634    * @param _to      Target address
635    * @param _id      ID of the token type
636    * @param _amount  Transfered amount
637    * @param _data    Additional data with no specified format, sent in call to `_to`
638    */
639   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
640     public
641   {
642     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeTransferFrom: INVALID_OPERATOR");
643     require(_to != address(0),"ERC1155#safeTransferFrom: INVALID_RECIPIENT");
644     // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
645 
646     _safeTransferFrom(_from, _to, _id, _amount);
647     _callonERC1155Received(_from, _to, _id, _amount, _data);
648   }
649 
650   /**
651    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
652    * @param _from     Source addresses
653    * @param _to       Target addresses
654    * @param _ids      IDs of each token type
655    * @param _amounts  Transfer amounts per token type
656    * @param _data     Additional data with no specified format, sent in call to `_to`
657    */
658   function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
659     public
660   {
661     // Requirements
662     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR");
663     require(_to != address(0), "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT");
664 
665     _safeBatchTransferFrom(_from, _to, _ids, _amounts);
666     _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
667   }
668 
669 
670   /***********************************|
671   |    Internal Transfer Functions    |
672   |__________________________________*/
673 
674   /**
675    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
676    * @param _from    Source address
677    * @param _to      Target address
678    * @param _id      ID of the token type
679    * @param _amount  Transfered amount
680    */
681   function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount)
682     internal
683   {
684     // Update balances
685     balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
686     balances[_to][_id] = balances[_to][_id].add(_amount);     // Add amount
687 
688     // Emit event
689     emit TransferSingle(msg.sender, _from, _to, _id, _amount);
690   }
691 
692   /**
693    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
694    */
695   function _callonERC1155Received(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
696     internal
697   {
698     // Check if recipient is contract
699     if (_to.isContract()) {
700       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _amount, _data);
701       require(retval == ERC1155_RECEIVED_VALUE, "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");
702     }
703   }
704 
705   /**
706    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
707    * @param _from     Source addresses
708    * @param _to       Target addresses
709    * @param _ids      IDs of each token type
710    * @param _amounts  Transfer amounts per token type
711    */
712   function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts)
713     internal
714   {
715     require(_ids.length == _amounts.length, "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH");
716 
717     // Number of transfer to execute
718     uint256 nTransfer = _ids.length;
719 
720     // Executing all transfers
721     for (uint256 i = 0; i < nTransfer; i++) {
722       // Update storage balance of previous bin
723       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
724       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
725     }
726 
727     // Emit event
728     emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
729   }
730 
731   /**
732    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
733    */
734   function _callonERC1155BatchReceived(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
735     internal
736   {
737     // Pass data if recipient is contract
738     if (_to.isContract()) {
739       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _amounts, _data);
740       require(retval == ERC1155_BATCH_RECEIVED_VALUE, "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE");
741     }
742   }
743 
744 
745   /***********************************|
746   |         Operator Functions        |
747   |__________________________________*/
748 
749   /**
750    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
751    * @param _operator  Address to add to the set of authorized operators
752    * @param _approved  True if the operator is approved, false to revoke approval
753    */
754   function setApprovalForAll(address _operator, bool _approved)
755     external
756   {
757     // Update operator status
758     operators[msg.sender][_operator] = _approved;
759     emit ApprovalForAll(msg.sender, _operator, _approved);
760   }
761 
762   /**
763    * @notice Queries the approval status of an operator for a given owner
764    * @param _owner     The owner of the Tokens
765    * @param _operator  Address of authorized operator
766    */
767   function isApprovedForAll(address _owner, address _operator)
768     virtual public view returns (bool isOperator)
769   {
770     return operators[_owner][_operator];
771   }
772 
773 
774   /***********************************|
775   |         Balance Functions         |
776   |__________________________________*/
777 
778   /**
779    * @notice Get the balance of an account's Tokens
780    * @param _owner  The address of the token holder
781    * @param _id     ID of the Token
782    * @return The _owner's balance of the Token type requested
783    */
784   function balanceOf(address _owner, uint256 _id)
785     public view returns (uint256)
786   {
787     return balances[_owner][_id];
788   }
789 
790   /**
791    * @notice Get the balance of multiple account/token pairs
792    * @param _owners The addresses of the token holders
793    * @param _ids    ID of the Tokens
794    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
795    */
796   function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
797     public view returns (uint256[] memory)
798   {
799     require(_owners.length == _ids.length, "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH");
800 
801     // Variables
802     uint256[] memory batchBalances = new uint256[](_owners.length);
803 
804     // Iterate over each owner and token ID
805     for (uint256 i = 0; i < _owners.length; i++) {
806       batchBalances[i] = balances[_owners[i]][_ids[i]];
807     }
808 
809     return batchBalances;
810   }
811 
812 
813   /***********************************|
814   |          ERC165 Functions         |
815   |__________________________________*/
816 
817   bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
818 
819   bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
820 
821   /**
822    * @notice Query if a contract implements an interface
823    * @param _interfaceID  The interface identifier, as specified in ERC-165
824    * @return `true` if the contract implements `_interfaceID` and
825    */
826   function supportsInterface(bytes4 _interfaceID) override external view returns (bool) {
827     if (_interfaceID == INTERFACE_SIGNATURE_ERC165 ||
828         _interfaceID == INTERFACE_SIGNATURE_ERC1155) {
829       return true;
830     }
831     return false;
832   }
833 
834 }
835 
836 /**
837  * @notice Contract that handles metadata related methods.
838  * @dev Methods assume a deterministic generation of URI based on token IDs.
839  *      Methods also assume that URI uses hex representation of token IDs.
840  */
841 contract ERC1155Metadata {
842 
843   // URI's default URI prefix
844   string internal baseMetadataURI;
845   event URI(string _uri, uint256 indexed _id);
846 
847 
848   /***********************************|
849   |     Metadata Public Function s    |
850   |__________________________________*/
851 
852   /**
853    * @notice A distinct Uniform Resource Identifier (URI) for a given token.
854    * @dev URIs are defined in RFC 3986.
855    *      URIs are assumed to be deterministically generated based on token ID
856    *      Token IDs are assumed to be represented in their hex format in URIs
857    * @return URI string
858    */
859   function uri(uint256 _id) virtual public view returns (string memory) {
860     return string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
861   }
862 
863 
864   /***********************************|
865   |    Metadata Internal Functions    |
866   |__________________________________*/
867 
868   /**
869    * @notice Will emit default URI log event for corresponding token _id
870    * @param _tokenIDs Array of IDs of tokens to log default URI
871    */
872   function _logURIs(uint256[] memory _tokenIDs) internal {
873     string memory baseURL = baseMetadataURI;
874     string memory tokenURI;
875 
876     for (uint256 i = 0; i < _tokenIDs.length; i++) {
877       tokenURI = string(abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json"));
878       emit URI(tokenURI, _tokenIDs[i]);
879     }
880   }
881 
882   /**
883    * @notice Will emit a specific URI log event for corresponding token
884    * @param _tokenIDs IDs of the token corresponding to the _uris logged
885    * @param _URIs    The URIs of the specified _tokenIDs
886    */
887   function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs) internal {
888     require(_tokenIDs.length == _URIs.length, "ERC1155Metadata#_logURIs: INVALID_ARRAYS_LENGTH");
889     for (uint256 i = 0; i < _tokenIDs.length; i++) {
890       emit URI(_URIs[i], _tokenIDs[i]);
891     }
892   }
893 
894   /**
895    * @notice Will update the base URL of token's URI
896    * @param _newBaseMetadataURI New base URL of token's URI
897    */
898   function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
899     baseMetadataURI = _newBaseMetadataURI;
900   }
901 
902 
903   /***********************************|
904   |    Utility Internal Functions     |
905   |__________________________________*/
906 
907   /**
908    * @notice Convert uint256 to string
909    * @param _i Unsigned integer to convert to string
910    */
911   function _uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
912     if (_i == 0) {
913       return "0";
914     }
915 
916     uint256 j = _i;
917     uint256 ii = _i;
918     uint256 len;
919 
920     // Get number of bytes
921     while (j != 0) {
922       len++;
923       j /= 10;
924     }
925 
926     bytes memory bstr = new bytes(len);
927     uint256 k = len - 1;
928 
929     // Get each individual ASCII
930     while (ii != 0) {
931       bstr[k--] = byte(uint8(48 + ii % 10));
932       ii /= 10;
933     }
934 
935     // Convert to string
936     return string(bstr);
937   }
938 
939 }
940 
941 /**
942  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
943  *      a parent contract to be executed as they are `internal` functions
944  */
945 contract ERC1155MintBurn is ERC1155 {
946 
947 
948   /****************************************|
949   |            Minting Functions           |
950   |_______________________________________*/
951 
952   /**
953    * @notice Mint _amount of tokens of a given id
954    * @param _to      The address to mint tokens to
955    * @param _id      Token id to mint
956    * @param _amount  The amount to be minted
957    * @param _data    Data to pass if receiver is contract
958    */
959   function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)
960     internal
961   {
962     // Add _amount
963     balances[_to][_id] = balances[_to][_id].add(_amount);
964 
965     // Emit event
966     emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
967 
968     // Calling onReceive method if recipient is contract
969     _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
970   }
971 
972   /**
973    * @notice Mint tokens for each ids in _ids
974    * @param _to       The address to mint tokens to
975    * @param _ids      Array of ids to mint
976    * @param _amounts  Array of amount of tokens to mint per id
977    * @param _data    Data to pass if receiver is contract
978    */
979   function _batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
980     internal
981   {
982     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH");
983 
984     // Number of mints to execute
985     uint256 nMint = _ids.length;
986 
987      // Executing all minting
988     for (uint256 i = 0; i < nMint; i++) {
989       // Update storage balance
990       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
991     }
992 
993     // Emit batch mint event
994     emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
995 
996     // Calling onReceive method if recipient is contract
997     _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
998   }
999 
1000 
1001   /****************************************|
1002   |            Burning Functions           |
1003   |_______________________________________*/
1004 
1005   /**
1006    * @notice Burn _amount of tokens of a given token id
1007    * @param _from    The address to burn tokens from
1008    * @param _id      Token id to burn
1009    * @param _amount  The amount to be burned
1010    */
1011   function _burn(address _from, uint256 _id, uint256 _amount)
1012     internal
1013   {
1014     //Substract _amount
1015     balances[_from][_id] = balances[_from][_id].sub(_amount);
1016 
1017     // Emit event
1018     emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
1019   }
1020 
1021   /**
1022    * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
1023    * @param _from     The address to burn tokens from
1024    * @param _ids      Array of token ids to burn
1025    * @param _amounts  Array of the amount to be burned
1026    */
1027   function _batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts)
1028     internal
1029   {
1030     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH");
1031 
1032     // Number of mints to execute
1033     uint256 nBurn = _ids.length;
1034 
1035      // Executing all minting
1036     for (uint256 i = 0; i < nBurn; i++) {
1037       // Update storage balance
1038       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
1039     }
1040 
1041     // Emit batch mint event
1042     emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
1043   }
1044 
1045 }
1046 
1047 library Strings {
1048 	// via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1049 	function strConcat(
1050 		string memory _a,
1051 		string memory _b,
1052 		string memory _c,
1053 		string memory _d,
1054 		string memory _e
1055 	) internal pure returns (string memory) {
1056 		bytes memory _ba = bytes(_a);
1057 		bytes memory _bb = bytes(_b);
1058 		bytes memory _bc = bytes(_c);
1059 		bytes memory _bd = bytes(_d);
1060 		bytes memory _be = bytes(_e);
1061 		string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1062 		bytes memory babcde = bytes(abcde);
1063 		uint256 k = 0;
1064 		for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1065 		for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1066 		for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1067 		for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1068 		for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1069 		return string(babcde);
1070 	}
1071 
1072 	function strConcat(
1073 		string memory _a,
1074 		string memory _b,
1075 		string memory _c,
1076 		string memory _d
1077 	) internal pure returns (string memory) {
1078 		return strConcat(_a, _b, _c, _d, "");
1079 	}
1080 
1081 	function strConcat(
1082 		string memory _a,
1083 		string memory _b,
1084 		string memory _c
1085 	) internal pure returns (string memory) {
1086 		return strConcat(_a, _b, _c, "", "");
1087 	}
1088 
1089 	function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
1090 		return strConcat(_a, _b, "", "", "");
1091 	}
1092 
1093 	function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
1094 		if (_i == 0) {
1095 			return "0";
1096 		}
1097 		uint256 j = _i;
1098 		uint256 len;
1099 		while (j != 0) {
1100 			len++;
1101 			j /= 10;
1102 		}
1103 		bytes memory bstr = new bytes(len);
1104 		uint256 k = len - 1;
1105 		while (_i != 0) {
1106 			bstr[k--] = bytes1(uint8(48 + (_i % 10)));
1107 			_i /= 10;
1108 		}
1109 		return string(bstr);
1110 	}
1111 }
1112 
1113 contract OwnableDelegateProxy {}
1114 
1115 contract ProxyRegistry {
1116 	mapping(address => OwnableDelegateProxy) public proxies;
1117 }
1118 
1119 /**
1120  * @title ERC1155Tradable
1121  * ERC1155Tradable - ERC1155 contract that whitelists an operator address, 
1122  * has create and mint functionality, and supports useful standards from OpenZeppelin,
1123   like _exists(), name(), symbol(), and totalSupply()
1124  */
1125 contract ERC1155Tradable is ERC1155, ERC1155MintBurn, ERC1155Metadata, Ownable, MinterRole, WhitelistAdminRole {
1126 	using Strings for string;
1127 
1128 	address proxyRegistryAddress;
1129 	uint256 private _currentTokenID = 0;
1130 	mapping(uint256 => address) public creators;
1131 	mapping(uint256 => uint256) public tokenSupply;
1132 	mapping(uint256 => uint256) public tokenMaxSupply;
1133 	// Contract name
1134 	string public name;
1135 	// Contract symbol
1136 	string public symbol;
1137 
1138 	constructor(
1139 		string memory _name,
1140 		string memory _symbol,
1141 		address _proxyRegistryAddress
1142 	) public {
1143 		name = _name;
1144 		symbol = _symbol;
1145 		proxyRegistryAddress = _proxyRegistryAddress;
1146 	}
1147 
1148 	function removeWhitelistAdmin(address account) public onlyOwner {
1149 		_removeWhitelistAdmin(account);
1150 	}
1151 
1152 	function removeMinter(address account) public onlyOwner {
1153 		_removeMinter(account);
1154 	}
1155 
1156 	function uri(uint256 _id) override public view returns (string memory) {
1157 		require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1158 		return Strings.strConcat(baseMetadataURI, Strings.uint2str(_id));
1159 	}
1160 
1161 	/**
1162 	 * @dev Returns the total quantity for a token ID
1163 	 * @param _id uint256 ID of the token to query
1164 	 * @return amount of token in existence
1165 	 */
1166 	function totalSupply(uint256 _id) public view returns (uint256) {
1167 		return tokenSupply[_id];
1168 	}
1169 
1170 	/**
1171 	 * @dev Returns the max quantity for a token ID
1172 	 * @param _id uint256 ID of the token to query
1173 	 * @return amount of token in existence
1174 	 */
1175 	function maxSupply(uint256 _id) public view returns (uint256) {
1176 		return tokenMaxSupply[_id];
1177 	}
1178 
1179 	/**
1180 	 * @dev Will update the base URL of token's URI
1181 	 * @param _newBaseMetadataURI New base URL of token's URI
1182 	 */
1183 	function setBaseMetadataURI(string memory _newBaseMetadataURI) public onlyWhitelistAdmin {
1184 		_setBaseMetadataURI(_newBaseMetadataURI);
1185 	}
1186 
1187 	/**
1188 	 * @dev Creates a new token type and assigns _initialSupply to an address
1189 	 * @param _maxSupply max supply allowed
1190 	 * @param _initialSupply Optional amount to supply the first owner
1191 	 * @param _uri Optional URI for this token type
1192 	 * @param _data Optional data to pass if receiver is contract
1193 	 */
1194 	function create(
1195 		uint256 _maxSupply,
1196 		uint256 _initialSupply,
1197 		string calldata _uri,
1198 		bytes calldata _data
1199 	) external onlyWhitelistAdmin returns (uint256 tokenId) {
1200 		require(_initialSupply <= _maxSupply, "Initial supply cannot be more than max supply");
1201 		uint256 _id = _getNextTokenID();
1202 		_incrementTokenTypeId();
1203 		creators[_id] = msg.sender;
1204 
1205 		if (bytes(_uri).length > 0) {
1206 			emit URI(_uri, _id);
1207 		}
1208 
1209 		if (_initialSupply != 0) _mint(msg.sender, _id, _initialSupply, _data);
1210 		tokenSupply[_id] = _initialSupply;
1211 		tokenMaxSupply[_id] = _maxSupply;
1212 		return _id;
1213 	}
1214 
1215 	/**
1216 	 * @dev Mints some amount of tokens to an address
1217 	 * @param _to          Address of the future owner of the token
1218 	 * @param _id          Token ID to mint
1219 	 * @param _quantity    Amount of tokens to mint
1220 	 * @param _data        Data to pass if receiver is contract
1221 	 */
1222 	function mint(
1223 		address _to,
1224 		uint256 _id,
1225 		uint256 _quantity,
1226 		bytes memory _data
1227 	) public onlyMinter {
1228 		uint256 tokenId = _id;
1229 		require(tokenSupply[tokenId] < tokenMaxSupply[tokenId], "Max supply reached");
1230 		_mint(_to, _id, _quantity, _data);
1231 		tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1232 	}
1233 
1234 	/**
1235 	 * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
1236 	 */
1237 	function isApprovedForAll(address _owner, address _operator) override public view returns (bool isOperator) {
1238 		// Whitelist OpenSea proxy contract for easy trading.
1239 		ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1240 		if (address(proxyRegistry.proxies(_owner)) == _operator) {
1241 			return true;
1242 		}
1243 
1244 		return ERC1155.isApprovedForAll(_owner, _operator);
1245 	}
1246 
1247 	/**
1248 	 * @dev Returns whether the specified token exists by checking to see if it has a creator
1249 	 * @param _id uint256 ID of the token to query the existence of
1250 	 * @return bool whether the token exists
1251 	 */
1252 	function _exists(uint256 _id) internal view returns (bool) {
1253 		return creators[_id] != address(0);
1254 	}
1255 
1256 	/**
1257 	 * @dev calculates the next token ID based on value of _currentTokenID
1258 	 * @return uint256 for the next token ID
1259 	 */
1260 	function _getNextTokenID() private view returns (uint256) {
1261 		return _currentTokenID.add(1);
1262 	}
1263 
1264 	/**
1265 	 * @dev increments the value of _currentTokenID
1266 	 */
1267 	function _incrementTokenTypeId() private {
1268 		_currentTokenID++;
1269 	}
1270 }
1271 
1272 contract TokenWrapper {
1273 	using SafeMath for uint256;
1274 	IERC20 public token;
1275 
1276 	constructor(IERC20 _erc20Address) public {
1277 		token = IERC20(_erc20Address);
1278 	}
1279 
1280 	uint256 private _totalSupply;
1281 	mapping(address => uint256) private _balances;
1282 
1283 	function totalSupply() public view returns (uint256) {
1284 		return _totalSupply;
1285 	}
1286 
1287 	function balanceOf(address account) public view returns (uint256) {
1288 		return _balances[account];
1289 	}
1290 
1291 	function stake(uint256 amount) virtual public {
1292 		_totalSupply = _totalSupply.add(amount);
1293 		_balances[msg.sender] = _balances[msg.sender].add(amount);
1294 		token.transferFrom(msg.sender, address(this), amount);
1295 	}
1296 
1297 	function withdraw(uint256 amount) virtual public {
1298 		_totalSupply = _totalSupply.sub(amount);
1299 		_balances[msg.sender] = _balances[msg.sender].sub(amount);
1300 		token.transfer(msg.sender, amount);
1301 	}
1302 }
1303 
1304 interface IDarkMatterOriginsStory {
1305   function unlockCard(address _account, uint256 _id) external;
1306 }
1307 
1308 contract DarkMatterCollectibleFarm is TokenWrapper, Ownable {
1309 	ERC1155Tradable public dmc;
1310   IDarkMatterOriginsStory public story;
1311 
1312 	mapping(address => uint256) public lastUpdateTime;
1313 	mapping(address => uint256) public points;
1314 	mapping(uint256 => uint256) public cards;
1315 
1316 	event CardAdded(uint256 card, uint256 points);
1317 	event Staked(address indexed user, uint256 amount);
1318 	event Withdrawn(address indexed user, uint256 amount);
1319 	event Redeemed(address indexed user, uint256 amount);
1320 
1321 	modifier updateReward(address account) {
1322 		if (account != address(0)) {
1323 			points[account] = earned(account);
1324 			lastUpdateTime[account] = block.timestamp;
1325 		}
1326 		_;
1327 	}
1328 
1329 	constructor(ERC1155Tradable _dmcAddress, IERC20 _erc20Address) public TokenWrapper(_erc20Address) {
1330 		dmc = _dmcAddress;
1331 	}
1332 
1333   function setStory(IDarkMatterOriginsStory _story) public onlyOwner {
1334     story = _story;
1335   }
1336 
1337 	function addCard(uint256 cardId, uint256 amount) public onlyOwner {
1338 		cards[cardId] = amount;
1339 		emit CardAdded(cardId, amount);
1340 	}
1341 
1342 	function earned(address account) public view returns (uint256) {
1343 		uint256 blockTime = block.timestamp;
1344 		return
1345 			points[account].add(
1346 				blockTime.sub(lastUpdateTime[account]).mul(1e18).div(86400).mul(
1347 					(balanceOf(account)).div(1e18)
1348 				)
1349 			);
1350 	}
1351 
1352 	// stake visibility is public as overriding TokenWrapper's stake() function
1353 	function stake(uint256 amount) override public updateReward(msg.sender) {
1354 		super.stake(amount);
1355 		emit Staked(msg.sender, amount);
1356 	}
1357 
1358 	function withdraw(uint256 amount) override public updateReward(msg.sender) {
1359 		require(amount > 0, "Cannot withdraw 0");
1360 
1361 		super.withdraw(amount);
1362 		emit Withdrawn(msg.sender, amount);
1363 	}
1364 
1365 	function exit() external {
1366 		withdraw(balanceOf(msg.sender));
1367 	}
1368 
1369 	function redeem(uint256 card) public updateReward(msg.sender) {
1370 		require(cards[card] != 0, "Card not found");
1371 		require(points[msg.sender] >= cards[card], "Not enough points to redeem for card");
1372 		require(dmc.totalSupply(card) < dmc.maxSupply(card), "Max cards minted");
1373         if (card < 8) {
1374           story.unlockCard(msg.sender, card);
1375         }
1376 
1377 		points[msg.sender] = points[msg.sender].sub(cards[card]);
1378 		dmc.mint(msg.sender, card, 1, "");
1379 		emit Redeemed(msg.sender, cards[card]);
1380 	}
1381 }