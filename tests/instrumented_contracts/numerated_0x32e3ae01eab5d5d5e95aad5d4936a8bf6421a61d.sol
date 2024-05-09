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
669 
670 	interface ERC721TokenReceiver {
671 		function onERC721Received(
672 			address operator,
673 			address from,
674 			uint256 id,
675 			bytes calldata data
676 		) external returns (bytes4);
677 	}
678 
679 pragma solidity >=0.8.4;
680 
681 contract TheCowboy is ERC721, PaymentSplitter {
682     uint256 public totalSupply;
683     uint256 private cost = 0 ether;
684     address public owner = msg.sender;
685 
686     error SoldOut();
687     error InsufficientFunds();
688     error NotOwner();
689 
690     event Minted(address indexed owner, string tokenURI, uint256 indexed mintTime);
691 
692     constructor(address[] memory _payees, uint256[] memory _shares)
693         ERC721("The Cowboy", "COWBOY")
694         PaymentSplitter(_payees, _shares)
695     {}
696 
697     function mint() external payable {
698         if (totalSupply + 1 > 5000) revert SoldOut();
699         if (msg.value < cost) revert InsufficientFunds();
700         totalSupply++;
701         _safeMint(msg.sender, totalSupply);
702         emit Minted(msg.sender, tokenURI(totalSupply), block.timestamp);
703     }
704 
705     function tokenURI(uint256 tokenId)
706         public
707         pure
708         override(ERC721)
709         returns (string memory)
710     {
711         return
712             string(
713                 abi.encodePacked(
714                     "ipfs://bafybeicckltlrnlbtlbkvx3ipt2bvulatnocdfon2xxrg3k63cfgdgjowi/",
715                     Strings.toString(tokenId),
716                     ".json"
717                 )
718             );
719     }
720 }