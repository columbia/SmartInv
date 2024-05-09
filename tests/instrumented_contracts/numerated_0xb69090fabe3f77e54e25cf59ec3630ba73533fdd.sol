1 pragma solidity ^0.4.17;
2 
3 contract Blockgame {
4 
5   uint public ENTRY_FEE = 0.075 ether;
6   uint public POINTS_TO_SPEND = 150;
7   uint public TEAMS_PER_ENTRY = 6;
8   uint public MAX_ENTRIES = 200;
9 
10   address public owner;
11   uint[6] public payoutPercentages;
12   uint public debt;
13 
14   uint[] public allTeamsCosts;
15   uint[] public allTeamsScores;
16 
17   DailyGame[] public allTimeGames;
18   mapping(uint => bool) public gamesList;
19   mapping(uint => DailyGame) public gameRecords; // uint == dateOfGame
20   mapping(address => uint) public availableWinnings;
21 
22   event NewEntry(address indexed player, uint[] selectedTeams);
23 
24   struct Entry {
25     uint timestamp;
26     uint[] teamsSelected;
27     address player;
28     uint entryIndex;
29   }
30 
31   // Pre and post summary
32   struct DailyGame {
33     uint numPlayers;
34     uint pool;
35     uint date;
36     uint closedTime;
37     uint[] playerScores; // A
38     uint[] topPlayersScores; // B
39     uint[] winnerAmounts; // C
40     address[] players; // A
41     uint[] topPlayersIndices; // B
42     address[] topPlayersAddresses; // B
43     address[] winnerAddresses; // C
44     Entry[] entries;
45   }
46 
47   constructor(){
48     owner = msg.sender;
49 
50     payoutPercentages[0] = 0;
51     payoutPercentages[1] = 50;
52     payoutPercentages[2] = 16;
53     payoutPercentages[3] = 12;
54     payoutPercentages[4] = 8;
55     payoutPercentages[5] = 4;
56   }
57 
58 
59   //UTILITIES
60   function() external payable { }
61 
62   modifier onlyOwner {
63     require(msg.sender == owner);
64     _;
65   }
66 
67   function changeEntryFee(uint _value) onlyOwner {
68     ENTRY_FEE = _value;
69   }
70 
71   function changeMaxEntries(uint _value) onlyOwner {
72     MAX_ENTRIES = _value;
73   }
74 
75   //submit alphabetically
76   function changeTeamCosts(uint[] _costs) onlyOwner {
77     allTeamsCosts = _costs;
78   }
79 
80   function changeAvailableSpend(uint _value) onlyOwner {
81     POINTS_TO_SPEND = _value;
82   }
83 
84   // _closedTime == Unix timestamp
85   function createGame(uint _gameDate, uint _closedTime) onlyOwner {
86     gamesList[_gameDate] = true;
87     gameRecords[_gameDate].closedTime = _closedTime;
88   }
89 
90   function withdraw(uint amount) onlyOwner returns(bool) {
91     require(amount <= (address(this).balance - debt));
92     owner.transfer(amount);
93     return true;
94   }
95 
96   function selfDestruct() onlyOwner {
97     selfdestruct(owner);
98   }
99 
100 
101   // SUBMITTING AN ENTRY
102 
103   // Verify that game exists
104   modifier gameOpen(uint _gameDate) {
105     require(gamesList[_gameDate] == true);
106     _;
107   }
108 
109   // Verify that teams selection is within cost
110   modifier withinCost(uint[] teamIndices) {
111       require(teamIndices.length == 6);
112       uint sum = 0;
113 
114       for(uint i = 0;i < 6; i++){
115         uint cost = allTeamsCosts[teamIndices[i]];
116         sum += cost;
117       }
118 
119       require(sum <= POINTS_TO_SPEND);
120       _;
121   }
122 
123   // Verify that constest hasn't closed
124   modifier beforeCutoff(uint _date) {
125     require(gameRecords[_date].closedTime > currentTime());
126     _;
127   }
128 
129   function createEntry(uint date, uint[] teamIndices) payable
130                        withinCost(teamIndices)
131                        gameOpen(date)
132                        beforeCutoff(date)
133                        external {
134 
135     require(msg.value == ENTRY_FEE);
136     require(gameRecords[date].numPlayers < MAX_ENTRIES);
137 
138     Entry memory entry;
139     entry.timestamp = currentTime();
140     entry.player = msg.sender;
141     entry.teamsSelected = teamIndices;
142 
143     gameRecords[date].entries.push(entry);
144     gameRecords[date].numPlayers++;
145     gameRecords[date].pool += ENTRY_FEE;
146 
147     uint entryIndex = gameRecords[date].players.push(msg.sender) - 1;
148     gameRecords[date].entries[entryIndex].entryIndex = entryIndex;
149 
150     emit NewEntry(msg.sender, teamIndices);
151   }
152 
153 
154   // ANALYZING SCORES
155 
156   // Register teams (alphabetically) points total for each game
157   function registerTeamScores(uint[] _scores) onlyOwner {
158     allTeamsScores = _scores;
159   }
160 
161   function registerTopPlayers(uint _date, uint[] _topPlayersIndices, uint[] _topScores) onlyOwner {
162     gameRecords[_date].topPlayersIndices = _topPlayersIndices;
163     for(uint i = 0; i < _topPlayersIndices.length; i++){
164       address player = gameRecords[_date].entries[_topPlayersIndices[i]].player;
165       gameRecords[_date].topPlayersAddresses.push(player);
166     }
167     gameRecords[_date].topPlayersScores = _topScores;
168   }
169 
170   // Allocate winnings to top 5 (or 5+ if ties) players
171   function generateWinners(uint _date) onlyOwner {
172     require(gameRecords[_date].closedTime < currentTime());
173     uint place = 1;
174     uint iterator = 0;
175     uint placeCount = 1;
176     uint currentScore = 1;
177     uint percentage = 0;
178     uint amount = 0;
179 
180     while(place <= 5){
181       currentScore = gameRecords[_date].topPlayersScores[iterator];
182       if(gameRecords[_date].topPlayersScores[iterator + 1] == currentScore){
183         placeCount++;
184         iterator++;
185       } else {
186         amount = 0;
187 
188         if(placeCount > 1){
189           percentage = 0;
190           for(uint n = place; n <= (place + placeCount);n++){
191             if(n <= 5){
192               percentage += payoutPercentages[n];
193             }
194           }
195           amount = gameRecords[_date].pool / placeCount * percentage / 100;
196         } else {
197           amount = gameRecords[_date].pool * payoutPercentages[place] / 100;
198         }
199 
200 
201         for(uint i = place - 1; i < (place + placeCount - 1); i++){
202           address winnerAddress = gameRecords[_date].entries[gameRecords[_date].topPlayersIndices[i]].player;
203           gameRecords[_date].winnerAddresses.push(winnerAddress);
204           gameRecords[_date].winnerAmounts.push(amount);
205         }
206 
207         iterator++;
208         place += placeCount;
209         placeCount = 1;
210       }
211 
212     }
213     allTimeGames.push(gameRecords[_date]);
214   }
215 
216   function assignWinnings(uint _date) onlyOwner {
217     address[] storage winners = gameRecords[_date].winnerAddresses;
218     uint[] storage winnerAmounts = gameRecords[_date].winnerAmounts;
219 
220     for(uint z = 0; z < winners.length; z++){
221       address currentWinner = winners[z];
222       uint currentRedeemable = availableWinnings[currentWinner];
223       uint newRedeemable = currentRedeemable + winnerAmounts[z];
224       availableWinnings[currentWinner] = newRedeemable;
225       debt += winnerAmounts[z];
226     }
227   }
228 
229   function redeem() external returns(bool success) {
230     require(availableWinnings[msg.sender] > 0);
231     uint amount = availableWinnings[msg.sender];
232     availableWinnings[msg.sender] = 0;
233     debt -= amount;
234     msg.sender.transfer(amount);
235     return true;
236   }
237 
238   function getAvailableWinnings(address _address) view returns(uint amount){
239     return availableWinnings[_address];
240   }
241 
242 
243   // OTHER USEFUL FUNCTIONS / TESTING
244 
245   function currentTime() view returns (uint _currentTime) {
246     return now;
247   }
248 
249   function getPointsToSpend() view returns(uint _POINTS_TO_SPEND) {
250     return POINTS_TO_SPEND;
251   }
252 
253   function getGameNumberOfEntries(uint _date) view returns(uint _length){
254     return gameRecords[_date].entries.length;
255   }
256 
257   function getCutoffTime(uint _date) view returns(uint cutoff){
258     return gameRecords[_date].closedTime;
259   }
260 
261   function getTeamScore(uint _teamIndex) view returns(uint score){
262     return allTeamsScores[_teamIndex];
263   }
264 
265   function getAllTeamScores() view returns(uint[] scores){
266     return allTeamsScores;
267   }
268 
269   function getAllPlayers(uint _date) view returns(address[] _players){
270     return gameRecords[_date].players;
271   }
272 
273   function getTopPlayerScores(uint _date) view returns(uint[] scores){
274     return gameRecords[_date].topPlayersScores;
275   }
276 
277   function getTopPlayers(uint _date) view returns(address[] _players){
278     return gameRecords[_date].topPlayersAddresses;
279   }
280 
281   function getWinners(uint _date) view returns(uint[] _amounts, address[] _players){
282     return (gameRecords[_date].winnerAmounts, gameRecords[_date].winnerAddresses);
283   }
284 
285   function getNumEntries(uint _date) view returns(uint _num){
286     return gameRecords[_date].numPlayers;
287   }
288 
289   function getPoolValue(uint _date) view returns(uint amount){
290     return gameRecords[_date].pool;
291   }
292 
293   function getBalance() view returns(uint _amount) {
294     return address(this).balance;
295   }
296 
297   function getTeamCost(uint _index) constant returns(uint cost){
298     return allTeamsCosts[_index];
299   }
300 
301   function getAllTeamCosts() view returns(uint[] costs){
302     return allTeamsCosts;
303   }
304 
305   function getPastGameResults(uint _gameIndex) view returns(address[] topPlayers,
306                                                             uint[] topPlayersScores,
307                                                             uint[] winnings){
308     return (allTimeGames[_gameIndex].topPlayersAddresses,
309             allTimeGames[_gameIndex].topPlayersScores,
310             allTimeGames[_gameIndex].winnerAmounts
311     );
312   }
313 
314   function getPastGamesLength() view returns(uint _length){
315     return allTimeGames.length;
316   }
317 
318   function getEntry(uint _date, uint _index) view returns(
319     address playerAddress,
320     uint[] teamsSelected,
321     uint entryIndex
322   ){
323     return (gameRecords[_date].entries[_index].player,
324             gameRecords[_date].entries[_index].teamsSelected,
325             gameRecords[_date].entries[_index].entryIndex);
326   }
327 
328 }