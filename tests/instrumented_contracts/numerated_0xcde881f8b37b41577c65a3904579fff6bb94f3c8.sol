1 pragma solidity ^0.4.19;
2 
3 /* King of the Hill, but with a twist
4 
5 To with the pot, you must obtain 1 million points.
6 You obtain points by becoming and staying the King.
7 To become the King, you must pay 1% of the pot.
8 As the King, you earn (minutes)^2 points, where minutes
9 is the amount of time you remain King.
10 
11 50% of the pot is used as an award, and the other 50%
12 seeds the pot for the next round.
13 
14 20% of bids go to the bonus pot, which is given to the
15 second-place person when someone wins.
16 
17 */
18 
19 contract EthKing {
20 	using SafeMath for uint256;
21 
22 	// ------------------ Events -----------------------------
23 
24 	event NewRound(
25 		uint _timestamp,
26 		uint _round,
27 		uint _initialMainPot,
28 		uint _initialBonusPot
29   );
30 
31 	event NewKingBid(
32 		uint _timestamp,
33 		address _address,
34 		uint _amount,
35 		uint _newMainPot,
36 		uint _newBonusPot
37 	);
38 
39 	event PlaceChange(
40 		uint _timestamp,
41 		address _newFirst,
42 		address _newSecond,
43 		uint _firstPoints,
44 		uint _secondPoints
45 	);
46 
47 	event Winner(
48 		uint _timestamp,
49 		address _first,
50 		uint _firstAmount,
51 		address _second,
52 		uint _secondAmount
53 	);
54 
55 	event EarningsWithdrawal(
56 		uint _timestamp,
57 		address _address,
58 		uint _amount
59 	);
60 
61 	// -------------------------------------------------------
62 
63 	address owner;
64 
65 	// ------------------ Game Constants ---------------------
66 
67 	// Fraction of the previous pot used to seed the next pot
68 	// Currently 50%
69 	uint private constant NEXT_POT_FRAC_TOP = 1;
70 	uint private constant NEXT_POT_FRAC_BOT = 2;
71 
72 	// Minimum fraction of the pot required to become the King
73 	// Currently 0.5%
74 	uint private constant MIN_LEADER_FRAC_TOP = 5;
75 	uint private constant MIN_LEADER_FRAC_BOT = 1000;
76 
77 	// Fraction of each bid used for the bonus pot
78 	uint private constant BONUS_POT_FRAC_TOP = 20;
79 	uint private constant BONUS_POT_FRAC_BOT = 100;
80 
81 	// Fractino of each bid used for the developer fee
82 	uint private constant DEV_FEE_FRAC_TOP = 5;
83 	uint private constant DEV_FEE_FRAC_BOT = 100;
84 
85 	// Exponent for point calculation
86 	// Currently x^2
87 	uint private constant POINT_EXPONENT = 2;
88 
89 	// How many points to win?
90 	uint private constant POINTS_TO_WIN = 1000000;
91 	
92 	// Null address for advancing round
93     address null_address = address(0x0);
94 
95 	// ----------------- Game Variables ----------------------
96 
97 	// The current King, and when he was last put in power
98 	address public king;
99 	uint public crownedTime;
100 
101 	// The current leader and the current 2nd-place leader
102 	address public first;
103 	address public second;
104 
105 	// Player info
106 	struct Player {
107 		uint points;
108 		uint roundLastPlayed;
109 		uint winnings;
110 	}
111 
112 	// Player mapping
113 	mapping (address => Player) private players;
114 
115 	// Current round number
116 	uint public round;
117 
118 	// Value of pot and bonus pot
119 	uint public mainPot;
120 	uint public bonusPot;
121 
122 	// ----------------- Game Logic -------------------------
123 
124 	function EthKing() public payable {
125 		// We should seed the game
126 		require(msg.value > 0);
127 
128 		// Set owner and round
129 		owner = msg.sender;
130 		round = 1;
131 
132 		// Calculate bonus pot and main pot
133 		uint _bonusPot = msg.value.mul(BONUS_POT_FRAC_TOP).div(BONUS_POT_FRAC_BOT);
134 		uint _mainPot = msg.value.sub(_bonusPot);
135 
136 		// Make sure we didn't make a mistake
137 		require(_bonusPot + _mainPot <= msg.value);
138 
139 		mainPot = _mainPot;
140 		bonusPot = _bonusPot;
141 
142 		// Set owner as King
143 		// Crowned upon contract creation
144 		king = owner;
145 		first = null_address;
146 		second = null_address;
147 		crownedTime = now;
148 		players[owner].roundLastPlayed = round;
149         players[owner].points = 0;
150 	}
151 
152 	// Calculate and reward points to the current King
153 	// Should be called when the current King is being kicked out
154 	modifier payoutOldKingPoints {
155 		uint _pointsToAward = calculatePoints(crownedTime, now);
156 		players[king].points = players[king].points.add(_pointsToAward);
157 
158 		// Check to see if King now is in first or second place.
159 		// If second place, just replace second place with King.
160 		// If first place, move first place down to second and King to first
161 		if (players[king].points > players[first].points) {
162 			second = first;
163 			first = king;
164 
165 			PlaceChange(now, first, second, players[first].points, players[second].points);
166 
167 		} else if (players[king].points > players[second].points && king != first) {
168 			second = king;
169 
170 			PlaceChange(now, first, second, players[first].points, players[second].points);
171 		}
172 
173 		_;
174 	}
175 
176 	// Check current leader's points
177 	// Advances the round if he's at 1 million or greater
178 	// Pays out main pot and bonus pot
179 	modifier advanceRoundIfNeeded {
180 		if (players[first].points >= POINTS_TO_WIN) {
181 			// Calculate next pots and winnings
182 			uint _nextMainPot = mainPot.mul(NEXT_POT_FRAC_TOP).div(NEXT_POT_FRAC_BOT);
183 			uint _nextBonusPot = bonusPot.mul(NEXT_POT_FRAC_TOP).div(NEXT_POT_FRAC_BOT);
184 
185 			uint _firstEarnings = mainPot.sub(_nextMainPot);
186 			uint _secondEarnings = bonusPot.sub(_nextBonusPot);
187 
188 			players[first].winnings = players[first].winnings.add(_firstEarnings);
189 			players[second].winnings = players[second].winnings.add(_secondEarnings);
190 
191 			// Advance round
192 			round++;
193 			mainPot = _nextMainPot;
194 			bonusPot = _nextBonusPot;
195 
196 			// Reset first and second and King
197 			first = null_address;
198 			second = null_address;
199 			players[owner].roundLastPlayed = round;
200 			players[owner].points = 0;
201 			players[king].roundLastPlayed = round;
202 			players[king].points = 0;
203 			king = owner;
204 			crownedTime = now;
205 
206 			NewRound(now, round, mainPot, bonusPot);
207 			PlaceChange(now, first, second, players[first].points, players[second].points);
208 		}
209 
210 		_;
211 	}
212 
213 	// Calculates the points a player earned in a given timer interval
214 	function calculatePoints(uint _earlierTime, uint _laterTime) private pure returns (uint) {
215 		// Earlier time could be the same as latertime (same block)
216 		// But it should never be later than laterTime!
217 		assert(_earlierTime <= _laterTime);
218 
219 		// If crowned and dethroned on same block, no points
220 		if (_earlierTime == _laterTime) { return 0; }
221 
222 		// Calculate points. Less than 1 minute is no payout
223 		uint timeElapsedInSeconds = _laterTime.sub(_earlierTime);
224 		if (timeElapsedInSeconds < 60) { return 0; }
225 
226 		uint timeElapsedInMinutes = timeElapsedInSeconds.div(60);
227 		assert(timeElapsedInMinutes > 0);
228 
229 		// 1000 minutes is an automatic win.
230 		if (timeElapsedInMinutes >= 1000) { return POINTS_TO_WIN; }
231 
232 		return timeElapsedInMinutes**POINT_EXPONENT;
233 	}
234 
235 	// Pays out current King
236 	// Advances round, if necessary
237 	// Makes sender King
238 	// Reverts if bid isn't high enough
239 	function becomeKing() public payable
240 		payoutOldKingPoints
241 		advanceRoundIfNeeded
242 	{
243 		// Calculate minimum bid amount
244 		uint _minLeaderAmount = mainPot.mul(MIN_LEADER_FRAC_TOP).div(MIN_LEADER_FRAC_BOT);
245 		require(msg.value >= _minLeaderAmount);
246 
247 		uint _bidAmountToDeveloper = msg.value.mul(DEV_FEE_FRAC_TOP).div(DEV_FEE_FRAC_BOT);
248 		uint _bidAmountToBonusPot = msg.value.mul(BONUS_POT_FRAC_TOP).div(BONUS_POT_FRAC_BOT);
249 		uint _bidAmountToMainPot = msg.value.sub(_bidAmountToDeveloper).sub(_bidAmountToBonusPot);
250 
251 		assert(_bidAmountToDeveloper + _bidAmountToBonusPot + _bidAmountToMainPot <= msg.value);
252 
253 		// Transfer dev fee to owner's winnings
254 		players[owner].winnings = players[owner].winnings.add(_bidAmountToDeveloper);
255 
256 		// Set new pot values
257 		mainPot = mainPot.add(_bidAmountToMainPot);
258 		bonusPot = bonusPot.add(_bidAmountToBonusPot);
259 
260 		// Clear out King's points if they are from last round
261 		if (players[king].roundLastPlayed != round) {
262 			players[king].points = 0;	
263 		}
264 		
265 		// Set King
266 		king = msg.sender;
267 		players[king].roundLastPlayed = round;
268 		crownedTime = now;
269 
270 		NewKingBid(now, king, msg.value, mainPot, bonusPot);
271 	}
272 
273 	// Transfer players their winnings
274 	function withdrawEarnings() public {
275 		require(players[msg.sender].winnings > 0);
276 		assert(players[msg.sender].winnings <= this.balance);
277 
278 		uint _amount = players[msg.sender].winnings;
279 		players[msg.sender].winnings = 0;
280 
281 		EarningsWithdrawal(now, msg.sender, _amount);
282 
283 		msg.sender.transfer(_amount);
284 	}
285 
286 	// Fallback function.
287 	// If 0 ether, triggers tryAdvance()
288 	// If > 0 ether, triggers becomeKing()
289 	function () public payable {
290 		if (msg.value == 0) { tryAdvance(); }
291 		else { becomeKing(); }
292 	}
293 
294 	// Utility function to advance the round / payout the winner
295 	function tryAdvance() public {
296 		// Calculate the King's current points.
297 		// If he's won, we payout and advance the round.
298 		// Equivalent to a bid, but without an actual bid.
299 		uint kingTotalPoints = calculatePoints(crownedTime, now) + players[king].points;
300 		if (kingTotalPoints >= POINTS_TO_WIN) { forceAdvance(); }
301 	}
302 
303 	// Internal function called by tryAdvance if current King has won
304 	function forceAdvance() private payoutOldKingPoints advanceRoundIfNeeded { }
305 	
306 	// Gets a player's information
307 	function getPlayerInfo(address _player) public constant returns(uint, uint, uint) {
308 		return (players[_player].points, players[_player].roundLastPlayed, players[_player].winnings);
309 	}
310 	
311 	// Gets the sender's information
312 	function getMyInfo() public constant returns(uint, uint, uint) {
313 		return getPlayerInfo(msg.sender);		
314 	}
315 	
316 	// Get the King's current points
317 	function getKingPoints() public constant returns(uint) { return players[king].points; }
318 	
319 	// Get the first player's current points
320 	function getFirstPoints() public constant returns(uint) { return players[first].points; }
321 	
322 	// Get the second player's current points
323 	function getSecondPoints() public constant returns(uint) { return players[second].points; }
324 }
325 
326 /**
327  * @title SafeMath
328  * @dev Math operations with safety checks that throw on error
329  */
330 library SafeMath {
331     /**
332     * @dev Multiplies two numbers, throws on overflow.
333     */
334     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
335         if (a == 0) {
336             return 0;
337         }
338         uint256 c = a * b;
339         assert(c / a == b);
340         return c;
341     }
342 
343     /**
344     * @dev Integer division of two numbers, truncating the quotient.
345     */
346     function div(uint256 a, uint256 b) internal pure returns (uint256) {
347         // assert(b > 0); // Solidity automatically throws when dividing by 0
348         uint256 c = a / b;
349         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
350         return c;
351     }
352 
353     /**
354     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
355     */
356     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
357         assert(b <= a);
358         return a - b;
359     }
360 
361     /**
362     * @dev Adds two numbers, throws on overflow.
363     */
364     function add(uint256 a, uint256 b) internal pure returns (uint256) {
365         uint256 c = a + b;
366         assert(c >= a);
367         return c;
368     }
369 }