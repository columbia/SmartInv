1 pragma solidity ^0.4.25;
2 
3 interface DSG {
4     function gamingDividendsReception() payable external;
5 }
6 
7 contract DSG_CoinFlipper{
8     using SafeMath for uint256;
9     
10     address constant public DSG_ADDRESS = 0x696826C18A6Bc9Be4BBfe3c3A6BB9f5a69388687;
11     uint256 public totalDividends;
12     uint256 public totalWinnings;
13     uint256 public totalTurnover;
14     uint256 public totalPlayed;
15     uint256 public maxBet;
16     uint256 public minBet;
17     uint256 public minContractBalance;
18     uint256 public minBetForJackpot;
19     uint256 public jackpotBalance;
20     uint256 public nextPayout;
21     uint256 public ownerDeposit;
22     address[2] public owners;
23     address[2] public candidates;
24     bool public paused;
25     
26     mapping (address => Bet) private usersBets;
27     
28     struct Bet {
29         uint256 blockNumber;
30         uint8 coin;
31         uint256 bet;
32     }
33     
34     modifier onlyOwners() {
35         require(msg.sender == owners[0] || msg.sender == owners[1]);
36         _;
37     }
38     modifier onlyUsers(){
39         require(tx.origin == msg.sender);
40         _;
41     }
42     modifier checkBlockNumber(){
43         uint256 blockNumber = usersBets[msg.sender].blockNumber;
44         if(block.number.sub(blockNumber) >= 250 && blockNumber > 0){
45             emit Result(msg.sender, 0, 1200, 0, jackpotBalance, 0, usersBets[msg.sender].bet);
46             delete usersBets[msg.sender];
47         }
48         else{
49             _;
50         }
51     }
52     constructor(address secondOwner) public payable{
53         owners[0]   = msg.sender;
54         owners[1]   = secondOwner;
55         ownerDeposit   = msg.value;
56         jackpotBalance = jackpotBalance.add(ownerDeposit.div(1000));
57     }
58     function play(uint8 coin) public payable checkBlockNumber onlyUsers{
59         uint256 bet = msg.value;
60         require(getContractBalance() > bet.add(bet).add(jackpotBalance), "Not enough ETH in contract");
61         require(bet >= minBet && bet <= maxBet, "Amount should be within range");
62         require(usersBets[msg.sender].bet == 0, "You have already bet");
63         require(coin == 0 || coin == 1, "Coin side is incorrect");
64         require(paused == false, "Game was stopped");
65         usersBets[msg.sender].bet = bet;
66         usersBets[msg.sender].blockNumber = block.number;
67         usersBets[msg.sender].coin = coin;
68         totalTurnover = totalTurnover.add(bet);
69         totalPlayed = totalPlayed.add(1);
70         emit PlaceBet(msg.sender, bet, coin, now);
71     }
72     function result() public checkBlockNumber onlyUsers{
73         require(blockhash(usersBets[msg.sender].blockNumber) != 0, "Your time to determine the result has come out or not yet come");
74         uint256 bet = usersBets[msg.sender].bet;
75         uint8   coin = usersBets[msg.sender].coin;
76         uint256 totalWinAmount;
77         uint256 winRate    = getWinningRate(bet);
78         uint256 r = _random(1200);
79         if(((r > 0 && r < 200) || (r > 400 && r < 600) || (r > 800 && r < 1000)) && coin == 1){
80             totalWinAmount = totalWinAmount.add(bet.mul(winRate).div(100));
81         }
82         if(((r > 200 && r < 400) || (r > 600 && r < 800) || (r > 1000 && r < 1200)) && coin == 0){
83             totalWinAmount = totalWinAmount.add(bet.mul(winRate).div(100));
84         }
85         if(bet >= minBetForJackpot && r == 0 && jackpotBalance > 0){
86             totalWinAmount = totalWinAmount.add(jackpotBalance).add(bet);
87             delete jackpotBalance;
88         }
89         if(totalWinAmount > 0){
90             msg.sender.transfer(totalWinAmount);
91             totalWinnings = totalWinnings.add(totalWinAmount);
92         }
93         jackpotBalance = jackpotBalance.add(bet.div(1000));
94         delete usersBets[msg.sender];
95         emit Result(msg.sender, coin, r, totalWinAmount, jackpotBalance, winRate, bet);
96     }
97     function sendDividends() public {
98         require(getContractBalance() > minContractBalance && now > nextPayout, "You cannot send dividends");
99         DSG DSG0 = DSG(DSG_ADDRESS);
100         uint256 balance = getContractBalance();
101         uint256 dividends = balance.sub(minContractBalance);
102         nextPayout = now.add(7 days);
103         totalDividends = totalDividends.add(dividends);
104         DSG0.gamingDividendsReception.value(dividends)();
105         emit Dividends(balance, dividends, now);
106     }
107     function getWinningRate(uint256 eth) public view returns(uint8){
108         uint256 x = maxBet.sub(minBet).div(4);
109         if(eth >= minBet && eth <= minBet.add(x)){
110             return 194;
111         }
112         else if(eth >= minBet.add(x.mul(1)) && eth <= minBet.add(x.mul(2))){
113             return 195;
114         }
115         else if(eth >= minBet.add(x.mul(2)) && eth <= minBet.add(x.mul(3))){
116             return 196;
117         }
118         else if(eth >= minBet.add(x.mul(3)) && eth <= minBet.add(x.mul(4))){
119             return 197;
120         }
121         else{
122             return 194;
123         }
124     }
125     function getContractBalance() public view returns (uint256) {
126         return address(this).balance;
127     }
128     function _random(uint256 max) private view returns(uint256){
129         bytes32 hash = blockhash(usersBets[msg.sender].blockNumber);
130         return uint256(keccak256(abi.encode(hash, msg.sender))) % max;
131     }
132     function deposit() public payable onlyOwners{
133         ownerDeposit = ownerDeposit.add(msg.value);
134         jackpotBalance = jackpotBalance.add(msg.value.div(100));
135     }
136     function sendOwnerDeposit(address recipient) public onlyOwners{
137         require(paused == true, 'Game was not stopped');
138         uint256 contractBalance = getContractBalance();
139         if(contractBalance >= ownerDeposit){
140             recipient.transfer(ownerDeposit);
141         }
142         else{
143             recipient.transfer(contractBalance);
144         }
145         delete jackpotBalance;
146         delete ownerDeposit;
147     }
148     function pauseGame(bool option) public onlyOwners{
149         paused = option;
150     }
151     function setMinBet(uint256 eth) public onlyOwners{
152         minBet = eth;
153     }
154     function setMaxBet(uint256 eth) public onlyOwners{
155         maxBet = eth;
156     }
157     function setMinBetForJackpot(uint256 eth) public onlyOwners{
158         minBetForJackpot = eth;
159     }
160     function setMinContractBalance(uint256 eth) public onlyOwners{
161         minContractBalance = eth;
162     }
163     function transferOwnership(address newOwnerAddress, uint8 k) public onlyOwners {
164         candidates[k] = newOwnerAddress;
165     }
166     function confirmOwner(uint8 k) public {
167         require(msg.sender == candidates[k]);
168         owners[k] = candidates[k];
169     }
170     event Dividends(
171         uint256 balance,
172         uint256 dividends,
173         uint256 timestamp
174     );
175     event Jackpot(
176         address indexed player,
177         uint256 jackpot,
178         uint256 timestamp
179     );
180     event PlaceBet(
181         address indexed player,
182         uint256 bet,
183         uint256 coin,
184         uint256 timestamp
185     );
186     event Result(
187         address indexed player,
188         uint256 indexed coin,
189         uint256 indexed random,
190         uint256 totalWinAmount,
191         uint256 jackpotBalance,
192         uint256 winRate,
193         uint256 bet
194     );
195 }
196 library SafeMath {
197     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
198         if (a == 0) {  return 0; }
199         uint256 c = a * b;
200         require(c / a == b);
201         return c;
202     }
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         require(b > 0);
205         uint256 c = a / b;
206         return c;
207     }
208     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
209         require(b <= a);
210         uint256 c = a - b;
211         return c;
212     }
213     function add(uint256 a, uint256 b) internal pure returns (uint256) {
214         uint256 c = a + b;
215         require(c >= a);
216         return c;
217     }
218     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
219         require(b != 0);
220         return a % b;
221     }
222 }