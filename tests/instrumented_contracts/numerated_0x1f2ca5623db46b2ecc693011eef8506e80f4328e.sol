1 // File: contracts/Reversi.sol
2 
3 pragma solidity ^0.4.18;
4 
5 library Reversi {
6     // event DebugBool(bool boolean);
7     // event DebugBoard(bytes16 board);
8     // event DebugUint(uint u);
9     uint8 constant BLACK = 1; //0b01 //0x1
10     uint8 constant WHITE = 2; //0b10 //0x2
11     uint8 constant EMPTY = 3; //0b11 //0x3
12 
13     struct Game {
14         bool error;
15         bool complete;
16         bool symmetrical;
17         bool RotSym;
18         bool Y0Sym;
19         bool X0Sym;
20         bool XYSym;
21         bool XnYSym;
22         bytes16 board;
23         bytes28 first32Moves;
24         bytes28 lastMoves;
25 
26         uint8 currentPlayer;
27         uint8 moveKey;
28         uint8 blackScore;
29         uint8 whiteScore;
30         // string msg;
31     }
32 
33 
34     function isValid (bytes28[2] moves) public pure returns (bool) {
35         Game memory game = playGame(moves);
36         if (game.error) {
37             return false;
38         } else if (!game.complete) {
39             return false;
40         } else {
41             return true;
42         }
43     }
44 
45     function getGame (bytes28[2] moves) public pure returns (bool error, bool complete, bool symmetrical, bytes16 board, uint8 currentPlayer, uint8 moveKey) {
46       Game memory game = playGame(moves);
47         return (
48             game.error,
49             game.complete,
50             game.symmetrical,
51             game.board,
52             game.currentPlayer,
53             game.moveKey
54             // game.msg
55         );
56     }
57 
58     function showColors () public pure returns(uint8, uint8, uint8) {
59         return (EMPTY, BLACK, WHITE);
60     }
61 
62     function playGame (bytes28[2] moves) internal pure returns (Game)  {
63         Game memory game;
64 
65         game.first32Moves = moves[0];
66         game.lastMoves = moves[1];
67         game.moveKey = 0;
68         game.blackScore = 2;
69         game.whiteScore = 2;
70 
71         game.error = false;
72         game.complete = false;
73         game.currentPlayer = BLACK;
74 
75 
76         // game.board = bytes16(10625432672847758622720); // completely empty board
77         game.board = bytes16(340282366920938456379662753540715053055); // empty board except for center pieces
78 
79         bool skip;
80         uint8 move;
81         uint8 col;
82         uint8 row;
83         uint8 i;
84         bytes28 currentMoves;
85 
86         for (i = 0; i < 60 && !skip; i++) {
87             currentMoves = game.moveKey < 32 ? game.first32Moves : game.lastMoves;
88             move = readMove(currentMoves, game.moveKey % 32, 32);
89             (col, row) = convertMove(move);
90             skip = !validMove(move);
91             if (i == 0 && (col != 2 || row != 3)) {
92                 skip = true; // this is to force the first move to always be C4 to avoid repeatable boards via mirroring translations
93                 game.error = true;
94             }
95             if (!skip && col < 8 && row < 8 && col >= 0 && row >= 0) {
96                 // game.msg = "make a move";
97                 game = makeMove(game, col, row);
98                 game.moveKey = game.moveKey + 1;
99                 if (game.error) {
100                     game.error = false;
101                     // maybe player has no valid moves and must pass
102                     if (game.currentPlayer == BLACK) {
103                         game.currentPlayer = WHITE;
104                     } else {
105                         game.currentPlayer = BLACK;
106                     }
107                     game = makeMove(game, col, row);
108                     if (game.error) {
109                         game.error = true;
110                         skip = true;
111                     }
112                 }
113             }
114         }
115         if (!game.error) {
116             game.error = false;
117             game = isComplete(game);
118             game = isSymmetrical(game);
119         }
120         return game;
121     }
122 
123     function makeMove (Game memory game, uint8 col, uint8 row) internal pure returns (Game)  {
124         // square is already occupied
125         if (returnTile(game.board, col, row) != EMPTY){
126             game.error = true;
127             // game.msg = "Invalid Game (square is already occupied)";
128             return game;
129         }
130         int8[2][8] memory possibleDirections;
131         uint8  possibleDirectionsLength;
132         (possibleDirections, possibleDirectionsLength) = getPossibleDirections(game, col, row);
133         // no valid directions
134         if (possibleDirectionsLength == 0) {
135             game.error = true;
136             // game.msg = "Invalid Game (doesnt border other tiles)";
137             return game;
138         }
139 
140         bytes28 newFlips;
141         uint8 newFlipsLength;
142         uint8 newFlipCol;
143         uint8 newFlipRow;
144         uint8 j;
145         bool valid = false;
146         for (uint8 i = 0; i < possibleDirectionsLength; i++) {
147             delete newFlips;
148             delete newFlipsLength;
149             (newFlips, newFlipsLength) = traverseDirection(game, possibleDirections[i], col, row);
150             for (j = 0; j < newFlipsLength; j++) {
151                 if (!valid) valid = true;
152                 (newFlipCol, newFlipRow) = convertMove(readMove(newFlips, j, newFlipsLength));
153                 game.board = turnTile(game.board, game.currentPlayer, newFlipCol, newFlipRow);
154                 if (game.currentPlayer == WHITE) {
155                     game.whiteScore += 1;
156                     game.blackScore -= 1;
157                 } else {
158                     game.whiteScore -= 1;
159                     game.blackScore += 1;
160                 }
161             }
162         }
163 
164         //no valid flips in directions
165         if (valid) {
166             game.board = turnTile(game.board, game.currentPlayer, col, row);
167             if (game.currentPlayer == WHITE) {
168                 game.whiteScore += 1;
169             } else {
170                 game.blackScore += 1;
171             }
172         } else {
173             game.error = true;
174             // game.msg = "Invalid Game (doesnt flip any other tiles)";
175             return game;
176         }
177 
178         // switch players
179         if (game.currentPlayer == BLACK) {
180             game.currentPlayer = WHITE;
181         } else {
182             game.currentPlayer = BLACK;
183         }
184         return game;
185     }
186 
187     function getPossibleDirections (Game memory game, uint8 col, uint8 row) internal pure returns(int8[2][8], uint8){
188 
189         int8[2][8] memory possibleDirections;
190         uint8 possibleDirectionsLength = 0;
191         int8[2][8] memory dirs = [
192             [int8(-1), int8(0)], // W
193             [int8(-1), int8(1)], // SW
194             [int8(0), int8(1)], // S
195             [int8(1), int8(1)], // SE
196             [int8(1), int8(0)], // E
197             [int8(1), int8(-1)], // NE
198             [int8(0), int8(-1)], // N
199             [int8(-1), int8(-1)] // NW
200         ];
201         int8 focusedRowPos;
202         int8 focusedColPos;
203         int8[2] memory dir;
204         uint8 testSquare;
205 
206         for (uint8 i = 0; i < 8; i++) {
207             dir = dirs[i];
208             focusedColPos = int8(col) + dir[0];
209             focusedRowPos = int8(row) + dir[1];
210 
211             // if tile is off the board it is not a valid move
212             if (!(focusedRowPos > 7 || focusedRowPos < 0 || focusedColPos > 7 || focusedColPos < 0)) {
213                 testSquare = returnTile(game.board, uint8(focusedColPos), uint8(focusedRowPos));
214 
215                 // if the surrounding tile is current color or no color it can"t be part of a capture
216                 if (testSquare != game.currentPlayer) {
217                     if (testSquare != EMPTY) {
218                         possibleDirections[possibleDirectionsLength] = dir;
219                         possibleDirectionsLength++;
220                     }
221                 }
222             }
223         }
224         return (possibleDirections, possibleDirectionsLength);
225     }
226 
227     function traverseDirection (Game memory game, int8[2] dir, uint8 col, uint8 row) internal pure returns(bytes28, uint8) {
228         bytes28 potentialFlips;
229         uint8 potentialFlipsLength = 0;
230 
231         if (game.currentPlayer == BLACK) {
232             uint8 opponentColor = WHITE;
233         } else {
234             opponentColor = BLACK;
235         }
236 
237         // take one step at a time in this direction
238         // ignoring the first step look for the same color as your tile
239         bool skip = false;
240         int8 testCol;
241         int8 testRow;
242         uint8 tile;
243         for (uint8 j = 1; j < 9; j++) {
244             if (!skip) {
245                 testCol = (int8(j) * dir[0]) + int8(col);
246                 testRow = (int8(j) * dir[1]) + int8(row);
247                 // ran off the board before hitting your own tile
248                 if (testCol > 7 || testCol < 0 || testRow > 7 || testRow < 0) {
249                     delete potentialFlips;
250                     potentialFlipsLength = 0;
251                     skip = true;
252                 } else{
253 
254                     tile = returnTile(game.board, uint8(testCol), uint8(testRow));
255 
256                     if (tile == opponentColor) {
257                         // if tile is opposite color it could be flipped, so add to potential flip array
258                         (potentialFlips, potentialFlipsLength) = addMove(potentialFlips, potentialFlipsLength, uint8(testCol), uint8(testRow));
259                     } else if (tile == game.currentPlayer && j > 1) {
260                         // hit current players tile which means capture is complete
261                         skip = true;
262                     } else {
263                         // either hit current players own color before hitting an opponent"s
264                         // or hit an empty space
265                         delete potentialFlips;
266                         delete potentialFlipsLength;
267                         skip = true;
268                     }
269                 }
270             }
271         }
272         return (potentialFlips, potentialFlipsLength);
273     }
274 
275     function isComplete (Game memory game) internal pure returns (Game) {
276 
277         if (game.moveKey == 60) {
278             // game.msg = "good game";
279             game.complete = true;
280             return game;
281         } else {
282             uint8[2][60] memory empties;
283             uint8 emptiesLength = 0;
284             for (uint8 i = 0; i < 64; i++) {
285                 uint8 tile = returnTile(game.board, ((i - (i % 8)) / 8), (i % 8));
286                 if (tile == EMPTY) {
287                     empties[emptiesLength] = [((i - (i % 8)) / 8), (i % 8)];
288                     emptiesLength++;
289                 }
290             }
291             bool validMovesRemains = false;
292             if (emptiesLength > 0) {
293                 bytes16 board = game.board;
294                 uint8[2] memory move;
295                 for (i = 0; i < emptiesLength && !validMovesRemains; i++) {
296                     move = empties[i];
297 
298                     game.currentPlayer = BLACK;
299                     game.error = false;
300                     game.board = board;
301                     game = makeMove(game, move[0], move[1]);
302                     if (!game.error) {
303                         validMovesRemains = true;
304                     }
305                     game.currentPlayer = WHITE;
306                     game.error = false;
307                     game.board = board;
308                     game = makeMove(game, move[0], move[1]);
309                     if (!game.error) {
310                         validMovesRemains = true;
311                     }
312                 }
313                 game.board = board;
314             }
315             if (validMovesRemains) {
316                 game.error = true;
317                 // game.msg = "Invalid Game (moves still available)";
318             } else {
319                 // game.msg = "good game";
320                 game.complete = true;
321                 game.error = false;
322             }
323         }
324         return game;
325     }
326 
327     function isSymmetrical (Game memory game) internal pure returns (Game) {
328         bool RotSym = true;
329         bool Y0Sym = true;
330         bool X0Sym = true;
331         bool XYSym = true;
332         bool XnYSym = true;
333         for (uint8 i = 0; i < 8 && (RotSym || Y0Sym || X0Sym || XYSym || XnYSym); i++) {
334             for (uint8 j = 0; j < 8 && (RotSym || Y0Sym || X0Sym || XYSym || XnYSym); j++) {
335 
336                 // rotational symmetry
337                 if (returnBytes(game.board, i, j) != returnBytes(game.board, (7 - i), (7 - j))) {
338                     RotSym = false;
339                 }
340                 // symmetry on y = 0
341                 if (returnBytes(game.board, i, j) != returnBytes(game.board, i, (7 - j))) {
342                     Y0Sym = false;
343                 }
344                 // symmetry on x = 0
345                 if (returnBytes(game.board, i, j) != returnBytes(game.board, (7 - i), j)) {
346                     X0Sym = false;
347                 }
348                 // symmetry on x = y
349                 if (returnBytes(game.board, i, j) != returnBytes(game.board, (7 - j), (7 - i))) {
350                     XYSym = false;
351                 }
352                 // symmetry on x = -y
353                 if (returnBytes(game.board, i, j) != returnBytes(game.board, j, i)) {
354                     XnYSym = false;
355                 }
356             }
357         }
358         if (RotSym || Y0Sym || X0Sym || XYSym || XnYSym) {
359             game.symmetrical = true;
360             game.RotSym = RotSym;
361             game.Y0Sym = Y0Sym;
362             game.X0Sym = X0Sym;
363             game.XYSym = XYSym;
364             game.XnYSym = XnYSym;
365         }
366         return game;
367     }
368 
369 
370 
371     // Utilities
372 
373     function returnSymmetricals (bool RotSym, bool Y0Sym, bool X0Sym, bool XYSym, bool XnYSym) public view returns (uint256) {
374         uint256 symmetries = (RotSym ? 1  : 0) << 1;
375         symmetries = (symmetries & (Y0Sym ? 1 : 0)) << 1;
376         symmetries = (symmetries & (X0Sym ? 1 : 0)) << 1;
377         symmetries = (symmetries & (XYSym ? 1 : 0)) << 1;
378         symmetries = symmetries & (XnYSym ? 1 : 0);
379         return symmetries;
380     }
381 
382 
383     function returnBytes (bytes16 board, uint8 col, uint8 row) internal pure returns (bytes16) {
384         uint128 push = posToPush(col, row);
385         return (board >> push) & bytes16(3);
386     }
387 
388     function turnTile (bytes16 board, uint8 color, uint8 col, uint8 row) internal pure returns (bytes16){
389         if (col > 7) revert();
390         if (row > 7) revert();
391         uint128 push = posToPush(col, row);
392         bytes16 mask = bytes16(3) << push;// 0b00000011 (ones)
393 
394         board = ((board ^ mask) & board);
395 
396         return board | (bytes16(color) << push);
397     }
398 
399     function returnTile (bytes16 board, uint8 col, uint8 row) internal pure returns (uint8){
400         uint128 push = posToPush(col, row);
401         bytes16 tile = (board >> push ) & bytes16(3);
402         return uint8(tile); // returns 2
403     }
404 
405     function posToPush (uint8 col, uint8 row) internal pure returns (uint128){
406         return uint128(((64) - ((8 * col) + row + 1)) * 2);
407     }
408 
409     function readMove (bytes28 moveSequence, uint8 moveKey, uint8 movesLength) public pure returns(uint8) {
410         bytes28 mask = bytes28(127);
411         uint8 push = (movesLength * 7) - (moveKey * 7) - 7;
412         return uint8((moveSequence >> push) & mask);
413     }
414 
415     function addMove (bytes28 moveSequence, uint8 movesLength, uint8 col, uint8 row) internal pure returns (bytes28, uint8) {
416         bytes28 move = bytes28(col + (row * 8) + 64);
417         moveSequence = moveSequence << 7;
418         moveSequence = moveSequence | move;
419         movesLength++;
420         return (moveSequence, movesLength);
421     }
422 
423     function validMove (uint8 move) internal pure returns(bool) {
424         return move >= 64;
425     }
426 
427     function convertMove (uint8 move) public pure returns(uint8, uint8) {
428         move = move - 64;
429         uint8 col = move % 8;
430         uint8 row = (move - col) / 8;
431         return (col, row);
432     }
433 
434 
435 }
436 
437 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
438 
439 pragma solidity ^0.4.24;
440 
441 
442 /**
443  * @title ERC20Basic
444  * @dev Simpler version of ERC20 interface
445  * See https://github.com/ethereum/EIPs/issues/179
446  */
447 contract ERC20Basic {
448   function totalSupply() public view returns (uint256);
449   function balanceOf(address who) public view returns (uint256);
450   function transfer(address to, uint256 value) public returns (bool);
451   event Transfer(address indexed from, address indexed to, uint256 value);
452 }
453 
454 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
455 
456 pragma solidity ^0.4.24;
457 
458 
459 
460 /**
461  * @title ERC20 interface
462  * @dev see https://github.com/ethereum/EIPs/issues/20
463  */
464 contract ERC20 is ERC20Basic {
465   function allowance(address owner, address spender)
466     public view returns (uint256);
467 
468   function transferFrom(address from, address to, uint256 value)
469     public returns (bool);
470 
471   function approve(address spender, uint256 value) public returns (bool);
472   event Approval(
473     address indexed owner,
474     address indexed spender,
475     uint256 value
476   );
477 }
478 
479 // File: zeppelin-solidity/contracts/introspection/ERC165.sol
480 
481 pragma solidity ^0.4.24;
482 
483 
484 /**
485  * @title ERC165
486  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
487  */
488 interface ERC165 {
489 
490   /**
491    * @notice Query if a contract implements an interface
492    * @param _interfaceId The interface identifier, as specified in ERC-165
493    * @dev Interface identification is specified in ERC-165. This function
494    * uses less than 30,000 gas.
495    */
496   function supportsInterface(bytes4 _interfaceId)
497     external
498     view
499     returns (bool);
500 }
501 
502 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
503 
504 pragma solidity ^0.4.24;
505 
506 
507 
508 /**
509  * @title ERC721 Non-Fungible Token Standard basic interface
510  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
511  */
512 contract ERC721Basic is ERC165 {
513   event Transfer(
514     address indexed _from,
515     address indexed _to,
516     uint256 indexed _tokenId
517   );
518   event Approval(
519     address indexed _owner,
520     address indexed _approved,
521     uint256 indexed _tokenId
522   );
523   event ApprovalForAll(
524     address indexed _owner,
525     address indexed _operator,
526     bool _approved
527   );
528 
529   function balanceOf(address _owner) public view returns (uint256 _balance);
530   function ownerOf(uint256 _tokenId) public view returns (address _owner);
531   function exists(uint256 _tokenId) public view returns (bool _exists);
532 
533   function approve(address _to, uint256 _tokenId) public;
534   function getApproved(uint256 _tokenId)
535     public view returns (address _operator);
536 
537   function setApprovalForAll(address _operator, bool _approved) public;
538   function isApprovedForAll(address _owner, address _operator)
539     public view returns (bool);
540 
541   function transferFrom(address _from, address _to, uint256 _tokenId) public;
542   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
543     public;
544 
545   function safeTransferFrom(
546     address _from,
547     address _to,
548     uint256 _tokenId,
549     bytes _data
550   )
551     public;
552 }
553 
554 // File: zeppelin-solidity/contracts/token/ERC721/ERC721.sol
555 
556 pragma solidity ^0.4.24;
557 
558 
559 
560 /**
561  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
562  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
563  */
564 contract ERC721Enumerable is ERC721Basic {
565   function totalSupply() public view returns (uint256);
566   function tokenOfOwnerByIndex(
567     address _owner,
568     uint256 _index
569   )
570     public
571     view
572     returns (uint256 _tokenId);
573 
574   function tokenByIndex(uint256 _index) public view returns (uint256);
575 }
576 
577 
578 /**
579  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
580  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
581  */
582 contract ERC721Metadata is ERC721Basic {
583   function name() external view returns (string _name);
584   function symbol() external view returns (string _symbol);
585   function tokenURI(uint256 _tokenId) public view returns (string);
586 }
587 
588 
589 /**
590  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
591  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
592  */
593 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
594 }
595 
596 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
597 
598 pragma solidity ^0.4.24;
599 
600 
601 /**
602  * @title ERC721 token receiver interface
603  * @dev Interface for any contract that wants to support safeTransfers
604  * from ERC721 asset contracts.
605  */
606 contract ERC721Receiver {
607   /**
608    * @dev Magic value to be returned upon successful reception of an NFT
609    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
610    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
611    */
612   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
613 
614   /**
615    * @notice Handle the receipt of an NFT
616    * @dev The ERC721 smart contract calls this function on the recipient
617    * after a `safetransfer`. This function MAY throw to revert and reject the
618    * transfer. Return of other than the magic value MUST result in the 
619    * transaction being reverted.
620    * Note: the contract address is always the message sender.
621    * @param _operator The address which called `safeTransferFrom` function
622    * @param _from The address which previously owned the token
623    * @param _tokenId The NFT identifier which is being transfered
624    * @param _data Additional data with no specified format
625    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
626    */
627   function onERC721Received(
628     address _operator,
629     address _from,
630     uint256 _tokenId,
631     bytes _data
632   )
633     public
634     returns(bytes4);
635 }
636 
637 // File: zeppelin-solidity/contracts/math/SafeMath.sol
638 
639 pragma solidity ^0.4.24;
640 
641 
642 /**
643  * @title SafeMath
644  * @dev Math operations with safety checks that throw on error
645  */
646 library SafeMath {
647 
648   /**
649   * @dev Multiplies two numbers, throws on overflow.
650   */
651   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
652     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
653     // benefit is lost if 'b' is also tested.
654     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
655     if (a == 0) {
656       return 0;
657     }
658 
659     c = a * b;
660     assert(c / a == b);
661     return c;
662   }
663 
664   /**
665   * @dev Integer division of two numbers, truncating the quotient.
666   */
667   function div(uint256 a, uint256 b) internal pure returns (uint256) {
668     // assert(b > 0); // Solidity automatically throws when dividing by 0
669     // uint256 c = a / b;
670     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
671     return a / b;
672   }
673 
674   /**
675   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
676   */
677   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
678     assert(b <= a);
679     return a - b;
680   }
681 
682   /**
683   * @dev Adds two numbers, throws on overflow.
684   */
685   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
686     c = a + b;
687     assert(c >= a);
688     return c;
689   }
690 }
691 
692 // File: zeppelin-solidity/contracts/AddressUtils.sol
693 
694 pragma solidity ^0.4.24;
695 
696 
697 /**
698  * Utility library of inline functions on addresses
699  */
700 library AddressUtils {
701 
702   /**
703    * Returns whether the target address is a contract
704    * @dev This function will return false if invoked during the constructor of a contract,
705    * as the code is not actually created until after the constructor finishes.
706    * @param addr address to check
707    * @return whether the target address is a contract
708    */
709   function isContract(address addr) internal view returns (bool) {
710     uint256 size;
711     // XXX Currently there is no better way to check if there is a contract in an address
712     // than to check the size of the code at that address.
713     // See https://ethereum.stackexchange.com/a/14016/36603
714     // for more details about how this works.
715     // TODO Check this again before the Serenity release, because all addresses will be
716     // contracts then.
717     // solium-disable-next-line security/no-inline-assembly
718     assembly { size := extcodesize(addr) }
719     return size > 0;
720   }
721 
722 }
723 
724 // File: zeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
725 
726 pragma solidity ^0.4.24;
727 
728 
729 
730 /**
731  * @title SupportsInterfaceWithLookup
732  * @author Matt Condon (@shrugs)
733  * @dev Implements ERC165 using a lookup table.
734  */
735 contract SupportsInterfaceWithLookup is ERC165 {
736   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
737   /**
738    * 0x01ffc9a7 ===
739    *   bytes4(keccak256('supportsInterface(bytes4)'))
740    */
741 
742   /**
743    * @dev a mapping of interface id to whether or not it's supported
744    */
745   mapping(bytes4 => bool) internal supportedInterfaces;
746 
747   /**
748    * @dev A contract implementing SupportsInterfaceWithLookup
749    * implement ERC165 itself
750    */
751   constructor()
752     public
753   {
754     _registerInterface(InterfaceId_ERC165);
755   }
756 
757   /**
758    * @dev implement supportsInterface(bytes4) using a lookup table
759    */
760   function supportsInterface(bytes4 _interfaceId)
761     external
762     view
763     returns (bool)
764   {
765     return supportedInterfaces[_interfaceId];
766   }
767 
768   /**
769    * @dev private method for registering an interface
770    */
771   function _registerInterface(bytes4 _interfaceId)
772     internal
773   {
774     require(_interfaceId != 0xffffffff);
775     supportedInterfaces[_interfaceId] = true;
776   }
777 }
778 
779 // File: zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
780 
781 pragma solidity ^0.4.24;
782 
783 
784 
785 
786 
787 
788 
789 /**
790  * @title ERC721 Non-Fungible Token Standard basic implementation
791  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
792  */
793 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
794 
795   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
796   /*
797    * 0x80ac58cd ===
798    *   bytes4(keccak256('balanceOf(address)')) ^
799    *   bytes4(keccak256('ownerOf(uint256)')) ^
800    *   bytes4(keccak256('approve(address,uint256)')) ^
801    *   bytes4(keccak256('getApproved(uint256)')) ^
802    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
803    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
804    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
805    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
806    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
807    */
808 
809   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
810   /*
811    * 0x4f558e79 ===
812    *   bytes4(keccak256('exists(uint256)'))
813    */
814 
815   using SafeMath for uint256;
816   using AddressUtils for address;
817 
818   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
819   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
820   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
821 
822   // Mapping from token ID to owner
823   mapping (uint256 => address) internal tokenOwner;
824 
825   // Mapping from token ID to approved address
826   mapping (uint256 => address) internal tokenApprovals;
827 
828   // Mapping from owner to number of owned token
829   mapping (address => uint256) internal ownedTokensCount;
830 
831   // Mapping from owner to operator approvals
832   mapping (address => mapping (address => bool)) internal operatorApprovals;
833 
834   /**
835    * @dev Guarantees msg.sender is owner of the given token
836    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
837    */
838   modifier onlyOwnerOf(uint256 _tokenId) {
839     require(ownerOf(_tokenId) == msg.sender);
840     _;
841   }
842 
843   /**
844    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
845    * @param _tokenId uint256 ID of the token to validate
846    */
847   modifier canTransfer(uint256 _tokenId) {
848     require(isApprovedOrOwner(msg.sender, _tokenId));
849     _;
850   }
851 
852   constructor()
853     public
854   {
855     // register the supported interfaces to conform to ERC721 via ERC165
856     _registerInterface(InterfaceId_ERC721);
857     _registerInterface(InterfaceId_ERC721Exists);
858   }
859 
860   /**
861    * @dev Gets the balance of the specified address
862    * @param _owner address to query the balance of
863    * @return uint256 representing the amount owned by the passed address
864    */
865   function balanceOf(address _owner) public view returns (uint256) {
866     require(_owner != address(0));
867     return ownedTokensCount[_owner];
868   }
869 
870   /**
871    * @dev Gets the owner of the specified token ID
872    * @param _tokenId uint256 ID of the token to query the owner of
873    * @return owner address currently marked as the owner of the given token ID
874    */
875   function ownerOf(uint256 _tokenId) public view returns (address) {
876     address owner = tokenOwner[_tokenId];
877     require(owner != address(0));
878     return owner;
879   }
880 
881   /**
882    * @dev Returns whether the specified token exists
883    * @param _tokenId uint256 ID of the token to query the existence of
884    * @return whether the token exists
885    */
886   function exists(uint256 _tokenId) public view returns (bool) {
887     address owner = tokenOwner[_tokenId];
888     return owner != address(0);
889   }
890 
891   /**
892    * @dev Approves another address to transfer the given token ID
893    * The zero address indicates there is no approved address.
894    * There can only be one approved address per token at a given time.
895    * Can only be called by the token owner or an approved operator.
896    * @param _to address to be approved for the given token ID
897    * @param _tokenId uint256 ID of the token to be approved
898    */
899   function approve(address _to, uint256 _tokenId) public {
900     address owner = ownerOf(_tokenId);
901     require(_to != owner);
902     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
903 
904     tokenApprovals[_tokenId] = _to;
905     emit Approval(owner, _to, _tokenId);
906   }
907 
908   /**
909    * @dev Gets the approved address for a token ID, or zero if no address set
910    * @param _tokenId uint256 ID of the token to query the approval of
911    * @return address currently approved for the given token ID
912    */
913   function getApproved(uint256 _tokenId) public view returns (address) {
914     return tokenApprovals[_tokenId];
915   }
916 
917   /**
918    * @dev Sets or unsets the approval of a given operator
919    * An operator is allowed to transfer all tokens of the sender on their behalf
920    * @param _to operator address to set the approval
921    * @param _approved representing the status of the approval to be set
922    */
923   function setApprovalForAll(address _to, bool _approved) public {
924     require(_to != msg.sender);
925     operatorApprovals[msg.sender][_to] = _approved;
926     emit ApprovalForAll(msg.sender, _to, _approved);
927   }
928 
929   /**
930    * @dev Tells whether an operator is approved by a given owner
931    * @param _owner owner address which you want to query the approval of
932    * @param _operator operator address which you want to query the approval of
933    * @return bool whether the given operator is approved by the given owner
934    */
935   function isApprovedForAll(
936     address _owner,
937     address _operator
938   )
939     public
940     view
941     returns (bool)
942   {
943     return operatorApprovals[_owner][_operator];
944   }
945 
946   /**
947    * @dev Transfers the ownership of a given token ID to another address
948    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
949    * Requires the msg sender to be the owner, approved, or operator
950    * @param _from current owner of the token
951    * @param _to address to receive the ownership of the given token ID
952    * @param _tokenId uint256 ID of the token to be transferred
953   */
954   function transferFrom(
955     address _from,
956     address _to,
957     uint256 _tokenId
958   )
959     public
960     canTransfer(_tokenId)
961   {
962     require(_from != address(0));
963     require(_to != address(0));
964 
965     clearApproval(_from, _tokenId);
966     removeTokenFrom(_from, _tokenId);
967     addTokenTo(_to, _tokenId);
968 
969     emit Transfer(_from, _to, _tokenId);
970   }
971 
972   /**
973    * @dev Safely transfers the ownership of a given token ID to another address
974    * If the target address is a contract, it must implement `onERC721Received`,
975    * which is called upon a safe transfer, and return the magic value
976    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
977    * the transfer is reverted.
978    *
979    * Requires the msg sender to be the owner, approved, or operator
980    * @param _from current owner of the token
981    * @param _to address to receive the ownership of the given token ID
982    * @param _tokenId uint256 ID of the token to be transferred
983   */
984   function safeTransferFrom(
985     address _from,
986     address _to,
987     uint256 _tokenId
988   )
989     public
990     canTransfer(_tokenId)
991   {
992     // solium-disable-next-line arg-overflow
993     safeTransferFrom(_from, _to, _tokenId, "");
994   }
995 
996   /**
997    * @dev Safely transfers the ownership of a given token ID to another address
998    * If the target address is a contract, it must implement `onERC721Received`,
999    * which is called upon a safe transfer, and return the magic value
1000    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1001    * the transfer is reverted.
1002    * Requires the msg sender to be the owner, approved, or operator
1003    * @param _from current owner of the token
1004    * @param _to address to receive the ownership of the given token ID
1005    * @param _tokenId uint256 ID of the token to be transferred
1006    * @param _data bytes data to send along with a safe transfer check
1007    */
1008   function safeTransferFrom(
1009     address _from,
1010     address _to,
1011     uint256 _tokenId,
1012     bytes _data
1013   )
1014     public
1015     canTransfer(_tokenId)
1016   {
1017     transferFrom(_from, _to, _tokenId);
1018     // solium-disable-next-line arg-overflow
1019     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
1020   }
1021 
1022   /**
1023    * @dev Returns whether the given spender can transfer a given token ID
1024    * @param _spender address of the spender to query
1025    * @param _tokenId uint256 ID of the token to be transferred
1026    * @return bool whether the msg.sender is approved for the given token ID,
1027    *  is an operator of the owner, or is the owner of the token
1028    */
1029   function isApprovedOrOwner(
1030     address _spender,
1031     uint256 _tokenId
1032   )
1033     internal
1034     view
1035     returns (bool)
1036   {
1037     address owner = ownerOf(_tokenId);
1038     // Disable solium check because of
1039     // https://github.com/duaraghav8/Solium/issues/175
1040     // solium-disable-next-line operator-whitespace
1041     return (
1042       _spender == owner ||
1043       getApproved(_tokenId) == _spender ||
1044       isApprovedForAll(owner, _spender)
1045     );
1046   }
1047 
1048   /**
1049    * @dev Internal function to mint a new token
1050    * Reverts if the given token ID already exists
1051    * @param _to The address that will own the minted token
1052    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1053    */
1054   function _mint(address _to, uint256 _tokenId) internal {
1055     require(_to != address(0));
1056     addTokenTo(_to, _tokenId);
1057     emit Transfer(address(0), _to, _tokenId);
1058   }
1059 
1060   /**
1061    * @dev Internal function to burn a specific token
1062    * Reverts if the token does not exist
1063    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1064    */
1065   function _burn(address _owner, uint256 _tokenId) internal {
1066     clearApproval(_owner, _tokenId);
1067     removeTokenFrom(_owner, _tokenId);
1068     emit Transfer(_owner, address(0), _tokenId);
1069   }
1070 
1071   /**
1072    * @dev Internal function to clear current approval of a given token ID
1073    * Reverts if the given address is not indeed the owner of the token
1074    * @param _owner owner of the token
1075    * @param _tokenId uint256 ID of the token to be transferred
1076    */
1077   function clearApproval(address _owner, uint256 _tokenId) internal {
1078     require(ownerOf(_tokenId) == _owner);
1079     if (tokenApprovals[_tokenId] != address(0)) {
1080       tokenApprovals[_tokenId] = address(0);
1081     }
1082   }
1083 
1084   /**
1085    * @dev Internal function to add a token ID to the list of a given address
1086    * @param _to address representing the new owner of the given token ID
1087    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1088    */
1089   function addTokenTo(address _to, uint256 _tokenId) internal {
1090     require(tokenOwner[_tokenId] == address(0));
1091     tokenOwner[_tokenId] = _to;
1092     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
1093   }
1094 
1095   /**
1096    * @dev Internal function to remove a token ID from the list of a given address
1097    * @param _from address representing the previous owner of the given token ID
1098    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1099    */
1100   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1101     require(ownerOf(_tokenId) == _from);
1102     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
1103     tokenOwner[_tokenId] = address(0);
1104   }
1105 
1106   /**
1107    * @dev Internal function to invoke `onERC721Received` on a target address
1108    * The call is not executed if the target address is not a contract
1109    * @param _from address representing the previous owner of the given token ID
1110    * @param _to target address that will receive the tokens
1111    * @param _tokenId uint256 ID of the token to be transferred
1112    * @param _data bytes optional data to send along with the call
1113    * @return whether the call correctly returned the expected magic value
1114    */
1115   function checkAndCallSafeTransfer(
1116     address _from,
1117     address _to,
1118     uint256 _tokenId,
1119     bytes _data
1120   )
1121     internal
1122     returns (bool)
1123   {
1124     if (!_to.isContract()) {
1125       return true;
1126     }
1127     bytes4 retval = ERC721Receiver(_to).onERC721Received(
1128       msg.sender, _from, _tokenId, _data);
1129     return (retval == ERC721_RECEIVED);
1130   }
1131 }
1132 
1133 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
1134 
1135 pragma solidity ^0.4.24;
1136 
1137 
1138 
1139 
1140 
1141 /**
1142  * @title Full ERC721 Token
1143  * This implementation includes all the required and some optional functionality of the ERC721 standard
1144  * Moreover, it includes approve all functionality using operator terminology
1145  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1146  */
1147 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
1148 
1149   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
1150   /**
1151    * 0x780e9d63 ===
1152    *   bytes4(keccak256('totalSupply()')) ^
1153    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
1154    *   bytes4(keccak256('tokenByIndex(uint256)'))
1155    */
1156 
1157   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
1158   /**
1159    * 0x5b5e139f ===
1160    *   bytes4(keccak256('name()')) ^
1161    *   bytes4(keccak256('symbol()')) ^
1162    *   bytes4(keccak256('tokenURI(uint256)'))
1163    */
1164 
1165   // Token name
1166   string internal name_;
1167 
1168   // Token symbol
1169   string internal symbol_;
1170 
1171   // Mapping from owner to list of owned token IDs
1172   mapping(address => uint256[]) internal ownedTokens;
1173 
1174   // Mapping from token ID to index of the owner tokens list
1175   mapping(uint256 => uint256) internal ownedTokensIndex;
1176 
1177   // Array with all token ids, used for enumeration
1178   uint256[] internal allTokens;
1179 
1180   // Mapping from token id to position in the allTokens array
1181   mapping(uint256 => uint256) internal allTokensIndex;
1182 
1183   // Optional mapping for token URIs
1184   mapping(uint256 => string) internal tokenURIs;
1185 
1186   /**
1187    * @dev Constructor function
1188    */
1189   constructor(string _name, string _symbol) public {
1190     name_ = _name;
1191     symbol_ = _symbol;
1192 
1193     // register the supported interfaces to conform to ERC721 via ERC165
1194     _registerInterface(InterfaceId_ERC721Enumerable);
1195     _registerInterface(InterfaceId_ERC721Metadata);
1196   }
1197 
1198   /**
1199    * @dev Gets the token name
1200    * @return string representing the token name
1201    */
1202   function name() external view returns (string) {
1203     return name_;
1204   }
1205 
1206   /**
1207    * @dev Gets the token symbol
1208    * @return string representing the token symbol
1209    */
1210   function symbol() external view returns (string) {
1211     return symbol_;
1212   }
1213 
1214   /**
1215    * @dev Returns an URI for a given token ID
1216    * Throws if the token ID does not exist. May return an empty string.
1217    * @param _tokenId uint256 ID of the token to query
1218    */
1219   function tokenURI(uint256 _tokenId) public view returns (string) {
1220     require(exists(_tokenId));
1221     return tokenURIs[_tokenId];
1222   }
1223 
1224   /**
1225    * @dev Gets the token ID at a given index of the tokens list of the requested owner
1226    * @param _owner address owning the tokens list to be accessed
1227    * @param _index uint256 representing the index to be accessed of the requested tokens list
1228    * @return uint256 token ID at the given index of the tokens list owned by the requested address
1229    */
1230   function tokenOfOwnerByIndex(
1231     address _owner,
1232     uint256 _index
1233   )
1234     public
1235     view
1236     returns (uint256)
1237   {
1238     require(_index < balanceOf(_owner));
1239     return ownedTokens[_owner][_index];
1240   }
1241 
1242   /**
1243    * @dev Gets the total amount of tokens stored by the contract
1244    * @return uint256 representing the total amount of tokens
1245    */
1246   function totalSupply() public view returns (uint256) {
1247     return allTokens.length;
1248   }
1249 
1250   /**
1251    * @dev Gets the token ID at a given index of all the tokens in this contract
1252    * Reverts if the index is greater or equal to the total number of tokens
1253    * @param _index uint256 representing the index to be accessed of the tokens list
1254    * @return uint256 token ID at the given index of the tokens list
1255    */
1256   function tokenByIndex(uint256 _index) public view returns (uint256) {
1257     require(_index < totalSupply());
1258     return allTokens[_index];
1259   }
1260 
1261   /**
1262    * @dev Internal function to set the token URI for a given token
1263    * Reverts if the token ID does not exist
1264    * @param _tokenId uint256 ID of the token to set its URI
1265    * @param _uri string URI to assign
1266    */
1267   function _setTokenURI(uint256 _tokenId, string _uri) internal {
1268     require(exists(_tokenId));
1269     tokenURIs[_tokenId] = _uri;
1270   }
1271 
1272   /**
1273    * @dev Internal function to add a token ID to the list of a given address
1274    * @param _to address representing the new owner of the given token ID
1275    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1276    */
1277   function addTokenTo(address _to, uint256 _tokenId) internal {
1278     super.addTokenTo(_to, _tokenId);
1279     uint256 length = ownedTokens[_to].length;
1280     ownedTokens[_to].push(_tokenId);
1281     ownedTokensIndex[_tokenId] = length;
1282   }
1283 
1284   /**
1285    * @dev Internal function to remove a token ID from the list of a given address
1286    * @param _from address representing the previous owner of the given token ID
1287    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1288    */
1289   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1290     super.removeTokenFrom(_from, _tokenId);
1291 
1292     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1293     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1294     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1295 
1296     ownedTokens[_from][tokenIndex] = lastToken;
1297     ownedTokens[_from][lastTokenIndex] = 0;
1298     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1299     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1300     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1301 
1302     ownedTokens[_from].length--;
1303     ownedTokensIndex[_tokenId] = 0;
1304     ownedTokensIndex[lastToken] = tokenIndex;
1305   }
1306 
1307   /**
1308    * @dev Internal function to mint a new token
1309    * Reverts if the given token ID already exists
1310    * @param _to address the beneficiary that will own the minted token
1311    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1312    */
1313   function _mint(address _to, uint256 _tokenId) internal {
1314     super._mint(_to, _tokenId);
1315 
1316     allTokensIndex[_tokenId] = allTokens.length;
1317     allTokens.push(_tokenId);
1318   }
1319 
1320   /**
1321    * @dev Internal function to burn a specific token
1322    * Reverts if the token does not exist
1323    * @param _owner owner of the token to burn
1324    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1325    */
1326   function _burn(address _owner, uint256 _tokenId) internal {
1327     super._burn(_owner, _tokenId);
1328 
1329     // Clear metadata (if any)
1330     if (bytes(tokenURIs[_tokenId]).length != 0) {
1331       delete tokenURIs[_tokenId];
1332     }
1333 
1334     // Reorg all tokens array
1335     uint256 tokenIndex = allTokensIndex[_tokenId];
1336     uint256 lastTokenIndex = allTokens.length.sub(1);
1337     uint256 lastToken = allTokens[lastTokenIndex];
1338 
1339     allTokens[tokenIndex] = lastToken;
1340     allTokens[lastTokenIndex] = 0;
1341 
1342     allTokens.length--;
1343     allTokensIndex[_tokenId] = 0;
1344     allTokensIndex[lastToken] = tokenIndex;
1345   }
1346 
1347 }
1348 
1349 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
1350 
1351 pragma solidity ^0.4.24;
1352 
1353 
1354 /**
1355  * @title Ownable
1356  * @dev The Ownable contract has an owner address, and provides basic authorization control
1357  * functions, this simplifies the implementation of "user permissions".
1358  */
1359 contract Ownable {
1360   address public owner;
1361 
1362 
1363   event OwnershipRenounced(address indexed previousOwner);
1364   event OwnershipTransferred(
1365     address indexed previousOwner,
1366     address indexed newOwner
1367   );
1368 
1369 
1370   /**
1371    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1372    * account.
1373    */
1374   constructor() public {
1375     owner = msg.sender;
1376   }
1377 
1378   /**
1379    * @dev Throws if called by any account other than the owner.
1380    */
1381   modifier onlyOwner() {
1382     require(msg.sender == owner);
1383     _;
1384   }
1385 
1386   /**
1387    * @dev Allows the current owner to relinquish control of the contract.
1388    * @notice Renouncing to ownership will leave the contract without an owner.
1389    * It will not be possible to call the functions with the `onlyOwner`
1390    * modifier anymore.
1391    */
1392   function renounceOwnership() public onlyOwner {
1393     emit OwnershipRenounced(owner);
1394     owner = address(0);
1395   }
1396 
1397   /**
1398    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1399    * @param _newOwner The address to transfer ownership to.
1400    */
1401   function transferOwnership(address _newOwner) public onlyOwner {
1402     _transferOwnership(_newOwner);
1403   }
1404 
1405   /**
1406    * @dev Transfers control of the contract to a newOwner.
1407    * @param _newOwner The address to transfer ownership to.
1408    */
1409   function _transferOwnership(address _newOwner) internal {
1410     require(_newOwner != address(0));
1411     emit OwnershipTransferred(owner, _newOwner);
1412     owner = _newOwner;
1413   }
1414 }
1415 
1416 // File: contracts/helpers/Admin.sol
1417 
1418 pragma solidity ^0.4.24;
1419 
1420 
1421 /**
1422  * @title Ownable
1423  * @dev The Ownable contract has an admin address, and provides basic authorization control
1424  * functions, this simplifies the implementation of "user permissions".
1425  */
1426 contract Admin {
1427   mapping (address => bool) public admins;
1428 
1429 
1430   event AdminshipRenounced(address indexed previousAdmin);
1431   event AdminshipTransferred(
1432     address indexed previousAdmin,
1433     address indexed newAdmin
1434   );
1435 
1436 
1437   /**
1438    * @dev The Ownable constructor sets the original `admin` of the contract to the sender
1439    * account.
1440    */
1441   constructor() public {
1442     admins[msg.sender] = true;
1443   }
1444 
1445   /**
1446    * @dev Throws if called by any account other than the admin.
1447    */
1448   modifier onlyAdmin() {
1449     require(admins[msg.sender]);
1450     _;
1451   }
1452 
1453   function isAdmin(address _admin) public view returns(bool) {
1454     return admins[_admin];
1455   }
1456 
1457   /**
1458    * @dev Allows the current admin to relinquish control of the contract.
1459    * @notice Renouncing to adminship will leave the contract without an admin.
1460    * It will not be possible to call the functions with the `onlyAdmin`
1461    * modifier anymore.
1462    */
1463   function renounceAdminship(address _previousAdmin) public onlyAdmin {
1464     emit AdminshipRenounced(_previousAdmin);
1465     admins[_previousAdmin] = false;
1466   }
1467 
1468   /**
1469    * @dev Allows the current admin to transfer control of the contract to a newAdmin.
1470    * @param _newAdmin The address to transfer adminship to.
1471    */
1472   function transferAdminship(address _newAdmin) public onlyAdmin {
1473     _transferAdminship(_newAdmin);
1474   }
1475 
1476   /**
1477    * @dev Transfers control of the contract to a newAdmin.
1478    * @param _newAdmin The address to transfer adminship to.
1479    */
1480   function _transferAdminship(address _newAdmin) internal {
1481     require(_newAdmin != address(0));
1482     emit AdminshipTransferred(msg.sender, _newAdmin);
1483     admins[_newAdmin] = true;
1484   }
1485 }
1486 
1487 // File: contracts/helpers/strings.sol
1488 
1489 /*
1490  * @title String & slice utility library for Solidity contracts.
1491  * @author Nick Johnson <arachnid@notdot.net>
1492  *
1493  * @dev Functionality in this library is largely implemented using an
1494  *      abstraction called a 'slice'. A slice represents a part of a string -
1495  *      anything from the entire string to a single character, or even no
1496  *      characters at all (a 0-length slice). Since a slice only has to specify
1497  *      an offset and a length, copying and manipulating slices is a lot less
1498  *      expensive than copying and manipulating the strings they reference.
1499  *
1500  *      To further reduce gas costs, most functions on slice that need to return
1501  *      a slice modify the original one instead of allocating a new one; for
1502  *      instance, `s.split(".")` will return the text up to the first '.',
1503  *      modifying s to only contain the remainder of the string after the '.'.
1504  *      In situations where you do not want to modify the original slice, you
1505  *      can make a copy first with `.copy()`, for example:
1506  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1507  *      Solidity has no memory management, it will result in allocating many
1508  *      short-lived slices that are later discarded.
1509  *
1510  *      Functions that return two slices come in two versions: a non-allocating
1511  *      version that takes the second slice as an argument, modifying it in
1512  *      place, and an allocating version that allocates and returns the second
1513  *      slice; see `nextRune` for example.
1514  *
1515  *      Functions that have to copy string data will return strings rather than
1516  *      slices; these can be cast back to slices for further processing if
1517  *      required.
1518  *
1519  *      For convenience, some functions are provided with non-modifying
1520  *      variants that create a new slice and return both; for instance,
1521  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1522  *      corresponding to the left and right parts of the string.
1523  */
1524 
1525 pragma solidity ^0.4.14;
1526 
1527 library strings {
1528     struct slice {
1529         uint _len;
1530         uint _ptr;
1531     }
1532 
1533     function memcpy(uint dest, uint src, uint len) private pure{
1534         // Copy word-length chunks while possible
1535         for(; len >= 32; len -= 32) {
1536             assembly {
1537                 mstore(dest, mload(src))
1538             }
1539             dest += 32;
1540             src += 32;
1541         }
1542 
1543         // Copy remaining bytes
1544         uint mask = 256 ** (32 - len) - 1;
1545         assembly {
1546             let srcpart := and(mload(src), not(mask))
1547             let destpart := and(mload(dest), mask)
1548             mstore(dest, or(destpart, srcpart))
1549         }
1550     }
1551 
1552     /*
1553      * @dev Returns a slice containing the entire string.
1554      * @param self The string to make a slice from.
1555      * @return A newly allocated slice containing the entire string.
1556      */
1557     function toSlice(string self) internal pure returns (slice) {
1558         uint ptr;
1559         assembly {
1560             ptr := add(self, 0x20)
1561         }
1562         return slice(bytes(self).length, ptr);
1563     }
1564 
1565     /*
1566      * @dev Returns the length of a null-terminated bytes32 string.
1567      * @param self The value to find the length of.
1568      * @return The length of the string, from 0 to 32.
1569      */
1570     function len(bytes32 self) internal pure returns (uint) {
1571         uint ret;
1572         if (self == 0)
1573             return 0;
1574         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1575             ret += 16;
1576             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1577         }
1578         if (self & 0xffffffffffffffff == 0) {
1579             ret += 8;
1580             self = bytes32(uint(self) / 0x10000000000000000);
1581         }
1582         if (self & 0xffffffff == 0) {
1583             ret += 4;
1584             self = bytes32(uint(self) / 0x100000000);
1585         }
1586         if (self & 0xffff == 0) {
1587             ret += 2;
1588             self = bytes32(uint(self) / 0x10000);
1589         }
1590         if (self & 0xff == 0) {
1591             ret += 1;
1592         }
1593         return 32 - ret;
1594     }
1595 
1596     /*
1597      * @dev Returns a slice containing the entire bytes32, interpreted as a
1598      *      null-termintaed utf-8 string.
1599      * @param self The bytes32 value to convert to a slice.
1600      * @return A new slice containing the value of the input argument up to the
1601      *         first null.
1602      */
1603     function toSliceB32(bytes32 self) internal pure returns (slice ret) {
1604         // Allocate space for `self` in memory, copy it there, and point ret at it
1605         assembly {
1606             let ptr := mload(0x40)
1607             mstore(0x40, add(ptr, 0x20))
1608             mstore(ptr, self)
1609             mstore(add(ret, 0x20), ptr)
1610         }
1611         ret._len = len(self);
1612     }
1613 
1614     /*
1615      * @dev Returns a new slice containing the same data as the current slice.
1616      * @param self The slice to copy.
1617      * @return A new slice containing the same data as `self`.
1618      */
1619     function copy(slice self) internal pure returns (slice) {
1620         return slice(self._len, self._ptr);
1621     }
1622 
1623     /*
1624      * @dev Copies a slice to a new string.
1625      * @param self The slice to copy.
1626      * @return A newly allocated string containing the slice's text.
1627      */
1628     function toString(slice self) internal pure returns (string) {
1629         var ret = new string(self._len);
1630         uint retptr;
1631         assembly { retptr := add(ret, 32) }
1632 
1633         memcpy(retptr, self._ptr, self._len);
1634         return ret;
1635     }
1636 
1637     /*
1638      * @dev Returns the length in runes of the slice. Note that this operation
1639      *      takes time proportional to the length of the slice; avoid using it
1640      *      in loops, and call `slice.empty()` if you only need to know whether
1641      *      the slice is empty or not.
1642      * @param self The slice to operate on.
1643      * @return The length of the slice in runes.
1644      */
1645     function len(slice self) internal pure returns (uint l) {
1646         // Starting at ptr-31 means the LSB will be the byte we care about
1647         var ptr = self._ptr - 31;
1648         var end = ptr + self._len;
1649         for (l = 0; ptr < end; l++) {
1650             uint8 b;
1651             assembly { b := and(mload(ptr), 0xFF) }
1652             if (b < 0x80) {
1653                 ptr += 1;
1654             } else if(b < 0xE0) {
1655                 ptr += 2;
1656             } else if(b < 0xF0) {
1657                 ptr += 3;
1658             } else if(b < 0xF8) {
1659                 ptr += 4;
1660             } else if(b < 0xFC) {
1661                 ptr += 5;
1662             } else {
1663                 ptr += 6;
1664             }
1665         }
1666     }
1667 
1668     /*
1669      * @dev Returns true if the slice is empty (has a length of 0).
1670      * @param self The slice to operate on.
1671      * @return True if the slice is empty, False otherwise.
1672      */
1673     function empty(slice self) internal pure returns (bool) {
1674         return self._len == 0;
1675     }
1676 
1677     /*
1678      * @dev Returns a positive number if `other` comes lexicographically after
1679      *      `self`, a negative number if it comes before, or zero if the
1680      *      contents of the two slices are equal. Comparison is done per-rune,
1681      *      on unicode codepoints.
1682      * @param self The first slice to compare.
1683      * @param other The second slice to compare.
1684      * @return The result of the comparison.
1685      */
1686     function compare(slice self, slice other) internal pure returns (int) {
1687         uint shortest = self._len;
1688         if (other._len < self._len)
1689             shortest = other._len;
1690 
1691         var selfptr = self._ptr;
1692         var otherptr = other._ptr;
1693         for (uint idx = 0; idx < shortest; idx += 32) {
1694             uint a;
1695             uint b;
1696             assembly {
1697                 a := mload(selfptr)
1698                 b := mload(otherptr)
1699             }
1700             if (a != b) {
1701                 // Mask out irrelevant bytes and check again
1702                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1703                 var diff = (a & mask) - (b & mask);
1704                 if (diff != 0)
1705                     return int(diff);
1706             }
1707             selfptr += 32;
1708             otherptr += 32;
1709         }
1710         return int(self._len) - int(other._len);
1711     }
1712 
1713     /*
1714      * @dev Returns true if the two slices contain the same text.
1715      * @param self The first slice to compare.
1716      * @param self The second slice to compare.
1717      * @return True if the slices are equal, false otherwise.
1718      */
1719     function equals(slice self, slice other) internal pure returns (bool) {
1720         return compare(self, other) == 0;
1721     }
1722 
1723     /*
1724      * @dev Extracts the first rune in the slice into `rune`, advancing the
1725      *      slice to point to the next rune and returning `self`.
1726      * @param self The slice to operate on.
1727      * @param rune The slice that will contain the first rune.
1728      * @return `rune`.
1729      */
1730     function nextRune(slice self, slice rune) internal pure returns (slice) {
1731         rune._ptr = self._ptr;
1732 
1733         if (self._len == 0) {
1734             rune._len = 0;
1735             return rune;
1736         }
1737 
1738         uint len;
1739         uint b;
1740         // Load the first byte of the rune into the LSBs of b
1741         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1742         if (b < 0x80) {
1743             len = 1;
1744         } else if(b < 0xE0) {
1745             len = 2;
1746         } else if(b < 0xF0) {
1747             len = 3;
1748         } else {
1749             len = 4;
1750         }
1751 
1752         // Check for truncated codepoints
1753         if (len > self._len) {
1754             rune._len = self._len;
1755             self._ptr += self._len;
1756             self._len = 0;
1757             return rune;
1758         }
1759 
1760         self._ptr += len;
1761         self._len -= len;
1762         rune._len = len;
1763         return rune;
1764     }
1765 
1766     /*
1767      * @dev Returns the first rune in the slice, advancing the slice to point
1768      *      to the next rune.
1769      * @param self The slice to operate on.
1770      * @return A slice containing only the first rune from `self`.
1771      */
1772     function nextRune(slice self) internal pure returns (slice ret) {
1773         nextRune(self, ret);
1774     }
1775 
1776     /*
1777      * @dev Returns the number of the first codepoint in the slice.
1778      * @param self The slice to operate on.
1779      * @return The number of the first codepoint in the slice.
1780      */
1781     function ord(slice self) internal pure returns (uint ret) {
1782         if (self._len == 0) {
1783             return 0;
1784         }
1785 
1786         uint word;
1787         uint length;
1788         uint divisor = 2 ** 248;
1789 
1790         // Load the rune into the MSBs of b
1791         assembly { word:= mload(mload(add(self, 32))) }
1792         var b = word / divisor;
1793         if (b < 0x80) {
1794             ret = b;
1795             length = 1;
1796         } else if(b < 0xE0) {
1797             ret = b & 0x1F;
1798             length = 2;
1799         } else if(b < 0xF0) {
1800             ret = b & 0x0F;
1801             length = 3;
1802         } else {
1803             ret = b & 0x07;
1804             length = 4;
1805         }
1806 
1807         // Check for truncated codepoints
1808         if (length > self._len) {
1809             return 0;
1810         }
1811 
1812         for (uint i = 1; i < length; i++) {
1813             divisor = divisor / 256;
1814             b = (word / divisor) & 0xFF;
1815             if (b & 0xC0 != 0x80) {
1816                 // Invalid UTF-8 sequence
1817                 return 0;
1818             }
1819             ret = (ret * 64) | (b & 0x3F);
1820         }
1821 
1822         return ret;
1823     }
1824 
1825     /*
1826      * @dev Returns the keccak-256 hash of the slice.
1827      * @param self The slice to hash.
1828      * @return The hash of the slice.
1829      */
1830     function keccak(slice self) internal pure returns (bytes32 ret) {
1831         assembly {
1832             ret := keccak256(mload(add(self, 32)), mload(self))
1833         }
1834     }
1835 
1836     /*
1837      * @dev Returns true if `self` starts with `needle`.
1838      * @param self The slice to operate on.
1839      * @param needle The slice to search for.
1840      * @return True if the slice starts with the provided text, false otherwise.
1841      */
1842     function startsWith(slice self, slice needle) internal pure returns (bool) {
1843         if (self._len < needle._len) {
1844             return false;
1845         }
1846 
1847         if (self._ptr == needle._ptr) {
1848             return true;
1849         }
1850 
1851         bool equal;
1852         assembly {
1853             let length := mload(needle)
1854             let selfptr := mload(add(self, 0x20))
1855             let needleptr := mload(add(needle, 0x20))
1856             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1857         }
1858         return equal;
1859     }
1860 
1861     /*
1862      * @dev If `self` starts with `needle`, `needle` is removed from the
1863      *      beginning of `self`. Otherwise, `self` is unmodified.
1864      * @param self The slice to operate on.
1865      * @param needle The slice to search for.
1866      * @return `self`
1867      */
1868     function beyond(slice self, slice needle) internal pure returns (slice) {
1869         if (self._len < needle._len) {
1870             return self;
1871         }
1872 
1873         bool equal = true;
1874         if (self._ptr != needle._ptr) {
1875             assembly {
1876                 let length := mload(needle)
1877                 let selfptr := mload(add(self, 0x20))
1878                 let needleptr := mload(add(needle, 0x20))
1879                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
1880             }
1881         }
1882 
1883         if (equal) {
1884             self._len -= needle._len;
1885             self._ptr += needle._len;
1886         }
1887 
1888         return self;
1889     }
1890 
1891     /*
1892      * @dev Returns true if the slice ends with `needle`.
1893      * @param self The slice to operate on.
1894      * @param needle The slice to search for.
1895      * @return True if the slice starts with the provided text, false otherwise.
1896      */
1897     function endsWith(slice self, slice needle) internal pure returns (bool) {
1898         if (self._len < needle._len) {
1899             return false;
1900         }
1901 
1902         var selfptr = self._ptr + self._len - needle._len;
1903 
1904         if (selfptr == needle._ptr) {
1905             return true;
1906         }
1907 
1908         bool equal;
1909         assembly {
1910             let length := mload(needle)
1911             let needleptr := mload(add(needle, 0x20))
1912             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1913         }
1914 
1915         return equal;
1916     }
1917 
1918     /*
1919      * @dev If `self` ends with `needle`, `needle` is removed from the
1920      *      end of `self`. Otherwise, `self` is unmodified.
1921      * @param self The slice to operate on.
1922      * @param needle The slice to search for.
1923      * @return `self`
1924      */
1925     function until(slice self, slice needle) internal pure returns (slice) {
1926         if (self._len < needle._len) {
1927             return self;
1928         }
1929 
1930         var selfptr = self._ptr + self._len - needle._len;
1931         bool equal = true;
1932         if (selfptr != needle._ptr) {
1933             assembly {
1934                 let length := mload(needle)
1935                 let needleptr := mload(add(needle, 0x20))
1936                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1937             }
1938         }
1939 
1940         if (equal) {
1941             self._len -= needle._len;
1942         }
1943 
1944         return self;
1945     }
1946 
1947     // Returns the memory address of the first byte of the first occurrence of
1948     // `needle` in `self`, or the first byte after `self` if not found.
1949     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1950         uint ptr;
1951         uint idx;
1952 
1953         if (needlelen <= selflen) {
1954             if (needlelen <= 32) {
1955                 // Optimized assembly for 68 gas per byte on short strings
1956                 assembly {
1957                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1958                     let needledata := and(mload(needleptr), mask)
1959                     let end := add(selfptr, sub(selflen, needlelen))
1960                     ptr := selfptr
1961                     loop:
1962                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
1963                     ptr := add(ptr, 1)
1964                     jumpi(loop, lt(sub(ptr, 1), end))
1965                     ptr := add(selfptr, selflen)
1966                     exit:
1967                 }
1968                 return ptr;
1969             } else {
1970                 // For long needles, use hashing
1971                 bytes32 hash;
1972                 assembly { hash := sha3(needleptr, needlelen) }
1973                 ptr = selfptr;
1974                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1975                     bytes32 testHash;
1976                     assembly { testHash := sha3(ptr, needlelen) }
1977                     if (hash == testHash)
1978                         return ptr;
1979                     ptr += 1;
1980                 }
1981             }
1982         }
1983         return selfptr + selflen;
1984     }
1985 
1986     // Returns the memory address of the first byte after the last occurrence of
1987     // `needle` in `self`, or the address of `self` if not found.
1988     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
1989         uint ptr;
1990 
1991         if (needlelen <= selflen) {
1992             if (needlelen <= 32) {
1993                 // Optimized assembly for 69 gas per byte on short strings
1994                 assembly {
1995                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
1996                     let needledata := and(mload(needleptr), mask)
1997                     ptr := add(selfptr, sub(selflen, needlelen))
1998                     loop:
1999                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
2000                     ptr := sub(ptr, 1)
2001                     jumpi(loop, gt(add(ptr, 1), selfptr))
2002                     ptr := selfptr
2003                     jump(exit)
2004                     ret:
2005                     ptr := add(ptr, needlelen)
2006                     exit:
2007                 }
2008                 return ptr;
2009             } else {
2010                 // For long needles, use hashing
2011                 bytes32 hash;
2012                 assembly { hash := sha3(needleptr, needlelen) }
2013                 ptr = selfptr + (selflen - needlelen);
2014                 while (ptr >= selfptr) {
2015                     bytes32 testHash;
2016                     assembly { testHash := sha3(ptr, needlelen) }
2017                     if (hash == testHash)
2018                         return ptr + needlelen;
2019                     ptr -= 1;
2020                 }
2021             }
2022         }
2023         return selfptr;
2024     }
2025 
2026     /*
2027      * @dev Modifies `self` to contain everything from the first occurrence of
2028      *      `needle` to the end of the slice. `self` is set to the empty slice
2029      *      if `needle` is not found.
2030      * @param self The slice to search and modify.
2031      * @param needle The text to search for.
2032      * @return `self`.
2033      */
2034     function find(slice self, slice needle) internal returns (slice) {
2035         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
2036         self._len -= ptr - self._ptr;
2037         self._ptr = ptr;
2038         return self;
2039     }
2040 
2041     /*
2042      * @dev Modifies `self` to contain the part of the string from the start of
2043      *      `self` to the end of the first occurrence of `needle`. If `needle`
2044      *      is not found, `self` is set to the empty slice.
2045      * @param self The slice to search and modify.
2046      * @param needle The text to search for.
2047      * @return `self`.
2048      */
2049     function rfind(slice self, slice needle) internal returns (slice) {
2050         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
2051         self._len = ptr - self._ptr;
2052         return self;
2053     }
2054 
2055     /*
2056      * @dev Splits the slice, setting `self` to everything after the first
2057      *      occurrence of `needle`, and `token` to everything before it. If
2058      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2059      *      and `token` is set to the entirety of `self`.
2060      * @param self The slice to split.
2061      * @param needle The text to search for in `self`.
2062      * @param token An output parameter to which the first token is written.
2063      * @return `token`.
2064      */
2065     function split(slice self, slice needle, slice token) internal returns (slice) {
2066         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
2067         token._ptr = self._ptr;
2068         token._len = ptr - self._ptr;
2069         if (ptr == self._ptr + self._len) {
2070             // Not found
2071             self._len = 0;
2072         } else {
2073             self._len -= token._len + needle._len;
2074             self._ptr = ptr + needle._len;
2075         }
2076         return token;
2077     }
2078 
2079     /*
2080      * @dev Splits the slice, setting `self` to everything after the first
2081      *      occurrence of `needle`, and returning everything before it. If
2082      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2083      *      and the entirety of `self` is returned.
2084      * @param self The slice to split.
2085      * @param needle The text to search for in `self`.
2086      * @return The part of `self` up to the first occurrence of `delim`.
2087      */
2088     function split(slice self, slice needle) internal returns (slice token) {
2089         split(self, needle, token);
2090     }
2091 
2092     /*
2093      * @dev Splits the slice, setting `self` to everything before the last
2094      *      occurrence of `needle`, and `token` to everything after it. If
2095      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2096      *      and `token` is set to the entirety of `self`.
2097      * @param self The slice to split.
2098      * @param needle The text to search for in `self`.
2099      * @param token An output parameter to which the first token is written.
2100      * @return `token`.
2101      */
2102     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
2103         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
2104         token._ptr = ptr;
2105         token._len = self._len - (ptr - self._ptr);
2106         if (ptr == self._ptr) {
2107             // Not found
2108             self._len = 0;
2109         } else {
2110             self._len -= token._len + needle._len;
2111         }
2112         return token;
2113     }
2114 
2115     /*
2116      * @dev Splits the slice, setting `self` to everything before the last
2117      *      occurrence of `needle`, and returning everything after it. If
2118      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2119      *      and the entirety of `self` is returned.
2120      * @param self The slice to split.
2121      * @param needle The text to search for in `self`.
2122      * @return The part of `self` after the last occurrence of `delim`.
2123      */
2124     function rsplit(slice self, slice needle) internal returns (slice token) {
2125         rsplit(self, needle, token);
2126     }
2127 
2128     /*
2129      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
2130      * @param self The slice to search.
2131      * @param needle The text to search for in `self`.
2132      * @return The number of occurrences of `needle` found in `self`.
2133      */
2134     function count(slice self, slice needle) internal returns (uint cnt) {
2135         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
2136         while (ptr <= self._ptr + self._len) {
2137             cnt++;
2138             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
2139         }
2140     }
2141 
2142     /*
2143      * @dev Returns True if `self` contains `needle`.
2144      * @param self The slice to search.
2145      * @param needle The text to search for in `self`.
2146      * @return True if `needle` is found in `self`, false otherwise.
2147      */
2148     function contains(slice self, slice needle) internal returns (bool) {
2149         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
2150     }
2151 
2152     /*
2153      * @dev Returns a newly allocated string containing the concatenation of
2154      *      `self` and `other`.
2155      * @param self The first slice to concatenate.
2156      * @param other The second slice to concatenate.
2157      * @return The concatenation of the two strings.
2158      */
2159     function concat(slice self, slice other) internal pure returns (string) {
2160         var ret = new string(self._len + other._len);
2161         uint retptr;
2162         assembly { retptr := add(ret, 32) }
2163         memcpy(retptr, self._ptr, self._len);
2164         memcpy(retptr + self._len, other._ptr, other._len);
2165         return ret;
2166     }
2167 
2168     /*
2169      * @dev Joins an array of slices, using `self` as a delimiter, returning a
2170      *      newly allocated string.
2171      * @param self The delimiter to use.
2172      * @param parts A list of slices to join.
2173      * @return A newly allocated string containing all the slices in `parts`,
2174      *         joined with `self`.
2175      */
2176     function join(slice self, slice[] parts) internal pure returns (string) {
2177         if (parts.length == 0)
2178             return "";
2179 
2180         uint length = self._len * (parts.length - 1);
2181         for(uint i = 0; i < parts.length; i++)
2182             length += parts[i]._len;
2183 
2184         var ret = new string(length);
2185         uint retptr;
2186         assembly { retptr := add(ret, 32) }
2187 
2188         for(i = 0; i < parts.length; i++) {
2189             memcpy(retptr, parts[i]._ptr, parts[i]._len);
2190             retptr += parts[i]._len;
2191             if (i < parts.length - 1) {
2192                 memcpy(retptr, self._ptr, self._len);
2193                 retptr += self._len;
2194             }
2195         }
2196 
2197         return ret;
2198     }
2199 }
2200 
2201 // File: contracts/CloversMetadata.sol
2202 
2203 pragma solidity ^0.4.18;
2204 
2205 /**
2206 * CloversMetadata contract is upgradeable and returns metadata about Clovers
2207 */
2208 
2209 
2210 
2211 contract CloversMetadata {
2212     using strings for *;
2213 
2214     function tokenURI(uint _tokenId) public view returns (string _infoUrl) {
2215         string memory base = "https://api.clovers.network/clovers/metadata/0x";
2216         string memory id = uint2hexstr(_tokenId);
2217         string memory suffix = "";
2218         return base.toSlice().concat(id.toSlice()).toSlice().concat(suffix.toSlice());
2219     }
2220     function uint2hexstr(uint i) internal pure returns (string) {
2221         if (i == 0) return "0";
2222         uint j = i;
2223         uint length;
2224         while (j != 0) {
2225             length++;
2226             j = j >> 4;
2227         }
2228         uint mask = 15;
2229         bytes memory bstr = new bytes(length);
2230         uint k = length - 1;
2231         while (i != 0){
2232             uint curr = (i & mask);
2233             bstr[k--] = curr > 9 ? byte(55 + curr) : byte(48 + curr); // 55 = 65 - 10
2234             i = i >> 4;
2235         }
2236         return string(bstr);
2237     }
2238 }
2239 
2240 // File: contracts/Clovers.sol
2241 
2242 pragma solidity ^0.4.18;
2243 
2244 /**
2245  * Digital Asset Registry for the Non Fungible Token Clover
2246  * with upgradeable contract reference for returning metadata.
2247  */
2248 
2249 
2250 
2251 
2252 
2253 
2254 
2255 contract Clovers is ERC721Token, Admin, Ownable {
2256 
2257     address public cloversMetadata;
2258     uint256 public totalSymmetries;
2259     uint256[5] symmetries; // RotSym, Y0Sym, X0Sym, XYSym, XnYSym
2260     address public cloversController;
2261     address public clubTokenController;
2262 
2263     mapping (uint256 => Clover) public clovers;
2264     struct Clover {
2265         bool keep;
2266         uint256 symmetries;
2267         bytes28[2] cloverMoves;
2268         uint256 blockMinted;
2269         uint256 rewards;
2270     }
2271 
2272     modifier onlyOwnerOrController() {
2273         require(
2274             msg.sender == cloversController ||
2275             owner == msg.sender ||
2276             admins[msg.sender]
2277         );
2278         _;
2279     }
2280 
2281 
2282     /**
2283     * @dev Checks msg.sender can transfer a token, by being owner, approved, operator or cloversController
2284     * @param _tokenId uint256 ID of the token to validate
2285     */
2286     modifier canTransfer(uint256 _tokenId) {
2287         require(isApprovedOrOwner(msg.sender, _tokenId) || msg.sender == cloversController);
2288         _;
2289     }
2290 
2291     constructor(string name, string symbol) public
2292         ERC721Token(name, symbol)
2293     { }
2294 
2295     function () public payable {}
2296 
2297     function implementation() public view returns (address) {
2298         return cloversMetadata;
2299     }
2300 
2301     function tokenURI(uint _tokenId) public view returns (string _infoUrl) {
2302         return CloversMetadata(cloversMetadata).tokenURI(_tokenId);
2303     }
2304     function getHash(bytes28[2] moves) public pure returns (bytes32) {
2305         return keccak256(moves);
2306     }
2307     function getKeep(uint256 _tokenId) public view returns (bool) {
2308         return clovers[_tokenId].keep;
2309     }
2310     function getBlockMinted(uint256 _tokenId) public view returns (uint256) {
2311         return clovers[_tokenId].blockMinted;
2312     }
2313     function getCloverMoves(uint256 _tokenId) public view returns (bytes28[2]) {
2314         return clovers[_tokenId].cloverMoves;
2315     }
2316     function getReward(uint256 _tokenId) public view returns (uint256) {
2317         return clovers[_tokenId].rewards;
2318     }
2319     function getSymmetries(uint256 _tokenId) public view returns (uint256) {
2320         return clovers[_tokenId].symmetries;
2321     }
2322     function getAllSymmetries() public view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
2323         return (
2324             totalSymmetries,
2325             symmetries[0], //RotSym,
2326             symmetries[1], //Y0Sym,
2327             symmetries[2], //X0Sym,
2328             symmetries[3], //XYSym,
2329             symmetries[4] //XnYSym
2330         );
2331     }
2332 
2333 /* ---------------------------------------------------------------------------------------------------------------------- */
2334 
2335     /**
2336     * @dev Moves Eth to a certain address for use in the CloversController
2337     * @param _to The address to receive the Eth.
2338     * @param _amount The amount of Eth to be transferred.
2339     */
2340     function moveEth(address _to, uint256 _amount) public onlyOwnerOrController {
2341         require(_amount <= this.balance);
2342         _to.transfer(_amount);
2343     }
2344     /**
2345     * @dev Moves Token to a certain address for use in the CloversController
2346     * @param _to The address to receive the Token.
2347     * @param _amount The amount of Token to be transferred.
2348     * @param _token The address of the Token to be transferred.
2349     */
2350     function moveToken(address _to, uint256 _amount, address _token) public onlyOwnerOrController returns (bool) {
2351         require(_amount <= ERC20(_token).balanceOf(this));
2352         return ERC20(_token).transfer(_to, _amount);
2353     }
2354     /**
2355     * @dev Approves Tokens to a certain address for use in the CloversController
2356     * @param _to The address to receive the Token approval.
2357     * @param _amount The amount of Token to be approved.
2358     * @param _token The address of the Token to be approved.
2359     */
2360     function approveToken(address _to, uint256 _amount, address _token) public onlyOwnerOrController returns (bool) {
2361         return ERC20(_token).approve(_to, _amount);
2362     }
2363 
2364     /**
2365     * @dev Sets whether the minter will keep the clover
2366     * @param _tokenId The token Id.
2367     * @param value Whether the clover will be kept.
2368     */
2369     function setKeep(uint256 _tokenId, bool value) public onlyOwnerOrController {
2370         clovers[_tokenId].keep = value;
2371     }
2372     function setBlockMinted(uint256 _tokenId, uint256 value) public onlyOwnerOrController {
2373         clovers[_tokenId].blockMinted = value;
2374     }
2375     function setCloverMoves(uint256 _tokenId, bytes28[2] moves) public onlyOwnerOrController {
2376         clovers[_tokenId].cloverMoves = moves;
2377     }
2378     function setReward(uint256 _tokenId, uint256 _amount) public onlyOwnerOrController {
2379         clovers[_tokenId].rewards = _amount;
2380     }
2381     function setSymmetries(uint256 _tokenId, uint256 _symmetries) public onlyOwnerOrController {
2382         clovers[_tokenId].symmetries = _symmetries;
2383     }
2384 
2385     /**
2386     * @dev Sets total tallies of symmetry counts. For use by the controller to correct for invalid Clovers.
2387     * @param _totalSymmetries The total number of Symmetries.
2388     * @param RotSym The total number of RotSym Symmetries.
2389     * @param Y0Sym The total number of Y0Sym Symmetries.
2390     * @param X0Sym The total number of X0Sym Symmetries.
2391     * @param XYSym The total number of XYSym Symmetries.
2392     * @param XnYSym The total number of XnYSym Symmetries.
2393     */
2394     function setAllSymmetries(uint256 _totalSymmetries, uint256 RotSym, uint256 Y0Sym, uint256 X0Sym, uint256 XYSym, uint256 XnYSym) public onlyOwnerOrController {
2395         totalSymmetries = _totalSymmetries;
2396         symmetries[0] = RotSym;
2397         symmetries[1] = Y0Sym;
2398         symmetries[2] = X0Sym;
2399         symmetries[3] = XYSym;
2400         symmetries[4] = XnYSym;
2401     }
2402 
2403     /**
2404     * @dev Deletes data about a Clover.
2405     * @param _tokenId The Id of the clover token to be deleted.
2406     */
2407     function deleteClover(uint256 _tokenId) public onlyOwnerOrController {
2408         delete(clovers[_tokenId]);
2409         unmint(_tokenId);
2410     }
2411     /**
2412     * @dev Updates the CloversController contract address and approves that contract to manage the Clovers owned by the Clovers contract.
2413     * @param _cloversController The address of the new contract.
2414     */
2415     function updateCloversControllerAddress(address _cloversController) public onlyOwner {
2416         require(_cloversController != 0);
2417         cloversController = _cloversController;
2418     }
2419 
2420 
2421 
2422     /**
2423     * @dev Updates the CloversMetadata contract address.
2424     * @param _cloversMetadata The address of the new contract.
2425     */
2426     function updateCloversMetadataAddress(address _cloversMetadata) public onlyOwner {
2427         require(_cloversMetadata != 0);
2428         cloversMetadata = _cloversMetadata;
2429     }
2430 
2431     function updateClubTokenController(address _clubTokenController) public onlyOwner {
2432         require(_clubTokenController != 0);
2433         clubTokenController = _clubTokenController;
2434     }
2435 
2436     /**
2437     * @dev Mints new Clovers.
2438     * @param _to The address of the new clover owner.
2439     * @param _tokenId The Id of the new clover token.
2440     */
2441     function mint (address _to, uint256 _tokenId) public onlyOwnerOrController {
2442         super._mint(_to, _tokenId);
2443         setApprovalForAll(clubTokenController, true);
2444     }
2445 
2446 
2447     function mintMany(address[] _tos, uint256[] _tokenIds, bytes28[2][] memory _movess, uint256[] _symmetries) public onlyAdmin {
2448         require(_tos.length == _tokenIds.length && _tokenIds.length == _movess.length && _movess.length == _symmetries.length);
2449         for (uint256 i = 0; i < _tos.length; i++) {
2450             address _to = _tos[i];
2451             uint256 _tokenId = _tokenIds[i];
2452             bytes28[2] memory _moves = _movess[i];
2453             uint256 _symmetry = _symmetries[i];
2454             setCloverMoves(_tokenId, _moves);
2455             if (_symmetry > 0) {
2456                 setSymmetries(_tokenId, _symmetry);
2457             }
2458             super._mint(_to, _tokenId);
2459             setApprovalForAll(clubTokenController, true);
2460         }
2461     }
2462 
2463     /**
2464     * @dev Unmints Clovers.
2465     * @param _tokenId The Id of the clover token to be destroyed.
2466     */
2467     function unmint (uint256 _tokenId) public onlyOwnerOrController {
2468         super._burn(ownerOf(_tokenId), _tokenId);
2469     }
2470 
2471 
2472 }
2473 
2474 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
2475 
2476 pragma solidity ^0.4.24;
2477 
2478 
2479 
2480 
2481 /**
2482  * @title Basic token
2483  * @dev Basic version of StandardToken, with no allowances.
2484  */
2485 contract BasicToken is ERC20Basic {
2486   using SafeMath for uint256;
2487 
2488   mapping(address => uint256) balances;
2489 
2490   uint256 totalSupply_;
2491 
2492   /**
2493   * @dev Total number of tokens in existence
2494   */
2495   function totalSupply() public view returns (uint256) {
2496     return totalSupply_;
2497   }
2498 
2499   /**
2500   * @dev Transfer token for a specified address
2501   * @param _to The address to transfer to.
2502   * @param _value The amount to be transferred.
2503   */
2504   function transfer(address _to, uint256 _value) public returns (bool) {
2505     require(_to != address(0));
2506     require(_value <= balances[msg.sender]);
2507 
2508     balances[msg.sender] = balances[msg.sender].sub(_value);
2509     balances[_to] = balances[_to].add(_value);
2510     emit Transfer(msg.sender, _to, _value);
2511     return true;
2512   }
2513 
2514   /**
2515   * @dev Gets the balance of the specified address.
2516   * @param _owner The address to query the the balance of.
2517   * @return An uint256 representing the amount owned by the passed address.
2518   */
2519   function balanceOf(address _owner) public view returns (uint256) {
2520     return balances[_owner];
2521   }
2522 
2523 }
2524 
2525 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
2526 
2527 pragma solidity ^0.4.24;
2528 
2529 
2530 
2531 
2532 /**
2533  * @title Standard ERC20 token
2534  *
2535  * @dev Implementation of the basic standard token.
2536  * https://github.com/ethereum/EIPs/issues/20
2537  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
2538  */
2539 contract StandardToken is ERC20, BasicToken {
2540 
2541   mapping (address => mapping (address => uint256)) internal allowed;
2542 
2543 
2544   /**
2545    * @dev Transfer tokens from one address to another
2546    * @param _from address The address which you want to send tokens from
2547    * @param _to address The address which you want to transfer to
2548    * @param _value uint256 the amount of tokens to be transferred
2549    */
2550   function transferFrom(
2551     address _from,
2552     address _to,
2553     uint256 _value
2554   )
2555     public
2556     returns (bool)
2557   {
2558     require(_to != address(0));
2559     require(_value <= balances[_from]);
2560     require(_value <= allowed[_from][msg.sender]);
2561 
2562     balances[_from] = balances[_from].sub(_value);
2563     balances[_to] = balances[_to].add(_value);
2564     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
2565     emit Transfer(_from, _to, _value);
2566     return true;
2567   }
2568 
2569   /**
2570    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
2571    * Beware that changing an allowance with this method brings the risk that someone may use both the old
2572    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
2573    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
2574    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2575    * @param _spender The address which will spend the funds.
2576    * @param _value The amount of tokens to be spent.
2577    */
2578   function approve(address _spender, uint256 _value) public returns (bool) {
2579     allowed[msg.sender][_spender] = _value;
2580     emit Approval(msg.sender, _spender, _value);
2581     return true;
2582   }
2583 
2584   /**
2585    * @dev Function to check the amount of tokens that an owner allowed to a spender.
2586    * @param _owner address The address which owns the funds.
2587    * @param _spender address The address which will spend the funds.
2588    * @return A uint256 specifying the amount of tokens still available for the spender.
2589    */
2590   function allowance(
2591     address _owner,
2592     address _spender
2593    )
2594     public
2595     view
2596     returns (uint256)
2597   {
2598     return allowed[_owner][_spender];
2599   }
2600 
2601   /**
2602    * @dev Increase the amount of tokens that an owner allowed to a spender.
2603    * approve should be called when allowed[_spender] == 0. To increment
2604    * allowed value is better to use this function to avoid 2 calls (and wait until
2605    * the first transaction is mined)
2606    * From MonolithDAO Token.sol
2607    * @param _spender The address which will spend the funds.
2608    * @param _addedValue The amount of tokens to increase the allowance by.
2609    */
2610   function increaseApproval(
2611     address _spender,
2612     uint256 _addedValue
2613   )
2614     public
2615     returns (bool)
2616   {
2617     allowed[msg.sender][_spender] = (
2618       allowed[msg.sender][_spender].add(_addedValue));
2619     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
2620     return true;
2621   }
2622 
2623   /**
2624    * @dev Decrease the amount of tokens that an owner allowed to a spender.
2625    * approve should be called when allowed[_spender] == 0. To decrement
2626    * allowed value is better to use this function to avoid 2 calls (and wait until
2627    * the first transaction is mined)
2628    * From MonolithDAO Token.sol
2629    * @param _spender The address which will spend the funds.
2630    * @param _subtractedValue The amount of tokens to decrease the allowance by.
2631    */
2632   function decreaseApproval(
2633     address _spender,
2634     uint256 _subtractedValue
2635   )
2636     public
2637     returns (bool)
2638   {
2639     uint256 oldValue = allowed[msg.sender][_spender];
2640     if (_subtractedValue > oldValue) {
2641       allowed[msg.sender][_spender] = 0;
2642     } else {
2643       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
2644     }
2645     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
2646     return true;
2647   }
2648 
2649 }
2650 
2651 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
2652 
2653 pragma solidity ^0.4.24;
2654 
2655 
2656 
2657 /**
2658  * @title DetailedERC20 token
2659  * @dev The decimals are only for visualization purposes.
2660  * All the operations are done using the smallest and indivisible token unit,
2661  * just as on Ethereum all the operations are done in wei.
2662  */
2663 contract DetailedERC20 is ERC20 {
2664   string public name;
2665   string public symbol;
2666   uint8 public decimals;
2667 
2668   constructor(string _name, string _symbol, uint8 _decimals) public {
2669     name = _name;
2670     symbol = _symbol;
2671     decimals = _decimals;
2672   }
2673 }
2674 
2675 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
2676 
2677 pragma solidity ^0.4.24;
2678 
2679 
2680 
2681 
2682 /**
2683  * @title Mintable token
2684  * @dev Simple ERC20 Token example, with mintable token creation
2685  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
2686  */
2687 contract MintableToken is StandardToken, Ownable {
2688   event Mint(address indexed to, uint256 amount);
2689   event MintFinished();
2690 
2691   bool public mintingFinished = false;
2692 
2693 
2694   modifier canMint() {
2695     require(!mintingFinished);
2696     _;
2697   }
2698 
2699   modifier hasMintPermission() {
2700     require(msg.sender == owner);
2701     _;
2702   }
2703 
2704   /**
2705    * @dev Function to mint tokens
2706    * @param _to The address that will receive the minted tokens.
2707    * @param _amount The amount of tokens to mint.
2708    * @return A boolean that indicates if the operation was successful.
2709    */
2710   function mint(
2711     address _to,
2712     uint256 _amount
2713   )
2714     hasMintPermission
2715     canMint
2716     public
2717     returns (bool)
2718   {
2719     totalSupply_ = totalSupply_.add(_amount);
2720     balances[_to] = balances[_to].add(_amount);
2721     emit Mint(_to, _amount);
2722     emit Transfer(address(0), _to, _amount);
2723     return true;
2724   }
2725 
2726   /**
2727    * @dev Function to stop minting new tokens.
2728    * @return True if the operation was successful.
2729    */
2730   function finishMinting() onlyOwner canMint public returns (bool) {
2731     mintingFinished = true;
2732     emit MintFinished();
2733     return true;
2734   }
2735 }
2736 
2737 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
2738 
2739 pragma solidity ^0.4.24;
2740 
2741 
2742 
2743 /**
2744  * @title Burnable Token
2745  * @dev Token that can be irreversibly burned (destroyed).
2746  */
2747 contract BurnableToken is BasicToken {
2748 
2749   event Burn(address indexed burner, uint256 value);
2750 
2751   /**
2752    * @dev Burns a specific amount of tokens.
2753    * @param _value The amount of token to be burned.
2754    */
2755   function burn(uint256 _value) public {
2756     _burn(msg.sender, _value);
2757   }
2758 
2759   function _burn(address _who, uint256 _value) internal {
2760     require(_value <= balances[_who]);
2761     // no need to require value <= totalSupply, since that would imply the
2762     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
2763 
2764     balances[_who] = balances[_who].sub(_value);
2765     totalSupply_ = totalSupply_.sub(_value);
2766     emit Burn(_who, _value);
2767     emit Transfer(_who, address(0), _value);
2768   }
2769 }
2770 
2771 // File: contracts/ClubToken.sol
2772 
2773 pragma solidity ^0.4.18;
2774 
2775 /**
2776  * ClubToken adheres to ERC20
2777  * it is a continuously mintable token administered by CloversController/ClubTokenController
2778  */
2779 
2780 
2781 
2782 
2783 
2784 contract ClubToken is StandardToken, DetailedERC20, MintableToken, BurnableToken {
2785 
2786     address public cloversController;
2787     address public clubTokenController;
2788 
2789     modifier hasMintPermission() {
2790       require(
2791           msg.sender == clubTokenController ||
2792           msg.sender == cloversController ||
2793           msg.sender == owner
2794       );
2795       _;
2796     }
2797 
2798     /**
2799     * @dev constructor for the ClubTokens contract
2800     * @param _name The name of the token
2801     * @param _symbol The symbol of the token
2802     * @param _decimals The decimals of the token
2803     */
2804     constructor(string _name, string _symbol, uint8 _decimals) public
2805         DetailedERC20(_name, _symbol, _decimals)
2806     {}
2807 
2808     function () public payable {}
2809 
2810     function updateClubTokenControllerAddress(address _clubTokenController) public onlyOwner {
2811         require(_clubTokenController != 0);
2812         clubTokenController = _clubTokenController;
2813     }
2814 
2815     function updateCloversControllerAddress(address _cloversController) public onlyOwner {
2816         require(_cloversController != 0);
2817         cloversController = _cloversController;
2818     }
2819 
2820 
2821       /**
2822        * @dev Transfer tokens from one address to another
2823        * @param _from address The address which you want to send tokens from
2824        * @param _to address The address which you want to transfer to
2825        * @param _value uint256 the amount of tokens to be transferred
2826        */
2827       function transferFrom(
2828         address _from,
2829         address _to,
2830         uint256 _value
2831       )
2832         public
2833         returns (bool)
2834       {
2835         require(_to != address(0));
2836         require(_value <= balances[_from]);
2837         if (msg.sender != cloversController && msg.sender != clubTokenController) {
2838             require(_value <= allowed[_from][msg.sender]);
2839             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
2840         }
2841         balances[_from] = balances[_from].sub(_value);
2842         balances[_to] = balances[_to].add(_value);
2843         emit Transfer(_from, _to, _value);
2844         return true;
2845       }
2846 
2847     /**
2848      * @dev Burns a specific amount of tokens.
2849      * @param _value The amount of token to be burned.
2850      * NOTE: Disabled as tokens should not be burned under circumstances beside selling tokens.
2851      */
2852     function burn(uint256 _value) public {
2853         _value;
2854         revert();
2855     }
2856 
2857     /**
2858      * @dev Burns a specific amount of tokens.
2859      * @param _burner The address of the token holder burning their tokens.
2860      * @param _value The amount of token to be burned.
2861      */
2862     function burn(address _burner, uint256 _value) public hasMintPermission {
2863       _burn(_burner, _value);
2864     }
2865 
2866     /**
2867     * @dev Moves Eth to a certain address for use in the ClubTokenController
2868     * @param _to The address to receive the Eth.
2869     * @param _amount The amount of Eth to be transferred.
2870     */
2871     function moveEth(address _to, uint256 _amount) public hasMintPermission {
2872         require(this.balance >= _amount);
2873         _to.transfer(_amount);
2874     }
2875     /**
2876     * @dev Moves Tokens to a certain address for use in the ClubTokenController
2877     * @param _to The address to receive the Tokens.
2878     * @param _amount The amount of Tokens to be transferred.
2879     * @param _token The address of the relevant token contract.
2880     * @return bool Whether or not the move was successful
2881     */
2882     function moveToken(address _to, uint256 _amount, address _token) public hasMintPermission returns (bool) {
2883         require(_amount <= StandardToken(_token).balanceOf(this));
2884         return StandardToken(_token).transfer(_to, _amount);
2885     }
2886     /**
2887     * @dev Approves Tokens to a certain address for use in the ClubTokenController
2888     * @param _to The address to be approved.
2889     * @param _amount The amount of Tokens to be approved.
2890     * @param _token The address of the relevant token contract.
2891     * @return bool Whether or not the approval was successful
2892     */
2893     function approveToken(address _to, uint256 _amount, address _token) public hasMintPermission returns (bool) {
2894         return StandardToken(_token).approve(_to, _amount);
2895     }
2896 }
2897 
2898 // File: bancor-contracts/solidity/contracts/converter/interfaces/IBancorFormula.sol
2899 
2900 pragma solidity ^0.4.24;
2901 
2902 /*
2903     Bancor Formula interface
2904 */
2905 contract IBancorFormula {
2906     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256);
2907     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256);
2908     function calculateCrossConnectorReturn(uint256 _fromConnectorBalance, uint32 _fromConnectorWeight, uint256 _toConnectorBalance, uint32 _toConnectorWeight, uint256 _amount) public view returns (uint256);
2909 }
2910 
2911 // File: bancor-contracts/solidity/contracts/utility/Utils.sol
2912 
2913 pragma solidity ^0.4.24;
2914 
2915 /*
2916     Utilities & Common Modifiers
2917 */
2918 contract Utils {
2919     /**
2920         constructor
2921     */
2922     constructor() public {
2923     }
2924 
2925     // verifies that an amount is greater than zero
2926     modifier greaterThanZero(uint256 _amount) {
2927         require(_amount > 0);
2928         _;
2929     }
2930 
2931     // validates an address - currently only checks that it isn't null
2932     modifier validAddress(address _address) {
2933         require(_address != address(0));
2934         _;
2935     }
2936 
2937     // verifies that the address is different than this contract address
2938     modifier notThis(address _address) {
2939         require(_address != address(this));
2940         _;
2941     }
2942 
2943     // Overflow protected math functions
2944 
2945     /**
2946         @dev returns the sum of _x and _y, asserts if the calculation overflows
2947 
2948         @param _x   value 1
2949         @param _y   value 2
2950 
2951         @return sum
2952     */
2953     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
2954         uint256 z = _x + _y;
2955         assert(z >= _x);
2956         return z;
2957     }
2958 
2959     /**
2960         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
2961 
2962         @param _x   minuend
2963         @param _y   subtrahend
2964 
2965         @return difference
2966     */
2967     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
2968         assert(_x >= _y);
2969         return _x - _y;
2970     }
2971 
2972     /**
2973         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
2974 
2975         @param _x   factor 1
2976         @param _y   factor 2
2977 
2978         @return product
2979     */
2980     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
2981         uint256 z = _x * _y;
2982         assert(_x == 0 || z / _x == _y);
2983         return z;
2984     }
2985 }
2986 
2987 // File: bancor-contracts/solidity/contracts/converter/BancorFormula.sol
2988 
2989 pragma solidity ^0.4.24;
2990 
2991 
2992 
2993 contract BancorFormula is IBancorFormula, Utils {
2994     string public version = '0.3';
2995 
2996     uint256 private constant ONE = 1;
2997     uint32 private constant MAX_WEIGHT = 1000000;
2998     uint8 private constant MIN_PRECISION = 32;
2999     uint8 private constant MAX_PRECISION = 127;
3000 
3001     /**
3002         Auto-generated via 'PrintIntScalingFactors.py'
3003     */
3004     uint256 private constant FIXED_1 = 0x080000000000000000000000000000000;
3005     uint256 private constant FIXED_2 = 0x100000000000000000000000000000000;
3006     uint256 private constant MAX_NUM = 0x200000000000000000000000000000000;
3007 
3008     /**
3009         Auto-generated via 'PrintLn2ScalingFactors.py'
3010     */
3011     uint256 private constant LN2_NUMERATOR   = 0x3f80fe03f80fe03f80fe03f80fe03f8;
3012     uint256 private constant LN2_DENOMINATOR = 0x5b9de1d10bf4103d647b0955897ba80;
3013 
3014     /**
3015         Auto-generated via 'PrintFunctionOptimalLog.py' and 'PrintFunctionOptimalExp.py'
3016     */
3017     uint256 private constant OPT_LOG_MAX_VAL = 0x15bf0a8b1457695355fb8ac404e7a79e3;
3018     uint256 private constant OPT_EXP_MAX_VAL = 0x800000000000000000000000000000000;
3019 
3020     /**
3021         Auto-generated via 'PrintFunctionConstructor.py'
3022     */
3023     uint256[128] private maxExpArray;
3024     constructor() public {
3025     //  maxExpArray[  0] = 0x6bffffffffffffffffffffffffffffffff;
3026     //  maxExpArray[  1] = 0x67ffffffffffffffffffffffffffffffff;
3027     //  maxExpArray[  2] = 0x637fffffffffffffffffffffffffffffff;
3028     //  maxExpArray[  3] = 0x5f6fffffffffffffffffffffffffffffff;
3029     //  maxExpArray[  4] = 0x5b77ffffffffffffffffffffffffffffff;
3030     //  maxExpArray[  5] = 0x57b3ffffffffffffffffffffffffffffff;
3031     //  maxExpArray[  6] = 0x5419ffffffffffffffffffffffffffffff;
3032     //  maxExpArray[  7] = 0x50a2ffffffffffffffffffffffffffffff;
3033     //  maxExpArray[  8] = 0x4d517fffffffffffffffffffffffffffff;
3034     //  maxExpArray[  9] = 0x4a233fffffffffffffffffffffffffffff;
3035     //  maxExpArray[ 10] = 0x47165fffffffffffffffffffffffffffff;
3036     //  maxExpArray[ 11] = 0x4429afffffffffffffffffffffffffffff;
3037     //  maxExpArray[ 12] = 0x415bc7ffffffffffffffffffffffffffff;
3038     //  maxExpArray[ 13] = 0x3eab73ffffffffffffffffffffffffffff;
3039     //  maxExpArray[ 14] = 0x3c1771ffffffffffffffffffffffffffff;
3040     //  maxExpArray[ 15] = 0x399e96ffffffffffffffffffffffffffff;
3041     //  maxExpArray[ 16] = 0x373fc47fffffffffffffffffffffffffff;
3042     //  maxExpArray[ 17] = 0x34f9e8ffffffffffffffffffffffffffff;
3043     //  maxExpArray[ 18] = 0x32cbfd5fffffffffffffffffffffffffff;
3044     //  maxExpArray[ 19] = 0x30b5057fffffffffffffffffffffffffff;
3045     //  maxExpArray[ 20] = 0x2eb40f9fffffffffffffffffffffffffff;
3046     //  maxExpArray[ 21] = 0x2cc8340fffffffffffffffffffffffffff;
3047     //  maxExpArray[ 22] = 0x2af09481ffffffffffffffffffffffffff;
3048     //  maxExpArray[ 23] = 0x292c5bddffffffffffffffffffffffffff;
3049     //  maxExpArray[ 24] = 0x277abdcdffffffffffffffffffffffffff;
3050     //  maxExpArray[ 25] = 0x25daf6657fffffffffffffffffffffffff;
3051     //  maxExpArray[ 26] = 0x244c49c65fffffffffffffffffffffffff;
3052     //  maxExpArray[ 27] = 0x22ce03cd5fffffffffffffffffffffffff;
3053     //  maxExpArray[ 28] = 0x215f77c047ffffffffffffffffffffffff;
3054     //  maxExpArray[ 29] = 0x1fffffffffffffffffffffffffffffffff;
3055     //  maxExpArray[ 30] = 0x1eaefdbdabffffffffffffffffffffffff;
3056     //  maxExpArray[ 31] = 0x1d6bd8b2ebffffffffffffffffffffffff;
3057         maxExpArray[ 32] = 0x1c35fedd14ffffffffffffffffffffffff;
3058         maxExpArray[ 33] = 0x1b0ce43b323fffffffffffffffffffffff;
3059         maxExpArray[ 34] = 0x19f0028ec1ffffffffffffffffffffffff;
3060         maxExpArray[ 35] = 0x18ded91f0e7fffffffffffffffffffffff;
3061         maxExpArray[ 36] = 0x17d8ec7f0417ffffffffffffffffffffff;
3062         maxExpArray[ 37] = 0x16ddc6556cdbffffffffffffffffffffff;
3063         maxExpArray[ 38] = 0x15ecf52776a1ffffffffffffffffffffff;
3064         maxExpArray[ 39] = 0x15060c256cb2ffffffffffffffffffffff;
3065         maxExpArray[ 40] = 0x1428a2f98d72ffffffffffffffffffffff;
3066         maxExpArray[ 41] = 0x13545598e5c23fffffffffffffffffffff;
3067         maxExpArray[ 42] = 0x1288c4161ce1dfffffffffffffffffffff;
3068         maxExpArray[ 43] = 0x11c592761c666fffffffffffffffffffff;
3069         maxExpArray[ 44] = 0x110a688680a757ffffffffffffffffffff;
3070         maxExpArray[ 45] = 0x1056f1b5bedf77ffffffffffffffffffff;
3071         maxExpArray[ 46] = 0x0faadceceeff8bffffffffffffffffffff;
3072         maxExpArray[ 47] = 0x0f05dc6b27edadffffffffffffffffffff;
3073         maxExpArray[ 48] = 0x0e67a5a25da4107fffffffffffffffffff;
3074         maxExpArray[ 49] = 0x0dcff115b14eedffffffffffffffffffff;
3075         maxExpArray[ 50] = 0x0d3e7a392431239fffffffffffffffffff;
3076         maxExpArray[ 51] = 0x0cb2ff529eb71e4fffffffffffffffffff;
3077         maxExpArray[ 52] = 0x0c2d415c3db974afffffffffffffffffff;
3078         maxExpArray[ 53] = 0x0bad03e7d883f69bffffffffffffffffff;
3079         maxExpArray[ 54] = 0x0b320d03b2c343d5ffffffffffffffffff;
3080         maxExpArray[ 55] = 0x0abc25204e02828dffffffffffffffffff;
3081         maxExpArray[ 56] = 0x0a4b16f74ee4bb207fffffffffffffffff;
3082         maxExpArray[ 57] = 0x09deaf736ac1f569ffffffffffffffffff;
3083         maxExpArray[ 58] = 0x0976bd9952c7aa957fffffffffffffffff;
3084         maxExpArray[ 59] = 0x09131271922eaa606fffffffffffffffff;
3085         maxExpArray[ 60] = 0x08b380f3558668c46fffffffffffffffff;
3086         maxExpArray[ 61] = 0x0857ddf0117efa215bffffffffffffffff;
3087         maxExpArray[ 62] = 0x07ffffffffffffffffffffffffffffffff;
3088         maxExpArray[ 63] = 0x07abbf6f6abb9d087fffffffffffffffff;
3089         maxExpArray[ 64] = 0x075af62cbac95f7dfa7fffffffffffffff;
3090         maxExpArray[ 65] = 0x070d7fb7452e187ac13fffffffffffffff;
3091         maxExpArray[ 66] = 0x06c3390ecc8af379295fffffffffffffff;
3092         maxExpArray[ 67] = 0x067c00a3b07ffc01fd6fffffffffffffff;
3093         maxExpArray[ 68] = 0x0637b647c39cbb9d3d27ffffffffffffff;
3094         maxExpArray[ 69] = 0x05f63b1fc104dbd39587ffffffffffffff;
3095         maxExpArray[ 70] = 0x05b771955b36e12f7235ffffffffffffff;
3096         maxExpArray[ 71] = 0x057b3d49dda84556d6f6ffffffffffffff;
3097         maxExpArray[ 72] = 0x054183095b2c8ececf30ffffffffffffff;
3098         maxExpArray[ 73] = 0x050a28be635ca2b888f77fffffffffffff;
3099         maxExpArray[ 74] = 0x04d5156639708c9db33c3fffffffffffff;
3100         maxExpArray[ 75] = 0x04a23105873875bd52dfdfffffffffffff;
3101         maxExpArray[ 76] = 0x0471649d87199aa990756fffffffffffff;
3102         maxExpArray[ 77] = 0x04429a21a029d4c1457cfbffffffffffff;
3103         maxExpArray[ 78] = 0x0415bc6d6fb7dd71af2cb3ffffffffffff;
3104         maxExpArray[ 79] = 0x03eab73b3bbfe282243ce1ffffffffffff;
3105         maxExpArray[ 80] = 0x03c1771ac9fb6b4c18e229ffffffffffff;
3106         maxExpArray[ 81] = 0x0399e96897690418f785257fffffffffff;
3107         maxExpArray[ 82] = 0x0373fc456c53bb779bf0ea9fffffffffff;
3108         maxExpArray[ 83] = 0x034f9e8e490c48e67e6ab8bfffffffffff;
3109         maxExpArray[ 84] = 0x032cbfd4a7adc790560b3337ffffffffff;
3110         maxExpArray[ 85] = 0x030b50570f6e5d2acca94613ffffffffff;
3111         maxExpArray[ 86] = 0x02eb40f9f620fda6b56c2861ffffffffff;
3112         maxExpArray[ 87] = 0x02cc8340ecb0d0f520a6af58ffffffffff;
3113         maxExpArray[ 88] = 0x02af09481380a0a35cf1ba02ffffffffff;
3114         maxExpArray[ 89] = 0x0292c5bdd3b92ec810287b1b3fffffffff;
3115         maxExpArray[ 90] = 0x0277abdcdab07d5a77ac6d6b9fffffffff;
3116         maxExpArray[ 91] = 0x025daf6654b1eaa55fd64df5efffffffff;
3117         maxExpArray[ 92] = 0x0244c49c648baa98192dce88b7ffffffff;
3118         maxExpArray[ 93] = 0x022ce03cd5619a311b2471268bffffffff;
3119         maxExpArray[ 94] = 0x0215f77c045fbe885654a44a0fffffffff;
3120         maxExpArray[ 95] = 0x01ffffffffffffffffffffffffffffffff;
3121         maxExpArray[ 96] = 0x01eaefdbdaaee7421fc4d3ede5ffffffff;
3122         maxExpArray[ 97] = 0x01d6bd8b2eb257df7e8ca57b09bfffffff;
3123         maxExpArray[ 98] = 0x01c35fedd14b861eb0443f7f133fffffff;
3124         maxExpArray[ 99] = 0x01b0ce43b322bcde4a56e8ada5afffffff;
3125         maxExpArray[100] = 0x019f0028ec1fff007f5a195a39dfffffff;
3126         maxExpArray[101] = 0x018ded91f0e72ee74f49b15ba527ffffff;
3127         maxExpArray[102] = 0x017d8ec7f04136f4e5615fd41a63ffffff;
3128         maxExpArray[103] = 0x016ddc6556cdb84bdc8d12d22e6fffffff;
3129         maxExpArray[104] = 0x015ecf52776a1155b5bd8395814f7fffff;
3130         maxExpArray[105] = 0x015060c256cb23b3b3cc3754cf40ffffff;
3131         maxExpArray[106] = 0x01428a2f98d728ae223ddab715be3fffff;
3132         maxExpArray[107] = 0x013545598e5c23276ccf0ede68034fffff;
3133         maxExpArray[108] = 0x01288c4161ce1d6f54b7f61081194fffff;
3134         maxExpArray[109] = 0x011c592761c666aa641d5a01a40f17ffff;
3135         maxExpArray[110] = 0x0110a688680a7530515f3e6e6cfdcdffff;
3136         maxExpArray[111] = 0x01056f1b5bedf75c6bcb2ce8aed428ffff;
3137         maxExpArray[112] = 0x00faadceceeff8a0890f3875f008277fff;
3138         maxExpArray[113] = 0x00f05dc6b27edad306388a600f6ba0bfff;
3139         maxExpArray[114] = 0x00e67a5a25da41063de1495d5b18cdbfff;
3140         maxExpArray[115] = 0x00dcff115b14eedde6fc3aa5353f2e4fff;
3141         maxExpArray[116] = 0x00d3e7a3924312399f9aae2e0f868f8fff;
3142         maxExpArray[117] = 0x00cb2ff529eb71e41582cccd5a1ee26fff;
3143         maxExpArray[118] = 0x00c2d415c3db974ab32a51840c0b67edff;
3144         maxExpArray[119] = 0x00bad03e7d883f69ad5b0a186184e06bff;
3145         maxExpArray[120] = 0x00b320d03b2c343d4829abd6075f0cc5ff;
3146         maxExpArray[121] = 0x00abc25204e02828d73c6e80bcdb1a95bf;
3147         maxExpArray[122] = 0x00a4b16f74ee4bb2040a1ec6c15fbbf2df;
3148         maxExpArray[123] = 0x009deaf736ac1f569deb1b5ae3f36c130f;
3149         maxExpArray[124] = 0x00976bd9952c7aa957f5937d790ef65037;
3150         maxExpArray[125] = 0x009131271922eaa6064b73a22d0bd4f2bf;
3151         maxExpArray[126] = 0x008b380f3558668c46c91c49a2f8e967b9;
3152         maxExpArray[127] = 0x00857ddf0117efa215952912839f6473e6;
3153     }
3154 
3155     /**
3156         @dev given a token supply, connector balance, weight and a deposit amount (in the connector token),
3157         calculates the return for a given conversion (in the main token)
3158 
3159         Formula:
3160         Return = _supply * ((1 + _depositAmount / _connectorBalance) ^ (_connectorWeight / 1000000) - 1)
3161 
3162         @param _supply              token total supply
3163         @param _connectorBalance    total connector balance
3164         @param _connectorWeight     connector weight, represented in ppm, 1-1000000
3165         @param _depositAmount       deposit amount, in connector token
3166 
3167         @return purchase return amount
3168     */
3169     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256) {
3170         // validate input
3171         require(_supply > 0 && _connectorBalance > 0 && _connectorWeight > 0 && _connectorWeight <= MAX_WEIGHT);
3172 
3173         // special case for 0 deposit amount
3174         if (_depositAmount == 0)
3175             return 0;
3176 
3177         // special case if the weight = 100%
3178         if (_connectorWeight == MAX_WEIGHT)
3179             return safeMul(_supply, _depositAmount) / _connectorBalance;
3180 
3181         uint256 result;
3182         uint8 precision;
3183         uint256 baseN = safeAdd(_depositAmount, _connectorBalance);
3184         (result, precision) = power(baseN, _connectorBalance, _connectorWeight, MAX_WEIGHT);
3185         uint256 temp = safeMul(_supply, result) >> precision;
3186         return temp - _supply;
3187     }
3188 
3189     /**
3190         @dev given a token supply, connector balance, weight and a sell amount (in the main token),
3191         calculates the return for a given conversion (in the connector token)
3192 
3193         Formula:
3194         Return = _connectorBalance * (1 - (1 - _sellAmount / _supply) ^ (1 / (_connectorWeight / 1000000)))
3195 
3196         @param _supply              token total supply
3197         @param _connectorBalance    total connector
3198         @param _connectorWeight     constant connector Weight, represented in ppm, 1-1000000
3199         @param _sellAmount          sell amount, in the token itself
3200 
3201         @return sale return amount
3202     */
3203     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256) {
3204         // validate input
3205         require(_supply > 0 && _connectorBalance > 0 && _connectorWeight > 0 && _connectorWeight <= MAX_WEIGHT && _sellAmount <= _supply);
3206 
3207         // special case for 0 sell amount
3208         if (_sellAmount == 0)
3209             return 0;
3210 
3211         // special case for selling the entire supply
3212         if (_sellAmount == _supply)
3213             return _connectorBalance;
3214 
3215         // special case if the weight = 100%
3216         if (_connectorWeight == MAX_WEIGHT)
3217             return safeMul(_connectorBalance, _sellAmount) / _supply;
3218 
3219         uint256 result;
3220         uint8 precision;
3221         uint256 baseD = _supply - _sellAmount;
3222         (result, precision) = power(_supply, baseD, MAX_WEIGHT, _connectorWeight);
3223         uint256 temp1 = safeMul(_connectorBalance, result);
3224         uint256 temp2 = _connectorBalance << precision;
3225         return (temp1 - temp2) / result;
3226     }
3227 
3228     /**
3229         @dev given two connector balances/weights and a sell amount (in the first connector token),
3230         calculates the return for a conversion from the first connector token to the second connector token (in the second connector token)
3231 
3232         Formula:
3233         Return = _toConnectorBalance * (1 - (_fromConnectorBalance / (_fromConnectorBalance + _amount)) ^ (_fromConnectorWeight / _toConnectorWeight))
3234 
3235         @param _fromConnectorBalance    input connector balance
3236         @param _fromConnectorWeight     input connector weight, represented in ppm, 1-1000000
3237         @param _toConnectorBalance      output connector balance
3238         @param _toConnectorWeight       output connector weight, represented in ppm, 1-1000000
3239         @param _amount                  input connector amount
3240 
3241         @return second connector amount
3242     */
3243     function calculateCrossConnectorReturn(uint256 _fromConnectorBalance, uint32 _fromConnectorWeight, uint256 _toConnectorBalance, uint32 _toConnectorWeight, uint256 _amount) public view returns (uint256) {
3244         // validate input
3245         require(_fromConnectorBalance > 0 && _fromConnectorWeight > 0 && _fromConnectorWeight <= MAX_WEIGHT && _toConnectorBalance > 0 && _toConnectorWeight > 0 && _toConnectorWeight <= MAX_WEIGHT);
3246 
3247         // special case for equal weights
3248         if (_fromConnectorWeight == _toConnectorWeight)
3249             return safeMul(_toConnectorBalance, _amount) / safeAdd(_fromConnectorBalance, _amount);
3250 
3251         uint256 result;
3252         uint8 precision;
3253         uint256 baseN = safeAdd(_fromConnectorBalance, _amount);
3254         (result, precision) = power(baseN, _fromConnectorBalance, _fromConnectorWeight, _toConnectorWeight);
3255         uint256 temp1 = safeMul(_toConnectorBalance, result);
3256         uint256 temp2 = _toConnectorBalance << precision;
3257         return (temp1 - temp2) / result;
3258     }
3259 
3260     /**
3261         General Description:
3262             Determine a value of precision.
3263             Calculate an integer approximation of (_baseN / _baseD) ^ (_expN / _expD) * 2 ^ precision.
3264             Return the result along with the precision used.
3265 
3266         Detailed Description:
3267             Instead of calculating "base ^ exp", we calculate "e ^ (log(base) * exp)".
3268             The value of "log(base)" is represented with an integer slightly smaller than "log(base) * 2 ^ precision".
3269             The larger "precision" is, the more accurately this value represents the real value.
3270             However, the larger "precision" is, the more bits are required in order to store this value.
3271             And the exponentiation function, which takes "x" and calculates "e ^ x", is limited to a maximum exponent (maximum value of "x").
3272             This maximum exponent depends on the "precision" used, and it is given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".
3273             Hence we need to determine the highest precision which can be used for the given input, before calling the exponentiation function.
3274             This allows us to compute "base ^ exp" with maximum accuracy and without exceeding 256 bits in any of the intermediate computations.
3275             This functions assumes that "_expN < 2 ^ 256 / log(MAX_NUM - 1)", otherwise the multiplication should be replaced with a "safeMul".
3276     */
3277     function power(uint256 _baseN, uint256 _baseD, uint32 _expN, uint32 _expD) internal view returns (uint256, uint8) {
3278         require(_baseN < MAX_NUM);
3279 
3280         uint256 baseLog;
3281         uint256 base = _baseN * FIXED_1 / _baseD;
3282         if (base < OPT_LOG_MAX_VAL) {
3283             baseLog = optimalLog(base);
3284         }
3285         else {
3286             baseLog = generalLog(base);
3287         }
3288 
3289         uint256 baseLogTimesExp = baseLog * _expN / _expD;
3290         if (baseLogTimesExp < OPT_EXP_MAX_VAL) {
3291             return (optimalExp(baseLogTimesExp), MAX_PRECISION);
3292         }
3293         else {
3294             uint8 precision = findPositionInMaxExpArray(baseLogTimesExp);
3295             return (generalExp(baseLogTimesExp >> (MAX_PRECISION - precision), precision), precision);
3296         }
3297     }
3298 
3299     /**
3300         Compute log(x / FIXED_1) * FIXED_1.
3301         This functions assumes that "x >= FIXED_1", because the output would be negative otherwise.
3302     */
3303     function generalLog(uint256 x) internal pure returns (uint256) {
3304         uint256 res = 0;
3305 
3306         // If x >= 2, then we compute the integer part of log2(x), which is larger than 0.
3307         if (x >= FIXED_2) {
3308             uint8 count = floorLog2(x / FIXED_1);
3309             x >>= count; // now x < 2
3310             res = count * FIXED_1;
3311         }
3312 
3313         // If x > 1, then we compute the fraction part of log2(x), which is larger than 0.
3314         if (x > FIXED_1) {
3315             for (uint8 i = MAX_PRECISION; i > 0; --i) {
3316                 x = (x * x) / FIXED_1; // now 1 < x < 4
3317                 if (x >= FIXED_2) {
3318                     x >>= 1; // now 1 < x < 2
3319                     res += ONE << (i - 1);
3320                 }
3321             }
3322         }
3323 
3324         return res * LN2_NUMERATOR / LN2_DENOMINATOR;
3325     }
3326 
3327     /**
3328         Compute the largest integer smaller than or equal to the binary logarithm of the input.
3329     */
3330     function floorLog2(uint256 _n) internal pure returns (uint8) {
3331         uint8 res = 0;
3332 
3333         if (_n < 256) {
3334             // At most 8 iterations
3335             while (_n > 1) {
3336                 _n >>= 1;
3337                 res += 1;
3338             }
3339         }
3340         else {
3341             // Exactly 8 iterations
3342             for (uint8 s = 128; s > 0; s >>= 1) {
3343                 if (_n >= (ONE << s)) {
3344                     _n >>= s;
3345                     res |= s;
3346                 }
3347             }
3348         }
3349 
3350         return res;
3351     }
3352 
3353     /**
3354         The global "maxExpArray" is sorted in descending order, and therefore the following statements are equivalent:
3355         - This function finds the position of [the smallest value in "maxExpArray" larger than or equal to "x"]
3356         - This function finds the highest position of [a value in "maxExpArray" larger than or equal to "x"]
3357     */
3358     function findPositionInMaxExpArray(uint256 _x) internal view returns (uint8) {
3359         uint8 lo = MIN_PRECISION;
3360         uint8 hi = MAX_PRECISION;
3361 
3362         while (lo + 1 < hi) {
3363             uint8 mid = (lo + hi) / 2;
3364             if (maxExpArray[mid] >= _x)
3365                 lo = mid;
3366             else
3367                 hi = mid;
3368         }
3369 
3370         if (maxExpArray[hi] >= _x)
3371             return hi;
3372         if (maxExpArray[lo] >= _x)
3373             return lo;
3374 
3375         require(false);
3376         return 0;
3377     }
3378 
3379     /**
3380         This function can be auto-generated by the script 'PrintFunctionGeneralExp.py'.
3381         It approximates "e ^ x" via maclaurin summation: "(x^0)/0! + (x^1)/1! + ... + (x^n)/n!".
3382         It returns "e ^ (x / 2 ^ precision) * 2 ^ precision", that is, the result is upshifted for accuracy.
3383         The global "maxExpArray" maps each "precision" to "((maximumExponent + 1) << (MAX_PRECISION - precision)) - 1".
3384         The maximum permitted value for "x" is therefore given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".
3385     */
3386     function generalExp(uint256 _x, uint8 _precision) internal pure returns (uint256) {
3387         uint256 xi = _x;
3388         uint256 res = 0;
3389 
3390         xi = (xi * _x) >> _precision; res += xi * 0x3442c4e6074a82f1797f72ac0000000; // add x^02 * (33! / 02!)
3391         xi = (xi * _x) >> _precision; res += xi * 0x116b96f757c380fb287fd0e40000000; // add x^03 * (33! / 03!)
3392         xi = (xi * _x) >> _precision; res += xi * 0x045ae5bdd5f0e03eca1ff4390000000; // add x^04 * (33! / 04!)
3393         xi = (xi * _x) >> _precision; res += xi * 0x00defabf91302cd95b9ffda50000000; // add x^05 * (33! / 05!)
3394         xi = (xi * _x) >> _precision; res += xi * 0x002529ca9832b22439efff9b8000000; // add x^06 * (33! / 06!)
3395         xi = (xi * _x) >> _precision; res += xi * 0x00054f1cf12bd04e516b6da88000000; // add x^07 * (33! / 07!)
3396         xi = (xi * _x) >> _precision; res += xi * 0x0000a9e39e257a09ca2d6db51000000; // add x^08 * (33! / 08!)
3397         xi = (xi * _x) >> _precision; res += xi * 0x000012e066e7b839fa050c309000000; // add x^09 * (33! / 09!)
3398         xi = (xi * _x) >> _precision; res += xi * 0x000001e33d7d926c329a1ad1a800000; // add x^10 * (33! / 10!)
3399         xi = (xi * _x) >> _precision; res += xi * 0x0000002bee513bdb4a6b19b5f800000; // add x^11 * (33! / 11!)
3400         xi = (xi * _x) >> _precision; res += xi * 0x00000003a9316fa79b88eccf2a00000; // add x^12 * (33! / 12!)
3401         xi = (xi * _x) >> _precision; res += xi * 0x0000000048177ebe1fa812375200000; // add x^13 * (33! / 13!)
3402         xi = (xi * _x) >> _precision; res += xi * 0x0000000005263fe90242dcbacf00000; // add x^14 * (33! / 14!)
3403         xi = (xi * _x) >> _precision; res += xi * 0x000000000057e22099c030d94100000; // add x^15 * (33! / 15!)
3404         xi = (xi * _x) >> _precision; res += xi * 0x0000000000057e22099c030d9410000; // add x^16 * (33! / 16!)
3405         xi = (xi * _x) >> _precision; res += xi * 0x00000000000052b6b54569976310000; // add x^17 * (33! / 17!)
3406         xi = (xi * _x) >> _precision; res += xi * 0x00000000000004985f67696bf748000; // add x^18 * (33! / 18!)
3407         xi = (xi * _x) >> _precision; res += xi * 0x000000000000003dea12ea99e498000; // add x^19 * (33! / 19!)
3408         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000031880f2214b6e000; // add x^20 * (33! / 20!)
3409         xi = (xi * _x) >> _precision; res += xi * 0x000000000000000025bcff56eb36000; // add x^21 * (33! / 21!)
3410         xi = (xi * _x) >> _precision; res += xi * 0x000000000000000001b722e10ab1000; // add x^22 * (33! / 22!)
3411         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000001317c70077000; // add x^23 * (33! / 23!)
3412         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000cba84aafa00; // add x^24 * (33! / 24!)
3413         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000082573a0a00; // add x^25 * (33! / 25!)
3414         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000005035ad900; // add x^26 * (33! / 26!)
3415         xi = (xi * _x) >> _precision; res += xi * 0x000000000000000000000002f881b00; // add x^27 * (33! / 27!)
3416         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000001b29340; // add x^28 * (33! / 28!)
3417         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000000000efc40; // add x^29 * (33! / 29!)
3418         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000007fe0; // add x^30 * (33! / 30!)
3419         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000000420; // add x^31 * (33! / 31!)
3420         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000000021; // add x^32 * (33! / 32!)
3421         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000000001; // add x^33 * (33! / 33!)
3422 
3423         return res / 0x688589cc0e9505e2f2fee5580000000 + _x + (ONE << _precision); // divide by 33! and then add x^1 / 1! + x^0 / 0!
3424     }
3425 
3426     /**
3427         Return log(x / FIXED_1) * FIXED_1
3428         Input range: FIXED_1 <= x <= LOG_EXP_MAX_VAL - 1
3429         Auto-generated via 'PrintFunctionOptimalLog.py'
3430         Detailed description:
3431         - Rewrite the input as a product of natural exponents and a single residual r, such that 1 < r < 2
3432         - The natural logarithm of each (pre-calculated) exponent is the degree of the exponent
3433         - The natural logarithm of r is calculated via Taylor series for log(1 + x), where x = r - 1
3434         - The natural logarithm of the input is calculated by summing up the intermediate results above
3435         - For example: log(250) = log(e^4 * e^1 * e^0.5 * 1.021692859) = 4 + 1 + 0.5 + log(1 + 0.021692859)
3436     */
3437     function optimalLog(uint256 x) internal pure returns (uint256) {
3438         uint256 res = 0;
3439 
3440         uint256 y;
3441         uint256 z;
3442         uint256 w;
3443 
3444         if (x >= 0xd3094c70f034de4b96ff7d5b6f99fcd8) {res += 0x40000000000000000000000000000000; x = x * FIXED_1 / 0xd3094c70f034de4b96ff7d5b6f99fcd8;} // add 1 / 2^1
3445         if (x >= 0xa45af1e1f40c333b3de1db4dd55f29a7) {res += 0x20000000000000000000000000000000; x = x * FIXED_1 / 0xa45af1e1f40c333b3de1db4dd55f29a7;} // add 1 / 2^2
3446         if (x >= 0x910b022db7ae67ce76b441c27035c6a1) {res += 0x10000000000000000000000000000000; x = x * FIXED_1 / 0x910b022db7ae67ce76b441c27035c6a1;} // add 1 / 2^3
3447         if (x >= 0x88415abbe9a76bead8d00cf112e4d4a8) {res += 0x08000000000000000000000000000000; x = x * FIXED_1 / 0x88415abbe9a76bead8d00cf112e4d4a8;} // add 1 / 2^4
3448         if (x >= 0x84102b00893f64c705e841d5d4064bd3) {res += 0x04000000000000000000000000000000; x = x * FIXED_1 / 0x84102b00893f64c705e841d5d4064bd3;} // add 1 / 2^5
3449         if (x >= 0x8204055aaef1c8bd5c3259f4822735a2) {res += 0x02000000000000000000000000000000; x = x * FIXED_1 / 0x8204055aaef1c8bd5c3259f4822735a2;} // add 1 / 2^6
3450         if (x >= 0x810100ab00222d861931c15e39b44e99) {res += 0x01000000000000000000000000000000; x = x * FIXED_1 / 0x810100ab00222d861931c15e39b44e99;} // add 1 / 2^7
3451         if (x >= 0x808040155aabbbe9451521693554f733) {res += 0x00800000000000000000000000000000; x = x * FIXED_1 / 0x808040155aabbbe9451521693554f733;} // add 1 / 2^8
3452 
3453         z = y = x - FIXED_1;
3454         w = y * y / FIXED_1;
3455         res += z * (0x100000000000000000000000000000000 - y) / 0x100000000000000000000000000000000; z = z * w / FIXED_1; // add y^01 / 01 - y^02 / 02
3456         res += z * (0x0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa - y) / 0x200000000000000000000000000000000; z = z * w / FIXED_1; // add y^03 / 03 - y^04 / 04
3457         res += z * (0x099999999999999999999999999999999 - y) / 0x300000000000000000000000000000000; z = z * w / FIXED_1; // add y^05 / 05 - y^06 / 06
3458         res += z * (0x092492492492492492492492492492492 - y) / 0x400000000000000000000000000000000; z = z * w / FIXED_1; // add y^07 / 07 - y^08 / 08
3459         res += z * (0x08e38e38e38e38e38e38e38e38e38e38e - y) / 0x500000000000000000000000000000000; z = z * w / FIXED_1; // add y^09 / 09 - y^10 / 10
3460         res += z * (0x08ba2e8ba2e8ba2e8ba2e8ba2e8ba2e8b - y) / 0x600000000000000000000000000000000; z = z * w / FIXED_1; // add y^11 / 11 - y^12 / 12
3461         res += z * (0x089d89d89d89d89d89d89d89d89d89d89 - y) / 0x700000000000000000000000000000000; z = z * w / FIXED_1; // add y^13 / 13 - y^14 / 14
3462         res += z * (0x088888888888888888888888888888888 - y) / 0x800000000000000000000000000000000;                      // add y^15 / 15 - y^16 / 16
3463 
3464         return res;
3465     }
3466 
3467     /**
3468         Return e ^ (x / FIXED_1) * FIXED_1
3469         Input range: 0 <= x <= OPT_EXP_MAX_VAL - 1
3470         Auto-generated via 'PrintFunctionOptimalExp.py'
3471         Detailed description:
3472         - Rewrite the input as a sum of binary exponents and a single residual r, as small as possible
3473         - The exponentiation of each binary exponent is given (pre-calculated)
3474         - The exponentiation of r is calculated via Taylor series for e^x, where x = r
3475         - The exponentiation of the input is calculated by multiplying the intermediate results above
3476         - For example: e^5.021692859 = e^(4 + 1 + 0.5 + 0.021692859) = e^4 * e^1 * e^0.5 * e^0.021692859
3477     */
3478     function optimalExp(uint256 x) internal pure returns (uint256) {
3479         uint256 res = 0;
3480 
3481         uint256 y;
3482         uint256 z;
3483 
3484         z = y = x % 0x10000000000000000000000000000000; // get the input modulo 2^(-3)
3485         z = z * y / FIXED_1; res += z * 0x10e1b3be415a0000; // add y^02 * (20! / 02!)
3486         z = z * y / FIXED_1; res += z * 0x05a0913f6b1e0000; // add y^03 * (20! / 03!)
3487         z = z * y / FIXED_1; res += z * 0x0168244fdac78000; // add y^04 * (20! / 04!)
3488         z = z * y / FIXED_1; res += z * 0x004807432bc18000; // add y^05 * (20! / 05!)
3489         z = z * y / FIXED_1; res += z * 0x000c0135dca04000; // add y^06 * (20! / 06!)
3490         z = z * y / FIXED_1; res += z * 0x0001b707b1cdc000; // add y^07 * (20! / 07!)
3491         z = z * y / FIXED_1; res += z * 0x000036e0f639b800; // add y^08 * (20! / 08!)
3492         z = z * y / FIXED_1; res += z * 0x00000618fee9f800; // add y^09 * (20! / 09!)
3493         z = z * y / FIXED_1; res += z * 0x0000009c197dcc00; // add y^10 * (20! / 10!)
3494         z = z * y / FIXED_1; res += z * 0x0000000e30dce400; // add y^11 * (20! / 11!)
3495         z = z * y / FIXED_1; res += z * 0x000000012ebd1300; // add y^12 * (20! / 12!)
3496         z = z * y / FIXED_1; res += z * 0x0000000017499f00; // add y^13 * (20! / 13!)
3497         z = z * y / FIXED_1; res += z * 0x0000000001a9d480; // add y^14 * (20! / 14!)
3498         z = z * y / FIXED_1; res += z * 0x00000000001c6380; // add y^15 * (20! / 15!)
3499         z = z * y / FIXED_1; res += z * 0x000000000001c638; // add y^16 * (20! / 16!)
3500         z = z * y / FIXED_1; res += z * 0x0000000000001ab8; // add y^17 * (20! / 17!)
3501         z = z * y / FIXED_1; res += z * 0x000000000000017c; // add y^18 * (20! / 18!)
3502         z = z * y / FIXED_1; res += z * 0x0000000000000014; // add y^19 * (20! / 19!)
3503         z = z * y / FIXED_1; res += z * 0x0000000000000001; // add y^20 * (20! / 20!)
3504         res = res / 0x21c3677c82b40000 + y + FIXED_1; // divide by 20! and then add y^1 / 1! + y^0 / 0!
3505 
3506         if ((x & 0x010000000000000000000000000000000) != 0) res = res * 0x1c3d6a24ed82218787d624d3e5eba95f9 / 0x18ebef9eac820ae8682b9793ac6d1e776; // multiply by e^2^(-3)
3507         if ((x & 0x020000000000000000000000000000000) != 0) res = res * 0x18ebef9eac820ae8682b9793ac6d1e778 / 0x1368b2fc6f9609fe7aceb46aa619baed4; // multiply by e^2^(-2)
3508         if ((x & 0x040000000000000000000000000000000) != 0) res = res * 0x1368b2fc6f9609fe7aceb46aa619baed5 / 0x0bc5ab1b16779be3575bd8f0520a9f21f; // multiply by e^2^(-1)
3509         if ((x & 0x080000000000000000000000000000000) != 0) res = res * 0x0bc5ab1b16779be3575bd8f0520a9f21e / 0x0454aaa8efe072e7f6ddbab84b40a55c9; // multiply by e^2^(+0)
3510         if ((x & 0x100000000000000000000000000000000) != 0) res = res * 0x0454aaa8efe072e7f6ddbab84b40a55c5 / 0x00960aadc109e7a3bf4578099615711ea; // multiply by e^2^(+1)
3511         if ((x & 0x200000000000000000000000000000000) != 0) res = res * 0x00960aadc109e7a3bf4578099615711d7 / 0x0002bf84208204f5977f9a8cf01fdce3d; // multiply by e^2^(+2)
3512         if ((x & 0x400000000000000000000000000000000) != 0) res = res * 0x0002bf84208204f5977f9a8cf01fdc307 / 0x0000003c6ab775dd0b95b4cbee7e65d11; // multiply by e^2^(+3)
3513 
3514         return res;
3515     }
3516 }
3517 
3518 // File: contracts/ClubTokenController.sol
3519 
3520 pragma solidity ^0.4.18;
3521 
3522 /**
3523 * The ClubTokenController is a replaceable endpoint for minting and unminting ClubToken.sol
3524 */
3525 
3526 
3527 
3528 
3529 
3530 contract ClubTokenController is BancorFormula, Admin, Ownable {
3531     event Buy(address buyer, uint256 tokens, uint256 value, uint256 poolBalance, uint256 tokenSupply);
3532     event Sell(address seller, uint256 tokens, uint256 value, uint256 poolBalance, uint256 tokenSupply);
3533 
3534     bool public paused;
3535     address public clubToken;
3536     address public simpleCloversMarket;
3537     address public curationMarket;
3538     address public support;
3539 
3540     /* uint256 public poolBalance; */
3541     uint256 public virtualSupply;
3542     uint256 public virtualBalance;
3543     uint32 public reserveRatio; // represented in ppm, 1-1000000
3544 
3545     constructor(address _clubToken) public {
3546         clubToken = _clubToken;
3547         paused = true;
3548     }
3549 
3550     function () public payable {
3551         buy(msg.sender);
3552     }
3553 
3554     modifier notPaused() {
3555         require(!paused || owner == msg.sender || admins[tx.origin], "Contract must not be paused");
3556         _;
3557     }
3558 
3559     function poolBalance() public constant returns(uint256) {
3560         return clubToken.balance;
3561     }
3562 
3563     /**
3564     * @dev gets the amount of tokens returned from spending Eth
3565     * @param buyValue The amount of Eth to be spent
3566     * @return A uint256 representing the amount of tokens gained in exchange for the Eth.
3567     */
3568     function getBuy(uint256 buyValue) public constant returns(uint256) {
3569         return calculatePurchaseReturn(
3570             safeAdd(ClubToken(clubToken).totalSupply(), virtualSupply),
3571             safeAdd(poolBalance(), virtualBalance),
3572             reserveRatio,
3573             buyValue);
3574     }
3575 
3576 
3577     /**
3578     * @dev gets the amount of Eth returned from selling tokens
3579     * @param sellAmount The amount of tokens to be sold
3580     * @return A uint256 representing the amount of Eth gained in exchange for the tokens.
3581     */
3582 
3583     function getSell(uint256 sellAmount) public constant returns(uint256) {
3584         return calculateSaleReturn(
3585             safeAdd(ClubToken(clubToken).totalSupply(), virtualSupply),
3586             safeAdd(poolBalance(), virtualBalance),
3587             reserveRatio,
3588             sellAmount);
3589     }
3590 
3591     function updatePaused(bool _paused) public onlyOwner {
3592         paused = _paused;
3593     }
3594 
3595     /**
3596     * @dev updates the Reserve Ratio variable
3597     * @param _reserveRatio The reserve ratio that determines the curve
3598     * @return A boolean representing whether or not the update was successful.
3599     */
3600     function updateReserveRatio(uint32 _reserveRatio) public onlyOwner returns(bool){
3601         reserveRatio = _reserveRatio;
3602         return true;
3603     }
3604 
3605     /**
3606     * @dev updates the Virtual Supply variable
3607     * @param _virtualSupply The virtual supply of tokens used for calculating buys and sells
3608     * @return A boolean representing whether or not the update was successful.
3609     */
3610     function updateVirtualSupply(uint256 _virtualSupply) public onlyOwner returns(bool){
3611         virtualSupply = _virtualSupply;
3612         return true;
3613     }
3614 
3615     /**
3616     * @dev updates the Virtual Balance variable
3617     * @param _virtualBalance The virtual balance of the contract used for calculating buys and sells
3618     * @return A boolean representing whether or not the update was successful.
3619     */
3620     function updateVirtualBalance(uint256 _virtualBalance) public onlyOwner returns(bool){
3621         virtualBalance = _virtualBalance;
3622         return true;
3623     }
3624     /**
3625     * @dev updates the poolBalance
3626     * @param _poolBalance The eth balance of ClubToken.sol
3627     * @return A boolean representing whether or not the update was successful.
3628     */
3629     /* function updatePoolBalance(uint256 _poolBalance) public onlyOwner returns(bool){
3630         poolBalance = _poolBalance;
3631         return true;
3632     } */
3633 
3634     /**
3635     * @dev updates the SimpleCloversMarket address
3636     * @param _simpleCloversMarket The address of the simpleCloversMarket
3637     * @return A boolean representing whether or not the update was successful.
3638     */
3639     function updateSimpleCloversMarket(address _simpleCloversMarket) public onlyOwner returns(bool){
3640         simpleCloversMarket = _simpleCloversMarket;
3641         return true;
3642     }
3643 
3644     /**
3645     * @dev updates the CurationMarket address
3646     * @param _curationMarket The address of the curationMarket
3647     * @return A boolean representing whether or not the update was successful.
3648     */
3649     function updateCurationMarket(address _curationMarket) public onlyOwner returns(bool){
3650         curationMarket = _curationMarket;
3651         return true;
3652     }
3653 
3654     /**
3655     * @dev updates the Support address
3656     * @param _support The address of the Support
3657     * @return A boolean representing whether or not the update was successful.
3658     */
3659     function updateSupport(address _support) public onlyOwner returns(bool){
3660         support = _support;
3661         return true;
3662     }
3663 
3664     /**
3665     * @dev donate Donate Eth to the poolBalance without increasing the totalSupply
3666     */
3667     function donate() public payable {
3668         require(msg.value > 0);
3669         /* poolBalance = safeAdd(poolBalance, msg.value); */
3670         clubToken.transfer(msg.value);
3671     }
3672 
3673     function burn(address from, uint256 amount) public {
3674         require(msg.sender == simpleCloversMarket);
3675         ClubToken(clubToken).burn(from, amount);
3676     }
3677 
3678     function transferFrom(address from, address to, uint256 amount) public {
3679         require(msg.sender == simpleCloversMarket || msg.sender == curationMarket || msg.sender == support);
3680         ClubToken(clubToken).transferFrom(from, to, amount);
3681     }
3682 
3683     /**
3684     * @dev buy Buy ClubTokens with Eth
3685     * @param buyer The address that should receive the new tokens
3686     */
3687     function buy(address buyer) public payable notPaused returns(bool) {
3688         require(msg.value > 0);
3689         uint256 tokens = getBuy(msg.value);
3690         require(tokens > 0);
3691         require(ClubToken(clubToken).mint(buyer, tokens));
3692         /* poolBalance = safeAdd(poolBalance, msg.value); */
3693         clubToken.transfer(msg.value);
3694         emit Buy(buyer, tokens, msg.value, poolBalance(), ClubToken(clubToken).totalSupply());
3695     }
3696 
3697 
3698     /**
3699     * @dev sell Sell ClubTokens for Eth
3700     * @param sellAmount The amount of tokens to sell
3701     */
3702     function sell(uint256 sellAmount) public notPaused returns(bool) {
3703         require(sellAmount > 0);
3704         require(ClubToken(clubToken).balanceOf(msg.sender) >= sellAmount);
3705         uint256 saleReturn = getSell(sellAmount);
3706         require(saleReturn > 0);
3707         require(saleReturn <= poolBalance());
3708         require(saleReturn <= clubToken.balance);
3709         ClubToken(clubToken).burn(msg.sender, sellAmount);
3710         /* poolBalance = safeSub(poolBalance, saleReturn); */
3711         ClubToken(clubToken).moveEth(msg.sender, saleReturn);
3712         emit Sell(msg.sender, sellAmount, saleReturn, poolBalance(), ClubToken(clubToken).totalSupply());
3713     }
3714 
3715 
3716  }
3717 
3718 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
3719 
3720 pragma solidity ^0.4.24;
3721 
3722 
3723 
3724 
3725 /**
3726  * @title SafeERC20
3727  * @dev Wrappers around ERC20 operations that throw on failure.
3728  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
3729  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
3730  */
3731 library SafeERC20 {
3732   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
3733     require(token.transfer(to, value));
3734   }
3735 
3736   function safeTransferFrom(
3737     ERC20 token,
3738     address from,
3739     address to,
3740     uint256 value
3741   )
3742     internal
3743   {
3744     require(token.transferFrom(from, to, value));
3745   }
3746 
3747   function safeApprove(ERC20 token, address spender, uint256 value) internal {
3748     require(token.approve(spender, value));
3749   }
3750 }
3751 
3752 // File: zeppelin-solidity/contracts/ownership/CanReclaimToken.sol
3753 
3754 pragma solidity ^0.4.24;
3755 
3756 
3757 
3758 
3759 
3760 /**
3761  * @title Contracts that should be able to recover tokens
3762  * @author SylTi
3763  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
3764  * This will prevent any accidental loss of tokens.
3765  */
3766 contract CanReclaimToken is Ownable {
3767   using SafeERC20 for ERC20Basic;
3768 
3769   /**
3770    * @dev Reclaim all ERC20Basic compatible tokens
3771    * @param token ERC20Basic The address of the token contract
3772    */
3773   function reclaimToken(ERC20Basic token) external onlyOwner {
3774     uint256 balance = token.balanceOf(this);
3775     token.safeTransfer(owner, balance);
3776   }
3777 
3778 }
3779 
3780 // File: zeppelin-solidity/contracts/ownership/HasNoTokens.sol
3781 
3782 pragma solidity ^0.4.24;
3783 
3784 
3785 
3786 /**
3787  * @title Contracts that should not own Tokens
3788  * @author Remco Bloemen <remco@2π.com>
3789  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
3790  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
3791  * owner to reclaim the tokens.
3792  */
3793 contract HasNoTokens is CanReclaimToken {
3794 
3795  /**
3796   * @dev Reject all ERC223 compatible tokens
3797   * @param from_ address The address that is transferring the tokens
3798   * @param value_ uint256 the amount of the specified token
3799   * @param data_ Bytes The data passed from the caller.
3800   */
3801   function tokenFallback(address from_, uint256 value_, bytes data_) external {
3802     from_;
3803     value_;
3804     data_;
3805     revert();
3806   }
3807 
3808 }
3809 
3810 // File: zeppelin-solidity/contracts/ownership/HasNoEther.sol
3811 
3812 pragma solidity ^0.4.24;
3813 
3814 
3815 
3816 /**
3817  * @title Contracts that should not own Ether
3818  * @author Remco Bloemen <remco@2π.com>
3819  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
3820  * in the contract, it will allow the owner to reclaim this ether.
3821  * @notice Ether can still be sent to this contract by:
3822  * calling functions labeled `payable`
3823  * `selfdestruct(contract_address)`
3824  * mining directly to the contract address
3825  */
3826 contract HasNoEther is Ownable {
3827 
3828   /**
3829   * @dev Constructor that rejects incoming Ether
3830   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
3831   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
3832   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
3833   * we could use assembly to access msg.value.
3834   */
3835   constructor() public payable {
3836     require(msg.value == 0);
3837   }
3838 
3839   /**
3840    * @dev Disallows direct send by settings a default function without the `payable` flag.
3841    */
3842   function() external {
3843   }
3844 
3845   /**
3846    * @dev Transfer all Ether held by the contract to the owner.
3847    */
3848   function reclaimEther() external onlyOwner {
3849     owner.transfer(address(this).balance);
3850   }
3851 }
3852 
3853 // File: contracts/CloversController.sol
3854 
3855 pragma solidity ^0.4.18;
3856 
3857 /**
3858  * The CloversController is a replaceable endpoint for minting and unminting Clovers.sol and ClubToken.sol
3859  */
3860 
3861 
3862 
3863 
3864 
3865 
3866 
3867 
3868 
3869 contract ISimpleCloversMarket {
3870     function sell(uint256 _tokenId, uint256 price) public;
3871 } 
3872 
3873 contract CloversController is HasNoEther, HasNoTokens {
3874     event cloverCommitted(bytes32 movesHash, address owner);
3875     event cloverClaimed(bytes28[2] moves, uint256 tokenId, address owner, uint stake, uint reward, uint256 symmetries, bool keep);
3876     event stakeRetrieved(uint256 tokenId, address owner, uint stake);
3877     event cloverChallenged(bytes28[2] moves, uint256 tokenId, address owner, address challenger, uint stake);
3878 
3879     using SafeMath for uint256;
3880     bool public paused;
3881     address public oracle;
3882     address public clovers;
3883     address public clubToken;
3884     address public clubTokenController;
3885     address public simpleCloversMarket;
3886     address public curationMarket;
3887 
3888     uint256 public gasLastUpdated_fastGasPrice_averageGasPrice_safeLowGasPrice;
3889     uint256 public gasBlockMargin = 240; // ~1 hour at 15 second blocks
3890 
3891     uint256 public basePrice;
3892     uint256 public priceMultiplier;
3893     uint256 public payMultiplier;
3894     uint256 public stakeAmount;
3895     uint256 public stakePeriod;
3896     uint256 public constant oneGwei = 1000000000;
3897     uint256 public marginOfError = 3;
3898     struct Commit {
3899         bool collected;
3900         uint256 stake;
3901         address committer;
3902     }
3903 
3904     mapping (bytes32 => Commit) public commits;
3905 
3906     modifier notPaused() {
3907         require(!paused, "Must not be paused");
3908         _;
3909     }
3910 
3911     modifier onlyOwnerOrOracle () {
3912         require(msg.sender == owner || msg.sender == oracle);
3913         _;
3914     }
3915 
3916     constructor(address _clovers, address _clubToken, address _clubTokenController) public {
3917         clovers = _clovers;
3918         clubToken = _clubToken;
3919         clubTokenController = _clubTokenController;
3920         paused = true;
3921     }
3922     /**
3923     * @dev Gets the current stake of a Clover based on the hash of the moves.
3924     * @param movesHash The hash of the moves that make up the clover.
3925     * @return A uint256 value of stake.
3926     */
3927     function getStake(bytes32 movesHash) public view returns (uint256) {
3928         return commits[movesHash].stake;
3929     }
3930     /**
3931     * @dev Gets the address of the committer of a Clover based on the hash of the moves.
3932     * @param movesHash The hash of the moves that make up the clover.
3933     * @return The address of the committer.
3934     */
3935     function getCommit(bytes32 movesHash) public view returns (address) {
3936         return commits[movesHash].committer;
3937     }
3938     /**
3939     * @dev Gets the current staking period needed to verify a Clover.
3940     * @param _tokenId The token Id of the clover.
3941     * @return A uint256 value of stake period in seconds.
3942     */
3943     function getMovesHash(uint _tokenId) public constant returns (bytes32) {
3944         return keccak256(Clovers(clovers).getCloverMoves(_tokenId));
3945     }
3946     /**
3947     * @dev Checks whether the game is valid.
3948     * @param moves The moves needed to play validate the game.
3949     * @return A boolean representing whether or not the game is valid.
3950     */
3951     function isValid(bytes28[2] moves) public constant returns (bool) {
3952         Reversi.Game memory game = Reversi.playGame(moves);
3953         return isValidGame(game.error, game.complete);
3954     }
3955 
3956     /**
3957     * @dev Checks whether the game is valid.
3958     * @param error The pre-played game error
3959     * @param complete The pre-played game complete boolean
3960     * @return A boolean representing whether or not the game is valid.
3961     */
3962     function isValidGame(bool error, bool complete) public pure returns (bool) {
3963         if (error) return false;
3964         if (!complete) return false;
3965         return true;
3966     }
3967     /**
3968     * @dev Checks whether the game has passed the verification period.
3969     * @param _tokenId The board being checked.
3970     * @return A boolean representing whether or not the game has been verified.
3971     */
3972     function isVerified(uint256 _tokenId) public constant returns (bool) {
3973         uint256 _blockMinted = Clovers(clovers).getBlockMinted(_tokenId);
3974         if(_blockMinted == 0) return false;
3975         return block.number.sub(_blockMinted) > stakePeriod;
3976     }
3977     /**
3978     * @dev Calculates the reward of the board.
3979     * @param _symmetries symmetries saved as a uint256 value like 00010101 where bits represent symmetry types.
3980     * @return A uint256 representing the reward that would be returned for claiming the board.
3981     */
3982     function calculateReward(uint256 _symmetries) public constant returns (uint256) {
3983         uint256 Symmetricals;
3984         uint256 RotSym;
3985         uint256 Y0Sym;
3986         uint256 X0Sym;
3987         uint256 XYSym;
3988         uint256 XnYSym;
3989         (Symmetricals,
3990         RotSym,
3991         Y0Sym,
3992         X0Sym,
3993         XYSym,
3994         XnYSym) = Clovers(clovers).getAllSymmetries();
3995         uint256 base = 0;
3996         if (_symmetries >> 4 & 1 == 1) base = base.add(payMultiplier.mul(Symmetricals + 1).div(RotSym + 1));
3997         if (_symmetries >> 3 & 1 == 1) base = base.add(payMultiplier.mul(Symmetricals + 1).div(Y0Sym + 1));
3998         if (_symmetries >> 2 & 1 == 1) base = base.add(payMultiplier.mul(Symmetricals + 1).div(X0Sym + 1));
3999         if (_symmetries >> 1 & 1 == 1) base = base.add(payMultiplier.mul(Symmetricals + 1).div(XYSym + 1));
4000         if (_symmetries & 1 == 1) base = base.add(payMultiplier.mul(Symmetricals + 1).div(XnYSym + 1));
4001         return base;
4002     }
4003 
4004 /*
4005     // NOTE: Disabled to reduce contract size
4006     function instantClaimClover(bytes28[2] moves, bool _keep) public payable returns (bool) {
4007         Reversi.Game memory game = Reversi.playGame(moves);
4008         require(isValidGame(game.error, game.complete));
4009         uint256 tokenId = uint256(game.board);
4010         require(Clovers(clovers).getBlockMinted(tokenId) == 0);
4011         require(!Clovers(clovers).exists(tokenId));
4012         Clovers(clovers).setBlockMinted(tokenId, block.number);
4013         Clovers(clovers).setCloverMoves(tokenId, moves);
4014 
4015         uint256 symmetries = Reversi.returnSymmetricals(game.RotSym, game.Y0Sym, game.X0Sym, game.XYSym, game.XnYSym);
4016         uint256 reward;
4017 
4018         if (uint256(symmetries) > 0) {
4019             Clovers(clovers).setSymmetries(tokenId, uint256(symmetries));
4020             reward = calculateReward(uint256(symmetries));
4021             Clovers(clovers).setReward(tokenId, reward);
4022         }
4023         if (_keep) {
4024             // If the user decides to keep the Clover, they must
4025             // pay for it in club tokens according to the reward price.
4026             if (ClubToken(clubToken).balanceOf(msg.sender) < reward) {
4027                 ClubTokenController(clubTokenController).buy.value(msg.value)(msg.sender); // msg.value needs to be enough to buy "reward" amount of Club Token
4028             }
4029             if (reward > 0) {
4030                 // ClubToken(clubToken).transferFrom(msg.sender, clubToken, reward); // if we'd rather keep the money
4031                 ClubToken(clubToken).burn(msg.sender, reward);
4032             }
4033             Clovers(clovers).mint(msg.sender, tokenId);
4034         } else {
4035             // If the user decides not to keep the Clover, they will
4036             // receive the reward price in club tokens, and the clover will
4037             // go for sale at 10x the reward price.
4038             if (reward > 0) {
4039                 require(ClubToken(clubToken).mint(msg.sender, reward));
4040             }
4041             Clovers(clovers).mint(clovers, tokenId);
4042         }
4043 
4044     } */
4045 
4046     function getPrice(uint256 _symmetries) public constant returns(uint256) {
4047         return basePrice.add(calculateReward(_symmetries));
4048     }
4049 
4050     function updateGasBlockMargin(uint256 _gasBlockMargin) public onlyOwnerOrOracle {
4051         gasBlockMargin = _gasBlockMargin;
4052     }
4053 
4054     function updateMarginOfError(uint256 _marginOfError) public onlyOwnerOrOracle {
4055         marginOfError = _marginOfError;
4056     }
4057 
4058     function updateGasPrices(uint256 _fastGasPrice, uint256 _averageGasPrice, uint256 _safeLowGasPrice) public onlyOwnerOrOracle {
4059         uint256 gasLastUpdated = block.number << 192;
4060         uint256 fastGasPrice = _fastGasPrice << 128;
4061         uint256 averageGasPrice = _averageGasPrice << 64;
4062         uint256 safeLowGasPrice = _safeLowGasPrice;
4063         gasLastUpdated_fastGasPrice_averageGasPrice_safeLowGasPrice = gasLastUpdated | fastGasPrice | averageGasPrice | safeLowGasPrice;
4064     }
4065 
4066     function gasLastUpdated() public view returns(uint256) {
4067         return uint256(uint64(gasLastUpdated_fastGasPrice_averageGasPrice_safeLowGasPrice >> 192));
4068     }
4069     function fastGasPrice() public view returns(uint256) {
4070         return uint256(uint64(gasLastUpdated_fastGasPrice_averageGasPrice_safeLowGasPrice >> 128));
4071     }
4072     function averageGasPrice() public view returns(uint256) {
4073         return uint256(uint64(gasLastUpdated_fastGasPrice_averageGasPrice_safeLowGasPrice >> 64));
4074     }
4075     function safeLowGasPrice() public view returns(uint256) {
4076         return uint256(uint64(gasLastUpdated_fastGasPrice_averageGasPrice_safeLowGasPrice));
4077     }
4078     function getGasPriceForApp() public view returns(uint256) {
4079         if (block.number.sub(gasLastUpdated()) > gasBlockMargin) {
4080             return oneGwei.mul(10);
4081         } else {
4082             return fastGasPrice();
4083         }
4084     }
4085 
4086     /**
4087     * @dev Claim the Clover without a commit or reveal. Payable so you can attach enough for the stake,
4088     * as well as enough to buy tokens if needed to keep the Clover.
4089     * @param moves The moves that make up the Clover reversi game.
4090     * @param _tokenId The board that results from the moves.
4091     * @param _symmetries symmetries saved as a uint256 value like 00010101 where bits represent symmetry
4092     * @param _keep symmetries saved as a uint256 value like 00010101 where bits represent symmetry
4093     * types.
4094     * @return A boolean representing whether or not the claim was successful.
4095     */
4096     function claimClover(bytes28[2] moves, uint256 _tokenId, uint256 _symmetries, bool _keep) public payable notPaused returns (bool) {
4097         emit cloverClaimed(moves, _tokenId, msg.sender, _tokenId, _tokenId, _symmetries, _keep);
4098 
4099         bytes32 movesHash = keccak256(moves);
4100 
4101         uint256 stakeWithGas = stakeAmount.mul(getGasPriceForApp());
4102         uint256 _marginOfError = stakeAmount.mul(oneGwei).mul(marginOfError);
4103         require(msg.value >= stakeWithGas.sub(_marginOfError));
4104         require(getCommit(movesHash) == 0);
4105 
4106         setCommit(movesHash, msg.sender);
4107         if (stakeWithGas > 0) {
4108             setStake(movesHash, stakeWithGas);
4109             clovers.transfer(stakeWithGas);
4110         }
4111 
4112         emit cloverCommitted(movesHash, msg.sender);
4113 
4114         require(!Clovers(clovers).exists(_tokenId));
4115         require(Clovers(clovers).getBlockMinted(_tokenId) == 0);
4116 
4117         Clovers(clovers).setBlockMinted(_tokenId, block.number);
4118         Clovers(clovers).setCloverMoves(_tokenId, moves);
4119         Clovers(clovers).setKeep(_tokenId, _keep);
4120 
4121         uint256 reward;
4122         if (_symmetries > 0) {
4123             Clovers(clovers).setSymmetries(_tokenId, _symmetries);
4124             reward = calculateReward(_symmetries);
4125             Clovers(clovers).setReward(_tokenId, reward);
4126         }
4127         uint256 price = basePrice.add(reward);
4128         if (_keep && price > 0) {
4129             // If the user decides to keep the Clover, they must
4130             // pay for it in club tokens according to the reward price.
4131             if (ClubToken(clubToken).balanceOf(msg.sender) < price) {
4132                 ClubTokenController(clubTokenController).buy.value(msg.value.sub(stakeWithGas))(msg.sender);
4133             }
4134             // require(ClubToken(clubToken).transferFrom(msg.sender, clovers, price));
4135             ClubToken(clubToken).burn(msg.sender, price);
4136         }
4137         Clovers(clovers).mint(clovers, _tokenId);
4138         emit cloverClaimed(moves, _tokenId, msg.sender, stakeWithGas, reward, _symmetries, _keep);
4139         return true;
4140     }
4141 
4142 
4143     // This is better than current commit hash because the commiter's address is part of the move sequence
4144     // otherwise griefing could still take place....
4145     // function generateCommit(bytes28[2] moves) public view returns(bytes32 commitHash) {
4146     //     return sha256(moves, msg.sender);
4147     // }
4148 
4149     /**
4150     * @dev Commit the hash of the moves needed to claim the Clover. A stake should be
4151     * made for counterfactual verification.
4152     * @param movesHash The hash of the moves that makes up the Clover reversi
4153     * game.
4154     * @return A boolean representing whether or not the commit was successful.
4155     NOTE: Disabled for contract size, if front running becomes a problem it can be
4156     implemented with an upgrade
4157     */
4158     /* function claimCloverCommit(bytes32 movesHash) public payable returns (bool) {
4159         require(msg.value >= stakeAmount);
4160         require(getCommit(movesHash) == 0);
4161 
4162         setCommit(movesHash, msg.sender);
4163         setStake(movesHash, stakeAmount);
4164 
4165         clovers.transfer(stakeAmount);
4166 
4167         emit cloverCommitted(movesHash, msg.sender);
4168         return true;
4169     }
4170     /**
4171     * @dev Reveal the solution to the previous commit to claim the Clover.
4172     * @param moves The moves that make up the Clover reversi game.
4173     * @param _tokenId The board that results from the moves.
4174     * @param _symmetries symmetries saved as a uint256 value like 00010101 where bits represent symmetry types.
4175     * @return A boolean representing whether or not the reveal and claim was successful.
4176     NOTE: Disabled for contract size, if front running becomes a problem it can be implemented with an upgrade
4177     */
4178     /* function claimCloverReveal(bytes28[2] moves, uint256 _tokenId, uint256 _symmetries, bool _keep) public returns (bool) {
4179         bytes32 movesHash = keccak256(moves);
4180         address committer = getCommit(movesHash);
4181 
4182         require(Clovers(clovers).getBlockMinted(_tokenId) == 0);
4183 
4184         Clovers(clovers).setBlockMinted(_tokenId, block.number);
4185         Clovers(clovers).setCloverMoves(_tokenId, moves);
4186         Clovers(clovers).setKeep(_tokenId, _keep);
4187         uint256 reward;
4188         if (_symmetries > 0) {
4189             Clovers(clovers).setSymmetries(_tokenId, _symmetries);
4190             reward = calculateReward(_symmetries);
4191             Clovers(clovers).setReward(_tokenId, reward);
4192         }
4193         if (_keep) {
4194             ClubToken(clubToken).increaseApproval(address(this), basePrice.add(reward));
4195         }
4196         uint256 stake = getStake(movesHash);
4197         emit cloverClaimed(moves, _tokenId, committer, stake, reward, _symmetries, _keep);
4198         return true;
4199     } */
4200 
4201 
4202     /**
4203     * @dev Retrieve the stake from a Clover claim after the stake period has ended, or with the authority of the oracle.
4204     * @param _tokenId The board which holds the stake.
4205     * @param _fastGasPrice The current fast gas price.
4206     * @param _averageGasPrice The current average gas price.
4207     * @param _safeLowGasPrice The current slow safe gas price
4208     * @return A boolean representing whether or not the retrieval was successful.
4209     */
4210     function retrieveStakeWithGas(uint256 _tokenId, uint256 _fastGasPrice, uint256 _averageGasPrice, uint256 _safeLowGasPrice) public payable returns (bool) {
4211         require(retrieveStake(_tokenId));
4212         if (msg.sender == owner || msg.sender == oracle) {
4213             updateGasPrices(_fastGasPrice, _averageGasPrice, _safeLowGasPrice);
4214         }
4215     }
4216 
4217     /**
4218     * @dev Retrieve the stake from a Clover claim after the stake period has ended, or with the authority of the oracle.
4219     * @param _tokenId The board which holds the stake.
4220     * @return A boolean representing whether or not the retrieval was successful.
4221     */
4222     function retrieveStake(uint256 _tokenId) public payable returns (bool) {
4223         bytes28[2] memory moves = Clovers(clovers).getCloverMoves(_tokenId);
4224         bytes32 movesHash = keccak256(moves);
4225 
4226 
4227         require(!commits[movesHash].collected);
4228         commits[movesHash].collected = true;
4229 
4230         require(isVerified(_tokenId) || msg.sender == owner || msg.sender == oracle);
4231 
4232         uint256 stake = getStake(movesHash);
4233         addSymmetries(_tokenId);
4234         address committer = getCommit(movesHash);
4235         require(committer == msg.sender || msg.sender == owner || msg.sender == oracle);
4236         uint256 reward = Clovers(clovers).getReward(_tokenId);
4237         bool _keep = Clovers(clovers).getKeep(_tokenId);
4238 
4239         if (_keep) {
4240             // If the user decided to keep the Clover, they will
4241             // receive the clover now that it has been verified
4242             Clovers(clovers).transferFrom(clovers, committer, _tokenId);
4243         } else {
4244             // If the user decided not to keep the Clover, they will
4245             // receive the reward price in club tokens, and the clover will
4246             // go for sale by the contract.
4247             ISimpleCloversMarket(simpleCloversMarket).sell(_tokenId, basePrice.add(reward.mul(priceMultiplier)));
4248             if (reward > 0) {
4249                 require(ClubToken(clubToken).mint(committer, reward));
4250             }
4251         }
4252         if (stake > 0) {
4253             Clovers(clovers).moveEth(msg.sender, stake);
4254         }
4255         emit stakeRetrieved(_tokenId, msg.sender, stake);
4256 
4257         return true;
4258     }
4259 
4260 
4261     /**
4262     * @dev Convert a bytes16 board into a uint256.
4263     * @param _board The board being converted.
4264     * @return number the uint256 being converted.
4265     */
4266     function convertBytes16ToUint(bytes16 _board) public view returns(uint256 number) {
4267         for(uint i=0;i<_board.length;i++){
4268             number = number + uint(_board[i])*(2**(8*(_board.length-(i+1))));
4269         }
4270     }
4271 
4272 
4273     /**
4274     * @dev Challenge a staked Clover for being invalid.
4275     * @param _tokenId The board being challenged.
4276     * @param _fastGasPrice The current fast gas price.
4277     * @param _averageGasPrice The current average gas price.
4278     * @param _safeLowGasPrice The current slow safe gas price
4279     * @return A boolean representing whether or not the challenge was successful.
4280     */
4281     function challengeCloverWithGas(uint256 _tokenId, uint256 _fastGasPrice, uint256 _averageGasPrice, uint256 _safeLowGasPrice) public returns (bool) {
4282         require(challengeClover(_tokenId));
4283         if (msg.sender == owner || msg.sender == oracle) {
4284             updateGasPrices(_fastGasPrice, _averageGasPrice, _safeLowGasPrice);
4285         }
4286         return true;
4287     }
4288     /**
4289     * @dev Challenge a staked Clover for being invalid.
4290     * @param _tokenId The board being challenged.
4291     * @return A boolean representing whether or not the challenge was successful.
4292     */
4293     function challengeClover(uint256 _tokenId) public returns (bool) {
4294         bool valid = true;
4295         bytes28[2] memory moves = Clovers(clovers).getCloverMoves(_tokenId);
4296 
4297         if (msg.sender != owner && msg.sender != oracle) {
4298             Reversi.Game memory game = Reversi.playGame(moves);
4299             if(convertBytes16ToUint(game.board) != _tokenId) {
4300                 valid = false;
4301             }
4302             if(valid && isValidGame(game.error, game.complete)) {
4303                 uint256 _symmetries = Clovers(clovers).getSymmetries(_tokenId);
4304                 valid = (_symmetries >> 4 & 1) > 0 == game.RotSym ? valid : false;
4305                 valid = (_symmetries >> 3 & 1) > 0 == game.Y0Sym ? valid : false;
4306                 valid = (_symmetries >> 2 & 1) > 0 == game.X0Sym ? valid : false;
4307                 valid = (_symmetries >> 1 & 1) > 0 == game.XYSym ? valid : false;
4308                 valid = (_symmetries & 1) > 0 == game.XnYSym ? valid : false;
4309             } else {
4310                 valid = false;
4311             }
4312             require(!valid);
4313         }
4314         bytes32 movesHash = keccak256(moves);
4315         uint256 stake = getStake(movesHash);
4316         if (!isVerified(_tokenId) && stake > 0) {
4317             Clovers(clovers).moveEth(msg.sender, stake);
4318         }
4319         if (commits[movesHash].collected) {
4320             removeSymmetries(_tokenId);
4321         }
4322 
4323         address committer = getCommit(movesHash);
4324         emit cloverChallenged(moves, _tokenId, committer, msg.sender, stake);
4325 
4326         Clovers(clovers).deleteClover(_tokenId);
4327         deleteCommit(movesHash);
4328         return true;
4329     }
4330 
4331     function fixSalePrice(uint256 _tokenId, uint256 _price) public onlyOwnerOrOracle {
4332         ISimpleCloversMarket(simpleCloversMarket).sell(_tokenId, _price);
4333     }
4334 
4335     /**
4336     * @dev Moves clovers without explicit allow permission for use by simpleCloversMarket
4337     * in order to avoid double transaction (allow, transferFrom)
4338     * @param _from The current owner of the Clover
4339     * @param _to The future owner of the Clover
4340     * @param _tokenId The Clover
4341     */
4342     function transferFrom(address _from, address _to, uint256 _tokenId) public {
4343         require(msg.sender == simpleCloversMarket || msg.sender == curationMarket);
4344         Clovers(clovers).transferFrom(_from, _to, _tokenId);
4345     }
4346 
4347     /**
4348     * @dev Updates pause boolean.
4349     * @param _paused The new puased boolean.
4350     */
4351     function updatePaused(bool _paused) public onlyOwner {
4352         paused = _paused;
4353     }
4354 
4355     /**
4356     * @dev Updates curationMarket Address.
4357     * @param _curationMarket The new curationMarket Address.
4358     */
4359     function updateCurationMarket(address _curationMarket) public onlyOwner {
4360         curationMarket = _curationMarket;
4361     }
4362     /**
4363     * @dev Updates oracle Address.
4364     * @param _oracle The new oracle Address.
4365     */
4366     function updateOracle(address _oracle) public onlyOwner {
4367         oracle = _oracle;
4368     }
4369 
4370     /**
4371     * @dev Updates simpleCloversMarket Address.
4372     * @param _simpleCloversMarket The new simpleCloversMarket address.
4373     */
4374     function updateSimpleCloversMarket(address _simpleCloversMarket) public onlyOwner {
4375         simpleCloversMarket = _simpleCloversMarket;
4376     }
4377 
4378     /**
4379     * @dev Updates clubTokenController Address.
4380     * @param _clubTokenController The new clubTokenController address.
4381     */
4382     function updateClubTokenController(address _clubTokenController) public onlyOwner {
4383         clubTokenController = _clubTokenController;
4384     }
4385     /**
4386     * @dev Updates the stake amount.
4387     * @param _stakeAmount The new amount needed to stake.
4388     */
4389     function updateStakeAmount(uint256 _stakeAmount) public onlyOwner {
4390         stakeAmount = _stakeAmount;
4391     }
4392     /**
4393     * @dev Updates the stake period.
4394     * @param _stakePeriod The uint256 value of time needed to stake before being verified.
4395     */
4396     function updateStakePeriod(uint256 _stakePeriod) public onlyOwner {
4397         stakePeriod = _stakePeriod;
4398     }
4399     /**
4400     * @dev Updates the pay multiplier, used to calculate token reward.
4401     * @param _payMultiplier The uint256 value of pay multiplier.
4402     */
4403     function updatePayMultipier(uint256 _payMultiplier) public onlyOwner {
4404         payMultiplier = _payMultiplier;
4405     }
4406     /**
4407     * @dev Updates the price multiplier, used to calculate the clover price (multiplied by the original reward).
4408     * @param _priceMultiplier The uint256 value of the price multiplier.
4409     */
4410     function updatePriceMultipier(uint256 _priceMultiplier) public onlyOwner {
4411         priceMultiplier = _priceMultiplier;
4412     }
4413     /**
4414     * @dev Updates the base price, used to calculate the clover cost.
4415     * @param _basePrice The uint256 value of the base price.
4416     */
4417     function updateBasePrice(uint256 _basePrice) public onlyOwner {
4418         basePrice = _basePrice;
4419     }
4420 
4421     /**
4422     * @dev Sets the stake of a Clover based on the hash of the moves.
4423     * @param movesHash The hash of the moves that make up the clover.
4424     * @param stake A uint256 value of stake.
4425     */
4426     function setStake(bytes32 movesHash, uint256 stake) private {
4427         commits[movesHash].stake = stake;
4428     }
4429 
4430     /**
4431     * @dev Sets the address of the committer of a Clover based on the hash of the moves.
4432     * @param movesHash The hash of the moves that make up the clover.
4433     * @param committer The address of the committer.
4434     */
4435     function setCommit(bytes32 movesHash, address committer) private {
4436         commits[movesHash].committer = committer;
4437     }
4438 
4439     function _setCommit(bytes32 movesHash, address committer) public onlyOwner {
4440         setCommit(movesHash, committer);
4441     }
4442     function deleteCommit(bytes32 movesHash) private {
4443         delete(commits[movesHash]);
4444     }
4445 
4446     /**
4447     * @dev Adds new tallys of the totals numbers of clover symmetries.
4448     * @param _tokenId The token which needs to be examined.
4449     */
4450     function addSymmetries(uint256 _tokenId) private {
4451         uint256 Symmetricals;
4452         uint256 RotSym;
4453         uint256 Y0Sym;
4454         uint256 X0Sym;
4455         uint256 XYSym;
4456         uint256 XnYSym;
4457         (Symmetricals,
4458         RotSym,
4459         Y0Sym,
4460         X0Sym,
4461         XYSym,
4462         XnYSym) = Clovers(clovers).getAllSymmetries();
4463         uint256 _symmetries = Clovers(clovers).getSymmetries(_tokenId);
4464         Symmetricals = Symmetricals.add(_symmetries > 0 ? 1 : 0);
4465         RotSym = RotSym.add(uint256(_symmetries >> 4 & 1));
4466         Y0Sym = Y0Sym.add(uint256(_symmetries >> 3 & 1));
4467         X0Sym = X0Sym.add(uint256(_symmetries >> 2 & 1));
4468         XYSym = XYSym.add(uint256(_symmetries >> 1 & 1));
4469         XnYSym = XnYSym.add(uint256(_symmetries & 1));
4470         Clovers(clovers).setAllSymmetries(Symmetricals, RotSym, Y0Sym, X0Sym, XYSym, XnYSym);
4471     }
4472     /**
4473     * @dev Remove false tallys of the totals numbers of clover symmetries.
4474     * @param _tokenId The token which needs to be examined.
4475     */
4476     function removeSymmetries(uint256 _tokenId) private {
4477         uint256 Symmetricals;
4478         uint256 RotSym;
4479         uint256 Y0Sym;
4480         uint256 X0Sym;
4481         uint256 XYSym;
4482         uint256 XnYSym;
4483         (Symmetricals,
4484         RotSym,
4485         Y0Sym,
4486         X0Sym,
4487         XYSym,
4488         XnYSym) = Clovers(clovers).getAllSymmetries();
4489         uint256 _symmetries = Clovers(clovers).getSymmetries(_tokenId);
4490         Symmetricals = Symmetricals.sub(_symmetries > 0 ? 1 : 0);
4491         RotSym = RotSym.sub(uint256(_symmetries >> 4 & 1));
4492         Y0Sym = Y0Sym.sub(uint256(_symmetries >> 3 & 1));
4493         X0Sym = X0Sym.sub(uint256(_symmetries >> 2 & 1));
4494         XYSym = XYSym.sub(uint256(_symmetries >> 1 & 1));
4495         XnYSym = XnYSym.sub(uint256(_symmetries & 1));
4496         Clovers(clovers).setAllSymmetries(Symmetricals, RotSym, Y0Sym, X0Sym, XYSym, XnYSym);
4497     }
4498 
4499 }