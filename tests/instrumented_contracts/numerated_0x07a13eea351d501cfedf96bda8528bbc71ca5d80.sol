1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
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
19     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
20 
21     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
22 
23     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
24 
25     function balanceOf(address _owner) external view returns (uint256);
26 
27     function ownerOf(uint256 _tokenId) external view returns (address);
28     
29     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) external;
30 
31     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
32 
33     function transferFrom(address _from, address _to, uint256 _tokenId) external;
34 
35     function approve(address _approved, uint256 _tokenId) external;
36 
37     function setApprovalForAll(address _operator, bool _approved) external;
38 
39     function getApproved(uint256 _tokenId) external view returns (address);
40 
41     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
42     
43 }
44 
45 interface IERC721Receiver {
46     /**
47      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
48      * by `operator` from `from`, this function is called.
49      *
50      * It must return its Solidity selector to confirm the token transfer.
51      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
52      *
53      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
54      */
55     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
56 }
57 
58 interface IERC721Metadata is IERC721 {
59 
60     /**
61      * @dev Returns the token collection name.
62      */
63     function name() external view returns (string memory);
64 
65     /**
66      * @dev Returns the token collection symbol.
67      */
68     function symbol() external view returns (string memory);
69     
70     function totalSupply() external view returns(uint256);
71     
72     /**
73      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
74      */
75     function tokenURI(uint256 tokenId) external view returns (string memory);
76 }
77 
78 library Address {
79     /**
80      * @dev Returns true if `account` is a contract.
81      *
82      * [IMPORTANT]
83      * ====
84      * It is unsafe to assume that an address for which this function returns
85      * false is an externally-owned account (EOA) and not a contract.
86      *
87      * Among others, `isContract` will return false for the following
88      * types of addresses:
89      *
90      *  - an externally-owned account
91      *  - a contract in construction
92      *  - an address where a contract will be created
93      *  - an address where a contract lived, but was destroyed
94      * ====
95      */
96     function isContract(address account) internal view returns (bool) {
97         // This method relies on extcodesize, which returns 0 for contracts in
98         // construction, since the code is only stored at the end of the
99         // constructor execution.
100 
101         uint256 size;
102         // solhint-disable-next-line no-inline-assembly
103         assembly { size := extcodesize(account) }
104         return size > 0;
105     }
106 
107     /**
108      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
109      * `recipient`, forwarding all available gas and reverting on errors.
110      *
111      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
112      * of certain opcodes, possibly making contracts go over the 2300 gas limit
113      * imposed by `transfer`, making them unable to receive funds via
114      * `transfer`. {sendValue} removes this limitation.
115      *
116      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
117      *
118      * IMPORTANT: because control is transferred to `recipient`, care must be
119      * taken to not create reentrancy vulnerabilities. Consider using
120      * {ReentrancyGuard} or the
121      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
122      */
123     function sendValue(address payable recipient, uint256 amount) internal {
124         require(address(this).balance >= amount, "Address: insufficient balance");
125 
126         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
127         (bool success, ) = recipient.call{ value: amount }("");
128         require(success, "Address: unable to send value, recipient may have reverted");
129     }
130 
131     /**
132      * @dev Performs a Solidity function call using a low level `call`. A
133      * plain`call` is an unsafe replacement for a function call: use this
134      * function instead.
135      *
136      * If `target` reverts with a revert reason, it is bubbled up by this
137      * function (like regular Solidity function calls).
138      *
139      * Returns the raw returned data. To convert to the expected return value,
140      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
141      *
142      * Requirements:
143      *
144      * - `target` must be a contract.
145      * - calling `target` with `data` must not revert.
146      *
147      * _Available since v3.1._
148      */
149     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
150       return functionCall(target, data, "Address: low-level call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
155      * `errorMessage` as a fallback revert reason when `target` reverts.
156      *
157      * _Available since v3.1._
158      */
159     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
160         return functionCallWithValue(target, data, 0, errorMessage);
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
165      * but also transferring `value` wei to `target`.
166      *
167      * Requirements:
168      *
169      * - the calling contract must have an ETH balance of at least `value`.
170      * - the called Solidity function must be `payable`.
171      *
172      * _Available since v3.1._
173      */
174     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
175         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
180      * with `errorMessage` as a fallback revert reason when `target` reverts.
181      *
182      * _Available since v3.1._
183      */
184     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
185         require(address(this).balance >= value, "Address: insufficient balance for call");
186         require(isContract(target), "Address: call to non-contract");
187 
188         // solhint-disable-next-line avoid-low-level-calls
189         (bool success, bytes memory returndata) = target.call{ value: value }(data);
190         return _verifyCallResult(success, returndata, errorMessage);
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
195      * but performing a static call.
196      *
197      * _Available since v3.3._
198      */
199     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
200         return functionStaticCall(target, data, "Address: low-level static call failed");
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
205      * but performing a static call.
206      *
207      * _Available since v3.3._
208      */
209     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
210         require(isContract(target), "Address: static call to non-contract");
211 
212         // solhint-disable-next-line avoid-low-level-calls
213         (bool success, bytes memory returndata) = target.staticcall(data);
214         return _verifyCallResult(success, returndata, errorMessage);
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
219      * but performing a delegate call.
220      *
221      * _Available since v3.4._
222      */
223     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
224         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
229      * but performing a delegate call.
230      *
231      * _Available since v3.4._
232      */
233     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
234         require(isContract(target), "Address: delegate call to non-contract");
235 
236         // solhint-disable-next-line avoid-low-level-calls
237         (bool success, bytes memory returndata) = target.delegatecall(data);
238         return _verifyCallResult(success, returndata, errorMessage);
239     }
240 
241     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
242         if (success) {
243             return returndata;
244         } else {
245             // Look for revert reason and bubble it up if present
246             if (returndata.length > 0) {
247                 // The easiest way to bubble the revert reason is using memory via assembly
248 
249                 // solhint-disable-next-line no-inline-assembly
250                 assembly {
251                     let returndata_size := mload(returndata)
252                     revert(add(32, returndata), returndata_size)
253                 }
254             } else {
255                 revert(errorMessage);
256             }
257         }
258     }
259 }
260 
261 library Strings {
262     bytes16 private constant alphabet = "0123456789abcdef";
263 
264     /**
265      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
266      */
267     function toString(uint256 value) internal pure returns (string memory) {
268         // Inspired by OraclizeAPI's implementation - MIT licence
269         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
270 
271         if (value == 0) {
272             return "0";
273         }
274         uint256 temp = value;
275         uint256 digits;
276         while (temp != 0) {
277             digits++;
278             temp /= 10;
279         }
280         bytes memory buffer = new bytes(digits);
281         while (value != 0) {
282             digits -= 1;
283             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
284             value /= 10;
285         }
286         return string(buffer);
287     }
288 
289     /**
290      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
291      */
292     function toHexString(uint256 value) internal pure returns (string memory) {
293         if (value == 0) {
294             return "0x00";
295         }
296         uint256 temp = value;
297         uint256 length = 0;
298         while (temp != 0) {
299             length++;
300             temp >>= 8;
301         }
302         return toHexString(value, length);
303     }
304 
305     /**
306      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
307      */
308     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
309         bytes memory buffer = new bytes(2 * length + 2);
310         buffer[0] = "0";
311         buffer[1] = "x";
312         for (uint256 i = 2 * length + 1; i > 1; --i) {
313             buffer[i] = alphabet[value & 0xf];
314             value >>= 4;
315         }
316         require(value == 0, "Strings: hex length insufficient");
317         return string(buffer);
318     }
319 
320 }
321 
322 abstract contract ERC165 is IERC165 {
323     /**
324      * @dev See {IERC165-supportsInterface}.
325      */
326     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
327         return interfaceId == type(IERC165).interfaceId;
328     }
329 }
330 
331 contract ERC721 is ERC165, IERC721, IERC721Metadata {
332     using Address for address;
333     using Strings for uint256;
334     
335     uint256 private _totalMintsAllowed = 4;
336     
337     string private uriLink = "https://spicypumpkins.com/api/json";
338     
339     bool private _minting = true;
340     
341     address payable private _owner;
342     
343     uint256 private _count;
344     
345     string private _name;
346 
347     string private _symbol;
348 
349     mapping(uint256 => address) private _owners;
350     
351     mapping(uint256 => string) private _uri;
352 
353     mapping(address => uint256) private _balances;
354 
355     mapping(uint256 => address) private _tokenApprovals;
356     
357     mapping(address => uint256) private _minted;
358 
359     mapping(address => mapping(address => bool)) private _operatorApprovals;
360 
361     constructor (string memory name_, string memory symbol_) {
362         _name = name_;
363         _symbol = symbol_;
364         _owners[0] = msg.sender;
365         _balances[msg.sender] = 1;
366         _owner = payable(msg.sender);
367     }
368     
369     function setMinting(bool boolean) external {
370         require(msg.sender == _owner);
371         _minting = boolean;
372     }
373     
374     function transferOwnership(address to) external {
375         require(msg.sender == _owner);
376         _owner = payable(to);
377     }
378     
379     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
380         return interfaceId == type(IERC721).interfaceId
381             || interfaceId == type(IERC721Metadata).interfaceId
382             || super.supportsInterface(interfaceId);
383     }
384 
385     function balanceOf(address owner) public view virtual override returns (uint256) {
386         require(owner != address(0), "ERC721: balance query for the zero address");
387         return _balances[owner];
388     }
389 
390     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
391         address owner = _owners[tokenId];
392         require(owner != address(0), "ERC721: owner query for nonexistent token");
393         return owner;
394     }
395 
396     function name() public view virtual override returns (string memory) {
397         return _name;
398     }
399 
400     function symbol() public view virtual override returns (string memory) {
401         return _symbol;
402     }
403     
404     function totalSupply() external view override returns(uint256){return 4444;}
405 
406     function tokenURI(uint256 tokenId) external view override returns (string memory) {
407         return _uri[tokenId];
408     }
409 
410     function _baseURI() internal view virtual returns (string memory) {
411         return "";
412     }
413 
414     function approve(address to, uint256 tokenId) external override {
415         address owner = ERC721.ownerOf(tokenId);
416         require(to != owner, "ERC721: approval to current owner");
417 
418         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
419             "ERC721: approve caller is not owner nor approved for all"
420         );
421 
422         _approve(to, tokenId);
423     }
424 
425     function getApproved(uint256 tokenId) public view virtual override returns (address) {
426         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
427 
428         return _tokenApprovals[tokenId];
429     }
430 
431     function setApprovalForAll(address operator, bool approved) public virtual override {
432         require(operator != msg.sender, "ERC721: approve to caller");
433 
434         _operatorApprovals[msg.sender][operator] = approved;
435         emit ApprovalForAll(msg.sender, operator, approved);
436     }
437 
438     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
439         return _operatorApprovals[owner][operator];
440     }
441 
442     function transferFrom(address from, address to, uint256 tokenId) external override {
443         //solhint-disable-next-line max-line-length
444         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
445 
446         _transfer(from, to, tokenId);
447     }
448 
449     function safeTransferFrom(address from, address to, uint256 tokenId) external override {
450         _transfer(from, to, tokenId);
451         require(_checkOnERC721Received(from, to, tokenId, ""), "ERC721: transfer to non ERC721Receiver implementer");
452     }
453 
454     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) external override {
455         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
456         _safeTransfer(from, to, tokenId, _data);
457     }
458 
459     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
460         _transfer(from, to, tokenId);
461         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
462     }
463 
464     function _exists(uint256 tokenId) internal view returns (bool) {
465         return _owners[tokenId] != address(0);
466     }
467 
468     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
469         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
470         address owner = _owners[tokenId];
471         require(spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender), "ERC721: Not approved or owner");
472         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
473     }
474     
475     function mint(address to) external payable returns(uint256 ID) {return internalMint(to);}
476     
477     function internalMint(address to) internal returns(uint256 ID){
478         require(_minted[msg.sender] < _totalMintsAllowed);
479         require(_count < 4444, "All NFT's minted");
480         require(_minting, "Minting disabeled");
481         require(msg.value == 50000000000000000, "Insufficient Eth");
482         _owner.transfer(address(this).balance);
483         require(to != address(0), "ERC721: mint to the zero address");
484         
485         uint256 count = _count;
486         string memory link = uriLink;
487         
488         ++_balances[to];
489         _owners[count] = to;
490             
491         string memory uri = concat(link, count.toString());
492         uri = concat(uri, ".json");
493         _uri[count] = uri;
494         
495         ++_count;
496         
497         emit Transfer(address(0), to, count);
498         
499         ++_minted[msg.sender];
500         return count;
501     }
502 
503     function concat(string memory _base, string memory _value) pure internal returns (string memory) {
504         bytes memory _baseBytes = bytes(_base);
505         bytes memory _valueBytes = bytes(_value);
506         
507         string memory _tmpValue = new string(_baseBytes.length + _valueBytes.length);
508         bytes memory _newValue = bytes(_tmpValue);
509         
510         uint i;
511         uint j;
512         
513         for(i=0;i<_baseBytes.length;i++) {
514             _newValue[j++] = _baseBytes[i];
515         }
516         
517         for(i=0;i<_valueBytes.length;i++) {
518             _newValue[j++] = _valueBytes[i];
519         }
520         
521         return string(_newValue);
522     }
523     
524     function multiMint(address to, uint256 amount) external payable returns(uint256[] memory IDs){
525         require(msg.value == 50000000000000000 * amount, "Insufficient Eth");
526         IDs = new uint256[](amount);
527         for(uint256 t; t < amount; ++t) {
528             IDs[t] = internalMint(to);
529         }
530         
531     }
532     
533     function changeMax(uint256 newMax) external {
534         require(msg.sender == _owner);
535         _totalMintsAllowed = newMax;
536     }
537     function _transfer(address from, address to, uint256 tokenId) internal virtual {
538         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
539         require(to != address(0), "ERC721: transfer to the zero address");
540 
541         // Clear approvals from the previous owner
542         _approve(address(0), tokenId);
543 
544         _balances[from] -= 1;
545         _balances[to] += 1;
546         _owners[tokenId] = to;
547 
548         emit Transfer(from, to, tokenId);
549     }
550 
551     function _approve(address to, uint256 tokenId) internal virtual {
552         _tokenApprovals[tokenId] = to;
553         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
554     }
555 
556     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
557         private returns (bool)
558     {
559         if (to.isContract()) {
560             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
561                 return retval == IERC721Receiver(to).onERC721Received.selector;
562             } catch (bytes memory reason) {
563                 if (reason.length == 0) {
564                     revert("ERC721: transfer to non ERC721Receiver implementer");
565                 } else {
566                     // solhint-disable-next-line no-inline-assembly
567                     assembly {
568                         revert(add(32, reason), mload(reason))
569                     }
570                 }
571             }
572         } else {
573             return true;
574         }
575     }
576 }