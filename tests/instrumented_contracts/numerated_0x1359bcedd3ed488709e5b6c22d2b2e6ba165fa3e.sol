1 pragma solidity ^0.4.24;
2 
3 // SafeMath library
4 library SafeMath {
5   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
6 		uint256 c = _a + _b;
7 		assert(c >= _a);
8 		return c;
9 	}
10 
11 	function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
12 		assert(_a >= _b);
13 		return _a - _b;
14 	}
15 
16 	function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
17     if (_a == 0) {
18      return 0;
19     }
20 		uint256 c = _a * _b;
21 		assert(c / _a == _b);
22 		return c;
23 	}
24 
25   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
26 		return _a / _b;
27 	}
28 }
29 
30 // Contract must have an owner
31 contract Ownable {
32   address public owner;
33 
34   constructor() public {
35     owner = msg.sender;
36   }
37 
38   modifier onlyOwner() {
39     require(msg.sender == owner, "onlyOwner wrong");
40     _;
41   }
42 
43   function setOwner(address _owner) onlyOwner public {
44     owner = _owner;
45   }
46 }
47 
48 interface ERC20Token {
49   function transfer(address _to, uint256 _value) external returns (bool);
50   function balanceOf(address _addr) external view returns (uint256);
51   function decimals() external view returns (uint8);
52 }
53 
54 // the WTA Gamebook that records games, players and admins
55 contract WTAGameBook is Ownable{
56   using SafeMath for uint256;
57 
58   string public name = "WTAGameBook V0.5";
59   string public version = "0.5";
60 
61   // admins info
62   address[] public admins;
63   mapping (address => uint256) public adminId;
64 
65   // games info
66   address[] public games;
67   mapping (address => uint256) public gameId;
68 
69   //players info
70   struct PlayerInfo {
71     uint256 pid;
72     address paddr;
73     uint256 referrer;
74   }
75 
76   uint256 public playerNum = 0;
77   mapping (uint256 => PlayerInfo) public player;
78   mapping (address => uint256) public playerId;
79 
80   event AdminAdded(address indexed _addr, uint256 _id, address indexed _adder);
81   event AdminRemoved(address indexed _addr, uint256 _id, address indexed _remover);
82   event GameAdded(address indexed _addr, uint256 _id, address indexed _adder);
83   event GameRemoved(address indexed _addr, uint256 _id, address indexed _remover);
84   event PlayerAdded(uint256 _pid, address indexed _paddr, uint256 _ref, address indexed _adder);
85 
86   event WrongTokenEmptied(address indexed _token, address indexed _addr, uint256 _amount);
87   event WrongEtherEmptied(address indexed _addr, uint256 _amount);
88 
89   // check the address is human or contract
90   function isHuman(address _addr) public view returns (bool) {
91     uint256 _codeLength;
92     assembly {_codeLength := extcodesize(_addr)}
93     return (_codeLength == 0);
94   }
95 
96   // address not zero
97   modifier validAddress(address _addr) {
98 		require(_addr != 0x0, "validAddress wrong");
99 		_;
100 	}
101 
102   modifier onlyAdmin() {
103     require(adminId[msg.sender] != 0, "onlyAdmin wrong");
104     _;
105   }
106 
107   modifier onlyAdminOrGame() {
108     require((adminId[msg.sender] != 0) || (gameId[msg.sender] != 0), "onlyAdminOrGame wrong");
109     _;
110   }
111 
112   // create new GameBook contract, no need arguments
113   constructor() public {
114     // initialization
115     // empty admin with id 0
116     adminId[address(0x0)] = 0;
117     admins.length++;
118     admins[0] = address(0x0);
119 
120     // empty game with id 0
121     gameId[address(0x0)] = 0;
122     games.length++;
123     games[0] = address(0x0);
124 
125     // first admin is owner
126     addAdmin(owner);
127   }
128 
129   // owner may add or remove admins
130   function addAdmin(address _admin) onlyOwner validAddress(_admin) public {
131     require(isHuman(_admin), "addAdmin human only");
132 
133     uint256 id = adminId[_admin];
134     if (id == 0) {
135       adminId[_admin] = admins.length;
136       id = admins.length++;
137     }
138     admins[id] = _admin;
139     emit AdminAdded(_admin, id, msg.sender);
140   }
141 
142   function removeAdmin(address _admin) onlyOwner validAddress(_admin) public {
143     require(adminId[_admin] != 0, "removeAdmin wrong");
144 
145     uint256 aid = adminId[_admin];
146     adminId[_admin] = 0;
147     for (uint256 i = aid; i<admins.length-1; i++){
148         admins[i] = admins[i+1];
149         adminId[admins[i]] = i;
150     }
151     delete admins[admins.length-1];
152     admins.length--;
153     emit AdminRemoved(_admin, aid, msg.sender);
154   }
155 
156   // admins may add or remove games
157   function addGame(address _game) onlyAdmin validAddress(_game) public {
158     require(!isHuman(_game), "addGame inhuman only");
159 
160     uint256 id = gameId[_game];
161     if (id == 0) {
162       gameId[_game] = games.length;
163       id = games.length++;
164     }
165     games[id] = _game;
166     emit GameAdded(_game, id, msg.sender);
167   }
168 
169   function removeGame(address _game) onlyAdmin validAddress(_game) public {
170     require(gameId[_game] != 0, "removeGame wrong");
171 
172     uint256 gid = gameId[_game];
173     gameId[_game] = 0;
174     for (uint256 i = gid; i<games.length-1; i++){
175         games[i] = games[i+1];
176         gameId[games[i]] = i;
177     }
178     delete games[games.length-1];
179     games.length--;
180     emit GameRemoved(_game, gid, msg.sender);
181   }
182 
183   // admins and games may add players, and players cannot be removed
184   function addPlayer(address _addr, uint256 _ref) onlyAdminOrGame validAddress(_addr) public returns (uint256) {
185     require(isHuman(_addr), "addPlayer human only");
186     require((_ref < playerNum.add(1)) && (playerId[_addr] == 0), "addPlayer parameter wrong");
187     playerId[_addr] = playerNum.add(1);
188     player[playerNum.add(1)] = PlayerInfo({pid: playerNum.add(1), paddr: _addr, referrer: _ref});
189     playerNum++;
190     emit PlayerAdded(playerNum, _addr, _ref, msg.sender);
191     return playerNum;
192   }
193 
194   // interface methods
195   function getPlayerIdByAddress(address _addr) validAddress(_addr) public view returns (uint256) {
196     return playerId[_addr];
197   }
198 
199   function getPlayerAddressById(uint256 _id) public view returns (address) {
200     require(_id <= playerNum && _id > 0, "getPlayerAddressById wrong");
201     return player[_id].paddr;
202   }
203 
204   function getPlayerRefById(uint256 _id) public view returns (uint256) {
205     require(_id <= playerNum && _id > 0, "getPlayerRefById wrong");
206     return player[_id].referrer;
207   }
208 
209   function getGameIdByAddress(address _addr) validAddress(_addr) public view returns (uint256) {
210     return gameId[_addr];
211   }
212 
213   function getGameAddressById(uint256 _id) public view returns (address) {
214     require(_id < games.length && _id > 0, "getGameAddressById wrong");
215     return games[_id];
216   }
217 
218   function isAdmin(address _addr) validAddress(_addr) public view returns (bool) {
219     return (adminId[_addr] > 0);
220   }
221 
222   // Safety measures
223   function () public payable {
224     revert();
225   }
226 
227   function emptyWrongToken(address _addr) onlyAdmin public {
228     ERC20Token wrongToken = ERC20Token(_addr);
229     uint256 amount = wrongToken.balanceOf(address(this));
230     require(amount > 0, "emptyToken need more balance");
231     require(wrongToken.transfer(msg.sender, amount), "empty Token transfer wrong");
232 
233     emit WrongTokenEmptied(_addr, msg.sender, amount);
234   }
235 
236   // shouldn't happen, just in case
237   function emptyWrongEther() onlyAdmin public {
238     uint256 amount = address(this).balance;
239     require(amount > 0, "emptyEther need more balance");
240     msg.sender.transfer(amount);
241 
242     emit WrongEtherEmptied(msg.sender, amount);
243   }
244 
245 }