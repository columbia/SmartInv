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
60         require(checkSolvency(bet), "Not enough ETH in contract");
61         require(paused == false, "Game was stopped");
62         require(bet >= minBet && bet <= maxBet, "Amount should be within range");
63         require(usersBets[msg.sender].bet == 0, "You have already bet");
64         bool[6] memory dice = [dice1, dice2, dice3, dice4, dice5, dice6];
65         usersBets[msg.sender].bet = bet;
66         usersBets[msg.sender].blockNumber = block.number;
67         usersBets[msg.sender].dice = dice;
68         totalTurnover = totalTurnover.add(bet);
69         totalPlayed = totalPlayed.add(1);
70         emit PlaceBet(msg.sender, bet, dice, now);
71     }
72     function result() public checkBlockNumber onlyUsers{
73         require(blockhash(usersBets[msg.sender].blockNumber) != 0, "Your time to determine the result has come out or not yet come");
74         uint256 r = _random(601);
75         bool[6] memory dice = usersBets[msg.sender].dice;
76         uint256 bet = usersBets[msg.sender].bet;
77         uint256 rate = getXRate(dice);
78         uint256 totalWinAmount;
79         if(getDice(r) == 1 && dice[0] == true){
80             totalWinAmount = totalWinAmount.add(bet.mul(rate).div(100));
81 		}
82 		else if(getDice(r) == 2 && dice[1] == true){
83 		    totalWinAmount = totalWinAmount.add(bet.mul(rate).div(100));
84 		}
85 		else if(getDice(r) == 3 && dice[2] == true){
86 		    totalWinAmount = totalWinAmount.add(bet.mul(rate).div(100));
87 		}
88 		else if(getDice(r) == 4 && dice[3] == true){
89 		    totalWinAmount = totalWinAmount.add(bet.mul(rate).div(100));
90 		}
91 		else if(getDice(r) == 5 && dice[4] == true){
92 		    totalWinAmount = totalWinAmount.add(bet.mul(rate).div(100));
93 		}
94 		else if(getDice(r) == 6 && dice[5] == true){
95 		    totalWinAmount = totalWinAmount.add(bet.mul(rate).div(100));
96 		}
97 		if(bet >= minBetForJackpot && r == 0 && jackpotBalance > 0){
98 		    totalWinAmount = totalWinAmount.add(jackpotBalance);
99 		    emit Jackpot(msg.sender, jackpotBalance, now);
100             delete jackpotBalance;
101 		}
102 		if(totalWinAmount > 0){
103 		    msg.sender.transfer(totalWinAmount);
104 	    	totalWinnings = totalWinnings.add(totalWinAmount);
105 		}
106         jackpotBalance = jackpotBalance.add(bet.div(1000));
107 		delete usersBets[msg.sender];
108 		emit Result(msg.sender, r, totalWinAmount, jackpotBalance, bet, dice, rate);
109     }
110     function getXRate(bool[6] dice) public pure returns(uint){
111         uint sum;
112         for(uint i = 0; i < dice.length; i++){
113             if(dice[i] == true) sum = sum.add(1);
114         }
115 		if(sum == 1) return 580;
116 		if(sum == 2) return 290;
117 		if(sum == 3) return 195;
118 		if(sum == 4) return 147;
119 		if(sum == 5) return 117;
120 	}
121     function getDice(uint r) private pure returns (uint){
122 		if((r > 0 && r <= 50) || (r > 300 && r <= 350)){
123 			return 1;
124 		}
125 		else if((r > 50 && r <= 100) || (r > 500 && r <= 550)){
126 			return 2;
127 		}
128 		else if((r > 100 && r <= 150) || (r > 450 && r <= 500)){
129 			return 3;
130 		}
131 		else if((r > 150 && r <= 200) || (r > 400 && r <= 450)){
132 			return 4;
133 		}
134 		else if((r > 200 && r <= 250) || (r > 350 && r <= 400)){
135 			return 5;
136 		}
137 		else if((r > 250 && r <= 300) || (r > 550 && r <= 600)){
138 			return 6;
139 		}
140 	}
141     function checkSolvency(uint bet) view public returns(bool){
142         if(getContractBalance() > bet.add(bet.mul(500).div(100)).add(jackpotBalance)) return true;
143         else return false;
144     }
145     function sendDividends() public {
146         require(getContractBalance() > minContractBalance && now > nextPayout, "You cannot send dividends");
147         DSG DSG0 = DSG(DSG_ADDRESS);
148         uint256 balance = getContractBalance();
149         uint256 dividends  = balance.sub(minContractBalance);
150         nextPayout = now.add(7 days);
151         totalDividends = totalDividends.add(dividends);
152         DSG0.gamingDividendsReception.value(dividends)();
153         emit Dividends(balance, dividends, now);
154     }
155      function getContractBalance() public view returns (uint256){
156         return address(this).balance;
157     }
158     function _random(uint256 max) private view returns(uint256){
159         bytes32 hash = blockhash(usersBets[msg.sender].blockNumber);
160         return uint256(keccak256(abi.encode(hash, msg.sender))) % max;
161     }
162     function deposit() public payable onlyOwners{
163         ownerDeposit = ownerDeposit.add(msg.value);
164     }
165     function sendOwnerDeposit(address recipient) public onlyOwners{
166         require(paused == true, 'Game was not stopped');
167         uint256 contractBalance = getContractBalance();
168         if(contractBalance >= ownerDeposit){
169             recipient.transfer(ownerDeposit);
170         }
171         else{
172             recipient.transfer(contractBalance);
173         }
174         delete jackpotBalance;
175         delete ownerDeposit;
176     }
177     function pauseGame(bool option) public onlyOwners{
178         paused = option;
179     }
180     function setMinBet(uint256 eth) public onlyOwners{
181         minBet = eth;
182     }
183     function setMaxBet(uint256 eth) public onlyOwners{
184         maxBet = eth;
185     }
186     function setMinBetForJackpot(uint256 eth) public onlyOwners{
187         minBetForJackpot = eth;
188     }
189     function setMinContractBalance(uint256 eth) public onlyOwners{
190         minContractBalance = eth;
191     }
192     function transferOwnership(address newOwnerAddress, uint8 k) public onlyOwners{
193         candidates[k] = newOwnerAddress;
194     }
195     function confirmOwner(uint8 k) public{
196         require(msg.sender == candidates[k]);
197         owners[k] = candidates[k];
198     }
199     event Dividends(
200         uint256 balance,
201         uint256 dividends,
202         uint256 timestamp
203     );
204     event Jackpot(
205         address indexed player,
206         uint256 jackpot,
207         uint256 timestamp
208     );
209     event PlaceBet(
210         address indexed player,
211         uint256 bet,
212         bool[6] dice,
213         uint256 timestamp
214     );
215     event Result(
216         address indexed player,
217         uint256 indexed random,
218         uint256 totalWinAmount,
219         uint256 jackpotBalance,
220         uint256 bet,
221         bool[6] dice,
222         uint256 winRate
223     );
224 }
225 library SafeMath {
226     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
227         if (a == 0) {  return 0; }
228         uint256 c = a * b;
229         require(c / a == b);
230         return c;
231     }
232     function div(uint256 a, uint256 b) internal pure returns (uint256) {
233         require(b > 0);
234         uint256 c = a / b;
235         return c;
236     }
237     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
238         require(b <= a);
239         uint256 c = a - b;
240         return c;
241     }
242     function add(uint256 a, uint256 b) internal pure returns (uint256) {
243         uint256 c = a + b;
244         require(c >= a);
245         return c;
246     }
247     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248         require(b != 0);
249         return a % b;
250     }
251 }