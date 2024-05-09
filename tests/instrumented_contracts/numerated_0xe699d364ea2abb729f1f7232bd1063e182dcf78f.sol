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
98 contract OldProductionBoiler
99 {
100     function GetBoilerInfo(address acc, uint idx) external view returns(uint, uint32[]);
101 }
102 
103 contract ProductionBoiler is BasicAuth
104 {
105 
106     struct Boiler
107     {
108         uint m_Expire;
109         uint32[] m_Chips;
110     }
111 
112     mapping(address => mapping(uint => Boiler)) g_Boilers;
113 
114     bool g_Synced = false;
115     function SyncOldData(OldProductionBoiler oldBoiler, address[] accounts) external CreatorAble
116     {
117         require(!g_Synced);
118         g_Synced = true;
119         for (uint i=0; i<accounts.length; i++)
120         {
121             address acc = accounts[i];
122             for (uint idx=0; idx<3; idx++)
123             {
124                 (uint expire, uint32[] memory chips) = oldBoiler.GetBoilerInfo(acc,idx);
125                 if (expire == 0) continue;
126                 g_Boilers[acc][idx].m_Expire = expire;
127                 g_Boilers[acc][idx].m_Chips = chips;
128             }
129         }
130     }
131 
132     //=========================================================================
133     function IsBoilerValid(address acc, uint idx) external view returns(bool)
134     {
135         Boiler storage obj = g_Boilers[acc][idx];
136         if (obj.m_Chips.length > 0) return false;
137         return true;
138     }
139 
140     function IsBoilerExpire(address acc, uint idx) external view returns(bool)
141     {
142         Boiler storage obj = g_Boilers[acc][idx];
143         return obj.m_Expire <= now;
144     }
145 
146     //=========================================================================
147 
148     function GenerateChips(address acc, uint idx, uint cd, uint32[] chips) external AuthAble OwnerAble(acc)
149     {
150         Boiler storage obj = g_Boilers[acc][idx];
151         obj.m_Expire = cd+now;
152         obj.m_Chips = chips;
153     }
154 
155     function CollectChips(address acc, uint idx) external AuthAble OwnerAble(acc) returns(uint32[] chips)
156     {
157         Boiler storage obj = g_Boilers[acc][idx];
158         chips = obj.m_Chips;
159         delete g_Boilers[acc][idx];
160     }
161 
162     function GetBoilerInfo(address acc, uint idx) external view returns(uint, uint32[])
163     {
164         Boiler storage obj = g_Boilers[acc][idx];
165         return (obj.m_Expire,obj.m_Chips);
166     }
167 
168 }