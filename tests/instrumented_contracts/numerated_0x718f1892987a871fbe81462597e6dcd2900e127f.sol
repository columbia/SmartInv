1 pragma solidity ^0.4.24;
2 
3 contract DiscountToken { mapping (address => uint256) public balanceOf; }
4 
5 contract TwoCoinsOneMoonGame {
6     struct Bettor {
7         address account;
8         uint256 amount;
9         uint256 amountEth;
10     }
11 
12     struct Event {
13         uint256 winner; //0 - blue; 1 - red
14         uint256 newMoonLevel;
15         uint256 block;
16         uint256 blueCap;
17         uint256 redCap;
18     }
19 
20     uint256 public lastLevelChangeBlock;
21     uint256 public lastEventId;
22     uint256 public lastActionBlock;
23     uint256 public moonLevel;
24 
25     uint256 public marketCapBlue;
26     uint256 public marketCapRed;
27 
28     uint256 public jackpotBlue;
29     uint256 public jackpotRed;
30     
31     uint256 public startBetBlue;
32     uint256 public endBetBlue;
33     uint256 public startBetRed;
34     uint256 public endBetRed;
35 
36     Bettor[] public bettorsBlue;
37     Bettor[] public bettorsRed;
38 
39     Event[] public history;
40 
41     mapping (address => uint) public balance;
42 
43     address private feeCollector;
44 
45     DiscountToken discountToken;
46 
47     string public publisherMessage;
48     address publisher;
49 
50     bool isPaused;
51 
52     constructor() public {
53         marketCapBlue = 0;
54         marketCapRed = 0;
55 
56         jackpotBlue = 0;
57         jackpotRed = 0;
58         
59         startBetBlue = 0;
60         startBetRed = 0;
61 
62         endBetBlue = 0;
63         endBetRed = 0;
64 
65         publisher = msg.sender;
66         feeCollector = 0xfD4e7B9F4F97330356F7d1b5DDB9843F2C3e9d87;
67         discountToken = DiscountToken(0x25a803EC5d9a14D41F1Af5274d3f2C77eec80CE9);
68         lastLevelChangeBlock = block.number;
69 
70         lastActionBlock = block.number;
71         moonLevel = 5 * (uint256(10) ** 17);
72         isPaused = false;
73     }
74 
75     function getBetAmountGNC(uint256 marketCap, uint256 tokenCount, uint256 betAmount) private view returns (uint256) {
76         require (msg.value >= 100 finney);
77 
78         uint256 betAmountGNC = 0;
79         if (marketCap < 1 * moonLevel / 100) {
80             betAmountGNC += 10 * betAmount;
81         }
82         else if (marketCap < 2 * moonLevel / 100) {
83             betAmountGNC += 8 * betAmount;
84         }
85         else if (marketCap < 5 * moonLevel / 100) {
86             betAmountGNC += 5 * betAmount;
87         }
88         else if (marketCap < 10 * moonLevel / 100) {
89             betAmountGNC += 4 * betAmount;
90         }
91         else if (marketCap < 20 * moonLevel / 100) {
92             betAmountGNC += 3 * betAmount;
93         }
94         else if (marketCap < 33 * moonLevel / 100) {
95             betAmountGNC += 2 * betAmount;
96         }
97         else {
98             betAmountGNC += betAmount;
99         }
100 
101         if (tokenCount != 0) {
102             if (tokenCount >= 2 && tokenCount <= 4) {
103                 betAmountGNC = betAmountGNC *  105 / 100;
104             }
105             if (tokenCount >= 5 && tokenCount <= 9) {
106                 betAmountGNC = betAmountGNC *  115 / 100;
107             }
108             if (tokenCount >= 10 && tokenCount <= 20) {
109                 betAmountGNC = betAmountGNC *  135 / 100;
110             }
111             if (tokenCount >= 21 && tokenCount <= 41) {
112                 betAmountGNC = betAmountGNC *  170 / 100;
113             }
114             if (tokenCount >= 42) {
115                 betAmountGNC = betAmountGNC *  200 / 100;
116             }
117         }
118         return betAmountGNC;
119     }
120 
121     function putMessage(string message) public {
122         if (msg.sender == publisher) {
123             publisherMessage = message;
124         }
125     }
126 
127     function togglePause(bool paused) public {
128         if (msg.sender == publisher) {
129             isPaused = paused;
130         }
131     }
132 
133     function getBetAmountETH(uint256 tokenCount) private returns (uint256) {
134         uint256 betAmount = msg.value;
135         if (tokenCount == 0) {
136             uint256 comission = betAmount * 38 / 1000;
137             betAmount -= comission;
138             balance[feeCollector] += comission;
139         }
140         return betAmount;
141     }
142 
143     function betBlueCoin(uint256 actionBlock) public payable {
144         require (!isPaused || marketCapBlue > 0 || actionBlock == lastActionBlock);
145 
146         uint256 tokenCount = discountToken.balanceOf(msg.sender);
147         uint256 betAmountETH = getBetAmountETH(tokenCount);
148         uint256 betAmountGNC = getBetAmountGNC(marketCapBlue, tokenCount, betAmountETH);
149 
150         jackpotBlue += betAmountETH;
151         marketCapBlue += betAmountGNC;
152         bettorsBlue.push(Bettor({account:msg.sender, amount:betAmountGNC, amountEth:betAmountETH}));
153         endBetBlue = bettorsBlue.length;
154         lastActionBlock = block.number;
155 
156         checkMoon();
157     }
158 
159     function betRedCoin(uint256 actionBlock) public payable {
160         require (!isPaused || marketCapRed > 0 || actionBlock == lastActionBlock);
161 
162         uint256 tokenCount = discountToken.balanceOf(msg.sender);
163         uint256 betAmountETH = getBetAmountETH(tokenCount);
164         uint256 betAmountGNC = getBetAmountGNC(marketCapBlue, tokenCount, betAmountETH);
165 
166         jackpotRed += betAmountETH;
167         marketCapRed += betAmountGNC;
168         bettorsRed.push(Bettor({account:msg.sender, amount:betAmountGNC, amountEth: betAmountETH}));
169         endBetRed = bettorsRed.length;
170         lastActionBlock = block.number;
171 
172         checkMoon();
173     }
174 
175     function withdraw() public {
176         if (balance[feeCollector] != 0) {
177             uint256 fee = balance[feeCollector];
178             balance[feeCollector] = 0;
179             feeCollector.call.value(fee)();
180         }
181 
182         uint256 amount = balance[msg.sender];
183         balance[msg.sender] = 0;
184         msg.sender.transfer(amount);
185     }
186 
187     function depositBalance(uint256 winner) private {
188         uint256 i;
189         if (winner == 0) {
190             for (i = startBetBlue; i < bettorsBlue.length; i++) {
191                 balance[bettorsBlue[i].account] += bettorsBlue[i].amountEth;
192                 balance[bettorsBlue[i].account] += 10**18 * bettorsBlue[i].amount / marketCapBlue * jackpotRed / 10**18;
193             }
194         }
195         else {
196             for (i = startBetRed; i < bettorsRed.length; i++) {
197                 balance[bettorsRed[i].account] += bettorsRed[i].amountEth;
198                 balance[bettorsRed[i].account] += 10**18 * bettorsRed[i].amount / marketCapRed * jackpotBlue / 10**18;
199             }
200         }
201     }
202 
203     function addEvent(uint256 winner) private {
204         history.push(Event({winner: winner, newMoonLevel: moonLevel, block: block.number, blueCap: marketCapBlue, redCap: marketCapRed}));
205         lastEventId = history.length - 1;
206         lastLevelChangeBlock = block.number;
207     }
208 
209     function burstBubble() private {
210         uint256 winner;
211         if (marketCapBlue == marketCapRed) {
212             winner = block.number % 2;
213         }
214         else if (marketCapBlue > marketCapRed) {
215             winner = 0;
216         }
217         else {
218             winner = 1;
219         }
220         depositBalance(winner);
221         moonLevel = moonLevel * 2;
222         addEvent(winner);
223 
224         marketCapBlue = 0;
225         marketCapRed = 0;
226 
227         jackpotBlue = 0;
228         jackpotRed = 0;
229         
230         startBetBlue = bettorsBlue.length;
231         startBetRed = bettorsRed.length;
232     }
233 
234     function checkMoon() private {
235         if (block.number - lastLevelChangeBlock > 2880) {
236            moonLevel = moonLevel / 2;
237            addEvent(2);
238         }
239         if (marketCapBlue >= moonLevel || marketCapRed >= moonLevel) {
240             burstBubble();
241         }
242     }
243 }