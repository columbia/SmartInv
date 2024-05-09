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
60 contract BasicAuth is Base
61 {
62 
63     mapping(address => bool) auth_list;
64 
65     modifier OwnerAble(address acc)
66     {
67         require(acc == tx.origin);
68         _;
69     }
70 
71     modifier AuthAble()
72     {
73         require(auth_list[msg.sender]);
74         _;
75     }
76 
77     modifier ValidHandleAuth()
78     {
79         require(tx.origin==creator || msg.sender==creator);
80         _;
81     }
82    
83     function SetAuth(address target) external ValidHandleAuth
84     {
85         auth_list[target] = true;
86     }
87 
88     function ClearAuth(address target) external ValidHandleAuth
89     {
90         delete auth_list[target];
91     }
92 
93 }
94 
95 
96 
97 
98 contract StoreGift is BasicAuth
99 {
100     struct Gift
101     {
102         string m_Key;
103         uint m_Expire;
104         uint32[] m_ItemIdxList;
105         uint[] m_ItemNumlist;
106     }
107 
108     mapping(address => mapping(string => bool)) g_Exchange;
109     mapping(string => Gift) g_Gifts;
110 
111     function HasGift(string key) public view returns(bool)
112     {
113         Gift storage obj = g_Gifts[key];
114         if (bytes(obj.m_Key).length == 0) return false;
115         if (obj.m_Expire!=0 && obj.m_Expire<now) return false;
116         return true;
117     }
118 
119     function AddGift(string key, uint expire, uint32[] idxList, uint[] numList) external CreatorAble
120     {
121         require(!HasGift(key));
122         require(now<expire || expire==0);
123         g_Gifts[key] = Gift({
124             m_Key           : key,
125             m_Expire        : expire,
126             m_ItemIdxList   : idxList,
127             m_ItemNumlist   : numList
128         });
129     }
130 
131     function DelGift(string key) external CreatorAble
132     {
133         delete g_Gifts[key];
134     }
135 
136     function GetGiftInfo(string key) external view returns(uint, uint32[], uint[])
137     {
138         Gift storage obj = g_Gifts[key];
139         return (obj.m_Expire, obj.m_ItemIdxList, obj.m_ItemNumlist);
140     }
141 
142     function Exchange(address acc, string key) external OwnerAble(acc) AuthAble
143     {
144         g_Exchange[acc][key] = true;
145     }
146 
147     function IsExchanged(address acc, string key) external view returns(bool)
148     {
149         return g_Exchange[acc][key];
150     }
151 
152 }