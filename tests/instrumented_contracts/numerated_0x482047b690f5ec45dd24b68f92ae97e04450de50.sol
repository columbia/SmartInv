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
72         uint256 randomNumber = _random(1000);
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
87             totalWinnings = totalWinnings.add(totalWinAmount);
88         }
89         else{
90             jackpotBalance = jackpotBalance.add(bet.div(100));
91         }
92         entropy = entropy.add(randomNumber);
93         delete usersBets[msg.sender];
94         emit Result(msg.sender, coin, randomNumber, totalWinAmount, jackpotBalance, winRate, bet);
95     }
96     function sendDividends() public {
97         require(getContractBalance() > minContractBalance && now > nextPayout, "You cannot send dividends");
98         DSG DSG0 = DSG(DSG_ADDRESS);
99         uint256 balance = getContractBalance();
100         uint256 dividends  = balance.sub(minContractBalance);
101         nextPayout         = now.add(7 days);
102         totalDividends = totalDividends.add(dividends);
103         DSG0.gamingDividendsReception.value(dividends)();
104         emit Dividends(balance, dividends, now);
105     }
106     function getWinningRate(uint256 eth) public view returns(uint8){
107         uint256 x = maxBet.sub(minBet).div(4);
108         uint8 rate;
109         if(eth >= minBet && eth <= minBet.add(x)){
110             rate = 95;
111         }
112         else if(eth >= minBet.add(x.mul(1)) && eth <= minBet.add(x.mul(2))){
113             rate = 96;
114         }
115         else if(eth >= minBet.add(x.mul(2)) && eth <= minBet.add(x.mul(3))){
116             rate = 97;
117         }
118         else if(eth >= minBet.add(x.mul(3)) && eth <= minBet.add(x.mul(4))){
119             rate = 98;
120         }
121         else{
122             rate = 95;
123         }
124         return rate;
125     }
126     function getContractBalance() public view returns (uint256) {
127         return address(this).balance;
128     }
129     function _random(uint256 max) private view returns(uint256){
130         bytes32 hash = blockhash(usersBets[msg.sender].blockNumber);
131         return uint256(keccak256(abi.encode(hash, now, entropy))) % max;
132     }
133     function deposit() public payable onlyOwners{
134         ownerDeposit = ownerDeposit.add(msg.value);
135         jackpotBalance = jackpotBalance.add(msg.value.div(100));
136     }
137     function sendOwnerDeposit(address recipient) public onlyOwners{
138         require(paused == true, 'Game was not stopped');
139         uint256 contractBalance = getContractBalance();
140         if(contractBalance >= ownerDeposit){
141             recipient.transfer(ownerDeposit);
142         }
143         else{
144             recipient.transfer(contractBalance);
145         }
146         delete jackpotBalance;
147         delete ownerDeposit;
148     }
149     function pauseGame(bool option) public onlyOwners{
150         paused = option;
151     }
152     function setMinBet(uint256 eth) public onlyOwners{
153         minBet = eth;
154     }
155     function setMaxBet(uint256 eth) public onlyOwners{
156         maxBet = eth;
157     }
158     function setMinBetForJackpot(uint256 eth) public onlyOwners{
159         minBetForJackpot = eth;
160     }
161     function setMinContractBalance(uint256 eth) public onlyOwners{
162         minContractBalance = eth;
163     }
164     function transferOwnership(address newOwnerAddress, uint8 k) public onlyOwners {
165         candidates[k] = newOwnerAddress;
166     }
167     function confirmOwner(uint8 k) public {
168         require(msg.sender == candidates[k]);
169         owners[k] = candidates[k];
170     }
171     event Dividends(
172         uint256 balance,
173         uint256 dividends,
174         uint256 timestamp
175     );
176     event Jackpot(
177         address indexed player,
178         uint256 jackpot,
179         uint256 timestamp
180     );
181     event PlaceBet(
182         address indexed player,
183         uint256 bet,
184         uint256 coin,
185         uint256 timestamp
186     );
187     event Result(
188         address indexed player,
189         uint256 indexed coin,
190         uint256 indexed random,
191         uint256 totalWinAmount,
192         uint256 jackpotBalance,
193         uint256 winRate,
194         uint256 bet
195     );
196 }
197 library SafeMath {
198     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
199         if (a == 0) {  return 0; }
200         uint256 c = a * b;
201         require(c / a == b);
202         return c;
203     }
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         require(b > 0);
206         uint256 c = a / b;
207         return c;
208     }
209     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
210         require(b <= a);
211         uint256 c = a - b;
212         return c;
213     }
214     function add(uint256 a, uint256 b) internal pure returns (uint256) {
215         uint256 c = a + b;
216         require(c >= a);
217         return c;
218     }
219     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
220         require(b != 0);
221         return a % b;
222     }
223 }