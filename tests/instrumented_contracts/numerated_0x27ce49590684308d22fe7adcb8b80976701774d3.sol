1 /*
2  _______  _______  ______    _______  _______  _______  ______   _______  _______  ______    _______  
3 |   _   ||  _    ||    _ |  |   _   ||       ||   _   ||      | |   _   ||  _    ||    _ |  |   _   | 
4 |  |_|  || |_|   ||   | ||  |  |_|  ||       ||  |_|  ||  _    ||  |_|  || |_|   ||   | ||  |  |_|  | 
5 |       ||       ||   |_||_ |       ||       ||       || | |   ||       ||       ||   |_||_ |       | 
6 |       ||  _   | |    __  ||       ||      _||       || |_|   ||       ||  _   | |    __  ||       | 
7 |   _   || |_|   ||   |  | ||   _   ||     |_ |   _   ||       ||   _   || |_|   ||   |  | ||   _   | 
8 |__| |__||_______||___|  |_||__| |__||_______||__| |__||______| |__| |__||_______||___|  |_||__| |__| 
9                                                                                                      
10                                        
11                                  _       
12                                 | |      
13   _ __  _ __ ___  ___  ___ _ __ | |_ ___ 
14  | '_ \| '__/ _ \/ __|/ _ \ '_ \| __/ __|
15  | |_) | | |  __/\__ \  __/ | | | |_\__ \
16  | .__/|_|  \___||___/\___|_| |_|\__|___/
17  | |                                     
18  |_|                                     
19                                                                                                       
20                                                                                                       
21  _______  __   __  _______        _______  _______  __   __        _______  _______  __   __  _______ 
22 |       ||  | |  ||       |      |       ||       ||  | |  |      |       ||   _   ||  |_|  ||       |
23 |_     _||  |_|  ||    ___|      |    ___||_     _||  |_|  |      |    ___||  |_|  ||       ||    ___|
24   |   |  |       ||   |___       |   |___   |   |  |       |      |   | __ |       ||       ||   |___ 
25   |   |  |       ||    ___|      |    ___|  |   |  |       |      |   ||  ||       ||       ||    ___|
26   |   |  |   _   ||   |___       |   |___   |   |  |   _   |      |   |_| ||   _   || ||_|| ||   |___ 
27   |___|  |__| |__||_______|      |_______|  |___|  |__| |__|      |_______||__| |__||_|   |_||_______|
28 
29 Copyright 2018 - theethgame.com
30 */
31 
32 pragma solidity ^0.4.13;
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 library SafeMath {
38 
39   /**
40   * @dev Multiplies two numbers, throws on overflow.
41   */
42   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
44     // benefit is lost if 'b' is also tested.
45     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
46     if (_a == 0) {
47       return 0;
48     }
49 
50     c = _a * _b;
51     assert(c / _a == _b);
52     return c;
53   }
54 
55   /**
56   * @dev Integer division of two numbers, truncating the quotient.
57   */
58   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
59     // assert(_b > 0); // Solidity automatically throws when dividing by 0
60     // uint256 c = _a / _b;
61     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
62     return _a / _b;
63   }
64 
65   /**
66   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
67   */
68   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
69     assert(_b <= _a);
70     return _a - _b;
71   }
72 
73   /**
74   * @dev Adds two numbers, throws on overflow.
75   */
76   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
77     c = _a + _b;
78     assert(c >= _a);
79     return c;
80   }
81 }
82 contract TheEthGame {
83     using SafeMath for uint256;
84     
85     struct Player {
86         uint256 score;
87         uint256 lastCellBoughtOnBlockNumber;
88         uint256 numberOfCellsOwned;
89         uint256 numberOfCellsBought;
90         uint256 earnings;
91 
92         uint256 partialHarmonicSum;
93         uint256 partialScoreSum;
94         
95         address referreal;
96 
97         bytes32 name;
98     }
99     
100     struct Cell {
101         address owner;
102         uint256 price;
103     }
104     
105     address public owner;
106     
107     uint256 constant private NUMBER_OF_LINES = 6;
108     uint256 constant private NUMBER_OF_COLUMNS = 6;
109     uint256 constant private NUMBER_OF_CELLS = NUMBER_OF_COLUMNS * NUMBER_OF_LINES;
110     uint256 constant private DEFAULT_POINTS_PER_CELL = 3;
111     uint256 constant private POINTS_PER_NEIGHBOUR = 1;
112 
113     uint256 constant private CELL_STARTING_PRICE = 0.002 ether;
114     uint256 constant private BLOCKS_TO_CONFIRM_TO_WIN_THE_GAME = 10000;
115     uint256 constant private PRICE_INCREASE_PERCENTAGE = uint(2);
116     uint256 constant private REFERREAL_PERCENTAGE = uint(10);
117     uint256 constant private POT_PERCENTAGE = uint(30);
118     uint256 constant private DEVELOPER_PERCENTAGE = uint(5);
119     uint256 constant private SCORE_PERCENTAGE = uint(25);
120     uint256 constant private NUMBER_OF_CELLS_PERCENTAGE = uint(30);
121     
122     Cell[NUMBER_OF_CELLS] cells;
123     
124     address[] private ranking;
125     mapping(address => Player) players;
126     mapping(bytes32 => address) nameToAddress;
127     
128     uint256 public numberOfCellsBought;
129     uint256 private totalScore;
130     
131     uint256 private developersCut = 0 ether;
132     uint256 private potCut = 0 ether;
133     uint256 private harmonicSum;
134     uint256 private totalScoreSum;
135     
136     address private rankOnePlayerAddress;
137     uint256 private isFirstSinceBlock;
138     
139     address public trophyAddress;
140     
141     event Bought (address indexed _from, address indexed _to);
142 
143     constructor () public {
144         owner = msg.sender;
145         trophyAddress = new TheEthGameTrophy();
146     }
147     
148     /* Modifiers */
149     modifier onlyOwner() {
150         require(owner == msg.sender);
151         _;
152     }
153     
154     /* Buying */
155     function nextPriceOf (uint256 _cellId) public view returns (uint256 _nextPrice) {
156         return priceOf(_cellId).mul(100 + PRICE_INCREASE_PERCENTAGE) / 100;
157     }
158     
159     function priceOf (uint256 _cellId) public view returns (uint256 _price) {
160         if (cells[_cellId].price == 0) {
161             return CELL_STARTING_PRICE;
162         }
163         
164         return cells[_cellId].price;
165     }
166     
167     function earningsFromNumberOfCells (address _address) internal view returns (uint256 _earnings) {
168         return harmonicSum.sub(players[_address].partialHarmonicSum).mul(players[_address].numberOfCellsBought);
169     }
170     
171     function distributeEarningsBasedOnNumberOfCells (address _address) internal {
172         players[_address].earnings = players[_address].earnings.add(earningsFromNumberOfCells(_address));
173         players[_address].partialHarmonicSum = harmonicSum;
174     }
175     
176     function earningsFromScore (address _address) internal view returns (uint256 _earnings) {
177         return totalScoreSum.sub(players[_address].partialScoreSum).mul(scoreOf(_address));
178     }
179     
180     function distributeEarningsBasedOnScore (address _newOwner, address _oldOwner) internal {
181         players[_newOwner].earnings = players[_newOwner].earnings.add(earningsFromScore(_newOwner));
182         players[_newOwner].partialScoreSum = totalScoreSum;
183         
184         if (_oldOwner != address(0)) {
185             players[_oldOwner].earnings = players[_oldOwner].earnings.add(earningsFromScore(_oldOwner));
186             players[_oldOwner].partialScoreSum = totalScoreSum;
187         }
188     }
189     
190     function earningsOfPlayer () public view returns (uint256 _wei) {
191         return players[msg.sender].earnings.add(earningsFromScore(msg.sender)).add(earningsFromNumberOfCells(msg.sender));
192     }
193     
194     function getRankOnePlayer (address _oldOwner) internal view returns (address _address, uint256 _oldOwnerIndex) {
195         address rankOnePlayer;
196         uint256 oldOwnerIndex;
197         
198         for (uint256 i = 0; i < ranking.length; i++) {
199             if (scoreOf(ranking[i]) > scoreOf(rankOnePlayer)) {
200                     rankOnePlayer = ranking[i];
201             } else if (scoreOf(ranking[i]) == scoreOf(rankOnePlayer) && players[ranking[i]].lastCellBoughtOnBlockNumber > players[rankOnePlayer].lastCellBoughtOnBlockNumber) {
202                     rankOnePlayer = ranking[i];
203             }
204             
205             if (ranking[i] == _oldOwner) {
206                 oldOwnerIndex = i;
207             }
208         }
209         
210         
211         return (rankOnePlayer, oldOwnerIndex);
212     }
213 
214     function buy (uint256 _cellId, address _referreal) payable public {
215         require(msg.value >= priceOf(_cellId));
216         require(!isContract(msg.sender));
217         require(_cellId < NUMBER_OF_CELLS);
218         require(msg.sender != address(0));
219         require(!isGameFinished()); //If game is finished nobody can buy cells.
220         require(ownerOf(_cellId) != msg.sender);
221         require(msg.sender != _referreal);
222         
223         address oldOwner = ownerOf(_cellId);
224         address newOwner = msg.sender;
225         uint256 price = priceOf(_cellId);
226         uint256 excess = msg.value.sub(price);
227 
228         bool isReferrealDistributed = distributeToReferreal(price, _referreal);
229         
230         //If numberOfCellsBought > 0 imply totalScore > 0
231         if (numberOfCellsBought > 0) {
232             harmonicSum = harmonicSum.add(price.mul(NUMBER_OF_CELLS_PERCENTAGE) / (numberOfCellsBought * 100));
233             if (isReferrealDistributed) {
234                 totalScoreSum = totalScoreSum.add(price.mul(SCORE_PERCENTAGE) / (totalScore * 100));
235             } else {
236                 totalScoreSum = totalScoreSum.add(price.mul(SCORE_PERCENTAGE.add(REFERREAL_PERCENTAGE)) / (totalScore * 100));
237             }
238         }else{
239             //First cell bought price goes to the pot.
240             potCut = potCut.add(price.mul(NUMBER_OF_CELLS_PERCENTAGE.add(SCORE_PERCENTAGE)) / 100);
241         }
242         
243         numberOfCellsBought++;
244         
245         distributeEarningsBasedOnNumberOfCells(newOwner);
246         
247         players[newOwner].numberOfCellsBought++;
248         players[newOwner].numberOfCellsOwned++;
249         
250         if (ownerOf(_cellId) != address(0)) {
251              players[oldOwner].numberOfCellsOwned--;
252         }
253         
254         players[newOwner].lastCellBoughtOnBlockNumber = block.number;
255          
256         address oldRankOnePlayer = rankOnePlayerAddress;
257         
258         (uint256 newOwnerScore, uint256 oldOwnerScore) = calculateScoresIfCellIsBought(newOwner, oldOwner, _cellId);
259         
260         distributeEarningsBasedOnScore(newOwner, oldOwner);
261         
262         totalScore = totalScore.sub(scoreOf(newOwner).add(scoreOf(oldOwner)));
263                 
264         players[newOwner].score = newOwnerScore;
265         players[oldOwner].score = oldOwnerScore;
266         
267         totalScore = totalScore.add(scoreOf(newOwner).add(scoreOf(oldOwner)));
268 
269         cells[_cellId].price = nextPriceOf(_cellId);
270         
271         //It had 0 cells before
272         if (players[newOwner].numberOfCellsOwned == 1) {
273            ranking.push(newOwner);
274         }
275         
276         if (oldOwner == rankOnePlayerAddress || (players[oldOwner].numberOfCellsOwned == 0 && oldOwner != address(0))) {
277             (address rankOnePlayer, uint256 oldOwnerIndex) = getRankOnePlayer(oldOwner); 
278             if (players[oldOwner].numberOfCellsOwned == 0 && oldOwner != address(0)) {
279                 delete ranking[oldOwnerIndex];
280             }
281             rankOnePlayerAddress = rankOnePlayer;
282         }else{ //Otherwise check if the new owner score is greater or equal than the rank one player score.
283             if (scoreOf(newOwner) >= scoreOf(rankOnePlayerAddress)) {
284                 rankOnePlayerAddress = newOwner;
285             }
286         }
287         
288         if (rankOnePlayerAddress != oldRankOnePlayer) {
289             isFirstSinceBlock = block.number;
290         }
291         
292 
293         developersCut = developersCut.add(price.mul(DEVELOPER_PERCENTAGE) / 100);
294         potCut = potCut.add(price.mul(POT_PERCENTAGE) / 100);
295 
296         _transfer(oldOwner, newOwner, _cellId);
297         
298         emit Bought(oldOwner, newOwner);
299         
300         if (excess > 0) {
301           newOwner.transfer(excess);
302         }
303     }
304     
305     function distributeToReferreal (uint256 _price, address _referreal) internal returns (bool _isDstributed) {
306         if (_referreal != address(0) && _referreal != msg.sender) {
307             players[msg.sender].referreal = _referreal;
308         }
309         
310         //Distribute to referreal
311         if (players[msg.sender].referreal != address(0)) {
312             address ref = players[msg.sender].referreal;
313             players[ref].earnings = players[ref].earnings.add(_price.mul(REFERREAL_PERCENTAGE) / 100);
314             return true;
315         }
316         
317         return false;
318     }
319     
320     /* Game */
321     function getPlayers () external view returns(uint256[] _scores, uint256[] _lastCellBoughtOnBlock, address[] _addresses, bytes32[] _names) {
322         uint256[] memory scores = new uint256[](ranking.length);
323         address[] memory addresses = new address[](ranking.length);
324         uint256[] memory lastCellBoughtOnBlock = new uint256[](ranking.length);
325         bytes32[] memory names = new bytes32[](ranking.length);
326         
327         for (uint256 i = 0; i < ranking.length; i++) {
328             Player memory p = players[ranking[i]];
329             
330             scores[i] = p.score;
331             addresses[i] = ranking[i];
332             lastCellBoughtOnBlock[i] = p.lastCellBoughtOnBlockNumber;
333             names[i] = p.name;
334         }
335         
336         return (scores, lastCellBoughtOnBlock, addresses, names);
337     }
338     
339     function getCells () external view returns (uint256[] _prices, uint256[] _nextPrice, address[] _owner, bytes32[] _names) {
340         uint256[] memory prices = new uint256[](NUMBER_OF_CELLS);
341         address[] memory owners = new address[](NUMBER_OF_CELLS);
342         bytes32[] memory names = new bytes32[](NUMBER_OF_CELLS);
343         uint256[] memory nextPrices = new uint256[](NUMBER_OF_CELLS);
344         
345         for (uint256 i = 0; i < NUMBER_OF_CELLS; i++) {
346              prices[i] = priceOf(i);
347              owners[i] = ownerOf(i);
348              names[i] = players[ownerOf(i)].name;
349              nextPrices[i] = nextPriceOf(i);
350         }
351         
352         return (prices, nextPrices, owners, names);
353     }
354     
355     function getPlayer () external view returns (bytes32 _name, uint256 _score, uint256 _earnings, uint256 _numberOfCellsBought) {
356         return (players[msg.sender].name, players[msg.sender].score, earningsOfPlayer(), players[msg.sender].numberOfCellsBought);
357     }
358     
359     function getCurrentPotSize () public view returns (uint256 _wei) {
360         return potCut;
361     }
362     
363     function getCurrentWinner () public view returns (address _address) {
364         return rankOnePlayerAddress;
365     }
366     
367     function getNumberOfBlocksRemainingToWin () public view returns (int256 _numberOfBlocks) {
368         return int256(BLOCKS_TO_CONFIRM_TO_WIN_THE_GAME) - int256(block.number.sub(isFirstSinceBlock));
369     }
370     
371     function scoreOf (address _address) public view returns (uint256 _score) {
372         return players[_address].score;
373     }
374     
375     function ownerOf (uint256 _cellId) public view returns (address _owner) {
376         return cells[_cellId].owner;
377     }
378     
379     function isGameFinished() public view returns (bool _isGameFinished) {
380         return rankOnePlayerAddress != address(0) && getNumberOfBlocksRemainingToWin() < 0;
381     }
382     
383     function calculateScoresIfCellIsBought (address _newOwner, address _oldOwner, uint256 _cellId) internal view returns (uint256 _newOwnerScore, uint256 _oldOwnerScore) {
384         //Minus 2 points at the old owner.
385         uint256 oldOwnerScoreAdjustment = DEFAULT_POINTS_PER_CELL;
386         
387         //Plus 2 points at the new owner.
388         uint256 newOwnerScoreAdjustment = DEFAULT_POINTS_PER_CELL;
389         
390         //Calulcate the number of neightbours of _cellId for the old 
391         //and the new owner, then double the number and multiply it by POINTS_PER_NEIGHBOUR.
392         oldOwnerScoreAdjustment = oldOwnerScoreAdjustment.add(calculateNumberOfNeighbours(_cellId, _oldOwner).mul(POINTS_PER_NEIGHBOUR).mul(2));
393         newOwnerScoreAdjustment = newOwnerScoreAdjustment.add(calculateNumberOfNeighbours(_cellId, _newOwner).mul(POINTS_PER_NEIGHBOUR).mul(2));
394         
395         if (_oldOwner == address(0)) {
396             oldOwnerScoreAdjustment = 0;
397         }
398         
399         return (scoreOf(_newOwner).add(newOwnerScoreAdjustment), scoreOf(_oldOwner).sub(oldOwnerScoreAdjustment));
400     }
401     
402     //Diagonal is not considered.
403     function calculateNumberOfNeighbours(uint256 _cellId, address _address) internal view returns (uint256 _numberOfNeighbours) {
404         uint256 numberOfNeighbours;
405         
406         (uint256 top, uint256 bottom, uint256 left, uint256 right) = getNeighbourhoodOf(_cellId);
407         
408         if (top != NUMBER_OF_CELLS && ownerOf(top) == _address) {
409             numberOfNeighbours = numberOfNeighbours.add(1);
410         }
411         
412         if (bottom != NUMBER_OF_CELLS && ownerOf(bottom) == _address) {
413             numberOfNeighbours = numberOfNeighbours.add(1);
414         }
415         
416         if (left != NUMBER_OF_CELLS && ownerOf(left) == _address) {
417             numberOfNeighbours = numberOfNeighbours.add(1);
418         }
419         
420         if (right != NUMBER_OF_CELLS && ownerOf(right) == _address) {
421             numberOfNeighbours = numberOfNeighbours.add(1);
422         }
423         
424         return numberOfNeighbours;
425     }
426 
427     function getNeighbourhoodOf(uint256 _cellId) internal pure returns (uint256 _top, uint256 _bottom, uint256 _left, uint256 _right) {
428         //IMPORTANT: The number 'NUMBER_OF_CELLS' is used  to indicate that a cell does not exists.
429         
430         //Set top cell as non existent.
431         uint256 topCellId = NUMBER_OF_CELLS;
432         
433         //If cell id is not on the first line set the correct _cellId as topCellId.
434         if(_cellId >= NUMBER_OF_LINES){
435            topCellId = _cellId.sub(NUMBER_OF_LINES);
436         }
437         
438         //Get the cell under _cellId by adding the number of cells per line.
439         uint256 bottomCellId = _cellId.add(NUMBER_OF_LINES);
440         
441         //If it's greater or equal than NUMBER_OF_CELLS bottom cell does not exists.
442         if (bottomCellId >= NUMBER_OF_CELLS) {
443             bottomCellId = NUMBER_OF_CELLS;
444         }
445         
446         //Set left cell as non existent.
447         uint256 leftCellId = NUMBER_OF_CELLS;
448         
449         //If the remainder of _cellId / NUMBER_OF_LINES is not 0 then _cellId is on
450         //not the first column and thus has a left neighbour.
451         if ((_cellId % NUMBER_OF_LINES) != 0) {
452             leftCellId = _cellId.sub(1);
453         }
454         
455         //Get the cell on the right by adding 1.
456         uint256 rightCellId = _cellId.add(1);
457 
458         //If the remainder of rightCellId / NUMBER_OF_LINES is 0 then _cellId is on
459         //the last column and thus has no right neighbour.
460         if ((rightCellId % NUMBER_OF_LINES) == 0) {
461             rightCellId = NUMBER_OF_CELLS;
462         }
463         
464         return (topCellId, bottomCellId, leftCellId, rightCellId);
465     }
466 
467     function _transfer(address _from, address _to, uint256 _cellId) internal {
468         require(_cellId < NUMBER_OF_CELLS);
469         require(ownerOf(_cellId) == _from);
470         require(_to != address(0));
471         require(_to != address(this));
472         cells[_cellId].owner = _to;
473     }
474     
475     /*Withdraws*/
476     function withdrawPot(string _message) public {
477         require(!isContract(msg.sender));
478         require(msg.sender != owner);
479         //A player can withdraw the pot if he is the rank one player
480         //and the game is finished.
481         require(rankOnePlayerAddress == msg.sender);
482         require(isGameFinished());
483         
484         uint256 toWithdraw = potCut;
485         potCut = 0;
486         msg.sender.transfer(toWithdraw);
487         
488         TheEthGameTrophy trophy = TheEthGameTrophy(trophyAddress);
489         trophy.award(msg.sender, _message);
490     }
491     
492     function withdrawDevelopersCut () onlyOwner() public {
493         uint256 toWithdraw = developersCut;
494         developersCut = 0;
495         owner.transfer(toWithdraw);
496     }
497   
498     function withdrawEarnings () public {
499         distributeEarningsBasedOnScore(msg.sender, address(0));
500         distributeEarningsBasedOnNumberOfCells(msg.sender);
501         
502         uint256 toWithdraw = earningsOfPlayer();
503         players[msg.sender].earnings = 0;
504         
505         msg.sender.transfer(toWithdraw);
506     }
507     
508     /* Player Name */
509     function setName(bytes32 _name) public {
510         if (nameToAddress[_name] != address(0)) {
511             return;
512         }
513         
514         players[msg.sender].name = _name;
515         nameToAddress[_name] = msg.sender;
516     }
517     
518     function nameOf(address _address) external view returns(bytes32 _name) {
519         return players[_address].name;
520     }
521     
522     function addressOf(bytes32 _name) external view returns (address _address) {
523         return nameToAddress[_name];
524     }
525     
526     /* Util */
527     function isContract(address addr) internal view returns (bool) {
528         uint size;
529         assembly { size := extcodesize(addr) } // solium-disable-line
530         return size > 0;
531     }
532 }
533 
534 contract TheEthGameTrophy {
535     string public name; 
536     string public description;
537     string public message;
538     
539     address public creator;
540     address public owner;
541     address public winner;
542     uint public rank;
543     
544     bool private isAwarded = false;
545     
546     event Award(uint256 indexed _blockNumber, uint256 indexed _timestamp, address indexed _owner);
547     event Transfer (address indexed _from, address indexed _to);
548 
549     constructor () public {
550         name = "The Eth Game Winner";
551         description = "2019-08-17";
552         rank = 1;
553         creator = msg.sender;
554     }
555     
556     function name() constant public returns (string _name) {
557         return name;
558     }
559     
560     function description() constant public returns (string _description) {
561         return description;
562     }
563     
564     function message() constant public returns (string _message) {
565         return message;
566     }
567     
568     function creator() constant public returns (address _creator) {
569         return creator;
570     }
571     
572     function owner() constant public returns (address _owner) {
573         return owner;
574     }
575     
576     function winner() constant public returns (address _winner) {
577         return winner;
578     }
579     
580     function rank() constant public returns (uint _rank) {
581         return rank;
582     }
583   
584     function award(address _address, string _message) public {
585         require(msg.sender == creator && !isAwarded);
586         isAwarded = true;
587         owner = _address;
588         winner = _address;
589         message = _message;
590         
591         emit Award(block.number, block.timestamp, _address);
592     }
593     
594     function transfer(address _to) private returns (bool success) {
595         require(msg.sender == owner);
596         owner = _to;
597         emit Transfer(msg.sender, _to);
598         return true;
599     }
600 }