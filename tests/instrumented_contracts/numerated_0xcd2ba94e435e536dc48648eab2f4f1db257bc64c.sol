1 // SPDX-License-Identifier: MIT
2 // If you think you may have found a vulnerability
3 // File: @opengsn/contracts/src/interfaces/IRelayRecipient.sol
4 
5 
6 pragma solidity >=0.6.0;
7 
8 /**
9  * a contract must implement this interface in order to support relayed transaction.
10  * It is better to inherit the BaseRelayRecipient as its implementation.
11  */
12 abstract contract IRelayRecipient {
13 
14     /**
15      * return if the forwarder is trusted to forward relayed transactions to us.
16      * the forwarder is required to verify the sender's signature, and verify
17      * the call is not a replay.
18      */
19     function isTrustedForwarder(address forwarder) public virtual view returns(bool);
20 
21     /**
22      * return the sender of this call.
23      * if the call came through our trusted forwarder, then the real sender is appended as the last 20 bytes
24      * of the msg.data.
25      * otherwise, return `msg.sender`
26      * should be used in the contract anywhere instead of msg.sender
27      */
28     function _msgSender() internal virtual view returns (address);
29 
30     /**
31      * return the msg.data of this call.
32      * if the call came through our trusted forwarder, then the real sender was appended as the last 20 bytes
33      * of the msg.data - so this method will strip those 20 bytes off.
34      * otherwise (if the call was made directly and not through the forwarder), return `msg.data`
35      * should be used in the contract instead of msg.data, where this difference matters.
36      */
37     function _msgData() internal virtual view returns (bytes calldata);
38 
39     function versionRecipient() external virtual view returns (string memory);
40 }
41 
42 // File: @opengsn/contracts/src/BaseRelayRecipient.sol
43 
44 
45 // solhint-disable no-inline-assembly
46 pragma solidity >=0.6.9;
47 
48 
49 /**
50  * A base contract to be inherited by any contract that want to receive relayed transactions
51  * A subclass must use "_msgSender()" instead of "msg.sender"
52  */
53 abstract contract BaseRelayRecipient is IRelayRecipient {
54 
55     /*
56      * Forwarder singleton we accept calls from
57      */
58     address private _trustedForwarder;
59 
60     function trustedForwarder() public virtual view returns (address){
61         return _trustedForwarder;
62     }
63 
64     function _setTrustedForwarder(address _forwarder) internal {
65         _trustedForwarder = _forwarder;
66     }
67 
68     function isTrustedForwarder(address forwarder) public virtual override view returns(bool) {
69         return forwarder == _trustedForwarder;
70     }
71 
72     /**
73      * return the sender of this call.
74      * if the call came through our trusted forwarder, return the original sender.
75      * otherwise, return `msg.sender`.
76      * should be used in the contract anywhere instead of msg.sender
77      */
78     function _msgSender() internal override virtual view returns (address ret) {
79         if (msg.data.length >= 20 && isTrustedForwarder(msg.sender)) {
80             // At this point we know that the sender is a trusted forwarder,
81             // so we trust that the last bytes of msg.data are the verified sender address.
82             // extract sender address from the end of msg.data
83             assembly {
84                 ret := shr(96,calldataload(sub(calldatasize(),20)))
85             }
86         } else {
87             ret = msg.sender;
88         }
89     }
90 
91     /**
92      * return the msg.data of this call.
93      * if the call came through our trusted forwarder, then the real sender was appended as the last 20 bytes
94      * of the msg.data - so this method will strip those 20 bytes off.
95      * otherwise (if the call was made directly and not through the forwarder), return `msg.data`
96      * should be used in the contract instead of msg.data, where this difference matters.
97      */
98     function _msgData() internal override virtual view returns (bytes calldata ret) {
99         if (msg.data.length >= 20 && isTrustedForwarder(msg.sender)) {
100             return msg.data[0:msg.data.length-20];
101         } else {
102             return msg.data;
103         }
104     }
105 }
106 
107 // File: contracts/lib/RelayRecipient.sol
108 
109 
110 
111 pragma solidity ^0.8.0;
112 
113 // import "@opengsn/gsn/contracts/BaseRelayRecipient.sol";
114 
115 
116 contract RelayRecipient is BaseRelayRecipient {
117     function versionRecipient() external pure override returns (string memory) {
118         return "1.0.0-beta.1/charged-particles.relay.recipient";
119     }
120 }
121 
122 // File: contracts/lib/TokenInfo.sol
123 
124 
125 
126 // TokenInfo.sol -- Part of the Charged Particles Protocol
127 // Copyright (c) 2021 Firma Lux, Inc. <https://charged.fi>
128 //
129 // Permission is hereby granted, free of charge, to any person obtaining a copy
130 // of this software and associated documentation files (the "Software"), to deal
131 // in the Software without restriction, including without limitation the rights
132 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
133 // copies of the Software, and to permit persons to whom the Software is
134 // furnished to do so, subject to the following conditions:
135 //
136 // The above copyright notice and this permission notice shall be included in all
137 // copies or substantial portions of the Software.
138 //
139 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
140 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
141 // FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
142 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
143 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
144 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
145 // SOFTWARE.
146 
147 pragma solidity ^0.8.0;
148 
149 library TokenInfo {
150     /**
151      * @dev Returns true if `account` is a contract.
152      * @dev Taken from OpenZeppelin library
153      *
154      * [IMPORTANT]
155      * ====
156      * It is unsafe to assume that an address for which this function returns
157      * false is an externally-owned account (EOA) and not a contract.
158      *
159      * Among others, `isContract` will return false for the following
160      * types of addresses:
161      *
162      *  - an externally-owned account
163      *  - a contract in construction
164      *  - an address where a contract will be created
165      *  - an address where a contract lived, but was destroyed
166      * ====
167      */
168     function isContract(address account) internal view returns (bool) {
169         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
170         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
171         // for accounts without code, i.e. `keccak256('')`
172         bytes32 codehash;
173         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
174         // solhint-disable-next-line no-inline-assembly
175         assembly {
176             codehash := extcodehash(account)
177         }
178         return (codehash != accountHash && codehash != 0x0);
179     }
180 
181     /**
182      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
183      * `recipient`, forwarding all available gas and reverting on errors.
184      * @dev Taken from OpenZeppelin library
185      *
186      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
187      * of certain opcodes, possibly making contracts go over the 2300 gas limit
188      * imposed by `transfer`, making them unable to receive funds via
189      * `transfer`. {sendValue} removes this limitation.
190      *
191      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
192      *
193      * IMPORTANT: because control is transferred to `recipient`, care must be
194      * taken to not create reentrancy vulnerabilities. Consider using
195      * {ReentrancyGuard} or the
196      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
197      */
198     function sendValue(
199         address payable recipient,
200         uint256 amount,
201         uint256 gasLimit
202     ) internal {
203         require(
204             address(this).balance >= amount,
205             "TokenInfo: insufficient balance"
206         );
207 
208         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
209         (bool success, ) = (gasLimit > 0)
210             ? recipient.call{value: amount, gas: gasLimit}("")
211             : recipient.call{value: amount}("");
212         require(
213             success,
214             "TokenInfo: unable to send value, recipient may have reverted"
215         );
216     }
217 }
218 
219 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
220 
221 
222 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
223 
224 pragma solidity ^0.8.0;
225 
226 /**
227  * @title ERC721 token receiver interface
228  * @dev Interface for any contract that wants to support safeTransfers
229  * from ERC721 asset contracts.
230  */
231 interface IERC721Receiver {
232     /**
233      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
234      * by `operator` from `from`, this function is called.
235      *
236      * It must return its Solidity selector to confirm the token transfer.
237      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
238      *
239      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
240      */
241     function onERC721Received(
242         address operator,
243         address from,
244         uint256 tokenId,
245         bytes calldata data
246     ) external returns (bytes4);
247 }
248 
249 // File: contracts/interfaces/ISignatureVerifier.sol
250 
251 
252 pragma solidity ^0.8.0;
253 
254 interface ISignatureVerifier {
255     function verify(
256         address _signer,
257         address _to,
258         uint256 _amount,
259         uint256 _nonce,
260         bytes memory signature
261     ) external pure returns (bool);
262 }
263 
264 // File: contracts/interfaces/IChargedParticles.sol
265 
266 
267 
268 // IChargedParticles.sol -- Part of the Charged Particles Protocol
269 // Copyright (c) 2021 Firma Lux, Inc. <https://charged.fi>
270 //
271 // Permission is hereby granted, free of charge, to any person obtaining a copy
272 // of this software and associated documentation files (the "Software"), to deal
273 // in the Software without restriction, including without limitation the rights
274 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
275 // copies of the Software, and to permit persons to whom the Software is
276 // furnished to do so, subject to the following conditions:
277 //
278 // The above copyright notice and this permission notice shall be included in all
279 // copies or substantial portions of the Software.
280 //
281 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
282 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
283 // FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
284 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
285 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
286 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
287 // SOFTWARE.
288 
289 pragma solidity ^0.8.0;
290 
291 /**
292  * @notice Interface for Charged Particles
293  */
294 interface IChargedParticles {
295     /***********************************|
296     |             Public API            |
297     |__________________________________*/
298 
299     function getStateAddress() external view returns (address stateAddress);
300 
301     function getSettingsAddress()
302         external
303         view
304         returns (address settingsAddress);
305 
306     function getManagersAddress()
307         external
308         view
309         returns (address managersAddress);
310 
311     function getFeesForDeposit(uint256 assetAmount)
312         external
313         view
314         returns (uint256 protocolFee);
315 
316     function baseParticleMass(
317         address contractAddress,
318         uint256 tokenId,
319         string calldata walletManagerId,
320         address assetToken
321     ) external returns (uint256);
322 
323     function currentParticleCharge(
324         address contractAddress,
325         uint256 tokenId,
326         string calldata walletManagerId,
327         address assetToken
328     ) external returns (uint256);
329 
330     function currentParticleKinetics(
331         address contractAddress,
332         uint256 tokenId,
333         string calldata walletManagerId,
334         address assetToken
335     ) external returns (uint256);
336 
337     function currentParticleCovalentBonds(
338         address contractAddress,
339         uint256 tokenId,
340         string calldata basketManagerId
341     ) external view returns (uint256);
342 
343     /***********************************|
344     |        Particle Mechanics         |
345     |__________________________________*/
346 
347     function energizeParticle(
348         address contractAddress,
349         uint256 tokenId,
350         string calldata walletManagerId,
351         address assetToken,
352         uint256 assetAmount,
353         address referrer
354     ) external returns (uint256 yieldTokensAmount);
355 
356     function dischargeParticle(
357         address receiver,
358         address contractAddress,
359         uint256 tokenId,
360         string calldata walletManagerId,
361         address assetToken
362     ) external returns (uint256 creatorAmount, uint256 receiverAmount);
363 
364     function dischargeParticleAmount(
365         address receiver,
366         address contractAddress,
367         uint256 tokenId,
368         string calldata walletManagerId,
369         address assetToken,
370         uint256 assetAmount
371     ) external returns (uint256 creatorAmount, uint256 receiverAmount);
372 
373     function dischargeParticleForCreator(
374         address receiver,
375         address contractAddress,
376         uint256 tokenId,
377         string calldata walletManagerId,
378         address assetToken,
379         uint256 assetAmount
380     ) external returns (uint256 receiverAmount);
381 
382     function releaseParticle(
383         address receiver,
384         address contractAddress,
385         uint256 tokenId,
386         string calldata walletManagerId,
387         address assetToken
388     ) external returns (uint256 creatorAmount, uint256 receiverAmount);
389 
390     function releaseParticleAmount(
391         address receiver,
392         address contractAddress,
393         uint256 tokenId,
394         string calldata walletManagerId,
395         address assetToken,
396         uint256 assetAmount
397     ) external returns (uint256 creatorAmount, uint256 receiverAmount);
398 
399     function covalentBond(
400         address contractAddress,
401         uint256 tokenId,
402         string calldata basketManagerId,
403         address nftTokenAddress,
404         uint256 nftTokenId
405     ) external returns (bool success);
406 
407     function breakCovalentBond(
408         address receiver,
409         address contractAddress,
410         uint256 tokenId,
411         string calldata basketManagerId,
412         address nftTokenAddress,
413         uint256 nftTokenId
414     ) external returns (bool success);
415 
416     /***********************************|
417     |          Particle Events          |
418     |__________________________________*/
419 
420     event Initialized(address indexed initiator);
421     event ControllerSet(address indexed controllerAddress, string controllerId);
422     event DepositFeeSet(uint256 depositFee);
423     event ProtocolFeesCollected(
424         address indexed assetToken,
425         uint256 depositAmount,
426         uint256 feesCollected
427     );
428 }
429 
430 // File: contracts/interfaces/IChargedState.sol
431 
432 
433 
434 // IChargedSettings.sol -- Part of the Charged Particles Protocol
435 // Copyright (c) 2021 Firma Lux, Inc. <https://charged.fi>
436 //
437 // Permission is hereby granted, free of charge, to any person obtaining a copy
438 // of this software and associated documentation files (the "Software"), to deal
439 // in the Software without restriction, including without limitation the rights
440 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
441 // copies of the Software, and to permit persons to whom the Software is
442 // furnished to do so, subject to the following conditions:
443 //
444 // The above copyright notice and this permission notice shall be included in all
445 // copies or substantial portions of the Software.
446 //
447 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
448 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
449 // FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
450 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
451 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
452 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
453 // SOFTWARE.
454 
455 pragma solidity ^0.8.0;
456 
457 /**
458  * @notice Interface for Charged State
459  */
460 interface IChargedState {
461     /***********************************|
462     |      Only NFT Owner/Operator      |
463     |__________________________________*/
464 
465     function setDischargeApproval(
466         address contractAddress,
467         uint256 tokenId,
468         address operator
469     ) external;
470 
471     function setReleaseApproval(
472         address contractAddress,
473         uint256 tokenId,
474         address operator
475     ) external;
476 
477     function setBreakBondApproval(
478         address contractAddress,
479         uint256 tokenId,
480         address operator
481     ) external;
482 
483     function setTimelockApproval(
484         address contractAddress,
485         uint256 tokenId,
486         address operator
487     ) external;
488 
489     function setApprovalForAll(
490         address contractAddress,
491         uint256 tokenId,
492         address operator
493     ) external;
494 
495     function setPermsForRestrictCharge(
496         address contractAddress,
497         uint256 tokenId,
498         bool state
499     ) external;
500 
501     function setPermsForAllowDischarge(
502         address contractAddress,
503         uint256 tokenId,
504         bool state
505     ) external;
506 
507     function setPermsForAllowRelease(
508         address contractAddress,
509         uint256 tokenId,
510         bool state
511     ) external;
512 
513     function setPermsForRestrictBond(
514         address contractAddress,
515         uint256 tokenId,
516         bool state
517     ) external;
518 
519     function setPermsForAllowBreakBond(
520         address contractAddress,
521         uint256 tokenId,
522         bool state
523     ) external;
524 
525     function setDischargeTimelock(
526         address contractAddress,
527         uint256 tokenId,
528         uint256 unlockBlock
529     ) external;
530 
531     function setReleaseTimelock(
532         address contractAddress,
533         uint256 tokenId,
534         uint256 unlockBlock
535     ) external;
536 
537     function setBreakBondTimelock(
538         address contractAddress,
539         uint256 tokenId,
540         uint256 unlockBlock
541     ) external;
542 
543     /***********************************|
544     |         Only NFT Contract         |
545     |__________________________________*/
546 
547     function setTemporaryLock(
548         address contractAddress,
549         uint256 tokenId,
550         bool isLocked
551     ) external;
552 }
553 
554 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
555 
556 
557 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 /**
562  * @dev Interface of the ERC165 standard, as defined in the
563  * https://eips.ethereum.org/EIPS/eip-165[EIP].
564  *
565  * Implementers can declare support of contract interfaces, which can then be
566  * queried by others ({ERC165Checker}).
567  *
568  * For an implementation, see {ERC165}.
569  */
570 interface IERC165 {
571     /**
572      * @dev Returns true if this contract implements the interface defined by
573      * `interfaceId`. See the corresponding
574      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
575      * to learn more about how these ids are created.
576      *
577      * This function call must use less than 30 000 gas.
578      */
579     function supportsInterface(bytes4 interfaceId) external view returns (bool);
580 }
581 
582 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
583 
584 
585 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
586 
587 pragma solidity ^0.8.0;
588 
589 
590 /**
591  * @dev Required interface of an ERC1155 compliant contract, as defined in the
592  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
593  *
594  * _Available since v3.1._
595  */
596 interface IERC1155 is IERC165 {
597     /**
598      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
599      */
600     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
601 
602     /**
603      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
604      * transfers.
605      */
606     event TransferBatch(
607         address indexed operator,
608         address indexed from,
609         address indexed to,
610         uint256[] ids,
611         uint256[] values
612     );
613 
614     /**
615      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
616      * `approved`.
617      */
618     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
619 
620     /**
621      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
622      *
623      * If an {URI} event was emitted for `id`, the standard
624      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
625      * returned by {IERC1155MetadataURI-uri}.
626      */
627     event URI(string value, uint256 indexed id);
628 
629     /**
630      * @dev Returns the amount of tokens of token type `id` owned by `account`.
631      *
632      * Requirements:
633      *
634      * - `account` cannot be the zero address.
635      */
636     function balanceOf(address account, uint256 id) external view returns (uint256);
637 
638     /**
639      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
640      *
641      * Requirements:
642      *
643      * - `accounts` and `ids` must have the same length.
644      */
645     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
646         external
647         view
648         returns (uint256[] memory);
649 
650     /**
651      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
652      *
653      * Emits an {ApprovalForAll} event.
654      *
655      * Requirements:
656      *
657      * - `operator` cannot be the caller.
658      */
659     function setApprovalForAll(address operator, bool approved) external;
660 
661     /**
662      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
663      *
664      * See {setApprovalForAll}.
665      */
666     function isApprovedForAll(address account, address operator) external view returns (bool);
667 
668     /**
669      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
670      *
671      * Emits a {TransferSingle} event.
672      *
673      * Requirements:
674      *
675      * - `to` cannot be the zero address.
676      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
677      * - `from` must have a balance of tokens of type `id` of at least `amount`.
678      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
679      * acceptance magic value.
680      */
681     function safeTransferFrom(
682         address from,
683         address to,
684         uint256 id,
685         uint256 amount,
686         bytes calldata data
687     ) external;
688 
689     /**
690      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
691      *
692      * Emits a {TransferBatch} event.
693      *
694      * Requirements:
695      *
696      * - `ids` and `amounts` must have the same length.
697      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
698      * acceptance magic value.
699      */
700     function safeBatchTransferFrom(
701         address from,
702         address to,
703         uint256[] calldata ids,
704         uint256[] calldata amounts,
705         bytes calldata data
706     ) external;
707 }
708 
709 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
710 
711 
712 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
713 
714 pragma solidity ^0.8.0;
715 
716 
717 /**
718  * @dev Implementation of the {IERC165} interface.
719  *
720  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
721  * for the additional interface id that will be supported. For example:
722  *
723  * ```solidity
724  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
725  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
726  * }
727  * ```
728  *
729  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
730  */
731 abstract contract ERC165 is IERC165 {
732     /**
733      * @dev See {IERC165-supportsInterface}.
734      */
735     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
736         return interfaceId == type(IERC165).interfaceId;
737     }
738 }
739 
740 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
741 
742 
743 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
744 
745 pragma solidity ^0.8.0;
746 
747 
748 /**
749  * @dev Required interface of an ERC721 compliant contract.
750  */
751 interface IERC721 is IERC165 {
752     /**
753      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
754      */
755     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
756 
757     /**
758      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
759      */
760     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
761 
762     /**
763      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
764      */
765     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
766 
767     /**
768      * @dev Returns the number of tokens in ``owner``'s account.
769      */
770     function balanceOf(address owner) external view returns (uint256 balance);
771 
772     /**
773      * @dev Returns the owner of the `tokenId` token.
774      *
775      * Requirements:
776      *
777      * - `tokenId` must exist.
778      */
779     function ownerOf(uint256 tokenId) external view returns (address owner);
780 
781     /**
782      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
783      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
784      *
785      * Requirements:
786      *
787      * - `from` cannot be the zero address.
788      * - `to` cannot be the zero address.
789      * - `tokenId` token must exist and be owned by `from`.
790      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
791      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
792      *
793      * Emits a {Transfer} event.
794      */
795     function safeTransferFrom(
796         address from,
797         address to,
798         uint256 tokenId
799     ) external;
800 
801     /**
802      * @dev Transfers `tokenId` token from `from` to `to`.
803      *
804      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
805      *
806      * Requirements:
807      *
808      * - `from` cannot be the zero address.
809      * - `to` cannot be the zero address.
810      * - `tokenId` token must be owned by `from`.
811      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
812      *
813      * Emits a {Transfer} event.
814      */
815     function transferFrom(
816         address from,
817         address to,
818         uint256 tokenId
819     ) external;
820 
821     /**
822      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
823      * The approval is cleared when the token is transferred.
824      *
825      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
826      *
827      * Requirements:
828      *
829      * - The caller must own the token or be an approved operator.
830      * - `tokenId` must exist.
831      *
832      * Emits an {Approval} event.
833      */
834     function approve(address to, uint256 tokenId) external;
835 
836     /**
837      * @dev Returns the account approved for `tokenId` token.
838      *
839      * Requirements:
840      *
841      * - `tokenId` must exist.
842      */
843     function getApproved(uint256 tokenId) external view returns (address operator);
844 
845     /**
846      * @dev Approve or remove `operator` as an operator for the caller.
847      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
848      *
849      * Requirements:
850      *
851      * - The `operator` cannot be the caller.
852      *
853      * Emits an {ApprovalForAll} event.
854      */
855     function setApprovalForAll(address operator, bool _approved) external;
856 
857     /**
858      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
859      *
860      * See {setApprovalForAll}
861      */
862     function isApprovedForAll(address owner, address operator) external view returns (bool);
863 
864     /**
865      * @dev Safely transfers `tokenId` token from `from` to `to`.
866      *
867      * Requirements:
868      *
869      * - `from` cannot be the zero address.
870      * - `to` cannot be the zero address.
871      * - `tokenId` token must exist and be owned by `from`.
872      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
873      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
874      *
875      * Emits a {Transfer} event.
876      */
877     function safeTransferFrom(
878         address from,
879         address to,
880         uint256 tokenId,
881         bytes calldata data
882     ) external;
883 }
884 
885 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
886 
887 
888 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
889 
890 pragma solidity ^0.8.0;
891 
892 
893 /**
894  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
895  * @dev See https://eips.ethereum.org/EIPS/eip-721
896  */
897 interface IERC721Metadata is IERC721 {
898     /**
899      * @dev Returns the token collection name.
900      */
901     function name() external view returns (string memory);
902 
903     /**
904      * @dev Returns the token collection symbol.
905      */
906     function symbol() external view returns (string memory);
907 
908     /**
909      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
910      */
911     function tokenURI(uint256 tokenId) external view returns (string memory);
912 }
913 
914 // File: contracts/interfaces/IERC721Consumable.sol
915 
916 
917 pragma solidity ^0.8.0;
918 
919 
920 /// @title ERC-721 Consumer Role extension
921 ///  Note: the ERC-165 identifier for this interface is 0x953c8dfa
922 interface IERC721Consumable is IERC721 {
923     /// @notice Emitted when `owner` changes the `consumer` of an NFT
924     /// The zero address for consumer indicates that there is no consumer address
925     /// When a Transfer event emits, this also indicates that the consumer address
926     /// for that NFT (if any) is set to none
927     event ConsumerChanged(
928         address indexed owner,
929         address indexed consumer,
930         uint256 indexed tokenId
931     );
932 
933     /// @notice Get the consumer address of an NFT
934     /// @dev The zero address indicates that there is no consumer
935     /// Throws if `_tokenId` is not a valid NFT
936     /// @param _tokenId The NFT to get the consumer address for
937     /// @return The consumer address for this NFT, or the zero address if there is none
938     function consumerOf(uint256 _tokenId) external view returns (address);
939 
940     /// @notice Change or reaffirm the consumer address for an NFT
941     /// @dev The zero address indicates there is no consumer address
942     /// Throws unless `msg.sender` is the current NFT owner, an authorised
943     /// operator of the current owner or approved address
944     /// Throws if `_tokenId` is not valid NFT
945     /// @param _consumer The new consumer of the NFT
946     function changeConsumer(address _consumer, uint256 _tokenId) external;
947 }
948 
949 // File: contracts/interfaces/IParticlon.sol
950 
951 
952 
953 // Particlon.sol -- Part of the Charged Particles Protocol
954 // Copyright (c) 2021 Firma Lux, Inc. <https://charged.fi>
955 //
956 // Permission is hereby granted, free of charge, to any person obtaining a copy
957 // of this software and associated documentation files (the "Software"), to deal
958 // in the Software without restriction, including without limitation the rights
959 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
960 // copies of the Software, and to permit persons to whom the Software is
961 // furnished to do so, subject to the following conditions:
962 //
963 // The above copyright notice and this permission notice shall be included in all
964 // copies or substantial portions of the Software.
965 //
966 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
967 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
968 // FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
969 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
970 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
971 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
972 // SOFTWARE.
973 
974 pragma solidity ^0.8.0;
975 
976 // pragma experimental ABIEncoderV2;
977 
978 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
979 // import "@openzeppelin/contracts/utils/math/SafeMath.sol";
980 // import "@openzeppelin/contracts/access/Ownable.sol";
981 // import "@openzeppelin/contracts/utils/Counters.sol";
982 // import "@openzeppelin/contracts/utils/Address.sol";
983 // import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
984 
985 // import "./BlackholePrevention.sol";
986 // import "./RelayRecipient.sol";
987 
988 
989 interface IParticlon is IERC721 {
990     enum EMintPhase {
991         CLOSED,
992         CLAIM,
993         WHITELIST,
994         PUBLIC
995     }
996     /// @notice Andy was here
997     event NewBaseURI(string indexed _uri);
998     event NewSignerAddress(address indexed signer);
999     event NewMintPhase(EMintPhase indexed mintPhase);
1000     event NewMintPrice(uint256 price);
1001 
1002     event AssetTokenSet(address indexed assetToken);
1003     event ChargedStateSet(address indexed chargedState);
1004     event ChargedSettingsSet(address indexed chargedSettings);
1005     event ChargedParticlesSet(address indexed chargedParticles);
1006 
1007     event SalePriceSet(uint256 indexed tokenId, uint256 salePrice);
1008     event CreatorRoyaltiesSet(uint256 indexed tokenId, uint256 royaltiesPct);
1009     event ParticlonSold(
1010         uint256 indexed tokenId,
1011         address indexed oldOwner,
1012         address indexed newOwner,
1013         uint256 salePrice,
1014         address creator,
1015         uint256 creatorRoyalties
1016     );
1017     event RoyaltiesClaimed(address indexed receiver, uint256 amountClaimed);
1018 
1019     /***********************************|
1020     |              Public               |
1021     |__________________________________*/
1022 
1023     function creatorOf(uint256 tokenId) external view returns (address);
1024 
1025     function getSalePrice(uint256 tokenId) external view returns (uint256);
1026 
1027     function getLastSellPrice(uint256 tokenId) external view returns (uint256);
1028 
1029     function getCreatorRoyalties(address account)
1030         external
1031         view
1032         returns (uint256);
1033 
1034     function getCreatorRoyaltiesPct(uint256 tokenId)
1035         external
1036         view
1037         returns (uint256);
1038 
1039     function getCreatorRoyaltiesReceiver(uint256 tokenId)
1040         external
1041         view
1042         returns (address);
1043 
1044     function buyParticlon(uint256 tokenId, uint256 gasLimit)
1045         external
1046         payable
1047         returns (bool);
1048 
1049     function claimCreatorRoyalties() external returns (uint256);
1050 
1051     // function createParticlonForSale(
1052     //     address creator,
1053     //     address receiver,
1054     //     // string memory tokenMetaUri,
1055     //     uint256 royaltiesPercent,
1056     //     uint256 salePrice
1057     // ) external returns (uint256 newTokenId);
1058 
1059     function mint(uint256 amount) external payable returns (bool);
1060 
1061     function mintWhitelist(
1062         uint256 amountMint,
1063         uint256 amountAllowed,
1064         uint256 nonce,
1065         bytes calldata signature
1066     ) external payable returns (bool);
1067 
1068     function mintFree(
1069         uint256 amountMint,
1070         uint256 amountAllowed,
1071         uint256 nonce,
1072         bytes calldata signature
1073     ) external returns (bool);
1074 
1075     // function batchParticlonsForSale(
1076     //     address creator,
1077     //     uint256 annuityPercent,
1078     //     uint256 royaltiesPercent,
1079     //     uint256[] calldata salePrices
1080     // ) external;
1081 
1082     // function createParticlonsForSale(
1083     //     address creator,
1084     //     address receiver,
1085     //     uint256 royaltiesPercent,
1086     //     // string[] calldata tokenMetaUris,
1087     //     uint256[] calldata salePrices
1088     // ) external returns (bool);
1089 
1090     // Andy was here
1091 
1092     /***********************************|
1093     |     Only Token Creator/Owner      |
1094     |__________________________________*/
1095 
1096     function setSalePrice(uint256 tokenId, uint256 salePrice) external;
1097 
1098     function setRoyaltiesPct(uint256 tokenId, uint256 royaltiesPct) external;
1099 
1100     function setCreatorRoyaltiesReceiver(uint256 tokenId, address receiver)
1101         external;
1102 }
1103 
1104 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1105 
1106 
1107 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1108 
1109 pragma solidity ^0.8.0;
1110 
1111 /**
1112  * @dev Contract module that helps prevent reentrant calls to a function.
1113  *
1114  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1115  * available, which can be applied to functions to make sure there are no nested
1116  * (reentrant) calls to them.
1117  *
1118  * Note that because there is a single `nonReentrant` guard, functions marked as
1119  * `nonReentrant` may not call one another. This can be worked around by making
1120  * those functions `private`, and then adding `external` `nonReentrant` entry
1121  * points to them.
1122  *
1123  * TIP: If you would like to learn more about reentrancy and alternative ways
1124  * to protect against it, check out our blog post
1125  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1126  */
1127 abstract contract ReentrancyGuard {
1128     // Booleans are more expensive than uint256 or any type that takes up a full
1129     // word because each write operation emits an extra SLOAD to first read the
1130     // slot's contents, replace the bits taken up by the boolean, and then write
1131     // back. This is the compiler's defense against contract upgrades and
1132     // pointer aliasing, and it cannot be disabled.
1133 
1134     // The values being non-zero value makes deployment a bit more expensive,
1135     // but in exchange the refund on every call to nonReentrant will be lower in
1136     // amount. Since refunds are capped to a percentage of the total
1137     // transaction's gas, it is best to keep them low in cases like this one, to
1138     // increase the likelihood of the full refund coming into effect.
1139     uint256 private constant _NOT_ENTERED = 1;
1140     uint256 private constant _ENTERED = 2;
1141 
1142     uint256 private _status;
1143 
1144     constructor() {
1145         _status = _NOT_ENTERED;
1146     }
1147 
1148     /**
1149      * @dev Prevents a contract from calling itself, directly or indirectly.
1150      * Calling a `nonReentrant` function from another `nonReentrant`
1151      * function is not supported. It is possible to prevent this from happening
1152      * by making the `nonReentrant` function external, and making it call a
1153      * `private` function that does the actual work.
1154      */
1155     modifier nonReentrant() {
1156         // On the first call to nonReentrant, _notEntered will be true
1157         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1158 
1159         // Any calls to nonReentrant after this point will fail
1160         _status = _ENTERED;
1161 
1162         _;
1163 
1164         // By storing the original value once again, a refund is triggered (see
1165         // https://eips.ethereum.org/EIPS/eip-2200)
1166         _status = _NOT_ENTERED;
1167     }
1168 }
1169 
1170 // File: @openzeppelin/contracts/utils/Strings.sol
1171 
1172 
1173 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1174 
1175 pragma solidity ^0.8.0;
1176 
1177 /**
1178  * @dev String operations.
1179  */
1180 library Strings {
1181     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1182 
1183     /**
1184      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1185      */
1186     function toString(uint256 value) internal pure returns (string memory) {
1187         // Inspired by OraclizeAPI's implementation - MIT licence
1188         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1189 
1190         if (value == 0) {
1191             return "0";
1192         }
1193         uint256 temp = value;
1194         uint256 digits;
1195         while (temp != 0) {
1196             digits++;
1197             temp /= 10;
1198         }
1199         bytes memory buffer = new bytes(digits);
1200         while (value != 0) {
1201             digits -= 1;
1202             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1203             value /= 10;
1204         }
1205         return string(buffer);
1206     }
1207 
1208     /**
1209      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1210      */
1211     function toHexString(uint256 value) internal pure returns (string memory) {
1212         if (value == 0) {
1213             return "0x00";
1214         }
1215         uint256 temp = value;
1216         uint256 length = 0;
1217         while (temp != 0) {
1218             length++;
1219             temp >>= 8;
1220         }
1221         return toHexString(value, length);
1222     }
1223 
1224     /**
1225      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1226      */
1227     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1228         bytes memory buffer = new bytes(2 * length + 2);
1229         buffer[0] = "0";
1230         buffer[1] = "x";
1231         for (uint256 i = 2 * length + 1; i > 1; --i) {
1232             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1233             value >>= 4;
1234         }
1235         require(value == 0, "Strings: hex length insufficient");
1236         return string(buffer);
1237     }
1238 }
1239 
1240 // File: @openzeppelin/contracts/utils/Address.sol
1241 
1242 
1243 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1244 
1245 pragma solidity ^0.8.1;
1246 
1247 /**
1248  * @dev Collection of functions related to the address type
1249  */
1250 library Address {
1251     /**
1252      * @dev Returns true if `account` is a contract.
1253      *
1254      * [IMPORTANT]
1255      * ====
1256      * It is unsafe to assume that an address for which this function returns
1257      * false is an externally-owned account (EOA) and not a contract.
1258      *
1259      * Among others, `isContract` will return false for the following
1260      * types of addresses:
1261      *
1262      *  - an externally-owned account
1263      *  - a contract in construction
1264      *  - an address where a contract will be created
1265      *  - an address where a contract lived, but was destroyed
1266      * ====
1267      *
1268      * [IMPORTANT]
1269      * ====
1270      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1271      *
1272      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1273      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1274      * constructor.
1275      * ====
1276      */
1277     function isContract(address account) internal view returns (bool) {
1278         // This method relies on extcodesize/address.code.length, which returns 0
1279         // for contracts in construction, since the code is only stored at the end
1280         // of the constructor execution.
1281 
1282         return account.code.length > 0;
1283     }
1284 
1285     /**
1286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1287      * `recipient`, forwarding all available gas and reverting on errors.
1288      *
1289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1291      * imposed by `transfer`, making them unable to receive funds via
1292      * `transfer`. {sendValue} removes this limitation.
1293      *
1294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1295      *
1296      * IMPORTANT: because control is transferred to `recipient`, care must be
1297      * taken to not create reentrancy vulnerabilities. Consider using
1298      * {ReentrancyGuard} or the
1299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1300      */
1301     function sendValue(address payable recipient, uint256 amount) internal {
1302         require(address(this).balance >= amount, "Address: insufficient balance");
1303 
1304         (bool success, ) = recipient.call{value: amount}("");
1305         require(success, "Address: unable to send value, recipient may have reverted");
1306     }
1307 
1308     /**
1309      * @dev Performs a Solidity function call using a low level `call`. A
1310      * plain `call` is an unsafe replacement for a function call: use this
1311      * function instead.
1312      *
1313      * If `target` reverts with a revert reason, it is bubbled up by this
1314      * function (like regular Solidity function calls).
1315      *
1316      * Returns the raw returned data. To convert to the expected return value,
1317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1318      *
1319      * Requirements:
1320      *
1321      * - `target` must be a contract.
1322      * - calling `target` with `data` must not revert.
1323      *
1324      * _Available since v3.1._
1325      */
1326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1327         return functionCall(target, data, "Address: low-level call failed");
1328     }
1329 
1330     /**
1331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1332      * `errorMessage` as a fallback revert reason when `target` reverts.
1333      *
1334      * _Available since v3.1._
1335      */
1336     function functionCall(
1337         address target,
1338         bytes memory data,
1339         string memory errorMessage
1340     ) internal returns (bytes memory) {
1341         return functionCallWithValue(target, data, 0, errorMessage);
1342     }
1343 
1344     /**
1345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1346      * but also transferring `value` wei to `target`.
1347      *
1348      * Requirements:
1349      *
1350      * - the calling contract must have an ETH balance of at least `value`.
1351      * - the called Solidity function must be `payable`.
1352      *
1353      * _Available since v3.1._
1354      */
1355     function functionCallWithValue(
1356         address target,
1357         bytes memory data,
1358         uint256 value
1359     ) internal returns (bytes memory) {
1360         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1361     }
1362 
1363     /**
1364      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1365      * with `errorMessage` as a fallback revert reason when `target` reverts.
1366      *
1367      * _Available since v3.1._
1368      */
1369     function functionCallWithValue(
1370         address target,
1371         bytes memory data,
1372         uint256 value,
1373         string memory errorMessage
1374     ) internal returns (bytes memory) {
1375         require(address(this).balance >= value, "Address: insufficient balance for call");
1376         require(isContract(target), "Address: call to non-contract");
1377 
1378         (bool success, bytes memory returndata) = target.call{value: value}(data);
1379         return verifyCallResult(success, returndata, errorMessage);
1380     }
1381 
1382     /**
1383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1384      * but performing a static call.
1385      *
1386      * _Available since v3.3._
1387      */
1388     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1389         return functionStaticCall(target, data, "Address: low-level static call failed");
1390     }
1391 
1392     /**
1393      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1394      * but performing a static call.
1395      *
1396      * _Available since v3.3._
1397      */
1398     function functionStaticCall(
1399         address target,
1400         bytes memory data,
1401         string memory errorMessage
1402     ) internal view returns (bytes memory) {
1403         require(isContract(target), "Address: static call to non-contract");
1404 
1405         (bool success, bytes memory returndata) = target.staticcall(data);
1406         return verifyCallResult(success, returndata, errorMessage);
1407     }
1408 
1409     /**
1410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1411      * but performing a delegate call.
1412      *
1413      * _Available since v3.4._
1414      */
1415     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1416         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1417     }
1418 
1419     /**
1420      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1421      * but performing a delegate call.
1422      *
1423      * _Available since v3.4._
1424      */
1425     function functionDelegateCall(
1426         address target,
1427         bytes memory data,
1428         string memory errorMessage
1429     ) internal returns (bytes memory) {
1430         require(isContract(target), "Address: delegate call to non-contract");
1431 
1432         (bool success, bytes memory returndata) = target.delegatecall(data);
1433         return verifyCallResult(success, returndata, errorMessage);
1434     }
1435 
1436     /**
1437      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1438      * revert reason using the provided one.
1439      *
1440      * _Available since v4.3._
1441      */
1442     function verifyCallResult(
1443         bool success,
1444         bytes memory returndata,
1445         string memory errorMessage
1446     ) internal pure returns (bytes memory) {
1447         if (success) {
1448             return returndata;
1449         } else {
1450             // Look for revert reason and bubble it up if present
1451             if (returndata.length > 0) {
1452                 // The easiest way to bubble the revert reason is using memory via assembly
1453 
1454                 assembly {
1455                     let returndata_size := mload(returndata)
1456                     revert(add(32, returndata), returndata_size)
1457                 }
1458             } else {
1459                 revert(errorMessage);
1460             }
1461         }
1462     }
1463 }
1464 
1465 // File: @openzeppelin/contracts/utils/Context.sol
1466 
1467 
1468 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1469 
1470 pragma solidity ^0.8.0;
1471 
1472 /**
1473  * @dev Provides information about the current execution context, including the
1474  * sender of the transaction and its data. While these are generally available
1475  * via msg.sender and msg.data, they should not be accessed in such a direct
1476  * manner, since when dealing with meta-transactions the account sending and
1477  * paying for execution may not be the actual sender (as far as an application
1478  * is concerned).
1479  *
1480  * This contract is only required for intermediate, library-like contracts.
1481  */
1482 abstract contract Context {
1483     function _msgSender() internal view virtual returns (address) {
1484         return msg.sender;
1485     }
1486 
1487     function _msgData() internal view virtual returns (bytes calldata) {
1488         return msg.data;
1489     }
1490 }
1491 
1492 // File: contracts/lib/ERC721A.sol
1493 
1494 
1495 // Creator: Chiru Labs
1496 
1497 pragma solidity ^0.8.4;
1498 
1499 
1500 
1501 
1502 
1503 
1504 
1505 
1506 error ApprovalCallerNotOwnerNorApproved();
1507 error ApprovalQueryForNonexistentToken();
1508 error ApproveToCaller();
1509 error ApprovalToCurrentOwner();
1510 error BalanceQueryForZeroAddress();
1511 error MintToZeroAddress();
1512 error MintZeroQuantity();
1513 error OwnerQueryForNonexistentToken();
1514 error TransferCallerNotOwnerNorApproved();
1515 error TransferFromIncorrectOwner();
1516 error TransferToNonERC721ReceiverImplementer();
1517 error TransferToZeroAddress();
1518 error URIQueryForNonexistentToken();
1519 
1520 /**
1521  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1522  * the Metadata extension. Built to optimize for lower gas during batch mints.
1523  *
1524  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1525  *
1526  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1527  *
1528  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1529  */
1530 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1531     using Address for address;
1532     using Strings for uint256;
1533 
1534     // Compiler will pack this into a single 256bit word.
1535     struct TokenOwnership {
1536         // The address of the owner.
1537         address addr;
1538         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1539         uint64 startTimestamp;
1540         // Whether the token has been burned.
1541         bool burned;
1542     }
1543 
1544     // Compiler will pack this into a single 256bit word.
1545     struct AddressData {
1546         // Realistically, 2**64-1 is more than enough.
1547         uint64 balance;
1548         // Keeps track of mint count with minimal overhead for tokenomics.
1549         uint64 numberMinted;
1550         // Keeps track of burn count with minimal overhead for tokenomics.
1551         uint64 numberBurned;
1552         // For miscellaneous variable(s) pertaining to the address
1553         // (e.g. number of whitelist mint slots used).
1554         // If there are multiple variables, please pack them into a uint64.
1555         uint64 aux;
1556     }
1557 
1558     // The tokenId of the next token to be minted.
1559     uint256 internal _currentIndex;
1560 
1561     // The number of tokens burned.
1562     uint256 internal _burnCounter;
1563 
1564     // Token name
1565     string private _name;
1566 
1567     // Token symbol
1568     string private _symbol;
1569 
1570     // Mapping from token ID to ownership details
1571     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1572     mapping(uint256 => TokenOwnership) internal _ownerships;
1573 
1574     // Mapping owner address to address data
1575     mapping(address => AddressData) private _addressData;
1576 
1577     // Mapping from token ID to approved address
1578     mapping(uint256 => address) private _tokenApprovals;
1579 
1580     // Mapping from owner to operator approvals
1581     mapping(address => mapping(address => bool)) private _operatorApprovals;
1582 
1583     constructor(string memory name_, string memory symbol_) {
1584         _name = name_;
1585         _symbol = symbol_;
1586         _currentIndex = _startTokenId();
1587     }
1588 
1589     /**
1590      * To change the starting tokenId, please override this function.
1591      */
1592     function _startTokenId() internal view virtual returns (uint256) {
1593         return 1;
1594     }
1595 
1596     /**
1597      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1598      */
1599     function totalSupply() public view returns (uint256) {
1600         // Counter underflow is impossible as _burnCounter cannot be incremented
1601         // more than _currentIndex - _startTokenId() times
1602         unchecked {
1603             return _currentIndex - _burnCounter - _startTokenId();
1604         }
1605     }
1606 
1607     /**
1608      * Returns the total amount of tokens minted in the contract.
1609      */
1610     function _totalMinted() internal view returns (uint256) {
1611         // Counter underflow is impossible as _currentIndex does not decrement,
1612         // and it is initialized to _startTokenId()
1613         unchecked {
1614             return _currentIndex - _startTokenId();
1615         }
1616     }
1617 
1618     /**
1619      * @dev See {IERC165-supportsInterface}.
1620      */
1621     function supportsInterface(bytes4 interfaceId)
1622         public
1623         view
1624         virtual
1625         override(ERC165, IERC165)
1626         returns (bool)
1627     {
1628         return
1629             interfaceId == type(IERC721).interfaceId ||
1630             interfaceId == type(IERC721Metadata).interfaceId ||
1631             super.supportsInterface(interfaceId);
1632     }
1633 
1634     /**
1635      * @dev See {IERC721-balanceOf}.
1636      */
1637     function balanceOf(address owner) public view override returns (uint256) {
1638         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1639         return uint256(_addressData[owner].balance);
1640     }
1641 
1642     /**
1643      * Returns the number of tokens minted by `owner`.
1644      */
1645     function _numberMinted(address owner) internal view returns (uint256) {
1646         return uint256(_addressData[owner].numberMinted);
1647     }
1648 
1649     /**
1650      * Returns the number of tokens burned by or on behalf of `owner`.
1651      */
1652     function _numberBurned(address owner) internal view returns (uint256) {
1653         return uint256(_addressData[owner].numberBurned);
1654     }
1655 
1656     /**
1657      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1658      */
1659     function _getAux(address owner) internal view returns (uint64) {
1660         return _addressData[owner].aux;
1661     }
1662 
1663     /**
1664      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1665      * If there are multiple variables, please pack them into a uint64.
1666      */
1667     function _setAux(address owner, uint64 aux) internal {
1668         _addressData[owner].aux = aux;
1669     }
1670 
1671     /**
1672      * Gas spent here starts off proportional to the maximum mint batch size.
1673      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1674      */
1675     function _ownershipOf(uint256 tokenId)
1676         internal
1677         view
1678         returns (TokenOwnership memory)
1679     {
1680         uint256 curr = tokenId;
1681 
1682         unchecked {
1683             if (_startTokenId() <= curr && curr < _currentIndex) {
1684                 TokenOwnership memory ownership = _ownerships[curr];
1685                 if (!ownership.burned) {
1686                     if (ownership.addr != address(0)) {
1687                         return ownership;
1688                     }
1689                     // Invariant:
1690                     // There will always be an ownership that has an address and is not burned
1691                     // before an ownership that does not have an address and is not burned.
1692                     // Hence, curr will not underflow.
1693                     while (true) {
1694                         curr--;
1695                         ownership = _ownerships[curr];
1696                         if (ownership.addr != address(0)) {
1697                             return ownership;
1698                         }
1699                     }
1700                 }
1701             }
1702         }
1703         revert OwnerQueryForNonexistentToken();
1704     }
1705 
1706     /**
1707      * @dev See {IERC721-ownerOf}.
1708      */
1709     function ownerOf(uint256 tokenId) public view override returns (address) {
1710         return _ownershipOf(tokenId).addr;
1711     }
1712 
1713     /**
1714      * @dev See {IERC721Metadata-name}.
1715      */
1716     function name() public view virtual override returns (string memory) {
1717         return _name;
1718     }
1719 
1720     /**
1721      * @dev See {IERC721Metadata-symbol}.
1722      */
1723     function symbol() public view virtual override returns (string memory) {
1724         return _symbol;
1725     }
1726 
1727     /**
1728      * @dev See {IERC721Metadata-tokenURI}.
1729      */
1730     function tokenURI(uint256 tokenId)
1731         public
1732         view
1733         virtual
1734         override
1735         returns (string memory)
1736     {
1737         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1738 
1739         string memory baseURI = _baseURI();
1740         return
1741             bytes(baseURI).length != 0
1742                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1743                 : "";
1744     }
1745 
1746     /**
1747      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1748      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1749      * by default, can be overriden in child contracts.
1750      */
1751     function _baseURI() internal view virtual returns (string memory) {
1752         return "";
1753     }
1754 
1755     /**
1756      * @dev See {IERC721-approve}.
1757      */
1758     function approve(address to, uint256 tokenId) public override {
1759         address owner = ERC721A.ownerOf(tokenId);
1760         if (to == owner) revert ApprovalToCurrentOwner();
1761 
1762         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1763             revert ApprovalCallerNotOwnerNorApproved();
1764         }
1765 
1766         _approve(to, tokenId, owner);
1767     }
1768 
1769     /**
1770      * @dev See {IERC721-getApproved}.
1771      */
1772     function getApproved(uint256 tokenId)
1773         public
1774         view
1775         override
1776         returns (address)
1777     {
1778         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1779 
1780         return _tokenApprovals[tokenId];
1781     }
1782 
1783     /**
1784      * @dev See {IERC721-setApprovalForAll}.
1785      */
1786     function setApprovalForAll(address operator, bool approved)
1787         public
1788         virtual
1789         override
1790     {
1791         if (operator == _msgSender()) revert ApproveToCaller();
1792 
1793         _operatorApprovals[_msgSender()][operator] = approved;
1794         emit ApprovalForAll(_msgSender(), operator, approved);
1795     }
1796 
1797     /**
1798      * @dev See {IERC721-isApprovedForAll}.
1799      */
1800     function isApprovedForAll(address owner, address operator)
1801         public
1802         view
1803         virtual
1804         override
1805         returns (bool)
1806     {
1807         return _operatorApprovals[owner][operator];
1808     }
1809 
1810     /**
1811      * @dev See {IERC721-transferFrom}.
1812      */
1813     function transferFrom(
1814         address from,
1815         address to,
1816         uint256 tokenId
1817     ) public virtual override {
1818         _transfer(from, to, tokenId);
1819     }
1820 
1821     /**
1822      * @dev See {IERC721-safeTransferFrom}.
1823      */
1824     function safeTransferFrom(
1825         address from,
1826         address to,
1827         uint256 tokenId
1828     ) public virtual override {
1829         safeTransferFrom(from, to, tokenId, "");
1830     }
1831 
1832     /**
1833      * @dev See {IERC721-safeTransferFrom}.
1834      */
1835     function safeTransferFrom(
1836         address from,
1837         address to,
1838         uint256 tokenId,
1839         bytes memory _data
1840     ) public virtual override {
1841         _transfer(from, to, tokenId);
1842         if (
1843             to.isContract() &&
1844             !_checkContractOnERC721Received(from, to, tokenId, _data)
1845         ) {
1846             revert TransferToNonERC721ReceiverImplementer();
1847         }
1848     }
1849 
1850     /**
1851      * @dev Returns whether `tokenId` exists.
1852      *
1853      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1854      *
1855      * Tokens start existing when they are minted (`_mint`),
1856      */
1857     function _exists(uint256 tokenId) internal view returns (bool) {
1858         return
1859             _startTokenId() <= tokenId &&
1860             tokenId < _currentIndex &&
1861             !_ownerships[tokenId].burned;
1862     }
1863 
1864     function _safeMint(address to, uint256 quantity) internal {
1865         _safeMint(to, quantity, "");
1866     }
1867 
1868     /**
1869      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1870      *
1871      * Requirements:
1872      *
1873      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1874      * - `quantity` must be greater than 0.
1875      *
1876      * Emits a {Transfer} event.
1877      */
1878     function _safeMint(
1879         address to,
1880         uint256 quantity,
1881         bytes memory _data
1882     ) internal {
1883         _mint(to, quantity, _data, true);
1884     }
1885 
1886     /**
1887      * @dev Mints `quantity` tokens and transfers them to `to`.
1888      *
1889      * Requirements:
1890      *
1891      * - `to` cannot be the zero address.
1892      * - `quantity` must be greater than 0.
1893      *
1894      * Emits a {Transfer} event.
1895      */
1896     function _mint(
1897         address to,
1898         uint256 quantity,
1899         bytes memory _data,
1900         bool safe
1901     ) internal {
1902         uint256 startTokenId = _currentIndex;
1903         if (to == address(0)) revert MintToZeroAddress();
1904         if (quantity == 0) revert MintZeroQuantity();
1905 
1906         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1907 
1908         // Overflows are incredibly unrealistic.
1909         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1910         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1911         unchecked {
1912             _addressData[to].balance += uint64(quantity);
1913             _addressData[to].numberMinted += uint64(quantity);
1914 
1915             _ownerships[startTokenId].addr = to;
1916             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1917 
1918             uint256 updatedIndex = startTokenId;
1919             uint256 end = updatedIndex + quantity;
1920 
1921             if (safe && to.isContract()) {
1922                 do {
1923                     emit Transfer(address(0), to, updatedIndex);
1924                     if (
1925                         !_checkContractOnERC721Received(
1926                             address(0),
1927                             to,
1928                             updatedIndex++,
1929                             _data
1930                         )
1931                     ) {
1932                         revert TransferToNonERC721ReceiverImplementer();
1933                     }
1934                 } while (updatedIndex != end);
1935                 // Reentrancy protection
1936                 if (_currentIndex != startTokenId) revert();
1937             } else {
1938                 do {
1939                     emit Transfer(address(0), to, updatedIndex++);
1940                 } while (updatedIndex != end);
1941             }
1942             _currentIndex = updatedIndex;
1943         }
1944         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1945     }
1946 
1947     /**
1948      * @dev Transfers `tokenId` from `from` to `to`.
1949      *
1950      * Requirements:
1951      *
1952      * - `to` cannot be the zero address.
1953      * - `tokenId` token must be owned by `from`.
1954      *
1955      * Emits a {Transfer} event.
1956      */
1957     function _transfer(
1958         address from,
1959         address to,
1960         uint256 tokenId
1961     ) internal virtual {
1962         /// @dev Andy was here, made it internal virtual to work with Charged Particles
1963         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1964 
1965         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1966 
1967         bool isApprovedOrOwner = (_msgSender() == from ||
1968             isApprovedForAll(from, _msgSender()) ||
1969             getApproved(tokenId) == _msgSender());
1970 
1971         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1972         if (to == address(0)) revert TransferToZeroAddress();
1973 
1974         _beforeTokenTransfers(from, to, tokenId, 1);
1975 
1976         // Clear approvals from the previous owner
1977         _approve(address(0), tokenId, from);
1978 
1979         // Underflow of the sender's balance is impossible because we check for
1980         // ownership above and the recipient's balance can't realistically overflow.
1981         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1982         unchecked {
1983             _addressData[from].balance -= 1;
1984             _addressData[to].balance += 1;
1985 
1986             TokenOwnership storage currSlot = _ownerships[tokenId];
1987             currSlot.addr = to;
1988             currSlot.startTimestamp = uint64(block.timestamp);
1989 
1990             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1991             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1992             uint256 nextTokenId = tokenId + 1;
1993             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1994             if (nextSlot.addr == address(0)) {
1995                 // This will suffice for checking _exists(nextTokenId),
1996                 // as a burned slot cannot contain the zero address.
1997                 if (nextTokenId != _currentIndex) {
1998                     nextSlot.addr = from;
1999                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2000                 }
2001             }
2002         }
2003 
2004         emit Transfer(from, to, tokenId);
2005         _afterTokenTransfers(from, to, tokenId, 1);
2006     }
2007 
2008     /**
2009      * @dev This is equivalent to _burn(tokenId, false)
2010      */
2011     function _burn(uint256 tokenId) internal virtual {
2012         _burn(tokenId, false);
2013     }
2014 
2015     /**
2016      * @dev Destroys `tokenId`.
2017      * The approval is cleared when the token is burned.
2018      *
2019      * Requirements:
2020      *
2021      * - `tokenId` must exist.
2022      *
2023      * Emits a {Transfer} event.
2024      */
2025     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2026         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2027 
2028         address from = prevOwnership.addr;
2029 
2030         if (approvalCheck) {
2031             bool isApprovedOrOwner = (_msgSender() == from ||
2032                 isApprovedForAll(from, _msgSender()) ||
2033                 getApproved(tokenId) == _msgSender());
2034 
2035             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2036         }
2037 
2038         _beforeTokenTransfers(from, address(0), tokenId, 1);
2039 
2040         // Clear approvals from the previous owner
2041         _approve(address(0), tokenId, from);
2042 
2043         // Underflow of the sender's balance is impossible because we check for
2044         // ownership above and the recipient's balance can't realistically overflow.
2045         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2046         unchecked {
2047             AddressData storage addressData = _addressData[from];
2048             addressData.balance -= 1;
2049             addressData.numberBurned += 1;
2050 
2051             // Keep track of who burned the token, and the timestamp of burning.
2052             TokenOwnership storage currSlot = _ownerships[tokenId];
2053             currSlot.addr = from;
2054             currSlot.startTimestamp = uint64(block.timestamp);
2055             currSlot.burned = true;
2056 
2057             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
2058             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2059             uint256 nextTokenId = tokenId + 1;
2060             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2061             if (nextSlot.addr == address(0)) {
2062                 // This will suffice for checking _exists(nextTokenId),
2063                 // as a burned slot cannot contain the zero address.
2064                 if (nextTokenId != _currentIndex) {
2065                     nextSlot.addr = from;
2066                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2067                 }
2068             }
2069         }
2070 
2071         emit Transfer(from, address(0), tokenId);
2072         _afterTokenTransfers(from, address(0), tokenId, 1);
2073 
2074         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2075         unchecked {
2076             _burnCounter++;
2077         }
2078     }
2079 
2080     /**
2081      * @dev Approve `to` to operate on `tokenId`
2082      *
2083      * Emits a {Approval} event.
2084      */
2085     function _approve(
2086         address to,
2087         uint256 tokenId,
2088         address owner
2089     ) private {
2090         _tokenApprovals[tokenId] = to;
2091         emit Approval(owner, to, tokenId);
2092     }
2093 
2094     /**
2095      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2096      *
2097      * @param from address representing the previous owner of the given token ID
2098      * @param to target address that will receive the tokens
2099      * @param tokenId uint256 ID of the token to be transferred
2100      * @param _data bytes optional data to send along with the call
2101      * @return bool whether the call correctly returned the expected magic value
2102      */
2103     function _checkContractOnERC721Received(
2104         address from,
2105         address to,
2106         uint256 tokenId,
2107         bytes memory _data
2108     ) private returns (bool) {
2109         try
2110             IERC721Receiver(to).onERC721Received(
2111                 _msgSender(),
2112                 from,
2113                 tokenId,
2114                 _data
2115             )
2116         returns (bytes4 retval) {
2117             return retval == IERC721Receiver(to).onERC721Received.selector;
2118         } catch (bytes memory reason) {
2119             if (reason.length == 0) {
2120                 revert TransferToNonERC721ReceiverImplementer();
2121             } else {
2122                 assembly {
2123                     revert(add(32, reason), mload(reason))
2124                 }
2125             }
2126         }
2127     }
2128 
2129     /**
2130      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2131      * And also called before burning one token.
2132      *
2133      * startTokenId - the first token id to be transferred
2134      * quantity - the amount to be transferred
2135      *
2136      * Calling conditions:
2137      *
2138      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2139      * transferred to `to`.
2140      * - When `from` is zero, `tokenId` will be minted for `to`.
2141      * - When `to` is zero, `tokenId` will be burned by `from`.
2142      * - `from` and `to` are never both zero.
2143      */
2144     function _beforeTokenTransfers(
2145         address from,
2146         address to,
2147         uint256 startTokenId,
2148         uint256 quantity
2149     ) internal virtual {}
2150 
2151     /**
2152      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2153      * minting.
2154      * And also called after one token has been burned.
2155      *
2156      * startTokenId - the first token id to be transferred
2157      * quantity - the amount to be transferred
2158      *
2159      * Calling conditions:
2160      *
2161      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2162      * transferred to `to`.
2163      * - When `from` is zero, `tokenId` has been minted for `to`.
2164      * - When `to` is zero, `tokenId` has been burned by `from`.
2165      * - `from` and `to` are never both zero.
2166      */
2167     function _afterTokenTransfers(
2168         address from,
2169         address to,
2170         uint256 startTokenId,
2171         uint256 quantity
2172     ) internal virtual {}
2173 }
2174 
2175 // File: @openzeppelin/contracts/security/Pausable.sol
2176 
2177 
2178 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
2179 
2180 pragma solidity ^0.8.0;
2181 
2182 
2183 /**
2184  * @dev Contract module which allows children to implement an emergency stop
2185  * mechanism that can be triggered by an authorized account.
2186  *
2187  * This module is used through inheritance. It will make available the
2188  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
2189  * the functions of your contract. Note that they will not be pausable by
2190  * simply including this module, only once the modifiers are put in place.
2191  */
2192 abstract contract Pausable is Context {
2193     /**
2194      * @dev Emitted when the pause is triggered by `account`.
2195      */
2196     event Paused(address account);
2197 
2198     /**
2199      * @dev Emitted when the pause is lifted by `account`.
2200      */
2201     event Unpaused(address account);
2202 
2203     bool private _paused;
2204 
2205     /**
2206      * @dev Initializes the contract in unpaused state.
2207      */
2208     constructor() {
2209         _paused = false;
2210     }
2211 
2212     /**
2213      * @dev Returns true if the contract is paused, and false otherwise.
2214      */
2215     function paused() public view virtual returns (bool) {
2216         return _paused;
2217     }
2218 
2219     /**
2220      * @dev Modifier to make a function callable only when the contract is not paused.
2221      *
2222      * Requirements:
2223      *
2224      * - The contract must not be paused.
2225      */
2226     modifier whenNotPaused() {
2227         require(!paused(), "Pausable: paused");
2228         _;
2229     }
2230 
2231     /**
2232      * @dev Modifier to make a function callable only when the contract is paused.
2233      *
2234      * Requirements:
2235      *
2236      * - The contract must be paused.
2237      */
2238     modifier whenPaused() {
2239         require(paused(), "Pausable: not paused");
2240         _;
2241     }
2242 
2243     /**
2244      * @dev Triggers stopped state.
2245      *
2246      * Requirements:
2247      *
2248      * - The contract must not be paused.
2249      */
2250     function _pause() internal virtual whenNotPaused {
2251         _paused = true;
2252         emit Paused(_msgSender());
2253     }
2254 
2255     /**
2256      * @dev Returns to normal state.
2257      *
2258      * Requirements:
2259      *
2260      * - The contract must be paused.
2261      */
2262     function _unpause() internal virtual whenPaused {
2263         _paused = false;
2264         emit Unpaused(_msgSender());
2265     }
2266 }
2267 
2268 // File: @openzeppelin/contracts/access/Ownable.sol
2269 
2270 
2271 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
2272 
2273 pragma solidity ^0.8.0;
2274 
2275 
2276 /**
2277  * @dev Contract module which provides a basic access control mechanism, where
2278  * there is an account (an owner) that can be granted exclusive access to
2279  * specific functions.
2280  *
2281  * By default, the owner account will be the one that deploys the contract. This
2282  * can later be changed with {transferOwnership}.
2283  *
2284  * This module is used through inheritance. It will make available the modifier
2285  * `onlyOwner`, which can be applied to your functions to restrict their use to
2286  * the owner.
2287  */
2288 abstract contract Ownable is Context {
2289     address private _owner;
2290 
2291     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2292 
2293     /**
2294      * @dev Initializes the contract setting the deployer as the initial owner.
2295      */
2296     constructor() {
2297         _transferOwnership(_msgSender());
2298     }
2299 
2300     /**
2301      * @dev Returns the address of the current owner.
2302      */
2303     function owner() public view virtual returns (address) {
2304         return _owner;
2305     }
2306 
2307     /**
2308      * @dev Throws if called by any account other than the owner.
2309      */
2310     modifier onlyOwner() {
2311         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2312         _;
2313     }
2314 
2315     /**
2316      * @dev Leaves the contract without owner. It will not be possible to call
2317      * `onlyOwner` functions anymore. Can only be called by the current owner.
2318      *
2319      * NOTE: Renouncing ownership will leave the contract without an owner,
2320      * thereby removing any functionality that is only available to the owner.
2321      */
2322     function renounceOwnership() public virtual onlyOwner {
2323         _transferOwnership(address(0));
2324     }
2325 
2326     /**
2327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2328      * Can only be called by the current owner.
2329      */
2330     function transferOwnership(address newOwner) public virtual onlyOwner {
2331         require(newOwner != address(0), "Ownable: new owner is the zero address");
2332         _transferOwnership(newOwner);
2333     }
2334 
2335     /**
2336      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2337      * Internal function without access restriction.
2338      */
2339     function _transferOwnership(address newOwner) internal virtual {
2340         address oldOwner = _owner;
2341         _owner = newOwner;
2342         emit OwnershipTransferred(oldOwner, newOwner);
2343     }
2344 }
2345 
2346 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2347 
2348 
2349 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
2350 
2351 pragma solidity ^0.8.0;
2352 
2353 /**
2354  * @dev Interface of the ERC20 standard as defined in the EIP.
2355  */
2356 interface IERC20 {
2357     /**
2358      * @dev Returns the amount of tokens in existence.
2359      */
2360     function totalSupply() external view returns (uint256);
2361 
2362     /**
2363      * @dev Returns the amount of tokens owned by `account`.
2364      */
2365     function balanceOf(address account) external view returns (uint256);
2366 
2367     /**
2368      * @dev Moves `amount` tokens from the caller's account to `to`.
2369      *
2370      * Returns a boolean value indicating whether the operation succeeded.
2371      *
2372      * Emits a {Transfer} event.
2373      */
2374     function transfer(address to, uint256 amount) external returns (bool);
2375 
2376     /**
2377      * @dev Returns the remaining number of tokens that `spender` will be
2378      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2379      * zero by default.
2380      *
2381      * This value changes when {approve} or {transferFrom} are called.
2382      */
2383     function allowance(address owner, address spender) external view returns (uint256);
2384 
2385     /**
2386      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2387      *
2388      * Returns a boolean value indicating whether the operation succeeded.
2389      *
2390      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2391      * that someone may use both the old and the new allowance by unfortunate
2392      * transaction ordering. One possible solution to mitigate this race
2393      * condition is to first reduce the spender's allowance to 0 and set the
2394      * desired value afterwards:
2395      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2396      *
2397      * Emits an {Approval} event.
2398      */
2399     function approve(address spender, uint256 amount) external returns (bool);
2400 
2401     /**
2402      * @dev Moves `amount` tokens from `from` to `to` using the
2403      * allowance mechanism. `amount` is then deducted from the caller's
2404      * allowance.
2405      *
2406      * Returns a boolean value indicating whether the operation succeeded.
2407      *
2408      * Emits a {Transfer} event.
2409      */
2410     function transferFrom(
2411         address from,
2412         address to,
2413         uint256 amount
2414     ) external returns (bool);
2415 
2416     /**
2417      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2418      * another (`to`).
2419      *
2420      * Note that `value` may be zero.
2421      */
2422     event Transfer(address indexed from, address indexed to, uint256 value);
2423 
2424     /**
2425      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2426      * a call to {approve}. `value` is the new allowance.
2427      */
2428     event Approval(address indexed owner, address indexed spender, uint256 value);
2429 }
2430 
2431 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
2432 
2433 
2434 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
2435 
2436 pragma solidity ^0.8.0;
2437 
2438 
2439 
2440 /**
2441  * @title SafeERC20
2442  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2443  * contract returns false). Tokens that return no value (and instead revert or
2444  * throw on failure) are also supported, non-reverting calls are assumed to be
2445  * successful.
2446  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2447  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2448  */
2449 library SafeERC20 {
2450     using Address for address;
2451 
2452     function safeTransfer(
2453         IERC20 token,
2454         address to,
2455         uint256 value
2456     ) internal {
2457         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2458     }
2459 
2460     function safeTransferFrom(
2461         IERC20 token,
2462         address from,
2463         address to,
2464         uint256 value
2465     ) internal {
2466         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2467     }
2468 
2469     /**
2470      * @dev Deprecated. This function has issues similar to the ones found in
2471      * {IERC20-approve}, and its usage is discouraged.
2472      *
2473      * Whenever possible, use {safeIncreaseAllowance} and
2474      * {safeDecreaseAllowance} instead.
2475      */
2476     function safeApprove(
2477         IERC20 token,
2478         address spender,
2479         uint256 value
2480     ) internal {
2481         // safeApprove should only be called when setting an initial allowance,
2482         // or when resetting it to zero. To increase and decrease it, use
2483         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2484         require(
2485             (value == 0) || (token.allowance(address(this), spender) == 0),
2486             "SafeERC20: approve from non-zero to non-zero allowance"
2487         );
2488         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2489     }
2490 
2491     function safeIncreaseAllowance(
2492         IERC20 token,
2493         address spender,
2494         uint256 value
2495     ) internal {
2496         uint256 newAllowance = token.allowance(address(this), spender) + value;
2497         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2498     }
2499 
2500     function safeDecreaseAllowance(
2501         IERC20 token,
2502         address spender,
2503         uint256 value
2504     ) internal {
2505         unchecked {
2506             uint256 oldAllowance = token.allowance(address(this), spender);
2507             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
2508             uint256 newAllowance = oldAllowance - value;
2509             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2510         }
2511     }
2512 
2513     /**
2514      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2515      * on the return value: the return value is optional (but if data is returned, it must not be false).
2516      * @param token The token targeted by the call.
2517      * @param data The call data (encoded using abi.encode or one of its variants).
2518      */
2519     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2520         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2521         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
2522         // the target address contains contract code and also asserts for success in the low-level call.
2523 
2524         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2525         if (returndata.length > 0) {
2526             // Return data is optional
2527             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2528         }
2529     }
2530 }
2531 
2532 // File: contracts/lib/BlackholePrevention.sol
2533 
2534 
2535 
2536 // BlackholePrevention.sol -- Part of the Charged Particles Protocol
2537 // Copyright (c) 2021 Firma Lux, Inc. <https://charged.fi>
2538 //
2539 // Permission is hereby granted, free of charge, to any person obtaining a copy
2540 // of this software and associated documentation files (the "Software"), to deal
2541 // in the Software without restriction, including without limitation the rights
2542 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
2543 // copies of the Software, and to permit persons to whom the Software is
2544 // furnished to do so, subject to the following conditions:
2545 //
2546 // The above copyright notice and this permission notice shall be included in all
2547 // copies or substantial portions of the Software.
2548 //
2549 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
2550 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
2551 // FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
2552 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
2553 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
2554 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
2555 // SOFTWARE.
2556 
2557 pragma solidity ^0.8.0;
2558 
2559 
2560 
2561 
2562 
2563 
2564 /**
2565  * @notice Prevents ETH or Tokens from getting stuck in a contract by allowing
2566  *  the Owner/DAO to pull them out on behalf of a user
2567  * This is only meant to contracts that are not expected to hold tokens, but do handle transferring them.
2568  */
2569 contract BlackholePrevention {
2570     using Address for address payable;
2571     using SafeERC20 for IERC20;
2572 
2573     event WithdrawStuckEther(address indexed receiver, uint256 amount);
2574     event WithdrawStuckERC20(
2575         address indexed receiver,
2576         address indexed tokenAddress,
2577         uint256 amount
2578     );
2579     event WithdrawStuckERC721(
2580         address indexed receiver,
2581         address indexed tokenAddress,
2582         uint256 indexed tokenId
2583     );
2584     event WithdrawStuckERC1155(
2585         address indexed receiver,
2586         address indexed tokenAddress,
2587         uint256 indexed tokenId,
2588         uint256 amount
2589     );
2590 
2591     function _withdrawEther(address payable receiver, uint256 amount)
2592         internal
2593         virtual
2594     {
2595         require(receiver != address(0x0), "BHP:E-403");
2596         if (address(this).balance >= amount) {
2597             receiver.sendValue(amount);
2598             emit WithdrawStuckEther(receiver, amount);
2599         }
2600     }
2601 
2602     function _withdrawERC20(
2603         address payable receiver,
2604         address tokenAddress,
2605         uint256 amount
2606     ) internal virtual {
2607         require(receiver != address(0x0), "BHP:E-403");
2608         if (IERC20(tokenAddress).balanceOf(address(this)) >= amount) {
2609             IERC20(tokenAddress).safeTransfer(receiver, amount);
2610             emit WithdrawStuckERC20(receiver, tokenAddress, amount);
2611         }
2612     }
2613 
2614     function _withdrawERC721(
2615         address payable receiver,
2616         address tokenAddress,
2617         uint256 tokenId
2618     ) internal virtual {
2619         require(receiver != address(0x0), "BHP:E-403");
2620         if (IERC721(tokenAddress).ownerOf(tokenId) == address(this)) {
2621             IERC721(tokenAddress).transferFrom(
2622                 address(this),
2623                 receiver,
2624                 tokenId
2625             );
2626             emit WithdrawStuckERC721(receiver, tokenAddress, tokenId);
2627         }
2628     }
2629 
2630     function _withdrawERC1155(
2631         address payable receiver,
2632         address tokenAddress,
2633         uint256 tokenId,
2634         uint256 amount
2635     ) internal virtual {
2636         require(receiver != address(0x0), "BHP:E-403");
2637         if (
2638             IERC1155(tokenAddress).balanceOf(address(this), tokenId) >= amount
2639         ) {
2640             IERC1155(tokenAddress).safeTransferFrom(
2641                 address(this),
2642                 receiver,
2643                 tokenId,
2644                 amount,
2645                 ""
2646             );
2647             emit WithdrawStuckERC1155(receiver, tokenAddress, tokenId, amount);
2648         }
2649     }
2650 }
2651 
2652 // File: contracts/Particlon.sol
2653 
2654 
2655 
2656 // ParticlonB.sol -- Part of the Charged Particles Protocol
2657 // Copyright (c) 2021 Firma Lux, Inc. <https://charged.fi>
2658 //
2659 // Permission is hereby granted, free of charge, to any person obtaining a copy
2660 // of this software and associated documentation files (the "Software"), to deal
2661 // in the Software without restriction, including without limitation the rights
2662 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
2663 // copies of the Software, and to permit persons to whom the Software is
2664 // furnished to do so, subject to the following conditions:
2665 //
2666 // The above copyright notice and this permission notice shall be included in all
2667 // copies or substantial portions of the Software.
2668 //
2669 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
2670 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
2671 // FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
2672 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
2673 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
2674 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
2675 // SOFTWARE.
2676 
2677 pragma solidity ^0.8.0;
2678 
2679 
2680 
2681 
2682 
2683 
2684 
2685 
2686 
2687 
2688 
2689 
2690 
2691 
2692 
2693 
2694 contract Particlon is
2695     IParticlon,
2696     ERC721A,
2697     IERC721Consumable,
2698     Ownable,
2699     Pausable,
2700     RelayRecipient,
2701     ReentrancyGuard,
2702     BlackholePrevention
2703 {
2704     // using SafeMath for uint256; // not needed since solidity 0.8
2705     using TokenInfo for address payable;
2706     using Strings for uint256;
2707 
2708     /// @dev In case we want to revoke the consumer part
2709     bool internal _revokeConsumerOnTransfer;
2710 
2711     /// @notice Address used to generate cryptographic signatures for whitelisted addresses
2712     address internal _signer = 0xE8cF9826C7702411bb916c447D759E0E631d2e68;
2713 
2714     uint256 internal _nonceClaim = 69;
2715     uint256 internal _nonceWL = 420;
2716 
2717     uint256 public constant MAX_SUPPLY = 10069;
2718     uint256 public constant INITIAL_PRICE = 0.15 ether;
2719 
2720     uint256 internal constant PERCENTAGE_SCALE = 1e4; // 10000  (100%)
2721     uint256 internal constant MAX_ROYALTIES = 8e3; // 8000   (80%)
2722 
2723     // Charged Particles V1 mainnet
2724 
2725     IChargedState internal _chargedState =
2726         IChargedState(0xB29256073C63960daAa398f1227D0adBC574341C);
2727     // IChargedSettings internal _chargedSettings;
2728     IChargedParticles internal _chargedParticles =
2729         IChargedParticles(0xaB1a1410EA40930755C1330Cc0fB3367897C8c41);
2730 
2731     /// @notice This needs to be set using the setAssetToken in order to get approved
2732     address internal _assetToken;
2733 
2734     // This right here drops the size so it doesn't break the limitation
2735     // Enable optimization also has to be tured on!
2736     ISignatureVerifier internal constant _signatureVerifier =
2737         ISignatureVerifier(0x47a0915747565E8264296457b894068fe5CA9186);
2738 
2739     uint256 internal _mintPrice;
2740 
2741     string internal _baseUri =
2742         "ipfs://QmQrdG1cESrBenNUaTmxckFm4gJwgLdkqTGxNLuh4t5vo8/";
2743 
2744     // Mapping from token ID to consumer address
2745     mapping(uint256 => address) _tokenConsumers;
2746 
2747     mapping(uint256 => address) internal _tokenCreator;
2748     mapping(uint256 => uint256) internal _tokenCreatorRoyaltiesPct;
2749     mapping(uint256 => address) internal _tokenCreatorRoyaltiesRedirect;
2750     mapping(address => uint256) internal _tokenCreatorClaimableRoyalties;
2751 
2752     mapping(uint256 => uint256) internal _tokenSalePrice;
2753     mapping(uint256 => uint256) internal _tokenLastSellPrice;
2754 
2755     /// @notice Adhere to limits per whitelisted wallet for claim mint phase
2756     mapping(address => uint256) internal _mintPassMinted;
2757 
2758     /// @notice Adhere to limits per whitelisted wallet for whitelist mint phase
2759     mapping(address => uint256) internal _whitelistedAddressMinted;
2760 
2761     /// @notice set to CLOSED by default
2762     EMintPhase public mintPhase;
2763 
2764     /***********************************|
2765     |          Initialization           |
2766     |__________________________________*/
2767 
2768     constructor() ERC721A("Particlon", "PART") {
2769         _mintPrice = INITIAL_PRICE;
2770     }
2771 
2772     /***********************************|
2773     |              Public               |
2774     |__________________________________*/
2775 
2776     // Define an "onlyOwner" switch
2777     function setRevokeConsumerOnTransfer(bool state) external onlyOwner {
2778         _revokeConsumerOnTransfer = state;
2779     }
2780 
2781     /**
2782      * @dev See {IERC165-supportsInterface}.
2783      */
2784     function supportsInterface(bytes4 interfaceId)
2785         public
2786         view
2787         override(IERC165, ERC721A)
2788         returns (bool)
2789     {
2790         return
2791             interfaceId == type(IERC721Consumable).interfaceId ||
2792             super.supportsInterface(interfaceId);
2793     }
2794 
2795     /**
2796      * @dev See {IERC721Consumable-consumerOf}
2797      */
2798     function consumerOf(uint256 _tokenId) external view returns (address) {
2799         require(
2800             _exists(_tokenId),
2801             "ERC721Consumable: consumer query for nonexistent token"
2802         );
2803         return _tokenConsumers[_tokenId];
2804     }
2805 
2806     function creatorOf(uint256 tokenId)
2807         external
2808         view
2809         override
2810         returns (address)
2811     {
2812         return _tokenCreator[tokenId];
2813     }
2814 
2815     function getSalePrice(uint256 tokenId)
2816         external
2817         view
2818         override
2819         returns (uint256)
2820     {
2821         return _tokenSalePrice[tokenId];
2822     }
2823 
2824     function getLastSellPrice(uint256 tokenId)
2825         external
2826         view
2827         override
2828         returns (uint256)
2829     {
2830         return _tokenLastSellPrice[tokenId];
2831     }
2832 
2833     function getCreatorRoyalties(address account)
2834         external
2835         view
2836         override
2837         returns (uint256)
2838     {
2839         return _tokenCreatorClaimableRoyalties[account];
2840     }
2841 
2842     function getCreatorRoyaltiesPct(uint256 tokenId)
2843         external
2844         view
2845         override
2846         returns (uint256)
2847     {
2848         return _tokenCreatorRoyaltiesPct[tokenId];
2849     }
2850 
2851     function getCreatorRoyaltiesReceiver(uint256 tokenId)
2852         external
2853         view
2854         override
2855         returns (address)
2856     {
2857         return _creatorRoyaltiesReceiver(tokenId);
2858     }
2859 
2860     function claimCreatorRoyalties()
2861         external
2862         override
2863         nonReentrant
2864         whenNotPaused
2865         returns (uint256)
2866     {
2867         return _claimCreatorRoyalties(_msgSender());
2868     }
2869 
2870     /***********************************|
2871     |      Create Multiple Particlons   |
2872     |__________________________________*/
2873 
2874     /// @notice Andy was here
2875     function mint(uint256 amount)
2876         external
2877         payable
2878         override
2879         nonReentrant
2880         whenNotPaused
2881         notBeforePhase(EMintPhase.PUBLIC)
2882         whenRemainingSupply
2883         requirePayment(amount)
2884         returns (bool)
2885     {
2886         // They may have minted 10, but if only 2 remain in supply, then they will only get 2, so only pay for 2
2887         uint256 actualPrice = _mintAmount(amount, _msgSender());
2888         _refundOverpayment(actualPrice, 0); // dont worry about gasLimit here as the "minter" could only hook themselves
2889         return true;
2890     }
2891 
2892     /// @notice Andy was here
2893     function mintWhitelist(
2894         uint256 amountMint,
2895         uint256 amountAllowed,
2896         uint256 nonce,
2897         bytes calldata signature
2898     )
2899         external
2900         payable
2901         override
2902         nonReentrant
2903         whenNotPaused
2904         notBeforePhase(EMintPhase.WHITELIST)
2905         whenRemainingSupply
2906         requirePayment(amountMint)
2907         requireWhitelist(amountMint, amountAllowed, nonce, signature)
2908         returns (bool)
2909     {
2910         // They may have been whitelisted to mint 10, but if only 2 remain in supply, then they will only get 2, so only pay for 2
2911         uint256 actualPrice = _mintAmount(amountMint, _msgSender());
2912         _refundOverpayment(actualPrice, 0);
2913         return true;
2914     }
2915 
2916     function mintFree(
2917         uint256 amountMint,
2918         uint256 amountAllowed,
2919         uint256 nonce,
2920         bytes calldata signature
2921     )
2922         external
2923         override
2924         whenNotPaused
2925         notBeforePhase(EMintPhase.CLAIM)
2926         whenRemainingSupply
2927         requirePass(amountMint, amountAllowed, nonce, signature)
2928         returns (bool)
2929     {
2930         // They may have been whitelisted to mint 10, but if only 2 remain in supply, then they will only get 2
2931         _mintAmount(amountMint, _msgSender());
2932         return true;
2933     }
2934 
2935     /***********************************|
2936     |           Buy Particlons          |
2937     |__________________________________*/
2938 
2939     function buyParticlon(uint256 tokenId, uint256 gasLimit)
2940         external
2941         payable
2942         override
2943         nonReentrant
2944         whenNotPaused
2945         returns (bool)
2946     {
2947         _buyParticlon(tokenId, gasLimit);
2948         return true;
2949     }
2950 
2951     /***********************************|
2952     |     Only Token Creator/Owner      |
2953     |__________________________________*/
2954 
2955     function setSalePrice(uint256 tokenId, uint256 salePrice)
2956         external
2957         override
2958         whenNotPaused
2959         onlyTokenOwnerOrApproved(tokenId)
2960     {
2961         _setSalePrice(tokenId, salePrice);
2962     }
2963 
2964     function setRoyaltiesPct(uint256 tokenId, uint256 royaltiesPct)
2965         external
2966         override
2967         whenNotPaused
2968         onlyTokenCreator(tokenId)
2969         onlyTokenOwnerOrApproved(tokenId)
2970     {
2971         _setRoyaltiesPct(tokenId, royaltiesPct);
2972     }
2973 
2974     function setCreatorRoyaltiesReceiver(uint256 tokenId, address receiver)
2975         external
2976         override
2977         whenNotPaused
2978         onlyTokenCreator(tokenId)
2979     {
2980         _tokenCreatorRoyaltiesRedirect[tokenId] = receiver;
2981     }
2982 
2983     /**
2984      * @dev See {IERC721Consumable-changeConsumer}
2985      */
2986     function changeConsumer(address _consumer, uint256 _tokenId) external {
2987         address owner = this.ownerOf(_tokenId);
2988         require(
2989             _msgSender() == owner ||
2990                 _msgSender() == getApproved(_tokenId) ||
2991                 isApprovedForAll(owner, _msgSender()),
2992             "ERC721Consumable: changeConsumer caller is not owner nor approved"
2993         );
2994         _changeConsumer(owner, _consumer, _tokenId);
2995     }
2996 
2997     /***********************************|
2998     |          Only Admin/DAO           |
2999     |__________________________________*/
3000 
3001     // Andy was here (Andy is everywhere)
3002 
3003     function setSignerAddress(address signer) external onlyOwner {
3004         _signer = signer;
3005         emit NewSignerAddress(signer);
3006     }
3007 
3008     // In case we need to "undo" a signature/prevent it from being used,
3009     // This is easier than changing the signer
3010     // we would also need to remake all unused signatures
3011     function setNonces(uint256 nonceClaim, uint256 nonceWL) external onlyOwner {
3012         _nonceClaim = nonceClaim;
3013         _nonceWL = nonceWL;
3014     }
3015 
3016     function setAssetToken(address assetToken) external onlyOwner {
3017         _assetToken = assetToken;
3018         // Need to Approve Charged Particles to transfer Assets from Particlon
3019         IERC20(assetToken).approve(
3020             address(_chargedParticles),
3021             type(uint256).max
3022         );
3023         emit AssetTokenSet(assetToken);
3024     }
3025 
3026     function setMintPrice(uint256 price) external onlyOwner {
3027         _mintPrice = price;
3028         emit NewMintPrice(price);
3029     }
3030 
3031     /// @notice This is needed for the reveal
3032     function setURI(string memory uri) external onlyOwner {
3033         _baseUri = uri;
3034         emit NewBaseURI(uri);
3035     }
3036 
3037     function setMintPhase(EMintPhase _mintPhase) external onlyOwner {
3038         mintPhase = _mintPhase;
3039         emit NewMintPhase(_mintPhase);
3040     }
3041 
3042     function setPausedState(bool state) external onlyOwner {
3043         state ? _pause() : _unpause(); // these emit events
3044     }
3045 
3046     /**
3047      * @dev Setup the ChargedParticles Interface
3048      */
3049     function setChargedParticles(address chargedParticles) external onlyOwner {
3050         _chargedParticles = IChargedParticles(chargedParticles);
3051         emit ChargedParticlesSet(chargedParticles);
3052     }
3053 
3054     /// @dev Setup the Charged-State Controller
3055     function setChargedState(address stateController) external onlyOwner {
3056         _chargedState = IChargedState(stateController);
3057         emit ChargedStateSet(stateController);
3058     }
3059 
3060     /// @dev Setup the Charged-Settings Controller
3061     // function setChargedSettings(address settings) external onlyOwner {
3062     //     _chargedSettings = IChargedSettings(settings);
3063     //     emit ChargedSettingsSet(settings);
3064     // }
3065 
3066     function setTrustedForwarder(address _trustedForwarder) external onlyOwner {
3067         _setTrustedForwarder(_trustedForwarder); // Andy was here, trustedForwarder is already defined in opengsn/contracts/src/BaseRelayRecipient.sol
3068     }
3069 
3070     /***********************************|
3071     |          Only Admin/DAO           |
3072     |      (blackhole prevention)       |
3073     |__________________________________*/
3074 
3075     function withdrawEther(address payable receiver, uint256 amount)
3076         external
3077         onlyOwner
3078     {
3079         _withdrawEther(receiver, amount);
3080     }
3081 
3082     function withdrawERC20(
3083         address payable receiver,
3084         address tokenAddress,
3085         uint256 amount
3086     ) external onlyOwner {
3087         _withdrawERC20(receiver, tokenAddress, amount);
3088     }
3089 
3090     function withdrawERC721(
3091         address payable receiver,
3092         address tokenAddress,
3093         uint256 tokenId
3094     ) external onlyOwner {
3095         _withdrawERC721(receiver, tokenAddress, tokenId);
3096     }
3097 
3098     /***********************************|
3099     |         Private Functions         |
3100     |__________________________________*/
3101 
3102     function _baseURI() internal view override returns (string memory) {
3103         return _baseUri;
3104     }
3105 
3106     function _mintAmount(uint256 amount, address creator)
3107         internal
3108         returns (uint256 actualPrice)
3109     {
3110         uint256 newTokenId = totalSupply();
3111         // newTokenId is equal to the supply at this stage
3112         if (newTokenId + amount > MAX_SUPPLY) {
3113             amount = MAX_SUPPLY - newTokenId;
3114         }
3115         // totalSupply += amount;
3116 
3117         // _safeMint's second argument now takes in a quantity, not a tokenId.
3118         _safeMint(creator, amount);
3119         actualPrice = amount * _mintPrice; // Charge people for the ACTUAL amount minted;
3120 
3121         uint256 assetAmount;
3122         newTokenId++;
3123         for (uint256 i; i < amount; i++) {
3124             // Set the first minters as the creators
3125             _tokenCreator[newTokenId + i] = creator;
3126             assetAmount += _getAssetAmount(newTokenId + i);
3127             // _chargeParticlon(newTokenId, "generic", assetAmount);
3128         }
3129         // Put all ERC20 tokens into the first Particlon to save a lot of gas
3130         _chargeParticlon(newTokenId, "generic", assetAmount);
3131     }
3132 
3133     /**
3134      * @dev Changes the consumer
3135      * Requirement: `tokenId` must exist
3136      */
3137     function _changeConsumer(
3138         address _owner,
3139         address _consumer,
3140         uint256 _tokenId
3141     ) internal {
3142         _tokenConsumers[_tokenId] = _consumer;
3143         emit ConsumerChanged(_owner, _consumer, _tokenId);
3144     }
3145 
3146     function _beforeTokenTransfers(
3147         address _from,
3148         address _to,
3149         uint256 _startTokenId,
3150         uint256 _quantity
3151     ) internal virtual override(ERC721A) {
3152         if (_from == address(0)) {
3153             return;
3154         }
3155         super._beforeTokenTransfers(_from, _to, _startTokenId, _quantity);
3156 
3157         require(!paused(), "ERC721Pausable: token transfer while paused");
3158 
3159         if (_revokeConsumerOnTransfer) {
3160             /// @notice quantity is always one in this case
3161             _changeConsumer(_from, address(0), _startTokenId);
3162         }
3163     }
3164 
3165     function _setSalePrice(uint256 tokenId, uint256 salePrice) internal {
3166         _tokenSalePrice[tokenId] = salePrice;
3167 
3168         // Temp-Lock/Unlock NFT
3169         //  prevents front-running the sale and draining the value of the NFT just before sale
3170         _chargedState.setTemporaryLock(address(this), tokenId, (salePrice > 0));
3171 
3172         emit SalePriceSet(tokenId, salePrice);
3173     }
3174 
3175     function _setRoyaltiesPct(uint256 tokenId, uint256 royaltiesPct) internal {
3176         require(royaltiesPct <= MAX_ROYALTIES, "PRT:E-421"); // Andy was here
3177         _tokenCreatorRoyaltiesPct[tokenId] = royaltiesPct;
3178         emit CreatorRoyaltiesSet(tokenId, royaltiesPct);
3179     }
3180 
3181     function _creatorRoyaltiesReceiver(uint256 tokenId)
3182         internal
3183         view
3184         returns (address)
3185     {
3186         address receiver = _tokenCreatorRoyaltiesRedirect[tokenId];
3187         if (receiver == address(0x0)) {
3188             receiver = _tokenCreator[tokenId];
3189         }
3190         return receiver;
3191     }
3192 
3193     /// @notice The tokens from a batch are being nested into the first NFT minted in that batch
3194     function _getAssetAmount(uint256 tokenId) internal pure returns (uint256) {
3195         if (tokenId == MAX_SUPPLY) {
3196             return 1596 * 10**18;
3197         } else if (tokenId > 9000) {
3198             return 1403 * 10**18;
3199         } else if (tokenId > 6000) {
3200             return 1000 * 10**18;
3201         } else if (tokenId > 3000) {
3202             return 1500 * 10**18;
3203         } else if (tokenId > 1000) {
3204             return 1750 * 10**18;
3205         }
3206         return 2500 * 10**18;
3207     }
3208 
3209     function _chargeParticlon(
3210         uint256 tokenId,
3211         string memory walletManagerId,
3212         uint256 assetAmount
3213     ) internal {
3214         address _self = address(this);
3215         _chargedParticles.energizeParticle(
3216             _self,
3217             tokenId,
3218             walletManagerId,
3219             _assetToken,
3220             assetAmount,
3221             _self
3222         );
3223     }
3224 
3225     function _buyParticlon(uint256 _tokenId, uint256 _gasLimit)
3226         internal
3227         returns (
3228             address contractAddress,
3229             uint256 tokenId,
3230             address oldOwner,
3231             address newOwner,
3232             uint256 salePrice,
3233             address royaltiesReceiver,
3234             uint256 creatorAmount
3235         )
3236     {
3237         contractAddress = address(this);
3238         tokenId = _tokenId;
3239         salePrice = _tokenSalePrice[_tokenId];
3240         require(salePrice > 0, "PRT:E-416");
3241         require(msg.value >= salePrice, "PRT:E-414");
3242 
3243         uint256 ownerAmount = salePrice;
3244         // creatorAmount;
3245         oldOwner = ownerOf(_tokenId);
3246         newOwner = _msgSender();
3247 
3248         // Creator Royalties
3249         royaltiesReceiver = _creatorRoyaltiesReceiver(_tokenId);
3250         uint256 royaltiesPct = _tokenCreatorRoyaltiesPct[_tokenId];
3251         uint256 lastSellPrice = _tokenLastSellPrice[_tokenId];
3252         if (
3253             royaltiesPct > 0 && lastSellPrice > 0 && salePrice > lastSellPrice
3254         ) {
3255             creatorAmount =
3256                 ((salePrice - lastSellPrice) * royaltiesPct) /
3257                 PERCENTAGE_SCALE;
3258             ownerAmount -= creatorAmount;
3259         }
3260         _tokenLastSellPrice[_tokenId] = salePrice;
3261 
3262         // Reserve Royalties for Creator
3263         if (creatorAmount > 0) {
3264             _tokenCreatorClaimableRoyalties[royaltiesReceiver] += creatorAmount;
3265         }
3266 
3267         // Transfer Token
3268         _transfer(oldOwner, newOwner, _tokenId);
3269 
3270         emit ParticlonSold(
3271             _tokenId,
3272             oldOwner,
3273             newOwner,
3274             salePrice,
3275             royaltiesReceiver,
3276             creatorAmount
3277         );
3278 
3279         // Transfer Payment
3280         if (ownerAmount > 0) {
3281             payable(oldOwner).sendValue(ownerAmount, _gasLimit);
3282         }
3283         _refundOverpayment(salePrice, _gasLimit);
3284     }
3285 
3286     /**
3287      * @dev Pays out the Creator Royalties of the calling account
3288      * @param receiver  The receiver of the claimable royalties
3289      * @return          The amount of Creator Royalties claimed
3290      */
3291     function _claimCreatorRoyalties(address receiver)
3292         internal
3293         returns (uint256)
3294     {
3295         uint256 claimableAmount = _tokenCreatorClaimableRoyalties[receiver];
3296         require(claimableAmount > 0, "PRT:E-411");
3297 
3298         delete _tokenCreatorClaimableRoyalties[receiver];
3299         payable(receiver).sendValue(claimableAmount, 0);
3300 
3301         emit RoyaltiesClaimed(receiver, claimableAmount);
3302 
3303         // Andy was here
3304         return claimableAmount;
3305     }
3306 
3307     function _refundOverpayment(uint256 threshold, uint256 gasLimit) internal {
3308         // Andy was here, removed SafeMath
3309         uint256 overage = msg.value - threshold;
3310         if (overage > 0) {
3311             payable(_msgSender()).sendValue(overage, gasLimit);
3312         }
3313     }
3314 
3315     function _transfer(
3316         address from,
3317         address to,
3318         uint256 tokenId
3319     ) internal override {
3320         // Unlock NFT
3321         _tokenSalePrice[tokenId] = 0; // Andy was here
3322         _chargedState.setTemporaryLock(address(this), tokenId, false);
3323 
3324         super._transfer(from, to, tokenId);
3325     }
3326 
3327     /***********************************|
3328     |          GSN/MetaTx Relay         |
3329     |__________________________________*/
3330 
3331     /// @dev See {BaseRelayRecipient-_msgSender}.
3332     /// Andy: removed payable
3333     function _msgSender()
3334         internal
3335         view
3336         override(BaseRelayRecipient, Context)
3337         returns (address)
3338     {
3339         return BaseRelayRecipient._msgSender();
3340     }
3341 
3342     /// @dev See {BaseRelayRecipient-_msgData}.
3343     function _msgData()
3344         internal
3345         view
3346         override(BaseRelayRecipient, Context)
3347         returns (bytes memory)
3348     {
3349         return BaseRelayRecipient._msgData();
3350     }
3351 
3352     /// @dev This is missing from ERC721A for some reason.
3353     function _isApprovedOrOwner(address spender, uint256 tokenId)
3354         internal
3355         view
3356         virtual
3357         returns (bool)
3358     {
3359         require(
3360             _exists(tokenId),
3361             "ERC721: operator query for nonexistent token"
3362         );
3363         address owner = ownerOf(tokenId);
3364         return (spender == owner ||
3365             isApprovedForAll(owner, spender) ||
3366             getApproved(tokenId) == spender);
3367     }
3368 
3369     /***********************************|
3370     |             Modifiers             |
3371     |__________________________________*/
3372 
3373     // Andy was here
3374     modifier notBeforePhase(EMintPhase _mintPhase) {
3375         require(mintPhase >= _mintPhase, "MINT PHASE ERR");
3376         _;
3377     }
3378 
3379     modifier whenRemainingSupply() {
3380         require(totalSupply() <= MAX_SUPPLY, "SUPPLY LIMIT");
3381         _;
3382     }
3383 
3384     modifier requirePayment(uint256 amount) {
3385         uint256 fullPrice = amount * _mintPrice;
3386         require(msg.value >= fullPrice, "LOW ETH");
3387         _;
3388     }
3389 
3390     modifier requireWhitelist(
3391         uint256 amountMint,
3392         uint256 amountAllowed,
3393         uint256 nonce,
3394         bytes calldata signature
3395     ) {
3396         require(amountMint <= amountAllowed, "AMOUNT ERR");
3397         require(nonce == _nonceWL, "NONCE ERR");
3398         require(
3399             _signatureVerifier.verify(
3400                 _signer,
3401                 _msgSender(),
3402                 amountAllowed,
3403                 nonce, // prevent WL signatures being used for claiming
3404                 signature
3405             ),
3406             "SIGNATURE ERR"
3407         );
3408         require(
3409             _whitelistedAddressMinted[_msgSender()] + amountMint <=
3410                 amountAllowed,
3411             "CLAIM ERR"
3412         );
3413         _whitelistedAddressMinted[_msgSender()] += amountMint;
3414         _;
3415     }
3416 
3417     /// @notice A snapshot is taken before the mint (mint pass NFT count is taken into consideration)
3418     modifier requirePass(
3419         uint256 amountMint,
3420         uint256 amountAllowed,
3421         uint256 nonce,
3422         bytes calldata signature
3423     ) {
3424         require(amountMint <= amountAllowed, "AMOUNT ERR");
3425         require(nonce == _nonceClaim, "NONCE ERR");
3426         require(
3427             _signatureVerifier.verify(
3428                 _signer,
3429                 _msgSender(),
3430                 amountAllowed,
3431                 nonce,
3432                 signature
3433             ),
3434             "SIGNATURE ERR"
3435         );
3436         require(
3437             _mintPassMinted[_msgSender()] + amountMint <= amountAllowed,
3438             "CLAIM ERR"
3439         );
3440         _mintPassMinted[_msgSender()] += amountMint;
3441         _;
3442     }
3443 
3444     modifier onlyTokenOwnerOrApproved(uint256 tokenId) {
3445         require(_isApprovedOrOwner(_msgSender(), tokenId), "PRT:E-105");
3446         _;
3447     }
3448 
3449     modifier onlyTokenCreator(uint256 tokenId) {
3450         require(_tokenCreator[tokenId] == _msgSender(), "PRT:E-104");
3451         _;
3452     }
3453 }