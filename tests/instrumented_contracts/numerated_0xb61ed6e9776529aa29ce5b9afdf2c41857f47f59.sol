1 // SPDX-License-Identifier: Unlicense
2 
3 pragma solidity >=0.5.0;
4 
5 interface ILayerZeroUserApplicationConfig {
6     // @notice set the configuration of the LayerZero messaging library of the specified version
7     // @param _version - messaging library version
8     // @param _chainId - the chainId for the pending config change
9     // @param _configType - type of configuration. every messaging library has its own convention.
10     // @param _config - configuration in the bytes. can encode arbitrary content.
11     function setConfig(
12         uint16 _version,
13         uint16 _chainId,
14         uint256 _configType,
15         bytes calldata _config
16     ) external;
17 
18     // @notice set the send() LayerZero messaging library version to _version
19     // @param _version - new messaging library version
20     function setSendVersion(uint16 _version) external;
21 
22     // @notice set the lzReceive() LayerZero messaging library version to _version
23     // @param _version - new messaging library version
24     function setReceiveVersion(uint16 _version) external;
25 
26     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
27     // @param _srcChainId - the chainId of the source chain
28     // @param _srcAddress - the contract address of the source contract at the source chain
29     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress)
30         external;
31 }
32 
33 pragma solidity >=0.5.0;
34 
35 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
36     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
37     // @param _dstChainId - the destination chain identifier
38     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
39     // @param _payload - a custom bytes payload to send to the destination contract
40     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
41     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
42     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
43     function send(
44         uint16 _dstChainId,
45         bytes calldata _destination,
46         bytes calldata _payload,
47         address payable _refundAddress,
48         address _zroPaymentAddress,
49         bytes calldata _adapterParams
50     ) external payable;
51 
52     // @notice used by the messaging library to publish verified payload
53     // @param _srcChainId - the source chain identifier
54     // @param _srcAddress - the source contract (as bytes) at the source chain
55     // @param _dstAddress - the address on destination chain
56     // @param _nonce - the unbound message ordering nonce
57     // @param _gasLimit - the gas limit for external contract execution
58     // @param _payload - verified payload to send to the destination contract
59     function receivePayload(
60         uint16 _srcChainId,
61         bytes calldata _srcAddress,
62         address _dstAddress,
63         uint64 _nonce,
64         uint256 _gasLimit,
65         bytes calldata _payload
66     ) external;
67 
68     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
69     // @param _srcChainId - the source chain identifier
70     // @param _srcAddress - the source chain contract address
71     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress)
72         external
73         view
74         returns (uint64);
75 
76     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
77     // @param _srcAddress - the source chain contract address
78     function getOutboundNonce(uint16 _dstChainId, address _srcAddress)
79         external
80         view
81         returns (uint64);
82 
83     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
84     // @param _dstChainId - the destination chain identifier
85     // @param _userApplication - the user app address on this EVM chain
86     // @param _payload - the custom message to send over LayerZero
87     // @param _payInZRO - if false, user app pays the protocol fee in native token
88     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
89     function estimateFees(
90         uint16 _dstChainId,
91         address _userApplication,
92         bytes calldata _payload,
93         bool _payInZRO,
94         bytes calldata _adapterParam
95     ) external view returns (uint256 nativeFee, uint256 zroFee);
96 
97     // @notice get this Endpoint's immutable source identifier
98     function getChainId() external view returns (uint16);
99 
100     // @notice the interface to retry failed message on this Endpoint destination
101     // @param _srcChainId - the source chain identifier
102     // @param _srcAddress - the source chain contract address
103     // @param _payload - the payload to be retried
104     function retryPayload(
105         uint16 _srcChainId,
106         bytes calldata _srcAddress,
107         bytes calldata _payload
108     ) external;
109 
110     // @notice query if any STORED payload (message blocking) at the endpoint.
111     // @param _srcChainId - the source chain identifier
112     // @param _srcAddress - the source chain contract address
113     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress)
114         external
115         view
116         returns (bool);
117 
118     // @notice query if the _libraryAddress is valid for sending msgs.
119     // @param _userApplication - the user app address on this EVM chain
120     function getSendLibraryAddress(address _userApplication)
121         external
122         view
123         returns (address);
124 
125     // @notice query if the _libraryAddress is valid for receiving msgs.
126     // @param _userApplication - the user app address on this EVM chain
127     function getReceiveLibraryAddress(address _userApplication)
128         external
129         view
130         returns (address);
131 
132     // @notice query if the non-reentrancy guard for send() is on
133     // @return true if the guard is on. false otherwise
134     function isSendingPayload() external view returns (bool);
135 
136     // @notice query if the non-reentrancy guard for receive() is on
137     // @return true if the guard is on. false otherwise
138     function isReceivingPayload() external view returns (bool);
139 
140     // @notice get the configuration of the LayerZero messaging library of the specified version
141     // @param _version - messaging library version
142     // @param _chainId - the chainId for the pending config change
143     // @param _userApplication - the contract address of the user application
144     // @param _configType - type of configuration. every messaging library has its own convention.
145     function getConfig(
146         uint16 _version,
147         uint16 _chainId,
148         address _userApplication,
149         uint256 _configType
150     ) external view returns (bytes memory);
151 
152     // @notice get the send() LayerZero messaging library version
153     // @param _userApplication - the contract address of the user application
154     function getSendVersion(address _userApplication)
155         external
156         view
157         returns (uint16);
158 
159     // @notice get the lzReceive() LayerZero messaging library version
160     // @param _userApplication - the contract address of the user application
161     function getReceiveVersion(address _userApplication)
162         external
163         view
164         returns (uint16);
165 }
166 
167 pragma solidity >=0.5.0;
168 
169 interface ILayerZeroReceiver {
170     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
171     // @param _srcChainId - the source endpoint identifier
172     // @param _srcAddress - the source sending contract address from the source chain
173     // @param _nonce - the ordered message nonce
174     // @param _payload - the signed payload is the UA bytes has encoded to be sent
175     function lzReceive(
176         uint16 _srcChainId,
177         bytes calldata _srcAddress,
178         uint64 _nonce,
179         bytes calldata _payload
180     ) external;
181 }
182 
183 
184 pragma solidity ^0.8.0;
185 
186 library Strings {
187     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
188 
189     /**
190      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
191      */
192     function toString(uint256 value) internal pure returns (string memory) {
193         // Inspired by OraclizeAPI's implementation - MIT licence
194         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
195 
196         if (value == 0) {
197             return "0";
198         }
199         uint256 temp = value;
200         uint256 digits;
201         while (temp != 0) {
202             digits++;
203             temp /= 10;
204         }
205         bytes memory buffer = new bytes(digits);
206         while (value != 0) {
207             digits -= 1;
208             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
209             value /= 10;
210         }
211         return string(buffer);
212     }
213 
214     /**
215      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
216      */
217     function toHexString(uint256 value) internal pure returns (string memory) {
218         if (value == 0) {
219             return "0x00";
220         }
221         uint256 temp = value;
222         uint256 length = 0;
223         while (temp != 0) {
224             length++;
225             temp >>= 8;
226         }
227         return toHexString(value, length);
228     }
229 
230     /**
231      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
232      */
233     function toHexString(uint256 value, uint256 length)
234         internal
235         pure
236         returns (string memory)
237     {
238         bytes memory buffer = new bytes(2 * length + 2);
239         buffer[0] = "0";
240         buffer[1] = "x";
241         for (uint256 i = 2 * length + 1; i > 1; --i) {
242             buffer[i] = _HEX_SYMBOLS[value & 0xf];
243             value >>= 4;
244         }
245         require(value == 0, "Strings: hex length insufficient");
246         return string(buffer);
247     }
248 }
249 
250 pragma solidity ^0.8.0;
251 
252 abstract contract Context {
253     function _msgSender() internal view virtual returns (address) {
254         return msg.sender;
255     }
256 
257     function _msgData() internal view virtual returns (bytes calldata) {
258         return msg.data;
259     }
260 }
261 
262 pragma solidity ^0.8.0;
263 
264 abstract contract Ownable is Context {
265     address private _owner;
266 
267     event OwnershipTransferred(
268         address indexed previousOwner,
269         address indexed newOwner
270     );
271 
272     /**
273      * @dev Initializes the contract setting the deployer as the initial owner.
274      */
275     constructor() {
276         _transferOwnership(_msgSender());
277     }
278 
279     /**
280      * @dev Returns the address of the current owner.
281      */
282     function owner() public view virtual returns (address) {
283         return _owner;
284     }
285 
286     /**
287      * @dev Throws if called by any account other than the owner.
288      */
289     modifier onlyOwner() {
290         require(owner() == _msgSender(), "Ownable: caller is not the owner");
291         _;
292     }
293 
294     /**
295      * @dev Leaves the contract without owner. It will not be possible to call
296      * `onlyOwner` functions anymore. Can only be called by the current owner.
297      *
298      * NOTE: Renouncing ownership will leave the contract without an owner,
299      * thereby removing any functionality that is only available to the owner.
300      */
301     function renounceOwnership() public virtual onlyOwner {
302         _transferOwnership(address(0));
303     }
304 
305     /**
306      * @dev Transfers ownership of the contract to a new account (`newOwner`).
307      * Can only be called by the current owner.
308      */
309     function transferOwnership(address newOwner) public virtual onlyOwner {
310         require(
311             newOwner != address(0),
312             "Ownable: new owner is the zero address"
313         );
314         _transferOwnership(newOwner);
315     }
316 
317     /**
318      * @dev Transfers ownership of the contract to a new account (`newOwner`).
319      * Internal function without access restriction.
320      */
321     function _transferOwnership(address newOwner) internal virtual {
322         address oldOwner = _owner;
323         _owner = newOwner;
324         emit OwnershipTransferred(oldOwner, newOwner);
325     }
326 }
327 
328 pragma solidity ^0.8.0;
329 
330 library Address {
331     function isContract(address account) internal view returns (bool) {
332         // This method relies on extcodesize, which returns 0 for contracts in
333         // construction, since the code is only stored at the end of the
334         // constructor execution.
335 
336         uint256 size;
337         assembly {
338             size := extcodesize(account)
339         }
340         return size > 0;
341     }
342 
343     function sendValue(address payable recipient, uint256 amount) internal {
344         require(
345             address(this).balance >= amount,
346             "Address: insufficient balance"
347         );
348 
349         (bool success, ) = recipient.call{value: amount}("");
350         require(
351             success,
352             "Address: unable to send value, recipient may have reverted"
353         );
354     }
355 
356     function functionCall(address target, bytes memory data)
357         internal
358         returns (bytes memory)
359     {
360         return functionCall(target, data, "Address: low-level call failed");
361     }
362 
363     function functionCall(
364         address target,
365         bytes memory data,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, 0, errorMessage);
369     }
370 
371     function functionCallWithValue(
372         address target,
373         bytes memory data,
374         uint256 value
375     ) internal returns (bytes memory) {
376         return
377             functionCallWithValue(
378                 target,
379                 data,
380                 value,
381                 "Address: low-level call with value failed"
382             );
383     }
384 
385     function functionCallWithValue(
386         address target,
387         bytes memory data,
388         uint256 value,
389         string memory errorMessage
390     ) internal returns (bytes memory) {
391         require(
392             address(this).balance >= value,
393             "Address: insufficient balance for call"
394         );
395         require(isContract(target), "Address: call to non-contract");
396 
397         (bool success, bytes memory returndata) = target.call{value: value}(
398             data
399         );
400         return verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     function functionStaticCall(address target, bytes memory data)
404         internal
405         view
406         returns (bytes memory)
407     {
408         return
409             functionStaticCall(
410                 target,
411                 data,
412                 "Address: low-level static call failed"
413             );
414     }
415 
416     function functionStaticCall(
417         address target,
418         bytes memory data,
419         string memory errorMessage
420     ) internal view returns (bytes memory) {
421         require(isContract(target), "Address: static call to non-contract");
422 
423         (bool success, bytes memory returndata) = target.staticcall(data);
424         return verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     function functionDelegateCall(address target, bytes memory data)
428         internal
429         returns (bytes memory)
430     {
431         return
432             functionDelegateCall(
433                 target,
434                 data,
435                 "Address: low-level delegate call failed"
436             );
437     }
438 
439     function functionDelegateCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal returns (bytes memory) {
444         require(isContract(target), "Address: delegate call to non-contract");
445 
446         (bool success, bytes memory returndata) = target.delegatecall(data);
447         return verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     function verifyCallResult(
451         bool success,
452         bytes memory returndata,
453         string memory errorMessage
454     ) internal pure returns (bytes memory) {
455         if (success) {
456             return returndata;
457         } else {
458             // Look for revert reason and bubble it up if present
459             if (returndata.length > 0) {
460                 // The easiest way to bubble the revert reason is using memory via assembly
461 
462                 assembly {
463                     let returndata_size := mload(returndata)
464                     revert(add(32, returndata), returndata_size)
465                 }
466             } else {
467                 revert(errorMessage);
468             }
469         }
470     }
471 }
472 
473 pragma solidity ^0.8.0;
474 
475 interface IERC721Receiver {
476     function onERC721Received(
477         address operator,
478         address from,
479         uint256 tokenId,
480         bytes calldata data
481     ) external returns (bytes4);
482 }
483 
484 pragma solidity ^0.8.0;
485 
486 interface IERC165 {
487 
488     function supportsInterface(bytes4 interfaceId) external view returns (bool);
489 }
490 
491 pragma solidity ^0.8.0;
492 
493 abstract contract ERC165 is IERC165 {
494     function supportsInterface(bytes4 interfaceId)
495         public
496         view
497         virtual
498         override
499         returns (bool)
500     {
501         return interfaceId == type(IERC165).interfaceId;
502     }
503 }
504 
505 pragma solidity ^0.8.0;
506 
507 interface IERC721 is IERC165 {
508 
509     event Transfer(
510         address indexed from,
511         address indexed to,
512         uint256 indexed tokenId
513     );
514 
515     event Approval(
516         address indexed owner,
517         address indexed approved,
518         uint256 indexed tokenId
519     );
520 
521     event ApprovalForAll(
522         address indexed owner,
523         address indexed operator,
524         bool approved
525     );
526 
527     function balanceOf(address owner) external view returns (uint256 balance);
528 
529     function ownerOf(uint256 tokenId) external view returns (address owner);
530 
531     function safeTransferFrom(
532         address from,
533         address to,
534         uint256 tokenId
535     ) external;
536 
537     function transferFrom(
538         address from,
539         address to,
540         uint256 tokenId
541     ) external;
542 
543     function approve(address to, uint256 tokenId) external;
544 
545     function getApproved(uint256 tokenId)
546         external
547         view
548         returns (address operator);
549 
550     function setApprovalForAll(address operator, bool _approved) external;
551 
552     function isApprovedForAll(address owner, address operator)
553         external
554         view
555         returns (bool);
556 
557     function safeTransferFrom(
558         address from,
559         address to,
560         uint256 tokenId,
561         bytes calldata data
562     ) external;
563 }
564 
565 pragma solidity ^0.8.0;
566 
567 interface IERC721Metadata is IERC721 {
568 
569     function name() external view returns (string memory);
570 
571     function symbol() external view returns (string memory);
572 
573     function tokenURI(uint256 tokenId) external view returns (string memory);
574 }
575 
576 pragma solidity ^0.8.0;
577 
578 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
579     using Address for address;
580     using Strings for uint256;
581 
582     // Token name
583     string private _name;
584 
585     // Token symbol
586     string private _symbol;
587 
588     // Mapping from token ID to owner address
589     mapping(uint256 => address) private _owners;
590 
591     // Mapping owner address to token count
592     mapping(address => uint256) private _balances;
593 
594     // Mapping from token ID to approved address
595     mapping(uint256 => address) private _tokenApprovals;
596 
597     // Mapping from owner to operator approvals
598     mapping(address => mapping(address => bool)) private _operatorApprovals;
599 
600     constructor(string memory name_, string memory symbol_) {
601         _name = name_;
602         _symbol = symbol_;
603     }
604 
605     function supportsInterface(bytes4 interfaceId)
606         public
607         view
608         virtual
609         override(ERC165, IERC165)
610         returns (bool)
611     {
612         return
613             interfaceId == type(IERC721).interfaceId ||
614             interfaceId == type(IERC721Metadata).interfaceId ||
615             super.supportsInterface(interfaceId);
616     }
617 
618     function balanceOf(address owner)
619         public
620         view
621         virtual
622         override
623         returns (uint256)
624     {
625         require(
626             owner != address(0),
627             "ERC721: balance query for the zero address"
628         );
629         return _balances[owner];
630     }
631 
632     function ownerOf(uint256 tokenId)
633         public
634         view
635         virtual
636         override
637         returns (address)
638     {
639         address owner = _owners[tokenId];
640         require(
641             owner != address(0),
642             "ERC721: owner query for nonexistent token"
643         );
644         return owner;
645     }
646 
647     function name() public view virtual override returns (string memory) {
648         return _name;
649     }
650 
651     function symbol() public view virtual override returns (string memory) {
652         return _symbol;
653     }
654 
655     function tokenURI(uint256 tokenId)
656         public
657         view
658         virtual
659         override
660         returns (string memory)
661     {
662         require(
663             _exists(tokenId),
664             "ERC721Metadata: URI query for nonexistent token"
665         );
666 
667         string memory baseURI = _baseURI();
668         return
669             bytes(baseURI).length > 0
670                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
671                 : "";
672     }
673 
674     function _baseURI() internal view virtual returns (string memory) {
675         return "";
676     }
677 
678     function approve(address to, uint256 tokenId) public virtual override {
679         address owner = ERC721.ownerOf(tokenId);
680         require(to != owner, "ERC721: approval to current owner");
681 
682         require(
683             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
684             "ERC721: approve caller is not owner nor approved for all"
685         );
686 
687         _approve(to, tokenId);
688     }
689 
690     function getApproved(uint256 tokenId)
691         public
692         view
693         virtual
694         override
695         returns (address)
696     {
697         require(
698             _exists(tokenId),
699             "ERC721: approved query for nonexistent token"
700         );
701 
702         return _tokenApprovals[tokenId];
703     }
704 
705     function setApprovalForAll(address operator, bool approved)
706         public
707         virtual
708         override
709     {
710         _setApprovalForAll(_msgSender(), operator, approved);
711     }
712 
713     function isApprovedForAll(address owner, address operator)
714         public
715         view
716         virtual
717         override
718         returns (bool)
719     {
720         return _operatorApprovals[owner][operator];
721     }
722 
723     function transferFrom(
724         address from,
725         address to,
726         uint256 tokenId
727     ) public virtual override {
728         //solhint-disable-next-line max-line-length
729         require(
730             _isApprovedOrOwner(_msgSender(), tokenId),
731             "ERC721: transfer caller is not owner nor approved"
732         );
733 
734         _transfer(from, to, tokenId);
735     }
736 
737     function safeTransferFrom(
738         address from,
739         address to,
740         uint256 tokenId
741     ) public virtual override {
742         safeTransferFrom(from, to, tokenId, "");
743     }
744 
745     function safeTransferFrom(
746         address from,
747         address to,
748         uint256 tokenId,
749         bytes memory _data
750     ) public virtual override {
751         require(
752             _isApprovedOrOwner(_msgSender(), tokenId),
753             "ERC721: transfer caller is not owner nor approved"
754         );
755         _safeTransfer(from, to, tokenId, _data);
756     }
757 
758     function _safeTransfer(
759         address from,
760         address to,
761         uint256 tokenId,
762         bytes memory _data
763     ) internal virtual {
764         _transfer(from, to, tokenId);
765         require(
766             _checkOnERC721Received(from, to, tokenId, _data),
767             "ERC721: transfer to non ERC721Receiver implementer"
768         );
769     }
770 
771     function _exists(uint256 tokenId) internal view virtual returns (bool) {
772         return _owners[tokenId] != address(0);
773     }
774 
775     function _isApprovedOrOwner(address spender, uint256 tokenId)
776         internal
777         view
778         virtual
779         returns (bool)
780     {
781         require(
782             _exists(tokenId),
783             "ERC721: operator query for nonexistent token"
784         );
785         address owner = ERC721.ownerOf(tokenId);
786         return (spender == owner ||
787             getApproved(tokenId) == spender ||
788             isApprovedForAll(owner, spender));
789     }
790 
791     function _safeMint(address to, uint256 tokenId) internal virtual {
792         _safeMint(to, tokenId, "");
793     }
794 
795     function _safeMint(
796         address to,
797         uint256 tokenId,
798         bytes memory _data
799     ) internal virtual {
800         _mint(to, tokenId);
801         require(
802             _checkOnERC721Received(address(0), to, tokenId, _data),
803             "ERC721: transfer to non ERC721Receiver implementer"
804         );
805     }
806 
807     function _mint(address to, uint256 tokenId) internal virtual {
808         require(to != address(0), "ERC721: mint to the zero address");
809 
810         _beforeTokenTransfer(address(0), to, tokenId);
811 
812         _balances[to] += 1;
813         _owners[tokenId] = to;
814 
815         emit Transfer(address(0), to, tokenId);
816     }
817 
818     function _burn(uint256 tokenId) internal virtual {
819         address owner = ERC721.ownerOf(tokenId);
820 
821         _beforeTokenTransfer(owner, address(0), tokenId);
822 
823         // Clear approvals
824         _approve(address(0), tokenId);
825 
826         _balances[owner] -= 1;
827         delete _owners[tokenId];
828 
829         emit Transfer(owner, address(0), tokenId);
830     }
831 
832     function _transfer(
833         address from,
834         address to,
835         uint256 tokenId
836     ) internal virtual {
837         require(
838             ERC721.ownerOf(tokenId) == from,
839             "ERC721: transfer of token that is not own"
840         );
841         require(to != address(0), "ERC721: transfer to the zero address");
842 
843         _beforeTokenTransfer(from, to, tokenId);
844 
845         // Clear approvals from the previous owner
846         _approve(address(0), tokenId);
847 
848         _balances[from] -= 1;
849         _balances[to] += 1;
850         _owners[tokenId] = to;
851 
852         emit Transfer(from, to, tokenId);
853     }
854 
855     function _approve(address to, uint256 tokenId) internal virtual {
856         _tokenApprovals[tokenId] = to;
857         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
858     }
859 
860     function _setApprovalForAll(
861         address owner,
862         address operator,
863         bool approved
864     ) internal virtual {
865         require(owner != operator, "ERC721: approve to caller");
866         _operatorApprovals[owner][operator] = approved;
867         emit ApprovalForAll(owner, operator, approved);
868     }
869 
870     function _checkOnERC721Received(
871         address from,
872         address to,
873         uint256 tokenId,
874         bytes memory _data
875     ) private returns (bool) {
876         if (to.isContract()) {
877             try
878                 IERC721Receiver(to).onERC721Received(
879                     _msgSender(),
880                     from,
881                     tokenId,
882                     _data
883                 )
884             returns (bytes4 retval) {
885                 return retval == IERC721Receiver.onERC721Received.selector;
886             } catch (bytes memory reason) {
887                 if (reason.length == 0) {
888                     revert(
889                         "ERC721: transfer to non ERC721Receiver implementer"
890                     );
891                 } else {
892                     assembly {
893                         revert(add(32, reason), mload(reason))
894                     }
895                 }
896             }
897         } else {
898             return true;
899         }
900     }
901 
902     function _beforeTokenTransfer(
903         address from,
904         address to,
905         uint256 tokenId
906     ) internal virtual {}
907 }
908 
909 pragma solidity ^0.8.6;
910 
911 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
912     ILayerZeroEndpoint internal endpoint;
913 
914     struct FailedMessages {
915         uint256 payloadLength;
916         bytes32 payloadHash;
917     }
918 
919     mapping(uint16 => mapping(bytes => mapping(uint256 => FailedMessages)))
920         public failedMessages;
921     mapping(uint16 => bytes) public trustedRemoteLookup;
922 
923     event MessageFailed(
924         uint16 _srcChainId,
925         bytes _srcAddress,
926         uint64 _nonce,
927         bytes _payload
928     );
929 
930     function lzReceive(
931         uint16 _srcChainId,
932         bytes memory _srcAddress,
933         uint64 _nonce,
934         bytes memory _payload
935     ) external override {
936         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
937         require(
938             _srcAddress.length == trustedRemoteLookup[_srcChainId].length &&
939                 keccak256(_srcAddress) ==
940                 keccak256(trustedRemoteLookup[_srcChainId]),
941             "NonblockingReceiver: invalid source sending contract"
942         );
943 
944         // try-catch all errors/exceptions
945         // having failed messages does not block messages passing
946         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
947             // do nothing
948         } catch {
949             // error / exception
950             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(
951                 _payload.length,
952                 keccak256(_payload)
953             );
954             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
955         }
956     }
957 
958     function onLzReceive(
959         uint16 _srcChainId,
960         bytes memory _srcAddress,
961         uint64 _nonce,
962         bytes memory _payload
963     ) public {
964         // only internal transaction
965         require(
966             msg.sender == address(this),
967             "NonblockingReceiver: caller must be Bridge."
968         );
969 
970         // handle incoming message
971         _LzReceive(_srcChainId, _srcAddress, _nonce, _payload);
972     }
973 
974     // abstract function
975     function _LzReceive(
976         uint16 _srcChainId,
977         bytes memory _srcAddress,
978         uint64 _nonce,
979         bytes memory _payload
980     ) internal virtual;
981 
982     function _lzSend(
983         uint16 _dstChainId,
984         bytes memory _payload,
985         address payable _refundAddress,
986         address _zroPaymentAddress,
987         bytes memory _txParam
988     ) internal {
989         endpoint.send{value: msg.value}(
990             _dstChainId,
991             trustedRemoteLookup[_dstChainId],
992             _payload,
993             _refundAddress,
994             _zroPaymentAddress,
995             _txParam
996         );
997     }
998 
999     function retryMessage(
1000         uint16 _srcChainId,
1001         bytes memory _srcAddress,
1002         uint64 _nonce,
1003         bytes calldata _payload
1004     ) external payable {
1005         // assert there is message to retry
1006         FailedMessages storage failedMsg = failedMessages[_srcChainId][
1007             _srcAddress
1008         ][_nonce];
1009         require(
1010             failedMsg.payloadHash != bytes32(0),
1011             "NonblockingReceiver: no stored message"
1012         );
1013         require(
1014             _payload.length == failedMsg.payloadLength &&
1015                 keccak256(_payload) == failedMsg.payloadHash,
1016             "LayerZero: invalid payload"
1017         );
1018         // clear the stored message
1019         failedMsg.payloadLength = 0;
1020         failedMsg.payloadHash = bytes32(0);
1021         // execute the message. revert if it fails again
1022         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1023     }
1024 
1025     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote)
1026         external
1027         onlyOwner
1028     {
1029         trustedRemoteLookup[_chainId] = _trustedRemote;
1030     }
1031 }
1032 
1033 pragma solidity ^0.8.7;
1034 
1035 contract OMNIDOORS is Ownable, ERC721, NonblockingReceiver {
1036     address public _owner;
1037     string private baseURI;
1038     uint256 nextTokenId = 5900;
1039     uint256 MAX_NETWORK_MINT = 9300;
1040 
1041     uint256 gasForDestinationLzReceive = 350000;
1042 
1043     constructor(string memory baseURI_, address _layerZeroEndpoint)
1044         ERC721("Omni Doors", "odoors")
1045     {
1046         _owner = msg.sender;
1047         endpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
1048         baseURI = baseURI_;
1049         for (uint256 i = 0; i < 330; i++) {
1050             _safeMint(_owner, ++nextTokenId);
1051         }
1052     }
1053 
1054     function mint(uint8 numTokens) external payable {
1055         require(numTokens < 2, "OMNI DOORS: Max 1 NFTs per transaction");
1056         require(
1057             nextTokenId + numTokens <= MAX_NETWORK_MINT,
1058             "OMNI DOORS: Mint exceeds supply for this network"
1059         );
1060 	for (uint8 i = 0; i < numTokens; i++) {
1061             _safeMint(msg.sender, ++nextTokenId);
1062 	}
1063     }
1064 
1065     function traverseChains(uint16 _chainId, uint256 tokenId) public payable {
1066         require(
1067             msg.sender == ownerOf(tokenId),
1068             "You must own the token to traverse"
1069         );
1070         require(
1071             trustedRemoteLookup[_chainId].length > 0,
1072             "This chain is currently unavailable for travel"
1073         );
1074 
1075         // burn NFT, eliminating it from circulation on src chain
1076         _burn(tokenId);
1077 
1078         // abi.encode() the payload with the values to send
1079         bytes memory payload = abi.encode(msg.sender, tokenId);
1080 
1081         // encode adapterParams to specify more gas for the destination
1082         uint16 version = 1;
1083         bytes memory adapterParams = abi.encodePacked(
1084             version,
1085             gasForDestinationLzReceive
1086         );
1087 
1088         // get the fees we need to pay to LayerZero + Relayer to cover message delivery
1089         // you will be refunded for extra gas paid
1090         (uint256 messageFee, ) = endpoint.estimateFees(
1091             _chainId,
1092             address(this),
1093             payload,
1094             false,
1095             adapterParams
1096         );
1097 
1098         require(
1099             msg.value >= messageFee,
1100             "OMNI DOORS: msg.value not enough to cover messageFee. Send gas for message fees"
1101         );
1102 
1103         endpoint.send{value: msg.value}(
1104             _chainId, // destination chainId
1105             trustedRemoteLookup[_chainId], // destination address of nft contract
1106             payload, // abi.encoded()'ed bytes
1107             payable(msg.sender), // refund address
1108             address(0x0), // 'zroPaymentAddress' unused for this
1109             adapterParams // txParameters
1110         );
1111     }
1112 
1113     function setBaseURI(string memory URI) external onlyOwner {
1114         baseURI = URI;
1115     }
1116 
1117     function donate() external payable {
1118     }
1119 
1120     function withdraw(uint256 amt) external onlyOwner {
1121         (bool sent, ) = payable(_owner).call{value: amt}("");
1122         require(sent, "OMNI DOORS: Failed to withdraw funds");
1123     }
1124 
1125     function setGasForDestinationLzReceive(uint256 newVal) external onlyOwner {
1126         gasForDestinationLzReceive = newVal;
1127     }
1128 
1129     function _LzReceive(
1130         uint16 _srcChainId,
1131         bytes memory _srcAddress,
1132         uint64 _nonce,
1133         bytes memory _payload
1134     ) internal override {
1135         // decode
1136         (address toAddr, uint256 tokenId) = abi.decode(
1137             _payload,
1138             (address, uint256)
1139         );
1140 
1141         // mint the tokens back into existence on destination chain
1142         _safeMint(toAddr, tokenId);
1143     }
1144 
1145     function _baseURI() internal view override returns (string memory) {
1146         return baseURI;
1147     }
1148 }