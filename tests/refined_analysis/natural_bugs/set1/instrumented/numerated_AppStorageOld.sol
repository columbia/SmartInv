1 /*
2  SPDX-License-Identifier: MIT
3 */
4 
5 pragma solidity =0.7.6;
6 pragma experimental ABIEncoderV2;
7 
8 import "../interfaces/IDiamondCut.sol";
9 
10 /**
11  * @author Publius
12  * @title App Storage Old defines the legacy state object for Beanstalk. It is used for migration.
13 **/
14 contract AccountOld {
15     struct Field {
16         mapping(uint256 => uint256) plots;
17         mapping(address => uint256) podAllowances;
18     }
19 
20     struct AssetSilo {
21         mapping(uint32 => uint256) withdrawals;
22         mapping(uint32 => uint256) deposits;
23         mapping(uint32 => uint256) depositSeeds;
24     }
25 
26     struct Silo {
27         uint256 stalk;
28         uint256 seeds;
29     }
30 
31     struct SeasonOfPlenty {
32         uint256 base;
33         uint256 stalk;
34     }
35 
36     struct State {
37         Field field;
38         AssetSilo bean;
39         AssetSilo lp;
40         Silo s;
41         uint32 lockedUntil;
42         uint32 lastUpdate;
43         uint32 lastSupplyIncrease;
44         SeasonOfPlenty sop;
45         uint256 roots; // Total amount of Roots.
46     }
47 }
48 
49 contract SeasonOld {
50     struct Global {
51         uint32 current;
52         uint256 start;
53         uint256 period;
54         uint256 timestamp;
55     }
56 
57     struct State {
58         uint256 increaseBase;
59         uint256 stalkBase;
60         uint32 next;
61     }
62 
63     struct SeasonOfPlenty {
64         uint256 base;
65         uint256 increaseBase;
66         uint32 rainSeason;
67         uint32 next;
68     }
69 
70     struct ResetBases {
71         uint256 increaseMultiple;
72         uint256 stalkMultiple;
73         uint256 sopMultiple;
74     }
75 }
76 
77 contract StorageOld {
78     struct Contracts {
79         address bean;
80         address pair;
81         address pegPair;
82         address weth;
83     }
84 
85     // Field
86 
87     struct Field {
88         uint256 soil;
89         uint256 pods;
90         uint256 harvested;
91         uint256 harvestable;
92     }
93 
94     // Governance
95 
96     struct Bip {
97         address proposer;
98         uint256 seeds;
99         uint256 stalk;
100         uint256 increaseBase;
101         uint256 stalkBase;
102         uint32 updated;
103         uint32 start;
104         uint32 period;
105         bool executed;
106         int pauseOrUnpause;
107         uint128 timestamp;
108         uint256 endTotalStalk;
109     }
110 
111     struct DiamondCut {
112         IDiamondCut.FacetCut[] diamondCut;
113         address initAddress;
114         bytes initData;
115     }
116 
117     struct Governance {
118         uint32[] activeBips;
119         uint32 bipIndex;
120         mapping(uint32 => DiamondCut) diamondCuts;
121         mapping(uint32 => mapping(address => bool)) voted;
122         mapping(uint32 => Bip) bips;
123     }
124 
125     // Silo
126 
127     struct AssetSilo {
128         uint256 deposited;
129         uint256 withdrawn;
130     }
131 
132     struct IncreaseSilo {
133         uint32 lastSupplyIncrease;
134         uint256 increase;
135         uint256 increaseBase;
136         uint256 stalk;
137         uint256 stalkBase;
138     }
139 
140     struct SeasonOfPlenty {
141         uint256 weth;
142         uint256 base;
143         uint32 last;
144     }
145 
146     struct Silo {
147         uint256 stalk;
148         uint256 seeds;
149         uint256 roots; // Total amount of Roots.
150     }
151 
152     struct Oracle {
153         bool initialized;
154         uint256 cumulative;
155         uint256 pegCumulative;
156         uint32 timestamp;
157         uint32 pegTimestamp;
158     }
159 
160     struct Rain {
161         uint32 start;
162         bool raining;
163         uint256 pods;
164         uint256 stalk;
165         uint256 stalkBase;
166         uint256 increaseStalk;
167     }
168 
169     struct Weather {
170         uint256 startSoil;
171         uint256 lastDSoil;
172         uint96 lastSoilPercent;
173         uint32 lastSowTime;
174         uint32 nextSowTime;
175         uint32 yield;
176         bool didSowBelowMin;
177         bool didSowFaster;
178     }
179 }
180 
181 struct AppStorageOld {
182     uint8 index;
183     int8[32] cases;
184     bool paused;
185     uint128 pausedAt;
186     SeasonOld.Global season;
187     StorageOld.Contracts c;
188     StorageOld.Field f;
189     StorageOld.Governance g;
190     StorageOld.Oracle o;
191     StorageOld.Rain r; // Remove `stalkBase` and `increaseBase`
192     StorageOld.Silo s; // Added `roots`, Set `stalk` and `seeds` in `InitBip0`
193     // Added reentrantStatus.
194     StorageOld.Weather w; // 3 slots
195     StorageOld.AssetSilo bean; // 2 slots
196     StorageOld.AssetSilo lp; // 2 slots
197     StorageOld.IncreaseSilo si; // 5 slots
198     StorageOld.SeasonOfPlenty sop; // 3 slots
199     mapping (uint32 => SeasonOld.State) seasons;
200     mapping (uint32 => SeasonOld.SeasonOfPlenty) sops;
201     mapping (uint32 => SeasonOld.ResetBases) rbs;
202     mapping (address => AccountOld.State) a;
203 }
204 
205 /*
206  * As a part of Bip-0 OldAppStorage was migrated to AppStorage. Several state variables were remapped, removed or shuffled.
207  *
208  * 2 memory slots (stalkBase and increaseBase) were removed from Rain.
209  * 1 memory slot was added to Silo (roots). reentrantStatus (was depreciated1) was added after Silo
210  * Thus, 2 memory slots were removed and 2 were added, so the storage mapping is contained.
211  * The in-between memory slots in Silo were migrated in InitBip0
212  *
213  * IncreaseSilo changed from 5 slots to 2 slots.
214  * V1IncreaseSilo was added after SeasonOfPlenty with 3 slots.
215  * Thus, IncreaseSilo and SeasonOfPlenty map to IncreaseSilo, SeasonOfPlenty and V1IncreaseSilo accounting for 8 total slots.
216  * Required migrations (such as SeasonOfPlenty shifting) were accounted for in InitBip0
217  * Thus, no memory was shifted unintentionally as 5 slots map to 5 slots
218  *
219  * seasons, sops, and rbs were removed. Mappings take up 1 slot, so 3 slots were removed.
220  * They were replaced with unclaimedRoots, v2SIBeans, sops
221  * seasons was changed to unclaimedRoots (1 slot -> 1 slot)
222  * sops was changed to v2SIBeans (1 slot -> 1 slot)
223  * rbs was changed to sops (1 slot -> 1 slot, Note: This sops variable in AppStorage is completely different than sops variable in AppStorageOld).
224  * No memory was shifted unintentionally as 3 slots map to 3 slots
225  *
226  * a remains at the same place in memory, so no memory should have been changed.
227  * The Account struct changed slightly, but no memory slots were shifted.
228  *
229  * bip0Stalk, hotFix3Stalk, fundraiser, fundraiserIndex were added to the end of the state.
230  * Because these variables were appended to the end of the state, no variables were overwritten by doing so.
231  *
232  */