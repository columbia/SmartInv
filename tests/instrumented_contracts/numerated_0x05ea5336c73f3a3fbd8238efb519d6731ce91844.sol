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
59 
60     function random(uint256 nonce, int256 min, int256 max) internal view returns(int256) {
61         return int256(uint256(keccak256(nonce + block.number + block.timestamp + uint256(block.coinbase))) % uint256((max - min))) + min;
62     }
63 }
64 
65 
66 /**
67  * @title Ownable
68  * @dev Check contract ownable for some admin operations
69  */
70 contract Ownable {
71     address public owner;
72     
73     modifier onlyOwner()  { require(msg.sender == owner); _; }
74 
75     function Ownable() public {
76         owner = msg.sender;
77     }
78 
79     function updateContractOwner(address newOwner) external onlyOwner {
80         require(newOwner != address(0));
81         owner = newOwner;
82     }
83 }
84 
85 
86 /**
87  * @dev General contract
88  */
89 contract DiceForSlice is Ownable {
90     // Contract events
91     event UserBet       (address user, uint8 number1, uint8 number2, uint8 number3, uint8 number4, uint8 number5);
92     event DiceRoll      (uint8 number1, uint8 number2, uint8 number3, uint8 number4, uint8 number5);
93     event Loser         (address loser);
94     event WeHaveAWinner (address winner, uint256 amount);
95     event OMGItIsJackPot(address winner);
96 
97     // Address storage for referral system
98     mapping(address => uint256) private bets;
99 
100     // Sponsor data
101     address private sponsor;
102     uint256 private sponsorDiff  = 100000000000000000;
103     uint256 public sponsorValue  = 0;
104 
105     // Nonce for more random
106     uint256 private nonce        = 1;
107 
108     // Current balances of contract
109     // -bank  - available reward value
110     // -stock - available value for restore bank in emergency
111     uint256 public bank          = 0;
112     uint256 public stock         = 0;
113 
114     // Bet price
115     uint256 private betPrice     = 500000000000000000;
116 
117     // Current bet split rules (in percent)
118     uint8   private partBank     = 55;
119     uint8   private partOwner    = 20;
120     uint8   private partSponsor  = 12;
121     uint8   private partStock    = 10;
122     uint8   private partReferral = 3;
123 
124     // Current rewards (in percent from bank)
125     uint8   private rewardOne    = 10;
126     uint8   private rewardTwo    = 20;
127     uint8   private rewardThree  = 30;
128     uint8   private rewardFour   = 50;
129     uint8   private jackPot      = 100;
130 
131     // Current number min max
132     uint8   private minNumber    = 1;
133     uint8   private maxNumber    = 6;
134 
135     /**
136      * @dev Check is valid msg value
137      */
138     modifier isValidBet(uint8 reward) {
139         require(msg.value == Math.percent(betPrice, reward));
140         _;
141     }
142 
143     /**
144      * @dev Check bank not empty (empty is < betPrice eth)
145      */
146     modifier bankNotEmpty() {
147         require(bank >= Math.percent(betPrice, rewardTwo));
148         require(address(this).balance >= bank);
149         _;
150     }
151 
152 
153     /**
154      * @dev Special method for fill contract bank 
155      */
156     function fillTheBank() external payable {
157         require(msg.value >= sponsorDiff);
158         if (msg.value >= sponsorValue + sponsorDiff) {
159             sponsorValue = msg.value;
160             sponsor      = msg.sender;
161         }
162         bank = Math.add(bank, msg.value);
163     }
164 
165 
166     /**
167      * @dev Restore value from stock
168      */
169     function appendStock(uint256 amount) external onlyOwner {
170         require(amount > 0);
171         require(stock >= amount);
172         bank  = Math.add(bank,  amount);
173         stock = Math.sub(stock, amount);
174     }
175 
176 
177     /**
178      * @dev Get full contract balance
179      */
180     function getBalance() public view returns(uint256) {
181         return address(this).balance;
182     }
183 
184 
185     /**
186      * @dev Get random number
187      */
188     function getRN() internal returns(uint8) {
189         // 7 is max because method sub min from max (7-1 = 6). Look in Math::random implementation
190         nonce++;
191         return uint8(Math.random(nonce, minNumber, maxNumber + minNumber));
192     }
193 
194 
195     /**
196      * @dev Check is valid number
197      */
198     function isValidNumber(uint8 number) internal view returns(bool) {
199         return number >= minNumber && number <= maxNumber;
200     }
201 
202 
203     /**
204      * @dev Split user bet in some pieces:
205      * - 55% go to bank
206      * - 20% go to contract developer :)
207      * - 12% go to sponsor
208      * - 10% go to stock for future restores
209      * - 3%  go to referral (if exists, if not - go into stock)
210      */
211     function splitTheBet(address referral) internal {
212         uint256 _partBank     = Math.percent(msg.value, partBank);
213         uint256 _partOwner    = Math.percent(msg.value, partOwner);
214         uint256 _partStock    = Math.percent(msg.value, partStock);
215         uint256 _partSponsor  = Math.percent(msg.value, partSponsor);
216         uint256 _partReferral = Math.percent(msg.value, partReferral);
217         
218         bank  = Math.add(bank,  _partBank);
219         stock = Math.add(stock, _partStock);
220         owner.transfer(_partOwner);
221         sponsor.transfer(_partSponsor);
222 
223         if (referral != address(0) && referral != msg.sender && bets[referral] > 0) {
224             referral.transfer(_partReferral);
225         } else {
226             stock = Math.add(stock, _partReferral);
227         }
228     }
229 
230 
231     /**
232      * @dev Check the winner
233      */
234     function isWinner(uint8 required, uint8[5] numbers, uint8[5] randoms) internal pure returns(bool) {
235         uint8 count = 0;
236         for (uint8 i = 0; i < numbers.length; i++) {
237             if (numbers[i] == 0) continue;
238             for (uint8 j = 0; j < randoms.length; j++) {
239                 if (randoms[j] == 0) continue;
240                 if (randoms[j] == numbers[i]) {
241                     count++;
242                     delete randoms[j];
243                     break;
244                 }
245             }
246         }
247         return count == required;
248     }
249 
250 
251     /**
252      * @dev Reward the winner
253      */
254     function rewardTheWinner(uint8 reward) internal {
255         uint256 rewardValue = Math.percent(bank, reward);
256         require(rewardValue <= getBalance());
257         require(rewardValue <= bank);
258         bank = Math.sub(bank, rewardValue);
259         msg.sender.transfer(rewardValue);
260         emit WeHaveAWinner(msg.sender, rewardValue);
261     }
262 
263 
264     /**
265      * @dev Roll the dice for numbers
266      */
267     function rollOne(address referral, uint8 number)
268     external payable isValidBet(rewardOne) bankNotEmpty {
269         require(isValidNumber(number));       
270         bets[msg.sender]++;
271 
272         splitTheBet(referral);
273 
274         uint8[5] memory numbers = [number,  0, 0, 0, 0];
275         uint8[5] memory randoms = [getRN(), 0, 0, 0, 0];
276 
277         emit UserBet(msg.sender, number, 0, 0, 0, 0);
278         emit DiceRoll(randoms[0], 0, 0, 0, 0);
279         if (isWinner(1, numbers, randoms)) {
280             rewardTheWinner(rewardOne);
281         } else {
282             emit Loser(msg.sender);
283         }
284     }
285 
286 
287     function rollTwo(address referral, uint8 number1, uint8 number2)
288     external payable isValidBet(rewardTwo) bankNotEmpty {
289         require(isValidNumber(number1) && isValidNumber(number2));
290         bets[msg.sender]++;
291 
292         splitTheBet(referral);
293 
294         uint8[5] memory numbers = [number1, number2, 0, 0, 0];
295         uint8[5] memory randoms = [getRN(), getRN(), 0, 0, 0];
296 
297         emit UserBet(msg.sender, number1, number2, 0, 0, 0);
298         emit DiceRoll(randoms[0], randoms[1], 0, 0, 0);
299         if (isWinner(2, numbers, randoms)) {
300             rewardTheWinner(rewardTwo);
301         } else {
302             emit Loser(msg.sender);
303         }
304     }
305 
306 
307     function rollThree(address referral, uint8 number1, uint8 number2, uint8 number3)
308     external payable isValidBet(rewardThree) bankNotEmpty {
309         require(isValidNumber(number1) && isValidNumber(number2) && isValidNumber(number3));
310         bets[msg.sender]++;
311 
312         splitTheBet(referral);
313 
314         uint8[5] memory numbers = [number1, number2, number3, 0, 0];
315         uint8[5] memory randoms = [getRN(), getRN(), getRN(), 0, 0];
316 
317         emit UserBet(msg.sender, number1, number2, number3, 0, 0);
318         emit DiceRoll(randoms[0], randoms[1], randoms[2], 0, 0);
319         if (isWinner(3, numbers, randoms)) {
320             rewardTheWinner(rewardThree);
321         } else {
322             emit Loser(msg.sender);
323         }
324     }
325 
326 
327     function rollFour(address referral, uint8 number1, uint8 number2, uint8 number3, uint8 number4)
328     external payable isValidBet(rewardFour) bankNotEmpty {
329         require(isValidNumber(number1) && isValidNumber(number2) && isValidNumber(number3) && isValidNumber(number4));
330         bets[msg.sender]++;
331 
332         splitTheBet(referral);
333 
334         uint8[5] memory numbers = [number1, number2, number3, number4, 0];
335         uint8[5] memory randoms = [getRN(), getRN(), getRN(), getRN(), 0];
336 
337         emit UserBet(msg.sender, number1, number2, number3, number4, 0);
338         emit DiceRoll(randoms[0], randoms[1], randoms[2], randoms[3], 0);
339         if (isWinner(4, numbers, randoms)) {
340             rewardTheWinner(rewardFour);
341         } else {
342             emit Loser(msg.sender);
343         }
344     }
345 
346 
347     function rollFive(address referral, uint8 number1, uint8 number2, uint8 number3, uint8 number4, uint8 number5)
348     external payable isValidBet(jackPot) bankNotEmpty {
349         require(isValidNumber(number1) && isValidNumber(number2) && isValidNumber(number3) && isValidNumber(number4) && isValidNumber(number5));
350         bets[msg.sender]++;
351 
352         splitTheBet(referral);
353 
354         uint8[5] memory numbers = [number1, number2, number3, number4, number5];
355         uint8[5] memory randoms = [getRN(), getRN(), getRN(), getRN(), getRN()];
356 
357         emit UserBet(msg.sender, number1, number2, number3, number4, number5);
358         emit DiceRoll(randoms[0], randoms[1], randoms[2], randoms[3], randoms[4]);
359         if (isWinner(5, numbers, randoms)) {
360             rewardTheWinner(jackPot);
361             emit OMGItIsJackPot(msg.sender);
362         } else {
363             emit Loser(msg.sender);
364         }
365     }
366 }