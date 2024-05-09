1 pragma solidity ^0.4.25;
2 
3 interface DSG {
4     function gamingDividendsReception() payable external;
5 }
6 
7 contract DiceDSG{
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
28         uint blockNumber;
29         uint bet;
30         bool[6] dice;
31     }
32     
33     modifier onlyOwners(){
34         require(msg.sender == owners[0] || msg.sender == owners[1]);
35         _;
36     }
37     modifier checkBlockNumber(){
38         uint256 blockNumber = usersBets[msg.sender].blockNumber;
39         if(block.number.sub(blockNumber) >= 250 && blockNumber > 0){
40             emit Result(msg.sender, 1000, 0, jackpotBalance, usersBets[msg.sender].bet, usersBets[msg.sender].dice, 0);
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
53     function play(bool dice1, bool dice2, bool dice3, bool dice4, bool dice5, bool dice6) public payable checkBlockNumber{
54         uint256 bet = msg.value;
55         require(checkSolvency(bet), "Not enough ETH in contract");
56         require(paused == false, "Game was stopped");
57         require(bet >= minBet && bet <= maxBet, "Amount should be within range");
58         require(usersBets[msg.sender].bet == 0, "You have already bet");
59         bool[6] memory dice = [dice1, dice2, dice3, dice4, dice5, dice6];
60         usersBets[msg.sender].bet = bet;
61         usersBets[msg.sender].blockNumber = block.number;
62         usersBets[msg.sender].dice = dice;
63         totalTurnover = totalTurnover.add(bet);
64         emit PlaceBet(msg.sender, bet, dice, now);
65     }
66     function result() public checkBlockNumber{
67         require(blockhash(usersBets[msg.sender].blockNumber) != 0, "Your time to determine the result has come out or not yet come");
68         uint256 r = _random(601);
69         bool[6] memory dice = usersBets[msg.sender].dice;
70         uint256 bet = usersBets[msg.sender].bet;
71         uint256 rate = getXRate(dice);
72         uint256 totalWinAmount;
73         if(getDice(r) == 1 && dice[0] == true){
74             totalWinAmount = totalWinAmount.add(bet.mul(rate).div(100));
75 		}
76 		else if(getDice(r) == 2 && dice[1] == true){
77 		    totalWinAmount = totalWinAmount.add(bet.mul(rate).div(100));
78 		}
79 		else if(getDice(r) == 3 && dice[2] == true){
80 		    totalWinAmount = totalWinAmount.add(bet.mul(rate).div(100));
81 		}
82 		else if(getDice(r) == 4 && dice[3] == true){
83 		    totalWinAmount = totalWinAmount.add(bet.mul(rate).div(100));
84 		}
85 		else if(getDice(r) == 5 && dice[4] == true){
86 		    totalWinAmount = totalWinAmount.add(bet.mul(rate).div(100));
87 		}
88 		else if(getDice(r) == 6 && dice[5] == true){
89 		    totalWinAmount = totalWinAmount.add(bet.mul(rate).div(100));
90 		}
91 		if(bet >= minBetForJackpot && r == 0 && jackpotBalance > 0){
92 		    totalWinAmount = totalWinAmount.add(jackpotBalance);
93 		    emit Jackpot(msg.sender, jackpotBalance, now);
94             delete jackpotBalance;
95 		}
96 		if(totalWinnings > 0){
97 		    msg.sender.transfer(totalWinAmount);
98 	    	totalWinnings = totalWinnings.add(totalWinAmount);
99 		}
100         jackpotBalance = jackpotBalance.add(bet.div(1000));
101 		delete usersBets[msg.sender];
102 		emit Result(msg.sender, r, totalWinAmount, jackpotBalance, bet, dice, rate);
103     }
104     function getXRate(bool[6] dice) public pure returns(uint){
105         uint sum;
106         for(uint i = 0; i < dice.length; i++){
107             if(dice[i] == true) sum = sum.add(1);
108         }
109 		if(sum == 1) return 580;
110 		if(sum == 2) return 290;
111 		if(sum == 3) return 195;
112 		if(sum == 4) return 147;
113 		if(sum == 5) return 117;
114 	}
115     function getDice(uint r) private pure returns (uint){
116 		if((r > 0 && r <= 50) || (r > 300 && r <= 350)){
117 			return 1;
118 		}
119 		else if((r > 50 && r <= 100) || (r > 500 && r <= 550)){
120 			return 2;
121 		}
122 		else if((r > 100 && r <= 150) || (r > 450 && r <= 500)){
123 			return 3;
124 		}
125 		else if((r > 150 && r <= 200) || (r > 400 && r <= 450)){
126 			return 4;
127 		}
128 		else if((r > 200 && r <= 250) || (r > 350 && r <= 400)){
129 			return 5;
130 		}
131 		else if((r > 250 && r <= 300) || (r > 550 && r <= 600)){
132 			return 6;
133 		}
134 	}
135     function checkSolvency(uint bet) view public returns(bool){
136         if(getContractBalance() > bet.add(bet.mul(500).div(100)).add(jackpotBalance)) return true;
137         else return false;
138     }
139     function sendDividends() public {
140         require(getContractBalance() > minContractBalance && now > nextPayout, "You cannot send dividends");
141         DSG DSG0 = DSG(DSG_ADDRESS);
142         uint256 balance = getContractBalance();
143         uint256 dividends  = balance.sub(minContractBalance);
144         nextPayout         = now.add(7 days);
145         totalDividends = totalDividends.add(dividends);
146         DSG0.gamingDividendsReception.value(dividends)();
147         emit Dividends(balance, dividends, now);
148     }
149      function getContractBalance() public view returns (uint256){
150         return address(this).balance;
151     }
152     function _random(uint256 max) private view returns(uint256){
153         bytes32 hash = blockhash(usersBets[msg.sender].blockNumber);
154         return uint256(keccak256(abi.encode(hash, now, msg.sender))) % max;
155     }
156     function _random(uint256 max, uint256 entropy) private view returns(uint256){
157         bytes32 hash = blockhash(usersBets[msg.sender].blockNumber);
158         return uint256(keccak256(abi.encode(hash, now, msg.sender, entropy))) % max;
159     }
160     function deposit() public payable onlyOwners{
161         ownerDeposit = ownerDeposit.add(msg.value);
162     }
163     function sendOwnerDeposit(address recipient) public onlyOwners{
164         require(paused == true, 'Game was not stopped');
165         uint256 contractBalance = getContractBalance();
166         if(contractBalance >= ownerDeposit){
167             recipient.transfer(ownerDeposit);
168         }
169         else{
170             recipient.transfer(contractBalance);
171         }
172         delete jackpotBalance;
173         delete ownerDeposit;
174     }
175     function pauseGame(bool option) public onlyOwners{
176         paused = option;
177     }
178     function setMinBet(uint256 eth) public onlyOwners{
179         minBet = eth;
180     }
181     function setMaxBet(uint256 eth) public onlyOwners{
182         maxBet = eth;
183     }
184     function setMinBetForJackpot(uint256 eth) public onlyOwners{
185         minBetForJackpot = eth;
186     }
187     function setMinContractBalance(uint256 eth) public onlyOwners{
188         minContractBalance = eth;
189     }
190     function transferOwnership(address newOwnerAddress, uint8 k) public onlyOwners{
191         candidates[k] = newOwnerAddress;
192     }
193     function confirmOwner(uint8 k) public{
194         require(msg.sender == candidates[k]);
195         owners[k] = candidates[k];
196     }
197     event Dividends(
198         uint256 balance,
199         uint256 dividends,
200         uint256 timestamp
201     );
202     event Jackpot(
203         address indexed player,
204         uint256 jackpot,
205         uint256 timestamp
206     );
207     event PlaceBet(
208         address indexed player,
209         uint256 bet,
210         bool[6] dice,
211         uint256 timestamp
212     );
213     event Result(
214         address indexed player,
215         uint256 indexed random,
216         uint256 totalWinAmount,
217         uint256 jackpotBalance,
218         uint256 bet,
219         bool[6] dice,
220         uint256 winRate
221     );
222 }
223 library SafeMath {
224     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
225         if (a == 0) {  return 0; }
226         uint256 c = a * b;
227         require(c / a == b);
228         return c;
229     }
230     function div(uint256 a, uint256 b) internal pure returns (uint256) {
231         require(b > 0);
232         uint256 c = a / b;
233         return c;
234     }
235     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
236         require(b <= a);
237         uint256 c = a - b;
238         return c;
239     }
240     function add(uint256 a, uint256 b) internal pure returns (uint256) {
241         uint256 c = a + b;
242         require(c >= a);
243         return c;
244     }
245     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
246         require(b != 0);
247         return a % b;
248     }
249 }