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
36     event BraveDeadPlayer(address indexed deadPlayer,uint256 numberOfStage,uint8 indexed deadIndex, uint8 rate);
37     event BraveWithdraw(address indexed player, uint256 indexed amount);
38     event BraveInvalidateStage(uint256 indexed stage, uint8 rate);
39     event BraveReferrer(address indexed referrer,address indexed referrered,uint8 indexed rate);
40 
41 
42     modifier hasEarnings()
43     {
44         require(_valueMap[msg.sender] > 0);
45         _;
46     }
47 
48     modifier isExistsOfNameAddressMap(string name){
49         require(_nameAddressMap[name]==0);
50         _;
51     }
52 
53     modifier isExistsOfAddressNameMap(){
54         require(bytes(_addressNameMap[msg.sender]).length<=0);
55         _;
56     }
57 
58     constructor()
59     public
60     {
61         _stageMap[1][0] = Stage(0, 0, false, 0);
62         _stageMap[5][0] = Stage(0, 0, false, 0);
63         _stageMap[10][0] = Stage(0, 0, false, 0);
64 
65         _currentMap[1] = 1;
66         _currentMap[5] = 1;
67         _currentMap[10] = 1;
68 
69         _finishMap[1] = 0;
70         _finishMap[5] = 0;
71         _finishMap[10] = 0;
72 
73         _nameAddressMap[""] = OFFICIAL;
74     }
75 
76     function() external payable {}
77 
78     function buyByAddress(address referee)
79     external
80     payable
81     {
82         uint8 rate = 1;
83         if (msg.value == PRICE) {
84             rate = 1;
85         } else if (msg.value == PRICE * 5) {
86             rate = 5;
87         } else if (msg.value == PRICE * 10) {
88             rate = 10;
89         } else {
90             require(false);
91         }
92 
93         resetStage(rate);
94 
95         buy(rate);
96 
97         overStage(rate);
98 
99         if (_addressMap[msg.sender] == 0) {
100             if (referee != 0x0000000000000000000000000000000000000000 && referee != msg.sender && _valueMap[referee] >= 0) {
101                 _addressMap[msg.sender] = referee;
102             } else {
103                 _addressMap[msg.sender] = OFFICIAL;
104             }
105         }
106         
107          emit BraveReferrer(_addressMap[msg.sender],msg.sender,rate);
108     }
109 
110     function setName(string name)
111     external
112     isExistsOfNameAddressMap(name)
113     isExistsOfAddressNameMap
114     {
115         _nameAddressMap[name] = msg.sender;
116         _addressNameMap[msg.sender] = name;
117 
118         overStage(1);
119         overStage(5);
120         overStage(10);
121     }
122 
123     function getName()
124     external
125     view
126     returns (string)
127     {
128         return _addressNameMap[msg.sender];
129     }
130 
131 
132     function buyByName(string name)
133     external
134     payable
135     {
136         uint8 rate = 1;
137         if (msg.value == PRICE) {
138             rate = 1;
139         } else if (msg.value == PRICE * 5) {
140             rate = 5;
141         } else if (msg.value == PRICE * 10) {
142             rate = 10;
143         } else {
144             require(false);
145         }
146 
147         resetStage(rate);
148 
149         buy(rate);
150 
151         overStage(rate);
152 
153         if (_addressMap[msg.sender] == 0) {
154 
155             if (_nameAddressMap[name] == 0) {
156 
157                 _addressMap[msg.sender] = OFFICIAL;
158 
159             } else {
160 
161                 address referee = _nameAddressMap[name];
162                 if (referee != 0x0000000000000000000000000000000000000000 && referee != msg.sender && _valueMap[referee] >= 0) {
163 
164                     _addressMap[msg.sender] = referee;
165                 } else {
166 
167                     _addressMap[msg.sender] = OFFICIAL;
168                 }
169             }
170         }
171         
172          emit BraveReferrer(_addressMap[msg.sender],msg.sender,rate);
173     }
174 
175 
176     function buyFromValue(uint8 rate)
177     external
178     {
179         require(rate == 1 || rate == 5 || rate == 10);
180         require(_valueMap[msg.sender] >= PRICE * rate);
181 
182         resetStage(rate);
183 
184         _valueMap[msg.sender] -= PRICE * rate;
185 
186         buy(rate);
187 
188         overStage(rate);
189         
190          emit BraveReferrer(_addressMap[msg.sender],msg.sender,rate);
191     }
192 
193     function withdraw()
194     external
195     hasEarnings
196     {
197 
198         uint256 amount = _valueMap[msg.sender];
199         _valueMap[msg.sender] = 0;
200 
201         emit BraveWithdraw(msg.sender, amount);
202 
203         msg.sender.transfer(amount);
204 
205         overStage(1);
206         overStage(5);
207         overStage(10);
208     }
209 
210     function forceOverStage()
211     external
212     {
213         overStage(1);
214         overStage(5);
215         overStage(10);
216     }
217 
218     function myEarnings()
219     external
220     view
221     hasEarnings
222     returns (uint256)
223     {
224         return _valueMap[msg.sender];
225     }
226 
227     function getEarnings(address adr)
228     external
229     view
230     returns (uint256)
231     {
232         return _valueMap[adr];
233     }
234 
235     function myReferee()
236     external
237     view
238     returns (uint256)
239     {
240         return _referredMap[msg.sender];
241     }
242 
243     function getReferee(address adr)
244     external
245     view
246     returns (uint256)
247     {
248         return _referredMap[adr];
249     }
250 
251     function getRefereeAddress(address adr)
252     external
253     view
254     returns (address)
255     {
256         return _addressMap[adr];
257     }
258 
259     function currentStageData(uint8 rate)
260     external
261     view
262     returns (uint256, uint256)
263     {
264         require(rate == 1 || rate == 5 || rate == 10);
265         uint256 curIndex = _currentMap[rate];
266         return (curIndex, _stageMap[rate][curIndex - 1].cnt);
267     }
268 
269     function getStageData(uint8 rate, uint256 index)
270     external
271     view
272     returns (address, address, address, bool, uint8)
273     {
274         require(rate == 1 || rate == 5 || rate == 10);
275         require(_finishMap[rate] >= index - 1);
276 
277         Stage storage finishStage = _stageMap[rate][index - 1];
278 
279         return (finishStage.playerMap[0], finishStage.playerMap[1], finishStage.playerMap[2], finishStage.isFinish, finishStage.deadIndex);
280     }
281 
282     function buy(uint8 rate)
283     private
284     {
285         Stage storage curStage = _stageMap[rate][_currentMap[rate] - 1];
286 
287         assert(curStage.cnt < MAX_PLAYERS);
288 
289         address player = msg.sender;
290 
291         curStage.playerMap[curStage.cnt] = player;
292         curStage.cnt++;
293 
294         emit BravePlayer(player, rate);
295 
296         if (curStage.cnt == MAX_PLAYERS) {
297             curStage.blocknumber = block.number;
298         }
299     }
300 
301     function overStage(uint8 rate)
302     private
303     {
304         uint256 curStageIndex = _currentMap[rate];
305         uint256 finishStageIndex = _finishMap[rate];
306 
307         assert(curStageIndex >= finishStageIndex);
308 
309         if (curStageIndex == finishStageIndex) {return;}
310 
311         Stage storage finishStage = _stageMap[rate][finishStageIndex];
312 
313         assert(!finishStage.isFinish);
314 
315         if (finishStage.cnt < MAX_PLAYERS) {return;}
316 
317         assert(finishStage.blocknumber != 0);
318 
319         if (block.number - 256 <= finishStage.blocknumber) {
320 
321             if (block.number == finishStage.blocknumber) {return;}
322 
323             uint8 deadIndex = uint8(blockhash(finishStage.blocknumber)) % MAX_PLAYERS;
324             address deadPlayer = finishStage.playerMap[deadIndex];
325             emit BraveDeadPlayer(deadPlayer,finishStageIndex,deadIndex, rate);
326             finishStage.deadIndex = deadIndex;
327 
328             for (uint8 i = 0; i < MAX_PLAYERS; i++) {
329                 address player = finishStage.playerMap[i];
330                 if (deadIndex != i) {
331                     _valueMap[player] += WIN_VALUE * rate;
332                 }
333 
334                 address referee = _addressMap[player];
335                 _valueMap[referee] += REFEREE_VALUE * rate;
336                 _referredMap[referee] += REFEREE_VALUE * rate;
337             }
338 
339 
340             uint256 dividends = p3dContract.myDividends(true);
341             if (dividends > 0) {
342                 p3dContract.withdraw();
343                 _valueMap[deadPlayer] += dividends;
344             }
345 
346             p3dContract.buy.value(P3D_VALUE * rate)(address(OFFICIAL_P3D));
347 
348         } else {
349 
350             for (uint8 j = 0; j < MAX_PLAYERS; j++) {
351                 _valueMap[finishStage.playerMap[j]] += PRICE * rate;
352             }
353 
354             emit BraveInvalidateStage(finishStageIndex, rate);
355         }
356 
357         finishStage.isFinish = true;
358         finishStageIndex++;
359         _finishMap[rate] = finishStageIndex;
360     }
361 
362     function resetStage(uint8 rate)
363     private 
364     {
365         uint256 curStageIndex = _currentMap[rate];
366         if (_stageMap[rate][curStageIndex - 1].cnt == MAX_PLAYERS) {
367             _stageMap[rate][curStageIndex] = Stage(0, 0, false, 0);
368             curStageIndex++;
369             _currentMap[rate] = curStageIndex;
370         }
371     }
372 }
373 
374 interface HourglassInterface {
375     function buy(address _playerAddress) payable external returns (uint256);
376     function withdraw() external;
377     function myDividends(bool _includeReferralBonus) external view returns (uint256);
378 }