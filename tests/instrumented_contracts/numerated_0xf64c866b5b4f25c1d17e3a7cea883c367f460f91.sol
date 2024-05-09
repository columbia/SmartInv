1 // File: contracts/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12     /**
13     * @dev Multiplies two numbers, throws on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22 
23         c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers, truncating the quotient.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // assert(b > 0); // Solidity automatically throws when dividing by 0
33         // uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35         return a / b;
36     }
37 
38     /**
39     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         assert(b <= a);
43         return a - b;
44     }
45 
46     /**
47     * @dev Adds two numbers, throws on overflow.
48     */
49     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50         c = a + b;
51         assert(c >= a);
52         return c;
53     }
54 }
55 
56 // File: contracts/Address.sol
57 
58 pragma solidity ^0.5.0;
59 
60 
61 /**
62  * Utility library of inline functions on addresses
63  */
64 library Address {
65 
66     /**
67      * Returns whether the target address is a contract
68      * @dev This function will return false if invoked during the constructor of a contract,
69      * as the code is not actually created until after the constructor finishes.
70      * @param account address of the account to check
71      * @return whether the target address is a contract
72      */
73     function isContract(address account) internal view returns (bool) {
74         uint256 size;
75         // XXX Currently there is no better way to check if there is a contract in an address
76         // than to check the size of the code at that address.
77         // See https://ethereum.stackexchange.com/a/14016/36603
78         // for more details about how this works.
79         // TODO Check this again before the Serenity release, because all addresses will be
80         // contracts then.
81         // solium-disable-next-line security/no-inline-assembly
82         assembly { size := extcodesize(account) }
83         return size > 0;
84     }
85 
86 }
87 
88 // File: contracts/Common.sol
89 
90 pragma solidity ^0.5.0;
91 
92 /**
93     Note: Simple contract to use as base for const vals
94 */
95 contract CommonConstants {
96 
97     bytes4 constant internal ERC1155_ACCEPTED = 0xf23a6e61; // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
98     bytes4 constant internal ERC1155_BATCH_ACCEPTED = 0xbc197c81; // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
99 }
100 
101 // File: contracts/IERC1155TokenReceiver.sol
102 
103 pragma solidity ^0.5.0;
104 
105 /**
106     Note: The ERC-165 identifier for this interface is 0x4e2312e0.
107 */
108 interface ERC1155TokenReceiver {
109     /**
110         @notice Handle the receipt of a single ERC1155 token type.
111         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
112         This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
113         This function MUST revert if it rejects the transfer.
114         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
115         @param _operator  The address which initiated the transfer (i.e. msg.sender)
116         @param _from      The address which previously owned the token
117         @param _id        The ID of the token being transferred
118         @param _value     The amount of tokens being transferred
119         @param _data      Additional data with no specified format
120         @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
121     */
122     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external returns(bytes4);
123 
124     /**
125         @notice Handle the receipt of multiple ERC1155 token types.
126         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
127         This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
128         This function MUST revert if it rejects the transfer(s).
129         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
130         @param _operator  The address which initiated the batch transfer (i.e. msg.sender)
131         @param _from      The address which previously owned the token
132         @param _ids       An array containing ids of each token being transferred (order and length must match _values array)
133         @param _values    An array containing amounts of each token being transferred (order and length must match _ids array)
134         @param _data      Additional data with no specified format
135         @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
136     */
137     function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external returns(bytes4);
138 }
139 
140 // File: contracts/ERC165.sol
141 
142 pragma solidity ^0.5.0;
143 
144 
145 /**
146  * @title ERC165
147  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
148  */
149 interface ERC165 {
150 
151     /**
152      * @notice Query if a contract implements an interface
153      * @param _interfaceId The interface identifier, as specified in ERC-165
154      * @dev Interface identification is specified in ERC-165. This function
155      * uses less than 30,000 gas.
156      */
157     function supportsInterface(bytes4 _interfaceId)
158     external
159     view
160     returns (bool);
161 }
162 
163 // File: contracts/IERC1155.sol
164 
165 pragma solidity ^0.5.0;
166 
167 
168 /**
169     @title ERC-1155 Multi Token Standard
170     @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md
171     Note: The ERC-165 identifier for this interface is 0xd9b67a26.
172  */
173 interface IERC1155 /* is ERC165 */ {
174     /**
175         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
176         The `_operator` argument MUST be msg.sender.
177         The `_from` argument MUST be the address of the holder whose balance is decreased.
178         The `_to` argument MUST be the address of the recipient whose balance is increased.
179         The `_id` argument MUST be the token type being transferred.
180         The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.
181         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
182         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
183     */
184     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
185 
186     /**
187         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
188         The `_operator` argument MUST be msg.sender.
189         The `_from` argument MUST be the address of the holder whose balance is decreased.
190         The `_to` argument MUST be the address of the recipient whose balance is increased.
191         The `_ids` argument MUST be the list of tokens being transferred.
192         The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.
193         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
194         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
195     */
196     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
197 
198     /**
199         @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absense of an event assumes disabled).
200     */
201     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
202 
203     /**
204         @dev MUST emit when the URI is updated for a token ID.
205         URIs are defined in RFC 3986.
206         The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
207     */
208     event URI(string _value, uint256 indexed _id);
209 
210     /**
211         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
212         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
213         MUST revert if `_to` is the zero address.
214         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
215         MUST revert on any other error.
216         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
217         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
218         @param _from    Source address
219         @param _to      Target address
220         @param _id      ID of the token type
221         @param _value   Transfer amount
222         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
223     */
224     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;
225 
226     /**
227         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
228         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
229         MUST revert if `_to` is the zero address.
230         MUST revert if length of `_ids` is not the same as length of `_values`.
231         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
232         MUST revert on any other error.
233         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
234         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
235         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
236         @param _from    Source address
237         @param _to      Target address
238         @param _ids     IDs of each token type (order and length must match _values array)
239         @param _values  Transfer amounts per token type (order and length must match _ids array)
240         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
241     */
242     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external;
243 
244     /**
245         @notice Get the balance of an account's Tokens.
246         @param _owner  The address of the token holder
247         @param _id     ID of the Token
248         @return        The _owner's balance of the Token type requested
249      */
250     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
251 
252     /**
253         @notice Get the balance of multiple account/token pairs
254         @param _owners The addresses of the token holders
255         @param _ids    ID of the Tokens
256         @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
257      */
258     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
259 
260     /**
261         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
262         @dev MUST emit the ApprovalForAll event on success.
263         @param _operator  Address to add to the set of authorized operators
264         @param _approved  True if the operator is approved, false to revoke approval
265     */
266     function setApprovalForAll(address _operator, bool _approved) external;
267 
268     /**
269         @notice Queries the approval status of an operator for a given owner.
270         @param _owner     The owner of the Tokens
271         @param _operator  Address of authorized operator
272         @return           True if the operator is approved, false if not
273     */
274     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
275 }
276 
277 // File: contracts/ERC1155.sol
278 
279 pragma solidity ^0.5.0;
280 
281 
282 
283 
284 
285 
286 // A sample implementation of core ERC1155 function.
287 contract ERC1155 is IERC1155, ERC165, CommonConstants
288 {
289     using SafeMath for uint256;
290     using Address for address;
291 
292     // id => (owner => balance)
293     mapping (uint256 => mapping(address => uint256)) internal balances;
294 
295     // owner => (operator => approved)
296     mapping (address => mapping(address => bool)) internal operatorApproval;
297 
298 /////////////////////////////////////////// ERC165 //////////////////////////////////////////////
299 
300     /*
301         bytes4(keccak256('supportsInterface(bytes4)'));
302     */
303     bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
304 
305     /*
306         bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
307         bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
308         bytes4(keccak256("balanceOf(address,uint256)")) ^
309         bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
310         bytes4(keccak256("setApprovalForAll(address,bool)")) ^
311         bytes4(keccak256("isApprovedForAll(address,address)"));
312     */
313     bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
314 
315     function supportsInterface(bytes4 _interfaceId)
316     public
317     view
318     returns (bool) {
319          if (_interfaceId == INTERFACE_SIGNATURE_ERC165 ||
320              _interfaceId == INTERFACE_SIGNATURE_ERC1155) {
321             return true;
322          }
323 
324          return false;
325     }
326 
327 /////////////////////////////////////////// ERC1155 //////////////////////////////////////////////
328 
329     /**
330         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
331         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
332         MUST revert if `_to` is the zero address.
333         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
334         MUST revert on any other error.
335         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
336         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
337         @param _from    Source address
338         @param _to      Target address
339         @param _id      ID of the token type
340         @param _value   Transfer amount
341         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
342     */
343     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external {
344 
345         require(_to != address(0x0), "_to must be non-zero.");
346         require(_from == msg.sender || operatorApproval[_from][msg.sender] == true, "Need operator approval for 3rd party transfers.");
347 
348         // SafeMath will throw with insuficient funds _from
349         // or if _id is not valid (balance will be 0)
350         balances[_id][_from] = balances[_id][_from].sub(_value);
351         balances[_id][_to]   = _value.add(balances[_id][_to]);
352 
353         // MUST emit event
354         emit TransferSingle(msg.sender, _from, _to, _id, _value);
355 
356         // Now that the balance is updated and the event was emitted,
357         // call onERC1155Received if the destination is a contract.
358         if (_to.isContract()) {
359             _doSafeTransferAcceptanceCheck(msg.sender, _from, _to, _id, _value, _data);
360         }
361     }
362 
363     /**
364         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
365         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
366         MUST revert if `_to` is the zero address.
367         MUST revert if length of `_ids` is not the same as length of `_values`.
368         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
369         MUST revert on any other error.
370         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
371         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
372         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
373         @param _from    Source address
374         @param _to      Target address
375         @param _ids     IDs of each token type (order and length must match _values array)
376         @param _values  Transfer amounts per token type (order and length must match _ids array)
377         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
378     */
379     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external {
380 
381         // MUST Throw on errors
382         require(_to != address(0x0), "destination address must be non-zero.");
383         require(_ids.length == _values.length, "_ids and _values array lenght must match.");
384         require(_from == msg.sender || operatorApproval[_from][msg.sender] == true, "Need operator approval for 3rd party transfers.");
385 
386         for (uint256 i = 0; i < _ids.length; ++i) {
387             uint256 id = _ids[i];
388             uint256 value = _values[i];
389 
390             // SafeMath will throw with insuficient funds _from
391             // or if _id is not valid (balance will be 0)
392             balances[id][_from] = balances[id][_from].sub(value);
393             balances[id][_to]   = value.add(balances[id][_to]);
394         }
395 
396         // Note: instead of the below batch versions of event and acceptance check you MAY have emitted a TransferSingle
397         // event and a subsequent call to _doSafeTransferAcceptanceCheck in above loop for each balance change instead.
398         // Or emitted a TransferSingle event for each in the loop and then the single _doSafeBatchTransferAcceptanceCheck below.
399         // However it is implemented the balance changes and events MUST match when a check (i.e. calling an external contract) is done.
400 
401         // MUST emit event
402         emit TransferBatch(msg.sender, _from, _to, _ids, _values);
403 
404         // Now that the balances are updated and the events are emitted,
405         // call onERC1155BatchReceived if the destination is a contract.
406         if (_to.isContract()) {
407             _doSafeBatchTransferAcceptanceCheck(msg.sender, _from, _to, _ids, _values, _data);
408         }
409     }
410 
411     /**
412         @notice Get the balance of an account's Tokens.
413         @param _owner  The address of the token holder
414         @param _id     ID of the Token
415         @return        The _owner's balance of the Token type requested
416      */
417     function balanceOf(address _owner, uint256 _id) external view returns (uint256) {
418         // The balance of any account can be calculated from the Transfer events history.
419         // However, since we need to keep the balances to validate transfer request,
420         // there is no extra cost to also privide a querry function.
421         return balances[_id][_owner];
422     }
423 
424 
425     /**
426         @notice Get the balance of multiple account/token pairs
427         @param _owners The addresses of the token holders
428         @param _ids    ID of the Tokens
429         @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
430      */
431     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory) {
432 
433         require(_owners.length == _ids.length);
434 
435         uint256[] memory balances_ = new uint256[](_owners.length);
436 
437         for (uint256 i = 0; i < _owners.length; ++i) {
438             balances_[i] = balances[_ids[i]][_owners[i]];
439         }
440 
441         return balances_;
442     }
443 
444     /**
445         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
446         @dev MUST emit the ApprovalForAll event on success.
447         @param _operator  Address to add to the set of authorized operators
448         @param _approved  True if the operator is approved, false to revoke approval
449     */
450     function setApprovalForAll(address _operator, bool _approved) external {
451         operatorApproval[msg.sender][_operator] = _approved;
452         emit ApprovalForAll(msg.sender, _operator, _approved);
453     }
454 
455     /**
456         @notice Queries the approval status of an operator for a given owner.
457         @param _owner     The owner of the Tokens
458         @param _operator  Address of authorized operator
459         @return           True if the operator is approved, false if not
460     */
461     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
462         return operatorApproval[_owner][_operator];
463     }
464 
465 /////////////////////////////////////////// Internal //////////////////////////////////////////////
466 
467     function _doSafeTransferAcceptanceCheck(address _operator, address _from, address _to, uint256 _id, uint256 _value, bytes memory _data) internal {
468 
469         // If this was a hybrid standards solution you would have to check ERC165(_to).supportsInterface(0x4e2312e0) here but as this is a pure implementation of an ERC-1155 token set as recommended by
470         // the standard, it is not necessary. The below should revert in all failure cases i.e. _to isn't a receiver, or it is and either returns an unknown value or it reverts in the call to indicate non-acceptance.
471 
472 
473         // Note: if the below reverts in the onERC1155Received function of the _to address you will have an undefined revert reason returned rather than the one in the require test.
474         // If you want predictable revert reasons consider using low level _to.call() style instead so the revert does not bubble up and you can revert yourself on the ERC1155_ACCEPTED test.
475         require(ERC1155TokenReceiver(_to).onERC1155Received(_operator, _from, _id, _value, _data) == ERC1155_ACCEPTED, "contract returned an unknown value from onERC1155Received");
476     }
477 
478     function _doSafeBatchTransferAcceptanceCheck(address _operator, address _from, address _to, uint256[] memory _ids, uint256[] memory _values, bytes memory _data) internal {
479 
480         // If this was a hybrid standards solution you would have to check ERC165(_to).supportsInterface(0x4e2312e0) here but as this is a pure implementation of an ERC-1155 token set as recommended by
481         // the standard, it is not necessary. The below should revert in all failure cases i.e. _to isn't a receiver, or it is and either returns an unknown value or it reverts in the call to indicate non-acceptance.
482 
483         // Note: if the below reverts in the onERC1155BatchReceived function of the _to address you will have an undefined revert reason returned rather than the one in the require test.
484         // If you want predictable revert reasons consider using low level _to.call() style instead so the revert does not bubble up and you can revert yourself on the ERC1155_BATCH_ACCEPTED test.
485         require(ERC1155TokenReceiver(_to).onERC1155BatchReceived(_operator, _from, _ids, _values, _data) == ERC1155_BATCH_ACCEPTED, "contract returned an unknown value from onERC1155BatchReceived");
486     }
487 }
488 
489 // File: contracts/Ownable.sol
490 
491 pragma solidity ^0.5.0;
492 
493 /**
494  * @dev Contract module which provides a basic access control mechanism, where
495  * there is an account (an owner) that can be granted exclusive access to
496  * specific functions.
497  *
498  * This module is used through inheritance. It will make available the modifier
499  * `onlyOwner`, which can be applied to your functions to restrict their use to
500  * the owner.
501  */
502 contract Ownable {
503     address private _owner;
504 
505     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
506 
507     /**
508      * @dev Initializes the contract setting the deployer as the initial owner.
509      */
510     constructor () internal {
511         _owner = msg.sender;
512         emit OwnershipTransferred(address(0), _owner);
513     }
514 
515     /**
516      * @dev Returns the address of the current owner.
517      */
518     function owner() public view returns (address) {
519         return _owner;
520     }
521 
522     /**
523      * @dev Throws if called by any account other than the owner.
524      */
525     modifier onlyOwner() {
526         require(isOwner(), "Ownable: caller is not the owner");
527         _;
528     }
529 
530     /**
531      * @dev Returns true if the caller is the current owner.
532      */
533     function isOwner() public view returns (bool) {
534         return msg.sender == _owner;
535     }
536 
537     /**
538      * @dev Leaves the contract without owner. It will not be possible to call
539      * `onlyOwner` functions anymore. Can only be called by the current owner.
540      *
541      * > Note: Renouncing ownership will leave the contract without an owner,
542      * thereby removing any functionality that is only available to the owner.
543      */
544     function renounceOwnership() public onlyOwner {
545         emit OwnershipTransferred(_owner, address(0));
546         _owner = address(0);
547     }
548 
549     /**
550      * @dev Transfers ownership of the contract to a new account (`newOwner`).
551      * Can only be called by the current owner.
552      */
553     function transferOwnership(address newOwner) public onlyOwner {
554         _transferOwnership(newOwner);
555     }
556 
557     /**
558      * @dev Transfers ownership of the contract to a new account (`newOwner`).
559      */
560     function _transferOwnership(address newOwner) internal {
561         require(newOwner != address(0), "Ownable: new owner is the zero address");
562         emit OwnershipTransferred(_owner, newOwner);
563         _owner = newOwner;
564     }
565 }
566 
567 // File: contracts/Strings.sol
568 
569 pragma solidity ^0.5.0;
570 
571 library Strings {
572   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
573   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
574       bytes memory _ba = bytes(_a);
575       bytes memory _bb = bytes(_b);
576       bytes memory _bc = bytes(_c);
577       bytes memory _bd = bytes(_d);
578       bytes memory _be = bytes(_e);
579       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
580       bytes memory babcde = bytes(abcde);
581       uint k = 0;
582       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
583       for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
584       for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
585       for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
586       for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
587       return string(babcde);
588     }
589 
590     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
591         return strConcat(_a, _b, _c, _d, "");
592     }
593 
594     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
595         return strConcat(_a, _b, _c, "", "");
596     }
597 
598     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
599         return strConcat(_a, _b, "", "", "");
600     }
601 
602     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
603         if (_i == 0) {
604             return "0";
605         }
606         uint j = _i;
607         uint len;
608         while (j != 0) {
609             len++;
610             j /= 10;
611         }
612         bytes memory bstr = new bytes(len);
613         uint k = len - 1;
614         while (_i != 0) {
615             bstr[k--] = byte(uint8(48 + _i % 10));
616             _i /= 10;
617         }
618         return string(bstr);
619     }
620 }
621 
622 // File: contracts/RCContract.sol
623 
624 pragma solidity ^0.5.0;
625 
626 
627 
628 
629 /**
630     @dev Mintable form of ERC1155
631     Shows how easy it is to mint new items.
632 */
633 contract RCContract is ERC1155, Ownable {
634 
635     bytes4 constant private INTERFACE_SIGNATURE_URI = 0x0e89341c;
636 
637      // Token name
638     string private _contractName = 'ReceiptChain';
639 
640     // Token symbol
641     string private _symbol = 'RCPT';
642 
643     // Base URI
644     string private _baseURI = 'https://receiptchain.io/api/items/';
645 
646     // Total Supplies
647     mapping(uint256 => uint256) private _totalSupplies;
648 
649     // A nonce to ensure we have a unique id each time we mint.
650     uint256 public nonce;
651 
652         /**
653         @dev Must emit on creation
654         The `_name` Name at creation gives some human context to what this token is in the blockchain
655         The `_id` Id of token.
656     */
657     event CreationName(string _value, uint256 indexed _id);
658 
659     event Update(string _value, uint256 indexed _id);
660 
661     function supportsInterface(bytes4 _interfaceId)
662     public
663     view
664     returns (bool) {
665         if (_interfaceId == INTERFACE_SIGNATURE_URI) {
666             return true;
667         } else {
668             return super.supportsInterface(_interfaceId);
669         }
670     }
671 
672     // Creates a new token type and assings _initialSupply to minter
673     function create(uint256 _initialSupply, address _to, string calldata _name) external onlyOwner returns (uint256 _id) {
674 
675         _id = _create(_initialSupply, _to, _name); 
676 
677     }
678 
679     // Creates a new token type and assings _initialSupply to minter
680     function _create(uint256 _initialSupply, address _to, string memory _name) internal returns (uint256 _id) {
681 
682         _id = ++nonce;
683         balances[_id][_to] = _initialSupply;
684         _totalSupplies[_id] = _initialSupply;
685 
686         // Transfer event with mint semantic
687         emit TransferSingle(msg.sender, address(0x0), _to, _id, _initialSupply);
688 
689         emit URI(string(abi.encodePacked(baseTokenURI(),Strings.uint2str(_id))), _id);
690 
691         if (bytes(_name).length > 0)
692             emit CreationName(_name, _id);
693 
694     }
695 
696     // Batch mint tokens. Assign directly to _to[].
697     function batchCreate(uint256[] calldata _initialSupplies, address[] calldata _to, string calldata _name) external onlyOwner {
698         
699         for (uint256 i = 0; i < _to.length; ++i) {
700             _create(_initialSupplies[i], _to[i], _name); 
701         }
702 
703     }
704 
705     function setBaseURI(string calldata uri) external onlyOwner {
706         _baseURI = uri;
707     }
708 
709     function update(string calldata _update, uint256 _id) external onlyOwner {
710         emit Update(_update, _id);
711     }
712 
713     function baseTokenURI() public view returns (string memory) {
714         return _baseURI;
715     }
716 
717     function uri(uint256 _id) external view returns (string memory) {
718         return string(abi.encodePacked(baseTokenURI(),Strings.uint2str(_id)));
719     }
720 
721     function tokenURI(uint256 _id) external view returns (string memory) {
722         return string(abi.encodePacked(baseTokenURI(),Strings.uint2str(_id)));
723     }
724 
725     /**
726      * @dev Gets the token name.
727      * @return string representing the token name
728      */
729     function name() external view returns (string memory) {
730         return _contractName;
731     }
732 
733     /**
734      * @dev Gets the token symbol.
735      * @return string representing the token symbol
736      */
737     function symbol() external view returns (string memory) {
738         return _symbol;
739     }
740 
741     /// @notice Returns the total token supply.
742     /// @dev Throws if '_tokenType' is not a valid SFT
743     /// @param _id The type of SFT to get the totalSupply of. Must be less than the return value of totalTokenTypes
744     /// @return The total supply of the given SFT
745     function totalSupply(uint256 _id) external view returns (uint256) {
746         return _totalSupplies[_id];
747     }
748 
749     /// @notice Returns the total number of token types for this contract
750     /// @dev Can possibly be zero
751     /// @return The total number of token types
752     function totalTokenTypes() external view returns (uint256) {
753         return nonce;
754     }
755 }