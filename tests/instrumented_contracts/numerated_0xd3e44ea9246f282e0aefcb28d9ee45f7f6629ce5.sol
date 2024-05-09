1 pragma solidity ^0.4.25;
2 
3 interface DSG {
4     function gamingDividendsReception() payable external;
5 }
6 
7 contract DSG_Turntable{
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
30         uint256 bet;
31     }
32     
33     modifier onlyOwners(){
34         require(msg.sender == owners[0] || msg.sender == owners[1]);
35         _;
36     }
37     modifier onlyUsers(){
38         require(tx.origin == msg.sender);
39         _;
40     }
41     modifier checkBlockNumber(){
42         uint256 blockNumber = usersBets[msg.sender].blockNumber;
43         if(block.number.sub(blockNumber) >= 250 && blockNumber > 0){
44             emit Result(msg.sender, 1000, 0, jackpotBalance, usersBets[msg.sender].bet, 0);
45             delete usersBets[msg.sender];
46         }
47         else{
48             _;
49         }
50     }
51     constructor(address secondOwner) public payable{
52         owners[0]   = msg.sender;
53         owners[1]   = secondOwner;
54         ownerDeposit   = msg.value;
55         jackpotBalance = jackpotBalance.add(ownerDeposit.div(1000));
56     }
57     function play() public payable checkBlockNumber onlyUsers{
58         uint256 bet = msg.value;
59         require(checkSolvency(bet), "Not enough ETH in contract");
60         require(paused == false, "Game was stopped");
61         require(bet >= minBet && bet <= maxBet, "Amount should be within range");
62         require(usersBets[msg.sender].bet == 0, "You have already bet");
63         usersBets[msg.sender].bet = bet;
64         usersBets[msg.sender].blockNumber = block.number;
65         totalTurnover = totalTurnover.add(bet);
66         totalPlayed = totalPlayed.add(1);
67         emit PlaceBet(msg.sender, bet, now);
68     }
69     function result() public checkBlockNumber onlyUsers{
70         require(blockhash(usersBets[msg.sender].blockNumber) != 0, "Your time to determine the result has come out or not yet come");
71         uint256 bet = usersBets[msg.sender].bet;
72         uint256 totalWinAmount;
73         uint256 r = _random(1000);
74         uint256 winRate = 0;
75         if(_winChanceJ(r, bet)){
76 		    winRate = 1000;
77             totalWinAmount = totalWinAmount.add(jackpotBalance).add(bet);
78             emit Jackpot(msg.sender, jackpotBalance, now);
79             delete jackpotBalance;
80 		}
81 		if(_winChance1x(r)){
82 		    winRate = 100;
83 		    totalWinAmount = totalWinAmount.add(bet);
84 		}
85 		if(_winChance1_5x(r)){
86 		    winRate = 150;
87 		    totalWinAmount = totalWinAmount.add(bet.mul(winRate).div(100));
88 		}
89 		if(_winChance2x(r)){
90 		    winRate = 200;
91 		    totalWinAmount = totalWinAmount.add(bet.mul(winRate).div(100));
92 		}
93 		if(_winChance2_5x(r)){
94 		    winRate = 250;
95 		    totalWinAmount = totalWinAmount.add(bet.mul(winRate).div(100));
96 		}
97 		if(_winChance3x(r)){
98 		    winRate = 300;
99 		    totalWinAmount = totalWinAmount.add(bet.mul(winRate).div(100));
100 		}
101 		if(_winChance5x(r)){
102 		    winRate = 500;
103 		    totalWinAmount = totalWinAmount.add(bet.mul(winRate).div(100));
104 		}
105 		if(totalWinAmount > 0){
106             msg.sender.transfer(totalWinAmount);
107             totalWinnings = totalWinnings.add(totalWinAmount);
108         }
109         jackpotBalance = jackpotBalance.add(bet.div(1000));
110         delete usersBets[msg.sender];
111         emit Result(msg.sender, r, totalWinAmount, jackpotBalance, bet, winRate);
112     }
113     function _winChanceJ(uint r, uint bet) private view returns(bool){
114 		if(bet >= minBetForJackpot && r == 999 && jackpotBalance > 0) return true;
115 		else return false;
116 	}
117     function _winChance5x(uint r) private pure returns(bool){
118 		if(r == 12 || r == 22 || r == 32 || r == 42 || r == 52) return true;
119 		else return false;
120 	}
121 	function _winChance3x(uint r) private pure returns(bool){
122 		if( (r >= 80 && r < 83)   ||
123 			(r >= 180 && r < 183) ||
124 			(r >= 280 && r < 283) ||
125 			(r >= 380 && r < 383) ||
126 			(r >= 480 && r < 483) ||
127 			(r >= 580 && r < 583) ||
128 			(r >= 680 && r < 683) ||
129 			(r >= 780 && r < 783))
130 		return true;
131 		else return false;
132 	}
133 	function _winChance2_5x(uint r) private pure returns(bool){
134 		if( (r >= 75 && r < 80)   ||
135 			(r >= 175 && r < 180) ||
136 			(r >= 275 && r < 280) ||
137 			(r >= 375 && r < 380) ||
138 			(r >= 475 && r < 480) ||
139 			(r >= 575 && r < 580) ||
140 			(r >= 675 && r < 680) ||
141 			(r >= 775 && r < 780))
142 	    return true;
143 		else return false;
144 	}
145 	function _winChance2x(uint r) private pure returns(bool){
146 		if((r >= 50 && r < 75) || (r >= 350 && r < 375) || (r >= 650 && r < 675) || (r >= 950 && r < 975)) return true;
147 		else return false;
148 	}
149 	function _winChance1_5x(uint r) private pure returns(bool){
150 		if((r >= 25 && r < 50) || (r >= 125 && r < 150)) return true;
151 		else if((r >= 425 && r < 450) || (r >= 525 && r < 550)) return true;
152 		else if((r >= 625 && r < 650) || (r >= 725 && r < 750)) return true;
153 		else return false;
154 	}
155 	function _winChance1x(uint r) private pure returns(bool){
156 		if((r >= 0 && r < 25) || (r >= 100 && r < 125)) return true;
157 		else if((r >= 400 && r < 425) || (r >= 500 && r < 525)) return true;
158 		else if((r >= 600 && r < 625) || (r >= 700 && r < 725)) return true;
159 		else return false;
160 	}
161     function checkSolvency(uint bet) view public returns(bool){
162         if(getContractBalance() > bet.mul(500).div(100).add(jackpotBalance)) return true;
163         else return false;
164     }
165     function sendDividends() public {
166         require(getContractBalance() > minContractBalance && now > nextPayout, "You cannot send dividends");
167         DSG DSG0 = DSG(DSG_ADDRESS);
168         uint256 balance = getContractBalance();
169         uint256 dividends = balance.sub(minContractBalance);
170         nextPayout = now.add(7 days);
171         totalDividends = totalDividends.add(dividends);
172         DSG0.gamingDividendsReception.value(dividends)();
173         emit Dividends(balance, dividends, now);
174     }
175      function getContractBalance() public view returns (uint256){
176         return address(this).balance;
177     }
178     function _random(uint256 max) private view returns(uint256){
179         bytes32 hash = blockhash(usersBets[msg.sender].blockNumber);
180         return uint256(keccak256(abi.encode(hash, msg.sender))) % max;
181     }
182     function deposit() public payable onlyOwners{
183         ownerDeposit = ownerDeposit.add(msg.value);
184     }
185     function sendOwnerDeposit(address recipient) public onlyOwners{
186         require(paused == true, 'Game was not stopped');
187         uint256 contractBalance = getContractBalance();
188         if(contractBalance >= ownerDeposit){
189             recipient.transfer(ownerDeposit);
190         }
191         else{
192             recipient.transfer(contractBalance);
193         }
194         delete jackpotBalance;
195         delete ownerDeposit;
196     }
197     function pauseGame(bool option) public onlyOwners{
198         paused = option;
199     }
200     function setMinBet(uint256 eth) public onlyOwners{
201         minBet = eth;
202     }
203     function setMaxBet(uint256 eth) public onlyOwners{
204         maxBet = eth;
205     }
206     function setMinBetForJackpot(uint256 eth) public onlyOwners{
207         minBetForJackpot = eth;
208     }
209     function setMinContractBalance(uint256 eth) public onlyOwners{
210         minContractBalance = eth;
211     }
212     function transferOwnership(address newOwnerAddress, uint8 k) public onlyOwners{
213         candidates[k] = newOwnerAddress;
214     }
215     function confirmOwner(uint8 k) public{
216         require(msg.sender == candidates[k]);
217         owners[k] = candidates[k];
218     }
219     event Dividends(
220         uint256 balance,
221         uint256 dividends,
222         uint256 timestamp
223     );
224     event Jackpot(
225         address indexed player,
226         uint256 jackpot,
227         uint256 timestamp
228     );
229     event PlaceBet(
230         address indexed player,
231         uint256 bet,
232         uint256 timestamp
233     );
234     event Result(
235         address indexed player,
236         uint256 indexed random,
237         uint256 totalWinAmount,
238         uint256 jackpotBalance,
239         uint256 bet,
240         uint256 winRate
241     );
242 }
243 library SafeMath {
244     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
245         if (a == 0) {  return 0; }
246         uint256 c = a * b;
247         require(c / a == b);
248         return c;
249     }
250     function div(uint256 a, uint256 b) internal pure returns (uint256) {
251         require(b > 0);
252         uint256 c = a / b;
253         return c;
254     }
255     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
256         require(b <= a);
257         uint256 c = a - b;
258         return c;
259     }
260     function add(uint256 a, uint256 b) internal pure returns (uint256) {
261         uint256 c = a + b;
262         require(c >= a);
263         return c;
264     }
265     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
266         require(b != 0);
267         return a % b;
268     }
269 }