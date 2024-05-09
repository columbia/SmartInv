1 pragma solidity ^0.4.24;
2 
3 /* LORDS OF THE SNAILS
4 
5 LOTS is a hot potato game on Ethereum.
6 Goal: gather enough eggs to win the round.
7 
8 8 different Snails produce eggs consistently.
9 Grab a Snail to own it and get the eggs he previously laid.
10 Snag while owning a Snail to get accumulated eggs.
11 
12 For each of the 8 Snails, there is one Lord.
13 Claim a Lord to own the corresponding Snail on round start.
14 
15 Both Snails and Lords are ether hot potatoes with fixed increases.
16 Snails can only be acquired while the game is active.
17 Lords can only be acquired while the game is paused.
18 
19 Snail cost starts at 0.01 ETH and rises by 0.01 for each level.
20 On a flip, the previous Snail owner is reimbursed the cost of his own flip.
21 On round end, Snail cost resets to 0.01 ETH.
22 
23 With each flip, the level of the Snail flipped rises by 1.
24 Egg production for that Snail is 1 per second per level.
25 
26 A global multiplier boosts bonus Eggs for flippers.
27 This multiplier rises by 1% per minute, and resets on a flip.
28 
29 Lord cost starts at 0.05 eth and rises by 0.05 per level.
30 On a flip, the previous Lord receives his flip + 0.01 ETH.
31 Lord cost and level are permanent.
32 Lords receive dividends everytime a Grab or Snag is done on their snail.
33 
34 Lord flips share a global egg bonus.
35 This bonus is fixed at 8 per second * round.
36 The bonus resets on a Lord flip or a round win.
37 
38 Once a player reaches the required amount of eggs through Grab or Snag,
39 Their amount of eggs is reset to 0 and they win the round.
40 They receive the round pot, and the game enters a 24 hours downtime period.
41 Other players keep their Eggs from round to round.
42 
43 */
44 
45 contract LordsOfTheSnails {
46     using SafeMath for uint;
47     
48     /* EVENTS */
49     
50     event WonRound (address indexed player, uint eth, uint round);
51     event StartedRound (uint round);
52     event GrabbedSnail (address indexed player, uint snail, uint eth, uint egg, uint playeregg);
53     event SnaggedEgg (address indexed player, uint snail, uint egg, uint playeregg);
54     event ClaimedLord (address indexed player, uint lord, uint eth, uint egg, uint playeregg);
55     event WithdrewBalance (address indexed player, uint eth);
56     event PaidThrone (address indexed player, uint eth);
57     event BoostedPot (address indexed player, uint eth);
58 
59     /* CONSTANTS */
60     
61     uint256 constant SNAIL_COST     = 0.01 ether; //per level
62     uint256 constant LORD_COST      = 0.05 ether; //per level
63     uint256 constant SNAG_COST      = 0.002 ether; //fixed
64     uint256 constant DOWNTIME       = 86400; //24 hours between rounds, in seconds
65     uint256 constant WIN_REQ        = 1000000; //per round
66     address constant SNAILTHRONE    = 0x261d650a521103428C6827a11fc0CBCe96D74DBc;
67 
68     /* STRUCTS */
69 
70     struct Snail {
71         uint256 level;
72         uint256 lastSnag;
73         address owner;
74     }
75     
76     Snail[8] colorSnail;
77     
78     struct Lord {
79         uint256 level;
80         address owner;
81     }
82     
83     Lord[8] lord;
84     
85     /* VARIABLES */
86     
87     //State of the game
88     bool public gameActive = false;
89     
90     //Current round
91     uint256 public round;
92     
93     //Timestamp for next round start
94     uint256 public nextRoundStart;
95     
96     //Requirement to win round
97     uint256 public victoryEgg;
98     
99     //Current egg leader
100     address public leader;
101     
102     //Last global Snail grab
103     uint256 public lastGrab;
104     
105     //Last global Lord claim
106     uint256 public lastClaim;
107     
108     //Game pot
109     uint256 public snailPot;
110     
111     //Round pot, part of the snailPot set at round start
112     uint256 public roundPot;
113     
114     //Divs for SnailThrone
115     uint256 public thronePot;
116     
117     /* MAPPINGS */
118     
119     mapping (address => uint256) playerEgg;
120     mapping (address => uint256) playerBalance;
121     
122     /* FUNCTIONS */
123 
124     // Constructor 
125     // Sets all snails and lords to level 1 and msg.sender
126     // Starts downtime period
127 
128     constructor() public {
129 
130         Lord memory _lord = Lord({
131             level: 1,
132             owner: msg.sender
133         });
134         
135         lord[0] =  _lord;
136         lord[1] =  _lord;
137         lord[2] =  _lord;
138         lord[3] =  _lord;
139         lord[4] =  _lord;
140         lord[5] =  _lord;
141         lord[6] =  _lord;
142         lord[7] =  _lord;
143         
144         leader = msg.sender;
145         lastClaim = now;
146         nextRoundStart = now.add(DOWNTIME);
147     }
148     
149     //-- PRIVATE --//
150     
151     // PotSplit
152     // 80% to snailPot, 10% to thronePot, 10% to lord owner
153     
154     function PotSplit(uint256 _msgValue, uint256 _id) private {
155         
156         snailPot = snailPot.add(_msgValue.mul(8).div(10));
157         thronePot = thronePot.add(_msgValue.div(10));
158         address _owner = lord[_id].owner;
159         playerBalance[_owner] = playerBalance[_owner].add(_msgValue.div(10));
160     }
161     
162     // WinRound
163     // Gives the roundpot to winner, pauses game
164     
165     function WinRound(address _msgSender) private {
166         gameActive = false;
167 		lastClaim = now; //let's avoid a race to flip the moment round ends
168         nextRoundStart = now.add(DOWNTIME);
169         playerEgg[_msgSender] = 0;
170         playerBalance[_msgSender] = playerBalance[_msgSender].add(roundPot);
171         
172         emit WonRound(_msgSender, roundPot, round);
173     }
174     
175     //-- PUBLIC --//
176     
177     // BeginRound
178     // Sets proper values, then starts the round
179     // roundPot = 10% of snailPot, winReq = 1MM * round
180     
181     function BeginRound() public {
182         require(now >= nextRoundStart, "downtime isn't over yet");
183         require(gameActive == false, "game is already active");
184         
185         for(uint256 i = 0; i < 8; i++){
186             colorSnail[i].level = 1;
187             colorSnail[i].lastSnag = now;
188             colorSnail[i].owner = lord[i].owner;
189         }
190 
191 		round = round.add(1);
192         victoryEgg = round.mul(WIN_REQ);
193         roundPot = snailPot.div(10);
194         snailPot = snailPot.sub(roundPot);
195         lastGrab = now;
196         gameActive = true;
197         
198         emit StartedRound(round);
199     }
200     
201     function GrabSnail(uint256 _id) public payable {
202         require(gameActive == true, "game is paused");
203         require(tx.origin == msg.sender, "no contracts allowed");
204         
205         //check cost
206         uint256 _cost = ComputeSnailCost(_id);
207         require(msg.value == _cost, "wrong amount of ETH");
208         
209         //split 0.01eth to pot
210         PotSplit(SNAIL_COST, _id);
211         
212         //give value - 0.01eth to previous owner
213         uint256 _prevReward = msg.value.sub(SNAIL_COST);
214         address _prevOwner = colorSnail[_id].owner;
215         playerBalance[_prevOwner] = playerBalance[_prevOwner].add(_prevReward);
216         
217         //compute eggs, set last hatch then give to flipper
218         uint256 _reward = ComputeEgg(true, _id);
219         colorSnail[_id].lastSnag = now;
220         playerEgg[msg.sender] = playerEgg[msg.sender].add(_reward);
221         
222         //give snail to flipper, raise level
223         colorSnail[_id].owner = msg.sender;
224         colorSnail[_id].level = colorSnail[_id].level.add(1);
225         
226         //set last flip to now
227         lastGrab = now;
228         
229         //check if flipper ends up winning round
230         if(playerEgg[msg.sender] >= victoryEgg){
231             WinRound(msg.sender);
232         } else {
233             emit GrabbedSnail(msg.sender, _id, _cost, _reward, playerEgg[msg.sender]);
234         }
235         
236         //check if flipper becomes leader
237         if(playerEgg[msg.sender] > playerEgg[leader]){
238             leader = msg.sender;
239         }
240     }
241     
242     function ClaimLord(uint256 _id) public payable {
243         require(gameActive == false, "lords can only flipped during downtime");
244         require(tx.origin == msg.sender, "no contracts allowed");
245         
246         //check cost
247         uint256 _cost = ComputeLordCost(_id);
248         require(msg.value == _cost, "wrong amount of ETH");
249         
250         uint256 _potSplit = 0.04 ether;
251         //split 0.04eth to pot
252         PotSplit(_potSplit, _id);
253         
254         //give value - 0.04eth to previous owner
255         uint256 _prevReward = msg.value.sub(_potSplit);
256         address _prevOwner = lord[_id].owner;
257         playerBalance[_prevOwner] = playerBalance[_prevOwner].add(_prevReward);
258 
259         //compute bonus eggs and give to flipper
260         uint256 _reward = ComputeLordBonus();
261         playerEgg[msg.sender] = playerEgg[msg.sender].add(_reward);
262         
263         //give lord to flipper, raise level
264         lord[_id].owner = msg.sender;
265         lord[_id].level = lord[_id].level.add(1);
266     
267         //set last lord flip to now
268         lastClaim = now;
269         
270         //check if flipper becomes leader
271         if(playerEgg[msg.sender] > playerEgg[leader]){
272             leader = msg.sender;
273         }
274         
275         emit ClaimedLord(msg.sender, _id, _cost, _reward, playerEgg[msg.sender]);
276     }
277     
278     function SnagEgg(uint256 _id) public payable {
279         require(gameActive == true, "can't snag during downtime");
280         require(msg.value == SNAG_COST, "wrong ETH amount (should be 0.002eth)");
281 		require(colorSnail[_id].owner == msg.sender, "own this snail to snag their eggs");
282         
283         //split msg.value
284         PotSplit(SNAG_COST, _id);
285         
286         //compute eggs, set last hatch then give reward
287         uint256 _reward = ComputeEgg(false, _id);
288         colorSnail[_id].lastSnag = now;
289         playerEgg[msg.sender] = playerEgg[msg.sender].add(_reward);
290          
291         //check if snagger ends up winning round
292         if(playerEgg[msg.sender] >= victoryEgg){
293             WinRound(msg.sender);
294         } else {
295             emit SnaggedEgg(msg.sender, _id, _reward, playerEgg[msg.sender]);
296         }
297         
298         //check if snagger becomes leader
299         if(playerEgg[msg.sender] > playerEgg[leader]){
300             leader = msg.sender;
301         }
302     }
303     
304     //-- MANAGEMENT --//
305     
306     // WithdrawBalance
307     // Withdraws the ETH balance of a player to his wallet
308     
309     function WithdrawBalance() public {
310         require(playerBalance[msg.sender] > 0, "no ETH in player balance");
311         
312         uint _amount = playerBalance[msg.sender];
313         playerBalance[msg.sender] = 0;
314         msg.sender.transfer(_amount);
315         
316         emit WithdrewBalance(msg.sender, _amount);
317     }
318     
319     // PayThrone
320     // Sends thronePot to SnailThrone
321     
322     function PayThrone() public {
323         uint256 _payThrone = thronePot;
324         thronePot = 0;
325         if (!SNAILTHRONE.call.value(_payThrone)()){
326             revert();
327         }
328         
329         emit PaidThrone(msg.sender, _payThrone);
330     }
331     
332     // fallback function
333     // Feeds the snailPot
334     
335     function() public payable {
336         snailPot = snailPot.add(msg.value);
337         
338         emit BoostedPot(msg.sender, msg.value);
339     }
340     
341     //-- COMPUTATIONS --//
342     
343     // ComputeSnailCost
344     // Returns cost to buy a particular snail
345     // Cost = next level * SNAIL_COST
346     
347     function ComputeSnailCost(uint256 _id) public view returns(uint256){
348         uint256 _cost = (colorSnail[_id].level.add(1)).mul(SNAIL_COST);
349         return _cost;
350     }
351     
352     // ComputeLordCost
353     // Returns cost to buy a particular snail
354     // Cost = next level * SNAIL_COST
355     
356     function ComputeLordCost(uint256 _id) public view returns(uint256){
357         uint256 _cost = (lord[_id].level.add(1)).mul(LORD_COST);
358         return _cost;
359     }
360     
361     // ComputeEgg
362     // Returns eggs produced since last snag
363     // 1 per second per level
364     // Multiplies by bonus if flip (1% per minute)
365     
366     function ComputeEgg(bool _flip, uint256 _id) public view returns(uint256) {
367         
368         //Get bonus (in %)
369         uint256 _bonus = 100;
370         if(_flip == true){
371             _bonus = _bonus.add((now.sub(lastGrab)).div(60));
372         }
373         
374         //Calculate eggs
375         uint256 _egg = now.sub(colorSnail[_id].lastSnag);
376         _egg = _egg.mul(colorSnail[_id].level).mul(_bonus).div(100);
377         return _egg;
378     }
379     
380     // ComputeLordBonus
381     // Returns bonus eggs for flipping a lord
382     // Bonus = 8 per second per round
383 	// (With 24h downtime, roughly 2/3 of the req in worst/best case)
384     
385     function ComputeLordBonus() public view returns(uint256){
386         return (now.sub(lastClaim)).mul(8).mul(round);
387     }
388     
389     //-- GETTERS --//
390     
391     function GetSnailLevel(uint256 _id) public view returns(uint256){
392         return colorSnail[_id].level;
393     }
394     
395     function GetSnailSnag(uint256 _id) public view returns(uint256){
396         return colorSnail[_id].lastSnag;
397     }
398     
399     function GetSnailOwner(uint256 _id) public view returns(address){
400         return colorSnail[_id].owner;
401     }
402     
403     function GetLordLevel(uint256 _id) public view returns(uint256){
404         return lord[_id].level;
405     }
406     
407     function GetLordOwner(uint256 _id) public view returns(address){
408         return lord[_id].owner;
409     }
410     
411     function GetPlayerBalance(address _player) public view returns(uint256){
412         return playerBalance[_player];
413     }
414     
415     function GetPlayerEgg(address _player) public view returns(uint256){
416         return playerEgg[_player];
417     }
418 }
419 
420 library SafeMath {
421 
422   /**
423   * @dev Multiplies two numbers, throws on overflow.
424   */
425   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
426     if (a == 0) {
427       return 0;
428     }
429     uint256 c = a * b;
430     assert(c / a == b);
431     return c;
432   }
433 
434   /**
435   * @dev Integer division of two numbers, truncating the quotient.
436   */
437   function div(uint256 a, uint256 b) internal pure returns (uint256) {
438     // assert(b > 0); // Solidity automatically throws when dividing by 0
439     uint256 c = a / b;
440     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
441     return c;
442   }
443 
444   /**
445   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
446   */
447   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
448     assert(b <= a);
449     return a - b;
450   }
451 
452   /**
453   * @dev Adds two numbers, throws on overflow.
454   */
455   function add(uint256 a, uint256 b) internal pure returns (uint256) {
456     uint256 c = a + b;
457     assert(c >= a);
458     return c;
459   }
460 }