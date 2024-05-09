1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, throws on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers, truncating the quotient.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // assert(b > 0); // Solidity automatically throws when dividing by 0
32         // uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34         return a / b;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         assert(b <= a);
42         return a - b;
43     }
44 
45     /**
46     * @dev Adds two numbers, throws on overflow.
47     */
48     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49         c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
54 
55 /**
56     Note: Simple contract to use as base for const vals
57 */
58 contract CommonConstants {
59 
60     bytes4 constant internal ERC1155_ACCEPTED = 0xf23a6e61; // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
61     bytes4 constant internal ERC1155_BATCH_ACCEPTED = 0xbc197c81; // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
62 }
63 
64 /**
65     Note: The ERC-165 identifier for this interface is 0x4e2312e0.
66 */
67 interface ERC1155TokenReceiver {
68     /**
69         @notice Handle the receipt of a single ERC1155 token type.
70         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
71         This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
72         This function MUST revert if it rejects the transfer.
73         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
74         @param _operator  The address which initiated the transfer (i.e. msg.sender)
75         @param _from      The address which previously owned the token
76         @param _id        The ID of the token being transferred
77         @param _value     The amount of tokens being transferred
78         @param _data      Additional data with no specified format
79         @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
80     */
81     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external returns(bytes4);
82 
83     /**
84         @notice Handle the receipt of multiple ERC1155 token types.
85         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
86         This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
87         This function MUST revert if it rejects the transfer(s).
88         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
89         @param _operator  The address which initiated the batch transfer (i.e. msg.sender)
90         @param _from      The address which previously owned the token
91         @param _ids       An array containing ids of each token being transferred (order and length must match _values array)
92         @param _values    An array containing amounts of each token being transferred (order and length must match _ids array)
93         @param _data      Additional data with no specified format
94         @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
95     */
96     function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external returns(bytes4);
97 }
98 
99 /**
100  * @dev Interface of the ERC165 standard, as defined in the
101  * https://eips.ethereum.org/EIPS/eip-165[EIP].
102  *
103  * Implementers can declare support of contract interfaces, which can then be
104  * queried by others ({ERC165Checker}).
105  *
106  * For an implementation, see {ERC165}.
107  */
108 interface IERC165 {
109     /**
110      * @dev Returns true if this contract implements the interface defined by
111      * `interfaceId`. See the corresponding
112      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
113      * to learn more about how these ids are created.
114      *
115      * This function call must use less than 30 000 gas.
116      */
117     function supportsInterface(bytes4 interfaceId) external view returns (bool);
118 }
119 
120 /**
121     @title ERC-1155 Multi Token Standard
122     @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md
123     Note: The ERC-165 identifier for this interface is 0xd9b67a26.
124  */
125 contract IERC1155 is IERC165 {
126     /**
127         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
128         The `_operator` argument MUST be msg.sender.
129         The `_from` argument MUST be the address of the holder whose balance is decreased.
130         The `_to` argument MUST be the address of the recipient whose balance is increased.
131         The `_id` argument MUST be the token type being transferred.
132         The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.
133         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
134         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
135     */
136     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
137 
138     /**
139         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
140         The `_operator` argument MUST be msg.sender.
141         The `_from` argument MUST be the address of the holder whose balance is decreased.
142         The `_to` argument MUST be the address of the recipient whose balance is increased.
143         The `_ids` argument MUST be the list of tokens being transferred.
144         The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.
145         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
146         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
147     */
148     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
149 
150     /**
151         @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absense of an event assumes disabled).
152     */
153     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
154 
155     /**
156         @dev MUST emit when the URI is updated for a token ID.
157         URIs are defined in RFC 3986.
158         The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
159     */
160     event URI(string _value, uint256 indexed _id);
161 
162     /**
163         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
164         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
165         MUST revert if `_to` is the zero address.
166         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
167         MUST revert on any other error.
168         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
169         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
170         @param _from    Source address
171         @param _to      Target address
172         @param _id      ID of the token type
173         @param _value   Transfer amount
174         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
175     */
176     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;
177 
178     /**
179         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
180         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
181         MUST revert if `_to` is the zero address.
182         MUST revert if length of `_ids` is not the same as length of `_values`.
183         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
184         MUST revert on any other error.
185         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
186         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
187         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
188         @param _from    Source address
189         @param _to      Target address
190         @param _ids     IDs of each token type (order and length must match _values array)
191         @param _values  Transfer amounts per token type (order and length must match _ids array)
192         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
193     */
194     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external;
195 
196     /**
197         @notice Get the balance of an account's Tokens.
198         @param _owner  The address of the token holder
199         @param _id     ID of the Token
200         @return        The _owner's balance of the Token type requested
201      */
202     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
203 
204     /**
205         @notice Get the balance of multiple account/token pairs
206         @param _owners The addresses of the token holders
207         @param _ids    ID of the Tokens
208         @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
209      */
210     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
211 
212     /**
213         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
214         @dev MUST emit the ApprovalForAll event on success.
215         @param _operator  Address to add to the set of authorized operators
216         @param _approved  True if the operator is approved, false to revoke approval
217     */
218     function setApprovalForAll(address _operator, bool _approved) external;
219 
220     /**
221         @notice Queries the approval status of an operator for a given owner.
222         @param _owner     The owner of the Tokens
223         @param _operator  Address of authorized operator
224         @return           True if the operator is approved, false if not
225     */
226     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
227 }
228 
229 /**
230  * @dev Implementation of the {IERC165} interface.
231  *
232  * Contracts may inherit from this and call {_registerInterface} to declare
233  * their support of an interface.
234  */
235 contract ERC165 is IERC165 {
236     /*
237      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
238      */
239     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
240 
241     /**
242      * @dev Mapping of interface ids to whether or not it's supported.
243      */
244     mapping(bytes4 => bool) private _supportedInterfaces;
245 
246     constructor () internal {
247         // Derived contracts need only register support for their own interfaces,
248         // we register support for ERC165 itself here
249         _registerInterface(_INTERFACE_ID_ERC165);
250     }
251 
252     /**
253      * @dev See {IERC165-supportsInterface}.
254      *
255      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
256      */
257     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
258         return _supportedInterfaces[interfaceId];
259     }
260 
261     /**
262      * @dev Registers the contract as an implementer of the interface defined by
263      * `interfaceId`. Support of the actual ERC165 interface is automatic and
264      * registering its interface id is not required.
265      *
266      * See {IERC165-supportsInterface}.
267      *
268      * Requirements:
269      *
270      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
271      */
272     function _registerInterface(bytes4 interfaceId) internal {
273         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
274         _supportedInterfaces[interfaceId] = true;
275     }
276 }
277 
278 /**
279  * @dev Collection of functions related to the address type
280  */
281 library Address {
282     /**
283      * @dev Returns true if `account` is a contract.
284      *
285      * [IMPORTANT]
286      * ====
287      * It is unsafe to assume that an address for which this function returns
288      * false is an externally-owned account (EOA) and not a contract.
289      *
290      * Among others, `isContract` will return false for the following 
291      * types of addresses:
292      *
293      *  - an externally-owned account
294      *  - a contract in construction
295      *  - an address where a contract will be created
296      *  - an address where a contract lived, but was destroyed
297      * ====
298      */
299     function isContract(address account) internal view returns (bool) {
300         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
301         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
302         // for accounts without code, i.e. `keccak256('')`
303         bytes32 codehash;
304         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
305         // solhint-disable-next-line no-inline-assembly
306         assembly { codehash := extcodehash(account) }
307         return (codehash != accountHash && codehash != 0x0);
308     }
309 
310     /**
311      * @dev Converts an `address` into `address payable`. Note that this is
312      * simply a type cast: the actual underlying value is not changed.
313      *
314      * _Available since v2.4.0._
315      */
316     function toPayable(address account) internal pure returns (address payable) {
317         return address(uint160(account));
318     }
319 
320     /**
321      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
322      * `recipient`, forwarding all available gas and reverting on errors.
323      *
324      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
325      * of certain opcodes, possibly making contracts go over the 2300 gas limit
326      * imposed by `transfer`, making them unable to receive funds via
327      * `transfer`. {sendValue} removes this limitation.
328      *
329      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
330      *
331      * IMPORTANT: because control is transferred to `recipient`, care must be
332      * taken to not create reentrancy vulnerabilities. Consider using
333      * {ReentrancyGuard} or the
334      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
335      *
336      * _Available since v2.4.0._
337      */
338     function sendValue(address payable recipient, uint256 amount) internal {
339         require(address(this).balance >= amount, "Address: insufficient balance");
340 
341         // solhint-disable-next-line avoid-call-value
342         (bool success, ) = recipient.call.value(amount)("");
343         require(success, "Address: unable to send value, recipient may have reverted");
344     }
345 }
346 
347 // A sample implementation of core ERC1155 function.
348 contract ERC1155 is IERC1155, ERC165, CommonConstants
349 {
350     using SafeMath for uint256;
351     using Address for address;
352 
353     // id => (owner => balance)
354     mapping (uint256 => mapping(address => uint256)) internal balances;
355 
356     // owner => (operator => approved)
357     mapping (address => mapping(address => bool)) internal operatorApproval;
358 
359 /////////////////////////////////////////// ERC165 //////////////////////////////////////////////
360 
361     /*
362         bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
363         bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
364         bytes4(keccak256("balanceOf(address,uint256)")) ^
365         bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
366         bytes4(keccak256("setApprovalForAll(address,bool)")) ^
367         bytes4(keccak256("isApprovedForAll(address,address)"));
368     */
369     bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
370 
371 /////////////////////////////////////////// CONSTRUCTOR //////////////////////////////////////////
372 
373     constructor() public {
374         _registerInterface(INTERFACE_SIGNATURE_ERC1155);
375     }
376 
377 /////////////////////////////////////////// ERC1155 //////////////////////////////////////////////
378 
379     /**
380         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
381         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
382         MUST revert if `_to` is the zero address.
383         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
384         MUST revert on any other error.
385         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
386         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
387         @param _from    Source address
388         @param _to      Target address
389         @param _id      ID of the token type
390         @param _value   Transfer amount
391         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
392     */
393     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external {
394 
395         require(_to != address(0x0), "_to must be non-zero.");
396         require(_from == msg.sender || operatorApproval[_from][msg.sender] == true, "Need operator approval for 3rd party transfers.");
397 
398         // SafeMath will throw with insuficient funds _from
399         // or if _id is not valid (balance will be 0)
400         balances[_id][_from] = balances[_id][_from].sub(_value);
401         balances[_id][_to]   = _value.add(balances[_id][_to]);
402 
403         // MUST emit event
404         emit TransferSingle(msg.sender, _from, _to, _id, _value);
405 
406         // Now that the balance is updated and the event was emitted,
407         // call onERC1155Received if the destination is a contract.
408         if (_to.isContract()) {
409             _doSafeTransferAcceptanceCheck(msg.sender, _from, _to, _id, _value, _data);
410         }
411     }
412 
413     /**
414         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
415         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
416         MUST revert if `_to` is the zero address.
417         MUST revert if length of `_ids` is not the same as length of `_values`.
418         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
419         MUST revert on any other error.
420         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
421         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
422         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
423         @param _from    Source address
424         @param _to      Target address
425         @param _ids     IDs of each token type (order and length must match _values array)
426         @param _values  Transfer amounts per token type (order and length must match _ids array)
427         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
428     */
429     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external {
430 
431         // MUST Throw on errors
432         require(_to != address(0x0), "destination address must be non-zero.");
433         require(_ids.length == _values.length, "_ids and _values array lenght must match.");
434         require(_from == msg.sender || operatorApproval[_from][msg.sender] == true, "Need operator approval for 3rd party transfers.");
435 
436         for (uint256 i = 0; i < _ids.length; ++i) {
437             uint256 id = _ids[i];
438             uint256 value = _values[i];
439 
440             // SafeMath will throw with insuficient funds _from
441             // or if _id is not valid (balance will be 0)
442             balances[id][_from] = balances[id][_from].sub(value);
443             balances[id][_to]   = value.add(balances[id][_to]);
444         }
445 
446         // Note: instead of the below batch versions of event and acceptance check you MAY have emitted a TransferSingle
447         // event and a subsequent call to _doSafeTransferAcceptanceCheck in above loop for each balance change instead.
448         // Or emitted a TransferSingle event for each in the loop and then the single _doSafeBatchTransferAcceptanceCheck below.
449         // However it is implemented the balance changes and events MUST match when a check (i.e. calling an external contract) is done.
450 
451         // MUST emit event
452         emit TransferBatch(msg.sender, _from, _to, _ids, _values);
453 
454         // Now that the balances are updated and the events are emitted,
455         // call onERC1155BatchReceived if the destination is a contract.
456         if (_to.isContract()) {
457             _doSafeBatchTransferAcceptanceCheck(msg.sender, _from, _to, _ids, _values, _data);
458         }
459     }
460 
461     /**
462         @notice Get the balance of an account's Tokens.
463         @param _owner  The address of the token holder
464         @param _id     ID of the Token
465         @return        The _owner's balance of the Token type requested
466      */
467     function balanceOf(address _owner, uint256 _id) external view returns (uint256) {
468         // The balance of any account can be calculated from the Transfer events history.
469         // However, since we need to keep the balances to validate transfer request,
470         // there is no extra cost to also privide a querry function.
471         return balances[_id][_owner];
472     }
473 
474 
475     /**
476         @notice Get the balance of multiple account/token pairs
477         @param _owners The addresses of the token holders
478         @param _ids    ID of the Tokens
479         @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
480      */
481     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory) {
482 
483         require(_owners.length == _ids.length);
484 
485         uint256[] memory balances_ = new uint256[](_owners.length);
486 
487         for (uint256 i = 0; i < _owners.length; ++i) {
488             balances_[i] = balances[_ids[i]][_owners[i]];
489         }
490 
491         return balances_;
492     }
493 
494     /**
495         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
496         @dev MUST emit the ApprovalForAll event on success.
497         @param _operator  Address to add to the set of authorized operators
498         @param _approved  True if the operator is approved, false to revoke approval
499     */
500     function setApprovalForAll(address _operator, bool _approved) external {
501         operatorApproval[msg.sender][_operator] = _approved;
502         emit ApprovalForAll(msg.sender, _operator, _approved);
503     }
504 
505     /**
506         @notice Queries the approval status of an operator for a given owner.
507         @param _owner     The owner of the Tokens
508         @param _operator  Address of authorized operator
509         @return           True if the operator is approved, false if not
510     */
511     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
512         return operatorApproval[_owner][_operator];
513     }
514 
515 /////////////////////////////////////////// Internal //////////////////////////////////////////////
516 
517     function _doSafeTransferAcceptanceCheck(address _operator, address _from, address _to, uint256 _id, uint256 _value, bytes memory _data) internal {
518 
519         // If this was a hybrid standards solution you would have to check ERC165(_to).supportsInterface(0x4e2312e0) here but as this is a pure implementation of an ERC-1155 token set as recommended by
520         // the standard, it is not necessary. The below should revert in all failure cases i.e. _to isn't a receiver, or it is and either returns an unknown value or it reverts in the call to indicate non-acceptance.
521 
522 
523         // Note: if the below reverts in the onERC1155Received function of the _to address you will have an undefined revert reason returned rather than the one in the require test.
524         // If you want predictable revert reasons consider using low level _to.call() style instead so the revert does not bubble up and you can revert yourself on the ERC1155_ACCEPTED test.
525         require(ERC1155TokenReceiver(_to).onERC1155Received(_operator, _from, _id, _value, _data) == ERC1155_ACCEPTED, "contract returned an unknown value from onERC1155Received");
526     }
527 
528     function _doSafeBatchTransferAcceptanceCheck(address _operator, address _from, address _to, uint256[] memory _ids, uint256[] memory _values, bytes memory _data) internal {
529 
530         // If this was a hybrid standards solution you would have to check ERC165(_to).supportsInterface(0x4e2312e0) here but as this is a pure implementation of an ERC-1155 token set as recommended by
531         // the standard, it is not necessary. The below should revert in all failure cases i.e. _to isn't a receiver, or it is and either returns an unknown value or it reverts in the call to indicate non-acceptance.
532 
533         // Note: if the below reverts in the onERC1155BatchReceived function of the _to address you will have an undefined revert reason returned rather than the one in the require test.
534         // If you want predictable revert reasons consider using low level _to.call() style instead so the revert does not bubble up and you can revert yourself on the ERC1155_BATCH_ACCEPTED test.
535         require(ERC1155TokenReceiver(_to).onERC1155BatchReceived(_operator, _from, _ids, _values, _data) == ERC1155_BATCH_ACCEPTED, "contract returned an unknown value from onERC1155BatchReceived");
536     }
537 }
538 
539 library UintLibrary {
540     function toString(uint256 _i) internal pure returns (string memory) {
541         if (_i == 0) {
542             return "0";
543         }
544         uint j = _i;
545         uint len;
546         while (j != 0) {
547             len++;
548             j /= 10;
549         }
550         bytes memory bstr = new bytes(len);
551         uint k = len - 1;
552         while (_i != 0) {
553             bstr[k--] = byte(uint8(48 + _i % 10));
554             _i /= 10;
555         }
556         return string(bstr);
557     }
558 }
559 
560 library StringLibrary {
561     using UintLibrary for uint256;
562 
563     function append(string memory _a, string memory _b) internal pure returns (string memory) {
564         bytes memory _ba = bytes(_a);
565         bytes memory _bb = bytes(_b);
566         bytes memory bab = new bytes(_ba.length + _bb.length);
567         uint k = 0;
568         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
569         for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
570         return string(bab);
571     }
572 
573     function append(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
574         bytes memory _ba = bytes(_a);
575         bytes memory _bb = bytes(_b);
576         bytes memory _bc = bytes(_c);
577         bytes memory bbb = new bytes(_ba.length + _bb.length + _bc.length);
578         uint k = 0;
579         for (uint i = 0; i < _ba.length; i++) bbb[k++] = _ba[i];
580         for (uint i = 0; i < _bb.length; i++) bbb[k++] = _bb[i];
581         for (uint i = 0; i < _bc.length; i++) bbb[k++] = _bc[i];
582         return string(bbb);
583     }
584 
585     function recover(string memory message, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
586         bytes memory msgBytes = bytes(message);
587         bytes memory fullMessage = concat(
588             bytes("\x19Ethereum Signed Message:\n"),
589             bytes(msgBytes.length.toString()),
590             msgBytes,
591             new bytes(0), new bytes(0), new bytes(0), new bytes(0)
592         );
593         return ecrecover(keccak256(fullMessage), v, r, s);
594     }
595 
596     function concat(bytes memory _ba, bytes memory _bb, bytes memory _bc, bytes memory _bd, bytes memory _be, bytes memory _bf, bytes memory _bg) internal pure returns (bytes memory) {
597         bytes memory resultBytes = new bytes(_ba.length + _bb.length + _bc.length + _bd.length + _be.length + _bf.length + _bg.length);
598         uint k = 0;
599         for (uint i = 0; i < _ba.length; i++) resultBytes[k++] = _ba[i];
600         for (uint i = 0; i < _bb.length; i++) resultBytes[k++] = _bb[i];
601         for (uint i = 0; i < _bc.length; i++) resultBytes[k++] = _bc[i];
602         for (uint i = 0; i < _bd.length; i++) resultBytes[k++] = _bd[i];
603         for (uint i = 0; i < _be.length; i++) resultBytes[k++] = _be[i];
604         for (uint i = 0; i < _bf.length; i++) resultBytes[k++] = _bf[i];
605         for (uint i = 0; i < _bg.length; i++) resultBytes[k++] = _bg[i];
606         return resultBytes;
607     }
608 }
609 
610 contract HasContractURI is ERC165 {
611 
612     string public contractURI;
613 
614     /*
615      * bytes4(keccak256('contractURI()')) == 0xe8a3d485
616      */
617     bytes4 private constant _INTERFACE_ID_CONTRACT_URI = 0xe8a3d485;
618 
619     constructor(string memory _contractURI) public {
620         contractURI = _contractURI;
621         _registerInterface(_INTERFACE_ID_CONTRACT_URI);
622     }
623 
624     /**
625      * @dev Internal function to set the contract URI
626      * @param _contractURI string URI prefix to assign
627      */
628     function _setContractURI(string memory _contractURI) internal {
629         contractURI = _contractURI;
630     }
631 }
632 
633 contract HasTokenURI {
634     using StringLibrary for string;
635 
636     //Token URI prefix
637     string public tokenURIPrefix;
638 
639     // Optional mapping for token URIs
640     mapping(uint256 => string) private _tokenURIs;
641 
642     constructor(string memory _tokenURIPrefix) public {
643         tokenURIPrefix = _tokenURIPrefix;
644     }
645 
646     /**
647      * @dev Returns an URI for a given token ID.
648      * Throws if the token ID does not exist. May return an empty string.
649      * @param tokenId uint256 ID of the token to query
650      */
651     function _tokenURI(uint256 tokenId) internal view returns (string memory) {
652         return tokenURIPrefix.append(_tokenURIs[tokenId]);
653     }
654 
655     /**
656      * @dev Internal function to set the token URI for a given token.
657      * Reverts if the token ID does not exist.
658      * @param tokenId uint256 ID of the token to set its URI
659      * @param uri string URI to assign
660      */
661     function _setTokenURI(uint256 tokenId, string memory uri) internal {
662         _tokenURIs[tokenId] = uri;
663     }
664 
665     /**
666      * @dev Internal function to set the token URI prefix.
667      * @param _tokenURIPrefix string URI prefix to assign
668      */
669     function _setTokenURIPrefix(string memory _tokenURIPrefix) internal {
670         tokenURIPrefix = _tokenURIPrefix;
671     }
672 
673     function _clearTokenURI(uint256 tokenId) internal {
674         if (bytes(_tokenURIs[tokenId]).length != 0) {
675             delete _tokenURIs[tokenId];
676         }
677     }
678 }
679 
680 /*
681  * @dev Provides information about the current execution context, including the
682  * sender of the transaction and its data. While these are generally available
683  * via msg.sender and msg.data, they should not be accessed in such a direct
684  * manner, since when dealing with GSN meta-transactions the account sending and
685  * paying for execution may not be the actual sender (as far as an application
686  * is concerned).
687  *
688  * This contract is only required for intermediate, library-like contracts.
689  */
690 contract Context {
691     // Empty internal constructor, to prevent people from mistakenly deploying
692     // an instance of this contract, which should be used via inheritance.
693     constructor () internal { }
694     // solhint-disable-previous-line no-empty-blocks
695 
696     function _msgSender() internal view returns (address payable) {
697         return msg.sender;
698     }
699 
700     function _msgData() internal view returns (bytes memory) {
701         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
702         return msg.data;
703     }
704 }
705 
706 /**
707  * @dev Contract module which provides a basic access control mechanism, where
708  * there is an account (an owner) that can be granted exclusive access to
709  * specific functions.
710  *
711  * This module is used through inheritance. It will make available the modifier
712  * `onlyOwner`, which can be applied to your functions to restrict their use to
713  * the owner.
714  */
715 contract Ownable is Context {
716     address private _owner;
717 
718     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
719 
720     /**
721      * @dev Initializes the contract setting the deployer as the initial owner.
722      */
723     constructor () internal {
724         address msgSender = _msgSender();
725         _owner = msgSender;
726         emit OwnershipTransferred(address(0), msgSender);
727     }
728 
729     /**
730      * @dev Returns the address of the current owner.
731      */
732     function owner() public view returns (address) {
733         return _owner;
734     }
735 
736     /**
737      * @dev Throws if called by any account other than the owner.
738      */
739     modifier onlyOwner() {
740         require(isOwner(), "Ownable: caller is not the owner");
741         _;
742     }
743 
744     /**
745      * @dev Returns true if the caller is the current owner.
746      */
747     function isOwner() public view returns (bool) {
748         return _msgSender() == _owner;
749     }
750 
751     /**
752      * @dev Leaves the contract without owner. It will not be possible to call
753      * `onlyOwner` functions anymore. Can only be called by the current owner.
754      *
755      * NOTE: Renouncing ownership will leave the contract without an owner,
756      * thereby removing any functionality that is only available to the owner.
757      */
758     function renounceOwnership() public onlyOwner {
759         emit OwnershipTransferred(_owner, address(0));
760         _owner = address(0);
761     }
762 
763     /**
764      * @dev Transfers ownership of the contract to a new account (`newOwner`).
765      * Can only be called by the current owner.
766      */
767     function transferOwnership(address newOwner) public onlyOwner {
768         _transferOwnership(newOwner);
769     }
770 
771     /**
772      * @dev Transfers ownership of the contract to a new account (`newOwner`).
773      */
774     function _transferOwnership(address newOwner) internal {
775         require(newOwner != address(0), "Ownable: new owner is the zero address");
776         emit OwnershipTransferred(_owner, newOwner);
777         _owner = newOwner;
778     }
779 }
780 
781 /**
782     Note: The ERC-165 identifier for this interface is 0x0e89341c.
783 */
784 interface IERC1155Metadata_URI {
785     /**
786         @notice A distinct Uniform Resource Identifier (URI) for a given token.
787         @dev URIs are defined in RFC 3986.
788         The URI may point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
789         @return URI string
790     */
791     function uri(uint256 _id) external view returns (string memory);
792 }
793 
794 /**
795     Note: The ERC-165 identifier for this interface is 0x0e89341c.
796 */
797 contract ERC1155Metadata_URI is IERC1155Metadata_URI, HasTokenURI {
798 
799     constructor(string memory _tokenURIPrefix) HasTokenURI(_tokenURIPrefix) public {
800 
801     }
802 
803     function uri(uint256 _id) external view returns (string memory) {
804         return _tokenURI(_id);
805     }
806 }
807 
808 contract HasSecondarySaleFees is ERC165 {
809 
810     event SecondarySaleFees(uint256 tokenId, address[] recipients, uint[] bps);
811 
812     /*
813      * bytes4(keccak256('getFeeBps(uint256)')) == 0x0ebd4c7f
814      * bytes4(keccak256('getFeeRecipients(uint256)')) == 0xb9c4d9fb
815      *
816      * => 0x0ebd4c7f ^ 0xb9c4d9fb == 0xb7799584
817      */
818     bytes4 private constant _INTERFACE_ID_FEES = 0xb7799584;
819 
820     constructor() public {
821         _registerInterface(_INTERFACE_ID_FEES);
822     }
823 
824     function getFeeRecipients(uint256 id) public view returns (address payable[] memory);
825     function getFeeBps(uint256 id) public view returns (uint[] memory);
826 }
827 
828 contract ERC1155Base is HasSecondarySaleFees, Ownable, ERC1155Metadata_URI, HasContractURI, ERC1155 {
829 
830     struct Fee {
831         address payable recipient;
832         uint256 value;
833     }
834 
835     // id => creator
836     mapping (uint256 => address) public creators;
837     // id => fees
838     mapping (uint256 => Fee[]) public fees;
839 
840     constructor(string memory contractURI, string memory tokenURIPrefix) HasContractURI(contractURI) ERC1155Metadata_URI(tokenURIPrefix) public {
841 
842     }
843 
844     function getFeeRecipients(uint256 id) public view returns (address payable[] memory) {
845         Fee[] memory _fees = fees[id];
846         address payable[] memory result = new address payable[](_fees.length);
847         for (uint i = 0; i < _fees.length; i++) {
848             result[i] = _fees[i].recipient;
849         }
850         return result;
851     }
852 
853     function getFeeBps(uint256 id) public view returns (uint[] memory) {
854         Fee[] memory _fees = fees[id];
855         uint[] memory result = new uint[](_fees.length);
856         for (uint i = 0; i < _fees.length; i++) {
857             result[i] = _fees[i].value;
858         }
859         return result;
860     }
861 
862     // Creates a new token type and assings _initialSupply to minter
863     function _mint(uint256 _id, Fee[] memory _fees, uint256 _supply, string memory _uri) internal {
864         require(creators[_id] == address(0x0), "Token is already minted");
865         require(_supply != 0, "Supply should be positive");
866         require(bytes(_uri).length > 0, "uri should be set");
867 
868         creators[_id] = msg.sender;
869         address[] memory recipients = new address[](_fees.length);
870         uint[] memory bps = new uint[](_fees.length);
871         for (uint i = 0; i < _fees.length; i++) {
872             require(_fees[i].recipient != address(0x0), "Recipient should be present");
873             require(_fees[i].value != 0, "Fee value should be positive");
874             fees[_id].push(_fees[i]);
875             recipients[i] = _fees[i].recipient;
876             bps[i] = _fees[i].value;
877         }
878         if (_fees.length > 0) {
879             emit SecondarySaleFees(_id, recipients, bps);
880         }
881         balances[_id][msg.sender] = _supply;
882         _setTokenURI(_id, _uri);
883 
884         // Transfer event with mint semantic
885         emit TransferSingle(msg.sender, address(0x0), msg.sender, _id, _supply);
886         emit URI(_uri, _id);
887     }
888 
889     function burn(address _owner, uint256 _id, uint256 _value) external {
890 
891         require(_owner == msg.sender || operatorApproval[_owner][msg.sender] == true, "Need operator approval for 3rd party burns.");
892 
893         // SafeMath will throw with insuficient funds _owner
894         // or if _id is not valid (balance will be 0)
895         balances[_id][_owner] = balances[_id][_owner].sub(_value);
896 
897         // MUST emit event
898         emit TransferSingle(msg.sender, _owner, address(0x0), _id, _value);
899     }
900 
901     /**
902      * @dev Internal function to set the token URI for a given token.
903      * Reverts if the token ID does not exist.
904      * @param tokenId uint256 ID of the token to set its URI
905      * @param uri string URI to assign
906      */
907     function _setTokenURI(uint256 tokenId, string memory uri) internal {
908         require(creators[tokenId] != address(0x0), "_setTokenURI: Token should exist");
909         super._setTokenURI(tokenId, uri);
910     }
911 
912     function setTokenURIPrefix(string memory tokenURIPrefix) public onlyOwner {
913         _setTokenURIPrefix(tokenURIPrefix);
914     }
915 
916     function setContractURI(string memory contractURI) public onlyOwner {
917         _setContractURI(contractURI);
918     }
919 }
920 
921 /**
922  * @title Roles
923  * @dev Library for managing addresses assigned to a Role.
924  */
925 library Roles {
926     struct Role {
927         mapping (address => bool) bearer;
928     }
929 
930     /**
931      * @dev Give an account access to this role.
932      */
933     function add(Role storage role, address account) internal {
934         require(!has(role, account), "Roles: account already has role");
935         role.bearer[account] = true;
936     }
937 
938     /**
939      * @dev Remove an account's access to this role.
940      */
941     function remove(Role storage role, address account) internal {
942         require(has(role, account), "Roles: account does not have role");
943         role.bearer[account] = false;
944     }
945 
946     /**
947      * @dev Check if an account has this role.
948      * @return bool
949      */
950     function has(Role storage role, address account) internal view returns (bool) {
951         require(account != address(0), "Roles: account is the zero address");
952         return role.bearer[account];
953     }
954 }
955 
956 contract SignerRole is Context {
957     using Roles for Roles.Role;
958 
959     event SignerAdded(address indexed account);
960     event SignerRemoved(address indexed account);
961 
962     Roles.Role private _signers;
963 
964     constructor () internal {
965         _addSigner(_msgSender());
966     }
967 
968     modifier onlySigner() {
969         require(isSigner(_msgSender()), "SignerRole: caller does not have the Signer role");
970         _;
971     }
972 
973     function isSigner(address account) public view returns (bool) {
974         return _signers.has(account);
975     }
976 
977     function addSigner(address account) public onlySigner {
978         _addSigner(account);
979     }
980 
981     function renounceSigner() public {
982         _removeSigner(_msgSender());
983     }
984 
985     function _addSigner(address account) internal {
986         _signers.add(account);
987         emit SignerAdded(account);
988     }
989 
990     function _removeSigner(address account) internal {
991         _signers.remove(account);
992         emit SignerRemoved(account);
993     }
994 }
995 
996 
997 
998 
999 
1000 
1001 contract RaribleToken is Ownable, SignerRole, ERC1155Base {
1002     string public name;
1003     string public symbol;
1004 
1005     constructor(string memory _name, string memory _symbol, address signer, string memory contractURI, string memory tokenURIPrefix) ERC1155Base(contractURI, tokenURIPrefix) public {
1006         name = _name;
1007         symbol = _symbol;
1008 
1009         _addSigner(signer);
1010         _registerInterface(bytes4(keccak256('MINT_WITH_ADDRESS')));
1011     }
1012 
1013     function addSigner(address account) public onlyOwner {
1014         _addSigner(account);
1015     }
1016 
1017     function removeSigner(address account) public onlyOwner {
1018         _removeSigner(account);
1019     }
1020 
1021     function mint(uint256 id, uint8 v, bytes32 r, bytes32 s, Fee[] memory fees, uint256 supply, string memory uri) public {
1022         require(isSigner(ecrecover(keccak256(abi.encodePacked(this, id)), v, r, s)), "signer should sign tokenId");
1023         _mint(id, fees, supply, uri);
1024     }
1025 }
1026 
1027 
1028 
1029 contract RaribleUserToken is RaribleToken {
1030     event CreateERC1155_v1(address indexed creator, string name, string symbol);
1031 
1032     constructor(string memory name, string memory symbol, string memory contractURI, string memory tokenURIPrefix, address signer) RaribleToken(name, symbol, signer, contractURI, tokenURIPrefix) public {
1033         emit CreateERC1155_v1(msg.sender, name, symbol);
1034     }
1035 
1036     function mint(uint256 id, uint8 v, bytes32 r, bytes32 s, Fee[] memory fees, uint256 supply, string memory uri) onlyOwner public {
1037         super.mint(id, v, r, s, fees, supply, uri);
1038     }
1039 }