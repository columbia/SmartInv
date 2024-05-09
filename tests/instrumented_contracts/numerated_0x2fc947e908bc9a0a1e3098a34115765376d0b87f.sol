1 /**
2  * GAMBLX JACKPOT CONTRACT
3  *
4  * Unlike traditional casinos with a house edge, at GAMBLX, our unique game mechanics system eliminates the house edge. This means (f.e.) you can enjoy up to an 80% chance to win X2 bets, depending on the round. Imagine the possibilities - with a total pool of $2800, a mere $40 bet can grant you a 50% chance to win, particularly during rounds with high bonus pools and smaller bets. Say goodbye to always losing – at GAMBLX, you have the advantage!
5  * 50% of token volume tax funds are automatically added to jackpot rounds as bonus pools.
6  * Additionally, 30% of total casino revenue is shared randomly into game pools, and 10% of casino revenue is used for token buyback at random interval.
7  * The token is deflationary, with 5% of tokens from tax volume being burned automatically.
8  * Holders of the token become part owners of the casino, receiving 30% of casino revenue and 20% of token tax fees through the Revenue Share Program.
9  * Return to Player (RTP) can reach up to +1000%, depending on the round and bonus pool. Players can even apply their skills to calculate the best timing to join game.
10  * Fully decentralized, winners for each round are automatically chosen using our smart contract provable fair system.
11  * 10% of each game pool contributes to casino revenue, and 30% of this revenue is shared with token holders through the Revenue Share system.
12  *
13  *
14  * At GamblX, we believe in provably fair gaming. Every game, bet, and winner can be verified, as our smart contract automatically selects winners at the end of each game, leaving no room for human intervention.
15  * As we expand our offerings, players can expect a diverse range of games designed to cater to all interests and preferences. From classic casino games with a blockchain twist to groundbreaking and unique creations, each game promises a seamless and transparent gaming experience.
16  * Our new games will feature provably fair mechanics, ensuring that players can verify the fairness of every outcome independently. The blockchain's decentralized nature provides added security and trust, ensuring that the integrity of the games remains uncompromised.
17  * Whether you are a seasoned gambler or a newcomer to the world of blockchain gaming, our upcoming releases will captivate and entertain you. Prepare to embark on an unforgettable journey, where thrilling gameplay and blockchain technology converge to create an unparalleled gaming adventure.
18  * GamblX invites players to join our revolution in the gambling world, where trust, fairness, and exhilarating gaming experiences converge. Embrace the advantage and explore the endless possibilities of winning with GamblX.
19  *
20  *
21  * Website: https://gamblx.com
22  * Twitter: https://twitter.com/gamblx_com
23  * Telegram: https://t.me/gamblx_com
24  * Medium: https://medium.com/@gamblx/
25  * Discord: https://discord.com/invite/bFfwwTYE
26  * Docs: https://gamblx.gitbook.io/info
27  * 
28  * 
29 */
30 
31 // SPDX-License-Identifier: MIT
32 
33 pragma solidity 0.8.21;
34 
35 contract GamblxJackpot {
36     /**
37     * @dev Write to log info about the new game.
38     *
39     * @param _game Game number.
40     * @param _time Time when game stated.
41     */
42     event Game(uint _game, uint indexed _time);
43 
44     struct Bet {
45         address addr;
46         uint256 ticketstart;
47         uint256 ticketend;
48     }
49     mapping (uint256 => mapping (uint256 => Bet)) public bets;
50     mapping (uint256 => uint256) public totalBets;
51 
52     //winning tickets history
53     mapping (uint256 => uint256) public ticketHistory;
54 
55     //winning address history
56     mapping (uint256 => address) public winnerHistory;
57     
58     // Game fee.
59     uint8 public fee = 10;
60     // Current game number.
61     uint public game;
62     // Min eth deposit jackpot
63     uint public minethjoin = 0.001 ether;
64 
65     // Game status
66     // 0 = running
67     // 1 = stop to show winners animation
68 	
69     uint public gamestatus = 0;
70 
71     // All-time game jackpot.
72     uint public allTimeJackpot = 0;
73     // All-time game players count
74     uint public allTimePlayers = 0;
75     
76     // Game status.
77     bool public isActive = true;
78     // The variable that indicates game status switching.
79     bool public toogleStatus = false;
80     // The array of all games
81     uint[] public games;
82     
83     // Store game jackpot.
84     mapping(uint => uint) jackpot;
85     // Store game players.
86     mapping(uint => address[]) players;
87     // Store total tickets for each game
88     mapping(uint => uint) tickets;
89     // Store bonus pool jackpot.
90     mapping(uint => uint) bonuspool;
91     // Store game start block number.
92     mapping(uint => uint) gamestartblock;
93 
94     address payable owner;
95 
96     uint counter = 1;
97 
98     /**
99     * @dev Check sender address and compare it to an owner.
100     */
101     modifier onlyOwner() {
102         require(
103             msg.sender == owner,
104             "Only owner can call this function."
105         );
106         _;
107     }
108 
109     /**
110     * @dev Initialize game.
111     * @dev Create ownable and stats aggregator instances, 
112     * @dev set funds distributor contract address.
113     *
114     */
115 
116     constructor() 
117     {
118         owner = payable(msg.sender);
119         startGame();
120     }
121 
122     /**
123     * @dev The method that allows buying tickets by directly sending ether to the contract.
124     */
125     function addBonus() public payable {
126         bonuspool[game] += msg.value;
127     }
128 
129     
130     function playerticketstart(uint _gameid, uint _pid) public view returns (uint256) {
131         return bets[_gameid][_pid].ticketstart;
132     }
133 
134     function playerticketend(uint _gameid, uint _pid) public view returns (uint256) {
135         return bets[_gameid][_pid].ticketend;
136     }
137 
138     function totaltickets(uint _uint) public view returns (uint256) {
139         return tickets[_uint];
140     }
141 
142     function playeraddr(uint _gameid, uint _pid) public view returns (address) {
143         return bets[_gameid][_pid].addr;
144     }
145 
146 
147     /**
148     * @dev Returns current game players.
149     */
150     function getPlayedGamePlayers() 
151         public
152         view
153         returns (uint)
154     {
155         return getPlayersInGame(game);
156     }
157 
158     /**
159     * @dev Get players by game.
160     *
161     * @param playedGame Game number.
162     */
163     function getPlayersInGame(uint playedGame) 
164         public 
165         view
166         returns (uint)
167     {
168         return players[playedGame].length;
169     }
170 
171     /**
172     * @dev Returns current game jackpot.
173     */
174     function getPlayedGameJackpot() 
175         public 
176         view
177         returns (uint) 
178     {
179         return getGameJackpot(game);
180     }
181     
182     /**
183     * @dev Get jackpot by game number.
184     *
185     * @param playedGame The number of the played game.
186     */
187     function getGameJackpot(uint playedGame) 
188         public 
189         view 
190         returns(uint)
191     {
192         return jackpot[playedGame]+bonuspool[playedGame];
193     }
194 
195     /**
196     * @dev Get bonus pool by game number.
197     *
198     * @param playedGame The number of the played game.
199     */
200     function getBonusPool(uint playedGame) 
201         public 
202         view 
203         returns(uint)
204     {
205         return bonuspool[playedGame];
206     }
207 
208 
209     /**
210     * @dev Get game start block by game number.
211     *
212     * @param playedGame The number of the played game.
213     */
214     function getGamestartblock(uint playedGame) 
215         public 
216         view 
217         returns(uint)
218     {
219         return gamestartblock[playedGame];
220     }
221 
222     /**
223     * @dev Get total ticket for game
224     */
225     function getGameTotalTickets(uint playedGame) 
226         public 
227         view 
228         returns(uint)
229     {
230         return tickets[playedGame];
231     }
232     
233     /**
234     * @dev Start the new game.
235     */
236     function start() public onlyOwner() {
237         if (players[game].length > 0) {
238             pickTheWinner();
239         } else {
240             bonuspool[game + 1] = bonuspool[game];
241         }
242         gamestatus = 1;
243         startGame();
244     }
245 
246     /**
247     * @dev Start the new game.
248     */
249     function setGamestatusZero() public onlyOwner() {
250         gamestatus = 0;
251     }
252 
253     /**
254     * @dev Get random number. It cant be influenced by anyone
255     * @dev Random number calculation depends on block timestamp,
256     * @dev difficulty, counter and jackpot players length.
257     *
258     */
259     function randomNumber(
260         uint number
261     ) 
262         internal
263         returns (uint) 
264     {
265         counter++;
266         uint random = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, counter, players[game].length, gasleft()))) % number;
267        return random + 1;
268     }
269     
270     /**
271     * @dev The payable method that accepts ether and adds the player to the jackpot game.
272     */
273     function enterJackpot() public payable {
274         require(msg.sender == tx.origin);
275         require(isActive);
276         require(gamestatus == 0);
277         require(msg.value >= minethjoin);
278 
279         uint newtotalstr = totalBets[game];
280         bets[game][newtotalstr].addr = address(msg.sender);
281         bets[game][newtotalstr].ticketstart = tickets[game]+1;
282         bets[game][newtotalstr].ticketend = ((tickets[game]+1)+(msg.value/(1000000000000000)))-1;
283 
284         totalBets[game] += 1;
285         jackpot[game] += msg.value;
286         tickets[game] += msg.value/1000000000000000;
287 
288         
289         players[game].push(msg.sender);
290     }
291 
292     /**
293     * @dev Start the new game.
294     * @dev Checks game status changes, if exists request for changing game status game status 
295     * @dev will be changed.
296     */
297     function startGame() internal {
298         require(isActive);
299 
300         game += 1;
301         if (toogleStatus) {
302             isActive = !isActive;
303             toogleStatus = false;
304         }
305         gamestartblock[game] = block.timestamp;
306         emit Game(game, block.timestamp);
307     }
308 
309     /**
310     * @dev Pick the winner using random number provably fair function.
311     */
312     function pickTheWinner() internal {
313         uint winner;
314         uint toPlayer;
315         if (players[game].length == 1) {
316             toPlayer = jackpot[game] + bonuspool[game];
317             payable(players[game][0]).transfer(toPlayer);
318             winner = 0;
319             ticketHistory[game] = 1;
320             winnerHistory[game] = players[game][0];
321         } else {
322             winner = randomNumber(tickets[game]); //winning ticket
323             uint256 lookingforticket = winner;
324             address ticketwinner;
325             for(uint8 i=0; i<= totalBets[game]; i++){
326                 address addr = bets[game][i].addr;
327                 uint256 ticketstart = bets[game][i].ticketstart;
328                 uint256 ticketend = bets[game][i].ticketend;
329                 if (lookingforticket >= ticketstart && lookingforticket <= ticketend){
330                     ticketwinner = addr; //finding winner address
331                 }
332             }
333 
334             ticketHistory[game] = lookingforticket;
335             winnerHistory[game] = ticketwinner;
336         
337             uint distribute = (jackpot[game] + bonuspool[game]) * fee / 100; //game fee
338             uint toTaxwallet = distribute * 99 / 100;
339             toPlayer = (jackpot[game] + bonuspool[game]) - distribute;
340             payable(address(0x54557f6873e31D4FB45562c93753936EB298c1CB)).transfer(toTaxwallet); //send 10% game fee
341             payable(ticketwinner).transfer(toPlayer); //send prize to winner
342         }
343     
344 
345         allTimeJackpot += toPlayer;
346         allTimePlayers += players[game].length;
347     }
348 
349 
350 }