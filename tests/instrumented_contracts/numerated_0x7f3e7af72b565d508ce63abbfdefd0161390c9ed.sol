1 pragma solidity 0.4.15;
2 
3 // visit https://KickTheCoin.com
4 contract KickTheCoin {
5     address houseAddress;
6     address creator;
7     address owner;
8     address airDroper;
9 
10     address lastPlayerToKickTheCoin;
11 
12     uint kickerCount;
13 
14     address firstKicker;
15     address secondKicker;
16 
17     uint costToKickTheCoin;
18     uint numberOfBlocksPerKick;
19     uint targetBlockNumber;
20 
21     // set to true when game contract should stop new games from starting
22     bool isSundown;
23     // The blocknumber at which the current sundown grace period will end
24     uint sundownGraceTargetBlock;
25 
26     // The index is incremented on each new game (via initGame)
27     uint gameIndex;
28 
29     uint currentValue;
30 
31     mapping(address => uint) shares;
32 
33     event LatestKicker(uint curGameIndex, address kicker, uint curVal, uint targetBlockNum);
34     event FirstKicker(uint curGameIndex, address kicker, uint curVal);
35     event SecondKicker(uint curGameIndex, address kicker, uint curVal);
36     event Withdraw(address kicker, uint curVal);
37     event Winner(uint curGameIndex, address winner, uint curVal);
38 
39     modifier onlyBy(address _account)
40     {
41         require(msg.sender == _account);
42         _;
43     }
44 
45     modifier onlyByOwnerAndOnlyIfGameIsNotActive() {
46         require(msg.sender == owner && !isGameActive());
47         _;
48     }
49 
50     modifier onlyDuringNormalOperations() {
51         require(!isSundown);
52         _;
53     }
54 
55     function KickTheCoin()
56     public
57     payable
58     {
59         creator = msg.sender;
60         owner = creator;
61         houseAddress = creator;
62         airDroper = creator;
63         gameIndex = 0;
64         isSundown = false;
65         costToKickTheCoin = 0.17 ether;
66         numberOfBlocksPerKick = 5;
67         initGame();
68     }
69 
70     function()
71     public
72     payable
73     {
74         kickTheCoin();
75     }
76 
77     function kickTheCoin()
78     public
79     payable
80     onlyDuringNormalOperations()
81     {
82         require(msg.value == costToKickTheCoin);
83 
84         if (hasWinner()) {
85             storeWinnerShare();
86             initGame();
87         }
88 
89         kickerCount += 1;
90         processKick();
91         lastPlayerToKickTheCoin = msg.sender;
92         targetBlockNumber = block.number + numberOfBlocksPerKick;
93 
94         LatestKicker(gameIndex, msg.sender, currentValue, targetBlockNumber);
95     }
96 
97     function withdrawShares()
98     public
99     {
100         if (hasWinner()) {
101             storeWinnerShare();
102             initGame();
103         }
104         pullShares(msg.sender);
105     }
106 
107     function checkShares(address shareHolder)
108     public
109     constant
110     returns (uint)
111     {
112         return shares[shareHolder];
113     }
114 
115     function isGameActive()
116     public
117     constant
118     returns (bool)
119     {
120         return targetBlockNumber >= block.number;
121     }
122 
123     function hasWinner()
124     public
125     constant
126     returns (bool)
127     {
128         return currentValue > 0 && !isGameActive();
129     }
130 
131     function getCurrentValue()
132     public
133     constant
134     returns (uint)
135     {
136         if (isGameActive()) {
137             return currentValue;
138         } else {
139             return 0;
140         }
141     }
142 
143     function getLastKicker()
144     public
145     constant
146     returns (address)
147     {
148         if (isGameActive()) {
149             return lastPlayerToKickTheCoin;
150         } else {
151             return address(0);
152         }
153     }
154 
155     function pullShares(address shareHolder)
156     public
157     {
158         var share = shares[shareHolder];
159         if (share == 0) {
160             return;
161         }
162 
163         shares[shareHolder] = 0;
164         shareHolder.transfer(share);
165         Withdraw(shareHolder, share);
166     }
167 
168     function airDrop(address player)
169     public
170     payable
171     onlyBy(airDroper)
172     {
173         player.transfer(1);
174         if (msg.value > 1) {
175             msg.sender.transfer(msg.value - 1);
176         }
177     }
178 
179     function getTargetBlockNumber()
180     public
181     constant
182     returns (uint)
183     {
184         return targetBlockNumber;
185     }
186 
187     function getBlocksLeftInCurrentKick()
188     public
189     constant
190     returns (uint)
191     {
192         if (targetBlockNumber < block.number) {
193             return 0;
194         }
195         return targetBlockNumber - block.number;
196     }
197 
198     function getNumberOfBlocksPerKick()
199     public
200     constant
201     returns (uint)
202     {
203         return numberOfBlocksPerKick;
204     }
205 
206     function getCostToKick()
207     public
208     constant
209     returns (uint)
210     {
211         return costToKickTheCoin;
212     }
213 
214     function getCurrentBlockNumber()
215     public
216     constant
217     returns (uint)
218     {
219         return block.number;
220     }
221 
222     function getGameIndex()
223     public
224     constant
225     returns (uint)
226     {
227         return gameIndex;
228     }
229 
230     function changeOwner(address _newOwner)
231     public
232     onlyBy(owner)
233     {
234         owner = _newOwner;
235     }
236 
237     function changeHouseAddress(address _newHouseAddress)
238     public
239     onlyBy(owner)
240     {
241         houseAddress = _newHouseAddress;
242     }
243 
244     function changeAirDroper(address _airDroper)
245     public
246     onlyBy(owner)
247     {
248         airDroper = _airDroper;
249     }
250 
251     function changeGameParameters(uint _costToKickTheCoin, uint _numberOfBlocksPerKick)
252     public
253     onlyByOwnerAndOnlyIfGameIsNotActive()
254     {
255         costToKickTheCoin = _costToKickTheCoin;
256         numberOfBlocksPerKick = _numberOfBlocksPerKick;
257     }
258 
259     function sundown()
260     public
261     onlyByOwnerAndOnlyIfGameIsNotActive()
262     {
263         isSundown = true;
264         sundownGraceTargetBlock = block.number + 100000;
265     }
266 
267     function gameIsSundown()
268     public
269     constant
270     returns (bool)
271     {
272         return isSundown;
273     }
274 
275     function getSundownGraceTargetBlock()
276     public
277     constant
278     returns (uint)
279     {
280         return sundownGraceTargetBlock;
281     }
282 
283     function sunrise()
284     public
285     onlyByOwnerAndOnlyIfGameIsNotActive()
286     {
287         isSundown = false;
288         sundownGraceTargetBlock = 0;
289     }
290 
291     function clear()
292     public
293     {
294         if (isSundown &&
295         sundownGraceTargetBlock != 0 &&
296         sundownGraceTargetBlock < block.number) {
297             houseAddress.transfer(this.balance);
298         }
299     }
300 
301     function initGame()
302     private
303     {
304         gameIndex += 1;
305         targetBlockNumber = 0;
306         currentValue = 0;
307         kickerCount = 0;
308         firstKicker = address(0);
309         secondKicker = address(0);
310         lastPlayerToKickTheCoin = address(0);
311     }
312 
313     function storeWinnerShare()
314     private
315     {
316         var share = currentValue;
317         currentValue = 0;
318         shares[lastPlayerToKickTheCoin] += share;
319         if (share > 0) {
320             Winner(gameIndex, lastPlayerToKickTheCoin, share);
321         }
322     }
323 
324     function setShares()
325     private
326     {
327         // 1.0% commission to the house
328         shares[houseAddress] += (msg.value * 10)/1000;
329         // 2.5% commission to first kicker
330         shares[firstKicker] += (msg.value * 25)/1000;
331         // 1.5% commission to second kicker
332         shares[secondKicker] += (msg.value * 15)/1000;
333     }
334 
335     function processKick()
336     private
337     {
338         if (kickerCount == 1) {
339             currentValue = msg.value; // no commission on first kick
340             firstKicker = msg.sender;
341             FirstKicker(gameIndex, msg.sender, currentValue);
342         } else if (kickerCount == 2) {
343             currentValue += msg.value; // no commission on second kick
344             secondKicker = msg.sender;
345             SecondKicker(gameIndex, msg.sender, currentValue);
346         } else {
347             // 5% is used. 2.5% for first kicker, 1.5% for second, 1% for house
348             // leaving 95% for the winner
349             currentValue += (msg.value * 950)/1000;
350             setShares();
351         }
352     }
353 }