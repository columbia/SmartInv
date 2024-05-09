1 pragma solidity ^0.4.18;
2  
3 contract Officials {
4     address public ceoAddress;
5     address public cfoAddress;
6     address public cgoAddress;
7     
8     modifier onlyCEO() {
9         require(msg.sender == ceoAddress);
10         _;
11     }
12     
13     modifier onlyCFO() {
14         require(msg.sender == cfoAddress);
15         _;
16     }
17     
18     modifier onlyCGO() {
19         require(msg.sender == cgoAddress);
20         _;
21     }
22     
23     modifier onlyOfficers() {
24         require(
25             msg.sender == ceoAddress ||
26             msg.sender == cgoAddress 
27         );
28         _;
29     }
30 
31     constructor() public {
32         ceoAddress = msg.sender;
33         cfoAddress = msg.sender;
34         cgoAddress = msg.sender;
35     }
36     
37     function setCEO(address _newCEO) public onlyCEO {
38         require(_newCEO != address(0));
39         ceoAddress = _newCEO;
40     }
41     
42     function setCGO(address _newCGO) public onlyCEO {
43         require(_newCGO != address(0));
44         cgoAddress = _newCGO;
45     }
46      
47     function setCFO(address _newCFO) public onlyCEO {
48         require(_newCFO != address(0));
49         cfoAddress = _newCFO;
50     }
51     
52 }
53  
54 contract Games is Officials{ 
55     
56     event Pause(bool paused);
57     event Create(uint256 gameId, address creator, address challenger, uint256 bet, uint256 count);
58     event Cancel(uint256 gameId);
59     event Won(uint256 gameId, address winner);
60     event Join(uint256 gameId, address challenger);
61     
62     bool public paused = true;
63     uint256 public gameCount = 0;
64     uint256 public minimumBet = 0.01 ether;
65     uint8 devFee = 6; //6% dev fee;
66     
67     struct Game {
68         address creator;
69         address challenger;
70         uint bet;
71         uint count;
72     }
73     
74     struct GameIndex {
75         uint index;
76         bool isPlaying;
77     }
78     
79     mapping (address => GameIndex) public players;
80     
81     Game[] private games;
82     
83     function togglePaused() public onlyCEO {
84         paused = !paused;
85         emit Pause(paused);
86     }
87     
88     modifier isUnpaused() {
89         require(paused == false);
90         _;
91     }
92     
93     modifier isPlaying(address _gameCreator) {
94         require(players[_gameCreator].isPlaying);
95         _;
96     }
97     
98     function setMinimumBet(uint _newMinBet) public onlyCEO {
99         minimumBet = _newMinBet;
100     }
101     
102     function createGame() public payable isUnpaused {
103         /* Function Rules */
104         // Only 1 Game Per initiator
105         // Only 1 Game Per challenger
106         require(msg.value >= minimumBet);
107         require(!players[msg.sender].isPlaying);
108         Game memory m = Game(msg.sender, 0, msg.value, gameCount);
109         uint256 newGameId = games.push(m) - 1;
110         gameCount++;
111         
112         players[msg.sender] = GameIndex(newGameId, true);
113         
114         emit Create(newGameId, m.creator, m.challenger, m.bet, m.count);
115     }
116     
117     function cancelGame(address _gameCreator) public isPlaying(_gameCreator) {
118         uint _gameId = players[_gameCreator].index;
119         
120         Game memory m = games[_gameId];
121         require(msg.sender == m.creator || msg.sender == ceoAddress);
122         require(m.challenger == 0);
123         
124         m.creator.transfer(m.bet);
125         
126         deleteGame(_gameId, m);
127         
128         emit Cancel(_gameId);
129     }
130     
131     function revertGame(address _gameCreator) public onlyCEO isPlaying(_gameCreator) {
132         uint _gameId = players[_gameCreator].index;
133 
134         Game memory m = games[_gameId];
135         require(m.challenger != 0); //This is only for active games
136         
137         m.creator.transfer(m.bet);
138         m.challenger.transfer(m.bet);
139         
140         deleteGame(_gameId, m);
141         
142         emit Cancel(_gameId);
143     }
144     
145     function joinGame(address _gameCreator) public payable isUnpaused isPlaying(_gameCreator){
146         uint _gameId = players[_gameCreator].index;
147         require(!players[msg.sender].isPlaying);
148         
149         Game storage m = games[_gameId]; 
150         require(msg.sender != m.creator);
151         require(m.challenger == 0);
152         require(msg.value == m.bet);
153         
154         m.challenger = msg.sender;
155         players[msg.sender] = GameIndex(_gameId, true);
156         
157         emit Join(_gameId, m.challenger);
158     }
159     
160     function declareWinner(address _gameCreator, bool _creatorWon) public onlyCGO isPlaying(_gameCreator){
161         uint _gameId = players[_gameCreator].index;
162         
163         Game storage m = games[_gameId];
164         uint256 devPayout = uint256(SafeMath.div(SafeMath.mul(m.bet, devFee), 100));
165         uint256 payout = uint256(SafeMath.add(m.bet, SafeMath.sub(m.bet, devPayout)));
166                 
167         address winner = m.creator;        
168          
169         if(!_creatorWon){
170             winner = m.challenger;
171         } 
172         
173         winner.transfer(payout);
174 
175         cfoAddress.transfer(devPayout);
176         
177         deleteGame(_gameId, m);
178         
179         emit Won(_gameId, winner);
180     }
181     
182     function deleteGame(uint _gameId, Game _game) internal {
183         if (games.length > 1) {
184             games[_gameId] = games[games.length - 1];
185             
186             players[games[_gameId].creator].index = _gameId;
187            
188             if (games[_gameId].challenger != 0) {
189                 players[games[_gameId].challenger].index = _gameId;
190             }
191         }
192         
193         
194         players[_game.creator].isPlaying = false;
195         
196         if (_game.challenger != 0) {
197             players[_game.challenger].isPlaying = false;
198         } 
199         
200         games.length--;
201     }
202     
203     function totalGames() public view returns (uint256 total) {
204         return games.length;
205     }
206     
207     function getGameById(uint256 _gameId) public view returns (
208         uint gameId,
209         address creator,
210         address challenger,
211         uint bet,
212         uint count
213      ) {
214         Game memory m = games[_gameId];
215         gameId = _gameId;
216         creator = m.creator;
217         challenger = m.challenger;
218         bet = m.bet;
219         count = m.count;
220      }
221      
222     function getGameByPlayer(address _player) public view isPlaying(_player) returns  (
223         uint gameId,
224         address creator,
225         address challenger,
226         uint bet,
227         uint count
228     ) {
229         Game memory m = games[players[_player].index];
230         gameId = players[_player].index;
231         creator = m.creator;
232         challenger = m.challenger;
233         bet = m.bet;
234         count = m.count;
235     }
236      
237 }
238 
239 library SafeMath {
240 
241   /**
242   * @dev Multiplies two numbers, throws on overflow.
243   */
244   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
245     if (a == 0) {
246       return 0;
247     }
248     uint256 c = a * b;
249     assert(c / a == b);
250     return c;
251   }
252 
253   /**
254   * @dev Integer division of two numbers, truncating the quotient.
255   */
256   function div(uint256 a, uint256 b) internal pure returns (uint256) {
257     // assert(b > 0); // Solidity automatically throws when dividing by 0
258     uint256 c = a / b;
259     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
260     return c;
261   }
262 
263   /**
264   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
265   */
266   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
267     assert(b <= a);
268     return a - b;
269   }
270 
271   /**
272   * @dev Adds two numbers, throws on overflow.
273   */
274   function add(uint256 a, uint256 b) internal pure returns (uint256) {
275     uint256 c = a + b;
276     assert(c >= a);
277     return c;
278   }
279 }