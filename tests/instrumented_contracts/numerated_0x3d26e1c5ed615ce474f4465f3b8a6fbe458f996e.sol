1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 pragma solidity ^0.8.0;
4 
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         return msg.data;
13     }
14 }
15 
16 // File: @openzeppelin/contracts/utils/Address.sol
17 
18 pragma solidity ^0.8.0;
19 
20 
21 library Address {
22     
23     function isContract(address account) internal view returns (bool) {
24         // This method relies on extcodesize, which returns 0 for contracts in
25         // construction, since the code is only stored at the end of the
26         // constructor execution.
27 
28         uint256 size;
29         assembly {
30             size := extcodesize(account)
31         }
32         return size > 0;
33     }
34 
35     
36     function sendValue(address payable recipient, uint256 amount) internal {
37         require(address(this).balance >= amount, "Address: insufficient balance");
38 
39         (bool success, ) = recipient.call{value: amount}("");
40         require(success, "Address: unable to send value, recipient may have reverted");
41     }
42 
43     
44     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
45         return functionCall(target, data, "Address: low-level call failed");
46     }
47 
48     
49     function functionCall(
50         address target,
51         bytes memory data,
52         string memory errorMessage
53     ) internal returns (bytes memory) {
54         return functionCallWithValue(target, data, 0, errorMessage);
55     }
56 
57     
58     function functionCallWithValue(
59         address target,
60         bytes memory data,
61         uint256 value
62     ) internal returns (bytes memory) {
63         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
64     }
65 
66     
67     function functionCallWithValue(
68         address target,
69         bytes memory data,
70         uint256 value,
71         string memory errorMessage
72     ) internal returns (bytes memory) {
73         require(address(this).balance >= value, "Address: insufficient balance for call");
74         require(isContract(target), "Address: call to non-contract");
75 
76         (bool success, bytes memory returndata) = target.call{value: value}(data);
77         return verifyCallResult(success, returndata, errorMessage);
78     }
79 
80     
81     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
82         return functionStaticCall(target, data, "Address: low-level static call failed");
83     }
84 
85     
86     function functionStaticCall(
87         address target,
88         bytes memory data,
89         string memory errorMessage
90     ) internal view returns (bytes memory) {
91         require(isContract(target), "Address: static call to non-contract");
92 
93         (bool success, bytes memory returndata) = target.staticcall(data);
94         return verifyCallResult(success, returndata, errorMessage);
95     }
96 
97     
98     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
99         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
100     }
101 
102     
103     function functionDelegateCall(
104         address target,
105         bytes memory data,
106         string memory errorMessage
107     ) internal returns (bytes memory) {
108         require(isContract(target), "Address: delegate call to non-contract");
109 
110         (bool success, bytes memory returndata) = target.delegatecall(data);
111         return verifyCallResult(success, returndata, errorMessage);
112     }
113 
114     
115     function verifyCallResult(
116         bool success,
117         bytes memory returndata,
118         string memory errorMessage
119     ) internal pure returns (bytes memory) {
120         if (success) {
121             return returndata;
122         } else {
123             // Look for revert reason and bubble it up if present
124             if (returndata.length > 0) {
125                 // The easiest way to bubble the revert reason is using memory via assembly
126 
127                 assembly {
128                     let returndata_size := mload(returndata)
129                     revert(add(32, returndata), returndata_size)
130                 }
131             } else {
132                 revert(errorMessage);
133             }
134         }
135     }
136 }
137 
138 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
139 
140 pragma solidity ^0.8.0;
141 
142 
143 interface IERC20 {
144     
145     function totalSupply() external view returns (uint256);
146 
147     
148     function balanceOf(address account) external view returns (uint256);
149 
150     
151     function transfer(address recipient, uint256 amount) external returns (bool);
152 
153     
154     function allowance(address owner, address spender) external view returns (uint256);
155 
156     
157     function approve(address spender, uint256 amount) external returns (bool);
158 
159     
160     function transferFrom(
161         address sender,
162         address recipient,
163         uint256 amount
164     ) external returns (bool);
165 
166     
167     event Transfer(address indexed from, address indexed to, uint256 value);
168 
169     
170     event Approval(address indexed owner, address indexed spender, uint256 value);
171 }
172 
173 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
174 
175 
176 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 
181 library SafeERC20 {
182     using Address for address;
183 
184     function safeTransfer(
185         IERC20 token,
186         address to,
187         uint256 value
188     ) internal {
189         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
190     }
191 
192     function safeTransferFrom(
193         IERC20 token,
194         address from,
195         address to,
196         uint256 value
197     ) internal {
198         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
199     }
200 
201     
202     function safeApprove(
203         IERC20 token,
204         address spender,
205         uint256 value
206     ) internal {
207         // safeApprove should only be called when setting an initial allowance,
208         // or when resetting it to zero. To increase and decrease it, use
209         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
210         require(
211             (value == 0) || (token.allowance(address(this), spender) == 0),
212             "SafeERC20: approve from non-zero to non-zero allowance"
213         );
214         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
215     }
216 
217     function safeIncreaseAllowance(
218         IERC20 token,
219         address spender,
220         uint256 value
221     ) internal {
222         uint256 newAllowance = token.allowance(address(this), spender) + value;
223         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
224     }
225 
226     function safeDecreaseAllowance(
227         IERC20 token,
228         address spender,
229         uint256 value
230     ) internal {
231         unchecked {
232             uint256 oldAllowance = token.allowance(address(this), spender);
233             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
234             uint256 newAllowance = oldAllowance - value;
235             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
236         }
237     }
238 
239     
240     function _callOptionalReturn(IERC20 token, bytes memory data) private {
241         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
242         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
243         // the target address contains contract code and also asserts for success in the low-level call.
244 
245         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
246         if (returndata.length > 0) {
247             // Return data is optional
248             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
249         }
250     }
251 }
252 
253 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
254 
255 
256 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
257 
258 pragma solidity ^0.8.0;
259 
260 
261 library MerkleProof {
262     
263     function verify(
264         bytes32[] memory proof,
265         bytes32 root,
266         bytes32 leaf
267     ) internal pure returns (bool) {
268         return processProof(proof, leaf) == root;
269     }
270 
271     
272     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
273         bytes32 computedHash = leaf;
274         for (uint256 i = 0; i < proof.length; i++) {
275             bytes32 proofElement = proof[i];
276             if (computedHash <= proofElement) {
277                 // Hash(current computed hash + current element of the proof)
278                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
279             } else {
280                 // Hash(current element of the proof + current computed hash)
281                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
282             }
283         }
284         return computedHash;
285     }
286 }
287 
288 // File: @openzeppelin/contracts/utils/Strings.sol
289 
290 pragma solidity ^0.8.0;
291 
292 
293 library Strings {
294     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
295 
296     
297     function toString(uint256 value) internal pure returns (string memory) {
298         // Inspired by OraclizeAPI's implementation - MIT licence
299         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
300 
301         if (value == 0) {
302             return "0";
303         }
304         uint256 temp = value;
305         uint256 digits;
306         while (temp != 0) {
307             digits++;
308             temp /= 10;
309         }
310         bytes memory buffer = new bytes(digits);
311         while (value != 0) {
312             digits -= 1;
313             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
314             value /= 10;
315         }
316         return string(buffer);
317     }
318 
319     
320     function toHexString(uint256 value) internal pure returns (string memory) {
321         if (value == 0) {
322             return "0x00";
323         }
324         uint256 temp = value;
325         uint256 length = 0;
326         while (temp != 0) {
327             length++;
328             temp >>= 8;
329         }
330         return toHexString(value, length);
331     }
332 
333     
334     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
335         bytes memory buffer = new bytes(2 * length + 2);
336         buffer[0] = "0";
337         buffer[1] = "x";
338         for (uint256 i = 2 * length + 1; i > 1; --i) {
339             buffer[i] = _HEX_SYMBOLS[value & 0xf];
340             value >>= 4;
341         }
342         require(value == 0, "Strings: hex length insufficient");
343         return string(buffer);
344     }
345 }
346 
347 // File: contracts/ERC721.sol
348 
349 pragma solidity >=0.8.0;
350 
351 abstract contract ERC721 {
352     
353 
354     event Transfer(address indexed from, address indexed to, uint256 indexed id);
355 
356     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
357 
358     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
359 
360     
361 
362     string public name;
363 
364     string public symbol;
365 
366     function tokenURI(uint256 id) public view virtual returns (string memory);
367 
368     
369 
370     mapping(address => uint256) public balanceOf;
371 
372     mapping(uint256 => address) public ownerOf;
373 
374     mapping(uint256 => address) public getApproved;
375 
376     mapping(address => mapping(address => bool)) public isApprovedForAll;
377 
378     
379 
380     constructor(string memory _name, string memory _symbol) {
381         name = _name;
382         symbol = _symbol;
383     }
384 
385     
386 
387     function approve(address spender, uint256 id) public virtual {
388         address owner = ownerOf[id];
389 
390         require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");
391 
392         getApproved[id] = spender;
393 
394         emit Approval(owner, spender, id);
395     }
396 
397     function setApprovalForAll(address operator, bool approved) public virtual {
398         isApprovedForAll[msg.sender][operator] = approved;
399 
400         emit ApprovalForAll(msg.sender, operator, approved);
401     }
402 
403     function transferFrom(
404         address from,
405         address to,
406         uint256 id
407     ) public virtual {
408         require(from == ownerOf[id], "WRONG_FROM");
409 
410         require(to != address(0), "INVALID_RECIPIENT");
411 
412         require(
413             msg.sender == from || msg.sender == getApproved[id] || isApprovedForAll[from][msg.sender],
414             "NOT_AUTHORIZED"
415         );
416 
417         // Underflow of the sender's balance is impossible because we check for
418         // ownership above and the recipient's balance can't realistically overflow.
419         unchecked {
420             balanceOf[from]--;
421 
422             balanceOf[to]++;
423         }
424 
425         ownerOf[id] = to;
426 
427         delete getApproved[id];
428 
429         emit Transfer(from, to, id);
430     }
431 
432     function safeTransferFrom(
433         address from,
434         address to,
435         uint256 id
436     ) public virtual {
437         transferFrom(from, to, id);
438 
439         require(
440             to.code.length == 0 ||
441                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
442                 ERC721TokenReceiver.onERC721Received.selector,
443             "UNSAFE_RECIPIENT"
444         );
445     }
446 
447     function safeTransferFrom(
448         address from,
449         address to,
450         uint256 id,
451         bytes memory data
452     ) public virtual {
453         transferFrom(from, to, id);
454 
455         require(
456             to.code.length == 0 ||
457                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
458                 ERC721TokenReceiver.onERC721Received.selector,
459             "UNSAFE_RECIPIENT"
460         );
461     }
462 
463     
464 
465     function supportsInterface(bytes4 interfaceId) public pure virtual returns (bool) {
466         return
467             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
468             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
469             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
470     }
471 
472     
473 
474     function _mint(address to, uint256 id) internal virtual {
475         require(to != address(0), "INVALID_RECIPIENT");
476 
477         require(ownerOf[id] == address(0), "ALREADY_MINTED");
478 
479         // Counter overflow is incredibly unrealistic.
480         unchecked {
481             balanceOf[to]++;
482         }
483 
484         ownerOf[id] = to;
485 
486         emit Transfer(address(0), to, id);
487     }
488 
489     function _burn(uint256 id) internal virtual {
490         address owner = ownerOf[id];
491 
492         require(ownerOf[id] != address(0), "NOT_MINTED");
493 
494         // Ownership check above ensures no underflow.
495         unchecked {
496             balanceOf[owner]--;
497         }
498 
499         delete ownerOf[id];
500 
501         delete getApproved[id];
502 
503         emit Transfer(owner, address(0), id);
504     }
505 
506     
507 
508     function _safeMint(address to, uint256 id) internal virtual {
509         _mint(to, id);
510 
511         require(
512             to.code.length == 0 ||
513                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
514                 ERC721TokenReceiver.onERC721Received.selector,
515             "UNSAFE_RECIPIENT"
516         );
517     }
518 
519     function _safeMint(
520         address to,
521         uint256 id,
522         bytes memory data
523     ) internal virtual {
524         _mint(to, id);
525 
526         require(
527             to.code.length == 0 ||
528                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
529                 ERC721TokenReceiver.onERC721Received.selector,
530             "UNSAFE_RECIPIENT"
531         );
532     }
533 }
534 
535 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
536 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
537 	interface ERC721TokenReceiver {
538 		function onERC721Received(
539 			address operator,
540 			address from,
541 			uint256 id,
542 			bytes calldata data
543 		) external returns (bytes4);
544 	}
545 
546 
547 pragma solidity >=0.8.4;
548 
549 contract PixelEK is ERC721  {
550     uint256 public totalSupply;
551     uint256 public cost = 0.0 ether;
552     uint256 public maxMints = 5;
553     address public owner = msg.sender;
554     address private lmnft = 0x9E6865DAEeeDD093ea4A4f6c9bFbBB0cE6Bc8b17;
555     
556     
557     
558     
559     
560 
561     mapping(address => uint256) internal userMints;
562 
563     error SoldOut();
564     error InsufficientFunds();
565     error MintLimit();
566     error NotOwner();
567     
568     
569 
570     event Minted(
571         address indexed owner,
572         string tokenURI,
573         uint256 indexed mintTime
574     );
575 
576     constructor()
577         ERC721("Evil Kongs - Pixel Edition", "EKPE")
578     {}
579 
580     function mint() external payable {
581         
582         if (userMints[msg.sender] >= maxMints) revert MintLimit();
583         if (totalSupply + 1 > 2023) revert SoldOut();
584         if (msg.value < cost) revert InsufficientFunds();
585         
586         userMints[msg.sender]++;
587         totalSupply++;
588         _safeMint(msg.sender, totalSupply);
589         payable(lmnft).transfer(msg.value / 40);
590         payable(owner).transfer(msg.value - (msg.value / 40));
591         emit Minted(msg.sender, tokenURI(totalSupply), block.timestamp);
592     }
593 
594     
595 
596     function setCost(uint256 _cost) external {
597         if (msg.sender != owner) revert NotOwner();
598         cost = _cost;
599     }
600 
601     function setMaxMints(uint256 _limit) external {
602         if (msg.sender != owner) revert NotOwner();
603         maxMints = _limit;
604     }
605 
606     
607 
608     function tokenURI(uint256 tokenId)
609         public
610         view
611         override(ERC721)
612         returns (string memory)
613     {
614         return
615             string(
616                 abi.encodePacked("ipfs://bafybeidum77qm5pieauvbjihq4h3vtdrnhzr72aguehhpmvsje6h7zckby/", Strings.toString(tokenId), ".json")
617             );
618     }
619 
620     function withdraw() external  {
621         if (msg.sender != owner) revert NotOwner();
622         (bool success, ) = payable(owner).call{value: address(this).balance}("");
623         require(success);
624     }
625     
626 }