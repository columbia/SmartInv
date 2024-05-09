1 pragma solidity ^0.4.10;
2 
3 contract Slot {
4     uint constant BET_EXPIRATION_BLOCKS = 250;
5     uint constant MIN_BET = 0.01 ether;
6     uint constant MAX_BET = 300000 ether;
7     uint constant JACKPOT_PERCENT = 10;
8     uint constant MINIPOT_PERCENT = 10;
9 
10     uint[][] REELS = [
11                       [1,2,1,3,1,4,5,3,5,6],
12                       [1,2,1,3,1,4,1,3,1,6],
13                       [4,5,3,5,4,2,4,3,5,6]
14                       ];
15 
16     uint[] SYMBOL_MASK = [0, 1, 2, 4, 8, 16, 32];
17 
18     uint[][] PAYTABLE = [
19                          [0x010100, 2],
20                          [0x010120, 4],
21                          [0x010110, 4],
22                          [0x040402, 8],
23                          [0x040404, 8],
24                          [0x080802, 12],
25                          [0x080808, 12],
26                          [0x202002, 16],
27                          [0x020220, 16],
28                          [0x202020, 100],
29                          [0x020202, 9999]
30                          ];
31 
32     address owner;
33     address pendingOwner;
34     uint acceptPrice;
35 
36     uint public pendingBetAmount;
37     uint public jackpotPool;
38     uint public minipotPool;
39     uint public rollTimes;
40     uint public minipotTimes;
41 
42     struct Roll {
43         uint bet;
44         uint8 lines;
45         uint8 rollCount;
46         uint blocknum;
47         address next;
48     }
49 
50     struct PartnerShare {
51         address from;
52         uint share;
53     }
54 
55     event RollBegin(address indexed from, uint bet, uint8 lines, uint count);
56     event RollEnd(address indexed from, uint bet, uint8 lines, uint32 wheel, uint win, uint minipot);
57 
58     mapping(address => Roll[]) public rolls;
59     address public rollHead;
60     address public rollTail;
61 
62     PartnerShare[] public partners;
63 
64     constructor () public {
65         owner = msg.sender;
66     }
67 
68     function setOwner(address newOwner, uint price) public {
69         require (msg.sender == owner, "Only owner can set new owner.");
70         require (newOwner != owner, "No need to set again.");
71         pendingOwner = newOwner;
72         acceptPrice = price;
73     }
74 
75     function acceptOwner() payable public {
76         require (msg.sender == pendingOwner, "You are not pending owner.");
77         require (msg.value >= acceptPrice, "Amount not enough.");
78         owner.transfer(acceptPrice);
79         owner = pendingOwner;
80     }
81 
82     // enable direct transfer ether to contract
83     function() public payable {
84         require (msg.value > 200 finney, 'Min investment required.');
85         if (owner != msg.sender) {
86             partners.push(PartnerShare(msg.sender, msg.value / 1 finney));
87         }
88     }
89 
90     function kill() external {
91         require (msg.sender == owner, "Only owner can kill.");
92         require (pendingBetAmount == 0, "All spins need processed befor self-destruct.");
93         distribute();
94         selfdestruct(owner);
95     }
96 
97     function rollBlockNumber(address addr) public view returns (uint) {
98         if (rolls[addr].length > 0) {
99             return rolls[addr][0].blocknum;
100         } else {
101             return 0;
102         }
103     }
104 
105     function getPartnersCount() public view returns (uint) {
106         return partners.length;
107     }
108 
109     function jackpot() public view returns (uint) {
110         return jackpotPool / 2;
111     }
112 
113     function minipot() public view returns (uint) {
114         return minipotPool / 2;
115     }
116 
117     function roll(uint8 lines, uint8 count) public payable {
118         require (rolls[msg.sender].length == 0, "Can't roll mutiple times.");
119 
120         uint betValue = msg.value / count;
121         require (betValue >= MIN_BET && betValue <= MAX_BET, "Bet amount should be within range.");
122         rolls[msg.sender].push(Roll(betValue, lines, count, block.number, address(0)));
123 
124         // append to roll linked list
125         if (rollHead == address(0)) {
126             rollHead = msg.sender;
127         } else {
128             rolls[rollTail][0].next = msg.sender;
129         }
130         rollTail = msg.sender;
131 
132         pendingBetAmount += msg.value;
133         jackpotPool += msg.value * JACKPOT_PERCENT / 100;
134         minipotPool += msg.value * MINIPOT_PERCENT / 100;
135 
136         emit RollBegin(msg.sender, betValue, lines, count);
137     }
138 
139     function check(uint maxCount) public {
140         require (maxCount > 0, 'No reason for check nothing');
141 
142         uint i = 0;
143         address currentAddr = rollHead;
144 
145         while (i < maxCount && currentAddr != address(0)) {
146             Roll storage rollReq = rolls[currentAddr][0];
147 
148             if (rollReq.blocknum >= block.number) {
149                 return;
150             }
151 
152             checkRoll(currentAddr, rollReq);
153 
154             rollHead = rollReq.next;
155             if (currentAddr == rollTail) {
156                 rollTail = address(0);
157             }
158 
159             delete rolls[currentAddr];
160 
161             currentAddr = rollHead;
162             i++;
163         }
164     }
165 
166     function checkRoll(address addr, Roll storage rollReq) private {
167         uint totalWin = 0;
168 
169         if (block.number <= rollReq.blocknum + BET_EXPIRATION_BLOCKS) {
170             for (uint x = 0; x < rollReq.rollCount; x++) {
171                 totalWin += doRoll(addr, rollReq.bet, rollReq.lines, rollReq.blocknum, pendingBetAmount + rollTimes + x);
172             }
173         } else {
174             totalWin = rollReq.bet * rollReq.rollCount - 2300;
175         }
176 
177         pendingBetAmount -= rollReq.bet * rollReq.rollCount;
178 
179         if (totalWin > 0) {
180             if (address(this).balance > totalWin + 2300) {
181                 addr.transfer(totalWin);
182             } else {
183                 partners.push(PartnerShare(addr, totalWin / 1 finney));
184             }
185         }
186     }
187 
188     function doRoll(address addr, uint bet, uint8 lines, uint blocknum, uint seed) private returns (uint) {
189         uint[3] memory stops;
190         uint winRate;
191         uint entropy;
192         (stops, winRate, entropy) = calcRoll(addr, blocknum, seed);
193 
194         uint wheel = stops[0]<<16 | stops[1]<<8 | stops[2];
195         uint win = bet * winRate;
196 
197         // Jackpot
198         if (winRate == 9999) {
199             win = jackpotPool / 2;
200             jackpotPool -= win;
201         }
202 
203 
204         rollTimes++;
205 
206         uint minipotWin = 0;
207         // Check minipot
208         if (0xffff / (entropy >> 32 & 0xffff) > (100 * (minipotTimes + 1)) - rollTimes) {
209             minipotTimes++;
210             minipotWin = minipotPool / 2;
211             minipotPool -= minipotWin;
212         }
213 
214         emit RollEnd(addr, bet, lines, uint32(wheel), win, minipotWin);
215 
216         return win + minipotWin;
217     }
218 
219     function calcRoll(address addr, uint blocknum, uint seed) public view returns (uint[3] memory stops, uint winValue, uint entropy) {
220         require (block.number > blocknum, "Can't check in the same block or before.");
221         require (block.number <= blocknum + BET_EXPIRATION_BLOCKS, "Can't check for too old block.");
222         entropy = uint(keccak256(abi.encodePacked(addr, blockhash(blocknum), seed)));
223         stops = [REELS[0][entropy % REELS[0].length],
224                  REELS[1][(entropy >> 8) % REELS[1].length],
225                  REELS[2][(entropy >> 16) % REELS[2].length]];
226         winValue = calcPayout(stops[0], stops[1], stops[2]);
227     }
228 
229     function calcPayout(uint p1, uint p2, uint p3) public view returns (uint) {
230         uint line = SYMBOL_MASK[p1] << 16 | SYMBOL_MASK[p2] << 8 | SYMBOL_MASK[p3];
231         uint pay = 0;
232 
233         for (uint i = 0; i < PAYTABLE.length; i++) {
234             if (PAYTABLE[i][0] == line & PAYTABLE[i][0]) {
235                 pay = PAYTABLE[i][1];
236             }
237         }
238 
239         return pay;
240     }
241 
242     function getBonus() public view returns (uint) {
243         return address(this).balance - pendingBetAmount - jackpotPool - minipotPool;
244     }
245 
246     function distribute() public returns (uint result) {
247         bool isPartner = (owner == msg.sender);
248         uint totalShare = 0;
249 
250         for (uint i = 0; i < partners.length; i++) {
251             if (partners[i].from == msg.sender) {
252                 isPartner = true;
253             }
254 
255             totalShare += partners[i].share;
256         }
257 
258         require(isPartner, 'Only partner can distrubute bonus.');
259 
260         uint bonus = getBonus();
261 
262         if (totalShare > 0) {
263             uint price = ((bonus / 10) * 6) / totalShare;
264 
265             if (price > 0) {
266                 for (uint j = 0; j < partners.length; j++) {
267                     uint share = partners[j].share * price;
268                     partners[j].from.transfer(share);
269                     if (partners[j].from == msg.sender) {
270                         result += share;
271                     }
272                 }
273             }
274 
275             if (price > 2 * 1 finney) {
276                 delete partners;
277             }
278         }
279 
280         uint ownerShare = (bonus / 10) * 4;
281         owner.transfer(ownerShare);
282         if (owner == msg.sender) {
283             result += ownerShare;
284         }
285     }
286 }