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
22  * Become a sponsor dude. (small update for you)
23  * I have exhausted the entire limit of my ETH.
24  */
25 
26 /**
27  * @title Math
28  * @dev Math operations with safety checks that throw on error. Added: random and "float" divide for numbers
29  */
30 library Math {
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a * b;
33         assert(a == 0 || c / a == b);
34         return c;
35     }
36  
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         // assert(b > 0); // Solidity automatically throws when dividing by 0
39         uint256 c = a / b;
40         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41         return c;
42     }
43  
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         assert(b <= a);
46         return a - b;
47     }
48  
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         assert(c >= a);
52         return c;
53     }
54 
55     function divf(int256 numerator, int256 denominator, uint256 precision) internal pure returns(int256) {
56         int256 _numerator = numerator * int256(10 ** (precision + 1));
57         int256 _quotient  = ((_numerator / denominator) + 5) / 10;
58         return _quotient;
59     }
60 
61     function percent(uint256 value, uint256 per) internal pure returns(uint256) {
62         return uint256((divf(int256(value), 100, 4) * int256(per)) / 10000);
63     }
64 }
65 
66 /**
67  * @dev Randomizer contract interface
68  */
69 contract Randomizer {
70     function getRandomNumber(int256 min, int256 max) public returns(int256);
71 }
72 
73 
74 /**
75  * @title Ownable
76  * @dev Check contract ownable for some admin operations
77  */
78 contract Ownable {
79     address public owner;
80     
81     modifier onlyOwner()  { require(msg.sender == owner); _; }
82 
83     function Ownable() public {
84         owner = msg.sender;
85     }
86 
87     function updateContractOwner(address newOwner) external onlyOwner {
88         require(newOwner != address(0));
89         owner = newOwner;
90     }
91 }
92 
93 
94 /**
95  * @dev General contract
96  */
97 contract DiceForSlice is Ownable {
98     // Contract events
99     event UserBet       (address user, uint8 number1, uint8 number2, uint8 number3, uint8 number4, uint8 number5);
100     event DiceRoll      (uint8 number1, uint8 number2, uint8 number3, uint8 number4, uint8 number5);
101     event Loser         (address loser);
102     event WeHaveAWinner (address winner, uint256 amount);
103     event OMGItIsJackPot(address winner);
104 
105     // Address storage for referral system
106     mapping(address => uint256) private bets;
107 
108     // Randomizer contract
109     Randomizer private rand;
110 
111     // Sponsor data
112     address private sponsor;
113     uint256 private sponsorDiff  = 100000000000000000;
114     uint256 public sponsorValue  = 0;
115 
116     // Current balances of contract
117     // -bank  - available reward value
118     // -stock - available value for restore bank in emergency
119     uint256 public bank          = 0;
120     uint256 public stock         = 0;
121 
122     // Bet price
123     uint256 private betPrice     = 500000000000000000;
124 
125     // Current bet split rules (in percent)
126     uint8   private partBank     = 55;
127     uint8   private partOwner    = 20;
128     uint8   private partSponsor  = 12;
129     uint8   private partStock    = 10;
130     uint8   private partReferral = 3;
131 
132     // Current rewards (in percent from bank)
133     uint8   private rewardOne    = 10;
134     uint8   private rewardTwo    = 20;
135     uint8   private rewardThree  = 30;
136     uint8   private rewardFour   = 50;
137     uint8   private jackPot      = 100;
138 
139     // Current number min max
140     uint8   private minNumber    = 1;
141     uint8   private maxNumber    = 6;
142 
143     /**
144      * @dev Check is valid msg value
145      */
146     modifier isValidBet(uint8 reward) {
147         require(msg.value == Math.percent(betPrice, reward));
148         _;
149     }
150 
151     /**
152      * @dev Ok. Enough. No contracts call allowed
153      * Become a sponsor dude.
154      */
155     modifier notFromContract() {
156         require(tx.origin == msg.sender);
157         _;
158     }
159 
160     /**
161      * @dev Check bank not empty (empty is < betPrice eth)
162      */
163     modifier bankNotEmpty() {
164         require(bank >= Math.percent(betPrice, rewardTwo));
165         require(address(this).balance >= bank);
166         _;
167     }
168 
169 
170     /**
171      * @dev Set randomizer address
172      */
173     function setRandomizer(address _rand) external onlyOwner {
174         rand = Randomizer(_rand);
175     }
176 
177 
178     /**
179      * @dev Special method for fill contract bank 
180      */
181     function fillTheBank() public payable {
182         require(msg.value >= sponsorDiff);
183         if (msg.value >= sponsorValue + sponsorDiff) {
184             sponsorValue = msg.value;
185             sponsor      = msg.sender;
186         }
187         bank = Math.add(bank, msg.value);
188     }
189     
190     function() public payable {
191         fillTheBank();
192     }
193 
194 
195     /**
196      * @dev Restore value from stock
197      */
198     function appendStock(uint256 amount) external onlyOwner {
199         require(amount > 0);
200         require(stock >= amount);
201         bank  = Math.add(bank,  amount);
202         stock = Math.sub(stock, amount);
203     }
204 
205 
206     /**
207      * @dev Get full contract balance
208      */
209     function getBalance() public view returns(uint256) {
210         return address(this).balance;
211     }
212 
213 
214     /**
215      * @dev Get random number
216      */
217     function getRN() private returns(uint8) {
218         return uint8(rand.getRandomNumber(minNumber, maxNumber + minNumber));
219     }
220 
221 
222     /**
223      * @dev Check is valid number
224      */
225     function isValidNumber(uint8 number) private view returns(bool) {
226         return number >= minNumber && number <= maxNumber;
227     }
228 
229 
230     /**
231      * @dev Split user bet in some pieces:
232      * - 55% go to bank
233      * - 20% go to contract developer :)
234      * - 12% go to sponsor
235      * - 10% go to stock for future restores
236      * - 3%  go to referral (if exists, if not - go into stock)
237      */
238     function splitTheBet(address referral) private {
239         uint256 _partBank     = Math.percent(msg.value, partBank);
240         uint256 _partOwner    = Math.percent(msg.value, partOwner);
241         uint256 _partStock    = Math.percent(msg.value, partStock);
242         uint256 _partSponsor  = Math.percent(msg.value, partSponsor);
243         uint256 _partReferral = Math.percent(msg.value, partReferral);
244         
245         bank  = Math.add(bank,  _partBank);
246         stock = Math.add(stock, _partStock);
247         owner.transfer(_partOwner);
248         sponsor.transfer(_partSponsor);
249 
250         if (referral != address(0) && referral != msg.sender && bets[referral] > 0) {
251             referral.transfer(_partReferral);
252         } else {
253             stock = Math.add(stock, _partReferral);
254         }
255     }
256 
257 
258     /**
259      * @dev Check the winner
260      */
261     function isWinner(uint8 required, uint8[5] numbers, uint8[5] randoms) private pure returns(bool) {
262         uint8 count = 0;
263         for (uint8 i = 0; i < numbers.length; i++) {
264             if (numbers[i] == 0) continue;
265             for (uint8 j = 0; j < randoms.length; j++) {
266                 if (randoms[j] == 0) continue;
267                 if (randoms[j] == numbers[i]) {
268                     count++;
269                     delete randoms[j];
270                     break;
271                 }
272             }
273         }
274         return count == required;
275     }
276 
277 
278     /**
279      * @dev Reward the winner
280      */
281     function rewardTheWinner(uint8 reward) private {
282         uint256 rewardValue = Math.percent(bank, reward);
283         require(rewardValue <= getBalance());
284         require(rewardValue <= bank);
285         bank = Math.sub(bank, rewardValue);
286         msg.sender.transfer(rewardValue);
287         emit WeHaveAWinner(msg.sender, rewardValue);
288     }
289 
290 
291     /**
292      * @dev Roll the dice for numbers
293      */
294     function rollOne(address referral, uint8 number)
295     external payable isValidBet(rewardOne) bankNotEmpty notFromContract {
296         require(isValidNumber(number));       
297         bets[msg.sender]++;
298 
299         splitTheBet(referral);
300 
301         uint8[5] memory numbers = [number,  0, 0, 0, 0];
302         uint8[5] memory randoms = [getRN(), 0, 0, 0, 0];
303 
304         emit UserBet(msg.sender, number, 0, 0, 0, 0);
305         emit DiceRoll(randoms[0], 0, 0, 0, 0);
306         if (isWinner(1, numbers, randoms)) {
307             rewardTheWinner(rewardOne);
308         } else {
309             emit Loser(msg.sender);
310         }
311     }
312 
313 
314     function rollTwo(address referral, uint8 number1, uint8 number2)
315     external payable isValidBet(rewardTwo) bankNotEmpty notFromContract {
316         require(isValidNumber(number1) && isValidNumber(number2));
317         bets[msg.sender]++;
318 
319         splitTheBet(referral);
320 
321         uint8[5] memory numbers = [number1, number2, 0, 0, 0];
322         uint8[5] memory randoms = [getRN(), getRN(), 0, 0, 0];
323 
324         emit UserBet(msg.sender, number1, number2, 0, 0, 0);
325         emit DiceRoll(randoms[0], randoms[1], 0, 0, 0);
326         if (isWinner(2, numbers, randoms)) {
327             rewardTheWinner(rewardTwo);
328         } else {
329             emit Loser(msg.sender);
330         }
331     }
332 
333 
334     function rollThree(address referral, uint8 number1, uint8 number2, uint8 number3)
335     external payable isValidBet(rewardThree) bankNotEmpty notFromContract {
336         require(isValidNumber(number1) && isValidNumber(number2) && isValidNumber(number3));
337         bets[msg.sender]++;
338 
339         splitTheBet(referral);
340 
341         uint8[5] memory numbers = [number1, number2, number3, 0, 0];
342         uint8[5] memory randoms = [getRN(), getRN(), getRN(), 0, 0];
343 
344         emit UserBet(msg.sender, number1, number2, number3, 0, 0);
345         emit DiceRoll(randoms[0], randoms[1], randoms[2], 0, 0);
346         if (isWinner(3, numbers, randoms)) {
347             rewardTheWinner(rewardThree);
348         } else {
349             emit Loser(msg.sender);
350         }
351     }
352 
353 
354     function rollFour(address referral, uint8 number1, uint8 number2, uint8 number3, uint8 number4)
355     external payable isValidBet(rewardFour) bankNotEmpty notFromContract {
356         require(isValidNumber(number1) && isValidNumber(number2) && isValidNumber(number3) && isValidNumber(number4));
357         bets[msg.sender]++;
358 
359         splitTheBet(referral);
360 
361         uint8[5] memory numbers = [number1, number2, number3, number4, 0];
362         uint8[5] memory randoms = [getRN(), getRN(), getRN(), getRN(), 0];
363 
364         emit UserBet(msg.sender, number1, number2, number3, number4, 0);
365         emit DiceRoll(randoms[0], randoms[1], randoms[2], randoms[3], 0);
366         if (isWinner(4, numbers, randoms)) {
367             rewardTheWinner(rewardFour);
368         } else {
369             emit Loser(msg.sender);
370         }
371     }
372 
373 
374     function rollFive(address referral, uint8 number1, uint8 number2, uint8 number3, uint8 number4, uint8 number5)
375     external payable isValidBet(jackPot) bankNotEmpty notFromContract {
376         require(isValidNumber(number1) && isValidNumber(number2) && isValidNumber(number3) && isValidNumber(number4) && isValidNumber(number5));
377         bets[msg.sender]++;
378 
379         splitTheBet(referral);
380 
381         uint8[5] memory numbers = [number1, number2, number3, number4, number5];
382         uint8[5] memory randoms = [getRN(), getRN(), getRN(), getRN(), getRN()];
383 
384         emit UserBet(msg.sender, number1, number2, number3, number4, number5);
385         emit DiceRoll(randoms[0], randoms[1], randoms[2], randoms[3], randoms[4]);
386         if (isWinner(5, numbers, randoms)) {
387             rewardTheWinner(jackPot);
388             emit OMGItIsJackPot(msg.sender);
389         } else {
390             emit Loser(msg.sender);
391         }
392     }
393 }