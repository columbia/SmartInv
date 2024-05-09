1 pragma solidity ^0.8.0;
2 
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 // File: @openzeppelin/contracts/utils/Address.sol
15 
16 pragma solidity ^0.8.0;
17 
18 library Address {
19     
20     function isContract(address account) internal view returns (bool) {
21         // This method relies on extcodesize, which returns 0 for contracts in
22         // construction, since the code is only stored at the end of the
23         // constructor execution.
24 
25         uint256 size;
26         assembly {
27             size := extcodesize(account)
28         }
29         return size > 0;
30     }
31 
32     
33     function sendValue(address payable recipient, uint256 amount) internal {
34         require(address(this).balance >= amount, "Address: insufficient balance");
35 
36         (bool success, ) = recipient.call{value: amount}("");
37         require(success, "Address: unable to send value, recipient may have reverted");
38     }
39 
40     
41     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
42         return functionCall(target, data, "Address: low-level call failed");
43     }
44 
45     
46     function functionCall(
47         address target,
48         bytes memory data,
49         string memory errorMessage
50     ) internal returns (bytes memory) {
51         return functionCallWithValue(target, data, 0, errorMessage);
52     }
53 
54     
55     function functionCallWithValue(
56         address target,
57         bytes memory data,
58         uint256 value
59     ) internal returns (bytes memory) {
60         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
61     }
62 
63     
64     function functionCallWithValue(
65         address target,
66         bytes memory data,
67         uint256 value,
68         string memory errorMessage
69     ) internal returns (bytes memory) {
70         require(address(this).balance >= value, "Address: insufficient balance for call");
71         require(isContract(target), "Address: call to non-contract");
72 
73         (bool success, bytes memory returndata) = target.call{value: value}(data);
74         return verifyCallResult(success, returndata, errorMessage);
75     }
76 
77     
78     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
79         return functionStaticCall(target, data, "Address: low-level static call failed");
80     }
81 
82     
83     function functionStaticCall(
84         address target,
85         bytes memory data,
86         string memory errorMessage
87     ) internal view returns (bytes memory) {
88         require(isContract(target), "Address: static call to non-contract");
89 
90         (bool success, bytes memory returndata) = target.staticcall(data);
91         return verifyCallResult(success, returndata, errorMessage);
92     }
93 
94     
95     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
96         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
97     }
98 
99     
100     function functionDelegateCall(
101         address target,
102         bytes memory data,
103         string memory errorMessage
104     ) internal returns (bytes memory) {
105         require(isContract(target), "Address: delegate call to non-contract");
106 
107         (bool success, bytes memory returndata) = target.delegatecall(data);
108         return verifyCallResult(success, returndata, errorMessage);
109     }
110 
111     
112     function verifyCallResult(
113         bool success,
114         bytes memory returndata,
115         string memory errorMessage
116     ) internal pure returns (bytes memory) {
117         if (success) {
118             return returndata;
119         } else {
120             // Look for revert reason and bubble it up if present
121             if (returndata.length > 0) {
122                 // The easiest way to bubble the revert reason is using memory via assembly
123 
124                 assembly {
125                     let returndata_size := mload(returndata)
126                     revert(add(32, returndata), returndata_size)
127                 }
128             } else {
129                 revert(errorMessage);
130             }
131         }
132     }
133 }
134 
135 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
136 
137 
138 
139 pragma solidity ^0.8.0;
140 
141 
142 interface IERC20 {
143     
144     function totalSupply() external view returns (uint256);
145 
146     
147     function balanceOf(address account) external view returns (uint256);
148 
149     
150     function transfer(address recipient, uint256 amount) external returns (bool);
151 
152     
153     function allowance(address owner, address spender) external view returns (uint256);
154 
155     
156     function approve(address spender, uint256 amount) external returns (bool);
157 
158     
159     function transferFrom(
160         address sender,
161         address recipient,
162         uint256 amount
163     ) external returns (bool);
164 
165     
166     event Transfer(address indexed from, address indexed to, uint256 value);
167 
168     
169     event Approval(address indexed owner, address indexed spender, uint256 value);
170 }
171 
172 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
173 
174 
175 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 
180 
181 
182 library SafeERC20 {
183     using Address for address;
184 
185     function safeTransfer(
186         IERC20 token,
187         address to,
188         uint256 value
189     ) internal {
190         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
191     }
192 
193     function safeTransferFrom(
194         IERC20 token,
195         address from,
196         address to,
197         uint256 value
198     ) internal {
199         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
200     }
201 
202     
203     function safeApprove(
204         IERC20 token,
205         address spender,
206         uint256 value
207     ) internal {
208         // safeApprove should only be called when setting an initial allowance,
209         // or when resetting it to zero. To increase and decrease it, use
210         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
211         require(
212             (value == 0) || (token.allowance(address(this), spender) == 0),
213             "SafeERC20: approve from non-zero to non-zero allowance"
214         );
215         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
216     }
217 
218     function safeIncreaseAllowance(
219         IERC20 token,
220         address spender,
221         uint256 value
222     ) internal {
223         uint256 newAllowance = token.allowance(address(this), spender) + value;
224         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
225     }
226 
227     function safeDecreaseAllowance(
228         IERC20 token,
229         address spender,
230         uint256 value
231     ) internal {
232         unchecked {
233             uint256 oldAllowance = token.allowance(address(this), spender);
234             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
235             uint256 newAllowance = oldAllowance - value;
236             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
237         }
238     }
239 
240     
241     function _callOptionalReturn(IERC20 token, bytes memory data) private {
242         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
243         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
244         // the target address contains contract code and also asserts for success in the low-level call.
245 
246         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
247         if (returndata.length > 0) {
248             // Return data is optional
249             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
250         }
251     }
252 }
253 
254 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
255 
256 
257 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
258 
259 pragma solidity ^0.8.0;
260 
261 
262 
263 
264 
265 contract PaymentSplitter is Context {
266     event PayeeAdded(address account, uint256 shares);
267     event PaymentReleased(address to, uint256 amount);
268     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
269     event PaymentReceived(address from, uint256 amount);
270 
271     uint256 private _totalShares;
272     uint256 private _totalReleased;
273 
274     mapping(address => uint256) private _shares;
275     mapping(address => uint256) private _released;
276     address[] private _payees;
277 
278     mapping(IERC20 => uint256) private _erc20TotalReleased;
279     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
280 
281     
282     constructor(address[] memory payees, uint256[] memory shares_) payable {
283         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
284         require(payees.length > 0, "PaymentSplitter: no payees");
285 
286         for (uint256 i = 0; i < payees.length; i++) {
287             _addPayee(payees[i], shares_[i]);
288         }
289     }
290 
291     
292     receive() external payable virtual {
293         emit PaymentReceived(_msgSender(), msg.value);
294     }
295 
296     
297     function totalShares() public view returns (uint256) {
298         return _totalShares;
299     }
300 
301     
302     function totalReleased() public view returns (uint256) {
303         return _totalReleased;
304     }
305 
306     
307     function totalReleased(IERC20 token) public view returns (uint256) {
308         return _erc20TotalReleased[token];
309     }
310 
311     
312     function shares(address account) public view returns (uint256) {
313         return _shares[account];
314     }
315 
316     
317     function released(address account) public view returns (uint256) {
318         return _released[account];
319     }
320 
321     
322     function released(IERC20 token, address account) public view returns (uint256) {
323         return _erc20Released[token][account];
324     }
325 
326     
327     function payee(uint256 index) public view returns (address) {
328         return _payees[index];
329     }
330 
331     
332     function release(address payable account) public virtual {
333         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
334 
335         uint256 totalReceived = address(this).balance + totalReleased();
336         uint256 payment = _pendingPayment(account, totalReceived, released(account));
337 
338         require(payment != 0, "PaymentSplitter: account is not due payment");
339 
340         _released[account] += payment;
341         _totalReleased += payment;
342 
343         Address.sendValue(account, payment);
344         emit PaymentReleased(account, payment);
345     }
346 
347     
348     function release(IERC20 token, address account) public virtual {
349         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
350 
351         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
352         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
353 
354         require(payment != 0, "PaymentSplitter: account is not due payment");
355 
356         _erc20Released[token][account] += payment;
357         _erc20TotalReleased[token] += payment;
358 
359         SafeERC20.safeTransfer(token, account, payment);
360         emit ERC20PaymentReleased(token, account, payment);
361     }
362 
363     
364     function _pendingPayment(
365         address account,
366         uint256 totalReceived,
367         uint256 alreadyReleased
368     ) private view returns (uint256) {
369         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
370     }
371 
372     
373     function _addPayee(address account, uint256 shares_) private {
374         require(account != address(0), "PaymentSplitter: account is the zero address");
375         require(shares_ > 0, "PaymentSplitter: shares are 0");
376         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
377 
378         _payees.push(account);
379         _shares[account] = shares_;
380         _totalShares = _totalShares + shares_;
381         emit PayeeAdded(account, shares_);
382     }
383 }
384 
385 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
386 
387 
388 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
389 
390 pragma solidity ^0.8.0;
391 
392 
393 library MerkleProof {
394     
395     function verify(
396         bytes32[] memory proof,
397         bytes32 root,
398         bytes32 leaf
399     ) internal pure returns (bool) {
400         return processProof(proof, leaf) == root;
401     }
402 
403     
404     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
405         bytes32 computedHash = leaf;
406         for (uint256 i = 0; i < proof.length; i++) {
407             bytes32 proofElement = proof[i];
408             if (computedHash <= proofElement) {
409                 // Hash(current computed hash + current element of the proof)
410                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
411             } else {
412                 // Hash(current element of the proof + current computed hash)
413                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
414             }
415         }
416         return computedHash;
417     }
418 }
419 
420 // File: @openzeppelin/contracts/utils/Strings.sol
421 
422 
423 
424 pragma solidity ^0.8.0;
425 
426 
427 library Strings {
428     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
429 
430     
431     function toString(uint256 value) internal pure returns (string memory) {
432         // Inspired by OraclizeAPI's implementation - MIT licence
433         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
434 
435         if (value == 0) {
436             return "0";
437         }
438         uint256 temp = value;
439         uint256 digits;
440         while (temp != 0) {
441             digits++;
442             temp /= 10;
443         }
444         bytes memory buffer = new bytes(digits);
445         while (value != 0) {
446             digits -= 1;
447             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
448             value /= 10;
449         }
450         return string(buffer);
451     }
452 
453     
454     function toHexString(uint256 value) internal pure returns (string memory) {
455         if (value == 0) {
456             return "0x00";
457         }
458         uint256 temp = value;
459         uint256 length = 0;
460         while (temp != 0) {
461             length++;
462             temp >>= 8;
463         }
464         return toHexString(value, length);
465     }
466 
467     
468     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
469         bytes memory buffer = new bytes(2 * length + 2);
470         buffer[0] = "0";
471         buffer[1] = "x";
472         for (uint256 i = 2 * length + 1; i > 1; --i) {
473             buffer[i] = _HEX_SYMBOLS[value & 0xf];
474             value >>= 4;
475         }
476         require(value == 0, "Strings: hex length insufficient");
477         return string(buffer);
478     }
479 }
480 
481 // File: contracts/ERC721.sol
482 
483 
484 pragma solidity >=0.8.0;
485 
486 abstract contract ERC721 {
487     
488 
489     event Transfer(address indexed from, address indexed to, uint256 indexed id);
490 
491     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
492 
493     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
494 
495     
496 
497     string public name;
498 
499     string public symbol;
500 
501     function tokenURI(uint256 id) public view virtual returns (string memory);
502 
503     
504 
505     mapping(address => uint256) public balanceOf;
506 
507     mapping(uint256 => address) public ownerOf;
508 
509     mapping(uint256 => address) public getApproved;
510 
511     mapping(address => mapping(address => bool)) public isApprovedForAll;
512 
513     
514 
515     constructor(string memory _name, string memory _symbol) {
516         name = _name;
517         symbol = _symbol;
518     }
519 
520     
521 
522     function approve(address spender, uint256 id) public virtual {
523         address owner = ownerOf[id];
524 
525         require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");
526 
527         getApproved[id] = spender;
528 
529         emit Approval(owner, spender, id);
530     }
531 
532     function setApprovalForAll(address operator, bool approved) public virtual {
533         isApprovedForAll[msg.sender][operator] = approved;
534 
535         emit ApprovalForAll(msg.sender, operator, approved);
536     }
537 
538     function transferFrom(
539         address from,
540         address to,
541         uint256 id
542     ) public virtual {
543         require(from == ownerOf[id], "WRONG_FROM");
544 
545         require(to != address(0), "INVALID_RECIPIENT");
546 
547         require(
548             msg.sender == from || msg.sender == getApproved[id] || isApprovedForAll[from][msg.sender],
549             "NOT_AUTHORIZED"
550         );
551 
552         // Underflow of the sender's balance is impossible because we check for
553         // ownership above and the recipient's balance can't realistically overflow.
554         unchecked {
555             balanceOf[from]--;
556 
557             balanceOf[to]++;
558         }
559 
560         ownerOf[id] = to;
561 
562         delete getApproved[id];
563 
564         emit Transfer(from, to, id);
565     }
566 
567     function safeTransferFrom(
568         address from,
569         address to,
570         uint256 id
571     ) public virtual {
572         transferFrom(from, to, id);
573 
574         require(
575             to.code.length == 0 ||
576                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
577                 ERC721TokenReceiver.onERC721Received.selector,
578             "UNSAFE_RECIPIENT"
579         );
580     }
581 
582     function safeTransferFrom(
583         address from,
584         address to,
585         uint256 id,
586         bytes memory data
587     ) public virtual {
588         transferFrom(from, to, id);
589 
590         require(
591             to.code.length == 0 ||
592                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
593                 ERC721TokenReceiver.onERC721Received.selector,
594             "UNSAFE_RECIPIENT"
595         );
596     }
597 
598     
599 
600     function supportsInterface(bytes4 interfaceId) public pure virtual returns (bool) {
601         return
602             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
603             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
604             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
605     }
606 
607     
608 
609     function _mint(address to, uint256 id) internal virtual {
610         require(to != address(0), "INVALID_RECIPIENT");
611 
612         require(ownerOf[id] == address(0), "ALREADY_MINTED");
613 
614         // Counter overflow is incredibly unrealistic.
615         unchecked {
616             balanceOf[to]++;
617         }
618 
619         ownerOf[id] = to;
620 
621         emit Transfer(address(0), to, id);
622     }
623 
624     function _burn(uint256 id) internal virtual {
625         address owner = ownerOf[id];
626 
627         require(ownerOf[id] != address(0), "NOT_MINTED");
628 
629         // Ownership check above ensures no underflow.
630         unchecked {
631             balanceOf[owner]--;
632         }
633 
634         delete ownerOf[id];
635 
636         delete getApproved[id];
637 
638         emit Transfer(owner, address(0), id);
639     }
640 
641     
642 
643     function _safeMint(address to, uint256 id) internal virtual {
644         _mint(to, id);
645 
646         require(
647             to.code.length == 0 ||
648                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
649                 ERC721TokenReceiver.onERC721Received.selector,
650             "UNSAFE_RECIPIENT"
651         );
652     }
653 
654     function _safeMint(
655         address to,
656         uint256 id,
657         bytes memory data
658     ) internal virtual {
659         _mint(to, id);
660 
661         require(
662             to.code.length == 0 ||
663                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
664                 ERC721TokenReceiver.onERC721Received.selector,
665             "UNSAFE_RECIPIENT"
666         );
667     }
668 }
669 	interface ERC721TokenReceiver {
670 		function onERC721Received(
671 			address operator,
672 			address from,
673 			uint256 id,
674 			bytes calldata data
675 		) external returns (bytes4);
676 	}
677 
678 pragma solidity ^0.8.10;
679 
680 contract Strudels is ERC721, PaymentSplitter {
681     uint256 public totalSupply;
682     uint256 private cost = 0.02 ether;
683     uint256 private whitelistCost = 0.00 ether;
684     bytes32 private merkleRoot;
685     address public owner = msg.sender;
686     bool public whitelistActive = true;
687 
688     mapping(address => bool) public whitelistClaimed;
689 
690     error WhitelistActive();
691     error WhitelistDisabled();
692     error SoldOut();
693 	error InsufficientFunds();
694 	error AlreadyClaimed();
695 	error InvalidProof();
696 	error NotOwner();
697 
698     event Minted(
699         address indexed owner,
700         string tokenURI,
701         uint256 indexed mintTime
702     );
703 
704     constructor(address[] memory _payees, uint256[] memory _shares)
705         ERC721("Strudels", "STRDLS")
706         PaymentSplitter(_payees, _shares)
707     {}
708 
709     function setWhitelist(bytes32 _merkleRoot) external {
710 		if (msg.sender != owner) revert NotOwner();
711         merkleRoot = _merkleRoot;
712     }
713 
714     function removeWhitelist() external {
715         if (msg.sender != owner) revert NotOwner();
716         if (!whitelistActive) revert WhitelistDisabled();
717         whitelistActive = false;
718     }
719 
720     function mint() external payable {
721         if (whitelistActive) revert WhitelistActive();
722         if (totalSupply + 1 > 2000) revert SoldOut();
723 		if (msg.value < cost) revert InsufficientFunds();
724         totalSupply++;
725         _safeMint(msg.sender, totalSupply);
726         emit Minted(msg.sender, tokenURI(totalSupply), block.timestamp);
727     }
728 
729     function whitelistedMint(bytes32[] calldata _merkleProof) external payable {
730 		if (whitelistClaimed[msg.sender]) revert AlreadyClaimed();
731    		if (totalSupply + 1 > 2000) revert SoldOut();
732 		if (msg.value < whitelistCost) revert InsufficientFunds();
733 
734         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
735 
736 		if (!MerkleProof.verify(_merkleProof, merkleRoot, leaf)) revert InvalidProof();
737 
738         whitelistClaimed[msg.sender] = true;
739         totalSupply++;
740         _safeMint(msg.sender, totalSupply);
741         emit Minted(msg.sender, tokenURI(totalSupply), block.timestamp);
742     }
743 
744     function tokenURI(uint256 tokenId)
745         public
746         pure
747         override(ERC721)
748         returns (string memory)
749     {
750         return
751             string(
752                 abi.encodePacked(
753                     "ipfs://QmabawcqzWqBh44egDKbeXRNn3N3YJmP46MyeWQHosm49c/",
754                     Strings.toString(tokenId),
755                     ".json"
756                 )
757             );
758     }
759 }