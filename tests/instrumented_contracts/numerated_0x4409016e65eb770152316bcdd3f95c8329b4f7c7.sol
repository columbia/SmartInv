1 pragma solidity ^0.4.16;
2 
3 contract SafeMath {
4     function safeAdd(uint256 x, uint256 y) pure internal returns(uint256) {
5       uint256 z = x + y;
6       assert((z >= x) && (z >= y));
7       return z;
8     }
9 
10     function safeSubtract(uint256 x, uint256 y) pure internal returns(uint256) {
11       assert(x >= y);
12       uint256 z = x - y;
13       return z;
14     }
15 
16     function safeMult(uint256 x, uint256 y) pure internal returns(uint256) {
17       uint256 z = x * y;
18       assert((x == 0)||(z/x == y));
19       return z;
20     }
21 
22 }
23 
24 contract ERC721 {
25    function totalSupply() public view returns (uint256 total);
26    function balanceOf(address _owner) public view returns (uint balance);
27    function ownerOf(uint256 _tokenId) public view returns (address owner);
28    function approve(address _to, uint256 _tokenId) external;
29    function transfer(address _to, uint256 _tokenId) external;
30    function tokensOfOwner(address _owner) public view returns (uint256[] ownerTokens);
31    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
32    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
33 }
34 
35 contract FMWorldAccessControl {
36     address public ceoAddress;
37     address public cooAddress;
38     
39     bool public pause = false;
40 
41     modifier onlyCEO() {
42         require(msg.sender == ceoAddress);
43         _;
44     }
45 
46     modifier onlyCOO() {
47         require(msg.sender == cooAddress);
48         _;
49     }
50 
51     modifier onlyC() {
52         require(
53             msg.sender == cooAddress ||
54             msg.sender == ceoAddress
55         );
56         _;
57     }
58 
59     modifier notPause() {
60         require(!pause);
61         _;
62     }
63     
64     function setCEO(address _newCEO) external onlyCEO {
65         require(_newCEO != address(0));
66         ceoAddress = _newCEO;
67     }
68     
69     function setCOO(address _newCOO) external onlyCEO {
70         require(_newCOO != address(0));
71 
72         cooAddress = _newCOO;
73     }
74 
75 
76     function setPause(bool _pause) external onlyC {
77         pause = _pause;
78     }
79     
80 
81 }
82 contract PlayerToken is ERC721, FMWorldAccessControl {
83 
84     struct Player {
85         uint32 talent;
86         uint32 tactics;
87         uint32 dribbling;
88         uint32 kick;
89         uint32 speed;
90         uint32 pass;
91         uint32 selection;
92         uint256 position;
93     }
94 
95     string public name = "Football Manager Player";
96     string public symbol = "FMP";
97 
98     Player[] public players;
99 
100     mapping (address => uint256) ownerPlayersCount;
101     mapping (uint256 => address) playerOwners;
102     mapping (uint256 => address) public playerApproved;
103     
104     function PlayerToken() public {
105         ceoAddress = msg.sender;
106         cooAddress = msg.sender;
107     }
108 
109     function balanceOf(address _owner) public view returns (uint256 count) {
110         return ownerPlayersCount[_owner];
111     }
112 
113     function totalSupply() public view returns (uint256) {
114         return players.length;
115     }
116 
117     function ownerOf(uint256 _tokenId) public view returns (address owner) {
118         owner = playerOwners[_tokenId];
119         require(owner != address(0));
120     }
121 
122     function approve(address _to, uint256 _tokenId) external {
123         require(msg.sender == ownerOf(_tokenId));
124         playerApproved[_tokenId] = _to;
125         Approval(msg.sender, _to, _tokenId);
126     }
127 
128     function _transfer(address _from, address _to, uint256 _tokenId) internal {
129         ownerPlayersCount[_to]++;
130         playerOwners[_tokenId] = _to;
131         if (_from != address(0)) {
132             ownerPlayersCount[_from]--;
133             delete playerApproved[_tokenId];
134         }
135         Transfer(_from, _to, _tokenId);
136     }
137 
138     function transfer(address _to, uint256 _tokenId) external {
139         require(_to != address(0));
140         require(msg.sender == ownerOf(_tokenId));
141         _transfer(msg.sender, _to, _tokenId);
142     }
143 
144     function transferFrom(address _from, address _to, uint256 _tokenId) external {
145         require(_to != address(0));
146         require(playerApproved[_tokenId] == msg.sender);
147         require(_from == ownerOf(_tokenId));
148         _transfer(_from, _to, _tokenId);
149     }
150 
151     function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
152         uint256 playersCount = balanceOf(_owner);
153         if (playersCount == 0) {
154             return new uint256[](0);
155         } else {
156             uint256[] memory result = new uint256[](playersCount);
157             uint256 totalPlayers = totalSupply();
158             uint256 playerId;
159             uint256 resultIndex = 0;
160             for (playerId = 1; playerId <= totalPlayers; playerId++) {
161                 if (playerOwners[playerId] == _owner) {
162                     result[resultIndex] = playerId;
163                     resultIndex++;
164                 }
165             }
166             return result;
167         }
168     }
169 
170     function getPlayer(uint256 _playerId) public view returns(
171         uint32 talent,
172         uint32 tactics,
173         uint32 dribbling,
174         uint32 kick,
175         uint32 speed,
176         uint32 pass,
177         uint32 selection,
178         uint256 position
179     ) {
180         Player memory player = players[_playerId];
181         talent = player.talent;
182         tactics = player.tactics;
183         dribbling = player.dribbling;
184         kick = player.kick;
185         speed = player.speed;
186         pass = player.pass;
187         selection = player.selection;
188         position = player.position;
189     }
190 
191     function getPosition(uint256 _playerId) public view returns(uint256) {
192         Player memory player = players[_playerId];
193         return player.position;
194     }
195 
196     function createPlayer(
197             uint32[7] _skills,
198             uint256 _position,
199             address _owner
200     )
201         public onlyCOO
202         returns (uint256)
203     {
204         Player memory player = Player(_skills[0], _skills[1], _skills[2], _skills[3], _skills[4], _skills[5], _skills[6], _position);
205         uint256 newPlayerId = players.push(player) - 1;
206          _transfer(0, _owner, newPlayerId);
207         return newPlayerId;
208     }
209 }