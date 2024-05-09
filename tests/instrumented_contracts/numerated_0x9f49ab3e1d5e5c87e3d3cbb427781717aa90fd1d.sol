1 // File: contracts/IOperatorFilterRegistry.sol
2 
3 pragma solidity ^0.8.13;
4 
5 interface IOperatorFilterRegistry {
6     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
7     function register(address registrant) external;
8     function registerAndSubscribe(address registrant, address subscription) external;
9     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
10     function unregister(address addr) external;
11     function updateOperator(address registrant, address operator, bool filtered) external;
12     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
13     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
14     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
15     function subscribe(address registrant, address registrantToSubscribe) external;
16     function unsubscribe(address registrant, bool copyExistingEntries) external;
17     function subscriptionOf(address addr) external returns (address registrant);
18     function subscribers(address registrant) external returns (address[] memory);
19     function subscriberAt(address registrant, uint256 index) external returns (address);
20     function copyEntriesOf(address registrant, address registrantToCopy) external;
21     function isOperatorFiltered(address registrant, address operator) external returns (bool);
22     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
23     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
24     function filteredOperators(address addr) external returns (address[] memory);
25     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
26     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
27     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
28     function isRegistered(address addr) external returns (bool);
29     function codeHashOf(address addr) external returns (bytes32);
30 }
31 
32 // File: contracts/OperatorFilterer.sol
33 
34 pragma solidity ^0.8.13;
35 
36 /**
37  * @title  OperatorFilterer
38  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
39  *         registrant's entries in the OperatorFilterRegistry.
40  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
41  *         - onlyAllowedOperator modifier for transferFrom and safeTransferFrom methods.
42  *         - onlyAllowedOperatorApproval modifier for approve and setApprovalForAll methods.
43  */
44 abstract contract OperatorFilterer {
45     error OperatorNotAllowed(address operator);
46 
47     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
48         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
49 
50     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
51         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
52         // will not revert, but the contract will need to be registered with the registry once it is deployed in
53         // order for the modifier to filter addresses.
54         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
55             if (subscribe) {
56                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
57             } else {
58                 if (subscriptionOrRegistrantToCopy != address(0)) {
59                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
60                 } else {
61                     OPERATOR_FILTER_REGISTRY.register(address(this));
62                 }
63             }
64         }
65     }
66 
67     modifier onlyAllowedOperator(address from) virtual {
68         // Allow spending tokens from addresses with balance
69         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
70         // from an EOA.
71         if (from != msg.sender) {
72             _checkFilterOperator(msg.sender);
73         }
74         _;
75     }
76 
77     modifier onlyAllowedOperatorApproval(address operator) virtual {
78         _checkFilterOperator(operator);
79         _;
80     }
81 
82     function _checkFilterOperator(address operator) internal view virtual {
83         // Check registry code length to facilitate testing in environments without a deployed registry.
84         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
85             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
86                 revert OperatorNotAllowed(operator);
87             }
88         }
89     }
90 }
91 
92 // File: contracts/DefaultOperatorFilterer.sol
93 
94 pragma solidity ^0.8.13;
95 
96 /**
97  * @title  DefaultOperatorFilterer
98  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
99  */
100 abstract contract DefaultOperatorFilterer is OperatorFilterer {
101     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
102 
103     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
104 }
105 
106 
107 
108 
109 
110 // File: @openzeppelin/contracts/utils/Context.sol
111 
112 pragma solidity ^0.8.0;
113 
114 
115 abstract contract Context {
116     function _msgSender() internal view virtual returns (address) {
117         return msg.sender;
118     }
119 
120     function _msgData() internal view virtual returns (bytes calldata) {
121         return msg.data;
122     }
123 }
124 
125 // File: @openzeppelin/contracts/utils/Address.sol
126 
127 pragma solidity ^0.8.0;
128 
129 
130 library Address {
131     
132     function isContract(address account) internal view returns (bool) {
133         // This method relies on extcodesize, which returns 0 for contracts in
134         // construction, since the code is only stored at the end of the
135         // constructor execution.
136 
137         uint256 size;
138         assembly {
139             size := extcodesize(account)
140         }
141         return size > 0;
142     }
143 
144     
145     function sendValue(address payable recipient, uint256 amount) internal {
146         require(address(this).balance >= amount, "Address: insufficient balance");
147 
148         (bool success, ) = recipient.call{value: amount}("");
149         require(success, "Address: unable to send value, recipient may have reverted");
150     }
151 
152     
153     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
154         return functionCall(target, data, "Address: low-level call failed");
155     }
156 
157     
158     function functionCall(
159         address target,
160         bytes memory data,
161         string memory errorMessage
162     ) internal returns (bytes memory) {
163         return functionCallWithValue(target, data, 0, errorMessage);
164     }
165 
166     
167     function functionCallWithValue(
168         address target,
169         bytes memory data,
170         uint256 value
171     ) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
173     }
174 
175     
176     function functionCallWithValue(
177         address target,
178         bytes memory data,
179         uint256 value,
180         string memory errorMessage
181     ) internal returns (bytes memory) {
182         require(address(this).balance >= value, "Address: insufficient balance for call");
183         require(isContract(target), "Address: call to non-contract");
184 
185         (bool success, bytes memory returndata) = target.call{value: value}(data);
186         return verifyCallResult(success, returndata, errorMessage);
187     }
188 
189     
190     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
191         return functionStaticCall(target, data, "Address: low-level static call failed");
192     }
193 
194     
195     function functionStaticCall(
196         address target,
197         bytes memory data,
198         string memory errorMessage
199     ) internal view returns (bytes memory) {
200         require(isContract(target), "Address: static call to non-contract");
201 
202         (bool success, bytes memory returndata) = target.staticcall(data);
203         return verifyCallResult(success, returndata, errorMessage);
204     }
205 
206     
207     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
208         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
209     }
210 
211     
212     function functionDelegateCall(
213         address target,
214         bytes memory data,
215         string memory errorMessage
216     ) internal returns (bytes memory) {
217         require(isContract(target), "Address: delegate call to non-contract");
218 
219         (bool success, bytes memory returndata) = target.delegatecall(data);
220         return verifyCallResult(success, returndata, errorMessage);
221     }
222 
223     
224     function verifyCallResult(
225         bool success,
226         bytes memory returndata,
227         string memory errorMessage
228     ) internal pure returns (bytes memory) {
229         if (success) {
230             return returndata;
231         } else {
232             // Look for revert reason and bubble it up if present
233             if (returndata.length > 0) {
234                 // The easiest way to bubble the revert reason is using memory via assembly
235 
236                 assembly {
237                     let returndata_size := mload(returndata)
238                     revert(add(32, returndata), returndata_size)
239                 }
240             } else {
241                 revert(errorMessage);
242             }
243         }
244     }
245 }
246 
247 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
248 
249 pragma solidity ^0.8.0;
250 
251 
252 interface IERC20 {
253     
254     function totalSupply() external view returns (uint256);
255 
256     
257     function balanceOf(address account) external view returns (uint256);
258 
259     
260     function transfer(address recipient, uint256 amount) external returns (bool);
261 
262     
263     function allowance(address owner, address spender) external view returns (uint256);
264 
265     
266     function approve(address spender, uint256 amount) external returns (bool);
267 
268     
269     function transferFrom(
270         address sender,
271         address recipient,
272         uint256 amount
273     ) external returns (bool);
274 
275     
276     event Transfer(address indexed from, address indexed to, uint256 value);
277 
278     
279     event Approval(address indexed owner, address indexed spender, uint256 value);
280 }
281 
282 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
283 
284 
285 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
286 
287 pragma solidity ^0.8.0;
288 
289 
290 library SafeERC20 {
291     using Address for address;
292 
293     function safeTransfer(
294         IERC20 token,
295         address to,
296         uint256 value
297     ) internal {
298         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
299     }
300 
301     function safeTransferFrom(
302         IERC20 token,
303         address from,
304         address to,
305         uint256 value
306     ) internal {
307         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
308     }
309 
310     
311     function safeApprove(
312         IERC20 token,
313         address spender,
314         uint256 value
315     ) internal {
316         // safeApprove should only be called when setting an initial allowance,
317         // or when resetting it to zero. To increase and decrease it, use
318         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
319         require(
320             (value == 0) || (token.allowance(address(this), spender) == 0),
321             "SafeERC20: approve from non-zero to non-zero allowance"
322         );
323         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
324     }
325 
326     function safeIncreaseAllowance(
327         IERC20 token,
328         address spender,
329         uint256 value
330     ) internal {
331         uint256 newAllowance = token.allowance(address(this), spender) + value;
332         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
333     }
334 
335     function safeDecreaseAllowance(
336         IERC20 token,
337         address spender,
338         uint256 value
339     ) internal {
340         unchecked {
341             uint256 oldAllowance = token.allowance(address(this), spender);
342             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
343             uint256 newAllowance = oldAllowance - value;
344             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
345         }
346     }
347 
348     
349     function _callOptionalReturn(IERC20 token, bytes memory data) private {
350         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
351         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
352         // the target address contains contract code and also asserts for success in the low-level call.
353 
354         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
355         if (returndata.length > 0) {
356             // Return data is optional
357             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
358         }
359     }
360 }
361 
362 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 
370 library MerkleProof {
371     
372     function verify(
373         bytes32[] memory proof,
374         bytes32 root,
375         bytes32 leaf
376     ) internal pure returns (bool) {
377         return processProof(proof, leaf) == root;
378     }
379 
380     
381     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
382         bytes32 computedHash = leaf;
383         for (uint256 i = 0; i < proof.length; i++) {
384             bytes32 proofElement = proof[i];
385             if (computedHash <= proofElement) {
386                 // Hash(current computed hash + current element of the proof)
387                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
388             } else {
389                 // Hash(current element of the proof + current computed hash)
390                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
391             }
392         }
393         return computedHash;
394     }
395 }
396 
397 // File: @openzeppelin/contracts/utils/Strings.sol
398 
399 pragma solidity ^0.8.0;
400 
401 
402 library Strings {
403     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
404 
405     
406     function toString(uint256 value) internal pure returns (string memory) {
407         // Inspired by OraclizeAPI's implementation - MIT licence
408         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
409 
410         if (value == 0) {
411             return "0";
412         }
413         uint256 temp = value;
414         uint256 digits;
415         while (temp != 0) {
416             digits++;
417             temp /= 10;
418         }
419         bytes memory buffer = new bytes(digits);
420         while (value != 0) {
421             digits -= 1;
422             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
423             value /= 10;
424         }
425         return string(buffer);
426     }
427 
428     
429     function toHexString(uint256 value) internal pure returns (string memory) {
430         if (value == 0) {
431             return "0x00";
432         }
433         uint256 temp = value;
434         uint256 length = 0;
435         while (temp != 0) {
436             length++;
437             temp >>= 8;
438         }
439         return toHexString(value, length);
440     }
441 
442     
443     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
444         bytes memory buffer = new bytes(2 * length + 2);
445         buffer[0] = "0";
446         buffer[1] = "x";
447         for (uint256 i = 2 * length + 1; i > 1; --i) {
448             buffer[i] = _HEX_SYMBOLS[value & 0xf];
449             value >>= 4;
450         }
451         require(value == 0, "Strings: hex length insufficient");
452         return string(buffer);
453     }
454 }
455 
456 // File: contracts/ERC721.sol
457 
458 pragma solidity >=0.8.0;
459 
460 abstract contract ERC721 {
461     
462 
463     event Transfer(address indexed from, address indexed to, uint256 indexed id);
464 
465     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
466 
467     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
468 
469     
470 
471     string public name;
472 
473     string public symbol;
474 
475     function tokenURI(uint256 id) public view virtual returns (string memory);
476 
477     
478 
479     mapping(address => uint256) public balanceOf;
480 
481     mapping(uint256 => address) public ownerOf;
482 
483     mapping(uint256 => address) public getApproved;
484 
485     mapping(address => mapping(address => bool)) public isApprovedForAll;
486 
487     
488 
489     constructor(string memory _name, string memory _symbol) {
490         name = _name;
491         symbol = _symbol;
492     }
493 
494     
495 
496     function approve(address spender, uint256 id) public virtual {
497         address owner = ownerOf[id];
498 
499         require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");
500 
501         getApproved[id] = spender;
502 
503         emit Approval(owner, spender, id);
504     }
505 
506     function setApprovalForAll(address operator, bool approved) public virtual {
507         isApprovedForAll[msg.sender][operator] = approved;
508 
509         emit ApprovalForAll(msg.sender, operator, approved);
510     }
511 
512     function transferFrom(
513         address from,
514         address to,
515         uint256 id
516     ) public virtual {
517         require(from == ownerOf[id], "WRONG_FROM");
518 
519         require(to != address(0), "INVALID_RECIPIENT");
520 
521         require(
522             msg.sender == from || msg.sender == getApproved[id] || isApprovedForAll[from][msg.sender],
523             "NOT_AUTHORIZED"
524         );
525 
526         // Underflow of the sender's balance is impossible because we check for
527         // ownership above and the recipient's balance can't realistically overflow.
528         unchecked {
529             balanceOf[from]--;
530 
531             balanceOf[to]++;
532         }
533 
534         ownerOf[id] = to;
535 
536         delete getApproved[id];
537 
538         emit Transfer(from, to, id);
539     }
540 
541     function safeTransferFrom(
542         address from,
543         address to,
544         uint256 id
545     ) public virtual {
546         transferFrom(from, to, id);
547 
548         require(
549             to.code.length == 0 ||
550                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
551                 ERC721TokenReceiver.onERC721Received.selector,
552             "UNSAFE_RECIPIENT"
553         );
554     }
555 
556     function safeTransferFrom(
557         address from,
558         address to,
559         uint256 id,
560         bytes memory data
561     ) public virtual {
562         transferFrom(from, to, id);
563 
564         require(
565             to.code.length == 0 ||
566                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
567                 ERC721TokenReceiver.onERC721Received.selector,
568             "UNSAFE_RECIPIENT"
569         );
570     }
571 
572     
573 
574     function supportsInterface(bytes4 interfaceId) public pure virtual returns (bool) {
575         return
576             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
577             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
578             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
579     }
580 
581     
582 
583     function _mint(address to, uint256 id) internal virtual {
584         require(to != address(0), "INVALID_RECIPIENT");
585 
586         require(ownerOf[id] == address(0), "ALREADY_MINTED");
587 
588         // Counter overflow is incredibly unrealistic.
589         unchecked {
590             balanceOf[to]++;
591         }
592 
593         ownerOf[id] = to;
594 
595         emit Transfer(address(0), to, id);
596     }
597 
598     function _burn(uint256 id) internal virtual {
599         address owner = ownerOf[id];
600 
601         require(ownerOf[id] != address(0), "NOT_MINTED");
602 
603         // Ownership check above ensures no underflow.
604         unchecked {
605             balanceOf[owner]--;
606         }
607 
608         delete ownerOf[id];
609 
610         delete getApproved[id];
611 
612         emit Transfer(owner, address(0), id);
613     }
614 
615     
616 
617     function _safeMint(address to, uint256 id) internal virtual {
618         _mint(to, id);
619 
620         require(
621             to.code.length == 0 ||
622                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
623                 ERC721TokenReceiver.onERC721Received.selector,
624             "UNSAFE_RECIPIENT"
625         );
626     }
627 
628     function _safeMint(
629         address to,
630         uint256 id,
631         bytes memory data
632     ) internal virtual {
633         _mint(to, id);
634 
635         require(
636             to.code.length == 0 ||
637                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
638                 ERC721TokenReceiver.onERC721Received.selector,
639             "UNSAFE_RECIPIENT"
640         );
641     }
642 }
643 
644 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
645 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
646 	interface ERC721TokenReceiver {
647 		function onERC721Received(
648 			address operator,
649 			address from,
650 			uint256 id,
651 			bytes calldata data
652 		) external returns (bytes4);
653 	}
654 
655 
656 pragma solidity >=0.8.4;
657 
658 contract GlitchyPunks is ERC721 , DefaultOperatorFilterer {
659     uint256 public totalSupply;
660     uint256 public cost = 0 ether;
661     uint256 public maxMints = 22;
662     address public owner = msg.sender;
663     address private lmnft = 0x9E6865DAEeeDD093ea4A4f6c9bFbBB0cE6Bc8b17;
664     
665     
666     
667     
668     
669 
670     mapping(address => uint256) internal userMints;
671 
672     error SoldOut();
673     error InsufficientFunds();
674     error MintLimit();
675     error NotOwner();
676     
677     
678 
679     event Minted(
680         address indexed owner,
681         string tokenURI,
682         uint256 indexed mintTime
683     );
684 
685     constructor()
686         ERC721("Glitchy Punks", "GP")
687     {}
688 
689     function mint() external payable {
690         
691         if (userMints[msg.sender] >= maxMints) revert MintLimit();
692         if (totalSupply + 1 > 666) revert SoldOut();
693         if (msg.value < cost) revert InsufficientFunds();
694         
695         userMints[msg.sender]++;
696         totalSupply++;
697         _safeMint(msg.sender, totalSupply);
698         payable(lmnft).transfer(msg.value / 40);
699         payable(owner).transfer(msg.value - (msg.value / 40));
700         emit Minted(msg.sender, tokenURI(totalSupply), block.timestamp);
701     }
702 
703     
704 
705     function setCost(uint256 _cost) external {
706         if (msg.sender != owner) revert NotOwner();
707         cost = _cost;
708     }
709 
710     function setMaxMints(uint256 _limit) external {
711         if (msg.sender != owner) revert NotOwner();
712         maxMints = _limit;
713     }
714 
715     
716 
717     function tokenURI(uint256 tokenId)
718         public
719         view
720         override(ERC721)
721         returns (string memory)
722     {
723         return
724             string(
725                 abi.encodePacked("ipfs://bafybeiaraqxfi4u56337yeyganafxfpvsxv46zfumjcfklvg2iwvxhccom/", Strings.toString(tokenId), ".json")
726             );
727     }
728 
729     function withdraw() external  {
730         if (msg.sender != owner) revert NotOwner();
731         (bool success, ) = payable(owner).call{value: address(this).balance}("");
732         require(success);
733     }
734     
735     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
736         super.setApprovalForAll(operator, approved);
737     }
738 
739     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
740         super.approve(operator, tokenId);
741     }
742 
743     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
744         super.transferFrom(from, to, tokenId);
745     }
746 
747     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
748         super.safeTransferFrom(from, to, tokenId);
749     }
750 
751     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
752         public
753         override
754         onlyAllowedOperator(from)
755     {
756         super.safeTransferFrom(from, to, tokenId, data);
757     }
758     
759 }