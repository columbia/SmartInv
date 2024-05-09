1 pragma solidity ^0.4.23;
2 
3 contract BasicAccessControl {
4     address public owner;
5     // address[] public moderators;
6     uint16 public totalModerators = 0;
7     mapping (address => bool) public moderators;
8     bool public isMaintaining = false;
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     modifier onlyModerators() {
20         require(msg.sender == owner || moderators[msg.sender] == true);
21         _;
22     }
23 
24     modifier isActive {
25         require(!isMaintaining);
26         _;
27     }
28 
29     function ChangeOwner(address _newOwner) onlyOwner public {
30         if (_newOwner != address(0)) {
31             owner = _newOwner;
32         }
33     }
34 
35 
36     function AddModerator(address _newModerator) onlyOwner public {
37         if (moderators[_newModerator] == false) {
38             moderators[_newModerator] = true;
39             totalModerators += 1;
40         }
41     }
42     
43     function RemoveModerator(address _oldModerator) onlyOwner public {
44         if (moderators[_oldModerator] == true) {
45             moderators[_oldModerator] = false;
46             totalModerators -= 1;
47         }
48     }
49 
50     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
51         isMaintaining = _isMaintaining;
52     }
53 }
54 
55 contract EtheremonAdventureSetting is BasicAccessControl {
56     struct RewardData {
57         uint monster_rate;
58         uint monster_id;
59         uint shard_rate;
60         uint shard_id;
61         uint level_rate;
62         uint exp_rate;
63         uint emont_rate;
64     }
65     mapping(uint => uint[]) public siteSet; // monster class -> site id
66     mapping(uint => uint) public monsterClassSiteSet;
67     mapping(uint => RewardData) public siteRewards; // site id => rewards (monster_rate, monster_id, shard_rate, shard_id, level_rate, exp_rate, emont_rate)
68     uint public levelItemClass = 200;
69     uint public expItemClass = 201;
70     uint[4] public levelRewards = [1, 1, 1, 2];
71     uint[11] public expRewards = [50, 50, 50, 50, 100, 100, 100, 100, 200, 200, 500];
72     uint[6] public emontRewards = [300000000, 300000000, 500000000, 500000000, 1000000000, 150000000];
73     
74     function setConfig(uint _levelItemClass, uint _expItemClass) onlyModerators public {
75         levelItemClass = _levelItemClass;
76         expItemClass = _expItemClass;
77     }
78     
79     function addSiteSet(uint _setId, uint _siteId) onlyModerators public {
80         uint[] storage siteList = siteSet[_setId];
81         for (uint index = 0; index < siteList.length; index++) {
82             if (siteList[index] == _siteId) {
83                 return;
84             }
85         }
86         siteList.push(_siteId);
87     }
88     
89     function removeSiteSet(uint _setId, uint _siteId) onlyModerators public {
90         uint[] storage siteList = siteSet[_setId];
91         uint foundIndex = 0;
92         for (; foundIndex < siteList.length; foundIndex++) {
93             if (siteList[foundIndex] == _siteId) {
94                 break;
95             }
96         }
97         if (foundIndex < siteList.length) {
98             siteList[foundIndex] = siteList[siteList.length-1];
99             delete siteList[siteList.length-1];
100             siteList.length--;
101         }
102     }
103     
104     function setMonsterClassSiteSet(uint _monsterId, uint _siteSetId) onlyModerators public {
105         monsterClassSiteSet[_monsterId] = _siteSetId;
106     }
107     
108     function setSiteRewards(uint _siteId, uint _monster_rate, uint _monster_id, uint _shard_rate, uint _shard_id, uint _level_rate, uint _exp_rate, uint _emont_rate) onlyModerators public {
109         RewardData storage reward = siteRewards[_siteId];
110         reward.monster_rate = _monster_rate;
111         reward.monster_id = _monster_id;
112         reward.shard_rate = _shard_rate;
113         reward.shard_id = _shard_id;
114         reward.level_rate = _level_rate;
115         reward.exp_rate = _exp_rate;
116         reward.emont_rate = _emont_rate;
117     }
118     
119     function setLevelRewards(uint _index, uint _value) onlyModerators public {
120         levelRewards[_index] = _value;
121     }
122     
123     function setExpRewards(uint _index, uint _value) onlyModerators public {
124         expRewards[_index] = _value;
125     }
126     
127     function setEmontRewards(uint _index, uint _value) onlyModerators public {
128         emontRewards[_index] = _value;
129     }
130     
131     function initSiteSet(uint _turn) onlyModerators public {
132         if (_turn == 1) {
133             siteSet[1] = [35, 3, 4, 37, 51, 8, 41, 11, 45, 47, 15, 16, 19, 52, 23, 36, 27, 30, 31];
134             siteSet[2] = [35, 3, 4, 49, 39, 8, 41, 11, 13, 15, 48, 43, 18, 19, 53, 23, 27, 30, 31];
135             siteSet[3] = [2, 4, 39, 40, 9, 47, 12, 14, 44, 16, 49, 20, 46, 54, 24, 25, 27, 36, 29, 31];
136             siteSet[4] = [51, 3, 5, 38, 7, 40, 11, 12, 45, 14, 47, 16, 35, 52, 21, 22, 26, 30, 31];
137             siteSet[5] = [33, 3, 4, 54, 38, 8, 10, 43, 45, 14, 50, 18, 35, 21, 22, 46, 26, 28, 42];
138             siteSet[6] = [51, 3, 36, 5, 7, 44, 42, 12, 13, 47, 17, 37, 19, 52, 24, 26, 28, 29, 31];
139             siteSet[7] = [32, 48, 2, 43, 4, 38, 7, 9, 42, 11, 34, 15, 16, 49, 21, 23, 25, 30, 53];
140             siteSet[8] = [1, 34, 54, 6, 33, 8, 44, 39, 12, 13, 46, 17, 50, 20, 22, 40, 24, 25, 29];
141             siteSet[9] = [32, 2, 6, 7, 40, 10, 39, 44, 34, 15, 48, 17, 50, 20, 21, 24, 25, 29, 52];
142             siteSet[10] = [32, 1, 36, 5, 38, 48, 9, 11, 45, 15, 16, 49, 19, 41, 23, 27, 28, 53, 37];
143         } else {
144             siteSet[11] = [2, 35, 37, 6, 7, 10, 46, 44, 50, 14, 18, 51, 21, 22, 26, 53, 42, 30, 31];
145             siteSet[12] = [1, 34, 5, 51, 33, 9, 10, 45, 14, 47, 16, 18, 19, 52, 41, 23, 27, 29, 37];
146             siteSet[13] = [32, 2, 35, 4, 5, 38, 49, 9, 42, 43, 12, 13, 48, 17, 21, 24, 25, 28, 53];
147             siteSet[14] = [1, 34, 3, 37, 6, 33, 8, 41, 10, 45, 46, 15, 17, 50, 20, 54, 24, 25, 29];
148             siteSet[15] = [33, 2, 34, 6, 7, 40, 42, 11, 13, 47, 50, 43, 18, 20, 22, 39, 26, 30, 52];
149             siteSet[16] = [32, 1, 36, 5, 39, 54, 9, 10, 43, 14, 18, 51, 20, 46, 22, 41, 27, 28, 53];
150             siteSet[17] = [32, 1, 49, 36, 38, 6, 33, 8, 44, 12, 13, 48, 17, 19, 40, 54, 23, 26, 28];
151         }
152     }
153     
154     function initMonsterClassSiteSet() onlyModerators public {
155             monsterClassSiteSet[1] = 1;
156             monsterClassSiteSet[2] = 2;
157             monsterClassSiteSet[3] = 3;
158             monsterClassSiteSet[4] = 4;
159             monsterClassSiteSet[5] = 5;
160             monsterClassSiteSet[6] = 6;
161             monsterClassSiteSet[7] = 7;
162             monsterClassSiteSet[8] = 8;
163             monsterClassSiteSet[9] = 8;
164             monsterClassSiteSet[10] = 2;
165             monsterClassSiteSet[11] = 9;
166             monsterClassSiteSet[12] = 10;
167             monsterClassSiteSet[13] = 11;
168             monsterClassSiteSet[14] = 12;
169             monsterClassSiteSet[15] = 3;
170             monsterClassSiteSet[16] = 13;
171             monsterClassSiteSet[17] = 3;
172             monsterClassSiteSet[18] = 8;
173             monsterClassSiteSet[19] = 8;
174             monsterClassSiteSet[20] = 14;
175             monsterClassSiteSet[21] = 13;
176             monsterClassSiteSet[22] = 4;
177             monsterClassSiteSet[23] = 9;
178             monsterClassSiteSet[24] = 1;
179             monsterClassSiteSet[25] = 1;
180             monsterClassSiteSet[26] = 3;
181             monsterClassSiteSet[27] = 2;
182             monsterClassSiteSet[28] = 6;
183             monsterClassSiteSet[29] = 4;
184             monsterClassSiteSet[30] = 14;
185             monsterClassSiteSet[31] = 10;
186             monsterClassSiteSet[32] = 1;
187             monsterClassSiteSet[33] = 15;
188             monsterClassSiteSet[34] = 3;
189             monsterClassSiteSet[35] = 3;
190             monsterClassSiteSet[36] = 2;
191             monsterClassSiteSet[37] = 8;
192             monsterClassSiteSet[38] = 1;
193             monsterClassSiteSet[39] = 2;
194             monsterClassSiteSet[40] = 3;
195             monsterClassSiteSet[41] = 4;
196             monsterClassSiteSet[42] = 5;
197             monsterClassSiteSet[43] = 6;
198             monsterClassSiteSet[44] = 7;
199             monsterClassSiteSet[45] = 8;
200             monsterClassSiteSet[46] = 8;
201             monsterClassSiteSet[47] = 2;
202             monsterClassSiteSet[48] = 9;
203             monsterClassSiteSet[49] = 10;
204             monsterClassSiteSet[50] = 8;
205             monsterClassSiteSet[51] = 14;
206             monsterClassSiteSet[52] = 1;
207             monsterClassSiteSet[53] = 3;
208             monsterClassSiteSet[54] = 2;
209             monsterClassSiteSet[55] = 6;
210             monsterClassSiteSet[56] = 4;
211             monsterClassSiteSet[57] = 14;
212             monsterClassSiteSet[58] = 10;
213             monsterClassSiteSet[59] = 1;
214             monsterClassSiteSet[60] = 15;
215             monsterClassSiteSet[61] = 3;
216             monsterClassSiteSet[62] = 8;
217             monsterClassSiteSet[63] = 8;
218             monsterClassSiteSet[64] = 1;
219             monsterClassSiteSet[65] = 2;
220             monsterClassSiteSet[66] = 4;
221             monsterClassSiteSet[67] = 5;
222             monsterClassSiteSet[68] = 14;
223             monsterClassSiteSet[69] = 1;
224             monsterClassSiteSet[70] = 3;
225             monsterClassSiteSet[71] = 3;
226             monsterClassSiteSet[72] = 16;
227             monsterClassSiteSet[73] = 17;
228             monsterClassSiteSet[74] = 5;
229             monsterClassSiteSet[75] = 7;
230             monsterClassSiteSet[76] = 1;
231             monsterClassSiteSet[77] = 17;
232             monsterClassSiteSet[78] = 10;
233             monsterClassSiteSet[79] = 1;
234             monsterClassSiteSet[80] = 13;
235             monsterClassSiteSet[81] = 4;
236             monsterClassSiteSet[82] = 17;
237             monsterClassSiteSet[83] = 10;
238             monsterClassSiteSet[84] = 1;
239             monsterClassSiteSet[85] = 13;
240             monsterClassSiteSet[86] = 4;
241             monsterClassSiteSet[87] = 1;
242             monsterClassSiteSet[88] = 4;
243             monsterClassSiteSet[89] = 1;
244             monsterClassSiteSet[90] = 2;
245             monsterClassSiteSet[91] = 2;
246             monsterClassSiteSet[92] = 2;
247             monsterClassSiteSet[93] = 15;
248             monsterClassSiteSet[94] = 15;
249             monsterClassSiteSet[95] = 15;
250             monsterClassSiteSet[96] = 12;
251             monsterClassSiteSet[97] = 12;
252             monsterClassSiteSet[98] = 12;
253             monsterClassSiteSet[99] = 5;
254             monsterClassSiteSet[100] = 5;
255             monsterClassSiteSet[101] = 8;
256             monsterClassSiteSet[102] = 8;
257             monsterClassSiteSet[103] = 2;
258             monsterClassSiteSet[104] = 2;
259             monsterClassSiteSet[105] = 15;
260             monsterClassSiteSet[106] = 1;
261             monsterClassSiteSet[107] = 1;
262             monsterClassSiteSet[108] = 1;
263             monsterClassSiteSet[109] = 9;
264             monsterClassSiteSet[110] = 10;
265             monsterClassSiteSet[111] = 13;
266             monsterClassSiteSet[112] = 11;
267             monsterClassSiteSet[113] = 14;
268             monsterClassSiteSet[114] = 6;
269             monsterClassSiteSet[115] = 8;
270             monsterClassSiteSet[116] = 3;
271             monsterClassSiteSet[117] = 3;
272             monsterClassSiteSet[118] = 3;
273             monsterClassSiteSet[119] = 13;
274             monsterClassSiteSet[120] = 13;
275             monsterClassSiteSet[121] = 13;
276             monsterClassSiteSet[122] = 5;
277             monsterClassSiteSet[123] = 5;
278             monsterClassSiteSet[124] = 5;
279             monsterClassSiteSet[125] = 15;
280             monsterClassSiteSet[126] = 15;
281             monsterClassSiteSet[127] = 15;
282             monsterClassSiteSet[128] = 1;
283             monsterClassSiteSet[129] = 1;
284             monsterClassSiteSet[130] = 1;
285             monsterClassSiteSet[131] = 14;
286             monsterClassSiteSet[132] = 14;
287             monsterClassSiteSet[133] = 14;
288             monsterClassSiteSet[134] = 16;
289             monsterClassSiteSet[135] = 16;
290             monsterClassSiteSet[136] = 13;
291             monsterClassSiteSet[137] = 13;
292             monsterClassSiteSet[138] = 4;
293             monsterClassSiteSet[139] = 4;
294             monsterClassSiteSet[140] = 7;
295             monsterClassSiteSet[141] = 7;
296             monsterClassSiteSet[142] = 4;
297             monsterClassSiteSet[143] = 4;
298             monsterClassSiteSet[144] = 13;
299             monsterClassSiteSet[145] = 13;
300             monsterClassSiteSet[146] = 9;
301             monsterClassSiteSet[147] = 9;
302             monsterClassSiteSet[148] = 14;
303             monsterClassSiteSet[149] = 14;
304             monsterClassSiteSet[150] = 14;
305             monsterClassSiteSet[151] = 1;
306             monsterClassSiteSet[152] = 1;
307             monsterClassSiteSet[153] = 12;
308             monsterClassSiteSet[154] = 9;
309             monsterClassSiteSet[155] = 14;
310             monsterClassSiteSet[156] = 16;
311             monsterClassSiteSet[157] = 16;
312             monsterClassSiteSet[158] = 8;
313     }
314     
315     function initSiteRewards(uint _turn) onlyModerators public {
316         if (_turn == 1) {
317             siteRewards[1] = RewardData(25, 116, 350, 350, 50, 350, 225);
318             siteRewards[2] = RewardData(25, 119, 350, 350, 50, 350, 225);
319             siteRewards[3] = RewardData(25, 122, 350, 350, 50, 350, 225);
320             siteRewards[4] = RewardData(25, 116, 350, 351, 50, 350, 225);
321             siteRewards[5] = RewardData(25, 119, 350, 351, 50, 350, 225);
322             siteRewards[6] = RewardData(25, 122, 350, 351, 50, 350, 225);
323             siteRewards[7] = RewardData(25, 116, 350, 352, 50, 350, 225);
324             siteRewards[8] = RewardData(25, 119, 350, 352, 50, 350, 225);
325             siteRewards[9] = RewardData(25, 122, 350, 352, 50, 350, 225);
326             siteRewards[10] = RewardData(25, 125, 350, 320, 50, 350, 225);
327             siteRewards[11] = RewardData(25, 128, 350, 320, 50, 350, 225);
328             siteRewards[12] = RewardData(25, 131, 350, 320, 50, 350, 225);
329             siteRewards[13] = RewardData(25, 125, 350, 321, 50, 350, 225);
330             siteRewards[14] = RewardData(25, 128, 350, 321, 50, 350, 225);
331             siteRewards[15] = RewardData(25, 131, 350, 321, 50, 350, 225);
332             siteRewards[16] = RewardData(25, 125, 350, 322, 50, 350, 225);
333             siteRewards[17] = RewardData(25, 128, 350, 322, 50, 350, 225);
334             siteRewards[18] = RewardData(25, 131, 350, 322, 50, 350, 225);
335             siteRewards[19] = RewardData(25, 134, 350, 340, 50, 350, 225);
336             siteRewards[20] = RewardData(25, 136, 350, 340, 50, 350, 225);
337             siteRewards[21] = RewardData(25, 138, 350, 340, 50, 350, 225);
338             siteRewards[22] = RewardData(25, 134, 350, 341, 50, 350, 225);
339             siteRewards[23] = RewardData(25, 136, 350, 341, 50, 350, 225);
340             siteRewards[24] = RewardData(25, 138, 350, 341, 50, 350, 225);
341             siteRewards[25] = RewardData(25, 134, 350, 342, 50, 350, 225);
342             siteRewards[26] = RewardData(25, 136, 350, 342, 50, 350, 225);
343             siteRewards[27] = RewardData(25, 138, 350, 342, 50, 350, 225);
344         } else {
345             siteRewards[28] = RewardData(25, 140, 350, 300, 50, 350, 225);
346             siteRewards[29] = RewardData(25, 142, 350, 300, 50, 350, 225);
347             siteRewards[30] = RewardData(25, 144, 350, 300, 50, 350, 225);
348             siteRewards[31] = RewardData(25, 140, 350, 301, 50, 350, 225);
349             siteRewards[32] = RewardData(25, 142, 350, 301, 50, 350, 225);
350             siteRewards[33] = RewardData(25, 144, 350, 301, 50, 350, 225);
351             siteRewards[34] = RewardData(25, 140, 350, 302, 50, 350, 225);
352             siteRewards[35] = RewardData(25, 142, 350, 302, 50, 350, 225);
353             siteRewards[36] = RewardData(25, 144, 350, 302, 50, 350, 225);
354             siteRewards[37] = RewardData(25, 153, 350, 310, 50, 350, 225);
355             siteRewards[38] = RewardData(25, 154, 350, 310, 50, 350, 225);
356             siteRewards[39] = RewardData(25, 155, 350, 310, 50, 350, 225);
357             siteRewards[40] = RewardData(25, 146, 350, 311, 50, 350, 225);
358             siteRewards[41] = RewardData(25, 148, 350, 311, 50, 350, 225);
359             siteRewards[42] = RewardData(25, 151, 350, 311, 50, 350, 225);
360             siteRewards[43] = RewardData(25, 146, 350, 312, 50, 350, 225);
361             siteRewards[44] = RewardData(25, 148, 350, 312, 50, 350, 225);
362             siteRewards[45] = RewardData(25, 151, 350, 312, 50, 350, 225);
363             siteRewards[46] = RewardData(25, 151, 350, 330, 50, 350, 225);
364             siteRewards[47] = RewardData(25, 146, 350, 330, 50, 350, 225);
365             siteRewards[48] = RewardData(25, 148, 350, 330, 50, 350, 225);
366             siteRewards[49] = RewardData(5, 153, 350, 331, 50, 350, 245);
367             siteRewards[50] = RewardData(5, 154, 350, 331, 50, 350, 245);
368             siteRewards[51] = RewardData(5, 155, 350, 331, 50, 350, 245);
369             siteRewards[52] = RewardData(25, 151, 350, 332, 50, 350, 225);
370             siteRewards[53] = RewardData(25, 146, 350, 332, 50, 350, 225);
371             siteRewards[54] = RewardData(25, 148, 350, 332, 50, 350, 225);
372         } 
373     }
374     
375     function getSiteRewards(uint _siteId) constant public returns(uint monster_rate, uint monster_id, uint shard_rate, uint shard_id, uint level_rate, uint exp_rate, uint emont_rate) {
376         RewardData storage reward = siteRewards[_siteId];
377         return (reward.monster_rate, reward.monster_id, reward.shard_rate, reward.shard_id, reward.level_rate, reward.exp_rate, reward.emont_rate);
378     }
379     
380     function getSiteId(uint _classId, uint _seed) constant public returns(uint) {
381         uint[] storage siteList = siteSet[monsterClassSiteSet[_classId]];
382         if (siteList.length == 0) return 0;
383         return siteList[_seed % siteList.length];
384     }
385     
386     function getSiteItem(uint _siteId, uint _seed) constant public returns(uint _monsterClassId, uint _tokenClassId, uint _value) {
387         uint value = _seed % 1000;
388         RewardData storage reward = siteRewards[_siteId];
389         // assign monster
390         if (value < reward.monster_rate) {
391             return (reward.monster_id, 0, 0);
392         }
393         value -= reward.monster_rate;
394         // shard
395         if (value < reward.shard_rate) {
396             return (0, reward.shard_id, 0);
397         }
398         value -= reward.shard_rate;
399         // level 
400         if (value < reward.level_rate) {
401             return (0, levelItemClass, levelRewards[value%4]);
402         }
403         value -= reward.level_rate;
404         // exp
405         if (value < reward.exp_rate) {
406             return (0, expItemClass, expRewards[value%11]);
407         }
408         value -= reward.exp_rate;
409         return (0, 0, emontRewards[value%6]);
410     }
411 }