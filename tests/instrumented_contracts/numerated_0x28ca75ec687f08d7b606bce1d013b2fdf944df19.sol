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
21     modifier MasterAble()
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
47 }
48 
49 contract BasicTime
50 {
51     uint constant DAY_SECONDS = 60 * 60 * 24;
52 
53     function GetDayCount(uint timestamp) pure internal returns(uint)
54     {
55         return timestamp/DAY_SECONDS;
56     }
57 
58     function GetExpireTime(uint timestamp, uint dayCnt) pure internal returns(uint)
59     {
60         uint dayEnd = GetDayCount(timestamp) + dayCnt;
61         return dayEnd * DAY_SECONDS;
62     }
63 
64 }
65 
66 contract BasicAuth is Base
67 {
68 
69     address master;
70     mapping(address => bool) auth_list;
71 
72     function InitMaster(address acc) internal
73     {
74         require(address(0) != acc);
75         master = acc;
76     }
77 
78     modifier MasterAble()
79     {
80         require(msg.sender == creator || msg.sender == master);
81         _;
82     }
83 
84     modifier OwnerAble(address acc)
85     {
86         require(acc == tx.origin);
87         _;
88     }
89 
90     modifier AuthAble()
91     {
92         require(auth_list[msg.sender]);
93         _;
94     }
95 
96     function CanHandleAuth(address from) internal view returns(bool)
97     {
98         return from == creator || from == master;
99     }
100     
101     function SetAuth(address target) external
102     {
103         require(CanHandleAuth(tx.origin) || CanHandleAuth(msg.sender));
104         auth_list[target] = true;
105     }
106 
107     function ClearAuth(address target) external
108     {
109         require(CanHandleAuth(tx.origin) || CanHandleAuth(msg.sender));
110         delete auth_list[target];
111     }
112 
113 }
114 
115 
116 
117 
118 contract StoreGifts is BasicAuth
119 {
120     struct Gift
121     {
122         string m_Key;
123         uint m_Expire;
124         uint32[] m_ItemIdxList;
125         uint[] m_ItemNumlist;
126     }
127 
128     mapping(address => mapping(string => bool)) g_Exchange;
129     mapping(string => Gift) g_Gifts;
130 
131     constructor(address Master) public
132     {
133         InitMaster(Master);
134     }
135 
136     function HasGift(string key) public view returns(bool)
137     {
138         Gift storage obj = g_Gifts[key];
139         if (bytes(obj.m_Key).length == 0) return false;
140         if (obj.m_Expire!=0 && obj.m_Expire<now) return false;
141         return true;
142     }
143 
144     function AddGift(string key, uint expire, uint32[] idxList, uint[] numList) external MasterAble
145     {
146         require(!HasGift(key));
147         require(now<expire || expire==0);
148         g_Gifts[key] = Gift({
149             m_Key           : key,
150             m_Expire        : expire,
151             m_ItemIdxList   : idxList,
152             m_ItemNumlist   : numList
153         });
154     }
155 
156     function DelGift(string key) external MasterAble
157     {
158         delete g_Gifts[key];
159     }
160 
161     function GetGiftInfo(string key) external view returns(uint, uint32[], uint[])
162     {
163         Gift storage obj = g_Gifts[key];
164         return (obj.m_Expire, obj.m_ItemIdxList, obj.m_ItemNumlist);
165     }
166 
167     function Exchange(address acc, string key) external OwnerAble(acc) AuthAble
168     {
169         g_Exchange[acc][key] = true;
170     }
171 
172     function IsExchanged(address acc, string key) external view returns(bool)
173     {
174         return g_Exchange[acc][key];
175     }
176 
177 }