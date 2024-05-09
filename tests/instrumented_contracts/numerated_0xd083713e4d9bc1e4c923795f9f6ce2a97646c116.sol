1 pragma solidity ^0.4.24;
2 
3 
4 
5 library IndexList
6 {
7     function insert(uint32[] storage self, uint32 index, uint pos) external
8     {
9         require(self.length >= pos);
10         self.length++;
11         for (uint i=self.length; i>pos; i++)
12         {
13             self[i+1] = self[i];
14         }
15         self[pos] = index;
16     }
17 
18     function remove(uint32[] storage self, uint32 index) external returns(bool)
19     {
20         return remove(self,index,0);
21     }
22 
23     function remove(uint32[] storage self, uint32 index, uint startPos) public returns(bool)
24     {
25         for (uint i=startPos; i<self.length; i++)
26         {
27             if (self[i] != index) continue;
28             for (uint j=i; j<self.length-1; j++)
29             {
30                 self[j] = self[j+1];
31             }
32             delete self[self.length-1];
33             self.length--;
34             return true;
35         }
36         return false;
37     }
38 
39 }
40 
41 library ItemList {
42 
43     using IndexList for uint32[];
44     
45     struct Data {
46         uint32[] m_List;
47         mapping(uint32 => uint) m_Maps;
48     }
49 
50     function _insert(Data storage self, uint32 key, uint val) internal
51     {
52         self.m_List.push(key);
53         self.m_Maps[key] = val;
54     }
55 
56     function _delete(Data storage self, uint32 key) internal
57     {
58         self.m_List.remove(key);
59         delete self.m_Maps[key];
60     }
61 
62     function set(Data storage self, uint32 key, uint num) public
63     {
64         if (!has(self,key)) {
65             if (num == 0) return;
66             _insert(self,key,num);
67         }
68         else if (num == 0) {
69             _delete(self,key);
70         } 
71         else {
72             uint old = self.m_Maps[key];
73             if (old == num) return;
74             self.m_Maps[key] = num;
75         }
76     }
77 
78     function add(Data storage self, uint32 key, uint num) external
79     {
80         uint iOld = get(self,key);
81         uint iNow = iOld+num;
82         require(iNow >= iOld);
83         set(self,key,iNow);
84     }
85 
86     function sub(Data storage self, uint32 key, uint num) external
87     {
88         uint iOld = get(self,key);
89         require(iOld >= num);
90         set(self,key,iOld-num);
91     }
92 
93     function has(Data storage self, uint32 key) public view returns(bool)
94     {
95         return self.m_Maps[key] > 0;
96     }
97 
98     function get(Data storage self, uint32 key) public view returns(uint)
99     {
100         return self.m_Maps[key];
101     }
102 
103     function list(Data storage self) view external returns(uint32[],uint[])
104     {
105         uint len = self.m_List.length;
106         uint[] memory values = new uint[](len);
107         for (uint i=0; i<len; i++)
108         {
109             uint32 key = self.m_List[i];
110             values[i] = self.m_Maps[key];
111         }
112         return (self.m_List,values);
113     }
114 
115     function isEmpty(Data storage self) view external returns(bool)
116     {
117         return self.m_List.length == 0;
118     }
119 
120     function keys(Data storage self) view external returns(uint32[])
121     {
122         return self.m_List;
123     }
124 
125 }
126 
127 
128 
129 
130 contract Base
131 {
132     uint8 constant HEROLEVEL_MIN = 1;
133     uint8 constant HEROLEVEL_MAX = 5;
134 
135     uint8 constant LIMITCHIP_MINLEVEL = 3;
136     uint constant PARTWEIGHT_NORMAL = 100;
137     uint constant PARTWEIGHT_LIMIT = 40;
138 
139     address creator;
140 
141     constructor() public
142     {
143         creator = msg.sender;
144     }
145 
146     modifier MasterAble()
147     {
148         require(msg.sender == creator);
149         _;
150     }
151 
152     function IsLimitPart(uint8 level, uint part) internal pure returns(bool)
153     {
154         if (level < LIMITCHIP_MINLEVEL) return false;
155         if (part < GetPartNum(level)) return false;
156         return true;
157     }
158 
159     function GetPartWeight(uint8 level, uint part) internal pure returns(uint)
160     {
161         if (IsLimitPart(level, part)) return PARTWEIGHT_LIMIT;
162         return PARTWEIGHT_NORMAL;
163     }
164     
165     function GetPartNum(uint8 level) internal pure returns(uint)
166     {
167         if (level <= 2) return 3;
168         else if (level <= 4) return 4;
169         return 5;
170     }
171 
172 }
173 
174 contract BasicTime
175 {
176     uint constant DAY_SECONDS = 60 * 60 * 24;
177 
178     function GetDayCount(uint timestamp) pure internal returns(uint)
179     {
180         return timestamp/DAY_SECONDS;
181     }
182 
183     function GetExpireTime(uint timestamp, uint dayCnt) pure internal returns(uint)
184     {
185         uint dayEnd = GetDayCount(timestamp) + dayCnt;
186         return dayEnd * DAY_SECONDS;
187     }
188 
189 }
190 
191 contract BasicAuth is Base
192 {
193 
194     address master;
195     mapping(address => bool) auth_list;
196 
197     function InitMaster(address acc) internal
198     {
199         require(address(0) != acc);
200         master = acc;
201     }
202 
203     modifier MasterAble()
204     {
205         require(msg.sender == creator || msg.sender == master);
206         _;
207     }
208 
209     modifier OwnerAble(address acc)
210     {
211         require(acc == tx.origin);
212         _;
213     }
214 
215     modifier AuthAble()
216     {
217         require(auth_list[msg.sender]);
218         _;
219     }
220 
221     function CanHandleAuth(address from) internal view returns(bool)
222     {
223         return from == creator || from == master;
224     }
225     
226     function SetAuth(address target) external
227     {
228         require(CanHandleAuth(tx.origin) || CanHandleAuth(msg.sender));
229         auth_list[target] = true;
230     }
231 
232     function ClearAuth(address target) external
233     {
234         require(CanHandleAuth(tx.origin) || CanHandleAuth(msg.sender));
235         delete auth_list[target];
236     }
237 
238 }
239 
240 
241 
242 
243 contract StoreGoods is BasicAuth
244 {
245     using ItemList for ItemList.Data;
246 
247     struct Goods
248     {
249         uint32 m_Index;
250         uint32 m_CostItem;
251         uint32 m_ItemRef;
252         uint32 m_Amount;
253         uint32 m_Duration;
254         uint32 m_Expire;
255         uint8 m_PurchaseLimit;
256         uint8 m_DiscountLimit;
257         uint8 m_DiscountRate;
258         uint m_CostNum;
259     }
260 
261     mapping(uint32 => Goods) g_Goods;
262     mapping(address => ItemList.Data) g_PurchaseInfo;
263 
264     constructor(address Master) public
265     {
266         InitMaster(Master);
267     }
268 
269     function AddGoods(
270         uint32 iGoods,
271         uint32 costItem,
272         uint price,
273         uint32 itemRef,
274         uint32 amount,
275         uint32 duration,
276         uint32 expire,
277         uint8 limit,
278         uint8 disCount,
279         uint8 disRate
280     ) external MasterAble
281     {
282         require(!HasGoods(iGoods));
283         g_Goods[iGoods] = Goods({
284             m_Index         :iGoods,
285             m_CostItem      :costItem,
286             m_ItemRef       :itemRef,
287             m_CostNum       :price,
288             m_Amount        :amount,
289             m_Duration      :duration,
290             m_Expire        :expire,
291             m_PurchaseLimit :limit,
292             m_DiscountLimit :disCount,
293             m_DiscountRate  :disRate
294         });
295     }
296 
297     function DelGoods(uint32 iGoods) external MasterAble
298     {
299         delete g_Goods[iGoods];
300     }
301 
302     function HasGoods(uint32 iGoods) public view returns(bool)
303     {
304         Goods storage obj = g_Goods[iGoods];
305         return obj.m_Index == iGoods;
306     }
307 
308     function GetGoodsInfo(uint32 iGoods) external view returns(
309         uint32,uint32,uint32,uint32,uint32,uint,uint8,uint8,uint8
310     )
311     {
312         Goods storage obj = g_Goods[iGoods];
313         return (
314             obj.m_Index,
315             obj.m_CostItem,
316             obj.m_ItemRef,
317             obj.m_Amount,
318             obj.m_Duration,
319             obj.m_CostNum,
320             obj.m_PurchaseLimit,
321             obj.m_DiscountLimit,
322             obj.m_DiscountRate
323         );
324     }
325 
326     function GetRealCost(address acc, uint32 iGoods) external view returns(uint)
327     {
328         Goods storage obj = g_Goods[iGoods];
329         if (g_PurchaseInfo[acc].get(iGoods) >= obj.m_DiscountLimit) {
330             return obj.m_CostNum;
331         }
332         else {
333             return obj.m_CostNum * obj.m_DiscountRate / 100;
334         }
335     }
336 
337     function BuyGoods(address acc, uint32 iGoods) external OwnerAble(acc) AuthAble
338     {
339         g_PurchaseInfo[acc].add(iGoods,1);
340     }
341 
342     function IsOnSale(uint32 iGoods) external view returns(bool)
343     {
344         Goods storage obj = g_Goods[iGoods];
345         if (obj.m_Expire == 0) return true;
346         if (obj.m_Expire >= now) return true;
347         return false;
348     }
349 
350     function CheckPurchaseCount(address acc, uint32 iGoods) external view returns(bool)
351     {
352         Goods storage obj = g_Goods[iGoods];
353         if (obj.m_PurchaseLimit == 0) return true;
354         if (g_PurchaseInfo[acc].get(iGoods) < obj.m_PurchaseLimit) return true;
355         return false;
356     }
357 
358     function GetPurchaseInfo(address acc) external view returns(uint32[], uint[])
359     {
360         return g_PurchaseInfo[acc].list();
361     }
362 
363 }