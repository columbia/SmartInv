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
76     }
77 
78     // private
79     uint private seed;
80 
81      // address
82     address public tokenContract;
83     
84     // variable
85     uint public addFee = 0.01 ether;
86     uint public addWeight = 5 * 10 ** 8; // emont
87     uint public moveCharge = 5; // percentage
88     uint public cashOutRate = 100; // to EMONT rate
89     uint public cashInRate = 50; // from EMONT to fish weight 
90     uint public width = 50;
91     uint public minJump = 2 * 2;
92     uint public maxPos = HIGH * width; // valid pos (0 -> maxPos - 1)
93     uint public minCashout = 20 * 10 ** 8;
94     uint public minEatable = 1 * 10 ** 8;
95     
96     mapping(uint => Fish) fishMap;
97     mapping(uint => uint) ocean; // pos => fish id
98     mapping(uint => uint) bonus; // pos => emont amount
99     mapping(address => uint) players;
100     
101     mapping(uint => uint) maxJumps; // weight in EMONT => square length
102     
103     uint public totalFish = 0;
104     
105     // event
106     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
107 
108     event EventCashout(address indexed player, uint fishId, uint weight);
109     event EventBonus(uint pos, uint value);
110     event EventMove(address indexed player, uint fishId, uint fromPos, uint toPos, uint weight);
111     event EventEat(address indexed player, address indexed defender, uint playerFishId, uint defenderFishId, uint fromPos, uint toPos, uint playerWeight);
112     event EventFight(address indexed player, address indexed defender, uint playerFishId, uint defenderFishId, uint fromPos, uint toPos, uint playerWeight);
113     event EventSuicide(address indexed player, address indexed defender, uint playerFishId, uint defenderFishId, uint fromPos, uint toPos, uint defenderWeight);
114     
115     
116     // modifier
117     modifier requireTokenContract {
118         require(tokenContract != address(0));
119         _;
120     }
121     
122     function EmontFrenzy(address _tokenContract) public {
123         tokenContract = _tokenContract;
124         seed = getRandom(0);
125     }
126     
127     function setConfig(uint _addFee, uint _addWeight, uint _moveCharge, uint _cashOutRate, uint _cashInRate, uint _width) onlyModerators external {
128         addFee = _addFee;
129         addWeight = _addWeight;
130         moveCharge = _moveCharge;
131         cashOutRate = _cashOutRate;
132         cashInRate = _cashInRate;
133         width = _width;
134         maxPos = HIGH * width;
135     }
136     
137     function setExtraConfig(uint _minCashout, uint _minEatable) onlyModerators external {
138         minCashout = _minCashout;
139         minEatable = _minEatable;
140     }
141     
142     // weight in emont, x*x
143     function updateMaxJump(uint _weight, uint _squareLength) onlyModerators external {
144         maxJumps[_weight] = _squareLength;
145     }
146     
147     function setDefaultMaxJump() onlyModerators external {
148         maxJumps[0] = 50 * 50;
149         maxJumps[1] = 30 * 30;
150         maxJumps[2] = 20 * 20;
151         maxJumps[3] = 15 * 15;
152         maxJumps[4] = 12 * 12;
153         maxJumps[5] = 9 * 9;
154         maxJumps[6] = 7 * 7;
155         maxJumps[7] = 7 * 7;
156         maxJumps[8] = 6 * 6;
157         maxJumps[9] = 6 * 6;
158         maxJumps[10] = 6 * 6;
159         maxJumps[11] = 5 * 5;
160         maxJumps[12] = 5 * 5;
161         maxJumps[13] = 5 * 5;
162         maxJumps[14] = 5 * 5;
163         maxJumps[15] = 4 * 4;
164         maxJumps[16] = 4 * 4;
165         maxJumps[17] = 4 * 4;
166         maxJumps[18] = 4 * 4;
167         maxJumps[19] = 4 * 4;
168         maxJumps[20] = 3 * 3;
169         maxJumps[21] = 3 * 3;
170         maxJumps[22] = 3 * 3;
171         maxJumps[23] = 3 * 3;
172         maxJumps[24] = 3 * 3;
173         maxJumps[25] = 3 * 3;
174     }
175     
176     function updateMinJump(uint _minJump) onlyModerators external {
177         minJump = _minJump;
178     }
179     
180     // moderators
181     
182     function withdrawEther(address _sendTo, uint _amount) onlyModerators external {
183         // no user money is kept in this contract, only trasaction fee
184         if (_amount > address(this).balance) {
185             revert();
186         }
187         _sendTo.transfer(_amount);
188     }
189     
190     function withdrawToken(address _sendTo, uint _amount) onlyModerators requireTokenContract external {
191         ERC20Interface token = ERC20Interface(tokenContract);
192         if (_amount > token.balanceOf(address(this))) {
193             revert();
194         }
195         token.transfer(_sendTo, _amount);
196     }
197     
198     function addBonus(uint _pos, uint _amount) onlyModerators external {
199         bonus[_pos] += _amount;
200         EventBonus(_pos, _amount);
201     }
202     
203     // for payment contract to call
204     function AddFishByToken(address _player, uint tokens) onlyModerators external {
205         uint weight = tokens * cashInRate / 100;
206         if (weight != addWeight) 
207             revert();
208         
209          // max: one fish per address
210         if (fishMap[players[_player]].weight > 0)
211             revert();
212         
213         totalFish += 1;
214         Fish storage fish = fishMap[totalFish];
215         fish.player = _player;
216         fish.weight = addWeight;
217         fish.active = false;
218         players[_player] = totalFish;
219         
220         seed = getRandom(seed);
221         Transfer(address(0), _player, totalFish);
222     }
223     
224     // public functions
225     function getRandom(uint _seed) constant public returns(uint) {
226         return uint(keccak256(block.timestamp, block.difficulty)) ^ _seed;
227     }
228     
229     function AddFish() isActive payable external {
230         if (msg.value != addFee) revert();
231         
232         // max: one fish per address
233         if (fishMap[players[msg.sender]].weight > 0)
234             revert();
235         
236         totalFish += 1;
237         Fish storage fish = fishMap[totalFish];
238         fish.player = msg.sender;
239         fish.weight = addWeight;
240         fish.active = false;
241         players[msg.sender] = totalFish;
242         
243         seed = getRandom(seed);
244         Transfer(address(0), msg.sender, totalFish);
245     }
246     
247     function DeductABS(uint _a, uint _b) pure public returns(uint) {
248         if (_a > _b) 
249             return (_a - _b);
250         return (_b - _a);
251     }
252     
253     function MoveFish(uint _fromPos, uint _toPos) isActive external {
254         // check valid _x, _y
255         if (_toPos >= maxPos && _fromPos != _toPos)
256             revert();
257         
258         uint fishId = players[msg.sender];
259         Fish storage fish = fishMap[fishId];
260         if (fish.weight == 0)
261             revert();
262         if (!fish.active && _fromPos != BASE_POS)
263             revert();
264         if (fish.active && ocean[_fromPos] != fishId)
265             revert();
266         
267         // check valid move
268         uint tempX = DeductABS(_fromPos / HIGH, _toPos / HIGH);
269         uint tempY = DeductABS(_fromPos % HIGH, _toPos % HIGH);
270         uint squareLength = maxJumps[fish.weight / ONE_EMONT];
271         if (squareLength == 0) squareLength = minJump;
272         
273         if (tempX * tempX + tempY * tempY > squareLength)
274             revert();
275         
276         // move 
277         ocean[_fromPos] = 0;
278         // charge when swiming except from the base
279         if (_fromPos != BASE_POS) {
280             tempX = (moveCharge * fish.weight) / 100;
281             bonus[_fromPos] += tempX;
282             fish.weight -= tempX;
283         } else {
284             fish.active = true;
285         }
286 
287         // go back to base
288         if (_toPos == BASE_POS) {
289             fish.active = false;
290             EventMove(msg.sender, fishId, _fromPos, _toPos, fish.weight);
291             return;
292         }
293 
294         tempX = ocean[_toPos]; // target fish id
295         // no fish at that location
296         if (tempX == 0) {
297             if (bonus[_toPos] > 0) {
298                 fish.weight += bonus[_toPos];
299                 bonus[_toPos] = 0;
300             }
301             
302             // update location
303             EventMove(msg.sender, fishId, _fromPos, _toPos, fish.weight);
304             ocean[_toPos] = fishId;
305         } else {
306             // can not attack from the base
307             if (_fromPos == BASE_POS) revert();
308             
309             Fish storage targetFish = fishMap[tempX];
310             if (targetFish.weight + minEatable <= fish.weight) {
311                 // eat the target fish
312                 fish.weight += targetFish.weight;
313                 targetFish.weight = 0;
314                 
315                 // update location
316                 ocean[_toPos] = fishId;
317                 
318                 EventEat(msg.sender, targetFish.player, fishId, tempX, _fromPos, _toPos, fish.weight);
319                 Transfer(targetFish.player, address(0), tempX);
320             } else if (targetFish.weight <= fish.weight) {
321                 // fight and win
322                 // bonus to others
323                 seed = getRandom(seed);
324                 tempY = seed % (maxPos - 1);
325                 if (tempY == BASE_POS) tempY += 1;
326                 bonus[tempY] = targetFish.weight * 2;
327                 
328                 EventBonus(tempY, targetFish.weight * 2);
329                 
330                 // fight 
331                 fish.weight -= targetFish.weight;
332                 targetFish.weight = 0;
333                 
334                 // update location
335                 if (fish.weight > 0) {
336                     ocean[_toPos] = fishId;
337                 } else {
338                     ocean[_toPos] = 0;
339                     Transfer(msg.sender, address(0), fishId);
340                 }
341                 
342                 EventFight(msg.sender, targetFish.player, fishId, tempX, _fromPos, _toPos, fish.weight);
343                 Transfer(targetFish.player, address(0), tempX);
344             } else {
345                 // bonus to others
346                 seed = getRandom(seed);
347                 tempY = seed % (maxPos - 1);
348                 if (tempY == BASE_POS) tempY += 1;
349                 bonus[tempY] = fish.weight * 2;
350                 
351                 EventBonus(tempY, fish.weight * 2);
352                 
353                 // suicide
354                 targetFish.weight -= fish.weight;
355                 fish.weight = 0;
356                 
357                 EventSuicide(msg.sender, targetFish.player, fishId, tempX, _fromPos, _toPos, targetFish.weight);
358                 Transfer(msg.sender, address(0), fishId);
359             }
360         }
361     }
362     
363     function CashOut() isActive external {
364         uint fishId = players[msg.sender];
365         Fish storage fish = fishMap[fishId];
366         
367         if (fish.weight < minCashout)
368             revert();
369         
370         if (fish.weight < addWeight) 
371             revert();
372         
373         uint _amount = fish.weight - addWeight;
374         fish.weight = addWeight;
375         
376         ERC20Interface token = ERC20Interface(tokenContract);
377         if (_amount > token.balanceOf(address(this))) {
378             revert();
379         }
380         token.transfer(msg.sender, (_amount * cashOutRate) / 100);
381         EventCashout(msg.sender, fishId, fish.weight);
382     }
383     
384     // public get 
385     function getFish(uint32 _fishId) constant public returns(address player, uint weight, bool active) {
386         Fish storage fish = fishMap[_fishId];
387         return (fish.player, fish.weight, fish.active);
388     }
389     
390     function getFishByAddress(address _player) constant public returns(uint fishId, address player, uint weight, bool active) {
391         fishId = players[_player];
392         Fish storage fish = fishMap[fishId];
393         player = fish.player;
394         weight =fish.weight;
395         active = fish.active;
396     }
397     
398     function getFishIdByAddress(address _player) constant public returns(uint fishId) {
399         return players[_player];
400     }
401     
402     function getFishIdByPos(uint _pos) constant public returns(uint fishId) {
403         return ocean[_pos];
404     }
405     
406     function getFishByPos(uint _pos) constant public returns(uint fishId, address player, uint weight) {
407         fishId = ocean[_pos];
408         Fish storage fish = fishMap[fishId];
409         return (fishId, fish.player, fish.weight);
410     }
411     
412     // cell has valid fish or bonus
413     function findTargetCell(uint _fromPos, uint _toPos) constant public returns(uint pos, uint fishId, address player, uint weight) {
414         for (uint index = _fromPos; index <= _toPos; index+=1) {
415             if (ocean[index] > 0) {
416                 fishId = ocean[index];
417                 Fish storage fish = fishMap[fishId];
418                 return (index, fishId, fish.player, fish.weight);
419             }
420             if (bonus[index] > 0) {
421                 return (index, 0, address(0), bonus[index]);
422             }
423         }
424     }
425     
426     function getStats() constant public returns(uint countFish, uint countBonus) {
427         countFish = 0;
428         countBonus = 0;
429         for (uint index = 0; index < width * HIGH; index++) {
430             if (ocean[index] > 0) {
431                 countFish += 1; 
432             } else if (bonus[index] > 0) {
433                 countBonus += 1;
434             }
435         }
436     }
437     
438     function getFishAtBase(uint _fishId) constant public returns(uint fishId, address player, uint weight) {
439         for (uint id = _fishId; id <= totalFish; id++) {
440             Fish storage fish = fishMap[id];
441             if (fish.weight > 0 && !fish.active) {
442                 return (id, fish.player, fish.weight);
443             }
444         }
445         
446         return (0, address(0), 0);
447     }
448     
449     function getMaxJump(uint _weight) constant public returns(uint) {
450         return maxJumps[_weight];
451     }
452     
453     // some meta data
454     string public constant name = "EmontFrenzy";
455     string public constant symbol = "EMONF";
456 
457     function totalSupply() public view returns (uint256) {
458         return totalFish;
459     }
460     
461     function balanceOf(address _owner) public view returns (uint256 _balance) {
462         if (fishMap[players[_owner]].weight > 0)
463             return 1;
464         return 0;
465     }
466     
467     function ownerOf(uint256 _tokenId) public view returns (address _owner) {
468         Fish storage fish = fishMap[_tokenId];
469         if (fish.weight > 0)
470             return fish.player;
471         return address(0);
472     }
473     
474     function transfer(address _to, uint256 _tokenId) public{
475         require(_to != address(0));
476         
477         uint fishId = players[msg.sender];
478         Fish storage fish = fishMap[fishId];
479         if (fishId == 0 || fish.weight == 0 || fishId != _tokenId)
480             revert();
481         
482         if (balanceOf(_to) > 0)
483             revert();
484         
485         fish.player = _to;
486         players[msg.sender] = 0;
487         players[_to] = fishId;
488         
489         Transfer(msg.sender, _to, _tokenId);
490     }
491     
492 }