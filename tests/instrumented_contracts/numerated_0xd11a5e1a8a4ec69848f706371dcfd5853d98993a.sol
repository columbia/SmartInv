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
21     uint256 private entropy;
22     address[2] public owners;
23     address[2] public candidates;
24     bool public paused;
25     
26     mapping (address => Bet) public usersBets;
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
38     modifier checkBlockNumber(){
39         uint256 blockNumber = usersBets[msg.sender].blockNumber;
40         if(block.number.sub(blockNumber) >= 250 && blockNumber > 0){
41             emit Result(msg.sender, 0, 1000, 0, jackpotBalance, 0, usersBets[msg.sender].bet);
42             delete usersBets[msg.sender];
43         }
44         else{
45             _;
46         }
47     }
48     constructor(address secondOwner) public payable{
49         owners[0]   = msg.sender;
50         owners[1]   = secondOwner;
51         ownerDeposit   = msg.value;
52         jackpotBalance = jackpotBalance.add(msg.value.div(100));
53     }
54     function play(uint8 coin) public payable checkBlockNumber{
55         uint256 bet = msg.value;
56         require(getContractBalance() > bet.add(bet).add(jackpotBalance), "Not enough ETH in contract");
57         require(paused == false, "Game was stopped");
58         require(bet >= minBet && bet <= maxBet, "Amount should be within range");
59         require(usersBets[msg.sender].bet == 0, "You have already bet");
60         usersBets[msg.sender].bet = bet;
61         usersBets[msg.sender].blockNumber = block.number;
62         usersBets[msg.sender].coin = coin;
63         totalTurnover = totalTurnover.add(bet);
64         emit PlaceBet(msg.sender, bet, coin, now);
65     }
66     function result() public checkBlockNumber{
67         require(blockhash(usersBets[msg.sender].blockNumber) != 0, "Your time to determine the result has come out or not yet come");
68         uint256 bet = usersBets[msg.sender].bet;
69         uint8   coin = usersBets[msg.sender].coin;
70         uint256 totalWinAmount;
71         uint256 winRate    = getWinningRate(usersBets[msg.sender].bet);
72         uint256 randomNumber = random(1000);
73         if(randomNumber > 499 && coin == 0){
74             totalWinAmount = totalWinAmount.add(bet.add(bet.mul(winRate).div(100)));
75             jackpotBalance = jackpotBalance.add(bet.mul(100 - winRate).div(1000));
76         }
77         if(randomNumber < 499 && coin == 1){
78             totalWinAmount = totalWinAmount.add(bet.add(bet.mul(winRate).div(100)));
79             jackpotBalance = jackpotBalance.add(bet.mul(100 - winRate).div(1000));
80         }
81         if(bet >= minBetForJackpot && randomNumber == 499 && jackpotBalance > 0){
82             totalWinAmount = totalWinAmount.add(jackpotBalance);
83             jackpotBalance = jackpotBalance.sub(jackpotBalance);
84         }
85         if(totalWinAmount > 0){
86             msg.sender.transfer(totalWinAmount);
87         }
88         else{
89             jackpotBalance = jackpotBalance.add(bet.div(100));
90         }
91         entropy = entropy.add(randomNumber);
92         delete usersBets[msg.sender];
93         emit Result(msg.sender, coin, randomNumber, totalWinAmount, jackpotBalance, winRate, bet);
94     }
95     function sendDividends() public {
96         require(getContractBalance() > minContractBalance && now > nextPayout, "You cannot send dividends");
97         DSG DSG0 = DSG(DSG_ADDRESS);
98         uint256 balance = getContractBalance();
99         uint256 dividends  = balance.sub(minContractBalance);
100         nextPayout         = now.add(7 days);
101         totalDividends = totalDividends.add(dividends);
102         DSG0.gamingDividendsReception.value(dividends)();
103         emit Dividends(balance, dividends, now);
104     }
105     function getWinningRate(uint256 eth) public view returns(uint8){
106         uint256 x = maxBet.sub(minBet).div(4);
107         uint8 rate;
108         if(eth >= minBet && eth <= minBet.add(x)){
109             rate = 95;
110         }
111         else if(eth >= minBet.add(x.mul(1)) && eth <= minBet.add(x.mul(2))){
112             rate = 96;
113         }
114         else if(eth >= minBet.add(x.mul(2)) && eth <= minBet.add(x.mul(3))){
115             rate = 97;
116         }
117         else if(eth >= minBet.add(x.mul(3)) && eth <= minBet.add(x.mul(4))){
118             rate = 98;
119         }
120         else{
121             rate = 95;
122         }
123         return rate;
124     }
125     function getContractBalance() public view returns (uint256) {
126         return address(this).balance;
127     }
128     function random(uint256 max) public view returns(uint256){
129         bytes32 hash = blockhash(usersBets[msg.sender].blockNumber);
130         return uint256(keccak256(abi.encode(hash, now, entropy))) % max;
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
144             delete jackpotBalance;
145         }
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