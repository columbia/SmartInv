1 /**
2  *         __  .__                                          .__       ___.    
3  *   _____/  |_|  |__   ___________  ____   ____       ____ |  |  __ _\_ |__  
4  * _/ __ \   __\  |  \_/ __ \_  __ \/  _ \ /    \    _/ ___\|  | |  |  \ __ \ 
5  * \  ___/|  | |   Y  \  ___/|  | \(  <_> )   |  \   \  \___|  |_|  |  / \_\ \
6  *  \___  >__| |___|  /\___  >__|   \____/|___|  / /\ \___  >____/____/|___  /
7  *      \/          \/     \/                  \/  \/     \/               \/ 
8  *
9  * https://etheron.club
10 **/
11 
12 
13 pragma solidity ^0.5.11;
14 
15 interface IERC20 {
16     function balanceOf(address account) external view returns (uint256);
17 }
18 
19 contract Etheron {
20     uint public currentUserID;
21 
22     mapping (uint => User) public users;
23     mapping (address => uint) public userWallets;
24     uint[10] public levelBase;
25     uint[9] public regBase;
26     address public token_contract;
27 
28     struct User {
29         bool exists;
30         address wallet;
31         uint referrer;
32         mapping (uint => uint) uplines;
33         mapping (uint => uint[]) referrals;
34         mapping (uint => uint) levelExpiry;
35     }
36 
37     event RegisterUserEvent(address indexed user, address indexed referrer, uint time);
38     event BuyLevelEvent(address indexed user, uint indexed level, uint time);
39     event TransferEvent(address indexed recipient, address indexed sender, uint indexed amount, uint time, uint recipientID, uint senderID, bool superprofit);
40     event LostProfitEvent(address indexed recipient, address indexed sender, uint indexed amount, uint time, uint senderID);
41 
42     constructor(address _owner, address _token) public {
43 
44       currentUserID++;
45       levelBase = [0.5 ether, 1 ether, 2 ether, 4 ether, 5 ether, 6 ether, 7 ether, 8 ether, 9 ether, 10 ether];
46       regBase = [0.6 ether, 1.8 ether, 4.1 ether, 8.5 ether, 17 ether, 33.6 ether, 66.3 ether, 131.1 ether, 260 ether];
47 
48       users[currentUserID] =  User({ exists: true, wallet: _owner, referrer: 1});
49       userWallets[_owner] = currentUserID;
50       token_contract = _token;
51 
52       for (uint i = 0; i < 90; i++) {
53         users[currentUserID].levelExpiry[i] = 1 << 37;
54       }
55       
56       for (uint i = 1; i < 10; i++) {
57           users[currentUserID].uplines[i] = 1;
58           users[currentUserID].referrals[i] = new uint[](0);
59       }
60     }
61 
62     function () external payable {
63         if (userWallets[msg.sender] == 0) {
64             require(msg.value == 0.6 ether, 'Wrong amount');
65             uint[9] memory tmp;
66             registerUser(userWallets[bytesToAddress(msg.data)], 0, tmp);
67         } else {
68             buyLevel(0);
69         }
70     }
71 
72     function registerUser(uint _referrer, uint _rounds, uint[9] memory _uplines) public payable {
73         require(_referrer > 0 && _referrer <= currentUserID, 'Invalid referrer ID');
74         require(_rounds < 9);
75         require(msg.value == regBase[_rounds], 'Wrong amount');
76         require(userWallets[msg.sender] == 0, 'User already registered');
77 
78         currentUserID++;
79         users[currentUserID] = User({ exists: true, wallet: msg.sender, referrer: _referrer });
80         userWallets[msg.sender] = currentUserID;
81 
82         for (uint i = 0 ; i <= _rounds; i++ ) {
83             levelUp(i * 10, 1, i + 1, currentUserID, _uplines[i]);
84         } 
85         emit RegisterUserEvent(msg.sender, users[_referrer].wallet, now);
86     }
87 
88     function buyLevel(uint _upline) public payable {
89         uint userID = userWallets[msg.sender];
90         require (userID > 0, 'User not registered');
91         (uint round, uint level, uint levelID) = getLevel(msg.value);
92         
93         if (level == 1 && round > 1) {
94             bool prev = false;
95             for (uint l = levelID - 10; l < levelID; l++) {
96                 if (users[userID].levelExpiry[l] >= now) {
97                     prev = true;
98                     break;
99                 }
100                 require(prev == true, 'Previous round not active');
101             }
102         } else {
103             for (uint l = level - 1; l > 0; l--) {
104                 require(users[userID].levelExpiry[levelID - level + l] >= now, 'Previous level not active');
105             }
106         }
107 
108         levelUp(levelID, level, round, userID, _upline);
109 
110         if (level == 4 && round < 9 && users[userID].levelExpiry[levelID + 7] <= now) levelUp(levelID + 7, 1, round + 1, userID, _upline);
111 
112         if (address(this).balance > 0) msg.sender.transfer(address(this).balance);
113     }
114     
115     function levelUp(uint _levelid, uint _level, uint _round, uint _userid, uint _upline) internal {
116 
117         uint duration = 30 days * _round + 90 days;
118         IERC20 token = IERC20(token_contract);
119         uint eron = token.balanceOf(msg.sender);
120 
121         if (users[_userid].levelExpiry[_levelid] == 0 || (users[_userid].levelExpiry[_levelid] < now && eron >= _round)) {
122             users[_userid].levelExpiry[_levelid] = now + duration;
123         } else {
124             users[_userid].levelExpiry[_levelid] += duration;
125         }
126         
127         if (_level == 1 && users[_userid].uplines[_round] == 0) {
128             if (_upline == 0) _upline = users[_userid].referrer;
129             if (_round > 1) _upline = findUplineUp(_upline, _round);
130             _upline = findUplineDown(_upline, _round);
131             users[_userid].uplines[_round] = _upline;
132             users[_upline].referrals[_round].push(_userid);
133         }
134 
135         payForLevel(_levelid, _userid, _level, _round, false);
136         emit BuyLevelEvent(msg.sender, _levelid, now);
137     }
138 
139     function payForLevel(uint _levelid, uint _userid, uint _height, uint _round, bool _superprofit) internal {
140       uint referrer = getUserUpline(_userid, _height, _round);
141       uint amount = lvlAmount(_levelid);
142 
143       if (users[referrer].levelExpiry[_levelid] < now) {
144         emit LostProfitEvent(users[referrer].wallet, msg.sender, amount, now, userWallets[msg.sender]);
145         payForLevel(_levelid, referrer, _height, _round, true);
146         return;
147       }
148 
149       if (address(uint160(users[referrer].wallet)).send(amount)) {
150         emit TransferEvent(users[referrer].wallet, msg.sender, amount, now, referrer, userWallets[msg.sender], _superprofit);
151       }
152     }
153 
154     function getUserUpline(uint _user, uint _height, uint _round) public view returns (uint) {
155         while (_height > 0) {
156             _user = users[_user].uplines[_round];
157             _height--;
158         }
159         return _user;
160     }
161 
162     function findUplineUp(uint _user, uint _round) public view returns (uint) {
163         while (users[_user].uplines[_round] == 0) {
164             _user = users[_user].uplines[1];
165         }
166         return _user;
167     }
168 
169     function findUplineDown(uint _user, uint _round) public view returns (uint) {
170       if (users[_user].referrals[_round].length < 2) {
171         return _user;
172       }
173 
174       uint[1024] memory referrals;
175       referrals[0] = users[_user].referrals[_round][0];
176       referrals[1] = users[_user].referrals[_round][1];
177 
178       uint referrer;
179 
180       for (uint i = 0; i < 1024; i++) {
181         if (users[referrals[i]].referrals[_round].length < 2) {
182           referrer = referrals[i];
183           break;
184         }
185 
186         if (i >= 512) {
187           continue;
188         }
189 
190         referrals[(i+1)*2] = users[referrals[i]].referrals[_round][0];
191         referrals[(i+1)*2+1] = users[referrals[i]].referrals[_round][1];
192       }
193 
194       require(referrer != 0, 'Referrer not found');
195       return referrer;
196     }
197 
198 
199     function getLevel(uint _amount) public view returns(uint, uint, uint) {
200 
201         if (_amount == 0.6 ether) return (1, 1, 0);
202         uint level = 0;
203         uint tmp = _amount % 1 ether;
204         uint round = tmp / 0.1 ether;
205         require(round != 0, 'Wrong amount');
206 
207         tmp = (_amount - tmp) / (2 ** (round - 1));
208 
209         for (uint i = 1; i <= 10; i++) {
210             if (tmp == levelBase[i - 1]) {
211                     level = i;
212                     break;
213             }
214         }
215         require(level > 0, 'Wrong amount');
216 
217         uint levelID = (round - 1) * 10 + level - 1;
218         
219         return (round, level, levelID);
220     }
221 
222     function lvlAmount (uint _levelID) public view returns(uint) {
223         uint level = _levelID % 10;
224         uint round = (_levelID - level) / 10;
225         uint tmp = levelBase[level] * (2 ** round);
226 
227         if (level == 3 && round < 8) return (tmp - (2 ** round) * 1 ether - 0.1 ether);
228         return (tmp  + (0.1 ether * (round + 1)));
229     }
230 
231     function getReferralTree(uint _user, uint _treeLevel, uint _round) external view returns (uint[] memory, uint[] memory, uint) {
232 
233         uint tmp = 2 ** (_treeLevel + 1) - 2;
234         uint[] memory ids = new uint[](tmp);
235         uint[] memory lvl = new uint[](tmp);
236 
237         ids[0] = (users[_user].referrals[_round].length > 0)? users[_user].referrals[_round][0]: 0;
238         ids[1] = (users[_user].referrals[_round].length > 1)? users[_user].referrals[_round][1]: 0;
239         lvl[0] = getMaxLevel(ids[0], _round);
240         lvl[1] = getMaxLevel(ids[1], _round);
241 
242         for (uint i = 0; i < (2 ** _treeLevel - 2); i++) {
243             tmp = i * 2 + 2;
244             ids[tmp] = (users[ids[i]].referrals[_round].length > 0)? users[ids[i]].referrals[_round][0]: 0;
245             ids[tmp + 1] = (users[ids[i]].referrals[_round].length > 1)? users[ids[i]].referrals[_round][1]: 0;
246             lvl[tmp] = getMaxLevel(ids[tmp], _round);
247             lvl[tmp + 1] = getMaxLevel(ids[tmp + 1], _round);
248         }
249         
250         uint curMax = getMaxLevel(_user, _round);
251 
252         return(ids, lvl, curMax);
253     }
254 
255     function getMaxLevel(uint _user, uint _round) private view returns (uint){
256         uint max = 0;
257         if (_user == 0) return 0;
258         if (!users[_user].exists) return 0;
259         for (uint i = 1; i <= 10; i++) {
260             if (users[_user].levelExpiry[_round * 10 - i] > now) {
261                 max = 11 - i;
262                 break;
263             }
264         }
265         return max;
266     }
267     
268     function getUplines(uint _user, uint _round) public view returns (uint[10] memory uplines, address[10] memory uplinesWallets) {
269         for(uint i = 0; i < 10; i++) {
270             _user = users[_user].uplines[_round];
271             uplines[i] = _user;
272             uplinesWallets[i] = users[_user].wallet;
273         }
274     }
275 
276     function getUserLevels(uint _user) external view returns (uint[90] memory levels) {
277         for (uint i = 0; i < 90; i++) {
278             levels[i] = users[_user].levelExpiry[i];
279         }
280     }
281 
282     function bytesToAddress(bytes memory _addr) private pure returns (address addr) {
283         assembly {
284             addr := mload(add(_addr, 20))
285         }
286     }
287 }