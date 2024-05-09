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
77             totalWinAmount = totalWinAmount.add(jackpotBalance);
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
118 		if(r == 11 || r == 21 || r == 31 || r == 41 || r == 51 || r == 61 || r == 71 || r == 81 || r == 91 || r == 99) return true;
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
129 			(r >= 780 && r < 783) ||
130 			(r >= 880 && r < 883) ||
131 			(r >= 980 && r < 983))
132 		return true;
133 		else return false;
134 	}
135 	function _winChance2_5x(uint r) private pure returns(bool){
136 		if( (r >= 75 && r < 80)   ||
137 			(r >= 175 && r < 180) ||
138 			(r >= 275 && r < 280) ||
139 			(r >= 375 && r < 380) ||
140 			(r >= 475 && r < 480) ||
141 			(r >= 575 && r < 580) ||
142 			(r >= 675 && r < 680) ||
143 			(r >= 775 && r < 780) ||
144 			(r >= 875 && r < 880) ||
145 			(r >= 975 && r < 980))
146 	    return true;
147 		else return false;
148 	}
149 	function _winChance2x(uint r) private pure returns(bool){
150 		if((r >= 50 && r < 75) || (r >= 350 && r < 375) || (r >= 650 && r < 675) || (r >= 950 && r < 975)) return true;
151 		else return false;
152 	}
153 	function _winChance1_5x(uint r) private pure returns(bool){
154 		if((r >= 25 && r < 50) || (r >= 125 && r < 150)) return true;
155 		else if((r >= 425 && r < 450) || (r >= 525 && r < 550)) return true;
156 		else if((r >= 625 && r < 650) || (r >= 725 && r < 750)) return true;
157 		else return false;
158 	}
159 	function _winChance1x(uint r) private pure returns(bool){
160 		if((r >= 0 && r < 25) || (r >= 100 && r < 125)) return true;
161 		else if((r >= 400 && r < 425) || (r >= 500 && r < 525)) return true;
162 		else if((r >= 600 && r < 625) || (r >= 700 && r < 725)) return true;
163 		else if((r >= 800 && r < 825) || (r >= 900 && r < 925)) return true;
164 		else return false;
165 	}
166     function checkSolvency(uint bet) view public returns(bool){
167         if(getContractBalance() > bet.mul(500).div(100).add(jackpotBalance)) return true;
168         else return false;
169     }
170     function sendDividends() public {
171         require(getContractBalance() > minContractBalance && now > nextPayout, "You cannot send dividends");
172         DSG DSG0 = DSG(DSG_ADDRESS);
173         uint256 balance = getContractBalance();
174         uint256 dividends = balance.sub(minContractBalance);
175         nextPayout = now.add(7 days);
176         totalDividends = totalDividends.add(dividends);
177         DSG0.gamingDividendsReception.value(dividends)();
178         emit Dividends(balance, dividends, now);
179     }
180      function getContractBalance() public view returns (uint256){
181         return address(this).balance;
182     }
183     function _random(uint256 max) private view returns(uint256){
184         bytes32 hash = blockhash(usersBets[msg.sender].blockNumber);
185         return uint256(keccak256(abi.encode(hash, msg.sender))) % max;
186     }
187     function deposit() public payable onlyOwners{
188         ownerDeposit = ownerDeposit.add(msg.value);
189     }
190     function sendOwnerDeposit(address recipient) public onlyOwners{
191         require(paused == true, 'Game was not stopped');
192         uint256 contractBalance = getContractBalance();
193         if(contractBalance >= ownerDeposit){
194             recipient.transfer(ownerDeposit);
195         }
196         else{
197             recipient.transfer(contractBalance);
198         }
199         delete jackpotBalance;
200         delete ownerDeposit;
201     }
202     function pauseGame(bool option) public onlyOwners{
203         paused = option;
204     }
205     function setMinBet(uint256 eth) public onlyOwners{
206         minBet = eth;
207     }
208     function setMaxBet(uint256 eth) public onlyOwners{
209         maxBet = eth;
210     }
211     function setMinBetForJackpot(uint256 eth) public onlyOwners{
212         minBetForJackpot = eth;
213     }
214     function setMinContractBalance(uint256 eth) public onlyOwners{
215         minContractBalance = eth;
216     }
217     function transferOwnership(address newOwnerAddress, uint8 k) public onlyOwners{
218         candidates[k] = newOwnerAddress;
219     }
220     function confirmOwner(uint8 k) public{
221         require(msg.sender == candidates[k]);
222         owners[k] = candidates[k];
223     }
224     event Dividends(
225         uint256 balance,
226         uint256 dividends,
227         uint256 timestamp
228     );
229     event Jackpot(
230         address indexed player,
231         uint256 jackpot,
232         uint256 timestamp
233     );
234     event PlaceBet(
235         address indexed player,
236         uint256 bet,
237         uint256 timestamp
238     );
239     event Result(
240         address indexed player,
241         uint256 indexed random,
242         uint256 totalWinAmount,
243         uint256 jackpotBalance,
244         uint256 bet,
245         uint256 winRate
246     );
247 }
248 library SafeMath {
249     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
250         if (a == 0) {  return 0; }
251         uint256 c = a * b;
252         require(c / a == b);
253         return c;
254     }
255     function div(uint256 a, uint256 b) internal pure returns (uint256) {
256         require(b > 0);
257         uint256 c = a / b;
258         return c;
259     }
260     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
261         require(b <= a);
262         uint256 c = a - b;
263         return c;
264     }
265     function add(uint256 a, uint256 b) internal pure returns (uint256) {
266         uint256 c = a + b;
267         require(c >= a);
268         return c;
269     }
270     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
271         require(b != 0);
272         return a % b;
273     }
274 }