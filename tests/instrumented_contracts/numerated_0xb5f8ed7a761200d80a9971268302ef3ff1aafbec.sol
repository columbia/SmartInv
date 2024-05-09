1 pragma solidity ^0.4.19;
2 
3 contract BasicAccessControl {
4     address public owner;
5     // address[] public moderators;
6     uint16 public totalModerators = 0;
7     mapping (address => bool) public moderators;
8     bool public isMaintaining = false;
9 
10     function BasicAccessControl() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     modifier onlyModerators() {
20         require(msg.sender == owner || moderators[msg.sender] == true);
21         _;
22     }
23 
24     modifier isActive {
25         require(!isMaintaining);
26         _;
27     }
28 
29     function ChangeOwner(address _newOwner) onlyOwner public {
30         if (_newOwner != address(0)) {
31             owner = _newOwner;
32         }
33     }
34 
35 
36     function AddModerator(address _newModerator) onlyOwner public {
37         if (moderators[_newModerator] == false) {
38             moderators[_newModerator] = true;
39             totalModerators += 1;
40         }
41     }
42     
43     function RemoveModerator(address _oldModerator) onlyOwner public {
44         if (moderators[_oldModerator] == true) {
45             moderators[_oldModerator] = false;
46             totalModerators -= 1;
47         }
48     }
49 
50     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
51         isMaintaining = _isMaintaining;
52     }
53 }
54 
55 contract ERC20Interface {
56     function totalSupply() public constant returns (uint);
57     function balanceOf(address tokenOwner) public constant returns (uint balance);
58     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
59     function transfer(address to, uint tokens) public returns (bool success);
60     function approve(address spender, uint tokens) public returns (bool success);
61     function transferFrom(address from, address to, uint tokens) public returns (bool success);
62 }
63 
64 
65 contract EmontFrenzy is BasicAccessControl {
66     uint constant public HIGH = 20;
67     uint constant public BASE_POS = 510;
68     uint constant public ONE_EMONT = 10 ** 8;
69 
70     struct Fish {
71         address player;
72         uint weight;
73         bool active; // location != 0
74     }
75 
76     // private
77     uint private seed;
78 
79      // address
80     address public tokenContract;
81     
82     // variable
83     uint public addFee = 0.01 ether;
84     uint public addWeight = 5 * 10 ** 8; // emont
85     uint public moveCharge = 5; // percentage
86     uint public cashOutRate = 100; // to EMONT rate
87     uint public cashInRate = 50; // from EMONT to fish weight 
88     uint public width = 50;
89     uint public minJump = 2 * 2;
90     uint public maxPos = HIGH * width; // valid pos (0 -> maxPos - 1)
91     
92     mapping(uint => Fish) fishMap;
93     mapping(uint => uint) ocean; // pos => fish id
94     mapping(uint => uint) bonus; // pos => emont amount
95     mapping(address => uint) players;
96     
97     mapping(uint => uint) maxJumps; // weight in EMONT => square length
98     
99     uint public totalFish = 0;
100     
101     // event
102     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
103 
104     event EventCashout(address indexed player, uint fishId, uint weight);
105     event EventBonus(uint pos, uint value);
106     event EventMove(address indexed player, uint fishId, uint fromPos, uint toPos, uint weight);
107     event EventEat(address indexed player, address indexed defender, uint playerFishId, uint defenderFishId, uint fromPos, uint toPos, uint playerWeight);
108     event EventSuicide(address indexed player, address indexed defender, uint playerFishId, uint defenderFishId, uint fromPos, uint toPos, uint defenderWeight);
109     
110     
111     // modifier
112     modifier requireTokenContract {
113         require(tokenContract != address(0));
114         _;
115     }
116     
117     function EmontFrenzy(address _tokenContract) public {
118         tokenContract = _tokenContract;
119         seed = getRandom(0);
120     }
121     
122     function setConfig(uint _addFee, uint _addWeight, uint _moveCharge, uint _cashOutRate, uint _cashInRate, uint _width) onlyModerators external {
123         addFee = _addFee;
124         addWeight = _addWeight;
125         moveCharge = _moveCharge;
126         cashOutRate = _cashOutRate;
127         cashInRate = _cashInRate;
128         width = _width;
129         maxPos = HIGH * width;
130     }
131     
132     
133     // weight in emont, x*x
134     function updateMaxJump(uint _weight, uint _squareLength) onlyModerators external {
135         maxJumps[_weight] = _squareLength;
136     }
137     
138     function setDefaultMaxJump() onlyModerators external {
139         maxJumps[0] = 50 * 50;
140         maxJumps[1] = 30 * 30;
141         maxJumps[2] = 20 * 20;
142         maxJumps[3] = 15 * 15;
143         maxJumps[4] = 12 * 12;
144         maxJumps[5] = 9 * 9;
145         maxJumps[6] = 7 * 7;
146         maxJumps[7] = 7 * 7;
147         maxJumps[8] = 6 * 6;
148         maxJumps[9] = 6 * 6;
149         maxJumps[10] = 6 * 6;
150         maxJumps[11] = 5 * 5;
151         maxJumps[12] = 5 * 5;
152         maxJumps[13] = 5 * 5;
153         maxJumps[14] = 5 * 5;
154         maxJumps[15] = 4 * 4;
155         maxJumps[16] = 4 * 4;
156         maxJumps[17] = 4 * 4;
157         maxJumps[18] = 4 * 4;
158         maxJumps[19] = 4 * 4;
159         maxJumps[20] = 3 * 3;
160         maxJumps[21] = 3 * 3;
161         maxJumps[22] = 3 * 3;
162         maxJumps[23] = 3 * 3;
163         maxJumps[24] = 3 * 3;
164         maxJumps[25] = 3 * 3;
165     }
166     
167     function updateMinJump(uint _minJump) onlyModerators external {
168         minJump = _minJump;
169     }
170     
171     // moderators
172     
173     function withdrawEther(address _sendTo, uint _amount) onlyModerators external {
174         // no user money is kept in this contract, only trasaction fee
175         if (_amount > address(this).balance) {
176             revert();
177         }
178         _sendTo.transfer(_amount);
179     }
180     
181     function withdrawToken(address _sendTo, uint _amount) onlyModerators requireTokenContract external {
182         ERC20Interface token = ERC20Interface(tokenContract);
183         if (_amount > token.balanceOf(address(this))) {
184             revert();
185         }
186         token.transfer(_sendTo, _amount);
187     }
188     
189     function addBonus(uint _pos, uint _amount) onlyModerators external {
190         bonus[_pos] += _amount;
191         EventBonus(_pos, _amount);
192     }
193     
194     // for payment contract to call
195     function AddFishByToken(address _player, uint tokens) onlyModerators external {
196         uint weight = tokens * cashInRate / 100;
197         if (weight != addWeight) 
198             revert();
199         
200          // max: one fish per address
201         if (fishMap[players[_player]].weight > 0)
202             revert();
203         
204         totalFish += 1;
205         Fish storage fish = fishMap[totalFish];
206         fish.player = _player;
207         fish.weight = addWeight;
208         fish.active = false;
209         players[_player] = totalFish;
210         
211         seed = getRandom(seed);
212         Transfer(address(0), _player, totalFish);
213     }
214     
215     // public functions
216     function getRandom(uint _seed) constant public returns(uint) {
217         return uint(keccak256(block.timestamp, block.difficulty)) ^ _seed;
218     }
219     
220     function AddFish() isActive payable external {
221         if (msg.value != addFee) revert();
222         
223         // max: one fish per address
224         if (fishMap[players[msg.sender]].weight > 0)
225             revert();
226         
227         totalFish += 1;
228         Fish storage fish = fishMap[totalFish];
229         fish.player = msg.sender;
230         fish.weight = addWeight;
231         fish.active = false;
232         players[msg.sender] = totalFish;
233         
234         seed = getRandom(seed);
235         Transfer(address(0), msg.sender, totalFish);
236     }
237     
238     function DeductABS(uint _a, uint _b) pure public returns(uint) {
239         if (_a > _b) 
240             return (_a - _b);
241         return (_b - _a);
242     }
243     
244     function MoveFish(uint _fromPos, uint _toPos) isActive external {
245         // check valid _x, _y
246         if (_toPos >= maxPos && _fromPos != _toPos)
247             revert();
248         
249         uint fishId = players[msg.sender];
250         Fish storage fish = fishMap[fishId];
251         if (fish.weight == 0)
252             revert();
253         if (!fish.active && _fromPos != BASE_POS)
254             revert();
255         if (fish.active && ocean[_fromPos] != fishId)
256             revert();
257         
258         // check valid move
259         uint tempX = DeductABS(_fromPos / HIGH, _toPos / HIGH);
260         uint tempY = DeductABS(_fromPos % HIGH, _toPos % HIGH);
261         uint squareLength = maxJumps[fish.weight / ONE_EMONT];
262         if (squareLength == 0) squareLength = minJump;
263         
264         if (tempX * tempX + tempY * tempY > squareLength)
265             revert();
266         
267         // move 
268         ocean[_fromPos] = 0;
269         // charge when swiming except from the base
270         if (_fromPos != BASE_POS) {
271             tempX = (moveCharge * fish.weight) / 100;
272             bonus[_fromPos] += tempX;
273             fish.weight -= tempX;
274         } else {
275             fish.active = true;
276         }
277 
278         // go back to base
279         if (_toPos == BASE_POS) {
280             fish.active = false;
281             EventMove(msg.sender, fishId, _fromPos, _toPos, fish.weight);
282             return;
283         }
284 
285         tempX = ocean[_toPos]; // target fish id
286         // no fish at that location
287         if (tempX == 0) {
288             if (bonus[_toPos] > 0) {
289                 fish.weight += bonus[_toPos];
290                 bonus[_toPos] = 0;
291             }
292             
293             // update location
294             EventMove(msg.sender, fishId, _fromPos, _toPos, fish.weight);
295             ocean[_toPos] = fishId;
296         } else {
297             // can not attack from the base
298             if (_fromPos == BASE_POS) revert();
299             
300             Fish storage targetFish = fishMap[tempX];
301             if (targetFish.weight <= fish.weight) {
302                 // eat the target fish
303                 fish.weight += targetFish.weight;
304                 targetFish.weight = 0;
305                 
306                 // update location
307                 ocean[_toPos] = fishId;
308                 
309                 EventEat(msg.sender, targetFish.player, fishId, tempX, _fromPos, _toPos, fish.weight);
310                 Transfer(targetFish.player, address(0), tempX);
311             } else {
312                 // bonus to others
313                 seed = getRandom(seed);
314                 tempY = seed % (maxPos - 1);
315                 if (tempY == BASE_POS) tempY += 1;
316                 bonus[tempY] = fish.weight * 2;
317                 
318                 EventBonus(tempY, fish.weight * 2);
319                 
320                 // suicide
321                 targetFish.weight -= fish.weight;
322                 fish.weight = 0;
323                 
324                 EventSuicide(msg.sender, targetFish.player, fishId, tempX, _fromPos, _toPos, targetFish.weight);
325                 Transfer(msg.sender, address(0), fishId);
326             }
327         }
328     }
329     
330     function CashOut(uint _amount) isActive external {
331         uint fishId = players[msg.sender];
332         Fish storage fish = fishMap[fishId];
333         
334         if (fish.weight < _amount + addWeight) 
335             revert();
336         
337         fish.weight -= _amount;
338         
339         ERC20Interface token = ERC20Interface(tokenContract);
340         if (_amount > token.balanceOf(address(this))) {
341             revert();
342         }
343         token.transfer(msg.sender, (_amount * cashOutRate) / 100);
344         EventCashout(msg.sender, fishId, fish.weight);
345     }
346     
347     // public get 
348     function getFish(uint32 _fishId) constant public returns(address player, uint weight, bool active) {
349         Fish storage fish = fishMap[_fishId];
350         return (fish.player, fish.weight, fish.active);
351     }
352     
353     function getFishByAddress(address _player) constant public returns(uint fishId, address player, uint weight, bool active) {
354         fishId = players[_player];
355         Fish storage fish = fishMap[fishId];
356         player = fish.player;
357         weight =fish.weight;
358         active = fish.active;
359     }
360     
361     function getFishIdByAddress(address _player) constant public returns(uint fishId) {
362         return players[_player];
363     }
364     
365     function getFishIdByPos(uint _pos) constant public returns(uint fishId) {
366         return ocean[_pos];
367     }
368     
369     function getFishByPos(uint _pos) constant public returns(uint fishId, address player, uint weight) {
370         fishId = ocean[_pos];
371         Fish storage fish = fishMap[fishId];
372         return (fishId, fish.player, fish.weight);
373     }
374     
375     // cell has valid fish or bonus
376     function findTargetCell(uint _fromPos, uint _toPos) constant public returns(uint pos, uint fishId, address player, uint weight) {
377         for (uint index = _fromPos; index <= _toPos; index+=1) {
378             if (ocean[index] > 0) {
379                 fishId = ocean[index];
380                 Fish storage fish = fishMap[fishId];
381                 return (index, fishId, fish.player, fish.weight);
382             }
383             if (bonus[index] > 0) {
384                 return (index, 0, address(0), bonus[index]);
385             }
386         }
387     }
388     
389     function getStats() constant public returns(uint countFish, uint countBonus) {
390         countFish = 0;
391         countBonus = 0;
392         for (uint index = 0; index < width * HIGH; index++) {
393             if (ocean[index] > 0) {
394                 countFish += 1; 
395             } else if (bonus[index] > 0) {
396                 countBonus += 1;
397             }
398         }
399     }
400     
401     function getFishAtBase(uint _fishId) constant public returns(uint fishId, address player, uint weight) {
402         for (uint id = _fishId; id <= totalFish; id++) {
403             Fish storage fish = fishMap[id];
404             if (fish.weight > 0 && !fish.active) {
405                 return (id, fish.player, fish.weight);
406             }
407         }
408         
409         return (0, address(0), 0);
410     }
411     
412     function getMaxJump(uint _weight) constant public returns(uint) {
413         return maxJumps[_weight];
414     }
415     
416     // some meta data
417     string public constant name = "EmontFrenzy";
418     string public constant symbol = "EMONF";
419 
420     function totalSupply() public view returns (uint256) {
421         return totalFish;
422     }
423     
424     function balanceOf(address _owner) public view returns (uint256 _balance) {
425         if (fishMap[players[_owner]].weight > 0)
426             return 1;
427         return 0;
428     }
429     
430     function ownerOf(uint256 _tokenId) public view returns (address _owner) {
431         Fish storage fish = fishMap[_tokenId];
432         if (fish.weight > 0)
433             return fish.player;
434         return address(0);
435     }
436     
437     function transfer(address _to, uint256 _tokenId) public{
438         require(_to != address(0));
439         
440         uint fishId = players[msg.sender];
441         Fish storage fish = fishMap[fishId];
442         if (fishId == 0 || fish.weight == 0 || fishId != _tokenId)
443             revert();
444         
445         if (balanceOf(_to) > 0)
446             revert();
447         
448         fish.player = _to;
449         players[msg.sender] = 0;
450         players[_to] = fishId;
451         
452         Transfer(msg.sender, _to, _tokenId);
453     }
454     
455 }