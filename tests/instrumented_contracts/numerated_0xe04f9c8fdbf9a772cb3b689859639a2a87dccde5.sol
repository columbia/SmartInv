1 pragma solidity 0.4.25;
2 
3 /**
4 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
5 * 
6 * Web              - https://333eth.io
7 * 
8 * Twitter          - https://twitter.com/333eth_io
9 * 
10 * Telegram_channel - https://t.me/Ethereum333
11 * 
12 * EN  Telegram_chat: https://t.me/Ethereum333_chat_en
13 * 
14 * RU  Telegram_chat: https://t.me/Ethereum333_chat_ru
15 * 
16 * KOR Telegram_chat: https://t.me/Ethereum333_chat_kor
17 * 
18 * Email:             mailto:support(at sign)333eth.io
19 * 
20 * 
21 * 
22 * When the timer reaches zero then latest bettor takes the bank. Each bet restart a timer again.
23 * 
24 * Bet in 1 ETH - the timer turns on for 3 minutes 33 seconds.
25 * 
26 * Bet 0.1ETH - the timer turns on for 6 minutes 33 seconds.
27 * 
28 * Bet 0.01 ETH - the timer turns on for 9 minutes 33 seconds.
29 * You need to send such bet`s amounts. If more was sent, then contract will return the difference to the wallet. For example, sending 0.99 ETH system will perceive as a contribution to 0.1 ETH and difference 0.89
30 * 
31 * The game does not have a fraudulent Ponzi scheme. No fraudulent referral programs.
32 * 
33 * In the contract of the game realized the refusal of ownership. It is impossible to stop the flow of bets. Bet from smart contracts is prohibited.
34 * 
35 * Eth distribution:
36 * 50% paid to the winner.
37 * 40% is transferred to the next level of the game with the same rules and so on.
38 * 10% commission (7.5% of them to shareholders, 2.5% of the administration).
39 * 
40 * RECOMMENDED GAS LIMIT: 100000
41 * 
42 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
43 */
44 
45 
46 library Zero {
47   function requireNotZero(address addr) internal pure {
48     require(addr != address(0), "require not zero address");
49   }
50 
51   function requireNotZero(uint val) internal pure {
52     require(val != 0, "require not zero value");
53   }
54 
55   function notZero(address addr) internal pure returns(bool) {
56     return !(addr == address(0));
57   }
58 
59   function isZero(address addr) internal pure returns(bool) {
60     return addr == address(0);
61   }
62 
63   function isZero(uint a) internal pure returns(bool) {
64     return a == 0;
65   }
66 
67   function notZero(uint a) internal pure returns(bool) {
68     return a != 0;
69   }
70 }
71 
72 
73 library Percent {
74   // Solidity automatically throws when dividing by 0
75   struct percent {
76     uint num;
77     uint den;
78   }
79   
80   // storage
81   function mul(percent storage p, uint a) internal view returns (uint) {
82     if (a == 0) {
83       return 0;
84     }
85     return a*p.num/p.den;
86   }
87 
88   function div(percent storage p, uint a) internal view returns (uint) {
89     return a/p.num*p.den;
90   }
91 
92   function sub(percent storage p, uint a) internal view returns (uint) {
93     uint b = mul(p, a);
94     if (b >= a) {
95       return 0;
96     }
97     return a - b;
98   }
99 
100   function add(percent storage p, uint a) internal view returns (uint) {
101     return a + mul(p, a);
102   }
103 
104   function toMemory(percent storage p) internal view returns (Percent.percent memory) {
105     return Percent.percent(p.num, p.den);
106   }
107 
108   // memory 
109   function mmul(percent memory p, uint a) internal pure returns (uint) {
110     if (a == 0) {
111       return 0;
112     }
113     return a*p.num/p.den;
114   }
115 
116   function mdiv(percent memory p, uint a) internal pure returns (uint) {
117     return a/p.num*p.den;
118   }
119 
120   function msub(percent memory p, uint a) internal pure returns (uint) {
121     uint b = mmul(p, a);
122     if (b >= a) {
123       return 0;
124     }
125     return a - b;
126   }
127 
128   function madd(percent memory p, uint a) internal pure returns (uint) {
129     return a + mmul(p, a);
130   }
131 }
132 
133 library Address {
134   function toAddress(bytes source) internal pure returns(address addr) {
135     // solium-disable security/no-inline-assembly
136     assembly { addr := mload(add(source,0x14)) }
137     return addr;
138   }
139 
140   function isNotContract(address addr) internal view returns(bool) {
141     // solium-disable security/no-inline-assembly
142     uint length;
143     assembly { length := extcodesize(addr) }
144     return length == 0;
145   }
146 }
147 
148 
149 contract Accessibility {
150   address private owner;
151   modifier onlyOwner() {
152     require(msg.sender == owner, "access denied");
153     _;
154   }
155 
156   constructor() public {
157     owner = msg.sender;
158   }
159 
160   function disown() internal {
161     delete owner;
162   }
163 }
164 
165 /**
166  * @title SafeMath
167  * @dev Math operations with safety checks that revert on error
168  */
169 library SafeMath {
170 
171   /**
172   * @dev Multiplies two numbers, reverts on overflow.
173   */
174   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
175     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176     // benefit is lost if 'b' is also tested.
177     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
178     if (_a == 0) {
179       return 0;
180     }
181 
182     uint256 c = _a * _b;
183     require(c / _a == _b);
184 
185     return c;
186   }
187 
188   /**
189   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
190   */
191   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
192     require(_b > 0); // Solidity only automatically asserts when dividing by 0
193     uint256 c = _a / _b;
194     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
195 
196     return c;
197   }
198 
199   /**
200   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
201   */
202   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
203     require(_b <= _a);
204     uint256 c = _a - _b;
205 
206     return c;
207   }
208 
209   /**
210   * @dev Adds two numbers, reverts on overflow.
211   */
212   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
213     uint256 c = _a + _b;
214     require(c >= _a);
215 
216     return c;
217   }
218 
219   /**
220   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
221   * reverts when dividing by zero.
222   */
223   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
224     require(b != 0);
225     return a % b;
226   }
227 }
228 
229 
230 library Timer {
231   using SafeMath for uint;
232   struct timer {
233     uint duration;
234     uint startup;
235   }
236   function start(timer storage t, uint duration) internal {
237     t.startup = now;
238     t.duration = duration;
239   }
240 
241   function timeLeft(timer storage t) internal view returns (uint) {
242     if (now >= t.startup.add(t.duration)) {
243       return 0;
244     }
245     return (t.startup+t.duration).sub(now);
246   }
247 }
248 
249 
250 library Bet {
251   struct bet {
252     address bettor;
253     uint amount;
254     uint excess;
255     uint duration;
256   }
257 
258   function New(address bettor, uint value) internal pure returns(bet memory b ) {
259     
260     (uint[3] memory vals, uint[3] memory durs) = bets();
261     if (value >= vals[0]) {
262       b.amount = vals[0];
263       b.duration = durs[0];
264     } else if (vals[1] <= value && value < vals[0]) {
265       b.amount = vals[1];
266       b.duration = durs[1];
267     } else if (vals[2] <= value && value < vals[1]) {
268       b.amount = vals[2];
269       b.duration = durs[2];
270     } else {
271       return b;
272     }
273 
274     b.bettor = bettor;
275     b.excess = value - b.amount;
276   }
277 
278   function bets() internal pure returns(uint[3] memory vals, uint[3] memory durs) {
279     (vals[0], vals[1], vals[2]) = (1 ether, 0.1 ether, 0.01 ether); 
280     (durs[0], durs[1], durs[2]) = (3 minutes + 33 seconds, 6 minutes + 33 seconds, 9 minutes + 33 seconds);
281   }
282 
283   function transferExcess(bet memory b) internal {
284     b.bettor.transfer(b.excess);
285   }
286 }
287 
288 
289 
290 contract LastHero is Accessibility {
291   using Percent for Percent.percent;
292   using Timer for Timer.timer;
293   using Address for address;
294   using Bet for Bet.bet;
295   using Zero for *;
296   
297   Percent.percent private m_bankPercent = Percent.percent(50,100);
298   Percent.percent private m_nextLevelPercent = Percent.percent(40,100);
299   Percent.percent private m_adminsPercent = Percent.percent(10,100);
300   
301   uint public nextLevelBankAmount;
302   uint public bankAmount;
303   uint public level;
304   address public bettor;
305   address public adminsAddress;
306   Timer.timer private m_timer;
307 
308   modifier notFromContract() {
309     require(msg.sender.isNotContract(), "only externally accounts");
310     _;
311   }
312 
313   event LogSendExcessOfEther(address indexed addr, uint excess, uint when);
314   event LogNewWinner(address indexed addr, uint indexed level, uint amount, uint when);
315   event LogNewLevel(uint indexed level, uint bankAmount, uint when);
316   event LogNewBet(address indexed addr, uint indexed amount, uint duration, uint indexed level, uint when);
317   event LogDisown(uint when);
318 
319 
320   constructor() public {
321     level = 1;
322     emit LogNewLevel(level, address(this).balance, now);
323     adminsAddress = msg.sender;
324     m_timer.duration = uint(-1);
325   }
326 
327   function() public payable {
328     doBet();
329   }
330 
331   function doDisown() public onlyOwner {
332     disown();
333     emit LogDisown(now);
334   }
335 
336   function setAdminsAddress(address addr) public onlyOwner {
337     addr.requireNotZero();
338     adminsAddress = addr;
339   }
340 
341   function bankPercent() public view returns(uint numerator, uint denominator) {
342     (numerator, denominator) = (m_bankPercent.num, m_bankPercent.den);
343   }
344 
345   function nextLevelPercent() public view returns(uint numerator, uint denominator) {
346     (numerator, denominator) = (m_nextLevelPercent.num, m_nextLevelPercent.den);
347   }
348 
349   function adminsPercent() public view returns(uint numerator, uint denominator) {
350     (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
351   }
352 
353   function timeLeft() public view returns(uint duration) {
354     duration = m_timer.timeLeft();
355   }
356 
357   function timerInfo() public view returns(uint startup, uint duration) {
358     (startup, duration) = (m_timer.startup, m_timer.duration);
359   }
360 
361   function durationForBetAmount(uint betAmount) public view returns(uint duration) {
362     Bet.bet memory bet = Bet.New(msg.sender, betAmount);
363     duration = bet.duration;
364   }
365 
366   function availableBets() public view returns(uint[3] memory vals, uint[3] memory durs) {
367     (vals, durs) = Bet.bets();
368   }
369 
370   function doBet() public payable notFromContract {
371 
372     // send ether to bettor if needed
373     if (m_timer.timeLeft().isZero()) {
374       bettor.transfer(bankAmount);
375       emit LogNewWinner(bettor, level, bankAmount, now);
376 
377       bankAmount = nextLevelBankAmount;
378       nextLevelBankAmount = 0;
379       level++;
380       emit LogNewLevel(level, bankAmount, now);
381     }
382 
383     Bet.bet memory bet = Bet.New(msg.sender, msg.value);
384     bet.amount.requireNotZero();
385 
386     // send bet`s excess of ether if needed
387     if (bet.excess.notZero()) {
388       bet.transferExcess();
389       emit LogSendExcessOfEther(bet.bettor, bet.excess, now);
390     }
391 
392     // commision
393     nextLevelBankAmount += m_nextLevelPercent.mul(bet.amount);
394     bankAmount += m_bankPercent.mul(bet.amount);
395     adminsAddress.send(m_adminsPercent.mul(bet.amount));
396   
397     m_timer.start(bet.duration);
398     bettor = bet.bettor;
399 
400     emit LogNewBet(bet.bettor, bet.amount, bet.duration, level, now);
401   }
402 }