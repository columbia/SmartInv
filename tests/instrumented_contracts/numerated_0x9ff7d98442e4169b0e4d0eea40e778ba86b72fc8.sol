1 pragma solidity ^0.5.10;
2 
3 contract iInventory {
4     
5     function createFromTemplate(
6         uint256 _templateId,
7         uint8 _feature1,
8         uint8 _feature2,
9         uint8 _feature3,
10         uint8 _feature4,
11         uint8 _equipmentPosition
12     )
13         public
14         returns(uint256);
15 
16 }
17 
18 contract DistributeItems is iInventory {
19     
20     modifier onlyAdmin() {
21         require(admin == msg.sender, "DISTRIBUTE_ITEMS: Caller is not admin");
22         _;
23     }
24     
25     // Check if msg.sender is allowed to take _templateId
26     modifier allowedItem(uint256 _templateId) {
27         require(allowed[msg.sender][_templateId], "DISTRIBUTE_ITEMS: Caller is not allowed to claim item");
28         _;
29     }
30     
31     // Check if distribution has ended (default 0 = skip this check)
32     modifier checkDistEndTime(uint256 _templateId) {
33         // if distribution end time was set...
34         if(distEndTime[_templateId] != 0) {
35             require(distEndTime[_templateId] >= now, "DISTRIBUTE_ITEMS: Distribution for item has ended");
36         }
37         _;
38     }
39     
40     // Check if hard cap reached (default 0 = skip this check)
41     modifier checkHardCap(uint256 _templateId) {
42         // If hard cap was set...
43         if(hardCap[_templateId] != 0) {
44             require(amtClaimed[_templateId] < hardCap[_templateId], "DISTRIBUTE_ITEMS: Hard cap for item reached");
45         }
46         _;
47     }
48     
49     // Check whether the player has claimed _templateId
50     modifier checkIfClaimed(uint256 _templateId) {
51         require(!claimed[_templateId][msg.sender], "DISTRIBUTE_ITEMS: Player has already claimed item");
52         _;
53     }
54     
55     iInventory inv = iInventory(0x9680223F7069203E361f55fEFC89B7c1A952CDcc);
56     
57     address private admin;
58     
59     // Address => (_templateId => bool)
60     mapping (address => mapping(uint256 => bool)) public allowed;
61     
62     // _templateId => timestamp when distribution ends (default 0 = no distribution end time)
63     mapping (uint256 => uint256) public distEndTime;
64     
65     // _templateId => hard cap of _templateId (default 0 = no cap)
66     mapping (uint256 => uint256) public hardCap;
67     
68     // _templateId => amount of times claimed 
69     mapping (uint256 => uint256) public amtClaimed;
70     
71     // _templateId => player => has the player claimed?
72     mapping (uint256 => mapping(address => bool)) public claimed;
73 
74     constructor() public {
75         admin = msg.sender;
76     }
77     
78     // Admin can add new item allowances
79     function addItemAllowance(
80         address _player,
81         uint256 _templateId,
82         bool _allowed
83     )
84         external
85         onlyAdmin
86     {
87         allowed[_player][_templateId] = _allowed;
88     }
89     
90     // Admin can add new item allowances in bulk 
91     function addItemAllowanceForAll(
92         address[] calldata _players,
93         uint256 _templateId,
94         bool _allowed
95     )
96         external
97         onlyAdmin
98     {
99         for(uint i = 0; i < _players.length; i++) {
100             allowed[_players[i]][_templateId] = _allowed;
101         }
102     }
103     
104     /*  Admin can add items with distribution time limits 
105         and hard cap limits */
106     function addTimedItem(
107         uint256 _templateId,
108         uint256 _distEndTime,
109         uint256 _hardCap
110     )
111         external
112         onlyAdmin
113     {
114         // Capped item?
115         if(_hardCap > 0) {
116             hardCap[_templateId] = _hardCap;
117         }
118         
119         // Has dist end time?
120         if(_distEndTime > now) {
121             distEndTime[_templateId] = _distEndTime;
122         }
123         
124     }
125     
126     /*  Player can claim 1x item of _templateId when 
127         Admin has set the allowance beforehand */
128     function claimItem(
129         uint256 _templateId,
130         uint8 _equipmentPosition
131     )
132         external
133         allowedItem(_templateId)
134     {
135         // Reset allowance (only once per allowance)
136         allowed[msg.sender][_templateId] = false;
137         
138         // Materialize
139         inv.createFromTemplate(
140             _templateId,
141             0,
142             0,
143             0,
144             0,
145             _equipmentPosition
146         );
147     }
148     
149     /*  Player can claim item drops that have 
150         distribution time limits or hard cap limits */
151     function claimTimedItem(
152         uint256 _templateId,
153         uint8 _equipmentPosition
154     )
155         external
156         checkDistEndTime(_templateId)
157         checkHardCap(_templateId)
158         checkIfClaimed(_templateId)
159     {
160         // increment the amount claimed if hard cap was set 
161         if(hardCap[_templateId] != 0) {
162             amtClaimed[_templateId]++;
163         }
164         
165         // only once per address 
166         claimed[_templateId][msg.sender] = true;
167         
168         // Materialize
169         inv.createFromTemplate(
170             _templateId,
171             0,
172             0,
173             0,
174             0,
175             _equipmentPosition
176         );
177     }
178     
179     function createFromTemplate(
180         uint256 _templateId,
181         uint8 _feature1,
182         uint8 _feature2,
183         uint8 _feature3,
184         uint8 _feature4,
185         uint8 _equipmentPosition
186     )
187         public
188         returns(uint256)
189     {
190         // (ง •̀_•́)ง
191     }
192     
193 }