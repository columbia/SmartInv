1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4     function safeMul(uint a, uint b) internal returns (uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function safeSub(uint a, uint b) internal returns (uint) {
11         assert(b <= a);
12         return a - b;
13     }
14 
15     function safeAdd(uint a, uint b) internal returns (uint) {
16         uint c = a + b;
17         assert(c>=a && c>=b);
18         return c;
19     }
20 
21     function assert(bool assertion) internal {
22         if (!assertion) throw;
23     }
24 }
25 
26 contract AccessControl is SafeMath{
27 
28     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
29     event ContractUpgrade(address newContract);
30 
31     // The addresses of the accounts (or contracts) that can execute actions within each roles.
32     address public ceoAddress;
33     address public cfoAddress;
34     address public cooAddress;
35 
36     address newContractAddress;
37 
38     uint public tip_total = 0;
39     uint public tip_rate = 10000000000000000;
40 
41     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
42     bool public paused = false;
43 
44     /// @dev Access modifier for CEO-only functionality
45     modifier onlyCEO() {
46         require(msg.sender == ceoAddress);
47         _;
48     }
49 
50     /// @dev Access modifier for CFO-only functionality
51     modifier onlyCFO() {
52         require(msg.sender == cfoAddress);
53         _;
54     }
55 
56     /// @dev Access modifier for COO-only functionality
57     modifier onlyCOO() {
58         require(msg.sender == cooAddress);
59         _;
60     }
61 
62     modifier onlyCLevel() {
63         require(
64             msg.sender == cooAddress ||
65             msg.sender == ceoAddress ||
66             msg.sender == cfoAddress
67         );
68         _;
69     }
70 
71     function () public payable{
72         tip_total = safeAdd(tip_total, msg.value);
73     }
74 
75     /// @dev Count amount with tip.
76     /// @param amount The totalAmount
77     function amountWithTip(uint amount) internal returns(uint){
78         uint tip = safeMul(amount, tip_rate) / (1 ether);
79         tip_total = safeAdd(tip_total, tip);
80         return safeSub(amount, tip);
81     }
82 
83     /// @dev Withdraw Tip.
84     function withdrawTip(uint amount) external onlyCFO {
85         require(amount > 0 && amount <= tip_total);
86         require(msg.sender.send(amount));
87         tip_total = tip_total - amount;
88     }
89 
90     // updgrade
91     function setNewAddress(address newContract) external onlyCEO whenPaused {
92         newContractAddress = newContract;
93         emit ContractUpgrade(newContract);
94     }
95 
96     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
97     /// @param _newCEO The address of the new CEO
98     function setCEO(address _newCEO) external onlyCEO {
99         require(_newCEO != address(0));
100 
101         ceoAddress = _newCEO;
102     }
103 
104     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
105     /// @param _newCFO The address of the new CFO
106     function setCFO(address _newCFO) external onlyCEO {
107         require(_newCFO != address(0));
108 
109         cfoAddress = _newCFO;
110     }
111 
112     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
113     /// @param _newCOO The address of the new COO
114     function setCOO(address _newCOO) external onlyCEO {
115         require(_newCOO != address(0));
116 
117         cooAddress = _newCOO;
118     }
119 
120     /*** Pausable functionality adapted from OpenZeppelin ***/
121 
122     /// @dev Modifier to allow actions only when the contract IS NOT paused
123     modifier whenNotPaused() {
124         require(!paused);
125         _;
126     }
127 
128     /// @dev Modifier to allow actions only when the contract IS paused
129     modifier whenPaused {
130         require(paused);
131         _;
132     }
133 
134     /// @dev Called by any "C-level" role to pause the contract. Used only when
135     ///  a bug or exploit is detected and we need to limit damage.
136     function pause() external onlyCLevel whenNotPaused {
137         paused = true;
138     }
139 
140     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
141     ///  one reason we may pause the contract is when CFO or COO accounts are
142     ///  compromised.
143     /// @notice This is public rather than external so it can be called by
144     ///  derived contracts.
145     function unpause() public onlyCEO whenPaused {
146         // can't unpause if contract was upgraded
147         paused = false;
148     }
149 }
150 
151 
152 contract RpsGame is SafeMath , AccessControl{
153 
154     /// @dev Constant definition
155     uint8 constant public NONE = 0;
156     uint8 constant public ROCK = 10;
157     uint8 constant public PAPER = 20;
158     uint8 constant public SCISSORS = 30;
159     uint8 constant public DEALERWIN = 201;
160     uint8 constant public PLAYERWIN = 102;
161     uint8 constant public DRAW = 101;
162 
163     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
164     event CreateGame(uint gameid, address dealer, uint amount);
165     event JoinGame(uint gameid, address player, uint amount);
166     event Reveal(uint gameid, address player, uint8 choice);
167     event CloseGame(uint gameid,address dealer,address player, uint8 result);
168 
169     /// @dev struct of a game
170     struct Game {
171         uint expireTime;
172         address dealer;
173         uint dealerValue;
174         bytes32 dealerHash;
175         uint8 dealerChoice;
176         address player;
177         uint8 playerChoice;
178         uint playerValue;
179         uint8 result;
180         bool closed;
181     }
182 
183     /// @dev struct of a game
184     mapping (uint => mapping(uint => uint8)) public payoff;
185     mapping (uint => Game) public games;
186     mapping (address => uint[]) public gameidsOf;
187 
188     /// @dev Current game maximum id
189     uint public maxgame = 0;
190     uint public expireTimeLimit = 30 minutes;
191 
192     /// @dev Initialization contract
193     function RpsGame() {
194         payoff[ROCK][ROCK] = DRAW;
195         payoff[ROCK][PAPER] = PLAYERWIN;
196         payoff[ROCK][SCISSORS] = DEALERWIN;
197         payoff[PAPER][ROCK] = DEALERWIN;
198         payoff[PAPER][PAPER] = DRAW;
199         payoff[PAPER][SCISSORS] = PLAYERWIN;
200         payoff[SCISSORS][ROCK] = PLAYERWIN;
201         payoff[SCISSORS][PAPER] = DEALERWIN;
202         payoff[SCISSORS][SCISSORS] = DRAW;
203         payoff[NONE][NONE] = DRAW;
204         payoff[ROCK][NONE] = DEALERWIN;
205         payoff[PAPER][NONE] = DEALERWIN;
206         payoff[SCISSORS][NONE] = DEALERWIN;
207         payoff[NONE][ROCK] = PLAYERWIN;
208         payoff[NONE][PAPER] = PLAYERWIN;
209         payoff[NONE][SCISSORS] = PLAYERWIN;
210 
211         ceoAddress = msg.sender;
212         cooAddress = msg.sender;
213         cfoAddress = msg.sender;
214     }
215 
216     /// @dev Create a game
217     function createGame(bytes32 dealerHash, address player) public payable whenNotPaused returns (uint){
218         require(dealerHash != 0x0);
219 
220         maxgame += 1;
221         Game storage game = games[maxgame];
222         game.dealer = msg.sender;
223         game.player = player;
224         game.dealerHash = dealerHash;
225         game.dealerChoice = NONE;
226         game.dealerValue = msg.value;
227         game.expireTime = expireTimeLimit + now;
228 
229         gameidsOf[msg.sender].push(maxgame);
230 
231         emit CreateGame(maxgame, game.dealer, game.dealerValue);
232 
233         return maxgame;
234     }
235 
236     /// @dev Join a game
237     function joinGame(uint gameid, uint8 choice) public payable whenNotPaused returns (uint){
238         Game storage game = games[gameid];
239 
240         require(msg.value == game.dealerValue && game.dealer != address(0) && game.dealer != msg.sender && game.playerChoice==NONE);
241         require(game.player == address(0) || game.player == msg.sender);
242         require(!game.closed);
243         require(now < game.expireTime);
244         require(checkChoice(choice));
245 
246         game.player = msg.sender;
247         game.playerChoice = choice;
248         game.playerValue = msg.value;
249         game.expireTime = expireTimeLimit + now;
250 
251         gameidsOf[msg.sender].push(gameid);
252 
253         emit JoinGame(gameid, game.player, game.playerValue);
254 
255         return gameid;
256     }
257 
258     /// @dev Creator reveals game choice
259     function reveal(uint gameid, uint8 choice, bytes32 randomSecret) public returns (bool) {
260         Game storage game = games[gameid];
261         bytes32 proof = getProof(msg.sender, choice, randomSecret);
262 
263         require(!game.closed);
264         require(now < game.expireTime);
265         require(game.dealerHash != 0x0);
266         require(checkChoice(choice));
267         require(checkChoice(game.playerChoice));
268         require(game.dealer == msg.sender && proof == game.dealerHash );
269 
270         game.dealerChoice = choice;
271 
272         Reveal(gameid, msg.sender, choice);
273 
274         close(gameid);
275 
276         return true;
277     }
278 
279     /// @dev Close game settlement rewards
280     function close(uint gameid) public returns(bool) {
281         Game storage game = games[gameid];
282 
283         require(!game.closed);
284         require(now > game.expireTime || (game.dealerChoice != NONE && game.playerChoice != NONE));
285 
286         uint8 result = payoff[game.dealerChoice][game.playerChoice];
287 
288         if(result == DEALERWIN){
289             require(game.dealer.send(amountWithTip(safeAdd(game.dealerValue, game.playerValue))));
290         }else if(result == PLAYERWIN){
291             require(game.player.send(amountWithTip(safeAdd(game.dealerValue, game.playerValue))));
292         }else if(result == DRAW){
293             require(game.dealer.send(game.dealerValue) && game.player.send(game.playerValue));
294         }
295 
296         game.closed = true;
297         game.result = result;
298 
299         emit CloseGame(gameid, game.dealer, game.player, result);
300 
301         return game.closed;
302     }
303 
304 
305     function getProof(address sender, uint8 choice, bytes32 randomSecret) public pure returns (bytes32){
306         return sha3(sender, choice, randomSecret);
307     }
308 
309     function gameCountOf(address owner) public view returns (uint){
310         return gameidsOf[owner].length;
311     }
312 
313     function checkChoice(uint8 choice) public view returns (bool){
314         return choice==ROCK||choice==PAPER||choice==SCISSORS;
315     }
316 
317 }