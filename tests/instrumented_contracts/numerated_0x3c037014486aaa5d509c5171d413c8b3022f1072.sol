1 // File: contracts/v5/Reversi.sol
2 
3 pragma solidity ^0.5.9;
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
34     function isValid (bytes28[2] memory moves) public pure returns (bool) {
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
45     function getGame (bytes28[2] memory moves) public pure returns (
46         bool error,
47         bool complete,
48         bool symmetrical,
49         bytes16 board,
50         uint8 currentPlayer,
51         uint8 moveKey
52     // , string memory msg
53     ) {
54         Game memory game = playGame(moves);
55         return (
56             game.error,
57             game.complete,
58             game.symmetrical,
59             game.board,
60             game.currentPlayer,
61             game.moveKey
62             // , game.msg
63         );
64     }
65 
66     function showColors () public pure returns(uint8, uint8, uint8) {
67         return (EMPTY, BLACK, WHITE);
68     }
69 
70     function emptyBoard() public pure returns (bytes16) {
71         // game.board = bytes16(10625432672847758622720); // completely empty board
72         return bytes16(uint128(340282366920938456379662753540715053055)); // empty board except for center pieces
73     }
74 
75     function playGame (bytes28[2] memory moves) internal pure returns (Game memory)  {
76         Game memory game;
77 
78         game.first32Moves = moves[0];
79         game.lastMoves = moves[1];
80         game.moveKey = 0;
81         game.blackScore = 2;
82         game.whiteScore = 2;
83 
84         game.error = false;
85         game.complete = false;
86         game.currentPlayer = BLACK;
87 
88         game.board = emptyBoard();
89 
90         bool skip;
91         uint8 move;
92         uint8 col;
93         uint8 row;
94         uint8 i;
95         bytes28 currentMoves;
96 
97         for (i = 0; i < 60 && !skip; i++) {
98             currentMoves = game.moveKey < 32 ? game.first32Moves : game.lastMoves;
99             move = readMove(currentMoves, game.moveKey % 32, 32);
100             (col, row) = convertMove(move);
101             skip = !validMove(move);
102             if (i == 0 && (col != 2 || row != 3)) {
103                 skip = true; // this is to force the first move to always be C4 to avoid repeatable boards via mirroring translations
104                 game.error = true;
105             }
106             if (!skip && col < 8 && row < 8 && col >= 0 && row >= 0) {
107                 // game.msg = "make a move";
108                 game = makeMove(game, col, row);
109                 game.moveKey = game.moveKey + 1;
110                 if (game.error) {
111                     if (!validMoveRemains(game)) {
112                         // player has no valid moves and must pass
113                         game.error = false;
114                         if (game.currentPlayer == BLACK) {
115                             game.currentPlayer = WHITE;
116                         } else {
117                             game.currentPlayer = BLACK;
118                         }
119                         game = makeMove(game, col, row);
120                         if (game.error) {
121                             game.error = true;
122                             skip = true;
123                         }
124                     }
125                 }
126             }
127         }
128         if (!game.error) {
129             game = isComplete(game);
130             game = isSymmetrical(game);
131         }
132         return game;
133     }
134 
135     function validMoveRemains (Game memory game) internal pure returns (bool) {
136         bool validMovesRemain = false;
137         bytes16 board = game.board;
138         uint8 i;
139         for (i = 0; i < 64 && !validMovesRemain; i++) {
140             uint8[2] memory move = [((i - (i % 8)) / 8), (i % 8)];
141             uint8 tile = returnTile(game.board, move[0], move[1]);
142             if (tile == EMPTY) {
143                 game.error = false;
144                 game.board = board;
145                 game = makeMove(game, move[0], move[1]);
146                 if (!game.error) {
147                     validMovesRemain = true;
148                 }
149             }
150         }
151         return validMovesRemain;
152     }
153 
154     function makeMove (Game memory game, uint8 col, uint8 row) internal pure returns (Game memory)  {
155         // square is already occupied
156         if (returnTile(game.board, col, row) != EMPTY){
157             game.error = true;
158             // game.msg = "Invalid Game (square is already occupied)";
159             return game;
160         }
161         int8[2][8] memory possibleDirections;
162         uint8  possibleDirectionsLength;
163         (possibleDirections, possibleDirectionsLength) = getPossibleDirections(game, col, row);
164         // no valid directions
165         if (possibleDirectionsLength == 0) {
166             game.error = true;
167             // game.msg = "Invalid Game (doesnt border other tiles)";
168             return game;
169         }
170 
171         bytes28 newFlips;
172         uint8 newFlipsLength;
173         uint8 newFlipCol;
174         uint8 newFlipRow;
175         uint8 j;
176         bool valid = false;
177         for (uint8 i = 0; i < possibleDirectionsLength; i++) {
178             delete newFlips;
179             delete newFlipsLength;
180             (newFlips, newFlipsLength) = traverseDirection(game, possibleDirections[i], col, row);
181             for (j = 0; j < newFlipsLength; j++) {
182                 if (!valid) valid = true;
183                 (newFlipCol, newFlipRow) = convertMove(readMove(newFlips, j, newFlipsLength));
184                 game.board = turnTile(game.board, game.currentPlayer, newFlipCol, newFlipRow);
185                 if (game.currentPlayer == WHITE) {
186                     game.whiteScore += 1;
187                     game.blackScore -= 1;
188                 } else {
189                     game.whiteScore -= 1;
190                     game.blackScore += 1;
191                 }
192             }
193         }
194 
195         //no valid flips in directions
196         if (valid) {
197             game.board = turnTile(game.board, game.currentPlayer, col, row);
198             if (game.currentPlayer == WHITE) {
199                 game.whiteScore += 1;
200             } else {
201                 game.blackScore += 1;
202             }
203         } else {
204             game.error = true;
205             // game.msg = "Invalid Game (doesnt flip any other tiles)";
206             return game;
207         }
208 
209         // switch players
210         if (game.currentPlayer == BLACK) {
211             game.currentPlayer = WHITE;
212         } else {
213             game.currentPlayer = BLACK;
214         }
215         return game;
216     }
217 
218     function getPossibleDirections (Game memory game, uint8 col, uint8 row) internal pure returns(int8[2][8] memory, uint8){
219 
220         int8[2][8] memory possibleDirections;
221         uint8 possibleDirectionsLength = 0;
222         int8[2][8] memory dirs = [
223             [int8(-1), int8(0)], // W
224             [int8(-1), int8(1)], // SW
225             [int8(0), int8(1)], // S
226             [int8(1), int8(1)], // SE
227             [int8(1), int8(0)], // E
228             [int8(1), int8(-1)], // NE
229             [int8(0), int8(-1)], // N
230             [int8(-1), int8(-1)] // NW
231         ];
232         int8 focusedRowPos;
233         int8 focusedColPos;
234         int8[2] memory dir;
235         uint8 testSquare;
236 
237         for (uint8 i = 0; i < 8; i++) {
238             dir = dirs[i];
239             focusedColPos = int8(col) + dir[0];
240             focusedRowPos = int8(row) + dir[1];
241 
242             // if tile is off the board it is not a valid move
243             if (!(focusedRowPos > 7 || focusedRowPos < 0 || focusedColPos > 7 || focusedColPos < 0)) {
244                 testSquare = returnTile(game.board, uint8(focusedColPos), uint8(focusedRowPos));
245 
246                 // if the surrounding tile is current color or no color it can"t be part of a capture
247                 if (testSquare != game.currentPlayer) {
248                     if (testSquare != EMPTY) {
249                         possibleDirections[possibleDirectionsLength] = dir;
250                         possibleDirectionsLength++;
251                     }
252                 }
253             }
254         }
255         return (possibleDirections, possibleDirectionsLength);
256     }
257 
258     function traverseDirection (Game memory game, int8[2] memory dir, uint8 col, uint8 row) internal pure returns(bytes28, uint8) {
259         bytes28 potentialFlips;
260         uint8 potentialFlipsLength = 0;
261         uint8 opponentColor;
262         if (game.currentPlayer == BLACK) {
263             opponentColor = WHITE;
264         } else {
265             opponentColor = BLACK;
266         }
267 
268         // take one step at a time in this direction
269         // ignoring the first step look for the same color as your tile
270         bool skip = false;
271         int8 testCol;
272         int8 testRow;
273         uint8 tile;
274         for (uint8 j = 1; j < 9; j++) {
275             if (!skip) {
276                 testCol = (int8(j) * dir[0]) + int8(col);
277                 testRow = (int8(j) * dir[1]) + int8(row);
278                 // ran off the board before hitting your own tile
279                 if (testCol > 7 || testCol < 0 || testRow > 7 || testRow < 0) {
280                     delete potentialFlips;
281                     potentialFlipsLength = 0;
282                     skip = true;
283                 } else{
284 
285                     tile = returnTile(game.board, uint8(testCol), uint8(testRow));
286 
287                     if (tile == opponentColor) {
288                         // if tile is opposite color it could be flipped, so add to potential flip array
289                         (potentialFlips, potentialFlipsLength) = addMove(potentialFlips, potentialFlipsLength, uint8(testCol), uint8(testRow));
290                     } else if (tile == game.currentPlayer && j > 1) {
291                         // hit current players tile which means capture is complete
292                         skip = true;
293                     } else {
294                         // either hit current players own color before hitting an opponent"s
295                         // or hit an empty space
296                         delete potentialFlips;
297                         delete potentialFlipsLength;
298                         skip = true;
299                     }
300                 }
301             }
302         }
303         return (potentialFlips, potentialFlipsLength);
304     }
305 
306     function isComplete (Game memory game) internal pure returns (Game memory) {
307         if (game.moveKey == 60) {
308             // game.msg = "good game";
309             game.complete = true;
310             return game;
311         } else {
312             uint8 i;
313             bool validMovesRemains = false;
314             bytes16 board = game.board;
315             for (i = 0; i < 64 && !validMovesRemains; i++) {
316                 uint8[2] memory move = [((i - (i % 8)) / 8), (i % 8)];
317                 uint8 tile = returnTile(game.board, move[0], move[1]);
318                 if (tile == EMPTY) {
319                     game.currentPlayer = BLACK;
320                     game.error = false;
321                     game.board = board;
322                     game = makeMove(game, move[0], move[1]);
323                     if (!game.error) {
324                         validMovesRemains = true;
325                     }
326                     game.currentPlayer = WHITE;
327                     game.error = false;
328                     game.board = board;
329                     game = makeMove(game, move[0], move[1]);
330                     if (!game.error) {
331                         validMovesRemains = true;
332                     }
333                 }
334             }
335             if (validMovesRemains) {
336                 game.error = true;
337                 // game.msg = "Invalid Game (moves still available)";
338             } else {
339                 // game.msg = "good game";
340                 game.complete = true;
341                 game.error = false;
342             }
343         }
344         return game;
345     }
346 
347     function isSymmetrical (Game memory game) internal pure returns (Game memory) {
348         bool RotSym = true;
349         bool Y0Sym = true;
350         bool X0Sym = true;
351         bool XYSym = true;
352         bool XnYSym = true;
353         for (uint8 i = 0; i < 8 && (RotSym || Y0Sym || X0Sym || XYSym || XnYSym); i++) {
354             for (uint8 j = 0; j < 8 && (RotSym || Y0Sym || X0Sym || XYSym || XnYSym); j++) {
355 
356                 // rotational symmetry
357                 if (returnBytes(game.board, i, j) != returnBytes(game.board, (7 - i), (7 - j))) {
358                     RotSym = false;
359                 }
360                 // symmetry on y = 0
361                 if (returnBytes(game.board, i, j) != returnBytes(game.board, i, (7 - j))) {
362                     Y0Sym = false;
363                 }
364                 // symmetry on x = 0
365                 if (returnBytes(game.board, i, j) != returnBytes(game.board, (7 - i), j)) {
366                     X0Sym = false;
367                 }
368                 // symmetry on x = y
369                 if (returnBytes(game.board, i, j) != returnBytes(game.board, (7 - j), (7 - i))) {
370                     XYSym = false;
371                 }
372                 // symmetry on x = -y
373                 if (returnBytes(game.board, i, j) != returnBytes(game.board, j, i)) {
374                     XnYSym = false;
375                 }
376             }
377         }
378         if (RotSym || Y0Sym || X0Sym || XYSym || XnYSym) {
379             game.symmetrical = true;
380             game.RotSym = RotSym;
381             game.Y0Sym = Y0Sym;
382             game.X0Sym = X0Sym;
383             game.XYSym = XYSym;
384             game.XnYSym = XnYSym;
385         }
386         return game;
387     }
388 
389 
390 
391     // Utilities
392 
393     function returnSymmetricals (bool RotSym, bool Y0Sym, bool X0Sym, bool XYSym, bool XnYSym) public pure returns (uint256) {
394         uint256 symmetries = 0;
395         if(RotSym) symmetries |= 16;
396         if(Y0Sym) symmetries |= 8;
397         if(X0Sym) symmetries |= 4;
398         if(XYSym) symmetries |= 2;
399         if(XnYSym) symmetries |= 1;
400         return symmetries;
401     }
402 
403 
404     function returnBytes (bytes16 board, uint8 col, uint8 row) internal pure returns (bytes16) {
405         uint128 push = posToPush(col, row);
406         return (board >> push) & bytes16(uint128(3));
407     }
408 
409     function turnTile (bytes16 board, uint8 color, uint8 col, uint8 row) internal pure returns (bytes16){
410         if (col > 7) revert("can't turn tile outside of board col");
411         if (row > 7) revert("can't turn tile outside of board row");
412         uint128 push = posToPush(col, row);
413         bytes16 mask = bytes16(uint128(3)) << push;// 0b00000011 (ones)
414 
415         board = ((board ^ mask) & board);
416 
417         return board | (bytes16(uint128(color)) << push);
418     }
419 
420     function returnTile (bytes16 board, uint8 col, uint8 row) public pure returns (uint8){
421         uint128 push = posToPush(col, row);
422         bytes16 tile = (board >> push ) & bytes16(uint128(3));
423         return uint8(uint128(tile)); // returns 2
424     }
425 
426     function posToPush (uint8 col, uint8 row) internal pure returns (uint128){
427         return uint128(((64) - ((8 * col) + row + 1)) * 2);
428     }
429 
430     function readMove (bytes28 moveSequence, uint8 moveKey, uint8 movesLength) public pure returns(uint8) {
431         bytes28 mask = bytes28(uint224(127));
432         uint8 push = (movesLength * 7) - (moveKey * 7) - 7;
433         return uint8(uint224((moveSequence >> push) & mask));
434     }
435 
436     function addMove (bytes28 moveSequence, uint8 movesLength, uint8 col, uint8 row) internal pure returns (bytes28, uint8) {
437         uint256 foo = col + (row * 8) + 64;
438         bytes28 move = bytes28(uint224(foo));
439         moveSequence = moveSequence << 7;
440         moveSequence = moveSequence | move;
441         movesLength++;
442         return (moveSequence, movesLength);
443     }
444 
445     function validMove (uint8 move) internal pure returns(bool) {
446         return move >= 64;
447     }
448 
449     function convertMove (uint8 move) public pure returns(uint8, uint8) {
450         move = move - 64;
451         uint8 col = move % 8;
452         uint8 row = (move - col) / 8;
453         return (col, row);
454     }
455 
456 }
457 
458 // File: contracts/v5/IClovers.sol
459 
460 pragma solidity ^0.5.9;
461 
462 contract IClovers {
463     function ownerOf(uint256 _tokenId) public view returns (address _owner);
464     function setCloverMoves(uint256 _tokenId, bytes28[2] memory moves) public;
465     function getCloverMoves(uint256 _tokenId) public view returns (bytes28[2] memory);
466     function getAllSymmetries() public view returns (uint256, uint256, uint256, uint256, uint256, uint256);
467     function exists(uint256 _tokenId) public view returns (bool _exists);
468     function getBlockMinted(uint256 _tokenId) public view returns (uint256);
469     function setBlockMinted(uint256 _tokenId, uint256 value) public;
470     function setKeep(uint256 _tokenId, bool value) public;
471     function setSymmetries(uint256 _tokenId, uint256 _symmetries) public;
472     function setReward(uint256 _tokenId, uint256 _amount) public;
473     function mint (address _to, uint256 _tokenId) public;
474     function getReward(uint256 _tokenId) public view returns (uint256);
475     function getKeep(uint256 _tokenId) public view returns (bool);
476     function transferFrom(address _from, address _to, uint256 _tokenId) public;
477     function moveEth(address _to, uint256 _amount) public;
478     function getSymmetries(uint256 _tokenId) public view returns (uint256);
479     function deleteClover(uint256 _tokenId) public;
480     function setAllSymmetries(uint256 _totalSymmetries, uint256 RotSym, uint256 Y0Sym, uint256 X0Sym, uint256 XYSym, uint256 XnYSym) public;
481 }
482 
483 // File: contracts/v5/IClubToken.sol
484 
485 pragma solidity ^0.5.9;
486 
487 contract IClubToken {
488     function balanceOf(address _owner) public view returns (uint256);
489     function burn(address _burner, uint256 _value) public;
490     function mint(address _to, uint256 _amount) public returns (bool);
491 }
492 
493 // File: contracts/v5/IClubTokenController.sol
494 
495 pragma solidity ^0.5.9;
496 
497 contract IClubTokenController {
498     function buy(address buyer) public payable returns(bool);
499 }
500 
501 // File: contracts/v5/ISimpleCloversMarket.sol
502 
503 pragma solidity ^0.5.9;
504 
505 contract ISimpleCloversMarket {
506     function sell(uint256 _tokenId, uint256 price) public;
507 }
508 
509 // File: @openzeppelin/contracts/math/SafeMath.sol
510 
511 pragma solidity ^0.5.0;
512 
513 /**
514  * @dev Wrappers over Solidity's arithmetic operations with added overflow
515  * checks.
516  *
517  * Arithmetic operations in Solidity wrap on overflow. This can easily result
518  * in bugs, because programmers usually assume that an overflow raises an
519  * error, which is the standard behavior in high level programming languages.
520  * `SafeMath` restores this intuition by reverting the transaction when an
521  * operation overflows.
522  *
523  * Using this library instead of the unchecked operations eliminates an entire
524  * class of bugs, so it's recommended to use it always.
525  */
526 library SafeMath {
527     /**
528      * @dev Returns the addition of two unsigned integers, reverting on
529      * overflow.
530      *
531      * Counterpart to Solidity's `+` operator.
532      *
533      * Requirements:
534      * - Addition cannot overflow.
535      */
536     function add(uint256 a, uint256 b) internal pure returns (uint256) {
537         uint256 c = a + b;
538         require(c >= a, "SafeMath: addition overflow");
539 
540         return c;
541     }
542 
543     /**
544      * @dev Returns the subtraction of two unsigned integers, reverting on
545      * overflow (when the result is negative).
546      *
547      * Counterpart to Solidity's `-` operator.
548      *
549      * Requirements:
550      * - Subtraction cannot overflow.
551      */
552     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
553         require(b <= a, "SafeMath: subtraction overflow");
554         uint256 c = a - b;
555 
556         return c;
557     }
558 
559     /**
560      * @dev Returns the multiplication of two unsigned integers, reverting on
561      * overflow.
562      *
563      * Counterpart to Solidity's `*` operator.
564      *
565      * Requirements:
566      * - Multiplication cannot overflow.
567      */
568     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
569         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
570         // benefit is lost if 'b' is also tested.
571         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
572         if (a == 0) {
573             return 0;
574         }
575 
576         uint256 c = a * b;
577         require(c / a == b, "SafeMath: multiplication overflow");
578 
579         return c;
580     }
581 
582     /**
583      * @dev Returns the integer division of two unsigned integers. Reverts on
584      * division by zero. The result is rounded towards zero.
585      *
586      * Counterpart to Solidity's `/` operator. Note: this function uses a
587      * `revert` opcode (which leaves remaining gas untouched) while Solidity
588      * uses an invalid opcode to revert (consuming all remaining gas).
589      *
590      * Requirements:
591      * - The divisor cannot be zero.
592      */
593     function div(uint256 a, uint256 b) internal pure returns (uint256) {
594         // Solidity only automatically asserts when dividing by 0
595         require(b > 0, "SafeMath: division by zero");
596         uint256 c = a / b;
597         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
598 
599         return c;
600     }
601 
602     /**
603      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
604      * Reverts when dividing by zero.
605      *
606      * Counterpart to Solidity's `%` operator. This function uses a `revert`
607      * opcode (which leaves remaining gas untouched) while Solidity uses an
608      * invalid opcode to revert (consuming all remaining gas).
609      *
610      * Requirements:
611      * - The divisor cannot be zero.
612      */
613     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
614         require(b != 0, "SafeMath: modulo by zero");
615         return a % b;
616     }
617 }
618 
619 // File: @openzeppelin/contracts/ownership/Ownable.sol
620 
621 pragma solidity ^0.5.0;
622 
623 /**
624  * @dev Contract module which provides a basic access control mechanism, where
625  * there is an account (an owner) that can be granted exclusive access to
626  * specific functions.
627  *
628  * This module is used through inheritance. It will make available the modifier
629  * `onlyOwner`, which can be aplied to your functions to restrict their use to
630  * the owner.
631  */
632 contract Ownable {
633     address private _owner;
634 
635     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
636 
637     /**
638      * @dev Initializes the contract setting the deployer as the initial owner.
639      */
640     constructor () internal {
641         _owner = msg.sender;
642         emit OwnershipTransferred(address(0), _owner);
643     }
644 
645     /**
646      * @dev Returns the address of the current owner.
647      */
648     function owner() public view returns (address) {
649         return _owner;
650     }
651 
652     /**
653      * @dev Throws if called by any account other than the owner.
654      */
655     modifier onlyOwner() {
656         require(isOwner(), "Ownable: caller is not the owner");
657         _;
658     }
659 
660     /**
661      * @dev Returns true if the caller is the current owner.
662      */
663     function isOwner() public view returns (bool) {
664         return msg.sender == _owner;
665     }
666 
667     /**
668      * @dev Leaves the contract without owner. It will not be possible to call
669      * `onlyOwner` functions anymore. Can only be called by the current owner.
670      *
671      * > Note: Renouncing ownership will leave the contract without an owner,
672      * thereby removing any functionality that is only available to the owner.
673      */
674     function renounceOwnership() public onlyOwner {
675         emit OwnershipTransferred(_owner, address(0));
676         _owner = address(0);
677     }
678 
679     /**
680      * @dev Transfers ownership of the contract to a new account (`newOwner`).
681      * Can only be called by the current owner.
682      */
683     function transferOwnership(address newOwner) public onlyOwner {
684         _transferOwnership(newOwner);
685     }
686 
687     /**
688      * @dev Transfers ownership of the contract to a new account (`newOwner`).
689      */
690     function _transferOwnership(address newOwner) internal {
691         require(newOwner != address(0), "Ownable: new owner is the zero address");
692         emit OwnershipTransferred(_owner, newOwner);
693         _owner = newOwner;
694     }
695 }
696 
697 // File: @openzeppelin/contracts/cryptography/ECDSA.sol
698 
699 pragma solidity ^0.5.0;
700 
701 /**
702  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
703  *
704  * These functions can be used to verify that a message was signed by the holder
705  * of the private keys of a given address.
706  */
707 library ECDSA {
708     /**
709      * @dev Returns the address that signed a hashed message (`hash`) with
710      * `signature`. This address can then be used for verification purposes.
711      *
712      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
713      * this function rejects them by requiring the `s` value to be in the lower
714      * half order, and the `v` value to be either 27 or 28.
715      *
716      * (.note) This call _does not revert_ if the signature is invalid, or
717      * if the signer is otherwise unable to be retrieved. In those scenarios,
718      * the zero address is returned.
719      *
720      * (.warning) `hash` _must_ be the result of a hash operation for the
721      * verification to be secure: it is possible to craft signatures that
722      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
723      * this is by receiving a hash of the original message (which may otherwise)
724      * be too long), and then calling `toEthSignedMessageHash` on it.
725      */
726     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
727         // Check the signature length
728         if (signature.length != 65) {
729             return (address(0));
730         }
731 
732         // Divide the signature in r, s and v variables
733         bytes32 r;
734         bytes32 s;
735         uint8 v;
736 
737         // ecrecover takes the signature parameters, and the only way to get them
738         // currently is to use assembly.
739         // solhint-disable-next-line no-inline-assembly
740         assembly {
741             r := mload(add(signature, 0x20))
742             s := mload(add(signature, 0x40))
743             v := byte(0, mload(add(signature, 0x60)))
744         }
745 
746         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
747         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
748         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
749         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
750         //
751         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
752         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
753         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
754         // these malleable signatures as well.
755         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
756             return address(0);
757         }
758 
759         if (v != 27 && v != 28) {
760             return address(0);
761         }
762 
763         // If the signature is valid (and not malleable), return the signer address
764         return ecrecover(hash, v, r, s);
765     }
766 
767     /**
768      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
769      * replicates the behavior of the
770      * [`eth_sign`](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign)
771      * JSON-RPC method.
772      *
773      * See `recover`.
774      */
775     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
776         // 32 is the length in bytes of hash,
777         // enforced by the type signature above
778         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
779     }
780 }
781 
782 // File: contracts/v5/CloversController.sol
783 
784 pragma solidity ^0.5.9;
785 
786 /**
787  * The CloversController is a replaceable endpoint for minting and unminting Clovers.sol and ClubToken.sol
788  */
789 
790 
791 
792 
793 
794 
795 
796 
797 
798 contract CloversController is Ownable {
799     event cloverCommitted(bytes32 movesHash, address owner);
800     event cloverClaimed(uint256 tokenId, bytes28[2] moves, address sender, address recepient, uint reward, uint256 symmetries, bool keep);
801     event cloverChallenged(uint256 tokenId, bytes28[2] moves, address owner, address challenger);
802 
803     using SafeMath for uint256;
804     using ECDSA for bytes32;
805 
806     bool public paused;
807     address public oracle;
808     IClovers public clovers;
809     IClubToken public clubToken;
810     IClubTokenController public clubTokenController;
811     ISimpleCloversMarket public simpleCloversMarket;
812     // Reversi public reversi;
813 
814     uint256 public gasLastUpdated_fastGasPrice_averageGasPrice_safeLowGasPrice;
815     uint256 public gasBlockMargin = 240; // ~1 hour at 15 second blocks
816 
817     uint256 public basePrice;
818     uint256 public priceMultiplier;
819     uint256 public payMultiplier;
820 
821     mapping(bytes32=>address) public commits;
822 
823     modifier notPaused() {
824         require(!paused, "Must not be paused");
825         _;
826     }
827 
828     constructor(
829         IClovers _clovers,
830         IClubToken _clubToken,
831         IClubTokenController _clubTokenController
832         // Reversi _reversi
833     ) public {
834         clovers = _clovers;
835         clubToken = _clubToken;
836         clubTokenController = _clubTokenController;
837         // reversi = _reversi;
838         paused = true;
839     }
840 
841     function getMovesHash(bytes28[2] memory moves) public pure returns (bytes32) {
842         return keccak256(abi.encodePacked(moves));
843     }
844 
845     function getMovesHashWithRecepient(bytes32 movesHash, address recepient) public pure returns (bytes32) {
846         return keccak256(abi.encodePacked(movesHash, recepient));
847     }
848 
849     /**
850     * @dev Checks whether the game is valid.
851     * @param moves The moves needed to play validate the game.
852     * @return A boolean representing whether or not the game is valid.
853     */
854     function isValid(bytes28[2] memory moves) public pure returns (bool) {
855         Reversi.Game memory game = Reversi.playGame(moves);
856         return isValidGame(game.error, game.complete);
857     }
858 
859     /**
860     * @dev Checks whether the game is valid.
861     * @param error The pre-played game error
862     * @param complete The pre-played game complete boolean
863     * @return A boolean representing whether or not the game is valid.
864     */
865     function isValidGame(bool error, bool complete) public pure returns (bool) {
866         if (error || !complete) {
867             return false;
868         } else {
869             return true;
870         }
871     }
872 
873     function getGame (bytes28[2] memory moves) public pure returns (bool error, bool complete, bool symmetrical, bytes16 board, uint8 currentPlayer, uint8 moveKey) {
874         // return Reversi.getGame(moves);
875         Reversi.Game memory game = Reversi.playGame(moves);
876         return (
877             game.error,
878             game.complete,
879             game.symmetrical,
880             game.board,
881             game.currentPlayer,
882             game.moveKey
883             // game.msg
884         );
885     }
886     /**
887     * @dev Calculates the reward of the board.
888     * @param symmetries symmetries saved as a uint256 value like 00010101 where bits represent symmetry types.
889     * @return A uint256 representing the reward that would be returned for claiming the board.
890     */
891     function calculateReward(uint256 symmetries) public view returns (uint256) {
892         uint256 Symmetricals;
893         uint256 RotSym;
894         uint256 Y0Sym;
895         uint256 X0Sym;
896         uint256 XYSym;
897         uint256 XnYSym;
898         (Symmetricals,
899         RotSym,
900         Y0Sym,
901         X0Sym,
902         XYSym,
903         XnYSym) = clovers.getAllSymmetries();
904         uint256 base = 0;
905         if (symmetries >> 4 & 1 == 1) base = base.add(payMultiplier.mul(Symmetricals + 1).div(RotSym + 1));
906         if (symmetries >> 3 & 1 == 1) base = base.add(payMultiplier.mul(Symmetricals + 1).div(Y0Sym + 1));
907         if (symmetries >> 2 & 1 == 1) base = base.add(payMultiplier.mul(Symmetricals + 1).div(X0Sym + 1));
908         if (symmetries >> 1 & 1 == 1) base = base.add(payMultiplier.mul(Symmetricals + 1).div(XYSym + 1));
909         if (symmetries & 1 == 1) base = base.add(payMultiplier.mul(Symmetricals + 1).div(XnYSym + 1));
910         return base;
911     }
912 
913     function getPrice(uint256 symmetries) public view returns(uint256) {
914         return basePrice.add(calculateReward(symmetries));
915     }
916 
917     // In order to prevent commit reveal griefing the first commit is a combined hash of the moves and the recepient.
918     // In order to use the same commit mapping, we mark this hash simply as address(1) so it is no longer the equivalent of address(0)
919     function claimCloverSecurelyPartOne(bytes32 movesHashWithRecepient) public {
920         commits[movesHashWithRecepient] = address(1);
921         commits[keccak256(abi.encodePacked(msg.sender))] = address(block.number);
922     }
923 
924     // Once a commit has been made to guarantee the move hash is associated with the recepient we can make a commit on the hash of the moves themselves
925     // If we were to make a claim on the moves in plaintext, the transaction could be front run on the claimCloverWithVerification or the claimCloverWithSignature
926     function claimCloverSecurelyPartTwo(bytes32 movesHash) public {
927         require(uint256(commits[keccak256(abi.encodePacked(msg.sender))]) < block.number, "Can't combine step1 with step2");
928         bytes32 commitHash = getMovesHashWithRecepient(movesHash, msg.sender);
929         address commitOfMovesHashWithRecepient = commits[commitHash];
930         require(
931             address(commitOfMovesHashWithRecepient) == address(1),
932             "Invalid commitOfMovesHashWithRecepient, please do claimCloverSecurelyPartOne"
933         );
934         delete(commits[commitHash]);
935         commits[movesHash] = msg.sender;
936     }
937 
938     function claimCloverWithVerification(bytes28[2] memory moves, bool keep) public payable returns (bool) {
939         bytes32 movesHash = getMovesHash(moves);
940         address committedRecepient = commits[movesHash];
941         require(committedRecepient == address(0) || committedRecepient == msg.sender, "Invalid committedRecepient");
942 
943         Reversi.Game memory game = Reversi.playGame(moves);
944         require(isValidGame(game.error, game.complete), "Invalid game");
945         uint256 tokenId = convertBytes16ToUint(game.board);
946         require(!clovers.exists(tokenId), "Clover already exists");
947 
948         uint256 symmetries = Reversi.returnSymmetricals(game.RotSym, game.Y0Sym, game.X0Sym, game.XYSym, game.XnYSym);
949         require(_claimClover(tokenId, moves, symmetries, msg.sender, keep), "Claim must succeed");
950         delete(commits[movesHash]);
951         return true;
952     }
953 
954 
955 
956     /**
957     * @dev Claim the Clover without a commit or reveal. Payable so you can buy tokens if needed.
958     * @param tokenId The board that results from the moves.
959     * @param moves The moves that make up the Clover reversi game.
960     * @param symmetries symmetries saved as a uint256 value like 00010101 where bits represent symmetry
961     * @param keep symmetries saved as a uint256 value like 00010101 where bits represent symmetry
962     * @param signature symmetries saved as a uint256 value like 00010101 where bits represent symmetry
963     * types.
964     * @return A boolean representing whether or not the claim was successful.
965     */
966     function claimCloverWithSignature(uint256 tokenId, bytes28[2] memory moves, uint256 symmetries, bool keep, bytes memory signature) public payable notPaused returns (bool) {
967         address committedRecepient = commits[getMovesHash(moves)];
968         require(committedRecepient == address(0) || committedRecepient == msg.sender, "Invalid committedRecepient");
969         require(!clovers.exists(tokenId), "Clover already exists");
970         require(checkSignature(tokenId, moves, symmetries, keep, msg.sender, signature, oracle), "Invalid Signature");
971         require(_claimClover(tokenId, moves, symmetries, msg.sender, keep), "Claim must succeed");
972         return true;
973     }
974 
975     function _claimClover(uint256 tokenId, bytes28[2] memory moves, uint256 symmetries, address recepient, bool keep) internal returns (bool) {
976         clovers.setCloverMoves(tokenId, moves);
977         clovers.setKeep(tokenId, keep);
978         uint256 reward;
979         if (symmetries > 0) {
980             clovers.setSymmetries(tokenId, symmetries);
981             reward = calculateReward(symmetries);
982             clovers.setReward(tokenId, reward);
983             addSymmetries(symmetries);
984         }
985         uint256 price = basePrice.add(reward);
986         if (keep && price > 0) {
987             // If the user decides to keep the Clover, they must
988             // pay for it in club tokens according to the reward price.
989             if (clubToken.balanceOf(msg.sender) < price) {
990                 clubTokenController.buy.value(msg.value)(msg.sender);
991             }
992             clubToken.burn(msg.sender, price);
993         }
994 
995         if (keep) {
996             // If the user decided to keep the Clover
997             clovers.mint(recepient, tokenId);
998         } else {
999             // If the user decided not to keep the Clover, they will
1000             // receive the reward price in club tokens, and the clover will
1001             // go for sale by the contract.
1002             clovers.mint(address(clovers), tokenId);
1003             simpleCloversMarket.sell(tokenId, basePrice.add(reward.mul(priceMultiplier)));
1004             if (reward > 0) {
1005                 require(clubToken.mint(recepient, reward), "mint must succeed");
1006             }
1007         }
1008         emit cloverClaimed(tokenId, moves, msg.sender, recepient, reward, symmetries, keep);
1009         return true;
1010     }
1011 
1012 
1013     /**
1014     * @dev Convert a bytes16 board into a uint256.
1015     * @param _board The board being converted.
1016     * @return number the uint256 being converted.
1017     */
1018     function convertBytes16ToUint(bytes16 _board) public pure returns(uint256 number) {
1019         for(uint i=0;i<_board.length;i++){
1020             number = number + uint(uint8(_board[i]))*(2**(8*(_board.length-(i+1))));
1021         }
1022     }
1023 
1024 
1025     /**
1026     * @dev Challenge a Clover for being invalid.
1027     * @param tokenId The board being challenged.
1028     * @return A boolean representing whether or not the challenge was successful.
1029     */
1030     function challengeClover(uint256 tokenId) public returns (bool) {
1031         require(clovers.exists(tokenId), "Clover must exist to be challenged");
1032         bool valid = true;
1033         bytes28[2] memory moves = clovers.getCloverMoves(tokenId);
1034         address payable _owner = address(uint160(owner()));
1035         if (msg.sender != _owner && msg.sender != oracle) {
1036             Reversi.Game memory game = Reversi.playGame(moves);
1037             if(convertBytes16ToUint(game.board) != tokenId) {
1038                 valid = false;
1039             }
1040             if(valid && isValidGame(game.error, game.complete)) {
1041                 uint256 symmetries = clovers.getSymmetries(tokenId);
1042                 valid = (symmetries >> 4 & 1) > 0 == game.RotSym ? valid : false;
1043                 valid = (symmetries >> 3 & 1) > 0 == game.Y0Sym ? valid : false;
1044                 valid = (symmetries >> 2 & 1) > 0 == game.X0Sym ? valid : false;
1045                 valid = (symmetries >> 1 & 1) > 0 == game.XYSym ? valid : false;
1046                 valid = (symmetries & 1) > 0 == game.XnYSym ? valid : false;
1047             } else {
1048                 valid = false;
1049             }
1050             require(!valid, "Must be invalid to challenge");
1051         }
1052 
1053         removeSymmetries(tokenId);
1054         address committer = clovers.ownerOf(tokenId);
1055         emit cloverChallenged(tokenId, moves, committer, msg.sender);
1056         clovers.deleteClover(tokenId);
1057         return true;
1058     }
1059 
1060     function updateSalePrice(uint256 tokenId, uint256 _price) public onlyOwner {
1061         simpleCloversMarket.sell(tokenId, _price);
1062     }
1063 
1064     /**
1065     * @dev Moves clovers without explicit allow permission for use by simpleCloversMarket
1066     * in order to avoid double transaction (allow, transferFrom)
1067     * @param _from The current owner of the Clover
1068     * @param _to The future owner of the Clover
1069     * @param tokenId The Clover
1070     */
1071     function transferFrom(address _from, address _to, uint256 tokenId) public {
1072         require(msg.sender == address(simpleCloversMarket), "transferFrom can only be done by simpleCloversMarket");
1073         clovers.transferFrom(_from, _to, tokenId);
1074     }
1075 
1076     /**
1077     * @dev Updates pause boolean.
1078     * @param _paused The new puased boolean.
1079     */
1080     function updatePaused(bool _paused) public onlyOwner {
1081         paused = _paused;
1082     }
1083 
1084     /**
1085     * @dev Updates oracle Address.
1086     * @param _oracle The new oracle Address.
1087     */
1088     function updateOracle(address _oracle) public onlyOwner {
1089         oracle = _oracle;
1090     }
1091 
1092     /**
1093     * @dev Updates simpleCloversMarket Address.
1094     * @param _simpleCloversMarket The new simpleCloversMarket address.
1095     */
1096     function updateSimpleCloversMarket(ISimpleCloversMarket _simpleCloversMarket) public onlyOwner {
1097         simpleCloversMarket = _simpleCloversMarket;
1098     }
1099 
1100     /**
1101     * @dev Updates clubTokenController Address.
1102     * @param _clubTokenController The new clubTokenController address.
1103     */
1104     function updateClubTokenController(IClubTokenController _clubTokenController) public onlyOwner {
1105         clubTokenController = _clubTokenController;
1106     }
1107     /**
1108     * @dev Updates the pay multiplier, used to calculate token reward.
1109     * @param _payMultiplier The uint256 value of pay multiplier.
1110     */
1111     function updatePayMultipier(uint256 _payMultiplier) public onlyOwner {
1112         payMultiplier = _payMultiplier;
1113     }
1114     /**
1115     * @dev Updates the price multiplier, used to calculate the clover price (multiplied by the original reward).
1116     * @param _priceMultiplier The uint256 value of the price multiplier.
1117     */
1118     function updatePriceMultipier(uint256 _priceMultiplier) public onlyOwner {
1119         priceMultiplier = _priceMultiplier;
1120     }
1121     /**
1122     * @dev Updates the base price, used to calculate the clover cost.
1123     * @param _basePrice The uint256 value of the base price.
1124     */
1125     function updateBasePrice(uint256 _basePrice) public onlyOwner {
1126         basePrice = _basePrice;
1127     }
1128 
1129     /**
1130     * @dev Adds new tallys of the totals numbers of clover symmetries.
1131     * @param symmetries The symmetries which needs to be added.
1132     */
1133     function addSymmetries(uint256 symmetries) private {
1134         uint256 Symmetricals;
1135         uint256 RotSym;
1136         uint256 Y0Sym;
1137         uint256 X0Sym;
1138         uint256 XYSym;
1139         uint256 XnYSym;
1140         (Symmetricals,
1141         RotSym,
1142         Y0Sym,
1143         X0Sym,
1144         XYSym,
1145         XnYSym) = clovers.getAllSymmetries();
1146         Symmetricals = Symmetricals.add(symmetries > 0 ? 1 : 0);
1147         RotSym = RotSym.add(uint256(symmetries >> 4 & 1));
1148         Y0Sym = Y0Sym.add(uint256(symmetries >> 3 & 1));
1149         X0Sym = X0Sym.add(uint256(symmetries >> 2 & 1));
1150         XYSym = XYSym.add(uint256(symmetries >> 1 & 1));
1151         XnYSym = XnYSym.add(uint256(symmetries & 1));
1152         clovers.setAllSymmetries(Symmetricals, RotSym, Y0Sym, X0Sym, XYSym, XnYSym);
1153     }
1154     /**
1155     * @dev Remove false tallys of the totals numbers of clover symmetries.
1156     * @param tokenId The token which needs to be examined.
1157     */
1158     function removeSymmetries(uint256 tokenId) private {
1159         uint256 Symmetricals;
1160         uint256 RotSym;
1161         uint256 Y0Sym;
1162         uint256 X0Sym;
1163         uint256 XYSym;
1164         uint256 XnYSym;
1165         (Symmetricals,
1166         RotSym,
1167         Y0Sym,
1168         X0Sym,
1169         XYSym,
1170         XnYSym) = clovers.getAllSymmetries();
1171         uint256 symmetries = clovers.getSymmetries(tokenId);
1172         Symmetricals = Symmetricals.sub(symmetries > 0 ? 1 : 0);
1173         RotSym = RotSym.sub(uint256(symmetries >> 4 & 1));
1174         Y0Sym = Y0Sym.sub(uint256(symmetries >> 3 & 1));
1175         X0Sym = X0Sym.sub(uint256(symmetries >> 2 & 1));
1176         XYSym = XYSym.sub(uint256(symmetries >> 1 & 1));
1177         XnYSym = XnYSym.sub(uint256(symmetries & 1));
1178         clovers.setAllSymmetries(Symmetricals, RotSym, Y0Sym, X0Sym, XYSym, XnYSym);
1179     }
1180 
1181     function checkSignature(
1182         uint256 tokenId,
1183         bytes28[2] memory moves,
1184         uint256 symmetries,
1185         bool keep,
1186         address recepient,
1187         bytes memory signature,
1188         address signer
1189     ) public pure returns (bool) {
1190         bytes32 hash = toEthSignedMessageHash(getHash(tokenId, moves, symmetries, keep, recepient));
1191         address result = recover(hash, signature);
1192         return (result != address(0) && result == signer);
1193     }
1194 
1195     function getHash(uint256 tokenId, bytes28[2] memory moves, uint256 symmetries, bool keep, address recepient) public pure returns (bytes32) {
1196         return keccak256(abi.encodePacked(tokenId, moves, symmetries, keep, recepient));
1197     }
1198     function recover(bytes32 hash, bytes memory signature) public pure returns (address) {
1199         return hash.recover(signature);
1200     }
1201     function toEthSignedMessageHash(bytes32 hash) public pure returns (bytes32) {
1202         return hash.toEthSignedMessageHash();
1203     }
1204 }