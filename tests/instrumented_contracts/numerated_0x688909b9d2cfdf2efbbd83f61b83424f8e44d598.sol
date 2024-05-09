1 /// @title Store lederboards in the Blockchain
2 /// @author Marcel Scherello blockscores@scherello.de
3 /// @notice Create a custom leaderboard and start counting the scores
4 /// @dev All function calls are currently implement without side effects
5 /// @dev v1.1.0
6 contract BlockScores {
7     struct Player {
8         bytes32  playerName;
9         address playerAddress;
10         uint  score;
11         uint  score_unconfirmed;
12         uint   isActive;
13     }
14     struct Board {
15         bytes32  boardName;
16         string  boardDescription;
17         uint   numPlayers;
18         address boardOwner;
19         mapping (uint => Player) players;
20     }
21     mapping (bytes32 => Board) boards;
22     uint public numBoards;
23     address owner = msg.sender;
24 
25     uint public balance;
26     uint public boardCost = 1000000000000000;
27     uint public playerCost = 1000000000000000;
28 
29     modifier isOwner {
30         assert(owner == msg.sender);
31         _;
32     }
33 
34     /**
35     Funding Functions
36     */
37 
38     /// @notice withdraw all funds to contract owner
39     /// @return true
40     function withdraw() isOwner public returns(bool) {
41         uint _amount = address(this).balance;
42         emit Withdrawal(owner, _amount);
43         owner.transfer(_amount);
44         balance -= _amount;
45         return true;
46     }
47 
48     /// @notice change the costs for using the contract
49     /// @param costBoard costs for a new board
50     /// @param costPlayer costs for a new player
51     /// @return true
52     function setCosts (uint costBoard, uint costPlayer) isOwner public returns(bool) {
53         boardCost = costBoard;
54         playerCost = costPlayer;
55         return true;
56     }
57 
58     /// @notice split the revenue of a new player between boardOwner and contract owner
59     /// @param boardOwner of the leaderboard
60     /// @param _amount amount to be split
61     /// @return true
62     function split(address boardOwner, uint _amount) internal returns(bool) {
63         emit Withdrawal(owner, _amount/2);
64         owner.transfer(_amount/2);
65         //emit Withdrawal(boardOwner, _amount/2);
66         boardOwner.transfer(_amount/2);
67         return true;
68     }
69 
70     /// @notice Event for Withdrawal
71     event Withdrawal(address indexed _from, uint _value);
72 
73     /**
74     Board Functions
75     */
76 
77     /// @notice Add a new leaderboard. Board hash will be created by name and creator
78     /// @notice a funding is required to create a new leaderboard
79     /// @param name The name of the leaderboard
80     /// @param boardDescription A subtitle for the leaderboard
81     /// @return The hash of the newly created leaderboard
82     function addNewBoard(bytes32 name, string boardDescription) public payable returns(bytes32 boardHash){
83         require(msg.value >= boardCost);
84         balance += msg.value;
85         boardHash = keccak256(abi.encodePacked(name, msg.sender));
86         numBoards++;
87         boards[boardHash] = Board(name, boardDescription, 0, msg.sender);
88         emit newBoardCreated(boardHash);
89     }
90 
91     /// @notice Simulate the creation of a leaderboard hash
92     /// @param name The name of the leaderboard
93     /// @param admin The address of the admin address
94     /// @return The possible hash of the leaderboard
95     function createBoardHash(bytes32 name, address admin) pure public returns (bytes32){
96         return keccak256(abi.encodePacked(name, admin));
97     }
98 
99     /// @notice Get the metadata of a leaderboard
100     /// @param boardHash The hash of the leaderboard
101     /// @return Leaderboard name, description and number of players
102     function getBoardByHash(bytes32 boardHash) constant public returns(bytes32,string,uint){
103         return (boards[boardHash].boardName, boards[boardHash].boardDescription, boards[boardHash].numPlayers);
104     }
105 
106     /// @notice Overwrite leaderboard name and desctiption as owner only
107     /// @param boardHash The hash of the leaderboard to be modified
108     /// @param name The new name of the leaderboard
109     /// @param boardDescription The new subtitle for the leaderboard
110     /// @return true
111     function changeBoardMetadata(bytes32 boardHash, bytes32 name, string boardDescription) public returns(bool) {
112         require(boards[boardHash].boardOwner == msg.sender);
113         boards[boardHash].boardName = name;
114         boards[boardHash].boardDescription = boardDescription;
115     }
116 
117     /// @notice event for newly created leaderboard
118     event newBoardCreated(bytes32 boardHash);
119 
120 
121     /**
122     Player Functions
123     */
124 
125     /// @notice Add a new player to an existing leaderboard
126     /// @param boardHash The hash of the leaderboard
127     /// @param playerName The name of the player
128     /// @return Player ID
129     function addPlayerToBoard(bytes32 boardHash, bytes32 playerName) public payable returns (bool) {
130         require(msg.value >= playerCost);
131         Board storage g = boards[boardHash];
132         split (g.boardOwner, msg.value);
133         uint newPlayerID = g.numPlayers++;
134         g.players[newPlayerID] = Player(playerName, msg.sender,0,0,1);
135         return true;
136     }
137 
138     /// @notice Get player data by leaderboard hash and player id/index
139     /// @param boardHash The hash of the leaderboard
140     /// @param playerID Index number of the player
141     /// @return Player name, confirmed score, unconfirmed score
142     function getPlayerByBoard(bytes32 boardHash, uint8 playerID) constant public returns (bytes32, uint, uint){
143         Player storage p = boards[boardHash].players[playerID];
144         require(p.isActive == 1);
145         return (p.playerName, p.score, p.score_unconfirmed);
146     }
147 
148     /// @notice The leaderboard owner can remove a player
149     /// @param boardHash The hash of the leaderboard
150     /// @param playerName The name of the player to be removed
151     /// @return true/false
152     function removePlayerFromBoard(bytes32 boardHash, bytes32 playerName) public returns (bool){
153         Board storage g = boards[boardHash];
154         require(g.boardOwner == msg.sender);
155         uint8 playerID = getPlayerId (boardHash, playerName, 0);
156         require(playerID < 255 );
157         g.players[playerID].isActive = 0;
158         return true;
159     }
160 
161     /// @notice Get the player id either by player Name or address
162     /// @param boardHash The hash of the leaderboard
163     /// @param playerName The name of the player
164     /// @param playerAddress The player address
165     /// @return ID or 999 in case of false
166     function getPlayerId (bytes32 boardHash, bytes32 playerName, address playerAddress) constant internal returns (uint8) {
167         Board storage g = boards[boardHash];
168         for (uint8 i = 0; i <= g.numPlayers; i++) {
169             if ((keccak256(abi.encodePacked(g.players[i].playerName)) == keccak256(abi.encodePacked(playerName)) || playerAddress == g.players[i].playerAddress) && g.players[i].isActive == 1) {
170                 return i;
171                 break;
172             }
173         }
174         return 255;
175     }
176 
177     /**
178     Score Functions
179     */
180 
181     /// @notice Add a unconfirmed score to leaderboard/player. Overwrites an existing unconfirmed score
182     /// @param boardHash The hash of the leaderboard
183     /// @param playerName The name of the player
184     /// @param score Integer
185     /// @return true/false
186     function addBoardScore(bytes32 boardHash, bytes32 playerName, uint score) public returns (bool){
187         uint8 playerID = getPlayerId (boardHash, playerName, 0);
188         require(playerID < 255 );
189         boards[boardHash].players[playerID].score_unconfirmed = score;
190         return true;
191     }
192 
193     /// @notice Confirm an unconfirmed score to leaderboard/player. Adds unconfirmed to existing score. Player can not confirm his own score
194     /// @param boardHash The hash of the leaderboard
195     /// @param playerName The name of the player who's score should be confirmed
196     /// @return true/false
197     function confirmBoardScore(bytes32 boardHash, bytes32 playerName) public returns (bool){
198         uint8 playerID = getPlayerId (boardHash, playerName, 0);
199         uint8 confirmerID = getPlayerId (boardHash, "", msg.sender);
200         require(playerID < 255); // player needs to be active
201         require(confirmerID < 255); // confirmer needs to be active
202         require(boards[boardHash].players[playerID].playerAddress != msg.sender); //confirm only other players
203         boards[boardHash].players[playerID].score += boards[boardHash].players[playerID].score_unconfirmed;
204         boards[boardHash].players[playerID].score_unconfirmed = 0;
205         return true;
206     }
207 
208     /**
209     Migration Functions
210     */
211     /// @notice Read board metadata for migration as contract owner only
212     /// @param boardHash The hash of the leaderboard
213     /// @return Bord metadata
214     function migrationGetBoard(bytes32 boardHash) constant isOwner public returns(bytes32,string,uint,address) {
215         return (boards[boardHash].boardName, boards[boardHash].boardDescription, boards[boardHash].numPlayers, boards[boardHash].boardOwner);
216     }
217 
218     /// @notice Write board metadata for migration as contract owner only
219     /// @param boardHash The hash of the leaderboard to be modified
220     /// @param name The new name of the leaderboard
221     /// @param boardDescription The new subtitle for the leaderboard
222     /// @param boardOwner The address for the boardowner
223     /// @return true
224     function migrationSetBoard(bytes32 boardHash, bytes32 name, string boardDescription, uint8 numPlayers, address boardOwner) isOwner public returns(bool) {
225         boards[boardHash].boardName = name;
226         boards[boardHash].boardDescription = boardDescription;
227         boards[boardHash].numPlayers = numPlayers;
228         boards[boardHash].boardOwner = boardOwner;
229         return true;
230     }
231 
232     /// @notice Read player metadata for migration as contract owner
233     /// @param boardHash The hash of the leaderboard
234     /// @param playerID Index number of the player
235     /// @return Player metadata
236     function migrationGetPlayer(bytes32 boardHash, uint8 playerID) constant isOwner public returns (uint, bytes32, address, uint, uint, uint){
237         Player storage p = boards[boardHash].players[playerID];
238         return (playerID, p.playerName, p.playerAddress, p.score, p.score_unconfirmed, p.isActive);
239     }
240 
241     /// @notice Write player metadata for migration as contract owner only
242     /// @param boardHash The hash of the leaderboard
243     /// @param playerID Player ID
244     /// @param playerName Player name
245     /// @param playerAddress Player address
246     /// @param score Player score
247     /// @param score_unconfirmed Player unconfirmed score
248     /// @param isActive Player isActive
249     /// @return true
250     function migrationSetPlayer(bytes32 boardHash, uint playerID, bytes32 playerName, address playerAddress, uint score, uint score_unconfirmed, uint isActive) isOwner public returns (bool) {
251         Board storage g = boards[boardHash];
252         g.players[playerID] = Player(playerName, playerAddress, score, score_unconfirmed, isActive);
253         return true;
254     }
255 
256 }