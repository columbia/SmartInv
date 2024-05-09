1 /**
2  *  
3  *  __                      _   __    __                               
4  * / _\_ __ ___   __ _ _ __| |_/ / /\ \ \__ _ _   _   _ __ _   _ _ __  
5  * \ \| '_ ` _ \ / _` | '__| __\ \/  \/ / _` | | | | | '__| | | | '_ \ 
6  * _\ \ | | | | | (_| | |  | |_ \  /\  / (_| | |_| |_| |  | |_| | | | |
7  * \__/_| |_| |_|\__,_|_|   \__| \/  \/ \__,_|\__, (_)_|   \__,_|_| |_|
8  *                                            |___/                    
9  * https://smartway.run/
10  * 
11 **/
12 
13 pragma solidity 0.5.12;
14 
15 contract SmartWay {
16 
17     struct User {
18         uint64 id;
19         uint64 referrerId;
20         address payable[] referrals;
21         mapping(uint8 => uint64) levelExpired;
22     }
23 
24     uint8 public constant REFERRER_1_LEVEL_LIMIT = 2;
25     uint64 public constant PERIOD_LENGTH = 12 days;
26 
27     address payable public ownerWallet;
28     uint64 public lastUserId;
29     
30     mapping(uint8 => uint) public levelPrice;
31     mapping(uint => uint8) public priceLevel;
32     
33     mapping(address => User) public users;
34     mapping(uint64 => address payable) public userList;
35     
36     event Registration(address indexed user, address referrer);
37     event LevelBought(address indexed user, uint8 level);
38     event GetMoneyForLevel(address indexed user, address indexed referral, uint8 level);
39     event SendMoneyError(address indexed user, address indexed referral, uint8 level);
40     event LostMoneyForLevel(address indexed user, address indexed referral, uint8 level);
41 
42     constructor(address payable owner) public {
43         _initData();
44         ownerWallet = owner;
45 
46         lastUserId++;
47         
48         userList[lastUserId] = owner;
49         users[owner].id = lastUserId;
50         
51         for(uint8 i = 1; i <= 12; i++) {
52             users[owner].levelExpired[i] = 77777777777;
53         }
54     }
55 
56     function () external payable {
57         uint8 level = priceLevel[msg.value];
58         require(level != 0, 'Incorrect value sent');
59         
60         if(users[msg.sender].id != 0)
61             return buyLevel(level);
62         
63         require(level == 1, 'Please buy level 1 for 0.2 ETH');
64         
65         address referrer = bytesToAddress(msg.data);
66 
67         if(users[referrer].id != 0)
68             return regUser(users[referrer].id);
69 
70         regUser(1);
71     }
72 
73     function regUser(uint64 referrerId) public payable {
74         require(users[msg.sender].id == 0, 'User exist');
75         require(referrerId > 0 && referrerId <= lastUserId, 'Incorrect referrer Id');
76         require(msg.value == levelPrice[1], 'Incorrect Value');
77 
78         if(users[userList[referrerId]].referrals.length >= REFERRER_1_LEVEL_LIMIT) {
79             address freeReferrer = findFreeReferrer(userList[referrerId]);
80             referrerId = users[freeReferrer].id;
81         }
82             
83         lastUserId++;
84 
85         users[msg.sender] = User({
86             id: lastUserId,
87             referrerId: referrerId,
88             referrals: new address payable[](0) 
89         });
90         
91         userList[lastUserId] = msg.sender;
92 
93         users[msg.sender].levelExpired[1] = uint64(now + PERIOD_LENGTH);
94 
95         users[userList[referrerId]].referrals.push(msg.sender);
96 
97         payForLevel(1, msg.sender);
98 
99         emit Registration(msg.sender, userList[referrerId]);
100     }
101 
102     function buyLevel(uint8 level) public payable {
103         require(users[msg.sender].id != 0, 'User is not exists'); 
104         require(level > 0 && level <= 12, 'Incorrect level');
105         require(msg.value == levelPrice[level], 'Incorrect Value');
106     
107         
108         for(uint8 i = level - 1; i > 0; i--) {
109             require(users[msg.sender].levelExpired[i] >= now, 'Buy the previous level');
110         }
111         
112         if(users[msg.sender].levelExpired[level] == 0 || users[msg.sender].levelExpired[level] < now) {
113             users[msg.sender].levelExpired[level] = uint64(now + PERIOD_LENGTH);
114         } else {
115             users[msg.sender].levelExpired[level] += PERIOD_LENGTH;
116         }
117         
118         payForLevel(level, msg.sender);
119 
120         emit LevelBought(msg.sender, level);
121     }
122     
123 
124     function payForLevel(uint8 level, address user) private {
125         address payable referrer;
126 
127         if (level%2 == 0) {
128             referrer = userList[users[userList[users[user].referrerId]].referrerId]; //extra variable will decrease aroud 50 recursion levels
129         } else {
130             referrer = userList[users[user].referrerId];
131         }
132 
133         if(users[referrer].id == 0) {
134             referrer = userList[1];
135         } 
136 
137         if(users[referrer].levelExpired[level] >= now) {
138             if (referrer.send(levelPrice[level])) {
139                 emit GetMoneyForLevel(referrer, msg.sender, level);
140             } else {
141                 emit SendMoneyError(referrer, msg.sender, level);
142             }
143         } else {
144             emit LostMoneyForLevel(referrer, msg.sender, level);
145 
146             payForLevel(level, referrer);
147         }
148     }
149 
150     function _initData() private {
151         levelPrice[1] = 0.2 ether;
152         levelPrice[2] = 0.22 ether;
153         levelPrice[3] = 0.4 ether;
154         levelPrice[4] = 0.44 ether;
155         levelPrice[5] = 0.7 ether;
156         levelPrice[6] = 0.77 ether;
157         levelPrice[7] = 1.2 ether;
158         levelPrice[8] = 1.3 ether;
159         levelPrice[9] = 2 ether;
160         levelPrice[10] = 2.2 ether;
161         levelPrice[11] = 3 ether;
162         levelPrice[12] = 3.3 ether;
163 
164         priceLevel[0.2 ether] = 1;
165         priceLevel[0.22 ether] = 2;
166         priceLevel[0.4 ether] = 3;
167         priceLevel[0.44 ether] = 4;
168         priceLevel[0.7 ether] = 5;
169         priceLevel[0.77 ether] = 6;
170         priceLevel[1.2 ether] = 7;
171         priceLevel[1.3 ether] = 8;
172         priceLevel[2 ether] = 9;
173         priceLevel[2.2 ether] = 10;
174         priceLevel[3 ether] = 11;
175         priceLevel[3.3 ether] = 12;
176     }
177 
178     function findFreeReferrer(address _user) public view returns(address) {
179         if(users[_user].referrals.length < REFERRER_1_LEVEL_LIMIT) 
180             return _user;
181 
182         address[] memory referrals = new address[](256);
183         address[] memory referralsBuf = new address[](256);
184 
185         referrals[0] = users[_user].referrals[0];
186         referrals[1] = users[_user].referrals[1];
187 
188         uint32 j = 2;
189         
190         while(true) {
191             for(uint32 i = 0; i < j; i++) {
192                 if(users[referrals[i]].referrals.length < 1) {
193                     return referrals[i];
194                 }
195             }
196             
197             for(uint32 i = 0; i < j; i++) {
198                 if (users[referrals[i]].referrals.length < REFERRER_1_LEVEL_LIMIT) {
199                     return referrals[i];
200                 }
201             }
202 
203             for(uint32 i = 0; i < j; i++) {
204                 referralsBuf[i] = users[referrals[i]].referrals[0];
205                 referralsBuf[j+i] = users[referrals[i]].referrals[1];
206             }
207 
208             j = j*2;
209 
210             for(uint32 i = 0; i < j; i++) {
211                 referrals[i] = referralsBuf[i];
212             }
213         }
214     }
215 
216     function viewUserReferral(address user) public view returns(address payable[] memory) {
217         return users[user].referrals;
218     }
219 
220     function viewUserLevelExpired(address user, uint8 level) public view returns(uint) {
221         return users[user].levelExpired[level];
222     }
223 
224     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
225         assembly {
226             addr := mload(add(bys, 20))
227         }
228     }
229 }