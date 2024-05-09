1 pragma solidity ^0.4.24;
2 
3 
4 
5 contract Base
6 {
7     uint8 constant HEROLEVEL_MIN = 1;
8     uint8 constant HEROLEVEL_MAX = 5;
9 
10     uint8 constant LIMITCHIP_MINLEVEL = 3;
11     uint constant PARTWEIGHT_NORMAL = 100;
12     uint constant PARTWEIGHT_LIMIT = 40;
13 
14     address creator;
15 
16     constructor() public
17     {
18         creator = msg.sender;
19     }
20 
21     modifier CreatorAble()
22     {
23         require(msg.sender == creator);
24         _;
25     }
26 
27     function IsLimitPart(uint8 level, uint part) internal pure returns(bool)
28     {
29         if (level < LIMITCHIP_MINLEVEL) return false;
30         if (part < GetPartNum(level)) return false;
31         return true;
32     }
33 
34     function GetPartWeight(uint8 level, uint part) internal pure returns(uint)
35     {
36         if (IsLimitPart(level, part)) return PARTWEIGHT_LIMIT;
37         return PARTWEIGHT_NORMAL;
38     }
39     
40     function GetPartNum(uint8 level) internal pure returns(uint)
41     {
42         if (level <= 2) return 3;
43         else if (level <= 4) return 4;
44         return 5;
45     }
46 
47     function GetPartLimit(uint8 level, uint part) internal pure returns(uint8)
48     {
49         if (!IsLimitPart(level, part)) return 0;
50         if (level == 5) return 1;
51         if (level == 4) return 8;
52         return 15;
53     }
54 
55 }
56 
57 
58 
59 
60 library ItemList {
61 
62     struct Data {
63         uint32[] m_List;
64         mapping(uint32 => uint) m_Maps;
65     }
66 
67     function set(Data storage self, uint32 key, uint num) public
68     {
69         if (!has(self,key)) {
70             if (num == 0) return;
71             self.m_List.push(key);
72             self.m_Maps[key] = num;
73         }
74         else if (num == 0) {
75             delete self.m_Maps[key];
76         } 
77         else {
78             uint old = self.m_Maps[key];
79             if (old == num) return;
80             self.m_Maps[key] = num;
81         }
82     }
83 
84     function add(Data storage self, uint32 key, uint num) external
85     {
86         uint iOld = get(self,key);
87         uint iNow = iOld+num;
88         require(iNow >= iOld);
89         set(self,key,iNow);
90     }
91 
92     function sub(Data storage self, uint32 key, uint num) external
93     {
94         uint iOld = get(self,key);
95         require(iOld >= num);
96         set(self,key,iOld-num);
97     }
98 
99     function has(Data storage self, uint32 key) public view returns(bool)
100     {
101         return self.m_Maps[key] > 0;
102     }
103 
104     function get(Data storage self, uint32 key) public view returns(uint)
105     {
106         return self.m_Maps[key];
107     }
108 
109     function list(Data storage self) view external returns(uint32[],uint[])
110     {
111         uint len = self.m_List.length;
112         uint[] memory values = new uint[](len);
113         for (uint i=0; i<len; i++)
114         {
115             uint32 key = self.m_List[i];
116             values[i] = self.m_Maps[key];
117         }
118         return (self.m_List,values);
119     }
120 
121     function isEmpty(Data storage self) view external returns(bool)
122     {
123         return self.m_List.length == 0;
124     }
125 
126     function keys(Data storage self) view external returns(uint32[])
127     {
128         return self.m_List;
129     }
130 
131 }
132 
133 
134 
135 
136 contract BasicAuth is Base
137 {
138 
139     mapping(address => bool) auth_list;
140 
141     modifier OwnerAble(address acc)
142     {
143         require(acc == tx.origin);
144         _;
145     }
146 
147     modifier AuthAble()
148     {
149         require(auth_list[msg.sender]);
150         _;
151     }
152 
153     modifier ValidHandleAuth()
154     {
155         require(tx.origin==creator || msg.sender==creator);
156         _;
157     }
158    
159     function SetAuth(address target) external ValidHandleAuth
160     {
161         auth_list[target] = true;
162     }
163 
164     function ClearAuth(address target) external ValidHandleAuth
165     {
166         delete auth_list[target];
167     }
168 
169 }
170 
171 
172 
173 
174 contract StoreGoods is BasicAuth
175 {
176     using ItemList for ItemList.Data;
177 
178     struct Goods
179     {
180         uint32 m_Index;
181         uint32 m_CostItem;
182         uint32 m_ItemRef;
183         uint32 m_Amount;
184         uint32 m_Duration;
185         uint32 m_Expire;
186         uint8 m_PurchaseLimit;
187         uint8 m_DiscountLimit;
188         uint8 m_DiscountRate;
189         uint m_CostNum;
190     }
191 
192     mapping(uint32 => Goods) g_Goods;
193     mapping(address => ItemList.Data) g_PurchaseInfo;
194 
195     function AddGoods(uint32 iGoods, uint32 costItem, uint price, uint32 itemRef, uint32 amount, uint32 duration, uint32 expire, uint8 limit, uint8 disCount, uint8 disRate) external CreatorAble
196     {
197         require(!HasGoods(iGoods));
198         g_Goods[iGoods] = Goods({
199             m_Index         :iGoods,
200             m_CostItem      :costItem,
201             m_ItemRef       :itemRef,
202             m_CostNum       :price,
203             m_Amount        :amount,
204             m_Duration      :duration,
205             m_Expire        :expire,
206             m_PurchaseLimit :limit,
207             m_DiscountLimit :disCount,
208             m_DiscountRate  :disRate
209         });
210     }
211 
212     function DelGoods(uint32 iGoods) external CreatorAble
213     {
214         delete g_Goods[iGoods];
215     }
216 
217     function HasGoods(uint32 iGoods) public view returns(bool)
218     {
219         Goods storage obj = g_Goods[iGoods];
220         return obj.m_Index == iGoods;
221     }
222 
223     function GetGoodsInfo(uint32 iGoods) external view returns(
224         uint32,uint32,uint32,uint32,uint32,uint,uint8,uint8,uint8
225     )
226     {
227         Goods storage obj = g_Goods[iGoods];
228         return (
229             obj.m_Index,
230             obj.m_CostItem,
231             obj.m_ItemRef,
232             obj.m_Amount,
233             obj.m_Duration,
234             obj.m_CostNum,
235             obj.m_PurchaseLimit,
236             obj.m_DiscountLimit,
237             obj.m_DiscountRate
238         );
239     }
240 
241     function GetRealCost(address acc, uint32 iGoods) external view returns(uint)
242     {
243         Goods storage obj = g_Goods[iGoods];
244         if (g_PurchaseInfo[acc].get(iGoods) >= obj.m_DiscountLimit) {
245             return obj.m_CostNum;
246         }
247         else {
248             return obj.m_CostNum * obj.m_DiscountRate / 100;
249         }
250     }
251 
252     function BuyGoods(address acc, uint32 iGoods) external OwnerAble(acc) AuthAble
253     {
254         g_PurchaseInfo[acc].add(iGoods,1);
255     }
256 
257     function IsOnSale(uint32 iGoods) external view returns(bool)
258     {
259         Goods storage obj = g_Goods[iGoods];
260         if (obj.m_Expire == 0) return true;
261         if (obj.m_Expire >= now) return true;
262         return false;
263     }
264 
265     function CheckPurchaseCount(address acc, uint32 iGoods) external view returns(bool)
266     {
267         Goods storage obj = g_Goods[iGoods];
268         if (obj.m_PurchaseLimit == 0) return true;
269         if (g_PurchaseInfo[acc].get(iGoods) < obj.m_PurchaseLimit) return true;
270         return false;
271     }
272 
273     function GetPurchaseInfo(address acc) external view returns(uint32[], uint[])
274     {
275         return g_PurchaseInfo[acc].list();
276     }
277 
278 }