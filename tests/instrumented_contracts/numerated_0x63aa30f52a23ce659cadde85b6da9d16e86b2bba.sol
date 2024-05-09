1 /**
2  *    ___         _                _        _      
3  *   / __\_ _ ___| |_  /\/\   __ _| |_ _ __(_)_  __
4  *  / _\/ _` / __| __|/    \ / _` | __| '__| \ \/ /
5  * / / | (_| \__ \ |_/ /\/\ \ (_| | |_| |  | |>  < 
6  * \/   \__,_|___/\__\/    \/\__,_|\__|_|  |_/_/\_\
7  *
8 **/
9 
10 
11 pragma solidity ^0.5.11;
12 
13 interface IERC20 {
14     function balanceOf(address account) external view returns (uint256);
15 }
16 
17 contract SafeMath {
18     function safeAdd(uint a, uint b) public pure returns(uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function safeSub(uint a, uint b) public pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function safeMul(uint a, uint b) public pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function safeDiv(uint a, uint b) public pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 contract FastMatrix is SafeMath {
38     uint public currentUserID;
39 
40     mapping (uint => User) public users;
41     mapping (address => uint) public userWallets;
42     uint[4] public levelBase;
43     uint[9] public regBase;
44     address public token_contract;
45 
46     struct User {
47         bool exists;
48         address wallet;
49         uint referrer;
50         mapping (uint => uint) uplines;
51         mapping (uint => uint[]) referrals;
52         mapping (uint => uint) levelExpiry;
53     }
54 
55     event RegisterUserEvent(address indexed user, address indexed referrer, uint time);
56     event BuyLevelEvent(address indexed user, uint indexed level, uint time);
57     event TransferEvent(address indexed recipient, address indexed sender, uint indexed amount, uint time, uint recipientID, uint senderID, bool superprofit);
58     event LostProfitEvent(address indexed recipient, address indexed sender, uint indexed amount, uint time, uint senderID);
59     event CommissionEvent(address indexed recipient, address indexed sender, uint indexed amount, address referral, uint time, uint recipientID, uint senderID, uint referralID);
60 
61     constructor(address _owner, address _token, address[2] memory techAccounts) public {
62 
63       currentUserID++;
64       levelBase = [0.1 ether, 0.14 ether, 0.3 ether, 1 ether];
65       regBase = [0.11 ether, 1.01 ether, 7.02 ether, 13.03 ether, 19.04 ether, 25.05 ether, 31.06 ether, 37.07 ether, 43.08 ether];
66 
67       users[currentUserID] =  User({ exists: true, wallet: _owner, referrer: 1});
68       userWallets[_owner] = currentUserID;
69       emit RegisterUserEvent(_owner, _owner, now);
70       
71       token_contract = _token;
72 
73       for (uint i = 0; i < 36; i++) {
74         users[currentUserID].levelExpiry[i] = 1 << 37;
75       }
76       
77       for (uint i = 1; i < 8; i++) {
78           users[currentUserID].uplines[i] = 1;
79           users[currentUserID].referrals[i] = new uint[](0);
80       }
81       
82       for(uint i = 0; i < techAccounts.length; i++){
83           currentUserID++;
84           users[currentUserID] =  User({ exists: true, wallet: techAccounts[i], referrer: 1});
85           userWallets[techAccounts[i]] = currentUserID;
86           emit RegisterUserEvent(techAccounts[i], _owner, now);
87           
88           for(uint levelID = 0; levelID < 36; levelID++){
89              users[currentUserID].levelExpiry[levelID] = 1 << 37;
90           }
91           
92         for (uint j = 1; j < 8; j++) {
93         users[currentUserID].uplines[j] = 1;
94         users[currentUserID].referrals[j] = new uint[](0);
95         users[1].referrals[j].push(currentUserID);
96         }
97           
98       }
99       
100     }
101 
102     function () external payable {
103         if (userWallets[msg.sender] == 0) {
104             require(msg.value == 0.11 ether, 'Wrong amount');
105             registerUser(userWallets[bytesToAddress(msg.data)]);
106         } else {
107             buyLevel(0);
108         }
109     }
110 
111     function registerUser(uint _referrer) public payable {
112         require(_referrer > 0 && _referrer <= currentUserID, 'Invalid referrer ID');
113         require(msg.value == regBase[0], 'Wrong amount');
114         require(userWallets[msg.sender] == 0, 'User already registered');
115 
116         currentUserID++;
117         users[currentUserID] = User({ exists: true, wallet: msg.sender, referrer: _referrer });
118         userWallets[msg.sender] = currentUserID;
119 
120         levelUp(0, 1, 1, currentUserID, _referrer);
121         
122         emit RegisterUserEvent(msg.sender, users[_referrer].wallet, now);
123     }
124 
125     function buyLevel(uint _upline) public payable {
126         uint userID = userWallets[msg.sender];
127         require (userID > 0, 'User not registered');
128         
129         require(users[userID].referrals[1].length >= 2, 'At least two referrals needed');
130         
131         (uint round, uint level, uint levelID) = getLevel(msg.value);
132         
133         if (level == 1 && round > 1) {
134             bool prev = false;
135             for (uint l = levelID - 2; l < levelID; l++) {
136                 if (users[userID].levelExpiry[l] >= now) {
137                     prev = true;
138                     break;
139                 }
140                 require(prev == true, 'Previous round not active');
141             }
142         } else {
143             for (uint l = level - 1; l > 0; l--) {
144                 require(users[userID].levelExpiry[levelID - level + l] >= now, 'Previous level not active');
145             }
146         }
147 
148         levelUp(levelID, level, round, userID, _upline);
149 
150         if (level == 4 && round < 9 && users[userID].levelExpiry[levelID + 2] <= now) levelUp(levelID + 1, 1, round + 1, userID, _upline);
151 
152         if (address(this).balance > 0) msg.sender.transfer(address(this).balance);
153     }
154     
155     function levelUp(uint _levelid, uint _level, uint _round, uint _userid, uint _upline) internal {
156 
157         uint duration = 30 days * _round + 60 days;
158         IERC20 token = IERC20(token_contract);
159         uint fmxt = token.balanceOf(msg.sender);
160 
161         if (users[_userid].levelExpiry[_levelid] == 0 || (users[_userid].levelExpiry[_levelid] < now && fmxt >= _round)) {
162             users[_userid].levelExpiry[_levelid] = now + duration;
163         } else {
164             users[_userid].levelExpiry[_levelid] += duration;
165         }
166         
167         if (_level == 1 && users[_userid].uplines[_round] == 0) {
168             if (_upline == 0) _upline = users[_userid].referrer;
169             if (_round > 1) _upline = findUplineUp(_upline, _round);
170             _upline = findUplineDown(_upline, _round);
171             users[_userid].uplines[_round] = _upline;
172             users[_upline].referrals[_round].push(_userid);
173         }
174 
175         payForLevel(_levelid, _userid, _level, _round, false);
176         emit BuyLevelEvent(msg.sender, _levelid, now);
177     }
178 
179     function payForLevel(uint _levelid, uint _userid, uint _height, uint _round, bool _superprofit) internal {
180         
181       uint refer = users[_userid].referrer;
182       uint referrer = getUserUpline(_userid, _height, _round);
183       uint amount = lvlAmount(_levelid);
184 
185       if (users[referrer].levelExpiry[_levelid] < now) {
186           if(users[referrer].levelExpiry[_levelid - 1] < now){
187             emit LostProfitEvent(users[referrer].wallet, msg.sender, amount, now, userWallets[msg.sender]);
188             payForLevel(_levelid, referrer, _height, _round, true);
189           } else {
190             levelUp(_levelid, _height, _round, referrer, 0);
191           }
192         return;
193       }
194 
195         if(_levelid == 0 && refer != referrer){
196             uint comission = safeDiv(amount, 10);
197             
198             emit CommissionEvent(users[refer].wallet, users[referrer].wallet, comission, msg.sender, now, refer, referrer, userWallets[msg.sender]);
199             
200               if (address(uint160(users[refer].wallet)).send(safeDiv(amount, 10))) {
201                 emit TransferEvent(users[refer].wallet, msg.sender, comission, now, refer, userWallets[msg.sender], _superprofit);
202               }
203               if (address(uint160(users[referrer].wallet)).send(safeMul(safeDiv(amount, 100), 90))) {
204                 emit TransferEvent(users[referrer].wallet, msg.sender, (amount - comission), now, referrer, userWallets[msg.sender], _superprofit);
205               }
206         } else {
207             
208               
209               if (address(uint160(users[referrer].wallet)).send(amount)) {
210                 emit TransferEvent(users[referrer].wallet, msg.sender, amount, now, referrer, userWallets[msg.sender], _superprofit);
211               }
212         }
213     }
214 
215     function getUserUpline(uint _user, uint _height, uint _round) public view returns (uint) {
216         while (_height > 0) {
217             _user = users[_user].uplines[_round];
218             _height--;
219         }
220         return _user;
221     }
222 
223     function findUplineUp(uint _user, uint _round) public view returns (uint) {
224         while (users[_user].uplines[_round] == 0) {
225             _user = users[_user].uplines[1];
226         }
227         return _user;
228     }
229 
230     function findUplineDown(uint _user, uint _round) public view returns (uint) {
231       if (users[_user].referrals[_round].length < 2) {
232         return _user;
233       }
234 
235       uint[1024] memory referrals;
236       referrals[0] = users[_user].referrals[_round][0];
237       referrals[1] = users[_user].referrals[_round][1];
238 
239       uint referrer;
240 
241       for (uint i = 0; i < 1024; i++) {
242         if (users[referrals[i]].referrals[_round].length < 2) {
243           referrer = referrals[i];
244           break;
245         }
246 
247         if (i >= 512) {
248           continue;
249         }
250 
251         referrals[(i+1)*2] = users[referrals[i]].referrals[_round][0];
252         referrals[(i+1)*2+1] = users[referrals[i]].referrals[_round][1];
253       }
254 
255       require(referrer != 0, 'Referrer not found');
256       return referrer;
257     }
258 
259 
260     function getLevel(uint _amount) public view returns(uint, uint, uint) {
261         if(_amount == 0.15 ether) // 1
262             return (1, 2, 1);
263         if(_amount == 1 ether) // 2
264             return (2, 2, 5);
265         if(_amount == 1.85 ether) // 3
266             return (3, 2, 9);
267         if(_amount == 2.7 ether) // 4
268             return (4, 2, 13);
269         if(_amount == 4.4 ether) // 6
270             return (6, 2, 21);
271         if(_amount == 5.25 ether) // 7
272             return (7, 2, 25);
273         if(_amount == 6.1 ether) // 8
274             return (8, 2, 29);
275         if(_amount == 6.95 ether) // 9
276             return (9, 2, 33);
277         
278         uint level = 0;
279         uint tmp = _amount % 0.1 ether;
280         uint round = tmp / 0.01 ether;
281         require(round != 0, 'Wrong amount');
282 
283         tmp = (_amount - (0.01 ether * round)) / (6 * (round - 1) + 1);
284 
285         for (uint i = 1; i <= 4; i++) {
286             if (tmp == levelBase[i - 1]) {
287                     level = i;
288                     break;
289             }
290         }
291         require(level > 0, 'Wrong amount');
292 
293         uint levelID = (round - 1) * 4 + level - 1;
294         
295         return (round, level, levelID);
296     }
297 
298     function lvlAmount (uint _levelID) public view returns(uint) {
299         uint level = _levelID % 4;
300         uint round = (_levelID - level) / 4;
301         uint tmp = levelBase[level] * (6 * round + 1);
302         uint price = (tmp  + (0.01 ether * (round + 1)));
303          if(level == 3 && round < 8) return (price - (levelBase[0] * (6 * (round + 1 ) + 1 ) ) - (0.01 ether * ( round + 2)));
304         return price;
305     }
306 
307     function getReferralTree(uint _user, uint _treeLevel, uint _round) external view returns (uint[] memory, uint[] memory, uint) {
308 
309         uint tmp = 2 ** (_treeLevel + 1) - 2;
310         uint[] memory ids = new uint[](tmp);
311         uint[] memory lvl = new uint[](tmp);
312 
313         ids[0] = (users[_user].referrals[_round].length > 0)? users[_user].referrals[_round][0]: 0;
314         ids[1] = (users[_user].referrals[_round].length > 1)? users[_user].referrals[_round][1]: 0;
315         lvl[0] = getMaxLevel(ids[0], _round);
316         lvl[1] = getMaxLevel(ids[1], _round);
317 
318         for (uint i = 0; i < (2 ** _treeLevel - 2); i++) {
319             tmp = i * 2 + 2;
320             ids[tmp] = (users[ids[i]].referrals[_round].length > 0)? users[ids[i]].referrals[_round][0]: 0;
321             ids[tmp + 1] = (users[ids[i]].referrals[_round].length > 1)? users[ids[i]].referrals[_round][1]: 0;
322             lvl[tmp] = getMaxLevel(ids[tmp], _round);
323             lvl[tmp + 1] = getMaxLevel(ids[tmp + 1], _round);
324         }
325         
326         uint curMax = getMaxLevel(_user, _round);
327 
328         return(ids, lvl, curMax);
329     }
330 
331     function getMaxLevel(uint _user, uint _round) private view returns (uint){
332         uint max = 0;
333         if (_user == 0) return 0;
334         if (!users[_user].exists) return 0;
335         for (uint i = 1; i <= 4; i++) {
336             if (users[_user].levelExpiry[_round * 4 - i] > now) {
337                 max = 5 - i;
338                 break;
339             }
340         }
341         return max;
342     }
343     
344     function getUplines(uint _user, uint _round) public view returns (uint[4] memory uplines, address[4] memory uplinesWallets) {
345         for(uint i = 0; i < 4; i++) {
346             _user = users[_user].uplines[_round];
347             uplines[i] = _user;
348             uplinesWallets[i] = users[_user].wallet;
349         }
350     }
351 
352     function getUserLevels(uint _user) external view returns (uint[36] memory levels) {
353         for (uint i = 0; i < 36; i++) {
354             levels[i] = users[_user].levelExpiry[i];
355         }
356     }
357 
358     function bytesToAddress(bytes memory _addr) private pure returns (address addr) {
359         assembly {
360             addr := mload(add(_addr, 20))
361         }
362     }
363 }