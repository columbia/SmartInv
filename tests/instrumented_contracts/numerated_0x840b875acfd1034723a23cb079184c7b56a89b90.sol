1 pragma solidity ^0.4.25;
2 
3 interface DSG {
4     function gamingDividendsReception() payable external;
5 }
6 
7 contract DSG_Dice{
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
29         uint blockNumber;
30         uint bet;
31         bool[6] dice;
32     }
33     
34     modifier onlyOwners(){
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
45             emit Result(msg.sender, 601, 0, jackpotBalance, usersBets[msg.sender].bet, usersBets[msg.sender].dice, 0);
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
58     function play(bool dice1, bool dice2, bool dice3, bool dice4, bool dice5, bool dice6) public payable checkBlockNumber onlyUsers{
59         uint256 bet = msg.value;
60         bool[6] memory dice = [dice1, dice2, dice3, dice4, dice5, dice6];
61         require(getXRate(dice) != 0, "Sides of dice  is incorrect");
62         require(checkSolvency(bet), "Not enough ETH in contract");
63         require(paused == false, "Game was stopped");
64         require(bet >= minBet && bet <= maxBet, "Amount should be within range");
65         require(usersBets[msg.sender].bet == 0, "You have already bet");
66         usersBets[msg.sender].bet = bet;
67         usersBets[msg.sender].blockNumber = block.number;
68         usersBets[msg.sender].dice = dice;
69         totalTurnover = totalTurnover.add(bet);
70         totalPlayed = totalPlayed.add(1);
71         emit PlaceBet(msg.sender, bet, dice, now);
72     }
73     function result() public checkBlockNumber onlyUsers{
74         require(blockhash(usersBets[msg.sender].blockNumber) != 0, "Your time to determine the result has come out or not yet come");
75         uint256 r = _random(601);
76         bool[6] memory dice = usersBets[msg.sender].dice;
77         uint256 bet = usersBets[msg.sender].bet;
78         uint256 rate = getXRate(dice);
79         uint256 totalWinAmount;
80         if(getDice(r) == 1 && dice[0] == true){
81             totalWinAmount = totalWinAmount.add(bet.mul(rate).div(100));
82 		}
83 		else if(getDice(r) == 2 && dice[1] == true){
84 		    totalWinAmount = totalWinAmount.add(bet.mul(rate).div(100));
85 		}
86 		else if(getDice(r) == 3 && dice[2] == true){
87 		    totalWinAmount = totalWinAmount.add(bet.mul(rate).div(100));
88 		}
89 		else if(getDice(r) == 4 && dice[3] == true){
90 		    totalWinAmount = totalWinAmount.add(bet.mul(rate).div(100));
91 		}
92 		else if(getDice(r) == 5 && dice[4] == true){
93 		    totalWinAmount = totalWinAmount.add(bet.mul(rate).div(100));
94 		}
95 		else if(getDice(r) == 6 && dice[5] == true){
96 		    totalWinAmount = totalWinAmount.add(bet.mul(rate).div(100));
97 		}
98 		if(bet >= minBetForJackpot && r == 0 && jackpotBalance > 0){
99 		    totalWinAmount = totalWinAmount.add(jackpotBalance).add(bet);
100 		    emit Jackpot(msg.sender, jackpotBalance, now);
101             delete jackpotBalance;
102 		}
103 		if(totalWinAmount > 0){
104 		    msg.sender.transfer(totalWinAmount);
105 	    	totalWinnings = totalWinnings.add(totalWinAmount);
106 		}
107         jackpotBalance = jackpotBalance.add(bet.div(1000));
108 		delete usersBets[msg.sender];
109 		emit Result(msg.sender, r, totalWinAmount, jackpotBalance, bet, dice, rate);
110     }
111     function getXRate(bool[6] dice) public pure returns(uint){
112         uint sum;
113         for(uint i = 0; i < dice.length; i++){
114             if(dice[i] == true) sum = sum.add(1);
115         }
116 		if(sum == 1) return 500;
117 		if(sum == 2) return 250;
118 		if(sum == 3) return 180;
119 		if(sum == 4) return 135;
120 		if(sum == 5) return 110;
121 		if(sum == 6 || sum == 0) return 0;
122 	}
123     function getDice(uint r) private pure returns (uint){
124 		if((r > 0 && r <= 50) || (r > 300 && r <= 350)){
125 			return 1;
126 		}
127 		else if((r > 50 && r <= 100) || (r > 500 && r <= 550)){
128 			return 2;
129 		}
130 		else if((r > 100 && r <= 150) || (r > 450 && r <= 500)){
131 			return 3;
132 		}
133 		else if((r > 150 && r <= 200) || (r > 400 && r <= 450)){
134 			return 4;
135 		}
136 		else if((r > 200 && r <= 250) || (r > 350 && r <= 400)){
137 			return 5;
138 		}
139 		else if((r > 250 && r <= 300) || (r > 550 && r <= 600)){
140 			return 6;
141 		}
142 	}
143     function checkSolvency(uint bet) view public returns(bool){
144         if(getContractBalance() > bet.add(bet.mul(500).div(100)).add(jackpotBalance)) return true;
145         else return false;
146     }
147     function sendDividends() public {
148         require(getContractBalance() > minContractBalance && now > nextPayout, "You cannot send dividends");
149         DSG DSG0 = DSG(DSG_ADDRESS);
150         uint256 balance = getContractBalance();
151         uint256 dividends  = balance.sub(minContractBalance);
152         nextPayout = now.add(7 days);
153         totalDividends = totalDividends.add(dividends);
154         DSG0.gamingDividendsReception.value(dividends)();
155         emit Dividends(balance, dividends, now);
156     }
157      function getContractBalance() public view returns (uint256){
158         return address(this).balance;
159     }
160     function _random(uint256 max) private view returns(uint256){
161         bytes32 hash = blockhash(usersBets[msg.sender].blockNumber);
162         return uint256(keccak256(abi.encode(hash, msg.sender))) % max;
163     }
164     function deposit() public payable onlyOwners{
165         ownerDeposit = ownerDeposit.add(msg.value);
166     }
167     function sendOwnerDeposit(address recipient) public onlyOwners{
168         require(paused == true, 'Game was not stopped');
169         uint256 contractBalance = getContractBalance();
170         if(contractBalance >= ownerDeposit){
171             recipient.transfer(ownerDeposit);
172         }
173         else{
174             recipient.transfer(contractBalance);
175         }
176         delete jackpotBalance;
177         delete ownerDeposit;
178     }
179     function pauseGame(bool option) public onlyOwners{
180         paused = option;
181     }
182     function setMinBet(uint256 eth) public onlyOwners{
183         minBet = eth;
184     }
185     function setMaxBet(uint256 eth) public onlyOwners{
186         maxBet = eth;
187     }
188     function setMinBetForJackpot(uint256 eth) public onlyOwners{
189         minBetForJackpot = eth;
190     }
191     function setMinContractBalance(uint256 eth) public onlyOwners{
192         minContractBalance = eth;
193     }
194     function transferOwnership(address newOwnerAddress, uint8 k) public onlyOwners{
195         candidates[k] = newOwnerAddress;
196     }
197     function confirmOwner(uint8 k) public{
198         require(msg.sender == candidates[k]);
199         owners[k] = candidates[k];
200     }
201     event Dividends(
202         uint256 balance,
203         uint256 dividends,
204         uint256 timestamp
205     );
206     event Jackpot(
207         address indexed player,
208         uint256 jackpot,
209         uint256 timestamp
210     );
211     event PlaceBet(
212         address indexed player,
213         uint256 bet,
214         bool[6] dice,
215         uint256 timestamp
216     );
217     event Result(
218         address indexed player,
219         uint256 indexed random,
220         uint256 totalWinAmount,
221         uint256 jackpotBalance,
222         uint256 bet,
223         bool[6] dice,
224         uint256 winRate
225     );
226 }
227 library SafeMath {
228     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
229         if (a == 0) {  return 0; }
230         uint256 c = a * b;
231         require(c / a == b);
232         return c;
233     }
234     function div(uint256 a, uint256 b) internal pure returns (uint256) {
235         require(b > 0);
236         uint256 c = a / b;
237         return c;
238     }
239     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
240         require(b <= a);
241         uint256 c = a - b;
242         return c;
243     }
244     function add(uint256 a, uint256 b) internal pure returns (uint256) {
245         uint256 c = a + b;
246         require(c >= a);
247         return c;
248     }
249     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
250         require(b != 0);
251         return a % b;
252     }
253 }