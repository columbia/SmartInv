1 /*! binar.sol | (c) 2020 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | SPDX-License-Identifier: MIT License */
2 
3 pragma solidity 0.6.8;
4 
5 contract Binar {
6     struct User {
7         uint256 id;
8         address inviter;
9         uint256 balance;
10         mapping(uint8 => uint40) expires;
11         mapping(uint8 => address) uplines;
12         mapping(uint8 => address[]) referrals;
13     }
14 
15     uint40 public LEVEL_TIME_LIFE = 120 days;
16 
17     address payable public root;
18     uint256 public last_id;
19 
20     uint256[] public levels;
21     mapping(address => User) public users;
22     mapping(uint256 => address) public users_ids;
23 
24     event Register(address indexed addr, address indexed inviter, uint256 id);
25     event BuyLevel(address indexed addr, address indexed upline, uint8 level, uint40 expires);
26     event Profit(address indexed addr, address indexed referral, uint256 value);
27     event Lost(address indexed addr, address indexed referral, uint256 value);
28 
29     constructor() public {
30         levels.push(0.11 ether);
31         levels.push(0.15 ether);
32         levels.push(0.41 ether);
33 
34         levels.push(0.22 ether);
35         levels.push(0.32 ether);
36         levels.push(0.82 ether);
37 
38         levels.push(0.43 ether);
39         levels.push(0.63 ether);
40         levels.push(1.63 ether);
41         
42         levels.push(0.84 ether);
43         levels.push(1.24 ether);
44         levels.push(3.24 ether);
45         
46         levels.push(1.65 ether);
47         levels.push(2.45 ether);
48         levels.push(6.45 ether);
49         
50         levels.push(3.26 ether);
51         levels.push(4.96 ether);
52         levels.push(12.86 ether);
53         
54         levels.push(6.47 ether);
55         levels.push(9.87 ether);
56         levels.push(25.67 ether);
57         
58         levels.push(12.88 ether);
59         levels.push(19.78 ether);
60         levels.push(51.28 ether);
61         
62         levels.push(25.69 ether);
63         levels.push(39.59 ether);
64         levels.push(102.49 ether);
65         
66         levels.push(51.30 ether);
67         levels.push(79.20 ether);
68         levels.push(205.20 ether);
69 
70         root = 0xbF49F4ffdf874d4A80A2F3fc22173Bd82C8e2893;
71 
72         _newUser(root, address(0));
73 
74         for(uint8 i = 0; i < levels.length; i++) {
75             users[root].expires[i] = uint40(-1);
76 
77             emit BuyLevel(root, address(0), i, users[root].expires[i]);
78         }
79     }
80 
81     receive() payable external {
82         require(users[msg.sender].id > 0, "User not register");
83         
84         users[msg.sender].balance += msg.value;
85 
86         _autoBuyLevel(msg.sender);
87     }
88 
89     fallback() payable external {
90         _register(msg.sender, bytesToAddress(msg.data), msg.value);
91     }
92 
93     function _newUser(address _addr, address _inviter) private {
94         users[_addr].id = ++last_id;
95         users[_addr].inviter = _inviter;
96         users_ids[last_id] = _addr;
97 
98         emit Register(_addr, _inviter, last_id);
99     }
100 
101     function _buyLevel(address _user, uint8 _level) private {
102         require(levels[_level] > 0, "Invalid level");
103         require(users[_user].balance >= levels[_level], "Insufficient funds");
104         require(_level == 0 || users[_user].expires[_level - 1] > block.timestamp, "Need previous level");
105         
106         users[_user].balance -= levels[_level];
107         users[_user].expires[_level] = uint40((users[_user].expires[_level] > block.timestamp ? users[_user].expires[_level] : block.timestamp) + LEVEL_TIME_LIFE);
108         
109         uint8 round = _level / 3;
110         uint8 offset = _level % 3;
111         address upline = users[_user].inviter;
112 
113         if(users[_user].uplines[round] == address(0)) {
114             while(users[upline].expires[_level] < block.timestamp) {
115                 emit Lost(upline, _user, levels[_level]);
116 
117                 upline = users[upline].inviter;
118             }
119 
120             upline = this.findFreeReferrer(upline, round);
121 
122             users[_user].uplines[round] = upline;
123             users[upline].referrals[round].push(_user);
124         }
125         else upline = users[_user].uplines[round];
126 
127         address profiter = this.findUpline(upline, round, offset);
128 
129         uint256 value = levels[_level];
130 
131         if(_level == 0) {
132             uint256 com = value / 10;
133 
134             if(payable(users[_user].inviter).send(com)) {
135                 value -= com;
136                 
137                 emit Profit(users[_user].inviter, _user, com);
138             }
139         }
140 
141         users[profiter].balance += value;
142         _autoBuyLevel(profiter);
143         
144         emit Profit(profiter, _user, value);
145         emit BuyLevel(_user, upline, _level, users[_user].expires[_level]);
146     }
147 
148     function _autoBuyLevel(address _user) private {
149         for(uint8 i = 0; i < levels.length; i++) {
150             if(levels[i] > users[_user].balance) break;
151 
152             if(users[_user].expires[i] < block.timestamp) {
153                 _buyLevel(_user, i);
154             }
155         }
156     }
157 
158     function _register(address _user, address _upline, uint256 _value) private {
159         require(users[_user].id == 0, "User arleady register");
160         require(users[_upline].id != 0, "Upline not register");
161         require(_value >= levels[0], "Insufficient funds");
162         
163         users[_user].balance += _value;
164 
165         _newUser(_user, _upline);
166         _buyLevel(_user, 0);
167     }
168 
169     function register(uint256 _upline_id) payable external {
170         _register(msg.sender, users_ids[_upline_id], msg.value);
171     }
172 
173     function buy(uint8 _level) payable external {
174         require(users[msg.sender].id > 0, "User not register");
175         
176         users[msg.sender].balance += msg.value;
177 
178         _buyLevel(msg.sender, _level);
179     }
180 
181     function withdraw(uint256 _value) payable external {
182         require(users[msg.sender].id > 0, "User not register");
183 
184         _value = _value > 0 ? _value : users[msg.sender].balance;
185 
186         require(_value <= users[msg.sender].balance, "Insufficient funds");
187         
188         users[msg.sender].balance -= _value;
189 
190         if(!payable(msg.sender).send(_value)) {
191             root.transfer(_value);
192         }
193     }
194 
195     function destruct() external {
196         require(msg.sender == root, "Access denied");
197 
198         selfdestruct(root);
199     }
200 
201     function findUpline(address _user, uint8 _round, uint8 _offset) external view returns(address) {
202         if(_user == root || _offset == 0) return _user;
203 
204         return this.findUpline(users[_user].uplines[_round], _round, _offset - 1);
205     }
206 
207     function findFreeReferrer(address _user, uint8 _round) external view returns(address) {
208         if(users[_user].referrals[_round].length < 2) return _user;
209 
210         address[] memory refs = new address[](1024);
211         
212         refs[0] = users[_user].referrals[_round][0];
213         refs[1] = users[_user].referrals[_round][1];
214 
215         for(uint16 i = 0; i < 1024; i++) {
216             if(users[refs[i]].referrals[_round].length < 2) {
217                 return refs[i];
218             }
219 
220             if(i < 511) {
221                 uint16 n = (i + 1) * 2;
222 
223                 refs[n] = users[refs[i]].referrals[_round][0];
224                 refs[n + 1] = users[refs[i]].referrals[_round][1];
225             }
226         }
227 
228         revert("No free referrer");
229     }
230 
231     function bytesToAddress(bytes memory _data) private pure returns(address addr) {
232         assembly {
233             addr := mload(add(_data, 20))
234         }
235     }
236 }