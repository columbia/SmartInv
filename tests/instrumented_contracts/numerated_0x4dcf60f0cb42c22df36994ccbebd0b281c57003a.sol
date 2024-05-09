1 /**
2  *            _ _ _ _                                                
3  *  _ __ ___ (_) | (_) ___  _ __    _ __ ___   ___  _ __   ___ _   _ 
4  * | '_ ` _ \| | | | |/ _ \| '_ \  | '_ ` _ \ / _ \| '_ \ / _ \ | | |
5  * | | | | | | | | | | (_) | | | |_| | | | | | (_) | | | |  __/ |_| |
6  * |_| |_| |_|_|_|_|_|\___/|_| |_(_)_| |_| |_|\___/|_| |_|\___|\__, |
7  *                                                              |___/ 
8  *      
9  *Hello
10  *I am a MillionMoney.
11  *My URL: https://million.money
12  *Support: https://t.me/cbsmart
13  *Chat Bot: https://t.me/mmethbot
14  */
15 
16 pragma solidity ^0.5.10;
17 
18 contract MillionMoney {
19 
20     uint UPLINE_1_LVL_LIMIT = 2;
21     uint PERIOD_LENGTH = 100 days;
22     uint OWNER_EXPIRED_DATE = 55555555555;
23     uint public currUserID = 0;
24 
25     address public ownerWallet = 0xb19dA4fd9f9A73A5A564C66D229B1E7219e8bdbe;
26 
27     mapping (uint => uint) public LVL_COST;
28     
29     struct UserStruct {
30         bool isExist;
31         uint id;
32         uint referrerID;
33         address[] referral;
34         mapping (uint => uint) levelExpired;
35     }
36 
37     mapping (address => UserStruct) public users;
38     mapping (uint => address) public userList;
39 
40     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
41     event buyLevelEvent(address indexed _user, uint _lvl, uint _time);
42     event prolongateLevelEvent(address indexed _user, uint _lvl, uint _time);
43     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _lvl, uint _time);
44     event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _lvl, uint _time);
45 
46 
47     constructor() public {
48 
49         LVL_COST[1] = 0.03 ether;
50         LVL_COST[2] = 0.05 ether;
51         LVL_COST[3] = 0.1 ether;
52         LVL_COST[4] = 0.4 ether;
53         LVL_COST[5] = 3 ether;
54         LVL_COST[6] = 5 ether;
55         LVL_COST[7] = 10 ether;
56         LVL_COST[8] = 40 ether;
57 
58         UserStruct memory userStruct;
59         currUserID++;
60 
61         userStruct = UserStruct({
62             isExist : true,
63             id : currUserID,
64             referrerID : 0,
65             referral : new address[](0)
66         });
67         users[ownerWallet] = userStruct;
68         userList[currUserID] = ownerWallet;
69 
70         for (uint i = 1; i < 9; i++) {
71             users[ownerWallet].levelExpired[i] = OWNER_EXPIRED_DATE;
72         }
73     }
74 
75     function () external payable {
76 
77         uint level;
78         bool isCorrectValue = false;
79         
80         for (uint j = 1; j < 9; j++) {
81             if(msg.value == LVL_COST[j]){
82                 level = j;
83                 isCorrectValue = true;
84                 break;
85             }
86         }
87         require(isCorrectValue, 'Incorrect Value send');
88 
89 
90         if(users[msg.sender].isExist){
91             buyLevel(level);
92         } else if(level == 1) {
93             uint refId = 0;
94             address upline = bytesToAddress(msg.data);
95 
96             if (users[upline].isExist){
97                 refId = users[upline].id;
98             } else {
99                 revert('Incorrect upline');
100             }
101 
102             regUser(refId);
103         } else {
104             revert("Please buy first level for 0.03 ETH");
105         }
106     }
107 
108     function regUser(uint _referrerID) public payable {
109         require(!users[msg.sender].isExist, 'User exist');
110 
111         require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect Upline Id');
112 
113         require(msg.value==LVL_COST[1], 'Incorrect Value');
114 
115 
116         if(users[userList[_referrerID]].referral.length >= UPLINE_1_LVL_LIMIT)
117         {
118             _referrerID = users[findFreeUpline(userList[_referrerID])].id;
119         }
120 
121 
122         UserStruct memory userStruct;
123         currUserID++;
124 
125         userStruct = UserStruct({
126             isExist : true,
127             id : currUserID,
128             referrerID : _referrerID,
129             referral : new address[](0)
130         });
131 
132         users[msg.sender] = userStruct;
133         userList[currUserID] = msg.sender;
134 
135         users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;
136         for (uint i = 2; i < 9; i++) {
137             users[msg.sender].levelExpired[i] = 0;
138         }
139 
140         users[userList[_referrerID]].referral.push(msg.sender);
141 
142         payForLevel(1, msg.sender);
143 
144         emit regLevelEvent(msg.sender, userList[_referrerID], now);
145     }
146 
147     function buyLevel(uint _lvl) public payable {
148         require(users[msg.sender].isExist, 'User not exist');
149 
150         require( _lvl>0 && _lvl<=8, 'Incorrect level');
151 
152         if(_lvl == 1){
153             require(msg.value==LVL_COST[1], 'Incorrect Value');
154             users[msg.sender].levelExpired[1] += PERIOD_LENGTH;
155         } else {
156             require(msg.value==LVL_COST[_lvl], 'Incorrect Value');
157 
158             for(uint l =_lvl-1; l>0; l-- ){
159                 require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');
160             }
161 
162             if(users[msg.sender].levelExpired[_lvl] == 0){
163                 users[msg.sender].levelExpired[_lvl] = now + PERIOD_LENGTH;
164             } else {
165                 users[msg.sender].levelExpired[_lvl] += PERIOD_LENGTH;
166             }
167         }
168         payForLevel(_lvl, msg.sender);
169         emit buyLevelEvent(msg.sender, _lvl, now);
170     }
171 
172     function payForLevel(uint _lvl, address _user) internal {
173 
174         address upline;
175         address upline1;
176         address upline2;
177         address upline3;
178         if(_lvl == 1 || _lvl == 5){
179             upline = userList[users[_user].referrerID];
180         } else if(_lvl == 2 || _lvl == 6){
181             upline1 = userList[users[_user].referrerID];
182             upline = userList[users[upline1].referrerID];
183         } else if(_lvl == 3 || _lvl == 7){
184             upline1 = userList[users[_user].referrerID];
185             upline2 = userList[users[upline1].referrerID];
186             upline = userList[users[upline2].referrerID];
187         } else if(_lvl == 4 || _lvl == 8){
188             upline1 = userList[users[_user].referrerID];
189             upline2 = userList[users[upline1].referrerID];
190             upline3 = userList[users[upline2].referrerID];
191             upline = userList[users[upline3].referrerID];
192         }
193 
194         if(!users[upline].isExist){
195             upline = userList[1];
196         }
197 
198         if(users[upline].levelExpired[_lvl] >= now ){
199             address(uint160(upline)).transfer(LVL_COST[_lvl]);
200             emit getMoneyForLevelEvent(upline, msg.sender, _lvl, now);
201         } else {
202             emit lostMoneyForLevelEvent(upline, msg.sender, _lvl, now);
203             payForLevel(_lvl,upline);
204         }
205     }
206 
207     function findFreeUpline(address _user) public view returns(address) {
208         if(users[_user].referral.length < UPLINE_1_LVL_LIMIT){
209             return _user;
210         }
211 
212         address[] memory referrals = new address[](62);
213         referrals[0] = users[_user].referral[0]; 
214         referrals[1] = users[_user].referral[1];
215 
216         address FreeUpline;
217         bool noFreeUpline = true;
218 
219         for(uint i = 0; i<254; i++){
220             if(users[referrals[i]].referral.length == UPLINE_1_LVL_LIMIT){
221                 if(i<126){
222                     referrals[(i+1)*2] = users[referrals[i]].referral[0];
223                     referrals[(i+1)*2+1] = users[referrals[i]].referral[1];
224                 }
225             }else{
226                 noFreeUpline = false;
227                 FreeUpline = referrals[i];
228                 break;
229             }
230         }
231         require(!noFreeUpline, 'No Free Upline');
232         return FreeUpline;
233 
234     }
235 
236     function viewUserReferral(address _user) public view returns(address[] memory) {
237         return users[_user].referral;
238     }
239 
240     function viewUserLevelExpired(address _user, uint _lvl) public view returns(uint) {
241         return users[_user].levelExpired[_lvl];
242     }
243     
244     function bytesToAddress(bytes memory bys) private pure returns (address  addr ) {
245         assembly {
246             addr := mload(add(bys, 20))
247         }
248     }
249 }