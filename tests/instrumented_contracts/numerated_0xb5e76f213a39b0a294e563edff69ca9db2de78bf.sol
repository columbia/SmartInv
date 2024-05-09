1 // File: contracts/ITraits.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 interface ITraits {
7   function tokenURI(uint256 tokenId) external view returns (string memory);
8 }
9 // File: contracts/ERC721.sol
10 
11 pragma solidity ^0.8.7;
12 
13 
14 /// @notice Modern and gas efficient ERC-721 + ERC-20/EIP-2612-like implementation,
15 /// including the MetaData, and partially, Enumerable extensions.
16 contract ERC721 {
17     /*///////////////////////////////////////////////////////////////
18                                   EVENTS
19     //////////////////////////////////////////////////////////////*/
20     
21     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
22     
23     event Approval(address indexed owner, address indexed spender, uint256 indexed tokenId);
24     
25     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
26     
27     /*///////////////////////////////////////////////////////////////
28                              METADATA STORAGE
29     //////////////////////////////////////////////////////////////*/
30     
31     address        implementation_;
32     address public admin; //Lame requirement from opensea
33     
34     /*///////////////////////////////////////////////////////////////
35                              ERC-721 STORAGE
36     //////////////////////////////////////////////////////////////*/
37 
38     uint256 public totalSupply;
39     uint256 public oldSupply;
40     uint256 public minted;
41     
42     mapping(address => uint256) public balanceOf;
43     
44     mapping(uint256 => address) public ownerOf;
45         
46     mapping(uint256 => address) public getApproved;
47  
48     mapping(address => mapping(address => bool)) public isApprovedForAll;
49 
50     /*///////////////////////////////////////////////////////////////
51                              VIEW FUNCTION
52     //////////////////////////////////////////////////////////////*/
53 
54     function owner() external view returns (address) {
55         return admin;
56     }
57     
58     /*///////////////////////////////////////////////////////////////
59                               ERC-20-LIKE LOGIC
60     //////////////////////////////////////////////////////////////*/
61     
62     function transfer(address to, uint256 tokenId) external {
63         require(msg.sender == ownerOf[tokenId], "NOT_OWNER");
64         
65         _transfer(msg.sender, to, tokenId);
66         
67     }
68     
69     /*///////////////////////////////////////////////////////////////
70                               ERC-721 LOGIC
71     //////////////////////////////////////////////////////////////*/
72     
73     function supportsInterface(bytes4 interfaceId) external pure returns (bool supported) {
74         supported = interfaceId == 0x80ac58cd || interfaceId == 0x5b5e139f;
75     }
76     
77     function approve(address spender, uint256 tokenId) external {
78         address owner_ = ownerOf[tokenId];
79         
80         require(msg.sender == owner_ || isApprovedForAll[owner_][msg.sender], "NOT_APPROVED");
81         
82         getApproved[tokenId] = spender;
83         
84         emit Approval(owner_, spender, tokenId); 
85     }
86     
87     function setApprovalForAll(address operator, bool approved) external {
88         isApprovedForAll[msg.sender][operator] = approved;
89         
90         emit ApprovalForAll(msg.sender, operator, approved);
91     }
92 
93     function transferFrom(address from, address to, uint256 tokenId) public {
94         require(
95             msg.sender == from 
96             || msg.sender == getApproved[tokenId]
97             || isApprovedForAll[from][msg.sender], 
98             "NOT_APPROVED"
99         );
100         
101         _transfer(from, to, tokenId);
102         
103     }
104     
105     function safeTransferFrom(address from, address to, uint256 tokenId) external {
106         safeTransferFrom(from, to, tokenId, "");
107     }
108     
109     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public {
110         transferFrom(from, to, tokenId); 
111         
112         if (to.code.length != 0) {
113             // selector = `onERC721Received(address,address,uint,bytes)`
114             (, bytes memory returned) = to.staticcall(abi.encodeWithSelector(0x150b7a02,
115                 msg.sender, from, tokenId, data));
116                 
117             bytes4 selector = abi.decode(returned, (bytes4));
118             
119             require(selector == 0x150b7a02, "NOT_ERC721_RECEIVER");
120         }
121     }
122     
123     /*///////////////////////////////////////////////////////////////
124                           INTERNAL UTILS
125     //////////////////////////////////////////////////////////////*/
126 
127     function _transfer(address from, address to, uint256 tokenId) internal {
128         require(ownerOf[tokenId] == from, "not owner");
129 
130         balanceOf[from]--; 
131         balanceOf[to]++;
132         
133         delete getApproved[tokenId];
134         
135         ownerOf[tokenId] = to;
136         emit Transfer(from, to, tokenId); 
137 
138     }
139 
140     function _mint(address to, uint256 tokenId) internal { 
141         require(ownerOf[tokenId] == address(0), "ALREADY_MINTED");
142 
143         uint supply = oldSupply + minted++;
144         uint maxSupply = 5000;
145         require(supply <= maxSupply, "MAX SUPPLY REACHED");
146         totalSupply++;
147                 
148         // This is safe because the sum of all user
149         // balances can't exceed type(uint256).max!
150         unchecked {
151             balanceOf[to]++;
152         }
153         
154         ownerOf[tokenId] = to;
155                 
156         emit Transfer(address(0), to, tokenId); 
157     }
158     
159     function _burn(uint256 tokenId) internal { 
160         address owner_ = ownerOf[tokenId];
161         
162         require(ownerOf[tokenId] != address(0), "NOT_MINTED");
163         
164         totalSupply--;
165         balanceOf[owner_]--;
166         
167         delete ownerOf[tokenId];
168                 
169         emit Transfer(owner_, address(0), tokenId); 
170     }
171 }
172 
173 
174 // File: contracts/ERC20.sol
175 
176 pragma solidity ^0.8.7;
177 
178 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
179 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
180 
181 contract ERC20 {
182     /*///////////////////////////////////////////////////////////////
183                                   EVENTS
184     //////////////////////////////////////////////////////////////*/
185 
186     event Transfer(address indexed from, address indexed to, uint256 value);
187     event Approval(address indexed owner, address indexed spender, uint256 value);
188 
189     /*///////////////////////////////////////////////////////////////
190                              METADATA STORAGE
191     //////////////////////////////////////////////////////////////*/
192 
193     string public name;
194     string public symbol;
195     uint8  public decimals;
196 
197     /*///////////////////////////////////////////////////////////////
198                              ERC20 STORAGE
199     //////////////////////////////////////////////////////////////*/
200 
201     uint256 public totalSupply;
202 
203     mapping(address => uint256) public balanceOf;
204 
205     mapping(address => mapping(address => uint256)) public allowance;
206 
207     mapping(address => bool) public isMinter;
208 
209     address public ruler;
210 
211     /*///////////////////////////////////////////////////////////////
212                               ERC20 LOGIC
213     //////////////////////////////////////////////////////////////*/
214 
215     constructor(string memory _name, string memory _symbol, uint8 _decimals) { 
216         ruler = msg.sender;
217         name = _name;
218         symbol = _symbol;
219         decimals = _decimals;
220     }
221 
222     function approve(address spender, uint256 value) external returns (bool) {
223         allowance[msg.sender][spender] = value;
224 
225         emit Approval(msg.sender, spender, value);
226 
227         return true;
228     }
229 
230     function transfer(address to, uint256 value) external returns (bool) {
231         balanceOf[msg.sender] -= value;
232 
233         // This is safe because the sum of all user
234         // balances can't exceed type(uint256).max!
235         unchecked {
236             balanceOf[to] += value;
237         }
238 
239         emit Transfer(msg.sender, to, value);
240 
241         return true;
242     }
243 
244     function transferFrom(
245         address from,
246         address to,
247         uint256 value
248     ) external returns (bool) {
249         if (allowance[from][msg.sender] != type(uint256).max) {
250             allowance[from][msg.sender] -= value;
251         }
252 
253         balanceOf[from] -= value;
254 
255         // This is safe because the sum of all user
256         // balances can't exceed type(uint256).max!
257         unchecked {
258             balanceOf[to] += value;
259         }
260 
261         emit Transfer(from, to, value);
262 
263         return true;
264     }
265 
266     /*///////////////////////////////////////////////////////////////
267                              ORC PRIVILEGE
268     //////////////////////////////////////////////////////////////*/
269 
270     function mint(address to, uint256 value) external {
271         require(isMinter[msg.sender], "FORBIDDEN TO MINT");
272         _mint(to, value);
273     }
274 
275     function burn(address from, uint256 value) external {
276         require(isMinter[msg.sender], "FORBIDDEN TO BURN");
277         _burn(from, value);
278     }
279 
280     /*///////////////////////////////////////////////////////////////
281                          Ruler Function
282     //////////////////////////////////////////////////////////////*/
283 
284     function setMinter(address minter, bool status) external {
285         require(msg.sender == ruler, "NOT ALLOWED TO RULE");
286 
287         isMinter[minter] = status;
288     }
289 
290     function setRuler(address ruler_) external {
291         require(msg.sender == ruler ||ruler == address(0), "NOT ALLOWED TO RULE");
292 
293         ruler = ruler_;
294     }
295 
296 
297     /*///////////////////////////////////////////////////////////////
298                           INTERNAL UTILS
299     //////////////////////////////////////////////////////////////*/
300 
301     function _mint(address to, uint256 value) internal {
302         totalSupply += value;
303 
304         // This is safe because the sum of all user
305         // balances can't exceed type(uint256).max!
306         unchecked {
307             balanceOf[to] += value;
308         }
309 
310         emit Transfer(address(0), to, value);
311     }
312 
313     function _burn(address from, uint256 value) internal {
314         balanceOf[from] -= value;
315 
316         // This is safe because a user won't ever
317         // have a balance larger than totalSupply!
318         unchecked {
319             totalSupply -= value;
320         }
321 
322         emit Transfer(from, address(0), value);
323     }
324 }
325 // File: hardhat/console.sol
326 
327 
328 pragma solidity >= 0.4.22 <0.9.0;
329 
330 library console {
331 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
332 
333 	function _sendLogPayload(bytes memory payload) private view {
334 		uint256 payloadLength = payload.length;
335 		address consoleAddress = CONSOLE_ADDRESS;
336 		assembly {
337 			let payloadStart := add(payload, 32)
338 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
339 		}
340 	}
341 
342 	function log() internal view {
343 		_sendLogPayload(abi.encodeWithSignature("log()"));
344 	}
345 
346 	function logInt(int p0) internal view {
347 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
348 	}
349 
350 	function logUint(uint p0) internal view {
351 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
352 	}
353 
354 	function logString(string memory p0) internal view {
355 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
356 	}
357 
358 	function logBool(bool p0) internal view {
359 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
360 	}
361 
362 	function logAddress(address p0) internal view {
363 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
364 	}
365 
366 	function logBytes(bytes memory p0) internal view {
367 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
368 	}
369 
370 	function logBytes1(bytes1 p0) internal view {
371 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
372 	}
373 
374 	function logBytes2(bytes2 p0) internal view {
375 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
376 	}
377 
378 	function logBytes3(bytes3 p0) internal view {
379 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
380 	}
381 
382 	function logBytes4(bytes4 p0) internal view {
383 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
384 	}
385 
386 	function logBytes5(bytes5 p0) internal view {
387 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
388 	}
389 
390 	function logBytes6(bytes6 p0) internal view {
391 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
392 	}
393 
394 	function logBytes7(bytes7 p0) internal view {
395 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
396 	}
397 
398 	function logBytes8(bytes8 p0) internal view {
399 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
400 	}
401 
402 	function logBytes9(bytes9 p0) internal view {
403 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
404 	}
405 
406 	function logBytes10(bytes10 p0) internal view {
407 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
408 	}
409 
410 	function logBytes11(bytes11 p0) internal view {
411 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
412 	}
413 
414 	function logBytes12(bytes12 p0) internal view {
415 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
416 	}
417 
418 	function logBytes13(bytes13 p0) internal view {
419 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
420 	}
421 
422 	function logBytes14(bytes14 p0) internal view {
423 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
424 	}
425 
426 	function logBytes15(bytes15 p0) internal view {
427 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
428 	}
429 
430 	function logBytes16(bytes16 p0) internal view {
431 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
432 	}
433 
434 	function logBytes17(bytes17 p0) internal view {
435 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
436 	}
437 
438 	function logBytes18(bytes18 p0) internal view {
439 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
440 	}
441 
442 	function logBytes19(bytes19 p0) internal view {
443 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
444 	}
445 
446 	function logBytes20(bytes20 p0) internal view {
447 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
448 	}
449 
450 	function logBytes21(bytes21 p0) internal view {
451 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
452 	}
453 
454 	function logBytes22(bytes22 p0) internal view {
455 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
456 	}
457 
458 	function logBytes23(bytes23 p0) internal view {
459 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
460 	}
461 
462 	function logBytes24(bytes24 p0) internal view {
463 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
464 	}
465 
466 	function logBytes25(bytes25 p0) internal view {
467 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
468 	}
469 
470 	function logBytes26(bytes26 p0) internal view {
471 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
472 	}
473 
474 	function logBytes27(bytes27 p0) internal view {
475 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
476 	}
477 
478 	function logBytes28(bytes28 p0) internal view {
479 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
480 	}
481 
482 	function logBytes29(bytes29 p0) internal view {
483 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
484 	}
485 
486 	function logBytes30(bytes30 p0) internal view {
487 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
488 	}
489 
490 	function logBytes31(bytes31 p0) internal view {
491 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
492 	}
493 
494 	function logBytes32(bytes32 p0) internal view {
495 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
496 	}
497 
498 	function log(uint p0) internal view {
499 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
500 	}
501 
502 	function log(string memory p0) internal view {
503 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
504 	}
505 
506 	function log(bool p0) internal view {
507 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
508 	}
509 
510 	function log(address p0) internal view {
511 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
512 	}
513 
514 	function log(uint p0, uint p1) internal view {
515 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
516 	}
517 
518 	function log(uint p0, string memory p1) internal view {
519 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
520 	}
521 
522 	function log(uint p0, bool p1) internal view {
523 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
524 	}
525 
526 	function log(uint p0, address p1) internal view {
527 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
528 	}
529 
530 	function log(string memory p0, uint p1) internal view {
531 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
532 	}
533 
534 	function log(string memory p0, string memory p1) internal view {
535 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
536 	}
537 
538 	function log(string memory p0, bool p1) internal view {
539 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
540 	}
541 
542 	function log(string memory p0, address p1) internal view {
543 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
544 	}
545 
546 	function log(bool p0, uint p1) internal view {
547 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
548 	}
549 
550 	function log(bool p0, string memory p1) internal view {
551 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
552 	}
553 
554 	function log(bool p0, bool p1) internal view {
555 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
556 	}
557 
558 	function log(bool p0, address p1) internal view {
559 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
560 	}
561 
562 	function log(address p0, uint p1) internal view {
563 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
564 	}
565 
566 	function log(address p0, string memory p1) internal view {
567 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
568 	}
569 
570 	function log(address p0, bool p1) internal view {
571 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
572 	}
573 
574 	function log(address p0, address p1) internal view {
575 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
576 	}
577 
578 	function log(uint p0, uint p1, uint p2) internal view {
579 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
580 	}
581 
582 	function log(uint p0, uint p1, string memory p2) internal view {
583 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
584 	}
585 
586 	function log(uint p0, uint p1, bool p2) internal view {
587 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
588 	}
589 
590 	function log(uint p0, uint p1, address p2) internal view {
591 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
592 	}
593 
594 	function log(uint p0, string memory p1, uint p2) internal view {
595 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
596 	}
597 
598 	function log(uint p0, string memory p1, string memory p2) internal view {
599 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
600 	}
601 
602 	function log(uint p0, string memory p1, bool p2) internal view {
603 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
604 	}
605 
606 	function log(uint p0, string memory p1, address p2) internal view {
607 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
608 	}
609 
610 	function log(uint p0, bool p1, uint p2) internal view {
611 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
612 	}
613 
614 	function log(uint p0, bool p1, string memory p2) internal view {
615 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
616 	}
617 
618 	function log(uint p0, bool p1, bool p2) internal view {
619 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
620 	}
621 
622 	function log(uint p0, bool p1, address p2) internal view {
623 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
624 	}
625 
626 	function log(uint p0, address p1, uint p2) internal view {
627 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
628 	}
629 
630 	function log(uint p0, address p1, string memory p2) internal view {
631 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
632 	}
633 
634 	function log(uint p0, address p1, bool p2) internal view {
635 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
636 	}
637 
638 	function log(uint p0, address p1, address p2) internal view {
639 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
640 	}
641 
642 	function log(string memory p0, uint p1, uint p2) internal view {
643 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
644 	}
645 
646 	function log(string memory p0, uint p1, string memory p2) internal view {
647 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
648 	}
649 
650 	function log(string memory p0, uint p1, bool p2) internal view {
651 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
652 	}
653 
654 	function log(string memory p0, uint p1, address p2) internal view {
655 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
656 	}
657 
658 	function log(string memory p0, string memory p1, uint p2) internal view {
659 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
660 	}
661 
662 	function log(string memory p0, string memory p1, string memory p2) internal view {
663 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
664 	}
665 
666 	function log(string memory p0, string memory p1, bool p2) internal view {
667 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
668 	}
669 
670 	function log(string memory p0, string memory p1, address p2) internal view {
671 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
672 	}
673 
674 	function log(string memory p0, bool p1, uint p2) internal view {
675 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
676 	}
677 
678 	function log(string memory p0, bool p1, string memory p2) internal view {
679 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
680 	}
681 
682 	function log(string memory p0, bool p1, bool p2) internal view {
683 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
684 	}
685 
686 	function log(string memory p0, bool p1, address p2) internal view {
687 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
688 	}
689 
690 	function log(string memory p0, address p1, uint p2) internal view {
691 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
692 	}
693 
694 	function log(string memory p0, address p1, string memory p2) internal view {
695 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
696 	}
697 
698 	function log(string memory p0, address p1, bool p2) internal view {
699 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
700 	}
701 
702 	function log(string memory p0, address p1, address p2) internal view {
703 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
704 	}
705 
706 	function log(bool p0, uint p1, uint p2) internal view {
707 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
708 	}
709 
710 	function log(bool p0, uint p1, string memory p2) internal view {
711 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
712 	}
713 
714 	function log(bool p0, uint p1, bool p2) internal view {
715 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
716 	}
717 
718 	function log(bool p0, uint p1, address p2) internal view {
719 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
720 	}
721 
722 	function log(bool p0, string memory p1, uint p2) internal view {
723 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
724 	}
725 
726 	function log(bool p0, string memory p1, string memory p2) internal view {
727 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
728 	}
729 
730 	function log(bool p0, string memory p1, bool p2) internal view {
731 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
732 	}
733 
734 	function log(bool p0, string memory p1, address p2) internal view {
735 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
736 	}
737 
738 	function log(bool p0, bool p1, uint p2) internal view {
739 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
740 	}
741 
742 	function log(bool p0, bool p1, string memory p2) internal view {
743 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
744 	}
745 
746 	function log(bool p0, bool p1, bool p2) internal view {
747 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
748 	}
749 
750 	function log(bool p0, bool p1, address p2) internal view {
751 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
752 	}
753 
754 	function log(bool p0, address p1, uint p2) internal view {
755 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
756 	}
757 
758 	function log(bool p0, address p1, string memory p2) internal view {
759 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
760 	}
761 
762 	function log(bool p0, address p1, bool p2) internal view {
763 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
764 	}
765 
766 	function log(bool p0, address p1, address p2) internal view {
767 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
768 	}
769 
770 	function log(address p0, uint p1, uint p2) internal view {
771 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
772 	}
773 
774 	function log(address p0, uint p1, string memory p2) internal view {
775 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
776 	}
777 
778 	function log(address p0, uint p1, bool p2) internal view {
779 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
780 	}
781 
782 	function log(address p0, uint p1, address p2) internal view {
783 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
784 	}
785 
786 	function log(address p0, string memory p1, uint p2) internal view {
787 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
788 	}
789 
790 	function log(address p0, string memory p1, string memory p2) internal view {
791 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
792 	}
793 
794 	function log(address p0, string memory p1, bool p2) internal view {
795 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
796 	}
797 
798 	function log(address p0, string memory p1, address p2) internal view {
799 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
800 	}
801 
802 	function log(address p0, bool p1, uint p2) internal view {
803 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
804 	}
805 
806 	function log(address p0, bool p1, string memory p2) internal view {
807 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
808 	}
809 
810 	function log(address p0, bool p1, bool p2) internal view {
811 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
812 	}
813 
814 	function log(address p0, bool p1, address p2) internal view {
815 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
816 	}
817 
818 	function log(address p0, address p1, uint p2) internal view {
819 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
820 	}
821 
822 	function log(address p0, address p1, string memory p2) internal view {
823 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
824 	}
825 
826 	function log(address p0, address p1, bool p2) internal view {
827 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
828 	}
829 
830 	function log(address p0, address p1, address p2) internal view {
831 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
832 	}
833 
834 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
835 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
836 	}
837 
838 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
839 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
840 	}
841 
842 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
843 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
844 	}
845 
846 	function log(uint p0, uint p1, uint p2, address p3) internal view {
847 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
848 	}
849 
850 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
851 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
852 	}
853 
854 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
855 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
856 	}
857 
858 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
859 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
860 	}
861 
862 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
863 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
864 	}
865 
866 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
867 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
868 	}
869 
870 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
871 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
872 	}
873 
874 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
875 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
876 	}
877 
878 	function log(uint p0, uint p1, bool p2, address p3) internal view {
879 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
880 	}
881 
882 	function log(uint p0, uint p1, address p2, uint p3) internal view {
883 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
884 	}
885 
886 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
887 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
888 	}
889 
890 	function log(uint p0, uint p1, address p2, bool p3) internal view {
891 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
892 	}
893 
894 	function log(uint p0, uint p1, address p2, address p3) internal view {
895 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
896 	}
897 
898 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
899 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
900 	}
901 
902 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
903 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
904 	}
905 
906 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
907 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
908 	}
909 
910 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
911 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
912 	}
913 
914 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
915 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
916 	}
917 
918 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
919 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
920 	}
921 
922 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
923 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
924 	}
925 
926 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
927 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
928 	}
929 
930 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
931 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
932 	}
933 
934 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
935 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
936 	}
937 
938 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
939 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
940 	}
941 
942 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
943 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
944 	}
945 
946 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
947 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
948 	}
949 
950 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
951 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
952 	}
953 
954 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
955 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
956 	}
957 
958 	function log(uint p0, string memory p1, address p2, address p3) internal view {
959 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
960 	}
961 
962 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
963 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
964 	}
965 
966 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
967 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
968 	}
969 
970 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
971 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
972 	}
973 
974 	function log(uint p0, bool p1, uint p2, address p3) internal view {
975 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
976 	}
977 
978 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
979 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
980 	}
981 
982 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
983 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
984 	}
985 
986 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
987 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
988 	}
989 
990 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
991 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
992 	}
993 
994 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
995 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
996 	}
997 
998 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
999 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1000 	}
1001 
1002 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1003 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1004 	}
1005 
1006 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1007 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1008 	}
1009 
1010 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1011 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1012 	}
1013 
1014 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1015 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1016 	}
1017 
1018 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1019 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1020 	}
1021 
1022 	function log(uint p0, bool p1, address p2, address p3) internal view {
1023 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1024 	}
1025 
1026 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1027 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1028 	}
1029 
1030 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1031 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1032 	}
1033 
1034 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1035 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1036 	}
1037 
1038 	function log(uint p0, address p1, uint p2, address p3) internal view {
1039 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1040 	}
1041 
1042 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1043 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1044 	}
1045 
1046 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1047 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1048 	}
1049 
1050 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1051 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1052 	}
1053 
1054 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1055 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1056 	}
1057 
1058 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1059 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1060 	}
1061 
1062 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1063 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1064 	}
1065 
1066 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1067 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1068 	}
1069 
1070 	function log(uint p0, address p1, bool p2, address p3) internal view {
1071 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1072 	}
1073 
1074 	function log(uint p0, address p1, address p2, uint p3) internal view {
1075 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1076 	}
1077 
1078 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1079 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1080 	}
1081 
1082 	function log(uint p0, address p1, address p2, bool p3) internal view {
1083 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1084 	}
1085 
1086 	function log(uint p0, address p1, address p2, address p3) internal view {
1087 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1088 	}
1089 
1090 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1091 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1092 	}
1093 
1094 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1095 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1096 	}
1097 
1098 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1099 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1100 	}
1101 
1102 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1103 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1104 	}
1105 
1106 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1107 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1108 	}
1109 
1110 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1111 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1112 	}
1113 
1114 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1115 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1116 	}
1117 
1118 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1119 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1120 	}
1121 
1122 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1123 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1124 	}
1125 
1126 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1127 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1128 	}
1129 
1130 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1131 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1132 	}
1133 
1134 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1135 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1136 	}
1137 
1138 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1139 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1140 	}
1141 
1142 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1143 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1144 	}
1145 
1146 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1147 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1148 	}
1149 
1150 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1151 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1152 	}
1153 
1154 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1155 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1156 	}
1157 
1158 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1159 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1160 	}
1161 
1162 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1163 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1164 	}
1165 
1166 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1167 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1168 	}
1169 
1170 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1171 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1172 	}
1173 
1174 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1175 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1176 	}
1177 
1178 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1179 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1180 	}
1181 
1182 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1183 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1184 	}
1185 
1186 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1187 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1188 	}
1189 
1190 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1191 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1192 	}
1193 
1194 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1195 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1196 	}
1197 
1198 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1199 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1200 	}
1201 
1202 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1203 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1204 	}
1205 
1206 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1207 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1208 	}
1209 
1210 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1211 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1212 	}
1213 
1214 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
1215 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1216 	}
1217 
1218 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
1219 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
1220 	}
1221 
1222 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
1223 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
1224 	}
1225 
1226 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
1227 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
1228 	}
1229 
1230 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
1231 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
1232 	}
1233 
1234 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
1235 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
1236 	}
1237 
1238 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1239 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1240 	}
1241 
1242 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1243 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1244 	}
1245 
1246 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1247 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1248 	}
1249 
1250 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
1251 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
1252 	}
1253 
1254 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1255 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1256 	}
1257 
1258 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1259 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1260 	}
1261 
1262 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
1263 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1264 	}
1265 
1266 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
1267 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1268 	}
1269 
1270 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1271 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1272 	}
1273 
1274 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1275 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1276 	}
1277 
1278 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1279 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1280 	}
1281 
1282 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
1283 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
1284 	}
1285 
1286 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1287 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1288 	}
1289 
1290 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1291 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1292 	}
1293 
1294 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1295 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1296 	}
1297 
1298 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1299 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1300 	}
1301 
1302 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1303 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1304 	}
1305 
1306 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1307 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1308 	}
1309 
1310 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1311 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1312 	}
1313 
1314 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1315 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1316 	}
1317 
1318 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1319 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1320 	}
1321 
1322 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1323 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1324 	}
1325 
1326 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1327 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1328 	}
1329 
1330 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1331 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1332 	}
1333 
1334 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1335 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1336 	}
1337 
1338 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1339 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1340 	}
1341 
1342 	function log(string memory p0, address p1, address p2, address p3) internal view {
1343 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1344 	}
1345 
1346 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1347 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1348 	}
1349 
1350 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1351 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1352 	}
1353 
1354 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1355 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1356 	}
1357 
1358 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1359 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1360 	}
1361 
1362 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1363 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1364 	}
1365 
1366 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1367 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1368 	}
1369 
1370 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1371 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1372 	}
1373 
1374 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1375 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1376 	}
1377 
1378 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1379 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1380 	}
1381 
1382 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1383 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1384 	}
1385 
1386 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1387 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1388 	}
1389 
1390 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1391 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1392 	}
1393 
1394 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1395 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1396 	}
1397 
1398 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1399 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1400 	}
1401 
1402 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1403 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1404 	}
1405 
1406 	function log(bool p0, uint p1, address p2, address p3) internal view {
1407 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1408 	}
1409 
1410 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1411 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1412 	}
1413 
1414 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1415 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1416 	}
1417 
1418 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1419 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1420 	}
1421 
1422 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1423 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1424 	}
1425 
1426 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1427 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1428 	}
1429 
1430 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1431 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1432 	}
1433 
1434 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1435 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1436 	}
1437 
1438 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1439 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1440 	}
1441 
1442 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1443 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1444 	}
1445 
1446 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1447 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1448 	}
1449 
1450 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1451 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1452 	}
1453 
1454 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1455 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1456 	}
1457 
1458 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1459 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1460 	}
1461 
1462 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1463 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1464 	}
1465 
1466 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1467 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1468 	}
1469 
1470 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1471 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1472 	}
1473 
1474 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1475 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1476 	}
1477 
1478 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1479 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1480 	}
1481 
1482 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1483 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1484 	}
1485 
1486 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1487 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1488 	}
1489 
1490 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1491 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1492 	}
1493 
1494 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1495 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1496 	}
1497 
1498 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1499 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1500 	}
1501 
1502 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1503 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1504 	}
1505 
1506 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1507 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1508 	}
1509 
1510 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1511 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1512 	}
1513 
1514 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1515 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1516 	}
1517 
1518 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1519 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1520 	}
1521 
1522 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1523 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1524 	}
1525 
1526 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1527 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1528 	}
1529 
1530 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1531 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1532 	}
1533 
1534 	function log(bool p0, bool p1, address p2, address p3) internal view {
1535 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1536 	}
1537 
1538 	function log(bool p0, address p1, uint p2, uint p3) internal view {
1539 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
1540 	}
1541 
1542 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
1543 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
1544 	}
1545 
1546 	function log(bool p0, address p1, uint p2, bool p3) internal view {
1547 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
1548 	}
1549 
1550 	function log(bool p0, address p1, uint p2, address p3) internal view {
1551 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
1552 	}
1553 
1554 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
1555 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
1556 	}
1557 
1558 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1559 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1560 	}
1561 
1562 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1563 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1564 	}
1565 
1566 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1567 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1568 	}
1569 
1570 	function log(bool p0, address p1, bool p2, uint p3) internal view {
1571 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
1572 	}
1573 
1574 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1575 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1576 	}
1577 
1578 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1579 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1580 	}
1581 
1582 	function log(bool p0, address p1, bool p2, address p3) internal view {
1583 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1584 	}
1585 
1586 	function log(bool p0, address p1, address p2, uint p3) internal view {
1587 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
1588 	}
1589 
1590 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1591 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1592 	}
1593 
1594 	function log(bool p0, address p1, address p2, bool p3) internal view {
1595 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1596 	}
1597 
1598 	function log(bool p0, address p1, address p2, address p3) internal view {
1599 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1600 	}
1601 
1602 	function log(address p0, uint p1, uint p2, uint p3) internal view {
1603 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
1604 	}
1605 
1606 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
1607 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
1608 	}
1609 
1610 	function log(address p0, uint p1, uint p2, bool p3) internal view {
1611 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
1612 	}
1613 
1614 	function log(address p0, uint p1, uint p2, address p3) internal view {
1615 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
1616 	}
1617 
1618 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
1619 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
1620 	}
1621 
1622 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
1623 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
1624 	}
1625 
1626 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
1627 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
1628 	}
1629 
1630 	function log(address p0, uint p1, string memory p2, address p3) internal view {
1631 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
1632 	}
1633 
1634 	function log(address p0, uint p1, bool p2, uint p3) internal view {
1635 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
1636 	}
1637 
1638 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
1639 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
1640 	}
1641 
1642 	function log(address p0, uint p1, bool p2, bool p3) internal view {
1643 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
1644 	}
1645 
1646 	function log(address p0, uint p1, bool p2, address p3) internal view {
1647 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
1648 	}
1649 
1650 	function log(address p0, uint p1, address p2, uint p3) internal view {
1651 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
1652 	}
1653 
1654 	function log(address p0, uint p1, address p2, string memory p3) internal view {
1655 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
1656 	}
1657 
1658 	function log(address p0, uint p1, address p2, bool p3) internal view {
1659 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
1660 	}
1661 
1662 	function log(address p0, uint p1, address p2, address p3) internal view {
1663 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
1664 	}
1665 
1666 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
1667 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
1668 	}
1669 
1670 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
1671 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
1672 	}
1673 
1674 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
1675 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
1676 	}
1677 
1678 	function log(address p0, string memory p1, uint p2, address p3) internal view {
1679 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
1680 	}
1681 
1682 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
1683 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
1684 	}
1685 
1686 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
1687 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
1688 	}
1689 
1690 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
1691 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
1692 	}
1693 
1694 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
1695 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
1696 	}
1697 
1698 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
1699 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
1700 	}
1701 
1702 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
1703 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
1704 	}
1705 
1706 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
1707 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
1708 	}
1709 
1710 	function log(address p0, string memory p1, bool p2, address p3) internal view {
1711 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
1712 	}
1713 
1714 	function log(address p0, string memory p1, address p2, uint p3) internal view {
1715 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
1716 	}
1717 
1718 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
1719 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
1720 	}
1721 
1722 	function log(address p0, string memory p1, address p2, bool p3) internal view {
1723 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
1724 	}
1725 
1726 	function log(address p0, string memory p1, address p2, address p3) internal view {
1727 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
1728 	}
1729 
1730 	function log(address p0, bool p1, uint p2, uint p3) internal view {
1731 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
1732 	}
1733 
1734 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
1735 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
1736 	}
1737 
1738 	function log(address p0, bool p1, uint p2, bool p3) internal view {
1739 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
1740 	}
1741 
1742 	function log(address p0, bool p1, uint p2, address p3) internal view {
1743 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
1744 	}
1745 
1746 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
1747 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
1748 	}
1749 
1750 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
1751 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
1752 	}
1753 
1754 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
1755 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
1756 	}
1757 
1758 	function log(address p0, bool p1, string memory p2, address p3) internal view {
1759 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
1760 	}
1761 
1762 	function log(address p0, bool p1, bool p2, uint p3) internal view {
1763 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
1764 	}
1765 
1766 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
1767 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
1768 	}
1769 
1770 	function log(address p0, bool p1, bool p2, bool p3) internal view {
1771 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
1772 	}
1773 
1774 	function log(address p0, bool p1, bool p2, address p3) internal view {
1775 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
1776 	}
1777 
1778 	function log(address p0, bool p1, address p2, uint p3) internal view {
1779 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
1780 	}
1781 
1782 	function log(address p0, bool p1, address p2, string memory p3) internal view {
1783 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
1784 	}
1785 
1786 	function log(address p0, bool p1, address p2, bool p3) internal view {
1787 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
1788 	}
1789 
1790 	function log(address p0, bool p1, address p2, address p3) internal view {
1791 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
1792 	}
1793 
1794 	function log(address p0, address p1, uint p2, uint p3) internal view {
1795 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
1796 	}
1797 
1798 	function log(address p0, address p1, uint p2, string memory p3) internal view {
1799 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
1800 	}
1801 
1802 	function log(address p0, address p1, uint p2, bool p3) internal view {
1803 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
1804 	}
1805 
1806 	function log(address p0, address p1, uint p2, address p3) internal view {
1807 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
1808 	}
1809 
1810 	function log(address p0, address p1, string memory p2, uint p3) internal view {
1811 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
1812 	}
1813 
1814 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
1815 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
1816 	}
1817 
1818 	function log(address p0, address p1, string memory p2, bool p3) internal view {
1819 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
1820 	}
1821 
1822 	function log(address p0, address p1, string memory p2, address p3) internal view {
1823 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
1824 	}
1825 
1826 	function log(address p0, address p1, bool p2, uint p3) internal view {
1827 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
1828 	}
1829 
1830 	function log(address p0, address p1, bool p2, string memory p3) internal view {
1831 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
1832 	}
1833 
1834 	function log(address p0, address p1, bool p2, bool p3) internal view {
1835 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
1836 	}
1837 
1838 	function log(address p0, address p1, bool p2, address p3) internal view {
1839 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
1840 	}
1841 
1842 	function log(address p0, address p1, address p2, uint p3) internal view {
1843 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
1844 	}
1845 
1846 	function log(address p0, address p1, address p2, string memory p3) internal view {
1847 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
1848 	}
1849 
1850 	function log(address p0, address p1, address p2, bool p3) internal view {
1851 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
1852 	}
1853 
1854 	function log(address p0, address p1, address p2, address p3) internal view {
1855 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
1856 	}
1857 
1858 }
1859 
1860 // File: contracts/Chicken.sol
1861 
1862 //SPDX-License-Identifier: MIT
1863 
1864 pragma solidity ^0.8.7;
1865 
1866 
1867 
1868 
1869 
1870 contract Chickens is ERC721 {
1871     uint256 public constant MAX_SUPPLY = 5000;
1872     bool public mintActive;
1873 
1874     uint8[] public raritiesFatness;
1875     uint8[] public aliasesFatness;
1876     // used to ensure there are no duplicates
1877     mapping(uint256 => uint256) public existingCombinations;
1878     // fatness level: 1-5
1879     uint256[] public feedingPrice;
1880 
1881     mapping(address => bool) public auth;
1882     mapping(uint256 => Chicken) internal chickens;
1883     mapping(uint256 => Action) public activities;
1884     // god chickens : Chicken, Cow, Omnipollo, FatHen
1885     mapping(uint256 => uint8) public godChicken; // tokenId => godId
1886     uint8 public godMinted;
1887 
1888     // reference to Traits
1889     ITraits public traits;
1890     ERC20 public egg;
1891     uint256 public eggClaimedTotal;
1892 
1893     bytes32 internal entropySauce;
1894     mapping(uint256 => uint256) public mintBlocks;
1895 
1896     function setAddresses(
1897         address _traits,
1898         address _egg
1899     ) external onlyOwner {
1900         traits = ITraits(_traits);
1901         egg = ERC20(_egg);
1902     }
1903 
1904     function setAuth(address add, bool isAuth) external onlyOwner {
1905         auth[add] = isAuth;
1906     }
1907 
1908     function transferOwnership(address newOwner) external onlyOwner {
1909         admin = newOwner;
1910     }
1911 
1912     function setMintStatus(bool _status) external onlyOwner {
1913         mintActive = _status;
1914     }
1915 
1916     // Render
1917 
1918     function tokenURI(uint256 tokenId) public view returns (string memory) {
1919         // chickens[tokenId] empty check
1920         require(mintBlocks[tokenId] != block.number, "ERC721Metadata: URI query for nonexistent token");
1921         return traits.tokenURI(tokenId);
1922     }
1923 
1924     event ActionMade(
1925         address owner,
1926         uint256 id,
1927         uint256 timestamp,
1928         uint8 activity
1929     );
1930     event ActionFeedChickens(
1931         address owner,
1932         uint256 id,
1933         uint256 newLevel
1934     );
1935     event GodChickenMinted(
1936         address owner,
1937         uint256 tokenId,
1938         uint8 godId
1939     );
1940 
1941     struct Chicken {
1942         uint8 comb;
1943         uint8 face;
1944         uint8 body;
1945         // Colors - Primary, Secondary, Tertiary
1946         uint8 color1;
1947         uint8 color2;
1948         uint8 color3;
1949         uint8 fatness;
1950         uint8 lvlFatness;
1951         uint16 level;
1952     }
1953     enum Actions {
1954         UNSTAKED,
1955         FARMING,
1956         LEVELUP
1957     }
1958     struct Action {
1959         address owner;
1960         uint88 timestamp;
1961         Actions action;
1962     }
1963 
1964     // Constructor
1965     constructor() {
1966         admin = msg.sender;
1967     }
1968 
1969     function initialize() public onlyOwner {
1970         admin = msg.sender;
1971         auth[msg.sender] = true;
1972 
1973         mintActive = false;
1974         // A.J. Walker's Alias Algorithm
1975         raritiesFatness = [189, 253, 127, 94, 31];
1976         aliasesFatness = [1, 4, 0, 0, 0];
1977         feedingPrice = [
1978             3 ether,
1979             5 ether,
1980             10 ether,
1981             20 ether
1982         ];
1983     }
1984 
1985     // Modifiers
1986 
1987     modifier noCheaters() {
1988         uint256 size = 0;
1989         address acc = msg.sender;
1990         assembly {
1991             size := extcodesize(acc)
1992         }
1993 
1994         require(
1995             auth[msg.sender] || (msg.sender == tx.origin && size == 0),
1996             "you're trying to cheat!"
1997         );
1998         _;
1999 
2000         // We'll use the last caller hash to add entropy to next caller
2001         entropySauce = keccak256(abi.encodePacked(acc, block.coinbase, entropySauce));
2002     }
2003 
2004     modifier ownerOfChicken(uint256 id) {
2005         require(
2006             ownerOf[id] == msg.sender || activities[id].owner == msg.sender,
2007             "not your chicken"
2008         );
2009         _;
2010     }
2011 
2012     modifier onlyOwner() {
2013         require(msg.sender == admin);
2014         _;
2015     }
2016 
2017     // Public Functions
2018 
2019     function mintChickens() public noCheaters {
2020         require(mintActive, "Must be active to mint");
2021         require(totalSupply <= MAX_SUPPLY, "All supply minted");
2022         uint256 cost = mintPriceEgg();
2023         if (cost > 0) egg.burn(msg.sender, cost);
2024         _mintChicken(msg.sender);
2025     }
2026 
2027     function feedChickens(uint256 id) public noCheaters {
2028         _claim(id);
2029 
2030         uint8 lvlFatness = chickens[id].lvlFatness;
2031         require(lvlFatness < 5, "Already max level");
2032         egg.burn(msg.sender, feedingPrice[lvlFatness-1]);
2033         chickens[id].lvlFatness = lvlFatness + 1;
2034 
2035         emit ActionFeedChickens(msg.sender, id, lvlFatness + 1);
2036     }
2037 
2038     function mintGodChickens(uint256 id) public noCheaters {
2039         require(godMinted < 4, "Minted all");
2040         require(chickens[id].level >= 24, "Low level");
2041         _claim(id);
2042         egg.burn(msg.sender, 300 ether);
2043 
2044         godMinted++;
2045         godChicken[id] = godMinted;
2046 
2047         emit GodChickenMinted(msg.sender, id, godMinted);
2048     }
2049 
2050     function doAction(uint256 id, Actions action_)
2051         public
2052         ownerOfChicken(id)
2053         noCheaters
2054     {
2055         _doAction(id, msg.sender, action_);
2056     }
2057 
2058     function _doAction(
2059         uint256 id,
2060         address chickenOwner,
2061         Actions action_
2062     ) internal {
2063         Action memory action = activities[id];
2064         require(action.action != action_, "already doing that");
2065         // if ((action.action == Actions.FARMING) && (action_ == Actions.LEVELUP) || (action.action == Actions.LEVELUP) && (action_ == Actions.FARMING)) // not allowed?
2066 
2067         // Picking the largest value between block.timestamp, action.timestamp and startingTime
2068         uint88 timestamp = uint88(
2069             block.timestamp > action.timestamp
2070                 ? block.timestamp
2071                 : action.timestamp
2072         );
2073 
2074         if (action.action == Actions.UNSTAKED) _transfer(chickenOwner, address(this), id);
2075         else {
2076             if (block.timestamp > action.timestamp) _claim(id);
2077             timestamp = timestamp > action.timestamp ? timestamp : action.timestamp;
2078         }
2079 
2080         address owner_ = action_ == Actions.UNSTAKED ? address(0) : chickenOwner;
2081         if (action_ == Actions.UNSTAKED) _transfer(address(this), chickenOwner, id);
2082 
2083         activities[id] = Action({
2084             owner: owner_,
2085             timestamp: timestamp,
2086             action: action_
2087         });
2088         emit ActionMade(chickenOwner, id, block.timestamp, uint8(action_));
2089     }
2090 
2091     function doActionWithManyChickens(uint256[] calldata ids, Actions action_)
2092         external
2093     {
2094         for (uint256 index = 0; index < ids.length; index++) {
2095             require(
2096                 ownerOf[ids[index]] == msg.sender || activities[ids[index]].owner == msg.sender,
2097                 "Not your chicken"
2098             );
2099             _doAction(ids[index], msg.sender, action_);
2100         }
2101     }
2102 
2103     function claim(uint256[] calldata ids) external {
2104         for (uint256 index = 0; index < ids.length; index++) {
2105             _claim(ids[index]);
2106         }
2107     }
2108 
2109     function _claim(uint256 id) internal noCheaters {
2110         Action memory action = activities[id];
2111 
2112         if (block.timestamp <= action.timestamp) return;
2113 
2114         uint256 timeDiff = uint256(block.timestamp - action.timestamp);
2115 
2116         if (action.action == Actions.FARMING) {
2117             uint256 eggAmount = claimableEgg(timeDiff, id, action.owner);
2118             egg.mint(action.owner, eggAmount);
2119             eggClaimedTotal += eggAmount;
2120         } else if (action.action == Actions.LEVELUP) {
2121             chickens[id].level += uint16(timeDiff / 1 days);
2122         }
2123 
2124         activities[id].timestamp = uint88(block.timestamp);
2125     }
2126 
2127     // Viewers
2128 
2129     function getTokenTraits(uint256 tokenId) external view virtual returns (Chicken memory) {
2130         if (mintBlocks[tokenId] == block.number) return chickens[0];
2131         return chickens[tokenId];
2132     }
2133 
2134     function mintPriceEgg() public view returns (uint256) {
2135         uint256 supply = minted;
2136         if (supply < 2500) return 0;
2137         if (supply < 3000) return 10 ether;
2138         if (supply < 3500) return 20 ether;
2139         if (supply < 4000) return 25 ether;
2140         if (supply < 4500) return 30 ether;
2141         if (supply < 5000) return 50 ether;
2142         return 50 ether;
2143     }
2144 
2145     function claimable(uint256 id) external view returns (uint256) {
2146         if (activities[id].action == Actions.FARMING) {
2147             uint256 timeDiff = block.timestamp > activities[id].timestamp
2148                 ? uint256(block.timestamp - activities[id].timestamp)
2149                 : 0;
2150             return claimableEgg(timeDiff, id, activities[id].owner);
2151         }
2152         if (activities[id].action == Actions.LEVELUP) {
2153             uint256 timeDiff = block.timestamp > activities[id].timestamp
2154                 ? uint256(block.timestamp - activities[id].timestamp)
2155                 : 0;
2156             return timeDiff / 1 days;
2157         }
2158         return 0;
2159     }
2160 
2161     function name() external pure returns (string memory) {
2162         return "Chickens";
2163     }
2164 
2165     function symbol() external pure returns (string memory) {
2166         return "Chickens";
2167     }
2168 
2169     // Internal Functions
2170 
2171     function _mintChicken(address to) internal {
2172         uint16 id = uint16(totalSupply + 1);
2173         mintBlocks[id] = block.number;
2174         uint256 seed = random(id);
2175         generate(id, seed);
2176         _mint(to, id);
2177     }
2178 
2179     function claimableEgg(uint256 timeDiff, uint256 id, address owner_) internal view returns (uint256)
2180     {
2181         if(eggClaimedTotal >= 250_000 ether) return 0;
2182         Chicken memory chicken = chickens[id];
2183         uint256 eggAmount = (timeDiff * 1 ether * chicken.lvlFatness) / 1 days;
2184         return eggAmount;
2185     }
2186 
2187     function generate(uint256 tokenId, uint256 seed) internal returns (Chicken memory t) {
2188         t = selectTraits(seed);
2189         chickens[tokenId] = t;
2190         return t;
2191 
2192         // keep the following code for future use, current version using different seed, so no need for now
2193         // if (existingCombinations[structToHash(t)] == 0) {
2194         //     chickens[tokenId] = t;
2195         //     existingCombinations[structToHash(t)] = tokenId;
2196         //     return t;
2197         // }
2198         // return generate(tokenId, random(seed));
2199     }
2200 
2201     function selectTrait(uint16 seed, uint8 traitType) internal view returns (uint8) {
2202         if (traitType == 0) return uint8(seed) % 12;
2203         if (traitType == 1) return uint8(seed) % 12;
2204         if (traitType == 2) return uint8(seed) % 12;
2205         if (traitType == 3) return uint8(seed) % 20;
2206         if (traitType == 4) return uint8(seed) % 20;
2207         if (traitType == 5) return uint8(seed) % 20;
2208         if (traitType == 6) return uint8(seed) % 5;
2209 
2210         // fatness rarity
2211         uint8 trait = uint8(seed) % uint8(raritiesFatness.length);
2212         if (seed >> 8 < raritiesFatness[trait]) return trait;
2213         return aliasesFatness[trait];
2214     }
2215 
2216     function selectTraits(uint256 seed) internal view returns (Chicken memory t) {    
2217         t.comb = selectTrait(uint16(seed & 0xFFFF), 0);
2218         seed >>= 16;
2219         t.face = selectTrait(uint16(seed & 0xFFFF), 1);
2220         seed >>= 16;
2221         t.body = selectTrait(uint16(seed & 0xFFFF), 2);
2222         seed >>= 16;
2223         t.color1 = selectTrait(uint16(seed & 0xFFFF), 3);
2224         seed >>= 16;
2225         t.color2 = selectTrait(uint16(seed & 0xFFFF), 4);
2226         seed >>= 16;
2227         t.color3 = selectTrait(uint16(seed & 0xFFFF), 5);
2228         seed >>= 16;
2229         t.fatness = selectTrait(uint16(seed & 0xFFFF), 6);
2230         seed >>= 16;
2231         t.lvlFatness = selectTrait(uint16(seed & 0xFFFF), 7) + 1;
2232         t.level = 1;
2233     }
2234 
2235     function structToHash(Chicken memory s) internal pure returns (uint256) {
2236         return uint256(bytes32(
2237         abi.encodePacked(
2238             s.comb,
2239             s.face,
2240             s.body,
2241             s.color1,
2242             s.color2,
2243             s.color3,
2244             s.fatness,
2245             s.lvlFatness
2246         )
2247         ));
2248     }
2249 
2250     function random(uint256 seed) internal view returns (uint256) {
2251         return uint256(keccak256(abi.encodePacked(
2252             tx.origin,
2253             blockhash(block.number - 1),
2254             block.timestamp,
2255             seed
2256         )));
2257     }
2258 }