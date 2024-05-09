1 pragma solidity ^0.4.16;
2 
3 contract PlayerToken {
4     function totalSupply() public view returns (uint256 total);
5     function balanceOf(address _owner) public view returns (uint balance);
6     function ownerOf(uint256 _tokenId) public view returns (address owner);
7     function approve(address _to, uint256 _tokenId) external;
8     function transfer(address _to, uint256 _tokenId) external;
9     function tokensOfOwner(address _owner) external view returns (uint256[] ownerTokens);
10     function createPlayer(uint32[7] _skills, uint256 _position, address _owner) public returns (uint256);
11     function getPlayer(uint256 playerId) public view returns(uint32 talent, uint32 tactics, uint32 dribbling, uint32 kick,
12        uint32 speed, uint32 pass, uint32 selection);
13     function getPosition(uint256 _playerId) public view returns(uint256);
14 
15     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
16     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
17 }
18 
19 
20 contract FMWorldAccessControl {
21     address public ceoAddress;
22     address public cooAddress;
23 
24     bool public pause = false;
25 
26     modifier onlyCEO() {
27         require(msg.sender == ceoAddress);
28         _;
29     }
30 
31     modifier onlyCOO() {
32         require(msg.sender == cooAddress);
33         _;
34     }
35 
36     modifier onlyC() {
37         require(
38             msg.sender == cooAddress ||
39             msg.sender == ceoAddress
40         );
41         _;
42     }
43 
44     modifier notPause() {
45         require(!pause);
46         _;
47     }
48 
49     function setCEO(address _newCEO) external onlyCEO {
50         require(_newCEO != address(0));
51 
52         ceoAddress = _newCEO;
53     }
54 
55     function setCOO(address _newCOO) external onlyCEO {
56         require(_newCOO != address(0));
57 
58         cooAddress = _newCOO;
59     }
60 
61 
62     function setPause(bool _pause) external onlyC {
63         pause = _pause;
64     }
65 
66 
67 }
68 
69 
70 contract Team is FMWorldAccessControl
71 {
72     struct TeamStruct {
73         string name;
74         string logo;
75         uint256[] playersIds;
76         uint256 minSkills;
77         uint256 minTalent;
78         mapping(uint256 => uint256) countPositions;
79     }
80 
81     uint256 public countPlayersInPosition;
82 
83     mapping(uint256 => TeamStruct) public teams;
84 
85     uint256[] public teamsIds;
86 
87     mapping (uint256 => uint256) mapPlayerTeam;
88 
89     mapping (address => uint256) mapOwnerTeam;
90 
91     address public playerTokenAddress;
92 
93     function Team(address _playerTokenAddress) public {
94         countPlayersInPosition = 4;
95         playerTokenAddress = _playerTokenAddress;
96 
97         ceoAddress = msg.sender;
98         cooAddress = msg.sender;
99     }
100 
101     function setName(uint256 _teamId, string _name) external onlyCEO {
102         teams[_teamId].name = _name;
103     }
104 
105     function setLogo(uint256 _teamId, string _logo) external onlyCEO {
106         teams[_teamId].logo = _logo;
107     }
108 
109 
110     function getTeamSumSkills(uint256 _teamId) public view returns(uint256 sumSkills) {
111         PlayerToken playerToken = PlayerToken(playerTokenAddress);
112         uint256 l = teams[_teamId].playersIds.length;
113         for (uint256 _playerIndex = 0; _playerIndex < l; _playerIndex++) {
114             var (_talent, _tactics, _dribbling, _kick, _speed, _pass, _selection) = playerToken.getPlayer(teams[_teamId].playersIds[_playerIndex]);
115             sumSkills +=  _tactics + _dribbling + _kick + _speed + _pass + _selection;
116         }
117     }
118 
119     function setPlayerTokenAddress(address _playerTokenAddress) public onlyCEO {
120         playerTokenAddress = _playerTokenAddress;
121     }
122 
123     function getPlayerIdOfIndex(uint256 _teamId, uint256 index) public view returns (uint256) {
124         return teams[_teamId].playersIds[index];
125     }
126 
127     function getCountTeams() public view returns(uint256) {
128         return teamsIds.length;
129     }
130 
131     function getAllTeamsIds() public view returns(uint256[]) {
132         return teamsIds;
133     }
134 
135     function setCountPlayersInPosition(uint256 _countPlayersInPosition) public onlyCEO {
136         countPlayersInPosition = _countPlayersInPosition;
137     }
138     
139     function getMinSkills(uint256 _teamId) public view returns(uint256) {
140         return teams[_teamId].minSkills;
141     }
142     
143     function getMinTalent(uint256 _teamId)  public view returns(uint256) {
144         return teams[_teamId].minTalent;
145     }
146 
147     function getTeam(uint256 _teamId) public view returns(string _name, string _logo, uint256 _minSkills, uint256 _minTalent,
148         uint256 _countPlayers, uint256 _countPositionsGk, uint256 _countPositionsDf, uint256 _countPositionsMd, uint256 _countPositionsFw) {
149         _name = teams[_teamId].name;
150         _logo = teams[_teamId].logo;
151         _minSkills = teams[_teamId].minSkills;
152         _minTalent = teams[_teamId].minTalent;
153         _countPlayers = teams[_teamId].playersIds.length;
154         _countPositionsGk = teams[_teamId].countPositions[1];
155         _countPositionsDf = teams[_teamId].countPositions[2];
156         _countPositionsMd = teams[_teamId].countPositions[3];
157         _countPositionsFw = teams[_teamId].countPositions[4];
158     }
159 
160     function createTeam(string _name, string _logo, uint256 _minTalent, uint256 _minSkills, address _owner, uint256 _playerId) public onlyCOO returns(uint256 _teamId) {
161         _teamId = teamsIds.length + 1;
162         PlayerToken playerToken = PlayerToken(playerTokenAddress);
163         uint256 _position = playerToken.getPosition(_playerId);
164         teams[_teamId].name = _name;
165         teams[_teamId].minSkills = _minSkills;
166         teams[_teamId].minTalent = _minTalent;
167         teams[_teamId].logo = _logo;
168         teamsIds.push(_teamId);
169         _addOwnerPlayerToTeam(_teamId, _owner, _playerId, _position);
170     }
171 
172     function getPlayerTeam(uint256 _playerId) public view returns(uint256) {
173         return mapPlayerTeam[_playerId];
174     }
175 
176     function getOwnerTeam(address _owner) public view returns(uint256) {
177         return mapOwnerTeam[_owner];
178     }
179 
180     function isTeam(uint256 _teamId) public view returns(bool) {
181         if (teams[_teamId].minTalent == 0) {
182             return false;
183         }
184         return true;
185     }
186 
187     function getTeamPlayers(uint256 _teamId) public view returns(uint256[]) {
188         return teams[_teamId].playersIds;
189     }
190 
191     function getCountPlayersOfOwner(uint256 _teamId, address _owner) public view returns(uint256 count) {
192         PlayerToken playerToken = PlayerToken(playerTokenAddress);
193         for (uint256 i = 0; i < teams[_teamId].playersIds.length; i++) {
194             if (playerToken.ownerOf(teams[_teamId].playersIds[i]) == _owner) {
195                 count++;
196             }
197         }
198     }
199 
200     function getCountPlayersOfTeam(uint256 _teamId) public view returns(uint256) {
201         return teams[_teamId].playersIds.length;
202     }
203 
204     function getCountPosition(uint256 _teamId, uint256 _position) public view returns(uint256) {
205         return teams[_teamId].countPositions[_position];
206     }
207 
208 
209     function _addOwnerPlayerToTeam(uint256 _teamId, address _owner, uint256 _playerId, uint256 _position) internal {
210         teams[_teamId].playersIds.push(_playerId);
211         teams[_teamId].countPositions[_position] += 1;
212         mapOwnerTeam[_owner] = _teamId;
213         mapPlayerTeam[_playerId] = _teamId;
214     }
215 
216     function joinTeam(uint256 _teamId, address _owner, uint256 _playerId, uint256 _position) public onlyCOO {
217         _addOwnerPlayerToTeam(_teamId, _owner, _playerId, _position);
218     }
219 
220     function leaveTeam(uint256 _teamId, address _owner, uint256 _playerId, uint256 _position) public onlyCOO {
221         PlayerToken playerToken = PlayerToken(playerTokenAddress);
222 
223         delete mapPlayerTeam[_playerId];
224         //
225 
226         teams[_teamId].countPositions[_position] -= 1;
227         //
228 
229         for (uint256 i = 0; i < teams[_teamId].playersIds.length; i++) {
230             if (teams[_teamId].playersIds[i] == _playerId) {
231                 _removePlayer(_teamId, i);
232                 break;
233             }
234         }
235 
236         bool isMapOwnerTeamDelete = true;
237         for (uint256 pl = 0; pl < teams[_teamId].playersIds.length; pl++) {
238             if (_owner == playerToken.ownerOf(teams[_teamId].playersIds[pl])) {
239                 isMapOwnerTeamDelete = false;
240                 break;
241             }
242         }
243 
244         if (isMapOwnerTeamDelete) {
245             delete mapOwnerTeam[_owner];
246         }
247     }
248 
249     function _removePlayer(uint256 _teamId, uint256 index) internal {
250         if (index >= teams[_teamId].playersIds.length) return;
251 
252         for (uint i = index; i<teams[_teamId].playersIds.length-1; i++){
253             teams[_teamId].playersIds[i] = teams[_teamId].playersIds[i+1];
254         }
255         delete teams[_teamId].playersIds[teams[_teamId].playersIds.length-1];
256         teams[_teamId].playersIds.length--;
257     }
258 
259 
260 
261 }