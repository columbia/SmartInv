1 pragma solidity ^0.4.16;
2 
3 contract PlayerToken {
4     function totalSupply() public view returns (uint256 total);
5     function balanceOf(address _owner) public view returns (uint balance);
6     function ownerOf(uint256 _tokenId) public view returns (address owner);
7     function approve(address _to, uint256 _tokenId) external;
8     function transfer(address _to, uint256 _tokenId) external;
9     function tokensOfOwner(address _owner) public view returns (uint256[] ownerTokens);
10     function createPlayer(uint32[7] _skills, uint256 _position, address _owner) public returns (uint256);
11     function getPlayer(uint256 playerId) public view returns(uint32 talent, uint32 tactics, uint32 dribbling, uint32 kick,
12        uint32 speed, uint32 pass, uint32 selection);
13     function getPosition(uint256 _playerId) public view returns(uint256);
14 
15     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
16     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
17 }
18 
19 contract CatalogPlayers {
20     function getBoxPrice(uint256 _league, uint256 _position) public view returns (uint256);
21     function getLengthClassPlayers(uint256 _league, uint256 _position) public view returns (uint256);
22     function getClassPlayers(uint256 _league, uint256 _position, uint256 _index) public view returns(uint32[7] skills);
23     function incrementCountSales(uint256 _league, uint256 _position) public;
24     function getCountSales(uint256 _league, uint256 _position) public view returns(uint256);
25 }
26 
27 contract Team {
28     uint256 public countPlayersInPosition;
29     uint256[] public teamsIds;
30 
31     function createTeam(string _name, string _logo, uint256 _minSkills, uint256 _minTalent, address _owner, uint256 _playerId) public returns(uint256 _teamId);
32     function getPlayerTeam(uint256 _playerId) public view returns(uint256);
33     function getOwnerTeam(address _owner) public view returns(uint256);
34     function getCountPlayersOfOwner(uint256 _teamId, address _owner) public view returns(uint256 count);
35     function getCountPosition(uint256 _teamId, uint256 _position) public view returns(uint256);
36     function joinTeam(uint256 _teamId, address _owner, uint256 _playerId, uint256 _position) public;
37     function isTeam(uint256 _teamId) public view returns(bool);
38     function leaveTeam(uint256 _teamId, address _owner, uint256 _playerId, uint256 _position) public;
39     function getTeamPlayers(uint256 _teamId) public view returns(uint256[]);
40     function getCountPlayersOfTeam(uint256 _teamId) public view returns(uint256);
41     function getPlayerIdOfIndex(uint256 _teamId, uint256 index) public view returns (uint256);
42     function getCountTeams() public view returns(uint256);
43     function getTeamSumSkills(uint256 _teamId) public view returns(uint256 sumSkills);
44     function getMinSkills(uint256 _teamId) public view returns(uint256);
45     function getMinTalent(uint256 _teamId)  public view returns(uint256);
46 
47 
48 }
49 
50 contract FMWorldAccessControl {
51     address public ceoAddress;
52     address public cooAddress;
53 
54     bool public pause = false;
55 
56     modifier onlyCEO() {
57         require(msg.sender == ceoAddress);
58         _;
59     }
60 
61     modifier onlyCOO() {
62         require(msg.sender == cooAddress);
63         _;
64     }
65 
66     modifier onlyC() {
67         require(
68             msg.sender == cooAddress ||
69             msg.sender == ceoAddress
70         );
71         _;
72     }
73 
74     modifier notPause() {
75         require(!pause);
76         _;
77     }
78 
79     function setCEO(address _newCEO) external onlyCEO {
80         require(_newCEO != address(0));
81 
82         ceoAddress = _newCEO;
83     }
84 
85     function setCOO(address _newCOO) external onlyCEO {
86         require(_newCOO != address(0));
87 
88         cooAddress = _newCOO;
89     }
90 
91 
92     function setPause(bool _pause) external onlyC {
93         pause = _pause;
94     }
95 
96 
97 }
98 
99 
100 contract FMWorld is FMWorldAccessControl {
101 
102     address public playerTokenAddress;
103     address public catalogPlayersAddress;
104     address public teamAddress;
105 
106     address private lastPlayerOwner = address(0x0);
107 
108     uint256 public balanceForReward;
109     uint256 public deposits;
110     
111     uint256 public countPartnerPlayers;
112 
113     mapping (uint256 => uint256) public balancesTeams;
114     mapping (address => uint256) public balancesInternal;
115 
116     bool public calculatedReward = true;
117     uint256 public lastCalculationRewardTime;
118 
119     modifier isCalculatedReward() {
120         require(calculatedReward);
121         _;
122     }
123 
124     function setPlayerTokenAddress(address _playerTokenAddress) public onlyCEO {
125         playerTokenAddress = _playerTokenAddress;
126     }
127 
128     function setCatalogPlayersAddress(address _catalogPlayersAddress) public onlyCEO {
129         catalogPlayersAddress = _catalogPlayersAddress;
130     }
131 
132     function setTeamAddress(address _teamAddress) public onlyCEO {
133         teamAddress = _teamAddress;
134     }
135 
136     function FMWorld(address _catalogPlayersAddress, address _playerTokenAddress, address _teamAddress) public {
137         catalogPlayersAddress = _catalogPlayersAddress;
138         playerTokenAddress = _playerTokenAddress;
139         teamAddress = _teamAddress;
140 
141         ceoAddress = msg.sender;
142         cooAddress = msg.sender;
143 
144         lastCalculationRewardTime = now;
145     }
146 
147     function openBoxPlayer(uint256 _league, uint256 _position) external notPause isCalculatedReward payable returns (uint256 _price) {
148         if (now > 1525024800) revert();
149         
150         PlayerToken playerToken = PlayerToken(playerTokenAddress);
151         CatalogPlayers catalogPlayers = CatalogPlayers(catalogPlayersAddress);
152 
153         _price = catalogPlayers.getBoxPrice(_league, _position);
154         
155         balancesInternal[msg.sender] += msg.value;
156         if (balancesInternal[msg.sender] < _price) {
157             revert();
158         }
159         balancesInternal[msg.sender] = balancesInternal[msg.sender] - _price;
160 
161         uint256 _classPlayerId = _getRandom(catalogPlayers.getLengthClassPlayers(_league, _position), lastPlayerOwner);
162         uint32[7] memory skills = catalogPlayers.getClassPlayers(_league, _position, _classPlayerId);
163 
164         playerToken.createPlayer(skills, _position, msg.sender);
165         lastPlayerOwner = msg.sender;
166         balanceForReward += msg.value / 2;
167         deposits += msg.value / 2;
168         catalogPlayers.incrementCountSales(_league, _position);
169 
170         if (now - lastCalculationRewardTime > 24 * 60 * 60 && balanceForReward > 10 ether) {
171             calculatedReward = false;
172         }
173     }
174 
175     function _getRandom(uint256 max, address addAddress) view internal returns(uint256) {
176         return (uint256(block.blockhash(block.number-1)) + uint256(addAddress)) % max;
177     }
178     
179     function _requireTalentSkills(uint256 _playerId, PlayerToken playerToken, uint256 _minTalent, uint256 _minSkills) internal view returns(bool) {
180         var (_talent, _tactics, _dribbling, _kick, _speed, _pass, _selection) = playerToken.getPlayer(_playerId);
181         if ((_talent < _minTalent) || (_tactics + _dribbling + _kick + _speed + _pass + _selection < _minSkills)) return false; 
182         return true;
183     }
184 
185     function createTeam(string _name, string _logo, uint32 _minTalent, uint32 _minSkills, uint256 _playerId) external notPause isCalculatedReward
186     {
187         PlayerToken playerToken = PlayerToken(playerTokenAddress);
188         Team team = Team(teamAddress);
189         require(playerToken.ownerOf(_playerId) == msg.sender);
190         require(team.getPlayerTeam(_playerId) == 0);
191         require(team.getOwnerTeam(msg.sender) == 0);
192         require(_requireTalentSkills(_playerId, playerToken, _minTalent, _minSkills));
193         team.createTeam(_name, _logo, _minTalent, _minSkills, msg.sender, _playerId);
194     }
195 
196     function joinTeam(uint256 _playerId, uint256 _teamId) external notPause isCalculatedReward
197     {
198         PlayerToken playerToken = PlayerToken(playerTokenAddress);
199         Team team = Team(teamAddress);
200         require(playerToken.ownerOf(_playerId) == msg.sender);
201         require(team.isTeam(_teamId));
202         require(team.getPlayerTeam(_playerId) == 0);
203         require(team.getOwnerTeam(msg.sender) == 0 || team.getOwnerTeam(msg.sender) == _teamId);
204         uint256 _position = playerToken.getPosition(_playerId);
205         require(team.getCountPosition(_teamId, _position) < team.countPlayersInPosition());
206         require(_requireTalentSkills(_playerId, playerToken, team.getMinTalent(_teamId), team.getMinSkills(_teamId)));
207 
208         _calcTeamBalance(_teamId, team, playerToken);
209         team.joinTeam(_teamId, msg.sender, _playerId, _position);
210     }
211 
212     function leaveTeam(uint256 _playerId, uint256 _teamId) external notPause isCalculatedReward
213     {
214         PlayerToken playerToken = PlayerToken(playerTokenAddress);
215         Team team = Team(teamAddress);
216         require(playerToken.ownerOf(_playerId) == msg.sender);
217         require(team.getPlayerTeam(_playerId) == _teamId);
218         _calcTeamBalance(_teamId, team, playerToken);
219         uint256 _position = playerToken.getPosition(_playerId);
220         team.leaveTeam(_teamId, msg.sender, _playerId, _position);
221     }
222 
223     function withdraw(address _sendTo, uint _amount) external onlyCEO returns(bool) {
224         if (_amount > deposits) {
225             return false;
226         }
227         deposits -= _amount;
228         _sendTo.transfer(_amount);
229         return true;
230     }
231 
232     function _calcTeamBalance(uint256 _teamId, Team team, PlayerToken playerToken) internal returns(bool){
233         if (balancesTeams[_teamId] == 0) {
234             return false;
235         }
236         uint256 _countPlayers = team.getCountPlayersOfTeam(_teamId);
237         for(uint256 i = 0; i < _countPlayers; i++) {
238             uint256 _playerId = team.getPlayerIdOfIndex(_teamId, i);
239             address _owner = playerToken.ownerOf(_playerId);
240             balancesInternal[_owner] += balancesTeams[_teamId] / _countPlayers;
241         }
242         balancesTeams[_teamId] = 0;
243         return true;
244     }
245 
246     function withdrawEther() external returns(bool) {
247         Team team = Team(teamAddress);
248         uint256 _teamId = team.getOwnerTeam(msg.sender);
249         if (balancesTeams[_teamId] > 0) {
250             PlayerToken playerToken = PlayerToken(playerTokenAddress);
251             _calcTeamBalance(_teamId, team, playerToken);
252         }
253         if (balancesInternal[msg.sender] == 0) {
254             return false;
255         }
256         msg.sender.transfer(balancesInternal[msg.sender]);
257         balancesInternal[msg.sender] = 0;
258 
259     }
260     
261     function createPartnerPlayer(uint256 _league, uint256 _position, uint256 _classPlayerId, address _toAddress) external notPause isCalculatedReward onlyC {
262         if (countPartnerPlayers >= 300) revert();
263         
264         PlayerToken playerToken = PlayerToken(playerTokenAddress);
265         CatalogPlayers catalogPlayers = CatalogPlayers(catalogPlayersAddress);
266 
267         uint32[7] memory skills = catalogPlayers.getClassPlayers(_league, _position, _classPlayerId);
268 
269         playerToken.createPlayer(skills, _position, _toAddress);
270         countPartnerPlayers++;
271     }
272 
273     function calculationTeamsRewards(uint256[] orderTeamsIds) public onlyC {
274         Team team = Team(teamAddress);
275         if (team.getCountTeams() < 50) {
276             lastCalculationRewardTime = now;
277             calculatedReward = true;
278             return;
279         }
280         
281         if (orderTeamsIds.length != team.getCountTeams()) { 
282             revert();
283         }
284         
285         for(uint256 teamIndex = 0; teamIndex < orderTeamsIds.length - 1; teamIndex++) {
286             if (team.getTeamSumSkills(orderTeamsIds[teamIndex]) < team.getTeamSumSkills(orderTeamsIds[teamIndex + 1])) {
287                 revert();
288             }
289         }
290         uint256 k;
291         for(uint256 i = 1; i < 51; i++) {
292             if (i == 1) { k = 2000; } 
293             else if (i == 2) { k = 1400; }
294             else if (i == 3) { k = 1000; }
295             else if (i == 4) { k = 600; }
296             else if (i == 5) { k = 500; }
297             else if (i == 6) { k = 400; }
298             else if (i == 7) { k = 300; }
299             else if (i >= 8 && i <= 12) { k = 200; }
300             else if (i >= 13 && i <= 30) { k = 100; }
301             else if (i >= 31) { k = 50; }
302             balancesTeams[orderTeamsIds[i - 1]] = balanceForReward * k / 10000;
303         }
304         balanceForReward = 0;
305         lastCalculationRewardTime = now;
306         calculatedReward = true;
307     }
308 
309     function getSumWithdrawals() public view returns(uint256 sum) {
310         for(uint256 i = 0; i < 51; i++) {
311              sum += balancesTeams[i + 1];
312         }
313     }
314 
315     function getBalance() public view returns (uint256 balance) {
316         uint256 balanceTeam = getBalanceTeam(msg.sender);
317         return balanceTeam + balancesInternal[msg.sender];
318     }
319     
320     function getBalanceTeam(address _owner) public view returns(uint256 balanceTeam) {
321         Team team = Team(teamAddress);
322         uint256 _teamId = team.getOwnerTeam(_owner);
323         if (_teamId == 0) {
324             return 0;
325         }
326         uint256 _countPlayersOwner = team.getCountPlayersOfOwner(_teamId, _owner);
327         uint256 _countPlayers = team.getCountPlayersOfTeam(_teamId);
328         balanceTeam = balancesTeams[_teamId] / _countPlayers * _countPlayersOwner;
329     }
330 
331 }