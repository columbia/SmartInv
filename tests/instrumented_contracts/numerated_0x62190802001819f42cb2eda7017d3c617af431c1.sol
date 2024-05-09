1 pragma solidity ^0.4.24;
2 
3 contract INTIME {
4     using SafeMath for *;
5     
6     struct Player {
7         uint id;
8         uint referrer;
9         uint generation;
10         string name;
11         uint256 weight;
12         uint256 balance;
13         uint256 withdrawal;
14         uint256 referralBonus;
15         uint256 lastKeyBonus;
16         uint256 potBonus;
17         uint256 stakingBonus;
18         uint256 airdropBonus;
19     }
20     
21     mapping(address => Player) public players;
22     
23     // System
24     address public teamAddress;
25     uint256 public teamNamingIncome;
26     address public keyAddress;
27     address[] participantPool;
28     uint256 participantPoolStart;
29     uint256 participantPoolEnd;
30     address[] public participants;
31     uint256 public participantsLength;
32     address[] public winner;
33     uint256 public deadline;
34     uint256 keyPrice_min;
35     uint256 keyPrice_max;
36     uint256 public keyPrice;
37     uint256 public currentGeneration;
38     uint256 public currentKeyRound;
39     uint256 public duration;
40     uint256[] public durationPhaseArray;
41     uint256 public durationPhaseIndex;
42     uint256 public poolWeight;
43     uint256 public poolBalance;
44     uint256 public poolReward;
45     uint256 public poolWithdraw;
46     bool public airdropped;
47     bool public keyLocked;
48     uint256 public airdropWinTime;
49     uint256 public airdropBalance;
50     uint256 public airdroppedAmount;
51     uint256 public unitStake;
52     uint256 public potReserve;
53     
54     mapping(string => address) addressFromName;
55     
56     event Withdrawal(
57         address indexed _from,
58         uint256 _value
59     );
60     event Deposit(
61         address indexed _keyHolder,
62         uint256 _weight,
63         uint256 _keyPrice,
64         uint256 _deadline,
65         uint256 _durationPhaseIndex,
66         bool _phaseChanged,
67         uint256 _poolBalance,
68         uint256 _poolReward,
69         uint256 _poolWeight,
70         // If Airdrop
71         bool _airdropped,
72         uint256 _airdropBalance,
73         // If Trigger Reserve
74         bool _potReserveGive,
75         uint256 _potReserve
76     );
77     
78     /**
79      * @dev prevents contracts from interacting with fomo3d 
80      */
81     modifier isHuman() {
82         address _addr = msg.sender;
83         uint256 _codeLength;
84         
85         assembly {_codeLength := extcodesize(_addr)}
86         require(_codeLength == 0, "sorry humans only");
87         _;
88     }
89     /**
90      * Constructor function
91      * 
92      */
93     constructor (
94         address _teamAddress
95     ) public {
96         teamAddress = _teamAddress;
97         keyPrice_min = 1e14;       // in wei, 0.0001 eth
98         keyPrice_max = 15e15;      // in wei, 0.015 eth
99         keyPrice = keyPrice_min;   // in wei, 0.0001 eth
100         keyAddress = msg.sender;
101         durationPhaseArray = [1440, 720, 360, 180, 90, 60, 30];
102         durationPhaseIndex = 0;
103         duration = durationPhaseArray[durationPhaseIndex];
104         currentGeneration = 0;
105         resetGame();
106     }
107     
108     function resetGame() private {
109         uint256 residualBalance = 0;
110         if(currentGeneration != 0) {
111             // Distribute tokens
112             // Staking distribution => distributed on deposit
113             // Pool distribution => 20%
114             unitStake = 0;
115             // 75% for the winner;
116             players[keyAddress].balance += poolBalance / 5 * 75 / 100;
117             players[keyAddress].lastKeyBonus += poolBalance / 5 * 75 / 100;
118             // 15% for random participant
119             if(participantPoolEnd - participantPoolStart > 0) {
120                 uint randParticipantIndex = rand(participantPoolStart + 1, participantPoolEnd);
121                 players[participantPool[randParticipantIndex - 1]].balance += poolBalance / 5 * 15 / 100;
122                 players[participantPool[randParticipantIndex - 1]].lastKeyBonus += poolBalance / 5 * 15 / 100;
123             } else {
124                 players[keyAddress].balance += poolBalance / 5 * 15 / 100;
125                 players[keyAddress].lastKeyBonus += poolBalance / 5 * 15 / 100;
126             }
127             // 10% and pot reserve for next round
128             residualBalance += poolBalance / 5 * 10 / 100 + potReserve;
129             winner.push(keyAddress);
130         }
131         airdropWinTime = now;
132         keyPrice = 1e15;
133         poolWeight = 0;
134         poolReward = 0;
135         potReserve = 0;
136         
137         // Reset duration and deadline
138         durationPhaseIndex = 0;
139         duration = durationPhaseArray[durationPhaseIndex];
140         deadline = now + duration * 1 minutes;
141         
142         poolBalance = residualBalance;
143         keyLocked = false;
144         currentKeyRound = 0;
145         currentGeneration ++;
146         keyAddress = teamAddress;
147         participantPoolStart = participantPool.length;
148         participantPoolEnd = participantPool.length;
149     }
150     
151     /**
152      * Unique address
153      *
154      */
155     function setName(string name) isHuman() payable public {
156         uint256 amount = msg.value;
157         require(amount >= 1e15);
158         require(addressFromName[name] == address(0));
159         players[teamAddress].balance += amount;
160         teamNamingIncome += amount;
161         players[msg.sender].name = name;
162         addressFromName[name] = msg.sender;
163     }
164 
165     /**
166      * Fallback function
167      *
168      * The function without name is the default function that is called whenever anyone sends funds to a contract
169      */
170     function referralName (string name) isHuman() payable public {
171         if(addressFromName[name] != address(0) && addressFromName[name] != msg.sender && players[msg.sender].referrer == 0)
172             players[msg.sender].referrer = players[addressFromName[name]].id;
173         uint256 amount = msg.value;
174         deposit(amount);
175     }
176     function referralPay (uint referrer) isHuman() payable public {
177         if(referrer > participants.length)
178             referrer = 0;
179         if(players[msg.sender].id != referrer && players[msg.sender].referrer == 0)
180             players[msg.sender].referrer = referrer;
181         uint256 amount = msg.value;
182         deposit(amount);
183     }
184     function () isHuman() payable public {
185         uint256 amount = msg.value;
186         deposit(amount);
187     }
188     function depositVault (uint keyCount, uint referrer) isHuman() public {
189         require(keyLocked == false);
190         keyLocked = true;
191         // Buy key from current balance
192         uint256 amount = keyCount * keyPrice;
193         uint256 availableWithdrawal = players[msg.sender].balance - players[msg.sender].withdrawal;
194         require(amount <= availableWithdrawal);
195         require(amount > 0);
196         players[msg.sender].withdrawal += amount;
197         
198         if(referrer > participants.length)
199             referrer = 0;
200         if(players[msg.sender].id != referrer && players[msg.sender].referrer == 0)
201             players[msg.sender].referrer = referrer;
202         keyLocked = false;
203         deposit(amount);
204     }
205     function deposit(uint256 amount) private {
206         if(now >= deadline) resetGame();
207         require(keyLocked == false);
208         keyLocked = true;
209         
210         // Update pool balance
211 		require(amount >= keyPrice, "You have to buy at least one key.");
212 		poolBalance += amount;
213 		
214 		currentKeyRound ++;
215 		participantPool.push(msg.sender);
216 		participantPoolEnd = participantPool.length;
217 		// Update deadline if not last round
218 		if(durationPhaseIndex < 6) deadline = now + duration * 1 minutes;
219 		
220 		// Update key holder
221 		keyAddress = msg.sender;
222 		
223 		if(players[msg.sender].generation == 0) {
224 		    participants.push(msg.sender);
225 		    participantsLength = participants.length;
226 		    players[msg.sender].id = participants.length;
227 		}
228 		if(players[msg.sender].generation != currentGeneration) {
229 			players[msg.sender].generation = currentGeneration;
230 			players[msg.sender].weight = 0;
231 		}
232 		// Handling stake distribution
233 		uint256 p_i = 0;
234 		uint256 deltaStake = 0;
235 		address _addr;
236 		// 58% for staking
237 		if(poolWeight > 0) {
238 		    unitStake = amount * 58 / 100 / poolWeight;
239 		    for(p_i = 0; p_i < participants.length; p_i++) {
240 		        _addr = participants[p_i];
241 		        if(players[_addr].generation == currentGeneration) {
242 		            players[_addr].balance += players[_addr].weight * unitStake;
243 		            players[_addr].stakingBonus += players[_addr].weight * unitStake;
244 		        }
245 		    }
246 		}
247 		// 15% for referral
248 		if(players[msg.sender].referrer > 0) {
249 		    _addr = participants[players[msg.sender].referrer - 1];
250 		    players[_addr].balance += amount * 15 / 100;
251 		    players[_addr].referralBonus += amount * 15 / 100;
252 		} else {
253 		    if(poolWeight > 0) {
254 		        deltaStake = amount * 15 / 100 / poolWeight;
255 		        for(p_i = 0; p_i < participants.length; p_i++) {
256 		            _addr = participants[p_i];
257 		            if(players[_addr].generation == currentGeneration) {
258 		                players[_addr].balance += players[_addr].weight * deltaStake;
259 		                players[_addr].stakingBonus += players[_addr].weight * deltaStake;
260 		            }
261 		        }
262 		    } else {
263 		        players[teamAddress].balance += amount * 15 / 100;
264 		        players[teamAddress].stakingBonus += amount * 15 / 100;
265 		    }
266 		}
267 		// 4% for team
268 		unitStake += deltaStake;
269 		players[teamAddress].balance += amount * 4 / 100;
270 		players[teamAddress].stakingBonus += amount * 4 / 100;
271 		
272 		poolReward += amount * 77 / 100;
273 		
274 		airdropBalance += amount * 2 / 100;
275 		airdropped = false;
276 		airdroppedAmount = 0;
277 		uint randNum = 0;
278 		if(amount >= 1e17 && amount < 1e18) {
279 		    // 0.1 ~ 1 eth, 1% chance
280 		    randNum = rand(1, 10000);
281 		    if(randNum <= 10) airdropped = true;
282 		} else if(amount >= 1e18 && amount < 1e19) {
283 		    // 1 eth ~ 10 eth, 10% chance
284 		    randNum = rand(1, 10000);
285 		    if(randNum <= 100) airdropped = true;
286 		} else if(amount >= 1e19) {
287 		    // greater than 1 eth, 5% chance
288 		    randNum = rand(1, 10000);
289 		    if(randNum <= 500) airdropped = true;
290 		}
291 		bool _phaseChanged = false;
292 		if(airdropped) {
293 		    
294 		    airdropWinTime = now;
295 		    players[msg.sender].balance += airdropBalance;
296             players[msg.sender].airdropBonus += airdropBalance;
297             poolReward += airdropBalance;
298             
299             airdroppedAmount = airdropBalance;
300             airdropBalance = 0;
301             if(durationPhaseIndex == 0 && airdropBalance >= 1e18) _phaseChanged = true;
302             else if(durationPhaseIndex == 1 && airdropBalance >= 2e18) _phaseChanged = true;
303             else if(durationPhaseIndex == 2 && airdropBalance >= 3e18) _phaseChanged = true;
304             else if(durationPhaseIndex == 3 && airdropBalance >= 5e18) _phaseChanged = true;
305             else if(durationPhaseIndex == 4 && airdropBalance >= 7e18) _phaseChanged = true;
306             else if(durationPhaseIndex == 5 && airdropBalance >= 1e19) _phaseChanged = true;
307             if(_phaseChanged) {
308                 durationPhaseIndex ++;
309                 duration = durationPhaseArray[durationPhaseIndex];
310                 deadline = now + duration * 1 minutes;
311             }
312             
313 		}
314 		
315 		// Staking weight calculation
316 		uint256 weight = amount.mul(1e7).div(keyPrice);
317 		players[msg.sender].weight += weight;
318 		uint256 originalPoolSegment = poolWeight / ((5e5).mul(1e7));
319 		poolWeight += weight;
320 		uint256 afterPoolSegment = poolWeight / ((5e5).mul(1e7));
321 		
322 		// Different Segment => giveout potReserve, every 1e5 keys
323 		potReserve += amount * 1 / 100;
324 		bool _potReserveGive = false;
325 		uint256 _potReserve = potReserve;
326 		if(originalPoolSegment != afterPoolSegment) {
327 		    _potReserveGive = true;
328 		    players[msg.sender].balance += potReserve;
329 		    players[msg.sender].potBonus += potReserve;
330 		    poolReward += potReserve;
331 		    potReserve = 0;
332 		}
333 		
334 		// Grow key price
335 		if(keyPrice < keyPrice_max) {
336 		    keyPrice = keyPrice_max - (1e23 - poolBalance).mul(keyPrice_max - keyPrice_min).div(1e23);
337 		} else {
338 		    keyPrice = keyPrice_max;
339 		}
340 		keyLocked = false;
341 		emit Deposit(
342 		    msg.sender,
343 		    weight,
344 		    keyPrice,
345 		    deadline,
346 		    durationPhaseIndex,
347 		    _phaseChanged,
348 		    poolBalance,
349 		    poolReward,
350 		    poolWeight,
351 		    airdropped,
352 		    airdropBalance,
353 		    _potReserveGive,
354 		    _potReserve
355         );
356     }
357     uint256 nonce = 0;
358     function rand(uint min, uint max) private returns (uint){
359         nonce++;
360         return uint(keccak256(toBytes(nonce)))%(min+max)-min;
361     }
362     function toBytes(uint256 x) private pure returns (bytes b) {
363         b = new bytes(32);
364         assembly { mstore(add(b, 32), x) }
365     }
366     /**
367      * Withdraw the funds
368      */
369     function safeWithdrawal() isHuman() public {
370         uint256 availableWithdrawal = players[msg.sender].balance - players[msg.sender].withdrawal;
371         require(availableWithdrawal > 0);
372         require(keyLocked == false);
373         keyLocked = true;
374         poolWithdraw += availableWithdrawal;
375         players[msg.sender].withdrawal += availableWithdrawal;
376         msg.sender.transfer(availableWithdrawal);
377         keyLocked = false;
378         emit Withdrawal(msg.sender, availableWithdrawal);
379     }
380     function helpWithdrawal(address userAddress) isHuman() public {
381         // Will only be executed when user himself cannot withdraw and asks our team for help
382         require(msg.sender == teamAddress);
383         uint256 availableWithdrawal = players[userAddress].balance - players[userAddress].withdrawal;
384         require(availableWithdrawal > 0);
385         require(keyLocked == false);
386         keyLocked = true;
387         poolWithdraw += availableWithdrawal;
388         players[userAddress].withdrawal += availableWithdrawal;
389         // Service fee: 5%
390         players[teamAddress].balance += availableWithdrawal * 5 / 100;
391         // User get 95%
392         userAddress.transfer(availableWithdrawal * 95 / 100);
393         keyLocked = false;
394         emit Withdrawal(userAddress, availableWithdrawal);
395     }
396 
397 }
398 
399 /**
400  * @title SafeMath
401  * @dev Math operations with safety checks that throw on error
402  */
403 library SafeMath {
404 
405   /**
406   * @dev Multiplies two numbers, throws on overflow.
407   */
408   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
409     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
410     // benefit is lost if 'b' is also tested.
411     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
412     if (a == 0) {
413       return 0;
414     }
415 
416     c = a * b;
417     assert(c / a == b);
418     return c;
419   }
420 
421   /**
422   * @dev Integer division of two numbers, truncating the quotient.
423   */
424   function div(uint256 a, uint256 b) internal pure returns (uint256) {
425     // assert(b > 0); // Solidity automatically throws when dividing by 0
426     // uint256 c = a / b;
427     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
428     return a / b;
429   }
430 
431   /**
432   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
433   */
434   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
435     assert(b <= a);
436     return a - b;
437   }
438 
439   /**
440   * @dev Adds two numbers, throws on overflow.
441   */
442   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
443     c = a + b;
444     assert(c >= a);
445     return c;
446   }
447 }