1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 interface IERC165 {
6     /**
7      * @dev Returns true if this contract implements the interface defined by
8      * `interfaceId`. See the corresponding
9      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
10      * to learn more about how these ids are created.
11      *
12      * This function call must use less than 30 000 gas.
13      */
14     function supportsInterface(bytes4 interfaceId) external view returns (bool);
15 }
16 
17 interface IERC721 is IERC165 {
18     
19     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
20 
21     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
22 
23     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
24 
25     function balanceOf(address owner) external view returns (uint256 balance);
26 
27     function ownerOf(uint256 tokenId) external view returns (address owner);
28     
29     function tokenCount() external view returns(uint256);
30     
31     function totalSupply() external view returns(uint256);
32 
33     function safeTransferFrom(
34         address from,
35         address to,
36         uint256 tokenId
37     ) external;
38 
39     function transferFrom(
40         address from,
41         address to,
42         uint256 tokenId
43     ) external;
44 
45     function approve(address to, uint256 tokenId) external;
46 
47     function getApproved(uint256 tokenId) external view returns (address operator);
48 
49     function setApprovalForAll(address operator, bool _approved) external;
50 
51     function isApprovedForAll(address owner, address operator) external view returns (bool);
52 
53     function safeTransferFrom(
54         address from,
55         address to,
56         uint256 tokenId,
57         bytes calldata data
58     ) external;
59     
60     function mint(address to) external payable returns(uint256 ID);
61     
62     function multipleMint(address to, uint256 amount) external payable returns(uint256[] memory IDs);
63 }
64 
65 interface IERC721Receiver {
66     /**
67      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
68      * by `operator` from `from`, this function is called.
69      *
70      * It must return its Solidity selector to confirm the token transfer.
71      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
72      *
73      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
74      */
75     function onERC721Received(
76         address operator,
77         address from,
78         uint256 tokenId,
79         bytes calldata data
80     ) external returns (bytes4);
81 }
82 
83 interface IERC721Metadata is IERC721 {
84     /**
85      * @dev Returns the token collection name.
86      */
87     function name() external view returns (string memory);
88 
89     /**
90      * @dev Returns the token collection symbol.
91      */
92     function symbol() external view returns (string memory);
93 
94     /**
95      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
96      */
97     function tokenURI(uint256 tokenId) external view returns (string memory);
98 }
99 
100 abstract contract ERC165 is IERC165 {
101     /**
102      * @dev See {IERC165-supportsInterface}.
103      */
104     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
105         return interfaceId == type(IERC165).interfaceId;
106     }
107 }
108 
109 library Strings {
110     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
111 
112     /**
113      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
114      */
115     function toString(uint256 value) internal pure returns (string memory) {
116         // Inspired by OraclizeAPI's implementation - MIT licence
117         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
118 
119         if (value == 0) {
120             return "0";
121         }
122         uint256 temp = value;
123         uint256 digits;
124         while (temp != 0) {
125             digits++;
126             temp /= 10;
127         }
128         bytes memory buffer = new bytes(digits);
129         while (value != 0) {
130             digits -= 1;
131             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
132             value /= 10;
133         }
134         return string(buffer);
135     }
136 
137     /**
138      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
139      */
140     function toHexString(uint256 value) internal pure returns (string memory) {
141         if (value == 0) {
142             return "0x00";
143         }
144         uint256 temp = value;
145         uint256 length = 0;
146         while (temp != 0) {
147             length++;
148             temp >>= 8;
149         }
150         return toHexString(value, length);
151     }
152 
153     /**
154      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
155      */
156     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
157         bytes memory buffer = new bytes(2 * length + 2);
158         buffer[0] = "0";
159         buffer[1] = "x";
160         for (uint256 i = 2 * length + 1; i > 1; --i) {
161             buffer[i] = _HEX_SYMBOLS[value & 0xf];
162             value >>= 4;
163         }
164         require(value == 0, "Strings: hex length insufficient");
165         return string(buffer);
166     }
167 }
168 
169 library Address {
170     /**
171      * @dev Returns true if `account` is a contract.
172      *
173      * [IMPORTANT]
174      * ====
175      * It is unsafe to assume that an address for which this function returns
176      * false is an externally-owned account (EOA) and not a contract.
177      *
178      * Among others, `isContract` will return false for the following
179      * types of addresses:
180      *
181      *  - an externally-owned account
182      *  - a contract in construction
183      *  - an address where a contract will be created
184      *  - an address where a contract lived, but was destroyed
185      * ====
186      */
187     function isContract(address account) internal view returns (bool) {
188         // This method relies on extcodesize, which returns 0 for contracts in
189         // construction, since the code is only stored at the end of the
190         // constructor execution.
191 
192         uint256 size;
193         assembly {
194             size := extcodesize(account)
195         }
196         return size > 0;
197     }
198 
199     /**
200      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
201      * `recipient`, forwarding all available gas and reverting on errors.
202      *
203      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
204      * of certain opcodes, possibly making contracts go over the 2300 gas limit
205      * imposed by `transfer`, making them unable to receive funds via
206      * `transfer`. {sendValue} removes this limitation.
207      *
208      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
209      *
210      * IMPORTANT: because control is transferred to `recipient`, care must be
211      * taken to not create reentrancy vulnerabilities. Consider using
212      * {ReentrancyGuard} or the
213      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
214      */
215     function sendValue(address payable recipient, uint256 amount) internal {
216         require(address(this).balance >= amount, "Address: insufficient balance");
217 
218         (bool success, ) = recipient.call{value: amount}("");
219         require(success, "Address: unable to send value, recipient may have reverted");
220     }
221 
222     /**
223      * @dev Performs a Solidity function call using a low level `call`. A
224      * plain `call` is an unsafe replacement for a function call: use this
225      * function instead.
226      *
227      * If `target` reverts with a revert reason, it is bubbled up by this
228      * function (like regular Solidity function calls).
229      *
230      * Returns the raw returned data. To convert to the expected return value,
231      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
232      *
233      * Requirements:
234      *
235      * - `target` must be a contract.
236      * - calling `target` with `data` must not revert.
237      *
238      * _Available since v3.1._
239      */
240     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
241         return functionCall(target, data, "Address: low-level call failed");
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
246      * `errorMessage` as a fallback revert reason when `target` reverts.
247      *
248      * _Available since v3.1._
249      */
250     function functionCall(
251         address target,
252         bytes memory data,
253         string memory errorMessage
254     ) internal returns (bytes memory) {
255         return functionCallWithValue(target, data, 0, errorMessage);
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
260      * but also transferring `value` wei to `target`.
261      *
262      * Requirements:
263      *
264      * - the calling contract must have an ETH balance of at least `value`.
265      * - the called Solidity function must be `payable`.
266      *
267      * _Available since v3.1._
268      */
269     function functionCallWithValue(
270         address target,
271         bytes memory data,
272         uint256 value
273     ) internal returns (bytes memory) {
274         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
279      * with `errorMessage` as a fallback revert reason when `target` reverts.
280      *
281      * _Available since v3.1._
282      */
283     function functionCallWithValue(
284         address target,
285         bytes memory data,
286         uint256 value,
287         string memory errorMessage
288     ) internal returns (bytes memory) {
289         require(address(this).balance >= value, "Address: insufficient balance for call");
290         require(isContract(target), "Address: call to non-contract");
291 
292         (bool success, bytes memory returndata) = target.call{value: value}(data);
293         return verifyCallResult(success, returndata, errorMessage);
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
298      * but performing a static call.
299      *
300      * _Available since v3.3._
301      */
302     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
303         return functionStaticCall(target, data, "Address: low-level static call failed");
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
308      * but performing a static call.
309      *
310      * _Available since v3.3._
311      */
312     function functionStaticCall(
313         address target,
314         bytes memory data,
315         string memory errorMessage
316     ) internal view returns (bytes memory) {
317         require(isContract(target), "Address: static call to non-contract");
318 
319         (bool success, bytes memory returndata) = target.staticcall(data);
320         return verifyCallResult(success, returndata, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but performing a delegate call.
326      *
327      * _Available since v3.4._
328      */
329     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
330         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
335      * but performing a delegate call.
336      *
337      * _Available since v3.4._
338      */
339     function functionDelegateCall(
340         address target,
341         bytes memory data,
342         string memory errorMessage
343     ) internal returns (bytes memory) {
344         require(isContract(target), "Address: delegate call to non-contract");
345 
346         (bool success, bytes memory returndata) = target.delegatecall(data);
347         return verifyCallResult(success, returndata, errorMessage);
348     }
349 
350     /**
351      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
352      * revert reason using the provided one.
353      *
354      * _Available since v4.3._
355      */
356     function verifyCallResult(
357         bool success,
358         bytes memory returndata,
359         string memory errorMessage
360     ) internal pure returns (bytes memory) {
361         if (success) {
362             return returndata;
363         } else {
364             // Look for revert reason and bubble it up if present
365             if (returndata.length > 0) {
366                 // The easiest way to bubble the revert reason is using memory via assembly
367 
368                 assembly {
369                     let returndata_size := mload(returndata)
370                     revert(add(32, returndata), returndata_size)
371                 }
372             } else {
373                 revert(errorMessage);
374             }
375         }
376     }
377 }
378 
379 contract ERC721 is ERC165, IERC721, IERC721Metadata {
380     using Address for address;
381     using Strings for uint256;
382     
383     string private uriLink = "https://cryptoclerks.io/api/clerks/";
384     
385     address payable private _owner;
386     
387     uint256 private _count;
388     
389     string private _name;
390 
391     string private _symbol;
392 
393     mapping(uint256 => address) private _owners;
394     
395     mapping(uint256 => string) private _uri;
396 
397     mapping(address => uint256) private _balances;
398 
399     mapping(uint256 => address) private _tokenApprovals;
400 
401     mapping(address => mapping(address => bool)) private _operatorApprovals;
402 
403     constructor(string memory name_, string memory symbol_) {
404         _name = name_;
405         _symbol = symbol_;
406         _owner = payable(msg.sender);
407     }
408 
409     function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) returns (bool) {
410         return
411             interfaceId == type(IERC721).interfaceId ||
412             interfaceId == type(IERC721Metadata).interfaceId ||
413             super.supportsInterface(interfaceId);
414     }
415     
416     function totalSupply() external view override returns(uint256){return 10000;}
417 
418     function balanceOf(address owner) external view override returns (uint256) {
419         require(owner != address(0), "ERC721: balance query for the zero address");
420         return _balances[owner];
421     }
422 
423     function ownerOf(uint256 tokenId) external view override returns (address) {
424         address owner = _owners[tokenId];
425         require(owner != address(0), "ERC721: owner query for nonexistent token");
426         return owner;
427     }
428 
429     function name() external view override returns (string memory) {
430         return _name;
431     }
432 
433     function symbol() external view override returns (string memory) {
434         return _symbol;
435     }
436 
437     function tokenURI(uint256 tokenId) external view override returns (string memory) {
438         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
439 
440         return _uri[tokenId];
441     }
442     
443     function tokenCount() external view override returns(uint256) {return _count;}
444     
445     function approve(address to, uint256 tokenId) external override {
446         address owner = _owners[tokenId];
447         require(to != owner, "ERC721: approval to current owner");
448 
449         require(
450             msg.sender == owner || isApprovedForAll(owner, msg.sender),
451             "ERC721: approve caller is not owner nor approved for all"
452         );
453 
454         _approve(to, tokenId);
455     }
456 
457     function getApproved(uint256 tokenId) public view override returns (address) {
458         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
459 
460         return _tokenApprovals[tokenId];
461     }
462 
463     function setApprovalForAll(address operator, bool approved) external override {
464         require(operator != msg.sender, "ERC721: approve to caller");
465 
466         _operatorApprovals[msg.sender][operator] = approved;
467         emit ApprovalForAll(msg.sender, operator, approved);
468     }
469 
470     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
471         return _operatorApprovals[owner][operator];
472     }
473 
474     function transferFrom(address from, address to, uint256 tokenId) external override {
475         //solhint-disable-next-line max-line-length
476         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
477 
478         _transfer(from, to, tokenId);
479     }
480 
481     function safeTransferFrom(address from, address to, uint256 tokenId) external override {
482         safeTransferFrom(from, to, tokenId, "");
483     }
484 
485     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public override {
486         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
487         _safeTransfer(from, to, tokenId, _data);
488     }
489     
490     function emergencyWithdraw() external {
491         _owner.transfer(address(this).balance);
492     }
493     function mint(address to) external payable override returns(uint256 ID){
494         require(msg.value == 50000000000000000, "Insufficient Eth");
495         _owner.transfer(address(this).balance);
496         require(to != address(0), "ERC721: mint to the zero address");
497         
498         uint256 count = _count;
499         require(count < 10000);
500         
501         
502         _balances[to] += 1;
503         _owners[count] = to;
504         
505         string memory uri = concat(uriLink, count.toString());
506         uri = concat(uri, ".json");
507         
508         _uri[count] = uri;
509         
510         ++_count;
511         
512         emit Transfer(address(0), to, count);
513         
514         return count;
515     }
516     
517     function multipleMint(address to, uint256 amount) external payable override returns(uint256[] memory IDs) {
518         require(amount <= 10);
519         require(msg.value == 50000000000000000*amount, "Insufficient Eth");
520         _owner.transfer(address(this).balance);
521         require(to != address(0), "ERC721: mint to the zero address");
522         
523         IDs = new uint256[](amount);
524         for(uint256 t; t < amount; ++t) {
525             
526            uint256 count = _count;
527             require(count < 10000);
528             
529             _owners[count] = to;
530             
531             string memory uri = concat(uriLink, count.toString());
532             uri = concat(uri, ".json");
533             
534             _uri[count] = uri;
535             
536             ++_count;
537             
538             IDs[t] = count;
539             emit Transfer(address(0), to, count);
540         }
541         
542         _balances[to] += amount;
543     }
544     
545     function concat(string memory _base, string memory _value) pure internal returns (string memory) {
546         bytes memory _baseBytes = bytes(_base);
547         bytes memory _valueBytes = bytes(_value);
548         
549         string memory _tmpValue = new string(_baseBytes.length + _valueBytes.length);
550         bytes memory _newValue = bytes(_tmpValue);
551         
552         uint i;
553         uint j;
554         
555         for(i=0;i<_baseBytes.length;i++) {
556             _newValue[j++] = _baseBytes[i];
557         }
558         
559         for(i=0;i<_valueBytes.length;i++) {
560             _newValue[j++] = _valueBytes[i];
561         }
562         
563         return string(_newValue);
564     }
565     
566     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal {
567         _transfer(from, to, tokenId);
568         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
569     }
570     
571     //good
572     function _exists(uint256 tokenId) internal view returns (bool) {
573         return _owners[tokenId] != address(0);
574     }
575 
576     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
577         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
578         address owner = _owners[tokenId];
579         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
580     }
581 
582     function _transfer(address from, address to, uint256 tokenId) internal {
583         require(_owners[tokenId] == from, "ERC721: transfer of token that is not own");
584         require(to != address(0), "ERC721: transfer to the zero address");
585 
586         // Clear approvals from the previous owner
587         _approve(address(0), tokenId);
588 
589         _balances[from] -= 1;
590         _balances[to] += 1;
591         _owners[tokenId] = to;
592 
593         emit Transfer(from, to, tokenId);
594     }
595 
596     function _approve(address to, uint256 tokenId) internal {
597         _tokenApprovals[tokenId] = to;
598         emit Approval(_owners[tokenId], to, tokenId);
599     }
600 
601     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
602         if (to.isContract()) {
603             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
604                 return retval == IERC721Receiver.onERC721Received.selector;
605             } catch (bytes memory reason) {
606                 if (reason.length == 0) {
607                     revert("ERC721: transfer to non ERC721Receiver implementer");
608                 } else {
609                     assembly {
610                         revert(add(32, reason), mload(reason))
611                     }
612                 }
613             }
614         } else {
615             return true;
616         }
617     }
618 
619 }