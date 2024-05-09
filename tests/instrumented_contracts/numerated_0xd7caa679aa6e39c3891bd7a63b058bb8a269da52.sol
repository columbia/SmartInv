1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 // File: @openzeppelin/contracts/interfaces/IERC20.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 
94 // File: dotApe/implementations/namehash.sol
95 
96 
97 pragma solidity 0.8.7;
98 
99 contract apeNamehash {
100     function getNamehash(string memory _name) public pure returns (bytes32 namehash) {
101         namehash = 0x0000000000000000000000000000000000000000000000000000000000000000;
102         namehash = keccak256(
103         abi.encodePacked(namehash, keccak256(abi.encodePacked('ape')))
104         );
105         namehash = keccak256(
106         abi.encodePacked(namehash, keccak256(abi.encodePacked(_name)))
107         );
108     }
109 
110     function getNamehashSubdomain(string memory _name, string memory _subdomain) public pure returns (bytes32 namehash) {
111         namehash = 0x0000000000000000000000000000000000000000000000000000000000000000;
112         namehash = keccak256(
113         abi.encodePacked(namehash, keccak256(abi.encodePacked('ape')))
114         );
115         namehash = keccak256(
116         abi.encodePacked(namehash, keccak256(abi.encodePacked(_name)))
117         );
118         namehash = keccak256(
119         abi.encodePacked(namehash, keccak256(abi.encodePacked(_subdomain)))
120         );
121     }
122 }
123 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
124 
125 
126 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
127 
128 pragma solidity ^0.8.0;
129 
130 /**
131  * @dev Interface of the ERC165 standard, as defined in the
132  * https://eips.ethereum.org/EIPS/eip-165[EIP].
133  *
134  * Implementers can declare support of contract interfaces, which can then be
135  * queried by others ({ERC165Checker}).
136  *
137  * For an implementation, see {ERC165}.
138  */
139 interface IERC165 {
140     /**
141      * @dev Returns true if this contract implements the interface defined by
142      * `interfaceId`. See the corresponding
143      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
144      * to learn more about how these ids are created.
145      *
146      * This function call must use less than 30 000 gas.
147      */
148     function supportsInterface(bytes4 interfaceId) external view returns (bool);
149 }
150 
151 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
152 
153 
154 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)
155 
156 pragma solidity ^0.8.0;
157 
158 
159 /**
160  * @dev Required interface of an ERC721 compliant contract.
161  */
162 interface IERC721 is IERC165 {
163     /**
164      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
165      */
166     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
167 
168     /**
169      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
170      */
171     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
172 
173     /**
174      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
175      */
176     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
177 
178     /**
179      * @dev Returns the number of tokens in ``owner``'s account.
180      */
181     function balanceOf(address owner) external view returns (uint256 balance);
182 
183     /**
184      * @dev Returns the owner of the `tokenId` token.
185      *
186      * Requirements:
187      *
188      * - `tokenId` must exist.
189      */
190     function ownerOf(uint256 tokenId) external view returns (address owner);
191 
192     /**
193      * @dev Safely transfers `tokenId` token from `from` to `to`.
194      *
195      * Requirements:
196      *
197      * - `from` cannot be the zero address.
198      * - `to` cannot be the zero address.
199      * - `tokenId` token must exist and be owned by `from`.
200      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
201      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
202      *
203      * Emits a {Transfer} event.
204      */
205     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
206 
207     /**
208      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
209      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
210      *
211      * Requirements:
212      *
213      * - `from` cannot be the zero address.
214      * - `to` cannot be the zero address.
215      * - `tokenId` token must exist and be owned by `from`.
216      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
217      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
218      *
219      * Emits a {Transfer} event.
220      */
221     function safeTransferFrom(address from, address to, uint256 tokenId) external;
222 
223     /**
224      * @dev Transfers `tokenId` token from `from` to `to`.
225      *
226      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
227      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
228      * understand this adds an external call which potentially creates a reentrancy vulnerability.
229      *
230      * Requirements:
231      *
232      * - `from` cannot be the zero address.
233      * - `to` cannot be the zero address.
234      * - `tokenId` token must be owned by `from`.
235      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
236      *
237      * Emits a {Transfer} event.
238      */
239     function transferFrom(address from, address to, uint256 tokenId) external;
240 
241     /**
242      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
243      * The approval is cleared when the token is transferred.
244      *
245      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
246      *
247      * Requirements:
248      *
249      * - The caller must own the token or be an approved operator.
250      * - `tokenId` must exist.
251      *
252      * Emits an {Approval} event.
253      */
254     function approve(address to, uint256 tokenId) external;
255 
256     /**
257      * @dev Approve or remove `operator` as an operator for the caller.
258      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
259      *
260      * Requirements:
261      *
262      * - The `operator` cannot be the caller.
263      *
264      * Emits an {ApprovalForAll} event.
265      */
266     function setApprovalForAll(address operator, bool approved) external;
267 
268     /**
269      * @dev Returns the account approved for `tokenId` token.
270      *
271      * Requirements:
272      *
273      * - `tokenId` must exist.
274      */
275     function getApproved(uint256 tokenId) external view returns (address operator);
276 
277     /**
278      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
279      *
280      * See {setApprovalForAll}
281      */
282     function isApprovedForAll(address owner, address operator) external view returns (bool);
283 }
284 
285 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
286 
287 
288 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
289 
290 pragma solidity ^0.8.0;
291 
292 
293 /**
294  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
295  * @dev See https://eips.ethereum.org/EIPS/eip-721
296  */
297 interface IERC721Enumerable is IERC721 {
298     /**
299      * @dev Returns the total amount of tokens stored by the contract.
300      */
301     function totalSupply() external view returns (uint256);
302 
303     /**
304      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
305      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
306      */
307     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
308 
309     /**
310      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
311      * Use along with {totalSupply} to enumerate all tokens.
312      */
313     function tokenByIndex(uint256 index) external view returns (uint256);
314 }
315 
316 // File: @openzeppelin/contracts/interfaces/IERC721Enumerable.sol
317 
318 
319 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC721Enumerable.sol)
320 
321 pragma solidity ^0.8.0;
322 
323 
324 // File: @openzeppelin/contracts/interfaces/IERC721.sol
325 
326 
327 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC721.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 
332 // File: dotApe/implementations/addressesImplementation.sol
333 
334 
335 pragma solidity ^0.8.7;
336 
337 interface IApeAddreses {
338     function owner() external view returns (address);
339     function getDotApeAddress(string memory _label) external view returns (address);
340 }
341 
342 pragma solidity ^0.8.7;
343 
344 abstract contract apeAddressesImpl {
345     address dotApeAddresses;
346 
347     constructor(address addresses_) {
348         dotApeAddresses = addresses_;
349     }
350 
351     function setAddressesImpl(address addresses_) public onlyOwner {
352         dotApeAddresses = addresses_;
353     }
354 
355     function owner() public view returns (address) {
356         return IApeAddreses(dotApeAddresses).owner();
357     }
358 
359     function getDotApeAddress(string memory _label) public view returns (address) {
360         return IApeAddreses(dotApeAddresses).getDotApeAddress(_label);
361     }
362 
363     modifier onlyOwner() {
364         require(owner() == msg.sender, "Ownable: caller is not the owner");
365         _;
366     }
367 
368     modifier onlyRegistrar() {
369         require(msg.sender == getDotApeAddress("registrar"), "Ownable: caller is not the registrar");
370         _;
371     }
372 
373     modifier onlyErc721() {
374         require(msg.sender == getDotApeAddress("erc721"), "Ownable: caller is not erc721");
375         _;
376     }
377 
378     modifier onlyTeam() {
379         require(msg.sender == getDotApeAddress("team"), "Ownable: caller is not team");
380         _;
381     }
382 
383 }
384 // File: dotApe/implementations/registryImplementation.sol
385 
386 
387 
388 pragma solidity ^0.8.7;
389 
390 
391 pragma solidity ^0.8.7;
392 
393 interface IApeRegistry {
394     function setRecord(bytes32 _hash, uint256 _tokenId, string memory _name, uint256 expiry_) external;
395     function getTokenId(bytes32 _hash) external view returns (uint256);
396     function getName(uint256 _tokenId) external view returns (string memory);
397     function currentSupply() external view returns (uint256);
398     function nextTokenId() external view returns (uint256);
399     function addOwner(address address_) external;
400     function changeOwner(address address_, uint256 tokenId_) external;
401     function getOwner(uint256 tokenId) external view returns (address);
402     function getExpiration(uint256 tokenId) external view returns (uint256);
403     function changeExpiration(uint256 tokenId, uint256 expiration_) external;
404     function setPrimaryName(address address_, uint256 tokenId) external;
405     function getPrimaryName(address address_) external view returns (string memory);
406     function getPrimaryNameTokenId(address address_) external view returns (uint256);
407     function getTxtRecord(uint256 tokenId, string memory label) external view returns (string memory);
408     function setTxtRecord(uint256 tokenId, string memory label, string memory record) external;
409 }
410 
411 pragma solidity ^0.8.7;
412 
413 abstract contract apeRegistryImpl is apeAddressesImpl {
414     
415     function setRecord(bytes32 _hash, uint256 _tokenId, string memory _name, uint256 expiry_) internal {
416         IApeRegistry(getDotApeAddress("registry")).setRecord(_hash, _tokenId, _name, expiry_);
417     }
418 
419     function getTokenId(bytes32 _hash) internal view returns (uint256) {
420         return IApeRegistry(getDotApeAddress("registry")).getTokenId(_hash);
421     }
422 
423     function getName(uint256 _tokenId) internal view returns (string memory) {
424         return IApeRegistry(getDotApeAddress("registry")).getName(_tokenId);     
425     }
426 
427     function nextTokenId() internal view returns (uint256) {
428         return IApeRegistry(getDotApeAddress("registry")).nextTokenId();
429     }
430 
431     function currentSupply() internal view returns (uint256) {
432         return IApeRegistry(getDotApeAddress("registry")).currentSupply();
433     }
434 
435     function addOwner(address address_) internal {
436         IApeRegistry(getDotApeAddress("registry")).addOwner(address_);
437     }
438 
439     function changeOwner(address address_, uint256 tokenId_) internal {
440         IApeRegistry(getDotApeAddress("registry")).changeOwner(address_, tokenId_);
441     }
442 
443     function getOwner(uint256 tokenId) internal view returns (address) {
444         return IApeRegistry(getDotApeAddress("registry")).getOwner(tokenId);
445     }
446 
447     function getExpiration(uint256 tokenId) internal view returns (uint256) {
448         return IApeRegistry(getDotApeAddress("registry")).getExpiration(tokenId);
449     }
450 
451     function changeExpiration(uint256 tokenId, uint256 expiration_) internal {
452         return IApeRegistry(getDotApeAddress("registry")).changeExpiration(tokenId, expiration_);
453     }
454 
455     function setPrimaryName(address address_, uint256 tokenId) internal {
456         return IApeRegistry(getDotApeAddress("registry")).setPrimaryName(address_, tokenId);
457     }
458 
459     function getPrimaryName(address address_) internal view returns (string memory) {
460         return IApeRegistry(getDotApeAddress("registry")).getPrimaryName(address_);
461     }
462 
463     function getPrimaryNameTokenId(address address_) internal view returns (uint256) {
464         return IApeRegistry(getDotApeAddress("registry")).getPrimaryNameTokenId(address_);
465     }
466 
467     function getTxtRecord(uint256 tokenId, string memory label) internal view returns (string memory) {
468         return IApeRegistry(getDotApeAddress("registry")).getTxtRecord(tokenId, label);
469     }
470 
471     function setTxtRecord(uint256 tokenId, string memory label, string memory record) internal {
472         return IApeRegistry(getDotApeAddress("registry")).setTxtRecord(tokenId, label, record);
473     }
474 }
475 // File: dotApe/implementations/erc721Implementation.sol
476 
477 
478 
479 pragma solidity ^0.8.7;
480 
481 
482 
483 
484 pragma solidity ^0.8.7;
485 
486 interface apeIERC721 {
487     function mint(address to) external;
488     function transferExpired(address to, uint256 tokenId) external;
489 }
490 
491 pragma solidity ^0.8.7;
492 
493 abstract contract apeErc721Impl is apeAddressesImpl {
494     
495     function mint(address to) internal {
496         apeIERC721(getDotApeAddress("erc721")).mint(to);
497     }
498 
499     function transferExpired(address to, uint256 tokenId) internal {
500         apeIERC721(getDotApeAddress("erc721")).transferExpired(to, tokenId);
501     }
502 
503     function totalSupply() internal view returns (uint256) {
504         return IERC721Enumerable(getDotApeAddress("erc721")).totalSupply();
505     }
506 
507 }
508 // File: dotApe/presaleRegistrar.sol
509 
510 
511 pragma solidity ^0.8.7;
512 
513 
514 
515 
516 
517 pragma solidity ^0.8.0;
518 
519 interface priceOracle {
520     function getCost(string memory name, uint256 durationInYears) external view returns (uint256);
521     function getCostUsd(string memory name, uint256 durationInYears) external view returns (uint256);
522     function getCostApecoin(string memory name, uint256 durationInYears) external view returns (uint256);
523 
524 }
525 
526 abstract contract priceOracleImpl is apeAddressesImpl {
527 
528     function getCost(string memory name, uint256 durationInYears) public view returns (uint256) {
529         return priceOracle(getDotApeAddress("priceOracle")).getCost(name, durationInYears);
530     }
531 
532     function getCostUsd(string memory name, uint256 durationInYears) public view returns (uint256) {
533         return priceOracle(getDotApeAddress("priceOracle")).getCostUsd(name, durationInYears);
534     }
535 
536     function getCostApecoin(string memory name, uint256 durationInYears) public view returns (uint256) {
537         return priceOracle(getDotApeAddress("priceOracle")).getCostApecoin(name, durationInYears);
538     }
539 }
540 
541 pragma solidity >=0.6.0;
542 
543 library TransferHelper {
544     /// @notice Transfers tokens from the targeted address to the given destination
545     /// @notice Errors with 'STF' if transfer fails
546     /// @param token The contract address of the token to be transferred
547     /// @param from The originating address from which the tokens will be transferred
548     /// @param to The destination address of the transfer
549     /// @param value The amount to be transferred
550     function safeTransferFrom(
551         address token,
552         address from,
553         address to,
554         uint256 value
555     ) internal {
556         (bool success, bytes memory data) =
557             token.call(abi.encodeWithSelector(IERC20.transferFrom.selector, from, to, value));
558         require(success && (data.length == 0 || abi.decode(data, (bool))), 'STF');
559     }
560 
561     /// @notice Transfers tokens from msg.sender to a recipient
562     /// @dev Errors with ST if transfer fails
563     /// @param token The contract address of the token which will be transferred
564     /// @param to The recipient of the transfer
565     /// @param value The value of the transfer
566     function safeTransfer(
567         address token,
568         address to,
569         uint256 value
570     ) internal {
571         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(IERC20.transfer.selector, to, value));
572         require(success && (data.length == 0 || abi.decode(data, (bool))), 'ST');
573     }
574 }
575 
576 pragma solidity 0.8.7;
577 
578 
579 abstract contract Signatures {
580 
581     struct Register {
582         string name;
583         address address_;
584         uint256 durationInYears;
585         uint256 cost;
586         bool primaryName;
587         bytes sig;
588         uint256 sigExpiration;
589     }
590 
591     struct Extend {
592         uint256 tokenId;
593         uint256 durationInYears;
594         uint256 cost;
595         bytes sig;
596         uint256 sigExpiration;
597     }
598      
599     function verifySignature(Register memory register_) public view returns(address) {
600         require(block.timestamp < register_.sigExpiration, "Signature has expired");
601         bytes32 message = keccak256(abi.encode(register_.name, register_.address_, register_.durationInYears, register_.cost, register_.primaryName, register_.sigExpiration));
602         return recoverSigner(message, register_.sig);
603     }
604 
605     function verifySignatureErc20(Register memory register_, address token) public view returns(address) {
606         require(block.timestamp < register_.sigExpiration, "Signature has expired");
607         bytes32 message = keccak256(abi.encode(register_.name, register_.address_, register_.durationInYears, register_.cost, token, register_.primaryName, register_.sigExpiration));
608         return recoverSigner(message, register_.sig);
609     }
610 
611     function verifySignatureExtend(Extend memory extend_) public view returns(address) {
612         require(block.timestamp < extend_.sigExpiration, "Signature has expired");
613         bytes32 message = keccak256(abi.encode(extend_.tokenId, extend_.durationInYears, extend_.cost, extend_.sigExpiration));
614         return recoverSigner(message, extend_.sig);
615     }
616 
617    function recoverSigner(bytes32 message, bytes memory sig)
618        public
619        pure
620        returns (address)
621      {
622        uint8 v;
623        bytes32 r;
624        bytes32 s;
625        (v, r, s) = splitSignature(sig);
626        return ecrecover(message, v, r, s);
627    }
628 
629    function splitSignature(bytes memory sig)
630        internal
631        pure
632        returns (uint8, bytes32, bytes32)
633      {
634        require(sig.length == 65);
635 
636        bytes32 r;
637        bytes32 s;
638        uint8 v;
639 
640        assembly {
641            // first 32 bytes, after the length prefix
642            r := mload(add(sig, 32))
643            // second 32 bytes
644            s := mload(add(sig, 64))
645            // final byte (first byte of the next 32 bytes)
646            v := byte(0, mload(add(sig, 96)))
647        }
648  
649        return (v, r, s);
650    }
651 }
652 
653 contract dotApePublicRegistrar is apeErc721Impl, apeRegistryImpl, apeNamehash, priceOracleImpl, Signatures {
654 
655     constructor(address _address) apeAddressesImpl(_address) {
656         erc20Accepted[apecoinAddress] = true;
657         erc20Accepted[usdtAddress] = true;
658         erc20Accepted[wethAddress] = true;
659     }
660     bool isContractActive = true;
661     address apecoinAddress = 0x4d224452801ACEd8B2F0aebE155379bb5D594381;
662     address usdtAddress = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
663     address wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
664     mapping(address => bool) private erc20Accepted;
665     uint256 secondsInYears = 365 days;
666 
667     struct RegisterTeam {
668         string name;
669         address registrant;
670         uint256 durationInYears;
671     }
672 
673     struct TxtRecord {
674         string label;
675         string record;
676     }
677 
678     struct PrimaryName {
679         address address_;
680         uint256 tokenId;
681     }
682 
683     event Registered(address indexed to, uint256 indexed tokenId, string indexed name, uint256 expiration);
684     event Extended(address indexed owner, uint256 indexed tokenId, string indexed name, uint256 previousExpiration, uint256 newExpiration);
685 
686     function register(Register[] memory registerParams) public payable {
687         require(isContractActive, "Contract is not active");
688         require(verifyAllSignatures(registerParams), "Not signed by signer");
689         require(getTotalCost(registerParams) <= msg.value, "Value sent is not correct");
690         
691         bool[] memory success = new bool[](registerParams.length);
692         for(uint256 i=0; i < registerParams.length; i++) {
693             success[i] = _register(msg.sender, registerParams[i].name, registerParams[i].durationInYears);
694 
695             if(success[i] && registerParams[i].primaryName) {
696                 setPrimaryName(msg.sender, getTokenId(getNamehash(registerParams[i].name)));
697             }
698         }
699         settleRefund(registerParams, success);
700     }
701 
702     function registerErc20(Register[] memory registerParams, address token) public {
703         require(isContractActive, "Contract is not active");
704         require(verifyAllSignaturesErc20(registerParams, token), "Not signed by signer");
705         
706         receiveErc20(token, msg.sender, getTotalCost(registerParams));
707 
708         bool[] memory success = new bool[](registerParams.length);
709         for(uint256 i=0; i < registerParams.length; i++) {
710             success[i] = _register(msg.sender, registerParams[i].name, registerParams[i].durationInYears);
711 
712             if(success[i] && registerParams[i].primaryName) {
713                 setPrimaryName(msg.sender, getTokenId(getNamehash(registerParams[i].name)));
714             }
715         }
716         settleRefundErc20(registerParams, success, token);
717     }
718 
719     function getTotalCost(Register[] memory registerParams) internal pure returns (uint256) {
720         uint256 total = 0;
721         for(uint256 i=0; i < registerParams.length; i++) {
722             total = total + registerParams[i].cost;
723         }
724         return total;
725     }
726 
727     function verifyAllSignatures(Register[] memory registerParams) internal view returns (bool) {
728         for(uint256 i=0; i < registerParams.length; i++) {
729             require(verifySignature(registerParams[i]) == getDotApeAddress("signer"), "Not signed by signer");
730             require(registerParams[i].address_ == msg.sender, "Caller is authorized");
731         }
732         return true;
733     }
734 
735     function verifyAllSignaturesErc20(Register[] memory registerParams, address token) internal view returns (bool) {
736         for(uint256 i=0; i < registerParams.length; i++) {
737             require(verifySignatureErc20(registerParams[i], token) == getDotApeAddress("signer"), "Not signed by signer");
738             require(registerParams[i].address_ == msg.sender, "Caller is authorized");
739         }
740         return true;
741     }
742 
743     function registerTeam(RegisterTeam[] memory registerParams) public onlyTeam {
744         require(isContractActive, "Contract is not active");
745         for(uint256 i=0; i < registerParams.length; i++) {
746             _register(registerParams[i].registrant, registerParams[i].name, registerParams[i].durationInYears);
747         }
748     }
749     
750     function _register(address registrant, string memory name, uint256 durationInYears) internal returns (bool) {
751         require(verifyName(name), "Name not supported");
752         bytes32 namehash = getNamehash(name);
753         if(!isRegistered(namehash)) {
754             //mint
755             mint(registrant);
756             uint256 tokenId = currentSupply();
757             uint256 expiration = block.timestamp + (durationInYears * secondsInYears);
758             setRecord(namehash, tokenId, name, expiration);
759 
760             emit Registered(registrant, tokenId, string(abi.encodePacked(name, ".ape")), expiration);
761             return true;
762         } else {
763             uint256 tokenId = getTokenId(namehash);
764             if(isExpired(tokenId)) {
765                 //change owner
766                 transferExpired(registrant, tokenId);
767                 uint256 expiration = block.timestamp + (durationInYears * secondsInYears);
768                 changeExpiration(tokenId, expiration);
769 
770                 emit Registered(registrant, tokenId, string(abi.encodePacked(name, ".ape")), expiration);
771                 return true;
772             } else {
773                 return false;
774             }
775         }
776     }
777 
778     function extend(Extend[] memory extendParams) public payable {
779         require(isContractActive, "Contract is not active");
780         require(verifyAllSignaturesExtend(extendParams), "Not signed by signer");
781         require(getTotalCostExtend(extendParams) <= msg.value, "Value sent is not correct");
782 
783         for(uint256 i; i < extendParams.length; i++) {
784             require(getOwner(extendParams[i].tokenId) == msg.sender, "Caller not owner");
785             _extend(extendParams[i].tokenId, extendParams[i].durationInYears);
786         }
787     }
788 
789     function getTotalCostExtend(Extend[] memory extendParams) internal pure returns (uint256) {
790         uint256 total = 0;
791         for(uint256 i=0; i < extendParams.length; i++) {
792             total = total + extendParams[i].cost;
793         }
794         return total;
795     }
796 
797     function verifyAllSignaturesExtend(Extend[] memory extendParams) internal view returns (bool) {
798         for(uint256 i=0; i < extendParams.length; i++) {
799             require(verifySignatureExtend(extendParams[i]) == getDotApeAddress("signer"), "Not signed by signer");
800         }
801         return true;
802     }
803 
804     function extendTeam(Extend[] memory extendParams) public onlyTeam {
805         require(isContractActive, "Contract is not active");
806         for(uint256 i; i < extendParams.length; i++) {
807             _extend(extendParams[i].tokenId, extendParams[i].durationInYears);
808         }
809     }
810 
811     function _extend(uint256 tokenId, uint256 durationInYears) internal {
812         require(tokenId <= currentSupply() && tokenId != 0, "TokenId not registered");
813         require(!isExpired(tokenId), "TokenId is expired");
814 
815         uint256 oldExpiration = getExpiration(tokenId);
816         uint256 newExpiration = getExpiration(tokenId) + (durationInYears * secondsInYears);
817         changeExpiration(tokenId, newExpiration);
818 
819         emit Extended(getOwner(tokenId), tokenId, string(abi.encodePacked(getName(tokenId), ".ape")), oldExpiration, newExpiration);
820     }
821 
822     function setPrimary(uint256 tokenId) public {
823         require(getOwner(tokenId) == msg.sender, "Caller is not the owner");
824         setPrimaryName(msg.sender, tokenId);
825     }
826 
827     function setPrimaryTeam(PrimaryName[] memory primaryNames) public onlyTeam {
828         for(uint256 i=0; i<primaryNames.length; i++) {
829             setPrimaryName(primaryNames[i].address_, primaryNames[i].tokenId);
830         }
831     }
832 
833     function setTxtRecords(uint256 tokenId, TxtRecord[] memory txtRecords) public {
834         require(isContractActive, "Contract is not active");
835         require(getOwner(tokenId) == msg.sender, "Caller is not the owner");
836 
837         for(uint256 i=0; i<txtRecords.length; i++) {
838             setTxtRecord(tokenId, txtRecords[i].label, txtRecords[i].record);
839         }
840     }
841 
842     function verifyName(string memory input) public pure returns (bool) {
843         bytes memory stringBytes = bytes(input);
844         
845         if (stringBytes.length < 3) {
846             return false; // String is less than 3 characters
847         }
848 
849         for (uint i = 0; i < stringBytes.length; i++) {
850             if (stringBytes[i] == "." || stringBytes[i] == " ") {
851                 return false; // String contains a period or space
852             }
853 
854             if (uint8(stringBytes[i]) >= 65 && uint8(stringBytes[i]) <= 90) {
855                 return false; // String contains uppercase letters
856             }
857         }
858         
859         return true; // String is valid and lowercase
860     }
861 
862     function isRegistered(bytes32 namehash) public view returns (bool) {
863         return getTokenId(namehash) != 0;
864     }
865 
866     function isExpired(uint256 tokenId) public view returns (bool) {
867         return getExpiration(tokenId) < block.timestamp && getOwner(tokenId) == getDotApeAddress("expiredVault");
868     }
869 
870     function isAvailable(string memory name) public view returns (bool) {
871         bytes32 namehash = getNamehash(name);
872         if(isRegistered(namehash)) {
873             uint256 tokenId = getTokenId(namehash);
874             if(isExpired(tokenId)) {
875                 return true;
876             } else {
877                 return false;
878             }
879         } else {
880             return true;
881         }
882     }
883 
884     function getTimestamp() public view returns (uint256) {
885         return block.timestamp;
886     }
887 
888     function settleRefund(Register[] memory registerParams, bool[] memory success) internal {
889         for(uint256 i; i < registerParams.length; i++) {
890             if(!success[i]) {
891                 payable(msg.sender).transfer(registerParams[i].cost);
892             }
893         }
894     }
895 
896     function settleRefundErc20(Register[] memory registerParams, bool[] memory success, address erc20) internal {
897         for(uint256 i; i < registerParams.length; i++) {
898             if(!success[i]) {
899                 sendErc20(erc20, msg.sender, registerParams[i].cost);
900             }
901         }
902     }
903 
904     function receiveErc20(address erc20, address spender, uint256 amount) internal {
905         require(amount <= IERC20(erc20).allowance(spender, address(this)), "Value not allowed by caller");
906         TransferHelper.safeTransferFrom(erc20, spender, address(this), amount);
907     }
908 
909     function sendErc20(address erc20, address receiver, uint256 amount) internal {
910         require(IERC20(erc20).balanceOf(address(this)) >= amount, "Balance of contract is less than amount");
911         TransferHelper.safeTransfer(erc20, receiver, amount);
912     }
913 
914     function withdraw(address to, uint256 amount) public onlyOwner {
915         require(amount <= address(this).balance);
916         payable(to).transfer(amount);
917     }
918 
919     function withdrawErc20(address to, uint256 amount, address token_) public onlyOwner {
920         IERC20 erc20 = IERC20(token_);
921         require(amount <= erc20.balanceOf(address(this)), "Amount exceeds balance.");
922         TransferHelper.safeTransfer(token_, to, amount);
923     }
924 
925     function flipContractActive() public onlyOwner {
926         isContractActive = !isContractActive;
927     }
928 }