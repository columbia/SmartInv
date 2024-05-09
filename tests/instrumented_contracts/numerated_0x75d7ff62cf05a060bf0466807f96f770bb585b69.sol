1 // SPDX-License-Identifier: Unlicense
2 //     ____  _______________ __  _____    ____  ____ _       _______
3 //    / __ )/  _/_  __/ ___// / / /   |  / __ \/ __ \ |     / /__  /
4 //   / __  |/ /  / /  \__ \/ /_/ / /| | / / / / / / / | /| / /  / / 
5 //  / /_/ // /  / /  ___/ / __  / ___ |/ /_/ / /_/ /| |/ |/ /  / /__
6 // /_____/___/ /_/  /____/_/ /_/_/  |_/_____/\____/ |__/|__/  /____/
7                                                                  
8 // https://SHADOWZVERSE.io
9 
10 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
11 
12 
13 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev Interface of the ERC165 standard, as defined in the
19  * https://eips.ethereum.org/EIPS/eip-165[EIP].
20  *
21  * Implementers can declare support of contract interfaces, which can then be
22  * queried by others ({ERC165Checker}).
23  *
24  * For an implementation, see {ERC165}.
25  */
26 interface IERC165 {
27     /**
28      * @dev Returns true if this contract implements the interface defined by
29      * `interfaceId`. See the corresponding
30      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
31      * to learn more about how these ids are created.
32      *
33      * This function call must use less than 30 000 gas.
34      */
35     function supportsInterface(bytes4 interfaceId) external view returns (bool);
36 }
37 
38 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
39 
40 
41 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
42 
43 pragma solidity ^0.8.0;
44 
45 
46 /**
47  * @dev Implementation of the {IERC165} interface.
48  *
49  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
50  * for the additional interface id that will be supported. For example:
51  *
52  * ```solidity
53  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
54  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
55  * }
56  * ```
57  *
58  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
59  */
60 abstract contract ERC165 is IERC165 {
61     /**
62      * @dev See {IERC165-supportsInterface}.
63      */
64     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
65         return interfaceId == type(IERC165).interfaceId;
66     }
67 }
68 
69 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
70 
71 
72 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 
77 /**
78  * @dev Interface for the NFT Royalty Standard.
79  *
80  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
81  * support for royalty payments across all NFT marketplaces and ecosystem participants.
82  *
83  * _Available since v4.5._
84  */
85 interface IERC2981 is IERC165 {
86     /**
87      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
88      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
89      */
90     function royaltyInfo(uint256 tokenId, uint256 salePrice)
91         external
92         view
93         returns (address receiver, uint256 royaltyAmount);
94 }
95 
96 // File: @openzeppelin/contracts/token/common/ERC2981.sol
97 
98 
99 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 
104 
105 /**
106  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
107  *
108  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
109  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
110  *
111  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
112  * fee is specified in basis points by default.
113  *
114  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
115  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
116  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
117  *
118  * _Available since v4.5._
119  */
120 abstract contract ERC2981 is IERC2981, ERC165 {
121     struct RoyaltyInfo {
122         address receiver;
123         uint96 royaltyFraction;
124     }
125 
126     RoyaltyInfo private _defaultRoyaltyInfo;
127     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
128 
129     /**
130      * @dev See {IERC165-supportsInterface}.
131      */
132     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
133         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
134     }
135 
136     /**
137      * @inheritdoc IERC2981
138      */
139     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
140         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
141 
142         if (royalty.receiver == address(0)) {
143             royalty = _defaultRoyaltyInfo;
144         }
145 
146         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
147 
148         return (royalty.receiver, royaltyAmount);
149     }
150 
151     /**
152      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
153      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
154      * override.
155      */
156     function _feeDenominator() internal pure virtual returns (uint96) {
157         return 10000;
158     }
159 
160     /**
161      * @dev Sets the royalty information that all ids in this contract will default to.
162      *
163      * Requirements:
164      *
165      * - `receiver` cannot be the zero address.
166      * - `feeNumerator` cannot be greater than the fee denominator.
167      */
168     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
169         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
170         require(receiver != address(0), "ERC2981: invalid receiver");
171 
172         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
173     }
174 
175     /**
176      * @dev Removes default royalty information.
177      */
178     function _deleteDefaultRoyalty() internal virtual {
179         delete _defaultRoyaltyInfo;
180     }
181 
182     /**
183      * @dev Sets the royalty information for a specific token id, overriding the global default.
184      *
185      * Requirements:
186      *
187      * - `receiver` cannot be the zero address.
188      * - `feeNumerator` cannot be greater than the fee denominator.
189      */
190     function _setTokenRoyalty(
191         uint256 tokenId,
192         address receiver,
193         uint96 feeNumerator
194     ) internal virtual {
195         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
196         require(receiver != address(0), "ERC2981: Invalid parameters");
197 
198         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
199     }
200 
201     /**
202      * @dev Resets royalty information for the token id back to the global default.
203      */
204     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
205         delete _tokenRoyaltyInfo[tokenId];
206     }
207 }
208 
209 // File: @openzeppelin/contracts/utils/Strings.sol
210 
211 
212 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
213 
214 pragma solidity ^0.8.0;
215 
216 /**
217  * @dev String operations.
218  */
219 library Strings {
220     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
221     uint8 private constant _ADDRESS_LENGTH = 20;
222 
223     /**
224      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
225      */
226     function toString(uint256 value) internal pure returns (string memory) {
227         // Inspired by OraclizeAPI's implementation - MIT licence
228         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
229 
230         if (value == 0) {
231             return "0";
232         }
233         uint256 temp = value;
234         uint256 digits;
235         while (temp != 0) {
236             digits++;
237             temp /= 10;
238         }
239         bytes memory buffer = new bytes(digits);
240         while (value != 0) {
241             digits -= 1;
242             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
243             value /= 10;
244         }
245         return string(buffer);
246     }
247 
248     /**
249      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
250      */
251     function toHexString(uint256 value) internal pure returns (string memory) {
252         if (value == 0) {
253             return "0x00";
254         }
255         uint256 temp = value;
256         uint256 length = 0;
257         while (temp != 0) {
258             length++;
259             temp >>= 8;
260         }
261         return toHexString(value, length);
262     }
263 
264     /**
265      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
266      */
267     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
268         bytes memory buffer = new bytes(2 * length + 2);
269         buffer[0] = "0";
270         buffer[1] = "x";
271         for (uint256 i = 2 * length + 1; i > 1; --i) {
272             buffer[i] = _HEX_SYMBOLS[value & 0xf];
273             value >>= 4;
274         }
275         require(value == 0, "Strings: hex length insufficient");
276         return string(buffer);
277     }
278 
279     /**
280      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
281      */
282     function toHexString(address addr) internal pure returns (string memory) {
283         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
284     }
285 }
286 
287 // File: hardhat/console.sol
288 
289 
290 pragma solidity >= 0.4.22 <0.9.0;
291 
292 library console {
293 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
294 
295 	function _sendLogPayload(bytes memory payload) private view {
296 		uint256 payloadLength = payload.length;
297 		address consoleAddress = CONSOLE_ADDRESS;
298 		assembly {
299 			let payloadStart := add(payload, 32)
300 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
301 		}
302 	}
303 
304 	function log() internal view {
305 		_sendLogPayload(abi.encodeWithSignature("log()"));
306 	}
307 
308 	function logInt(int p0) internal view {
309 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
310 	}
311 
312 	function logUint(uint p0) internal view {
313 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
314 	}
315 
316 	function logString(string memory p0) internal view {
317 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
318 	}
319 
320 	function logBool(bool p0) internal view {
321 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
322 	}
323 
324 	function logAddress(address p0) internal view {
325 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
326 	}
327 
328 	function logBytes(bytes memory p0) internal view {
329 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
330 	}
331 
332 	function logBytes1(bytes1 p0) internal view {
333 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
334 	}
335 
336 	function logBytes2(bytes2 p0) internal view {
337 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
338 	}
339 
340 	function logBytes3(bytes3 p0) internal view {
341 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
342 	}
343 
344 	function logBytes4(bytes4 p0) internal view {
345 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
346 	}
347 
348 	function logBytes5(bytes5 p0) internal view {
349 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
350 	}
351 
352 	function logBytes6(bytes6 p0) internal view {
353 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
354 	}
355 
356 	function logBytes7(bytes7 p0) internal view {
357 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
358 	}
359 
360 	function logBytes8(bytes8 p0) internal view {
361 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
362 	}
363 
364 	function logBytes9(bytes9 p0) internal view {
365 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
366 	}
367 
368 	function logBytes10(bytes10 p0) internal view {
369 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
370 	}
371 
372 	function logBytes11(bytes11 p0) internal view {
373 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
374 	}
375 
376 	function logBytes12(bytes12 p0) internal view {
377 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
378 	}
379 
380 	function logBytes13(bytes13 p0) internal view {
381 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
382 	}
383 
384 	function logBytes14(bytes14 p0) internal view {
385 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
386 	}
387 
388 	function logBytes15(bytes15 p0) internal view {
389 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
390 	}
391 
392 	function logBytes16(bytes16 p0) internal view {
393 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
394 	}
395 
396 	function logBytes17(bytes17 p0) internal view {
397 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
398 	}
399 
400 	function logBytes18(bytes18 p0) internal view {
401 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
402 	}
403 
404 	function logBytes19(bytes19 p0) internal view {
405 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
406 	}
407 
408 	function logBytes20(bytes20 p0) internal view {
409 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
410 	}
411 
412 	function logBytes21(bytes21 p0) internal view {
413 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
414 	}
415 
416 	function logBytes22(bytes22 p0) internal view {
417 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
418 	}
419 
420 	function logBytes23(bytes23 p0) internal view {
421 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
422 	}
423 
424 	function logBytes24(bytes24 p0) internal view {
425 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
426 	}
427 
428 	function logBytes25(bytes25 p0) internal view {
429 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
430 	}
431 
432 	function logBytes26(bytes26 p0) internal view {
433 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
434 	}
435 
436 	function logBytes27(bytes27 p0) internal view {
437 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
438 	}
439 
440 	function logBytes28(bytes28 p0) internal view {
441 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
442 	}
443 
444 	function logBytes29(bytes29 p0) internal view {
445 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
446 	}
447 
448 	function logBytes30(bytes30 p0) internal view {
449 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
450 	}
451 
452 	function logBytes31(bytes31 p0) internal view {
453 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
454 	}
455 
456 	function logBytes32(bytes32 p0) internal view {
457 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
458 	}
459 
460 	function log(uint p0) internal view {
461 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
462 	}
463 
464 	function log(string memory p0) internal view {
465 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
466 	}
467 
468 	function log(bool p0) internal view {
469 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
470 	}
471 
472 	function log(address p0) internal view {
473 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
474 	}
475 
476 	function log(uint p0, uint p1) internal view {
477 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
478 	}
479 
480 	function log(uint p0, string memory p1) internal view {
481 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
482 	}
483 
484 	function log(uint p0, bool p1) internal view {
485 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
486 	}
487 
488 	function log(uint p0, address p1) internal view {
489 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
490 	}
491 
492 	function log(string memory p0, uint p1) internal view {
493 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
494 	}
495 
496 	function log(string memory p0, string memory p1) internal view {
497 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
498 	}
499 
500 	function log(string memory p0, bool p1) internal view {
501 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
502 	}
503 
504 	function log(string memory p0, address p1) internal view {
505 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
506 	}
507 
508 	function log(bool p0, uint p1) internal view {
509 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
510 	}
511 
512 	function log(bool p0, string memory p1) internal view {
513 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
514 	}
515 
516 	function log(bool p0, bool p1) internal view {
517 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
518 	}
519 
520 	function log(bool p0, address p1) internal view {
521 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
522 	}
523 
524 	function log(address p0, uint p1) internal view {
525 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
526 	}
527 
528 	function log(address p0, string memory p1) internal view {
529 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
530 	}
531 
532 	function log(address p0, bool p1) internal view {
533 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
534 	}
535 
536 	function log(address p0, address p1) internal view {
537 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
538 	}
539 
540 	function log(uint p0, uint p1, uint p2) internal view {
541 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
542 	}
543 
544 	function log(uint p0, uint p1, string memory p2) internal view {
545 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
546 	}
547 
548 	function log(uint p0, uint p1, bool p2) internal view {
549 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
550 	}
551 
552 	function log(uint p0, uint p1, address p2) internal view {
553 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
554 	}
555 
556 	function log(uint p0, string memory p1, uint p2) internal view {
557 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
558 	}
559 
560 	function log(uint p0, string memory p1, string memory p2) internal view {
561 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
562 	}
563 
564 	function log(uint p0, string memory p1, bool p2) internal view {
565 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
566 	}
567 
568 	function log(uint p0, string memory p1, address p2) internal view {
569 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
570 	}
571 
572 	function log(uint p0, bool p1, uint p2) internal view {
573 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
574 	}
575 
576 	function log(uint p0, bool p1, string memory p2) internal view {
577 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
578 	}
579 
580 	function log(uint p0, bool p1, bool p2) internal view {
581 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
582 	}
583 
584 	function log(uint p0, bool p1, address p2) internal view {
585 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
586 	}
587 
588 	function log(uint p0, address p1, uint p2) internal view {
589 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
590 	}
591 
592 	function log(uint p0, address p1, string memory p2) internal view {
593 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
594 	}
595 
596 	function log(uint p0, address p1, bool p2) internal view {
597 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
598 	}
599 
600 	function log(uint p0, address p1, address p2) internal view {
601 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
602 	}
603 
604 	function log(string memory p0, uint p1, uint p2) internal view {
605 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
606 	}
607 
608 	function log(string memory p0, uint p1, string memory p2) internal view {
609 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
610 	}
611 
612 	function log(string memory p0, uint p1, bool p2) internal view {
613 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
614 	}
615 
616 	function log(string memory p0, uint p1, address p2) internal view {
617 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
618 	}
619 
620 	function log(string memory p0, string memory p1, uint p2) internal view {
621 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
622 	}
623 
624 	function log(string memory p0, string memory p1, string memory p2) internal view {
625 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
626 	}
627 
628 	function log(string memory p0, string memory p1, bool p2) internal view {
629 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
630 	}
631 
632 	function log(string memory p0, string memory p1, address p2) internal view {
633 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
634 	}
635 
636 	function log(string memory p0, bool p1, uint p2) internal view {
637 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
638 	}
639 
640 	function log(string memory p0, bool p1, string memory p2) internal view {
641 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
642 	}
643 
644 	function log(string memory p0, bool p1, bool p2) internal view {
645 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
646 	}
647 
648 	function log(string memory p0, bool p1, address p2) internal view {
649 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
650 	}
651 
652 	function log(string memory p0, address p1, uint p2) internal view {
653 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
654 	}
655 
656 	function log(string memory p0, address p1, string memory p2) internal view {
657 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
658 	}
659 
660 	function log(string memory p0, address p1, bool p2) internal view {
661 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
662 	}
663 
664 	function log(string memory p0, address p1, address p2) internal view {
665 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
666 	}
667 
668 	function log(bool p0, uint p1, uint p2) internal view {
669 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
670 	}
671 
672 	function log(bool p0, uint p1, string memory p2) internal view {
673 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
674 	}
675 
676 	function log(bool p0, uint p1, bool p2) internal view {
677 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
678 	}
679 
680 	function log(bool p0, uint p1, address p2) internal view {
681 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
682 	}
683 
684 	function log(bool p0, string memory p1, uint p2) internal view {
685 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
686 	}
687 
688 	function log(bool p0, string memory p1, string memory p2) internal view {
689 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
690 	}
691 
692 	function log(bool p0, string memory p1, bool p2) internal view {
693 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
694 	}
695 
696 	function log(bool p0, string memory p1, address p2) internal view {
697 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
698 	}
699 
700 	function log(bool p0, bool p1, uint p2) internal view {
701 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
702 	}
703 
704 	function log(bool p0, bool p1, string memory p2) internal view {
705 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
706 	}
707 
708 	function log(bool p0, bool p1, bool p2) internal view {
709 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
710 	}
711 
712 	function log(bool p0, bool p1, address p2) internal view {
713 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
714 	}
715 
716 	function log(bool p0, address p1, uint p2) internal view {
717 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
718 	}
719 
720 	function log(bool p0, address p1, string memory p2) internal view {
721 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
722 	}
723 
724 	function log(bool p0, address p1, bool p2) internal view {
725 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
726 	}
727 
728 	function log(bool p0, address p1, address p2) internal view {
729 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
730 	}
731 
732 	function log(address p0, uint p1, uint p2) internal view {
733 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
734 	}
735 
736 	function log(address p0, uint p1, string memory p2) internal view {
737 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
738 	}
739 
740 	function log(address p0, uint p1, bool p2) internal view {
741 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
742 	}
743 
744 	function log(address p0, uint p1, address p2) internal view {
745 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
746 	}
747 
748 	function log(address p0, string memory p1, uint p2) internal view {
749 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
750 	}
751 
752 	function log(address p0, string memory p1, string memory p2) internal view {
753 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
754 	}
755 
756 	function log(address p0, string memory p1, bool p2) internal view {
757 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
758 	}
759 
760 	function log(address p0, string memory p1, address p2) internal view {
761 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
762 	}
763 
764 	function log(address p0, bool p1, uint p2) internal view {
765 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
766 	}
767 
768 	function log(address p0, bool p1, string memory p2) internal view {
769 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
770 	}
771 
772 	function log(address p0, bool p1, bool p2) internal view {
773 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
774 	}
775 
776 	function log(address p0, bool p1, address p2) internal view {
777 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
778 	}
779 
780 	function log(address p0, address p1, uint p2) internal view {
781 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
782 	}
783 
784 	function log(address p0, address p1, string memory p2) internal view {
785 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
786 	}
787 
788 	function log(address p0, address p1, bool p2) internal view {
789 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
790 	}
791 
792 	function log(address p0, address p1, address p2) internal view {
793 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
794 	}
795 
796 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
797 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
798 	}
799 
800 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
801 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
802 	}
803 
804 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
805 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
806 	}
807 
808 	function log(uint p0, uint p1, uint p2, address p3) internal view {
809 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
810 	}
811 
812 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
813 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
814 	}
815 
816 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
817 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
818 	}
819 
820 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
821 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
822 	}
823 
824 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
825 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
826 	}
827 
828 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
829 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
830 	}
831 
832 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
833 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
834 	}
835 
836 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
837 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
838 	}
839 
840 	function log(uint p0, uint p1, bool p2, address p3) internal view {
841 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
842 	}
843 
844 	function log(uint p0, uint p1, address p2, uint p3) internal view {
845 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
846 	}
847 
848 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
849 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
850 	}
851 
852 	function log(uint p0, uint p1, address p2, bool p3) internal view {
853 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
854 	}
855 
856 	function log(uint p0, uint p1, address p2, address p3) internal view {
857 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
858 	}
859 
860 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
861 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
862 	}
863 
864 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
865 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
866 	}
867 
868 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
869 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
870 	}
871 
872 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
873 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
874 	}
875 
876 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
877 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
878 	}
879 
880 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
881 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
882 	}
883 
884 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
885 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
886 	}
887 
888 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
889 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
890 	}
891 
892 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
893 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
894 	}
895 
896 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
897 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
898 	}
899 
900 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
901 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
902 	}
903 
904 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
905 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
906 	}
907 
908 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
909 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
910 	}
911 
912 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
913 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
914 	}
915 
916 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
917 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
918 	}
919 
920 	function log(uint p0, string memory p1, address p2, address p3) internal view {
921 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
922 	}
923 
924 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
925 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
926 	}
927 
928 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
929 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
930 	}
931 
932 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
933 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
934 	}
935 
936 	function log(uint p0, bool p1, uint p2, address p3) internal view {
937 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
938 	}
939 
940 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
941 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
942 	}
943 
944 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
945 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
946 	}
947 
948 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
949 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
950 	}
951 
952 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
953 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
954 	}
955 
956 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
957 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
958 	}
959 
960 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
961 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
962 	}
963 
964 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
965 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
966 	}
967 
968 	function log(uint p0, bool p1, bool p2, address p3) internal view {
969 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
970 	}
971 
972 	function log(uint p0, bool p1, address p2, uint p3) internal view {
973 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
974 	}
975 
976 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
977 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
978 	}
979 
980 	function log(uint p0, bool p1, address p2, bool p3) internal view {
981 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
982 	}
983 
984 	function log(uint p0, bool p1, address p2, address p3) internal view {
985 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
986 	}
987 
988 	function log(uint p0, address p1, uint p2, uint p3) internal view {
989 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
990 	}
991 
992 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
993 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
994 	}
995 
996 	function log(uint p0, address p1, uint p2, bool p3) internal view {
997 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
998 	}
999 
1000 	function log(uint p0, address p1, uint p2, address p3) internal view {
1001 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1002 	}
1003 
1004 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1005 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1006 	}
1007 
1008 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1009 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1010 	}
1011 
1012 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1013 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1014 	}
1015 
1016 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1017 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1018 	}
1019 
1020 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1021 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1022 	}
1023 
1024 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1025 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1026 	}
1027 
1028 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1029 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1030 	}
1031 
1032 	function log(uint p0, address p1, bool p2, address p3) internal view {
1033 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1034 	}
1035 
1036 	function log(uint p0, address p1, address p2, uint p3) internal view {
1037 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1038 	}
1039 
1040 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1041 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1042 	}
1043 
1044 	function log(uint p0, address p1, address p2, bool p3) internal view {
1045 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1046 	}
1047 
1048 	function log(uint p0, address p1, address p2, address p3) internal view {
1049 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1050 	}
1051 
1052 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1053 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1054 	}
1055 
1056 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1057 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1058 	}
1059 
1060 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1061 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1062 	}
1063 
1064 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1065 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1066 	}
1067 
1068 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1069 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1070 	}
1071 
1072 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1073 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1074 	}
1075 
1076 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1077 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1078 	}
1079 
1080 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1081 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1082 	}
1083 
1084 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1085 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1086 	}
1087 
1088 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1089 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1090 	}
1091 
1092 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1093 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1094 	}
1095 
1096 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1097 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1098 	}
1099 
1100 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1101 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1102 	}
1103 
1104 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1105 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1106 	}
1107 
1108 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1109 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1110 	}
1111 
1112 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1113 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1114 	}
1115 
1116 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1117 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1118 	}
1119 
1120 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1121 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1122 	}
1123 
1124 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1125 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1126 	}
1127 
1128 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1129 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1130 	}
1131 
1132 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1133 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1134 	}
1135 
1136 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1137 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1138 	}
1139 
1140 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1141 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1142 	}
1143 
1144 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1145 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1146 	}
1147 
1148 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1149 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1150 	}
1151 
1152 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1153 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1154 	}
1155 
1156 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1157 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1158 	}
1159 
1160 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1161 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1162 	}
1163 
1164 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1165 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1166 	}
1167 
1168 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1169 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1170 	}
1171 
1172 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1173 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1174 	}
1175 
1176 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
1177 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1178 	}
1179 
1180 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
1181 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
1182 	}
1183 
1184 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
1185 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
1186 	}
1187 
1188 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
1189 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
1190 	}
1191 
1192 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
1193 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
1194 	}
1195 
1196 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
1197 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
1198 	}
1199 
1200 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1201 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1202 	}
1203 
1204 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1205 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1206 	}
1207 
1208 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1209 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1210 	}
1211 
1212 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
1213 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
1214 	}
1215 
1216 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1217 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1218 	}
1219 
1220 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1221 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1222 	}
1223 
1224 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
1225 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1226 	}
1227 
1228 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
1229 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1230 	}
1231 
1232 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1233 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1234 	}
1235 
1236 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1237 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1238 	}
1239 
1240 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1241 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1242 	}
1243 
1244 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
1245 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
1246 	}
1247 
1248 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1249 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1250 	}
1251 
1252 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1253 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1254 	}
1255 
1256 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1257 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1258 	}
1259 
1260 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1261 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1262 	}
1263 
1264 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1265 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1266 	}
1267 
1268 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1269 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1270 	}
1271 
1272 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1273 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1274 	}
1275 
1276 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1277 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1278 	}
1279 
1280 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1281 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1282 	}
1283 
1284 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1285 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1286 	}
1287 
1288 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1289 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1290 	}
1291 
1292 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1293 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1294 	}
1295 
1296 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1297 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1298 	}
1299 
1300 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1301 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1302 	}
1303 
1304 	function log(string memory p0, address p1, address p2, address p3) internal view {
1305 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1306 	}
1307 
1308 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1309 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1310 	}
1311 
1312 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1313 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1314 	}
1315 
1316 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1317 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1318 	}
1319 
1320 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1321 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1322 	}
1323 
1324 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1325 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1326 	}
1327 
1328 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1329 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1330 	}
1331 
1332 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1333 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1334 	}
1335 
1336 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1337 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1338 	}
1339 
1340 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1341 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1342 	}
1343 
1344 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1345 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1346 	}
1347 
1348 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1349 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1350 	}
1351 
1352 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1353 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1354 	}
1355 
1356 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1357 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1358 	}
1359 
1360 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1361 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1362 	}
1363 
1364 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1365 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1366 	}
1367 
1368 	function log(bool p0, uint p1, address p2, address p3) internal view {
1369 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1370 	}
1371 
1372 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1373 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1374 	}
1375 
1376 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1377 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1378 	}
1379 
1380 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1381 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1382 	}
1383 
1384 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1385 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1386 	}
1387 
1388 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1389 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1390 	}
1391 
1392 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1393 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1394 	}
1395 
1396 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1397 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1398 	}
1399 
1400 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1401 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1402 	}
1403 
1404 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1405 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1406 	}
1407 
1408 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1409 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1410 	}
1411 
1412 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1413 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1414 	}
1415 
1416 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1417 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1418 	}
1419 
1420 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1421 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1422 	}
1423 
1424 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1425 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1426 	}
1427 
1428 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1429 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1430 	}
1431 
1432 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1433 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1434 	}
1435 
1436 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1437 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1438 	}
1439 
1440 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1441 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1442 	}
1443 
1444 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1445 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1446 	}
1447 
1448 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1449 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1450 	}
1451 
1452 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1453 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1454 	}
1455 
1456 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1457 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1458 	}
1459 
1460 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1461 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1462 	}
1463 
1464 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1465 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1466 	}
1467 
1468 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1469 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1470 	}
1471 
1472 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1473 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1474 	}
1475 
1476 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1477 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1478 	}
1479 
1480 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1481 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1482 	}
1483 
1484 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1485 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1486 	}
1487 
1488 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1489 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1490 	}
1491 
1492 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1493 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1494 	}
1495 
1496 	function log(bool p0, bool p1, address p2, address p3) internal view {
1497 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1498 	}
1499 
1500 	function log(bool p0, address p1, uint p2, uint p3) internal view {
1501 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
1502 	}
1503 
1504 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
1505 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
1506 	}
1507 
1508 	function log(bool p0, address p1, uint p2, bool p3) internal view {
1509 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
1510 	}
1511 
1512 	function log(bool p0, address p1, uint p2, address p3) internal view {
1513 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
1514 	}
1515 
1516 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
1517 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
1518 	}
1519 
1520 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1521 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1522 	}
1523 
1524 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1525 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1526 	}
1527 
1528 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1529 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1530 	}
1531 
1532 	function log(bool p0, address p1, bool p2, uint p3) internal view {
1533 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
1534 	}
1535 
1536 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1537 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1538 	}
1539 
1540 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1541 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1542 	}
1543 
1544 	function log(bool p0, address p1, bool p2, address p3) internal view {
1545 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1546 	}
1547 
1548 	function log(bool p0, address p1, address p2, uint p3) internal view {
1549 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
1550 	}
1551 
1552 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1553 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1554 	}
1555 
1556 	function log(bool p0, address p1, address p2, bool p3) internal view {
1557 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1558 	}
1559 
1560 	function log(bool p0, address p1, address p2, address p3) internal view {
1561 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1562 	}
1563 
1564 	function log(address p0, uint p1, uint p2, uint p3) internal view {
1565 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
1566 	}
1567 
1568 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
1569 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
1570 	}
1571 
1572 	function log(address p0, uint p1, uint p2, bool p3) internal view {
1573 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
1574 	}
1575 
1576 	function log(address p0, uint p1, uint p2, address p3) internal view {
1577 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
1578 	}
1579 
1580 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
1581 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
1582 	}
1583 
1584 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
1585 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
1586 	}
1587 
1588 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
1589 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
1590 	}
1591 
1592 	function log(address p0, uint p1, string memory p2, address p3) internal view {
1593 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
1594 	}
1595 
1596 	function log(address p0, uint p1, bool p2, uint p3) internal view {
1597 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
1598 	}
1599 
1600 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
1601 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
1602 	}
1603 
1604 	function log(address p0, uint p1, bool p2, bool p3) internal view {
1605 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
1606 	}
1607 
1608 	function log(address p0, uint p1, bool p2, address p3) internal view {
1609 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
1610 	}
1611 
1612 	function log(address p0, uint p1, address p2, uint p3) internal view {
1613 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
1614 	}
1615 
1616 	function log(address p0, uint p1, address p2, string memory p3) internal view {
1617 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
1618 	}
1619 
1620 	function log(address p0, uint p1, address p2, bool p3) internal view {
1621 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
1622 	}
1623 
1624 	function log(address p0, uint p1, address p2, address p3) internal view {
1625 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
1626 	}
1627 
1628 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
1629 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
1630 	}
1631 
1632 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
1633 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
1634 	}
1635 
1636 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
1637 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
1638 	}
1639 
1640 	function log(address p0, string memory p1, uint p2, address p3) internal view {
1641 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
1642 	}
1643 
1644 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
1645 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
1646 	}
1647 
1648 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
1649 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
1650 	}
1651 
1652 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
1653 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
1654 	}
1655 
1656 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
1657 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
1658 	}
1659 
1660 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
1661 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
1662 	}
1663 
1664 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
1665 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
1666 	}
1667 
1668 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
1669 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
1670 	}
1671 
1672 	function log(address p0, string memory p1, bool p2, address p3) internal view {
1673 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
1674 	}
1675 
1676 	function log(address p0, string memory p1, address p2, uint p3) internal view {
1677 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
1678 	}
1679 
1680 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
1681 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
1682 	}
1683 
1684 	function log(address p0, string memory p1, address p2, bool p3) internal view {
1685 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
1686 	}
1687 
1688 	function log(address p0, string memory p1, address p2, address p3) internal view {
1689 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
1690 	}
1691 
1692 	function log(address p0, bool p1, uint p2, uint p3) internal view {
1693 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
1694 	}
1695 
1696 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
1697 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
1698 	}
1699 
1700 	function log(address p0, bool p1, uint p2, bool p3) internal view {
1701 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
1702 	}
1703 
1704 	function log(address p0, bool p1, uint p2, address p3) internal view {
1705 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
1706 	}
1707 
1708 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
1709 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
1710 	}
1711 
1712 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
1713 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
1714 	}
1715 
1716 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
1717 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
1718 	}
1719 
1720 	function log(address p0, bool p1, string memory p2, address p3) internal view {
1721 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
1722 	}
1723 
1724 	function log(address p0, bool p1, bool p2, uint p3) internal view {
1725 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
1726 	}
1727 
1728 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
1729 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
1730 	}
1731 
1732 	function log(address p0, bool p1, bool p2, bool p3) internal view {
1733 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
1734 	}
1735 
1736 	function log(address p0, bool p1, bool p2, address p3) internal view {
1737 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
1738 	}
1739 
1740 	function log(address p0, bool p1, address p2, uint p3) internal view {
1741 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
1742 	}
1743 
1744 	function log(address p0, bool p1, address p2, string memory p3) internal view {
1745 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
1746 	}
1747 
1748 	function log(address p0, bool p1, address p2, bool p3) internal view {
1749 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
1750 	}
1751 
1752 	function log(address p0, bool p1, address p2, address p3) internal view {
1753 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
1754 	}
1755 
1756 	function log(address p0, address p1, uint p2, uint p3) internal view {
1757 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
1758 	}
1759 
1760 	function log(address p0, address p1, uint p2, string memory p3) internal view {
1761 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
1762 	}
1763 
1764 	function log(address p0, address p1, uint p2, bool p3) internal view {
1765 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
1766 	}
1767 
1768 	function log(address p0, address p1, uint p2, address p3) internal view {
1769 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
1770 	}
1771 
1772 	function log(address p0, address p1, string memory p2, uint p3) internal view {
1773 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
1774 	}
1775 
1776 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
1777 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
1778 	}
1779 
1780 	function log(address p0, address p1, string memory p2, bool p3) internal view {
1781 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
1782 	}
1783 
1784 	function log(address p0, address p1, string memory p2, address p3) internal view {
1785 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
1786 	}
1787 
1788 	function log(address p0, address p1, bool p2, uint p3) internal view {
1789 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
1790 	}
1791 
1792 	function log(address p0, address p1, bool p2, string memory p3) internal view {
1793 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
1794 	}
1795 
1796 	function log(address p0, address p1, bool p2, bool p3) internal view {
1797 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
1798 	}
1799 
1800 	function log(address p0, address p1, bool p2, address p3) internal view {
1801 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
1802 	}
1803 
1804 	function log(address p0, address p1, address p2, uint p3) internal view {
1805 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
1806 	}
1807 
1808 	function log(address p0, address p1, address p2, string memory p3) internal view {
1809 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
1810 	}
1811 
1812 	function log(address p0, address p1, address p2, bool p3) internal view {
1813 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
1814 	}
1815 
1816 	function log(address p0, address p1, address p2, address p3) internal view {
1817 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
1818 	}
1819 
1820 }
1821 
1822 // File: @openzeppelin/contracts/utils/Context.sol
1823 
1824 
1825 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1826 
1827 pragma solidity ^0.8.0;
1828 
1829 /**
1830  * @dev Provides information about the current execution context, including the
1831  * sender of the transaction and its data. While these are generally available
1832  * via msg.sender and msg.data, they should not be accessed in such a direct
1833  * manner, since when dealing with meta-transactions the account sending and
1834  * paying for execution may not be the actual sender (as far as an application
1835  * is concerned).
1836  *
1837  * This contract is only required for intermediate, library-like contracts.
1838  */
1839 abstract contract Context {
1840     function _msgSender() internal view virtual returns (address) {
1841         return msg.sender;
1842     }
1843 
1844     function _msgData() internal view virtual returns (bytes calldata) {
1845         return msg.data;
1846     }
1847 }
1848 
1849 // File: @openzeppelin/contracts/access/Ownable.sol
1850 
1851 
1852 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1853 
1854 pragma solidity ^0.8.0;
1855 
1856 
1857 /**
1858  * @dev Contract module which provides a basic access control mechanism, where
1859  * there is an account (an owner) that can be granted exclusive access to
1860  * specific functions.
1861  *
1862  * By default, the owner account will be the one that deploys the contract. This
1863  * can later be changed with {transferOwnership}.
1864  *
1865  * This module is used through inheritance. It will make available the modifier
1866  * `onlyOwner`, which can be applied to your functions to restrict their use to
1867  * the owner.
1868  */
1869 abstract contract Ownable is Context {
1870     address private _owner;
1871 
1872     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1873 
1874     /**
1875      * @dev Initializes the contract setting the deployer as the initial owner.
1876      */
1877     constructor() {
1878         _transferOwnership(_msgSender());
1879     }
1880 
1881     /**
1882      * @dev Throws if called by any account other than the owner.
1883      */
1884     modifier onlyOwner() {
1885         _checkOwner();
1886         _;
1887     }
1888 
1889     /**
1890      * @dev Returns the address of the current owner.
1891      */
1892     function owner() public view virtual returns (address) {
1893         return _owner;
1894     }
1895 
1896     /**
1897      * @dev Throws if the sender is not the owner.
1898      */
1899     function _checkOwner() internal view virtual {
1900         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1901     }
1902 
1903     /**
1904      * @dev Leaves the contract without owner. It will not be possible to call
1905      * `onlyOwner` functions anymore. Can only be called by the current owner.
1906      *
1907      * NOTE: Renouncing ownership will leave the contract without an owner,
1908      * thereby removing any functionality that is only available to the owner.
1909      */
1910     function renounceOwnership() public virtual onlyOwner {
1911         _transferOwnership(address(0));
1912     }
1913 
1914     /**
1915      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1916      * Can only be called by the current owner.
1917      */
1918     function transferOwnership(address newOwner) public virtual onlyOwner {
1919         require(newOwner != address(0), "Ownable: new owner is the zero address");
1920         _transferOwnership(newOwner);
1921     }
1922 
1923     /**
1924      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1925      * Internal function without access restriction.
1926      */
1927     function _transferOwnership(address newOwner) internal virtual {
1928         address oldOwner = _owner;
1929         _owner = newOwner;
1930         emit OwnershipTransferred(oldOwner, newOwner);
1931     }
1932 }
1933 
1934 // File: erc721a/contracts/IERC721A.sol
1935 
1936 
1937 // ERC721A Contracts v4.1.0
1938 // Creator: Chiru Labs
1939 
1940 pragma solidity ^0.8.4;
1941 
1942 /**
1943  * @dev Interface of an ERC721A compliant contract.
1944  */
1945 interface IERC721A {
1946     /**
1947      * The caller must own the token or be an approved operator.
1948      */
1949     error ApprovalCallerNotOwnerNorApproved();
1950 
1951     /**
1952      * The token does not exist.
1953      */
1954     error ApprovalQueryForNonexistentToken();
1955 
1956     /**
1957      * The caller cannot approve to their own address.
1958      */
1959     error ApproveToCaller();
1960 
1961     /**
1962      * Cannot query the balance for the zero address.
1963      */
1964     error BalanceQueryForZeroAddress();
1965 
1966     /**
1967      * Cannot mint to the zero address.
1968      */
1969     error MintToZeroAddress();
1970 
1971     /**
1972      * The quantity of tokens minted must be more than zero.
1973      */
1974     error MintZeroQuantity();
1975 
1976     /**
1977      * The token does not exist.
1978      */
1979     error OwnerQueryForNonexistentToken();
1980 
1981     /**
1982      * The caller must own the token or be an approved operator.
1983      */
1984     error TransferCallerNotOwnerNorApproved();
1985 
1986     /**
1987      * The token must be owned by `from`.
1988      */
1989     error TransferFromIncorrectOwner();
1990 
1991     /**
1992      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
1993      */
1994     error TransferToNonERC721ReceiverImplementer();
1995 
1996     /**
1997      * Cannot transfer to the zero address.
1998      */
1999     error TransferToZeroAddress();
2000 
2001     /**
2002      * The token does not exist.
2003      */
2004     error URIQueryForNonexistentToken();
2005 
2006     /**
2007      * The `quantity` minted with ERC2309 exceeds the safety limit.
2008      */
2009     error MintERC2309QuantityExceedsLimit();
2010 
2011     /**
2012      * The `extraData` cannot be set on an unintialized ownership slot.
2013      */
2014     error OwnershipNotInitializedForExtraData();
2015 
2016     struct TokenOwnership {
2017         // The address of the owner.
2018         address addr;
2019         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
2020         uint64 startTimestamp;
2021         // Whether the token has been burned.
2022         bool burned;
2023         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
2024         uint24 extraData;
2025     }
2026 
2027     /**
2028      * @dev Returns the total amount of tokens stored by the contract.
2029      *
2030      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
2031      */
2032     function totalSupply() external view returns (uint256);
2033 
2034     // ==============================
2035     //            IERC165
2036     // ==============================
2037 
2038     /**
2039      * @dev Returns true if this contract implements the interface defined by
2040      * `interfaceId`. See the corresponding
2041      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2042      * to learn more about how these ids are created.
2043      *
2044      * This function call must use less than 30 000 gas.
2045      */
2046     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2047 
2048     // ==============================
2049     //            IERC721
2050     // ==============================
2051 
2052     /**
2053      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2054      */
2055     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
2056 
2057     /**
2058      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2059      */
2060     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
2061 
2062     /**
2063      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2064      */
2065     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
2066 
2067     /**
2068      * @dev Returns the number of tokens in ``owner``'s account.
2069      */
2070     function balanceOf(address owner) external view returns (uint256 balance);
2071 
2072     /**
2073      * @dev Returns the owner of the `tokenId` token.
2074      *
2075      * Requirements:
2076      *
2077      * - `tokenId` must exist.
2078      */
2079     function ownerOf(uint256 tokenId) external view returns (address owner);
2080 
2081     /**
2082      * @dev Safely transfers `tokenId` token from `from` to `to`.
2083      *
2084      * Requirements:
2085      *
2086      * - `from` cannot be the zero address.
2087      * - `to` cannot be the zero address.
2088      * - `tokenId` token must exist and be owned by `from`.
2089      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2090      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2091      *
2092      * Emits a {Transfer} event.
2093      */
2094     function safeTransferFrom(
2095         address from,
2096         address to,
2097         uint256 tokenId,
2098         bytes calldata data
2099     ) external;
2100 
2101     /**
2102      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2103      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2104      *
2105      * Requirements:
2106      *
2107      * - `from` cannot be the zero address.
2108      * - `to` cannot be the zero address.
2109      * - `tokenId` token must exist and be owned by `from`.
2110      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
2111      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2112      *
2113      * Emits a {Transfer} event.
2114      */
2115     function safeTransferFrom(
2116         address from,
2117         address to,
2118         uint256 tokenId
2119     ) external;
2120 
2121     /**
2122      * @dev Transfers `tokenId` token from `from` to `to`.
2123      *
2124      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
2125      *
2126      * Requirements:
2127      *
2128      * - `from` cannot be the zero address.
2129      * - `to` cannot be the zero address.
2130      * - `tokenId` token must be owned by `from`.
2131      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2132      *
2133      * Emits a {Transfer} event.
2134      */
2135     function transferFrom(
2136         address from,
2137         address to,
2138         uint256 tokenId
2139     ) external;
2140 
2141     /**
2142      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2143      * The approval is cleared when the token is transferred.
2144      *
2145      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2146      *
2147      * Requirements:
2148      *
2149      * - The caller must own the token or be an approved operator.
2150      * - `tokenId` must exist.
2151      *
2152      * Emits an {Approval} event.
2153      */
2154     function approve(address to, uint256 tokenId) external;
2155 
2156     /**
2157      * @dev Approve or remove `operator` as an operator for the caller.
2158      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2159      *
2160      * Requirements:
2161      *
2162      * - The `operator` cannot be the caller.
2163      *
2164      * Emits an {ApprovalForAll} event.
2165      */
2166     function setApprovalForAll(address operator, bool _approved) external;
2167 
2168     /**
2169      * @dev Returns the account approved for `tokenId` token.
2170      *
2171      * Requirements:
2172      *
2173      * - `tokenId` must exist.
2174      */
2175     function getApproved(uint256 tokenId) external view returns (address operator);
2176 
2177     /**
2178      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2179      *
2180      * See {setApprovalForAll}
2181      */
2182     function isApprovedForAll(address owner, address operator) external view returns (bool);
2183 
2184     // ==============================
2185     //        IERC721Metadata
2186     // ==============================
2187 
2188     /**
2189      * @dev Returns the token collection name.
2190      */
2191     function name() external view returns (string memory);
2192 
2193     /**
2194      * @dev Returns the token collection symbol.
2195      */
2196     function symbol() external view returns (string memory);
2197 
2198     /**
2199      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2200      */
2201     function tokenURI(uint256 tokenId) external view returns (string memory);
2202 
2203     // ==============================
2204     //            IERC2309
2205     // ==============================
2206 
2207     /**
2208      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
2209      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
2210      */
2211     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
2212 }
2213 
2214 // File: erc721a/contracts/ERC721A.sol
2215 
2216 
2217 // ERC721A Contracts v4.1.0
2218 // Creator: Chiru Labs
2219 
2220 pragma solidity ^0.8.4;
2221 
2222 
2223 /**
2224  * @dev ERC721 token receiver interface.
2225  */
2226 interface ERC721A__IERC721Receiver {
2227     function onERC721Received(
2228         address operator,
2229         address from,
2230         uint256 tokenId,
2231         bytes calldata data
2232     ) external returns (bytes4);
2233 }
2234 
2235 /**
2236  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
2237  * including the Metadata extension. Built to optimize for lower gas during batch mints.
2238  *
2239  * Assumes serials are sequentially minted starting at `_startTokenId()`
2240  * (defaults to 0, e.g. 0, 1, 2, 3..).
2241  *
2242  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2243  *
2244  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
2245  */
2246 contract ERC721A is IERC721A {
2247     // Mask of an entry in packed address data.
2248     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
2249 
2250     // The bit position of `numberMinted` in packed address data.
2251     uint256 private constant BITPOS_NUMBER_MINTED = 64;
2252 
2253     // The bit position of `numberBurned` in packed address data.
2254     uint256 private constant BITPOS_NUMBER_BURNED = 128;
2255 
2256     // The bit position of `aux` in packed address data.
2257     uint256 private constant BITPOS_AUX = 192;
2258 
2259     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
2260     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
2261 
2262     // The bit position of `startTimestamp` in packed ownership.
2263     uint256 private constant BITPOS_START_TIMESTAMP = 160;
2264 
2265     // The bit mask of the `burned` bit in packed ownership.
2266     uint256 private constant BITMASK_BURNED = 1 << 224;
2267 
2268     // The bit position of the `nextInitialized` bit in packed ownership.
2269     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
2270 
2271     // The bit mask of the `nextInitialized` bit in packed ownership.
2272     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
2273 
2274     // The bit position of `extraData` in packed ownership.
2275     uint256 private constant BITPOS_EXTRA_DATA = 232;
2276 
2277     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
2278     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
2279 
2280     // The mask of the lower 160 bits for addresses.
2281     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
2282 
2283     // The maximum `quantity` that can be minted with `_mintERC2309`.
2284     // This limit is to prevent overflows on the address data entries.
2285     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
2286     // is required to cause an overflow, which is unrealistic.
2287     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
2288 
2289     // The tokenId of the next token to be minted.
2290     uint256 private _currentIndex;
2291 
2292     // The number of tokens burned.
2293     uint256 private _burnCounter;
2294 
2295     // Token name
2296     string private _name;
2297 
2298     // Token symbol
2299     string private _symbol;
2300 
2301     // Mapping from token ID to ownership details
2302     // An empty struct value does not necessarily mean the token is unowned.
2303     // See `_packedOwnershipOf` implementation for details.
2304     //
2305     // Bits Layout:
2306     // - [0..159]   `addr`
2307     // - [160..223] `startTimestamp`
2308     // - [224]      `burned`
2309     // - [225]      `nextInitialized`
2310     // - [232..255] `extraData`
2311     mapping(uint256 => uint256) private _packedOwnerships;
2312 
2313     // Mapping owner address to address data.
2314     //
2315     // Bits Layout:
2316     // - [0..63]    `balance`
2317     // - [64..127]  `numberMinted`
2318     // - [128..191] `numberBurned`
2319     // - [192..255] `aux`
2320     mapping(address => uint256) private _packedAddressData;
2321 
2322     // Mapping from token ID to approved address.
2323     mapping(uint256 => address) private _tokenApprovals;
2324 
2325     // Mapping from owner to operator approvals
2326     mapping(address => mapping(address => bool)) private _operatorApprovals;
2327 
2328     constructor(string memory name_, string memory symbol_) {
2329         _name = name_;
2330         _symbol = symbol_;
2331         _currentIndex = _startTokenId();
2332     }
2333 
2334     /**
2335      * @dev Returns the starting token ID.
2336      * To change the starting token ID, please override this function.
2337      */
2338     function _startTokenId() internal view virtual returns (uint256) {
2339         return 0;
2340     }
2341 
2342     /**
2343      * @dev Returns the next token ID to be minted.
2344      */
2345     function _nextTokenId() internal view returns (uint256) {
2346         return _currentIndex;
2347     }
2348 
2349     /**
2350      * @dev Returns the total number of tokens in existence.
2351      * Burned tokens will reduce the count.
2352      * To get the total number of tokens minted, please see `_totalMinted`.
2353      */
2354     function totalSupply() public view override returns (uint256) {
2355         // Counter underflow is impossible as _burnCounter cannot be incremented
2356         // more than `_currentIndex - _startTokenId()` times.
2357         unchecked {
2358             return _currentIndex - _burnCounter - _startTokenId();
2359         }
2360     }
2361 
2362     /**
2363      * @dev Returns the total amount of tokens minted in the contract.
2364      */
2365     function _totalMinted() internal view returns (uint256) {
2366         // Counter underflow is impossible as _currentIndex does not decrement,
2367         // and it is initialized to `_startTokenId()`
2368         unchecked {
2369             return _currentIndex - _startTokenId();
2370         }
2371     }
2372 
2373     /**
2374      * @dev Returns the total number of tokens burned.
2375      */
2376     function _totalBurned() internal view returns (uint256) {
2377         return _burnCounter;
2378     }
2379 
2380     /**
2381      * @dev See {IERC165-supportsInterface}.
2382      */
2383     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2384         // The interface IDs are constants representing the first 4 bytes of the XOR of
2385         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
2386         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
2387         return
2388             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
2389             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
2390             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
2391     }
2392 
2393     /**
2394      * @dev See {IERC721-balanceOf}.
2395      */
2396     function balanceOf(address owner) public view override returns (uint256) {
2397         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2398         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
2399     }
2400 
2401     /**
2402      * Returns the number of tokens minted by `owner`.
2403      */
2404     function _numberMinted(address owner) internal view returns (uint256) {
2405         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
2406     }
2407 
2408     /**
2409      * Returns the number of tokens burned by or on behalf of `owner`.
2410      */
2411     function _numberBurned(address owner) internal view returns (uint256) {
2412         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
2413     }
2414 
2415     /**
2416      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2417      */
2418     function _getAux(address owner) internal view returns (uint64) {
2419         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
2420     }
2421 
2422     /**
2423      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2424      * If there are multiple variables, please pack them into a uint64.
2425      */
2426     function _setAux(address owner, uint64 aux) internal {
2427         uint256 packed = _packedAddressData[owner];
2428         uint256 auxCasted;
2429         // Cast `aux` with assembly to avoid redundant masking.
2430         assembly {
2431             auxCasted := aux
2432         }
2433         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
2434         _packedAddressData[owner] = packed;
2435     }
2436 
2437     /**
2438      * Returns the packed ownership data of `tokenId`.
2439      */
2440     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
2441         uint256 curr = tokenId;
2442 
2443         unchecked {
2444             if (_startTokenId() <= curr)
2445                 if (curr < _currentIndex) {
2446                     uint256 packed = _packedOwnerships[curr];
2447                     // If not burned.
2448                     if (packed & BITMASK_BURNED == 0) {
2449                         // Invariant:
2450                         // There will always be an ownership that has an address and is not burned
2451                         // before an ownership that does not have an address and is not burned.
2452                         // Hence, curr will not underflow.
2453                         //
2454                         // We can directly compare the packed value.
2455                         // If the address is zero, packed is zero.
2456                         while (packed == 0) {
2457                             packed = _packedOwnerships[--curr];
2458                         }
2459                         return packed;
2460                     }
2461                 }
2462         }
2463         revert OwnerQueryForNonexistentToken();
2464     }
2465 
2466     /**
2467      * Returns the unpacked `TokenOwnership` struct from `packed`.
2468      */
2469     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2470         ownership.addr = address(uint160(packed));
2471         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
2472         ownership.burned = packed & BITMASK_BURNED != 0;
2473         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
2474     }
2475 
2476     /**
2477      * Returns the unpacked `TokenOwnership` struct at `index`.
2478      */
2479     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
2480         return _unpackedOwnership(_packedOwnerships[index]);
2481     }
2482 
2483     /**
2484      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
2485      */
2486     function _initializeOwnershipAt(uint256 index) internal {
2487         if (_packedOwnerships[index] == 0) {
2488             _packedOwnerships[index] = _packedOwnershipOf(index);
2489         }
2490     }
2491 
2492     /**
2493      * Gas spent here starts off proportional to the maximum mint batch size.
2494      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
2495      */
2496     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
2497         return _unpackedOwnership(_packedOwnershipOf(tokenId));
2498     }
2499 
2500     /**
2501      * @dev Packs ownership data into a single uint256.
2502      */
2503     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2504         assembly {
2505             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2506             owner := and(owner, BITMASK_ADDRESS)
2507             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
2508             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
2509         }
2510     }
2511 
2512     /**
2513      * @dev See {IERC721-ownerOf}.
2514      */
2515     function ownerOf(uint256 tokenId) public view override returns (address) {
2516         return address(uint160(_packedOwnershipOf(tokenId)));
2517     }
2518 
2519     /**
2520      * @dev See {IERC721Metadata-name}.
2521      */
2522     function name() public view virtual override returns (string memory) {
2523         return _name;
2524     }
2525 
2526     /**
2527      * @dev See {IERC721Metadata-symbol}.
2528      */
2529     function symbol() public view virtual override returns (string memory) {
2530         return _symbol;
2531     }
2532 
2533     /**
2534      * @dev See {IERC721Metadata-tokenURI}.
2535      */
2536     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2537         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2538 
2539         string memory baseURI = _baseURI();
2540         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
2541     }
2542 
2543     /**
2544      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2545      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2546      * by default, it can be overridden in child contracts.
2547      */
2548     function _baseURI() internal view virtual returns (string memory) {
2549         return '';
2550     }
2551 
2552     /**
2553      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2554      */
2555     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2556         // For branchless setting of the `nextInitialized` flag.
2557         assembly {
2558             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
2559             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2560         }
2561     }
2562 
2563     /**
2564      * @dev See {IERC721-approve}.
2565      */
2566     function approve(address to, uint256 tokenId) public override {
2567         address owner = ownerOf(tokenId);
2568 
2569         if (_msgSenderERC721A() != owner)
2570             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2571                 revert ApprovalCallerNotOwnerNorApproved();
2572             }
2573 
2574         _tokenApprovals[tokenId] = to;
2575         emit Approval(owner, to, tokenId);
2576     }
2577 
2578     /**
2579      * @dev See {IERC721-getApproved}.
2580      */
2581     function getApproved(uint256 tokenId) public view override returns (address) {
2582         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2583 
2584         return _tokenApprovals[tokenId];
2585     }
2586 
2587     /**
2588      * @dev See {IERC721-setApprovalForAll}.
2589      */
2590     function setApprovalForAll(address operator, bool approved) public virtual override {
2591         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
2592 
2593         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2594         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2595     }
2596 
2597     /**
2598      * @dev See {IERC721-isApprovedForAll}.
2599      */
2600     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2601         return _operatorApprovals[owner][operator];
2602     }
2603 
2604     /**
2605      * @dev See {IERC721-safeTransferFrom}.
2606      */
2607     function safeTransferFrom(
2608         address from,
2609         address to,
2610         uint256 tokenId
2611     ) public virtual override {
2612         safeTransferFrom(from, to, tokenId, '');
2613     }
2614 
2615     /**
2616      * @dev See {IERC721-safeTransferFrom}.
2617      */
2618     function safeTransferFrom(
2619         address from,
2620         address to,
2621         uint256 tokenId,
2622         bytes memory _data
2623     ) public virtual override {
2624         transferFrom(from, to, tokenId);
2625         if (to.code.length != 0)
2626             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2627                 revert TransferToNonERC721ReceiverImplementer();
2628             }
2629     }
2630 
2631     /**
2632      * @dev Returns whether `tokenId` exists.
2633      *
2634      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2635      *
2636      * Tokens start existing when they are minted (`_mint`),
2637      */
2638     function _exists(uint256 tokenId) internal view returns (bool) {
2639         return
2640             _startTokenId() <= tokenId &&
2641             tokenId < _currentIndex && // If within bounds,
2642             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
2643     }
2644 
2645     /**
2646      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2647      */
2648     function _safeMint(address to, uint256 quantity) internal {
2649         _safeMint(to, quantity, '');
2650     }
2651 
2652     /**
2653      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2654      *
2655      * Requirements:
2656      *
2657      * - If `to` refers to a smart contract, it must implement
2658      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2659      * - `quantity` must be greater than 0.
2660      *
2661      * See {_mint}.
2662      *
2663      * Emits a {Transfer} event for each mint.
2664      */
2665     function _safeMint(
2666         address to,
2667         uint256 quantity,
2668         bytes memory _data
2669     ) internal {
2670         _mint(to, quantity);
2671 
2672         unchecked {
2673             if (to.code.length != 0) {
2674                 uint256 end = _currentIndex;
2675                 uint256 index = end - quantity;
2676                 do {
2677                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2678                         revert TransferToNonERC721ReceiverImplementer();
2679                     }
2680                 } while (index < end);
2681                 // Reentrancy protection.
2682                 if (_currentIndex != end) revert();
2683             }
2684         }
2685     }
2686 
2687     /**
2688      * @dev Mints `quantity` tokens and transfers them to `to`.
2689      *
2690      * Requirements:
2691      *
2692      * - `to` cannot be the zero address.
2693      * - `quantity` must be greater than 0.
2694      *
2695      * Emits a {Transfer} event for each mint.
2696      */
2697     function _mint(address to, uint256 quantity) internal {
2698         uint256 startTokenId = _currentIndex;
2699         if (to == address(0)) revert MintToZeroAddress();
2700         if (quantity == 0) revert MintZeroQuantity();
2701 
2702         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2703 
2704         // Overflows are incredibly unrealistic.
2705         // `balance` and `numberMinted` have a maximum limit of 2**64.
2706         // `tokenId` has a maximum limit of 2**256.
2707         unchecked {
2708             // Updates:
2709             // - `balance += quantity`.
2710             // - `numberMinted += quantity`.
2711             //
2712             // We can directly add to the `balance` and `numberMinted`.
2713             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
2714 
2715             // Updates:
2716             // - `address` to the owner.
2717             // - `startTimestamp` to the timestamp of minting.
2718             // - `burned` to `false`.
2719             // - `nextInitialized` to `quantity == 1`.
2720             _packedOwnerships[startTokenId] = _packOwnershipData(
2721                 to,
2722                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2723             );
2724 
2725             uint256 tokenId = startTokenId;
2726             uint256 end = startTokenId + quantity;
2727             do {
2728                 emit Transfer(address(0), to, tokenId++);
2729             } while (tokenId < end);
2730 
2731             _currentIndex = end;
2732         }
2733         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2734     }
2735 
2736     /**
2737      * @dev Mints `quantity` tokens and transfers them to `to`.
2738      *
2739      * This function is intended for efficient minting only during contract creation.
2740      *
2741      * It emits only one {ConsecutiveTransfer} as defined in
2742      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2743      * instead of a sequence of {Transfer} event(s).
2744      *
2745      * Calling this function outside of contract creation WILL make your contract
2746      * non-compliant with the ERC721 standard.
2747      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2748      * {ConsecutiveTransfer} event is only permissible during contract creation.
2749      *
2750      * Requirements:
2751      *
2752      * - `to` cannot be the zero address.
2753      * - `quantity` must be greater than 0.
2754      *
2755      * Emits a {ConsecutiveTransfer} event.
2756      */
2757     function _mintERC2309(address to, uint256 quantity) internal {
2758         uint256 startTokenId = _currentIndex;
2759         if (to == address(0)) revert MintToZeroAddress();
2760         if (quantity == 0) revert MintZeroQuantity();
2761         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2762 
2763         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2764 
2765         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2766         unchecked {
2767             // Updates:
2768             // - `balance += quantity`.
2769             // - `numberMinted += quantity`.
2770             //
2771             // We can directly add to the `balance` and `numberMinted`.
2772             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
2773 
2774             // Updates:
2775             // - `address` to the owner.
2776             // - `startTimestamp` to the timestamp of minting.
2777             // - `burned` to `false`.
2778             // - `nextInitialized` to `quantity == 1`.
2779             _packedOwnerships[startTokenId] = _packOwnershipData(
2780                 to,
2781                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2782             );
2783 
2784             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2785 
2786             _currentIndex = startTokenId + quantity;
2787         }
2788         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2789     }
2790 
2791     /**
2792      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2793      */
2794     function _getApprovedAddress(uint256 tokenId)
2795         private
2796         view
2797         returns (uint256 approvedAddressSlot, address approvedAddress)
2798     {
2799         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
2800         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
2801         assembly {
2802             // Compute the slot.
2803             mstore(0x00, tokenId)
2804             mstore(0x20, tokenApprovalsPtr.slot)
2805             approvedAddressSlot := keccak256(0x00, 0x40)
2806             // Load the slot's value from storage.
2807             approvedAddress := sload(approvedAddressSlot)
2808         }
2809     }
2810 
2811     /**
2812      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
2813      */
2814     function _isOwnerOrApproved(
2815         address approvedAddress,
2816         address from,
2817         address msgSender
2818     ) private pure returns (bool result) {
2819         assembly {
2820             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
2821             from := and(from, BITMASK_ADDRESS)
2822             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2823             msgSender := and(msgSender, BITMASK_ADDRESS)
2824             // `msgSender == from || msgSender == approvedAddress`.
2825             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
2826         }
2827     }
2828 
2829     /**
2830      * @dev Transfers `tokenId` from `from` to `to`.
2831      *
2832      * Requirements:
2833      *
2834      * - `to` cannot be the zero address.
2835      * - `tokenId` token must be owned by `from`.
2836      *
2837      * Emits a {Transfer} event.
2838      */
2839     function transferFrom(
2840         address from,
2841         address to,
2842         uint256 tokenId
2843     ) public virtual override {
2844         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2845 
2846         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2847 
2848         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
2849 
2850         // The nested ifs save around 20+ gas over a compound boolean condition.
2851         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
2852             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2853 
2854         if (to == address(0)) revert TransferToZeroAddress();
2855 
2856         _beforeTokenTransfers(from, to, tokenId, 1);
2857 
2858         // Clear approvals from the previous owner.
2859         assembly {
2860             if approvedAddress {
2861                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2862                 sstore(approvedAddressSlot, 0)
2863             }
2864         }
2865 
2866         // Underflow of the sender's balance is impossible because we check for
2867         // ownership above and the recipient's balance can't realistically overflow.
2868         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2869         unchecked {
2870             // We can directly increment and decrement the balances.
2871             --_packedAddressData[from]; // Updates: `balance -= 1`.
2872             ++_packedAddressData[to]; // Updates: `balance += 1`.
2873 
2874             // Updates:
2875             // - `address` to the next owner.
2876             // - `startTimestamp` to the timestamp of transfering.
2877             // - `burned` to `false`.
2878             // - `nextInitialized` to `true`.
2879             _packedOwnerships[tokenId] = _packOwnershipData(
2880                 to,
2881                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2882             );
2883 
2884             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2885             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
2886                 uint256 nextTokenId = tokenId + 1;
2887                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2888                 if (_packedOwnerships[nextTokenId] == 0) {
2889                     // If the next slot is within bounds.
2890                     if (nextTokenId != _currentIndex) {
2891                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2892                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2893                     }
2894                 }
2895             }
2896         }
2897 
2898         emit Transfer(from, to, tokenId);
2899         _afterTokenTransfers(from, to, tokenId, 1);
2900     }
2901 
2902     /**
2903      * @dev Equivalent to `_burn(tokenId, false)`.
2904      */
2905     function _burn(uint256 tokenId) internal virtual {
2906         _burn(tokenId, false);
2907     }
2908 
2909     /**
2910      * @dev Destroys `tokenId`.
2911      * The approval is cleared when the token is burned.
2912      *
2913      * Requirements:
2914      *
2915      * - `tokenId` must exist.
2916      *
2917      * Emits a {Transfer} event.
2918      */
2919     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2920         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2921 
2922         address from = address(uint160(prevOwnershipPacked));
2923 
2924         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
2925 
2926         if (approvalCheck) {
2927             // The nested ifs save around 20+ gas over a compound boolean condition.
2928             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
2929                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2930         }
2931 
2932         _beforeTokenTransfers(from, address(0), tokenId, 1);
2933 
2934         // Clear approvals from the previous owner.
2935         assembly {
2936             if approvedAddress {
2937                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2938                 sstore(approvedAddressSlot, 0)
2939             }
2940         }
2941 
2942         // Underflow of the sender's balance is impossible because we check for
2943         // ownership above and the recipient's balance can't realistically overflow.
2944         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2945         unchecked {
2946             // Updates:
2947             // - `balance -= 1`.
2948             // - `numberBurned += 1`.
2949             //
2950             // We can directly decrement the balance, and increment the number burned.
2951             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
2952             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
2953 
2954             // Updates:
2955             // - `address` to the last owner.
2956             // - `startTimestamp` to the timestamp of burning.
2957             // - `burned` to `true`.
2958             // - `nextInitialized` to `true`.
2959             _packedOwnerships[tokenId] = _packOwnershipData(
2960                 from,
2961                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2962             );
2963 
2964             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2965             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
2966                 uint256 nextTokenId = tokenId + 1;
2967                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2968                 if (_packedOwnerships[nextTokenId] == 0) {
2969                     // If the next slot is within bounds.
2970                     if (nextTokenId != _currentIndex) {
2971                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2972                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2973                     }
2974                 }
2975             }
2976         }
2977 
2978         emit Transfer(from, address(0), tokenId);
2979         _afterTokenTransfers(from, address(0), tokenId, 1);
2980 
2981         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2982         unchecked {
2983             _burnCounter++;
2984         }
2985     }
2986 
2987     /**
2988      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2989      *
2990      * @param from address representing the previous owner of the given token ID
2991      * @param to target address that will receive the tokens
2992      * @param tokenId uint256 ID of the token to be transferred
2993      * @param _data bytes optional data to send along with the call
2994      * @return bool whether the call correctly returned the expected magic value
2995      */
2996     function _checkContractOnERC721Received(
2997         address from,
2998         address to,
2999         uint256 tokenId,
3000         bytes memory _data
3001     ) private returns (bool) {
3002         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
3003             bytes4 retval
3004         ) {
3005             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
3006         } catch (bytes memory reason) {
3007             if (reason.length == 0) {
3008                 revert TransferToNonERC721ReceiverImplementer();
3009             } else {
3010                 assembly {
3011                     revert(add(32, reason), mload(reason))
3012                 }
3013             }
3014         }
3015     }
3016 
3017     /**
3018      * @dev Directly sets the extra data for the ownership data `index`.
3019      */
3020     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
3021         uint256 packed = _packedOwnerships[index];
3022         if (packed == 0) revert OwnershipNotInitializedForExtraData();
3023         uint256 extraDataCasted;
3024         // Cast `extraData` with assembly to avoid redundant masking.
3025         assembly {
3026             extraDataCasted := extraData
3027         }
3028         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
3029         _packedOwnerships[index] = packed;
3030     }
3031 
3032     /**
3033      * @dev Returns the next extra data for the packed ownership data.
3034      * The returned result is shifted into position.
3035      */
3036     function _nextExtraData(
3037         address from,
3038         address to,
3039         uint256 prevOwnershipPacked
3040     ) private view returns (uint256) {
3041         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
3042         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
3043     }
3044 
3045     /**
3046      * @dev Called during each token transfer to set the 24bit `extraData` field.
3047      * Intended to be overridden by the cosumer contract.
3048      *
3049      * `previousExtraData` - the value of `extraData` before transfer.
3050      *
3051      * Calling conditions:
3052      *
3053      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
3054      * transferred to `to`.
3055      * - When `from` is zero, `tokenId` will be minted for `to`.
3056      * - When `to` is zero, `tokenId` will be burned by `from`.
3057      * - `from` and `to` are never both zero.
3058      */
3059     function _extraData(
3060         address from,
3061         address to,
3062         uint24 previousExtraData
3063     ) internal view virtual returns (uint24) {}
3064 
3065     /**
3066      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
3067      * This includes minting.
3068      * And also called before burning one token.
3069      *
3070      * startTokenId - the first token id to be transferred
3071      * quantity - the amount to be transferred
3072      *
3073      * Calling conditions:
3074      *
3075      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
3076      * transferred to `to`.
3077      * - When `from` is zero, `tokenId` will be minted for `to`.
3078      * - When `to` is zero, `tokenId` will be burned by `from`.
3079      * - `from` and `to` are never both zero.
3080      */
3081     function _beforeTokenTransfers(
3082         address from,
3083         address to,
3084         uint256 startTokenId,
3085         uint256 quantity
3086     ) internal virtual {}
3087 
3088     /**
3089      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
3090      * This includes minting.
3091      * And also called after one token has been burned.
3092      *
3093      * startTokenId - the first token id to be transferred
3094      * quantity - the amount to be transferred
3095      *
3096      * Calling conditions:
3097      *
3098      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
3099      * transferred to `to`.
3100      * - When `from` is zero, `tokenId` has been minted for `to`.
3101      * - When `to` is zero, `tokenId` has been burned by `from`.
3102      * - `from` and `to` are never both zero.
3103      */
3104     function _afterTokenTransfers(
3105         address from,
3106         address to,
3107         uint256 startTokenId,
3108         uint256 quantity
3109     ) internal virtual {}
3110 
3111     /**
3112      * @dev Returns the message sender (defaults to `msg.sender`).
3113      *
3114      * If you are writing GSN compatible contracts, you need to override this function.
3115      */
3116     function _msgSenderERC721A() internal view virtual returns (address) {
3117         return msg.sender;
3118     }
3119 
3120     /**
3121      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
3122      */
3123     function _toString(uint256 value) internal pure returns (string memory ptr) {
3124         assembly {
3125             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
3126             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
3127             // We will need 1 32-byte word to store the length,
3128             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
3129             ptr := add(mload(0x40), 128)
3130             // Update the free memory pointer to allocate.
3131             mstore(0x40, ptr)
3132 
3133             // Cache the end of the memory to calculate the length later.
3134             let end := ptr
3135 
3136             // We write the string from the rightmost digit to the leftmost digit.
3137             // The following is essentially a do-while loop that also handles the zero case.
3138             // Costs a bit more than early returning for the zero case,
3139             // but cheaper in terms of deployment and overall runtime costs.
3140             for {
3141                 // Initialize and perform the first pass without check.
3142                 let temp := value
3143                 // Move the pointer 1 byte leftwards to point to an empty character slot.
3144                 ptr := sub(ptr, 1)
3145                 // Write the character to the pointer. 48 is the ASCII index of '0'.
3146                 mstore8(ptr, add(48, mod(temp, 10)))
3147                 temp := div(temp, 10)
3148             } temp {
3149                 // Keep dividing `temp` until zero.
3150                 temp := div(temp, 10)
3151             } {
3152                 // Body of the for loop.
3153                 ptr := sub(ptr, 1)
3154                 mstore8(ptr, add(48, mod(temp, 10)))
3155             }
3156 
3157             let length := sub(end, ptr)
3158             // Move the pointer 32 bytes leftwards to make room for the length.
3159             ptr := sub(ptr, 32)
3160             // Store the length.
3161             mstore(ptr, length)
3162         }
3163     }
3164 }
3165 
3166 // File: contracts/BITSHADOWZ.sol
3167 
3168 
3169 
3170 pragma solidity ^0.8.4;
3171 
3172 contract BITSHADOWZ is ERC721A, ERC2981, Ownable {
3173 
3174     //Collection Data
3175     uint256 public packSize = 5;
3176     uint256 public maxSupply = 9999;
3177     uint256 public price = 0.05 ether;
3178     bool public ogMintEnabled = false;
3179     bool public wlMintEnabled = false;
3180     bool public publicMintEnabled = false;
3181     string public contractURI;
3182     string public baseURI;
3183 
3184     //Royalty
3185     address public royaltyAddress;
3186     uint public royalty = 750;
3187 
3188     //Owner
3189     address payable public withdrawWallet;
3190   
3191     //Presale
3192     struct OG {
3193         address wallet;
3194         uint256 freeMints; 
3195         bool isOG;       
3196     }
3197 
3198     mapping(address => OG) public ogList;
3199     uint256 public numOGLists; //debug
3200     mapping(address => bool) public whitelist;
3201     uint256 public numWhiteLists; //debug
3202 
3203     constructor() ERC721A("BITSHADOWZ", "BSZ"){
3204         withdrawWallet = payable(msg.sender);   
3205         royaltyAddress = payable(msg.sender);   
3206     }
3207 
3208     //Mint
3209     function mint(uint256 numPacks) external payable {
3210         require(totalSupply() < maxSupply, "Sold out.");    
3211         if(msg.sender != owner()) {
3212             if(!publicMintEnabled){
3213                 if(ogList[msg.sender].isOG) require(ogMintEnabled, "OG mint not open yet.");//check
3214                 else if(whitelist[msg.sender] && !ogList[msg.sender].isOG) require(wlMintEnabled, "WL mint not open yet.");//check
3215                 else require(publicMintEnabled, "Public mint not open yet");//check
3216             }
3217         }
3218        
3219         require(totalSupply() + (numPacks * packSize) <= maxSupply, "Not enough supply remaining for request.");
3220         if(msg.sender != owner()) require(msg.value == numPacks * price, "Wrong payment value.");
3221         else require(msg.value == 0, "Only Zero");
3222 
3223         uint256 quantity = numPacks * packSize;
3224         if(ogList[msg.sender].freeMints > 0) {
3225             uint256 freeMints = ogList[msg.sender].freeMints;
3226             ogList[msg.sender].freeMints = 0;
3227             quantity += freeMints;
3228         }
3229         _safeMint(msg.sender, quantity);
3230     }
3231 
3232     function ownerMint(uint256 tokenQuantity) external onlyOwner {//check
3233         require(tokenQuantity > 0, "Must be greater than zero");
3234         require((totalSupply() + tokenQuantity) <= maxSupply, "Not enough supply remaining for request.");
3235         _safeMint(msg.sender, tokenQuantity);
3236     }
3237 
3238     function setOGMintEnabled() external onlyOwner{//check
3239         ogMintEnabled = !ogMintEnabled;
3240     }
3241 
3242     function setWLMintEnabled() external onlyOwner{//check
3243         require(ogMintEnabled, "OG List not enabled");
3244         wlMintEnabled = !wlMintEnabled;
3245     }
3246 
3247     function setPublicMintEnabled() external onlyOwner{//check
3248         require(ogMintEnabled, "OG List not enabled");
3249         require(wlMintEnabled, "WL not enabled");
3250         publicMintEnabled = !publicMintEnabled;
3251     }
3252 
3253     function setPrice(uint256 newPriceWEI) external onlyOwner{ //check
3254         price = newPriceWEI;
3255     }
3256 
3257         function setMaxSupply(uint256 newMaxSupply) external onlyOwner{ //check
3258         maxSupply = newMaxSupply;
3259     }
3260 
3261     function _startTokenId() internal pure override(ERC721A) returns (uint256) {
3262         return 1;
3263     }
3264 
3265     //Metadata
3266     function setContractURI(string calldata _contractURI) external onlyOwner {
3267         contractURI = _contractURI;
3268     }
3269 
3270     function setBaseURI(string calldata _baseTokenURI) external onlyOwner {
3271         baseURI = _baseTokenURI;
3272     }
3273 
3274     function tokenURI(uint tokenId) public view override(ERC721A) returns (string memory) {
3275         require(tokenId != 0 && tokenId <= totalSupply(), "Token doesn't exist");
3276           return string(abi.encodePacked(baseURI, Strings.toString(tokenId), ".json"));
3277     }
3278 
3279     function _baseURI() internal view override returns (string memory) {
3280         return baseURI;
3281     }
3282 
3283     //OG List
3284     function addOGList(OG[] calldata ogs) external onlyOwner{//check
3285         for(uint256 i = 0; i < ogs.length; i++){
3286             numOGLists++;
3287             ogList[ogs[i].wallet].freeMints = ogs[i].freeMints;
3288             ogList[ogs[i].wallet].isOG = true;
3289         }
3290     }
3291 
3292     function checkOG() external view returns (bool) {
3293         return ogList[msg.sender].isOG;
3294     }
3295 
3296     function checkFreeMints() external view returns (uint256) {
3297         return ogList[msg.sender].freeMints;
3298     }
3299 
3300     //Whitelist
3301     function addWhiteList(address[] calldata addresses) external onlyOwner{//check
3302         for(uint256 i = 0; i < addresses.length; i++){
3303             numWhiteLists++;
3304             whitelist[addresses[i]] = true;
3305         }
3306     }
3307 
3308     function checkWhiteList() external view returns (bool) {
3309         return whitelist[msg.sender];
3310     }
3311 
3312     //Withdraw
3313     function setWithdrawWallet(address payable _address) external onlyOwner {//check
3314         withdrawWallet = _address;
3315     }
3316 
3317     function withdraw() external onlyOwner {
3318         uint balance = address(this).balance;
3319         withdrawWallet.transfer(balance);
3320     }
3321 
3322     function showBalance() public view returns(uint256){
3323         return address(this).balance;
3324     }
3325 
3326     //Royalties
3327     function royaltyInfo(uint, uint _salePrice) public view override returns (address receiver, uint royaltyAmount) {
3328         return (royaltyAddress, (_salePrice * royalty) / 10000);
3329     }
3330 
3331     function setRoyalty(uint16 _royalty) external onlyOwner {
3332         require(_royalty <= 750, "Royalty capped at 7.5%");
3333         royalty = _royalty;
3334     }
3335 
3336     function setRoyaltyAddress(address _royaltyAddress) external onlyOwner {
3337         royaltyAddress = _royaltyAddress;
3338     }
3339 
3340     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool) {
3341         return ERC721A.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
3342     }
3343 }