1 pragma solidity ^0.4.25;
2 
3 contract Brave3d {
4 
5     struct Stage {
6         uint8 cnt;
7         uint256 blocknumber;
8         bool isFinish;
9         uint8 deadIndex;
10         mapping(uint8 => address) playerMap;
11     }
12 
13 
14     HourglassInterface constant p3dContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
15 
16     address constant private  OFFICIAL = 0x97397C2129517f82031a28742247465BC75E1849;
17     address constant private  OFFICIAL_P3D = 0x97397C2129517f82031a28742247465BC75E1849;
18 
19     uint8 constant private MAX_PLAYERS = 3;
20     uint256 constant private PRICE = 0.1 ether;
21     uint256 constant private P3D_VALUE = 0.019 ether;
22     uint256 constant private REFEREE_VALUE = 0.007 ether;
23     uint256 constant private  WIN_VALUE = 0.13 ether;
24 
25     mapping(address => uint256) private _valueMap;
26     mapping(address => uint256) private _referredMap;
27     mapping(address => address) private _addressMap;
28     mapping(string => address)  private _nameAddressMap;
29     mapping(address => string)  private _addressNameMap;
30 
31     mapping(uint8 => mapping(uint256 => Stage)) private _stageMap;
32     mapping(uint8 => uint256) private _finishMap;
33     mapping(uint8 => uint256) private _currentMap;
34 
35     event BravePlayer(address indexed player, uint8 rate);
36     event BraveDeadPlayer(address indexed deadPlayer, uint8 rate);
37     event BraveWithdraw(address indexed player, uint256 indexed amount);
38     event BraveInvalidateStage(uint256 indexed stage, uint8 rate);
39 
40 
41     modifier hasEarnings()
42     {
43         require(_valueMap[msg.sender] > 0);
44         _;
45     }
46 
47     modifier isExistsOfNameAddressMap(string name){
48         require(_nameAddressMap[name]==0);
49         _;
50     }
51 
52     modifier isExistsOfAddressNameMap(){
53         require(bytes(_addressNameMap[msg.sender]).length<=0);
54         _;
55     }
56 
57     constructor()
58     public
59     {
60         _stageMap[1][0] = Stage(0, 0, false, 0);
61         _stageMap[5][0] = Stage(0, 0, false, 0);
62         _stageMap[10][0] = Stage(0, 0, false, 0);
63 
64         _currentMap[1] = 1;
65         _currentMap[5] = 1;
66         _currentMap[10] = 1;
67 
68         _finishMap[1] = 0;
69         _finishMap[5] = 0;
70         _finishMap[10] = 0;
71 
72         _nameAddressMap[""] = OFFICIAL;
73     }
74 
75     function() external payable {}
76 
77     function buyByAddress(address referee)
78     external
79     payable
80     {
81         uint8 rate = 1;
82         if (msg.value == PRICE) {
83             rate = 1;
84         } else if (msg.value == PRICE * 5) {
85             rate = 5;
86         } else if (msg.value == PRICE * 10) {
87             rate = 10;
88         } else {
89             require(false);
90         }
91 
92         resetStage(rate);
93 
94         buy(rate);
95 
96         overStage(rate);
97 
98         if (_addressMap[msg.sender] == 0) {
99             if (referee != 0x0000000000000000000000000000000000000000 && referee != msg.sender && _valueMap[referee] > 0) {
100                 _addressMap[msg.sender] = referee;
101             } else {
102                 _addressMap[msg.sender] = OFFICIAL;
103             }
104         }
105     }
106 
107     function setName(string name)
108     external
109     isExistsOfNameAddressMap(name)
110     isExistsOfAddressNameMap
111     {
112         _nameAddressMap[name] = msg.sender;
113         _addressNameMap[msg.sender] = name;
114 
115         overStage(1);
116         overStage(5);
117         overStage(10);
118     }
119 
120     function getName()
121     external
122     view
123     returns (string)
124     {
125         return _addressNameMap[msg.sender];
126     }
127 
128 
129     function buyByName(string name)
130     external
131     payable
132     {
133         uint8 rate = 1;
134         if (msg.value == PRICE) {
135             rate = 1;
136         } else if (msg.value == PRICE * 5) {
137             rate = 5;
138         } else if (msg.value == PRICE * 10) {
139             rate = 10;
140         } else {
141             require(false);
142         }
143 
144         resetStage(rate);
145 
146         buy(rate);
147 
148         overStage(rate);
149 
150         if (_addressMap[msg.sender] == 0) {
151 
152             if (_nameAddressMap[name] == 0) {
153 
154                 _addressMap[msg.sender] = OFFICIAL;
155 
156             } else {
157 
158                 address referee = _nameAddressMap[name];
159                 if (referee != 0x0000000000000000000000000000000000000000 && referee != msg.sender && _valueMap[referee] > 0) {
160 
161                     _addressMap[msg.sender] = referee;
162                 } else {
163 
164                     _addressMap[msg.sender] = OFFICIAL;
165                 }
166             }
167         }
168     }
169 
170 
171     function buyFromValue(uint8 rate)
172     external
173     {
174         require(rate == 1 || rate == 5 || rate == 10);
175         require(_valueMap[msg.sender] >= PRICE * rate);
176 
177         resetStage(rate);
178 
179         _valueMap[msg.sender] -= PRICE * rate;
180 
181         buy(rate);
182 
183         overStage(rate);
184     }
185 
186     function withdraw()
187     external
188     hasEarnings
189     {
190 
191         uint256 amount = _valueMap[msg.sender];
192         _valueMap[msg.sender] = 0;
193 
194         emit BraveWithdraw(msg.sender, amount);
195 
196         msg.sender.transfer(amount);
197 
198         overStage(1);
199         overStage(5);
200         overStage(10);
201     }
202 
203     function myEarnings()
204     external
205     view
206     hasEarnings
207     returns (uint256)
208     {
209         return _valueMap[msg.sender];
210     }
211 
212     function getEarnings(address adr)
213     external
214     view
215     returns (uint256)
216     {
217         return _valueMap[adr];
218     }
219 
220     function myReferee()
221     external
222     view
223     returns (uint256)
224     {
225         return _referredMap[msg.sender];
226     }
227 
228     function getReferee(address adr)
229     external
230     view
231     returns (uint256)
232     {
233         return _referredMap[adr];
234     }
235 
236     function getRefereeAddress(address adr)
237     external
238     view
239     returns (address)
240     {
241         return _addressMap[adr];
242     }
243 
244     function currentStageData(uint8 rate)
245     external
246     view
247     returns (uint256, uint256)
248     {
249         require(rate == 1 || rate == 5 || rate == 10);
250         uint256 curIndex = _currentMap[rate];
251         return (curIndex, _stageMap[rate][curIndex - 1].cnt);
252     }
253 
254     function getStageData(uint8 rate, uint256 index)
255     external
256     view
257     returns (address, address, address, bool, uint8)
258     {
259         require(rate == 1 || rate == 5 || rate == 10);
260         require(_finishMap[rate] >= index - 1);
261 
262         Stage storage finishStage = _stageMap[rate][index - 1];
263 
264         return (finishStage.playerMap[0], finishStage.playerMap[1], finishStage.playerMap[2], finishStage.isFinish, finishStage.deadIndex);
265     }
266 
267     function buy(uint8 rate)
268     private
269     {
270         Stage storage curStage = _stageMap[rate][_currentMap[rate] - 1];
271 
272         assert(curStage.cnt < MAX_PLAYERS);
273 
274         address player = msg.sender;
275 
276         curStage.playerMap[curStage.cnt] = player;
277         curStage.cnt++;
278 
279         emit BravePlayer(player, rate);
280 
281         if (curStage.cnt == MAX_PLAYERS) {
282             curStage.blocknumber = block.number;
283         }
284     }
285 
286     function overStage(uint8 rate)
287     private
288     {
289         uint256 curStageIndex = _currentMap[rate];
290         uint256 finishStageIndex = _finishMap[rate];
291 
292         assert(curStageIndex >= finishStageIndex);
293 
294         if (curStageIndex == finishStageIndex) {return;}
295 
296         Stage storage finishStage = _stageMap[rate][finishStageIndex];
297 
298         assert(!finishStage.isFinish);
299 
300         if (finishStage.cnt < MAX_PLAYERS) {return;}
301 
302         assert(finishStage.blocknumber != 0);
303 
304         if (block.number - 256 <= finishStage.blocknumber) {
305 
306             if (block.number == finishStage.blocknumber) {return;}
307 
308             uint8 deadIndex = uint8(blockhash(finishStage.blocknumber)) % MAX_PLAYERS;
309             address deadPlayer = finishStage.playerMap[deadIndex];
310             emit BraveDeadPlayer(deadPlayer, rate);
311             finishStage.deadIndex = deadIndex;
312 
313             for (uint8 i = 0; i < MAX_PLAYERS; i++) {
314                 address player = finishStage.playerMap[i];
315                 if (deadIndex != i) {
316                     _valueMap[player] += WIN_VALUE * rate;
317                 }
318 
319                 address referee = _addressMap[player];
320                 _valueMap[referee] += REFEREE_VALUE * rate;
321                 _referredMap[referee] += REFEREE_VALUE * rate;
322             }
323 
324 
325             uint256 dividends = p3dContract.myDividends(true);
326             if (dividends > 0) {
327                 p3dContract.withdraw();
328                 _valueMap[deadPlayer] += dividends;
329             }
330 
331             p3dContract.buy.value(P3D_VALUE * rate)(address(OFFICIAL_P3D));
332 
333         } else {
334 
335             for (uint8 j = 0; j < MAX_PLAYERS; j++) {
336                 _valueMap[finishStage.playerMap[j]] += PRICE * rate;
337             }
338 
339             emit BraveInvalidateStage(finishStageIndex, rate);
340         }
341 
342         finishStage.isFinish = true;
343         finishStageIndex++;
344         _finishMap[rate] = finishStageIndex;
345     }
346 
347     function resetStage(uint8 rate)
348     private
349     {
350         uint256 curStageIndex = _currentMap[rate];
351         if (_stageMap[rate][curStageIndex - 1].cnt == MAX_PLAYERS) {
352             _stageMap[rate][curStageIndex] = Stage(0, 0, false, 0);
353             curStageIndex++;
354             _currentMap[rate] = curStageIndex;
355         }
356     }
357 }
358 
359 interface HourglassInterface {
360     function buy(address _playerAddress) payable external returns (uint256);
361     function withdraw() external;
362     function myDividends(bool _includeReferralBonus) external view returns (uint256);
363 }