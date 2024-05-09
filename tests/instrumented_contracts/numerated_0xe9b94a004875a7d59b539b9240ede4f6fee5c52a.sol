1 pragma solidity ^0.4.25;
2 
3 interface DSG {
4     function gamingDividendsReception() payable external;
5 }
6 
7 contract TurntableDSG{
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
29         uint256 bet;
30     }
31     
32     modifier onlyOwners(){
33         require(msg.sender == owners[0] || msg.sender == owners[1]);
34         _;
35     }
36     modifier checkBlockNumber(){
37         uint256 blockNumber = usersBets[msg.sender].blockNumber;
38         if(block.number.sub(blockNumber) >= 250 && blockNumber > 0){
39             emit Result(msg.sender, 1000, 0, jackpotBalance, usersBets[msg.sender].bet, 0);
40             delete usersBets[msg.sender];
41         }
42         else{
43             _;
44         }
45     }
46     constructor(address secondOwner) public payable{
47         owners[0]   = msg.sender;
48         owners[1]   = secondOwner;
49         ownerDeposit   = msg.value;
50         jackpotBalance = jackpotBalance.add(ownerDeposit.div(1000));
51     }
52     function play() public payable checkBlockNumber{
53         uint256 bet = msg.value;
54         require(checkSolvency(bet), "Not enough ETH in contract");
55         require(paused == false, "Game was stopped");
56         require(bet >= minBet && bet <= maxBet, "Amount should be within range");
57         require(usersBets[msg.sender].bet == 0, "You have already bet");
58         usersBets[msg.sender].bet = bet;
59         usersBets[msg.sender].blockNumber = block.number;
60         totalTurnover = totalTurnover.add(bet);
61         emit PlaceBet(msg.sender, bet, now);
62     }
63     function result() public checkBlockNumber{
64         require(blockhash(usersBets[msg.sender].blockNumber) != 0, "Your time to determine the result has come out or not yet come");
65         uint256 bet = usersBets[msg.sender].bet;
66         uint256 totalWinAmount;
67         uint256 r = _random(1000, 0);
68         uint256 winRate = 0;
69         if(_winChanceJ(r, bet)){
70 		    winRate = 1000;
71             totalWinAmount = totalWinAmount.add(jackpotBalance);
72             emit Jackpot(msg.sender, jackpotBalance, now);
73             delete jackpotBalance;
74 		}
75 		if(_winChance1x(r)){
76 		    winRate = 100;
77 		    totalWinAmount = totalWinAmount.add(bet);
78 		}
79 		if(_winChance1_5x(r)){
80 		    winRate = 150;
81 		    totalWinAmount = totalWinAmount.add(bet.mul(winRate).div(100));
82 		}
83 		if(_winChance2x(r)){
84 		    winRate = 200;
85 		    totalWinAmount = totalWinAmount.add(bet.mul(winRate).div(100));
86 		}
87 		if(_winChance2_5x(r)){
88 		    winRate = 250;
89 		    totalWinAmount = totalWinAmount.add(bet.mul(winRate).div(100));
90 		}
91 		if(_winChance3x(r)){
92 		    winRate = 300;
93 		    totalWinAmount = totalWinAmount.add(bet.mul(winRate).div(100));
94 		}
95 		if(_winChance5x(r)){
96 		    winRate = 500;
97 		    totalWinAmount = totalWinAmount.add(bet.mul(winRate).div(100));
98 		}
99 		if(totalWinAmount > 0){
100             msg.sender.transfer(totalWinAmount);
101             totalWinnings = totalWinnings.add(totalWinAmount);
102         }
103         jackpotBalance = jackpotBalance.add(bet.div(1000));
104         delete usersBets[msg.sender];
105         emit Result(msg.sender, r, totalWinAmount, jackpotBalance, bet, winRate);
106     }
107     function _winChanceJ(uint r, uint bet) private view returns(bool){
108 		if(bet >= minBetForJackpot && r == 999 && jackpotBalance > 0) return true;
109 		else return false;
110 	}
111     function _winChance5x(uint r) private pure returns(bool){
112 		if(r == 11 || r == 21 || r == 31 || r == 41 || r == 51 || r == 61 || r == 71 || r == 81 || r == 91 || r == 99) return true;
113 		else return false;
114 	}
115 	function _winChance3x(uint r) private pure returns(bool){
116 		if((r >= 80 && r < 83)    ||
117 			(r == 180 && r < 183) ||
118 			(r == 280 && r < 283) ||
119 			(r == 380 && r < 383) ||
120 			(r == 480 && r < 483) ||
121 			(r == 580 && r < 583) ||
122 			(r == 680 && r < 683) ||
123 			(r == 780 && r < 783) ||
124 			(r == 880 && r < 883) ||
125 			(r == 980 && r < 983))
126 		return true;
127 		else return false;
128 	}
129 	function _winChance2_5x(uint r) private pure returns(bool){
130 		if( (r >= 75 && r < 80)   ||
131 			(r >= 175 && r < 180) ||
132 			(r >= 275 && r < 280) ||
133 			(r >= 375 && r < 380) ||
134 			(r >= 475 && r < 480) ||
135 			(r >= 575 && r < 580) ||
136 			(r >= 675 && r < 680) ||
137 			(r >= 775 && r < 780)) {
138 			return true;
139 		}
140 		else{
141 			return false;
142 		}
143 	}
144 	function _winChance2x(uint r) private pure returns(bool){
145 		if( (r >= 50 && r < 75)   ||
146 			(r >= 350 && r < 375) ||
147 			(r >= 650 && r < 675) ||
148 			(r >= 950 && r < 975)) {
149 			return true;
150 		}
151 		else{
152 			return false;
153 		}
154 	}
155 	function _winChance1_5x(uint r) private pure returns(bool){
156 		if((r >= 25 && r < 50) || (r >= 125 && r < 150)){
157 			return true;
158 		}
159 		else if((r >= 225 && r < 250) || (r >= 325 && r < 350)){
160 			return true;
161 		}
162 		else if((r >= 425 && r < 450) || (r >= 525 && r < 550)){
163 			return true;
164 		}
165 		else if((r >= 625 && r < 650) || (r >= 725 && r < 750)){
166 			return true;
167 		}
168 		else{
169 			return false;
170 		}
171 	}
172 	function _winChance1x(uint r) private pure returns(bool){
173 		if((r >= 0 && r < 25) || (r >= 100 && r < 125)){
174 			return true;
175 		}
176 		else if((r >= 200 && r < 225) || (r >= 300 && r < 325)){
177 			return true;
178 		}
179 		else if((r >= 400 && r < 425) || (r >= 500 && r < 525)){
180 			return true;
181 		}
182 		else if((r >= 600 && r < 625) || (r >= 700 && r < 725)){
183 			return true;
184 		}
185 		else if((r >= 800 && r < 825) || (r >= 900 && r < 925)){
186 			return true;
187 		}
188 		else{
189 			return false;
190 		}
191 	}
192     function checkSolvency(uint bet) view public returns(bool){
193         if(getContractBalance() > bet.mul(500).div(100).add(jackpotBalance)) return true;
194         else return false;
195     }
196     function sendDividends() public {
197         require(getContractBalance() > minContractBalance && now > nextPayout, "You cannot send dividends");
198         DSG DSG0 = DSG(DSG_ADDRESS);
199         uint256 balance = getContractBalance();
200         uint256 dividends  = balance.sub(minContractBalance);
201         nextPayout         = now.add(7 days);
202         totalDividends = totalDividends.add(dividends);
203         DSG0.gamingDividendsReception.value(dividends)();
204         emit Dividends(balance, dividends, now);
205     }
206      function getContractBalance() public view returns (uint256){
207         return address(this).balance;
208     }
209     function _random(uint256 max, uint256 entropy) private view returns(uint256){
210         bytes32 hash = blockhash(usersBets[msg.sender].blockNumber);
211         return uint256(keccak256(abi.encode(hash, now, msg.sender, entropy))) % max;
212     }
213     function deposit() public payable onlyOwners{
214         ownerDeposit = ownerDeposit.add(msg.value);
215     }
216     function sendOwnerDeposit(address recipient) public onlyOwners{
217         require(paused == true, 'Game was not stopped');
218         uint256 contractBalance = getContractBalance();
219         if(contractBalance >= ownerDeposit){
220             recipient.transfer(ownerDeposit);
221         }
222         else{
223             recipient.transfer(contractBalance);
224         }
225         delete jackpotBalance;
226         delete ownerDeposit;
227     }
228     function pauseGame(bool option) public onlyOwners{
229         paused = option;
230     }
231     function setMinBet(uint256 eth) public onlyOwners{
232         minBet = eth;
233     }
234     function setMaxBet(uint256 eth) public onlyOwners{
235         maxBet = eth;
236     }
237     function setMinBetForJackpot(uint256 eth) public onlyOwners{
238         minBetForJackpot = eth;
239     }
240     function setMinContractBalance(uint256 eth) public onlyOwners{
241         minContractBalance = eth;
242     }
243     function transferOwnership(address newOwnerAddress, uint8 k) public onlyOwners{
244         candidates[k] = newOwnerAddress;
245     }
246     function confirmOwner(uint8 k) public{
247         require(msg.sender == candidates[k]);
248         owners[k] = candidates[k];
249     }
250     event Dividends(
251         uint256 balance,
252         uint256 dividends,
253         uint256 timestamp
254     );
255     event Jackpot(
256         address indexed player,
257         uint256 jackpot,
258         uint256 timestamp
259     );
260     event PlaceBet(
261         address indexed player,
262         uint256 bet,
263         uint256 timestamp
264     );
265     event Result(
266         address indexed player,
267         uint256 indexed random,
268         uint256 totalWinAmount,
269         uint256 jackpotBalance,
270         uint256 bet,
271         uint256 winRate
272     );
273 }
274 library SafeMath {
275     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
276         if (a == 0) {  return 0; }
277         uint256 c = a * b;
278         require(c / a == b);
279         return c;
280     }
281     function div(uint256 a, uint256 b) internal pure returns (uint256) {
282         require(b > 0);
283         uint256 c = a / b;
284         return c;
285     }
286     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
287         require(b <= a);
288         uint256 c = a - b;
289         return c;
290     }
291     function add(uint256 a, uint256 b) internal pure returns (uint256) {
292         uint256 c = a + b;
293         require(c >= a);
294         return c;
295     }
296     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
297         require(b != 0);
298         return a % b;
299     }
300 }