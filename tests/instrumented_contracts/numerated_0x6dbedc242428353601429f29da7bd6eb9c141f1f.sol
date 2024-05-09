1 pragma solidity 0.4.25;
2 
3 
4 /**
5 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
6 * 
7 * Web              - https://333eth.io
8 * 
9 * Twitter          - https://twitter.com/333eth_io
10 * 
11 * Telegram_channel - https://t.me/Ethereum333
12 * 
13 * EN  Telegram_chat: https://t.me/Ethereum333_chat_en
14 * 
15 * RU  Telegram_chat: https://t.me/Ethereum333_chat_ru
16 * 
17 * KOR Telegram_chat: https://t.me/Ethereum333_chat_kor
18 * 
19 * Email:             mailto:support(at sign)333eth.io
20 * 
21 * 
22 * 
23 * When the timer reaches zero then latest bettor takes the bank. Each bet restart a timer again.
24 * 
25 * Bet 0.01 ETH - if balance < 100 ETH
26 * Bet 0.02 ETH - if 100 ETH <= balance <= 200 ETH
27 * Bet 0.03 ETH - if 200 ETH < balance
28 * 
29 * The timer turns on for 5 minutes always. 
30 *    
31 * You need to send such bet`s amounts. If more was sent, then contract will return the difference to the wallet. For example, sending 0.03 ETH system will perceive as a contribution to 0.01 ETH and difference 0.02
32 * 
33 * The game does not have a fraudulent Ponzi scheme. No fraudulent referral programs.
34 * 
35 * In the contract of the game realized the refusal of ownership. It is impossible to stop the flow of bets. Bet from smart contracts is prohibited.
36 * 
37 * Eth distribution:
38 * 50% paid to the winner.
39 * 33% is transferred to the next level of the game with the same rules and so on.
40 * 17% commission.
41 * 
42 * RECOMMENDED GAS LIMIT: 150000
43 * 
44 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
45 */
46 
47 
48 
49 library Percent {
50   // Solidity automatically throws when dividing by 0
51   struct percent {
52     uint num;
53     uint den;
54   }
55   
56   // storage
57   function mul(percent storage p, uint a) internal view returns (uint) {
58     if (a == 0) {
59       return 0;
60     }
61     return a*p.num/p.den;
62   }
63 
64   function div(percent storage p, uint a) internal view returns (uint) {
65     return a/p.num*p.den;
66   }
67 
68   function sub(percent storage p, uint a) internal view returns (uint) {
69     uint b = mul(p, a);
70     if (b >= a) {
71       return 0;
72     }
73     return a - b;
74   }
75 
76   function add(percent storage p, uint a) internal view returns (uint) {
77     return a + mul(p, a);
78   }
79 
80   function toMemory(percent storage p) internal view returns (Percent.percent memory) {
81     return Percent.percent(p.num, p.den);
82   }
83 
84   // memory 
85   function mmul(percent memory p, uint a) internal pure returns (uint) {
86     if (a == 0) {
87       return 0;
88     }
89     return a*p.num/p.den;
90   }
91 
92   function mdiv(percent memory p, uint a) internal pure returns (uint) {
93     return a/p.num*p.den;
94   }
95 
96   function msub(percent memory p, uint a) internal pure returns (uint) {
97     uint b = mmul(p, a);
98     if (b >= a) {
99       return 0;
100     }
101     return a - b;
102   }
103 
104   function madd(percent memory p, uint a) internal pure returns (uint) {
105     return a + mmul(p, a);
106   }
107 }
108 
109 
110 contract Accessibility {
111   enum AccessRank { None, PayIn, Manager, Full }
112   mapping(address => AccessRank) public admins;
113   modifier onlyAdmin(AccessRank  r) {
114     require(
115       admins[msg.sender] == r || admins[msg.sender] == AccessRank.Full,
116       "access denied"
117     );
118     _;
119   }
120   event LogProvideAccess(address indexed whom, AccessRank rank, uint when);
121 
122   constructor() public {
123     admins[msg.sender] = AccessRank.Full;
124     emit LogProvideAccess(msg.sender, AccessRank.Full, now);
125   }
126 
127   function provideAccess(address addr, AccessRank rank) public onlyAdmin(AccessRank.Manager) {
128     require(rank <= AccessRank.Manager, "cannot to give full access rank");
129     if (admins[addr] != rank) {
130       admins[addr] = rank;
131       emit LogProvideAccess(addr, rank, now);
132     }
133   }
134 }
135 
136 /**
137  * @title SafeMath
138  * @dev Math operations with safety checks that revert on error
139  */
140 library SafeMath {
141 
142   /**
143   * @dev Multiplies two numbers, reverts on overflow.
144   */
145   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
146     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
147     // benefit is lost if 'b' is also tested.
148     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
149     if (_a == 0) {
150       return 0;
151     }
152 
153     uint256 c = _a * _b;
154     require(c / _a == _b);
155 
156     return c;
157   }
158 
159   /**
160   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
161   */
162   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
163     require(_b > 0); // Solidity only automatically asserts when dividing by 0
164     uint256 c = _a / _b;
165     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
166 
167     return c;
168   }
169 
170   /**
171   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
172   */
173   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
174     require(_b <= _a);
175     uint256 c = _a - _b;
176 
177     return c;
178   }
179 
180   /**
181   * @dev Adds two numbers, reverts on overflow.
182   */
183   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
184     uint256 c = _a + _b;
185     require(c >= _a);
186 
187     return c;
188   }
189 
190   /**
191   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
192   * reverts when dividing by zero.
193   */
194   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
195     require(b != 0);
196     return a % b;
197   }
198 }
199 
200 
201 
202 library Timer {
203   struct timer {
204     uint startup;
205     uint duration;
206   }
207   function start(timer storage t, uint duration) internal {
208     t.startup = now;
209     t.duration = duration;
210   }
211 
212   function timeLeft(timer storage t) internal view returns (uint) {
213     if (now >= t.startup + t.duration) {
214       return 0;
215     }
216     return t.startup + t.duration - now;
217   }
218 }
219 
220 
221 
222 
223 contract LastHero is Accessibility {
224   using Percent for Percent.percent;
225   using Timer for Timer.timer;
226   
227   Percent.percent public bankPercent = Percent.percent(50, 100);
228   Percent.percent public nextLevelPercent = Percent.percent(33, 100);
229   Percent.percent public adminsPercent = Percent.percent(17, 100);
230 
231   bool public isActive;
232   uint public nextLevelBankAmount;
233   uint private m_bankAmount;
234   uint public jackpot;
235   uint public level;
236   uint public constant betDuration = 5 minutes;
237   address public adminsAddress;
238   address public bettor;
239   Timer.timer public timer;
240 
241   modifier notFromContract() {
242     require(msg.sender == tx.origin, "only externally accounts");
243     _;
244 
245     // we can use 'transfer' for all bettors with it - no thx
246   }
247 
248   event LogSendExcessOfEther(address indexed addr, uint excess, uint when);
249   event LogNewWinner(address indexed addr, uint indexed level, uint amount, uint when);
250   event LogNewLevel(uint indexed level, uint bankAmount, uint when);
251   event LogNewBet(address indexed addr, uint indexed amount, uint duration, uint indexed level, uint when);
252 
253 
254   constructor() public {
255     adminsAddress = msg.sender;
256     timer.duration = uint(-1); // 2^256 - 1
257     nextLevel();
258   }
259 
260   function() external payable {
261     if (admins[msg.sender] == AccessRank.PayIn) {
262       if (level <= 3) {
263         increaseJackpot();
264       } else {
265         increaseBank();
266       }
267       return ;
268     }
269 
270     bet();
271   }
272 
273   function timeLeft() external view returns(uint duration) {
274     duration = timer.timeLeft();
275   }
276 
277   function setAdminsAddress(address addr) external onlyAdmin(AccessRank.Full) {
278     require(addr != address(0), "require not zero address");
279     adminsAddress = addr;
280   }
281 
282   function activate() external onlyAdmin(AccessRank.Full) {
283     isActive = true;
284   }
285 
286   function betAmountAtNow() public view returns(uint amount) {
287     uint balance = address(this).balance;
288 
289     // (1) 0.01 ETH - if balance < 100 ETH
290     // (2) 0.02 ETH - if 100 ETH <= balance <= 200 ETH
291     // (3) 0.03 ETH - if 200 ETH < balance
292 
293     if (balance < 100 ether) {
294       amount = 0.01 ether;
295     } else if (100 ether <= balance && balance <= 200 ether) {
296       amount = 0.02 ether;
297     } else {
298       amount = 0.03 ether;
299     }
300   }
301   
302   function bankAmount() public view returns(uint) {
303     if (level <= 3) {
304       return jackpot;
305     }
306     return m_bankAmount;
307   }
308 
309   function bet() public payable notFromContract {
310     require(isActive, "game is not active");
311 
312     if (timer.timeLeft() == 0) {
313       uint win = bankAmount();
314       if (bettor.send(win)) {
315         emit LogNewWinner(bettor, level, win, now);
316       }
317 
318       if (level > 3) {
319         m_bankAmount = nextLevelBankAmount;
320         nextLevelBankAmount = 0;
321       }
322 
323       nextLevel();
324     }
325 
326     uint betAmount = betAmountAtNow();
327     require(msg.value >= betAmount, "too low msg value");
328     timer.start(betDuration);
329     bettor = msg.sender;
330 
331     uint excess = msg.value - betAmount;
332     if (excess > 0) {
333       if (bettor.send(excess)) {
334         emit LogSendExcessOfEther(bettor, excess, now);
335       }
336     }
337  
338     nextLevelBankAmount += nextLevelPercent.mul(betAmount);
339     m_bankAmount += bankPercent.mul(betAmount);
340     adminsAddress.send(adminsPercent.mul(betAmount));
341 
342     emit LogNewBet(bettor, betAmount, betDuration, level, now);
343   }
344 
345   function increaseJackpot() public payable onlyAdmin(AccessRank.PayIn) {
346     require(level <= 3, "jackpots only on first three levels");
347     jackpot += msg.value / (4 - level); // add for remained levels
348   }
349 
350   function increaseBank() public payable onlyAdmin(AccessRank.PayIn) {
351     require(level > 3, "bank amount only above three level");
352     m_bankAmount += msg.value;
353     if (jackpot > 0) {
354       m_bankAmount += jackpot;
355       jackpot = 0;
356     }
357   }
358 
359   function nextLevel() private {
360     level++;
361     emit LogNewLevel(level, m_bankAmount, now);
362   }
363 }