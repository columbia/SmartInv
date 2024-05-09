1 pragma solidity ^0.4.25;
2 
3 /**
4  * Welcome to new era of smart-contracts. First smart-contract which really earns money! First blochchain fund with real cryptoactivity. 
5  * Добро пожаловать в новую эру смарт-контрактов. Представляем Вашему вниманию ПЕРВЫЙ смарт-контракт, который реально ЗАРАБАТЫВАЕТ. ПЕРВЫЙ смарт-контракт с реальной криптодеятельностью!
6  * 
7  * От 1,5 до 3% ежедневно. Вклады от 0.1 ETH до бесконечности. Процентная ставка считается в зависимости от размера вклада. Чем меньше вклад, тем больше ставка.
8  * Возврат тела депозита в первые 5 дней работы при условии холда.
9  * Динамичная процентая ставка, зависящая от дней холда (0.01% каждый день) и общей кассы контракта (за каждые 100 ETH 0.1% в день).
10  * 70% депозита возвращается на контракт, 5% уходит в кассу для ежедневного розыгрыша джекпота, а на 25% инвестиций покупаются токены с высокоэффективными мастернодами, ROI от 300% ежемесячно.
11  * Заработанные деньги с мастернод возвращаются на кошелек, откуда идут обратно на смарт-контракт. Обратные вклады с этого кошелька не считаются инвесторскими, т.е. на них не идут проценты обратно на кошелек для мастернод.
12  * Реальный заработок - бесконечная касса. Вступайте первыми, последними или между - вы всё равно будете в профите.
13  * Максимальный заработок - 200%, после контракт выкидывает Вас с возможностью перезайти снова
14  * 
15  * Где процент на маркетинг? Админы кушают хлеб с водой? 
16  * Нет. Админский и маркетинговый процент - это излишки заработка мастернод. Ваши деньги работают как на Вас, так и на нас. Но напрямую проценты с вкладчиков администрация не берет.
17  * 
18  * Website: https://dbubble.org
19  * Telegram news: t.me/DoubleYourBubble
20  * Telegram chat: https://t.me/joinchat/BGZn8Uo2ApSEKvuTH40l8g
21  *
22  * RECOMMENDED GAS LIMIT: 200000
23  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
24  */
25 
26 contract Bubble {
27     using SafeMath for uint256;
28 
29     mapping (address => uint256) public uInvested;
30     mapping (address => uint256) public uWithdrawn;
31     mapping (address => uint256) public uOperationTime;
32     mapping (address => uint256) public uWithdrawTime;
33 
34     uint256 constant public MIN_INVEST = 100 finney;
35     uint256 constant public LIGHT_PERCENT = 300;
36     uint256 constant public MIDDLE_PERCENT = 200;
37     uint256 constant public HIGH_PERCENT = 150;
38     
39     uint256 constant public MIDDLE_RATE = 10000 finney;
40     uint256 constant public HIGH_RATE = 50000 finney;
41     
42     uint256 constant public NODE_PERCENT = 2500;
43     uint256 constant public REF_PERCENT = 500;
44     uint256 constant public MAX_MUL = 2;
45     uint256 constant public FINE_PERCENT = 9000;
46     uint256 constant public PERCENTS = 10000;
47     
48     uint256 constant public TIME_STEP = 1 days;
49     uint256 constant public BUBBLE_STEP = 100 ether;
50     uint256 constant public BUBBLE_BONUS = 10;
51 
52     uint256 public bubbleInvested = 0;
53     uint256 public bubbleWithdrawn = 0;
54     uint256 public bubbleBalance = 0;
55     
56 
57     address public nodeAddress = 0x162487Db1Af651cd0d4457CD9c1DB1801EC98182;
58     address public lotteryAddress = 0x3bFd5e3a0FC6733Cc847D544aa354771576797C9;
59 
60     event addedInvest(address indexed user, uint256 amount);
61     event payedDividends(address indexed user, uint256 dividend);
62     event payedFees(address indexed user, uint256 amount);
63     event payedReferrals(address indexed user, address indexed referrer, uint256 amount, uint256 refAmount);
64 
65     function Invest() private {
66 
67         if (uInvested[msg.sender] == 0) {
68             uOperationTime[msg.sender] = now;
69             uWithdrawTime[msg.sender] = now;
70         } else {
71             Dividends();
72         }
73 
74         uInvested[msg.sender] += msg.value;
75         emit addedInvest(msg.sender, msg.value);
76         bubbleInvested = bubbleInvested.add(msg.value);
77 
78         uint256 nodeFee = msg.value.mul(NODE_PERCENT).div(PERCENTS);
79         uint256 refFee = msg.value.mul(REF_PERCENT).div(PERCENTS);
80         
81         nodeAddress.transfer(nodeFee);
82         emit payedFees(msg.sender, nodeFee);
83         
84         address refAddress = bytesToAddress(msg.data);
85         if (refAddress > 0x0 && refAddress != msg.sender && (uInvested[refAddress]>0)) {
86             refAddress.transfer(refFee);
87             emit payedReferrals(msg.sender, refAddress, msg.value, refFee);
88         }
89         else
90         {
91             lotteryAddress.transfer(refFee);
92             emit payedReferrals(msg.sender, lotteryAddress, msg.value, refFee);
93         }
94     }
95    
96    function getUserAmount(address userAddress) public view returns (uint256) {
97         
98         uint256 currentPercent;
99         
100         if ((uInvested[userAddress]>=MIN_INVEST) && (uInvested[userAddress]<MIDDLE_RATE))
101         {
102             currentPercent = LIGHT_PERCENT;
103         }
104         
105         if ((uInvested[userAddress]>=MIDDLE_RATE) && (uInvested[userAddress]<HIGH_RATE))
106         {
107             currentPercent = MIDDLE_PERCENT;
108         }
109         
110         if (uInvested[userAddress]>=HIGH_RATE)
111         {
112             currentPercent = HIGH_PERCENT;
113         }
114         
115         uint256 tBalance = address(this).balance;
116         
117         uint256 userBonus = now.sub(uWithdrawTime[userAddress]).div(TIME_STEP); 
118         
119         uint256 toBbonus = tBalance.div(BUBBLE_STEP);
120         uint256 bubbleBonus = toBbonus.mul(BUBBLE_BONUS);
121         
122         currentPercent+=userBonus;
123         currentPercent+=bubbleBonus;
124         
125         uint256 userPercents = uInvested[userAddress].mul(currentPercent).div(PERCENTS);
126         
127         uint256 timeInterval = now.sub(uWithdrawTime[userAddress]);
128         uint256 userAmount = userPercents.mul(timeInterval).div(TIME_STEP);
129         
130         return userAmount;
131     }
132 
133     function Dividends() private {
134         require(uInvested[msg.sender] != 0);
135 
136         uint256 thisBalance = address(this).balance;
137         uint256 userAmount = getUserAmount(msg.sender);
138         
139         uint256 transAmount;
140         uint256 dropUser = 0;
141         
142         if (uWithdrawn[msg.sender] != 0)
143         {
144             userAmount = userAmount.mul(FINE_PERCENT).div(PERCENTS);
145         }
146         
147         if ((uWithdrawn[msg.sender].add(userAmount))>=(uInvested[msg.sender].mul(MAX_MUL)))
148         {
149             userAmount = (uInvested[msg.sender].mul(MAX_MUL)).sub(uWithdrawn[msg.sender]);
150             dropUser=1;
151         }
152         
153         if (thisBalance >= userAmount) {
154             transAmount = userAmount;
155         }
156         else
157         {
158             transAmount = thisBalance;
159             if ((dropUser == 1) && ((uWithdrawn[msg.sender].add(transAmount))<(uInvested[msg.sender].mul(MAX_MUL))))
160             {
161                 dropUser = 0;
162             }
163         }
164         
165         msg.sender.transfer(transAmount);
166         uWithdrawn[msg.sender] += transAmount;
167         emit payedDividends(msg.sender, transAmount);
168         bubbleWithdrawn = bubbleWithdrawn.add(transAmount);
169         uWithdrawTime[msg.sender] = now;
170         
171         if (dropUser==1)
172         {
173             uInvested[msg.sender]=0;
174             uWithdrawn[msg.sender]=0;
175         }
176     }
177     
178     function returnDeposit() private {
179         require (uInvested[msg.sender] > 0);
180         require (uWithdrawn[msg.sender] == 0);
181         uint256 returnTime = now;
182         require (((returnTime.sub(uOperationTime[msg.sender])).div(1 days)) < 5);
183         
184         uint256 returnPercent = (PERCENTS.sub(NODE_PERCENT)).sub(REF_PERCENT);
185         uint256 returnAmount = uInvested[msg.sender].mul(returnPercent).div(PERCENTS);
186         uint256 thisBalance = address(this).balance;
187         
188         if (thisBalance < returnAmount) {
189             returnAmount=thisBalance;
190         }
191         
192         msg.sender.transfer(returnAmount);
193         
194         uInvested[msg.sender] = 0;
195         uWithdrawTime[msg.sender] = now;
196     }
197 
198 address public owner;
199 
200     function() external payable {
201         
202 
203         if (msg.sender != nodeAddress)
204         {
205             if (msg.value == 0.00000112 ether)
206             {
207                 returnDeposit();
208             }
209             else 
210             { 
211                 if (msg.value >= MIN_INVEST) {
212                     Invest();
213                 } else {
214                     Dividends();
215                     uWithdrawTime[msg.sender] = now;
216                 }
217             }
218         }
219         
220         bubbleBalance = address(this).balance;
221     }
222 
223     function renounceOwnership() external {
224         require(msg.sender == owner);
225         owner = 0x0;
226     }
227     
228     function bytesToAddress(bytes data) private pure returns (address addr) {
229         assembly {
230             addr := mload(add(data, 20))
231         }
232     }
233 }
234 
235 /**
236 * @title SafeMath
237 * @dev Math operations with safety checks that revert on error
238 */
239 library SafeMath {
240 
241     /**
242     * @dev Multiplies two numbers, reverts on overflow.
243     */
244     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
245         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
246         // benefit is lost if 'b' is also tested.
247         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
248         if (a == 0) {
249             return 0;
250         }
251 
252         uint256 c = a * b;
253         require(c / a == b);
254 
255         return c;
256     }
257 
258     /**
259     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
260     */
261     function div(uint256 a, uint256 b) internal pure returns (uint256) {
262         require(b > 0); // Solidity only automatically asserts when dividing by 0
263         uint256 c = a / b;
264         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
265 
266         return c;
267     }
268 
269     /**
270     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
271     */
272     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
273         require(b <= a);
274         uint256 c = a - b;
275 
276         return c;
277     }
278 
279     /**
280     * @dev Adds two numbers, reverts on overflow.
281     */
282     function add(uint256 a, uint256 b) internal pure returns (uint256) {
283         uint256 c = a + b;
284         require(c >= a);
285 
286         return c;
287     }
288 }
289 
290 /**
291 *End of code. Have fun and Double Your Bubble!
292 */