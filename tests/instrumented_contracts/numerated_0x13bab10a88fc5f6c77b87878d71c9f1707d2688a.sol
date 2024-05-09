1 /**
2  *Submitted for verification at Etherscan.io on 2020-06-03
3 */
4 
5 pragma solidity ^0.5.0;
6 pragma experimental ABIEncoderV2;
7 
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15     /**
16     * @dev Multiplies two numbers, throws on overflow.
17     */
18     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
19         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
20         // benefit is lost if 'b' is also tested.
21         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
22         if (a == 0) {
23             return 0;
24         }
25 
26         c = a * b;
27         assert(c / a == b);
28         return c;
29     }
30 
31     /**
32     * @dev Integer division of two numbers, truncating the quotient.
33     */
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         // uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return a / b;
39     }
40 
41     /**
42     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43     */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         assert(b <= a);
46         return a - b;
47     }
48 
49     /**
50     * @dev Adds two numbers, throws on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
53         c = a + b;
54         assert(c >= a);
55         return c;
56     }
57 }
58 
59 /**
60     Note: Simple contract to use as base for const vals
61 */
62 contract CommonConstants {
63 
64     bytes4 constant internal ERC1155_ACCEPTED = 0xf23a6e61; // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
65     bytes4 constant internal ERC1155_BATCH_ACCEPTED = 0xbc197c81; // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
66 }
67 
68 /**
69     Note: The ERC-165 identifier for this interface is 0x4e2312e0.
70 */
71 interface ERC1155TokenReceiver {
72     /**
73         @notice Handle the receipt of a single ERC1155 token type.
74         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
75         This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
76         This function MUST revert if it rejects the transfer.
77         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
78         @param _operator  The address which initiated the transfer (i.e. msg.sender)
79         @param _from      The address which previously owned the token
80         @param _id        The ID of the token being transferred
81         @param _value     The amount of tokens being transferred
82         @param _data      Additional data with no specified format
83         @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
84     */
85     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external returns(bytes4);
86 
87     /**
88         @notice Handle the receipt of multiple ERC1155 token types.
89         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
90         This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
91         This function MUST revert if it rejects the transfer(s).
92         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
93         @param _operator  The address which initiated the batch transfer (i.e. msg.sender)
94         @param _from      The address which previously owned the token
95         @param _ids       An array containing ids of each token being transferred (order and length must match _values array)
96         @param _values    An array containing amounts of each token being transferred (order and length must match _ids array)
97         @param _data      Additional data with no specified format
98         @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
99     */
100     function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external returns(bytes4);
101 }
102 
103 /**
104  * @dev Interface of the ERC165 standard, as defined in the
105  * https://eips.ethereum.org/EIPS/eip-165[EIP].
106  *
107  * Implementers can declare support of contract interfaces, which can then be
108  * queried by others ({ERC165Checker}).
109  *
110  * For an implementation, see {ERC165}.
111  */
112 interface IERC165 {
113     /**
114      * @dev Returns true if this contract implements the interface defined by
115      * `interfaceId`. See the corresponding
116      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
117      * to learn more about how these ids are created.
118      *
119      * This function call must use less than 30 000 gas.
120      */
121     function supportsInterface(bytes4 interfaceId) external view returns (bool);
122 }
123 
124 /**
125     @title ERC-1155 Multi Token Standard
126     @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md
127     Note: The ERC-165 identifier for this interface is 0xd9b67a26.
128  */
129 contract IERC1155 is IERC165 {
130     /**
131         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
132         The `_operator` argument MUST be msg.sender.
133         The `_from` argument MUST be the address of the holder whose balance is decreased.
134         The `_to` argument MUST be the address of the recipient whose balance is increased.
135         The `_id` argument MUST be the token type being transferred.
136         The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.
137         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
138         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
139     */
140     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
141 
142     /**
143         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
144         The `_operator` argument MUST be msg.sender.
145         The `_from` argument MUST be the address of the holder whose balance is decreased.
146         The `_to` argument MUST be the address of the recipient whose balance is increased.
147         The `_ids` argument MUST be the list of tokens being transferred.
148         The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.
149         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
150         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
151     */
152     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
153 
154     /**
155         @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absense of an event assumes disabled).
156     */
157     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
158 
159     /**
160         @dev MUST emit when the URI is updated for a token ID.
161         URIs are defined in RFC 3986.
162         The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
163     */
164     event URI(string _value, uint256 indexed _id);
165 
166     /**
167         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
168         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
169         MUST revert if `_to` is the zero address.
170         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
171         MUST revert on any other error.
172         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
173         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
174         @param _from    Source address
175         @param _to      Target address
176         @param _id      ID of the token type
177         @param _value   Transfer amount
178         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
179     */
180     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;
181 
182     /**
183         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
184         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
185         MUST revert if `_to` is the zero address.
186         MUST revert if length of `_ids` is not the same as length of `_values`.
187         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
188         MUST revert on any other error.
189         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
190         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
191         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
192         @param _from    Source address
193         @param _to      Target address
194         @param _ids     IDs of each token type (order and length must match _values array)
195         @param _values  Transfer amounts per token type (order and length must match _ids array)
196         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
197     */
198     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external;
199 
200     /**
201         @notice Get the balance of an account's Tokens.
202         @param _owner  The address of the token holder
203         @param _id     ID of the Token
204         @return        The _owner's balance of the Token type requested
205      */
206     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
207 
208     /**
209         @notice Get the balance of multiple account/token pairs
210         @param _owners The addresses of the token holders
211         @param _ids    ID of the Tokens
212         @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
213      */
214     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
215 
216     /**
217         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
218         @dev MUST emit the ApprovalForAll event on success.
219         @param _operator  Address to add to the set of authorized operators
220         @param _approved  True if the operator is approved, false to revoke approval
221     */
222     function setApprovalForAll(address _operator, bool _approved) external;
223 
224     /**
225         @notice Queries the approval status of an operator for a given owner.
226         @param _owner     The owner of the Tokens
227         @param _operator  Address of authorized operator
228         @return           True if the operator is approved, false if not
229     */
230     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
231 }
232 
233 /**
234  * @dev Implementation of the {IERC165} interface.
235  *
236  * Contracts may inherit from this and call {_registerInterface} to declare
237  * their support of an interface.
238  */
239 contract ERC165 is IERC165 {
240     /*
241      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
242      */
243     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
244 
245     /**
246      * @dev Mapping of interface ids to whether or not it's supported.
247      */
248     mapping(bytes4 => bool) private _supportedInterfaces;
249 
250     constructor () internal {
251         // Derived contracts need only register support for their own interfaces,
252         // we register support for ERC165 itself here
253         _registerInterface(_INTERFACE_ID_ERC165);
254     }
255 
256     /**
257      * @dev See {IERC165-supportsInterface}.
258      *
259      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
260      */
261     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
262         return _supportedInterfaces[interfaceId];
263     }
264 
265     /**
266      * @dev Registers the contract as an implementer of the interface defined by
267      * `interfaceId`. Support of the actual ERC165 interface is automatic and
268      * registering its interface id is not required.
269      *
270      * See {IERC165-supportsInterface}.
271      *
272      * Requirements:
273      *
274      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
275      */
276     function _registerInterface(bytes4 interfaceId) internal {
277         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
278         _supportedInterfaces[interfaceId] = true;
279     }
280 }
281 
282 /**
283  * @dev Collection of functions related to the address type
284  */
285 library Address {
286     /**
287      * @dev Returns true if `account` is a contract.
288      *
289      * [IMPORTANT]
290      * ====
291      * It is unsafe to assume that an address for which this function returns
292      * false is an externally-owned account (EOA) and not a contract.
293      *
294      * Among others, `isContract` will return false for the following 
295      * types of addresses:
296      *
297      *  - an externally-owned account
298      *  - a contract in construction
299      *  - an address where a contract will be created
300      *  - an address where a contract lived, but was destroyed
301      * ====
302      */
303     function isContract(address account) internal view returns (bool) {
304         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
305         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
306         // for accounts without code, i.e. `keccak256('')`
307         bytes32 codehash;
308         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
309         // solhint-disable-next-line no-inline-assembly
310         assembly { codehash := extcodehash(account) }
311         return (codehash != accountHash && codehash != 0x0);
312     }
313 
314     /**
315      * @dev Converts an `address` into `address payable`. Note that this is
316      * simply a type cast: the actual underlying value is not changed.
317      *
318      * _Available since v2.4.0._
319      */
320     function toPayable(address account) internal pure returns (address payable) {
321         return address(uint160(account));
322     }
323 
324     /**
325      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
326      * `recipient`, forwarding all available gas and reverting on errors.
327      *
328      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
329      * of certain opcodes, possibly making contracts go over the 2300 gas limit
330      * imposed by `transfer`, making them unable to receive funds via
331      * `transfer`. {sendValue} removes this limitation.
332      *
333      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
334      *
335      * IMPORTANT: because control is transferred to `recipient`, care must be
336      * taken to not create reentrancy vulnerabilities. Consider using
337      * {ReentrancyGuard} or the
338      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
339      *
340      * _Available since v2.4.0._
341      */
342     function sendValue(address payable recipient, uint256 amount) internal {
343         require(address(this).balance >= amount, "Address: insufficient balance");
344 
345         // solhint-disable-next-line avoid-call-value
346         (bool success, ) = recipient.call.value(amount)("");
347         require(success, "Address: unable to send value, recipient may have reverted");
348     }
349 }
350 
351 // A sample implementation of core ERC1155 function.
352 contract ERC1155 is IERC1155, ERC165, CommonConstants
353 {
354     using SafeMath for uint256;
355     using Address for address;
356 
357     // id => (owner => balance)
358     mapping (uint256 => mapping(address => uint256)) internal balances;
359 
360     // owner => (operator => approved)
361     mapping (address => mapping(address => bool)) internal operatorApproval;
362 
363 /////////////////////////////////////////// ERC165 //////////////////////////////////////////////
364 
365     /*
366         bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
367         bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
368         bytes4(keccak256("balanceOf(address,uint256)")) ^
369         bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
370         bytes4(keccak256("setApprovalForAll(address,bool)")) ^
371         bytes4(keccak256("isApprovedForAll(address,address)"));
372     */
373     bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
374 
375 /////////////////////////////////////////// CONSTRUCTOR //////////////////////////////////////////
376 
377     constructor() public {
378         _registerInterface(INTERFACE_SIGNATURE_ERC1155);
379     }
380 
381 /////////////////////////////////////////// ERC1155 //////////////////////////////////////////////
382 
383     /**
384         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
385         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
386         MUST revert if `_to` is the zero address.
387         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
388         MUST revert on any other error.
389         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
390         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
391         @param _from    Source address
392         @param _to      Target address
393         @param _id      ID of the token type
394         @param _value   Transfer amount
395         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
396     */
397     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external {
398 
399         require(_to != address(0x0), "_to must be non-zero.");
400         require(_from == msg.sender || operatorApproval[_from][msg.sender] == true, "Need operator approval for 3rd party transfers.");
401 
402         // SafeMath will throw with insuficient funds _from
403         // or if _id is not valid (balance will be 0)
404         balances[_id][_from] = balances[_id][_from].sub(_value);
405         balances[_id][_to]   = _value.add(balances[_id][_to]);
406 
407         // MUST emit event
408         emit TransferSingle(msg.sender, _from, _to, _id, _value);
409 
410         // Now that the balance is updated and the event was emitted,
411         // call onERC1155Received if the destination is a contract.
412         if (_to.isContract()) {
413             _doSafeTransferAcceptanceCheck(msg.sender, _from, _to, _id, _value, _data);
414         }
415     }
416 
417     /**
418         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
419         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
420         MUST revert if `_to` is the zero address.
421         MUST revert if length of `_ids` is not the same as length of `_values`.
422         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
423         MUST revert on any other error.
424         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
425         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
426         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
427         @param _from    Source address
428         @param _to      Target address
429         @param _ids     IDs of each token type (order and length must match _values array)
430         @param _values  Transfer amounts per token type (order and length must match _ids array)
431         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
432     */
433     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external {
434 
435         // MUST Throw on errors
436         require(_to != address(0x0), "destination address must be non-zero.");
437         require(_ids.length == _values.length, "_ids and _values array lenght must match.");
438         require(_from == msg.sender || operatorApproval[_from][msg.sender] == true, "Need operator approval for 3rd party transfers.");
439 
440         for (uint256 i = 0; i < _ids.length; ++i) {
441             uint256 id = _ids[i];
442             uint256 value = _values[i];
443 
444             // SafeMath will throw with insuficient funds _from
445             // or if _id is not valid (balance will be 0)
446             balances[id][_from] = balances[id][_from].sub(value);
447             balances[id][_to]   = value.add(balances[id][_to]);
448         }
449 
450         // Note: instead of the below batch versions of event and acceptance check you MAY have emitted a TransferSingle
451         // event and a subsequent call to _doSafeTransferAcceptanceCheck in above loop for each balance change instead.
452         // Or emitted a TransferSingle event for each in the loop and then the single _doSafeBatchTransferAcceptanceCheck below.
453         // However it is implemented the balance changes and events MUST match when a check (i.e. calling an external contract) is done.
454 
455         // MUST emit event
456         emit TransferBatch(msg.sender, _from, _to, _ids, _values);
457 
458         // Now that the balances are updated and the events are emitted,
459         // call onERC1155BatchReceived if the destination is a contract.
460         if (_to.isContract()) {
461             _doSafeBatchTransferAcceptanceCheck(msg.sender, _from, _to, _ids, _values, _data);
462         }
463     }
464 
465     /**
466         @notice Get the balance of an account's Tokens.
467         @param _owner  The address of the token holder
468         @param _id     ID of the Token
469         @return        The _owner's balance of the Token type requested
470      */
471     function balanceOf(address _owner, uint256 _id) external view returns (uint256) {
472         // The balance of any account can be calculated from the Transfer events history.
473         // However, since we need to keep the balances to validate transfer request,
474         // there is no extra cost to also privide a querry function.
475         return balances[_id][_owner];
476     }
477 
478 
479     /**
480         @notice Get the balance of multiple account/token pairs
481         @param _owners The addresses of the token holders
482         @param _ids    ID of the Tokens
483         @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
484      */
485     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory) {
486 
487         require(_owners.length == _ids.length);
488 
489         uint256[] memory balances_ = new uint256[](_owners.length);
490 
491         for (uint256 i = 0; i < _owners.length; ++i) {
492             balances_[i] = balances[_ids[i]][_owners[i]];
493         }
494 
495         return balances_;
496     }
497 
498     /**
499         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
500         @dev MUST emit the ApprovalForAll event on success.
501         @param _operator  Address to add to the set of authorized operators
502         @param _approved  True if the operator is approved, false to revoke approval
503     */
504     function setApprovalForAll(address _operator, bool _approved) external {
505         operatorApproval[msg.sender][_operator] = _approved;
506         emit ApprovalForAll(msg.sender, _operator, _approved);
507     }
508 
509     /**
510         @notice Queries the approval status of an operator for a given owner.
511         @param _owner     The owner of the Tokens
512         @param _operator  Address of authorized operator
513         @return           True if the operator is approved, false if not
514     */
515     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
516         return operatorApproval[_owner][_operator];
517     }
518 
519 /////////////////////////////////////////// Internal //////////////////////////////////////////////
520 
521     function _doSafeTransferAcceptanceCheck(address _operator, address _from, address _to, uint256 _id, uint256 _value, bytes memory _data) internal {
522 
523         // If this was a hybrid standards solution you would have to check ERC165(_to).supportsInterface(0x4e2312e0) here but as this is a pure implementation of an ERC-1155 token set as recommended by
524         // the standard, it is not necessary. The below should revert in all failure cases i.e. _to isn't a receiver, or it is and either returns an unknown value or it reverts in the call to indicate non-acceptance.
525 
526 
527         // Note: if the below reverts in the onERC1155Received function of the _to address you will have an undefined revert reason returned rather than the one in the require test.
528         // If you want predictable revert reasons consider using low level _to.call() style instead so the revert does not bubble up and you can revert yourself on the ERC1155_ACCEPTED test.
529         require(ERC1155TokenReceiver(_to).onERC1155Received(_operator, _from, _id, _value, _data) == ERC1155_ACCEPTED, "contract returned an unknown value from onERC1155Received");
530     }
531 
532     function _doSafeBatchTransferAcceptanceCheck(address _operator, address _from, address _to, uint256[] memory _ids, uint256[] memory _values, bytes memory _data) internal {
533 
534         // If this was a hybrid standards solution you would have to check ERC165(_to).supportsInterface(0x4e2312e0) here but as this is a pure implementation of an ERC-1155 token set as recommended by
535         // the standard, it is not necessary. The below should revert in all failure cases i.e. _to isn't a receiver, or it is and either returns an unknown value or it reverts in the call to indicate non-acceptance.
536 
537         // Note: if the below reverts in the onERC1155BatchReceived function of the _to address you will have an undefined revert reason returned rather than the one in the require test.
538         // If you want predictable revert reasons consider using low level _to.call() style instead so the revert does not bubble up and you can revert yourself on the ERC1155_BATCH_ACCEPTED test.
539         require(ERC1155TokenReceiver(_to).onERC1155BatchReceived(_operator, _from, _ids, _values, _data) == ERC1155_BATCH_ACCEPTED, "contract returned an unknown value from onERC1155BatchReceived");
540     }
541 }
542 
543 library UintLibrary {
544     function toString(uint256 _i) internal pure returns (string memory) {
545         if (_i == 0) {
546             return "0";
547         }
548         uint j = _i;
549         uint len;
550         while (j != 0) {
551             len++;
552             j /= 10;
553         }
554         bytes memory bstr = new bytes(len);
555         uint k = len - 1;
556         while (_i != 0) {
557             bstr[k--] = byte(uint8(48 + _i % 10));
558             _i /= 10;
559         }
560         return string(bstr);
561     }
562 }
563 
564 library StringLibrary {
565     using UintLibrary for uint256;
566 
567     function append(string memory _a, string memory _b) internal pure returns (string memory) {
568         bytes memory _ba = bytes(_a);
569         bytes memory _bb = bytes(_b);
570         bytes memory bab = new bytes(_ba.length + _bb.length);
571         uint k = 0;
572         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
573         for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
574         return string(bab);
575     }
576 
577     function append(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
578         bytes memory _ba = bytes(_a);
579         bytes memory _bb = bytes(_b);
580         bytes memory _bc = bytes(_c);
581         bytes memory bbb = new bytes(_ba.length + _bb.length + _bc.length);
582         uint k = 0;
583         for (uint i = 0; i < _ba.length; i++) bbb[k++] = _ba[i];
584         for (uint i = 0; i < _bb.length; i++) bbb[k++] = _bb[i];
585         for (uint i = 0; i < _bc.length; i++) bbb[k++] = _bc[i];
586         return string(bbb);
587     }
588 
589     function recover(string memory message, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
590         bytes memory msgBytes = bytes(message);
591         bytes memory fullMessage = concat(
592             bytes("\x19Ethereum Signed Message:\n"),
593             bytes(msgBytes.length.toString()),
594             msgBytes,
595             new bytes(0), new bytes(0), new bytes(0), new bytes(0)
596         );
597         return ecrecover(keccak256(fullMessage), v, r, s);
598     }
599 
600     function concat(bytes memory _ba, bytes memory _bb, bytes memory _bc, bytes memory _bd, bytes memory _be, bytes memory _bf, bytes memory _bg) internal pure returns (bytes memory) {
601         bytes memory resultBytes = new bytes(_ba.length + _bb.length + _bc.length + _bd.length + _be.length + _bf.length + _bg.length);
602         uint k = 0;
603         for (uint i = 0; i < _ba.length; i++) resultBytes[k++] = _ba[i];
604         for (uint i = 0; i < _bb.length; i++) resultBytes[k++] = _bb[i];
605         for (uint i = 0; i < _bc.length; i++) resultBytes[k++] = _bc[i];
606         for (uint i = 0; i < _bd.length; i++) resultBytes[k++] = _bd[i];
607         for (uint i = 0; i < _be.length; i++) resultBytes[k++] = _be[i];
608         for (uint i = 0; i < _bf.length; i++) resultBytes[k++] = _bf[i];
609         for (uint i = 0; i < _bg.length; i++) resultBytes[k++] = _bg[i];
610         return resultBytes;
611     }
612 }
613 
614 contract HasContractURI is ERC165 {
615 
616     string public contractURI;
617 
618     /*
619      * bytes4(keccak256('contractURI()')) == 0xe8a3d485
620      */
621     bytes4 private constant _INTERFACE_ID_CONTRACT_URI = 0xe8a3d485;
622 
623     constructor(string memory _contractURI) public {
624         contractURI = _contractURI;
625         _registerInterface(_INTERFACE_ID_CONTRACT_URI);
626     }
627 
628     /**
629      * @dev Internal function to set the contract URI
630      * @param _contractURI string URI prefix to assign
631      */
632     function _setContractURI(string memory _contractURI) internal {
633         contractURI = _contractURI;
634     }
635 }
636 
637 contract HasTokenURI {
638     using StringLibrary for string;
639 
640     //Token URI prefix
641     string public tokenURIPrefix;
642 
643     // Optional mapping for token URIs
644     mapping(uint256 => string) private _tokenURIs;
645 
646     constructor(string memory _tokenURIPrefix) public {
647         tokenURIPrefix = _tokenURIPrefix;
648     }
649 
650     /**
651      * @dev Returns an URI for a given token ID.
652      * Throws if the token ID does not exist. May return an empty string.
653      * @param tokenId uint256 ID of the token to query
654      */
655     function _tokenURI(uint256 tokenId) internal view returns (string memory) {
656         return tokenURIPrefix.append(_tokenURIs[tokenId]);
657     }
658 
659     /**
660      * @dev Internal function to set the token URI for a given token.
661      * Reverts if the token ID does not exist.
662      * @param tokenId uint256 ID of the token to set its URI
663      * @param uri string URI to assign
664      */
665     function _setTokenURI(uint256 tokenId, string memory uri) internal {
666         _tokenURIs[tokenId] = uri;
667     }
668 
669     /**
670      * @dev Internal function to set the token URI prefix.
671      * @param _tokenURIPrefix string URI prefix to assign
672      */
673     function _setTokenURIPrefix(string memory _tokenURIPrefix) internal {
674         tokenURIPrefix = _tokenURIPrefix;
675     }
676 
677     function _clearTokenURI(uint256 tokenId) internal {
678         if (bytes(_tokenURIs[tokenId]).length != 0) {
679             delete _tokenURIs[tokenId];
680         }
681     }
682 }
683 
684 /*
685  * @dev Provides information about the current execution context, including the
686  * sender of the transaction and its data. While these are generally available
687  * via msg.sender and msg.data, they should not be accessed in such a direct
688  * manner, since when dealing with GSN meta-transactions the account sending and
689  * paying for execution may not be the actual sender (as far as an application
690  * is concerned).
691  *
692  * This contract is only required for intermediate, library-like contracts.
693  */
694 contract Context {
695     // Empty internal constructor, to prevent people from mistakenly deploying
696     // an instance of this contract, which should be used via inheritance.
697     constructor () internal { }
698     // solhint-disable-previous-line no-empty-blocks
699 
700     function _msgSender() internal view returns (address payable) {
701         return msg.sender;
702     }
703 
704     function _msgData() internal view returns (bytes memory) {
705         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
706         return msg.data;
707     }
708 }
709 
710 /**
711  * @dev Contract module which provides a basic access control mechanism, where
712  * there is an account (an owner) that can be granted exclusive access to
713  * specific functions.
714  *
715  * This module is used through inheritance. It will make available the modifier
716  * `onlyOwner`, which can be applied to your functions to restrict their use to
717  * the owner.
718  */
719 contract Ownable is Context {
720     address private _owner;
721 
722     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
723 
724     /**
725      * @dev Initializes the contract setting the deployer as the initial owner.
726      */
727     constructor () internal {
728         address msgSender = _msgSender();
729         _owner = msgSender;
730         emit OwnershipTransferred(address(0), msgSender);
731     }
732 
733     /**
734      * @dev Returns the address of the current owner.
735      */
736     function owner() public view returns (address) {
737         return _owner;
738     }
739 
740     /**
741      * @dev Throws if called by any account other than the owner.
742      */
743     modifier onlyOwner() {
744         require(isOwner(), "Ownable: caller is not the owner");
745         _;
746     }
747 
748     /**
749      * @dev Returns true if the caller is the current owner.
750      */
751     function isOwner() public view returns (bool) {
752         return _msgSender() == _owner;
753     }
754 
755     /**
756      * @dev Leaves the contract without owner. It will not be possible to call
757      * `onlyOwner` functions anymore. Can only be called by the current owner.
758      *
759      * NOTE: Renouncing ownership will leave the contract without an owner,
760      * thereby removing any functionality that is only available to the owner.
761      */
762     function renounceOwnership() public onlyOwner {
763         emit OwnershipTransferred(_owner, address(0));
764         _owner = address(0);
765     }
766 
767     /**
768      * @dev Transfers ownership of the contract to a new account (`newOwner`).
769      * Can only be called by the current owner.
770      */
771     function transferOwnership(address newOwner) public onlyOwner {
772         _transferOwnership(newOwner);
773     }
774 
775     /**
776      * @dev Transfers ownership of the contract to a new account (`newOwner`).
777      */
778     function _transferOwnership(address newOwner) internal {
779         require(newOwner != address(0), "Ownable: new owner is the zero address");
780         emit OwnershipTransferred(_owner, newOwner);
781         _owner = newOwner;
782     }
783 }
784 
785 /**
786     Note: The ERC-165 identifier for this interface is 0x0e89341c.
787 */
788 interface IERC1155Metadata_URI {
789     /**
790         @notice A distinct Uniform Resource Identifier (URI) for a given token.
791         @dev URIs are defined in RFC 3986.
792         The URI may point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
793         @return URI string
794     */
795     function uri(uint256 _id) external view returns (string memory);
796 }
797 
798 /**
799     Note: The ERC-165 identifier for this interface is 0x0e89341c.
800 */
801 contract ERC1155Metadata_URI is IERC1155Metadata_URI, HasTokenURI {
802 
803     constructor(string memory _tokenURIPrefix) HasTokenURI(_tokenURIPrefix) public {
804 
805     }
806 
807     function uri(uint256 _id) external view returns (string memory) {
808         return _tokenURI(_id);
809     }
810 }
811 
812 contract ERC1155Base is Ownable, ERC1155Metadata_URI, HasContractURI, ERC1155 {
813 
814     // id => creator
815     mapping (uint256 => address) public creators;
816 
817     constructor(string memory contractURI, string memory tokenURIPrefix) HasContractURI(contractURI) ERC1155Metadata_URI(tokenURIPrefix) public {
818 
819     }
820 
821     // Creates a new token type and assings _initialSupply to minter
822     function _mint(uint256 _id, uint256 _supply, string memory _uri) internal {
823         require(creators[_id] == address(0x0), "Token is already minted");
824         require(_supply != 0, "Supply should be positive");
825         require(bytes(_uri).length > 0, "uri should be set");
826 
827         creators[_id] = msg.sender;
828 
829         balances[_id][msg.sender] = _supply;
830         _setTokenURI(_id, _uri);
831 
832         // Transfer event with mint semantic
833         emit TransferSingle(msg.sender, address(0x0), msg.sender, _id, _supply);
834         emit URI(_uri, _id);
835     }
836 
837     function burn(address _owner, uint256 _id, uint256 _value) external {
838 
839         require(_owner == msg.sender || operatorApproval[_owner][msg.sender] == true, "Need operator approval for 3rd party burns.");
840 
841         // SafeMath will throw with insuficient funds _owner
842         // or if _id is not valid (balance will be 0)
843         balances[_id][_owner] = balances[_id][_owner].sub(_value);
844 
845         // MUST emit event
846         emit TransferSingle(msg.sender, _owner, address(0x0), _id, _value);
847     }
848 
849     /**
850      * @dev Internal function to set the token URI for a given token.
851      * Reverts if the token ID does not exist.
852      * @param tokenId uint256 ID of the token to set its URI
853      * @param uri string URI to assign
854      */
855     function _setTokenURI(uint256 tokenId, string memory uri) internal {
856         require(creators[tokenId] != address(0x0), "_setTokenURI: Token should exist");
857         super._setTokenURI(tokenId, uri);
858     }
859 
860     function setTokenURIPrefix(string memory tokenURIPrefix) public onlyOwner {
861         _setTokenURIPrefix(tokenURIPrefix);
862     }
863 
864     function setContractURI(string memory contractURI) public onlyOwner {
865         _setContractURI(contractURI);
866     }
867 }
868 
869 contract SeenNFToken is Ownable, ERC1155Base {
870     string public name;
871     string public symbol;
872 
873     constructor(string memory _name, string memory _symbol, string memory contractURI, string memory tokenURIPrefix) ERC1155Base(contractURI, tokenURIPrefix) public {
874         name = _name;
875         symbol = _symbol;
876 
877         _registerInterface(bytes4(keccak256('MINT_WITH_ADDRESS')));
878     }
879 
880     function mint(uint256 id, uint256 supply, string memory uri) public onlyOwner {
881         _mint(id, supply, uri);
882     }
883 }