1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
6         if (_a == 0) {
7             return 0;
8         }
9         uint256 c = _a * _b;
10         require(c / _a == _b);
11         return c;
12     }
13 
14     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
15         require(_b > 0);
16         uint256 c = _a / _b;
17         return c;
18     }
19 
20     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
21         require(_b <= _a);
22         uint256 c = _a - _b;
23         return c;
24     }
25 
26     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
27         uint256 c = _a + _b;
28         require(c >= _a);
29         return c;
30     }
31 
32     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b != 0);
34         return a % b;
35     }
36 }
37 
38 contract Ownable {
39     address public owner;
40 
41     event OwnershipRenounced(address indexed previousOwner);
42     event OwnershipTransferred(
43         address indexed previousOwner,
44         address indexed newOwner
45     );
46 
47     constructor() public {
48         owner = msg.sender;
49     }
50 
51     modifier onlyOwner() {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipRenounced(owner);
58         owner = address(0);
59     }
60 
61     function transferOwnership(address _newOwner) public onlyOwner {
62         _transferOwnership(_newOwner);
63     }
64 
65     function _transferOwnership(address _newOwner) internal {
66         require(_newOwner != address(0));
67         emit OwnershipTransferred(owner, _newOwner);
68         owner = _newOwner;
69     }
70 }
71 
72 contract Wallet is Ownable {
73     using SafeMath for uint256;
74 
75     LotteryData public lotteryData;
76 
77     uint256 public minPaymnent = 10**16;
78 
79     function setMinPayment(uint256 value) public onlyOwner {
80         minPaymnent = value;
81     }
82 
83     constructor() public {
84         lotteryData = LotteryData(msg.sender);
85     }
86 
87     function() payable external {
88         require(msg.value >= minPaymnent);
89         lotteryData.participate(msg.sender, msg.value);
90     }
91 
92     function finishDay() external returns(uint256) {
93         require(msg.sender == address(lotteryData));
94         uint256 balance = address(this).balance;
95         if (balance >= minPaymnent) {
96             lotteryData.getFunds.value(balance)();
97             return balance;
98         }
99         else {
100             return 0;
101         }
102     }
103 }
104 
105 contract LotteryData is Ownable {
106     using SafeMath for uint256;
107 
108     event Withdrawn(address indexed payee, uint256 weiAmount);
109     event Deposited(address indexed payee, uint256 weiAmount);
110     event WinnerWallet(address indexed wallet, uint256 bank);
111 
112     Wallet public wallet_0 = new Wallet();
113     Wallet public wallet_1 = new Wallet();
114     Wallet public wallet_2 = new Wallet();
115 
116     uint256 public finishTime;
117     uint256 constant roundTime = 86400;
118 
119     uint internal dilemma;
120     uint internal max_participators = 100;
121     uint internal participators;
122     uint internal randNonce = 19;
123     uint internal winner;
124     uint internal winner_1;
125     uint internal winner_2;
126     uint256 internal fund;
127     uint256 internal commission;
128     uint256 internal totalBetsWithoutCommission;
129 
130     mapping(uint => address) public wallets;
131     mapping(address => mapping (address => uint256)) public playersBets;
132     mapping(address => mapping (uint => address)) public players;
133     mapping(address => uint256) public totalBets;
134     mapping(address => uint) public totalPlayers;
135     mapping(address => uint256) private _deposits;
136 
137     //monitoring part
138     uint public games;
139 
140     struct wins{
141         address winner;
142         uint256 time;
143     }
144 
145     mapping(uint => wins) public gamesLog;
146 
147     constructor() public {
148         wallets[0] = address(wallet_0);
149         wallets[1] = address(wallet_1);
150         wallets[2] = address(wallet_2);
151         finishTime = now.add(roundTime);
152     }
153 
154     modifier validWallets() {
155         require(
156             msg.sender == address(wallet_0) ||
157             msg.sender == address(wallet_1) ||
158             msg.sender == address(wallet_2)
159         );
160         _;
161     }
162 
163     function depositsOf(address payee) public view returns (uint256) {
164         return _deposits[payee];
165     }
166 
167     function deposit(address payee, uint256 amount) internal {
168         _deposits[payee] = _deposits[payee].add(amount);
169         emit Deposited(payee, amount);
170     }
171 
172     function getFunds() public payable validWallets {}
173 
174     function lastWinner() public view returns(address) {
175         return gamesLog[games].winner;
176     }
177 
178     function getRandomWallet() internal returns(uint) {
179         uint result = uint(keccak256(abi.encodePacked(now, randNonce, blockhash(block.number - 1)))) % 3;
180         randNonce = randNonce.add(result.add(2));
181         return result;
182     }
183 
184     function _fundriser() internal returns(uint256) {
185         fund = fund.add(wallet_0.finishDay());
186         fund = fund.add(wallet_1.finishDay());
187         return fund.add(wallet_2.finishDay());
188     }
189 
190     function _randomizer() internal returns(uint) {
191         // random choose one of three wallets
192         winner = getRandomWallet();
193         // check if this address had payments, if no solving it
194         if(totalPlayers[wallets[winner]] == 0) {
195             dilemma = uint(keccak256(abi.encodePacked(now, winner, blockhash(block.number - 1)))) % 2;
196             if(winner == 0) {
197                 if(dilemma == 1) {
198                     winner_1 = 2;
199                     winner_2 = 1;
200                 } else {
201                     winner_1 = 1;
202                     winner_2 = 2;
203                 }
204             }
205             if(winner == 1) {
206                 if(dilemma == 1) {
207                     winner_1 = 2;
208                     winner_2 = 0;
209                 } else {
210                     winner_1 = 0;
211                     winner_2 = 2;
212                 }
213             }
214             if(winner == 2) {
215                 if(dilemma == 1) {
216                     winner_1 = 1;
217                     winner_2 = 0;
218                 } else {
219                     winner_1 = 0;
220                     winner_2 = 1;
221                 }
222             }
223             winner = (totalPlayers[wallets[winner_1]] == 0) ? winner_2 : winner_1;
224         }
225 
226         return winner;
227     }
228 
229     function _distribute() internal {
230         // calculate commission
231         commission = fund.mul(15).div(100);
232         totalBetsWithoutCommission = fund.sub(commission);
233         deposit(owner, commission);
234         // calculate and make deposits
235         for (uint i = 0; i < totalPlayers[wallets[winner]]; i++) {
236             uint percents = playersBets[wallets[winner]][players[wallets[winner]][i]].mul(10000).div(totalBets[wallets[winner]]);
237             deposit(players[wallets[winner]][i], totalBetsWithoutCommission.mul(percents).div(10000));
238         }
239     }
240 
241     function _collector() internal {
242         fund = 0;
243         participators = 0;
244         totalBets[wallets[0]] = 0;
245         for (uint j = 0; j < 3; j++) {
246             for (uint k = 0; k < totalPlayers[wallets[j]]; k++) {
247                 playersBets[wallets[j]][players[wallets[j]][k]] = 0;
248                 players[wallets[j]][k] = address(0x0);
249             }
250             totalBets[wallets[j]] = 0;
251             totalPlayers[wallets[j]] = 0;
252         }
253     }
254 
255     function _logger(address _winner, uint256 _fund) internal {
256         games = games + 1;
257         gamesLog[games].winner =_winner;
258         gamesLog[games].time = now;
259         emit WinnerWallet(_winner, _fund);
260     }
261 
262     function participate(address player, uint256 amount) external validWallets {
263         if (now >= finishTime || participators >= max_participators) {
264             // send all funds to this wallet
265             fund = _fundriser();
266             // if it has participators
267             if(fund > 0) {
268                 // get winner
269                 winner = _randomizer();
270                 // _distribute
271                 _distribute();
272                 // clear state
273                 _collector();
274                 // log data
275                 _logger(wallets[winner], fund);
276             }
277             // update round
278             finishTime = finishTime.add(roundTime);
279         }
280 
281         if (playersBets[msg.sender][player] == 0) {
282             players[msg.sender][totalPlayers[msg.sender]] = player;
283             totalPlayers[msg.sender] = totalPlayers[msg.sender].add(1);
284             participators = participators.add(1);
285         }
286         playersBets[msg.sender][player] = playersBets[msg.sender][player].add(amount);
287         totalBets[msg.sender] = totalBets[msg.sender].add(amount);
288     }
289 
290     /**
291     * @dev Withdraw accumulated balance for a payee.
292     */
293     function withdraw() public {
294         uint256 payment = _deposits[msg.sender];
295         _deposits[msg.sender] = 0;
296         msg.sender.transfer(payment);
297         emit Withdrawn(msg.sender, payment);
298     }
299 
300     function paymentValidator(address _payee, uint256 _amount) internal {
301         if(_payee != address(wallet_0) &&
302            _payee != address(wallet_1) &&
303            _payee != address(wallet_2))
304         {
305             if(_amount == uint(0)) {
306                 if(depositsOf(_payee) != uint(0)) {
307                     withdraw();
308                 } else {
309                     revert("You have zero balance");
310                 }
311             } else {
312                 revert("You can't do nonzero transaction");
313             }
314         }
315     }
316 
317     function() external payable {
318         paymentValidator(msg.sender, msg.value);
319     }
320 }