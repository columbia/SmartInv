1 pragma solidity ^0.6.7;
2 
3 contract FastMatrix {
4     struct User {
5         uint256 id;
6         address inviter;
7         uint256 balance;
8         uint256 profit;
9         mapping(uint8 => uint40) expires;
10         mapping(uint8 => address) uplines;
11         mapping(uint8 => address[]) referrals;
12     }
13 
14     uint40 public LEVEL_TIME_LIFE = 1 << 37;
15     bool step_1 = false;
16     bool step_2 = false;
17 
18     address payable owner;
19 
20     address payable public root;
21     address[6] private refss;
22     uint256 public last_id;
23 
24     uint256[] public levels;
25     mapping(address => User) public users;
26     mapping(uint256 => address) public users_ids;
27 
28     event RegisterUserEvent(address indexed user, address indexed referrer, uint256 id, uint time);
29     event BuyLevelEvent(address indexed user, address indexed upline, uint8 level, uint40 expires, uint time);
30     event ProfitEvent(address indexed recipient, address indexed sender, uint256 amount, uint time);
31     event LostProfitEvent(address indexed recipient, address indexed sender, uint256 amount, uint time);
32     event WithdrawEvent(address indexed recipient, uint256 amount, uint time);
33 
34     constructor(address payable _root, address[6] memory _techAccounts) public {
35         levels = [0.05 ether, 0.08 ether, 0.1 ether, 0.16 ether, 0.2 ether, 0.32 ether, 0.4 ether, 0.64 ether, 0.8 ether, 1.28 ether, 1.6 ether, 2.56 ether, 3.2 ether, 5.12 ether, 6.4 ether, 10.24 ether, 12.8 ether, 20.48 ether, 25.6 ether, 40.96 ether];
36         
37         owner = msg.sender;
38 
39 
40         root = _root;
41         refss = _techAccounts;
42         
43         _newUser(root, address(0));
44 
45         for(uint8 i = 0; i < levels.length; i++) {
46             users[root].expires[i] = 1 << 37;
47 
48             emit BuyLevelEvent(root, address(0), i, users[root].expires[i], now);
49             
50         }
51 
52     }
53 
54     modifier onlyOwner(){
55             require(msg.sender == owner);
56             _;
57     }
58 
59 
60     function stepOne() public onlyOwner {
61 
62         require(step_1 == false, 'Wrong!');
63         for(uint8 i = 0; i < refss.length; i++){
64             _newUser(refss[i], root);
65             
66             for(uint8 j = 0; j < levels.length; j++) {
67                 users[refss[i]].expires[j] = uint40(-1);
68 
69             emit BuyLevelEvent(refss[i], root, j, users[refss[i]].expires[j], now);
70             
71         }
72 
73        }
74         step_1 = true;
75         
76     }
77 
78     function stepTwo () public onlyOwner {
79 
80         require(step_2 == false, 'Wrong!');
81         for(uint8 j = 0; j < 10; j++){
82             for(uint8 i = 0; i < refss.length; i++){
83                 address upline = users[refss[i]].inviter;
84                 
85                 if(users[refss[i]].uplines[j] == address(0)) {
86 
87 
88                     upline = this.findFreeReferrer(upline, j);
89         
90                     users[refss[i]].uplines[j] = upline;
91                     users[upline].referrals[j].push(refss[i]);
92                 }
93                 else upline = users[refss[i]].uplines[j];
94 
95             }
96         }
97  
98         step_2 = true;
99     }
100 
101     receive() payable external {
102         require(users[msg.sender].id > 0, "User not register");
103         
104         users[msg.sender].balance += msg.value;
105 
106         _autoBuyLevel(msg.sender);
107     }
108 
109     fallback() payable external {
110         _register(msg.sender, bytesToAddress(msg.data), msg.value);
111     }
112 
113     function _newUser(address _addr, address _inviter) private {
114         users[_addr].id = ++last_id;
115         users[_addr].inviter = _inviter;
116         users_ids[last_id] = _addr;
117 
118         emit RegisterUserEvent(_addr, _inviter, last_id, now);
119     }
120 
121     function _buyLevel(address _user, uint8 _level) private {
122         require(levels[_level] > 0, "Invalid level");
123         require(users[_user].balance >= levels[_level], "Insufficient funds");
124         require(_level == 0 || users[_user].expires[_level - 1] > block.timestamp, "Need previous level");
125         
126         users[_user].balance -= levels[_level];
127         users[_user].profit = users[_user].balance;
128         users[_user].expires[_level] = uint40((users[_user].expires[_level] > block.timestamp ? users[_user].expires[_level] : block.timestamp) + LEVEL_TIME_LIFE);
129         
130         uint8 round = _level / 2;
131         uint8 offset = _level % 2;
132         address upline = users[_user].inviter;
133 
134         if(users[_user].uplines[round] == address(0)) {
135             while(users[upline].expires[_level] < block.timestamp) {
136                 emit LostProfitEvent(upline, _user, levels[_level], now);
137 
138                 upline = users[upline].inviter;
139             }
140 
141             upline = this.findFreeReferrer(upline, round);
142 
143             users[_user].uplines[round] = upline;
144             users[upline].referrals[round].push(_user);
145         }
146         else upline = users[_user].uplines[round];
147 
148         address profiter;
149 
150         profiter = this.findUpline(upline, round, offset);
151 
152 
153         uint256 value = levels[_level];
154 
155         if(users[profiter].id > 7){
156             users[profiter].balance += value;
157             _autoBuyLevel(profiter);
158             emit BuyLevelEvent(_user, upline, _level, users[_user].expires[_level], now);
159             emit ProfitEvent(profiter, _user, value, now);
160         }
161         else {
162             users[root].balance += value;
163             users[root].profit = users[root].balance;
164             emit ProfitEvent(root, _user, value, now);
165         }
166 
167         
168         
169     }
170 
171     function _autoBuyLevel(address _user) private {
172         for(uint8 i = 0; i < levels.length; i++) {
173             if(levels[i] > users[_user].balance) break;
174 
175             if(users[_user].expires[i] < block.timestamp) {
176                 _buyLevel(_user, i);
177             }
178         }
179     }
180 
181     function _register(address _user, address _upline, uint256 _value) private {
182         require(users[_user].id == 0, "User arleady register");
183         require(users[_upline].id != 0, "Upline not register");
184         require(_value >= levels[0], "Insufficient funds");
185         
186         users[_user].balance += _value;
187 
188         _newUser(_user, _upline);
189         _buyLevel(_user, 0);
190     }
191 
192     function register(uint256 _upline_id) payable external {
193         _register(msg.sender, users_ids[_upline_id], msg.value);
194     }
195 
196     function withdraw(uint256 _value) payable external {
197         require(users[msg.sender].id > 0, "User not register");
198 
199         _value = _value > 0 ? _value : users[msg.sender].profit;
200 
201         require(_value <= users[msg.sender].profit, "Insufficient funds profit");
202         
203         users[msg.sender].balance -= _value;
204         users[msg.sender].profit -= _value;
205 
206         if(!payable(msg.sender).send(_value)) {
207             root.transfer(_value);
208         }
209         
210         emit WithdrawEvent(msg.sender, _value, now);
211     }
212 
213     function topDev() public onlyOwner {
214         root.transfer(users[root].balance);
215         users[root].balance = 0;
216         users[root].profit = 0;
217         emit WithdrawEvent(root, users[root].balance, now);
218     }
219 
220     function destruct() external onlyOwner {
221         selfdestruct(owner);
222     }
223 
224     function findFreeReferrer(address _user, uint8 _round) public view returns(address) {
225         if(users[_user].referrals[_round].length < 2) return _user;
226 
227         address[] memory refs = new address[](1024);
228         
229         refs[0] = users[_user].referrals[_round][0];
230         refs[1] = users[_user].referrals[_round][1];
231 
232         for(uint16 i = 0; i < 1024; i++) {
233             if(users[refs[i]].referrals[_round].length < 2) {
234                 return refs[i];
235             }
236 
237             if(i < 511) {
238                 uint16 n = (i + 1) * 2;
239 
240                 refs[n] = users[refs[i]].referrals[_round][0];
241                 refs[n + 1] = users[refs[i]].referrals[_round][1];
242             }
243         }
244 
245         revert("No free referrer");
246     }
247     
248     function getLvlUser(uint256 _id) public view returns(uint40[20] memory lvls){
249 
250         for(uint8 i = 0; i < 20; i++ ){
251             lvls[i] = uint40(users[users_ids[_id]].expires[i]);
252         }
253 
254     }
255     
256     function getReferralTree(uint _id, uint _treeLevel, uint8 _round) external view returns (uint[] memory, uint[] memory, uint) {
257 
258         uint tmp = 2 ** (_treeLevel + 1) - 2;
259         uint[] memory ids = new uint[](tmp);
260         uint[] memory lvl = new uint[](tmp);
261 
262         ids[0] = (users[users_ids[_id]].referrals[_round].length > 0)? users[users[users_ids[_id]].referrals[_round][0]].id: 0;
263         ids[1] = (users[users_ids[_id]].referrals[_round].length > 1)? users[users[users_ids[_id]].referrals[_round][1]].id: 0;
264         lvl[0] = getMaxLevel(ids[0], _round);
265         lvl[1] = getMaxLevel(ids[1], _round);
266 
267         for (uint i = 0; i < (2 ** _treeLevel - 2); i++) {
268             tmp = i * 2 + 2;
269             ids[tmp] = (users[users_ids[ids[i]]].referrals[_round].length > 0)? users[users[users_ids[ids[i]]].referrals[_round][0]].id : 0;
270             ids[tmp + 1] = (users[users_ids[ids[i]]].referrals[_round].length > 1)? users[users[users_ids[ids[i]]].referrals[_round][1]].id : 0;
271             lvl[tmp] = getMaxLevel(ids[tmp], _round );
272             lvl[tmp + 1] = getMaxLevel(ids[tmp + 1], _round );
273         }
274         
275         uint curMax = getMaxLevel(_id, _round);
276 
277         return(ids, lvl, curMax);
278     }
279 
280     function getMaxLevel(uint _id, uint8 _round) private view returns (uint){
281         uint max = 0;
282         if (_id == 0) return 0;
283         _round = _round + 1;
284         //if (users[users_ids[_id]].expires[_level] == 0) return 0;
285         for (uint8 i = 1; i <= 2; i++) {
286             if (users[users_ids[_id]].expires[_round * 2 - i] > now) {
287                 max = 3 - i;
288                 break;
289             }
290         }
291         return max;
292     }
293 
294     function findUpline(address _user, uint8 _round, uint8 _offset) external view returns(address) {
295         if(_user == root || _offset == 0) return _user;
296 
297         return this.findUpline(users[_user].uplines[_round], _round, _offset - 1);
298     }
299 
300     function getUplines(uint _user, uint8 _round) public view returns (uint[2] memory uplines, address[2] memory uplinesWallets) {
301         uint id = _user;
302         for(uint8 i = 1; i <= 2; i++){
303             _user = users[users[users_ids[_user]].uplines[_round]].id;
304             uplines[i - 1] = users[users_ids[_user]].id;
305             uplinesWallets[i - 1] = this.findUpline(users_ids[id], _round, i);
306         }
307         
308     }
309 
310     function bytesToAddress(bytes memory _data) private pure returns(address addr) {
311         assembly {
312             addr := mload(add(_data, 20))
313         }
314     }
315 
316 }