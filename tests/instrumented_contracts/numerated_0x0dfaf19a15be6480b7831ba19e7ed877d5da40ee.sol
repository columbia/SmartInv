1 contract Owner {
2     address public owner;
3 
4     modifier onlyOwner() {
5         require(msg.sender == owner);
6         _;
7     }
8 
9     function Owner(address _owner) public {
10         owner = _owner;
11     }
12 
13     function changeOwner(address _newOwnerAddr) public onlyOwner {
14         require(_newOwnerAddr != address(0));
15         owner = _newOwnerAddr;
16     }
17 }
18 
19 contract XPOT is Owner {
20     
21     event Game(uint _game, uint indexed _time);
22 
23     event Ticket(
24         address indexed _address,
25         uint indexed _game,
26         uint _number,
27         uint _time
28     );
29     
30     // Game fee.
31     uint8 public fee = 10;
32     // Current game number.
33     uint public game;
34     // Ticket price.
35     uint public ticketPrice = 0.01 ether;
36     // New ticket price.
37     uint public newPrice;
38     // All-time game jackpot.
39     uint public allTimeJackpot = 0;
40     // All-time game players count
41     uint public allTimePlayers = 0;
42     
43     // Game status.
44     bool public isActive = true;
45     // The variable that indicates game status switching.
46     bool public toogleStatus = false;
47     // The array of all games
48     uint[] public games;
49     
50     // Store game jackpot.
51     mapping(uint => uint) jackpot;
52     // Store game players.
53     mapping(uint => address[]) players;
54     
55     // Funds distributor address.
56     address public fundsDistributor;
57 
58     /**
59     * @dev Check sender address and compare it to an owner.
60     */
61     modifier onlyOwner() {
62         require(msg.sender == owner);
63         _;
64     }
65     
66     function XPOT(
67         address distributor
68     ) 
69      public Owner(msg.sender)
70     {
71         fundsDistributor = distributor;
72         startGame();
73     }
74 
75     function() public payable {
76         buyTicket(address(0));
77     }
78 
79     function getPlayedGamePlayers() 
80         public
81         view
82         returns (uint)
83     {
84         return getPlayersInGame(game);
85     }
86 
87     function getPlayersInGame(uint playedGame) 
88         public 
89         view
90         returns (uint)
91     {
92         return players[playedGame].length;
93     }
94 
95     function getPlayedGameJackpot() 
96         public 
97         view
98         returns (uint) 
99     {
100         return getGameJackpot(game);
101     }
102     
103     function getGameJackpot(uint playedGame) 
104         public 
105         view 
106         returns(uint)
107     {
108         return jackpot[playedGame];
109     }
110     
111     function toogleActive() public onlyOwner() {
112         if (!isActive) {
113             isActive = true;
114         } else {
115             toogleStatus = !toogleStatus;
116         }
117     }
118     
119     function start() public onlyOwner() {
120         if (players[game].length > 0) {
121             pickTheWinner();
122         }
123         startGame();
124     }
125 
126     function changeTicketPrice(uint price) 
127         public 
128         onlyOwner() 
129     {
130         newPrice = price;
131     }
132 
133 
134     /**
135     * @dev Get random number.
136     * @dev Random number calculation depends on block timestamp,
137     * @dev difficulty, number and hash.
138     *
139     * @param min Minimal number.
140     * @param max Maximum number.
141     * @param time Timestamp.
142     * @param difficulty Block difficulty.
143     * @param number Block number.
144     * @param bHash Block hash.
145     */
146     function randomNumber(
147         uint min,
148         uint max,
149         uint time,
150         uint difficulty,
151         uint number,
152         bytes32 bHash
153     ) 
154         public 
155         pure 
156         returns (uint) 
157     {
158         min ++;
159         max ++;
160 
161         uint random = uint(keccak256(
162             time * 
163             difficulty * 
164             number *
165             uint(bHash)
166         ))%10 + 1;
167        
168         uint result = uint(keccak256(random))%(min+max)-min;
169         
170         if (result > max) {
171             result = max;
172         }
173         
174         if (result < min) {
175             result = min;
176         }
177         
178         result--;
179 
180         return result;
181     }
182     
183     /**
184     * @dev The payable method that accepts ether and adds the player to the game.
185     */
186     function buyTicket(address partner) public payable {
187         require(isActive);
188         require(msg.value == ticketPrice);
189         
190         jackpot[game] += msg.value;
191         
192         uint playerNumber =  players[game].length;
193         players[game].push(msg.sender);
194 
195         emit Ticket(msg.sender, game, playerNumber, now);
196     }
197 
198     /**
199     * @dev Start the new game.
200     * @dev Checks ticket price changes, if exists new ticket price the price will be changed.
201     * @dev Checks game status changes, if exists request for changing game status game status 
202     * @dev will be changed.
203     */
204     function startGame() internal {
205         require(isActive);
206 
207         game = block.number;
208         if (newPrice != 0) {
209             ticketPrice = newPrice;
210             newPrice = 0;
211         }
212         if (toogleStatus) {
213             isActive = !isActive;
214             toogleStatus = false;
215         }
216         emit Game(game, now);
217     }
218 
219     /**
220     * @dev Pick the winner.
221     * @dev Check game players, depends on player count provides next logic:
222     * @dev - if in the game is only one player, by game rules the whole jackpot 
223     * @dev without commission returns to him.
224     * @dev - if more than one player smart contract randomly selects one player, 
225     * @dev calculates commission and after that jackpot transfers to the winner,
226     * @dev commision to founders.
227     */
228     function pickTheWinner() internal {
229         uint winner;
230         uint toPlayer;
231         if (players[game].length == 1) {
232             toPlayer = jackpot[game];
233             players[game][0].transfer(jackpot[game]);
234             winner = 0;
235         } else {
236             winner = randomNumber(
237                 0,
238                 players[game].length - 1,
239                 block.timestamp,
240                 block.difficulty,
241                 block.number,
242                 blockhash(block.number - 1)
243             );
244         
245             uint distribute = jackpot[game] * fee / 100;
246             toPlayer = jackpot[game] - distribute;
247             players[game][winner].transfer(toPlayer);
248             fundsDistributor.transfer(distribute);
249         }
250         
251         allTimeJackpot += toPlayer;
252         allTimePlayers += players[game].length;
253     }
254 }