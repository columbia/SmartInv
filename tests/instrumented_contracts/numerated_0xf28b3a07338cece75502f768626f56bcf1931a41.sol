1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5 /**
6 * @dev Multiplies two numbers, throws on overflow.
7 */
8 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9 if (a == 0) {
10 return 0;
11 }
12 uint256 c = a * b;
13 assert(c / a == b);
14 return c;
15 }
16 
17 /**
18 * @dev Integer division of two numbers, truncating the quotient.
19 */
20 function div(uint256 a, uint256 b) internal pure returns (uint256) {
21 // assert(b > 0); // Solidity automatically throws when dividing by 0
22 uint256 c = a / b;
23 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24 return c;
25 }
26 
27 /**
28 * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29 */
30 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31 assert(b <= a);
32 return a - b;
33 }
34 
35 /**
36 * @dev Adds two numbers, throws on overflow.
37 */
38 function add(uint256 a, uint256 b) internal pure returns (uint256) {
39 uint256 c = a + b;
40 assert(c >= a);
41 return c;
42 }
43 }
44 contract DarkLord {
45 
46 using SafeMath for uint256;
47 event NewZombie(uint zombieId, string name, uint dna);
48 
49 mapping(address => uint) playerExp;
50 mapping (address => bool) private inwitness;
51 address[] public winnerAdd;
52 
53 modifier onlyWit() {
54 require(inwitness[msg.sender]);
55 _;
56 }
57 
58 struct Battlelog {
59 uint id1;
60 uint id2;
61 uint result;
62 address witness;
63 }
64 
65 Battlelog[] battleresults;
66 
67 
68 struct BMBattlelog {
69 uint id1;
70 uint id2;
71 uint id3;
72 uint id4;
73 uint result;
74 address witness;
75 }
76 
77 BMBattlelog[] bmbattleresults;
78 
79 
80 function _addWit (address _inwitness) private {
81 inwitness[_inwitness] = true;
82 }
83 
84 function _delWit (address _inwitness) private {
85 delete inwitness[_inwitness];
86 }
87 
88 function initialWittness() public {
89 _addWit(msg.sender);
90 
91 }
92 
93 function clearwit(address _inwitness) public{
94 if(_inwitness==msg.sender){
95 delete inwitness[_inwitness];
96 }
97 }
98 
99 function initialCard(uint total) public view returns(uint i) {
100 
101 i = uint256(sha256(abi.encodePacked(block.timestamp, block.number-i-1))) % total +1;
102 
103 }
104 
105 function initialBattle(uint id1,uint total1,uint id2,uint total2) onlyWit() public returns (uint wid){
106 uint darklord;
107 if(total1.mul(2)>5000){
108 darklord=total1.mul(2);
109 }else{
110 darklord=5000;
111 }
112 
113 uint256 threshold = dataCalc(total1.add(total2),darklord);
114 
115 uint256 i = uint256(sha256(abi.encodePacked(block.timestamp, block.number-i-1))) % 100 +1;
116 if(i <= threshold){
117 wid = 0;
118 winnerAdd.push(msg.sender);
119 }else{
120 wid = 1;
121 }
122 battleresults.push(Battlelog(id1,id2,wid,msg.sender));
123 _delWit(msg.sender);
124 }
125 
126 
127 function initialBM(uint id1,uint total1,uint id2,uint total2,uint id3,uint total3,uint id4,uint total4) onlyWit() public returns (uint wid){
128 uint teamETH;
129 uint teamTron;
130 teamETH=total1+total2;
131 teamTron=total3+total4;
132 
133 uint256 threshold = dataCalc(teamETH,teamTron);
134 
135 uint256 i = uint256(sha256(abi.encodePacked(block.timestamp, block.number-i-1))) % 100 +1;
136 if(i <= threshold){
137 wid = 0;
138 winnerAdd.push(msg.sender);
139 }else{
140 wid = 1;
141 }
142 bmbattleresults.push(BMBattlelog(id1,id2,id3,id4,wid,msg.sender));
143 _delWit(msg.sender);
144 }
145 
146 function dataCalc(uint _total1, uint _total2) public pure returns (uint256 _threshold){
147 
148 // We can just leave the other fields blank:
149 
150 uint256 threshold = _total1.mul(100).div(_total1+_total2);
151 
152 if(threshold > 90){
153 threshold = 90;
154 }
155 if(threshold < 10){
156 threshold = 10;
157 }
158 
159 return threshold;
160 
161 }
162 
163 function getBattleDetails(uint _battleId) public view returns (
164 uint _id1,
165 uint _id2,
166 uint256 _result,
167 address _witadd
168 ) {
169 Battlelog storage _battle = battleresults[_battleId];
170 
171 _id1 = _battle.id1;
172 _id2 = _battle.id2;
173 _result = _battle.result;
174 _witadd = _battle.witness;
175 }
176 
177 function getBMBattleDetails(uint _battleId) public view returns (
178 uint _id1,
179 uint _id2,
180 uint _id3,
181 uint _id4,
182 uint256 _result,
183 address _witadd
184 ) {
185 BMBattlelog storage _battle = bmbattleresults[_battleId];
186 
187 _id1 = _battle.id1;
188 _id2 = _battle.id2;
189 _id3 = _battle.id3;
190 _id4 = _battle.id4;
191 _result = _battle.result;
192 _witadd = _battle.witness;
193 }
194 
195 
196 function totalSupply() public view returns (uint256 _totalSupply) {
197 return battleresults.length;
198 }
199 
200 function totalBmSupply() public view returns (uint256 _totalSupply) {
201 return bmbattleresults.length;
202 }
203 
204 
205 }