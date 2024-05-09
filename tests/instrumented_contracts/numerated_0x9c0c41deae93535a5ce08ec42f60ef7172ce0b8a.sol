1 pragma solidity ^0.5.4;
2 
3 /**
4     INSTRUCTION:
5     Send more then 0.01 ETH to one of Wallet Contract address
6     [wallet_0, wallet_1, wallet_2], after round end send to This contract 0 ETH
7     transaction and if you choise won, take your winnings.
8 
9     DAPP:     http://smartlottery.game (mirror: http://smartlottery.clab)
10     BOT:      http://t.me/SmartLotteryGame_bot
11     LICENSE:  Under proprietary rights. All rights reserved.
12               Except <lib.SafeMath, cont.Ownable> under The MIT License (MIT)
13     AUTHOR:   http://t.me/pironmind
14     
15 */
16 
17 library SafeMath {
18     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
19         if (_a == 0) {
20             return 0;
21         }
22         uint256 c = _a * _b;
23         require(c / _a == _b);
24         return c;
25     }
26 
27     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
28         require(_b > 0);
29         uint256 c = _a / _b;
30         return c;
31     }
32 
33     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
34         require(_b <= _a);
35         uint256 c = _a - _b;
36         return c;
37     }
38 
39     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
40         uint256 c = _a + _b;
41         require(c >= _a);
42         return c;
43     }
44 
45     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
46         require(b != 0);
47         return a % b;
48     }
49 }
50 
51 contract Ownable {
52     address public owner;
53 
54     event OwnershipRenounced(address indexed previousOwner);
55     event OwnershipTransferred(
56         address indexed previousOwner,
57         address indexed newOwner
58     );
59 
60     constructor() public {
61         owner = msg.sender;
62     }
63 
64     modifier onlyOwner() {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function renounceOwnership() public onlyOwner {
70         emit OwnershipRenounced(owner);
71         owner = address(0);
72     }
73 
74     function transferOwnership(address _newOwner) public onlyOwner {
75         _transferOwnership(_newOwner);
76     }
77 
78     function _transferOwnership(address _newOwner) internal {
79         require(_newOwner != address(0));
80         emit OwnershipTransferred(owner, _newOwner);
81         owner = _newOwner;
82     }
83 }
84 
85 contract Wallet is Ownable {
86     using SafeMath for uint256;
87 
88     LotteryData public lotteryData;
89 
90     uint256 public minPaymnent = 10**16;
91 
92     function setMinPayment(uint256 value) public onlyOwner {
93         minPaymnent = value;
94     }
95 
96     constructor() public {
97         lotteryData = LotteryData(msg.sender);
98     }
99 
100     function() payable external {
101         require(msg.value >= minPaymnent);
102         lotteryData.participate(msg.sender, msg.value);
103     }
104 
105     function finishDay() external returns(uint256) {
106         require(msg.sender == address(lotteryData));
107         uint256 balance = address(this).balance;
108         if (balance >= minPaymnent) {
109             lotteryData.getFunds.value(balance)();
110             return balance;
111         } else {
112             return 0;
113         }
114     }
115 }
116 
117 contract LotteryData is Ownable {
118     using SafeMath for uint;
119 
120     event Withdrawn(address indexed payee, uint256 weiAmount);
121     event Deposited(address indexed payee, uint256 weiAmount);
122     event WinnerWallet(address indexed wallet, uint256 bank);
123 
124     Wallet public wallet_0 = new Wallet();
125     Wallet public wallet_1 = new Wallet();
126     Wallet public wallet_2 = new Wallet();
127 
128     uint256 public finishTime;
129     uint256 constant roundTime = 86400;
130 
131     uint internal dilemma;
132     uint internal max_participators = 100;
133     uint internal participators;
134     uint internal randNonce = 19;
135     uint internal winner;
136     uint internal winner_1;
137     uint internal winner_2;
138     uint256 internal fund;
139     uint256 internal commission;
140     uint256 internal totalBetsWithoutCommission;
141 
142     mapping(uint => address) public wallets;
143     mapping(address => mapping (address => uint256)) public playersBets;
144     mapping(address => mapping (uint => address)) public players;
145     mapping(address => uint256) public totalBets;
146     mapping(address => uint) public totalPlayers;
147     mapping(address => uint256) private _deposits;
148 
149     uint public games;
150 
151     struct wins{
152         address winner;
153         uint256 time;
154     }
155 
156     mapping(uint => wins) public gamesLog;
157 
158     constructor() public {
159         wallets[0] = address(wallet_0);
160         wallets[1] = address(wallet_1);
161         wallets[2] = address(wallet_2);
162         finishTime = now.add(roundTime);
163     }
164 
165     modifier validWallets() {
166         require(
167             msg.sender == address(wallet_0) ||
168             msg.sender == address(wallet_1) ||
169             msg.sender == address(wallet_2)
170         );
171         _;
172     }
173 
174     function depositsOf(address payee) public view returns (uint256) {
175         return _deposits[payee];
176     }
177 
178     function deposit(address payee, uint256 amount) internal {
179         _deposits[payee] = _deposits[payee].add(amount);
180         emit Deposited(payee, amount);
181     }
182 
183     function getFunds() public payable validWallets {}
184 
185     function lastWinner() public view returns(address) {
186         return gamesLog[games].winner;
187     }
188 
189     function getRandomWallet() internal returns(uint) {
190         uint result = uint(keccak256(abi.encodePacked(now, randNonce, blockhash(block.number - 1)))) % 3;
191         randNonce = randNonce.add(result.add(2));
192         return result;
193     }
194 
195     function _fundriser() internal returns(uint256) {
196         fund = fund.add(wallet_0.finishDay());
197         fund = fund.add(wallet_1.finishDay());
198         return fund.add(wallet_2.finishDay());
199     }
200 
201     function _randomizer() internal returns(uint) {
202         // random choose one of three wallets
203         winner = getRandomWallet();
204         // check if this address had payments, if no solving it
205         if(totalPlayers[wallets[winner]] == 0) {
206             dilemma = uint(keccak256(abi.encodePacked(now, winner, blockhash(block.number - 1)))) % 2;
207             if(winner == 0) {
208                 if(dilemma == 1) {
209                     winner_1 = 2; winner_2 = 1;
210                 } else {
211                     winner_1 = 1; winner_2 = 2;
212                 }
213             }
214             if(winner == 1) {
215                 if(dilemma == 1) {
216                     winner_1 = 2; winner_2 = 0;
217                 } else {
218                     winner_1 = 0; winner_2 = 2;
219                 }
220             }
221             if(winner == 2) {
222                 if(dilemma == 1) {
223                     winner_1 = 1; winner_2 = 0;
224                 } else {
225                     winner_1 = 0; winner_2 = 1;
226                 }
227             }
228             winner = (totalPlayers[wallets[winner_1]] == 0) ? winner_2 : winner_1;
229         }
230 
231         return winner;
232     }
233 
234     function _distribute() internal {
235         // calculate commission
236         commission = fund.mul(15).div(100);
237         totalBetsWithoutCommission = fund.sub(commission);
238         deposit(owner, commission);
239         // calculate and make deposits
240         for (uint i = 0; i < totalPlayers[wallets[winner]]; i++) {
241             uint percents = playersBets[wallets[winner]][players[wallets[winner]][i]].mul(10000).div(totalBets[wallets[winner]]);
242             deposit(players[wallets[winner]][i], totalBetsWithoutCommission.mul(percents).div(10000));
243         }
244     }
245 
246     function _collector() internal {
247         fund = 0;
248         participators = 0;
249         totalBets[wallets[0]] = 0;
250         for (uint j = 0; j < 3; j++) {
251             for (uint k = 0; k < totalPlayers[wallets[j]]; k++) {
252                 playersBets[wallets[j]][players[wallets[j]][k]] = 0;
253                 players[wallets[j]][k] = address(0x0);
254             }
255             totalBets[wallets[j]] = 0;
256             totalPlayers[wallets[j]] = 0;
257         }
258     }
259 
260     function _logger(address _winner, uint256 _fund) internal {
261         games = games + 1;
262         gamesLog[games].winner =_winner;
263         gamesLog[games].time = now;
264         emit WinnerWallet(_winner, _fund);
265     }
266 
267     function participate(address player, uint256 amount) external validWallets {
268         if (now >= finishTime || participators >= max_participators) {
269             // send all funds to this wallet
270             fund = _fundriser();
271             // if it has participators
272             if(fund > 0) {
273                 // get winner
274                 winner = _randomizer();
275                 // _distribute
276                 _distribute();
277                 // clear state
278                 _collector();
279                 // log data
280                 _logger(wallets[winner], fund);
281             }
282             // update round
283             finishTime = now.add(roundTime);
284         }
285 
286         if (playersBets[msg.sender][player] == 0) {
287             players[msg.sender][totalPlayers[msg.sender]] = player;
288             totalPlayers[msg.sender] = totalPlayers[msg.sender].add(1);
289             participators = participators.add(1);
290         }
291         playersBets[msg.sender][player] = playersBets[msg.sender][player].add(amount);
292         totalBets[msg.sender] = totalBets[msg.sender].add(amount);
293     }
294 
295     /**
296     * @dev Withdraw accumulated balance for a payee.
297     */
298     function withdraw() public {
299         uint256 payment = _deposits[msg.sender];
300         _deposits[msg.sender] = 0;
301         msg.sender.transfer(payment);
302         emit Withdrawn(msg.sender, payment);
303     }
304 
305     function paymentValidator(address _payee, uint256 _amount) internal {
306         if(_payee != address(wallet_0) &&
307            _payee != address(wallet_1) &&
308            _payee != address(wallet_2))
309         {
310             if(_amount == uint(0)) {
311                 if(depositsOf(_payee) != uint(0)) {
312                     withdraw();
313                 } else {
314                     revert("You have zero balance");
315                 }
316             } else {
317                 revert("You can't do nonzero transaction");
318             }
319         }
320     }
321 
322     function() external payable {
323         paymentValidator(msg.sender, msg.value);
324     }
325 }