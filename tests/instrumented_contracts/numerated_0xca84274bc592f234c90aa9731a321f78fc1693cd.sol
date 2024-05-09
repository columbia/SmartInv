1 pragma solidity 0.6.12;
2 
3 contract AbsGoldenMatrix1{
4     struct Level {
5         uint256 price;
6         uint256 profit;
7     }
8 
9     struct User {
10         uint256 id;
11         address inviter;
12         uint256 level;
13         uint256 profit;
14         uint256 hold;
15         mapping(uint256 => address) uplines;
16         mapping(uint256 => address[]) referrals;
17     }
18 
19     address public owner;
20     bool public sync_close;
21 
22     address payable public root;
23     uint256 public last_id;
24 
25     Level[] public levels;
26     mapping(address => User) public users;
27     mapping(uint256 => address) public users_ids;
28 
29     event Register(address indexed addr, address indexed inviter, uint256 id);
30     event LevelUp(address indexed addr, address indexed upline, uint256 level);
31     event Profit(address indexed addr, address indexed referral, uint256 value);
32     event Hold(address indexed addr, address indexed referral, uint256 value);
33 
34     constructor() public {
35         owner = msg.sender;
36 
37         levels.push(Level(0.05 ether, 0.05 ether));
38         levels.push(Level(0.05 ether, 0.05 ether));
39 
40         levels.push(Level(0.15 ether, 0.15 ether));
41         levels.push(Level(0.15 ether, 0.15 ether));
42 
43         levels.push(Level(0.45 ether, 0.45 ether));
44         levels.push(Level(0.45 ether, 0.45 ether));
45         
46         levels.push(Level(1.35 ether, 1.35 ether));
47         levels.push(Level(1.35 ether, 1.35 ether));
48         
49         levels.push(Level(4.05 ether, 4.05 ether));
50         levels.push(Level(4.05 ether, 4.05 ether));
51         
52         levels.push(Level(12.15 ether, 12.15 ether));
53         levels.push(Level(12.15 ether, 12.15 ether));
54         
55         levels.push(Level(36.45 ether, 36.45 ether));
56         levels.push(Level(36.45 ether, 145.75 ether));
57 
58         root = 0xcC16f3dcE95cC295741c2f638c22a43C23a8e009;
59 
60         _newUser(root, address(0), address(0));
61     }
62 
63     receive() payable external {
64         _register(msg.sender, root, msg.value);
65     }
66 
67     fallback() payable external {
68         _register(msg.sender, _bytesToAddress(msg.data), msg.value);
69     }
70 
71     function _send(address _addr, uint256 _value) private {
72         if(!sync_close) return;
73 
74         if(_addr == address(0) || !payable(_addr).send(_value)) {
75             root.transfer(_value);
76         }
77     }
78 
79     function _newUser(address _addr, address _inviter, address _upline) private {
80         users[_addr].id = ++last_id;
81         users[_addr].inviter = _inviter;
82         users_ids[last_id] = _addr;
83 
84         emit Register(_addr, _inviter, last_id);
85 
86         _levelUp(_addr, _upline, 0);
87     }
88 
89     function _levelUp(address _addr, address _upline, uint256 _level) private {
90         if(_upline != address(0)) {
91             users[_addr].uplines[_level] = _upline;
92             users[_upline].referrals[_level].push(_addr);
93         }
94 
95         emit LevelUp(_addr, _upline, _level);
96     }
97 
98     function _transferFunds(address _user, address _from, uint256 _amount) private {
99         if(users[_user].profit < levels[users[_user].level % levels.length].profit) {
100             users[_user].profit += _amount;
101             
102             _send(_user, _amount);
103             
104             emit Profit(_user, _from, _amount);
105         }
106         else {
107             users[_user].hold += _amount;
108             
109             emit Hold(_user, _from, _amount);
110 
111             uint256 next_level = users[_user].level + 1;
112 
113             if(users[_user].hold >= levels[next_level % levels.length].price) {
114                 users[_user].profit = 0;
115                 users[_user].hold = 0;
116                 users[_user].level = next_level;
117 
118                 if(_user != root) {
119                     address upline = this.findFreeReferrer(
120                         this.findUplineOffset(
121                             this.findUplineHasLevel(
122                                 users[_user].uplines[0],
123                                 next_level
124                             ),
125                             next_level,
126                             uint8(next_level % 2)
127                         ),
128                         next_level
129                     );
130                     
131                     _levelUp(_user, upline, next_level);
132                 }
133                 else _levelUp(_user, address(0), next_level);
134             }
135 
136             _transferFunds(users[_user].uplines[users[_user].level], _from, _amount);
137         }
138     }
139 
140     function _register(address _user, address _inviter, uint256 _value) private {
141         require(users[_user].id == 0, "User arleady register");
142         require(users[_inviter].id != 0, "Upline not register");
143         require(_value == levels[0].price, "Bad amount");
144 
145         address upline = this.findFreeReferrer(_inviter, 0);
146         
147         _newUser(_user, _inviter, upline);
148         _transferFunds(upline, _user, _value);
149     }
150 
151     function register(uint256 _upline_id) payable external {
152         _register(msg.sender, users_ids[_upline_id], msg.value);
153     }
154 
155     function findUplineHasLevel(address _user, uint256 _level) external view returns(address) {
156         if(_user == root || users[_user].level >= _level) return _user;
157 
158         return this.findUplineHasLevel(users[_user].uplines[0], _level);
159     }
160 
161     function findUplineOffset(address _user, uint256 _level, uint8 _offset) external view returns(address) {
162         if(_user == root || _offset == 0) return _user;
163 
164         return this.findUplineOffset(users[_user].uplines[_level], _level, _offset - 1);
165     }
166 
167     function findFreeReferrer(address _user, uint256 _level) external view returns(address) {
168         if(users[_user].referrals[_level].length < 2) return _user;
169 
170         address[] memory refs = new address[](1024);
171         
172         refs[0] = users[_user].referrals[_level][0];
173         refs[1] = users[_user].referrals[_level][1];
174 
175         for(uint16 i = 0; i < 1024; i++) {
176             if(users[refs[i]].referrals[_level].length < 2) {
177                 return refs[i];
178             }
179 
180             if(i < 511) {
181                 uint16 n = (i + 1) * 2;
182 
183                 refs[n] = users[refs[i]].referrals[_level][0];
184                 refs[n + 1] = users[refs[i]].referrals[_level][1];
185             }
186         }
187 
188         revert("No free referrer");
189     }
190 
191     function _bytesToAddress(bytes memory _data) private pure returns(address addr) {
192         assembly {
193             addr := mload(add(_data, 20))
194         }
195     }
196 
197     /*
198         Only sync functions
199     */
200     function sync(address[] calldata _users, address[] calldata _inviters) external {
201         require(msg.sender == owner, "Only owner");
202         require(!sync_close, "Sync already close");
203         
204         for(uint256 i = 0; i < _users.length; i++) {
205             _register(_users[i], _inviters[i], 0.05 ether);
206         }
207     }
208 
209     function syncClose() external {
210         require(msg.sender == owner, "Only owner");
211         require(!sync_close, "Sync already close");
212 
213         sync_close = true;
214     }
215 }