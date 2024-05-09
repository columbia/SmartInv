1 /*! absgoldenmatrix.sol | (c) 2020 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | SPDX-License-Identifier: MIT License */
2 
3 pragma solidity 0.6.12;
4 
5 contract AbsGoldenMatrix {
6     struct Level {
7         uint256 price;
8         uint256 profit;
9     }
10 
11     struct User {
12         uint256 id;
13         address inviter;
14         uint256 level;
15         uint256 profit;
16         uint256 hold;
17         mapping(uint256 => address) uplines;
18         mapping(uint256 => address[]) referrals;
19     }
20 
21     address payable public root;
22     uint256 public last_id;
23 
24     Level[] public levels;
25     mapping(address => User) public users;
26     mapping(uint256 => address) public users_ids;
27 
28     event Register(address indexed addr, address indexed inviter, uint256 id);
29     event LevelUp(address indexed addr, address indexed upline, uint256 level);
30     event Profit(address indexed addr, address indexed referral, uint256 value);
31     event Hold(address indexed addr, address indexed referral, uint256 value);
32 
33     constructor() public {
34         levels.push(Level(0.05 ether, 0.05 ether));
35         levels.push(Level(0.05 ether, 0.05 ether));
36 
37         levels.push(Level(0.15 ether, 0.15 ether));
38         levels.push(Level(0.15 ether, 0.15 ether));
39 
40         levels.push(Level(0.45 ether, 0.45 ether));
41         levels.push(Level(0.45 ether, 0.45 ether));
42         
43         levels.push(Level(1.35 ether, 1.35 ether));
44         levels.push(Level(1.35 ether, 1.35 ether));
45         
46         levels.push(Level(4.05 ether, 4.05 ether));
47         levels.push(Level(4.05 ether, 4.05 ether));
48         
49         levels.push(Level(12.15 ether, 12.15 ether));
50         levels.push(Level(12.15 ether, 12.15 ether));
51         
52         levels.push(Level(36.45 ether, 36.45 ether));
53         levels.push(Level(36.45 ether, 145.75 ether));
54 
55         root = 0xcC16f3dcE95cC295741c2f638c22a43C23a8e009;
56 
57         _newUser(root, address(0), address(0));
58     }
59 
60     receive() payable external {
61         _register(msg.sender, root, msg.value);
62     }
63 
64     fallback() payable external {
65         _register(msg.sender, _bytesToAddress(msg.data), msg.value);
66     }
67 
68     function _send(address _addr, uint256 _value) private {
69         if(_addr == address(0) || !payable(_addr).send(_value)) {
70             root.transfer(_value);
71         }
72     }
73 
74     function _newUser(address _addr, address _inviter, address _upline) private {
75         users[_addr].id = ++last_id;
76         users[_addr].inviter = _inviter;
77         users_ids[last_id] = _addr;
78 
79         emit Register(_addr, _inviter, last_id);
80 
81         _levelUp(_addr, _upline, 0);
82     }
83 
84     function _levelUp(address _addr, address _upline, uint256 _level) private {
85         if(_upline != address(0)) {
86             users[_addr].uplines[_level] = _upline;
87             users[_upline].referrals[_level].push(_addr);
88         }
89 
90         emit LevelUp(_addr, _upline, _level);
91     }
92 
93     function _transferFunds(address _user, address _from, uint256 _amount) private {
94         if(users[_user].profit < levels[users[_user].level % levels.length].profit) {
95             users[_user].profit += _amount;
96             
97             _send(_user, _amount);
98             
99             emit Profit(_user, _from, _amount);
100         }
101         else {
102             users[_user].hold += _amount;
103             
104             emit Hold(_user, _from, _amount);
105 
106             uint256 next_level = users[_user].level + 1;
107 
108             if(users[_user].hold >= levels[next_level % levels.length].price) {
109                 users[_user].hold = 0;
110                 users[_user].level = next_level;
111 
112                 if(_user != root) {
113                     address upline = this.findFreeReferrer(
114                         this.findUplineOffset(
115                             this.findUplineHasLevel(
116                                 users[_user].uplines[0],
117                                 next_level
118                             ),
119                             next_level,
120                             uint8(next_level % 2)
121                         ),
122                         next_level
123                     );
124                     
125                     _levelUp(_user, upline, next_level);
126                 }
127                 else _levelUp(_user, address(0), next_level);
128             }
129 
130             _transferFunds(users[_user].uplines[users[_user].level], _from, _amount);
131         }
132     }
133 
134     function _register(address _user, address _inviter, uint256 _value) private {
135         require(users[_user].id == 0, "User arleady register");
136         require(users[_inviter].id != 0, "Upline not register");
137         require(_value == levels[0].price, "Bad amount");
138 
139         address upline = this.findFreeReferrer(_inviter, 0);
140         
141         _newUser(_user, _inviter, upline);
142         _transferFunds(upline, _user, _value);
143     }
144 
145     function register(uint256 _upline_id) payable external {
146         _register(msg.sender, users_ids[_upline_id], msg.value);
147     }
148 
149     function findUplineHasLevel(address _user, uint256 _level) external view returns(address) {
150         if(_user == root || users[_user].level >= _level) return _user;
151 
152         return this.findUplineHasLevel(users[_user].uplines[0], _level);
153     }
154 
155     function findUplineOffset(address _user, uint256 _level, uint8 _offset) external view returns(address) {
156         if(_user == root || _offset == 0) return _user;
157 
158         return this.findUplineOffset(users[_user].uplines[_level], _level, _offset - 1);
159     }
160 
161     function findFreeReferrer(address _user, uint256 _level) external view returns(address) {
162         if(users[_user].referrals[_level].length < 2) return _user;
163 
164         address[] memory refs = new address[](1024);
165         
166         refs[0] = users[_user].referrals[_level][0];
167         refs[1] = users[_user].referrals[_level][1];
168 
169         for(uint16 i = 0; i < 1024; i++) {
170             if(users[refs[i]].referrals[_level].length < 2) {
171                 return refs[i];
172             }
173 
174             if(i < 511) {
175                 uint16 n = (i + 1) * 2;
176 
177                 refs[n] = users[refs[i]].referrals[_level][0];
178                 refs[n + 1] = users[refs[i]].referrals[_level][1];
179             }
180         }
181 
182         revert("No free referrer");
183     }
184 
185     function _bytesToAddress(bytes memory _data) private pure returns(address addr) {
186         assembly {
187             addr := mload(add(_data, 20))
188         }
189     }
190 }