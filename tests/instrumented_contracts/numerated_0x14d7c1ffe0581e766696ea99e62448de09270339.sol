1 // SPDX-License-Identifier: CC0-1.0
2 //
3 //
4 //
5 //
6 // oooOooooo looka fren wats dis... shIneez?
7 // YUMMZ many manY shineEz, deez mine now teeheeE
8 // wat? wat it is?
9 //
10 // AAAAAAAUUUUUGGGHHHHH shineez on da blokcHin?
11 // waaaaaaaaitttt you wan sum?
12 // okieee fren, u use how uuu want teeheeE...
13 //
14 //
15 //     _,   _,  __  ,  ___,,  , ,    _,  _,  ___,
16 //    / _  / \,'|_) | ' |  |\ | |   / \,/ \,' |
17 //   '\_|`'\_/ _|_)'|___|_,|'\|'|__'\_/'\_/   |
18 //     _|  '  '       '    '  `   ' '   '     '
19 //    '      '      '            '          '
20 //
21 //               _    |.-""-.)    /\
22 //              | \   /   .= \)  /  \
23 //              |  \ / =. --  \ /  ) |   '
24 //     '        \ ( \   o\/0   /     /
25 //               \_, '- /   \   ,___/
26 //                 /    \__ /    \
27 //                 \, ___/\___,  /    '
28 //          '       \  ----     /            '
29 //                   \         /
30 //      '             '--___--'
31 //                       [ ]             '
32 //              '       { }
33 //                       [ ]    '             '
34 //         '            { }
35 //                       [ ]           '
36 //
37 //
38 //
39 // iNspired bY gObLiNtOwn, the lOOt pRojecT, sEttLementS...
40 //
41 // a Cc0 pRojeCt frOm imp0ster, zhOug & jAytHin stAyTHin...
42 //
43 //          ...enJoy... teEEhheeeEEEe...
44 //
45 //
46 //
47 //
48 
49 // File: @openzeppelin/contracts/utils/Base64.sol
50 
51 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Base64.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev Provides a set of functions to operate with Base64 strings.
57  *
58  * _Available since v4.5._
59  */
60 library Base64 {
61 	/**
62 	 * @dev Base64 Encoding/Decoding Table
63 	 */
64 	string internal constant _TABLE =
65 		'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
66 
67 	/**
68 	 * @dev Converts a `bytes` to its Bytes64 `string` representation.
69 	 */
70 	function encode(bytes memory data) internal pure returns (string memory) {
71 		/**
72 		 * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
73 		 * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
74 		 */
75 		if (data.length == 0) return '';
76 
77 		// Loads the table into memory
78 		string memory table = _TABLE;
79 
80 		// Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
81 		// and split into 4 numbers of 6 bits.
82 		// The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
83 		// - `data.length + 2`  -> Round up
84 		// - `/ 3`              -> Number of 3-bytes chunks
85 		// - `4 *`              -> 4 characters for each chunk
86 		string memory result = new string(4 * ((data.length + 2) / 3));
87 
88 		assembly {
89 			// Prepare the lookup table (skip the first "length" byte)
90 			let tablePtr := add(table, 1)
91 
92 			// Prepare result pointer, jump over length
93 			let resultPtr := add(result, 32)
94 
95 			// Run over the input, 3 bytes at a time
96 			for {
97 				let dataPtr := data
98 				let endPtr := add(data, mload(data))
99 			} lt(dataPtr, endPtr) {
100 
101 			} {
102 				// Advance 3 bytes
103 				dataPtr := add(dataPtr, 3)
104 				let input := mload(dataPtr)
105 
106 				// To write each character, shift the 3 bytes (18 bits) chunk
107 				// 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
108 				// and apply logical AND with 0x3F which is the number of
109 				// the previous character in the ASCII table prior to the Base64 Table
110 				// The result is then added to the table to get the character to write,
111 				// and finally write it in the result pointer but with a left shift
112 				// of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
113 
114 				mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
115 				resultPtr := add(resultPtr, 1) // Advance
116 
117 				mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
118 				resultPtr := add(resultPtr, 1) // Advance
119 
120 				mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
121 				resultPtr := add(resultPtr, 1) // Advance
122 
123 				mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
124 				resultPtr := add(resultPtr, 1) // Advance
125 			}
126 
127 			// When data `bytes` is not exactly 3 bytes long
128 			// it is padded with `=` characters at the end
129 			switch mod(mload(data), 3)
130 			case 1 {
131 				mstore8(sub(resultPtr, 1), 0x3d)
132 				mstore8(sub(resultPtr, 2), 0x3d)
133 			}
134 			case 2 {
135 				mstore8(sub(resultPtr, 1), 0x3d)
136 			}
137 		}
138 
139 		return result;
140 	}
141 }
142 
143 // File: @openzeppelin/contracts/utils/Strings.sol
144 
145 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
146 
147 pragma solidity ^0.8.0;
148 
149 /**
150  * @dev String operations.
151  */
152 library Strings {
153 	bytes16 private constant _HEX_SYMBOLS = '0123456789abcdef';
154 
155 	/**
156 	 * @dev Converts a `uint256` to its ASCII `string` decimal representation.
157 	 */
158 	function toString(uint256 value) internal pure returns (string memory) {
159 		// Inspired by OraclizeAPI's implementation - MIT licence
160 		// https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
161 
162 		if (value == 0) {
163 			return '0';
164 		}
165 		uint256 temp = value;
166 		uint256 digits;
167 		while (temp != 0) {
168 			digits++;
169 			temp /= 10;
170 		}
171 		bytes memory buffer = new bytes(digits);
172 		while (value != 0) {
173 			digits -= 1;
174 			buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
175 			value /= 10;
176 		}
177 		return string(buffer);
178 	}
179 
180 	/**
181 	 * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
182 	 */
183 	function toHexString(uint256 value) internal pure returns (string memory) {
184 		if (value == 0) {
185 			return '0x00';
186 		}
187 		uint256 temp = value;
188 		uint256 length = 0;
189 		while (temp != 0) {
190 			length++;
191 			temp >>= 8;
192 		}
193 		return toHexString(value, length);
194 	}
195 
196 	/**
197 	 * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
198 	 */
199 	function toHexString(uint256 value, uint256 length)
200 		internal
201 		pure
202 		returns (string memory)
203 	{
204 		bytes memory buffer = new bytes(2 * length + 2);
205 		buffer[0] = '0';
206 		buffer[1] = 'x';
207 		for (uint256 i = 2 * length + 1; i > 1; --i) {
208 			buffer[i] = _HEX_SYMBOLS[value & 0xf];
209 			value >>= 4;
210 		}
211 		require(value == 0, 'Strings: hex length insufficient');
212 		return string(buffer);
213 	}
214 }
215 
216 // File: @rari-capital/solmate/src/tokens/ERC721.sol
217 
218 pragma solidity >=0.8.0;
219 
220 /// @notice Modern, minimalist, and gas efficient ERC-721 implementation.
221 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
222 abstract contract ERC721 {
223 	/*//////////////////////////////////////////////////////////////
224                                  EVENTS
225     //////////////////////////////////////////////////////////////*/
226 
227 	event Transfer(address indexed from, address indexed to, uint256 indexed id);
228 
229 	event Approval(
230 		address indexed owner,
231 		address indexed spender,
232 		uint256 indexed id
233 	);
234 
235 	event ApprovalForAll(
236 		address indexed owner,
237 		address indexed operator,
238 		bool approved
239 	);
240 
241 	/*//////////////////////////////////////////////////////////////
242                          METADATA STORAGE/LOGIC
243     //////////////////////////////////////////////////////////////*/
244 
245 	string public name;
246 
247 	string public symbol;
248 
249 	function tokenURI(uint256 id) public view virtual returns (string memory);
250 
251 	/*//////////////////////////////////////////////////////////////
252                       ERC721 BALANCE/OWNER STORAGE
253     //////////////////////////////////////////////////////////////*/
254 
255 	mapping(uint256 => address) internal _ownerOf;
256 
257 	mapping(address => uint256) internal _balanceOf;
258 
259 	function ownerOf(uint256 id) public view virtual returns (address owner) {
260 		require((owner = _ownerOf[id]) != address(0), 'NOT_MINTED');
261 	}
262 
263 	function balanceOf(address owner) public view virtual returns (uint256) {
264 		require(owner != address(0), 'ZERO_ADDRESS');
265 
266 		return _balanceOf[owner];
267 	}
268 
269 	/*//////////////////////////////////////////////////////////////
270                          ERC721 APPROVAL STORAGE
271     //////////////////////////////////////////////////////////////*/
272 
273 	mapping(uint256 => address) public getApproved;
274 
275 	mapping(address => mapping(address => bool)) public isApprovedForAll;
276 
277 	/*//////////////////////////////////////////////////////////////
278                                CONSTRUCTOR
279     //////////////////////////////////////////////////////////////*/
280 
281 	constructor(string memory _name, string memory _symbol) {
282 		name = _name;
283 		symbol = _symbol;
284 	}
285 
286 	/*//////////////////////////////////////////////////////////////
287                               ERC721 LOGIC
288     //////////////////////////////////////////////////////////////*/
289 
290 	function approve(address spender, uint256 id) public virtual {
291 		address owner = _ownerOf[id];
292 
293 		require(
294 			msg.sender == owner || isApprovedForAll[owner][msg.sender],
295 			'NOT_AUTHORIZED'
296 		);
297 
298 		getApproved[id] = spender;
299 
300 		emit Approval(owner, spender, id);
301 	}
302 
303 	function setApprovalForAll(address operator, bool approved) public virtual {
304 		isApprovedForAll[msg.sender][operator] = approved;
305 
306 		emit ApprovalForAll(msg.sender, operator, approved);
307 	}
308 
309 	function transferFrom(
310 		address from,
311 		address to,
312 		uint256 id
313 	) public virtual {
314 		require(from == _ownerOf[id], 'WRONG_FROM');
315 
316 		require(to != address(0), 'INVALID_RECIPIENT');
317 
318 		require(
319 			msg.sender == from ||
320 				isApprovedForAll[from][msg.sender] ||
321 				msg.sender == getApproved[id],
322 			'NOT_AUTHORIZED'
323 		);
324 
325 		// Underflow of the sender's balance is impossible because we check for
326 		// ownership above and the recipient's balance can't realistically overflow.
327 		unchecked {
328 			_balanceOf[from]--;
329 
330 			_balanceOf[to]++;
331 		}
332 
333 		_ownerOf[id] = to;
334 
335 		delete getApproved[id];
336 
337 		emit Transfer(from, to, id);
338 	}
339 
340 	function safeTransferFrom(
341 		address from,
342 		address to,
343 		uint256 id
344 	) public virtual {
345 		transferFrom(from, to, id);
346 
347 		require(
348 			to.code.length == 0 ||
349 				ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, '') ==
350 				ERC721TokenReceiver.onERC721Received.selector,
351 			'UNSAFE_RECIPIENT'
352 		);
353 	}
354 
355 	function safeTransferFrom(
356 		address from,
357 		address to,
358 		uint256 id,
359 		bytes calldata data
360 	) public virtual {
361 		transferFrom(from, to, id);
362 
363 		require(
364 			to.code.length == 0 ||
365 				ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
366 				ERC721TokenReceiver.onERC721Received.selector,
367 			'UNSAFE_RECIPIENT'
368 		);
369 	}
370 
371 	/*//////////////////////////////////////////////////////////////
372                               ERC165 LOGIC
373     //////////////////////////////////////////////////////////////*/
374 
375 	function supportsInterface(bytes4 interfaceId)
376 		public
377 		view
378 		virtual
379 		returns (bool)
380 	{
381 		return
382 			interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
383 			interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
384 			interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
385 	}
386 
387 	/*//////////////////////////////////////////////////////////////
388                         INTERNAL MINT/BURN LOGIC
389     //////////////////////////////////////////////////////////////*/
390 
391 	function _mint(address to, uint256 id) internal virtual {
392 		require(to != address(0), 'INVALID_RECIPIENT');
393 
394 		require(_ownerOf[id] == address(0), 'ALREADY_MINTED');
395 
396 		// Counter overflow is incredibly unrealistic.
397 		unchecked {
398 			_balanceOf[to]++;
399 		}
400 
401 		_ownerOf[id] = to;
402 
403 		emit Transfer(address(0), to, id);
404 	}
405 
406 	function _burn(uint256 id) internal virtual {
407 		address owner = _ownerOf[id];
408 
409 		require(owner != address(0), 'NOT_MINTED');
410 
411 		// Ownership check above ensures no underflow.
412 		unchecked {
413 			_balanceOf[owner]--;
414 		}
415 
416 		delete _ownerOf[id];
417 
418 		delete getApproved[id];
419 
420 		emit Transfer(owner, address(0), id);
421 	}
422 
423 	/*//////////////////////////////////////////////////////////////
424                         INTERNAL SAFE MINT LOGIC
425     //////////////////////////////////////////////////////////////*/
426 
427 	function _safeMint(address to, uint256 id) internal virtual {
428 		_mint(to, id);
429 
430 		require(
431 			to.code.length == 0 ||
432 				ERC721TokenReceiver(to).onERC721Received(
433 					msg.sender,
434 					address(0),
435 					id,
436 					''
437 				) ==
438 				ERC721TokenReceiver.onERC721Received.selector,
439 			'UNSAFE_RECIPIENT'
440 		);
441 	}
442 
443 	function _safeMint(
444 		address to,
445 		uint256 id,
446 		bytes memory data
447 	) internal virtual {
448 		_mint(to, id);
449 
450 		require(
451 			to.code.length == 0 ||
452 				ERC721TokenReceiver(to).onERC721Received(
453 					msg.sender,
454 					address(0),
455 					id,
456 					data
457 				) ==
458 				ERC721TokenReceiver.onERC721Received.selector,
459 			'UNSAFE_RECIPIENT'
460 		);
461 	}
462 }
463 
464 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
465 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
466 abstract contract ERC721TokenReceiver {
467 	function onERC721Received(
468 		address,
469 		address,
470 		uint256,
471 		bytes calldata
472 	) external virtual returns (bytes4) {
473 		return ERC721TokenReceiver.onERC721Received.selector;
474 	}
475 }
476 
477 // File: contracts/GoblinLoot.sol
478 
479 pragma solidity ^0.8.0;
480 
481 contract GoblinLoot is ERC721 {
482 	using Strings for uint256;
483 
484 	uint256 public constant MAX_SUPPLY = 5000;
485 	uint256 public constant MINT_DURATION = 48 hours;
486 	uint256 public totalSupply;
487 	uint256 public mintClosingTime;
488 	bool public mintIsActive;
489 	address public tipWithdrawer;
490 
491 	address private imp0ster = 0x023006cED81c7Bf6D17A5bC1e1B40104114d0019;
492 	address private zhoug = 0xc99547f73B0Aa2C69E56849e8986137776D72474;
493 
494 	// -------------------------------------------------------------------------------------------------- kOonstrukktorr
495 	constructor() ERC721('GoblinLoot', 'gObLooT') {
496 		tipWithdrawer = msg.sender;
497 		mintClosingTime = block.timestamp + MINT_DURATION;
498 		mintIsActive = true;
499 		_batchMint(imp0ster, 50);
500 		_batchMint(zhoug, 50);
501 	}
502 
503 	// -------------------------------------------------------------------------------------------------- sLott KeYsss
504 	uint256 internal constant SLOT_WEAP = 1;
505 	uint256 internal constant SLOT_HEAD = 2;
506 	uint256 internal constant SLOT_BODY = 3;
507 	uint256 internal constant SLOT_HAND = 4;
508 	uint256 internal constant SLOT_FOOT = 5;
509 	uint256 internal constant SLOT_NECK = 6;
510 	uint256 internal constant SLOT_RING = 7;
511 	uint256 internal constant SLOT_TRI1 = 8;
512 	uint256 internal constant SLOT_TRI2 = 9;
513 
514 	// -------------------------------------------------------------------------------------------------- matEriallss
515 	string[] internal heavyMaterials = [
516 		'bone',
517 		'stone',
518 		'bronze',
519 		'wood',
520 		'rubber',
521 		'iron',
522 		'gold',
523 		'copper',
524 		'tin',
525 		'goblinsteel',
526 		'scrap'
527 	];
528 
529 	string[] internal lightMaterials = [
530 		'linen',
531 		'fur',
532 		'leather',
533 		'bark',
534 		'cotton',
535 		'cardboard',
536 		'hide',
537 		'scrap',
538 		'burlap',
539 		'goblinmail',
540 		'paper',
541 		'snakeskin '
542 	];
543 
544 	// -------------------------------------------------------------------------------------------------- iTEMs
545 	string[] internal weapons = [
546 		'club',
547 		'scythe',
548 		'hammer',
549 		'sickle',
550 		'longspear',
551 		'shortspear',
552 		'staff',
553 		'slingshot',
554 		'shortbow',
555 		'longbow',
556 		'mace',
557 		'dagger',
558 		'totem',
559 		'wand',
560 		'pickaxe',
561 		'hatchet',
562 		'maul',
563 		'knife'
564 	];
565 
566 	string[] internal headGear = [
567 		'cap',
568 		'hood',
569 		'helmet',
570 		'crown',
571 		'earring',
572 		'top hat',
573 		'bonnet',
574 		'kettle',
575 		'pot lid',
576 		'goggles',
577 		'monocle',
578 		'bowler',
579 		'eyepatch'
580 	];
581 
582 	string[] internal bodyGear = [
583 		'husk',
584 		'cloak',
585 		'pads',
586 		'pauldrons',
587 		'waistcoat',
588 		'loincloth',
589 		'trousers',
590 		'robe',
591 		'rags',
592 		'harness',
593 		'tunic',
594 		'wrappings',
595 		'cuirass',
596 		'crop top',
597 		'sash',
598 		'toga',
599 		'belt',
600 		'vest',
601 		'cape'
602 	];
603 
604 	string[] internal handGear = [
605 		'hooks',
606 		'gloves',
607 		'bracers',
608 		'gauntlets',
609 		'bangles',
610 		'knuckleguards',
611 		'bracelets',
612 		'claws',
613 		'handwraps',
614 		'mittens',
615 		'wristbands',
616 		'talons'
617 	];
618 
619 	string[] internal footGear = [
620 		'sandals',
621 		'boots',
622 		'footwraps',
623 		'greaves',
624 		'anklets',
625 		'shackles',
626 		'booties',
627 		'socks',
628 		'shinguards',
629 		'toe rings',
630 		'slippers',
631 		'shoes',
632 		'clogs'
633 	];
634 
635 	string[] internal necklaces = [
636 		'chain',
637 		'amulet',
638 		'locket',
639 		'pendant',
640 		'choker'
641 	];
642 
643 	string[] internal rings = [
644 		'gold ring',
645 		'silver ring',
646 		'bronze ring',
647 		'iron ring'
648 	];
649 
650 	string[] internal trinkets1 = [
651 		'pipe',
652 		'sundial',
653 		'clock',
654 		'bellows',
655 		'brush',
656 		'comb',
657 		'candle',
658 		'candlestick',
659 		'torch',
660 		'scratcher',
661 		'gaslamp',
662 		'shoehorn',
663 		'dice',
664 		'spoon',
665 		'periscope',
666 		'spyglass',
667 		'lute',
668 		'drum',
669 		'tamborine',
670 		'whistle',
671 		'pocketwatch',
672 		'compass',
673 		'whip'
674 	];
675 
676 	string[] internal trinkets2 = [
677 		'potato',
678 		'pickle',
679 		'ruby',
680 		'herb pouch',
681 		'tooth',
682 		'jawbone',
683 		'dandelions',
684 		'sapphire',
685 		'diamond',
686 		'mushroom',
687 		'emerald',
688 		'sardines',
689 		'sulfur',
690 		'seeds',
691 		'beans',
692 		'quicksilver',
693 		'skull',
694 		'blueberries',
695 		'egg',
696 		'meat',
697 		'oil',
698 		'chalk',
699 		'charcoal',
700 		'twigs',
701 		'sweets',
702 		'amethyst',
703 		'obsidian',
704 		'pebbles',
705 		'goo',
706 		'rose',
707 		'seaweed',
708 		'feathers'
709 	];
710 
711 	string[] internal trinkets3 = [
712 		'sailcloth',
713 		'cog',
714 		'rope',
715 		'vial',
716 		'flask',
717 		'jar',
718 		'gasket',
719 		'shears',
720 		'nails',
721 		'screws',
722 		'thread',
723 		'sewing needle',
724 		'mallet',
725 		'fishing rod',
726 		'grindstone',
727 		'bowl',
728 		'paintbrush',
729 		'scroll',
730 		'scraper',
731 		'???',
732 		'grappling hook',
733 		'sand',
734 		'stein',
735 		'teapot',
736 		'wineskin'
737 	];
738 
739 	// -------------------------------------------------------------------------------------------------- preEefiX aN SUFfixxx
740 	string[] internal jewelryPrefixes = [
741 		'crude',
742 		'flawed',
743 		'rusty',
744 		'perfect',
745 		'fine',
746 		'flawless',
747 		'noble',
748 		'embossed',
749 		'tainted',
750 		'chipped',
751 		'worn',
752 		'sooty',
753 		'stolen'
754 	];
755 
756 	string[] internal prefixes = [
757 		'sparkling',
758 		'shiny',
759 		'slick',
760 		'glowing',
761 		'polished',
762 		'damp',
763 		'blighty',
764 		'bloody',
765 		'thorny',
766 		'doomed',
767 		'gloomy',
768 		'grim',
769 		'makeshift',
770 		'noxious',
771 		'hairy',
772 		'mossy',
773 		'stinky',
774 		'dusty',
775 		'charred',
776 		'spiky',
777 		'cursed',
778 		'scaly',
779 		'crusty',
780 		'damned',
781 		'briny',
782 		'dirty',
783 		'slimy',
784 		'muddy',
785 		'lucky',
786 		"artificer's",
787 		"wayfarer's",
788 		"thief's",
789 		"captain's",
790 		"henchman's",
791 		"daredevil's",
792 		"bandit's",
793 		"inspector's",
794 		"raider's",
795 		"miner's",
796 		"builder's"
797 	];
798 
799 	string[] internal suffixes = [
800 		'of RRRAAAAAHHH',
801 		'of AAAUUUGGHHH',
802 		'of power',
803 		'of sneak',
804 		'of strike',
805 		'of smite',
806 		'of charm',
807 		'of trade',
808 		'of anger',
809 		'of rage',
810 		'of fury',
811 		'of ash',
812 		'of fear',
813 		'of havoc',
814 		'of rapture',
815 		'of terror',
816 		'of the cliffs',
817 		'of the swamp',
818 		'of the bog',
819 		'of the rift',
820 		'of the sewers',
821 		'of the woods',
822 		'of the caves',
823 		'of the grave'
824 	];
825 
826 	// -------------------------------------------------------------------------------------------------- eRRorzZ aaN modIffieerss
827 	error MintInactive();
828 	error NotEnoughLoot();
829 	error NotAuthorized();
830 	error NotMinted();
831 
832 	modifier mintControl() {
833 		_;
834 		if (totalSupply == MAX_SUPPLY || block.timestamp > mintClosingTime) {
835 			mintIsActive = false;
836 		}
837 	}
838 
839 	// -------------------------------------------------------------------------------------------------- wRiTez
840 	function _batchMint(address _recipient, uint256 _amount) private {
841 		unchecked {
842 			for (uint256 i = 1; i < _amount + 1; ++i) {
843 				_safeMint(_recipient, totalSupply + i);
844 			}
845 			totalSupply += _amount;
846 		}
847 	}
848 
849 	function mint() public mintControl {
850 		if (!mintIsActive) revert MintInactive();
851 		if (totalSupply == MAX_SUPPLY) revert NotEnoughLoot();
852 		unchecked {
853 			++totalSupply;
854 		}
855 		_safeMint(msg.sender, totalSupply);
856 	}
857 
858 	function mintThreeWithATip() public payable mintControl {
859 		if (!mintIsActive) revert MintInactive();
860 		if (totalSupply + 3 > MAX_SUPPLY) revert NotEnoughLoot();
861 		if (msg.value <= 0) revert NotAuthorized();
862 		_batchMint(msg.sender, 3);
863 	}
864 
865 	function burn(uint256 _tokenId) public {
866 		if (
867 			msg.sender != address(_ownerOf[_tokenId]) ||
868 			isApprovedForAll[_ownerOf[_tokenId]][msg.sender]
869 		) revert NotAuthorized();
870 		_burn(_tokenId);
871 	}
872 
873 	function updateTipWithdrawer(address _newWithdrawer) public {
874 		if (msg.sender != tipWithdrawer) revert NotAuthorized();
875 		tipWithdrawer = _newWithdrawer;
876 	}
877 
878 	function withdrawTips() external payable {
879 		if (msg.sender != tipWithdrawer) revert NotAuthorized();
880 		(bool os, ) = payable(tipWithdrawer).call{value: address(this).balance}('');
881 		require(os);
882 	}
883 
884 	// -------------------------------------------------------------------------------------------------- rEEdz
885 	function isHeavyMaterial(uint256 _key) internal pure returns (bool) {
886 		return (_key == SLOT_WEAP || _key == SLOT_HEAD || _key == SLOT_HAND);
887 	}
888 
889 	function isLightMaterial(uint256 _key) internal pure returns (bool) {
890 		return (_key == SLOT_BODY || _key == SLOT_FOOT);
891 	}
892 
893 	function isTrinket(uint256 _key) internal pure returns (bool) {
894 		return (_key == SLOT_TRI1 || _key == SLOT_TRI2);
895 	}
896 
897 	function isJewelry(uint256 _key) internal pure returns (bool) {
898 		return (_key == SLOT_NECK || _key == SLOT_RING);
899 	}
900 
901 	function random(uint256 _seedOne, uint256 _seedTwo)
902 		internal
903 		pure
904 		returns (uint256)
905 	{
906 		return
907 			uint256(
908 				keccak256(
909 					abi.encodePacked('AUuuU', _seedOne, 'UuUu', _seedTwo, 'uUgHH')
910 				)
911 			);
912 	}
913 
914 	function join(string memory _itemOne, string memory _itemTwo)
915 		internal
916 		pure
917 		returns (string memory)
918 	{
919 		return string(abi.encodePacked(_itemOne, ' ', _itemTwo));
920 	}
921 
922 	function pluck(
923 		uint256 _tokenId,
924 		uint256 _slotKey,
925 		string[] memory _sourceArray
926 	) internal view returns (string memory) {
927 		uint256 rand = random(_tokenId, _slotKey);
928 		uint256 AUUUGH = rand % 69;
929 		string memory output = _sourceArray[rand % _sourceArray.length];
930 
931 		if (isHeavyMaterial(_slotKey)) {
932 			output = join(heavyMaterials[rand % heavyMaterials.length], output);
933 		}
934 
935 		if (isLightMaterial(_slotKey)) {
936 			output = join(lightMaterials[rand % lightMaterials.length], output);
937 		}
938 
939 		if (isJewelry(_slotKey)) {
940 			output = join(jewelryPrefixes[rand % jewelryPrefixes.length], output);
941 		}
942 
943 		// no prefix or suffix
944 		if (AUUUGH < 23 || isTrinket(_slotKey)) {
945 			return output;
946 		}
947 
948 		// both prefix & suffix
949 		if (AUUUGH > 55) {
950 			// if jewelry, apply only the suffix
951 			if (isJewelry(_slotKey)) {
952 				return join(output, suffixes[rand % suffixes.length]);
953 			}
954 
955 			return
956 				join(
957 					join(prefixes[rand % prefixes.length], output),
958 					suffixes[rand % suffixes.length]
959 				);
960 		}
961 
962 		// prefix only
963 		if (AUUUGH > 40 && !isJewelry(_slotKey)) {
964 			return join(prefixes[rand % prefixes.length], output);
965 		}
966 
967 		// suffix only
968 		return join(output, suffixes[rand % suffixes.length]);
969 	}
970 
971 	function getWeapon(uint256 _tokenId) public view returns (string memory) {
972 		return pluck(_tokenId, SLOT_WEAP, weapons);
973 	}
974 
975 	function getHead(uint256 _tokenId) public view returns (string memory) {
976 		return pluck(_tokenId, SLOT_HEAD, headGear);
977 	}
978 
979 	function getBody(uint256 _tokenId) public view returns (string memory) {
980 		return pluck(_tokenId, SLOT_BODY, bodyGear);
981 	}
982 
983 	function getHand(uint256 _tokenId) public view returns (string memory) {
984 		return pluck(_tokenId, SLOT_HAND, handGear);
985 	}
986 
987 	function getFoot(uint256 _tokenId) public view returns (string memory) {
988 		return pluck(_tokenId, SLOT_FOOT, footGear);
989 	}
990 
991 	function getNeck(uint256 _tokenId) public view returns (string memory) {
992 		return pluck(_tokenId, SLOT_NECK, necklaces);
993 	}
994 
995 	function getRing(uint256 _tokenId) public view returns (string memory) {
996 		return pluck(_tokenId, SLOT_RING, rings);
997 	}
998 
999 	function getTrinket1(uint256 _tokenId) public view returns (string memory) {
1000 		return pluck(_tokenId, SLOT_TRI1, trinkets1);
1001 	}
1002 
1003 	function getTrinket2(uint256 _tokenId) public view returns (string memory) {
1004 		return pluck(_tokenId, SLOT_TRI2, trinkets2);
1005 	}
1006 
1007 	function getTrinket3(uint256 _tokenId) public view returns (string memory) {
1008 		return pluck(_tokenId, SLOT_TRI2, trinkets3);
1009 	}
1010 
1011 	function getShinee(uint256 _tokenId) public pure returns (uint256) {
1012 		return (random(_tokenId, 420) % 10) + 1;
1013 	}
1014 
1015 	function buildSVG(uint256 _tokenId) internal view returns (string memory) {
1016 		string[24] memory parts;
1017 		parts[
1018 			0
1019 		] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: #AFB886; font-family: monospace; font-size: 16px; letter-spacing: -0.05em; }</style><rect width="100%" height="100%" fill="#242910" /><text x="10" y="20" class="base">';
1020 		parts[1] = getWeapon(_tokenId);
1021 		parts[2] = '</text><text x="10" y="40" class="base">';
1022 		parts[3] = getHead(_tokenId);
1023 		parts[4] = '</text><text x="10" y="60" class="base">';
1024 		parts[5] = getBody(_tokenId);
1025 		parts[6] = '</text><text x="10" y="80" class="base">';
1026 		parts[7] = getHand(_tokenId);
1027 		parts[8] = '</text><text x="10" y="100" class="base">';
1028 		parts[9] = getFoot(_tokenId);
1029 		parts[10] = '</text><text x="10" y="120" class="base">';
1030 		parts[11] = getNeck(_tokenId);
1031 		parts[12] = '</text><text x="10" y="140" class="base">';
1032 		parts[13] = getRing(_tokenId);
1033 		parts[14] = '</text><text x="10" y="160" class="base">';
1034 		parts[15] = getTrinket1(_tokenId);
1035 		parts[16] = '</text><text x="10" y="180" class="base">';
1036 		parts[17] = getTrinket2(_tokenId);
1037 		parts[18] = '</text><text x="10" y="200" class="base">';
1038 		parts[19] = getTrinket3(_tokenId);
1039 		parts[
1040 			20
1041 		] = '</text><text x="10" y="220" class="base">---------------------';
1042 		parts[21] = '</text><text x="10" y="240" class="base">';
1043 		parts[22] = Strings.toString(getShinee(_tokenId));
1044 		parts[23] = ' shinee</text></svg>';
1045 
1046 		string memory svg = string(
1047 			abi.encodePacked(
1048 				parts[0],
1049 				parts[1],
1050 				parts[2],
1051 				parts[3],
1052 				parts[4],
1053 				parts[5],
1054 				parts[6],
1055 				parts[7],
1056 				parts[8]
1057 			)
1058 		);
1059 		svg = string(
1060 			abi.encodePacked(
1061 				svg,
1062 				parts[9],
1063 				parts[10],
1064 				parts[11],
1065 				parts[12],
1066 				parts[13],
1067 				parts[14],
1068 				parts[15],
1069 				parts[16]
1070 			)
1071 		);
1072 		return
1073 			string(
1074 				abi.encodePacked(
1075 					svg,
1076 					parts[17],
1077 					parts[18],
1078 					parts[19],
1079 					parts[20],
1080 					parts[21],
1081 					parts[22],
1082 					parts[23]
1083 				)
1084 			);
1085 	}
1086 
1087 	function buildAttr(string memory _traitType, string memory _value)
1088 		internal
1089 		pure
1090 		returns (string memory)
1091 	{
1092 		return
1093 			string(
1094 				abi.encodePacked(
1095 					'{"trait_type": "',
1096 					_traitType,
1097 					'", "value": "',
1098 					_value,
1099 					'"},'
1100 				)
1101 			);
1102 	}
1103 
1104 	function buildAttrList(uint256 _tokenId)
1105 		internal
1106 		view
1107 		returns (string memory)
1108 	{
1109 		string[12] memory parts;
1110 		parts[0] = '[';
1111 		parts[1] = buildAttr('weapon', getWeapon(_tokenId));
1112 		parts[2] = buildAttr('head', getHead(_tokenId));
1113 		parts[3] = buildAttr('body', getBody(_tokenId));
1114 		parts[4] = buildAttr('hand', getHand(_tokenId));
1115 		parts[5] = buildAttr('foot', getFoot(_tokenId));
1116 		parts[6] = buildAttr('neck', getNeck(_tokenId));
1117 		parts[7] = buildAttr('ring', getRing(_tokenId));
1118 		parts[8] = buildAttr('trinket_one', getTrinket1(_tokenId));
1119 		parts[9] = buildAttr('trinket_two', getTrinket2(_tokenId));
1120 		parts[10] = buildAttr('trinket_three', getTrinket3(_tokenId));
1121 		parts[11] = string(
1122 			abi.encodePacked(
1123 				'{"trait_type": "shinee", "value": ',
1124 				Strings.toString(getShinee(_tokenId)),
1125 				', "max_value": 10}]'
1126 			)
1127 		);
1128 
1129 		string memory output = string(
1130 			abi.encodePacked(
1131 				parts[0],
1132 				parts[1],
1133 				parts[2],
1134 				parts[3],
1135 				parts[4],
1136 				parts[5],
1137 				parts[6],
1138 				parts[7],
1139 				parts[8]
1140 			)
1141 		);
1142 
1143 		return string(abi.encodePacked(output, parts[9], parts[10], parts[11]));
1144 	}
1145 
1146 	function tokenURI(uint256 _tokenId)
1147 		public
1148 		view
1149 		override
1150 		returns (string memory)
1151 	{
1152 		if (_ownerOf[_tokenId] == address(0)) revert NotMinted();
1153 
1154 		string memory json = Base64.encode(
1155 			bytes(
1156 				string(
1157 					abi.encodePacked(
1158 						'{"name": "sack #',
1159 						Strings.toString(_tokenId),
1160 						'", "description": "oooOooooo looka fren wats dis... shIneez?\\nYUMMZ\\n\\nmany manY shineEz, deez mine now teeheeE\\n\\nwat? wat it is?\\nAAAAAAAUUUUUGGGHHHHH shineez on da blokcHin?\\n\\nwaaaaaaaaitttt you wan sum?\\nokieee fren, u use how uuu want teeheeE", "image": "data:image/svg+xml;base64,',
1161 						Base64.encode(bytes(buildSVG(_tokenId))),
1162 						'", "attributes": ',
1163 						buildAttrList(_tokenId),
1164 						'}'
1165 					)
1166 				)
1167 			)
1168 		);
1169 
1170 		string memory output = string(
1171 			abi.encodePacked('data:application/json;base64,', json)
1172 		);
1173 		return output;
1174 	}
1175 
1176 	function getSacksOwned(address _address)
1177 		public
1178 		view
1179 		returns (uint256[] memory ownedIds)
1180 	{
1181 		uint256 balance = _balanceOf[_address];
1182 		uint256 idCounter = 1;
1183 		uint256 ownedCounter = 0;
1184 		ownedIds = new uint256[](balance);
1185 
1186 		while (ownedCounter < balance && idCounter < MAX_SUPPLY + 1) {
1187 			address ownerAddress = _ownerOf[idCounter];
1188 			if (ownerAddress == _address) {
1189 				ownedIds[ownedCounter] = idCounter;
1190 				ownedCounter++;
1191 			}
1192 			idCounter++;
1193 		}
1194 	}
1195 }