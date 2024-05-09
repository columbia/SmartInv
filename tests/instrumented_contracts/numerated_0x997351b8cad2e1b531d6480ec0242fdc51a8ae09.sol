1 pragma solidity ^0.4.16;
2 
3 /**
4  * This contract specially developed for http://diceforslice.co
5  * 
6  * What is it?
7  * This is a game that allows you to win an amount of ETH to your personal ethereum address.
8  * The possible winning depends on your stake and on amount of ETH in the bank.
9  *
10  * Wanna profit?
11  * Be a sponsor or referral - read more on http://diceforslice.co
12  *
13  * Win chances:
14  * 1 dice = 1/6
15  * 2 dice = 1/18
16  * 3 dice = 1/36
17  * 4 dice = 1/54
18  * 5 dice = 1/64
19  */
20 
21 /**
22  * @title Math
23  * @dev Math operations with safety checks that throw on error. Added: random and "float" divide for numbers
24  */
25 library Math {
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a * b;
28         assert(a == 0 || c / a == b);
29         return c;
30     }
31  
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // assert(b > 0); // Solidity automatically throws when dividing by 0
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36         return c;
37     }
38  
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43  
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 
50     function divf(int256 numerator, int256 denominator, uint256 precision) internal pure returns(int256) {
51         int256 _numerator = numerator * int256(10 ** (precision + 1));
52         int256 _quotient  = ((_numerator / denominator) + 5) / 10;
53         return _quotient;
54     }
55 
56     function percent(uint256 value, uint256 per) internal pure returns(uint256) {
57         return uint256((divf(int256(value), 100, 4) * int256(per)) / 10000);
58     }
59 }
60 
61 /**
62  * @title Randomizer
63  * @dev Fuck me... >_<
64  */
65 contract Randomizer {
66     function getRandomNumber(int256 min, int256 max) public returns(int256);
67 }
68 
69 
70 /**
71  * @title Ownable
72  * @dev Check contract ownable for some admin operations
73  */
74 contract Ownable {
75     address public owner;
76     
77     modifier onlyOwner()  { require(msg.sender == owner); _; }
78 
79     function Ownable() public {
80         owner = msg.sender;
81     }
82 
83     function updateContractOwner(address newOwner) external onlyOwner {
84         require(newOwner != address(0));
85         owner = newOwner;
86     }
87 }
88 
89 
90 /**
91  * @dev General contract
92  */
93 contract DiceForSlice is Ownable {
94     // Contract events
95     event UserBet       (address user, uint8 number1, uint8 number2, uint8 number3, uint8 number4, uint8 number5);
96     event DiceRoll      (uint8 number1, uint8 number2, uint8 number3, uint8 number4, uint8 number5);
97     event Loser         (address loser);
98     event WeHaveAWinner (address winner, uint256 amount);
99     event OMGItIsJackPot(address winner);
100 
101     // Address storage for referral system
102     mapping(address => uint256) private bets;
103 
104     // Randomizer contract
105     Randomizer private rand;
106 
107     // Sponsor data
108     address private sponsor;
109     uint256 private sponsorDiff  = 100000000000000000;
110     uint256 public sponsorValue  = 0;
111 
112     // Current balances of contract
113     // -bank  - available reward value
114     // -stock - available value for restore bank in emergency
115     uint256 public bank          = 0;
116     uint256 public stock         = 0;
117 
118     // Bet price
119     uint256 private betPrice     = 500000000000000000;
120 
121     // Current bet split rules (in percent)
122     uint8   private partBank     = 55;
123     uint8   private partOwner    = 20;
124     uint8   private partSponsor  = 12;
125     uint8   private partStock    = 10;
126     uint8   private partReferral = 3;
127 
128     // Current rewards (in percent from bank)
129     uint8   private rewardOne    = 10;
130     uint8   private rewardTwo    = 20;
131     uint8   private rewardThree  = 30;
132     uint8   private rewardFour   = 50;
133     uint8   private jackPot      = 100;
134 
135     // Current number min max
136     uint8   private minNumber    = 1;
137     uint8   private maxNumber    = 6;
138 
139     /**
140      * @dev Check is valid msg value
141      */
142     modifier isValidBet(uint8 reward) {
143         require(msg.value == Math.percent(betPrice, reward));
144         _;
145     }
146 
147     /**
148      * @dev Check bank not empty (empty is < betPrice eth)
149      */
150     modifier bankNotEmpty() {
151         require(bank >= Math.percent(betPrice, rewardTwo));
152         require(address(this).balance >= bank);
153         _;
154     }
155 
156 
157     /**
158      * @dev Set randomizer address
159      */
160     function setRandomizer(address _rand) external onlyOwner {
161         rand = Randomizer(_rand);
162     }
163 
164 
165     /**
166      * @dev Special method for fill contract bank 
167      */
168     function fillTheBank() external payable {
169         require(msg.value >= sponsorDiff);
170         if (msg.value >= sponsorValue + sponsorDiff) {
171             sponsorValue = msg.value;
172             sponsor      = msg.sender;
173         }
174         bank = Math.add(bank, msg.value);
175     }
176 
177 
178     /**
179      * @dev Restore value from stock
180      */
181     function appendStock(uint256 amount) external onlyOwner {
182         require(amount > 0);
183         require(stock >= amount);
184         bank  = Math.add(bank,  amount);
185         stock = Math.sub(stock, amount);
186     }
187 
188 
189     /**
190      * @dev Get full contract balance
191      */
192     function getBalance() public view returns(uint256) {
193         return address(this).balance;
194     }
195 
196 
197     /**
198      * @dev Get random number
199      */
200     function getRN() internal returns(uint8) {
201         return uint8(rand.getRandomNumber(minNumber, maxNumber + minNumber));
202     }
203 
204 
205     /**
206      * @dev Check is valid number
207      */
208     function isValidNumber(uint8 number) private view returns(bool) {
209         return number >= minNumber && number <= maxNumber;
210     }
211 
212 
213     /**
214      * @dev Split user bet in some pieces:
215      * - 55% go to bank
216      * - 20% go to contract developer :)
217      * - 12% go to sponsor
218      * - 10% go to stock for future restores
219      * - 3%  go to referral (if exists, if not - go into stock)
220      */
221     function splitTheBet(address referral) private {
222         uint256 _partBank     = Math.percent(msg.value, partBank);
223         uint256 _partOwner    = Math.percent(msg.value, partOwner);
224         uint256 _partStock    = Math.percent(msg.value, partStock);
225         uint256 _partSponsor  = Math.percent(msg.value, partSponsor);
226         uint256 _partReferral = Math.percent(msg.value, partReferral);
227         
228         bank  = Math.add(bank,  _partBank);
229         stock = Math.add(stock, _partStock);
230         owner.transfer(_partOwner);
231         sponsor.transfer(_partSponsor);
232 
233         if (referral != address(0) && referral != msg.sender && bets[referral] > 0) {
234             referral.transfer(_partReferral);
235         } else {
236             stock = Math.add(stock, _partReferral);
237         }
238     }
239 
240 
241     /**
242      * @dev Check the winner
243      */
244     function isWinner(uint8 required, uint8[5] numbers, uint8[5] randoms) private pure returns(bool) {
245         uint8 count = 0;
246         for (uint8 i = 0; i < numbers.length; i++) {
247             if (numbers[i] == 0) continue;
248             for (uint8 j = 0; j < randoms.length; j++) {
249                 if (randoms[j] == 0) continue;
250                 if (randoms[j] == numbers[i]) {
251                     count++;
252                     delete randoms[j];
253                     break;
254                 }
255             }
256         }
257         return count == required;
258     }
259 
260 
261     /**
262      * @dev Reward the winner
263      */
264     function rewardTheWinner(uint8 reward) private {
265         uint256 rewardValue = Math.percent(bank, reward);
266         require(rewardValue <= getBalance());
267         require(rewardValue <= bank);
268         bank = Math.sub(bank, rewardValue);
269         msg.sender.transfer(rewardValue);
270         emit WeHaveAWinner(msg.sender, rewardValue);
271     }
272 
273 
274     /**
275      * @dev Roll the dice for numbers
276      */
277     function rollOne(address referral, uint8 number)
278     external payable isValidBet(rewardOne) bankNotEmpty {
279         require(isValidNumber(number));       
280         bets[msg.sender]++;
281 
282         splitTheBet(referral);
283 
284         uint8[5] memory numbers = [number,  0, 0, 0, 0];
285         uint8[5] memory randoms = [getRN(), 0, 0, 0, 0];
286 
287         emit UserBet(msg.sender, number, 0, 0, 0, 0);
288         emit DiceRoll(randoms[0], 0, 0, 0, 0);
289         if (isWinner(1, numbers, randoms)) {
290             rewardTheWinner(rewardOne);
291         } else {
292             emit Loser(msg.sender);
293         }
294     }
295 
296 
297     function rollTwo(address referral, uint8 number1, uint8 number2)
298     external payable isValidBet(rewardTwo) bankNotEmpty {
299         require(isValidNumber(number1) && isValidNumber(number2));
300         bets[msg.sender]++;
301 
302         splitTheBet(referral);
303 
304         uint8[5] memory numbers = [number1, number2, 0, 0, 0];
305         uint8[5] memory randoms = [getRN(), getRN(), 0, 0, 0];
306 
307         emit UserBet(msg.sender, number1, number2, 0, 0, 0);
308         emit DiceRoll(randoms[0], randoms[1], 0, 0, 0);
309         if (isWinner(2, numbers, randoms)) {
310             rewardTheWinner(rewardTwo);
311         } else {
312             emit Loser(msg.sender);
313         }
314     }
315 
316 
317     function rollThree(address referral, uint8 number1, uint8 number2, uint8 number3)
318     external payable isValidBet(rewardThree) bankNotEmpty {
319         require(isValidNumber(number1) && isValidNumber(number2) && isValidNumber(number3));
320         bets[msg.sender]++;
321 
322         splitTheBet(referral);
323 
324         uint8[5] memory numbers = [number1, number2, number3, 0, 0];
325         uint8[5] memory randoms = [getRN(), getRN(), getRN(), 0, 0];
326 
327         emit UserBet(msg.sender, number1, number2, number3, 0, 0);
328         emit DiceRoll(randoms[0], randoms[1], randoms[2], 0, 0);
329         if (isWinner(3, numbers, randoms)) {
330             rewardTheWinner(rewardThree);
331         } else {
332             emit Loser(msg.sender);
333         }
334     }
335 
336 
337     function rollFour(address referral, uint8 number1, uint8 number2, uint8 number3, uint8 number4)
338     external payable isValidBet(rewardFour) bankNotEmpty {
339         require(isValidNumber(number1) && isValidNumber(number2) && isValidNumber(number3) && isValidNumber(number4));
340         bets[msg.sender]++;
341 
342         splitTheBet(referral);
343 
344         uint8[5] memory numbers = [number1, number2, number3, number4, 0];
345         uint8[5] memory randoms = [getRN(), getRN(), getRN(), getRN(), 0];
346 
347         emit UserBet(msg.sender, number1, number2, number3, number4, 0);
348         emit DiceRoll(randoms[0], randoms[1], randoms[2], randoms[3], 0);
349         if (isWinner(4, numbers, randoms)) {
350             rewardTheWinner(rewardFour);
351         } else {
352             emit Loser(msg.sender);
353         }
354     }
355 
356 
357     function rollFive(address referral, uint8 number1, uint8 number2, uint8 number3, uint8 number4, uint8 number5)
358     external payable isValidBet(jackPot) bankNotEmpty {
359         require(isValidNumber(number1) && isValidNumber(number2) && isValidNumber(number3) && isValidNumber(number4) && isValidNumber(number5));
360         bets[msg.sender]++;
361 
362         splitTheBet(referral);
363 
364         uint8[5] memory numbers = [number1, number2, number3, number4, number5];
365         uint8[5] memory randoms = [getRN(), getRN(), getRN(), getRN(), getRN()];
366 
367         emit UserBet(msg.sender, number1, number2, number3, number4, number5);
368         emit DiceRoll(randoms[0], randoms[1], randoms[2], randoms[3], randoms[4]);
369         if (isWinner(5, numbers, randoms)) {
370             rewardTheWinner(jackPot);
371             emit OMGItIsJackPot(msg.sender);
372         } else {
373             emit Loser(msg.sender);
374         }
375     }
376 }