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
122 		if((r >= 80 && r < 83)    ||
123 			(r == 180 && r < 183) ||
124 			(r == 280 && r < 283) ||
125 			(r == 380 && r < 383) ||
126 			(r == 480 && r < 483) ||
127 			(r == 580 && r < 583) ||
128 			(r == 680 && r < 683) ||
129 			(r == 780 && r < 783) ||
130 			(r == 880 && r < 883) ||
131 			(r == 980 && r < 983))
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
143 			(r >= 775 && r < 780)) {
144 			return true;
145 		}
146 		else{
147 			return false;
148 		}
149 	}
150 	function _winChance2x(uint r) private pure returns(bool){
151 		if( (r >= 50 && r < 75)   ||
152 			(r >= 350 && r < 375) ||
153 			(r >= 650 && r < 675) ||
154 			(r >= 950 && r < 975)) {
155 			return true;
156 		}
157 		else{
158 			return false;
159 		}
160 	}
161 	function _winChance1_5x(uint r) private pure returns(bool){
162 		if((r >= 25 && r < 50) || (r >= 125 && r < 150)){
163 			return true;
164 		}
165 		else if((r >= 225 && r < 250) || (r >= 325 && r < 350)){
166 			return true;
167 		}
168 		else if((r >= 425 && r < 450) || (r >= 525 && r < 550)){
169 			return true;
170 		}
171 		else if((r >= 625 && r < 650) || (r >= 725 && r < 750)){
172 			return true;
173 		}
174 		else{
175 			return false;
176 		}
177 	}
178 	function _winChance1x(uint r) private pure returns(bool){
179 		if((r >= 0 && r < 25) || (r >= 100 && r < 125)){
180 			return true;
181 		}
182 		else if((r >= 200 && r < 225) || (r >= 300 && r < 325)){
183 			return true;
184 		}
185 		else if((r >= 400 && r < 425) || (r >= 500 && r < 525)){
186 			return true;
187 		}
188 		else if((r >= 600 && r < 625) || (r >= 700 && r < 725)){
189 			return true;
190 		}
191 		else if((r >= 800 && r < 825) || (r >= 900 && r < 925)){
192 			return true;
193 		}
194 		else{
195 			return false;
196 		}
197 	}
198     function checkSolvency(uint bet) view public returns(bool){
199         if(getContractBalance() > bet.mul(500).div(100).add(jackpotBalance)) return true;
200         else return false;
201     }
202     function sendDividends() public {
203         require(getContractBalance() > minContractBalance && now > nextPayout, "You cannot send dividends");
204         DSG DSG0 = DSG(DSG_ADDRESS);
205         uint256 balance = getContractBalance();
206         uint256 dividends = balance.sub(minContractBalance);
207         nextPayout = now.add(7 days);
208         totalDividends = totalDividends.add(dividends);
209         DSG0.gamingDividendsReception.value(dividends)();
210         emit Dividends(balance, dividends, now);
211     }
212      function getContractBalance() public view returns (uint256){
213         return address(this).balance;
214     }
215     function _random(uint256 max) private view returns(uint256){
216         bytes32 hash = blockhash(usersBets[msg.sender].blockNumber);
217         return uint256(keccak256(abi.encode(hash, msg.sender))) % max;
218     }
219     function deposit() public payable onlyOwners{
220         ownerDeposit = ownerDeposit.add(msg.value);
221     }
222     function sendOwnerDeposit(address recipient) public onlyOwners{
223         require(paused == true, 'Game was not stopped');
224         uint256 contractBalance = getContractBalance();
225         if(contractBalance >= ownerDeposit){
226             recipient.transfer(ownerDeposit);
227         }
228         else{
229             recipient.transfer(contractBalance);
230         }
231         delete jackpotBalance;
232         delete ownerDeposit;
233     }
234     function pauseGame(bool option) public onlyOwners{
235         paused = option;
236     }
237     function setMinBet(uint256 eth) public onlyOwners{
238         minBet = eth;
239     }
240     function setMaxBet(uint256 eth) public onlyOwners{
241         maxBet = eth;
242     }
243     function setMinBetForJackpot(uint256 eth) public onlyOwners{
244         minBetForJackpot = eth;
245     }
246     function setMinContractBalance(uint256 eth) public onlyOwners{
247         minContractBalance = eth;
248     }
249     function transferOwnership(address newOwnerAddress, uint8 k) public onlyOwners{
250         candidates[k] = newOwnerAddress;
251     }
252     function confirmOwner(uint8 k) public{
253         require(msg.sender == candidates[k]);
254         owners[k] = candidates[k];
255     }
256     event Dividends(
257         uint256 balance,
258         uint256 dividends,
259         uint256 timestamp
260     );
261     event Jackpot(
262         address indexed player,
263         uint256 jackpot,
264         uint256 timestamp
265     );
266     event PlaceBet(
267         address indexed player,
268         uint256 bet,
269         uint256 timestamp
270     );
271     event Result(
272         address indexed player,
273         uint256 indexed random,
274         uint256 totalWinAmount,
275         uint256 jackpotBalance,
276         uint256 bet,
277         uint256 winRate
278     );
279 }
280 library SafeMath {
281     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
282         if (a == 0) {  return 0; }
283         uint256 c = a * b;
284         require(c / a == b);
285         return c;
286     }
287     function div(uint256 a, uint256 b) internal pure returns (uint256) {
288         require(b > 0);
289         uint256 c = a / b;
290         return c;
291     }
292     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
293         require(b <= a);
294         uint256 c = a - b;
295         return c;
296     }
297     function add(uint256 a, uint256 b) internal pure returns (uint256) {
298         uint256 c = a + b;
299         require(c >= a);
300         return c;
301     }
302     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
303         require(b != 0);
304         return a % b;
305     }
306 }