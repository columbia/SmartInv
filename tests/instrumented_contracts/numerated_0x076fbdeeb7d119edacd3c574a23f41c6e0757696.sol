1 pragma solidity ^0.4.24;
2 
3 /*
4  _____                                                        _   
5 /__   \_ __ ___  __ _ ___ _   _ _ __ ___    /\  /\_   _ _ __ | |_ 
6   / /\/ '__/ _ \/ _` / __| | | | '__/ _ \  / /_/ / | | | '_ \| __|
7  / /  | | |  __/ (_| \__ \ |_| | | |  __/ / __  /| |_| | | | | |_ 
8  \/   |_|  \___|\__,_|___/\__,_|_|  \___| \/ /_/  \__,_|_| |_|\__|
9 
10 
11  Treasure Hunt
12 
13  Buy a box with 0.1 ETH for your chance to find hidden treasure.
14 
15  You have the chance to win a portion of the Jackpot
16 
17  When all the boxes have been opened or 5 treasure chests are found,
18  the board resets with the Jackpot carrying over to the next game
19 
20  You will need Metamask or Trustwallet to play
21 
22  GREEN boxes are available to open, just click to open then pay 0.1 ETH
23 
24  RED boxes have been opened and were empty
25 
26  CHESTS are where treasure was discovered
27 
28  COPY your maternode link and send it to your friends
29  Whenever they buy a box using your link, you get 10% of their
30  bet!!!!!
31 
32  COME JOIN THE HUNT
33 
34  website:  https:treasurehunter.ga
35 
36  discord:  https://discord.gg/VQwAtyy
37                                                                   
38 */
39 
40 
41 contract TreasureHunt {
42     using SafeMath for uint;
43 
44 
45     event Winner(
46         address customerAddress,
47         uint256 amount
48     );
49 
50     event Bet(
51         address customerAddress,
52         uint256 number
53     );
54 
55      event Restart(
56         uint256 number
57     );
58     
59     mapping (uint8 => address[]) playersByNumber ;
60     mapping (bytes32 => bool) gameNumbers;
61     mapping (bytes32 => bool) prizeNumbers;
62     mapping (uint8 => bool) Prizes;
63     mapping (uint8 => bool) PrizeLocations;
64     mapping (uint8 => bool) usedNumbers;
65 
66 
67     uint8[] public numbers;
68     uint8[] public PrizeNums;
69     bytes32[] public prizeList;
70     uint public lastNumber;
71 
72     bytes32[101] bytesArray;
73 
74     uint public gameCount = 1;
75 
76     uint public minBet = 0.1 ether;
77     uint public jackpot = 0;
78     uint8 public prizeCount = 0;
79 
80     uint8 public prizeMax = 10;
81 
82     uint public houseRate = 40;  //4%
83     uint public referralRate = 100; //10%
84 
85     uint8 public numberCount = 0;
86     uint maxNum = 100;
87 
88     uint8 maxPrizeNum = 5;
89 
90     
91     address owner;
92     
93     constructor() public {
94         owner = msg.sender;
95 
96         prizeCount = 0;
97         gameCount = gameCount + 1;
98         numberCount = 0;
99         for (uint8 i = 1; i<maxNum+1; i++) {
100             bytesArray[i] = 0x0;
101             usedNumbers[i] = false;
102         }
103        
104     }
105 
106 
107     function contains(uint8 number) public view returns (bool){
108         return usedNumbers[number];
109     }
110 
111     function enterNumber(uint8 number, address _referrer) payable public {
112         //bytes32 bytesNumber = bytes32(number);
113 
114         require(!contains(number));
115         require(msg.value >= minBet);
116         require(number <= maxNum+1);
117 
118         numberCount += 1;
119         
120 
121         uint betAmount = msg.value;
122 
123         uint houseFee = SafeMath.div(SafeMath.mul(betAmount, houseRate),1000);
124 
125         owner.transfer(houseFee);
126 
127         betAmount = SafeMath.sub(betAmount,houseFee);
128 
129 
130         if(
131         // is this a referred purchase?
132             _referrer != 0x0000000000000000000000000000000000000000 &&
133             _referrer != msg.sender)
134             {
135                 uint refFee = SafeMath.div(SafeMath.mul(betAmount, referralRate),1000);
136                 
137                 _referrer.transfer(refFee);
138                 betAmount = SafeMath.sub(betAmount,refFee);
139             }
140 
141         uint8 checkPrize = random();
142         jackpot = address(this).balance;
143         if (number == checkPrize||number == checkPrize+10||number == checkPrize+20||number == checkPrize+30||number == checkPrize+40||number == checkPrize+50||number == checkPrize+60||number == checkPrize+70||number == checkPrize+80||number == checkPrize+90) {
144         
145                 prizeCount = prizeCount + 1;
146                 payout(prizeCount);
147                 bytesArray[number] = 0x2;
148   
149         } else {
150             bytesArray[number] = 0x1;
151         }
152 
153         //playersByNumber[number].push(msg.sender);
154         numbers.push(number);
155         usedNumbers[number] = true;
156         //gameNumbers.push(number);
157 
158         emit Bet(msg.sender, number);
159 
160         if (numberCount >= maxNum-1) {
161             restartGame();
162         }
163         
164     }
165 
166     function payout(uint8 prizeNum)  {
167 
168         uint winAmount = 0;
169         jackpot = address(this).balance;
170         //msg.sender.transfer(jackpot);
171         // winAmount = SafeMath.div(SafeMath.mul(jackpot,100),10);
172         // msg.sender.transfer(winAmount);
173 
174         uint prizelevel = randomPrize();
175         
176         if (prizelevel == 1){   //payout 10% of jackpot
177 
178             winAmount = SafeMath.div(SafeMath.mul(jackpot,10),100);
179             msg.sender.transfer(winAmount);
180 
181         } else if (prizelevel == 2) {
182 
183             winAmount = SafeMath.div(SafeMath.mul(jackpot,20),100);
184             msg.sender.transfer(winAmount);
185 
186         } else if (prizelevel == 3) {
187 
188             winAmount = SafeMath.div(SafeMath.mul(jackpot,30),100);
189             msg.sender.transfer(winAmount);
190 
191         } else if (prizelevel == 4) {
192 
193             winAmount = SafeMath.div(SafeMath.mul(jackpot,40),100);
194             msg.sender.transfer(winAmount);
195 
196         } else if (prizelevel >= 5) {
197 
198             winAmount = SafeMath.div(SafeMath.mul(jackpot,70),100);
199             msg.sender.transfer(winAmount);
200             
201 
202         }
203 
204         // if (prizeCount >= maxPrizeNum){
205         //     restartGame();
206         // }
207 
208         emit Winner(msg.sender,winAmount);
209         
210     }
211 
212     function restartGame() internal {
213         //reset values
214         prizeCount = 0;
215         delete numbers;
216         delete PrizeNums;
217         delete bytesArray;
218         //delete usedNumbers;
219         gameCount = gameCount + 1;
220         numberCount = 0;
221         for (uint8 i = 0; i<101; i++) {
222             //bytesArray[i] = 0x0;
223             usedNumbers[i] = false;
224         }
225         emit Restart(gameCount);
226     }
227 
228 
229   function restartRemote() public {
230         //reset values
231         require(msg.sender == owner);
232         prizeCount = 0;
233         delete numbers;
234         delete PrizeNums;
235         delete bytesArray;
236         //delete usedNumbers;
237         gameCount = gameCount + 1;
238         numberCount = 0;
239         for (uint8 i = 0; i<101; i++) {
240             //bytesArray[i] = 0x0;
241             usedNumbers[i] = false;
242         }
243         emit Restart(gameCount);
244     }
245 
246     function random() private view returns (uint8) {
247 
248 
249 
250         uint8 prize = uint8(uint256(keccak256(block.timestamp, block.difficulty)) % prizeMax) + 1;
251 
252         PrizeNums.push(prize);
253 
254         return(prize);
255 
256  
257     }
258 
259     function randomPrize() private view returns (uint8) {
260 
261 
262 
263         uint8 prizeLevel = uint8(uint256(keccak256(block.timestamp, block.difficulty)) % 5) + 1;
264 
265         return(prizeLevel);
266 
267  
268     }
269 
270     function jackpotDeposit() public payable 
271     {
272 
273     }
274 
275     function prizeContains(uint8 number) returns (uint8){
276         return PrizeNums[number];
277     }
278 
279     function getArray() constant returns (bytes32[101])
280     {
281         return bytesArray;
282     }
283 
284     function getValue(uint8 x) constant returns (bytes32)
285     {
286         return bytesArray[x];
287     }
288 
289     function setMaxPrizeNum(uint8 maxNum) public
290     {
291         require(msg.sender == owner);
292         maxPrizeNum = maxNum;
293     }
294 
295 
296 
297     function getPrize(uint8 x) constant returns (uint8)
298         {
299             return PrizeNums[x];
300         }
301 
302     function getPrizeNumber(bytes32 x) constant returns (bool)
303         {
304             return prizeNumbers[x];
305         }
306 
307     function getEthValue() public view returns (uint)
308     {
309         return address(this).balance;
310     } 
311     
312 }
313 
314 
315 /**
316  * @title SafeMath
317  * @dev Math operations with safety checks that throw on error
318  */
319 library SafeMath {
320   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
321     uint256 c = a * b;
322     assert(a == 0 || c / a == b);
323     return c;
324   }
325  
326   function div(uint256 a, uint256 b) internal constant returns (uint256) {
327     // assert(b > 0); // Solidity automatically throws when dividing by 0
328     uint256 c = a / b;
329     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
330     return c;
331   }
332  
333   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
334     assert(b <= a);
335     return a - b;
336   }
337  
338   function add(uint256 a, uint256 b) internal constant returns (uint256) {
339     uint256 c = a + b;
340     assert(c >= a);
341     return c;
342   }
343 }