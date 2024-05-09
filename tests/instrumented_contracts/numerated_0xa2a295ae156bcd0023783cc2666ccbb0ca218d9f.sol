1 pragma solidity ^0.5.0;
2 
3 pragma solidity ^0.5.0;
4 
5 pragma solidity ^0.5.0;
6 
7 pragma solidity ^0.5.0;
8 
9 
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that throw on error
13  */
14 library SafeMath {
15 
16     /**
17     * @dev Multiplies two numbers, throws on overflow.
18     */
19     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
21         // benefit is lost if 'b' is also tested.
22         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
23         if (a == 0) {
24             return 0;
25         }
26 
27         c = a * b;
28         assert(c / a == b);
29         return c;
30     }
31 
32     /**
33     * @dev Integer division of two numbers, truncating the quotient.
34     */
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         // assert(b > 0); // Solidity automatically throws when dividing by 0
37         // uint256 c = a / b;
38         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39         return a / b;
40     }
41 
42     /**
43     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44     */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         assert(b <= a);
47         return a - b;
48     }
49 
50     /**
51     * @dev Adds two numbers, throws on overflow.
52     */
53     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
54         c = a + b;
55         assert(c >= a);
56         return c;
57     }
58 }
59 
60 pragma solidity ^0.5.0;
61 
62 
63 /**
64  * Utility library of inline functions on addresses
65  */
66 library Address {
67 
68     /**
69      * Returns whether the target address is a contract
70      * @dev This function will return false if invoked during the constructor of a contract,
71      * as the code is not actually created until after the constructor finishes.
72      * @param account address of the account to check
73      * @return whether the target address is a contract
74      */
75     function isContract(address account) internal view returns (bool) {
76         uint256 size;
77         // XXX Currently there is no better way to check if there is a contract in an address
78         // than to check the size of the code at that address.
79         // See https://ethereum.stackexchange.com/a/14016/36603
80         // for more details about how this works.
81         // TODO Check this again before the Serenity release, because all addresses will be
82         // contracts then.
83         // solium-disable-next-line security/no-inline-assembly
84         assembly { size := extcodesize(account) }
85         return size > 0;
86     }
87 
88 }
89 
90 pragma solidity ^0.5.0;
91 
92 /**
93     Note: Simple contract to use as base for const vals
94 */
95 contract CommonConstants {
96 
97     bytes4 constant internal ERC1155_ACCEPTED = 0x4dc21a2f; // keccak256("accept_erc1155_tokens()")
98     bytes4 constant internal ERC1155_BATCH_ACCEPTED = 0xac007889; // keccak256("accept_batch_erc1155_tokens()")
99 }
100 
101 pragma solidity ^0.5.0;
102 
103 /**
104     Note: The ERC-165 identifier for this interface is 0x43b236a2.
105 */
106 interface IERC1155TokenReceiver {
107 
108     /**
109         @notice Handle the receipt of a single ERC1155 token type.
110         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
111         This function MUST return `bytes4(keccak256("accept_erc1155_tokens()"))` (i.e. 0x4dc21a2f) if it accepts the transfer.
112         This function MUST revert if it rejects the transfer.
113         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
114         @param _operator  The address which initiated the transfer (i.e. msg.sender)
115         @param _from      The address which previously owned the token
116         @param _id        The id of the token being transferred
117         @param _value     The amount of tokens being transferred
118         @param _data      Additional data with no specified format
119         @return           `bytes4(keccak256("accept_erc1155_tokens()"))`
120     */
121     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external returns(bytes4);
122 
123     /**
124         @notice Handle the receipt of multiple ERC1155 token types.
125         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
126         This function MUST return `bytes4(keccak256("accept_batch_erc1155_tokens()"))` (i.e. 0xac007889) if it accepts the transfer(s).
127         This function MUST revert if it rejects the transfer(s).
128         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
129         @param _operator  The address which initiated the batch transfer (i.e. msg.sender)
130         @param _from      The address which previously owned the token
131         @param _ids       An array containing ids of each token being transferred (order and length must match _values array)
132         @param _values    An array containing amounts of each token being transferred (order and length must match _ids array)
133         @param _data      Additional data with no specified format
134         @return           `bytes4(keccak256("accept_batch_erc1155_tokens()"))`
135     */
136     function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external returns(bytes4);
137 
138     /**
139         @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
140         @dev This function MUST return `bytes4(keccak256("isERC1155TokenReceiver()"))` (i.e. 0x0d912442).
141         This function MUST NOT consume more than 5,000 gas.
142         @return           `bytes4(keccak256("isERC1155TokenReceiver()"))`
143     */
144     function isERC1155TokenReceiver() external view returns (bytes4);
145 }
146 
147 pragma solidity ^0.5.0;
148 
149 pragma solidity ^0.5.0;
150 
151 
152 /**
153  * @title ERC165
154  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
155  */
156 interface ERC165 {
157 
158     /**
159      * @notice Query if a contract implements an interface
160      * @param _interfaceId The interface identifier, as specified in ERC-165
161      * @dev Interface identification is specified in ERC-165. This function
162      * uses less than 30,000 gas.
163      */
164     function supportsInterface(bytes4 _interfaceId)
165     external
166     view
167     returns (bool);
168 }
169 
170 
171 /**
172     @title ERC-1155 Multi Token Standard
173     @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md
174     Note: The ERC-165 identifier for this interface is 0xd9b67a26.
175  */
176 interface IERC1155 /* is ERC165 */ {
177     /**
178         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
179         The `_operator` argument MUST be msg.sender.
180         The `_from` argument MUST be the address of the holder whose balance is decreased.
181         The `_to` argument MUST be the address of the recipient whose balance is increased.
182         The `_id` argument MUST be the token type being transferred.
183         The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.
184         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
185         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
186     */
187     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
188 
189     /**
190         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
191         The `_operator` argument MUST be msg.sender.
192         The `_from` argument MUST be the address of the holder whose balance is decreased.
193         The `_to` argument MUST be the address of the recipient whose balance is increased.
194         The `_ids` argument MUST be the list of tokens being transferred.
195         The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.
196         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
197         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
198     */
199     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
200 
201     /**
202         @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absense of an event assumes disabled).
203     */
204     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
205 
206     /**
207         @dev MUST emit when the URI is updated for a token ID.
208         URIs are defined in RFC 3986.
209         The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
210 
211         The URI value allows for ID substitution by clients. If the string {id} exists in any URI,
212         clients MUST replace this with the actual token ID in hexadecimal form.
213     */
214     event URI(string _value, uint256 indexed _id);
215 
216     /**
217         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
218         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
219         MUST revert if `_to` is the zero address.
220         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
221         MUST revert on any other error.
222         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
223         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
224         @param _from    Source address
225         @param _to      Target address
226         @param _id      ID of the token type
227         @param _value   Transfer amount
228         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
229     */
230     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;
231 
232     /**
233         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
234         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
235         MUST revert if `_to` is the zero address.
236         MUST revert if length of `_ids` is not the same as length of `_values`.
237         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
238         MUST revert on any other error.
239         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
240         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
241         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
242         @param _from    Source address
243         @param _to      Target address
244         @param _ids     IDs of each token type (order and length must match _values array)
245         @param _values  Transfer amounts per token type (order and length must match _ids array)
246         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
247     */
248     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external;
249 
250     /**
251         @notice Get the balance of an account's Tokens.
252         @param _owner  The address of the token holder
253         @param _id     ID of the Token
254         @return        The _owner's balance of the Token type requested
255      */
256     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
257 
258     /**
259         @notice Get the balance of multiple account/token pairs
260         @param _owners The addresses of the token holders
261         @param _ids    ID of the Tokens
262         @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
263      */
264     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
265 
266     /**
267         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
268         @dev MUST emit the ApprovalForAll event on success.
269         @param _operator  Address to add to the set of authorized operators
270         @param _approved  True if the operator is approved, false to revoke approval
271     */
272     function setApprovalForAll(address _operator, bool _approved) external;
273 
274     /**
275         @notice Queries the approval status of an operator for a given owner.
276         @param _owner     The owner of the Tokens
277         @param _operator  Address of authorized operator
278         @return           True if the operator is approved, false if not
279     */
280     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
281 }
282 
283 
284 // A sample implementation of core ERC1155 function.
285 contract ERC1155 is IERC1155, ERC165, CommonConstants
286 {
287     using SafeMath for uint256;
288     using Address for address;
289 
290     // id => (owner => balance)
291     mapping (uint256 => mapping(address => uint256)) internal balances;
292 
293     // owner => (operator => approved)
294     mapping (address => mapping(address => bool)) internal operatorApproval;
295 
296 /////////////////////////////////////////// ERC165 //////////////////////////////////////////////
297 
298     /*
299         bytes4(keccak256('supportsInterface(bytes4)'));
300     */
301     bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
302 
303     /*
304         bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
305         bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
306         bytes4(keccak256("balanceOf(address,uint256)")) ^
307         bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
308         bytes4(keccak256("setApprovalForAll(address,bool)")) ^
309         bytes4(keccak256("isApprovedForAll(address,address)"));
310     */
311     bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
312 
313     function supportsInterface(bytes4 _interfaceId)
314     public
315     view
316     returns (bool) {
317          if (_interfaceId == INTERFACE_SIGNATURE_ERC165 ||
318              _interfaceId == INTERFACE_SIGNATURE_ERC1155) {
319             return true;
320          }
321 
322          return false;
323     }
324 
325 /////////////////////////////////////////// ERC1155 //////////////////////////////////////////////
326 
327     /**
328         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
329         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
330         MUST revert if `_to` is the zero address.
331         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
332         MUST revert on any other error.
333         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
334         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
335         @param _from    Source address
336         @param _to      Target address
337         @param _id      ID of the token type
338         @param _value   Transfer amount
339         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
340     */
341     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external {
342 
343         require(_to != address(0x0), "_to must be non-zero.");
344         require(_from == msg.sender || operatorApproval[_from][msg.sender] == true, "Need operator approval for 3rd party transfers.");
345 
346         // SafeMath will throw with insuficient funds _from
347         // or if _id is not valid (balance will be 0)
348         balances[_id][_from] = balances[_id][_from].sub(_value);
349         balances[_id][_to]   = _value.add(balances[_id][_to]);
350 
351         // MUST emit event
352         emit TransferSingle(msg.sender, _from, _to, _id, _value);
353 
354         // Now that the balance is updated and the event was emitted,
355         // call onERC1155Received if the destination is a contract.
356         if (_to.isContract()) {
357             _doSafeTransferAcceptanceCheck(msg.sender, _from, _to, _id, _value, _data);
358         }
359     }
360 
361     /**
362         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
363         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
364         MUST revert if `_to` is the zero address.
365         MUST revert if length of `_ids` is not the same as length of `_values`.
366         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
367         MUST revert on any other error.
368         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
369         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
370         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
371         @param _from    Source address
372         @param _to      Target address
373         @param _ids     IDs of each token type (order and length must match _values array)
374         @param _values  Transfer amounts per token type (order and length must match _ids array)
375         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
376     */
377     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external {
378 
379         // MUST Throw on errors
380         require(_to != address(0x0), "destination address must be non-zero.");
381         require(_ids.length == _values.length, "_ids and _values array lenght must match.");
382         require(_from == msg.sender || operatorApproval[_from][msg.sender] == true, "Need operator approval for 3rd party transfers.");
383 
384         for (uint256 i = 0; i < _ids.length; ++i) {
385             uint256 id = _ids[i];
386             uint256 value = _values[i];
387 
388             // SafeMath will throw with insuficient funds _from
389             // or if _id is not valid (balance will be 0)
390             balances[id][_from] = balances[id][_from].sub(value);
391             balances[id][_to]   = value.add(balances[id][_to]);
392         }
393 
394         // Note: instead of the below batch versions of event and acceptance check you MAY have emitted a TransferSingle
395         // event and a subsequent call to _doSafeTransferAcceptanceCheck in above loop for each balance change instead.
396         // Or emitted a TransferSingle event for each in the loop and then the single _doSafeBatchTransferAcceptanceCheck below.
397         // However it is implemented the balance changes and events MUST match when a check (i.e. calling an external contract) is done.
398 
399         // MUST emit event
400         emit TransferBatch(msg.sender, _from, _to, _ids, _values);
401 
402         // Now that the balances are updated and the events are emitted,
403         // call onERC1155BatchReceived if the destination is a contract.
404         if (_to.isContract()) {
405             _doSafeBatchTransferAcceptanceCheck(msg.sender, _from, _to, _ids, _values, _data);
406         }
407     }
408 
409     /**
410         @notice Get the balance of an account's Tokens.
411         @param _owner  The address of the token holder
412         @param _id     ID of the Token
413         @return        The _owner's balance of the Token type requested
414      */
415     function balanceOf(address _owner, uint256 _id) external view returns (uint256) {
416         // The balance of any account can be calculated from the Transfer events history.
417         // However, since we need to keep the balances to validate transfer request,
418         // there is no extra cost to also privide a querry function.
419         return balances[_id][_owner];
420     }
421 
422 
423     /**
424         @notice Get the balance of multiple account/token pairs
425         @param _owners The addresses of the token holders
426         @param _ids    ID of the Tokens
427         @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
428      */
429     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory) {
430 
431         require(_owners.length == _ids.length);
432 
433         uint256[] memory balances_ = new uint256[](_owners.length);
434 
435         for (uint256 i = 0; i < _owners.length; ++i) {
436             balances_[i] = balances[_ids[i]][_owners[i]];
437         }
438 
439         return balances_;
440     }
441 
442     /**
443         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
444         @dev MUST emit the ApprovalForAll event on success.
445         @param _operator  Address to add to the set of authorized operators
446         @param _approved  True if the operator is approved, false to revoke approval
447     */
448     function setApprovalForAll(address _operator, bool _approved) external {
449         operatorApproval[msg.sender][_operator] = _approved;
450         emit ApprovalForAll(msg.sender, _operator, _approved);
451     }
452 
453     /**
454         @notice Queries the approval status of an operator for a given owner.
455         @param _owner     The owner of the Tokens
456         @param _operator  Address of authorized operator
457         @return           True if the operator is approved, false if not
458     */
459     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
460         return operatorApproval[_owner][_operator];
461     }
462 
463 /////////////////////////////////////////// Internal //////////////////////////////////////////////
464 
465     function _doSafeTransferAcceptanceCheck(address _operator, address _from, address _to, uint256 _id, uint256 _value, bytes memory _data) internal {
466 
467         (bool success, bytes memory returnData) = _to.call(
468             abi.encodeWithSignature(
469                 "onERC1155Received(address,address,uint256,uint256,bytes)",
470                 _operator,
471                 _from,
472                 _id,
473                 _value,
474                 _data
475             )
476         );
477         (success); // ignore warning on unused var
478         bytes4 receiverRet = 0x0;
479         if(returnData.length > 0) {
480             assembly {
481                 receiverRet := mload(add(returnData, 32))
482             }
483         }
484 
485         if (receiverRet == ERC1155_ACCEPTED) {
486             // dest was a receiver and all good, do nothing.
487         } else {
488             // dest was a receiver and rejected, revert.
489             revert("Receiver contract did not accept the transfer.");
490         }
491     }
492 
493     function _doSafeBatchTransferAcceptanceCheck(address _operator, address _from, address _to, uint256[] memory _ids, uint256[] memory _values, bytes memory _data) internal {
494 
495         (bool success, bytes memory returnData) = _to.call(
496             abi.encodeWithSignature(
497                 "onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)",
498                 _operator,
499                 _from,
500                 _ids,
501                 _values,
502                 _data
503             )
504         );
505         (success); // ignore warning on unused var
506         bytes4 receiverRet = 0x0;
507         if(returnData.length > 0) {
508             assembly {
509                 receiverRet := mload(add(returnData, 32))
510             }
511         }
512 
513         if (receiverRet == ERC1155_BATCH_ACCEPTED) {
514             // dest was a receiver and all good, do nothing.
515         } else {
516             // dest was a receiver and rejected, revert.
517             revert("Receiver contract did not accept the transfer.");
518         }
519     }
520 }
521 
522 
523 /**
524     @dev Extension to ERC1155 for Mixed Fungible and Non-Fungible Items support
525     The main benefit is sharing of common type information, just like you do when
526     creating a fungible id.
527 */
528 contract ERC1155MixedFungible is ERC1155 {
529 
530     // Use a split bit implementation.
531     // Store the type in the upper 128 bits..
532     uint256 constant TYPE_MASK = uint256(uint128(~0)) << 128;
533 
534     // ..and the non-fungible index in the lower 128
535     uint256 constant NF_INDEX_MASK = uint128(~0);
536 
537     // The top bit is a flag to tell if this is a NFI.
538     uint256 constant public TYPE_NF_BIT = 1 << 255;
539 
540     uint256 constant NFT_MASK = (uint256(uint128(~0)) << 128) & ~uint256(1 << 255);
541 
542     // NFT ownership. Key is (_type | index), value - token owner address.
543     mapping (uint256 => address) nfOwners;
544 
545     // Only to make code clearer. Should not be functions
546     function isNonFungible(uint256 _id) public pure returns(bool) {
547         return _id & TYPE_NF_BIT == TYPE_NF_BIT;
548     }
549     function isFungible(uint256 _id) public pure returns(bool) {
550         return _id & TYPE_NF_BIT == 0;
551     }
552     function getNonFungibleIndex(uint256 _id) public pure returns(uint256) {
553         return _id & NF_INDEX_MASK;
554     }
555     function getNonFungibleBaseType(uint256 _id) public pure returns(uint256) {
556         return _id & TYPE_MASK;
557     }
558     function getNFTType(uint256 _id) public pure returns(uint256) {
559         return (_id & NFT_MASK) >> 128;
560     }
561     function isNonFungibleBaseType(uint256 _id) public pure returns(bool) {
562         // A base type has the NF bit but does not have an index.
563         return (_id & TYPE_NF_BIT == TYPE_NF_BIT) && (_id & NF_INDEX_MASK == 0);
564     }
565     function isNonFungibleItem(uint256 _id) public pure returns(bool) {
566         // A base type has the NF bit but does has an index.
567         return (_id & TYPE_NF_BIT == TYPE_NF_BIT) && (_id & NF_INDEX_MASK != 0);
568     }
569 
570     function ownerOf(uint256 _id) external view returns (address) {
571         return nfOwners[_id];
572     }
573 
574     function _ownerOf(uint256 _id) internal view returns (address) {
575         return nfOwners[_id];
576     }
577 
578     // override
579     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external {
580 
581         require(_to != address(0x0), "cannot send to zero address");
582         require(_from == msg.sender || operatorApproval[_from][msg.sender] == true, "Need operator approval for 3rd party transfers.");
583 
584         if (isNonFungible(_id)) {
585             require(nfOwners[_id] == _from);
586             nfOwners[_id] = _to;
587             // You could keep balance of NF type in base type id like so:
588             // uint256 baseType = getNonFungibleBaseType(_id);
589             // balances[baseType][_from] = balances[baseType][_from].sub(_value);
590             // balances[baseType][_to]   = balances[baseType][_to].add(_value);
591             onTransferNft(_from, _to, _id);
592         } else {
593             balances[_id][_from] = balances[_id][_from].sub(_value);
594             balances[_id][_to]   = balances[_id][_to].add(_value);
595             onTransfer20(_from, _to, _id, _value);
596         }
597 
598         emit TransferSingle(msg.sender, _from, _to, _id, _value);
599 
600         if (_to.isContract()) {
601             _doSafeTransferAcceptanceCheck(msg.sender, _from, _to, _id, _value, _data);
602         }
603     }
604 
605     function onTransferNft(address _from, address _to, uint256 _tokenId) internal {
606     }
607 
608     function onTransfer20(address _from, address _to, uint256 _type, uint256 _value) internal {
609     }
610 
611     // override
612     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external {
613 
614         require(_to != address(0x0), "cannot send to zero address");
615         require(_ids.length == _values.length, "Array length must match");
616 
617         // Only supporting a global operator approval allows us to do only 1 check and not to touch storage to handle allowances.
618         require(_from == msg.sender || operatorApproval[_from][msg.sender] == true, "Need operator approval for 3rd party transfers.");
619 
620         for (uint256 i = 0; i < _ids.length; ++i) {
621             // Cache value to local variable to reduce read costs.
622             uint256 id = _ids[i];
623             uint256 value = _values[i];
624 
625             if (isNonFungible(id)) {
626                 require(nfOwners[id] == _from);
627                 nfOwners[id] = _to;
628             } else {
629                 balances[id][_from] = balances[id][_from].sub(value);
630                 balances[id][_to]   = value.add(balances[id][_to]);
631             }
632         }
633 
634         emit TransferBatch(msg.sender, _from, _to, _ids, _values);
635 
636         if (_to.isContract()) {
637             _doSafeBatchTransferAcceptanceCheck(msg.sender, _from, _to, _ids, _values, _data);
638         }
639     }
640 
641     function balanceOf(address _owner, uint256 _id) external view returns (uint256) {
642         if (isNonFungibleItem(_id))
643             return nfOwners[_id] == _owner ? 1 : 0;
644         return balances[_id][_owner];
645     }
646 
647     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory) {
648 
649         require(_owners.length == _ids.length);
650 
651         uint256[] memory balances_ = new uint256[](_owners.length);
652 
653         for (uint256 i = 0; i < _owners.length; ++i) {
654             uint256 id = _ids[i];
655             if (isNonFungibleItem(id)) {
656                 balances_[i] = nfOwners[id] == _owners[i] ? 1 : 0;
657             } else {
658             	balances_[i] = balances[id][_owners[i]];
659             }
660         }
661 
662         return balances_;
663     }
664 }
665 
666 pragma solidity ^0.5.0;
667 
668 /**
669     Note: The ERC-165 identifier for this interface is 0x0e89341c.
670 */
671 interface ERC1155Metadata_URI {
672     /**
673         @notice A distinct Uniform Resource Identifier (URI) for a given token.
674         @dev URIs are defined in RFC 3986.
675         The URI may point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
676         @return URI string
677     */
678     function uri(uint256 _id) external view returns (string memory);
679 }
680 
681 pragma solidity ^0.5.0;
682 
683 pragma solidity ^0.5.0;
684 
685 contract Operators
686 {
687     mapping (address=>bool) ownerAddress;
688     mapping (address=>bool) operatorAddress;
689 
690     constructor() public
691     {
692         ownerAddress[msg.sender] = true;
693     }
694 
695     modifier onlyOwner()
696     {
697         require(ownerAddress[msg.sender]);
698         _;
699     }
700 
701     function isOwner(address _addr) public view returns (bool) {
702         return ownerAddress[_addr];
703     }
704 
705     function addOwner(address _newOwner) external onlyOwner {
706         require(_newOwner != address(0));
707 
708         ownerAddress[_newOwner] = true;
709     }
710 
711     function removeOwner(address _oldOwner) external onlyOwner {
712         delete(ownerAddress[_oldOwner]);
713     }
714 
715     modifier onlyOperator() {
716         require(isOperator(msg.sender));
717         _;
718     }
719 
720     function isOperator(address _addr) public view returns (bool) {
721         return operatorAddress[_addr] || ownerAddress[_addr];
722     }
723 
724     function addOperator(address _newOperator) external onlyOwner {
725         require(_newOperator != address(0));
726 
727         operatorAddress[_newOperator] = true;
728     }
729 
730     function removeOperator(address _oldOperator) external onlyOwner {
731         delete(operatorAddress[_oldOperator]);
732     }
733 }
734 
735 
736 contract ERC1155URIProvider is Operators
737 {
738     string public staticUri;
739 
740     function setUri(string calldata _uri) external onlyOwner
741     {
742         staticUri = _uri;
743     }
744 
745     function uri(uint256) external view returns (string memory)
746     {
747         return staticUri;
748     }
749 }
750 
751 pragma solidity ^0.5.0;
752 
753 interface IERC1155Mintable
754 {
755     function mintNonFungibleSingle(uint256 _type, address _to) external;
756     function mintNonFungible(uint256 _type, address[] calldata _to) external;
757     function mintFungibleSingle(uint256 _id, address _to, uint256 _quantity) external;
758     function mintFungible(uint256 _id, address[] calldata _to, uint256[] calldata _quantities) external;
759 }
760 
761 
762 pragma solidity ^0.5.0;
763 
764 // ----------------------------------------------------------------------------
765 contract ERC20 {
766 
767     function balanceOf(address tokenOwner) external view returns (uint balance);
768     function transfer(address to, uint tokens) external returns (bool success);
769 }
770 
771 pragma solidity ^0.5.0;
772 
773 /// @title ERC-721 Non-Fungible Token Standard
774 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
775 ///  Note: the ERC-165 identifier for this interface is 0x6466353c
776 interface ERC721Proxy /*is ERC165*/ {
777 
778     /// @notice Query if a contract implements an interface
779     /// @param interfaceID The interface identifier, as specified in ERC-165
780     /// @dev Interface identification is specified in ERC-165. This function
781     ///  uses less than 30,000 gas.
782     /// @return `true` if the contract implements `interfaceID` and
783     ///  `interfaceID` is not 0xffffffff, `false` otherwise
784     function supportsInterface(bytes4 interfaceID) external view returns (bool);
785 
786     /// @dev This emits when ownership of any NFT changes by any mechanism.
787     ///  This event emits when NFTs are created (`from` == 0) and destroyed
788     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
789     ///  may be created and assigned without emitting Transfer. At the time of
790     ///  any transfer, the approved address for that NFT (if any) is reset to none.
791     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
792 
793     /// @dev This emits when the approved address for an NFT is changed or
794     ///  reaffirmed. The zero address indicates there is no approved address.
795     ///  When a Transfer event emits, this also indicates that the approved
796     ///  address for that NFT (if any) is reset to none.
797     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
798 
799     /// @dev This emits when an operator is enabled or disabled for an owner.
800     ///  The operator can manage all NFTs of the owner.
801     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
802 
803     /// @notice Count all NFTs assigned to an owner
804     /// @dev NFTs assigned to the zero address are considered invalid, and this
805     ///  function throws for queries about the zero address.
806     /// @param _owner An address for whom to query the balance
807     /// @return The number of NFTs owned by `_owner`, possibly zero
808     function balanceOf(address _owner) external view returns (uint256);
809 
810     /// @notice Find the owner of an NFT
811     /// @param _tokenId The identifier for an NFT
812     /// @dev NFTs assigned to zero address are considered invalid, and queries
813     ///  about them do throw.
814     /// @return The address of the owner of the NFT
815     function ownerOf(uint256 _tokenId) external view returns (address);
816 
817     /// @notice Transfers the ownership of an NFT from one address to another address
818     /// @dev Throws unless `msg.sender` is the current owner, an authorized
819     ///  operator, or the approved address for this NFT. Throws if `_from` is
820     ///  not the current owner. Throws if `_to` is the zero address. Throws if
821     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
822     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
823     ///  `onERC721Received` on `_to` and throws if the return value is not
824     ///  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
825     /// @param _from The current owner of the NFT
826     /// @param _to The new owner
827     /// @param _tokenId The NFT to transfer
828     /// @param data Additional data with no specified format, sent in call to `_to`
829     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external;
830 
831     /// @notice Transfers the ownership of an NFT from one address to another address
832     /// @dev This works identically to the other function with an extra data parameter,
833     ///  except this function just sets data to ""
834     /// @param _from The current owner of the NFT
835     /// @param _to The new owner
836     /// @param _tokenId The NFT to transfer
837     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
838 
839     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
840     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
841     ///  THEY MAY BE PERMANENTLY LOST
842     /// @dev Throws unless `msg.sender` is the current owner, an authorized
843     ///  operator, or the approved address for this NFT. Throws if `_from` is
844     ///  not the current owner. Throws if `_to` is the zero address. Throws if
845     ///  `_tokenId` is not a valid NFT.
846     /// @param _from The current owner of the NFT
847     /// @param _to The new owner
848     /// @param _tokenId The NFT to transfer
849     function transferFrom(address _from, address _to, uint256 _tokenId) external;
850 
851     /// @notice Set or reaffirm the approved address for an NFT
852     /// @dev The zero address indicates there is no approved address.
853     /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
854     ///  operator of the current owner.
855     /// @param _approved The new approved NFT controller
856     /// @param _tokenId The NFT to approve
857     function approve(address _approved, uint256 _tokenId) external;
858 
859     /// @notice Enable or disable approval for a third party ("operator") to manage
860     ///  all your asset.
861     /// @dev Emits the ApprovalForAll event
862     /// @param _operator Address to add to the set of authorized operators.
863     /// @param _approved True if the operators is approved, false to revoke approval
864     function setApprovalForAll(address _operator, bool _approved) external;
865 
866     /// @notice Get the approved address for a single NFT
867     /// @dev Throws if `_tokenId` is not a valid NFT
868     /// @param _tokenId The NFT to find the approved address for
869     /// @return The approved address for this NFT, or the zero address if there is none
870     function getApproved(uint256 _tokenId) external view returns (address);
871 
872     /// @notice Query if an address is an authorized operator for another address
873     /// @param _owner The address that owns the NFTs
874     /// @param _operator The address that acts on behalf of the owner
875     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
876     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
877 
878 
879     /// @notice A descriptive name for a collection of NFTs in this contract
880     function name() external view returns (string memory _name);
881 
882     /// @notice An abbreviated name for NFTs in this contract
883     function symbol() external view returns (string memory _symbol);
884 
885 
886     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
887     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
888     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
889     ///  Metadata JSON Schema".
890     function tokenURI(uint256 _tokenId) external view returns (string memory);
891 
892     /// @notice Count NFTs tracked by this contract
893     /// @return A count of valid NFTs tracked by this contract, where each one of
894     ///  them has an assigned and queryable owner not equal to the zero address
895     function totalSupply() external view returns (uint256);
896 
897     /// @notice Enumerate valid NFTs
898     /// @dev Throws if `_index` >= `totalSupply()`.
899     /// @param _index A counter less than `totalSupply()`
900     /// @return The token identifier for the `_index`th NFT,
901     ///  (sort order not specified)
902     function tokenByIndex(uint256 _index) external view returns (uint256);
903 
904     /// @notice Enumerate NFTs assigned to an owner
905     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
906     ///  `_owner` is the zero address, representing invalid NFTs.
907     /// @param _owner An address where we are interested in NFTs owned by them
908     /// @param _index A counter less than `balanceOf(_owner)`
909     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
910     ///   (sort order not specified)
911     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
912 
913     /// @notice Transfers a Token to another address. When transferring to a smart
914     ///  contract, ensure that it is aware of ERC-721, otherwise the Token may be lost forever.
915     /// @param _to The address of the recipient, can be a user or contract.
916     /// @param _tokenId The ID of the Token to transfer.
917     function transfer(address _to, uint256 _tokenId) external;
918 
919     function onTransfer(address _from, address _to, uint256 _nftIndex) external;
920 }
921 
922 pragma solidity ^0.5.0;
923 
924 // ----------------------------------------------------------------------------
925 contract ERC20Proxy {
926     function totalSupply() external view returns (uint);
927     function balanceOf(address tokenOwner) external view returns (uint balance);
928     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
929     function transfer(address to, uint tokens) external returns (bool success);
930     function approve(address spender, uint tokens) external returns (bool success);
931     function transferFrom(address from, address to, uint tokens) external returns (bool success);
932     event Transfer(address indexed from, address indexed to, uint tokens);
933     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
934 
935     function onTransfer(address _from, address _to, uint256 _value) external;
936 }
937 
938 pragma solidity ^0.5.0;
939 
940 interface MintCallbackInterface
941 {
942     function onMint(uint256 id) external;
943 }
944 
945 
946 /**
947     @title Blockchain Cuties Collectible contract.
948     @dev Mixed Fungible Mintable form of ERC1155
949     Shows how easy it is to mint new items
950     @author https://BlockChainArchitect.io + Enjin
951 */
952 contract BlockchainCutiesERC1155 is ERC1155MixedFungible, Operators, ERC1155Metadata_URI, IERC1155Mintable {
953 
954     mapping (uint256 => uint256) public maxIndex;
955 
956     mapping(uint256 => ERC721Proxy) public proxy721;
957     mapping(uint256 => ERC20Proxy) public proxy20;
958     mapping(uint256 => bool) public disallowSetProxy721;
959     mapping(uint256 => bool) public disallowSetProxy20;
960     MintCallbackInterface public mintCallback;
961 
962     bytes4 constant private INTERFACE_SIGNATURE_ERC1155_URI = 0x0e89341c;
963 
964     function supportsInterface(bytes4 _interfaceId) public view returns (bool) {
965         return
966             super.supportsInterface(_interfaceId) ||
967             _interfaceId == INTERFACE_SIGNATURE_ERC1155_URI;
968     }
969 
970     // This function only creates the type.
971     // _type must be shifted by 128 bits left
972     // for NFT TYPE_NF_BIT should be added to _type
973     function create(uint256 _type) onlyOwner external
974     {
975         // emit a Transfer event with Create semantic to help with discovery.
976         emit TransferSingle(msg.sender, address(0x0), address(0x0), _type, 0);
977     }
978 
979     function setMintCallback(MintCallbackInterface _newCallback) external onlyOwner
980     {
981         mintCallback = _newCallback;
982     }
983 
984     function mintNonFungibleSingleShort(uint128 _type, address _to) external onlyOperator {
985         uint tokenType = (uint256(_type) << 128) | (1 << 255);
986         _mintNonFungibleSingle(tokenType, _to);
987     }
988 
989     function mintNonFungibleSingle(uint256 _type, address _to) external onlyOperator {
990         // No need to check this is a nf type
991         require(isNonFungible(_type));
992         require(getNonFungibleIndex(_type) == 0);
993 
994         _mintNonFungibleSingle(_type, _to);
995     }
996 
997     function _mintNonFungibleSingle(uint256 _type, address _to) internal {
998 
999         // Index are 1-based.
1000         uint256 index = maxIndex[_type] + 1;
1001 
1002         uint256 id  = _type | index;
1003 
1004         nfOwners[id] = _to;
1005 
1006         // You could use base-type id to store NF type balances if you wish.
1007         // balances[_type][dst] = quantity.add(balances[_type][dst]);
1008 
1009         emit TransferSingle(msg.sender, address(0x0), _to, id, 1);
1010 
1011         onTransferNft(address(0x0), _to, id);
1012         maxIndex[_type] = maxIndex[_type].add(1);
1013 
1014         if (address(mintCallback) != address(0)) {
1015             mintCallback.onMint(id);
1016         }
1017 
1018         if (_to.isContract()) {
1019             _doSafeTransferAcceptanceCheck(msg.sender, msg.sender, _to, id, 1, '');
1020         }
1021     }
1022 
1023     function mintNonFungibleShort(uint128 _type, address[] calldata _to) external onlyOperator {
1024         uint tokenType = (uint256(_type) << 128) | (1 << 255);
1025         _mintNonFungible(tokenType, _to);
1026     }
1027 
1028     function mintNonFungible(uint256 _type, address[] calldata _to) external onlyOperator {
1029 
1030         // No need to check this is a nf type
1031         require(isNonFungible(_type), "_type must be NFT type");
1032         _mintNonFungible(_type, _to);
1033     }
1034 
1035     function _mintNonFungible(uint256 _type, address[] memory _to) internal {
1036 
1037         // Index are 1-based.
1038         uint256 index = maxIndex[_type] + 1;
1039 
1040         for (uint256 i = 0; i < _to.length; ++i) {
1041             address dst = _to[i];
1042             uint256 id  = _type | index + i;
1043 
1044             nfOwners[id] = dst;
1045 
1046             // You could use base-type id to store NF type balances if you wish.
1047             // balances[_type][dst] = quantity.add(balances[_type][dst]);
1048 
1049             emit TransferSingle(msg.sender, address(0x0), dst, id, 1);
1050             onTransferNft(address(0x0), dst, id);
1051 
1052             if (address(mintCallback) != address(0)) {
1053                 mintCallback.onMint(id);
1054             }
1055             if (dst.isContract()) {
1056                 _doSafeTransferAcceptanceCheck(msg.sender, msg.sender, dst, id, 1, '');
1057             }
1058         }
1059 
1060         maxIndex[_type] = _to.length.add(maxIndex[_type]);
1061     }
1062 
1063     function mintFungibleSingle(uint256 _id, address _to, uint256 _quantity) external onlyOperator {
1064 
1065         require(isFungible(_id));
1066 
1067         // Grant the items to the caller
1068         balances[_id][_to] = _quantity.add(balances[_id][_to]);
1069 
1070         // Emit the Transfer/Mint event.
1071         // the 0x0 source address implies a mint
1072         // It will also provide the circulating supply info.
1073         emit TransferSingle(msg.sender, address(0x0), _to, _id, _quantity);
1074         onTransfer20(address(0x0), _to, _id, _quantity);
1075 
1076         if (_to.isContract()) {
1077             _doSafeTransferAcceptanceCheck(msg.sender, msg.sender, _to, _id, _quantity, '');
1078         }
1079     }
1080 
1081     function mintFungible(uint256 _id, address[] calldata _to, uint256[] calldata _quantities) external onlyOperator {
1082 
1083         require(isFungible(_id));
1084 
1085         for (uint256 i = 0; i < _to.length; ++i) {
1086 
1087             address to = _to[i];
1088             uint256 quantity = _quantities[i];
1089 
1090             // Grant the items to the caller
1091             balances[_id][to] = quantity.add(balances[_id][to]);
1092 
1093             // Emit the Transfer/Mint event.
1094             // the 0x0 source address implies a mint
1095             // It will also provide the circulating supply info.
1096             emit TransferSingle(msg.sender, address(0x0), to, _id, quantity);
1097             onTransfer20(address(0x0), to, _id, quantity);
1098 
1099             if (to.isContract()) {
1100                 _doSafeTransferAcceptanceCheck(msg.sender, msg.sender, to, _id, quantity, '');
1101             }
1102         }
1103     }
1104 
1105     function setURI(string calldata _uri, uint256 _id) external onlyOperator {
1106         emit URI(_uri, _id);
1107     }
1108 
1109     ERC1155URIProvider public uriProvider;
1110 
1111     function setUriProvider(ERC1155URIProvider _uriProvider) onlyOwner external
1112     {
1113         uriProvider = _uriProvider;
1114     }
1115 
1116     function uri(uint256 _id) external view returns (string memory)
1117     {
1118         return uriProvider.uri(_id);
1119     }
1120 
1121     function withdraw() external onlyOwner
1122     {
1123         if (address(this).balance > 0)
1124         {
1125             msg.sender.transfer(address(this).balance);
1126         }
1127     }
1128 
1129     function withdrawTokenFromBalance(ERC20 _tokenContract) external onlyOwner
1130     {
1131         uint256 balance = _tokenContract.balanceOf(address(this));
1132         _tokenContract.transfer(msg.sender, balance);
1133     }
1134 
1135     function totalSupplyNonFungible(uint256 _type) view external returns (uint256)
1136     {
1137         // No need to check this is a nf type
1138         require(isNonFungible(_type));
1139         return maxIndex[_type];
1140     }
1141 
1142     function totalSupplyNonFungibleShort(uint128 _type) view external returns (uint256)
1143     {
1144         uint tokenType = (uint256(_type) << 128) | (1 << 255);
1145         return maxIndex[tokenType];
1146     }
1147 
1148     function setProxy721(uint256 nftType, ERC721Proxy proxy) external onlyOwner
1149     {
1150         require(!disallowSetProxy721[nftType]);
1151         proxy721[nftType] = proxy;
1152     }
1153 
1154     // @dev can be only disabled. There is not way to enable later.
1155     function disableSetProxy721(uint256 nftType) external onlyOwner
1156     {
1157         disallowSetProxy721[nftType] = true;
1158     }
1159 
1160     function setProxy20(uint256 _type, ERC20Proxy proxy) external onlyOwner
1161     {
1162         require(!disallowSetProxy20[_type]);
1163         proxy20[_type] = proxy;
1164     }
1165 
1166     // @dev can be only disabled. There is not way to enable later.
1167     function disableSetProxy20(uint256 _type) external onlyOwner
1168     {
1169         disallowSetProxy20[_type] = true;
1170     }
1171 
1172     function proxyTransfer721(address _from, address _to, uint256 _tokenId, bytes calldata _data) external
1173     {
1174         uint256 nftType = getNFTType(_tokenId);
1175         ERC721Proxy proxy = proxy721[nftType];
1176         require(msg.sender == address(proxy));
1177 
1178         require(_ownerOf(_tokenId) == _from);
1179         require(_to != address(0x0), "cannot send to zero address");
1180         nfOwners[_tokenId] = _to;
1181         emit TransferSingle(msg.sender, _from, _to, _tokenId, 1);
1182         onTransferNft(_from, _to, _tokenId);
1183 
1184         if (_to.isContract()) {
1185             _doSafeTransferAcceptanceCheck(_to, _from, _to, _tokenId, 1, _data);
1186         }
1187     }
1188 
1189     // override
1190     function onTransferNft(address _from, address _to, uint256 _tokenId) internal {
1191         uint256 nftType = getNFTType(_tokenId);
1192         uint256 nftIndex = getNonFungibleIndex(_tokenId);
1193         ERC721Proxy proxy = proxy721[nftType];
1194         if (address(proxy) != address(0x0))
1195         {
1196             proxy.onTransfer(_from, _to, nftIndex);
1197         }
1198     }
1199 
1200     function proxyTransfer20(address _from, address _to, uint256 _tokenId, uint256 _value) external
1201     {
1202         ERC20Proxy proxy = proxy20[_tokenId];
1203         require(msg.sender == address(proxy));
1204 
1205         require(_to != address(0x0), "cannot send to zero address");
1206 
1207         balances[_tokenId][_from] = balances[_tokenId][_from].sub(_value);
1208         balances[_tokenId][_to]   = balances[_tokenId][_to].add(_value);
1209 
1210         emit TransferSingle(msg.sender, _from, _to, _tokenId, _value);
1211         onTransfer20(_from, _to, _tokenId, _value);
1212     }
1213 
1214     // override
1215     function onTransfer20(address _from, address _to, uint256 _tokenId, uint256 _value) internal {
1216         ERC20Proxy proxy = proxy20[_tokenId];
1217         if (address(proxy) != address(0x0))
1218         {
1219             proxy.onTransfer(_from, _to, _value);
1220         }
1221     }
1222 
1223     // override
1224     function burn(address _from, uint256 _id, uint256 _value) external {
1225 
1226         require(_from == msg.sender || operatorApproval[_from][msg.sender] == true, "Need operator approval for 3rd party transfers.");
1227 
1228         address to = address(0x0);
1229 
1230         if (isNonFungible(_id)) {
1231             require(nfOwners[_id] == _from);
1232             nfOwners[_id] = to;
1233             // You could keep balance of NF type in base type id like so:
1234             // uint256 baseType = getNonFungibleBaseType(_id);
1235             // balances[baseType][_from] = balances[baseType][_from].sub(_value);
1236             // balances[baseType][_to]   = balances[baseType][_to].add(_value);
1237             onTransferNft(_from, to, _id);
1238         } else {
1239             balances[_id][_from] = balances[_id][_from].sub(_value);
1240             balances[_id][to]   = balances[_id][to].add(_value);
1241             onTransfer20(_from, to, _id, _value);
1242         }
1243 
1244         emit TransferSingle(msg.sender, _from, to, _id, _value);
1245     }
1246 }