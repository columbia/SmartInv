1 pragma solidity ^0.4.19;
2 
3 // copyright contact@emontalliance.com
4 
5 contract BasicAccessControl {
6     address public owner;
7     // address[] public moderators;
8     uint16 public totalModerators = 0;
9     mapping (address => bool) public moderators;
10     bool public isMaintaining = false;
11 
12     function BasicAccessControl() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     modifier onlyModerators() {
22         require(msg.sender == owner || moderators[msg.sender] == true);
23         _;
24     }
25 
26     modifier isActive {
27         require(!isMaintaining);
28         _;
29     }
30 
31     function ChangeOwner(address _newOwner) onlyOwner public {
32         if (_newOwner != address(0)) {
33             owner = _newOwner;
34         }
35     }
36 
37 
38     function AddModerator(address _newModerator) onlyOwner public {
39         if (moderators[_newModerator] == false) {
40             moderators[_newModerator] = true;
41             totalModerators += 1;
42         }
43     }
44     
45     function RemoveModerator(address _oldModerator) onlyOwner public {
46         if (moderators[_oldModerator] == true) {
47             moderators[_oldModerator] = false;
48             totalModerators -= 1;
49         }
50     }
51 
52     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
53         isMaintaining = _isMaintaining;
54     }
55 }
56 
57 contract ERC20Interface {
58     function totalSupply() public constant returns (uint);
59     function balanceOf(address tokenOwner) public constant returns (uint balance);
60     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
61     function transfer(address to, uint tokens) public returns (bool success);
62     function approve(address spender, uint tokens) public returns (bool success);
63     function transferFrom(address from, address to, uint tokens) public returns (bool success);
64 }
65 
66 
67 contract EmontFrenzy is BasicAccessControl {
68     uint constant public HIGH = 20;
69     uint constant public BASE_POS = 510;
70     uint constant public ONE_EMONT = 10 ** 8;
71 
72     struct Fish {
73         address player;
74         uint weight;
75         bool active; // location != 0
76         uint blockNumber; // block number
77     }
78 
79     // private
80     uint private seed;
81 
82      // address
83     address public tokenContract;
84     
85     // variable
86     uint public addFee = 0.01 ether;
87     uint public addWeight = 5 * 10 ** 8; // emont
88     uint public addDrop = 5 * 10 ** 8; // emont
89     uint public moveCharge = 5; // percentage
90     uint public cashOutRate = 100; // to EMONT rate
91     uint public cashInRate = 50; // from EMONT to fish weight 
92     uint public width = 50;
93     uint public minJump = 2 * 2;
94     uint public maxPos = HIGH * width; // valid pos (0 -> maxPos - 1)
95     uint public minCashout = 25 * 10 ** 8;
96     uint public minEatable = 1 * 10 ** 8;
97     uint public minWeightDeduct = 4 * 10 ** 8; // 0.2 EMONT
98     
99     uint public basePunish = 40000; // per block
100     uint public oceanBonus = 125000; // per block
101     uint public minWeightPunish = 1 * 10 ** 8;
102     uint public maxWeightBonus = 25 * 10 ** 8;
103     
104     mapping(uint => Fish) fishMap;
105     mapping(uint => uint) ocean; // pos => fish id
106     mapping(uint => uint) bonus; // pos => emont amount
107     mapping(address => uint) players;
108     
109     mapping(uint => uint) maxJumps; // weight in EMONT => square length
110     
111     uint public totalFish = 0;
112     
113     // event
114     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
115 
116     event EventCashout(address indexed player, uint fishId, uint weight);
117     event EventBonus(uint pos, uint value);
118     event EventMove(address indexed player, uint fishId, uint fromPos, uint toPos, uint weight);
119     event EventEat(address indexed player, address indexed defender, uint playerFishId, uint defenderFishId, uint fromPos, uint toPos, uint playerWeight);
120     event EventFight(address indexed player, address indexed defender, uint playerFishId, uint defenderFishId, uint fromPos, uint toPos, uint playerWeight);
121     event EventSuicide(address indexed player, address indexed defender, uint playerFishId, uint defenderFishId, uint fromPos, uint toPos, uint defenderWeight);
122     
123     
124     // modifier
125     modifier requireTokenContract {
126         require(tokenContract != address(0));
127         _;
128     }
129     
130     function EmontFrenzy(address _tokenContract) public {
131         tokenContract = _tokenContract;
132         seed = getRandom(0);
133     }
134     
135     function setRate(uint _moveCharge, uint _cashOutRate, uint _cashInRate) onlyModerators external {
136         moveCharge = _moveCharge;
137         cashOutRate = _cashOutRate;
138         cashInRate = _cashInRate;
139     }
140     
141     function setMaxConfig(uint _minWeightPunish, uint _maxWeightBonus) onlyModerators external {
142         minWeightPunish = _minWeightPunish;
143         maxWeightBonus = _maxWeightBonus;
144     }
145     
146     function setConfig(uint _addFee, uint _addWeight, uint _addDrop,  uint _width) onlyModerators external {
147         addFee = _addFee;
148         addWeight = _addWeight;
149         addDrop = _addDrop;
150         width = _width;
151         maxPos = HIGH * width;
152     }
153     
154     function setExtraConfig(uint _minCashout, uint _minEatable, uint _minWeightDeduct, uint _basePunish, uint _oceanBonus) onlyModerators external {
155         minCashout = _minCashout;
156         minEatable = _minEatable;
157         minWeightDeduct = _minWeightDeduct;
158         basePunish = _basePunish;
159         oceanBonus = _oceanBonus;
160     }
161     
162     // weight in emont, x*x
163     function updateMaxJump(uint _weight, uint _squareLength) onlyModerators external {
164         maxJumps[_weight] = _squareLength;
165     }
166     
167     function setDefaultMaxJump() onlyModerators external {
168         maxJumps[0] = 50 * 50;
169         maxJumps[1] = 30 * 30;
170         maxJumps[2] = 20 * 20;
171         maxJumps[3] = 15 * 15;
172         maxJumps[4] = 12 * 12;
173         maxJumps[5] = 9 * 9;
174         maxJumps[6] = 7 * 7;
175         maxJumps[7] = 7 * 7;
176         maxJumps[8] = 6 * 6;
177         maxJumps[9] = 6 * 6;
178         maxJumps[10] = 6 * 6;
179         maxJumps[11] = 5 * 5;
180         maxJumps[12] = 5 * 5;
181         maxJumps[13] = 5 * 5;
182         maxJumps[14] = 5 * 5;
183         maxJumps[15] = 4 * 4;
184         maxJumps[16] = 4 * 4;
185         maxJumps[17] = 4 * 4;
186         maxJumps[18] = 4 * 4;
187         maxJumps[19] = 4 * 4;
188         maxJumps[20] = 3 * 3;
189         maxJumps[21] = 3 * 3;
190         maxJumps[22] = 3 * 3;
191         maxJumps[23] = 3 * 3;
192         maxJumps[24] = 3 * 3;
193         maxJumps[25] = 3 * 3;
194     }
195     
196     function updateMinJump(uint _minJump) onlyModerators external {
197         minJump = _minJump;
198     }
199     
200     // moderators
201     
202     function withdrawEther(address _sendTo, uint _amount) onlyModerators external {
203         // no user money is kept in this contract, only trasaction fee
204         if (_amount > address(this).balance) {
205             revert();
206         }
207         _sendTo.transfer(_amount);
208     }
209     
210     function withdrawToken(address _sendTo, uint _amount) onlyModerators requireTokenContract external {
211         ERC20Interface token = ERC20Interface(tokenContract);
212         if (_amount > token.balanceOf(address(this))) {
213             revert();
214         }
215         token.transfer(_sendTo, _amount);
216     }
217     
218     function addBonus(uint _pos, uint _amount) onlyModerators external {
219         bonus[_pos] += _amount;
220         EventBonus(_pos, _amount);
221     }
222     
223     function refundFish(address _player, uint _weight) onlyModerators external {
224          // max: one fish per address
225         if (fishMap[players[_player]].weight > 0)
226             revert();
227         
228         totalFish += 1;
229         Fish storage fish = fishMap[totalFish];
230         fish.player = _player;
231         fish.weight = _weight;
232         fish.active = false;
233         fish.blockNumber = block.number;
234         players[_player] = totalFish;
235         
236         seed = getRandom(seed);
237         Transfer(address(0), _player, totalFish);
238     }
239     
240     function cleanOcean(uint _pos1, uint _pos2, uint _pos3, uint _pos4, uint _pos5, uint _pos6, uint _pos7, uint _pos8, uint _pos9, uint _pos10) onlyModerators external {
241         if (_pos1 > 0) {
242             bonus[_pos1] = 0;
243             EventBonus(_pos1, 0);
244         }
245         if (_pos2 > 0) {
246             bonus[_pos2] = 0;
247             EventBonus(_pos2, 0);
248         }
249         if (_pos3 > 0) {
250             bonus[_pos3] = 0;
251             EventBonus(_pos3, 0);
252         }
253         if (_pos4 > 0) {
254             bonus[_pos4] = 0;
255             EventBonus(_pos4, 0);
256         }
257         if (_pos5 > 0) {
258             bonus[_pos5] = 0;
259             EventBonus(_pos5, 0);
260         }
261         if (_pos6 > 0) {
262             bonus[_pos6] = 0;
263             EventBonus(_pos6, 0);
264         }
265         if (_pos7 > 0) {
266             bonus[_pos7] = 0;
267             EventBonus(_pos7, 0);
268         }
269         if (_pos8 > 0) {
270             bonus[_pos8] = 0;
271             EventBonus(_pos8, 0);
272         }
273         if (_pos9 > 0) {
274             bonus[_pos9] = 0;
275             EventBonus(_pos9, 0);
276         }
277         if (_pos10 > 0) {
278             bonus[_pos10] = 0;
279             EventBonus(_pos10, 0);
280         }
281     }
282     
283     // for payment contract to call
284     function AddFishByToken(address _player, uint _tokens) onlyModerators external {
285         uint weight = _tokens * cashInRate / 100;
286         if (weight != addWeight) 
287             revert();
288         
289          // max: one fish per address
290         if (fishMap[players[_player]].weight > 0)
291             revert();
292         
293         totalFish += 1;
294         Fish storage fish = fishMap[totalFish];
295         fish.player = _player;
296         fish.weight = addWeight;
297         fish.active = false;
298         fish.blockNumber = block.number;
299         players[_player] = totalFish;
300         
301         // airdrop
302         if (addDrop > 0) {
303             seed = getRandom(seed);
304             uint temp = seed % (maxPos - 1);
305             if (temp == BASE_POS) temp += 1;
306             bonus[temp] += addDrop;
307             EventBonus(temp, bonus[temp]);
308         } else {
309             seed = getRandom(seed);
310         }
311         Transfer(address(0), _player, totalFish);
312     }
313     
314     // public functions
315     function getRandom(uint _seed) constant public returns(uint) {
316         return uint(keccak256(block.timestamp, block.difficulty)) ^ _seed;
317     }
318     
319     function AddFish() isActive payable external {
320         if (msg.value != addFee) revert();
321         
322         // max: one fish per address
323         if (fishMap[players[msg.sender]].weight > 0)
324             revert();
325         
326         totalFish += 1;
327         Fish storage fish = fishMap[totalFish];
328         fish.player = msg.sender;
329         fish.weight = addWeight;
330         fish.active = false;
331         fish.blockNumber = block.number;
332         players[msg.sender] = totalFish;
333         
334         // airdrop
335         if (addDrop > 0) {
336             seed = getRandom(seed);
337             uint temp = seed % (maxPos - 1);
338             if (temp == BASE_POS) temp += 1;
339             bonus[temp] += addDrop;
340             EventBonus(temp, bonus[temp]);
341         } else {
342             seed = getRandom(seed);
343         }
344         Transfer(address(0), msg.sender, totalFish);
345     }
346     
347     function DeductABS(uint _a, uint _b) pure public returns(uint) {
348         if (_a > _b) 
349             return (_a - _b);
350         return (_b - _a);
351     }
352     
353     function SafeDeduct(uint _a, uint _b) pure public returns(uint) {
354         if (_a > _b)
355             return (_a - _b);
356         return 0;
357     }
358     
359     function MoveFromBase(uint _toPos) isActive external {
360         // from = 0
361         if (_toPos >= maxPos || _toPos == 0)
362             revert();
363         
364         uint fishId = players[msg.sender];
365         Fish storage fish = fishMap[fishId];
366         if (fish.weight == 0)
367             revert();
368         // not from base
369         if (fish.active)
370             revert();
371         
372         // deduct weight
373         if (fish.weight > minWeightPunish) {
374             uint tempX = SafeDeduct(block.number, fish.blockNumber);
375             tempX = SafeDeduct(fish.weight, tempX * basePunish);
376             if (tempX < minWeightPunish) {
377                 fish.weight = minWeightPunish;
378             } else {
379                 fish.weight = tempX;
380             }
381         }
382         
383         // check valid move
384         tempX = DeductABS(BASE_POS / HIGH, _toPos / HIGH);
385         uint tempY = DeductABS(BASE_POS % HIGH, _toPos % HIGH);
386         uint squareLength = maxJumps[fish.weight / ONE_EMONT];
387         if (squareLength == 0) squareLength = minJump;
388         if (tempX * tempX + tempY * tempY > squareLength)
389             revert();
390         
391         // can not attack
392         if (ocean[_toPos] > 0)
393             revert();
394             
395         // check target bonus 
396         if (bonus[_toPos] > 0) {
397             fish.weight += bonus[_toPos];
398             bonus[_toPos] = 0;
399         }
400         
401         fish.active = true;
402         fish.blockNumber = block.number;
403         ocean[_toPos] = fishId;
404         EventMove(msg.sender, fishId, BASE_POS, _toPos, fish.weight);
405     }
406     
407     function MoveToBase(uint _fromPos) isActive external {
408         uint fishId = players[msg.sender];
409         Fish storage fish = fishMap[fishId];
410         if (fish.weight == 0)
411             revert();
412         if (!fish.active || ocean[_fromPos] != fishId)
413             revert();
414         
415         // check valid move
416         uint tempX = DeductABS(_fromPos / HIGH, BASE_POS / HIGH);
417         uint tempY = DeductABS(_fromPos % HIGH, BASE_POS % HIGH);
418         uint squareLength = maxJumps[fish.weight / ONE_EMONT];
419         if (squareLength == 0) squareLength = minJump;
420         if (tempX * tempX + tempY * tempY > squareLength)
421             revert();
422         
423         if (fish.weight >= minWeightDeduct) {
424             tempX = (moveCharge * fish.weight) / 100;
425             bonus[_fromPos] += tempX;
426             fish.weight -= tempX;
427         }
428         
429         // add bonus
430         if (fish.weight < maxWeightBonus) {
431             uint temp = SafeDeduct(block.number, fish.blockNumber) * oceanBonus;
432             if (fish.weight + temp > maxWeightBonus) {
433                 fish.weight = maxWeightBonus;
434             } else {
435                 fish.weight += temp;
436             }
437         }
438         
439         ocean[_fromPos] = 0;
440         fish.active = false;
441         fish.blockNumber = block.number;
442         EventMove(msg.sender, fishId, _fromPos, BASE_POS, fish.weight);
443         return;
444     }
445     
446     function MoveFish(uint _fromPos, uint _toPos) isActive external {
447         // check valid _x, _y
448         if (_toPos >= maxPos && _fromPos != _toPos)
449             revert();
450         if (_fromPos == BASE_POS || _toPos == BASE_POS)
451             revert();
452         
453         uint fishId = players[msg.sender];
454         Fish storage fish = fishMap[fishId];
455         if (fish.weight == 0)
456             revert();
457         if (!fish.active || ocean[_fromPos] != fishId)
458             revert();
459         
460         // check valid move
461         uint tempX = DeductABS(_fromPos / HIGH, _toPos / HIGH);
462         uint tempY = DeductABS(_fromPos % HIGH, _toPos % HIGH);
463         uint squareLength = maxJumps[fish.weight / ONE_EMONT];
464         if (squareLength == 0) squareLength = minJump;
465         
466         if (tempX * tempX + tempY * tempY > squareLength)
467             revert();
468         
469         // move 
470         ocean[_fromPos] = 0;
471         if (fish.weight >= minWeightDeduct) {
472             tempX = (moveCharge * fish.weight) / 100;
473             bonus[_fromPos] += tempX;
474             fish.weight -= tempX;
475         }
476 
477         tempX = ocean[_toPos]; // target fish id
478         // no fish at that location
479         if (tempX == 0) {
480             if (bonus[_toPos] > 0) {
481                 fish.weight += bonus[_toPos];
482                 bonus[_toPos] = 0;
483             }
484             
485             // update location
486             EventMove(msg.sender, fishId, _fromPos, _toPos, fish.weight);
487             ocean[_toPos] = fishId;
488         } else {
489             Fish storage targetFish = fishMap[tempX];
490             if (targetFish.weight + minEatable <= fish.weight) {
491                 // eat the target fish
492                 fish.weight += targetFish.weight;
493                 targetFish.weight = 0;
494                 
495                 // update location
496                 ocean[_toPos] = fishId;
497                 
498                 EventEat(msg.sender, targetFish.player, fishId, tempX, _fromPos, _toPos, fish.weight);
499                 Transfer(targetFish.player, address(0), tempX);
500             } else if (targetFish.weight <= fish.weight) {
501                 // fight and win
502                 // bonus to others
503                 seed = getRandom(seed);
504                 tempY = seed % (maxPos - 1);
505                 if (tempY == BASE_POS) tempY += 1;
506                 bonus[tempY] += targetFish.weight * 2;
507                 
508                 EventBonus(tempY, bonus[tempY]);
509                 
510                 // fight 
511                 fish.weight -= targetFish.weight;
512                 targetFish.weight = 0;
513                 
514                 // update location
515                 if (fish.weight > 0) {
516                     ocean[_toPos] = fishId;
517                 } else {
518                     ocean[_toPos] = 0;
519                     Transfer(msg.sender, address(0), fishId);
520                 }
521                 
522                 EventFight(msg.sender, targetFish.player, fishId, tempX, _fromPos, _toPos, fish.weight);
523                 Transfer(targetFish.player, address(0), tempX);
524             } else {
525                 // bonus to others
526                 seed = getRandom(seed);
527                 tempY = seed % (maxPos - 1);
528                 if (tempY == BASE_POS) tempY += 1;
529                 bonus[tempY] += fish.weight * 2;
530                 
531                 EventBonus(tempY, bonus[tempY]);
532                 
533                 // suicide
534                 targetFish.weight -= fish.weight;
535                 fish.weight = 0;
536                 
537                 EventSuicide(msg.sender, targetFish.player, fishId, tempX, _fromPos, _toPos, targetFish.weight);
538                 Transfer(msg.sender, address(0), fishId);
539             }
540         }
541     }
542     
543     function CashOut() isActive external {
544         uint fishId = players[msg.sender];
545         Fish storage fish = fishMap[fishId];
546         
547         // if fish at base, need to deduct 
548         if (!fish.active) {
549             // deduct weight
550             if (fish.weight > minWeightPunish) {
551                 uint tempX = SafeDeduct(block.number, fish.blockNumber);
552                 tempX = SafeDeduct(fish.weight, tempX * basePunish);
553                 if (tempX < minWeightPunish) {
554                     fish.weight = minWeightPunish;
555                 } else {
556                     fish.weight = tempX;
557                 }
558             }
559             fish.blockNumber = block.number;
560         }
561         
562         if (fish.weight < minCashout)
563             revert();
564         
565         if (fish.weight < addWeight) 
566             revert();
567         
568         uint _amount = fish.weight - addWeight;
569         fish.weight = addWeight;
570         
571         ERC20Interface token = ERC20Interface(tokenContract);
572         if (_amount > token.balanceOf(address(this))) {
573             revert();
574         }
575         token.transfer(msg.sender, (_amount * cashOutRate) / 100);
576         EventCashout(msg.sender, fishId, fish.weight);
577     }
578     
579     // public get 
580     function getFish(uint32 _fishId) constant public returns(address player, uint weight, bool active, uint blockNumber) {
581         Fish storage fish = fishMap[_fishId];
582         return (fish.player, fish.weight, fish.active, fish.blockNumber);
583     }
584     
585     function getFishByAddress(address _player) constant public returns(uint fishId, address player, uint weight, bool active, uint blockNumber) {
586         fishId = players[_player];
587         Fish storage fish = fishMap[fishId];
588         player = fish.player;
589         weight =fish.weight;
590         active = fish.active;
591         blockNumber = fish.blockNumber;
592     }
593     
594     function getFishIdByAddress(address _player) constant public returns(uint fishId) {
595         return players[_player];
596     }
597     
598     function getFishIdByPos(uint _pos) constant public returns(uint fishId) {
599         return ocean[_pos];
600     }
601     
602     function getFishByPos(uint _pos) constant public returns(uint fishId, address player, uint weight, uint blockNumber) {
603         fishId = ocean[_pos];
604         Fish storage fish = fishMap[fishId];
605         return (fishId, fish.player, fish.weight, fish.blockNumber);
606     }
607     
608     // cell has valid fish or bonus
609     function getActiveFish(uint _fromPos, uint _toPos) constant public returns(uint pos, uint fishId, address player, uint weight, uint blockNumber) {
610         for (uint index = _fromPos; index <= _toPos; index+=1) {
611             if (ocean[index] > 0) {
612                 fishId = ocean[index];
613                 Fish storage fish = fishMap[fishId];
614                 return (index, fishId, fish.player, fish.weight, fish.blockNumber);
615             }
616         }
617     }
618     
619     function getAllBonus(uint _fromPos, uint _toPos) constant public returns(uint pos, uint amount) {
620         for (uint index = _fromPos; index <= _toPos; index+=1) {
621             if (bonus[index] > 0) {
622                 return (index, bonus[index]);
623             }
624         }
625     }
626     
627     function getStats() constant public returns(uint countFish, uint countBonus) {
628         countFish = 0;
629         countBonus = 0;
630         for (uint index = 0; index < width * HIGH; index++) {
631             if (ocean[index] > 0) {
632                 countFish += 1; 
633             }
634             if (bonus[index] > 0) {
635                 countBonus += 1;
636             }
637         }
638     }
639     
640     function getFishAtBase(uint _fishId) constant public returns(uint fishId, address player, uint weight, uint blockNumber) {
641         for (uint id = _fishId; id <= totalFish; id++) {
642             Fish storage fish = fishMap[id];
643             if (fish.weight > 0 && !fish.active) {
644                 return (id, fish.player, fish.weight, fish.blockNumber);
645             }
646         }
647         
648         return (0, address(0), 0, 0);
649     }
650     
651     function countFishAtBase() constant public returns(uint count) {
652         count = 0;
653         for (uint id = 0; id <= totalFish; id++) {
654             Fish storage fish = fishMap[id];
655             if (fish.weight > 0 && !fish.active) {
656                 count += 1; 
657             }
658         }
659     }
660     
661     function getMaxJump(uint _weight) constant public returns(uint) {
662         return maxJumps[_weight];
663     }
664     
665     // some meta data
666     string public constant name = "EmontFrenzy";
667     string public constant symbol = "EMONF";
668 
669     function totalSupply() public view returns (uint256) {
670         return totalFish;
671     }
672     
673     function balanceOf(address _owner) public view returns (uint256 _balance) {
674         if (fishMap[players[_owner]].weight > 0)
675             return 1;
676         return 0;
677     }
678     
679     function ownerOf(uint256 _tokenId) public view returns (address _owner) {
680         Fish storage fish = fishMap[_tokenId];
681         if (fish.weight > 0)
682             return fish.player;
683         return address(0);
684     }
685     
686     function transfer(address _to, uint256 _tokenId) public{
687         require(_to != address(0));
688         
689         uint fishId = players[msg.sender];
690         Fish storage fish = fishMap[fishId];
691         if (fishId == 0 || fish.weight == 0 || fishId != _tokenId)
692             revert();
693         
694         if (balanceOf(_to) > 0)
695             revert();
696         
697         fish.player = _to;
698         players[msg.sender] = 0;
699         players[_to] = fishId;
700         
701         Transfer(msg.sender, _to, _tokenId);
702     }
703     
704 }