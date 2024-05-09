1 pragma solidity ^ 0.4.18;
2 
3 /**
4     Data format
5 
6     32 bytes = 128bits
7     
8     ---
9      0 10 eth (enough for 1M Ether)
10     10 4  votes
11     14 4  first timestamp
12     18 10 name 
13     28 1  approved 0=no 1=yes
14     29 1  selected 0=no 1=yes
15     30 2  list position 
16 
17     ---
18 
19  */
20 contract CryptoBabyName {
21     uint8 constant S_NAME_POS = 18;
22     uint8 constant S_NAME_SIZE = 10;
23     uint8 constant S_SCORE_POS = 0;
24     uint8 constant S_SCORE_SIZE = 10;
25     uint8 constant S_VOTES_POS = 10;
26     uint8 constant S_VOTES_SIZE = 4;
27     uint8 constant S_TIMESTAMP_POS = 14;
28     uint8 constant S_TIMESTAMP_SIZE = 4;
29     uint8 constant S_APPROVED_POS = 28;
30     uint8 constant S_APPROVED_SIZE = 1;
31     uint8 constant S_SELECTED_POS = 29;
32     uint8 constant S_SELECTED_SIZE = 1;
33 
34 
35     address public owner;
36     address public beneficiary;
37 
38     mapping(bytes10 => uint) leaderboard;
39     mapping(address => mapping(bytes10 => uint)) voters;
40 
41     uint[100] allNames;
42 
43     mapping(string => string) metadata;
44 
45 
46     uint babyName;
47     uint babyBirthday;
48 
49     uint counter = 0;
50     modifier restricted() {
51         if (msg.sender == owner) _;
52     }
53 
54     function CryptoBabyName() public {
55         owner = msg.sender;
56     }
57 
58     event Vote(address voter, string name, uint value);
59     event NewSuggestion(address voter, string name, uint number);
60     event BabyBorn(string name, uint birthday);
61 
62     // VOTING
63     /// @notice Voting. Send any amount of Ether to vote. 
64     /// @param name Name to vote for. 2-10 characters of English Alphabet
65     function vote(string name) external payable{
66         _vote(name, msg.value, msg.sender);
67     }
68 
69     function () public payable{
70         if (msg.data.length >= 2 && msg.data.length <= 10) {
71             _vote(string(msg.data), msg.value, msg.sender);
72         }
73     }
74 
75     function _vote(string name, uint value, address voter) private {
76         require(babyName == 0);
77 
78         bytes10 name10 = normalizeAndCheckName(bytes(name));
79         if (leaderboard[name10] != 0) { //existing name
80             uint newVal = leaderboard[name10];
81             newVal = addToPart(newVal, S_SCORE_POS, S_SCORE_SIZE, value);//value
82             newVal = addToPart(newVal, S_VOTES_POS, S_VOTES_SIZE, 1);//vote count
83 
84             _update(name10, newVal);
85         } else { //new name
86             uint uni = 0xFFFF;//0xFFFF = unsaved mark
87             uni = setPart(uni, S_SCORE_POS, S_SCORE_SIZE, value);
88             uint uname = uint(name10);
89             uni = setPart(uni, S_NAME_POS, S_NAME_SIZE, uname);
90             uni = setPart(uni, S_VOTES_POS, S_VOTES_SIZE, 1);
91             uni = setPart(uni, S_TIMESTAMP_POS, S_TIMESTAMP_SIZE, block.timestamp);
92 
93             uni |= 0xFFFF;//mark unsaved
94             _update(name10, uni);
95             counter += 1;
96             NewSuggestion(voter, name, counter);
97         }
98 
99         voters[voter][name10] += value; //save voter info
100 
101         Vote(voter, name, value);
102     }
103 
104     function didVoteForName(address voter, string name) public view returns(uint value){
105         value = voters[voter][normalizeAndCheckName(bytes(name))];
106     }
107 
108     function _update(bytes10 name10, uint updated) private {
109         uint16 idx = uint16(updated);
110         if (idx == 0xFFFF) {
111             uint currentBottom;
112             uint bottomIndex;
113             (currentBottom, bottomIndex) = bottomName();
114 
115             if (updated > currentBottom) {
116                 //remove old score
117                 if (getPart(currentBottom, S_SCORE_POS, S_SCORE_SIZE) > 0) {
118                     currentBottom = currentBottom | uint(0xFFFF);//remove index
119                     bytes10 bottomName10 = bytes10(getPart(currentBottom, S_NAME_POS, S_NAME_SIZE));
120                     leaderboard[bottomName10] = currentBottom;
121                 }
122                 //update the new one
123                 updated = (updated & ~uint(0xFFFF)) | bottomIndex;
124                 allNames[bottomIndex] = updated;
125             }
126         } else {
127             allNames[idx] = updated;
128         }
129         leaderboard[name10] = updated;
130     }
131 
132     function getPart(uint val, uint8 pos, uint8 sizeBytes) private pure returns(uint result){
133         uint mask = makeMask(sizeBytes);
134         result = (val >> ((32 - (pos + sizeBytes)) * 8)) & mask;
135     }
136 
137     function makeMask(uint8 size) pure private returns(uint mask){
138         mask = (uint(1) << (size * 8)) - 1;
139     }
140 
141     function setPart(uint val, uint8 pos, uint8 sizeBytes, uint newValue) private pure returns(uint result){
142         uint mask = makeMask(sizeBytes);
143         result = (val & ~(mask << (((32 - (pos + sizeBytes)) * 8)))) | ((newValue & mask) << (((32 - (pos + sizeBytes)) * 8)));
144     }
145 
146     function addToPart(uint val, uint8 pos, uint8 sizeBytes, uint value) private pure returns(uint result){
147         result = setPart(val, pos, sizeBytes, getPart(val, pos, sizeBytes) + value);
148     }
149 
150 
151     //GETING RESULTS
152 
153     function bottomName() public view returns(uint name, uint index){
154         uint16 n = uint16(allNames.length);
155         uint j = 0;
156         name = allNames[0];
157         index = 0;
158         for (j = 1; j < n; j++) {
159             uint t = allNames[j];
160             if (t < name) {
161                 name = t;
162                 index = j;
163             }
164         }
165     }
166 
167     function getTopN(uint nn) public view returns(uint[] top){
168         uint n = nn;
169         if (n > allNames.length) {
170             n = allNames.length;
171         }
172         top = new uint[](n);
173         uint cnt = allNames.length;
174         uint usedNames;
175 
176         for (uint j = 0; j < n; j++ ) {
177             uint maxI = 0;
178             uint maxScore = 0;
179             bool found = false;
180             for (uint i = 0; i < cnt; i++ ) {
181                 if (allNames[i] > maxScore) {
182                     if ((usedNames & (uint(1) << i)) == 0) {
183                         maxScore = allNames[i];
184                         maxI = i;
185                         found = true;
186                     }
187                 }
188             }
189             if (found) {
190                 usedNames |= uint(1) << maxI;
191                 top[j] = maxScore;
192             } else {
193                 break;
194             }
195         }
196     }
197 
198     function getTopNames() external view returns(uint[100]){
199         return allNames;
200     }
201 
202     function getCount() external view returns(uint count){
203         count = counter;
204     }
205 
206     function getScoreForName(string name) external view returns(uint){
207         return leaderboard[normalizeAndCheckName(bytes(name))];
208     }
209 
210     //approval
211 
212     function approve(string name, uint8 approval) external {
213         require(msg.sender == owner);
214 
215         bytes10 name10 = normalizeAndCheckName(bytes(name));
216         uint uname = leaderboard[name10];
217         if (uname != 0) {
218             uname = setPart(uname, S_APPROVED_POS, S_APPROVED_SIZE, approval);
219             _update(name10, uname);
220         }
221     }
222 
223 
224 
225     function redeem(uint _value) external{
226         require(msg.sender == owner);
227         uint value = _value;
228 
229         if (value == 0) {
230             value = this.balance;
231         }
232         owner.transfer(value);
233     }
234 
235     //
236     function babyBornEndVoting(string name, uint birthday) external returns(uint finalName){
237         require(msg.sender == owner);
238 
239         bytes10 name10 = normalizeAndCheckName(bytes(name));
240         finalName = leaderboard[name10];
241         if (finalName != 0) {
242             babyName = finalName;
243             babyBirthday = birthday;
244             BabyBorn(name, birthday);
245         }
246     }
247 
248     function getSelectedName() external view returns(uint name, uint birthday){
249         name = babyName;
250         birthday = babyBirthday;
251     }
252 
253 
254     function normalizeAndCheckName(bytes name) private pure returns(bytes10 name10){
255         require(name.length <= 10);
256         require(name.length >= 2);
257         for (uint8 i = 0; i < name.length; i++ ) {
258             bytes1 chr = name[i] & ~0x20;//UPERCASE
259             require(chr >= 0x41 && chr <= 0x5A);//only A-Z
260             name[i] = chr;
261             name10 |= bytes10(chr) >> (8 * i);
262         }
263     }
264 
265 }