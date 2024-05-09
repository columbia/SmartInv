1 pragma solidity ^0.4.25;
2 
3 interface DSG {
4     function gamingDividendsReception() payable external;
5 }
6 
7 contract CoinFlipper{
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
51         jackpotBalance = jackpotBalance.add(msg.value.div(100));
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
70         uint256 winRate    = getWinningRate(usersBets[msg.sender].bet);
71         uint256 r = _random(1200);
72         if(((r > 0 && r < 200) || (r > 400 && r < 600) || (r > 800 && r < 1000)) && coin == 1){
73             totalWinAmount = totalWinAmount.add(bet.add(bet.mul(winRate).div(100)));
74             jackpotBalance = jackpotBalance.add(bet.mul(100 - winRate).div(1000));
75         }
76         if(((r > 200 && r < 400) || (r > 600 && r < 800) || (r > 1000 && r < 1200)) && coin == 0){
77             totalWinAmount = totalWinAmount.add(bet.add(bet.mul(winRate).div(100)));
78             jackpotBalance = jackpotBalance.add(bet.mul(100 - winRate).div(1000));
79         }
80         if(bet >= minBetForJackpot && r == 0 && jackpotBalance > 0){
81             totalWinAmount = totalWinAmount.add(jackpotBalance).add(bet.add(bet.mul(winRate).div(100)));
82             delete jackpotBalance;
83         }
84         if(totalWinAmount > 0){
85             msg.sender.transfer(totalWinAmount);
86             totalWinnings = totalWinnings.add(totalWinAmount);
87         }
88         else{
89             jackpotBalance = jackpotBalance.add(bet.div(100));
90         }
91         delete usersBets[msg.sender];
92         emit Result(msg.sender, coin, r, totalWinAmount, jackpotBalance, winRate, bet);
93     }
94     function sendDividends() public {
95         require(getContractBalance() > minContractBalance && now > nextPayout, "You cannot send dividends");
96         DSG DSG0 = DSG(DSG_ADDRESS);
97         uint256 balance = getContractBalance();
98         uint256 dividends  = balance.sub(minContractBalance);
99         nextPayout         = now.add(7 days);
100         totalDividends = totalDividends.add(dividends);
101         DSG0.gamingDividendsReception.value(dividends)();
102         emit Dividends(balance, dividends, now);
103     }
104     function getWinningRate(uint256 eth) public view returns(uint8){
105         uint256 x = maxBet.sub(minBet).div(4);
106         uint8 rate;
107         if(eth >= minBet && eth <= minBet.add(x)){
108             rate = 95;
109         }
110         else if(eth >= minBet.add(x.mul(1)) && eth <= minBet.add(x.mul(2))){
111             rate = 96;
112         }
113         else if(eth >= minBet.add(x.mul(2)) && eth <= minBet.add(x.mul(3))){
114             rate = 97;
115         }
116         else if(eth >= minBet.add(x.mul(3)) && eth <= minBet.add(x.mul(4))){
117             rate = 98;
118         }
119         else{
120             rate = 95;
121         }
122         return rate;
123     }
124     function getContractBalance() public view returns (uint256) {
125         return address(this).balance;
126     }
127     function _random(uint256 max) private view returns(uint256){
128         bytes32 hash = blockhash(usersBets[msg.sender].blockNumber);
129         return uint256(keccak256(abi.encode(hash, now, msg.sender))) % max;
130     }
131     function deposit() public payable onlyOwners{
132         ownerDeposit = ownerDeposit.add(msg.value);
133         jackpotBalance = jackpotBalance.add(msg.value.div(100));
134     }
135     function sendOwnerDeposit(address recipient) public onlyOwners{
136         require(paused == true, 'Game was not stopped');
137         uint256 contractBalance = getContractBalance();
138         if(contractBalance >= ownerDeposit){
139             recipient.transfer(ownerDeposit);
140         }
141         else{
142             recipient.transfer(contractBalance);
143         }
144         delete jackpotBalance;
145         delete ownerDeposit;
146     }
147     function pauseGame(bool option) public onlyOwners{
148         paused = option;
149     }
150     function setMinBet(uint256 eth) public onlyOwners{
151         minBet = eth;
152     }
153     function setMaxBet(uint256 eth) public onlyOwners{
154         maxBet = eth;
155     }
156     function setMinBetForJackpot(uint256 eth) public onlyOwners{
157         minBetForJackpot = eth;
158     }
159     function setMinContractBalance(uint256 eth) public onlyOwners{
160         minContractBalance = eth;
161     }
162     function transferOwnership(address newOwnerAddress, uint8 k) public onlyOwners {
163         candidates[k] = newOwnerAddress;
164     }
165     function confirmOwner(uint8 k) public {
166         require(msg.sender == candidates[k]);
167         owners[k] = candidates[k];
168     }
169     event Dividends(
170         uint256 balance,
171         uint256 dividends,
172         uint256 timestamp
173     );
174     event Jackpot(
175         address indexed player,
176         uint256 jackpot,
177         uint256 timestamp
178     );
179     event PlaceBet(
180         address indexed player,
181         uint256 bet,
182         uint256 coin,
183         uint256 timestamp
184     );
185     event Result(
186         address indexed player,
187         uint256 indexed coin,
188         uint256 indexed random,
189         uint256 totalWinAmount,
190         uint256 jackpotBalance,
191         uint256 winRate,
192         uint256 bet
193     );
194 }
195 library SafeMath {
196     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
197         if (a == 0) {  return 0; }
198         uint256 c = a * b;
199         require(c / a == b);
200         return c;
201     }
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         require(b > 0);
204         uint256 c = a / b;
205         return c;
206     }
207     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
208         require(b <= a);
209         uint256 c = a - b;
210         return c;
211     }
212     function add(uint256 a, uint256 b) internal pure returns (uint256) {
213         uint256 c = a + b;
214         require(c >= a);
215         return c;
216     }
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         require(b != 0);
219         return a % b;
220     }
221 }