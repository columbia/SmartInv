1 contract owned {
2     address public owner;
3     
4     function owned() {
5         owner = msg.sender;
6     }
7     
8     function setOwner(address _new) onlyOwner {
9         owner = _new;
10     }
11     
12     modifier onlyOwner {
13         if (msg.sender != owner) throw;
14     }
15 }
16 
17 contract TheGrid is owned {
18 	// The number of the game
19 	uint public gameId = 1;
20 	// The size of the grid. It will start at 3 and increase
21     uint public size = 4;
22 	uint public nextsize = 5;
23 	// Number of empty spots. Reaching 0 will create next game
24     uint public empty = 16;
25     
26 	// The micro of the owners benefit, i.e. it will gain
27 	// money / 1000000 * benefitMicros.
28     uint public benefitMicros = 24900;
29 	// The current price for one spot of the grid
30     uint public price = 100 finney;
31 	// The price to start with for one spot
32 	uint public startPrice = 100 finney;
33 	// Micros of the price increase after buy, i.e after each buy
34 	// the price will be old / 1000000 * priceIncrease
35 	uint public priceIncrease = 15000;
36 	// The win for this game
37     uint public win;
38     
39 	// A mapping of the pending payouts
40 	mapping(address => uint) public pendingPayouts;
41 	uint public totalPayouts;
42 	// A mapping of the points gained in this game
43     mapping(address => uint) public balanceOf;
44     uint public totalSupply;
45     
46 	// State of the grid. Positions are encoded as _x*size+_y.
47     address[] public theGrid;
48 	// A list of all players, needed for payouts.
49     address[] public players;
50 	// The last player who played. Not allowed to play next turn too.
51 	address public lastPlayer;
52 	
53 	// The timeout interval
54 	uint public timeout = 6 hours;
55 	// Timestamp of the timeout if no one plays before
56 	uint public timeoutAt;
57     
58 	// Will be triggered on the end of each game
59 	event GameEnded(uint indexed gameId, uint win, uint totalPoints);
60 	// Will be triggered on each start of a game
61 	event GameStart(uint indexed gameId, uint size);
62 	// Will be triggered on each bought position
63 	event PositionBought(uint indexed gameId, uint indexed moveNo,
64 						 uint where, address who, uint pointsGained, 
65 						 uint etherPaid);
66 	// Will be triggered on each timeout!
67 	event Timeout(uint indexed gameId, uint indexed moveNo);
68 	// Will be triggered on each payout withdraw
69 	event Collect(address indexed who, uint value);
70 	
71     function TheGrid() {
72 		// Setting the length of theGrid and timeout
73         theGrid.length = empty;        
74 		timeoutAt = now + timeout;
75 		GameStart(gameId, size);
76     }
77 	
78 	// The direction count counts the positions hold by this player in ONE
79 	// direction, i.e. to determine a line length you have to call it twice
80 	// (one time for north direction, one time for south by example)
81 	function directionCount(int _x, int _y, int _dx, int _dy)
82 			internal returns (uint) {
83 		var found = uint(0);
84 		var s = int(size);
85 		_x += _dx;
86 		_y += _dy;
87 		// While still on the grid...
88 		while (_x < s && _y < s && _x >= 0 && _y >= 0) {
89 			// If it is the sender, gain point, else break
90 			if (theGrid[getIndex(uint(_x), uint(_y))] == msg.sender) {
91 				found ++;
92 			} else {
93 				break;
94 			}
95 			// Go to next position
96 			_x += _dx;
97 			_y += _dy;
98 		}
99 		return found;
100 	}
101     
102     /// Buy the spot at _x, _y if it is available and gain points for every
103     /// connected spot of your color sharing lines with this spot.
104     function buy(uint _x, uint _y) {
105 		// Has to be an available position (getIndex will throw off-grid)
106         if (theGrid[getIndex(_x, _y)] != 0) throw;
107 		// No one is allowed to play two token right after each other
108 		if (msg.sender == lastPlayer) throw;
109 		// If there is a timeout, divide the price by two and let the
110 		// next game start at 3 again.
111 		if (now > timeoutAt) {
112 			price = price / 2;
113 			// 1 finney is the lowest acceptable price. It makes sure the
114 			// calculation of a players share never becomes 0.
115 			if (price < 1 finney) price = 1 finney;
116 			nextsize = 3;
117 			Timeout(gameId, size*size - empty + 1);
118 		}
119 		// If more than the price per position is sended, add it to the
120 		// payouts so it can be withdrawn later
121 		if (msg.value < price) {
122 			throw;
123 		} else {
124 			// The owner of the contract gets a little benefit
125 			// The sender gets back the overhead
126 			var benefit = price / 1000000 * benefitMicros;
127 			if (pendingPayouts[owner] + benefit < pendingPayouts[owner]) throw;
128 			pendingPayouts[owner] += benefit;
129 			if (pendingPayouts[msg.sender] + msg.value - price < pendingPayouts[msg.sender]) throw;
130 			pendingPayouts[msg.sender] += msg.value - price;
131 			if (totalPayouts + msg.value - price + benefit < totalPayouts) throw;
132 			totalPayouts += msg.value - price + benefit;
133 			// Add the price to the win
134 			if (win + price - benefit < win) throw;
135 			win += price - benefit;
136 		}
137 
138         // Set the position to this address
139         empty --;
140         theGrid[getIndex(_x, _y)] = msg.sender;
141         
142         // Add player on first time and give him his one joining point
143         var found = uint(0);
144 		if (balanceOf[msg.sender] == 0) {
145             players.push(msg.sender);
146 			found = 1;
147         }
148         
149         // Discover linear connected spots and give the buyer the square
150 		// of the lines lengths as points. See the rules.
151 		
152 		var x = int(_x);
153 		var y = int(_y);
154 		
155 		// East to west
156 		var a = 1 + directionCount(x, y, 1, 0) + directionCount(x, y, -1, 0);
157 		if (a >= 3) {
158 			found += a * a;
159 		}
160 		
161 		// North east to south west
162 		a = 1 + directionCount(x, y, 1, 1) + directionCount(x, y, -1, -1);
163 		if (a >= 3) {
164 			found += a * a;
165 		}
166 		
167 		// North to south
168 		a = 1 + directionCount(x, y, 0, 1) + directionCount(x, y, 0, -1);
169 		if (a >= 3) {
170 			found += a * a;
171 		}
172 		
173 		// North west to south east
174 		a = 1 + directionCount(x, y, 1, -1) + directionCount(x, y, -1, 1);
175 		if (a >= 3) {
176 			found += a * a;
177 		}
178         
179         // Add points
180 		if (balanceOf[msg.sender] + found < balanceOf[msg.sender]) throw;
181         balanceOf[msg.sender] += found;
182 		if (totalSupply + found < totalSupply) throw;
183         totalSupply += found;
184 		
185 		// Trigger event before the price increases!
186 		PositionBought(gameId, size*size-empty, getIndex(_x, _y), msg.sender, found, price);
187 		
188 		// Increase the price per position by the price Increase
189 		price = price / 1000000 * (1000000 + priceIncrease);
190 		
191 		// Set new timeout and last player played
192 		timeoutAt = now + timeout;
193 		lastPlayer = msg.sender;
194 		
195 		// If this was the last empty position, initiate next game
196         if (empty == 0) nextRound();
197     }
198 	
199 	/// Collect your pending payouts using this method
200 	function collect() {
201 		var balance = pendingPayouts[msg.sender];
202 		pendingPayouts[msg.sender] = 0;
203 		totalPayouts -= balance;
204 		if (!msg.sender.send(balance)) throw;
205 		Collect(msg.sender, balance);
206 	}
207     
208 	// Returns the in array index of one position and throws on
209 	// off-grid position
210     function getIndex(uint _x, uint _y) internal returns (uint) {
211         if (_x >= size) throw;
212         if (_y >= size) throw;
213 		return _x * size + _y;
214     }
215     
216 	// Will initiate the next game by clearing most of the data
217 	// and calculating the payouts.
218     function nextRound() internal {
219         GameEnded(gameId, win, totalSupply);
220 		// Calculate share per point
221 		if (totalPayouts + win < totalPayouts) throw;
222 		totalPayouts += win;
223 		// If the totalSupply is 0, no one played, so no one can gain a share
224 		// The maximum total Supply is lower than 1.1e9, so the share can't
225 		// become 0 because of a too high totalSupply, as a finney is still
226 		// bigger.
227 		var share = totalSupply == 0 ? 0 : win / totalSupply;
228         // Send balances to the payouts
229 		// If the win was not dividable by the number of points, it is kept
230 		// for the next game. Most properly only some wei.
231         for (var i = 0; i < players.length; i++) {
232 			var amount = share * balanceOf[players[i]];
233 			totalSupply -= balanceOf[players[i]];
234 			balanceOf[players[i]] = 0;
235 			if (pendingPayouts[players[i]] + amount < pendingPayouts[players[i]]) throw;
236             pendingPayouts[players[i]] += amount;
237 			win -= amount;
238         }
239 		
240         
241         // Delete positions and player
242         delete theGrid;
243         delete players;
244 		lastPlayer = 0x0;
245 		// The next game will be a bit bigger, but limit it to 64.
246         size = nextsize;
247 		if (nextsize < 64) nextsize ++;
248 		gameId ++;
249 		// Calculate empty spots
250         empty = size * size;
251 		theGrid.length = empty;
252 		// Reset the price
253 		price = startPrice;
254 		
255 		GameStart(gameId, size);
256     }
257 }