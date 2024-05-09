1 pragma solidity ^0.4.18;
2 
3 contract GoCryptobotAccessControl {
4     address public owner;
5     address public operator;
6 
7     bool public paused;
8 
9     modifier onlyOwner() {require(msg.sender == owner); _;}
10     modifier onlyOperator() {require(msg.sender == operator); _;}
11     modifier onlyOwnerOrOperator() {require(msg.sender == owner || msg.sender == operator); _;}
12 
13     modifier whenPaused() {require(paused); _;}
14     modifier whenNotPaused() {require(!paused); _;}
15 
16     function transferOwnership(address newOwner) public onlyOwner {
17         require(newOwner != address(0));
18         owner = newOwner;
19     }
20 
21     function transferOperator(address newOperator) public onlyOwner {
22         require(newOperator != address(0));
23         operator = newOperator;
24     }
25 
26     function pause() public onlyOwnerOrOperator whenNotPaused {
27         paused = true;
28     }
29 
30     function unpause() public onlyOwner whenPaused {
31         paused = false;
32     }
33 }
34 
35 contract GoCryptobotRandom is GoCryptobotAccessControl {
36     uint commitmentNumber;
37     bytes32 randomBytes;
38 
39     function commitment() public onlyOperator {
40         commitmentNumber = block.number;
41     }
42 
43     function _initRandom() internal {
44         require(commitmentNumber < block.number);
45 
46         if (commitmentNumber < block.number - 255) {
47             randomBytes = block.blockhash(block.number - 1);
48         } else {
49             randomBytes = block.blockhash(commitmentNumber);
50         }
51     }
52 
53     function _shuffle(uint8[] deck) internal {
54         require(deck.length < 256);
55 
56         uint8 deckLength = uint8(deck.length);
57         uint8 random;
58         for (uint8 i = 0; i < deckLength; i++) {
59             if (i % 32 == 0) {
60                 randomBytes = keccak256(randomBytes);
61             }
62             random = uint8(randomBytes[i % 32]) % (deckLength - i);
63 
64             if (random != deckLength - 1 - i) {
65                 deck[random] ^= deck[deckLength - 1 - i];
66                 deck[deckLength - 1 - i] ^= deck[random];
67                 deck[random] ^= deck[deckLength - 1 - i];
68             }
69         }
70     }
71 
72     function _random256() internal returns(uint256) {
73         randomBytes = keccak256(randomBytes);
74         return uint256(randomBytes);
75     }
76 }
77 
78 contract GoCryptobotScore is GoCryptobotRandom {
79     // A part's skill consists of color and level. (Total 2 bytes)
80     //   1   2
81     // Skill
82     // +---+---+
83     // | C | L +
84     // +---+---+
85     //
86     // C = Color, 0 ~ 4.
87     // L = Level, 0 ~ 8.
88     //
89     uint256 constant PART_SKILL_SIZE = 2;
90 
91     // A part consists of level and 3 skills. (Total 7 bytes)
92     //   1   2   3   4   5   6   7
93     // Part
94     // +---+---+---+---+---+---+---+
95     // | L | Skill | Skill | Skill |
96     // +---+---+---+---+---+---+---+
97     //
98     // L = Level, 1 ~ 50.
99     //
100     // A part doesn't contains color because individual color doesn't affect to
101     // the score, but it is used to calculate player's theme color.
102     //
103     uint256 constant PART_BASE_SIZE = 1;
104     uint256 constant PART_SIZE = PART_BASE_SIZE + 3 * PART_SKILL_SIZE;
105 
106     // A player consists of theme effect and 4 parts. (Total 29 bytes)
107     //   1   2   3   4   5   6   7
108     // Player
109     // +---+
110     // | C |
111     // +---+---+---+---+---+---+---+
112     // |         HEAD PART         |
113     // +---+---+---+---+---+---+---+
114     // |         BODY PART         |
115     // +---+---+---+---+---+---+---+
116     // |         LEGS PART         |
117     // +---+---+---+---+---+---+---+
118     // |         BOOSTER PART      |
119     // +---+---+---+---+---+---+---+
120     //
121     // C = Whether player's theme effect is enabled or not, 1 or 0.
122     //
123     // The theme effect is set to 1 iff the theme of each part are identical.
124     //
125     uint256 constant PLAYER_BASE_SIZE = 1;
126     uint256 constant PLAYER_SIZE = PLAYER_BASE_SIZE + PART_SIZE * 4;
127 
128     enum PartType {HEAD, BODY, LEGS, BOOSTER}
129     enum EventType {BOWLING, HANGING, SPRINT, HIGH_JUMP}
130     enum EventColor {NONE, YELLOW, BLUE, GREEN, RED}
131 
132     function _getPartLevel(bytes data, uint partOffset) internal pure returns(uint8) {
133         return uint8(data[partOffset + 0]);
134     }
135     // NOTE: _getPartSkillColor is called up to 128 * 4 * 3 times. Explicit
136     // conversion to EventColor could be costful.
137     function _getPartSkillColor(bytes data, uint partOffset, uint skillIndex) internal pure returns(byte) {
138         return data[partOffset + PART_BASE_SIZE + (skillIndex * PART_SKILL_SIZE) + 0];
139     }
140     function _getPartSkillLevel(bytes data, uint partOffset, uint skillIndex) internal pure returns(uint8) {
141         return uint8(data[partOffset + PART_BASE_SIZE + (skillIndex * PART_SKILL_SIZE) + 1]);
142     }
143 
144     function _getPlayerThemeEffect(bytes data, uint playerOffset) internal pure returns(byte) {
145         return data[playerOffset + 0];
146     }
147 
148     function _getPlayerEventScore(bytes data, uint playerIndex, EventType eventType, EventColor _eventMajorColor, EventColor _eventMinorColor) internal pure returns(uint) {
149         uint partOffset = (PLAYER_SIZE * playerIndex) + PLAYER_BASE_SIZE + (uint256(eventType) * PART_SIZE);
150         uint level = _getPartLevel(data, partOffset);
151         uint majorSkillSum = 0;
152         uint minorSkillSum = 0;
153 
154         byte eventMajorColor = byte(uint8(_eventMajorColor));
155         byte eventMinorColor = byte(uint8(_eventMinorColor));
156         for (uint i = 0; i < 3; i++) {
157             byte skillColor = _getPartSkillColor(data, partOffset, i);
158             if (skillColor == eventMajorColor) {
159                 majorSkillSum += _getPartSkillLevel(data, partOffset, i);
160             } else if (skillColor == eventMinorColor) {
161                 minorSkillSum += _getPartSkillLevel(data, partOffset, i);
162             }
163         }
164         byte playerThemeEffect = _getPlayerThemeEffect(data, PLAYER_SIZE * playerIndex);
165         if (playerThemeEffect != 0) {
166             return level + (majorSkillSum * 4) + (minorSkillSum * 2);
167         } else {
168             return level + (majorSkillSum * 3) + (minorSkillSum * 1);
169         }
170     }
171 }
172 
173 contract GoCryptobotRounds is GoCryptobotScore {
174     event RoundFinished(EventType eventType, EventColor eventMajorColor, EventColor eventMinorColor, uint scoreA, uint scoreB, uint scoreC, uint scoreD);
175     event AllFinished(uint scoreA, uint scoreB, uint scoreC, uint scoreD);
176     event WinnerTeam(uint8[4] candidates, uint8 winner);
177 
178     function run(bytes playerData, uint8[4] eventTypes, uint8[2][4] eventColors) public onlyOperator {
179         require(playerData.length == 128 * PLAYER_SIZE);
180 
181         _initRandom();
182 
183         uint8[] memory colorSelection = new uint8[](8);
184         colorSelection[0] = 0;
185         colorSelection[1] = 1;
186         colorSelection[2] = 0;
187         colorSelection[3] = 1;
188         colorSelection[4] = 0;
189         colorSelection[5] = 1;
190         colorSelection[6] = 0;
191         colorSelection[7] = 1;
192 
193         _shuffle(colorSelection);
194 
195         uint[4] memory totalScores;
196         for (uint8 i = 0; i < 4; i++) {
197             uint8 majorColor = eventColors[i][colorSelection[i]];
198             uint8 minorColor = eventColors[i][colorSelection[i]^1];
199             uint[4] memory roundScores = _round(playerData, EventType(eventTypes[i]), EventColor(majorColor), EventColor(minorColor));
200             totalScores[0] += roundScores[0];
201             totalScores[1] += roundScores[1];
202             totalScores[2] += roundScores[2];
203             totalScores[3] += roundScores[3];
204         }
205         AllFinished(totalScores[0], totalScores[1], totalScores[2], totalScores[3]);
206 
207         uint maxScore;
208         uint maxCount;
209         uint8[4] memory candidates;
210         for (i = 0; i < 4; i++) {
211             if (maxScore < totalScores[i]) {
212                 maxScore = totalScores[i];
213                 maxCount = 0;
214                 candidates[maxCount++] = i + 1;
215             } else if (maxScore == totalScores[i]) {
216                 candidates[maxCount++] = i + 1;
217             }
218         }
219         assert(maxCount > 0);
220         if (maxCount == 1) {
221             WinnerTeam(candidates, candidates[0]);
222         } else {
223             WinnerTeam(candidates, candidates[_random256() % maxCount]);
224         }
225     }
226 
227     function _round(bytes memory playerData, EventType eventType, EventColor eventMajorColor, EventColor eventMinorColor) internal returns(uint[4]) {
228         uint numOfPlayers = playerData.length / PLAYER_SIZE;
229         uint[4] memory scores;
230         for (uint i = 0; i < numOfPlayers; i++) {
231             scores[i / (numOfPlayers / 4)] += _getPlayerEventScore(playerData, i, eventType, eventMajorColor, eventMinorColor);
232         }
233         RoundFinished(eventType, eventMajorColor, eventMinorColor, scores[0], scores[1], scores[2], scores[3]);
234         return scores;
235     }
236 }
237 
238 contract GoCryptobotCore is GoCryptobotRounds {
239     function GoCryptobotCore() public {
240         paused = false;
241 
242         owner = msg.sender;
243         operator = msg.sender;
244     }
245 }