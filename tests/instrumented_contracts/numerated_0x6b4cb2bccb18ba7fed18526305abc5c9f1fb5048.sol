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
266 
267 
268 
269 
270 contract PaymentSplitter is Context {
271     event PayeeAdded(address account, uint256 shares);
272     event PaymentReleased(address to, uint256 amount);
273     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
274     event PaymentReceived(address from, uint256 amount);
275 
276     uint256 private _totalShares;
277     uint256 private _totalReleased;
278 
279     mapping(address => uint256) private _shares;
280     mapping(address => uint256) private _released;
281     address[] private _payees;
282 
283     mapping(IERC20 => uint256) private _erc20TotalReleased;
284     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
285 
286     
287     constructor(address[] memory payees, uint256[] memory shares_) payable {
288         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
289         require(payees.length > 0, "PaymentSplitter: no payees");
290 
291         for (uint256 i = 0; i < payees.length; i++) {
292             _addPayee(payees[i], shares_[i]);
293         }
294     }
295 
296     
297     receive() external payable virtual {
298         emit PaymentReceived(_msgSender(), msg.value);
299     }
300 
301     
302     function totalShares() public view returns (uint256) {
303         return _totalShares;
304     }
305 
306     
307     function totalReleased() public view returns (uint256) {
308         return _totalReleased;
309     }
310 
311     
312     function totalReleased(IERC20 token) public view returns (uint256) {
313         return _erc20TotalReleased[token];
314     }
315 
316     
317     function shares(address account) public view returns (uint256) {
318         return _shares[account];
319     }
320 
321     
322     function released(address account) public view returns (uint256) {
323         return _released[account];
324     }
325 
326     
327     function released(IERC20 token, address account) public view returns (uint256) {
328         return _erc20Released[token][account];
329     }
330 
331     
332     function payee(uint256 index) public view returns (address) {
333         return _payees[index];
334     }
335 
336     
337     function release(address payable account) public virtual {
338         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
339 
340         uint256 totalReceived = address(this).balance + totalReleased();
341         uint256 payment = _pendingPayment(account, totalReceived, released(account));
342 
343         require(payment != 0, "PaymentSplitter: account is not due payment");
344 
345         _released[account] += payment;
346         _totalReleased += payment;
347 
348         Address.sendValue(account, payment);
349         emit PaymentReleased(account, payment);
350     }
351 
352     
353     function release(IERC20 token, address account) public virtual {
354         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
355 
356         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
357         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
358 
359         require(payment != 0, "PaymentSplitter: account is not due payment");
360 
361         _erc20Released[token][account] += payment;
362         _erc20TotalReleased[token] += payment;
363 
364         SafeERC20.safeTransfer(token, account, payment);
365         emit ERC20PaymentReleased(token, account, payment);
366     }
367 
368     
369     function _pendingPayment(
370         address account,
371         uint256 totalReceived,
372         uint256 alreadyReleased
373     ) private view returns (uint256) {
374         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
375     }
376 
377     
378     function _addPayee(address account, uint256 shares_) private {
379         require(account != address(0), "PaymentSplitter: account is the zero address");
380         require(shares_ > 0, "PaymentSplitter: shares are 0");
381         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
382 
383         _payees.push(account);
384         _shares[account] = shares_;
385         _totalShares = _totalShares + shares_;
386         emit PayeeAdded(account, shares_);
387     }
388 }
389 
390 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
391 
392 
393 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 
398 library MerkleProof {
399     
400     function verify(
401         bytes32[] memory proof,
402         bytes32 root,
403         bytes32 leaf
404     ) internal pure returns (bool) {
405         return processProof(proof, leaf) == root;
406     }
407 
408     
409     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
410         bytes32 computedHash = leaf;
411         for (uint256 i = 0; i < proof.length; i++) {
412             bytes32 proofElement = proof[i];
413             if (computedHash <= proofElement) {
414                 // Hash(current computed hash + current element of the proof)
415                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
416             } else {
417                 // Hash(current element of the proof + current computed hash)
418                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
419             }
420         }
421         return computedHash;
422     }
423 }
424 
425 // File: @openzeppelin/contracts/utils/Strings.sol
426 
427 
428 
429 pragma solidity ^0.8.0;
430 
431 
432 library Strings {
433     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
434 
435     
436     function toString(uint256 value) internal pure returns (string memory) {
437         // Inspired by OraclizeAPI's implementation - MIT licence
438         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
439 
440         if (value == 0) {
441             return "0";
442         }
443         uint256 temp = value;
444         uint256 digits;
445         while (temp != 0) {
446             digits++;
447             temp /= 10;
448         }
449         bytes memory buffer = new bytes(digits);
450         while (value != 0) {
451             digits -= 1;
452             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
453             value /= 10;
454         }
455         return string(buffer);
456     }
457 
458     
459     function toHexString(uint256 value) internal pure returns (string memory) {
460         if (value == 0) {
461             return "0x00";
462         }
463         uint256 temp = value;
464         uint256 length = 0;
465         while (temp != 0) {
466             length++;
467             temp >>= 8;
468         }
469         return toHexString(value, length);
470     }
471 
472     
473     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
474         bytes memory buffer = new bytes(2 * length + 2);
475         buffer[0] = "0";
476         buffer[1] = "x";
477         for (uint256 i = 2 * length + 1; i > 1; --i) {
478             buffer[i] = _HEX_SYMBOLS[value & 0xf];
479             value >>= 4;
480         }
481         require(value == 0, "Strings: hex length insufficient");
482         return string(buffer);
483     }
484 }
485 
486 // File: contracts/ERC721.sol
487 
488 
489 pragma solidity >=0.8.0;
490 
491 abstract contract ERC721 {
492     
493 
494     event Transfer(address indexed from, address indexed to, uint256 indexed id);
495 
496     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
497 
498     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
499 
500     
501 
502     string public name;
503 
504     string public symbol;
505 
506     function tokenURI(uint256 id) public view virtual returns (string memory);
507 
508     
509 
510     mapping(address => uint256) public balanceOf;
511 
512     mapping(uint256 => address) public ownerOf;
513 
514     mapping(uint256 => address) public getApproved;
515 
516     mapping(address => mapping(address => bool)) public isApprovedForAll;
517 
518     
519 
520     constructor(string memory _name, string memory _symbol) {
521         name = _name;
522         symbol = _symbol;
523     }
524 
525     
526 
527     function approve(address spender, uint256 id) public virtual {
528         address owner = ownerOf[id];
529 
530         require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");
531 
532         getApproved[id] = spender;
533 
534         emit Approval(owner, spender, id);
535     }
536 
537     function setApprovalForAll(address operator, bool approved) public virtual {
538         isApprovedForAll[msg.sender][operator] = approved;
539 
540         emit ApprovalForAll(msg.sender, operator, approved);
541     }
542 
543     function transferFrom(
544         address from,
545         address to,
546         uint256 id
547     ) public virtual {
548         require(from == ownerOf[id], "WRONG_FROM");
549 
550         require(to != address(0), "INVALID_RECIPIENT");
551 
552         require(
553             msg.sender == from || msg.sender == getApproved[id] || isApprovedForAll[from][msg.sender],
554             "NOT_AUTHORIZED"
555         );
556 
557         // Underflow of the sender's balance is impossible because we check for
558         // ownership above and the recipient's balance can't realistically overflow.
559         unchecked {
560             balanceOf[from]--;
561 
562             balanceOf[to]++;
563         }
564 
565         ownerOf[id] = to;
566 
567         delete getApproved[id];
568 
569         emit Transfer(from, to, id);
570     }
571 
572     function safeTransferFrom(
573         address from,
574         address to,
575         uint256 id
576     ) public virtual {
577         transferFrom(from, to, id);
578 
579         require(
580             to.code.length == 0 ||
581                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
582                 ERC721TokenReceiver.onERC721Received.selector,
583             "UNSAFE_RECIPIENT"
584         );
585     }
586 
587     function safeTransferFrom(
588         address from,
589         address to,
590         uint256 id,
591         bytes memory data
592     ) public virtual {
593         transferFrom(from, to, id);
594 
595         require(
596             to.code.length == 0 ||
597                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
598                 ERC721TokenReceiver.onERC721Received.selector,
599             "UNSAFE_RECIPIENT"
600         );
601     }
602 
603     
604 
605     function supportsInterface(bytes4 interfaceId) public pure virtual returns (bool) {
606         return
607             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
608             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
609             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
610     }
611 
612     
613 
614     function _mint(address to, uint256 id) internal virtual {
615         require(to != address(0), "INVALID_RECIPIENT");
616 
617         require(ownerOf[id] == address(0), "ALREADY_MINTED");
618 
619         // Counter overflow is incredibly unrealistic.
620         unchecked {
621             balanceOf[to]++;
622         }
623 
624         ownerOf[id] = to;
625 
626         emit Transfer(address(0), to, id);
627     }
628 
629     function _burn(uint256 id) internal virtual {
630         address owner = ownerOf[id];
631 
632         require(ownerOf[id] != address(0), "NOT_MINTED");
633 
634         // Ownership check above ensures no underflow.
635         unchecked {
636             balanceOf[owner]--;
637         }
638 
639         delete ownerOf[id];
640 
641         delete getApproved[id];
642 
643         emit Transfer(owner, address(0), id);
644     }
645 
646     
647 
648     function _safeMint(address to, uint256 id) internal virtual {
649         _mint(to, id);
650 
651         require(
652             to.code.length == 0 ||
653                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
654                 ERC721TokenReceiver.onERC721Received.selector,
655             "UNSAFE_RECIPIENT"
656         );
657     }
658 
659     function _safeMint(
660         address to,
661         uint256 id,
662         bytes memory data
663     ) internal virtual {
664         _mint(to, id);
665 
666         require(
667             to.code.length == 0 ||
668                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
669                 ERC721TokenReceiver.onERC721Received.selector,
670             "UNSAFE_RECIPIENT"
671         );
672     }
673 }
674 
675 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
676 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
677 	interface ERC721TokenReceiver {
678 		function onERC721Received(
679 			address operator,
680 			address from,
681 			uint256 id,
682 			bytes calldata data
683 		) external returns (bytes4);
684 	}
685 // File: contracts/dsadsaa.sol
686 
687 pragma solidity >=0.8.4;
688 
689 
690 
691 
692 
693 contract BACSbyISMTOYS is ERC721, PaymentSplitter {
694     uint256 public totalSupply;
695     uint256 private cost = 0.16 ether;
696     uint256 private whitelistCost = 0.16 ether;
697     address public owner = msg.sender;
698     bytes32 private merkleRoot;
699     bool public whitelistActive = true;
700     string baseURI;
701 
702     mapping(address => bool) internal whitelistClaimed;
703 
704     error WhitelistActive();
705     error SoldOut();
706     error InsufficientFunds();
707     error AlreadyClaimed();
708     error InvalidProof();
709     error NotOwner();
710     error MintNotEnabled();
711     error URIAlreadySet();
712     error WhitelistDisabled();
713 
714     event Minted(
715         address indexed owner,
716         string tokenURI,
717         uint256 indexed mintTime
718     );
719 
720     constructor(address[] memory _payees, uint256[] memory _shares)
721         ERC721("The Bored Ape Chess Set by IsmToys", "BACS")
722         PaymentSplitter(_payees, _shares)
723     {}
724 
725     function setWhitelist(bytes32 _merkleRoot) external {
726 		if (msg.sender != owner) revert NotOwner();
727         merkleRoot = _merkleRoot;
728     }
729 
730     function removeWhitelist() external {
731         if (msg.sender != owner) revert NotOwner();
732         if (!whitelistActive) revert WhitelistDisabled();
733         whitelistActive = false;
734     }
735 
736     function mint() external payable {
737         if (bytes(baseURI).length == 0) revert MintNotEnabled();
738         if (whitelistActive) revert WhitelistActive();
739         if (totalSupply + 1 > 399) revert SoldOut();
740         if (msg.value < cost) revert InsufficientFunds();
741         totalSupply++;
742         _safeMint(msg.sender, totalSupply);
743         emit Minted(msg.sender, tokenURI(totalSupply), block.timestamp);
744     }
745 
746     function whitelistedMint(bytes32[] calldata _merkleProof) external payable {
747         if (bytes(baseURI).length == 0) revert MintNotEnabled();
748         if (whitelistClaimed[msg.sender]) revert AlreadyClaimed();
749         if (totalSupply + 1 > 399) revert SoldOut();
750         if (msg.value < whitelistCost) revert InsufficientFunds();
751 
752         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
753 
754         if (!MerkleProof.verify(_merkleProof, merkleRoot, leaf))
755             revert InvalidProof();
756 
757         whitelistClaimed[msg.sender] = true;
758         totalSupply++;
759         _safeMint(msg.sender, totalSupply);
760         emit Minted(msg.sender, tokenURI(totalSupply), block.timestamp);
761     }
762 
763     function setBaseURI(string memory _uri) external {
764         if (bytes(baseURI).length > 0) revert URIAlreadySet();
765         if (msg.sender != owner) revert NotOwner();
766         baseURI = _uri;
767     }
768 
769     function tokenURI(uint256 tokenId)
770         public
771         view
772         override(ERC721)
773         returns (string memory)
774     {
775         return
776             string(
777                 abi.encodePacked(baseURI, Strings.toString(tokenId), ".json")
778             );
779     }
780 }