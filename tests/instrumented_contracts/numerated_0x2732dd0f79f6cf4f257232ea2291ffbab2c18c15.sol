1 pragma solidity ^0.4.25;
2 
3 interface DSG {
4     function gamingDividendsReception() payable external;
5 }
6 
7 contract CoinFlipperDSG{
8     using SafeMath for uint256;
9     
10     address constant public DSG_ADDRESS = 0x696826C18A6Bc9Be4BBfe3c3A6BB9f5a69388687;
11     uint256 public totalDividends;
12     uint256 public totalWinnings;
13     uint256 public totalTurnover;
14     uint256 public maxBet;
15     uint256 public minBet;
16     uint256 public minContractBalance;
17     uint256 public minBetForJackpot;
18     uint256 public jackpotBalance;
19     uint256 public nextPayout;
20     uint256 public ownerDeposit;
21     address[2] public owners;
22     address[2] public candidates;
23     bool public paused;
24     
25     mapping (address => Bet) public usersBets;
26     
27     struct Bet {
28         uint256 blockNumber;
29         uint8 coin;
30         uint256 bet;
31     }
32     
33     modifier onlyOwners() {
34         require(msg.sender == owners[0] || msg.sender == owners[1]);
35         _;
36     }
37     modifier checkBlockNumber(){
38         uint256 blockNumber = usersBets[msg.sender].blockNumber;
39         if(block.number.sub(blockNumber) >= 250 && blockNumber > 0){
40             emit Result(msg.sender, 0, 1000, 0, jackpotBalance, 0, usersBets[msg.sender].bet);
41             delete usersBets[msg.sender];
42         }
43         else{
44             _;
45         }
46     }
47     constructor(address secondOwner) public payable{
48         owners[0]   = msg.sender;
49         owners[1]   = secondOwner;
50         ownerDeposit   = msg.value;
51         jackpotBalance = jackpotBalance.add(ownerDeposit.div(1000));
52     }
53     function play(uint8 coin) public payable checkBlockNumber{
54         uint256 bet = msg.value;
55         require(getContractBalance() > bet.add(bet).add(jackpotBalance), "Not enough ETH in contract");
56         require(paused == false, "Game was stopped");
57         require(bet >= minBet && bet <= maxBet, "Amount should be within range");
58         require(usersBets[msg.sender].bet == 0, "You have already bet");
59         usersBets[msg.sender].bet = bet;
60         usersBets[msg.sender].blockNumber = block.number;
61         usersBets[msg.sender].coin = coin;
62         totalTurnover = totalTurnover.add(bet);
63         emit PlaceBet(msg.sender, bet, coin, now);
64     }
65     function result() public checkBlockNumber{
66         require(blockhash(usersBets[msg.sender].blockNumber) != 0, "Your time to determine the result has come out or not yet come");
67         uint256 bet = usersBets[msg.sender].bet;
68         uint8   coin = usersBets[msg.sender].coin;
69         uint256 totalWinAmount;
70         uint256 winRate    = getWinningRate(bet);
71         uint256 r = _random(1200);
72         if(((r > 0 && r < 200) || (r > 400 && r < 600) || (r > 800 && r < 1000)) && coin == 1){
73             totalWinAmount = totalWinAmount.add(bet.mul(winRate).div(100));
74             jackpotBalance = jackpotBalance.add(bet.div(1000));
75         }
76         if(((r > 200 && r < 400) || (r > 600 && r < 800) || (r > 1000 && r < 1200)) && coin == 0){
77             totalWinAmount = totalWinAmount.add(bet.mul(winRate).div(100));
78             jackpotBalance = jackpotBalance.add(bet.div(1000));
79         }
80         if(bet >= minBetForJackpot && r == 0 && jackpotBalance > 0){
81             totalWinAmount = totalWinAmount.add(jackpotBalance).add(bet);
82             delete jackpotBalance;
83         }
84         if(totalWinAmount > 0){
85             msg.sender.transfer(totalWinAmount);
86             totalWinnings = totalWinnings.add(totalWinAmount);
87         }
88         delete usersBets[msg.sender];
89         emit Result(msg.sender, coin, r, totalWinAmount, jackpotBalance, winRate, bet);
90     }
91     function sendDividends() public {
92         require(getContractBalance() > minContractBalance && now > nextPayout, "You cannot send dividends");
93         DSG DSG0 = DSG(DSG_ADDRESS);
94         uint256 balance = getContractBalance();
95         uint256 dividends  = balance.sub(minContractBalance);
96         nextPayout         = now.add(7 days);
97         totalDividends = totalDividends.add(dividends);
98         DSG0.gamingDividendsReception.value(dividends)();
99         emit Dividends(balance, dividends, now);
100     }
101     function getWinningRate(uint256 eth) public view returns(uint8){
102         uint256 x = maxBet.sub(minBet).div(4);
103         if(eth >= minBet && eth <= minBet.add(x)){
104             return 194;
105         }
106         else if(eth >= minBet.add(x.mul(1)) && eth <= minBet.add(x.mul(2))){
107             return 195;
108         }
109         else if(eth >= minBet.add(x.mul(2)) && eth <= minBet.add(x.mul(3))){
110             return 196;
111         }
112         else if(eth >= minBet.add(x.mul(3)) && eth <= minBet.add(x.mul(4))){
113             return 197;
114         }
115         else{
116             return 194;
117         }
118     }
119     function getContractBalance() public view returns (uint256) {
120         return address(this).balance;
121     }
122     function _random(uint256 max) private view returns(uint256){
123         bytes32 hash = blockhash(usersBets[msg.sender].blockNumber);
124         return uint256(keccak256(abi.encode(hash, now, msg.sender))) % max;
125     }
126     function deposit() public payable onlyOwners{
127         ownerDeposit = ownerDeposit.add(msg.value);
128         jackpotBalance = jackpotBalance.add(msg.value.div(100));
129     }
130     function sendOwnerDeposit(address recipient) public onlyOwners{
131         require(paused == true, 'Game was not stopped');
132         uint256 contractBalance = getContractBalance();
133         if(contractBalance >= ownerDeposit){
134             recipient.transfer(ownerDeposit);
135         }
136         else{
137             recipient.transfer(contractBalance);
138         }
139         delete jackpotBalance;
140         delete ownerDeposit;
141     }
142     function pauseGame(bool option) public onlyOwners{
143         paused = option;
144     }
145     function setMinBet(uint256 eth) public onlyOwners{
146         minBet = eth;
147     }
148     function setMaxBet(uint256 eth) public onlyOwners{
149         maxBet = eth;
150     }
151     function setMinBetForJackpot(uint256 eth) public onlyOwners{
152         minBetForJackpot = eth;
153     }
154     function setMinContractBalance(uint256 eth) public onlyOwners{
155         minContractBalance = eth;
156     }
157     function transferOwnership(address newOwnerAddress, uint8 k) public onlyOwners {
158         candidates[k] = newOwnerAddress;
159     }
160     function confirmOwner(uint8 k) public {
161         require(msg.sender == candidates[k]);
162         owners[k] = candidates[k];
163     }
164     event Dividends(
165         uint256 balance,
166         uint256 dividends,
167         uint256 timestamp
168     );
169     event Jackpot(
170         address indexed player,
171         uint256 jackpot,
172         uint256 timestamp
173     );
174     event PlaceBet(
175         address indexed player,
176         uint256 bet,
177         uint256 coin,
178         uint256 timestamp
179     );
180     event Result(
181         address indexed player,
182         uint256 indexed coin,
183         uint256 indexed random,
184         uint256 totalWinAmount,
185         uint256 jackpotBalance,
186         uint256 winRate,
187         uint256 bet
188     );
189 }
190 library SafeMath {
191     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
192         if (a == 0) {  return 0; }
193         uint256 c = a * b;
194         require(c / a == b);
195         return c;
196     }
197     function div(uint256 a, uint256 b) internal pure returns (uint256) {
198         require(b > 0);
199         uint256 c = a / b;
200         return c;
201     }
202     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
203         require(b <= a);
204         uint256 c = a - b;
205         return c;
206     }
207     function add(uint256 a, uint256 b) internal pure returns (uint256) {
208         uint256 c = a + b;
209         require(c >= a);
210         return c;
211     }
212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213         require(b != 0);
214         return a % b;
215     }
216 }