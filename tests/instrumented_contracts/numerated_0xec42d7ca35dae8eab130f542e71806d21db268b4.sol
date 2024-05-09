1 // File: @openzeppelin/contracts/utils/Context.sol
2 pragma solidity ^0.8.0;
3 
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 // File: @openzeppelin/contracts/utils/Address.sol
16 
17 
18 
19 pragma solidity ^0.8.0;
20 
21 
22 library Address {
23     
24     function isContract(address account) internal view returns (bool) {
25         // This method relies on extcodesize, which returns 0 for contracts in
26         // construction, since the code is only stored at the end of the
27         // constructor execution.
28 
29         uint256 size;
30         assembly {
31             size := extcodesize(account)
32         }
33         return size > 0;
34     }
35 
36     
37     function sendValue(address payable recipient, uint256 amount) internal {
38         require(address(this).balance >= amount, "Address: insufficient balance");
39 
40         (bool success, ) = recipient.call{value: amount}("");
41         require(success, "Address: unable to send value, recipient may have reverted");
42     }
43 
44     
45     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
46         return functionCall(target, data, "Address: low-level call failed");
47     }
48 
49     
50     function functionCall(
51         address target,
52         bytes memory data,
53         string memory errorMessage
54     ) internal returns (bytes memory) {
55         return functionCallWithValue(target, data, 0, errorMessage);
56     }
57 
58     
59     function functionCallWithValue(
60         address target,
61         bytes memory data,
62         uint256 value
63     ) internal returns (bytes memory) {
64         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
65     }
66 
67     
68     function functionCallWithValue(
69         address target,
70         bytes memory data,
71         uint256 value,
72         string memory errorMessage
73     ) internal returns (bytes memory) {
74         require(address(this).balance >= value, "Address: insufficient balance for call");
75         require(isContract(target), "Address: call to non-contract");
76 
77         (bool success, bytes memory returndata) = target.call{value: value}(data);
78         return verifyCallResult(success, returndata, errorMessage);
79     }
80 
81     
82     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
83         return functionStaticCall(target, data, "Address: low-level static call failed");
84     }
85 
86     
87     function functionStaticCall(
88         address target,
89         bytes memory data,
90         string memory errorMessage
91     ) internal view returns (bytes memory) {
92         require(isContract(target), "Address: static call to non-contract");
93 
94         (bool success, bytes memory returndata) = target.staticcall(data);
95         return verifyCallResult(success, returndata, errorMessage);
96     }
97 
98     
99     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
100         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
101     }
102 
103     
104     function functionDelegateCall(
105         address target,
106         bytes memory data,
107         string memory errorMessage
108     ) internal returns (bytes memory) {
109         require(isContract(target), "Address: delegate call to non-contract");
110 
111         (bool success, bytes memory returndata) = target.delegatecall(data);
112         return verifyCallResult(success, returndata, errorMessage);
113     }
114 
115     
116     function verifyCallResult(
117         bool success,
118         bytes memory returndata,
119         string memory errorMessage
120     ) internal pure returns (bytes memory) {
121         if (success) {
122             return returndata;
123         } else {
124             // Look for revert reason and bubble it up if present
125             if (returndata.length > 0) {
126                 // The easiest way to bubble the revert reason is using memory via assembly
127 
128                 assembly {
129                     let returndata_size := mload(returndata)
130                     revert(add(32, returndata), returndata_size)
131                 }
132             } else {
133                 revert(errorMessage);
134             }
135         }
136     }
137 }
138 
139 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
140 
141 
142 
143 pragma solidity ^0.8.0;
144 
145 
146 interface IERC20 {
147     
148     function totalSupply() external view returns (uint256);
149 
150     
151     function balanceOf(address account) external view returns (uint256);
152 
153     
154     function transfer(address recipient, uint256 amount) external returns (bool);
155 
156     
157     function allowance(address owner, address spender) external view returns (uint256);
158 
159     
160     function approve(address spender, uint256 amount) external returns (bool);
161 
162     
163     function transferFrom(
164         address sender,
165         address recipient,
166         uint256 amount
167     ) external returns (bool);
168 
169     
170     event Transfer(address indexed from, address indexed to, uint256 value);
171 
172     
173     event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
177 
178 
179 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 
184 
185 
186 library SafeERC20 {
187     using Address for address;
188 
189     function safeTransfer(
190         IERC20 token,
191         address to,
192         uint256 value
193     ) internal {
194         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
195     }
196 
197     function safeTransferFrom(
198         IERC20 token,
199         address from,
200         address to,
201         uint256 value
202     ) internal {
203         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
204     }
205 
206     
207     function safeApprove(
208         IERC20 token,
209         address spender,
210         uint256 value
211     ) internal {
212         // safeApprove should only be called when setting an initial allowance,
213         // or when resetting it to zero. To increase and decrease it, use
214         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
215         require(
216             (value == 0) || (token.allowance(address(this), spender) == 0),
217             "SafeERC20: approve from non-zero to non-zero allowance"
218         );
219         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
220     }
221 
222     function safeIncreaseAllowance(
223         IERC20 token,
224         address spender,
225         uint256 value
226     ) internal {
227         uint256 newAllowance = token.allowance(address(this), spender) + value;
228         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
229     }
230 
231     function safeDecreaseAllowance(
232         IERC20 token,
233         address spender,
234         uint256 value
235     ) internal {
236         unchecked {
237             uint256 oldAllowance = token.allowance(address(this), spender);
238             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
239             uint256 newAllowance = oldAllowance - value;
240             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
241         }
242     }
243 
244     
245     function _callOptionalReturn(IERC20 token, bytes memory data) private {
246         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
247         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
248         // the target address contains contract code and also asserts for success in the low-level call.
249 
250         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
251         if (returndata.length > 0) {
252             // Return data is optional
253             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
254         }
255     }
256 }
257 
258 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
259 
260 
261 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
262 
263 pragma solidity ^0.8.0;
264 
265 
266 
267 
268 
269 contract PaymentSplitter is Context {
270     event PayeeAdded(address account, uint256 shares);
271     event PaymentReleased(address to, uint256 amount);
272     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
273     event PaymentReceived(address from, uint256 amount);
274 
275     uint256 private _totalShares;
276     uint256 private _totalReleased;
277 
278     mapping(address => uint256) private _shares;
279     mapping(address => uint256) private _released;
280     address[] private _payees;
281 
282     mapping(IERC20 => uint256) private _erc20TotalReleased;
283     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
284 
285     
286     constructor(address[] memory payees, uint256[] memory shares_) payable {
287         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
288         require(payees.length > 0, "PaymentSplitter: no payees");
289 
290         for (uint256 i = 0; i < payees.length; i++) {
291             _addPayee(payees[i], shares_[i]);
292         }
293     }
294 
295     
296     receive() external payable virtual {
297         emit PaymentReceived(_msgSender(), msg.value);
298     }
299 
300     
301     function totalShares() public view returns (uint256) {
302         return _totalShares;
303     }
304 
305     
306     function totalReleased() public view returns (uint256) {
307         return _totalReleased;
308     }
309 
310     
311     function totalReleased(IERC20 token) public view returns (uint256) {
312         return _erc20TotalReleased[token];
313     }
314 
315     
316     function shares(address account) public view returns (uint256) {
317         return _shares[account];
318     }
319 
320     
321     function released(address account) public view returns (uint256) {
322         return _released[account];
323     }
324 
325     
326     function released(IERC20 token, address account) public view returns (uint256) {
327         return _erc20Released[token][account];
328     }
329 
330     
331     function payee(uint256 index) public view returns (address) {
332         return _payees[index];
333     }
334 
335     
336     function release(address payable account) public virtual {
337         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
338 
339         uint256 totalReceived = address(this).balance + totalReleased();
340         uint256 payment = _pendingPayment(account, totalReceived, released(account));
341 
342         require(payment != 0, "PaymentSplitter: account is not due payment");
343 
344         _released[account] += payment;
345         _totalReleased += payment;
346 
347         Address.sendValue(account, payment);
348         emit PaymentReleased(account, payment);
349     }
350 
351     
352     function release(IERC20 token, address account) public virtual {
353         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
354 
355         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
356         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
357 
358         require(payment != 0, "PaymentSplitter: account is not due payment");
359 
360         _erc20Released[token][account] += payment;
361         _erc20TotalReleased[token] += payment;
362 
363         SafeERC20.safeTransfer(token, account, payment);
364         emit ERC20PaymentReleased(token, account, payment);
365     }
366 
367     
368     function _pendingPayment(
369         address account,
370         uint256 totalReceived,
371         uint256 alreadyReleased
372     ) private view returns (uint256) {
373         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
374     }
375 
376     
377     function _addPayee(address account, uint256 shares_) private {
378         require(account != address(0), "PaymentSplitter: account is the zero address");
379         require(shares_ > 0, "PaymentSplitter: shares are 0");
380         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
381 
382         _payees.push(account);
383         _shares[account] = shares_;
384         _totalShares = _totalShares + shares_;
385         emit PayeeAdded(account, shares_);
386     }
387 }
388 
389 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
390 
391 
392 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 
397 library MerkleProof {
398     
399     function verify(
400         bytes32[] memory proof,
401         bytes32 root,
402         bytes32 leaf
403     ) internal pure returns (bool) {
404         return processProof(proof, leaf) == root;
405     }
406 
407     
408     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
409         bytes32 computedHash = leaf;
410         for (uint256 i = 0; i < proof.length; i++) {
411             bytes32 proofElement = proof[i];
412             if (computedHash <= proofElement) {
413                 // Hash(current computed hash + current element of the proof)
414                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
415             } else {
416                 // Hash(current element of the proof + current computed hash)
417                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
418             }
419         }
420         return computedHash;
421     }
422 }
423 
424 // File: @openzeppelin/contracts/utils/Strings.sol
425 
426 
427 
428 pragma solidity ^0.8.0;
429 
430 
431 library Strings {
432     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
433 
434     
435     function toString(uint256 value) internal pure returns (string memory) {
436         // Inspired by OraclizeAPI's implementation - MIT licence
437         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
438 
439         if (value == 0) {
440             return "0";
441         }
442         uint256 temp = value;
443         uint256 digits;
444         while (temp != 0) {
445             digits++;
446             temp /= 10;
447         }
448         bytes memory buffer = new bytes(digits);
449         while (value != 0) {
450             digits -= 1;
451             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
452             value /= 10;
453         }
454         return string(buffer);
455     }
456 
457     
458     function toHexString(uint256 value) internal pure returns (string memory) {
459         if (value == 0) {
460             return "0x00";
461         }
462         uint256 temp = value;
463         uint256 length = 0;
464         while (temp != 0) {
465             length++;
466             temp >>= 8;
467         }
468         return toHexString(value, length);
469     }
470 
471     
472     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
473         bytes memory buffer = new bytes(2 * length + 2);
474         buffer[0] = "0";
475         buffer[1] = "x";
476         for (uint256 i = 2 * length + 1; i > 1; --i) {
477             buffer[i] = _HEX_SYMBOLS[value & 0xf];
478             value >>= 4;
479         }
480         require(value == 0, "Strings: hex length insufficient");
481         return string(buffer);
482     }
483 }
484 
485 // File: contracts/ERC721.sol
486 
487 
488 pragma solidity >=0.8.0;
489 
490 abstract contract ERC721 {
491     
492 
493     event Transfer(address indexed from, address indexed to, uint256 indexed id);
494 
495     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
496 
497     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
498 
499     
500 
501     string public name;
502 
503     string public symbol;
504 
505     function tokenURI(uint256 id) public view virtual returns (string memory);
506 
507     
508 
509     mapping(address => uint256) public balanceOf;
510 
511     mapping(uint256 => address) public ownerOf;
512 
513     mapping(uint256 => address) public getApproved;
514 
515     mapping(address => mapping(address => bool)) public isApprovedForAll;
516 
517     
518 
519     constructor(string memory _name, string memory _symbol) {
520         name = _name;
521         symbol = _symbol;
522     }
523 
524     
525 
526     function approve(address spender, uint256 id) public virtual {
527         address owner = ownerOf[id];
528 
529         require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");
530 
531         getApproved[id] = spender;
532 
533         emit Approval(owner, spender, id);
534     }
535 
536     function setApprovalForAll(address operator, bool approved) public virtual {
537         isApprovedForAll[msg.sender][operator] = approved;
538 
539         emit ApprovalForAll(msg.sender, operator, approved);
540     }
541 
542     function transferFrom(
543         address from,
544         address to,
545         uint256 id
546     ) public virtual {
547         require(from == ownerOf[id], "WRONG_FROM");
548 
549         require(to != address(0), "INVALID_RECIPIENT");
550 
551         require(
552             msg.sender == from || msg.sender == getApproved[id] || isApprovedForAll[from][msg.sender],
553             "NOT_AUTHORIZED"
554         );
555 
556         // Underflow of the sender's balance is impossible because we check for
557         // ownership above and the recipient's balance can't realistically overflow.
558         unchecked {
559             balanceOf[from]--;
560 
561             balanceOf[to]++;
562         }
563 
564         ownerOf[id] = to;
565 
566         delete getApproved[id];
567 
568         emit Transfer(from, to, id);
569     }
570 
571     function safeTransferFrom(
572         address from,
573         address to,
574         uint256 id
575     ) public virtual {
576         transferFrom(from, to, id);
577 
578         require(
579             to.code.length == 0 ||
580                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
581                 ERC721TokenReceiver.onERC721Received.selector,
582             "UNSAFE_RECIPIENT"
583         );
584     }
585 
586     function safeTransferFrom(
587         address from,
588         address to,
589         uint256 id,
590         bytes memory data
591     ) public virtual {
592         transferFrom(from, to, id);
593 
594         require(
595             to.code.length == 0 ||
596                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
597                 ERC721TokenReceiver.onERC721Received.selector,
598             "UNSAFE_RECIPIENT"
599         );
600     }
601 
602     
603 
604     function supportsInterface(bytes4 interfaceId) public pure virtual returns (bool) {
605         return
606             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
607             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
608             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
609     }
610 
611     
612 
613     function _mint(address to, uint256 id) internal virtual {
614         require(to != address(0), "INVALID_RECIPIENT");
615 
616         require(ownerOf[id] == address(0), "ALREADY_MINTED");
617 
618         // Counter overflow is incredibly unrealistic.
619         unchecked {
620             balanceOf[to]++;
621         }
622 
623         ownerOf[id] = to;
624 
625         emit Transfer(address(0), to, id);
626     }
627 
628     function _burn(uint256 id) internal virtual {
629         address owner = ownerOf[id];
630 
631         require(ownerOf[id] != address(0), "NOT_MINTED");
632 
633         // Ownership check above ensures no underflow.
634         unchecked {
635             balanceOf[owner]--;
636         }
637 
638         delete ownerOf[id];
639 
640         delete getApproved[id];
641 
642         emit Transfer(owner, address(0), id);
643     }
644 
645     
646 
647     function _safeMint(address to, uint256 id) internal virtual {
648         _mint(to, id);
649 
650         require(
651             to.code.length == 0 ||
652                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
653                 ERC721TokenReceiver.onERC721Received.selector,
654             "UNSAFE_RECIPIENT"
655         );
656     }
657 
658     function _safeMint(
659         address to,
660         uint256 id,
661         bytes memory data
662     ) internal virtual {
663         _mint(to, id);
664 
665         require(
666             to.code.length == 0 ||
667                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
668                 ERC721TokenReceiver.onERC721Received.selector,
669             "UNSAFE_RECIPIENT"
670         );
671     }
672 }
673 
674 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
675 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
676 	interface ERC721TokenReceiver {
677 		function onERC721Received(
678 			address operator,
679 			address from,
680 			uint256 id,
681 			bytes calldata data
682 		) external returns (bytes4);
683 	}
684 // File: contracts/Later.sol
685 
686 pragma solidity >=0.8.4;
687 
688 contract DeYOOts is ERC721, PaymentSplitter {
689     uint256 public totalSupply;
690     uint256 private cost = 0 ether;
691     address public owner = msg.sender;
692     string baseURI;
693 
694     error SoldOut();
695 	error InsufficientFunds();
696 	error NotOwner();
697     error URIAlreadySet();
698 
699     event Minted(
700         address indexed owner,
701         string tokenURI,
702         uint256 indexed mintTime
703     );
704 
705     constructor(address[] memory _payees, uint256[] memory _shares)
706         ERC721("DeY00ts (33.3%)", "yOOts")
707         PaymentSplitter(_payees, _shares)
708     {}
709 
710     function mint() external payable {
711         if (totalSupply + 1 > 4900) revert SoldOut();
712 		if (msg.value < cost) revert InsufficientFunds();
713         totalSupply++;
714         _safeMint(msg.sender, totalSupply);
715         emit Minted(msg.sender, tokenURI(totalSupply), block.timestamp);
716     }
717 
718       function setBaseURI(string memory _uri) external {
719         if (bytes(baseURI).length > 0) revert URIAlreadySet();
720         if (msg.sender != owner) revert NotOwner();
721         baseURI = _uri;
722     }
723 
724       function tokenURI(uint256 tokenId)
725         public
726         view
727         override(ERC721)
728         returns (string memory)
729     {
730         return
731             string(
732                 abi.encodePacked(baseURI, Strings.toString(tokenId), ".json")
733             );
734     }
735 }