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
81             jackpotBalance = jackpotBalance.add(bet.div(1000));
82         }
83         if(((r > 200 && r < 400) || (r > 600 && r < 800) || (r > 1000 && r < 1200)) && coin == 0){
84             totalWinAmount = totalWinAmount.add(bet.mul(winRate).div(100));
85             jackpotBalance = jackpotBalance.add(bet.div(1000));
86         }
87         if(bet >= minBetForJackpot && r == 0 && jackpotBalance > 0){
88             totalWinAmount = totalWinAmount.add(jackpotBalance).add(bet);
89             delete jackpotBalance;
90         }
91         if(totalWinAmount > 0){
92             msg.sender.transfer(totalWinAmount);
93             totalWinnings = totalWinnings.add(totalWinAmount);
94         }
95         delete usersBets[msg.sender];
96         emit Result(msg.sender, coin, r, totalWinAmount, jackpotBalance, winRate, bet);
97     }
98     function sendDividends() public {
99         require(getContractBalance() > minContractBalance && now > nextPayout, "You cannot send dividends");
100         DSG DSG0 = DSG(DSG_ADDRESS);
101         uint256 balance = getContractBalance();
102         uint256 dividends = balance.sub(minContractBalance);
103         nextPayout = now.add(7 days);
104         totalDividends = totalDividends.add(dividends);
105         DSG0.gamingDividendsReception.value(dividends)();
106         emit Dividends(balance, dividends, now);
107     }
108     function getWinningRate(uint256 eth) public view returns(uint8){
109         uint256 x = maxBet.sub(minBet).div(4);
110         if(eth >= minBet && eth <= minBet.add(x)){
111             return 194;
112         }
113         else if(eth >= minBet.add(x.mul(1)) && eth <= minBet.add(x.mul(2))){
114             return 195;
115         }
116         else if(eth >= minBet.add(x.mul(2)) && eth <= minBet.add(x.mul(3))){
117             return 196;
118         }
119         else if(eth >= minBet.add(x.mul(3)) && eth <= minBet.add(x.mul(4))){
120             return 197;
121         }
122         else{
123             return 194;
124         }
125     }
126     function getContractBalance() public view returns (uint256) {
127         return address(this).balance;
128     }
129     function _random(uint256 max) private view returns(uint256){
130         bytes32 hash = blockhash(usersBets[msg.sender].blockNumber);
131         return uint256(keccak256(abi.encode(hash, msg.sender))) % max;
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