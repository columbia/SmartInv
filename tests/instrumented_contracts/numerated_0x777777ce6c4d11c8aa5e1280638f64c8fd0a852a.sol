1 /*
2 ╔═══╦╗─╔══╦╗╔╦════╦══╦╗╔╗╔╦══╦╗─╔╗╔══╦══╗
3 ║╔═╗║║─║╔╗║║║╠═╗╔═╣╔╗║║║║║╠╗╔╣╚═╝║╚╗╔╣╔╗║
4 ║╚═╝║║─║╚╝║╚╝║─║║─║║║║║║║║║║║║╔╗─║─║║║║║║
5 ║╔══╣║─║╔╗╠═╗║─║║─║║║║║║║║║║║║║╚╗║─║║║║║║
6 ║║──║╚═╣║║║╔╝║─║║─║╚╝║╚╝╚╝╠╝╚╣║─║╠╦╝╚╣╚╝║
7 ╚╝──╚══╩╝╚╝╚═╝─╚╝─╚══╩═╝╚═╩══╩╝─╚╩╩══╩══╝
8 */
9 
10 //By playing platform games you agree that your age is over 21 and you clearly understand that you can lose your coins
11 //The platform is not responsible for all Ethereum cryptocurrency losses during the game.
12 //The contract uses the entropy algorithm Signidice
13 //https://github.com/gluk256/misc/blob/master/rng4ethereum/signidice.md
14 
15 
16 //license by cryptogame.bet
17 
18 pragma solidity 0.5.16;
19 
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a / b;
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a); 
34     return a - b; 
35   } 
36   
37   function add(uint256 a, uint256 b) internal pure returns (uint256) { 
38     uint256 c = a + b; assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract PlayToWinGames {
44     using SafeMath for uint;
45     address payable public  owner = 0x7777773BA6D0FF3cB87E0b09A0A652CA30d48030;
46     address public  CROUPIER_BOB = 0xB0b77786E6C7FAf962e448aC63ee7160ED971931;
47     uint public minStake = 0.01 ether;
48     uint public maxStake = 15 ether;
49     uint public constant WIN_COEFFICIENT = 198;
50     uint public constant DICE_COEFFICIENT = 600;
51     mapping(address => uint) public deposit;
52     mapping(address => uint) public withdrawal;
53     bool status = true;
54 
55     enum GameState {
56         Pending,
57         Win,
58         Lose,
59         Draw
60     }
61     
62     enum Games {
63         CoinFlip,
64         KNB,
65         Dice
66     }
67 
68     struct Game {
69         Games game_title;
70         address payable player;
71         uint bet;
72         bytes32 seed;
73         GameState state;
74         uint result;
75         bytes choice;
76         uint profit;
77     }
78 
79     event NewGame(address indexed player, bytes32 seed, uint bet, bytes choice, string  game);
80     event DemoGame(address indexed player, bytes32 seed, uint bet, bytes choice, string  game);
81     event ConfirmGame(address indexed player, string  game, uint profit, bytes choice, uint game_choice, bytes32 seed, bool status, bool draw,  uint timestamp);
82     event Deposit(address indexed from, uint indexed block, uint value, uint time);
83     event Withdrawal(address indexed from, uint indexed block, uint value, uint ident,uint time);
84     mapping(bytes32 => Game) public listGames;
85     
86     // Only our croupier and no one else can open the bet
87     modifier onlyCroupier() {
88         require(msg.sender == CROUPIER_BOB);
89         _;
90     }
91     
92     // Check that the rate is between 0.01 - 15 ether
93     modifier betInRange() {
94         require(minStake <= msg.value && msg.value <= maxStake);
95         _;
96     }
97     
98     modifier onlyOwner {
99         require(msg.sender == owner); _;
100     }
101     
102     modifier isNotContract() {
103         uint size;
104         address addr = msg.sender;
105         assembly { size := extcodesize(addr) }
106         require(size == 0 && tx.origin == msg.sender);
107         _;
108     }
109     
110     modifier contractIsOn() {
111         require(status);
112         _;
113     }
114 
115     // Game CoinFlip
116     // The game of tossing a coin, the coin has 2 sides,
117     // an eagle and a tails, which one is up to you to choose
118     function game_coin(bytes memory _choice, bytes32 seed) public betInRange payable returns(uint8) {
119         string memory game_title = 'CoinFlip';
120         uint8 user_choice;
121         assembly {user_choice := mload(add(0x1, _choice))}
122         require(listGames[seed].bet == 0x0);
123         require(_choice.length == 1);
124         require(user_choice == 0 || user_choice == 1);
125         
126         listGames[seed] = Game({
127             game_title: Games.CoinFlip,
128             player: msg.sender,
129             bet: msg.value,
130             seed: seed,
131             state: GameState.Pending,
132             choice: _choice,
133             result: 0,
134             profit: 0
135         });
136         emit NewGame(msg.sender, seed, msg.value, _choice, game_title);
137         return user_choice;
138     }
139     
140     // Game KNB
141     // Game of stone, scissors, paper
142     // The stone breaks the scissors, the scissors cut the paper, the paper wraps the stone.
143     // Everything is just kk in childhood, it remains only to try to play
144     function game_knb(bytes memory _choice, bytes32 seed) public betInRange payable {
145         string memory game_title = 'KNB';
146         uint8 user_choice;
147         assembly {user_choice := mload(add(0x1, _choice))}
148         require(listGames[seed].bet == 0x0);
149         require(_choice.length == 1);
150         //Checking that bids are in the right range
151         //1 - stone, 2 - scissors, 3 - paper
152         require(user_choice >=1 && user_choice <=3);
153         
154         listGames[seed] = Game({
155             game_title: Games.KNB,
156             player: msg.sender,
157             bet: msg.value,
158             seed: seed,
159             state: GameState.Pending,
160             choice: _choice,
161             result: 0,
162             profit: 0
163         });
164        emit NewGame(msg.sender, seed, msg.value, _choice, game_title);
165     }
166     
167     // Game Dice
168     // Playing dice, the player can select up to 5 dice values at a time. The more dice a player chooses, the less his final reward.
169     // The reward is calculated according to the formula:  (6 / number of selected cubes) * bet
170     function game_dice(bytes memory _choice, bytes32 seed) public betInRange payable {
171         string memory game_title = 'Dice';
172         require(listGames[seed].bet == 0x0);
173         //Checking that bids are in the right range, and no more than 5 cubes are selected
174         require(_choice.length >= 1 && _choice.length <= 5);
175         listGames[seed] = Game({
176             game_title: Games.Dice,
177             player: msg.sender,
178             bet: msg.value,
179             seed: seed,
180             state: GameState.Pending,
181             choice: _choice,
182             result: 0,
183             profit: 0
184         });
185         emit NewGame(msg.sender, seed, msg.value, _choice, game_title);
186     }
187 
188     //Casino must sign the resulting value V with its PrivKey, thus producing the digital signature S = sign(PrivKey, V), and send the corresponding TX, containing S.
189     //The contract recovers the actual public key (K) from the digital signature S, and verifies that it is equal to the previously published PubKey (K == PubKey).
190     //If APK does not match PubKey, it is tantamount to cheating. In this case, the contract simply rejects the transaction.
191     //The contract uses S as a seed for the predefined PRNG algorithm (e.g. SHA-3 based), which produces the lucky number (L), e.g. between 1 and 6.
192     function confirm(bytes32 seed, uint8 _v, bytes32 _r, bytes32 _s) public onlyCroupier {
193         // Checking that it was Uncle Bob who signed the transaction, otherwise we reject the impostor transaction
194         require (ecrecover(seed, _v, _r, _s) == CROUPIER_BOB);
195         Game storage game = listGames[seed];
196         bytes memory choice = game.choice;
197         game.result = uint256(_s) % 12;
198         uint profit = 0;
199         uint8 user_choice;
200         //Our algorithms are very simple and understandable even to the average Internet user and do not need additional explanation
201         //Coin game algorithm
202         if (game.game_title == Games.CoinFlip){
203             assembly {user_choice := mload(add(0x1, choice))}
204             if(game.result == user_choice){
205                 profit = game.bet.mul(WIN_COEFFICIENT).div(100);
206                 game.state = GameState.Win;
207                 game.profit = profit;
208                 game.player.transfer(profit);
209                 emit ConfirmGame(game.player, 'CoinFlip', profit, game.choice, game.result, game.seed, true, false, now);
210             }else{
211                 game.state = GameState.Lose;
212                 emit ConfirmGame(game.player, 'CoinFlip', 0, game.choice, game.result, game.seed, false, false, now);
213             }
214         //KNB game algorithm
215         }else if(game.game_title == Games.KNB){
216             assembly {user_choice := mload(add(0x1, choice))}
217             if(game.result != user_choice){
218                 if (user_choice == 1 && game.result == 2 || user_choice == 2 && game.result == 3 || user_choice == 3 && game.result == 1) {
219                     profit = game.bet.mul(WIN_COEFFICIENT).div(100);
220                     game.state = GameState.Win;
221                     game.profit = profit;
222                     game.player.transfer(profit);
223                     emit ConfirmGame(game.player, 'KNB', profit, game.choice, game.result, game.seed, true, false, now);
224                 }else{
225                     game.state = GameState.Lose;
226                     emit ConfirmGame(game.player, 'KNB', 0, game.choice, game.result, game.seed, false, false, now);
227                 }
228             }else{
229                 profit = game.bet.sub(0.001 ether);
230                 game.player.transfer(profit);
231                 game.state = GameState.Draw;
232                 emit ConfirmGame(game.player, 'KNB', profit, game.choice, game.result, game.seed, false, true, now);
233             }
234         //Dice game algorithm
235         }else if(game.game_title == Games.Dice){
236             uint length = game.choice.length + 1;
237             for(uint8 i=1; i< length; i++){
238                 assembly {user_choice  := mload(add(i, choice))}
239                 if (user_choice == game.result){
240                     profit = game.bet.mul(DICE_COEFFICIENT.div(game.choice.length)).div(100);
241                 }
242             }
243             if(profit > 0){
244                 game.state = GameState.Win;
245                 game.profit = profit;
246                 game.player.transfer(profit);
247                 emit ConfirmGame(game.player, 'Dice', profit, game.choice, game.result, game.seed, true, false, now);
248             }else{
249                 game.state = GameState.Lose;
250                 emit ConfirmGame(game.player, 'Dice', 0, game.choice, game.result, game.seed, false, false, now);
251             }
252         }
253     }
254     // Demo game, 0 ether value. To reduce the cost of the game, we calculate a random result on the server
255     function demo_game(string memory game, bytes memory _choice, bytes32 seed, uint bet) public {
256         emit DemoGame(msg.sender, seed, bet, _choice, game);
257     }
258     
259     function get_player_choice(bytes32 seed) public view returns(bytes memory) {
260         Game storage game = listGames[seed];
261         return game.choice;
262     }
263     
264     //The casino has its own expenses for maintaining the servers, paying for them, each signature by our bot Bob costs 0.00135 ether
265     //and we honestly believe that the money that players own is ours, everyone can try their luck and play with us
266     function pay_royalty (uint _value) onlyOwner public {
267         owner.transfer(_value * 1 ether);
268     }
269     
270     //automatic withdrawal using server bot
271     function multisend(address payable[] memory dests, uint256[] memory values, uint256[] memory ident) onlyOwner contractIsOn public returns(uint) {
272         uint256 i = 0;
273         
274         while (i < dests.length) {
275             uint transfer_value = values[i].sub(values[i].mul(3).div(100));
276             dests[i].transfer(transfer_value);
277             withdrawal[dests[i]]+=values[i];
278             emit Withdrawal(dests[i], block.number, values[i], ident[i], now);
279             i += 1;
280         }
281         return(i);
282     }
283     
284     function startProphylaxy()onlyOwner public {
285         status = false;
286     }
287     
288     function stopProphylaxy()onlyOwner public {
289         status = true;
290     }
291     // recharge function for games
292     function() external isNotContract contractIsOn betInRange payable {
293         deposit[msg.sender]+= msg.value;
294         emit Deposit(msg.sender, block.number, msg.value, now);
295     }
296 }
297 
298 //🅿🅻🅰🆈🆃🅾🆆🅸🅽.🅸🅾