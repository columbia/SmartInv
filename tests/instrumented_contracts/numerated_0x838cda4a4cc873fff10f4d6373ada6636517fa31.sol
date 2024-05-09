1 pragma solidity ^0.4.16;
2 
3 // copyright contact@Etheremon.com
4 
5 contract BasicAccessControl {
6     address public owner;
7     // address[] public moderators;
8     uint16 public totalModerators = 0;
9     mapping (address => bool) public moderators;
10     bool public isMaintaining = true;
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
57 
58 contract EtheremonRankData is BasicAccessControl {
59 
60     struct PlayerData {
61         address trainer;
62         uint32 point;
63         uint32 energy;
64         uint lastClaim;
65         uint32 totalWin;
66         uint32 totalLose;
67         uint64[6] monsters;
68     }
69     
70     mapping(uint32 => PlayerData) players;
71     mapping(address => uint32) playerIds;
72     
73     uint32 public totalPlayer = 0;
74     uint32 public startingPoint = 1200;
75     
76     // only moderators
77     /*
78     TO AVOID ANY BUGS, WE ALLOW MODERATORS TO HAVE PERMISSION TO ALL THESE FUNCTIONS AND UPDATE THEM IN EARLY BETA STAGE.
79     AFTER THE SYSTEM IS STABLE, WE WILL REMOVE OWNER OF THIS SMART CONTRACT AND ONLY KEEP ONE MODERATOR WHICH IS ETHEREMON BATTLE CONTRACT.
80     HENCE, THE DECENTRALIZED ATTRIBUTION IS GUARANTEED.
81     */
82     
83     function updateConfig(uint32 _startingPoint) onlyModerators external {
84         startingPoint = _startingPoint;
85     }
86     
87     function setPlayer(address _trainer, uint64 _a0, uint64 _a1, uint64 _a2, uint64 _s0, uint64 _s1, uint64 _s2) onlyModerators external returns(uint32 playerId){
88         require(_trainer != address(0));
89         playerId = playerIds[_trainer];
90         
91         bool isNewPlayer = false;
92         if (playerId == 0) {
93             totalPlayer += 1;
94             playerId = totalPlayer;
95             playerIds[_trainer] = playerId;
96             isNewPlayer = true;
97         }
98         
99         PlayerData storage player = players[playerId];
100         if (isNewPlayer)
101             player.point = startingPoint;
102         player.trainer = _trainer;
103         player.monsters[0] = _a0;
104         player.monsters[1] = _a1;
105         player.monsters[2] = _a2;
106         player.monsters[3] = _s0;
107         player.monsters[4] = _s1;
108         player.monsters[5] = _s2;
109     }
110     
111     function updatePlayerPoint(uint32 _playerId, uint32 _totalWin, uint32 _totalLose, uint32 _point) onlyModerators external {
112         PlayerData storage player = players[_playerId];
113         player.point = _point;
114         player.totalWin = _totalWin;
115         player.totalLose = _totalLose;
116     }
117     
118     function updateEnergy(uint32 _playerId, uint32 _energy, uint _lastClaim) onlyModerators external {
119         PlayerData storage player = players[_playerId];
120         player.energy = _energy;
121         player.lastClaim = _lastClaim;
122     }
123     
124     // read access 
125     function getPlayerData(uint32 _playerId) constant external returns(address trainer, uint32 totalWin, uint32 totalLose, uint32 point, 
126         uint64 a0, uint64 a1, uint64 a2, uint64 s0, uint64 s1, uint64 s2, uint32 energy, uint lastClaim) {
127         PlayerData memory player = players[_playerId];
128         return (player.trainer, player.totalWin, player.totalLose, player.point, player.monsters[0], player.monsters[1], player.monsters[2], 
129             player.monsters[3], player.monsters[4], player.monsters[5], player.energy, player.lastClaim);
130     }
131     
132     function getPlayerDataByAddress(address _trainer) constant external returns(uint32 playerId, uint32 totalWin, uint32 totalLose, uint32 point,
133         uint64 a0, uint64 a1, uint64 a2, uint64 s0, uint64 s1, uint64 s2, uint32 energy, uint lastClaim) {
134         playerId = playerIds[_trainer];
135         PlayerData memory player = players[playerId];
136         totalWin = player.totalWin;
137         totalLose = player.totalLose;
138         point = player.point;
139         a0 = player.monsters[0];
140         a1 = player.monsters[1];
141         a2 = player.monsters[2];
142         s0 = player.monsters[3];
143         s1 = player.monsters[4];
144         s2 = player.monsters[5];
145         energy = player.energy;
146         lastClaim = player.lastClaim;
147     }
148     
149     function isOnBattle(address _trainer, uint64 _objId) constant external returns(bool) {
150         uint32 playerId = playerIds[_trainer];
151         if (playerId == 0)
152             return false;
153         PlayerData memory player = players[playerId];
154         for (uint i = 0; i < player.monsters.length; i++)
155             if (player.monsters[i] == _objId)
156                 return true;
157         return false;
158     }
159 
160     function getPlayerPoint(uint32 _playerId) constant external returns(address trainer, uint32 totalWin, uint32 totalLose, uint32 point) {
161         PlayerData memory player = players[_playerId];
162         return (player.trainer, player.totalWin, player.totalLose, player.point);
163     }
164     
165     function getPlayerId(address _trainer) constant external returns(uint32 playerId) {
166         return playerIds[_trainer];
167     }
168 
169     function getPlayerEnergy(uint32 _playerId) constant external returns(address trainer, uint32 energy, uint lastClaim) {
170         PlayerData memory player = players[_playerId];
171         trainer = player.trainer;
172         energy = player.energy;
173         lastClaim = player.lastClaim;
174     }
175     
176     function getPlayerEnergyByAddress(address _trainer) constant external returns(uint32 playerId, uint32 energy, uint lastClaim) {
177         playerId = playerIds[_trainer];
178         PlayerData memory player = players[playerId];
179         energy = player.energy;
180         lastClaim = player.lastClaim;
181     }
182 }