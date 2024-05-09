1 pragma solidity ^0.4.16;
2 
3 contract EtherGuess {
4 
5     //Storage Variables
6     bool private running;  //Pause / Unpause the game
7     bytes32 public pauseReason;
8     uint public totalPayout; //Total Amount waiting Payout
9     int public numberOfGuesses;  //Total Guesses for this Game
10     uint public currentRound;
11     uint public totalPayedOut;
12     uint8 public adminPayout;   //The Percentage of Admin Payout
13     uint public lastFinish;
14     uint public minimumValue;
15     address public admin;
16     address public bot;
17     mapping (address => uint) public winners;
18     mapping (int => GuessInfo) public guesses;
19     mapping (uint8 => bool) public closedHour;
20 
21     //Constant Variables
22     uint constant NEGLECTGUESSTIMER = 5 days;
23     uint constant NEGLECTOWNERTIMER = 30 days;
24     uint constant ADMINPAYOUTDENOMINATOR = 100;
25 
26     function EtherGuess() public {
27        
28         minimumValue = 5 finney;
29         admin = msg.sender;
30         bot = msg.sender;
31         adminPayout = 10;
32         running = true;
33         closedHour[23] = true;
34         closedHour[0] = true;
35         currentRound = 1;
36         lastFinish = now;
37     }
38 
39     struct GuessInfo {
40         address owner;
41         uint value;
42         uint round;
43     }
44 
45     function setOpenCloseHour(uint8 hour, bool closed) onlyAdmin public {
46             closedHour[hour] = closed;
47     }
48 
49     function setAdminPayout(uint8 newAdminPayout) onlyAdmin public {
50         require(newAdminPayout <= 10);
51         adminPayout = newAdminPayout;
52     }
53 
54     function setBotAddress(address newBot) onlyAdmin public {
55         bot = newBot;
56     }
57     
58     event Withdraw(
59         address indexed _payto,
60         uint _value
61     );
62 
63     event Winner(
64         address indexed _payto,
65         uint indexed _round,
66         uint _value,
67         int _price,
68         string _priceInfo
69     );
70 
71     event NoWinner(
72         address indexed _admin,
73         uint indexed _round,
74         int _price,
75         string _priceInfo
76     );
77 
78     event Refund(
79         address indexed _payto,
80         uint indexed _round,
81         uint _value,
82         int _guess
83     );
84 
85     event Neglect(
86         address indexed _payto,
87         uint indexed _round,
88         uint _value,
89         int _guess
90     );
91 
92     event Guess(
93         address  indexed _from,
94         uint indexed _round,
95         int _numberOfGuesses,
96         int  _guess,
97         uint _value
98     );
99 
100     modifier onlyAdmin {
101         require(msg.sender == admin);
102         _;
103     }
104 
105     modifier adminOrBot {
106         require(msg.sender == bot || msg.sender == admin);
107         _;
108     }
109     
110     modifier isOpen {
111       require(!closedHour[uint8((now / 60 / 60) % 24)] && running);
112       _;
113     }
114 
115     function () public payable {
116           
117     }
118 
119 
120     function isGuessesOpen() public view returns (bool, bytes32) {
121         bool open = true;
122         bytes32 answer = "";
123         
124         if (closedHour[uint8((now / 60 / 60) % 24)]){
125             open = false;
126             answer = "Hours";
127         }
128         
129         if (!running) {
130             open = running;
131             answer = pauseReason;
132         }
133         return (open, answer);
134     }
135 
136 
137     function getWinnings() public {
138         require(winners[msg.sender]>0);
139         uint value = winners[msg.sender];
140         winners[msg.sender] = 0;
141         totalPayout = subToZero(totalPayout,value);
142         Withdraw(msg.sender,value);
143         msg.sender.transfer(value);
144     }
145 
146     function addGuess(int guess) public payable isOpen {
147         uint oldRound = guesses[guess].round;
148         uint oldValue = guesses[guess].value;
149         uint testValue;
150         if (oldRound < currentRound) {
151             testValue = minimumValue;
152         } else {
153             testValue = oldValue + minimumValue;
154         }
155         require(testValue == msg.value);
156         if (oldRound == currentRound) {
157            totalPayout += oldValue;
158            address oldOwner = guesses[guess].owner;
159            winners[oldOwner] += oldValue;
160            Refund(oldOwner, currentRound, oldValue, guess);
161            guesses[guess].owner = msg.sender;
162            guesses[guess].value = msg.value;
163         } else {
164             GuessInfo memory gi = GuessInfo(msg.sender, msg.value, currentRound);
165             guesses[guess] = gi;
166         }
167         numberOfGuesses++;
168         Guess(msg.sender, currentRound, numberOfGuesses, guess, msg.value);
169         
170     }
171     
172     function addGuessWithRefund(int guess) public payable isOpen {
173         uint oldRound = guesses[guess].round;
174         uint oldValue = guesses[guess].value;
175         uint testValue;
176         if (oldRound < currentRound) {
177             testValue = minimumValue;
178         } else {
179             testValue = oldValue + minimumValue;
180         }
181         require(winners[msg.sender] >= testValue);
182         if (oldRound == currentRound) {
183            totalPayout += oldValue;
184            address oldOwner = guesses[guess].owner;
185            winners[oldOwner] += oldValue;
186            Refund(oldOwner, currentRound, oldValue, guess);
187            guesses[guess].owner = msg.sender;
188            guesses[guess].value = testValue;
189            winners[msg.sender] -= testValue;
190         } else {
191             GuessInfo memory gi = GuessInfo(msg.sender, testValue, currentRound);
192             guesses[guess] = gi;
193             winners[msg.sender] -= testValue;
194         }
195         numberOfGuesses++;
196         Guess(msg.sender, currentRound, numberOfGuesses, guess, testValue);
197         
198     }
199     
200     function multiGuess(int[] multiGuesses) public payable isOpen {
201         require(multiGuesses.length > 1 && multiGuesses.length <= 20);
202         uint valueLeft = msg.value;
203         for (uint i = 0; i < multiGuesses.length; i++) {
204             if (valueLeft > 0) {
205                 uint newValue = minimumValue;
206                 if (guesses[multiGuesses[i]].round == currentRound) {
207                     uint oldValue = guesses[multiGuesses[i]].value;
208                     totalPayout += oldValue;
209                     address oldOwner = guesses[multiGuesses[i]].owner;
210                     winners[oldOwner] += oldValue;
211                     Refund(oldOwner, currentRound, oldValue, multiGuesses[i]);
212                     newValue = oldValue + minimumValue;
213                 }
214                 valueLeft = subToZero(valueLeft,newValue);
215                 GuessInfo memory gi = GuessInfo(msg.sender, newValue, currentRound);
216                 guesses[multiGuesses[i]] = gi;
217                 Guess(msg.sender, currentRound, ++numberOfGuesses, multiGuesses[i], newValue);
218             }
219 
220         }
221         if (valueLeft > 0) {
222             Refund(msg.sender, currentRound, valueLeft, -1);
223             winners[msg.sender] += valueLeft;
224         }
225 
226     }
227 
228     function pauseResumeContract(bool state, bytes32 reason) public onlyAdmin {
229         pauseReason = reason;
230         running = state;
231         lastFinish = now;
232     }
233 
234     function subToZero(uint a, uint b) pure internal returns (uint) {
235         if (b > a) {
236             return 0;
237         } else {
238         return a - b;
239         }
240     }
241     
242 
243     function finishUpRound(int price, string priceInfo) public adminOrBot {
244         
245         
246             if (guesses[price].round == currentRound && guesses[price].value > 0) {
247                 
248                 uint finalTotalPayout = this.balance - totalPayout;
249                 uint finalAdminPayout = (finalTotalPayout * adminPayout) / ADMINPAYOUTDENOMINATOR;
250                 uint finalPlayerPayout = finalTotalPayout - finalAdminPayout;
251                 
252                 Winner(guesses[price].owner, currentRound, finalPlayerPayout, price, priceInfo);  
253                 
254                 totalPayout += finalTotalPayout;
255                 totalPayedOut += finalPlayerPayout;
256                 winners[guesses[price].owner] += finalPlayerPayout;
257                 winners[admin] += finalAdminPayout;
258                 numberOfGuesses = 0;
259                 currentRound++;
260 
261             } else {
262                 NoWinner(msg.sender, currentRound, price, priceInfo);
263             }
264         
265 
266         lastFinish = now;
267 
268     }
269 
270     function neglectGuess(int guess) public {
271         require(lastFinish + NEGLECTGUESSTIMER < now);
272         require(guesses[guess].owner == msg.sender && guesses[guess].round == currentRound);
273         guesses[guess].round = 0;  
274         numberOfGuesses -= 1;
275         Neglect(msg.sender, currentRound, guesses[guess].value, guess);
276         msg.sender.transfer(guesses[guess].value);
277 
278     }
279 
280     function neglectOwner() public {
281         require(lastFinish + NEGLECTOWNERTIMER < now);
282         lastFinish = now;
283         admin = msg.sender;
284         winners[msg.sender] += winners[admin];
285         winners[admin] = 0;
286     }
287 
288 }