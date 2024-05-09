1 pragma solidity ^0.4.25;
2 
3 contract IUserData {
4     //set
5     function setUserRef(address _address, address _refAddress, string _gameName) public;
6     //get
7     function getUserRef(address _address, string _gameName) public view returns (address);
8 }
9 
10 contract Dice_BrickGame {
11     IUserData userData = IUserData(address(0x21d364b66d9065B5207124e2b1e49e4193e0a2ff));
12 
13     //Setup Contract
14     uint8 public FEE_PERCENT = 2;
15     uint8 public JACKPOT_PERCENT = 1;
16     uint constant MIN_JACKPOT = 0.1 ether;
17     uint public JACKPOT_WIN = 1000;
18     uint public MIN_BET = 0.01 ether;
19     uint public MAX_BET = 1 ether;
20     uint public MAX_PROFIT = 5 ether;
21     uint public REF_PERCENT = 5;
22     address public owner;
23     address private bot;
24     uint public jackpotFund;
25     uint public resolve = 0;
26     uint public payLoan = 0;
27 
28     struct Bet {
29         uint blockNumber;
30         address player;
31         uint amount;
32         bytes hexData;
33     }
34 
35     struct Loan {
36         address player;
37         uint amount;
38     }
39 
40     Bet[] public bets;
41     Loan[] private loans;
42 
43 
44     // Events
45     event DiceBet(address indexed player, uint amount, uint blockNumber, bytes data, uint8 result, uint reward, uint16 jackpotNumber, uint indexed modulo);
46     event Jackpot(address indexed player, uint amount);
47     event JackpotIncrease(uint amount);
48     event FailedPayment(address indexed beneficiary, uint amount);
49     event Payment(address indexed beneficiary, uint amount);
50     event Repayment(address indexed beneficiary, uint amount);
51 
52     constructor () public {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         require(msg.sender == owner, "OnlyOwner can call.");
58         _;
59     }
60 
61     modifier onlyBot {
62         require(msg.sender == bot || msg.sender == owner, "OnlyOwner can call.");
63         _;
64     }
65 
66     function() public payable {
67         uint8 length = uint8(msg.data.length);
68         require(length >= 2, "Wrong bet number!");
69         address ref = address(0x0);
70         uint8 index;
71         if(length > 12) {
72             index = 20;
73             ref = toAddress(msg.data, 0);
74             require(ref != msg.sender, "Reference must be different than sender");
75         } else {
76             index = 0;
77         }
78         uint8 modulo = uint8((msg.data[index] >> 4) & 0xF) * 10 + uint8(msg.data[index] & 0xF);
79         require(modulo == 2 || modulo == 6 || modulo == 12 || modulo == 0, "Wrong modulo!");
80         if (modulo == 0) {
81             modulo = 100;
82         }
83         uint8[] memory number = new uint8[](length - index - 1);
84         for (uint8 j = 0; j < length - index - 1; j++) {
85             number[j] = uint8((msg.data[j + index + 1] >> 4) & 0xF) * 10 + uint8(msg.data[j + index + 1] & 0xF);
86             if (modulo == 12) {
87                 require(number[j] > 1 && number[j] <= 12, "Two Dice Confirm!");
88             } else {
89                 require(number[j] <= modulo, "Wrong number bet!");
90                 if (modulo != 100) {
91                     require(number[j] > 0, "Wrong number bet!");
92                 }
93             }
94         }
95         if (modulo == 100) {
96             require(number[0] == 0 || number[0] == 1, "Etheroll Confirm!");
97             require(number[1] > 1 && number[1] < 100, "Etheroll Confirm!");
98         } else if (modulo == 12) {
99             require(number.length < 11, "Much number bet!");
100         } else {
101             require(number.length < modulo, "Much number bet!");
102         }
103         require(msg.value >= MIN_BET && msg.value <= MAX_BET, "Value confirm!");
104         uint winPossible;
105         if (modulo == 100) {
106             if (number[0] == 1) {
107                 winPossible = (100 - number[1]) / number[1] * msg.value * (100 - FEE_PERCENT - (msg.value >= MIN_JACKPOT ? 1 : 0)) / 100;
108             } else {
109                 winPossible = (number[1] - 1) / (101 - number[1]) * msg.value * (100 - FEE_PERCENT - (msg.value >= MIN_JACKPOT ? 1 : 0)) / 100;
110             }
111         } else {
112             if (modulo == 12) {
113                 winPossible = ((modulo - 1 - number.length) / number.length + 1) * msg.value * (100 - FEE_PERCENT - (msg.value >= MIN_JACKPOT ? 1 : 0)) / 100;
114             } else {
115                 winPossible = ((modulo - number.length) / number.length + 1) * msg.value * (100 - FEE_PERCENT - (msg.value >= MIN_JACKPOT ? 1 : 0)) / 100;
116             }
117 
118         }
119         require(winPossible <= MAX_PROFIT);
120         if(userData.getUserRef(msg.sender, "Dice") != address(0x0)) {
121             userData.getUserRef(msg.sender, "Dice").transfer(msg.value * REF_PERCENT / 1000);
122         } else if(ref != address(0x0)) {
123             ref.transfer(msg.value * REF_PERCENT / 1000);
124             userData.setUserRef(msg.sender, ref, "Dice");
125         }
126         bets.length++;
127         bets[bets.length - 1].blockNumber = block.number;
128         bets[bets.length - 1].player = msg.sender;
129         bets[bets.length - 1].amount = msg.value;
130         bets[bets.length - 1].hexData.length = length - index;
131         for(j = 0; j < bets[bets.length - 1].hexData.length; j++){
132             bets[bets.length - 1].hexData[j] = msg.data[j + index];
133         }
134     }
135 
136     function setBot(address _bot) public onlyOwner {
137         require(_bot != address(0x0));
138         bot = _bot;
139     }
140 
141     function setConfig(uint8 _FEE_PERCENT, uint8 _JACKPOT_PERCENT, uint _MAX_PROFIT, uint _MIN_BET, uint _MAX_BET, uint _JACKPOT_WIN, uint8 _REF_PERCENT) public onlyOwner {
142         FEE_PERCENT = _FEE_PERCENT;
143         JACKPOT_PERCENT = _JACKPOT_PERCENT;
144         MAX_PROFIT = _MAX_PROFIT;
145         MIN_BET = _MIN_BET;
146         MAX_BET = _MAX_BET;
147         MAX_PROFIT = _MAX_PROFIT;
148         JACKPOT_WIN = _JACKPOT_WIN;
149         REF_PERCENT = _REF_PERCENT;
150     }
151 
152     function increaseJackpot(uint increaseAmount) external onlyOwner {
153         require(increaseAmount <= address(this).balance, "Not enough funds");
154         jackpotFund += uint(increaseAmount);
155         emit JackpotIncrease(jackpotFund);
156     }
157 
158     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
159         require(withdrawAmount <= address(this).balance, "Not enough funds");
160         require(jackpotFund + withdrawAmount <= address(this).balance, "Not enough funds.");
161         sendFunds(beneficiary, withdrawAmount);
162     }
163 
164     function kill() external onlyOwner {
165         sendFunds(owner, address(this).balance);
166         selfdestruct(owner);
167     }
168 
169 
170     function doBet(uint gameNumber) private {
171         uint8 modulo = uint8((bets[gameNumber].hexData[0] >> 4) & 0xF) * 10 + uint8(bets[gameNumber].hexData[0] & 0xF);
172         uint8 result;
173         if (modulo == 12) {
174             uint8 dice1 = uint8(keccak256(abi.encodePacked(bets[gameNumber].hexData, blockhash(bets[gameNumber].blockNumber)))) % 6;
175             uint8 dice2 = uint8(keccak256(abi.encodePacked(address(this).balance, blockhash(bets[gameNumber].blockNumber), bets[gameNumber].player))) % 6;
176             result = (dice1 == 0 ? 6 : dice1) + (dice2 == 0 ? 6 : dice2);
177         } else {
178             result = uint8(keccak256(abi.encodePacked(bets[gameNumber].hexData, address(this).balance, blockhash(bets[gameNumber].blockNumber), bets[gameNumber].player))) % modulo;
179         }
180         if (result == 0) {
181             result = modulo;
182         }
183         uint winValue = 0;
184         uint8[] memory number = new uint8[](bets[gameNumber].hexData.length - 1);
185         for (uint8 j = 0; j < bets[gameNumber].hexData.length - 1; j++) {
186             number[j] = uint8((bets[gameNumber].hexData[j + 1] >> 4) & 0xF) * 10 + uint8(bets[gameNumber].hexData[j + 1] & 0xF);
187         }
188 
189         for (uint8 i = 0; i < number.length; i++) {
190             if (number[i] == result) {
191                 if (modulo == 12) {
192                     winValue = bets[gameNumber].amount * (100 - FEE_PERCENT) / 100 + (modulo - 1 - number.length) * bets[gameNumber].amount * (100 - FEE_PERCENT) / (100 * number.length);
193                 } else {
194                     winValue = bets[gameNumber].amount * (100 - FEE_PERCENT) / 100 + (modulo - number.length) * bets[gameNumber].amount * (100 - FEE_PERCENT) / (100 * number.length);
195                 }
196                 break;
197             }
198         }
199         if (bets[gameNumber].amount >= MIN_JACKPOT) {
200             jackpotFund += bets[gameNumber].amount * JACKPOT_PERCENT / 100;
201             emit JackpotIncrease(jackpotFund);
202             if (winValue != 0) {
203                 winValue = bets[gameNumber].amount * (100 - FEE_PERCENT - JACKPOT_PERCENT) / 100 + (modulo - number.length) * bets[gameNumber].amount * (100 - FEE_PERCENT - JACKPOT_PERCENT) / (100 * number.length);
204             }
205             uint16 jackpotNumber = uint16(uint(keccak256(abi.encodePacked(bets[gameNumber].player, winValue, blockhash(bets[gameNumber].blockNumber), bets[gameNumber].hexData))) % JACKPOT_WIN);
206             if (jackpotNumber == 999) {
207                 emit Jackpot(bets[gameNumber].player, jackpotFund);
208                 sendFunds(bets[gameNumber].player, jackpotFund + winValue);
209                 jackpotFund = 0;
210             } else {
211                 if (winValue > 0) {
212                     sendFunds(bets[gameNumber].player, winValue);
213                 }
214             }
215         } else {
216             if (winValue > 0) {
217                 sendFunds(bets[gameNumber].player, winValue);
218             }
219         }
220         emit DiceBet(bets[gameNumber].player, bets[gameNumber].amount, bets[gameNumber].blockNumber, bets[gameNumber].hexData, result, winValue, jackpotNumber, modulo);
221     }
222 
223     function etheRoll(uint gameNumber) private {
224         uint8 result = uint8(keccak256(abi.encodePacked(bets[gameNumber].hexData, blockhash(bets[gameNumber].blockNumber), bets[gameNumber].player))) % 100;
225         if (result == 0) {
226             result = 100;
227         }
228         uint winValue = 0;
229 
230         uint8[] memory number = new uint8[](bets[gameNumber].hexData.length - 1);
231         for (uint8 j = 0; j < bets[gameNumber].hexData.length - 1; j++) {
232             number[j] = uint8((bets[gameNumber].hexData[j + 1] >> 4) & 0xF) * 10 + uint8(bets[gameNumber].hexData[j + 1] & 0xF);
233         }
234 
235         if (number[0] == 0 && number[1] >= result) {
236             winValue = bets[gameNumber].amount * (100 - FEE_PERCENT) / 100 + (100 - uint(number[1])) * bets[gameNumber].amount * (100 - FEE_PERCENT) / (100 * uint(number[1]));
237         }
238         if (number[0] == 1 && number[1] <= result) {
239             winValue = bets[gameNumber].amount * (100 - FEE_PERCENT) / 100 + (uint(number[1]) - 1) * bets[gameNumber].amount * (100 - FEE_PERCENT) / (100 * (101 - uint(number[1])));
240         }
241         if (bets[gameNumber].amount >= MIN_JACKPOT) {
242             jackpotFund += bets[gameNumber].amount * JACKPOT_PERCENT / 100;
243             emit JackpotIncrease(jackpotFund);
244             if (number[0] == 0 && number[1] >= result) {
245                 winValue = bets[gameNumber].amount * (100 - FEE_PERCENT - JACKPOT_PERCENT) / 100 + (100 - uint(number[1])) * bets[gameNumber].amount * (100 - FEE_PERCENT - JACKPOT_PERCENT) / (100 * uint(number[1]));
246             }
247             if (number[0] == 1 && number[1] <= result) {
248                 winValue = bets[gameNumber].amount * (100 - FEE_PERCENT - JACKPOT_PERCENT) / 100 + (uint(number[1]) - 1) * bets[gameNumber].amount * (100 - FEE_PERCENT - JACKPOT_PERCENT) / (100 * (101 - uint(number[1])));
249             }
250             uint16 jackpotNumber = uint16(uint(keccak256(abi.encodePacked(bets[gameNumber].hexData, winValue, blockhash(bets[gameNumber].blockNumber), bets[gameNumber].player))) % JACKPOT_WIN);
251             if (jackpotNumber == 999) {
252                 emit Jackpot(bets[gameNumber].player, jackpotFund);
253                 sendFunds(bets[gameNumber].player, jackpotFund + winValue);
254                 jackpotFund = 0;
255             } else {
256                 if (winValue > 0) {
257                     sendFunds(bets[gameNumber].player, winValue);
258                 }
259             }
260         } else {
261             if (winValue > 0) {
262                 sendFunds(bets[gameNumber].player, winValue);
263             }
264         }
265 
266         emit DiceBet(bets[gameNumber].player, bets[gameNumber].amount, bets[gameNumber].blockNumber, bets[gameNumber].hexData, result, winValue, jackpotNumber, 100);
267     }
268 
269     function resolveBet() public onlyBot {
270         uint i = 0;
271         for (uint k = resolve; k < bets.length; k++) {
272             uint8 modulo = uint8((bets[k].hexData[0] >> 4) & 0xF) * 10 + uint8(bets[k].hexData[0] & 0xF);
273             if (modulo == 0) {
274                 modulo = 100;
275             }
276 
277             if (bets[k].blockNumber <= (block.number - 1)) {
278                 if (modulo == 100) {
279                     etheRoll(k);
280                     i++;
281                 } else {
282                     doBet(k);
283                     i++;
284                 }
285             } else {
286                 break;
287             }
288         }
289         resolve += i;
290     }
291 
292     function addBalance() public payable {}
293 
294 
295     function sendFunds(address beneficiary, uint amount) private {
296         if (beneficiary.send(amount)) {
297             emit Payment(beneficiary, amount);
298         } else {
299             emit FailedPayment(beneficiary, amount);
300             loans.push(Loan(beneficiary, amount));
301         }
302     }
303 
304     function payLoan() public onlyBot {
305         uint pay = 0;
306         for (uint i = payLoan; i < loans.length; i++) {
307             if (loans[i].player.send(loans[i].amount)) {
308                 emit Repayment(loans[i].player, loans[i].amount);
309                 pay++;
310             } else {
311                 break;
312             }
313         }
314         payLoan += pay;
315     }
316 
317     function getLengthBets() public view returns (uint) {
318         return bets.length;
319     }
320     function toAddress(bytes _bytes, uint _start) internal  pure returns (address) {
321         require(_bytes.length >= (_start + 20),"Wrong size!");
322         address tempAddress;
323 
324         assembly {
325             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
326         }
327 
328         return tempAddress;
329     }
330 }