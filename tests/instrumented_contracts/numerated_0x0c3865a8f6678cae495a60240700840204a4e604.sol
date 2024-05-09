1 pragma solidity ^0.4.16;
2 
3 // copyright contact@Etheremon.com
4 
5 contract BasicAccessControl {
6     address public owner;
7     // address[] public moderators;
8     uint16 public totalModerators = 0;
9     mapping (address => bool) public moderators;
10     bool public isMaintaining = false;
11 
12     function BasicAccessControl() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     modifier onlyModerators() {
22         require(msg.sender == owner || moderators[msg.sender] == true);
23         _;
24     }
25 
26     modifier isActive {
27         require(!isMaintaining);
28         _;
29     }
30 
31     function ChangeOwner(address _newOwner) onlyOwner public {
32         if (_newOwner != address(0)) {
33             owner = _newOwner;
34         }
35     }
36 
37 
38     function AddModerator(address _newModerator) onlyOwner public {
39         if (moderators[_newModerator] == false) {
40             moderators[_newModerator] = true;
41             totalModerators += 1;
42         }
43     }
44     
45     function RemoveModerator(address _oldModerator) onlyOwner public {
46         if (moderators[_oldModerator] == true) {
47             moderators[_oldModerator] = false;
48             totalModerators -= 1;
49         }
50     }
51 
52     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
53         isMaintaining = _isMaintaining;
54     }
55 }
56 
57 contract EtheremonTransformSetting is BasicAccessControl {
58     
59     uint32[] public randomClassIds = [32, 97, 80, 73, 79, 81, 101, 103, 105];
60     mapping(uint32 => uint8) public layingEggLevels;
61     mapping(uint32 => uint8) public layingEggDeductions;
62     mapping(uint32 => uint8) public transformLevels;
63     mapping(uint32 => uint32) public transformClasses;
64     
65     function setConfigClass(uint32 _classId, uint8 _layingLevel, uint8 _layingCost, uint8 _transformLevel, uint32 _tranformClass) onlyModerators public {
66         layingEggLevels[_classId] = _layingLevel;
67         layingEggDeductions[_classId] = _layingCost;
68         transformLevels[_classId] = _transformLevel;
69         transformClasses[_classId] = _tranformClass;
70     }
71     
72     function addRandomClass(uint32 _newClassId) onlyModerators public {
73         if (_newClassId > 0) {
74             for (uint index = 0; index < randomClassIds.length; index++) {
75                 if (randomClassIds[index] == _newClassId) {
76                     return;
77                 }
78             }
79             randomClassIds.push(_newClassId);
80         }
81     }
82     
83     function removeRandomClass(uint32 _oldClassId) onlyModerators public {
84         uint foundIndex = 0;
85         for (; foundIndex < randomClassIds.length; foundIndex++) {
86             if (randomClassIds[foundIndex] == _oldClassId) {
87                 break;
88             }
89         }
90         if (foundIndex < randomClassIds.length) {
91             randomClassIds[foundIndex] = randomClassIds[randomClassIds.length-1];
92             delete randomClassIds[randomClassIds.length-1];
93             randomClassIds.length--;
94         }
95     }
96     
97     function initMonsterClassConfig() onlyModerators external {
98         setConfigClass(1, 0, 0, 20, 38);
99         setConfigClass(2, 0, 0, 20, 39);
100         setConfigClass(3, 0, 0, 26, 40);
101         setConfigClass(4, 0, 0, 20, 41);
102         setConfigClass(5, 0, 0, 20, 42);
103         setConfigClass(6, 0, 0, 25, 43);
104         setConfigClass(7, 0, 0, 28, 44);
105         setConfigClass(8, 0, 0, 25, 45);
106         setConfigClass(9, 0, 0, 27, 46);
107         setConfigClass(10, 0, 0, 29, 47);
108         setConfigClass(11, 0, 0, 25, 48);
109         setConfigClass(12, 0, 0, 26, 49);
110         setConfigClass(18, 0, 0, 28, 50);
111         setConfigClass(20, 0, 0, 20, 51);
112         setConfigClass(24, 0, 0, 39, 89);
113         setConfigClass(25, 0, 0, 20, 52);
114         setConfigClass(26, 0, 0, 21, 53);
115         setConfigClass(27, 0, 0, 28, 54);
116         
117         setConfigClass(28, 35, 5, 28, 55);
118         setConfigClass(29, 35, 5, 27, 56);
119         setConfigClass(30, 35, 5, 28, 57);
120         setConfigClass(31, 34, 5, 27, 58);
121         setConfigClass(32, 34, 5, 27, 59);
122         setConfigClass(33, 33, 5, 28, 60);
123         setConfigClass(34, 31, 5, 21, 61);
124         
125         setConfigClass(37, 34, 5, 26, 62);
126         setConfigClass(38, 0, 0, 40, 64);
127         setConfigClass(39, 0, 0, 40, 65);
128         setConfigClass(41, 0, 0, 39, 66);
129         setConfigClass(42, 0, 0, 42, 67);
130         setConfigClass(51, 0, 0, 37, 68);
131         setConfigClass(52, 0, 0, 39, 69);
132         setConfigClass(53, 0, 0, 38, 70);
133         setConfigClass(61, 0, 0, 39, 71);
134         setConfigClass(62, 0, 0, 5, 63);
135         
136         setConfigClass(77, 36, 5, 32, 82);
137         setConfigClass(78, 35, 5, 30, 83);
138         setConfigClass(79, 32, 5, 23, 84);
139         setConfigClass(80, 35, 5, 29, 85);
140         setConfigClass(81, 34, 5, 24, 86);
141         setConfigClass(84, 0, 0, 38, 87);
142         
143         setConfigClass(86, 0, 0, 41, 88);
144         setConfigClass(89, 0, 0, 42, 158);
145         setConfigClass(90, 0, 0, 28, 91);
146         setConfigClass(91, 0, 0, 38, 92);
147         setConfigClass(93, 0, 0, 28, 94);
148         setConfigClass(94, 0, 0, 38, 95);
149         
150         setConfigClass(97, 35, 5, 32, 98);
151         setConfigClass(99, 34, 5, 30, 100);
152         setConfigClass(101, 36, 5, 31, 102);
153         setConfigClass(103, 39, 7, 30, 104);
154         setConfigClass(106, 34, 5, 31, 107);
155         setConfigClass(107, 0, 0, 43, 108);
156         
157         setConfigClass(116, 0, 0, 27, 117);
158         setConfigClass(117, 0, 0, 37, 118);
159         setConfigClass(119, 0, 0, 28, 120);
160         setConfigClass(120, 0, 0, 37, 121);
161         setConfigClass(122, 0, 0, 29, 123);
162         setConfigClass(123, 0, 0, 36, 124);
163         setConfigClass(125, 0, 0, 26, 126);
164         setConfigClass(126, 0, 0, 37, 127);
165         setConfigClass(128, 0, 0, 26, 129);
166         setConfigClass(129, 0, 0, 38, 130);
167         setConfigClass(131, 0, 0, 27, 132);
168         setConfigClass(132, 0, 0, 37, 133);
169         setConfigClass(134, 0, 0, 35, 135);
170         setConfigClass(136, 0, 0, 36, 137);
171         setConfigClass(138, 0, 0, 36, 139);
172         setConfigClass(140, 0, 0, 35, 141);
173         setConfigClass(142, 0, 0, 36, 143);
174         setConfigClass(144, 0, 0, 34, 145);
175         setConfigClass(146, 0, 0, 36, 147);
176         setConfigClass(148, 0, 0, 26, 149);
177         setConfigClass(149, 0, 0, 37, 150);
178         
179         setConfigClass(151, 0, 0, 36, 152);
180         setConfigClass(156, 0, 0, 38, 157);
181     }
182     
183     // read access
184     
185     function getRandomClassId(uint _seed) constant external returns(uint32) {
186         return randomClassIds[_seed % randomClassIds.length];
187     }
188     
189     function getLayEggInfo(uint32 _classId) constant external returns(uint8 layingLevel, uint8 layingCost) {
190         layingLevel = layingEggLevels[_classId];
191         layingCost = layingEggDeductions[_classId];
192     }
193     
194     function getTransformInfo(uint32 _classId) constant external returns(uint32 transformClassId, uint8 level) {
195         transformClassId = transformClasses[_classId];
196         level = transformLevels[_classId];
197     }
198     
199     function getClassTransformInfo(uint32 _classId) constant external returns(uint8 layingLevel, uint8 layingCost, uint8 transformLevel, uint32 transformCLassId) {
200         layingLevel = layingEggLevels[_classId];
201         layingCost = layingEggDeductions[_classId];
202         transformLevel = transformLevels[_classId];
203         transformCLassId = transformClasses[_classId];
204     }
205 }