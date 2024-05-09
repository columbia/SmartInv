1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Context.sol
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
18 
19 
20 pragma solidity ^0.8.0;
21 
22 
23 library Address {
24     
25     function isContract(address account) internal view returns (bool) {
26         // This method relies on extcodesize, which returns 0 for contracts in
27         // construction, since the code is only stored at the end of the
28         // constructor execution.
29 
30         uint256 size;
31         assembly {
32             size := extcodesize(account)
33         }
34         return size > 0;
35     }
36 
37     
38     function sendValue(address payable recipient, uint256 amount) internal {
39         require(address(this).balance >= amount, "Address: insufficient balance");
40 
41         (bool success, ) = recipient.call{value: amount}("");
42         require(success, "Address: unable to send value, recipient may have reverted");
43     }
44 
45     
46     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
47         return functionCall(target, data, "Address: low-level call failed");
48     }
49 
50     
51     function functionCall(
52         address target,
53         bytes memory data,
54         string memory errorMessage
55     ) internal returns (bytes memory) {
56         return functionCallWithValue(target, data, 0, errorMessage);
57     }
58 
59     
60     function functionCallWithValue(
61         address target,
62         bytes memory data,
63         uint256 value
64     ) internal returns (bytes memory) {
65         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
66     }
67 
68     
69     function functionCallWithValue(
70         address target,
71         bytes memory data,
72         uint256 value,
73         string memory errorMessage
74     ) internal returns (bytes memory) {
75         require(address(this).balance >= value, "Address: insufficient balance for call");
76         require(isContract(target), "Address: call to non-contract");
77 
78         (bool success, bytes memory returndata) = target.call{value: value}(data);
79         return verifyCallResult(success, returndata, errorMessage);
80     }
81 
82     
83     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
84         return functionStaticCall(target, data, "Address: low-level static call failed");
85     }
86 
87     
88     function functionStaticCall(
89         address target,
90         bytes memory data,
91         string memory errorMessage
92     ) internal view returns (bytes memory) {
93         require(isContract(target), "Address: static call to non-contract");
94 
95         (bool success, bytes memory returndata) = target.staticcall(data);
96         return verifyCallResult(success, returndata, errorMessage);
97     }
98 
99     
100     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
101         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
102     }
103 
104     
105     function functionDelegateCall(
106         address target,
107         bytes memory data,
108         string memory errorMessage
109     ) internal returns (bytes memory) {
110         require(isContract(target), "Address: delegate call to non-contract");
111 
112         (bool success, bytes memory returndata) = target.delegatecall(data);
113         return verifyCallResult(success, returndata, errorMessage);
114     }
115 
116     
117     function verifyCallResult(
118         bool success,
119         bytes memory returndata,
120         string memory errorMessage
121     ) internal pure returns (bytes memory) {
122         if (success) {
123             return returndata;
124         } else {
125             // Look for revert reason and bubble it up if present
126             if (returndata.length > 0) {
127                 // The easiest way to bubble the revert reason is using memory via assembly
128 
129                 assembly {
130                     let returndata_size := mload(returndata)
131                     revert(add(32, returndata), returndata_size)
132                 }
133             } else {
134                 revert(errorMessage);
135             }
136         }
137     }
138 }
139 
140 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
141 
142 
143 
144 pragma solidity ^0.8.0;
145 
146 
147 interface IERC20 {
148     
149     function totalSupply() external view returns (uint256);
150 
151     
152     function balanceOf(address account) external view returns (uint256);
153 
154     
155     function transfer(address recipient, uint256 amount) external returns (bool);
156 
157     
158     function allowance(address owner, address spender) external view returns (uint256);
159 
160     
161     function approve(address spender, uint256 amount) external returns (bool);
162 
163     
164     function transferFrom(
165         address sender,
166         address recipient,
167         uint256 amount
168     ) external returns (bool);
169 
170     
171     event Transfer(address indexed from, address indexed to, uint256 value);
172 
173     
174     event Approval(address indexed owner, address indexed spender, uint256 value);
175 }
176 
177 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
178 
179 
180 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 
185 
186 
187 library SafeERC20 {
188     using Address for address;
189 
190     function safeTransfer(
191         IERC20 token,
192         address to,
193         uint256 value
194     ) internal {
195         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
196     }
197 
198     function safeTransferFrom(
199         IERC20 token,
200         address from,
201         address to,
202         uint256 value
203     ) internal {
204         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
205     }
206 
207     
208     function safeApprove(
209         IERC20 token,
210         address spender,
211         uint256 value
212     ) internal {
213         // safeApprove should only be called when setting an initial allowance,
214         // or when resetting it to zero. To increase and decrease it, use
215         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
216         require(
217             (value == 0) || (token.allowance(address(this), spender) == 0),
218             "SafeERC20: approve from non-zero to non-zero allowance"
219         );
220         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
221     }
222 
223     function safeIncreaseAllowance(
224         IERC20 token,
225         address spender,
226         uint256 value
227     ) internal {
228         uint256 newAllowance = token.allowance(address(this), spender) + value;
229         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
230     }
231 
232     function safeDecreaseAllowance(
233         IERC20 token,
234         address spender,
235         uint256 value
236     ) internal {
237         unchecked {
238             uint256 oldAllowance = token.allowance(address(this), spender);
239             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
240             uint256 newAllowance = oldAllowance - value;
241             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
242         }
243     }
244 
245     
246     function _callOptionalReturn(IERC20 token, bytes memory data) private {
247         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
248         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
249         // the target address contains contract code and also asserts for success in the low-level call.
250 
251         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
252         if (returndata.length > 0) {
253             // Return data is optional
254             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
255         }
256     }
257 }
258 
259 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
260 
261 
262 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 contract PaymentSplitter is Context {
267     event PayeeAdded(address account, uint256 shares);
268     event PaymentReleased(address to, uint256 amount);
269     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
270     event PaymentReceived(address from, uint256 amount);
271 
272     uint256 private _totalShares;
273     uint256 private _totalReleased;
274 
275     mapping(address => uint256) private _shares;
276     mapping(address => uint256) private _released;
277     address[] private _payees;
278 
279     mapping(IERC20 => uint256) private _erc20TotalReleased;
280     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
281 
282     
283     constructor(address[] memory payees, uint256[] memory shares_) payable {
284         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
285         require(payees.length > 0, "PaymentSplitter: no payees");
286 
287         for (uint256 i = 0; i < payees.length; i++) {
288             _addPayee(payees[i], shares_[i]);
289         }
290     }
291 
292     
293     receive() external payable virtual {
294         emit PaymentReceived(_msgSender(), msg.value);
295     }
296 
297     
298     function totalShares() public view returns (uint256) {
299         return _totalShares;
300     }
301 
302     
303     function totalReleased() public view returns (uint256) {
304         return _totalReleased;
305     }
306 
307     
308     function totalReleased(IERC20 token) public view returns (uint256) {
309         return _erc20TotalReleased[token];
310     }
311 
312     
313     function shares(address account) public view returns (uint256) {
314         return _shares[account];
315     }
316 
317     
318     function released(address account) public view returns (uint256) {
319         return _released[account];
320     }
321 
322     
323     function released(IERC20 token, address account) public view returns (uint256) {
324         return _erc20Released[token][account];
325     }
326 
327     
328     function payee(uint256 index) public view returns (address) {
329         return _payees[index];
330     }
331 
332     
333     function release(address payable account) public virtual {
334         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
335 
336         uint256 totalReceived = address(this).balance + totalReleased();
337         uint256 payment = _pendingPayment(account, totalReceived, released(account));
338 
339         require(payment != 0, "PaymentSplitter: account is not due payment");
340 
341         _released[account] += payment;
342         _totalReleased += payment;
343 
344         Address.sendValue(account, payment);
345         emit PaymentReleased(account, payment);
346     }
347 
348     
349     function release(IERC20 token, address account) public virtual {
350         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
351 
352         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
353         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
354 
355         require(payment != 0, "PaymentSplitter: account is not due payment");
356 
357         _erc20Released[token][account] += payment;
358         _erc20TotalReleased[token] += payment;
359 
360         SafeERC20.safeTransfer(token, account, payment);
361         emit ERC20PaymentReleased(token, account, payment);
362     }
363 
364     
365     function _pendingPayment(
366         address account,
367         uint256 totalReceived,
368         uint256 alreadyReleased
369     ) private view returns (uint256) {
370         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
371     }
372 
373     
374     function _addPayee(address account, uint256 shares_) private {
375         require(account != address(0), "PaymentSplitter: account is the zero address");
376         require(shares_ > 0, "PaymentSplitter: shares are 0");
377         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
378 
379         _payees.push(account);
380         _shares[account] = shares_;
381         _totalShares = _totalShares + shares_;
382         emit PayeeAdded(account, shares_);
383     }
384 }
385 
386 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
387 
388 
389 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
390 
391 pragma solidity ^0.8.0;
392 
393 
394 library MerkleProof {
395     
396     function verify(
397         bytes32[] memory proof,
398         bytes32 root,
399         bytes32 leaf
400     ) internal pure returns (bool) {
401         return processProof(proof, leaf) == root;
402     }
403 
404     
405     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
406         bytes32 computedHash = leaf;
407         for (uint256 i = 0; i < proof.length; i++) {
408             bytes32 proofElement = proof[i];
409             if (computedHash <= proofElement) {
410                 // Hash(current computed hash + current element of the proof)
411                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
412             } else {
413                 // Hash(current element of the proof + current computed hash)
414                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
415             }
416         }
417         return computedHash;
418     }
419 }
420 
421 // File: @openzeppelin/contracts/utils/Strings.sol
422 
423 
424 
425 pragma solidity ^0.8.0;
426 
427 
428 library Strings {
429     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
430 
431     
432     function toString(uint256 value) internal pure returns (string memory) {
433         // Inspired by OraclizeAPI's implementation - MIT licence
434         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
435 
436         if (value == 0) {
437             return "0";
438         }
439         uint256 temp = value;
440         uint256 digits;
441         while (temp != 0) {
442             digits++;
443             temp /= 10;
444         }
445         bytes memory buffer = new bytes(digits);
446         while (value != 0) {
447             digits -= 1;
448             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
449             value /= 10;
450         }
451         return string(buffer);
452     }
453 
454     
455     function toHexString(uint256 value) internal pure returns (string memory) {
456         if (value == 0) {
457             return "0x00";
458         }
459         uint256 temp = value;
460         uint256 length = 0;
461         while (temp != 0) {
462             length++;
463             temp >>= 8;
464         }
465         return toHexString(value, length);
466     }
467 
468     
469     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
470         bytes memory buffer = new bytes(2 * length + 2);
471         buffer[0] = "0";
472         buffer[1] = "x";
473         for (uint256 i = 2 * length + 1; i > 1; --i) {
474             buffer[i] = _HEX_SYMBOLS[value & 0xf];
475             value >>= 4;
476         }
477         require(value == 0, "Strings: hex length insufficient");
478         return string(buffer);
479     }
480 }
481 
482 // File: contracts/ERC721.sol
483 
484 
485 pragma solidity >=0.8.0;
486 
487 abstract contract ERC721 {
488     
489 
490     event Transfer(address indexed from, address indexed to, uint256 indexed id);
491 
492     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
493 
494     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
495 
496     
497 
498     string public name;
499 
500     string public symbol;
501 
502     function tokenURI(uint256 id) public view virtual returns (string memory);
503 
504     
505 
506     mapping(address => uint256) public balanceOf;
507 
508     mapping(uint256 => address) public ownerOf;
509 
510     mapping(uint256 => address) public getApproved;
511 
512     mapping(address => mapping(address => bool)) public isApprovedForAll;
513 
514     
515 
516     constructor(string memory _name, string memory _symbol) {
517         name = _name;
518         symbol = _symbol;
519     }
520 
521     
522 
523     function approve(address spender, uint256 id) public virtual {
524         address owner = ownerOf[id];
525 
526         require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");
527 
528         getApproved[id] = spender;
529 
530         emit Approval(owner, spender, id);
531     }
532 
533     function setApprovalForAll(address operator, bool approved) public virtual {
534         isApprovedForAll[msg.sender][operator] = approved;
535 
536         emit ApprovalForAll(msg.sender, operator, approved);
537     }
538 
539     function transferFrom(
540         address from,
541         address to,
542         uint256 id
543     ) public virtual {
544         require(from == ownerOf[id], "WRONG_FROM");
545 
546         require(to != address(0), "INVALID_RECIPIENT");
547 
548         require(
549             msg.sender == from || msg.sender == getApproved[id] || isApprovedForAll[from][msg.sender],
550             "NOT_AUTHORIZED"
551         );
552 
553         // Underflow of the sender's balance is impossible because we check for
554         // ownership above and the recipient's balance can't realistically overflow.
555         unchecked {
556             balanceOf[from]--;
557 
558             balanceOf[to]++;
559         }
560 
561         ownerOf[id] = to;
562 
563         delete getApproved[id];
564 
565         emit Transfer(from, to, id);
566     }
567 
568     function safeTransferFrom(
569         address from,
570         address to,
571         uint256 id
572     ) public virtual {
573         transferFrom(from, to, id);
574 
575         require(
576             to.code.length == 0 ||
577                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
578                 ERC721TokenReceiver.onERC721Received.selector,
579             "UNSAFE_RECIPIENT"
580         );
581     }
582 
583     function safeTransferFrom(
584         address from,
585         address to,
586         uint256 id,
587         bytes memory data
588     ) public virtual {
589         transferFrom(from, to, id);
590 
591         require(
592             to.code.length == 0 ||
593                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
594                 ERC721TokenReceiver.onERC721Received.selector,
595             "UNSAFE_RECIPIENT"
596         );
597     }
598 
599     
600 
601     function supportsInterface(bytes4 interfaceId) public pure virtual returns (bool) {
602         return
603             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
604             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
605             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
606     }
607 
608     
609 
610     function _mint(address to, uint256 id) internal virtual {
611         require(to != address(0), "INVALID_RECIPIENT");
612 
613         require(ownerOf[id] == address(0), "ALREADY_MINTED");
614 
615         // Counter overflow is incredibly unrealistic.
616         unchecked {
617             balanceOf[to]++;
618         }
619 
620         ownerOf[id] = to;
621 
622         emit Transfer(address(0), to, id);
623     }
624 
625     function _burn(uint256 id) internal virtual {
626         address owner = ownerOf[id];
627 
628         require(ownerOf[id] != address(0), "NOT_MINTED");
629 
630         // Ownership check above ensures no underflow.
631         unchecked {
632             balanceOf[owner]--;
633         }
634 
635         delete ownerOf[id];
636 
637         delete getApproved[id];
638 
639         emit Transfer(owner, address(0), id);
640     }
641 
642     
643 
644     function _safeMint(address to, uint256 id) internal virtual {
645         _mint(to, id);
646 
647         require(
648             to.code.length == 0 ||
649                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
650                 ERC721TokenReceiver.onERC721Received.selector,
651             "UNSAFE_RECIPIENT"
652         );
653     }
654 
655     function _safeMint(
656         address to,
657         uint256 id,
658         bytes memory data
659     ) internal virtual {
660         _mint(to, id);
661 
662         require(
663             to.code.length == 0 ||
664                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
665                 ERC721TokenReceiver.onERC721Received.selector,
666             "UNSAFE_RECIPIENT"
667         );
668     }
669 }
670 
671 	interface ERC721TokenReceiver {
672 		function onERC721Received(
673 			address operator,
674 			address from,
675 			uint256 id,
676 			bytes calldata data
677 		) external returns (bytes4);
678 	}
679 
680 pragma solidity >=0.8.4;
681 
682 contract SuperSaiyanNFTs is ERC721, PaymentSplitter {
683     uint256 public totalSupply;
684     uint256 private cost = 0 ether;
685     address public owner = msg.sender;
686 
687     error SoldOut();
688     error InsufficientFunds();
689     error NotOwner();
690 
691     event Minted(address indexed owner, string tokenURI, uint256 indexed mintTime);
692 
693     constructor(address[] memory _payees, uint256[] memory _shares)
694         ERC721("Super Saiyan Army", "SSJA")
695         PaymentSplitter(_payees, _shares)
696     {}
697 
698     function mint() external payable {
699         if (totalSupply + 1 > 2000) revert SoldOut();
700         if (msg.value < cost) revert InsufficientFunds();
701         totalSupply++;
702         _safeMint(msg.sender, totalSupply);
703         emit Minted(msg.sender, tokenURI(totalSupply), block.timestamp);
704     }
705 
706     function tokenURI(uint256 tokenId)
707         public
708         pure
709         override(ERC721)
710         returns (string memory)
711     {
712         return
713             string(
714                 abi.encodePacked(
715                     "ipfs://bafybeiakce3oajngsvclli4cbdoqeckimiccgvguvrku7apl2fcix4dvpy/",
716                     Strings.toString(tokenId),
717                     ".json"
718                 )
719             );
720     }
721 }