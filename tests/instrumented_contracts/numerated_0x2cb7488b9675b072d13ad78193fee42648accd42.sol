1 pragma solidity ^0.5.17;
2 
3 contract CloneFactory {
4 
5   function createClone(address target) internal returns (address result) {
6     bytes20 targetBytes = bytes20(target);
7     assembly {
8       let clone := mload(0x40)
9       mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
10       mstore(add(clone, 0x14), targetBytes)
11       mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
12       result := create(0, clone, 0x37)
13     }
14   }
15 }
16 
17 /**
18  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
19  * the optional functions; to access them see {ERC20Detailed}.
20  */
21 interface IERC20 {
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `recipient`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address recipient, uint256 amount) external returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `sender` to `recipient` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Emitted when `value` tokens are moved from one account (`from`) to
79      * another (`to`).
80      *
81      * Note that `value` may be zero.
82      */
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     /**
86      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
87      * a call to {approve}. `value` is the new allowance.
88      */
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 
93 /**
94  * @title SafeERC20
95  * @dev Wrappers around ERC20 operations that throw on failure (when the token
96  * contract returns false). Tokens that return no value (and instead revert or
97  * throw on failure) are also supported, non-reverting calls are assumed to be
98  * successful.
99  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
100  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
101  */
102 library SafeERC20 {
103     using SafeMath for uint256;
104     using Address for address;
105 
106     function safeTransfer(IERC20 token, address to, uint256 value) internal {
107         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
108     }
109 
110     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
111         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
112     }
113 
114     /**
115      * @dev Deprecated. This function has issues similar to the ones found in
116      * {IERC20-approve}, and its usage is discouraged.
117      *
118      * Whenever possible, use {safeIncreaseAllowance} and
119      * {safeDecreaseAllowance} instead.
120      */
121     function safeApprove(IERC20 token, address spender, uint256 value) internal {
122         // safeApprove should only be called when setting an initial allowance,
123         // or when resetting it to zero. To increase and decrease it, use
124         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
125         // solhint-disable-next-line max-line-length
126         require((value == 0) || (token.allowance(address(this), spender) == 0),
127             "SafeERC20: approve from non-zero to non-zero allowance"
128         );
129         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
130     }
131 
132     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
133         uint256 newAllowance = token.allowance(address(this), spender).add(value);
134         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
135     }
136 
137     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
138         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
139         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
140     }
141 
142     /**
143      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
144      * on the return value: the return value is optional (but if data is returned, it must not be false).
145      * @param token The token targeted by the call.
146      * @param data The call data (encoded using abi.encode or one of its variants).
147      */
148     function _callOptionalReturn(IERC20 token, bytes memory data) private {
149         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
150         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
151         // the target address contains contract code and also asserts for success in the low-level call.
152 
153         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
154         if (returndata.length > 0) { // Return data is optional
155             // solhint-disable-next-line max-line-length
156             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
157         }
158     }
159 }
160 
161 
162 /*
163  * @dev Provides information about the current execution context, including the
164  * sender of the transaction and its data. While these are generally available
165  * via msg.sender and msg.data, they should not be accessed in such a direct
166  * manner, since when dealing with GSN meta-transactions the account sending and
167  * paying for execution may not be the actual sender (as far as an application
168  * is concerned).
169  *
170  * This contract is only required for intermediate, library-like contracts.
171  */
172 contract Context {
173     // Empty internal constructor, to prevent people from mistakenly deploying
174     // an instance of this contract, which should be used via inheritance.
175     constructor () internal { }
176     // solhint-disable-previous-line no-empty-blocks
177 
178     function _msgSender() internal view returns (address payable) {
179         return msg.sender;
180     }
181 
182     function _msgData() internal view returns (bytes memory) {
183         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
184         return msg.data;
185     }
186 }
187 
188 /**
189  * @dev Contract module which provides a basic access control mechanism, where
190  * there is an account (an owner) that can be granted exclusive access to
191  * specific functions.
192  *
193  * This module is used through inheritance. It will make available the modifier
194  * `onlyOwner`, which can be applied to your functions to restrict their use to
195  * the owner.
196  */
197 contract Ownable is Context {
198     address private _owner;
199 
200     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
201 
202     /**
203      * @dev Initializes the contract setting the deployer as the initial owner.
204      */
205     constructor () internal {
206         address msgSender = _msgSender();
207         _owner = msgSender;
208         emit OwnershipTransferred(address(0), msgSender);
209     }
210     
211     function initOwnable() internal{
212         address msgSender = _msgSender();
213         _owner = msgSender;
214         emit OwnershipTransferred(address(0), msgSender);
215     }
216 
217     /**
218      * @dev Returns the address of the current owner.
219      */
220     function owner() public view returns (address) {
221         return _owner;
222     }
223 
224     /**
225      * @dev Throws if called by any account other than the owner.
226      */
227     modifier onlyOwner() {
228         require(isOwner(), "Ownable: caller is not the owner");
229         _;
230     }
231 
232     /**
233      * @dev Returns true if the caller is the current owner.
234      */
235     function isOwner() public view returns (bool) {
236         return _msgSender() == _owner;
237     }
238 
239     /**
240      * @dev Leaves the contract without owner. It will not be possible to call
241      * `onlyOwner` functions anymore. Can only be called by the current owner.
242      *
243      * NOTE: Renouncing ownership will leave the contract without an owner,
244      * thereby removing any functionality that is only available to the owner.
245      */
246     function renounceOwnership() public onlyOwner {
247         emit OwnershipTransferred(_owner, address(0));
248         _owner = address(0);
249     }
250 
251     /**
252      * @dev Transfers ownership of the contract to a new account (`newOwner`).
253      * Can only be called by the current owner.
254      */
255     function transferOwnership(address newOwner) public onlyOwner {
256         _transferOwnership(newOwner);
257     }
258 
259     /**
260      * @dev Transfers ownership of the contract to a new account (`newOwner`).
261      */
262     function _transferOwnership(address newOwner) internal {
263         require(newOwner != address(0), "Ownable: new owner is the zero address");
264         emit OwnershipTransferred(_owner, newOwner);
265         _owner = newOwner;
266     }
267 }
268 
269 /**
270  * @title Roles
271  * @dev Library for managing addresses assigned to a Role.
272  */
273 library Roles {
274     struct Role {
275         mapping (address => bool) bearer;
276     }
277 
278     /**
279      * @dev Give an account access to this role.
280      */
281     function add(Role storage role, address account) internal {
282         require(!has(role, account), "Roles: account already has role");
283         role.bearer[account] = true;
284     }
285 
286     /**
287      * @dev Remove an account's access to this role.
288      */
289     function remove(Role storage role, address account) internal {
290         require(has(role, account), "Roles: account does not have role");
291         role.bearer[account] = false;
292     }
293 
294     /**
295      * @dev Check if an account has this role.
296      * @return bool
297      */
298     function has(Role storage role, address account) internal view returns (bool) {
299         require(account != address(0), "Roles: account is the zero address");
300         return role.bearer[account];
301     }
302 }
303 
304 contract MinterRole is Context {
305     using Roles for Roles.Role;
306 
307     event MinterAdded(address indexed account);
308     event MinterRemoved(address indexed account);
309 
310     Roles.Role private _minters;
311 
312     function initMinter() internal{
313         _addMinter(_msgSender());
314     }
315 
316     constructor () internal {
317         _addMinter(_msgSender());
318     }
319 
320     modifier onlyMinter() {
321         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
322         _;
323     }
324 
325     function isMinter(address account) public view returns (bool) {
326         return _minters.has(account);
327     }
328 
329     function addMinter(address account) public onlyMinter {
330         _addMinter(account);
331     }
332 
333     function renounceMinter() public {
334         _removeMinter(_msgSender());
335     }
336 
337     function _addMinter(address account) internal {
338         _minters.add(account);
339         emit MinterAdded(account);
340     }
341 
342     function _removeMinter(address account) internal {
343         _minters.remove(account);
344         emit MinterRemoved(account);
345     }
346 }
347 
348 /**
349  * @title WhitelistAdminRole
350  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
351  */
352 contract WhitelistAdminRole is Context {
353     using Roles for Roles.Role;
354 
355     event WhitelistAdminAdded(address indexed account);
356     event WhitelistAdminRemoved(address indexed account);
357 
358     Roles.Role private _whitelistAdmins;
359 
360     function initWhiteListAdmin() internal{
361         _addWhitelistAdmin(_msgSender());
362     }
363 
364     constructor () internal {
365         _addWhitelistAdmin(_msgSender());
366     }
367 
368     modifier onlyWhitelistAdmin() {
369         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
370         _;
371     }
372 
373     function isWhitelistAdmin(address account) public view returns (bool) {
374         return _whitelistAdmins.has(account);
375     }
376 
377     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
378         _addWhitelistAdmin(account);
379     }
380 
381     function renounceWhitelistAdmin() public {
382         _removeWhitelistAdmin(_msgSender());
383     }
384 
385     function _addWhitelistAdmin(address account) internal {
386         _whitelistAdmins.add(account);
387         emit WhitelistAdminAdded(account);
388     }
389 
390     function _removeWhitelistAdmin(address account) internal {
391         _whitelistAdmins.remove(account);
392         emit WhitelistAdminRemoved(account);
393     }
394 }
395 
396 /**
397  * @title ERC165
398  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
399  */
400 interface IERC165 {
401 
402     /**
403      * @notice Query if a contract implements an interface
404      * @dev Interface identification is specified in ERC-165. This function
405      * uses less than 30,000 gas
406      * @param _interfaceId The interface identifier, as specified in ERC-165
407      */
408     function supportsInterface(bytes4 _interfaceId)
409     external
410     view
411     returns (bool);
412 }
413 
414 /**
415  * @title SafeMath
416  * @dev Unsigned math operations with safety checks that revert on error
417  */
418 library SafeMath {
419 
420   /**
421    * @dev Multiplies two unsigned integers, reverts on overflow.
422    */
423   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
424     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
425     // benefit is lost if 'b' is also tested.
426     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
427     if (a == 0) {
428       return 0;
429     }
430 
431     uint256 c = a * b;
432     require(c / a == b, "SafeMath#mul: OVERFLOW");
433 
434     return c;
435   }
436 
437   /**
438    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
439    */
440   function div(uint256 a, uint256 b) internal pure returns (uint256) {
441     // Solidity only automatically asserts when dividing by 0
442     require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
443     uint256 c = a / b;
444     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
445 
446     return c;
447   }
448 
449   /**
450    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
451    */
452   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
453     require(b <= a, "SafeMath#sub: UNDERFLOW");
454     uint256 c = a - b;
455 
456     return c;
457   }
458 
459   /**
460    * @dev Adds two unsigned integers, reverts on overflow.
461    */
462   function add(uint256 a, uint256 b) internal pure returns (uint256) {
463     uint256 c = a + b;
464     require(c >= a, "SafeMath#add: OVERFLOW");
465 
466     return c; 
467   }
468 
469   /**
470    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
471    * reverts when dividing by zero.
472    */
473   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
474     require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
475     return a % b;
476   }
477 
478 }
479 
480 /**
481  * @dev ERC-1155 interface for accepting safe transfers.
482  */
483 interface IERC1155TokenReceiver {
484 
485   /**
486    * @notice Handle the receipt of a single ERC1155 token type
487    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
488    * This function MAY throw to revert and reject the transfer
489    * Return of other amount than the magic value MUST result in the transaction being reverted
490    * Note: The token contract address is always the message sender
491    * @param _operator  The address which called the `safeTransferFrom` function
492    * @param _from      The address which previously owned the token
493    * @param _id        The id of the token being transferred
494    * @param _amount    The amount of tokens being transferred
495    * @param _data      Additional data with no specified format
496    * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
497    */
498   function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4);
499 
500   /**
501    * @notice Handle the receipt of multiple ERC1155 token types
502    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
503    * This function MAY throw to revert and reject the transfer
504    * Return of other amount than the magic value WILL result in the transaction being reverted
505    * Note: The token contract address is always the message sender
506    * @param _operator  The address which called the `safeBatchTransferFrom` function
507    * @param _from      The address which previously owned the token
508    * @param _ids       An array containing ids of each token being transferred
509    * @param _amounts   An array containing amounts of each token being transferred
510    * @param _data      Additional data with no specified format
511    * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
512    */
513   function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4);
514 
515   /**
516    * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
517    * @param  interfaceID The ERC-165 interface ID that is queried for support.s
518    * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
519    *      This function MUST NOT consume more than 5,000 gas.
520    * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
521    */
522   function supportsInterface(bytes4 interfaceID) external view returns (bool);
523 
524 }
525 
526 interface IERC1155 {
527   // Events
528 
529   /**
530    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
531    *   Operator MUST be msg.sender
532    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
533    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
534    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
535    *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
536    */
537   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
538 
539   /**
540    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
541    *   Operator MUST be msg.sender
542    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
543    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
544    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
545    *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
546    */
547   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
548 
549   /**
550    * @dev MUST emit when an approval is updated
551    */
552   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
553 
554   /**
555    * @dev MUST emit when the URI is updated for a token ID
556    *   URIs are defined in RFC 3986
557    *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
558    */
559   event URI(string _amount, uint256 indexed _id);
560 
561   /**
562    * @notice Transfers amount of an _id from the _from address to the _to address specified
563    * @dev MUST emit TransferSingle event on success
564    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
565    * MUST throw if `_to` is the zero address
566    * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
567    * MUST throw on any other error
568    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
569    * @param _from    Source address
570    * @param _to      Target address
571    * @param _id      ID of the token type
572    * @param _amount  Transfered amount
573    * @param _data    Additional data with no specified format, sent in call to `_to`
574    */
575   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
576 
577   /**
578    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
579    * @dev MUST emit TransferBatch event on success
580    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
581    * MUST throw if `_to` is the zero address
582    * MUST throw if length of `_ids` is not the same as length of `_amounts`
583    * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
584    * MUST throw on any other error
585    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
586    * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
587    * @param _from     Source addresses
588    * @param _to       Target addresses
589    * @param _ids      IDs of each token type
590    * @param _amounts  Transfer amounts per token type
591    * @param _data     Additional data with no specified format, sent in call to `_to`
592   */
593   function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
594   
595   /**
596    * @notice Get the balance of an account's Tokens
597    * @param _owner  The address of the token holder
598    * @param _id     ID of the Token
599    * @return        The _owner's balance of the Token type requested
600    */
601   function balanceOf(address _owner, uint256 _id) external view returns (uint256);
602 
603   /**
604    * @notice Get the balance of multiple account/token pairs
605    * @param _owners The addresses of the token holders
606    * @param _ids    ID of the Tokens
607    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
608    */
609   function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
610 
611   /**
612    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
613    * @dev MUST emit the ApprovalForAll event on success
614    * @param _operator  Address to add to the set of authorized operators
615    * @param _approved  True if the operator is approved, false to revoke approval
616    */
617   function setApprovalForAll(address _operator, bool _approved) external;
618 
619   /**
620    * @notice Queries the approval status of an operator for a given owner
621    * @param _owner     The owner of the Tokens
622    * @param _operator  Address of authorized operator
623    * @return           True if the operator is approved, false if not
624    */
625   function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
626 
627 }
628 
629 library Address {
630     /**
631      * @dev Returns true if `account` is a contract.
632      *
633      * [IMPORTANT]
634      * ====
635      * It is unsafe to assume that an address for which this function returns
636      * false is an externally-owned account (EOA) and not a contract.
637      *
638      * Among others, `isContract` will return false for the following
639      * types of addresses:
640      *
641      *  - an externally-owned account
642      *  - a contract in construction
643      *  - an address where a contract will be created
644      *  - an address where a contract lived, but was destroyed
645      * ====
646      */
647     function isContract(address account) internal view returns (bool) {
648         // This method relies on extcodesize, which returns 0 for contracts in
649         // construction, since the code is only stored at the end of the
650         // constructor execution.
651 
652         uint256 size;
653         // solhint-disable-next-line no-inline-assembly
654         assembly { size := extcodesize(account) }
655         return size > 0;
656     }
657 
658     /**
659      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
660      * `recipient`, forwarding all available gas and reverting on errors.
661      *
662      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
663      * of certain opcodes, possibly making contracts go over the 2300 gas limit
664      * imposed by `transfer`, making them unable to receive funds via
665      * `transfer`. {sendValue} removes this limitation.
666      *
667      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
668      *
669      * IMPORTANT: because control is transferred to `recipient`, care must be
670      * taken to not create reentrancy vulnerabilities. Consider using
671      * {ReentrancyGuard} or the
672      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
673      */
674     function sendValue(address payable recipient, uint256 amount) internal {
675         require(address(this).balance >= amount, "Address: insufficient balance");
676 
677         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
678         (bool success, ) = recipient.call.value(amount)("");
679         require(success, "Address: unable to send value, recipient may have reverted");
680     }
681 
682     /**
683      * @dev Performs a Solidity function call using a low level `call`. A
684      * plain`call` is an unsafe replacement for a function call: use this
685      * function instead.
686      *
687      * If `target` reverts with a revert reason, it is bubbled up by this
688      * function (like regular Solidity function calls).
689      *
690      * Returns the raw returned data. To convert to the expected return value,
691      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
692      *
693      * Requirements:
694      *
695      * - `target` must be a contract.
696      * - calling `target` with `data` must not revert.
697      *
698      * _Available since v3.1._
699      */
700     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
701       return functionCall(target, data, "Address: low-level call failed");
702     }
703 
704     /**
705      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
706      * `errorMessage` as a fallback revert reason when `target` reverts.
707      *
708      * _Available since v3.1._
709      */
710     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
711         return functionCallWithValue(target, data, 0, errorMessage);
712     }
713 
714     /**
715      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
716      * but also transferring `value` wei to `target`.
717      *
718      * Requirements:
719      *
720      * - the calling contract must have an ETH balance of at least `value`.
721      * - the called Solidity function must be `payable`.
722      *
723      * _Available since v3.1._
724      */
725     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
726         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
727     }
728 
729     /**
730      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
731      * with `errorMessage` as a fallback revert reason when `target` reverts.
732      *
733      * _Available since v3.1._
734      */
735     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
736         require(address(this).balance >= value, "Address: insufficient balance for call");
737         require(isContract(target), "Address: call to non-contract");
738 
739         // solhint-disable-next-line avoid-low-level-calls
740         (bool success, bytes memory returndata) = target.call.value(value)(data);
741         return _verifyCallResult(success, returndata, errorMessage);
742     }
743 
744     /**
745      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
746      * but performing a static call.
747      *
748      * _Available since v3.3._
749      */
750     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
751         return functionStaticCall(target, data, "Address: low-level static call failed");
752     }
753 
754     /**
755      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
756      * but performing a static call.
757      *
758      * _Available since v3.3._
759      */
760     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
761         require(isContract(target), "Address: static call to non-contract");
762 
763         // solhint-disable-next-line avoid-low-level-calls
764         (bool success, bytes memory returndata) = target.staticcall(data);
765         return _verifyCallResult(success, returndata, errorMessage);
766     }
767 
768     /**
769      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
770      * but performing a delegate call.
771      *
772      * _Available since v3.3._
773      */
774     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
775         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
776     }
777 
778     /**
779      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
780      * but performing a delegate call.
781      *
782      * _Available since v3.3._
783      */
784     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
785         require(isContract(target), "Address: delegate call to non-contract");
786 
787         // solhint-disable-next-line avoid-low-level-calls
788         (bool success, bytes memory returndata) = target.delegatecall(data);
789         return _verifyCallResult(success, returndata, errorMessage);
790     }
791 
792     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
793         if (success) {
794             return returndata;
795         } else {
796             // Look for revert reason and bubble it up if present
797             if (returndata.length > 0) {
798                 // The easiest way to bubble the revert reason is using memory via assembly
799 
800                 // solhint-disable-next-line no-inline-assembly
801                 assembly {
802                     let returndata_size := mload(returndata)
803                     revert(add(32, returndata), returndata_size)
804                 }
805             } else {
806                 revert(errorMessage);
807             }
808         }
809     }
810 }
811 
812 /**
813  * @dev Implementation of Multi-Token Standard contract
814  */
815 contract ERC1155 is IERC165 {
816   using SafeMath for uint256;
817   using Address for address;
818 
819 
820   /***********************************|
821   |        Variables and Events       |
822   |__________________________________*/
823 
824   // onReceive function signatures
825   bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;
826   bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
827 
828   // Objects balances
829   mapping (address => mapping(uint256 => uint256)) internal balances;
830 
831   // Operator Functions
832   mapping (address => mapping(address => bool)) internal operators;
833 
834   // Events
835   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
836   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
837   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
838   event URI(string _uri, uint256 indexed _id);
839 
840 
841   /***********************************|
842   |     Public Transfer Functions     |
843   |__________________________________*/
844 
845   /**
846    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
847    * @param _from    Source address
848    * @param _to      Target address
849    * @param _id      ID of the token type
850    * @param _amount  Transfered amount
851    * @param _data    Additional data with no specified format, sent in call to `_to`
852    */
853   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
854     public
855   {
856     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeTransferFrom: INVALID_OPERATOR");
857     require(_to != address(0),"ERC1155#safeTransferFrom: INVALID_RECIPIENT");
858     // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
859 
860     _safeTransferFrom(_from, _to, _id, _amount);
861     _callonERC1155Received(_from, _to, _id, _amount, _data);
862   }
863 
864   /**
865    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
866    * @param _from     Source addresses
867    * @param _to       Target addresses
868    * @param _ids      IDs of each token type
869    * @param _amounts  Transfer amounts per token type
870    * @param _data     Additional data with no specified format, sent in call to `_to`
871    */
872   function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
873     public
874   {
875     // Requirements
876     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR");
877     require(_to != address(0), "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT");
878 
879     _safeBatchTransferFrom(_from, _to, _ids, _amounts);
880     _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
881   }
882 
883 
884   /***********************************|
885   |    Internal Transfer Functions    |
886   |__________________________________*/
887 
888   /**
889    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
890    * @param _from    Source address
891    * @param _to      Target address
892    * @param _id      ID of the token type
893    * @param _amount  Transfered amount
894    */
895   function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount)
896     internal
897   {
898     // Update balances
899     balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
900     balances[_to][_id] = balances[_to][_id].add(_amount);     // Add amount
901 
902     // Emit event
903     emit TransferSingle(msg.sender, _from, _to, _id, _amount);
904   }
905 
906   /**
907    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
908    */
909   function _callonERC1155Received(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
910     internal
911   {
912     // Check if recipient is contract
913     if (_to.isContract()) {
914       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _amount, _data);
915       require(retval == ERC1155_RECEIVED_VALUE, "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");
916     }
917   }
918 
919   /**
920    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
921    * @param _from     Source addresses
922    * @param _to       Target addresses
923    * @param _ids      IDs of each token type
924    * @param _amounts  Transfer amounts per token type
925    */
926   function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts)
927     internal
928   {
929     require(_ids.length == _amounts.length, "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH");
930 
931     // Number of transfer to execute
932     uint256 nTransfer = _ids.length;
933 
934     // Executing all transfers
935     for (uint256 i = 0; i < nTransfer; i++) {
936       // Update storage balance of previous bin
937       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
938       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
939     }
940 
941     // Emit event
942     emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
943   }
944 
945   /**
946    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
947    */
948   function _callonERC1155BatchReceived(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
949     internal
950   {
951     // Pass data if recipient is contract
952     if (_to.isContract()) {
953       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _amounts, _data);
954       require(retval == ERC1155_BATCH_RECEIVED_VALUE, "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE");
955     }
956   }
957 
958 
959   /***********************************|
960   |         Operator Functions        |
961   |__________________________________*/
962 
963   /**
964    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
965    * @param _operator  Address to add to the set of authorized operators
966    * @param _approved  True if the operator is approved, false to revoke approval
967    */
968   function setApprovalForAll(address _operator, bool _approved)
969     external
970   {
971     // Update operator status
972     operators[msg.sender][_operator] = _approved;
973     emit ApprovalForAll(msg.sender, _operator, _approved);
974   }
975 
976   /**
977    * @notice Queries the approval status of an operator for a given owner
978    * @param _owner     The owner of the Tokens
979    * @param _operator  Address of authorized operator
980    * @return True if the operator is approved, false if not
981    */
982   function isApprovedForAll(address _owner, address _operator)
983     public view returns (bool isOperator)
984   {
985     return operators[_owner][_operator];
986   }
987 
988 
989   /***********************************|
990   |         Balance Functions         |
991   |__________________________________*/
992 
993   /**
994    * @notice Get the balance of an account's Tokens
995    * @param _owner  The address of the token holder
996    * @param _id     ID of the Token
997    * @return The _owner's balance of the Token type requested
998    */
999   function balanceOf(address _owner, uint256 _id)
1000     public view returns (uint256)
1001   {
1002     return balances[_owner][_id];
1003   }
1004 
1005   /**
1006    * @notice Get the balance of multiple account/token pairs
1007    * @param _owners The addresses of the token holders
1008    * @param _ids    ID of the Tokens
1009    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
1010    */
1011   function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
1012     public view returns (uint256[] memory)
1013   {
1014     require(_owners.length == _ids.length, "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH");
1015 
1016     // Variables
1017     uint256[] memory batchBalances = new uint256[](_owners.length);
1018 
1019     // Iterate over each owner and token ID
1020     for (uint256 i = 0; i < _owners.length; i++) {
1021       batchBalances[i] = balances[_owners[i]][_ids[i]];
1022     }
1023 
1024     return batchBalances;
1025   }
1026 
1027 
1028   /***********************************|
1029   |          ERC165 Functions         |
1030   |__________________________________*/
1031 
1032   /**
1033    * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
1034    */
1035   bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
1036 
1037   /**
1038    * INTERFACE_SIGNATURE_ERC1155 =
1039    * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
1040    * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
1041    * bytes4(keccak256("balanceOf(address,uint256)")) ^
1042    * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
1043    * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
1044    * bytes4(keccak256("isApprovedForAll(address,address)"));
1045    */
1046   bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
1047 
1048   /**
1049    * @notice Query if a contract implements an interface
1050    * @param _interfaceID  The interface identifier, as specified in ERC-165
1051    * @return `true` if the contract implements `_interfaceID` and
1052    */
1053   function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
1054     if (_interfaceID == INTERFACE_SIGNATURE_ERC165 ||
1055         _interfaceID == INTERFACE_SIGNATURE_ERC1155) {
1056       return true;
1057     }
1058     return false;
1059   }
1060 
1061 }
1062 
1063 /**
1064  * @notice Contract that handles metadata related methods.
1065  * @dev Methods assume a deterministic generation of URI based on token IDs.
1066  *      Methods also assume that URI uses hex representation of token IDs.
1067  */
1068 contract ERC1155Metadata {
1069 
1070   // URI's default URI prefix
1071   string internal baseMetadataURI;
1072   event URI(string _uri, uint256 indexed _id);
1073 
1074 
1075   /***********************************|
1076   |     Metadata Public Function s    |
1077   |__________________________________*/
1078 
1079   /**
1080    * @notice A distinct Uniform Resource Identifier (URI) for a given token.
1081    * @dev URIs are defined in RFC 3986.
1082    *      URIs are assumed to be deterministically generated based on token ID
1083    *      Token IDs are assumed to be represented in their hex format in URIs
1084    * @return URI string
1085    */
1086   function uri(uint256 _id) public view returns (string memory) {
1087     return string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
1088   }
1089 
1090 
1091   /***********************************|
1092   |    Metadata Internal Functions    |
1093   |__________________________________*/
1094 
1095   /**
1096    * @notice Will emit default URI log event for corresponding token _id
1097    * @param _tokenIDs Array of IDs of tokens to log default URI
1098    */
1099   function _logURIs(uint256[] memory _tokenIDs) internal {
1100     string memory baseURL = baseMetadataURI;
1101     string memory tokenURI;
1102 
1103     for (uint256 i = 0; i < _tokenIDs.length; i++) {
1104       tokenURI = string(abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json"));
1105       emit URI(tokenURI, _tokenIDs[i]);
1106     }
1107   }
1108 
1109   /**
1110    * @notice Will emit a specific URI log event for corresponding token
1111    * @param _tokenIDs IDs of the token corresponding to the _uris logged
1112    * @param _URIs    The URIs of the specified _tokenIDs
1113    */
1114   function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs) internal {
1115     require(_tokenIDs.length == _URIs.length, "ERC1155Metadata#_logURIs: INVALID_ARRAYS_LENGTH");
1116     for (uint256 i = 0; i < _tokenIDs.length; i++) {
1117       emit URI(_URIs[i], _tokenIDs[i]);
1118     }
1119   }
1120 
1121   /**
1122    * @notice Will update the base URL of token's URI
1123    * @param _newBaseMetadataURI New base URL of token's URI
1124    */
1125   function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
1126     baseMetadataURI = _newBaseMetadataURI;
1127   }
1128 
1129 
1130   /***********************************|
1131   |    Utility Internal Functions     |
1132   |__________________________________*/
1133 
1134   /**
1135    * @notice Convert uint256 to string
1136    * @param _i Unsigned integer to convert to string
1137    */
1138   function _uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
1139     if (_i == 0) {
1140       return "0";
1141     }
1142 
1143     uint256 j = _i;
1144     uint256 ii = _i;
1145     uint256 len;
1146 
1147     // Get number of bytes
1148     while (j != 0) {
1149       len++;
1150       j /= 10;
1151     }
1152 
1153     bytes memory bstr = new bytes(len);
1154     uint256 k = len - 1;
1155 
1156     // Get each individual ASCII
1157     while (ii != 0) {
1158       bstr[k--] = byte(uint8(48 + ii % 10));
1159       ii /= 10;
1160     }
1161 
1162     // Convert to string
1163     return string(bstr);
1164   }
1165 
1166 }
1167 
1168 /**
1169  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
1170  *      a parent contract to be executed as they are `internal` functions
1171  */
1172 contract ERC1155MintBurn is ERC1155 {
1173 
1174 
1175   /****************************************|
1176   |            Minting Functions           |
1177   |_______________________________________*/
1178 
1179   /**
1180    * @notice Mint _amount of tokens of a given id
1181    * @param _to      The address to mint tokens to
1182    * @param _id      Token id to mint
1183    * @param _amount  The amount to be minted
1184    * @param _data    Data to pass if receiver is contract
1185    */
1186   function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)
1187     internal
1188   {
1189     // Add _amount
1190     balances[_to][_id] = balances[_to][_id].add(_amount);
1191 
1192     // Emit event
1193     emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
1194 
1195     // Calling onReceive method if recipient is contract
1196     _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
1197   }
1198 
1199   /**
1200    * @notice Mint tokens for each ids in _ids
1201    * @param _to       The address to mint tokens to
1202    * @param _ids      Array of ids to mint
1203    * @param _amounts  Array of amount of tokens to mint per id
1204    * @param _data    Data to pass if receiver is contract
1205    */
1206   function _batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
1207     internal
1208   {
1209     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH");
1210 
1211     // Number of mints to execute
1212     uint256 nMint = _ids.length;
1213 
1214      // Executing all minting
1215     for (uint256 i = 0; i < nMint; i++) {
1216       // Update storage balance
1217       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
1218     }
1219 
1220     // Emit batch mint event
1221     emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
1222 
1223     // Calling onReceive method if recipient is contract
1224     _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
1225   }
1226 
1227 
1228   /****************************************|
1229   |            Burning Functions           |
1230   |_______________________________________*/
1231 
1232   /**
1233    * @notice Burn _amount of tokens of a given token id
1234    * @param _from    The address to burn tokens from
1235    * @param _id      Token id to burn
1236    * @param _amount  The amount to be burned
1237    */
1238   function _burn(address _from, uint256 _id, uint256 _amount)
1239     internal
1240   {
1241     //Substract _amount
1242     balances[_from][_id] = balances[_from][_id].sub(_amount);
1243 
1244     // Emit event
1245     emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
1246   }
1247 
1248   /**
1249    * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
1250    * @param _from     The address to burn tokens from
1251    * @param _ids      Array of token ids to burn
1252    * @param _amounts  Array of the amount to be burned
1253    */
1254   function _batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts)
1255     internal
1256   {
1257     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH");
1258 
1259     // Number of mints to execute
1260     uint256 nBurn = _ids.length;
1261 
1262      // Executing all minting
1263     for (uint256 i = 0; i < nBurn; i++) {
1264       // Update storage balance
1265       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
1266     }
1267 
1268     // Emit batch mint event
1269     emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
1270   }
1271 
1272 }
1273 
1274 library Strings {
1275 	// via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1276 	function strConcat(
1277 		string memory _a,
1278 		string memory _b,
1279 		string memory _c,
1280 		string memory _d,
1281 		string memory _e
1282 	) internal pure returns (string memory) {
1283 		bytes memory _ba = bytes(_a);
1284 		bytes memory _bb = bytes(_b);
1285 		bytes memory _bc = bytes(_c);
1286 		bytes memory _bd = bytes(_d);
1287 		bytes memory _be = bytes(_e);
1288 		string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1289 		bytes memory babcde = bytes(abcde);
1290 		uint256 k = 0;
1291 		for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1292 		for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1293 		for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1294 		for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1295 		for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1296 		return string(babcde);
1297 	}
1298 
1299 	function strConcat(
1300 		string memory _a,
1301 		string memory _b,
1302 		string memory _c,
1303 		string memory _d
1304 	) internal pure returns (string memory) {
1305 		return strConcat(_a, _b, _c, _d, "");
1306 	}
1307 
1308 	function strConcat(
1309 		string memory _a,
1310 		string memory _b,
1311 		string memory _c
1312 	) internal pure returns (string memory) {
1313 		return strConcat(_a, _b, _c, "", "");
1314 	}
1315 
1316 	function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
1317 		return strConcat(_a, _b, "", "", "");
1318 	}
1319 
1320 	function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
1321 		if (_i == 0) {
1322 			return "0";
1323 		}
1324 		uint256 j = _i;
1325 		uint256 len;
1326 		while (j != 0) {
1327 			len++;
1328 			j /= 10;
1329 		}
1330 		bytes memory bstr = new bytes(len);
1331 		uint256 k = len - 1;
1332 		while (_i != 0) {
1333 			bstr[k--] = bytes1(uint8(48 + (_i % 10)));
1334 			_i /= 10;
1335 		}
1336 		return string(bstr);
1337 	}
1338 }
1339 
1340 contract OwnableDelegateProxy {}
1341 
1342 contract ProxyRegistry {
1343 	mapping(address => OwnableDelegateProxy) public proxies;
1344 }
1345 
1346 /**
1347  * @title ERC1155Tradable
1348  * ERC1155Tradable - ERC1155 contract that whitelists an operator address, 
1349  * has create and mint functionality, and supports useful standards from OpenZeppelin,
1350   like _exists(), name(), symbol(), and totalSupply()
1351  */
1352 contract ERC1155Tradable is ERC1155, ERC1155MintBurn, ERC1155Metadata, Ownable, MinterRole, WhitelistAdminRole {
1353 	using Strings for string;
1354 
1355 	address proxyRegistryAddress;
1356 	uint256 private _currentTokenID = 0;
1357 	mapping(uint256 => address) public creators;
1358 	mapping(uint256 => uint256) public tokenSupply;
1359 	mapping(uint256 => uint256) public tokenMaxSupply;
1360 	// Contract name
1361 	string public name;
1362 	// Contract symbol
1363 	string public symbol;
1364 
1365     mapping(uint256 => string) private uris;
1366 
1367     bool private constructed = false;
1368 
1369     function init(
1370 		string memory _name,
1371 		string memory _symbol,
1372 		address _proxyRegistryAddress
1373 	) public {
1374 	    
1375 	    require(!constructed, "ERC155 Tradeable must not be constructed yet");
1376 	    
1377 	    constructed = true;
1378 	    
1379 		name = _name;
1380 		symbol = _symbol;
1381 		proxyRegistryAddress = _proxyRegistryAddress;
1382 		
1383 		super.initOwnable();
1384 		super.initMinter();
1385 		super.initWhiteListAdmin();
1386 	}
1387 
1388 	constructor(
1389 		string memory _name,
1390 		string memory _symbol,
1391 		address _proxyRegistryAddress
1392 	) public {
1393 	    constructed = true;
1394 		name = _name;
1395 		symbol = _symbol;
1396 		proxyRegistryAddress = _proxyRegistryAddress;
1397 	}
1398 
1399 	function removeWhitelistAdmin(address account) public onlyOwner {
1400 		_removeWhitelistAdmin(account);
1401 	}
1402 
1403 	function removeMinter(address account) public onlyOwner {
1404 		_removeMinter(account);
1405 	}
1406 
1407 	function uri(uint256 _id) public view returns (string memory) {
1408 		require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1409 		//return super.uri(_id);
1410 		
1411 		if(bytes(uris[_id]).length > 0){
1412 		    return uris[_id];
1413 		}
1414 		return Strings.strConcat(baseMetadataURI, Strings.uint2str(_id));
1415 	}
1416 
1417 	/**
1418 	 * @dev Returns the total quantity for a token ID
1419 	 * @param _id uint256 ID of the token to query
1420 	 * @return amount of token in existence
1421 	 */
1422 	function totalSupply(uint256 _id) public view returns (uint256) {
1423 		return tokenSupply[_id];
1424 	}
1425 
1426 	/**
1427 	 * @dev Returns the max quantity for a token ID
1428 	 * @param _id uint256 ID of the token to query
1429 	 * @return amount of token in existence
1430 	 */
1431 	function maxSupply(uint256 _id) public view returns (uint256) {
1432 		return tokenMaxSupply[_id];
1433 	}
1434 
1435 	/**
1436 	 * @dev Will update the base URL of token's URI
1437 	 * @param _newBaseMetadataURI New base URL of token's URI
1438 	 */
1439 	function setBaseMetadataURI(string memory _newBaseMetadataURI) public onlyWhitelistAdmin {
1440 		_setBaseMetadataURI(_newBaseMetadataURI);
1441 	}
1442 
1443 	/**
1444 	 * @dev Creates a new token type and assigns _initialSupply to an address
1445 	 * @param _maxSupply max supply allowed
1446 	 * @param _initialSupply Optional amount to supply the first owner
1447 	 * @param _uri Optional URI for this token type
1448 	 * @param _data Optional data to pass if receiver is contract
1449 	 * @return The newly created token ID
1450 	 */
1451 	function create(
1452 		uint256 _maxSupply,
1453 		uint256 _initialSupply,
1454 		string calldata _uri,
1455 		bytes calldata _data
1456 	) external onlyWhitelistAdmin returns (uint256 tokenId) {
1457 		require(_initialSupply <= _maxSupply, "Initial supply cannot be more than max supply");
1458 		uint256 _id = _getNextTokenID();
1459 		_incrementTokenTypeId();
1460 		creators[_id] = msg.sender;
1461 
1462 		if (bytes(_uri).length > 0) {
1463 		    uris[_id] = _uri;
1464 			emit URI(_uri, _id);
1465 		}
1466 		else{
1467 		    emit URI(string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json")), _id);
1468 		}
1469 
1470 		if (_initialSupply != 0) _mint(msg.sender, _id, _initialSupply, _data);
1471 		tokenSupply[_id] = _initialSupply;
1472 		tokenMaxSupply[_id] = _maxSupply;
1473 		return _id;
1474 	}
1475 	
1476 	function updateUri(uint256 _id, string calldata _uri) external onlyWhitelistAdmin{
1477 	    if (bytes(_uri).length > 0) {
1478 		    uris[_id] = _uri;
1479 			emit URI(_uri, _id);
1480 		}
1481 		else{
1482 		    emit URI(string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json")), _id);
1483 		}
1484 	}
1485 	
1486 	function burn(address _address, uint256 _id, uint256 _amount) external {
1487 	    require((msg.sender == _address) || isApprovedForAll(_address, msg.sender), "ERC1155#burn: INVALID_OPERATOR");
1488 	    require(balances[_address][_id] >= _amount, "Trying to burn more tokens than you own");
1489 	    _burn(_address, _id, _amount);
1490 	}
1491 	
1492 	function updateProxyRegistryAddress(address _proxyRegistryAddress) external onlyWhitelistAdmin{
1493 	    require(_proxyRegistryAddress != address(0), "No zero address");
1494 	    proxyRegistryAddress = _proxyRegistryAddress;
1495 	}
1496 
1497 	/**
1498 	 * @dev Mints some amount of tokens to an address
1499 	 * @param _id          Token ID to mint
1500 	 * @param _quantity    Amount of tokens to mint
1501 	 * @param _data        Data to pass if receiver is contract
1502 	 */
1503 	function mint(
1504 		uint256 _id,
1505 		uint256 _quantity,
1506 		bytes memory _data
1507 	) public onlyMinter {
1508 		uint256 tokenId = _id;
1509 		require(tokenSupply[tokenId].add(_quantity) <= tokenMaxSupply[tokenId], "Max supply reached");
1510 		_mint(msg.sender, _id, _quantity, _data);
1511 		tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1512 	}
1513 
1514 	/**
1515 	 * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
1516 	 */
1517 	function isApprovedForAll(address _owner, address _operator) public view returns (bool isOperator) {
1518 		// Whitelist OpenSea proxy contract for easy trading.
1519 		ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1520 		if (address(proxyRegistry.proxies(_owner)) == _operator) {
1521 			return true;
1522 		}
1523 
1524 		return ERC1155.isApprovedForAll(_owner, _operator);
1525 	}
1526 
1527 	/**
1528 	 * @dev Returns whether the specified token exists by checking to see if it has a creator
1529 	 * @param _id uint256 ID of the token to query the existence of
1530 	 * @return bool whether the token exists
1531 	 */
1532 	function _exists(uint256 _id) internal view returns (bool) {
1533 		return creators[_id] != address(0);
1534 	}
1535 
1536 	/**
1537 	 * @dev calculates the next token ID based on value of _currentTokenID
1538 	 * @return uint256 for the next token ID
1539 	 */
1540 	function _getNextTokenID() private view returns (uint256) {
1541 		return _currentTokenID.add(1);
1542 	}
1543 
1544 	/**
1545 	 * @dev increments the value of _currentTokenID
1546 	 */
1547 	function _incrementTokenTypeId() private {
1548 		_currentTokenID++;
1549 	}
1550 }
1551 
1552 /**
1553  * @title Unifty
1554  * Unifty - NFT Tools
1555  * 
1556  * Rinkeby Opensea: 0xf57b2c51ded3a29e6891aba85459d600256cf317 
1557  * Mainnet Opensea: 0xa5409ec958c83c3f309868babaca7c86dcb077c1
1558  */
1559 contract Unifty is ERC1155Tradable {
1560     
1561     string private _contractURI = "https://unifty.io/meta/contract.json";
1562     
1563 	constructor(address _proxyRegistryAddress) public ERC1155Tradable("Unifty", "UNIF", _proxyRegistryAddress) {
1564 		_setBaseMetadataURI("https://unifty.io/meta/");
1565 	}
1566 
1567 	function contractURI() public view returns (string memory) {
1568 		return _contractURI;
1569 	}
1570 	
1571 	function setContractURI(string memory _uri) public onlyWhitelistAdmin{
1572 	    _contractURI = _uri;
1573 	}
1574 	
1575 	function version() external pure returns (uint256) {
1576 		return 1;
1577 	}
1578 	
1579 }
1580 
1581 
1582 contract PauserRole is Context {
1583     using Roles for Roles.Role;
1584 
1585     event PauserAdded(address indexed account);
1586     event PauserRemoved(address indexed account);
1587 
1588     Roles.Role private _pausers;
1589 
1590     function initPauserRole() internal{
1591         _addPauser(_msgSender());
1592     }
1593 
1594     constructor () internal {
1595         _addPauser(_msgSender());
1596     }
1597 
1598     modifier onlyPauser() {
1599         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
1600         _;
1601     }
1602 
1603     function isPauser(address account) public view returns (bool) {
1604         return _pausers.has(account);
1605     }
1606 
1607     function addPauser(address account) public onlyPauser {
1608         _addPauser(account);
1609     }
1610 
1611     function renouncePauser() public {
1612         _removePauser(_msgSender());
1613     }
1614 
1615     function _addPauser(address account) internal {
1616         _pausers.add(account);
1617         emit PauserAdded(account);
1618     }
1619 
1620     function _removePauser(address account) internal {
1621         _pausers.remove(account);
1622         emit PauserRemoved(account);
1623     }
1624 }
1625 
1626 contract Pausable is Context, PauserRole {
1627 
1628     event Paused(address account);
1629     event Unpaused(address account);
1630     bool private _paused;
1631 
1632     constructor () internal {
1633         _paused = false;
1634     }
1635 
1636     function paused() public view returns (bool) {
1637         return _paused;
1638     }
1639 
1640     modifier whenNotPaused() {
1641         require(!_paused, "Pausable: paused");
1642         _;
1643     }
1644 
1645     modifier whenPaused() {
1646         require(_paused, "Pausable: not paused");
1647         _;
1648     }
1649 
1650     function pause() public onlyPauser whenNotPaused {
1651         _paused = true;
1652         emit Paused(_msgSender());
1653     }
1654 
1655     function unpause() public onlyPauser whenPaused {
1656         _paused = false;
1657         emit Unpaused(_msgSender());
1658     }
1659 }
1660 
1661 contract Wrap {
1662 	using SafeMath for uint256;
1663 	using SafeERC20 for IERC20;
1664 	IERC20 public token;
1665 
1666 	constructor(IERC20 _tokenAddress) public {
1667 		token = IERC20(_tokenAddress);
1668 	}
1669 
1670 	uint256 private _totalSupply;
1671 	mapping(address => uint256) private _balances;
1672 
1673 	function totalSupply() external view returns (uint256) {
1674 		return _totalSupply;
1675 	}
1676 
1677 	function balanceOf(address account) public view returns (uint256) {
1678 		return _balances[account];
1679 	}
1680 
1681 	function stake(uint256 amount) public {
1682 		_totalSupply = _totalSupply.add(amount);
1683 		_balances[msg.sender] = _balances[msg.sender].add(amount);
1684 		IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
1685 	}
1686 
1687 	function withdraw(uint256 amount) public {
1688 		_totalSupply = _totalSupply.sub(amount);
1689 		_balances[msg.sender] = _balances[msg.sender].sub(amount);
1690 		IERC20(token).safeTransfer(msg.sender, amount);
1691 	}
1692 
1693 	function _rescueScore(address account) internal {
1694 		uint256 amount = _balances[account];
1695 
1696 		_totalSupply = _totalSupply.sub(amount);
1697 		_balances[account] = _balances[account].sub(amount);
1698 		IERC20(token).safeTransfer(account, amount);
1699 	}
1700 }
1701 
1702 interface DetailedERC20 {
1703     
1704     function name() external view returns (string memory);
1705     function symbol() external view returns (string memory);
1706     function decimals() external view returns (uint8);
1707     function totalSupply() external view returns (uint256);
1708 }
1709 
1710 contract UniftyFarm is Wrap, Ownable, Pausable, CloneFactory, WhitelistAdminRole {
1711 	using SafeMath for uint256;
1712 
1713 	struct Card {
1714 		uint256 points;
1715 		uint256 releaseTime;
1716 		uint256 mintFee;
1717 		uint256 controllerFee;
1718 		address artist;
1719 		address erc1155;
1720 		bool nsfw;
1721 		bool shadowed;
1722 		uint256 supply;
1723 	}
1724 	
1725 	address payable public feeAddress = address(0x2989018B83436C6bBa00144A8277fd859cdafA7D);
1726     uint256 public farmFee = 50000000000000000;
1727     uint256 public farmFeeMinimumNif = 5000 * 10**18;
1728     uint256[] public wildcards;
1729     ERC1155Tradable public wildcardErc1155Address;
1730 	bool public isCloned = false;
1731     mapping(address => address[]) public farms;
1732     bool public constructed = false;
1733     
1734     bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;
1735     bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
1736     bytes4 constant internal ERC1155_RECEIVED_ERR_VALUE = 0x0;
1737     
1738 	uint256 public periodStart;
1739 	uint256 public minStake;
1740 	uint256 public maxStake;
1741 	uint256 public rewardRate = 86400; // 1 point per day per staked token, multiples of this lowers time per staked token
1742 	uint256 public totalFeesCollected;
1743 	uint256 public spentScore;
1744 	address public rescuer;
1745 	address public controller;
1746 
1747 	mapping(address => uint256) public pendingWithdrawals;
1748 	mapping(address => uint256) public lastUpdateTime;
1749 	mapping(address => uint256) public points;
1750 	mapping(address => mapping ( uint256 => Card ) ) public cards;
1751 
1752 	event CardAdded(address indexed erc1155, uint256 indexed card, uint256 points, uint256 mintFee, address indexed artist, uint256 releaseTime);
1753 	event CardType(address indexed erc1155, uint256 indexed card, string indexed cardType);
1754 	event CardShadowed(address indexed erc1155, uint256 indexed card, bool indexed shadowed);
1755 	event Removed(address indexed erc1155, uint256 indexed card, address indexed recipient, uint256 amount);
1756 	event Staked(address indexed user, uint256 amount);
1757 	event Withdrawn(address indexed user, uint256 amount);
1758 	event Redeemed(address indexed user, address indexed erc1155, uint256 indexed id, uint256 amount);
1759 	event RescueRedeemed(address indexed user, uint256 amount);
1760 	event FarmCreated(address indexed user, address indexed farm, uint256 fee, string uri);
1761 	event FarmUri(address indexed farm, string uri);
1762 
1763 	modifier updateReward(address account) {
1764 		if (account != address(0)) {
1765 			points[account] = earned(account);
1766 			lastUpdateTime[account] = block.timestamp;
1767 		}
1768 		_;
1769 	}
1770 
1771 	constructor(
1772 		uint256 _periodStart,
1773 		uint256 _minStake,
1774 		uint256 _maxStake,
1775 		address _controller,
1776 		IERC20 _tokenAddress,
1777 		string memory _uri
1778 	) public Wrap(_tokenAddress) {
1779 	    require(_minStake >= 0 && _maxStake > 0 && _maxStake >= _minStake, "Problem with min and max stake setup");
1780 	    constructed = true;
1781 		periodStart = _periodStart;
1782 		minStake = _minStake;
1783 		maxStake = _maxStake;
1784 		controller = _controller;
1785 		emit FarmCreated(msg.sender, address(this), 0, _uri);
1786 	    emit FarmUri(address(this), _uri);
1787 	}
1788 
1789 	function cardMintFee(address erc1155Address, uint256 id) external view returns (uint256) {
1790 		return cards[erc1155Address][id].mintFee.add(cards[erc1155Address][id].controllerFee);
1791 	}
1792 
1793 	function cardReleaseTime(address erc1155Address, uint256 id) external view returns (uint256) {
1794 		return cards[erc1155Address][id].releaseTime;
1795 	}
1796 
1797 	function cardPoints(address erc1155Address, uint256 id) external view returns (uint256) {
1798 		return cards[erc1155Address][id].points;
1799 	}
1800 
1801 	function earned(address account) public view returns (uint256) {
1802 		
1803 		uint256 decimals = DetailedERC20(address(token)).decimals();
1804 		uint256 pow = 1;
1805 
1806         for(uint256 i = 0; i < decimals; i++){
1807             pow = pow.mul(10);
1808         }
1809 		
1810 		return points[account].add(
1811 		    getCurrPoints(account, pow)
1812 	    );
1813 	}
1814 	
1815 	function getCurrPoints(address account, uint256 pow) internal view returns(uint256){
1816 	    uint256 blockTime = block.timestamp;
1817 	    return blockTime.sub(lastUpdateTime[account]).mul(pow).div(rewardRate).mul(balanceOf(account)).div(pow);
1818 	}
1819 	
1820 	function setRewardRate(uint256 _rewardRate) external onlyWhitelistAdmin{
1821 	    require(_rewardRate > 0, "Reward rate too low");
1822 	    rewardRate = _rewardRate;
1823 	}
1824 	
1825 	function setMinMaxStake(uint256 _minStake, uint256 _maxStake) external onlyWhitelistAdmin{
1826 	    require(_minStake >= 0 && _maxStake > 0 && _maxStake >= _minStake, "Problem with min and max stake setup");
1827 	    minStake = _minStake;
1828 	    maxStake = _maxStake;
1829 	}
1830 	
1831 	function stake(uint256 amount) public updateReward(msg.sender) whenNotPaused() {
1832 		require(block.timestamp >= periodStart, "Pool not open");
1833 		require(amount.add(balanceOf(msg.sender)) >= minStake && amount.add(balanceOf(msg.sender)) > 0, "Too few deposit");
1834 		require(amount.add(balanceOf(msg.sender)) <= maxStake, "Deposit limit reached");
1835 
1836 		super.stake(amount);
1837 		emit Staked(msg.sender, amount);
1838 	}
1839 
1840 	function withdraw(uint256 amount) public updateReward(msg.sender) {
1841 		require(amount > 0, "Cannot withdraw 0");
1842 
1843 		super.withdraw(amount);
1844 		emit Withdrawn(msg.sender, amount);
1845 	}
1846 
1847 	function exit() external {
1848 		withdraw(balanceOf(msg.sender));
1849 	}
1850 
1851 	function redeem(address erc1155Address, uint256 id) external payable updateReward(msg.sender) {
1852 		require(cards[erc1155Address][id].points != 0, "Card not found");
1853 		require(block.timestamp >= cards[erc1155Address][id].releaseTime, "Card not released");
1854 		require(points[msg.sender] >= cards[erc1155Address][id].points, "Redemption exceeds point balance");
1855 		
1856 		uint256 fees = cards[erc1155Address][id].mintFee.add( cards[erc1155Address][id].controllerFee );
1857 		
1858         // wildcards and nif passes disabled in clones
1859         bool enableFees = fees > 0;
1860         
1861         if(!isCloned){
1862             uint256 nifBalance = IERC20(address(0x7e291890B01E5181f7ecC98D79ffBe12Ad23df9e)).balanceOf(msg.sender);
1863             if(nifBalance >= farmFeeMinimumNif || iHaveAnyWildcard()){
1864                 enableFees = false;
1865                 fees = 0;
1866             }
1867         }
1868         
1869         require(msg.value == fees, "Send the proper ETH for the fees");
1870 
1871 		if (enableFees) {
1872 			totalFeesCollected = totalFeesCollected.add(fees);
1873 			pendingWithdrawals[controller] = pendingWithdrawals[controller].add( cards[erc1155Address][id].controllerFee );
1874 			pendingWithdrawals[cards[erc1155Address][id].artist] = pendingWithdrawals[cards[erc1155Address][id].artist].add( cards[erc1155Address][id].mintFee );
1875 		}
1876 
1877 		points[msg.sender] = points[msg.sender].sub(cards[erc1155Address][id].points);
1878 		spentScore = spentScore.add(cards[erc1155Address][id].points);
1879 		
1880 		ERC1155Tradable(cards[erc1155Address][id].erc1155).safeTransferFrom(address(this), msg.sender, id, 1, "");
1881 		
1882 		emit Redeemed(msg.sender, cards[erc1155Address][id].erc1155, id, cards[erc1155Address][id].points);
1883 	}
1884 
1885 	function rescueScore(address account) external updateReward(account) returns (uint256) {
1886 		require(msg.sender == rescuer, "!rescuer");
1887 		uint256 earnedPoints = points[account];
1888 		spentScore = spentScore.add(earnedPoints);
1889 		points[account] = 0;
1890 
1891 		if (balanceOf(account) > 0) {
1892 			_rescueScore(account);
1893 		}
1894 
1895 		emit RescueRedeemed(account, earnedPoints);
1896 		return earnedPoints;
1897 	}
1898 
1899 	function setController(address _controller) external onlyWhitelistAdmin {
1900 		uint256 amount = pendingWithdrawals[controller];
1901 		pendingWithdrawals[controller] = 0;
1902 		pendingWithdrawals[_controller] = pendingWithdrawals[_controller].add(amount);
1903 		controller = _controller;
1904 	}
1905 
1906 	function setRescuer(address _rescuer) external onlyWhitelistAdmin {
1907 		rescuer = _rescuer;
1908 	}
1909 
1910 	function setControllerFee(address _erc1155Address, uint256 _id, uint256 _controllerFee) external onlyWhitelistAdmin {
1911 		cards[_erc1155Address][_id].controllerFee = _controllerFee;
1912 	}
1913 	
1914 	function setShadowed(address _erc1155Address, uint256 _id, bool _shadowed) external onlyWhitelistAdmin {
1915 		cards[_erc1155Address][_id].shadowed = _shadowed;
1916 		emit CardShadowed(_erc1155Address, _id, _shadowed);
1917 	}
1918 	
1919 	function emitFarmUri(string calldata _uri) external onlyWhitelistAdmin{
1920 	    emit FarmUri(address(this), _uri);
1921 	} 
1922 	
1923 	function removeNfts(address _erc1155Address, uint256 _id, uint256 _amount, address _recipient) external onlyWhitelistAdmin{
1924 	    
1925 	    ERC1155Tradable(_erc1155Address).safeTransferFrom(address(this), _recipient, _id, _amount, "");
1926 	    emit Removed(_erc1155Address, _id, _recipient, _amount);
1927 	} 
1928 
1929 	function createNft(
1930 		uint256 _supply,
1931 		uint256 _points,
1932 		uint256 _mintFee,
1933 		uint256 _controllerFee,
1934 		address _artist,
1935 		uint256 _releaseTime,
1936 		address _erc1155Address,
1937 		string calldata _uri,
1938 		string calldata _cardType
1939 	) external onlyWhitelistAdmin returns (uint256) {
1940 		uint256 tokenId = ERC1155Tradable(_erc1155Address).create(_supply, _supply, _uri, "");
1941 		require(tokenId > 0, "ERC1155 create did not succeed");
1942         Card storage c = cards[_erc1155Address][tokenId];
1943 		c.points = _points;
1944 		c.releaseTime = _releaseTime;
1945 		c.mintFee = _mintFee;
1946 		c.controllerFee = _controllerFee;
1947 		c.artist = _artist;
1948 		c.erc1155 = _erc1155Address;
1949 		c.supply = _supply;
1950 		emitCardAdded(_erc1155Address, tokenId, _points, _mintFee, _controllerFee, _artist, _releaseTime, _cardType);
1951 		return tokenId;
1952 	}
1953 	
1954 	function addNfts(
1955 		uint256 _points,
1956 		uint256 _mintFee,
1957 		uint256 _controllerFee,
1958 		address _artist,
1959 		uint256 _releaseTime,
1960 		address _erc1155Address,
1961 		uint256 _tokenId,
1962 		string calldata _cardType,
1963 		uint256 _cardAmount
1964 	) external onlyWhitelistAdmin returns (uint256) {
1965 		require(_tokenId > 0, "Invalid token id");
1966 		require(_cardAmount > 0, "Invalid card amount");
1967 		Card storage c = cards[_erc1155Address][_tokenId];
1968 		c.points = _points;
1969 		c.releaseTime = _releaseTime;
1970 		c.mintFee = _mintFee;
1971 		c.controllerFee = _controllerFee;
1972 		c.artist = _artist;
1973 		c.erc1155 = _erc1155Address;
1974 		c.supply = c.supply.add(_cardAmount);
1975 		ERC1155Tradable(_erc1155Address).safeTransferFrom(msg.sender, address(this), _tokenId, _cardAmount, "");
1976 		emitCardAdded(_erc1155Address, _tokenId, _points, _mintFee, _controllerFee, _artist, _releaseTime, _cardType);
1977 		return _tokenId;
1978 	}
1979 	
1980 	function updateNftData(
1981 	    address _erc1155Address, 
1982 	    uint256 _id,
1983 	    uint256 _points,
1984 		uint256 _mintFee,
1985 		uint256 _controllerFee,
1986 		address _artist,
1987 		uint256 _releaseTime,
1988 		bool _nsfw,
1989 		bool _shadowed,
1990 		string calldata _cardType
1991     ) external onlyWhitelistAdmin{
1992         require(_id > 0, "Invalid token id");
1993 	    Card storage c = cards[_erc1155Address][_id];
1994 		c.points = _points;
1995 		c.releaseTime = _releaseTime;
1996 		c.mintFee = _mintFee;
1997 		c.controllerFee = _controllerFee;
1998 		c.artist = _artist;
1999 		c.nsfw = _nsfw;
2000 		c.shadowed = _shadowed;
2001 		emit CardType(_erc1155Address, _id, _cardType);
2002 	}
2003 	
2004 	function supply(address _erc1155Address, uint256 _id) external view returns (uint256){
2005 	    return cards[_erc1155Address][_id].supply;
2006 	}
2007 	
2008 	function emitCardAdded(address _erc1155Address, uint256 tokenId, uint256 _points, uint256 _mintFee, uint256 _controllerFee, address _artist, uint256 _releaseTime, string memory _cardType) private onlyWhitelistAdmin{
2009 	    emit CardAdded(_erc1155Address, tokenId, _points, _mintFee.add(_controllerFee), _artist, _releaseTime);
2010 		emit CardType(_erc1155Address, tokenId, _cardType);
2011 	}
2012 
2013 	function withdrawFee() external {
2014 		uint256 amount = pendingWithdrawals[msg.sender];
2015 		require(amount > 0, "nothing to withdraw");
2016 		pendingWithdrawals[msg.sender] = 0;
2017 		msg.sender.transfer(amount);
2018 	}
2019 	
2020 	function getFarmsLength(address _address) external view returns (uint256) {
2021 	    return farms[_address].length;
2022 	}
2023 	
2024 	function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4){
2025 	    
2026 	    if(ERC1155Tradable(_operator) == ERC1155Tradable(address(this))){
2027 	    
2028 	        return ERC1155_RECEIVED_VALUE;
2029 	    
2030 	    }
2031 	    
2032 	    return ERC1155_RECEIVED_ERR_VALUE;
2033 	}
2034 	
2035 	function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4){
2036 	      
2037         if(ERC1155Tradable(_operator) == ERC1155Tradable(address(this))){
2038     
2039             return ERC1155_BATCH_RECEIVED_VALUE;
2040     
2041         }
2042     
2043         return ERC1155_RECEIVED_ERR_VALUE;
2044     }
2045 	
2046 	/**
2047 	 * Cloning functions
2048 	 * Disabled in clones and only working in the genesis contract.
2049 	 * */
2050 	 function init( 
2051 	    uint256 _periodStart,
2052 	    uint256 _minStake,
2053 		uint256 _maxStake,
2054 		address _controller,
2055 		IERC20 _tokenAddress,
2056 		string calldata _uri,
2057 		address _creator
2058 	) external {
2059 	    require(!constructed && !isCloned, "UniftyFarm must not be constructed yet or cloned.");
2060 	    require(_minStake >= 0 && _maxStake > 0 && _maxStake >= _minStake, "Problem with min and max stake setup");
2061 	    
2062 	    rewardRate = 86400;
2063 	    
2064 	    periodStart = _periodStart;
2065 	    minStake = _minStake;
2066 		maxStake = _maxStake;
2067 		controller = _controller;
2068 		token = _tokenAddress;
2069 	    
2070 		super.initOwnable();
2071 		super.initWhiteListAdmin();
2072 		super.initPauserRole();
2073 		
2074 		emit FarmCreated(_creator, address(this), 0, _uri);
2075 	    emit FarmUri(address(this), _uri);
2076 	}
2077 	
2078 	 function newFarm(
2079 	    uint256 _periodStart,
2080 	    uint256 _minStake,
2081 		uint256 _maxStake,
2082 		address _controller,
2083 		IERC20 _tokenAddress,
2084 		string calldata _uri
2085     ) external payable {
2086 	    
2087 	    require(!isCloned, "Not callable from clone");
2088 	    
2089 	    uint256 nifBalance = IERC20(address(0x7e291890B01E5181f7ecC98D79ffBe12Ad23df9e)).balanceOf(msg.sender);
2090 	    if(nifBalance < farmFeeMinimumNif && !iHaveAnyWildcard()){
2091 	        require(msg.value == farmFee, "Invalid farm fee");
2092 	    }
2093 	    
2094 	    address clone = createClone(address(this));
2095 	    
2096 	    UniftyFarm(clone).init(_periodStart, _minStake, _maxStake, _controller, _tokenAddress, _uri, msg.sender);
2097 	    UniftyFarm(clone).setCloned();
2098 	    UniftyFarm(clone).addWhitelistAdmin(msg.sender);
2099 	    UniftyFarm(clone).addPauser(msg.sender);
2100 	    UniftyFarm(clone).renounceWhitelistAdmin();
2101 	    UniftyFarm(clone).renouncePauser();
2102 	    UniftyFarm(clone).transferOwnership(msg.sender);
2103 	    
2104 	    farms[msg.sender].push(clone);
2105 	    
2106 	    // enough NIF or a wildcard? then there won't be no fee
2107 	    if(nifBalance < farmFeeMinimumNif && !iHaveAnyWildcard()){
2108 	        feeAddress.transfer(msg.value);
2109 	    }
2110 	    
2111 	    emit FarmCreated(msg.sender, clone, nifBalance < farmFeeMinimumNif && !iHaveAnyWildcard() ? farmFee : 0, _uri);
2112 	    emit FarmUri(clone, _uri);
2113 	}
2114 	
2115 	function iHaveAnyWildcard() public view returns (bool){
2116 	    for(uint256 i = 0; i < wildcards.length; i++){
2117 	        if(wildcardErc1155Address.balanceOf(msg.sender, wildcards[i]) > 0){
2118 	            return true;
2119 	        }
2120 	    }
2121 	  
2122 	    return false;
2123 	}
2124 	
2125 	function setFeeAddress(address payable _feeAddress) external onlyWhitelistAdmin {
2126 	    require(!isCloned, "Not callable from clone");
2127 	    feeAddress = _feeAddress;
2128 	}
2129 	
2130 	function setFarmFee(uint256 _farmFee) external onlyWhitelistAdmin{
2131 	    require(!isCloned, "Not callable from clone");
2132 	    farmFee = _farmFee;
2133 	}
2134 	
2135 	function setFarmFeeMinimumNif(uint256 _minNif) external onlyWhitelistAdmin{
2136 	    require(!isCloned, "Not callable from clone");
2137 	    farmFeeMinimumNif = _minNif;
2138 	}
2139 	
2140 	function setCloned() external onlyWhitelistAdmin {
2141 	    require(!isCloned, "Not callable from clone");
2142 	    isCloned = true;
2143 	}
2144 	
2145 	function setWildcard(uint256 wildcard) external onlyWhitelistAdmin {
2146 	    require(!isCloned, "Not callable from clone");
2147 	    wildcards.push(wildcard);
2148 	}
2149 	
2150 	function setWildcardErc1155Address(ERC1155Tradable _address) external onlyWhitelistAdmin {
2151 	    require(!isCloned, "Not callable from clone");
2152 	    wildcardErc1155Address = _address;
2153 	}
2154 	
2155 	
2156 	function removeWildcard(uint256 wildcard) external onlyWhitelistAdmin {
2157 	    require(!isCloned, "Not callable from clone");
2158 	    uint256 tmp = wildcards[wildcards.length - 1];
2159 	    bool found = false;
2160 	    for(uint256 i = 0; i < wildcards.length; i++){
2161 	        if(wildcards[i] == wildcard){
2162 	            wildcards[i] = tmp;
2163 	            found = true;
2164 	            break;
2165 	        }
2166 	    }
2167 	    if(found){
2168 	        delete wildcards[wildcards.length - 1];
2169 	        wildcards.length--;
2170 	    }
2171 	}
2172 }